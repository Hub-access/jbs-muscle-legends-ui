# JBS 力量传奇 UI

**The Best Clan In Muscle Legend**

当前独立公开工程：Roblox 原生 Luau 界面、当前玩家正背面角色展示、中文注释、所需素材及浏览器演示。仓库只含当前版本，不包含旧项目、历史压缩包或旧源码备份。

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
| 离线检查 | UI 364项、正面210项、双视图187项通过 |
| 浏览器演示 | 构建和4项路由测试通过，所有游戏动作仅为演示 |
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

修改 `JBS_Reference05/src/` 后运行 `python3 JBS_Reference05/tools/build.py` 更新单文件、模型与场景。原生测试入口 `NativeDualAvatarQA` 默认禁用，只在 Studio 测试场景手动启用。

素材来源与生成式编辑记录在 `JBS_Reference05/assets/source/`；参考图不是恢复出的原始分层，也没有把账号页面或固定作者外观写入自动角色来源。未代替原始素材作者添加授权协议。
