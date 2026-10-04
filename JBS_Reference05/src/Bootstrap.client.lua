--[[
    原生 LocalScript 启动文件：放在客户端 StarterPlayerScripts 下。
    同目录 ModuleScript 由 Runtime 组装；脚本被销毁时清理自身界面。
    想修改内容请编辑 src 的模块，单文件发布版由 tools/build.py 自动生成。
]]
-- Studio: insert JBS_Reference05.rbxmx beneath StarterPlayer > StarterPlayerScripts.
local Runtime = require(script.Parent.Runtime)
local app = Runtime.Mount()
if app then
    app.Scope:Connect(script.Destroying, function()
        app.Destroy()
    end)
end
