--[[
    一个展示区的专用 Camera / WorldModel / Model。没有玩家监听或账号查询。
    Prepare 先准备未挂载的一组实例；Attach 只在共享管理器的短事务中调用。
    每个展示区独立按 AbsoluteSize 取景，不读取 Camera.ViewportSize。
]]
local Fit = require(script.Parent.AvatarFit)
local Display = {}
Display.__index = Display
function Display.new(id, viewport, label, direction, fov)
    return setmetatable({
        id = id,
        viewport = viewport,
        label = label,
        direction = direction,
        fov = fov,
        visible = false,
        current = nil,
    }, Display)
end
function Display.Fit(record, viewport, direction, fov)
    local size = viewport.AbsoluteSize
    local fit = Fit.Compute(record.snapshot.bounds, size.X, size.Y, fov, direction)
    if not fit then
        return
    end -- 初次布局尚未有尺寸；等 AbsoluteSize 事件，不增加轮询。
    record.camera.CFrame =
        CFrame.lookAt(Vector3.new(fit.x, fit.y, fit.z), Vector3.new(fit.x, fit.y, fit.lookZ))
    record.camera.Focus = CFrame.new(fit.x, fit.y, fit.lookZ)
end
function Display.Dispose(record)
    if not record then
        return
    end
    if record.world then
        record.world:Destroy()
    end
    if record.camera then
        record.camera:Destroy()
    end
    -- Prepare 在挂进 world 之前也可能失败，独立清理该路径持有的 model。
    if record.snapshot then
        record.snapshot.model:Destroy()
    end
end
function Display:Prepare(snapshot, appearanceVersion, source)
    local record = { snapshot = snapshot, appearanceVersion = appearanceVersion, source = source }
    local ok, err = pcall(function()
        assert(self.viewport.Parent ~= nil, "展示控件已移除：" .. self.id)
        record.world = Instance.new("WorldModel")
        record.world.Name = "AvatarWorld_" .. self.id
        record.camera = Instance.new("Camera")
        record.camera.Name = "AvatarCamera_" .. self.id
        record.camera.FieldOfViewMode = Enum.FieldOfViewMode.Vertical
        record.camera.FieldOfView = self.fov
        snapshot.model:SetAttribute("JBS_AppearanceVersion", appearanceVersion)
        snapshot.model:SetAttribute("JBS_AppearanceSource", source)
        snapshot.model:SetAttribute("JBS_AvatarView", self.id)
        snapshot.model.Parent = record.world -- world 此时仍在 DataModel 外。
        Display.Fit(record, self.viewport, self.direction, self.fov)
    end)
    if not ok then
        Display.Dispose(record)
        error(err)
    end
    return record
end
function Display:Attach(record)
    assert(self.viewport.Parent ~= nil, "展示控件在提交前已移除：" .. self.id)
    record.world.Parent = self.viewport
    record.camera.Parent = self.viewport
    self.viewport.CurrentCamera = record.camera
end
function Display:Restore(record)
    -- 不把已被隐藏/销毁流程释放的旧模型重新挂回来。
    local camera = record and record.world.Parent == self.viewport and record.camera or nil
    self.viewport.CurrentCamera = camera
end
function Display:Release()
    local old = self.current
    self.current = nil
    pcall(function()
        self.viewport.CurrentCamera = nil
    end)
    Display.Dispose(old)
end
function Display:Resize()
    if self.visible and self.current then
        Display.Fit(self.current, self.viewport, self.direction, self.fov)
    end
end
function Display:Diagnostics()
    local c = self.current
    return {
        visible = self.visible,
        direction = self.direction,
        appearanceVersion = c and c.appearanceVersion or nil,
        source = c and c.source or "none",
        activeModels = c and 1 or 0,
        worlds = c and 1 or 0,
        cameras = c and 1 or 0,
        modelInstances = c and #c.snapshot.model:GetDescendants() + 1 or 0,
    }
end
return Display
