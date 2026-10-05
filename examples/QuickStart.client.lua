--[[
    放在 StarterPlayer > StarterPlayerScripts 的 LocalScript 示例。
    先把仓库根目录 JBS_UI.rbxmx 导入 ReplicatedStorage（得到 JBS_UI ModuleScript）。
    示例只更新界面和打印选择，不执行购买、传送、训练，也不替代服务端权限校验。
]]
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Library = require(ReplicatedStorage:WaitForChild("JBS_UI"))

-- 同一个 Id 再次创建会恢复已有窗口；created=false 时不要重复添加控件。
local Window, created = Library:CreateWindow({
    Id = "JBS_Example",
    Title = "JBS · 我的界面",
    Hotkey = Enum.KeyCode.RightShift, -- 输入文字时不会吞掉快捷键。
    AvatarPreview = {Enabled = true, BackEnabled = true}, -- 当前玩家正面 + 背面。
    AssetIds = {}, -- 图片上传后填入真实 rbxassetid://...；空表显示原生降级外观。
})
if not Window or not created then return end

-- Columns=3 是桌面三列卡片；较窄时自动改成两列或一列，字号不一起缩小。
local Home = Window:Tab({Id = "home", Title = "主要", Columns = 3})
Home:Toggle({Id = "train", Title = "自动锻炼", Description = "示例：只保存选择", Default = false,
    Callback = function(enabled)
        print("选择自动锻炼：", enabled)
        -- 这里接你自己的合法游戏逻辑。界面库本身不会创建自动训练循环。
    end})
Home:Toggle({Id = "rebirth", Title = "自动重生", Description = "示例：只保存选择", Default = false})
Home:Toggle({Id = "spin", Title = "自动轮盘", Description = "示例：只保存选择", Default = false})
Home:Button({Title = "传送地点", ButtonText = "打开传送页", Callback = function() Window:SelectTab("teleport") end})
Home:Button({Title = "宠物商店购买", ButtonText = "打开宠物页", Callback = function() Window:SelectTab("pets") end})
Home:Button({Title = "Boss", ButtonText = "显示说明", Callback = function() Window:Notify("Boss 业务由你的代码接入") end})
Home:Input({Id = "targetRebirths", Title = "目标次数", Description = "0 为无限；含义由你的业务读取",
    Numeric = true, Integer = true, Min = 0, Default = 0})

local Teleport = Window:Tab({Id = "teleport", Title = "传送"})
-- 此处演示两个已有名称。完整当前功能清单仍在 JBS_Reference05/catalog/PreviousUI.json。
-- 若要直接使用当前所有功能名称、地点、宠物和原接线，请看 ExistingJBS.client.lua。
local Destination = Teleport:Dropdown({Id = "destination", Title = "传送地点",
    Options = {{Id = "lobby", Label = "大厅"}, {Id = "island", Label = "小岛"}}, Default = "lobby"})
Teleport:Button({Title = "传送", ButtonText = "读取选择", Callback = function()
    Window:Notify("示例选择：" .. tostring(Destination:Get()) .. "；未执行传送")
end})

local Pets = Window:Tab({Id = "pets", Title = "宠物"})
local Pet = Pets:Dropdown({Id = "pet", Title = "宠物商店购买", Description = "示例选项，不代表当前商店库存",
    Options = {"地狱火龙"}})
Pets:Button({Title = "刷新宠物列表", ButtonText = "更新示例选项", Callback = function()
    Pet:SetOptions({"地狱火龙"}) -- 每次刷新会清理旧选项事件；仍存在的选择会保留。
end})
Pets:Label({Title = "接入方式", Description = "由你的业务提供真实宠物列表与购买回调。"})

local Settings = Window:Tab({Id = "settings", Title = "设置"})
Settings:Section("常用控件示例")
Settings:Slider({Id = "exampleValue", Title = "示例数值", Description = "鼠标/触摸拖动，或直接输入数值",
    Min = 0, Max = 100, Step = 5, Default = 50})
Settings:Divider()
Settings:Input({Id = "note", Title = "备注", Placeholder = "输入你的文字", Default = ""})

-- 右侧设置区和普通页面使用同一套控件接口。
Window:Sidebar():Toggle({Title = "减少动态", Default = false,
    Callback = function(enabled) Window:SetReducedMotion(enabled) end})
Window:Sidebar():Label({Title = "当前状态", Description = "演示界面，游戏业务未接入"})

Window:SetActions({
    Start = function(values)
        print("开始按钮读取的选择：", values.train, values.targetRebirths)
        Window:SetStatus("script", {Title = "演示已开始", Detail = "没有执行游戏操作", Badge = "演示"})
    end,
    Stop = function()
        Window:SetStatus("script", {Title = "演示已停止", Detail = "没有执行游戏操作", Badge = "演示"})
    end,
})
Window:OnDestroy(function()
    -- 如果你的代码拥有事件或任务，可在这里自行停止/断开。库只清理它自己创建的资源。
    print("JBS 示例窗口已销毁")
end)
script.Destroying:Connect(function() Window:Destroy() end)

-- 后续修改示例：
-- Destination:Set("island")       -- 静默更新，不触发业务回调。
-- Destination:Set("island", true) -- 更新并触发 Callback。
-- Pet:SetEnabled(false)           -- 禁用一个控件。
-- Window:Hide() / Window:Show()    -- 隐藏/恢复，不代表停止业务。
-- Window:Destroy()                -- 彻底释放本窗口。
