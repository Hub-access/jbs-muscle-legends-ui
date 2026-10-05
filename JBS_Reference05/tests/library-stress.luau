-- Runs actual library code against the offline engine double. Never native render evidence.
local passed = 0
local function check(value, message) assert(value, message); passed += 1 end
-- Text measurement here only exercises layout decisions, not Roblox font rasterization.
services.TextService = {GetTextSize = function(_, text, size, _, bounds)
    return Vector2.new(math.min(bounds.X, #text * size * 0.55), math.ceil(math.max(1, #text * size * 0.55 / bounds.X)) * size)
end}
local Library = Modules.Library
local baseline, baselineConnections = instanceCount(), activeConnections()
check(not playerGui:FindFirstChild("JBS_UI"), "requiring library must create no GUI")
local window, created = Library:CreateWindow({Id = "LibTest", AvatarPreview = false, ReducedMotion = true, Hotkey = Enum.KeyCode.RightShift})
check(created and window and window.Screen.Parent == playerGui, "explicit create")
local home = window:Tab({Id = "home", Title = "主要", Columns = 3})
local other = window:Tab({Id = "other", Title = "其他"})
local toggleCalls, buttonCalls, inputCalls, dropCalls, sliderCalls = 0, 0, 0, 0, 0
local toggle = home:Toggle({Id = "toggle", Title = "自动锻炼", Default = false, Callback = function(value)
    check(type(value) == "boolean", "toggle callback value type"); toggleCalls += 1
end})
local button = home:Button({Id = "button", Title = "按钮", Callback = function() buttonCalls += 1 end})
local input = home:Input({Id = "input", Title = "目标次数", Numeric = true, Integer = true, Min = 0, Default = 0,
    Callback = function() inputCalls += 1 end})
local drop = home:Dropdown({Id = "drop", Title = "地点", Options = {{Id = "a", Label = "大厅"}, {Id = "b", Label = "小岛"}},
    Default = "a", Callback = function() dropCalls += 1 end})
local slider = home:Slider({Id = "slider", Title = "数值", Min = 10, Max = 30, Step = 2, Default = 12,
    Callback = function() sliderCalls += 1 end})
home:Section("分组"); home:Divider(); home:Label({Title = "说明", Description = "真正的中文说明"})
window:Sidebar():Toggle({Id = "right", Title = "右栏开关"})
check(toggleCalls + buttonCalls + inputCalls + dropCalls + sliderCalls == 0, "construction never calls callbacks")
check(window:GetControl("drop") == drop and window:GetValues().slider == 12, "registry and snapshot")
local count = instanceCount()
local same, reused = Library:CreateWindow({Id = "LibTest", AvatarPreview = false})
check(same == window and reused == false and instanceCount() == count, "duplicate returns existing window")
check(not pcall(function() window:Tab({Id = "home"}) end), "duplicate tab rejected")
check(not pcall(function() home:Button({Id = "toggle"}) end), "duplicate control rejected")

toggle.toggle.button.Activated:Fire()
check(toggle:Get() == true and toggleCalls == 1, "actual toggle click")
toggle:Set(false)
check(not toggle:Get() and toggleCalls == 1, "programmatic update is silent")
toggle:Set(true, true); toggle:Set(true, true)
check(toggleCalls == 2, "same value does not fire twice")
toggle:SetEnabled(false); toggle.toggle.button.Activated:Fire()
check(toggle:Get() and toggleCalls == 2 and toggle.toggle.root.Value.Text == "禁用", "disabled toggle")
toggle:SetEnabled(true)
button.action.button.Activated:Fire()
check(buttonCalls == 1, "actual button click")
button:SetVisible(false); check(not button:Press() and buttonCalls == 1, "hidden button does not run")
button:SetVisible(true)
input.input.Text = "12.7"; input.input.FocusLost:Fire()
check(input:Get() == 12 and inputCalls == 1 and input.input.Text == "12", "numeric input commit")
input.input.Text = "nan text"; input.input.FocusLost:Fire()
check(input:Get() == 12 and inputCalls == 1 and input.input.Text == "12", "invalid input restores text")
input:Set(-20, true); check(input:Get() == 0, "numeric clamp")
check(not slider:Set(0/0) and slider:Get() == 12, "NaN rejected")

drop.action.button.Activated:Fire()
check(drop.list.Visible, "dropdown opens")
drop.optionRows[2].hit.Activated:Fire()
check(drop:Get() == "b" and dropCalls == 1 and not drop.list.Visible, "dropdown choice")
check(not drop:Set("unknown") and drop:Get() == "b", "unknown dropdown id rejected")
local initialInstances, initialConnections = instanceCount(), activeConnections()
local initialSubscribers = #window.assets.subscribers
for _ = 1, 60 do drop:SetOptions({{Id = "a", Label = "大厅"}, {Id = "b", Label = "小岛"}}) end
check(instanceCount() == initialInstances and activeConnections() == initialConnections, "dropdown refresh does not grow instances or connections")
check(#window.assets.subscribers == initialSubscribers, "dropdown refresh does not grow asset subscriptions")
drop:SetOptions({"c"})
check(drop:Get() == nil and dropCalls == 1, "removed selection clears silently")
drop:SetOptions({}); check(not drop.action.button.Active and not drop.open, "empty dropdown disabled")
drop:SetOptions({"a", "b"}); drop:Set("a")

-- Pointer input is normalized against the track; it commits once on release.
slider.track.AbsoluteSize, slider.track.AbsolutePosition = Vector2.new(200, 6), Vector2.new(100, 0)
local mouse = {UserInputType = Enum.UserInputType.MouseButton1, Position = Vector2.new(140, 0)}
slider.hit.InputBegan:Fire(mouse)
UserInputService.InputChanged:Fire({UserInputType = Enum.UserInputType.MouseMovement, Position = Vector2.new(250, 0)})
check(sliderCalls == 0, "slider preview does not spam business callback")
UserInputService.InputEnded:Fire(mouse)
check(slider:Get() == 26 and sliderCalls == 1, "mouse slider release snaps to step")
local touch = {UserInputType = Enum.UserInputType.Touch, Position = Vector2.new(300, 0)}
slider.hit.InputBegan:Fire(touch); UserInputService.InputEnded:Fire(touch)
check(slider:Get() == 30 and sliderCalls == 2, "touch slider release")
GuiService.SelectedObject = slider.hit
UserInputService.InputBegan:Fire({KeyCode = Enum.KeyCode.Left}, false)
check(slider:Get() == 28 and sliderCalls == 3, "keyboard slider")
window:SelectTab("other")
UserInputService.InputBegan:Fire({KeyCode = Enum.KeyCode.Left}, false)
check(slider:Get() == 28 and sliderCalls == 3, "hidden tab ignores global keyboard handler")
window:SelectTab("home"); GuiService.SelectedObject = nil
slider.hit.InputBegan:Fire(touch)
window:Hide(); window:Show()
check(not slider.drag and slider.input.Text == tostring(slider:Get()), "hide discards uncommitted slider preview")
slider.hit.InputBegan:Fire(touch); window.Screen.Enabled = false
UserInputService.InputEnded:Fire(touch)
check(slider:Get() == 28 and sliderCalls == 3, "externally disabled ScreenGui cancels pointer commit")
window.Screen.Enabled = true

local rejected = home:Toggle({Id = "reject", Title = "拒绝", Callback = function() return false, "拒绝原因" end})
check(not rejected:Set(true, true) and not rejected:Get(), "callback false rolls back")
check(window.banner.Text:find("拒绝原因") ~= nil, "callback reason is shown")
local errored = home:Toggle({Id = "error", Title = "异常", Callback = function() error("injected callback error") end})
check(not errored:Set(true, true) and not errored:Get(), "callback exception rolls back")
rejected:Destroy(); errored:Destroy()

local waiting, enters = nil, 0
local slow = home:Toggle({Id = "slow", Title = "异步", Callback = function()
    enters += 1; waiting = coroutine.running(); coroutine.yield()
end})
task.spawn(function() slow:Set(true, true) end)
check(slow.busy and not slow:Set(false, true) and enters == 1, "yielded callback has reentry guard")
check(coroutine.resume(waiting), "resume live callback")
check(not slow.busy and slow:Get(), "yielded callback completes")
task.spawn(function() slow:Set(false, true) end)
slow:Destroy()
check(coroutine.resume(waiting), "callback return after control destruction is safe")
check(not window:GetControl("slow"), "destroy removes registry entry")

local actions = 0
window:SetActions({Start = function(values) check(values.input == 0, "start receives values"); actions += 1 end,
    Stop = function() actions += 1 end})
window.start.button.Activated:Fire(); window.stop.button.Activated:Fire()
check(actions == 2, "start and stop actual buttons")
window:SetActions({}); window.start.button.Activated:Fire()
check(actions == 2 and not window.start.button.Active, "missing callback disabled")
window:Hide(); check(not window.viewport.Visible and window.restore.root.Visible, "hide")
window.restore.button.Activated:Fire(); check(window.visible and window.viewport.Visible, "restore")
UserInputService.InputBegan:Fire({KeyCode = Enum.KeyCode.RightShift}, false)
check(not window.visible, "hotkey hide")
UserInputService.InputBegan:Fire({KeyCode = Enum.KeyCode.RightShift}, false)
check(window.visible, "hotkey restore")

-- Constructor rejection must not strand partial controls in the window.
initialInstances, initialConnections = instanceCount(), activeConnections()
for _, make in ipairs({
    function() home:Toggle({Default = "bad"}) end,
    function() home:Input({Numeric = true, Default = "bad"}) end,
    function() home:Slider({Default = "bad"}) end,
    function() home:Dropdown({Options = {"a", "a"}}) end,
}) do check(not pcall(make), "bad constructor rejected") end
check(instanceCount() == initialInstances and activeConnections() == initialConnections, "bad arguments leave no controls")

initialSubscribers = #window.assets.subscribers
for i = 1, 40 do
    local tab = window:Tab({Id = "temporary", Title = "临时页"})
    tab:Toggle({Title = "临时开关"}); tab:Destroy()
end
check(instanceCount() == initialInstances and activeConnections() == initialConnections, "tab removal releases nav and controls")
check(#window.assets.subscribers == initialSubscribers, "tab removal releases assets")
local staleTab = window:Tab({Id = "stale", Title = "旧引用"}); staleTab:Destroy()
local replacement = window:Tab({Id = "stale", Title = "新实例"}); staleTab:Destroy()
check(window.tabs.stale == replacement, "stale tab reference cannot destroy a replacement")
replacement:Destroy()
local autoA, autoB = window:Tab("自动编号A"), window:Tab("自动编号B")
autoA:Destroy()
local autoC = window:Tab("自动编号C")
check(autoB.Id ~= autoC.Id, "auto tab ids remain unique after deletion")
autoB:Destroy(); autoC:Destroy()

for _, dimensions in ipairs({{1920,1080},{1280,720},{800,700},{390,844}}) do
    window.viewport.AbsoluteSize = Vector2.new(dimensions[1], dimensions[2]); window:Resize()
    check(window.root.Size.X.Offset <= dimensions[1], "window fits width")
    check(window.pageHost.Size.X.Offset > 0 and window.pageHost.Size.Y.Offset > 0, "usable content bounds")
    for _, row in ipairs(home.rows) do
        check(row.Root.Size.X.Offset > 0 and row.Root.Size.Y.Offset > 0, "positive control dimensions")
        if row.action then check(row.action.root.Position.Y.Offset >= row.contentY, "action below text") end
    end
end
local cleaned = 0
window:OnDestroy(function() cleaned += 1 end)
window.Screen:Destroy(); window:Destroy()
check(cleaned == 1 and window.dead, "external ScreenGui destruction cleans once")
check(activeConnections() == baselineConnections and instanceCount() == baseline, "whole window no instances/connections left")
for _ = 1, 15 do
    local w = Library:CreateWindow({Id = "repeat", AvatarPreview = false, ReducedMotion = true})
    w:Tab({Title = "测试"}):Dropdown({Options = {"a", "b"}})
    w:Destroy()
end
check(activeConnections() == baselineConnections and instanceCount() == baseline, "15 rebuilds are bounded")
check(not pcall(function() Library:CreateWindow({Id = "bad", AvatarPreview = false, OnStart = 12}) end), "failed window construction")
check(activeConnections() == baselineConnections and instanceCount() == baseline, "failed window construction cleans")

-- Current-character integration uses the existing dual-avatar manager, with no account image mock.
local character = Instance.new("Model"); character.Name = "LibraryAvatarFixture"; character.Parent = player
local humanoid = Instance.new("Humanoid"); humanoid.Parent = character
local root = Instance.new("Part"); root.Name = "HumanoidRootPart"; root.Parent = character
local torso = Instance.new("Part"); torso.Name = "Torso"; torso.Size = Vector3.new(4,4,2); torso.Parent = character
local head = Instance.new("Part"); head.Name = "Head"; head.Parent = character
for _, pair in ipairs({{root,torso,Vector3.zero},{torso,head,Vector3.new(0,3,0)}}) do
    local motor = Instance.new("Motor6D"); motor.Part0 = pair[1]; motor.Part1 = pair[2]; motor.C0 = CFrame.new(pair[3]); motor.Parent = character
end
player.Character = character
window = Library:CreateWindow({Id = "avatars", ReducedMotion = true})
window:Tab("主要")
advance(2)
local front, back = window.heroAvatar.views.front.current, window.heroAvatar.views.back.current
check(front and back and front.snapshot.model ~= back.snapshot.model, "library has independent front/back models")
check(front.appearanceVersion == back.appearanceVersion and front.source == back.source, "library shares appearance version/source")
window:Hide(); advance(1)
check(window.heroAvatar:Diagnostics().activeModels == 0, "hide releases avatar displays")
window:Show(); advance(2)
check(window.heroAvatar:Diagnostics().activeModels == 2, "show restores both avatars")
window:Destroy(); player.Character = nil; character:Destroy(); advance(20)
check(activeConnections() == baselineConnections and instanceCount() == baseline, "avatar library cleanup")

local preset = Library:CreateJBS({Config = {AvatarPreview = {Enabled = false}}})
check(preset.Controller and preset.Screen:FindFirstChild("Input_targetRebirths", true), "original preset available through library")
preset.Destroy()
check(activeConnections() == baselineConnections and instanceCount() == baseline, "preset cleanup")
print("PASS", passed, "library assertions; inert require, callbacks, controls, dropdown refresh, slider input, lifecycle, responsive layout decisions, shared avatars")
print("OFFLINE ONLY: no native screenshot, font rendering, mobile touch or FPS measurement.")
