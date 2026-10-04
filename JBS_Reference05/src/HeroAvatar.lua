--[[
    正背面共享外观的生命周期管理。生产来源始终由 Runtime 传入 LocalPlayer。
    Character 优先；账号模型仅为明确标注的备用。没有 GetUserThumbnail 或固定账号。
    不监听 CFrame/Transform，不使用 RunService，不跟踪游戏动作。

    阅读顺序：new → SetCharacter → MarkDirty → Refresh → Commit。
    隐藏/销毁：取消调度、使请求令牌过期、断开适当监听并清理展示实例。
    Roblox 账号 API 的进行中请求不能可靠取消；晚到模型只销毁，不再挂载。
]]
local Snapshot = require(script.Parent.AvatarSnapshot)
local Display = require(script.Parent.AvatarDisplay)
local RefreshMath = require(script.Parent.AvatarRefresh)
local AccountRequest = require(script.Parent.AvatarAccountRequest)
local HeroAvatar = {}
HeroAvatar.__index = HeroAvatar
local bodyColors =
    { "HeadColor3", "LeftArmColor3", "RightArmColor3", "LeftLegColor3", "RightLegColor3", "TorsoColor3" }
local function appearanceProperties(v)
    if v:IsA("BasePart") then
        local p = { "Size", "Color", "Transparency", "Material" }
        if v:IsA("MeshPart") then
            table.insert(p, "MeshId")
            table.insert(p, "TextureID")
        end
        return p
    elseif v:IsA("DataModelMesh") then
        return { "Scale", "Offset", "MeshId", "TextureId" }
    elseif v:IsA("Decal") then
        return { "Texture", "Color3", "Transparency" }
    elseif v:IsA("Shirt") then
        return { "ShirtTemplate" }
    elseif v:IsA("Pants") then
        return { "PantsTemplate" }
    elseif v:IsA("ShirtGraphic") then
        return { "Graphic" }
    elseif v:IsA("BodyColors") then
        return bodyColors
    elseif v:IsA("SurfaceAppearance") then
        return { "ColorMap", "MetalnessMap", "NormalMap", "RoughnessMap", "AlphaMode" }
    elseif v:IsA("CharacterMesh") then
        return { "BodyPart", "MeshId", "BaseTextureId", "OverlayTextureId" }
    elseif v:IsA("WrapLayer") then
        return { "Enabled", "Order", "Puffiness", "CageMeshId", "ReferenceMeshId" }
    elseif v:IsA("WrapTarget") then
        return { "CageMeshId" }
    elseif v:IsA("NumberValue") and v.Parent and v.Parent:IsA("Humanoid") then
        return { "Value" }
    end
    return {}
end
local function relevant(v)
    return #appearanceProperties(v) > 0
        or v:IsA("Accessory")
        or v:IsA("Humanoid")
        or v:IsA("Attachment")
        or v:IsA("JointInstance")
        or v:IsA("WeldConstraint")
        or v:IsA("BillboardGui")
        or v:IsA("SurfaceGui")
end
local function disconnect(list)
    for _, connection in ipairs(list) do
        connection:Disconnect()
    end
    table.clear(list)
end
function HeroAvatar.new(player, viewport, statusLabel, options, testDependencies)
    options = options or {}
    -- 仅 Studio 测试入口可注入延迟/失败的账号服务；生产配置不接受此字段。
    if testDependencies then
        assert(game:GetService("RunService"):IsStudio(), "测试替身仅限 Studio")
    end
    local self = setmetatable({
        player = player,
        viewport = viewport,
        label = statusLabel,
        visible = false,
        dead = false,
        version = 0,
        revision = 0,
        requestSequence = 0,
        appearanceVersion = 0,
        views = {},
        viewOrder = {},
        commitFailures = 0,
        testDependencies = testDependencies,
        timers = {},
        connections = {},
        characterConnections = {},
        watched = {},
        dirty = true,
        lastBuild = -math.huge,
        buildCount = 0,
        discarded = 0,
        fallbackAttempts = 0,
        readyAttempts = 0,
        state = "等待显示",
        source = "none",
        debounce = math.clamp(options.Debounce or 0.45, 0.3, 0.6),
        maxWait = math.max(0.6, options.MaxWait or 1.2),
        minInterval = math.max(0.5, options.MinInterval or 1.5),
        maxReady = math.clamp(options.ReadyAttempts or 8, 1, 20),
        fallbackTimeout = math.max(3, options.FallbackTimeout or 12),
        fov = math.clamp(options.FieldOfView or 35, 20, 70),
        maxDescendants = options.MaxDescendants or 2000,
    }, HeroAvatar)
    self.fetchAccount = testDependencies and testDependencies.FetchAccount
        or function(userId)
            return game:GetService("Players"):CreateHumanoidModelFromUserIdAsync(userId)
        end
    table.insert(
        self.connections,
        player.CharacterAdded:Connect(function(character)
            self:SetCharacter(character)
        end)
    )
    table.insert(
        self.connections,
        player.CharacterRemoving:Connect(function(character)
            if character == self.character then
                self:SetCharacter(nil)
            end
        end)
    )
    self:AddView("front", viewport, statusLabel, "front", self.fov)
    -- 先连事件再读 Character，防止漏掉“脚本启动之前就已生成”的角色。
    self:SetCharacter(player.Character)
    return self
end
-- 每处只新增尺寸监听；Character/衣服/配饰监听仍由这个管理器唯一持有。
function HeroAvatar:AddView(id, viewport, label, direction, fov)
    assert(not self.dead and not self.views[id], "展示区重复或已销毁")
    local display = Display.new(id, viewport, label, direction, fov or self.fov)
    self.views[id] = display
    table.insert(self.viewOrder, id)
    table.insert(
        self.connections,
        viewport:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
            display:Resize()
        end)
    )
    return display
end
function HeroAvatar:SyncFrontAliases()
    -- 保留第一阶段的诊断/QA 访问方式；真正实例所有权在各 Display.current 中。
    local record = self.views.front.current
    self.active = record and record.snapshot or nil
    self.world = record and record.world or nil
    self.camera = record and record.camera or nil
end
function HeroAvatar:HasDisplay()
    for _, display in pairs(self.views) do
        if display.current then
            return true
        end
    end
    return false
end
function HeroAvatar:CaptureRequest()
    return { character = self.version, request = self.requestSequence, revision = self.revision }
end
function HeroAvatar:IsCurrent(token)
    return not self.dead
        and self.visible
        and token.character == self.version
        and token.request == self.requestSequence
        and token.revision == self.revision
end
function HeroAvatar:SetState(message, compact)
    if self.dead then
        return
    end
    self.state = message
    for id, display in pairs(self.views) do
        display.label.Text = id == "back" and (compact or message) or message
    end
end
function HeroAvatar:CancelTimer(key)
    local thread = self.timers[key]
    self.timers[key] = nil
    if thread then
        pcall(task.cancel, thread)
    end
end
function HeroAvatar:After(key, seconds, callback)
    self:CancelTimer(key)
    self.timers[key] = task.delay(seconds, function()
        self.timers[key] = nil
        if not self.dead then
            callback()
        end
    end)
end
function HeroAvatar:ClearTimers()
    local keys = {}
    for key in pairs(self.timers) do
        table.insert(keys, key)
    end
    for _, key in ipairs(keys) do
        self:CancelTimer(key)
    end
end
function HeroAvatar:CancelAccountSubscription()
    if self.cancelAccount then
        self.cancelAccount()
        self.cancelAccount = nil
    end
    if self.pendingFallback then
        self.pendingFallback.expired = true
        self.pendingFallback = nil
    end
end
function HeroAvatar:Unwatch(v)
    if self.watched[v] then
        disconnect(self.watched[v])
        self.watched[v] = nil
    end
end
function HeroAvatar:Watch(v)
    if self.watched[v] then
        return
    end
    local list = {}
    for _, property in ipairs(appearanceProperties(v)) do
        -- API 版本可能没有某个外观字段；只略过不存在的字段，不监听所有属性替代。
        local ok, signal = pcall(v.GetPropertyChangedSignal, v, property)
        if ok then
            table.insert(
                list,
                signal:Connect(function()
                    self:MarkDirty()
                end)
            )
        end
    end
    if #list > 0 then
        self.watched[v] = list
    end
end
function HeroAvatar:ClearCharacterConnections()
    disconnect(self.characterConnections)
    local instances = {}
    for instance in pairs(self.watched) do
        table.insert(instances, instance)
    end
    for _, instance in ipairs(instances) do
        self:Unwatch(instance)
    end
end
function HeroAvatar:SetCharacter(character)
    if self.dead or self.character == character and self.characterInitialized then
        return
    end
    self.characterInitialized = true
    self:ClearCharacterConnections()
    self:CancelAccountSubscription()
    self.version += 1
    self.revision += 1
    self:ClearTimers()
    self.character = character
    self.characterReady = false
    self.readyAttempts = 0
    self.fallbackAttempts = 0
    self.firstDirty = nil
    if character then
        local descendants = character:GetDescendants()
        if #descendants <= self.maxDescendants then
            for _, v in ipairs(descendants) do
                self:Watch(v)
            end
        end
        table.insert(
            self.characterConnections,
            character.DescendantAdded:Connect(function(v)
                if #character:GetDescendants() <= self.maxDescendants then
                    self:Watch(v)
                end
                if relevant(v) then
                    self.readyAttempts = 0
                    self:MarkDirty()
                end
            end)
        )
        table.insert(
            self.characterConnections,
            character.DescendantRemoving:Connect(function(v)
                self:Unwatch(v)
                for _, child in ipairs(v:GetDescendants()) do
                    self:Unwatch(child)
                end
                if relevant(v) then
                    self:MarkDirty()
                end
            end)
        )
        table.insert(
            self.characterConnections,
            character.AncestryChanged:Connect(function()
                self:MarkDirty()
            end)
        )
    end
    self:MarkDirty()
end
function HeroAvatar:MarkDirty(retry)
    if self.dead then
        return
    end
    self.dirty = true
    if not retry then
        self.revision += 1
        self.requestSequence += 1
        self.commitFailures = 0
        -- 真正的外观变更使旧异步订阅过期；再次订阅仍复用同一未完成引擎请求。
        if self.pendingFallback then
            self:CancelAccountSubscription()
            self:CancelTimer("fallback-timeout")
            self.fallbackAttempts = 0
        end
    end
    if self.visible and self:HasDisplay() then
        self:SetState("外观更新中 · 保留上一版", "更新中 · v" .. self.appearanceVersion)
    end
    local now = os.clock()
    self.firstDirty = self.firstDirty or now
    if not self.visible then
        return
    end -- 仅记录，隐藏时没有复制/账号请求/定时重试。
    local due =
        RefreshMath.Due(self.firstDirty, now, self.lastBuild, self.debounce, self.maxWait, self.minInterval)
    self:After("refresh", math.max(0, due - now), function()
        self:Refresh()
    end)
end
function HeroAvatar:Release()
    for _, display in pairs(self.views) do
        display:Release()
    end
    self:SyncFrontAliases()
    self.source = "none"
end
-- 两处独立显隐：离开首页时释放正面，仍可见的侧栏继续由同一个来源更新。
function HeroAvatar:SetViewVisibility(visibility)
    if self.dead then
        return
    end
    local changed, any = false, false
    for id, display in pairs(self.views) do
        local visible = visibility[id] == true
        if visible ~= display.visible then
            changed = true
            display.visible = visible
            display.viewport.Visible = visible
            if not visible then
                display:Release()
            end
        end
        any = any or visible
    end
    if not changed then
        return
    end
    self.visible = any
    self.version += 1
    self:ClearTimers()
    self:CancelAccountSubscription()
    self:SyncFrontAliases()
    if not any then
        self.source = "none"
        self.characterReady = false
        self.dirty = true
        self.firstDirty = nil
        self:SetState("角色展示已暂停", "展示已暂停")
    else
        self.readyAttempts = 0
        self.fallbackAttempts = 0
        self:SetState("正在读取当前角色…", "角色更新中…")
        self:MarkDirty()
    end
end
-- 保留原单视图 API；测试或整体关闭时同时控制所有已登记展示区。
function HeroAvatar:SetVisible(visible)
    local flags = {}
    for id in pairs(self.views) do
        flags[id] = visible
    end
    self:SetViewVisibility(flags)
end
function HeroAvatar:FitCamera()
    self.views.front:Resize()
end
function HeroAvatar:Commit(snapshot, source, token)
    if not self:IsCurrent(token) or self.committing then
        snapshot.model:Destroy()
        self.discarded += 1
        return false
    end
    self.committing = true
    local nextVersion = self.appearanceVersion + 1
    local candidates, old, models = {}, {}, { snapshot.model }
    local preparedCount = 0
    local ok, problem = pcall(function()
        -- 仅从这一份净化快照复制第二份；不再读取一次真实 Character 或账号资料。
        for _, id in ipairs(self.viewOrder) do
            local display = self.views[id]
            if display.visible then
                if self.testDependencies and self.testDependencies.BeforePrepareView then
                    self.testDependencies.BeforePrepareView(id)
                end
                local currentSnapshot = snapshot
                if preparedCount > 0 then
                    local model, reason = Snapshot.Copy(snapshot.model)
                    assert(model, reason)
                    table.insert(models, model)
                    currentSnapshot = { model = model, bounds = snapshot.bounds, report = snapshot.report }
                end
                local record = display:Prepare(currentSnapshot, nextVersion, source)
                table.insert(candidates, { display = display, record = record })
                old[display] = display.current
                preparedCount += 1
            end
        end
        assert(preparedCount > 0 and self:IsCurrent(token), "外观请求已过期")
        -- 提交段不 yield。旧模型仍保留到全部成功，异常时可回滚专用相机。
        for _, entry in ipairs(candidates) do
            if self.testDependencies and self.testDependencies.BeforeAttachView then
                self.testDependencies.BeforeAttachView(entry.display.id)
            end
            assert(self:IsCurrent(token) and entry.display.visible, "提交期间请求已过期")
            entry.display:Attach(entry.record)
        end
        assert(self:IsCurrent(token), "提交结束前请求已过期")
    end)
    self.committing = false
    if not ok then
        local restored = true
        for _, entry in ipairs(candidates) do
            local display = entry.display
            local previous = display.current == old[display] and old[display] or display.current
            local recovered = pcall(display.Restore, display, previous)
            restored = recovered and restored
        end
        for _, entry in ipairs(candidates) do
            Display.Dispose(entry.record)
        end
        for _, model in ipairs(models) do
            model:Destroy()
        end
        if not restored then
            self:Release()
        end -- 控件已失效时一致降级，不能留半套新旧外观。
        self:SyncFrontAliases()
        if self:IsCurrent(token) then
            self.lastError = tostring(problem)
            self.commitFailures += 1
            local retained = self:HasDisplay()
            self:SetState(
                retained and "外观更新失败 · 保留上一组" or "角色展示失败 · 等待重试",
                retained and "更新失败 · 旧版保留" or "角色展示失败"
            )
            if self.commitFailures < 3 then
                self:After("commit-retry", self.minInterval, function()
                    self:MarkDirty(true)
                end)
            end
        else
            self.discarded += 1
        end
        return false
    end
    -- 对外版本号和所有权一起发布；此前没有把半套候选写进 Display.current。
    for _, entry in ipairs(candidates) do
        entry.display.current = entry.record
    end
    self.appearanceVersion = nextVersion
    self.committedRequest = token.request
    self.source = source
    self.buildCount += 1
    self.commitFailures = 0
    self.lastError = nil
    self:CancelTimer("commit-retry")
    self:SyncFrontAliases()
    for _, entry in ipairs(candidates) do
        Display.Dispose(old[entry.display])
    end
    local detail = source == "character" and "当前游戏角色" or "账号外观备用 · 非游戏体型"
    local compact = source == "character" and "游戏角色" or "账号备用"
    if #snapshot.report.unsupported > 0 then
        detail ..= " · 二维标签未支持"
        compact ..= " · 有限制"
    end
    if #snapshot.report.excluded > 0 then
        detail ..= " · 已排除异常装饰"
        compact ..= " · 有排除"
    end
    self:SetState(detail .. " · v" .. nextVersion, compact .. " · v" .. nextVersion)
    return true
end
function HeroAvatar:Fallback(token)
    if self.dead or not self.visible or self.pendingFallback or self.fallbackAttempts >= 2 then
        return
    end
    if self.source == "account" and self:HasDisplay() then
        local allVisibleReady = self.committedRequest == token.request
        for _, display in pairs(self.views) do
            if display.visible and not display.current then
                allVisibleReady = false
            end
        end
        if allVisibleReady then
            return
        end
        -- 单处恢复时，现有账号副本可作为同一来源；只在无 yield 提交期短暂复制。
        local existing
        for _, display in pairs(self.views) do
            if display.current then
                existing = display.current.snapshot
                break
            end
        end
        local copy, reason = Snapshot.Copy(existing.model)
        if copy then
            self:Commit(
                { model = copy, bounds = existing.bounds, report = existing.report },
                "account",
                token
            )
        else
            self.lastError = reason
            self:SetState("备用外观复制失败 · 保留上一组", "备用更新失败")
        end
        return
    end
    self.fallbackAttempts += 1
    local ticket = { token = token, expired = false }
    self.pendingFallback = ticket
    self:SetState("正在读取账号备用外观…", "账号备用读取中…")
    self:After("fallback-timeout", self.fallbackTimeout, function()
        if self.pendingFallback == ticket then
            ticket.expired = true
            self:SetState("账号备用超时 · 等待角色就绪", "备用超时 · 等待角色")
        end
    end)
    -- 引擎请求由小型共享请求器拥有，窗口只持有可撤销的订阅。
    self.cancelAccount = AccountRequest.Subscribe(self.player.UserId, self.fetchAccount, function(ok, model)
        if self.pendingFallback == ticket then
            self.pendingFallback = nil
            self:CancelTimer("fallback-timeout")
        end
        local stale = not self:IsCurrent(ticket.token) or ticket.expired or self.characterReady
        if stale then
            if ok and model then
                model:Destroy()
            end
            self.discarded += 1
            if not self.dead and self.visible and not self.characterReady and not self.pendingFallback then
                self:MarkDirty(true)
            end
            return
        end
        if ok and model then
            local ready, snapshot = pcall(Snapshot.Prepare, model)
            if ready then
                self:Commit(snapshot, "account", token)
            else
                model:Destroy()
                self.lastError = tostring(snapshot)
                self:SetState(
                    "账号外观不兼容 · 等待游戏角色",
                    "备用不兼容 · 等待角色"
                )
            end
        else
            self.lastError = tostring(model)
            self:SetState("账号外观加载失败 · 等待游戏角色", "备用失败 · 等待角色")
            if self.fallbackAttempts < 2 then
                self:After("fallback-retry", 3, function()
                    self:Fallback(self:CaptureRequest())
                end)
            end
        end
    end)
end
function HeroAvatar:Refresh()
    if self.dead or not self.visible then
        return
    end
    self.dirty = false
    self.firstDirty = nil
    self.lastBuild = os.clock()
    local token = self:CaptureRequest()
    local character = self.character
    local snapshot, reason
    local started = os.clock()
    if character and character.Parent and #character:GetDescendants() <= self.maxDescendants then
        snapshot, reason = Snapshot.FromCharacter(character)
    else
        reason = "Character 未就绪或超出展示部件上限"
    end
    self.lastBuildMs = (os.clock() - started) * 1000
    if snapshot then
        self.characterReady = true
        self:CancelTimer("ready")
        self:CancelTimer("fallback-retry")
        self:CancelTimer("fallback-timeout")
        self:CancelAccountSubscription()
        self:Commit(snapshot, "character", token)
        return
    end
    self.characterReady = false
    self.lastError = reason
    self.readyAttempts += 1
    if self:HasDisplay() then
        self:SetState(
            (self.source == "account" and "账号外观备用" or "保留上次游戏快照")
                .. " · 当前角色待就绪",
            self.source == "account" and "账号备用 · 等待角色" or "上版快照 · 等待角色"
        )
    else
        self:SetState("当前角色待就绪…")
    end
    if self.readyAttempts < self.maxReady then
        self:After("ready", math.max(0.5, self.minInterval), function()
            self:MarkDirty(true) -- 有限就绪重试不代表新外观，不使进行中的账号请求无故过期。
        end)
    end
    -- 首次短暂缺头/衣服给就绪检查机会；两次仍失败才使用账号备用。
    if self.readyAttempts >= 2 then
        self:Fallback(token)
    end
    if self.readyAttempts >= self.maxReady and not self:HasDisplay() and not self.pendingFallback then
        self:SetState("角色暂不可用 · 等待外观变化", "角色暂不可用")
    end
end
function HeroAvatar:Diagnostics()
    local connections = #self.connections + #self.characterConnections
    for _, list in pairs(self.watched) do
        connections += #list
    end
    local timers = 0
    for _ in pairs(self.timers) do
        timers += 1
    end
    local models, worlds, cameras, instances = 0, 0, 0, 0
    local views = {}
    for id, display in pairs(self.views) do
        local d = display:Diagnostics()
        views[id] = d
        models += d.activeModels
        worlds += d.worlds
        cameras += d.cameras
        instances += d.modelInstances
    end
    return {
        appearanceVersion = self.appearanceVersion,
        requestSequence = self.requestSequence,
        committedRequest = self.committedRequest,
        views = views,
        sourceListenerSets = self.dead and 0 or 1,
        state = self.state,
        source = self.source,
        visible = self.visible,
        destroyed = self.dead,
        activeModels = models,
        worlds = worlds,
        cameras = cameras,
        modelInstances = instances,
        connections = connections,
        scheduledTasks = timers,
        pendingAccountRequest = self.pendingFallback ~= nil,
        packageAccountRequests = AccountRequest.PendingCount(),
        builds = self.buildCount,
        discarded = self.discarded,
        lastBuildMs = self.lastBuildMs,
        lastError = self.lastError,
        report = self.active and self.active.report or nil,
        hiddenPolicy = "release display; keep filtered appearance listeners; no background rebuild",
    }
end
function HeroAvatar:Destroy()
    if self.dead then
        return
    end
    self.dead = true
    self.visible = false
    self.version += 1
    self:ClearTimers()
    self:CancelAccountSubscription()
    disconnect(self.connections)
    self:ClearCharacterConnections()
    self:Release()
    self.character = nil
    self.state = "已销毁"
end
return HeroAvatar
