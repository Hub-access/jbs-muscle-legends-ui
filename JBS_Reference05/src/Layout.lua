--[[
    第一阶段排版参数与自适应：只调整现有控件的尺寸/位置，不触碰游戏回调。
    默认 100% 逻辑字号；窗口变窄时快捷卡三列变两列，中栏可滚动。
    面板边框复用 Components.ResizePanel，重排不会新建控件或事件。
]]
local Layout = {}
local function rect(object, x, y, w, h)
    object.Position = UDim2.fromOffset(x, y)
    object.Size = UDim2.fromOffset(math.max(1, w), math.max(1, h))
end
local function text(object, x, y, w, h, size, wrapped)
    rect(object, x, y, w, h)
    object.TextSize = size
    object.TextScaled = false
    object.TextWrapped = wrapped == true
    object.TextTruncate = Enum.TextTruncate.None
    object.LineHeight = 1.35
end
function Layout.Compute(width, height, comfort)
    local scale = comfort and 0.9 or 1
    local w, h = math.min(1672, (width - 16) / scale), math.min(941, (height - 16) / scale)
    local narrow = w < 1500
    local left, right = narrow and 176 or 246, narrow and 288 or 326
    local center = w - left - right - 24
    local columns = center >= 990 and 3 or (center >= 640 and 2 or 1)
    local hero = narrow and math.max(225, center * 380 / 1085) or 310
    local rows = math.ceil(6 / columns)
    local quick = 52 + rows * 112 + (rows - 1) * 14 + 58
    local short = h < 900
    return {
        width = w,
        height = h,
        scale = scale,
        narrow = narrow,
        left = left,
        right = right,
        centerX = left + 12,
        centerW = center,
        rightX = w - right,
        centerH = h - 269,
        columns = columns,
        cardW = (center - 32 - (columns - 1) * 14) / columns,
        heroH = hero,
        quickH = quick,
        statusH = short and 288 or 346,
        settingsY = short and 376 or 434,
        settingsH = short and 302 or 318,
        userY = short and 690 or h - 177,
        userH = short and h - 717 or 150,
        short = short,
    }
end
function Layout.Apply(v, viewportWidth, viewportHeight)
    local l = Layout.Compute(viewportWidth, viewportHeight, v.controller.sizeMode == "Comfort")
    v.layout = l
    local u = v.u
    local function panel(object, x, y, w, h)
        object.Position = UDim2.fromOffset(x, y)
        u:ResizePanel(object, w, h)
    end
    v.scale.Scale = l.scale
    v.root.Size = UDim2.fromOffset(l.width, l.height)
    -- 外壳跟随可用窗口，只有中间内容拥有独立滚动范围。
    v.viewport.CanvasSize = UDim2.fromOffset(viewportWidth, viewportHeight)
    v.homePosition = UDim2.fromOffset(
        math.max(8, (viewportWidth - l.width * l.scale) / 2),
        math.max(8, (viewportHeight - l.height * l.scale) / 2)
    )
    panel(v.shell, 0, 0, l.width, l.height)
    rect(v.center, l.centerX, 62, l.centerW, l.centerH)
    local homeHeight = l.heroH + 12 + l.quickH
    v.pages.home.Size = UDim2.fromOffset(l.centerW, homeHeight)
    v.center.CanvasSize = v.controller.page == "home" and UDim2.fromOffset(0, homeHeight)
        or UDim2.fromOffset(1084, 658)
    panel(v.hero, 0, 0, l.centerW, l.heroH)
    rect(v.hero.Hero, 3, 3, l.centerW - 6, l.heroH - 6)
    rect(v.hero.HeroPending, 20, 20, l.centerW - 40, l.heroH - 40)
    panel(v.quick, 0, l.heroH + 12, l.centerW, l.quickH)
    local rows = math.ceil(6 / l.columns)
    local gridHeight = rows * 112 + (rows - 1) * 14
    rect(v.cardGrid, 16, 52, l.centerW - 32, gridHeight)
    v.gridLayout.CellSize = UDim2.fromOffset(l.cardW, 112)
    v.gridLayout.FillDirectionMaxCells = l.columns
    for _, card in ipairs(v.cards) do
        u:ResizePanel(card.root, l.cardW, 112)
        local actionWidth = card.hit and 30 or 64
        local textWidth = l.cardW - 72 - 16 - actionWidth - 16
        text(card.title, 72, 27, textWidth, 29, 21)
        text(card.description, 72, 60, textWidth, 23, 16)
        rect(
            card.action,
            l.cardW - 16 - actionWidth,
            card.hit and 42 or 32,
            actionWidth,
            card.hit and 27 or 48
        )
        if card.hit then
            rect(card.hit, 0, 0, l.cardW, 112)
        end
    end
    rect(v.parameterRow, 16, 52 + gridHeight + 8, l.centerW - 32, 44)
    rect(v.parameterRow.Divider, 0, 0, l.centerW - 32, 1)
    local sidebar = v.root.Sidebar
    panel(sidebar, 0, 0, l.left, l.height - 27)
    rect(sidebar.Logo, 5, 5, l.left - 10, l.narrow and 118 or 150)
    rect(sidebar.LogoPending, 10, 10, l.left - 20, 120)
    rect(sidebar.Navigation, 8, l.narrow and 135 or 170, l.left - 16, 430)
    sidebar.Navigation.NavigationLayout.Padding = UDim.new(0, l.narrow and 9 or 10)
    for _, nav in pairs(v.nav) do
        local rowHeight = l.narrow and 55 or 62
        u:ResizePanel(nav.shell, l.left - 16, rowHeight)
        rect(nav.face, 6, 5, l.left - 28, rowHeight - 10)
        rect(nav.button, 0, 0, l.left - 16, rowHeight)
        text(
            nav.label,
            l.narrow and 52 or 76,
            0,
            l.left - (l.narrow and 76 or 102),
            rowHeight,
            l.narrow and 20 or 24
        )
        for _, child in ipairs(nav.shell:GetChildren()) do
            if child.Name:sub(1, 5) == "Icon_" then
                rect(child, 14, (rowHeight - 34) / 2, 34, 34)
            end
        end
    end
    local artHeight = math.min(245, l.left * 245 / 248)
    rect(sidebar.SidebarArt, 0, l.height - 65 - artHeight, l.left, artHeight)
    rect(sidebar.SidebarArtPending, 10, l.height - 65 - artHeight, l.left - 20, artHeight)
    text(sidebar.BrandClose, 10, l.height - 61, l.left - 20, 27, l.narrow and 13 or 17)
    local bar = v.root.Topbar
    local barWidth = l.width - l.centerX
    panel(bar, l.centerX, 0, barWidth, 60)
    text(bar.Brand, 28, 5, 370, 46, 18)
    bar.Motto.Visible = not l.narrow
    text(bar.Motto, 410, 8, barWidth - 850, 40, 13)
    rect(bar.BrandSlogan, barWidth - 430, 0, 220, 56)
    rect(v.dragHandle, 14, 4, barWidth - 206, 48)
    for index, name in ipairs({ "Minimize", "Resize", "Close" }) do
        rect(bar:FindFirstChild(name), barWidth - 192 + (index - 1) * 64, 5, 60, 45)
        rect(bar:FindFirstChild(name .. "Icon"), barWidth - 192 + (index - 1) * 64, 5, 60, 45)
    end
    panel(v.controlPanel, l.centerX, l.height - 189, l.centerW, 162)
    local usable = l.centerW - (l.narrow and 40 or 284)
    local buttonWidth = (usable - 14) / 2
    for index, item in ipairs({ { v.start, "play" }, { v.stop, "stop" } }) do
        local button = item[1]
        panel(button.root, 20 + (index - 1) * (buttonWidth + 14), 45, buttonWidth, 64)
        rect(button.button, 0, 0, buttonWidth, 64)
        local titleX = math.max(68, (buttonWidth - 184) / 2 + 56)
        text(button.label, titleX, 0, buttonWidth - titleX - 12, 64, 24)
        rect(button.root:FindFirstChild("Icon_" .. item[2]), titleX - 52, 13, 38, 38)
    end
    local art = v.controlPanel.ControlArt
    rect(art, l.centerW - 238, 10, 225, 129)
    -- 窄窗只收起这处装饰留白，人物图片文件保持原样。
    art.Visible = not l.narrow and v.assets.status.control_art == "已加载"
    v.controlPanel.ControlArtPending.Visible = not l.narrow and v.assets.status.control_art ~= "已加载"
    rect(v.feedbackArea, 24, 115, usable - 8, 36)
    v.banner.Size = UDim2.fromOffset(usable - 16, 36)
    panel(v.statusPanel, l.rightX, 76, l.right, l.statusH)
    local rowHeight = (l.statusH - 64) / 3
    for index, row in ipairs({ v.environment, v.lifecycle, v.version }) do
        local y = 52 + (index - 1) * rowHeight
        rect(row.icon, 22, y + 18, 32, 32)
        text(row.title, 66, y, l.right - 144, 27, 18)
        text(row.detail, 66, y + 30, l.right - 144, 42, 14, true)
        text(row.badge, l.right - 66, y + 5, 46, 26, 13)
        rect(row.separator, 22, y + rowHeight - 6, l.right - 44, 1)
    end
    panel(v.settingsPanel, l.rightX, l.settingsY, l.right, l.settingsH)
    for index = 4, 8 do
        local f = require(script.Parent.Theme).Features[index]
        local y = (l.short and 48 or 52) + (index - 4) * 48
        rect(v.settingsPanel:FindFirstChild("Icon_" .. f.icon), 24, y + 9, 26, 26)
        text(v.settingsPanel:FindFirstChild("Label_" .. f.id), 62, y + 7, l.right - 158, 30, 18)
        rect(v.toggles[f.id].root, l.right - 86, y, 64, 48)
    end
    panel(v.userPanel, l.rightX, l.userY, l.right, l.userH)
    rect(v.userPanel.Icon_crown, 22, 16, 30, 30)
    text(v.userPanel.Username, 64, 11, l.right - 80, 26, 18)
    text(v.userPanel.Permission, 64, 37, l.right - 80, 20, 13)
    rect(v.userPanel.Divider, 22, 62, l.right - 44, 1)
    rect(v.userPanel.Icon_gem, 22, 79, 30, 30)
    text(v.userPanel.Quote, 64, 72, l.right - 82, 24, l.short and 13 or 15)
    text(v.userPanel.Quote2, 64, 96, l.right - 82, 24, l.short and 13 or 15)
    text(v.footer, l.centerX, l.height - 24, l.width - l.centerX, 20, 10)
end
return Layout
