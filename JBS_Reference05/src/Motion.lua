--[[
    动效管理：基于 Roblox TweenService 平滑改变位置和颜色。
    一个对象同时只允许一个本模块动画；新动画会取消旧动画。
    减少动态时直接设置最终值，仍保留清晰的界面和点击反馈。
]]
local TweenService = game:GetService("TweenService")
local Motion = {}
Motion.__index = Motion
-- 记录当前动画与用户的减少动态偏好。
function Motion.new(reduced)
    return setmetatable({ active = {}, reduced = reduced, dead = false }, Motion)
end
-- 先移除完成事件，再取消动画，防止旧回调覆盖新状态。
function Motion:Cancel(object)
    local entry = self.active[object]
    if entry then
        self.active[object] = nil
        entry.connection:Disconnect()
        entry.tween:Cancel()
        entry.tween:Destroy()
    end
end
-- 把对象属性变到目标值；动画取消不会误触发正常完成回调。
function Motion:To(object, duration, properties, done)
    if self.dead then
        return
    end
    self:Cancel(object)
    if self.reduced then
        for k, v in pairs(properties) do
            object[k] = v
        end
        if done then
            done()
        end
        return
    end
    local tween = TweenService:Create(
        object,
        TweenInfo.new(duration, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
        properties
    )
    local entry = { tween = tween, properties = properties }
    entry.connection = tween.Completed:Connect(function(state)
        if self.active[object] ~= entry then
            return
        end
        self.active[object] = nil
        entry.connection:Disconnect()
        tween:Destroy()
        if not self.dead and state == Enum.PlaybackState.Completed and done then
            done()
        end
    end)
    self.active[object] = entry
    tween:Play()
end
-- 切换为减少动态时，把所有未完成动画立即放到目标位置。
function Motion:SetReduced(value)
    self.reduced = value
    if value then
        local objects = {}
        for object in pairs(self.active) do
            table.insert(objects, object)
        end
        for _, object in ipairs(objects) do
            local properties = self.active[object].properties
            self:Cancel(object)
            for key, value in pairs(properties) do
                object[key] = value
            end
        end
    end
end
-- 返回本模块仍在管理的动画数，供诊断使用。
function Motion:Count()
    local n = 0
    for _ in pairs(self.active) do
        n += 1
    end
    return n
end
-- 结束本模块所有动画并断开完成事件。
function Motion:Destroy()
    if self.dead then
        return
    end
    self.dead = true
    local objects = {}
    for object in pairs(self.active) do
        table.insert(objects, object)
    end
    for _, object in ipairs(objects) do
        self:Cancel(object)
    end
end
return Motion
