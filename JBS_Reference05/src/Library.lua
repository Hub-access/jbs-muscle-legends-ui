--[[
    JBS UI 库公开入口。require 本模块只得到接口，不创建窗口、不启动游戏任务。
    CreateWindow：用当前 JBS 外观建立你自己的页面和控件。
    CreateJBS：原样创建当前工程的完整预设，业务仍通过原 Bindings 接入。
    用法统一使用冒号：Library:CreateWindow({Id="MyUI", Title="我的界面"})。
]]
local Library = { Version = "1.0.0" }

function Library:CreateWindow(options)
    return require(script.Parent.LibraryWindow).new(options or {})
end

function Library:CreateJBS(options)
    -- 复用已有入口：保留原有授权、配置、启停、热键和当前玩家正背面展示。
    return require(script.Parent.Runtime).Mount(options or {})
end

return Library
