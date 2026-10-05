--[[
    UI 库的页面/右栏共用控件。不包含任何游戏 Remote、坐标或自动任务。
    每个控件有自己的清理箱，删除一个控件不必销毁整个窗口。
    创建控件和 Set(value) 默认静默；真实交互或 Set(value, true) 才执行 Callback。
    Callback 返回 false, "原因" 或抛错时回滚值；等待中的回调不会重复进入。
]]
local Cleanup = require(script.Parent.Cleanup)
local Components = require(script.Parent.Components)
local Theme = require(script.Parent.Theme)
local C = Theme.Colors
local TextService = game:GetService("TextService")
local InputService = game:GetService("UserInputService")
local Controls = {}
Controls.__index = Controls
local Control = {}
Control.__index = Control

local function finite(value)
    return type(value) == "number" and value == value and math.abs(value) < math.huge
end
local function rect(object, x, y, w, h)
    object.Position = UDim2.fromOffset(x, y)
    object.Size = UDim2.fromOffset(math.max(1, w), math.max(1, h))
end
local function options(input)
    if type(input) == "string" then return {Title = input} end
    assert(input == nil or type(input) == "table", "控件参数必须是 table")
    return input or {}
end
local function measured(text, width, size, bold)
    if text == "" then return 0 end
    -- 按可用宽度测量换行，不把长标题自动缩小。最终字形仍以 Roblox 实测为准。
    local bounds = TextService:GetTextSize(text, size, bold and Theme.Bold or Theme.Font,
        Vector2.new(math.max(20, width), 100000))
    return math.max(math.ceil(size * 1.4), math.ceil(bounds.Y * 1.4))
end
local function normalizeOptions(values)
    assert(type(values) == "table", "Dropdown.Options 必须是数组")
    local result, seen = {}, {}
    for _, value in ipairs(values) do
        local id, label
        if type(value) == "string" then id, label = value, value
        elseif type(value) == "table" then id, label = value.Id, value.Label or value.Id end
        assert(type(id) == "string" and id ~= "" and type(label) == "string", "下拉选项使用字符串或 {Id, Label}")
        assert(not seen[id], "下拉选项 Id 重复：" .. id)
        seen[id] = true
        table.insert(result, {Id = id, Label = label})
    end
    return result
end

-- Container 可以是一页内容，也可以是右侧设置区；所有控件使用相同接口。
function Controls.new(window, parent, columns)
    return setmetatable({window = window, parent = parent, rows = {}, width = 300,
        columns = columns or 1, dead = false}, Controls)
end
function Controls:IsVisible()
    return not self.dead and self.window.visible and self.window.Screen.Enabled and self.parent.Visible
end

function Controls:Relayout(width)
    if self.dead then return end
    self.width = math.max(100, width or self.width)
    local columns = math.min(self.columns, math.max(1, math.floor((self.width + 12) / 312)))
    local cardWidth = (self.width - (columns - 1) * 12) / columns
    local y, group, tallest = 0, {}, 0
    local function flush()
        if #group == 0 then return end
        for index, row in ipairs(group) do
            row:_Layout((index - 1) * (cardWidth + 12), y, cardWidth, tallest)
        end
        y += tallest + 12
        group, tallest = {}, 0
    end
    for _, row in ipairs(self.rows) do
        if not row.dead and row.visible then
            if row.kind == "Section" or row.kind == "Divider" then
                flush()
                local h = row:_Measure(self.width)
                row:_Layout(0, y, self.width, h)
                y += h + 12
            else
                table.insert(group, row)
                tallest = math.max(tallest, row:_Measure(cardWidth))
                if #group == columns then flush() end
            end
        end
    end
    flush()
    self.parent.CanvasSize = UDim2.fromOffset(0, math.max(0, y))
end

function Controls:_Create(kind, input)
    assert(not self.dead and not self.window.dead, "页面已经销毁")
    local p = options(input)
    assert(p.Callback == nil or type(p.Callback) == "function", "Callback 必须是函数")
    self.window.sequence += 1
    local id = p.Id or ("control_" .. self.window.sequence)
    assert(type(id) == "string" and id ~= "" and not self.window.controls[id], "控件 Id 为空或重复")
    local scope = Cleanup.new()
    local u = Components.new(scope, self.window.motion, self.window.assets)
    local row = setmetatable({container = self, window = self.window, scope = scope, u = u,
        Id = id, kind = kind, title = p.Title or kind, description = p.Description or "",
        enabled = p.Disabled ~= true, visible = p.Visible ~= false, callback = p.Callback,
        dead = false, busy = false, value = nil}, Control)
    assert(type(row.title) == "string" and type(row.description) == "string", "Title / Description 必须是字符串")
    if kind == "Section" or kind == "Divider" then
        row.Root = u:Box(self.parent, id, 0, 0, 300, 40)
    else
        row.Root = u:Panel(self.parent, id, 0, 0, 300, 100, "card")
    end
    row.Root.Visible = row.visible
    row.TitleLabel = u:Text(row.Root, "Title", row.title, 16, 12, 268, 28, 18, C.White, true)
    row.DescriptionLabel = u:Text(row.Root, "Description", row.description, 16, 40, 268, 20, 14, C.Muted)
    for _, label in ipairs({row.TitleLabel, row.DescriptionLabel}) do
        label.TextWrapped = true
        label.TextTruncate = Enum.TextTruncate.None
        label.LineHeight = 1.4
    end
    self.window.controls[id] = row
    table.insert(self.rows, row)
    return row, p
end

function Control:Get() return self.value end
function Control:SetTitle(value)
    if self.dead then return false end
    assert(type(value) == "string", "标题必须是字符串")
    self.title, self.TitleLabel.Text = value, value
    self.container:Relayout()
    return true
end
function Control:SetDescription(value)
    if self.dead then return false end
    assert(type(value) == "string", "说明必须是字符串")
    self.description, self.DescriptionLabel.Text = value, value
    self.container:Relayout()
    return true
end
function Control:SetEnabled(value)
    if self.dead then return false end
    self.enabled = value == true
    if not self.enabled then self.drag = nil; self.open = false end
    self:_Paint()
    self.container:Relayout()
    return true
end
function Control:SetVisible(value)
    if self.dead then return false end
    self.visible, self.Root.Visible = value == true, value == true
    if not self.visible then self.drag = nil; self.open = false end
    self.container:Relayout()
    return true
end

function Control:_Normalize(value)
    if self.kind == "Toggle" then
        assert(type(value) == "boolean", "开关值必须是 boolean")
    elseif self.kind == "Input" then
        if self.numeric then
            value = tonumber(value)
            assert(finite(value), "请输入有限数值")
            if self.minimum then value = math.max(self.minimum, value) end
            if self.maximum then value = math.min(self.maximum, value) end
            if self.integer then value = math.floor(value) end
        else
            assert(type(value) == "string", "输入值必须是字符串")
        end
    elseif self.kind == "Slider" then
        value = tonumber(value)
        assert(finite(value), "滑块值必须是有限数值")
        value = math.clamp(value, self.minimum, self.maximum)
        value = math.clamp(self.minimum + math.floor((value - self.minimum) / self.step + 0.5) * self.step,
            self.minimum, self.maximum)
        value = tonumber(string.format("%.10g", value))
    elseif self.kind == "Dropdown" then
        if value ~= nil then
            local found = false
            for _, item in ipairs(self.values) do if item.Id == value then found = true end end
            assert(found, "下拉值不在当前 Options 中")
        end
    else error("此控件没有可设置的值") end
    return value
end

-- UI 回调可以 yield。忙碌期间拒绝重复提交，销毁后不再写入失效控件。
function Control:Set(value, fireCallback)
    if self.dead or self.busy then return false, "控件已销毁或回调处理中" end
    local ok, normalized = pcall(self._Normalize, self, value)
    if not ok then self.window:Notify({Title = "输入无效", Content = tostring(normalized)}); self:_Paint(); return false end
    if normalized == self.value then self:_Paint(); return true end
    local old = self.value
    self.value = normalized
    self:_Paint()
    if fireCallback and self.callback then
        self.busy = true; self:_Paint()
        local success, accepted, reason = pcall(self.callback, normalized, self)
        self.busy = false
        if self.dead then return false, "控件已销毁" end
        if not success or accepted == false then
            self.value = old
            self.window:Notify({Title = "操作未完成", Content = tostring(success and (reason or "回调拒绝了本次修改") or accepted)})
            self:_Paint()
            return false
        end
        self:_Paint()
    end
    return true
end

function Control:Press()
    if self.kind ~= "Button" or self.dead or self.busy or not self.enabled or not self.visible or not self.container:IsVisible() then return false end
    if not self.callback then return false end
    self.busy = true; self:_Paint()
    local ok, accepted, reason = pcall(self.callback, self)
    self.busy = false
    if self.dead then return false end
    self:_Paint()
    if not ok or accepted == false then
        self.window:Notify({Title = "操作未完成", Content = tostring(ok and (reason or "回调返回 false") or accepted)})
        return false
    end
    return true
end

function Control:_Paint()
    if self.dead then return end
    local enabled = self.enabled and not self.busy
    if self.kind == "Button" then enabled = enabled and self.callback ~= nil end
    self.TitleLabel.TextColor3 = self.enabled and C.White or C.Muted
    if self.toggle then
        self.toggle.Set(self.value == true, enabled)
        -- 通用库的禁用代表调用者禁用，不把它错误解释成游戏“未接入”。
        self.toggle.root.Value.Text = self.busy and "处理中" or (not self.enabled and "禁用" or (self.value and "开启" or "关闭"))
    end
    if self.action then
        self.action.button.Active, self.action.button.Selectable = enabled, enabled
        if self.kind == "Button" then self.action.label.Text = self.busy and "处理中…" or self.buttonText end
    end
    if self.input then
        self.input.TextEditable = enabled
        self.input.Text = self.value == nil and "" or tostring(self.value)
    end
    if self.kind == "Dropdown" then
        local caption = #self.values == 0 and "暂无选项" or self.placeholder
        for _, item in ipairs(self.values) do if item.Id == self.value then caption = item.Label end end
        self.action.label.Text = caption
        self.action.button.Active = enabled and #self.values > 0
        self.action.button.Selectable = self.action.button.Active
        if not enabled then self.open = false end
        self.list.Visible = self.open == true
        for _, item in ipairs(self.optionRows or {}) do item.hit.Active = enabled; item.hit.Selectable = enabled end
    elseif self.kind == "Slider" then
        local value = self.drag and self.drag.value or self.value
        local ratio = (value - self.minimum) / (self.maximum - self.minimum)
        self.fill.Size = UDim2.fromScale(ratio, 1)
        self.knob.Position = UDim2.new(ratio, -7, 0.5, -7)
        self.hit.Active, self.hit.Selectable = enabled, enabled
        self.input.Text = tostring(value)
    end
end

function Control:_Measure(width)
    if self.kind == "Divider" then return 8 end
    local textWidth = math.max(20, width - 32 - (self.kind == "Toggle" and 80 or 0))
    self.titleHeight = measured(self.title, textWidth, 18, true)
    self.descriptionHeight = measured(self.description, textWidth, 14, false)
    self.contentY = 12 + self.titleHeight + (self.descriptionHeight > 0 and 5 + self.descriptionHeight or 0)
    if self.kind == "Section" then return math.max(40, self.contentY + 8) end
    if self.kind == "Toggle" then return math.max(84, self.contentY + 14) end
    if self.kind == "Label" then return self.contentY + 14 end
    local h = self.contentY + 10 + 44 + 14
    if self.kind == "Dropdown" and self.open then
        self.optionsHeight = 0
        for _, item in ipairs(self.optionRows) do
            self.optionsHeight += math.max(42, measured(item.label.Text, width - 64, 16, false) + 16)
        end
        h += math.min(216, self.optionsHeight) + 8
    end
    return h
end

function Control:_Layout(x, y, width, height)
    rect(self.Root, x, y, width, height)
    if self.kind == "Divider" then rect(self.line, 0, 3, width, 1); return end
    if self.kind ~= "Section" then self.u:ResizePanel(self.Root, width, height) end
    local textWidth = width - 32 - (self.kind == "Toggle" and 80 or 0)
    rect(self.TitleLabel, 16, 12, textWidth, self.titleHeight)
    rect(self.DescriptionLabel, 16, 17 + self.titleHeight, textWidth, self.descriptionHeight)
    self.DescriptionLabel.Visible = self.descriptionHeight > 0
    local actionY = self.contentY + 10
    if self.toggle then rect(self.toggle.root, width - 80, (height - 48) / 2, 64, 48) end
    if self.action then
        rect(self.action.root, 16, actionY, width - 32, 44)
        self.u:ResizePanel(self.action.root, width - 32, 44)
        rect(self.action.button, 0, 0, width - 32, 44)
        rect(self.action.label, 12, 0, width - 56, 44)
        self.action.label.TextSize = 16
    end
    if self.input then
        if self.kind == "Slider" then rect(self.input, width - 106, actionY, 90, 40)
        else rect(self.input, 16, actionY, width - 32, 40) end
    end
    if self.kind == "Slider" then
        rect(self.track, 20, actionY + 17, width - 142, 6)
        rect(self.hit, 12, actionY, width - 126, 40)
    elseif self.kind == "Dropdown" then
        local optionY = 0
        for _, item in ipairs(self.optionRows) do
            local rowHeight = math.max(42, measured(item.label.Text, width - 64, 16, false) + 16)
            rect(item.label, 12, optionY, width - 64, rowHeight)
            rect(item.hit, 0, optionY, width - 40, rowHeight)
            optionY += rowHeight
        end
        self.optionsHeight = optionY
        rect(self.list, 16, actionY + 52, width - 32, math.min(216, optionY))
        self.list.CanvasSize = UDim2.fromOffset(0, optionY)
    end
end

function Control:Destroy()
    if self.dead then return end
    self.dead = true; self.drag = nil
    if self.optionScope then self.optionScope:Destroy() end
    self.scope:Destroy()
    -- Cancel 只取消本控件上的现有动画，不干涉其他控件或游戏脚本。
    for _, object in ipairs(self.Root:GetDescendants()) do self.window.motion:Cancel(object) end
    self.window.motion:Cancel(self.Root)
    self.window.assets:UnbindTree(self.Root)
    self.Root:Destroy()
    self.window.controls[self.Id] = nil
    local index = table.find(self.container.rows, self)
    if index then table.remove(self.container.rows, index) end
    self.container:Relayout()
end

function Controls:Toggle(input)
    local p = options(input)
    assert(p.Default == nil or type(p.Default) == "boolean", "Toggle.Default 必须是 boolean")
    local row = self:_Create("Toggle", p)
    row.toggle = row.u:Toggle(row.Root, "Toggle", 220, 20, function()
        if row.enabled and not row.busy and row.visible and row.container:IsVisible() then row:Set(not row.value, true) end
    end)
    row.value = p.Default == true
    row:_Paint(); self:Relayout(); return row
end

function Controls:Button(input)
    local p = options(input)
    assert(p.ButtonText == nil or type(p.ButtonText) == "string", "ButtonText 必须是字符串")
    local row = self:_Create("Button", p)
    row.buttonText = p.ButtonText or "执行"
    row.action = row.u:Button(row.Root, "Action", row.buttonText, 16, 60, 268, 44, function() row:Press() end, p.Primary == true)
    row:_Paint(); self:Relayout(); return row
end

local function inputBox(row, placeholder)
    local box = row.u:Make("TextBox", row.Root, "Input", {
        BackgroundColor3 = C.Black, BorderSizePixel = 0, TextColor3 = C.White,
        PlaceholderColor3 = C.Muted, PlaceholderText = placeholder or "请输入",
        Font = Theme.Font, TextSize = 16, ClearTextOnFocus = false, MultiLine = false,
        TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 6,
    })
    row.u:Make("UIPadding", box, "Padding", {PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10)})
    row.u:Make("UIStroke", box, "Border", {Color = C.Border, Thickness = 1})
    row.scope:Connect(box.FocusLost, function()
        if row.enabled and not row.busy and row.visible and row.container:IsVisible() then row:Set(box.Text, true) else row:_Paint() end
    end)
    return box
end
function Controls:Input(input)
    local p = table.clone(options(input))
    assert(p.Min == nil or finite(p.Min), "Min 必须为有限数值")
    assert(p.Max == nil or finite(p.Max), "Max 必须为有限数值")
    assert(not (p.Min and p.Max) or p.Min <= p.Max, "Min 不能大于 Max")
    if p.Numeric and p.Integer then
        if p.Min then p.Min = math.ceil(p.Min) end
        if p.Max then p.Max = math.floor(p.Max) end
        assert(not (p.Min and p.Max) or p.Min <= p.Max, "范围中没有可用整数")
    end
    if p.Default ~= nil then
        assert(p.Numeric and finite(tonumber(p.Default)) or (not p.Numeric and type(p.Default) == "string"), "Input.Default 类型不正确")
    end
    local row = self:_Create("Input", p)
    row.numeric, row.integer, row.minimum, row.maximum = p.Numeric == true, p.Integer == true, p.Min, p.Max
    row.input = inputBox(row, p.Placeholder)
    row.value = row:_Normalize(p.Default == nil and (row.numeric and 0 or "") or p.Default)
    row:_Paint(); self:Relayout(); return row
end

function Control:SetOptions(values, fireCallback)
    assert(self.kind == "Dropdown", "SetOptions 只用于下拉框")
    if self.dead or self.busy then return false end
    local normalized = normalizeOptions(values)
    local oldValues, oldValue = self.values, self.value
    self.values = normalized
    local retained = false
    for _, item in ipairs(normalized) do if item.Id == self.value then retained = true end end
    if not retained and not self:Set(nil, fireCallback) then
        self.values, self.value = oldValues, oldValue
        self:_Paint(); return false
    end
    if self.optionScope then self.optionScope:Destroy() end
    self.optionScope, self.optionRows = Cleanup.new(), {}
    for _, child in ipairs(self.list:GetDescendants()) do self.window.motion:Cancel(child) end
    for _, child in ipairs(self.list:GetChildren()) do child:Destroy() end
    local u = Components.new(self.optionScope, self.window.motion, self.window.assets)
    for index, item in ipairs(normalized) do
        local label = u:Text(self.list, "OptionLabel_" .. index, item.Label, 12, 0, 240, 42, 16, C.White)
        label.TextWrapped, label.TextTruncate, label.LineHeight = true, Enum.TextTruncate.None, 1.4
        local hit = u:Interact(self.list, "Option_" .. index, 0, 0, 260, 42, function()
            if self.dead or not self.enabled or self.busy or not self.visible or not self.open or not self.container:IsVisible() then return end
            self.open = false; self.list.Visible = false
            self:Set(item.Id, true)
            self.container:Relayout()
        end)
        table.insert(self.optionRows, {label = label, hit = hit})
    end
    self.open = false; self:_Paint(); self.container:Relayout(); return true
end
function Controls:Dropdown(input)
    local p = options(input)
    local values = normalizeOptions(p.Options or {})
    if p.Default ~= nil then
        local found = false
        for _, item in ipairs(values) do if item.Id == p.Default then found = true end end
        assert(found, "Dropdown.Default 不在 Options 内")
    end
    local row = self:_Create("Dropdown", p)
    row.values, row.optionRows, row.placeholder = {}, {}, p.Placeholder or "请选择"
    row.list = row.u:Make("ScrollingFrame", row.Root, "Options", {
        BackgroundColor3 = C.Black, BorderSizePixel = 0, Visible = false,
        ScrollBarThickness = 4, ScrollBarImageColor3 = C.Light, ClipsDescendants = true,
        ScrollingDirection = Enum.ScrollingDirection.Y, CanvasSize = UDim2.fromOffset(0, 0),
    })
    row.action = row.u:Button(row.Root, "Selection", "请选择", 16, 60, 268, 44, function()
        if not row.enabled or row.busy or #row.values == 0 or not row.container:IsVisible() then return end
        row.open = not row.open; row:_Paint()
        -- 展开菜单只占自己的卡片，不覆盖下一行；换行后的选项高度也参与测量。
        row.container:Relayout()
    end)
    row:SetOptions(values); row:Set(p.Default); self:Relayout(); return row
end

function Controls:Slider(input)
    local p = options(input)
    local minimum, maximum, step = p.Min or 0, p.Max or 100, p.Step or 1
    assert(finite(minimum) and finite(maximum) and maximum > minimum, "Slider 需要 Min < Max")
    assert(finite(step) and step > 0, "Step 必须大于 0")
    assert(p.Default == nil or finite(tonumber(p.Default)), "Slider.Default 必须是有限数值")
    local row = self:_Create("Slider", p)
    row.minimum, row.maximum, row.step = minimum, maximum, step
    row.value = row:_Normalize(p.Default or minimum)
    row.input = inputBox(row, "数值")
    row.track = row.u:Line(row.Root, "Track", 20, 77, 150, 6, C.Dim)
    row.fill = row.u:Line(row.track, "Fill", 0, 0, 1, 6, C.Pink)
    row.knob = row.u:Line(row.track, "Knob", 0, 0, 14, 14, C.White)
    row.u:Make("UICorner", row.knob, "Round", {CornerRadius = UDim.new(1, 0)})
    row.hit = row.u:Interact(row.Root, "SliderHit", 12, 60, 170, 40, function() end)
    local function point(event)
        local width = row.track.AbsoluteSize.X
        if width <= 0 then return row.value end
        local ratio = math.clamp((event.Position.X - row.track.AbsolutePosition.X) / width, 0, 1)
        return row:_Normalize(minimum + ratio * (maximum - minimum))
    end
    row.scope:Connect(row.hit.InputBegan, function(event)
        if not row.enabled or row.busy or not row.visible or not row.container:IsVisible() then return end
        if event.UserInputType == Enum.UserInputType.MouseButton1 or event.UserInputType == Enum.UserInputType.Touch then
            row.drag = {input = event, value = point(event)}; row:_Paint()
        end
    end)
    row.scope:Connect(InputService.InputChanged, function(event)
        if row.drag and not row.container:IsVisible() then row.drag = nil; row:_Paint(); return end
        if row.drag and (event == row.drag.input or (row.drag.input.UserInputType == Enum.UserInputType.MouseButton1
            and event.UserInputType == Enum.UserInputType.MouseMovement)) then
            row.drag.value = point(event); row:_Paint()
        end
    end)
    row.scope:Connect(InputService.InputEnded, function(event)
        if row.drag and not row.container:IsVisible() then row.drag = nil; row:_Paint(); return end
        if row.drag and (event == row.drag.input or (row.drag.input.UserInputType == Enum.UserInputType.MouseButton1
            and event.UserInputType == Enum.UserInputType.MouseButton1)) then
            local value = row.drag.value; row.drag = nil; row:Set(value, true)
        end
    end)
    row.scope:Connect(InputService.InputBegan, function(event, processed)
        if processed or not row.enabled or row.busy or not row.visible or not row.container:IsVisible()
            or InputService:GetFocusedTextBox() or game:GetService("GuiService").SelectedObject ~= row.hit then return end
        if event.KeyCode == Enum.KeyCode.Left then row:Set(row.value - step, true)
        elseif event.KeyCode == Enum.KeyCode.Right then row:Set(row.value + step, true)
        elseif event.KeyCode == Enum.KeyCode.Home then row:Set(minimum, true)
        elseif event.KeyCode == Enum.KeyCode.End then row:Set(maximum, true) end
    end)
    row:_Paint(); self:Relayout(); return row
end

function Controls:Label(input)
    local row = self:_Create("Label", input); self:Relayout(); return row
end
function Controls:Section(input)
    local row = self:_Create("Section", input); self:Relayout(); return row
end
function Controls:Divider()
    local row = self:_Create("Divider", {Title = ""})
    row.TitleLabel.Visible, row.DescriptionLabel.Visible = false, false
    row.line = row.u:Line(row.Root, "DividerLine", 0, 3, 300, 1, C.Border)
    self:Relayout(); return row
end
function Controls:Destroy()
    if self.dead then return end
    self.dead = true
    for _, row in ipairs(table.clone(self.rows)) do row:Destroy() end
    table.clear(self.rows)
end
return Controls
