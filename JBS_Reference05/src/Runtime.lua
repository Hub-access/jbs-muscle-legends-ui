--[[
    启动与销毁总入口，把配置、状态、界面、资源和业务适配器组装起来。
    同一 PlayerGui 中通过 JBS5_Owner 找到已有界面，重复运行只恢复窗口。
    默认使用本次游戏会话存储；跨次登录存储需要你的 LoadState / SaveState。
]]
local Cleanup = require(script.Parent.Cleanup)
local Motion = require(script.Parent.Motion)
local Assets = require(script.Parent.Assets)
local Adapter = require(script.Parent.BusinessAdapter)
local Controller = require(script.Parent.Controller)
local View = require(script.Parent.View)
local Catalog = require(script.Parent.LegacyCatalog)
local Defaults = require(script.Parent.Config)
local DefaultBindings = require(script.Parent.BusinessBindings)
local HttpService = game:GetService("HttpService")
local Runtime = {}
local function sanitize(data, config)
    if type(data) ~= "table" then
        data = {}
    end
    local validPages =
        { home = true, teleport = true, pets = true, boss = true, rebirth = true, settings = true }
    local allowedTasks = {}
    for _, feature in ipairs(Catalog.features) do
        allowedTasks[feature.id] = true
    end
    local selected = {}
    if type(data.selected) == "table" then
        for k, v in pairs(data.selected) do
            if allowedTasks[k] and type(v) == "boolean" then
                selected[k] = v
            end
        end
    end
    local choices = {}
    if type(data.choices) == "table" then
        for k, v in pairs(data.choices) do
            if (validPages[k] or k == "eggTargets") and type(v) == "string" then
                choices[k] = v
            end
        end
    end
    local parameters = { targetRebirths = 0, giftAmount = 0 }
    for id in pairs(parameters) do
        local value = type(data.parameters) == "table" and tonumber(data.parameters[id]) or 0
        if value and value == value and math.abs(value) ~= math.huge then
            parameters[id] = math.max(0, math.floor(value))
        end
    end
    local reduced = config.ReducedMotion
    if type(data.reduced) == "boolean" then
        reduced = data.reduced
    end
    return {
        page = validPages[data.page] and data.page or "home",
        selected = selected,
        choices = choices,
        parameters = parameters,
        reduced = reduced,
        sizeMode = data.sizeMode == "Comfort" and "Comfort" or "Fit",
    }
end
-- 一次完整启动：去重 → 读设置 → 创建组件 → 绑定事件 → 加载美术。
function Runtime.Mount(options)
    options = options or {}
    local player = game:GetService("Players").LocalPlayer
    assert(player, "JBS 必须从客户端 LocalScript 运行")
    local parent = options.Parent or player:WaitForChild("PlayerGui")
    local owner = parent:FindFirstChild("JBS5_Owner")
    if owner and owner:IsA("BindableFunction") and owner:GetAttribute("JBSReference05") == true then
        owner:Invoke("Restore")
        return nil, "已恢复现有窗口，未重复启动"
    end
    local config = table.clone(Defaults)
    for k, v in pairs(options.Config or {}) do
        config[k] = v
    end
    local bindings = options.Bindings or DefaultBindings
    local scope = Cleanup.new()
    local adapter = Adapter.new(config, bindings)
    local persisted = nil
    if bindings.LoadState then
        local ok, result = pcall(bindings.LoadState)
        if ok then
            persisted = result
        end
    else
        local raw = parent:GetAttribute(config.SessionAttribute)
        if type(raw) == "string" then
            local ok, result = pcall(HttpService.JSONDecode, HttpService, raw)
            if ok then
                persisted = result
            end
        end
    end
    local controller = Controller.new(adapter, sanitize(persisted, config), function(state)
        if bindings.SaveState then
            bindings.SaveState(state)
        else
            parent:SetAttribute(config.SessionAttribute, HttpService:JSONEncode(state))
        end
    end)
    local motion = Motion.new(controller.reduced)
    local assets = Assets.new(config.AssetIds)
    local screen = Instance.new("ScreenGui")
    screen.Name = "JBS_Reference05"
    screen.ResetOnSpawn = false
    screen.IgnoreGuiInset = false
    screen.DisplayOrder = config.DisplayOrder
    screen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screen.Parent = parent
    local view
    local built, buildError = pcall(function()
        view = View.new(screen, scope, motion, assets, controller, adapter, player, config)
    end)
    if not built then
        controller:Destroy()
        scope:Destroy()
        motion:Destroy()
        assets:Destroy()
        screen:Destroy()
        error(buildError)
    end
    local api = {
        Controller = controller,
        View = view,
        Screen = screen,
        Assets = assets,
        Scope = scope,
        Motion = motion,
    }
    function api.Restore()
        controller:SetWindow("Open")
    end
    function api.Close()
        controller:SetWindow("Closed")
    end
    function api.Diagnostics()
        return {
            avatar = view.heroAvatar and view.heroAvatar:Diagnostics() or { enabled = false },
            instances = #screen:GetDescendants() + 1,
            connections = scope:Count(),
            tweens = motion:Count(),
            refreshCount = view.refreshCount,
            refreshMeanMs = view.refreshCount and view.refreshTotal / view.refreshCount or 0,
            refreshMaxMs = view.refreshMax,
            phase = controller.phase,
            assetStatus = table.clone(assets.status),
            businessWorkerPending = controller.busy,
        }
    end
    function api.Destroy()
        if api.dead then
            return
        end
        api.dead = true
        controller:Destroy()
        motion:Destroy()
        assets:Destroy()
        scope:Destroy()
        if owner then
            owner.OnInvoke = nil
            owner:Destroy()
        end
        screen:Destroy()
    end
    owner = Instance.new("BindableFunction")
    owner.Name = "JBS5_Owner"
    owner:SetAttribute("JBSReference05", true)
    owner.OnInvoke = function(command)
        if command == "Restore" then
            api.Restore()
            return true
        elseif command == "Destroy" then
            api.Destroy()
            return true
        elseif command == "Diagnostics" then
            return api.Diagnostics()
        end
        return false
    end
    owner.Parent = parent
    scope:Add(controller:Subscribe(function()
        view:Refresh()
    end))
    scope:Connect(screen.Destroying, function()
        api.Destroy()
    end)
    if bindings.Changed then
        scope:Connect(bindings.Changed, function()
            view:Refresh()
        end)
    end
    if config.Hotkey then
        scope:Connect(game:GetService("UserInputService").InputBegan, function(event, processed)
            if
                not processed
                and event.KeyCode == config.Hotkey
                and not game:GetService("UserInputService"):GetFocusedTextBox()
            then
                controller:SetWindow(controller.window == "Open" and "Minimized" or "Open")
            end
        end)
    end
    assets:Load(function()
        if not api.dead then
            view:Refresh()
        end
    end)
    return api
end
return Runtime
