--[[
    游戏接线入口：界面的按钮通过这里调用你原有的功能模块。

    这次只对齐旧 UI 的名称、字段和参数，没有复制或执行旧版 Game.lua 的循环。
    Tasks / Controls 默认留空，因此原生界面会诚实显示“未接入”。
    下方 GetOptions 只读取商店名字和在线玩家名字，不发送任何游戏请求。

    持续任务 Tasks 的八个稳定键：
      rebirth 自动重生；train 自动锻炼；spin 自动轮盘；petbuy 自动购买；
      boss 自动打Boss；packrebirth 换包重生；fasttrain 快速锻炼；eategg 自动吃蛋。

    接线形式（请用实际业务模块替换示意名字，不要直接取消注释运行）：
      Tasks.train = { Start = function(context)
          -- context.Parameters.targetRebirths 是目标次数。
          -- context.Choices.pets 是选中的宠物/光环。
          -- 调用自己的业务模块，并返回只停止该任务的函数。
          return yourTrainingModule.start(context)
      end }
    Start 必须返回可重复调用的停止函数；每次等待后检查 context.Cancelled。
    启动失败要清理已创建资源；后台错误通过 context.ReportError 通知界面。

    一次性按钮：
      Controls.buyPet(parameters, context)：读取 parameters.pet。
      Controls.giftEggs(parameters, context)：读取 eggTarget 和 giftAmount（0 为全部）。
      Actions.teleport = {Options={{Id="大厅",Label="大厅"}}, Perform=function(id,context)...end}
    接线后应保留原有协议、频率和坐标；这里不会猜测 RemoteEvent 参数。
]]
local Bindings = {
    Tasks = {},
    Controls = {},
    Actions = {},
}

-- 宠物名称优先来自和旧 UI 相同的商店目录；返回 nil 时适配器使用旧版 49 项兜底。
-- 玩家列表没有兜底假名字；必须是真正处在同一服务器中的其他玩家。
function Bindings.GetOptions(page)
    local options = {}
    if page == "pets" then
        local storage = game:GetService("ReplicatedStorage")
        local shared = storage:FindFirstChild("shared")
        local runtime = shared and shared:FindFirstChild("runtime")
        local shop = runtime and runtime:FindFirstChild("cPetShopFolder")
        if shop then
            for _, item in ipairs(shop:GetChildren()) do
                table.insert(options, { Id = item.Name, Label = item.Name })
            end
        end
        if #options == 0 then
            return nil
        end
    elseif page == "eggTargets" then
        local players = game:GetService("Players")
        for _, player in ipairs(players:GetPlayers()) do
            if player ~= players.LocalPlayer then
                table.insert(options, { Id = player.Name, Label = player.Name })
            end
        end
    else
        return nil
    end
    table.sort(options, function(a, b)
        return a.Label < b.Label
    end)
    return options
end

-- 可选扩展：GetEnvironment / GetIdentity 提供可信的运行环境和身份。
-- LoadState / SaveState 可接入现有存储；不提供时只在当前 PlayerGui 会话保存。
-- Changed 可传入原业务的只读变化信号，界面收到后刷新显示。
return Bindings
