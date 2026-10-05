-- 保留当前完整 JBS 界面和所有既有名称，不必手工重建页面。
-- JBS_UI.rbxmx 先导入 ReplicatedStorage；本文件放 StarterPlayerScripts。
local Library = require(game:GetService("ReplicatedStorage"):WaitForChild("JBS_UI"))
local app, message = Library:CreateJBS({
    Config = {
        Hotkey = Enum.KeyCode.RightShift,
        AssetIds = {}, -- 填写你上传并有权使用的真实图片 ID。
    },
    -- Bindings = require(你的业务模块),
    -- 接口保持原有 BusinessBindings 约定，包括 LoadState/SaveState、Tasks、Controls 与授权。
    -- 不传 Bindings 时明确显示“未接入”，不会假装已连接或自动运行。
})
if not app then warn(message); return end
script.Destroying:Connect(function() app.Destroy() end)
