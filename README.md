# JBS UI Library · 力量传奇

**The Best Clan In Muscle Legend**

可复用的 Roblox 原生 Luau UI 库：粉紫金属外观、自定义页面与控件、当前玩家正背面展示、中文注释。保留当前完整 JBS 预设和浏览器演示；只维护当前工程，不放旧项目或历史压缩包。

## 作为 UI 库使用

- [UI 库单文件源码](JBS_UI.lua) · [Studio 导入模块](JBS_UI.rbxmx)
- [中文接口与接入文档](UI库使用说明.md)
- [完整注释示例](examples/QuickStart.client.lua) · [Studio 演示场景](examples/JBS_UI_Demo.rbxlx)
- [当前完整 JBS 预设接入](examples/ExistingJBS.client.lua)

将 `JBS_UI.rbxmx` 导入 `ReplicatedStorage`，在客户端 LocalScript 中调用：

```lua
local UI = require(game:GetService("ReplicatedStorage"):WaitForChild("JBS_UI"))
local Window, created = UI:CreateWindow({Id = "MyJBS", Title = "JBS · 我的界面"})
if not Window or not created then return end
local Main = Window:Tab({Title = "主要", Columns = 3})
Main:Toggle({Title = "自动锻炼", Default = false, Callback = function(enabled)
    print(enabled) -- 在这里绑定你自己的业务
end})
```

加载库本身不会创建窗口或启动任务。支持 Toggle、Button、Input、Dropdown、Slider、Label、Section、Divider；值更新、禁用、通知和销毁都有独立接口。需要完整当前界面时调用 `UI:CreateJBS(options)`，继续使用原有 `Bindings`。

## 下载与打开

- [下载整个工程 ZIP](https://github.com/Hub-access/jbs-muscle-legends-ui/archive/refs/heads/main.zip)
- [VS Code 中文工作区](JBS_中文注释工程.code-workspace)
- [Roblox Studio 场景](JBS_Reference05/JBS_Reference05.rbxlx)
- [可导入模型](JBS_Reference05/JBS_Reference05.rbxmx) · [单文件 LocalScript](JBS_Reference05/JBS_Reference05.client.lua) · [模块源码](JBS_Reference05/src/)

原生三个入口选择一种，不要同时安装。Studio 使用 **Play**；模块放在 `StarterPlayer > StarterPlayerScripts`。正常入口不运行测试脚本。

## 当前功能与完成状态

主横幅正面与左下角背面优先读取当前 `LocalPlayer.Character`，共享同一版外观、分别使用自己的模型和相机。账号外观仅作为明确标记的备用。保留三栏框架、原有名称、控件与业务接线边界。

| 项目 | 状态 |
| --- | --- |
| 原生界面和正背面同步代码 | 已实现，中文注释模块齐全 |
| 离线检查 | 库117项、UI364项、正面210项、双视图187项通过 |
| 浏览器演示 | 保持现有演示；此前构建和4项路由测试通过，不代表本库原生验证 |
| Roblox 原生实测 | 待验证，没有原生截图或真实帧率结论 |
| 图片资源 | 本地素材齐全；真实资源ID、上传权限和原生加载待验证 |
| 实际游戏业务 | 当前包仍待接线，保持明确“未接入”状态 |

公开发布代码不会自动完成 Roblox 图片上传，也不会把浏览器预览变成原生验证。

## 说明与维护

- [中文代码导览](JBS_Reference05/先读我_代码导览.md)
- [正背面同步与原生验收步骤](JBS_Reference05/第二阶段_正背面同步_说明.md)
- [图片资源清单](JBS_Reference05/第二阶段_资源清单.md) · [集中资源配置](JBS_Reference05/src/Config.lua)
- [浏览器演示启动说明](JBS_DynamicPreview/README.md)
- [本次发布检查](publication-checks.json) · [文件校验表](SHA256SUMS)

修改 `JBS_Reference05/src/` 后运行 `python3 JBS_Reference05/tools/build.py` 更新 UI 库、单文件、模型与示例场景。原生测试入口 `NativeDualAvatarQA` 默认禁用，只在 Studio 测试场景手动启用。

素材来源与生成式编辑记录在 `JBS_Reference05/assets/source/`；参考图不是恢复出的原始分层，也没有把账号页面或固定作者外观写入自动角色来源。未代替原始素材作者添加授权协议。
