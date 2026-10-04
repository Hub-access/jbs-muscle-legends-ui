--[[
    角色复制与净化。只有 Copy 的 Archivable 短路径会临时写真实角色；
    该路径绝不等待，逐项恢复所有改过的标志。其余代码只接触未挂载副本。
    第一阶段支持有 Head + Torso/UpperTorso 的 R6/R15 及它们的焊接扩展。
    无可靠关节连接的可见部件会使本次快照失败，转明确标注的账号备用。
]]
local Snapshot = {}
local bodyNames = {
    Head = true,
    Torso = true,
    UpperTorso = true,
    LowerTorso = true,
    ["Left Arm"] = true,
    ["Right Arm"] = true,
    ["Left Leg"] = true,
    ["Right Leg"] = true,
    LeftUpperArm = true,
    LeftLowerArm = true,
    LeftHand = true,
    RightUpperArm = true,
    RightLowerArm = true,
    RightHand = true,
    LeftUpperLeg = true,
    LeftLowerLeg = true,
    LeftFoot = true,
    RightUpperLeg = true,
    RightLowerLeg = true,
    RightFoot = true,
}
-- 只允许外观与骨架类型。默认拒绝其他类型，避免遗漏脚本、交互、力或场景引用。
local allowed = {
    Model = true,
    Folder = true,
    Humanoid = true,
    Accessory = true,
    Hat = true,
    BodyColors = true,
    Shirt = true,
    Pants = true,
    ShirtGraphic = true,
    Attachment = true,
    Bone = true,
    WrapLayer = true,
    WrapTarget = true,
    SurfaceAppearance = true,
    CharacterMesh = true,
    Decal = true,
    Texture = true,
    NumberValue = true,
    Vector3Value = true, -- 保留 Humanoid 尺寸值与部件 OriginalSize；均不含实例引用。
    Motor6D = true,
    Motor = true,
    Weld = true,
    ManualWeld = true,
    WeldConstraint = true,
}
local function keep(v)
    return allowed[v.ClassName] or v:IsA("BasePart") or v:IsA("DataModelMesh")
end
local function internal(v, model)
    return v ~= nil and (v == model or v:IsDescendantOf(model))
end
function Snapshot.Copy(character)
    local changed = {}
    local copy
    local ok, err = pcall(function()
        local all = character:GetDescendants()
        table.insert(all, 1, character)
        for _, item in ipairs(all) do
            if not item.Archivable then
                table.insert(changed, item)
                item.Archivable = true
            end
        end
        copy = character:Clone()
        assert(copy, "Character:Clone 返回空模型")
    end)
    -- finally：即使中间设置/Clone 出错，也继续恢复前面改过的每一个实例。
    local restoreErrors = {}
    for i = #changed, 1, -1 do
        local restored, problem = pcall(function()
            changed[i].Archivable = false
        end)
        if not restored then
            table.insert(restoreErrors, tostring(problem))
        end
    end
    if not ok or #restoreErrors > 0 then
        if copy then
            copy:Destroy()
        end
        return nil, tostring(err or table.concat(restoreErrors, "; "))
    end
    return copy
end
local function corners(part, collect)
    local half = part.Size / 2
    -- SpecialMesh 的 Scale/Offset 也参与取景，避免 Part 很小而头发模型很大。
    local mesh = part:FindFirstChildWhichIsA("DataModelMesh")
    local offset = Vector3.zero
    if mesh then
        half = Vector3.new(
            half.X * math.max(1, math.abs(mesh.Scale.X)),
            half.Y * math.max(1, math.abs(mesh.Scale.Y)),
            half.Z * math.max(1, math.abs(mesh.Scale.Z))
        )
        offset = mesh.Offset
    end
    for _, x in ipairs({ -1, 1 }) do
        for _, y in ipairs({ -1, 1 }) do
            for _, z in ipairs({ -1, 1 }) do
                collect(
                    part.CFrame:PointToWorldSpace(offset + Vector3.new(half.X * x, half.Y * y, half.Z * z))
                )
            end
        end
    end
end
local function boundsOf(parts)
    local b = {
        minX = math.huge,
        minY = math.huge,
        minZ = math.huge,
        maxX = -math.huge,
        maxY = -math.huge,
        maxZ = -math.huge,
    }
    for _, part in ipairs(parts) do
        corners(part, function(p)
            b.minX = math.min(b.minX, p.X)
            b.maxX = math.max(b.maxX, p.X)
            b.minY = math.min(b.minY, p.Y)
            b.maxY = math.max(b.maxY, p.Y)
            b.minZ = math.min(b.minZ, p.Z)
            b.maxZ = math.max(b.maxZ, p.Z)
        end)
    end
    return b
end
function Snapshot.Prepare(model)
    assert(model and model:IsA("Model") and model.Parent == nil, "只可净化未挂载的副本")
    local report = { unsupported = {}, excluded = {}, removed = 0 }
    local humanoid = model:FindFirstChildOfClass("Humanoid")
    -- 清理描述/缩放元数据之前先关闭自动缩放，避免净化本身使副本恢复账号默认体型。
    if humanoid then
        humanoid.AutomaticScalingEnabled = false
    end
    -- 先记录不支持的二维头饰/标签；不复制文字，也不凭空补 SIGMA。
    for _, v in ipairs(model:GetDescendants()) do
        if v:IsA("BillboardGui") or v:IsA("SurfaceGui") then
            table.insert(report.unsupported, v.ClassName .. ":" .. v.Name)
        end
    end
    for _, v in ipairs(model:GetDescendants()) do
        if v:IsDescendantOf(model) then
            if not keep(v) then
                report.removed += 1
                v:Destroy()
            else
                -- 标签可能被宿主游戏的 CollectionService 监听，展示副本不应触发其业务。
                for _, tag in ipairs(v:GetTags()) do
                    v:RemoveTag(tag)
                end
                if v:IsA("Model") and v.PrimaryPart and not internal(v.PrimaryPart, model) then
                    v.PrimaryPart = nil
                end
            end
        end
    end
    for _, tag in ipairs(model:GetTags()) do
        model:RemoveTag(tag)
    end
    local root = model:FindFirstChild("HumanoidRootPart")
    local head = model:FindFirstChild("Head")
    local torso = model:FindFirstChild("UpperTorso") or model:FindFirstChild("Torso")
    assert(
        humanoid
            and root
            and head
            and torso
            and root:IsA("BasePart")
            and head:IsA("BasePart")
            and torso:IsA("BasePart"),
        "缺少标准头部/躯干/根部骨架，需游戏专用适配"
    )
    humanoid.AutomaticScalingEnabled = false -- 防止描述重新覆盖游戏自定义体型。
    humanoid.AutoRotate = false
    humanoid.BreakJointsOnDeath = false
    humanoid.RequiresNeck = false
    humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
    humanoid.EvaluateStateMachine = false
    local parts, edges, original = {}, {}, {}
    local originalRoot = root.CFrame
    local function edge(a, b, offset)
        edges[a] = edges[a] or {}
        edges[b] = edges[b] or {}
        table.insert(edges[a], { part = b, offset = offset })
        table.insert(edges[b], { part = a, offset = offset:Inverse() })
    end
    for _, v in ipairs(model:GetDescendants()) do
        if v:IsA("BasePart") then
            table.insert(parts, v)
            original[v] = v.CFrame
            v.Anchored = true
            v.CanCollide = false
            v.CanTouch = false
            v.CanQuery = false
            v.AssemblyLinearVelocity = Vector3.zero
            v.AssemblyAngularVelocity = Vector3.zero
            v.LocalTransparencyModifier = 0 -- 保留 Transparency，隐藏的根部不会显现。
        elseif v:IsA("Bone") then
            v.Transform = CFrame.identity
        end
    end
    -- JointInstance 的 C0/C1 保留角色自身体型。通过图求解中立姿势，
    -- 不只清空 Transform：锚定部件不能依赖下一帧物理求解来更新位置。
    for _, v in ipairs(model:GetDescendants()) do
        if v:IsA("JointInstance") or v:IsA("WeldConstraint") then
            local a, b = v.Part0, v.Part1
            if not internal(a, model) or not internal(b, model) then
                report.removed += 1
                v:Destroy()
            else
                if v:IsA("Motor6D") then
                    v.Transform = CFrame.identity
                end
                local offset = if v:IsA("WeldConstraint")
                    then original[a]:ToObjectSpace(original[b])
                    else v.C0 * v.C1:Inverse()
                edge(a, b, offset)
            end
        end
    end
    root.CFrame = CFrame.identity
    local visited, queue = { [root] = true }, { root }
    local cursor = 1
    while cursor <= #queue do
        local a = queue[cursor]
        cursor += 1
        for _, link in ipairs(edges[a] or {}) do
            if not visited[link.part] then
                visited[link.part] = true
                link.part.CFrame = a.CFrame * link.offset
                table.insert(queue, link.part)
            end
        end
    end
    local body, visible = {}, {}
    for _, part in ipairs(parts) do
        if not visited[part] then
            -- 不冻结游离可见部件的跑跳姿势。隐藏辅助物可留在独立空间。
            assert(part.Transparency >= 0.95, "未连接的可见部件需要适配：" .. part.Name)
            part.CFrame = originalRoot:ToObjectSpace(original[part])
        end
        if part.Transparency < 0.95 and part ~= root then
            if bodyNames[part.Name] and part.Parent == model then
                table.insert(body, part)
            end
            table.insert(visible, part)
        end
    end
    assert(#body >= 2, "可见身体不足，不能可靠取景")
    local bb = boundsOf(body)
    local bodySpan = math.max(bb.maxX - bb.minX, bb.maxY - bb.minY, bb.maxZ - bb.minZ, 0.5)
    local selected = {}
    for _, part in ipairs(visible) do
        local pb = boundsOf({ part })
        local largest = math.max(pb.maxX - pb.minX, pb.maxY - pb.minY, pb.maxZ - pb.minZ)
        local distance = (part.Position - torso.Position).Magnitude
        if largest > bodySpan * 4 or distance > bodySpan * 4 then
            table.insert(report.excluded, part.Name)
            part.Transparency = 1 -- 仅副本排除巨大/远处异常装饰，并在诊断中列明。
        else
            table.insert(selected, part)
        end
    end
    local bounds = boundsOf(selected)
    -- 以躯干下沿附近为裁切起点，优先完整保留头、头饰和肩部。
    local tb = boundsOf({ torso })
    bounds.fitBottom = tb.minY - (tb.maxY - tb.minY) * 0.70
    bounds.backFitBottom = tb.minY - (tb.maxY - tb.minY) * 0.35 -- 侧栏优先头发、肩背和腰部。
    assert(bounds.maxY > bounds.minY, "可见范围无效")
    model.PrimaryPart = root
    model.Name = "SanitizedCharacterClone"
    report.parts = #parts
    report.pose = "neutral-C0-C1; custom animated C0/C1 and skinned meshes need visual QA"
    return { model = model, bounds = bounds, report = report }
end
-- 所有 Prepare 失败都销毁副本；调用者没有半成品需要猜测如何清理。
function Snapshot.FromCharacter(character)
    local copy, reason = Snapshot.Copy(character)
    if not copy then
        return nil, reason
    end
    local ok, result = pcall(Snapshot.Prepare, copy)
    if not ok then
        copy:Destroy()
        return nil, tostring(result)
    end
    return result
end
return Snapshot
