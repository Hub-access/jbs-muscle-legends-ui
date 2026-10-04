-- Second-stage regression. Production code + deterministic engine double, never native evidence.
local passed, scenarios = 0, {}
local function check(ok, reason)
    assert(ok, reason)
    passed += 1
end
local function scenario(name)
    table.insert(scenarios, name)
end
local baseline = instanceCount()
local container = Instance.new("Folder")
local function makePart(model, name, size, position)
    local p = Instance.new("Part")
    p.Name = name
    p.Size = size
    p.CFrame = CFrame.new(position)
    p.Parent = model
    return p
end
local function weld(model, a, b, position)
    local j = Instance.new("Motor6D")
    j.Part0 = a
    j.Part1 = b
    j.C0 = CFrame.new(position)
    j.Parent = model
    return j
end
local function look(width, color)
    local m = Instance.new("Model")
    m.Name = "AppearanceFixture"
    local hum = Instance.new("Humanoid")
    hum.Parent = m
    local root = makePart(m, "HumanoidRootPart", Vector3.new(2, 2, 1), Vector3.new(100, 0, 50))
    root.Transparency = 1
    local body = makePart(m, "Torso", Vector3.new(width, 3, 2), Vector3.new(100, 0, 50))
    local head = makePart(m, "Head", Vector3.new(2, 1, 1), Vector3.new(300, 40, -50))
    head.Color = color
    weld(m, root, body, Vector3.zero)
    weld(m, body, head, Vector3.new(0, 2, 0))
    local arm = makePart(m, "Left Arm", Vector3.new(2, 3, 2), Vector3.new(500, 10, 0))
    weld(m, body, arm, Vector3.new(-width * 0.65, 0, 0))
    local shirt = Instance.new("Shirt")
    shirt.ShirtTemplate = "fixture-shirt"
    shirt.Parent = m
    m.Parent = container
    m.Archivable = false
    head.Archivable = false
    return m
end
local a = look(6, Color3.new(0.1, 0.5, 0.9))
local b = look(2, Color3.new(0.8, 0.6, 0.1))
local fakePlayer = Instance.new("Player")
fakePlayer.UserId = 819726
fakePlayer.Character = a
local front = Instance.new("ViewportFrame")
front.Parent = container
front.AbsoluteSize = Vector2.new(450, 260)
local back = Instance.new("ViewportFrame")
back.Parent = container
back.AbsoluteSize = Vector2.new(176, 150)
local frontStatus = Instance.new("TextLabel")
frontStatus.Parent = container
local backStatus = Instance.new("TextLabel")
backStatus.Parent = container
local hooks = {}
local hero = Modules.HeroAvatar.new(fakePlayer, front, frontStatus, { MinInterval = 0.5 }, hooks)
local beforeBackConnections = activeConnections()
hero:AddView("back", back, backStatus, "back", 35)
check(
    activeConnections() == beforeBackConnections + 1,
    "back adds resize connection, no new character listener set"
)
local accountCalls, requests = 0, {}
hooks.FetchAccount = nil -- The production fetch closure below uses the engine service double.
services.Players.CreateHumanoidModelFromUserIdAsync = function(_, id)
    check(id == fakePlayer.UserId, "fallback uses only the current player's UserId")
    accountCalls += 1
    table.insert(requests, coroutine.running())
    return coroutine.yield()
end
local function pair()
    return hero.views.front.current, hero.views.back.current
end
local function sameVersion(reason)
    local f, r = pair()
    check(f and r and f.appearanceVersion == r.appearanceVersion and f.source == r.source, reason)
    return f, r
end
scenario("independent models, one normalized source, actual reverse camera")
hero:SetVisible(true)
advance(0.7)
local f, r = sameVersion("initial pair shares appearance version and source")
check(
    f.snapshot.model ~= r.snapshot.model and f.world ~= r.world and f.camera ~= r.camera,
    "all three owned instances are independent"
)
check(
    f.snapshot.model.Parent == f.world and r.snapshot.model.Parent == r.world,
    "each model stays in its own WorldModel"
)
check(
    front.CurrentCamera == f.camera and back.CurrentCamera == r.camera,
    "dedicated CurrentCamera per display"
)
check(
    f.camera.CFrame.Position.Z < f.camera.CFrame.target.Z
        and r.camera.CFrame.Position.Z > r.camera.CFrame.target.Z,
    "back camera is behind normalized body, not a mirror"
)
check(
    f.snapshot.model.Head.CFrame.Position.X == r.snapshot.model.Head.CFrame.Position.X,
    "body coordinates are identical, no horizontal flipping"
)
check(
    f.snapshot.model:GetAttribute("JBS_AppearanceVersion")
        == r.snapshot.model:GetAttribute("JBS_AppearanceVersion"),
    "version also carried by models"
)
check(
    accountCalls == 0 and hero:Diagnostics().activeModels == 2,
    "current Character uses zero account queries and exactly two models"
)
check(not a.Archivable and not a.Head.Archivable, "shared copy restores source flags")
local stableInstances, stableConnections = instanceCount(), activeConnections()
local sourceCopy = Modules.AvatarSnapshot.Copy
local reads = 0
Modules.AvatarSnapshot.Copy = function(model)
    if model == a then
        reads += 1
    end
    return sourceCopy(model)
end
scenario("one source read per update, clothing/body changes applied to both")
a.Head.Color = Color3.new(0.2, 0.8, 0.4)
a.Torso.Size = Vector3.new(8, 3, 2)
advance(0.7)
f, r = sameVersion("one new pair after appearance burst")
check(reads == 1, "a refresh reads the real Character once")
check(
    f.snapshot.model.Head.Color == a.Head.Color and r.snapshot.model.Head.Color == a.Head.Color,
    "both keep actual non-author skin color"
)
check(f.snapshot.model.Torso.Size.X == 8 and r.snapshot.model.Torso.Size.X == 8, "same custom body scale")
Modules.AvatarSnapshot.Copy = sourceCopy
check(
    instanceCount() == stableInstances and activeConnections() == stableConnections,
    "replacing pair releases both old models"
)
local beforeMoves = hero.buildCount
for i = 1, 40 do
    a.Head.CFrame = CFrame.new(i, 5, i)
    advance(0.02)
end
check(hero.buildCount == beforeMoves, "movement does not rebuild either view")
scenario("late accessory and independent resize")
local accessory = Instance.new("Accessory")
accessory.Name = "LateHat"
local handle = makePart(accessory, "Handle", Vector3.new(1, 5, 1), Vector3.zero)
local hatWeld = Instance.new("Weld")
hatWeld.Part0 = a.Head
hatWeld.Part1 = handle
hatWeld.C0 = CFrame.new(0, 2.5, 0)
hatWeld.Parent = handle
accessory.Parent = a
advance(0.7)
f, r = sameVersion("delayed accessory appears in same pair")
check(
    f.snapshot.model:FindFirstChild("LateHat") and r.snapshot.model:FindFirstChild("LateHat"),
    "both retain delayed 3D accessory"
)
local oldFrontCamera = f.camera.CFrame
local oldBackCamera = r.camera.CFrame
local version = hero.appearanceVersion
back.AbsoluteSize = Vector2.new(90, 300)
check(
    r.camera.CFrame ~= oldBackCamera and f.camera.CFrame == oldFrontCamera,
    "back resize only fits its own camera"
)
check(hero.appearanceVersion == version, "resize does not fetch appearance or replace models")
accessory:Destroy()
advance(0.7)
check(activeConnections() == stableConnections, "removed accessory releases appearance connections")
scenario("back preparation failure retains complete old pair")
local oldF, oldR = pair()
local oldVersion = hero.appearanceVersion
hooks.BeforePrepareView = function(id)
    if id == "back" then
        error("injected back preparation failure")
    end
end
a.Head.Color = Color3.new(0.3, 0.4, 0.5)
advance(0.7)
f, r = pair()
check(
    f == oldF and r == oldR and hero.appearanceVersion == oldVersion,
    "preparation failure publishes neither candidate"
)
check(
    instanceCount() == stableInstances and string.find(backStatus.Text, "失败") ~= nil,
    "failed candidates released, status explains failure"
)
hooks.BeforePrepareView = nil
advance(1.3)
sameVersion("bounded retry recovers pair")
scenario("second camera assignment failure rolls back first attach")
oldF, oldR = pair()
oldVersion = hero.appearanceVersion
faultAssignments[back] = "CurrentCamera"
a.Head.Color = Color3.new(0.8, 0.2, 0.4)
advance(0.7)
f, r = pair()
check(
    f == oldF and r == oldR and hero.appearanceVersion == oldVersion,
    "partial attach rolls back ownership/version"
)
check(
    front.CurrentCamera == oldF.camera and back.CurrentCamera == oldR.camera,
    "both previous cameras restored"
)
check(instanceCount() == stableInstances, "partial attach leaves no candidate WorldModels/cameras/models")
advance(1.3)
sameVersion("retry after commit failure succeeds")
scenario("stale prepared revision cannot overwrite newer appearance")
local staleToken = hero:CaptureRequest()
local staleSnapshot = assert(Modules.AvatarSnapshot.FromCharacter(a))
a.Head.Color = Color3.new(0.7, 0.9, 0.2)
check(
    not hero:Commit(staleSnapshot, "character", staleToken) and staleSnapshot.model._destroyed,
    "request sequence discards stale prepared result"
)
advance(0.7)
sameVersion("latest requested revision committed")
scenario("hide in the short submit path cleans old and candidate pairs")
hooks.BeforeAttachView = function(id)
    if id == "back" then
        hero:SetVisible(false)
    end
end
a.Head.Color = Color3.new(0.4, 0.9, 0.5)
advance(0.7)
check(
    hero:Diagnostics().activeModels == 0 and hero:Diagnostics().scheduledTasks == 0,
    "hide during attach has no active models or queued work"
)
check(front.CurrentCamera == nil and back.CurrentCamera == nil, "hide cannot resurrect old cameras")
hooks.BeforeAttachView = nil
hero:SetVisible(true)
advance(0.7)
sameVersion("restore after interrupted commit")
check(instanceCount() == stableInstances, "interrupted commit releases all temporary instances")
scenario("hidden view resumes latest version, shared visible back keeps updating")
hero:SetViewVisibility({ front = false, back = true })
advance(0.7)
check(
    hero:Diagnostics().activeModels == 1 and hero.views.front.current == nil,
    "hidden front releases its model"
)
a.Head.Color = Color3.new(0.1, 0.1, 0.1)
advance(0.7)
local onlyBack = hero.views.back.current
check(onlyBack.snapshot.model.Head.Color == a.Head.Color, "visible back updates without another source")
hero:SetViewVisibility({ front = true, back = true })
advance(0.7)
f, r = sameVersion("restored front and existing back commit one new version")
check(
    f.snapshot.model.Head.Color == a.Head.Color and r.snapshot.model.Head.Color == a.Head.Color,
    "restored view never revives older appearance"
)
scenario("account fallback loading, respawn and stale response")
fakePlayer.Character = nil
fakePlayer.CharacterRemoving:Fire(a)
advance(1.8)
check(accountCalls == 1 and #requests == 1, "both views share one account query")
fakePlayer.Character = b
fakePlayer.CharacterAdded:Fire(b)
advance(0.7)
local late = look(9, Color3.new(0.9, 0.1, 0.1))
late.Parent = nil
check(coroutine.resume(table.remove(requests, 1), late), "finish superseded account call")
f, r = sameVersion("new character wins over late account result")
check(
    late._destroyed and f.snapshot.model.Torso.Size.X == 2 and r.snapshot.model.Torso.Size.X == 2,
    "late old source cannot replace either new body"
)
fakePlayer.Character = nil
fakePlayer.CharacterRemoving:Fire(b)
advance(1.8)
local fallback = look(3, Color3.new(0.4, 0.5, 0.6))
fallback.Parent = nil
check(coroutine.resume(table.remove(requests, 1), fallback), "finish valid shared fallback")
f, r = sameVersion("account result assigned to both views")
check(
    f.source == "account"
        and string.find(frontStatus.Text, "备用")
        and string.find(backStatus.Text, "备用"),
    "both mark account source explicitly"
)
local previousCalls = accountCalls
hero:SetViewVisibility({ front = false, back = true })
advance(2)
hero:SetVisible(true)
advance(2)
sameVersion("account-backed hidden view restores same source")
check(accountCalls == previousCalls, "restoring one account view uses existing result, no second lookup")
fakePlayer.Character = a
fakePlayer.CharacterAdded:Fire(a)
advance(0.7)
sameVersion("current game Character replaces fallback in both")
scenario("30 full hide/restore cycles and bounded ownership")
stableInstances = instanceCount()
stableConnections = activeConnections()
for _ = 1, 30 do
    hero:SetVisible(false)
    check(
        hero:Diagnostics().activeModels == 0 and queuedCount() == 0,
        "hidden pair releases owned display work"
    )
    local oldBuilds = hero.buildCount
    a.Head.Color = Color3.new(0.2, 0.3, 0.4)
    advance(0.7)
    check(hero.buildCount == oldBuilds, "both hidden only record dirty state")
    hero:SetVisible(true)
    advance(0.7)
    sameVersion("cycle restores matching pair")
    check(
        hero:Diagnostics().activeModels == 2
            and instanceCount() == stableInstances
            and activeConnections() == stableConnections,
        "stable pair does not grow across 30 cycles"
    )
end
scenario("destroy in submit path and late engine response")
hooks.BeforeAttachView = function(id)
    if id == "back" then
        hero:Destroy()
    end
end
a.Head.Color = Color3.new(0.6, 0.6, 0.6)
advance(0.7)
check(
    hero:Diagnostics().activeModels == 0 and hero:Diagnostics().connections == 0 and queuedCount() == 0,
    "destroy during attach disposes all candidates and listeners"
)
check(front.CurrentCamera == nil and back.CurrentCamera == nil, "destroyed UI cannot regain cameras")
fakePlayer.Character = nil
local pendingHero =
    Modules.HeroAvatar.new(fakePlayer, front, frontStatus, { MinInterval = 0.5, ReadyAttempts = 2 })
pendingHero:AddView("back", back, backStatus, "back", 35)
pendingHero:SetVisible(true)
advance(1.8)
check(#requests == 1, "one pending account request for a two-view owner")
pendingHero:Destroy()
local abandoned = look(4, Color3.new(0.2, 0.7, 0.8))
abandoned.Parent = nil
check(
    coroutine.resume(table.remove(requests, 1), abandoned),
    "resolve account result after dual-owner destruction"
)
check(
    abandoned._destroyed and pendingHero:Diagnostics().activeModels == 0,
    "late result cannot resurrect either display"
)
scenario("full UI integration, no business starts, clipped front suspension")
player.Character = a
player.UserId = fakePlayer.UserId
local businessCalls = 0
local app = Modules.Runtime.Mount({
    Bindings = {
        LoadState = function()
            return { page = "home", reduced = true }
        end,
        SaveState = function() end,
        Tasks = { train = {
            Start = function()
                businessCalls += 1
                return function()
                    businessCalls += 100
                end
            end,
        } },
    },
})
advance(0.7)
check(app.Diagnostics().avatar.activeModels == 2, "default UI uses pair")
check(
    app.View.root.Sidebar.SidebarArt:IsA("Frame")
        and app.Screen:FindFirstChild("CleanBackCityBackground", true),
    "back uses clean layers, not fixed character ImageLabel"
)
local nativeHero = app.View.heroAvatar
local visualListeners = nativeHero:Diagnostics().connections
app.Controller:SetSelected("train", true)
a.Head.Color = Color3.new(0.6, 0.5, 0.4)
advance(2)
check(businessCalls == 0 and app.Controller.phase == "Idle", "avatar refresh does not start/stop business")
app.View.heroAvatarHolder.AbsolutePosition = Vector2.new(0, -5000)
check(
    nativeHero.views.front.current == nil and nativeHero.views.back.current ~= nil,
    "fully clipped front releases model while sidebar remains"
)
app.View.heroAvatarHolder.AbsolutePosition = Vector2.new(0, 0)
advance(2)
check(nativeHero:Diagnostics().activeModels == 2, "scrolling into view restores a matching pair")
app.Controller:SetPage("pets")
advance(2)
check(
    nativeHero:Diagnostics().activeModels == 1 and nativeHero.views.back.current ~= nil,
    "navigation keeps only visible back active"
)
app.Controller:SetPage("home")
advance(2)
check(
    nativeHero:Diagnostics().activeModels == 2 and nativeHero:Diagnostics().connections == visualListeners,
    "navigation restores pair without new listeners"
)
app.Screen.Enabled = false
check(nativeHero:Diagnostics().activeModels == 0, "ScreenGui disable releases both")
app.Screen.Enabled = true
advance(2)
check(nativeHero:Diagnostics().activeModels == 2, "ScreenGui enable restores both")
check(businessCalls == 0, "all avatar/window operations remained isolated from business")
app.Destroy()
player.Character = nil
fakePlayer:Destroy()
container:Destroy()
check(
    instanceCount() == baseline and activeConnections() == 0 and queuedCount() == 0,
    "all dual-view test resources released"
)
print("PASS", passed, "dual-view assertions across", #scenarios, "scenarios; 30 hide/restore cycles")
for _, name in ipairs(scenarios) do
    print("SCENARIO", name)
end
print("OFFLINE DOUBLE ONLY: no Roblox render, upload permission, real-account fidelity or FPS measured.")
