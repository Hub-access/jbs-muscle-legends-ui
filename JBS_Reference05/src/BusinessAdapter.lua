--[[
    界面与游戏业务之间的边界。
    名称和列表可以显示，但只有真实回调存在时按钮才可执行。
    修改接线请看 BusinessBindings.lua；此模块不猜测游戏协议，也不发送 RemoteEvent。
]]
-- 接口层只转交已经接入的回调。
local Catalog = require(script.Parent.LegacyCatalog)
local Adapter = {}
Adapter.__index = Adapter
-- 保存外部提供的任务和操作表，默认空表意味着尚未接入。
function Adapter.new(config, bindings)
    return setmetatable({
        config = config,
        bindings = bindings or {},
        tasks = (bindings and bindings.Tasks) or {},
        actions = (bindings and bindings.Actions) or {},
    }, Adapter)
end
-- 用回调存在性判断功能可用，不用一个开关假装已连接游戏。
function Adapter:Available(id)
    local item = self.tasks[id]
    return type(item) == "table" and type(item.Start) == "function"
end
-- 调用已接入的任务，并要求对方返回专属停止函数。
function Adapter:Start(id, context)
    assert(self:Available(id), "功能未接入: " .. id)
    -- Start 必须返回可重复调用的专属清理函数，只拥有自己的资源。
    -- 每次等待后检查 Cancelled；后台错误通过 ReportError 上报。
    local stop = self.tasks[id].Start(context)
    assert(type(stop) == "function", "Start 必须返回专属清理函数: " .. id)
    return stop
end
-- 返回统一的 {Id, Label} 列表。名称是资料，列出名称并不代表功能已接通。
function Adapter:GetOptions(page)
    local action = self.actions[page]
    if action and action.Options then
        return action.Options
    end
    if self.bindings.GetOptions then
        local ok, options = pcall(self.bindings.GetOptions, page)
        if ok and type(options) == "table" then
            return options
        end
    end
    local options = {}
    if page == "teleport" then
        for _, item in ipairs(Catalog.teleports) do
            table.insert(options, { Id = item.id, Label = item.label })
        end
    elseif page == "pets" then
        for _, name in ipairs(Catalog.fallbackPets) do
            table.insert(options, { Id = name, Label = name })
        end
        table.sort(options, function(a, b)
            return a.Label < b.Label
        end)
    end
    return options
end
-- 一次性按钮的接线，与持续循环 Tasks 分开。没有回调时按钮显示未接入。
function Adapter:CanControl(id)
    return type((self.bindings.Controls or {})[id]) == "function"
end
function Adapter:Control(id, parameters, context)
    assert(self:CanControl(id), "功能未接入: " .. id)
    return self.bindings.Controls[id](parameters, context)
end
-- 选择类操作必须同时具有选项和执行回调。
function Adapter:CanPerform(page)
    return self.actions[page] ~= nil
        and type(self.actions[page].Perform) == "function"
        and #self:GetOptions(page) > 0
end
-- 执行前再次确认所选 ID 仍在允许列表中。
function Adapter:Perform(page, id, context)
    assert(self:CanPerform(page), "功能未接入")
    local found = false
    for _, option in ipairs(self:GetOptions(page)) do
        if option.Id == id then
            found = true
            break
        end
    end
    assert(found, "选择项已失效")
    return self.actions[page].Perform(id, context)
end
-- 显示可核对的 PlaceId 或 Studio 环境，不把界面打开当成游戏连接成功。
function Adapter:Environment()
    if self.bindings.GetEnvironment then
        local ok, value = pcall(self.bindings.GetEnvironment)
        if ok and type(value) == "table" then
            return value
        end
        return { Title = "环境检测错误", Detail = tostring(value), Badge = "错误", Kind = "error" }
    end
    local studio = game:GetService("RunService"):IsStudio()
    if studio then
        return {
            Title = "Studio 本地环境",
            Detail = "目标游戏尚未核对",
            Badge = "本地",
            Kind = "neutral",
        }
    end
    for _, id in ipairs(self.config.TargetPlaceIds) do
        if game.PlaceId == id then
            return {
                Title = "目标环境已匹配",
                Detail = "PlaceId " .. tostring(game.PlaceId),
                Badge = "已匹配",
                Kind = "good",
            }
        end
    end
    return {
        Title = "目标环境未确认",
        Detail = "PlaceId " .. tostring(game.PlaceId),
        Badge = "未确认",
        Kind = "neutral",
    }
end
-- 优先使用接线模块提供的可信身份，否则显示当前玩家。
function Adapter:Identity(player)
    if self.bindings.GetIdentity then
        local ok, value = pcall(self.bindings.GetIdentity, player)
        if ok and type(value) == "table" then
            return value
        end
    end
    return { Name = player.DisplayName, Tag = "普通用户" }
end
return Adapter
