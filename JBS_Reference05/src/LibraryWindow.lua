--[[
    通用 UI 库窗口：复用现有金属控件、颜色、素材、角色双视图和拖动逻辑。
    页面/右侧设置由调用者添加，库不内置训练、传送、购买或授权逻辑。
    桌面保留三栏；窄窗口把区域上下排列并滚动，文字仍用正常字号。
]]
local Cleanup = require(script.Parent.Cleanup)
local Components = require(script.Parent.Components)
local Motion = require(script.Parent.Motion)
local Assets = require(script.Parent.Assets)
local Defaults = require(script.Parent.Config)
local Theme = require(script.Parent.Theme)
local View = require(script.Parent.View)
local Controls = require(script.Parent.LibraryControls)
local C = Theme.Colors
local Window = {}
Window.__index = Window
local registry = setmetatable({}, {__mode = "k"})
local function rect(object, x, y, w, h)
    object.Position = UDim2.fromOffset(x, y)
    object.Size = UDim2.fromOffset(math.max(1, w), math.max(1, h))
end
local function config(options)
    local result = table.clone(Defaults)
    result.AssetIds = table.clone(Defaults.AssetIds)
    for key, value in pairs(options.AssetIds or {}) do result.AssetIds[key] = value end
    result.AvatarPreview = table.clone(Defaults.AvatarPreview)
    if options.AvatarPreview == false then result.AvatarPreview.Enabled = false
    elseif type(options.AvatarPreview) == "table" then
        for key, value in pairs(options.AvatarPreview) do result.AvatarPreview[key] = value end
    end
    result.DisplayOrder = options.DisplayOrder or Defaults.DisplayOrder
    return result
end

-- 构造失败时也回收已创建的连接/实例；重复 Id 恢复原窗口，不堆叠第二套界面。
function Window.new(options)
    assert(type(options) == "table", "CreateWindow 参数必须是 table")
    local player = game:GetService("Players").LocalPlayer
    assert(player, "JBS UI 库请从客户端 LocalScript 调用")
    local parent = options.Parent or player:WaitForChild("PlayerGui")
    local id = options.Id or "JBS_UI"
    assert(type(id) == "string" and #id <= 64 and id:match("^[%w_-]+$"), "窗口 Id 使用 1–64 个英文字母、数字、下划线或连字符")
    registry[parent] = registry[parent] or {}
    local existing = registry[parent][id]
    if existing and not existing.dead then existing:Show(); return existing, false end
    local ownerName = "JBSUI_Owner_" .. id
    local owner = parent:FindFirstChild(ownerName)
    if owner then
        if owner:IsA("BindableFunction") and owner:GetAttribute("JBSUILibrary") == true then owner:Invoke("Restore") end
        return nil, "同 Id 窗口已存在；没有替换或销毁其他界面"
    end
    local self = setmetatable({Id = id, parent = parent, player = player, options = options,
        config = config(options), scope = Cleanup.new(), motion = Motion.new(options.ReducedMotion == true),
        tabs = {}, tabOrder = {}, controls = {}, sequence = 0, tabSequence = 0, artGaps = {},
        visible = true, dead = false, controller = {window = "Open", page = "home"}}, Window)
    self.assets = Assets.new(self.config.AssetIds)
    self.u = Components.new(self.scope, self.motion, self.assets)
    local ok, err = pcall(function()
        self.Screen = self.u:Make("ScreenGui", parent, id, {ResetOnSpawn = false,
            IgnoreGuiInset = false, DisplayOrder = self.config.DisplayOrder, ZIndexBehavior = Enum.ZIndexBehavior.Sibling})
        self:_Build()
        self.owner = self.u:Make("BindableFunction", parent, ownerName)
        self.owner:SetAttribute("JBSUILibrary", true)
        self.owner.OnInvoke = function(command)
            if command == "Restore" then self:Show(); return true end
            return false
        end
        self.scope:Connect(self.Screen.Destroying, function() self:Destroy() end)
        if options.Hotkey then
            local input = game:GetService("UserInputService")
            self.scope:Connect(input.InputBegan, function(event, processed)
                if not processed and not input:GetFocusedTextBox() and event.KeyCode == options.Hotkey then
                    self:SetVisible(not self.visible)
                end
            end)
        end
        self:SetActions({Start = options.OnStart, Stop = options.OnStop})
        self:Resize()
        self.assets:Load(function() if not self.dead then self:_RefreshArt() end end)
    end)
    if not ok then self:Destroy(); error(err, 2) end
    registry[parent][id] = self
    return self, true
end

function Window:_Scroller(parent, name)
    return self.u:Make("ScrollingFrame", parent, name, {BackgroundTransparency = 1, BorderSizePixel = 0,
        ScrollBarThickness = 4, ScrollBarImageColor3 = C.Light, ClipsDescendants = true,
        CanvasSize = UDim2.fromOffset(0, 0), ScrollingDirection = Enum.ScrollingDirection.Y})
end
function Window:_Art(parent, name, key, x, y, w, h)
    local note = self.u:Text(parent, name .. "Pending", "JBS\n美术资源待上传", x, y, w, h, 18, C.Muted, true)
    note.TextXAlignment, note.TextWrapped = Enum.TextXAlignment.Center, true
    table.insert(self.artGaps, {label = note, key = key})
    return self.u:Art(parent, name, key, x, y, w, h)
end
function Window:_Build()
    local u = self.u
    self.viewport = self:_Scroller(self.Screen, "WindowViewport")
    self.viewport.Size = UDim2.fromScale(1, 1)
    self.root = u:Box(self.viewport, "JBSLibraryWindow", 0, 0, 1672, 941)
    self.shell = u:Panel(self.root, "Shell", 0, 0, 1672, 941)
    self.topbar = u:Panel(self.root, "Topbar", 258, 0, 1414, 60, "card")
    self.title = u:Text(self.topbar, "Title", self.options.Title or "JBS · MUSCLE LEGENDS", 22, 5, 620, 48, 20, C.Light, true)
    self.dragHandle = u:Interact(self.topbar, "DragHandle", 10, 0, 900, 60, function() end)
    self.dragHandle.Selectable = false
    self.windowButtons = {}
    for _, spec in ipairs({
        {"Minimize", "—", function() self:Hide() end},
        {"Resize", "□", function() self.expanded = not self.expanded; self:Resize() end},
        {"Close", "×", function() self:Hide() end},
    }) do
        local label = u:Text(self.topbar, spec[1] .. "Label", spec[2], 0, 5, 54, 46, 25, C.White)
        label.TextXAlignment = Enum.TextXAlignment.Center
        table.insert(self.windowButtons, {label = label, hit = u:Interact(self.topbar, spec[1], 0, 5, 54, 46, spec[3])})
    end
    self.sidebar = u:Panel(self.root, "Sidebar", 0, 0, 246, 914)
    self.logo = self:_Art(self.sidebar, "Logo", "logo_jbs", 8, 6, 230, 147)
    self.navigation = self:_Scroller(self.sidebar, "Navigation")
    self.center = self:_Scroller(self.root, "Center")
    self.hero = u:Panel(self.center, "HeroFrame", 0, 0, 1076, 310)
    if self.config.AvatarPreview.Enabled ~= false then
        if self.config.AvatarPreview.BackEnabled ~= false then require(script.Parent.AvatarSidebarView).Build(self, self.sidebar) end
        require(script.Parent.AvatarHeroView).Build(self)
    else
        self:_Art(self.hero, "Hero", "hero_clean", 3, 3, 1070, 304)
        self:_Art(self.sidebar, "SidebarArt", "sidebar_clean", 0, 629, 246, 245)
    end
    self.brandClose = u:Text(self.sidebar, "BrandClose", "力量不止 · 传奇永在", 10, 875, 226, 24, 16, C.Light)
    self.pagesPanel = u:Panel(self.center, "Pages", 0, 322, 1076, 350)
    self.pageTitle = u:Text(self.pagesPanel, "PageTitle", "添加页面开始使用", 20, 8, 800, 32, 20, C.White, true)
    self.pageHost = u:Box(self.pagesPanel, "PageHost", 16, 50, 1044, 284)
    self.controlPanel = u:Panel(self.root, "Controls", 258, 752, 1076, 162)
    u:Heading(self.controlPanel, self.options.ControlsTitle or "脚本控制", nil, "bolt")
    self.start = u:Button(self.controlPanel, "Start", "开始脚本", 20, 45, 390, 64,
        function() self:_Action("Start") end, true)
    self.stop = u:Button(self.controlPanel, "Stop", "停止脚本", 424, 45, 390, 64,
        function() self:_Action("Stop") end)
    self.feedback = self:_Scroller(self.controlPanel, "Feedback")
    self.feedback.AutomaticCanvasSize = Enum.AutomaticSize.Y
    self.banner = u:Text(self.feedback, "Message", "", 0, 0, 760, 34, 14, C.Light)
    self.banner.TextWrapped, self.banner.TextTruncate = true, Enum.TextTruncate.None
    self.banner.AutomaticSize, self.banner.LineHeight = Enum.AutomaticSize.Y, 1.4
    self.statusPanel = u:Panel(self.root, "Status", 1346, 76, 326, 300)
    u:Heading(self.statusPanel, "脚本状态", nil, "status")
    self.statusRows = {}
    for i, id in ipairs({"connection", "script", "version"}) do
        self.statusRows[id] = View.StatusRow(self, self.statusPanel, id, ({"game", "settings", "version"})[i], 52 + (i - 1) * 78, "", "", "")
    end
    self:SetStatus("connection", {Title = "界面已创建", Detail = "游戏连接由接入方提供", Badge = "UI"})
    self:SetStatus("script", {Title = "等待操作", Detail = "只执行你绑定的回调", Badge = "就绪"})
    self:SetStatus("version", {Title = "JBS UI 1.0.0", Detail = "本地库版本", Badge = "本地"})
    self.settingsPanel = u:Panel(self.root, "Settings", 1346, 388, 326, 330)
    u:Heading(self.settingsPanel, self.options.SettingsTitle or "脚本设置", nil, "settings")
    self.settingsHost = self:_Scroller(self.settingsPanel, "SettingsContent")
    self.settings = Controls.new(self, self.settingsHost, 1)
    self.userPanel = u:Panel(self.root, "User", 1346, 752, 326, 150)
    u:Icon(self.userPanel, "crown", 20, 18, 34)
    self.username = u:Text(self.userPanel, "Username", self.player.DisplayName, 66, 14, 240, 30, 18, C.White, true)
    self.tag = u:Text(self.userPanel, "Tag", self.options.UserTag or "当前玩家", 66, 46, 240, 24, 14, C.Muted)
    self.quote = u:Text(self.userPanel, "Quote", "MORE POWER · MORE POSSIBILITIES", 18, 88, 290, 42, 14, C.Light)
    self.quote.TextWrapped = true
    self.footer = u:Text(self.root, "Footer", self.options.Footer or "The Best Clan In Muscle Legend", 258, 915, 1414, 22, 13, C.Light)
    self.footer.TextXAlignment = Enum.TextXAlignment.Center
    self.restore = u:Button(self.Screen, "Restore", "恢复 JBS", 16, 16, 170, 52, function() self:Show() end, true)
    self.restore.root.Visible = false
    self.scope:Connect(self.viewport:GetPropertyChangedSignal("AbsoluteSize"), function() self:Resize() end)
    View.BindDragging(self)
end

function Window:_RefreshArt()
    for _, gap in ipairs(self.artGaps) do gap.label.Visible = self.assets.status[gap.key] ~= "已加载" end
    -- 紧凑布局没有左侧装饰位，不让异步加载完成重新显示隐藏的图片。
    if self.compact then
        self.logo.Visible = false; self.sidebar.LogoPending.Visible = false
        local art, note = self.sidebar:FindFirstChild("SidebarArt"), self.sidebar:FindFirstChild("SidebarArtPending")
        if art then art.Visible = false end
        if note then note.Visible = false end
    end
    self:RefreshAvatarVisibility()
end
function Window:RefreshAvatarVisibility()
    if not self.heroAvatar then return end
    View.RefreshAvatarVisibility(self)
end

function Window:Resize()
    if self.dead or not self.viewport then return end
    local size = self.viewport.AbsoluteSize
    if size.X <= 0 or size.Y <= 0 then return end
    local w = math.max(280, math.min(self.expanded and size.X - 16 or 1672, size.X - 16))
    local h = math.max(704, math.min(941, size.Y - 16))
    self.compact = w < 1000
    local left, right = w < 1500 and 176 or 246, w < 1500 and 288 or 326
    local centerX, centerW = left + 12, w - left - right - 24
    local centerY, centerH, heroH = 62, h - 254, w < 1500 and 235 or 310
    local sideX, sideY, sideW, sideH = 0, 0, left, h - 27
    local rightX, statusY, statusH = w - right, 76, 288
    local settingsY, settingsH, userY, userH = 376, math.max(150, h - 553), h - 165, 138
    local controlY = h - 189
    if self.compact then
        -- 手机/窄窗只改变排列，不把全页字体一起缩小。
        sideX, sideY, sideW, sideH = 0, 72, w, 132
        centerX, centerW, centerY, centerH, heroH = 0, w, 216, 600, math.max(170, w * 0.29)
        controlY = centerY + centerH + 12
        rightX, right, statusY, statusH = 0, w, controlY + 174, 288
        settingsY, settingsH = statusY + statusH + 12, 320
        userY, userH = settingsY + settingsH + 12, 138
        h = userY + userH + 28
    end
    self.layout = {width = w, height = h, centerWidth = centerW, compact = self.compact}
    local function panel(object, x, y, width, height)
        object.Position = UDim2.fromOffset(x, y); self.u:ResizePanel(object, width, height)
    end
    rect(self.root, math.max(8, (size.X - w) / 2), 8, w, h)
    self.homePosition = self.root.Position
    panel(self.shell, 0, 0, w, h)
    self.viewport.CanvasSize = UDim2.fromOffset(0, h + 16)
    local topX, topW = self.compact and 0 or centerX, self.compact and w or w - centerX
    panel(self.topbar, topX, 0, topW, 60)
    rect(self.title, 22, 5, topW - 206, 48)
    rect(self.dragHandle, 10, 0, topW - 190, 60)
    for i, button in ipairs(self.windowButtons) do
        rect(button.label, topW - 178 + (i - 1) * 56, 5, 54, 46)
        rect(button.hit, topW - 178 + (i - 1) * 56, 5, 54, 46)
    end
    panel(self.sidebar, sideX, sideY, sideW, sideH)
    local navY, navH = self.compact and 12 or 146, self.compact and 108 or math.max(100, sideH - 410)
    rect(self.navigation, 8, navY, sideW - 16, navH)
    self.logo.Visible = not self.compact and self.assets.status.logo_jbs == "已加载"
    self.sidebar.LogoPending.Visible = not self.compact and self.assets.status.logo_jbs ~= "已加载"
    rect(self.logo, 5, 5, sideW - 10, 132)
    rect(self.sidebar.LogoPending, 10, 10, sideW - 20, 120)
    local sideArt = self.sidebar:FindFirstChild("SidebarArt")
    if sideArt then
        local artH = math.min(245, sideW)
        rect(sideArt, 0, sideH - artH - 39, sideW, artH)
        sideArt.Visible = not self.compact and (self.heroAvatar ~= nil or self.assets.status.sidebar_clean == "已加载")
        local note = self.sidebar:FindFirstChild("SidebarArtPending")
        if note then rect(note, 0, sideH - artH - 39, sideW, artH); note.Visible = not self.compact and not self.heroAvatar and self.assets.status.sidebar_clean ~= "已加载" end
    end
    self.brandClose.Visible = not self.compact
    rect(self.brandClose, 10, sideH - 32, sideW - 20, 24)
    local navOffset = 0
    for _, tab in ipairs(self.tabOrder) do
        local titleWidth = sideW - 44
        local bounds = game:GetService("TextService"):GetTextSize(tab.Title, 18, Theme.Bold, Vector2.new(titleWidth, 100000))
        local rowHeight = math.max(54, math.ceil(bounds.Y * 1.4) + 16)
        panel(tab.nav.root, 0, navOffset, sideW - 16, rowHeight)
        rect(tab.nav.label, 14, 8, titleWidth, rowHeight - 16)
        tab.nav.label.TextSize, tab.nav.label.TextWrapped, tab.nav.label.TextTruncate = 18, true, Enum.TextTruncate.None
        rect(tab.nav.button, 0, 0, sideW - 16, rowHeight)
        navOffset += rowHeight + 10
    end
    self.navigation.CanvasSize = UDim2.fromOffset(0, navOffset)
    rect(self.center, centerX, centerY, centerW, centerH)
    panel(self.hero, 0, 0, centerW, heroH)
    rect(self.hero.Hero, 3, 3, centerW - 6, heroH - 6)
    local heroPending = self.hero:FindFirstChild("HeroPending")
    if heroPending then rect(heroPending, 20, 20, centerW - 40, heroH - 40) end
    local pageH = math.max(260, centerH - heroH - 12)
    panel(self.pagesPanel, 0, heroH + 12, centerW, pageH)
    rect(self.pageTitle, 20, 8, centerW - 40, 32)
    rect(self.pageHost, 16, 50, centerW - 32, pageH - 66)
    self.center.CanvasSize = UDim2.fromOffset(0, heroH + 12 + pageH)
    for _, tab in ipairs(self.tabOrder) do
        rect(tab.Root, 0, 0, centerW - 32, pageH - 66)
        tab:Relayout(centerW - 40)
    end
    panel(self.controlPanel, centerX, controlY, centerW, 162)
    local buttonW = (centerW - 54) / 2
    for index, button in ipairs({self.start, self.stop}) do
        panel(button.root, 20 + (index - 1) * (buttonW + 14), 45, buttonW, 64)
        rect(button.button, 0, 0, buttonW, 64); rect(button.label, 12, 0, buttonW - 24, 64)
        button.label.TextSize = 18
    end
    rect(self.feedback, 24, 115, centerW - 48, 36)
    rect(self.banner, 0, 0, centerW - 56, 34)
    panel(self.statusPanel, rightX, statusY, right, statusH)
    for index, id in ipairs({"connection", "script", "version"}) do
        local row, y = self.statusRows[id], 52 + (index - 1) * 78
        rect(row.icon, 18, y + 15, 28, 28)
        rect(row.title, 58, y, right - 140, 26)
        rect(row.detail, 58, y + 28, right - 140, 44)
        row.title.TextSize, row.detail.TextSize = 18, 14
        row.detail.TextWrapped, row.detail.TextTruncate = true, Enum.TextTruncate.None
        rect(row.badge, right - 68, y + 3, 50, 26); row.badge.TextSize = 13
        rect(row.separator, 18, y + 74, right - 36, 1)
    end
    panel(self.settingsPanel, rightX, settingsY, right, settingsH)
    rect(self.settingsHost, 12, 48, right - 24, settingsH - 62)
    self.settings:Relayout(right - 32)
    panel(self.userPanel, rightX, userY, right, userH)
    rect(self.username, 66, 14, right - 84, 30); rect(self.tag, 66, 46, right - 84, 24)
    rect(self.quote, 18, 88, right - 36, 42)
    rect(self.footer, 16, h - 25, w - 32, 22)
    self:RefreshAvatarVisibility()
end

function Window:Tab(options)
    assert(not self.dead, "窗口已销毁")
    if type(options) == "string" then options = {Title = options} end
    options = options or {}
    self.tabSequence += 1
    local id = options.Id or ("tab_" .. self.tabSequence)
    assert(type(id) == "string" and id ~= "" and not self.tabs[id], "Tab.Id 为空或重复")
    local columns = options.Columns or 1
    assert(columns == 1 or columns == 2 or columns == 3, "Columns 只能是 1、2、3")
    assert(options.Title == nil or type(options.Title) == "string", "Tab.Title 必须是字符串")
    local root = self:_Scroller(self.pageHost, "Page_" .. id)
    root.Visible = false
    local tab = Controls.new(self, root, columns)
    tab.Id, tab.Title, tab.Root = id, options.Title or id, root
    tab.navScope = Cleanup.new()
    tab.nav = Components.new(tab.navScope, self.motion, self.assets):Button(self.navigation,
        "Tab_" .. id, tab.Title, 0, 0, 230, 62, function() self:SelectTab(id) end)
    tab.Destroy = function()
        if self.tabs[id] == tab then return self:RemoveTab(id) end
        return false -- 旧 Tab 引用不能销毁后来复用了同一 Id 的新 Tab。
    end
    self.tabs[id] = tab; table.insert(self.tabOrder, tab)
    if not self.activeTab then self:SelectTab(id) end
    self:Resize()
    return tab
end
function Window:RemoveTab(id)
    local tab = self.tabs[id]
    if not tab then return false end
    Controls.Destroy(tab)
    tab.navScope:Destroy()
    for _, object in ipairs(tab.nav.root:GetDescendants()) do self.motion:Cancel(object) end
    self.assets:UnbindTree(tab.nav.root)
    tab.nav.root:Destroy(); tab.Root:Destroy()
    self.tabs[id] = nil
    table.remove(self.tabOrder, table.find(self.tabOrder, tab))
    if self.activeTab == id then
        self.activeTab = nil
        if not self.dead then
            if self.tabOrder[1] then self:SelectTab(self.tabOrder[1].Id)
            else self.pageTitle.Text = "添加页面开始使用" end
        end
    end
    if not self.dead then self:Resize() end
    return true
end
function Window:SelectTab(id)
    if self.dead or not self.tabs[id] then return false end
    self.activeTab = id
    for _, tab in ipairs(self.tabOrder) do
        tab.Root.Visible = tab.Id == id
        tab.nav.label.TextColor3 = tab.Id == id and C.Light or C.White
        for _, control in ipairs(tab.rows) do
            control.drag = nil
            if control.kind == "Dropdown" then control.open = false; control:_Paint() end
            if control.kind == "Slider" then control:_Paint() end
        end
        tab:Relayout()
    end
    self.pageTitle.Text = self.tabs[id].Title
    return true
end
function Window:Sidebar() return self.settings end
function Window:GetControl(id) return self.controls[id] end
function Window:GetValues()
    local values = {}
    for id, control in pairs(self.controls) do if control.value ~= nil then values[id] = control.value end end
    return values
end
function Window:SetStatus(id, info)
    if self.dead then return false end
    local row = self.statusRows[id]
    assert(row, "状态 Id 使用 connection、script 或 version")
    for key, label in pairs({Title = row.title, Detail = row.detail, Badge = row.badge}) do
        if info[key] ~= nil then label.Text = tostring(info[key]) end
    end
    if info.Color then row.badge.BackgroundColor3 = info.Color end
    return true
end
function Window:Notify(message)
    if self.dead then return false end
    if type(message) == "string" then message = {Content = message} end
    self.banner.Text = (message.Title and tostring(message.Title) .. " · " or "") .. tostring(message.Content or "")
    self.feedback.CanvasPosition = Vector2.zero
    return true
end
function Window:_PaintActions()
    for _, pair in ipairs({{"Start", self.start}, {"Stop", self.stop}}) do
        local active = not self.actionBusy and type(self.actions[pair[1]]) == "function"
        pair[2].button.Active, pair[2].button.Selectable = active, active
    end
end
function Window:SetActions(callbacks)
    if self.dead then return false end
    for _, key in ipairs({"Start", "Stop"}) do assert(callbacks[key] == nil or type(callbacks[key]) == "function", key .. " 必须是函数") end
    self.actions = {Start = callbacks.Start, Stop = callbacks.Stop}
    self:_PaintActions()
    if not self.actions.Start and not self.actions.Stop then self:Notify("开始 / 停止回调尚未绑定") end
    return true
end
function Window:_Action(name)
    if self.dead or self.actionBusy or not self.actions[name] then return false end
    self.actionBusy = true; self:_PaintActions()
    local ok, accepted, reason = pcall(self.actions[name], self:GetValues(), self)
    self.actionBusy = false
    if self.dead then return false end
    self:_PaintActions()
    if not ok or accepted == false then self:Notify({Title = "回调未完成", Content = tostring(ok and reason or accepted)}); return false end
    self:Notify(name == "Start" and "已调用开始回调" or "已调用停止回调")
    return true
end
function Window:SetVisible(value)
    if self.dead then return false end
    self.visible = value == true
    self.controller.window = self.visible and "Open" or "Closed"
    self.viewport.Visible, self.restore.root.Visible = self.visible, not self.visible
    for _, control in pairs(self.controls) do
        control.drag = nil
        if control.kind == "Dropdown" then control.open = false; control:_Paint() end
        if control.kind == "Slider" then control:_Paint() end
    end
    for _, tab in ipairs(self.tabOrder) do tab:Relayout() end
    self.settings:Relayout()
    self:RefreshAvatarVisibility()
    return true
end
function Window:Show() return self:SetVisible(true) end
function Window:Hide() return self:SetVisible(false) end
function Window:SetReducedMotion(value) if not self.dead then self.motion:SetReduced(value == true) end end
function Window:OnDestroy(callback)
    assert(type(callback) == "function", "OnDestroy 需要函数")
    self.scope:Add(callback)
    return callback
end
function Window:Diagnostics()
    local count = self.scope:Count()
    for _, tab in ipairs(self.tabOrder) do count += tab.navScope:Count() end
    local controls = 0
    for _, control in pairs(self.controls) do
        controls += 1; count += control.scope:Count() + (control.optionScope and control.optionScope:Count() or 0)
    end
    return {destroyed = self.dead, controls = controls, tabs = #self.tabOrder, connections = count,
        instances = self.dead and 0 or #self.Screen:GetDescendants() + 1,
        avatar = self.heroAvatar and self.heroAvatar:Diagnostics() or {enabled = false}}
end
function Window:Destroy()
    if self.dead then return end
    self.dead = true
    if registry[self.parent] and registry[self.parent][self.Id] == self then registry[self.parent][self.Id] = nil end
    if self.settings then self.settings:Destroy() end
    for _, tab in ipairs(table.clone(self.tabOrder)) do self:RemoveTab(tab.Id) end
    self.scope:Destroy()
    self.motion:Destroy()
    self.assets:Destroy()
    if self.owner then self.owner.OnInvoke = nil; self.owner:Destroy() end
    if self.Screen then self.Screen:Destroy() end
    table.clear(self.tabs); table.clear(self.tabOrder); table.clear(self.controls)
end
return Window
