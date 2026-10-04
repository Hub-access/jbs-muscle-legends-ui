--[[
    主界面布局：左侧导航、中间主视觉/功能页、右侧状态、底部启停。
    阅读 BuildHome 了解首页，BuildPages 了解翻页；旧版业务页细节在 LegacyPages.lua。
    Refresh 只更新显示，不启动游戏功能。窗口隐藏与脚本停止是两个不同动作。
]]
local Catalog = require(script.Parent.LegacyCatalog)
local Theme = require(script.Parent.Theme)
local LegacyPages = require(script.Parent.LegacyPages)
local Layout = require(script.Parent.Layout)
local Components = require(script.Parent.Components)
local C = Theme.Colors
local View = {}
View.__index = View
local function textChanged(label, value)
    if label.Text ~= value then
        label.Text = value
    end
end
-- 先建立全窗口容器，再创建所有页；之后切页只改变 Visible。
function View.new(screen, scope, motion, assets, controller, adapter, player, config)
    local self = setmetatable({
        scope = scope,
        motion = motion,
        assets = assets,
        controller = controller,
        adapter = adapter,
        player = player,
        nav = {},
        pages = {},
        toggles = {},
        extraToggles = {},
        controlButtons = {},
        teleportButtons = {},
        artGaps = {},
        dropdowns = {},
        windowGeneration = 0,
        pageGeneration = 0,
        frameTimes = {},
        config = config,
    }, View)
    local u = Components.new(scope, motion, assets)
    self.u = u
    self.viewport = u:Make("ScrollingFrame", screen, "Viewport", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Size = UDim2.fromScale(1, 1),
        CanvasSize = UDim2.fromOffset(0, 0),
        ScrollBarThickness = 5,
        ScrollBarImageColor3 = C.Light,
        ScrollingDirection = Enum.ScrollingDirection.XY,
    })
    self.root = u:Box(self.viewport, "JBS_Reference05", 0, 0, 1672, 941)
    self.scale = u:Make("UIScale", self.root, "ResponsiveScale", { Scale = 1 })
    self.shell = u:Panel(self.root, "OuterShell", 0, 0, 1672, 941, "panel")
    self.center = u:Make("ScrollingFrame", self.root, "CenterViewport", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = UDim2.fromOffset(258, 62),
        Size = UDim2.fromOffset(1076, 672),
        CanvasSize = UDim2.fromOffset(0, 672),
        ScrollBarThickness = 4,
        ScrollBarImageColor3 = C.Light,
        ScrollingDirection = Enum.ScrollingDirection.XY,
        ClipsDescendants = true,
    })
    self:BuildSidebar()
    self:BuildTopbar()
    self:BuildHome()
    self:BuildPages()
    self:BuildControl()
    self:BuildRight()
    self.footer = u:Text(
        self.root,
        "Footer",
        "J B S   ·   M U S C L E  L E G E N D S   ·   R O B L O X",
        252,
        911,
        1420,
        28,
        16,
        C.Light
    )
    self.footer.TextXAlignment = Enum.TextXAlignment.Center
    self.restore = u:Button(screen, "Restore", "恢复 JBS", 16, 16, 180, 54, function()
        controller:SetWindow("Open")
    end, true)
    self.restore.root.Visible = false
    self.feedbackArea = u:Make("ScrollingFrame", self.controlPanel, "FeedbackArea", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = UDim2.fromOffset(24, 115),
        Size = UDim2.fromOffset(760, 36),
        CanvasSize = UDim2.fromOffset(0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ScrollBarThickness = 3,
        ClipsDescendants = true,
    })
    self.banner = u:Text(self.feedbackArea, "Feedback", "", 0, 0, 760, 36, 14, C.Light)
    self.banner.TextWrapped = true
    self.banner.TextTruncate = Enum.TextTruncate.None
    self.banner.LineHeight = 1.35
    self.banner.AutomaticSize = Enum.AutomaticSize.Y
    u:Make("Frame", screen, "SafeBounds", { Visible = false, Size = UDim2.fromScale(1, 1) })
    scope:Connect(self.viewport:GetPropertyChangedSignal("AbsoluteSize"), function()
        self:Resize()
    end)
    self:BindDragging()
    self:Resize()
    self:Refresh()
    return self
end
-- 装饰图未接入时显示明确占位说明，不阻止其他控件使用。
function View:Art(parent, name, key, x, y, w, h, message)
    local fallback =
        self.u:Text(parent, name .. "Pending", message, x + 20, y + 12, w - 40, h - 24, 24, C.Muted, true)
    fallback.TextWrapped = true
    fallback.TextXAlignment = Enum.TextXAlignment.Center
    table.insert(self.artGaps, { label = fallback, key = key })
    return self.u:Art(parent, name, key, x, y, w, h)
end
-- 六个导航按钮共用控制器的 page 状态。
function View:BuildSidebar()
    local u = self.u
    local c = self.controller
    local panel = u:Panel(self.root, "Sidebar", 0, 0, 246, 914, "panel")
    self:Art(panel, "Logo", "logo_jbs", 8, 6, 230, 147, "品牌字标\n美术资源未接入")
    local nav = u:Box(panel, "Navigation", 8, 177, 230, 450)
    u:Make("UIListLayout", nav, "NavigationLayout", {
        FillDirection = Enum.FillDirection.Vertical,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 12),
    })
    for i, page in ipairs(Theme.Pages) do
        local row = u:Panel(nav, "Nav_" .. page[1], 0, 0, 230, 66, "card")
        row.LayoutOrder = i
        local face = u:Line(row, "SelectedFace", 10, 6, 210, 54, C.Pink)
        u:Make(
            "UIGradient",
            face,
            "SelectionGradient",
            { Color = ColorSequence.new(C.Pink, Color3.fromHex("57103F")) }
        )
        u:Icon(row, page[3], 21, 10, 43)
        local caption = u:Text(row, "Label", page[2], 85, 0, 133, 66, 27, C.White, true)
        local hit = u:Interact(row, "Navigate", 0, 0, 230, 66, function()
            c:SetPage(page[1])
        end)
        self.nav[page[1]] = { face = face, label = caption, button = hit, shell = row }
    end
    if
        self.config.AvatarPreview
        and self.config.AvatarPreview.Enabled ~= false
        and self.config.AvatarPreview.BackEnabled ~= false
    then
        require(script.Parent.AvatarSidebarView).Build(self, panel)
    else
        self:Art(panel, "SidebarArt", "sidebar_art", 0, 629, 246, 245, "人物装饰\n美术资源未接入")
    end
    u:Text(panel, "BrandClose", "力量不止 · 传奇永在", 20, 875, 215, 24, 20, C.White, true)
end
-- 把拖动区与最小化/尺寸/关闭按钮分开，避免点击被拖拽吞掉。
function View:BuildTopbar()
    local u = self.u
    local c = self.controller
    local bar = u:Panel(self.root, "Topbar", 252, 0, 1420, 60, "card")
    u:Text(bar, "Brand", "JBS  MUSCLE LEGENDS   >>>", 68, 4, 360, 48, 20, C.Light, true)
    u:Text(bar, "Motto", "TRAIN HARDER  ·  BECOME STRONGER", 450, 9, 535, 40, 17, C.Muted)
    local slogan = u:Art(bar, "BrandSlogan", "frame_atlas", 990, 0, 220, 56)
    slogan.ImageRectOffset = Vector2.new(352, 256)
    slogan.ImageRectSize = Vector2.new(245, 60)
    self.dragHandle = u:Interact(bar, "TitleDragArea", 14, 4, 1190, 48, function() end)
    self.dragHandle.Selectable = false
    for _, button in ipairs({
        {
            "Minimize",
            "—",
            1220,
            function()
                c:SetWindow("Minimized")
            end,
        },
        {
            "Resize",
            "□",
            1284,
            function()
                c:SetSizeMode(c.sizeMode == "Fit" and "Comfort" or "Fit")
            end,
        },
        {
            "Close",
            "×",
            1348,
            function()
                c:SetWindow("Closed")
            end,
        },
    }) do
        local label = u:Text(bar, button[1] .. "Icon", button[2], button[3], 5, 60, 45, 30, C.White)
        label.TextXAlignment = Enum.TextXAlignment.Center
        u:Interact(bar, button[1], button[3], 5, 60, 45, button[4])
    end
end
-- 首页保留图五主视觉、三个开关和三个功能页入口。
function View:BuildHome()
    local u, c = self.u, self.controller
    local page = u:Box(self.center, "Page_home", 0, 0, 1076, 672)
    self.pages.home = page
    self.hero = u:Panel(page, "HeroFrame", 0, 0, 1076, 310, "panel")
    if self.config.AvatarPreview and self.config.AvatarPreview.Enabled ~= false then
        require(script.Parent.AvatarHeroView).Build(self)
    else
        self:Art(self.hero, "Hero", "hero_banner", 3, 3, 1070, 304, "主视觉美术资源未接入")
    end
    self.quick = u:Panel(page, "QuickFunctions", 0, 322, 1076, 350, "panel")
    u:Heading(self.quick, "快捷功能", nil, "strength")
    self.cardGrid = u:Box(self.quick, "Cards", 16, 52, 1044, 238)
    self.gridLayout = u:Make("UIGridLayout", self.cardGrid, "CardGrid", {
        CellSize = UDim2.fromOffset(338, 112),
        CellPadding = UDim2.fromOffset(14, 14),
        SortOrder = Enum.SortOrder.LayoutOrder,
        FillDirectionMaxCells = 3,
    })
    self.cards = {}
    for index = 1, 3 do
        local f = Theme.Features[index]
        local card = u:Panel(self.cardGrid, "Card_" .. f.id, 0, 0, 338, 112, "card")
        card.LayoutOrder = index
        local icon = u:Icon(card, f.icon, 16, 34, 44)
        local title = u:Text(card, "Title", f.title, 72, 27, 170, 29, 21, C.White, true)
        local description = u:Text(card, "Description", f.description, 72, 60, 170, 23, 16, C.Muted)
        self.toggles[f.id] = u:Toggle(card, "Toggle_" .. f.id, 258, 32, function()
            c:SetSelected(f.id, not c.selected[f.id])
        end)
        table.insert(
            self.cards,
            {
                root = card,
                icon = icon,
                title = title,
                description = description,
                action = self.toggles[f.id].root,
            }
        )
    end
    for index, f in ipairs({
        { "teleport", "传送地点", "14 个传送地点", "pin" },
        { "pets", "宠物商店购买", "选择宠物 / 光环", "pet" },
        { "boss", "自动打Boss", "自动寻找 Boss", "boss" },
    }) do
        local card = u:Panel(self.cardGrid, "Card_" .. f[1], 0, 0, 338, 112, "card")
        card.LayoutOrder = index + 3
        local icon = u:Icon(card, f[4], 16, 34, 44)
        local title = u:Text(card, "Title", f[2], 72, 27, 212, 29, 21, C.White, true)
        local description = u:Text(card, "Description", f[3], 72, 60, 212, 23, 16, C.Muted)
        local arrow = u:Icon(card, "arrow", 294, 42, 27)
        local hit = u:Interact(card, "Open_" .. f[1], 0, 0, 338, 112, function()
            c:SetPage(f[1])
        end)
        table.insert(
            self.cards,
            { root = card, icon = icon, title = title, description = description, action = arrow, hit = hit }
        )
    end
    -- 原输入框的提交回调继续由 LegacyPages.Input 提供，只移动到卡片下方。
    self.parameterRow = u:Box(self.quick, "ParameterRow", 16, 298, 1044, 44)
    u:Line(self.parameterRow, "Divider", 0, 0, 1044, 1, C.Border)
    u:Text(self.parameterRow, "TargetLabel", Catalog.labels.targetRebirths, 10, 8, 110, 28, 18, C.White, true)
    self.targetInput = LegacyPages.Input(
        self,
        self.parameterRow,
        "targetRebirths",
        "",
        "重生目标，0为无限",
        130,
        -26,
        180
    )
    self.targetInput.Position = UDim2.fromOffset(130, 8)
    self.targetInput.Size = UDim2.fromOffset(180, 32)
    self.targetInput.TextSize = 18
    u:Text(self.parameterRow, "TargetHint", "0 为无限", 326, 8, 190, 28, 14, C.Muted)
end
-- 下拉菜单使用可复用行池：重新读取宠物名单只改文字，已有行不会重复绑定。
function View:Dropdown(parent, name, options, x, y, w, choose)
    local u = self.u
    local state = { open = false, value = nil, options = {}, rows = {} }
    state.button = u:Button(parent, name, "请选择", x, y, w, 58, function()
        -- 展开前重新读取，避免玩家离开后仍显示过期名字。
        if state.page then
            state.SetOptions(self.adapter:GetOptions(state.page))
        end
        if #state.options == 0 then
            return
        end
        state.open = not state.open
        state.list.Visible = state.open
    end, false)
    state.list = u:Make("ScrollingFrame", parent, name .. "Options", {
        Visible = false,
        BackgroundColor3 = C.Black,
        BorderSizePixel = 0,
        Position = UDim2.fromOffset(x, y + 60),
        Size = UDim2.fromOffset(w, 240),
        CanvasSize = UDim2.fromOffset(0, 0),
        ScrollBarThickness = 5,
        ZIndex = 30,
    })
    state.SetOptions = function(nextOptions)
        state.options = nextOptions
        state.list.CanvasSize = UDim2.fromOffset(0, #nextOptions * 48)
        for index, option in ipairs(nextOptions) do
            if not state.rows[index] then
                local label =
                    u:Text(state.list, "Option_" .. index, "", 16, (index - 1) * 48, w - 32, 46, 22, C.White)
                label.ZIndex = 31
                local hit = u:Interact(state.list, "Choose_" .. index, 0, (index - 1) * 48, w, 48, function()
                    local current = state.options[index]
                    state.open = false
                    state.list.Visible = false
                    if current then
                        choose(current.Id)
                    end
                end)
                hit.ZIndex = 32
                state.rows[index] = { label = label, hit = hit }
            end
            state.rows[index].label.Text = option.Label
        end
        for index, row in ipairs(state.rows) do
            row.label.Visible = index <= #nextOptions
            row.hit.Visible = index <= #nextOptions
        end
        state.button.button.Active = #nextOptions > 0
        state.button.button.Selectable = #nextOptions > 0
        if #nextOptions == 0 then
            state.open = false
            state.list.Visible = false
        end
    end
    state.Set = function(value)
        state.value = value
        local title = #state.options > 0 and "请选择" or "暂无可用选项"
        for _, option in ipairs(state.options) do
            if option.Id == value then
                title = option.Label
            end
        end
        textChanged(state.button.label, title)
    end
    state.SetOptions(options)
    table.insert(self.dropdowns, state)
    return state
end
-- 建立设置页及四个旧版业务页；实际旧版布局委托给 LegacyPages。
function View:BuildPages()
    local u = self.u
    local c = self.controller
    for _, p in ipairs(Theme.Pages) do
        if p[1] ~= "home" then
            local page = u:Panel(self.center, "Page_" .. p[1], 0, 0, 1084, 658, "panel")
            page.Visible = false
            self.pages[p[1]] = page
            u:Icon(page, p[3], 36, 28, 52)
            u:Text(page, "Title", p[2], 112, 24, 840, 64, 34, C.White, true)
            u:Text(page, "Subtitle", "JBS · MUSCLE LEGENDS", 40, 106, 930, 34, 21, C.Muted)
            u:Line(page, "Divider", 38, 153, 1008, 2, C.Border)
            if p[1] == "settings" then
                u:Text(page, "EffectsHeading", "界面动效", 44, 188, 800, 40, 26, C.White, true)
                u:Text(
                    page,
                    "EffectsHint",
                    "减少动态保留相同的图片、颜色和静态清晰度。",
                    44,
                    234,
                    952,
                    40,
                    22,
                    C.Muted
                )
                self.effects = self:Dropdown(
                    page,
                    "Effects",
                    { { Id = "full", Label = "完整效果" }, { Id = "reduced", Label = "减少动态" } },
                    44,
                    299,
                    620,
                    function(value)
                        c:SetReduced(value == "reduced")
                    end
                )
                u:Text(
                    page,
                    "Persistence",
                    "页面、选项与动效在本次 PlayerGui 会话中保留。",
                    44,
                    408,
                    970,
                    46,
                    22,
                    C.Muted
                )
                u:Text(
                    page,
                    "Persistence2",
                    "跨次登录存储可通过 BusinessBindings.LoadState / SaveState 接入。",
                    44,
                    457,
                    970,
                    46,
                    20,
                    C.Muted
                )
                self.assetReport = u:Text(page, "Assets", "", 44, 548, 980, 74, 21, C.Light)
                self.assetReport.TextWrapped = true
            else
                LegacyPages.Build(self, page, p[1])
            end
        end
    end
end
-- 开始与停止只调用状态控制器，避免在界面层直接开循环。
function View:BuildControl()
    local u, c = self.u, self.controller
    local panel = u:Panel(self.root, "ScriptControl", 258, 746, 1076, 162, "panel")
    self.controlPanel = panel
    u:Heading(panel, "脚本控制", nil, "bolt")
    self.start = u:Button(panel, "Start", "开始脚本", 20, 45, 380, 64, function()
        c:Start()
    end, true)
    self.stop = u:Button(panel, "Stop", "停止脚本", 414, 45, 380, 64, function()
        c:Stop()
    end, false)
    for _, item in ipairs({ { self.start, "play" }, { self.stop, "stop" } }) do
        u:Icon(item[1].root, item[2], 64, 13, 38)
        item[1].label.Position = UDim2.fromOffset(112, 0)
        item[1].label.Size = UDim2.fromOffset(230, 64)
        item[1].label.TextSize = 24
        item[1].label.TextXAlignment = Enum.TextXAlignment.Left
    end
    self:Art(panel, "ControlArt", "control_art", 838, 9, 225, 129, "美术资源未接入")
end
-- 统一创建状态行，后续只替换标题、描述与徽标文字。
function View:StatusRow(parent, name, icon, y, title, detail, badge)
    local u = self.u
    local image = u:Icon(parent, icon, 22, y + 17, 32)
    local row = {
        icon = image,
        title = u:Text(parent, name .. "Title", title, 88, y, 215, 32, 19, C.White, true),
        detail = u:Text(parent, name .. "Detail", detail, 88, y + 36, 215, 28, 19, C.Muted),
        badge = u:Text(parent, name .. "Badge", badge, 241, y + 4, 65, 27, 19, C.White, true),
    }
    row.title.Size = UDim2.fromOffset(149, 32)
    row.badge.TextXAlignment = Enum.TextXAlignment.Center
    row.badge.BackgroundTransparency = 0.2
    row.badge.BackgroundColor3 = C.Dim
    u:Make("UICorner", row.badge, "StatusPill", { CornerRadius = UDim.new(1, 0) })
    row.separator = u:Line(parent, "Separator", 24, y + 78, 280, 1, C.Border)
    return row
end
-- 右侧五个快捷开关与旧版对应页面共享状态。
function View:BuildRight()
    local u = self.u
    local c = self.controller
    local status = u:Panel(self.root, "Status", 1346, 76, 326, 346, "panel")
    self.statusPanel = status
    u:Heading(status, "脚本状态", nil, "status")
    self.environment = self:StatusRow(status, "Environment", "game", 86, "", "", "")
    self.lifecycle =
        self:StatusRow(status, "Lifecycle", "settings", 172, "脚本未开始", "等待操作", "未开始")
    self.version = self:StatusRow(
        status,
        "Version",
        "version",
        258,
        "版本 " .. self.config.Version,
        "本地配置版本",
        "本地"
    )
    local settings = u:Panel(self.root, "Settings", 1346, 434, 326, 318, "panel")
    self.settingsPanel = settings
    u:Heading(settings, "脚本设置", nil, "settings")
    for i = 4, #Theme.Features do
        local f = Theme.Features[i]
        local y = 75 + (i - 4) * 42
        u:Icon(settings, f.icon, 28, y + 1, 28)
        u:Text(settings, "Label_" .. f.id, f.title, 64, y, 175, 32, 20, C.White)
        self.toggles[f.id] = u:Toggle(settings, "Toggle_" .. f.id, 236, y, function()
            c:SetSelected(f.id, not c.selected[f.id])
        end, true)
    end
    local identity = self.adapter:Identity(self.player)
    local user = u:Panel(self.root, "User", 1346, 764, 326, 150, "panel")
    self.userPanel = user
    u:Icon(user, "crown", 26, 21, 49)
    u:Text(user, "Username", identity.Name or self.player.DisplayName, 92, 19, 204, 31, 22, C.White, true)
    u:Text(user, "Permission", identity.Tag or "普通用户", 92, 51, 205, 27, 19, C.Light)
    u:Line(user, "Divider", 24, 87, 280, 1, C.Border)
    u:Icon(user, "gem", 26, 103, 44)
    u:Text(user, "Quote", "强大的不是脚本，", 93, 99, 213, 28, 20, C.Muted)
    u:Text(user, "Quote2", "而是永不放弃的你。", 93, 129, 213, 28, 20, C.Muted)
end
-- 保持默认逻辑字号；窄窗重排卡片并只滚动中间内容。
function View:Resize()
    local size = self.viewport.AbsoluteSize
    if size.X <= 0 or size.Y <= 0 then
        return
    end
    Layout.Apply(self, size.X, size.Y)
    self.motion:Cancel(self.root)
    self.root.Position = self.homePosition
    if self.controller.window ~= "Open" then
        self.viewport.Visible = false
    end
end
-- 鼠标与触摸共用拖动逻辑，只绑定一次移动和结束事件。
function View:BindDragging()
    local input = game:GetService("UserInputService")
    local drag = nil
    self.scope:Connect(self.dragHandle.InputBegan, function(event)
        if
            event.UserInputType == Enum.UserInputType.MouseButton1
            or event.UserInputType == Enum.UserInputType.Touch
        then
            drag = { input = event, point = event.Position, origin = self.root.Position }
        end
    end)
    self.scope:Connect(input.InputChanged, function(event)
        if not drag then
            return
        end
        if event.UserInputType ~= Enum.UserInputType.MouseMovement and event ~= drag.input then
            return
        end
        local delta = event.Position - drag.point
        local s = self.viewport.AbsoluteSize
        self.root.Position = UDim2.fromOffset(
            math.clamp(drag.origin.X.Offset + delta.X, 8, math.max(8, s.X - 180)),
            math.clamp(drag.origin.Y.Offset + delta.Y, 8, math.max(8, s.Y - 60))
        )
        self.homePosition = self.root.Position
    end)
    self.scope:Connect(input.InputEnded, function(event)
        if drag and (event == drag.input or event.UserInputType == Enum.UserInputType.MouseButton1) then
            drag = nil
        end
    end)
end
-- 业务状态与角色显示解耦：切页/关闭窗口暂停展示，不停止任何业务回调。
function View:RefreshAvatarVisibility()
    if not self.heroAvatar then
        return
    end
    local visibility = {}
    for id, holder in pairs(self.avatarHolders) do
        local visible = self.controller.window == "Open"
        local point, size = holder.AbsolutePosition, holder.AbsoluteSize
        local left, top, right, bottom = point.X, point.Y, point.X + size.X, point.Y + size.Y
        local node = holder
        while node and visible do
            if node:IsA("GuiObject") and not node.Visible then visible = false end
            if node:IsA("ScreenGui") and not node.Enabled then visible = false end
            -- 中间内容滚动后，完全离开裁切区域的主横幅也释放展示；不只看 Visible。
            if node:IsA("GuiObject") and (node.ClipsDescendants or node:IsA("ScrollingFrame")) then
                local p, s = node.AbsolutePosition, node.AbsoluteSize
                if size.X > 0 and size.Y > 0 and s.X > 0 and s.Y > 0 then
                    left = math.max(left, p.X)
                    top = math.max(top, p.Y)
                    right = math.min(right, p.X + s.X)
                    bottom = math.min(bottom, p.Y + s.Y)
                    if right <= left or bottom <= top then
                        visible = false
                    end
                end
            end
            node = node.Parent
        end
        visibility[id] = visible and (id ~= "front" or self.controller.page == "home")
    end
    self.heroAvatar:SetViewVisibility(visibility)
end
-- 状态变化后更新现有实例；不重建页面，不调用业务启动。
function View:Refresh()
    local began = os.clock()
    local c = self.controller
    if c.dead then
        return
    end
    if self.lastReduced ~= c.reduced then
        self.lastReduced = c.reduced
        self.motion:SetReduced(c.reduced)
    end
    for id, nav in pairs(self.nav) do
        local selected = c.page == id
        nav.face.Visible = selected
        for _, child in ipairs(nav.shell:GetChildren()) do
            if child.Name == "Body" or child.Name == "FallbackEdge" then
                child.Visible = selected
            elseif child.Name == "MetalPatch" then
                child.Visible = selected and self.assets.status.frame_atlas == "已加载"
            end
        end
    end
    if self.lastPage ~= c.page then
        self.pageGeneration += 1
        for id, page in pairs(self.pages) do
            page.Visible = c.page == id
        end
        for _, dropdown in ipairs(self.dropdowns) do
            dropdown.open = false
            dropdown.list.Visible = false
        end
        local page = self.pages[c.page] or self.pages.home
        local origin = UDim2.fromOffset(0, 0)
        page.Position = UDim2.fromOffset(8, 0)
        self.motion:To(page, Theme.Motion.Page, { Position = origin })
        self.lastPage = c.page
        self.center.CanvasPosition = Vector2.zero
        self:Resize()
    end
    for id, toggle in pairs(self.toggles) do
        toggle.Set(c.selected[id] == true, self.adapter:Available(id))
    end
    for _, dropdown in ipairs(self.dropdowns) do
        if dropdown.page then
            dropdown.SetOptions(self.adapter:GetOptions(dropdown.page))
            dropdown.Set(c.choices[dropdown.page])
        end
    end
    LegacyPages.Refresh(self)
    self.effects.Set(c.reduced and "reduced" or "full")
    local env = self.adapter:Environment()
    textChanged(self.environment.title, env.Title or "环境未知")
    textChanged(self.environment.detail, env.Detail or "未提供检测数据")
    textChanged(self.environment.badge, env.Badge or "未知")
    self.environment.badge.BackgroundColor3 = env.Kind == "good" and C.Green
        or (env.Kind == "error" and C.Error or C.Dim)
    textChanged(self.lifecycle.title, "脚本" .. c:PhaseText())
    textChanged(self.lifecycle.badge, c:PhaseText())
    textChanged(
        self.lifecycle.detail,
        c.phase == "Error" and "请查看底部错误提示"
            or (c.phase == "Running" and "所选任务已启动" or "仅管理本脚本任务")
    )
    self.lifecycle.badge.BackgroundColor3 = c.phase == "Running" and C.Pink
        or (c.phase == "Error" and C.Error or C.Dim)
    textChanged(self.banner, c.message)
    self.banner.TextColor3 = c.phase == "Error" and C.Error or C.Light
    self.start.button.Active = not c.busy and c.phase ~= "Running" and c.phase ~= "Stopping"
    self.start.button.Selectable = self.start.button.Active
    textChanged(self.start.label, c.phase == "Starting" and "启动中…" or "开始脚本")
    textChanged(self.stop.label, c.phase == "Stopping" and "停止中…" or "停止脚本")
    local loaded, total = self.assets:Summary()
    textChanged(
        self.assetReport,
        "美术资源 "
            .. loaded
            .. " / "
            .. total
            .. " 已加载。未接入或失败时显示降级界面。"
    )
    for _, gap in ipairs(self.artGaps) do
        gap.label.Visible = self.assets.status[gap.key] ~= "已加载"
            and not (gap.key == "control_art" and self.layout and self.layout.narrow)
    end
    -- 异步图片加载也会触发 Refresh；窄窗仍须保留按钮宽度。
    if self.layout and self.layout.narrow then
        self.controlPanel.ControlArt.Visible = false
    end
    if self.lastMode ~= c.sizeMode then
        self.lastMode = c.sizeMode
        self:Resize()
    end
    if self.lastWindow ~= c.window then
        self.lastWindow = c.window
        self.windowGeneration += 1
        local generation = self.windowGeneration
        if c.window == "Open" then
            self.viewport.Visible = true
            self.restore.root.Visible = false
            local p = self.homePosition
            self.root.Position = UDim2.fromOffset(p.X.Offset, p.Y.Offset + 10)
            self.motion:To(self.root, Theme.Motion.Open, { Position = p })
        else
            self.restore.root.Visible = true
            local p = self.homePosition
            self.motion:To(
                self.root,
                Theme.Motion.Hide,
                { Position = UDim2.fromOffset(p.X.Offset, p.Y.Offset + 10) },
                function()
                    if not c.dead and generation == self.windowGeneration and c.window ~= "Open" then
                        self.viewport.Visible = false
                    end
                end
            )
        end
    elseif c.reduced then
        self.viewport.Visible = c.window == "Open"
    end
    self:RefreshAvatarVisibility()
    local ms = (os.clock() - began) * 1000
    self.refreshCount = (self.refreshCount or 0) + 1
    self.refreshTotal = (self.refreshTotal or 0) + ms
    self.refreshMax = math.max(self.refreshMax or 0, ms)
end
return View
