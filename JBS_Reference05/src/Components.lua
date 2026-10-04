--[[
    原生控件工厂：把重复的 Frame、TextLabel、TextButton 封装成易读方法。
    Box = 透明容器；Text = 文字；Panel = 金属边框；Button = 按钮；Toggle = 开关。
    布局参数依次是 x、y、宽、高；所有事件交给 scope 管理，销毁窗口时统一断开。
]]
local Theme = require(script.Parent.Theme)
local Assets = require(script.Parent.Assets)
local C = Theme.Colors
local UI = {}
UI.__index = UI
-- 工厂只使用传入的清理箱、动画器和资源表，不建立额外全局状态。
function UI.new(scope, motion, assets)
    return setmetatable({ scope = scope, motion = motion, assets = assets, buttons = 0 }, UI)
end
-- 统一创建 Instance 并赋值属性，最后挂到父节点。
function UI:Make(class, parent, name, properties)
    local object = Instance.new(class)
    object.Name = name
    for key, value in pairs(properties or {}) do
        object[key] = value
    end
    object.Parent = parent
    return object
end
-- 建立透明 Frame 容器，方便把一组控件一起移动或隐藏。
function UI:Box(parent, name, x, y, w, h)
    return self:Make("Frame", parent, name, {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = UDim2.fromOffset(x, y),
        Size = UDim2.fromOffset(w, h),
    })
end
-- 建立可读的原生文字；过长时截断，避免覆盖旁边控件。
function UI:Text(parent, name, text, x, y, w, h, size, color, bold)
    return self:Make("TextLabel", parent, name, {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = UDim2.fromOffset(x, y),
        Size = UDim2.fromOffset(w, h),
        Text = text,
        TextColor3 = color or C.White,
        Font = bold and Theme.Bold or Theme.Font,
        TextSize = size or 20,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center,
        TextTruncate = Enum.TextTruncate.AtEnd,
        ZIndex = 5,
    })
end
-- 用细 Frame 画分隔线、倒角边和高光。
function UI:Line(parent, name, x, y, w, h, color, rotation)
    return self:Make("Frame", parent, name, {
        BorderSizePixel = 0,
        BackgroundColor3 = color,
        Position = UDim2.fromOffset(x, y),
        Size = UDim2.fromOffset(w, h),
        Rotation = rotation or 0,
        ZIndex = 3,
    })
end
-- 金属面板由原生底色与八块边框裁片组成；不是整图覆盖按钮。
function UI:Panel(parent, name, x, y, w, h, kind)
    local panel = self:Box(parent, name, x, y, w, h)
    panel:SetAttribute("JBSPanelKind", kind or "panel")
    local cut = kind == "card" and 10 or 16
    -- 固定倒角组成八边形底板；边框裁片单独拉伸，文字与按钮保持原生。
    local body = self:Box(panel, "Body", 0, 0, w, h)
    body.ClipsDescendants = true
    local horizontal = self:Line(body, "FillH", cut, 0, w - 2 * cut, h, C.Panel)
    local vertical = self:Line(body, "FillV", 0, cut, w, h - 2 * cut, C.Panel)
    for _, p in ipairs({ { cut, cut }, { w - cut, cut }, { cut, h - cut }, { w - cut, h - cut } }) do
        local side = cut * math.sqrt(2)
        self:Line(body, "CutFacet", p[1] - side / 2, p[2] - side / 2, side, side, C.Panel, 45)
    end
    for _, fill in ipairs({ horizontal, vertical }) do
        self:Make("UIGradient", fill, "MetalShade", {
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromHex("3C103D")),
                ColorSequenceKeypoint.new(0.35, C.Panel),
                ColorSequenceKeypoint.new(1, C.Black),
            }),
            Rotation = 90,
        })
    end
    local border = self:Box(panel, "FallbackEdge", 0, 0, w, h)
    for _, e in ipairs({
        { cut, 1, w - 2 * cut, 2, 0 },
        { cut, h - 3, w - 2 * cut, 2, 0 },
        { 1, cut, 2, h - 2 * cut, 0 },
        { w - 3, cut, 2, h - 2 * cut, 0 },
        { 1, cut / 2, cut * 1.414, 2, -45 },
        { w - cut - 3, cut / 2, cut * 1.414, 2, 45 },
        { 1, h - cut / 2 - 2, cut * 1.414, 2, 45 },
        { w - cut - 3, h - cut / 2 - 2, cut * 1.414, 2, -45 },
    }) do
        self:Line(border, "Edge", e[1], e[2], e[3], e[4], C.Border, e[5])
    end
    self:Line(border, "Specular", cut + 4, 2, math.min(120, w * 0.3), 2, C.Light)
    self:Line(border, "Laser", w - math.min(80, w * 0.2) - cut, h - 4, math.min(80, w * 0.2), 2, C.Pink)
    local meta = Assets.Meta.frame_atlas.patches[kind or "panel"]
    local r = meta.rect
    local b = meta.border
    local xs = { 0, b, r[3] - b }
    local ys = { 0, b, r[4] - b }
    local sw = { b, r[3] - 2 * b, b }
    local sh = { b, r[4] - 2 * b, b }
    local dx = { 0, b, w - b }
    local dy = { 0, b, h - b }
    local dw = { b, w - 2 * b, b }
    local dh = { b, h - 2 * b, b }
    for row = 1, 3 do
        for col = 1, 3 do
            if not (row == 2 and col == 2) then
                local image = self:Make("ImageLabel", panel, "MetalPatch", {
                    BackgroundTransparency = 1,
                    Position = UDim2.fromOffset(dx[col], dy[row]),
                    Size = UDim2.fromOffset(dw[col], dh[row]),
                    ZIndex = 4,
                })
                self.assets:Bind(image, "frame_atlas", { r[1] + xs[col], r[2] + ys[row], sw[col], sh[row] })
            end
        end
    end
    return panel
end
-- 摆放装饰图片；是否可见由资源加载状态决定。
function UI:Art(parent, name, key, x, y, w, h)
    local image = self:Make("ImageLabel", parent, name, {
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(x, y),
        Size = UDim2.fromOffset(w, h),
        ScaleType = Enum.ScaleType.Fit,
        ZIndex = 4,
    })
    self.assets:Bind(image, key)
    return image
end
-- 从同一图集读取图标，减少独立图片资源数量。
function UI:Icon(parent, key, x, y, size)
    local image = self:Make("ImageLabel", parent, "Icon_" .. key, {
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(x, y),
        Size = UDim2.fromOffset(size, size),
        ScaleType = Enum.ScaleType.Fit,
        ImageColor3 = C.Light,
        ZIndex = 5,
    })
    self.assets:Bind(image, "icon_atlas", Assets.Meta.icon_atlas.rects[key])
    return image
end
-- 建立真正可点击和键盘可聚焦的按钮，统一提供悬停与焦点反馈。
function UI:Interact(parent, name, x, y, w, h, callback)
    self.buttons += 1
    local button = self:Make("TextButton", parent, name, {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Text = "",
        AutoButtonColor = false,
        Position = UDim2.fromOffset(x, y),
        Size = UDim2.fromOffset(w, h),
        Selectable = true,
        Active = true,
        ZIndex = 8,
    })
    local focus = self:Make(
        "UIStroke",
        button,
        "KeyboardFocus",
        { Color = C.White, Thickness = 2, Transparency = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }
    )
    self.scope:Connect(button.SelectionGained, function()
        self.motion:To(focus, 0.1, { Transparency = 0 })
    end)
    self.scope:Connect(button.SelectionLost, function()
        self.motion:To(focus, 0.1, { Transparency = 1 })
    end)
    self.scope:Connect(button.MouseEnter, function()
        if button.Active then
            focus.Color = C.Light
            self.motion:To(focus, 0.12, { Transparency = 0.2 })
        end
    end)
    self.scope:Connect(button.MouseLeave, function()
        focus.Color = C.White
        self.motion:To(
            focus,
            0.12,
            { Transparency = game:GetService("GuiService").SelectedObject == button and 0 or 1 }
        )
    end)
    self.scope:Connect(button.Activated, function()
        if button.Active then
            callback()
        end
    end)
    return button
end
-- 把金属外框、文字、真实按钮组合在一起，返回可更新的引用。
function UI:Button(parent, name, text, x, y, w, h, callback, primary)
    local panel = self:Panel(parent, name, x, y, w, h, primary and "primary" or "card")
    if primary then
        local glow = self:Line(panel, "PrimaryFace", 14, 14, w - 28, h - 28, C.Pink)
        self:Make(
            "UIGradient",
            glow,
            "PrimaryGradient",
            { Rotation = 90, Color = ColorSequence.new(C.Pink, Color3.fromHex("820451")) }
        )
    end
    local label = self:Text(panel, "Caption", text, 14, 0, w - 28, h, 26, C.White, true)
    label.TextXAlignment = Enum.TextXAlignment.Center
    local button = self:Interact(panel, name .. "Action", 0, 0, w, h, callback)
    return { root = panel, button = button, label = label }
end
-- 只创建一次开关；Set(value,enabled) 更新位置、颜色和可操作状态。
function UI:Toggle(parent, name, x, y, callback, compact)
    -- 状态只有这一个固定位置：轨道下方。compact 不再把文字塞进滑块。
    local root = self:Box(parent, name, x, y, 64, 48)
    local track = self:Make("Frame", root, "Track", {
        BorderSizePixel = 0,
        BackgroundColor3 = C.Dim,
        Position = UDim2.fromOffset(5, 0),
        Size = UDim2.fromOffset(54, 26),
        ZIndex = 5,
    })
    self:Make("UICorner", track, "Pill", { CornerRadius = UDim.new(1, 0) })
    local knob = self:Make("Frame", track, "Knob", {
        BorderSizePixel = 0,
        BackgroundColor3 = C.White,
        Position = UDim2.fromOffset(3, 3),
        Size = UDim2.fromOffset(20, 20),
        ZIndex = 6,
    })
    self:Make("UICorner", knob, "Pill", { CornerRadius = UDim.new(1, 0) })
    local label = self:Text(root, "Value", "关闭", 0, 29, 64, 19, 13, C.Muted)
    label.TextXAlignment = Enum.TextXAlignment.Center
    local button = self:Interact(root, name .. "Action", 0, 0, 64, 48, callback)
    local last, previousEnabled = nil, nil
    return {
        root = root,
        button = button,
        Set = function(value, enabled)
            if value == last and enabled == previousEnabled then
                return
            end
            last = value
            previousEnabled = enabled
            button.Active = enabled
            button.Selectable = enabled
            label.Text = enabled and (value and "开启" or "关闭") or "未接入"
            self.motion:To(
                knob,
                Theme.Motion.Toggle,
                { Position = UDim2.fromOffset(value and enabled and 31 or 3, 3) }
            )
            self.motion:To(
                track,
                Theme.Motion.Toggle,
                { BackgroundColor3 = enabled and value and C.Pink or C.Dim }
            )
        end,
    }
end
-- 模块标题只保留中文；品牌英文仍在顶栏和 JBS 素材中。
function UI:Heading(parent, title, english, icon)
    self:Icon(parent, icon, 17, 10, 28)
    self:Text(parent, "Heading", title, 56, 5, 240, 38, 20, C.White, true)
    if english then
        self:Text(parent, "English", english, 180, 16, 390, 28, 18, C.Muted)
    end
end
-- 面板在窄窗中改变尺寸时，保留原切角及图集边框，不缩放里面的字体。
function UI:ResizePanel(panel, w, h)
    panel.Size = UDim2.fromOffset(w, h)
    local kind = panel:GetAttribute("JBSPanelKind") or "panel"
    local cut = kind == "card" and 10 or 16
    local function rect(object, x, y, width, height)
        object.Position = UDim2.fromOffset(x, y)
        object.Size = UDim2.fromOffset(math.max(1, width), math.max(1, height))
    end
    local body = panel:FindFirstChild("Body")
    if not body then
        return
    end
    rect(body, 0, 0, w, h)
    rect(body.FillH, cut, 0, w - 2 * cut, h)
    rect(body.FillV, 0, cut, w, h - 2 * cut)
    local corners = { { cut, cut }, { w - cut, cut }, { cut, h - cut }, { w - cut, h - cut } }
    local index = 0
    for _, child in ipairs(body:GetChildren()) do
        if child.Name == "CutFacet" then
            index += 1
            local point = corners[index]
            local side = cut * math.sqrt(2)
            rect(child, point[1] - side / 2, point[2] - side / 2, side, side)
        end
    end
    local edge = panel.FallbackEdge
    rect(edge, 0, 0, w, h)
    local edges = {
        { cut, 1, w - 2 * cut, 2 },
        { cut, h - 3, w - 2 * cut, 2 },
        { 1, cut, 2, h - 2 * cut },
        { w - 3, cut, 2, h - 2 * cut },
        { 1, cut / 2, cut * 1.414, 2 },
        { w - cut - 3, cut / 2, cut * 1.414, 2 },
        { 1, h - cut / 2 - 2, cut * 1.414, 2 },
        { w - cut - 3, h - cut / 2 - 2, cut * 1.414, 2 },
    }
    index = 0
    for _, child in ipairs(edge:GetChildren()) do
        if child.Name == "Edge" then
            index += 1
            local r = edges[index]
            rect(child, r[1], r[2], r[3], r[4])
        end
    end
    rect(edge.Specular, cut + 4, 2, math.min(120, w * 0.3), 2)
    rect(edge.Laser, w - math.min(80, w * 0.2) - cut, h - 4, math.min(80, w * 0.2), 2)
    local b = Assets.Meta.frame_atlas.patches[kind].border
    local dx, dy = { 0, b, w - b }, { 0, b, h - b }
    local dw, dh = { b, w - 2 * b, b }, { b, h - 2 * b, b }
    local pieces = {}
    for _, child in ipairs(panel:GetChildren()) do
        if child.Name == "MetalPatch" then
            table.insert(pieces, child)
        end
    end
    index = 0
    for row = 1, 3 do
        for col = 1, 3 do
            if not (row == 2 and col == 2) then
                index += 1
                rect(pieces[index], dx[col], dy[row], dw[col], dh[row])
            end
        end
    end
    local primary = panel:FindFirstChild("PrimaryFace")
    if primary then
        rect(primary, 14, 14, w - 28, h - 28)
    end
end
return UI
