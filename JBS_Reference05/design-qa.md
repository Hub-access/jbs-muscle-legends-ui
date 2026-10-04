# 当前交付验证状态

本公开仓库只保存当前工程。过去的排版截图、历史样稿和旧版本不随包发布。

## 已完成的检查

- 原生模块、单文件、模型和测试场景来自同一份源码，交付一致性由 `tools/check_stage2_package.py` 检查。
- 离线 UI、正面角色和双视图同步断言通过，当前输出保存在 `evidence/offline-tests.txt`、`evidence/offline-avatar-tests.txt`、`evidence/offline-dual-avatar-tests.txt`。
- 浏览器可以作为独立演示；构建与路由检查记录在仓库根目录 `publication-checks.json`。网页不读取 Roblox 玩家，也不证明原生运行。

## 仍需原生验证

- 尚未获得 Roblox Studio / 客户端的真实截图、交互记录或性能数据。
- 图片资源 ID 仍为空；需由有权限的发布主体上传并配置 `src/Config.lua`，核对图片尺寸和图集裁切。
- 当前游戏业务仍待接线，界面保留“未接入”等真实状态。
- 在原生环境中检查字体、窗口缩放、切页、输入、开关、启停、隐藏恢复和玩家换装/重生后的正背面同步。

查看 [正背面同步说明](第二阶段_正背面同步_说明.md)、[资源清单](第二阶段_资源清单.md) 和 [检查结果](evidence/verification.json)。离线通过不等于原生验收通过。
