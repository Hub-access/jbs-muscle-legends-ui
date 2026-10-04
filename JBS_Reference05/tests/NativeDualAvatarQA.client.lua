--[[
    待执行的 Roblox Studio 原生验收入口；不是本机已通过的记录。
    将本 LocalScript 单独放入 StarterPlayerScripts，与 JBS_Reference05 模型同级。
    仅在空白本地测试场景运行。它会关闭当前 JBS UI，使用明确的测试业务绑定，
    最后恢复默认入口；不会改变 LocalPlayer.Character、衣服、关节或游戏相机。
    第二阶段：正背面共享来源；两种 HumanoidDescription 是测试外观，不是两个真实账号。
    默认禁用；与旧 NativeAvatarQA 不要同时启用。四组帧间隔仅在本入口采样。
]]
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
assert(RunService:IsStudio(), "只能在 Studio 本地测试")
local player = Players.LocalPlayer
local package = player:WaitForChild("PlayerScripts"):WaitForChild("JBS_Reference05", 10)
assert(package, "先导入 JBS_Reference05.rbxmx 到 StarterPlayerScripts")
local Runtime = require(package.Runtime)
local Hero = require(package.HeroAvatar)
local Snapshot = require(package.AvatarSnapshot)
local Config = require(package.Config)
local parent = player:WaitForChild("PlayerGui")
local owner = parent:FindFirstChild("JBS5_Owner")
if owner then
    owner:Invoke("Destroy")
end
local savedSession = parent:GetAttribute(Config.SessionAttribute)
local owned, heroes, app = {}, {}, nil
local results = {
    environment = "Roblox Studio native, opt-in QA",
    realAccountsTested = 0,
    testLooks = {},
    checks = {},
    screenshots = "manual capture still required",
    performanceNote = "Frame intervals include Studio/game workload; not isolated UI GPU time.",
}
local function own(v)
    table.insert(owned, v)
    return v
end
local function check(condition, label)
    assert(condition, label)
    table.insert(results.checks, label)
end
local function untilTrue(fn, label, seconds)
    local deadline = os.clock() + (seconds or 15)
    repeat
        if fn() then
            return
        end
        task.wait(0.1)
    until os.clock() > deadline
    error("超时：" .. label)
end
local function frames()
    local values = {}
    for _ = 1, 180 do
        table.insert(values, RunService.RenderStepped:Wait() * 1000)
    end
    table.sort(values)
    local sum = 0
    for _, value in ipairs(values) do
        sum += value
    end
    return { count = #values, meanMs = sum / #values, p50Ms = values[90], p95Ms = values[171] }
end
local bindings = {
    Tasks = {},
    LoadState = function()
        return { page = "home", reduced = true }
    end,
    SaveState = function() end,
    GetEnvironment = function()
        return {
            Title = "原生角色 QA",
            Detail = "测试外观 / 无游戏业务",
            Badge = "测试",
            Kind = "neutral",
        }
    end,
}
local function newApp(enabled, back)
    -- Bootstrap 与测试脚本的首次启动顺序不固定；每次挂载前再检查一次所有权。
    local previous = parent:FindFirstChild("JBS5_Owner")
    if previous then
        previous:Invoke("Destroy")
    end
    return Runtime.Mount({
        Bindings = bindings,
        Config = { ReducedMotion = true, AvatarPreview = { Enabled = enabled, BackEnabled = back == true } },
    })
end
local function fakePlayer(character)
    local added, removing = own(Instance.new("BindableEvent")), own(Instance.new("BindableEvent"))
    return {
        Character = character,
        UserId = player.UserId,
        CharacterAdded = added.Event,
        CharacterRemoving = removing.Event,
    },
        added,
        removing
end
local function makeLook(rigType, color, width)
    local desc = own(Instance.new("HumanoidDescription"))
    desc.HeadColor = color
    desc.TorsoColor = color
    desc.LeftArmColor = color
    desc.RightArmColor = color
    desc.LeftLegColor = color
    desc.RightLegColor = color
    desc.WidthScale = width
    local model = own(Players:CreateHumanoidModelFromDescriptionAsync(desc, rigType))
    model.Name = "QA_" .. rigType.Name
    -- 仅挂在测试 Folder，绝不替换 player.Character。
    local fixtureFolder = own(Instance.new("Folder"))
    fixtureFolder.Name = "JBS_QA_AppearanceOnly"
    fixtureFolder.Parent = game:GetService("ReplicatedStorage")
    model.Parent = fixtureFolder
    table.insert(
        results.testLooks,
        { rig = rigType.Name, source = "HumanoidDescription fixture; not real account", width = width }
    )
    return model
end
local function newHarness(source, fetch, hooks)
    local screen = own(Instance.new("ScreenGui"))
    screen.Name = "JBS_Avatar_QA_Container"
    screen.Parent = parent
    local viewport = Instance.new("ViewportFrame")
    viewport.Name = "TestViewport"
    viewport.Size = UDim2.fromOffset(450, 280)
    viewport.Position = UDim2.fromOffset(20, 100)
    viewport.BackgroundColor3 = Color3.fromRGB(20, 10, 30)
    viewport.Parent = screen
    local label = Instance.new("TextLabel")
    label.Size = UDim2.fromOffset(600, 40)
    label.Parent = screen
    hooks = hooks or {}
    hooks.FetchAccount = fetch
    local service = Hero.new(source, viewport, label, { MinInterval = 0.5, ReadyAttempts = 3 }, hooks)
    local rear = Instance.new("ViewportFrame")
    rear.Name = "TestBackViewport"
    rear.Size = UDim2.fromOffset(240, 240)
    rear.Position = UDim2.fromOffset(500, 100)
    rear.BackgroundColor3 = Color3.fromRGB(20, 10, 30)
    rear.Parent = screen
    local rearLabel = Instance.new("TextLabel")
    rearLabel.Position = UDim2.fromOffset(500, 350)
    rearLabel.Size = UDim2.fromOffset(260, 40)
    rearLabel.Parent = screen
    service:AddView("back", rear, rearLabel, "back", 35)
    table.insert(heroes, service)
    service:SetVisible(true)
    return service, viewport, rear
end
local function pair(h, label)
    local f, b = h.views.front.current, h.views.back.current
    check(f ~= nil and b ~= nil, label .. "：两处存在")
    check(f.appearanceVersion == b.appearanceVersion and f.source == b.source, label .. "：同版同来源")
    check(
        f.snapshot.model ~= b.snapshot.model and f.world ~= b.world and f.camera ~= b.camera,
        label .. "：独立实例"
    )
    check(
        f.snapshot.model.Parent == f.world and b.snapshot.model.Parent == b.world,
        label .. "：各自模型父节点"
    )
    check(
        h.views.front.viewport.CurrentCamera == f.camera and h.views.back.viewport.CurrentCamera == b.camera,
        label .. "：独立 CurrentCamera"
    )
    check(
        f.camera.CFrame.LookVector.Z > 0 and b.camera.CFrame.LookVector.Z < 0,
        label .. "：规范化角色前后相机方向"
    )
    local d = h:Diagnostics()
    check(
        d.activeModels == 2 and d.worlds == 2 and d.cameras == 2 and d.sourceListenerSets == 1,
        label .. "：两份活动模型，一套来源监听"
    )
end
local ok, problem = xpcall(function()
    untilTrue(function()
        return player.Character and player.Character:FindFirstChild("Head")
    end, "LocalPlayer 角色")
    local live = player.Character
    local liveParent = live.Parent
    -- 无 yield 地对照真实人物，避免把游戏本身的后续动画误判为本模块修改。
    local flags = {}
    for _, v in ipairs(live:GetDescendants()) do
        flags[v] = v.Archivable
    end
    flags[live] = live.Archivable
    local root = live:FindFirstChild("HumanoidRootPart")
    local beforePosition = root and root.CFrame
    local gameCamera = workspace.CurrentCamera
    local cameraFrame, cameraSubject = gameCamera.CFrame, gameCamera.CameraSubject
    local snap, reason = Snapshot.FromCharacter(live)
    check(snap ~= nil, "真实当前角色可复制：" .. tostring(reason))
    for v, flag in pairs(flags) do
        check(v.Archivable == flag, "Archivable 恢复：" .. v.Name)
    end
    check(live == player.Character and live.Parent == liveParent, "未搬动真实 Character")
    check(not root or root.CFrame == beforePosition, "未改真实位置")
    check(
        workspace.CurrentCamera == gameCamera
            and gameCamera.CFrame == cameraFrame
            and gameCamera.CameraSubject == cameraSubject,
        "未修改游戏相机"
    )
    snap.model:Destroy()
    results.realAccountsTested = 1
    results.testContext = {
        placeId = game.PlaceId,
        viewport = { width = gameCamera.ViewportSize.X, height = gameCamera.ViewportSize.Y },
        scene = "Local QA floor/spawn; record any additional scene contents manually",
        device = "Record device model, OS and graphics setting manually alongside this log",
    }
    app = newApp(false, false)
    task.wait(1)
    results.withoutAvatar = { diagnostics = app.Diagnostics(), frames = frames() }
    app.Destroy()
    app = newApp(true, false)
    untilTrue(function()
        return app.View.heroAvatar.source == "character"
    end, "首次显示已有 Character")
    results.frontOnly = { diagnostics = app.Diagnostics(), frames = frames() }
    app.Destroy()
    app = newApp(true, true)
    untilTrue(function()
        return app.View.heroAvatar.source == "character"
            and app.View.heroAvatar:Diagnostics().activeModels == 2
    end, "正背面当前角色")
    pair(app.View.heroAvatar, "真实当前玩家")
    results.frontAndBack = { diagnostics = app.Diagnostics(), frames = frames() }
    local before = app.View.heroAvatar:Diagnostics()
    for _ = 1, 30 do
        app.Close()
        local hidden = app.View.heroAvatar:Diagnostics()
        check(
            hidden.activeModels == 0 and hidden.worlds == 0 and hidden.scheduledTasks == 0,
            "隐藏释放模型与任务"
        )
        app.Restore()
        untilTrue(function()
            return app.View.heroAvatar.source == "character"
        end, "恢复角色")
        local d = app.View.heroAvatar:Diagnostics()
        check(d.activeModels == 2 and d.worlds == 2 and d.cameras == 2, "两套活动展示")
        pair(app.View.heroAvatar, "显隐恢复")
        check(d.connections == before.connections, "开关无连接增长")
    end
    results.after30Cycles = app.Diagnostics()
    check(
        results.after30Cycles.avatar.modelInstances == before.modelInstances,
        "同一外观模型数量不累积"
    )
    app.Close()
    results.hidden = { diagnostics = app.Diagnostics(), frames = frames() }
    local blue = makeLook(Enum.HumanoidRigType.R6, Color3.fromRGB(55, 155, 220), 1)
    local gold = makeLook(Enum.HumanoidRigType.R15, Color3.fromRGB(230, 190, 85), 1.4)
    local source, added, removing = fakePlayer(blue)
    local accountCalls = 0
    local h, viewport, rear = newHarness(source, function(id)
        accountCalls += 1
        check(id == player.UserId, "备用请求仅使用当前玩家 ID")
        local clone = gold:Clone()
        clone.Parent = nil
        return clone
    end)
    untilTrue(function()
        return h.source == "character"
    end, "R6 测试外观")
    pair(h, "R6 蓝色测试外观")
    check(h.active.model:FindFirstChild("Torso").Color == blue.Torso.Color, "不写死粉色皮肤")
    local hat = Instance.new("Accessory")
    hat.Name = "QA_TallHat"
    local handle = Instance.new("Part")
    handle.Name = "Handle"
    handle.Size = Vector3.new(1.5, 3, 1.5)
    handle.Parent = hat
    local weld = Instance.new("Weld")
    weld.Part0 = blue.Head
    weld.Part1 = handle
    weld.C0 = CFrame.new(0, 2, 0)
    weld.Parent = handle
    hat.Parent = blue
    untilTrue(function()
        return h.active.model:FindFirstChild(hat.Name) ~= nil
    end, "迟到头饰")
    pair(h, "迟到头饰")
    check(h.views.back.current.snapshot.model:FindFirstChild(hat.Name) ~= nil, "背面也有迟到头饰")
    local builds = h.buildCount
    blue.Head.Color = Color3.fromRGB(40, 200, 170)
    untilTrue(function()
        return h.buildCount > builds
    end, "外观变化")
    pair(h, "体色更新")
    local rearCameraBefore = h.views.back.current.camera.CFrame
    local oldCamera = h.camera.CFrame
    viewport.Size = UDim2.fromOffset(220, 380)
    task.wait(0.2)
    check(h.camera.CFrame ~= oldCamera, "窗口宽高改变重新取景")
    check(h.views.back.current.camera.CFrame == rearCameraBefore, "正面尺寸不改变背面相机")
    rear.Size = UDim2.fromOffset(150, 340)
    task.wait(0.2)
    check(h.views.back.current.camera.CFrame ~= rearCameraBefore, "背面独立尺寸取景")
    removing:Fire(blue)
    source.Character = nil
    untilTrue(function()
        return h.source == "account"
    end, "账号备用测试替身")
    pair(h, "同一次账号备用结果")
    check(accountCalls == 1, "两处只查询一次备用")
    check(string.find(h.views.back.label.Text, "账号备用", 1, true) ~= nil, "背面备用来源标识")
    source.Character = gold
    added:Fire(gold)
    untilTrue(function()
        return h.source == "character" and h.active.model:FindFirstChild("UpperTorso")
    end, "R15 重生测试替身")
    pair(h, "R15 金色重生测试替身")
    check(h.active.model.UpperTorso.Color == gold.UpperTorso.Color, "第二外观维持自身肤色")
    -- 故障只注入 QA 管理器，生产入口没有这些依赖；不改真实 Character。
    for _, faultPoint in ipairs({ "BeforePrepareView", "BeforeAttachView" }) do
        local previousFront, previousBack = h.views.front.current, h.views.back.current
        local failures = h.commitFailures
        h.testDependencies[faultPoint] = function(id)
            if id == "back" then
                error("QA deliberate back failure: " .. faultPoint)
            end
        end
        h:MarkDirty()
        untilTrue(function()
            return h.commitFailures > failures
        end, faultPoint)
        check(
            h.views.front.current == previousFront and h.views.back.current == previousBack,
            faultPoint .. "：完整保留旧组"
        )
        pair(h, faultPoint .. " 回滚后")
        check(
            #viewport:GetChildren() == 2 and #rear:GetChildren() == 2,
            faultPoint .. "：候选 WorldModel/Camera 已回收"
        )
        h.testDependencies[faultPoint] = nil
        h:MarkDirty()
        untilTrue(function()
            return h.views.front.current ~= previousFront
        end, "失败后恢复")
        pair(h, faultPoint .. " 恢复")
    end
    h:Destroy()
    check(h:Diagnostics().connections == 0, "完整销毁连接")
    local empty = fakePlayer(nil)
    local pendingModel
    local late = newHarness(empty, function()
        task.wait(3)
        pendingModel = gold:Clone()
        return pendingModel
    end)
    untilTrue(function()
        return late.pendingFallback ~= nil
    end, "等待中的备用请求")
    late:Destroy()
    task.wait(3.2)
    check(
        pendingModel ~= nil and pendingModel.Parent == nil and #pendingModel:GetChildren() == 0,
        "销毁后晚到模型被清理"
    )
    local bad = newHarness(empty, function()
        error("QA deliberate account failure")
    end)
    untilTrue(function()
        return bad.fallbackAttempts == 2 and not bad.pendingFallback
    end, "失败有限重试")
    check(bad.lastError ~= nil, "加载失败明确记录")
    bad:Destroy()
    app.Restore()
    results.nativeSource = "LocalPlayer.Character tested once; second real account not tested"
    results.artStatus = {
        hero_clean = app.Assets.status.hero_clean,
        sidebar_clean = app.Assets.status.sidebar_clean,
        note = "Asset loader status is not a visual approval or a rights audit",
    }
    results.manualRemaining = {
        "capture full native UI, front and back at normal and narrow windows",
        "verify clean art permissions, image failure behavior and original slogan/JBS occlusion",
        "record hardware, graphics quality and scene with all four performance samples",
        "real respawn via Roblox reset",
        "second real account",
        "layered clothing/custom muscle rig visual fidelity",
        "keyboard/touch/navigation and starting/stopping original business",
    }
end, debug.traceback)
for _, h in ipairs(heroes) do
    h:Destroy()
end
if app then
    app.Destroy()
end
for i = #owned, 1, -1 do
    owned[i]:Destroy()
end
parent:SetAttribute(Config.SessionAttribute, savedSession)
results.passed = ok
results.error = not ok and tostring(problem) or nil
print("JBS_NATIVE_DUAL_AVATAR_QA " .. HttpService:JSONEncode(results))
Runtime.Mount()
if not ok then
    error(problem)
end
