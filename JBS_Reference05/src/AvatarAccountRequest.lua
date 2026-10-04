--[[
    同一模块包内、同一 UserId 至多一个进行中的账号请求。
    UI 销毁只取消订阅；引擎返回时没有订阅者就销毁模型。
    再次 Mount 可接住已有请求，避免网络很慢时反复开关/重建积累请求。
    本模块不缓存完成的账号模型，也不保存 UI/Character 引用。
]]
local Request = {}
local pending = {}
function Request.Subscribe(userId, fetch, callback)
    local entry = pending[userId]
    local start = entry == nil
    if start then
        entry = { listeners = {} }
        pending[userId] = entry
    end
    entry.listeners[callback] = true
    local function unsubscribe()
        entry.listeners[callback] = nil
    end
    if start then
        task.spawn(function()
            local ok, result = pcall(fetch, userId)
            pending[userId] = nil
            local listeners = {}
            for listener in pairs(entry.listeners) do
                table.insert(listeners, listener)
            end
            table.clear(entry.listeners)
            -- 正背面共享管理器正常只有一个订阅者；多个测试容器也不能反复搬动同一个 Model。
            for index, listener in ipairs(listeners) do
                local value, success = result, ok
                if ok and index < #listeners then
                    local copied, clone = pcall(function()
                        return result:Clone()
                    end)
                    success = copied and clone ~= nil
                    value = success and clone or "备用模型无法复制"
                end
                local delivered, problem = pcall(listener, success, value)
                if not delivered then
                    if success and value then
                        value:Destroy()
                    end
                    warn("JBS avatar subscriber:", problem)
                end
            end
            if #listeners == 0 and ok and result then
                result:Destroy()
            end
        end)
    end
    return unsubscribe
end
function Request.PendingCount()
    local count = 0
    for _ in pairs(pending) do
        count += 1
    end
    return count
end
return Request
