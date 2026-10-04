--[[
    资源清理箱：记录本界面创建的连接、实例或清理函数。
    Add 放入资源；Connect 绑定并登记事件；Destroy 统一释放。
    只清理本模块拥有的资源，避免影响游戏里的其他界面或脚本。
]]
local Cleanup = {}
Cleanup.__index = Cleanup
-- 为一次界面实例建立独立的资源清单。
function Cleanup.new()
    return setmetatable({ items = {}, dead = false }, Cleanup)
end
-- 登记需要清理的资源；已经销毁后禁止继续添加。
function Cleanup:Add(item)
    if self.dead then
        error("Cannot attach to disposed UI")
    end
    table.insert(self.items, item)
    return item
end
-- 建立一次监听，同时登记它的所有权，避免漏断开。
function Cleanup:Connect(signal, callback)
    return self:Add(signal:Connect(callback))
end
-- 统计仍连接的事件，用于反复操作后的泄漏检查。
function Cleanup:Count()
    local n = 0
    for _, v in ipairs(self.items) do
        if typeof(v) == "RBXScriptConnection" and v.Connected then
            n += 1
        end
    end
    return n
end
-- 逆序清理；一个资源清理出错也继续释放剩余资源。
function Cleanup:Destroy()
    if self.dead then
        return
    end
    self.dead = true
    for i = #self.items, 1, -1 do
        local v = self.items[i]
        local ok, err = pcall(function()
            if type(v) == "function" then
                v()
            elseif typeof(v) == "RBXScriptConnection" then
                v:Disconnect()
            else
                v:Destroy()
            end
        end)
        if not ok then
            warn("JBS cleanup:", err)
        end
    end
    table.clear(self.items)
end
return Cleanup
