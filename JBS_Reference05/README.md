> UI 库入口已提供：[单文件](../JBS_UI.lua)、[导入模块](../JBS_UI.rbxmx)、[中文文档](../UI库使用说明.md)。以下是当前完整预设的说明；自定义页面使用 `CreateWindow`，当前预设使用 `CreateJBS`。

# JBS 图五 · Roblox 原生 Luau 工程

## 当前更新：当前玩家正背面同步，第二阶段代码交付

英文 **The Best Clan In Muscle Legend** 保持原样。主横幅正面和左下角背面共用当前玩家的一次外观来源，各自持有独立的三维展示模型与相机。

**第二阶段代码及离线检查完成，原生和资源接入仍待验证。** 先读 [第二阶段接入与验收说明](第二阶段_正背面同步_说明.md) 和 [正背面资源清单](第二阶段_资源清单.md)。实际重新执行的三套离线检查为364/210/187项；本机没有可用 Studio，会话中没有原生截图或帧率测量。浏览器仍是静态人物演示，不读取 Roblox 账号。

本轮保留已通过排版、既有功能和未提交工作。游戏业务没有在当前包接线，原有“未接入”状态不变。本公开仓库只分发当前版本；当前行为以第二阶段说明为准。

## 本次更新：旧版名称与中文注释

先读 [中文代码导览](先读我_代码导览.md)。已按上一版「JBS 粉紫暗铬」源码对齐 29 个操作控件、14 个地点和 49 项宠物/光环兜底名称，补回目标次数、购买、Boss、换包、快速锻炼、吃蛋和送蛋字段。旧游戏源码保持原样；这里未执行它的业务。相邻目录提供独立的 Chrome 动态预览，浏览器证据不代表原生运行。

## 运行

1. 在 Roblox Studio 打开 `JBS_Reference05.rbxlx`，按 **Play**。也可将 `JBS_Reference05.rbxmx` 导入已有工程的 `StarterPlayer > StarterPlayerScripts`。
2. `Bootstrap` 是 LocalScript，默认创建到 `LocalPlayer.PlayerGui`。原生切页、参数选择、窗口控制和动效设置可操作；游戏动作须接线。
3. 首次运行没有已上传图片 ID，将显示清楚标注的美术缺失界面。**这不是视觉完成状态。** 上传下表所需 PNG，并将实际图片资源 ID 填入 `Config.AssetIds`，才可显示完整素材。
4. 现有业务通过 `BusinessBindings` 注入。默认业务开关禁用并显示“未接入”，开始按钮不会假装运行。

三个入口任选一个，不要同时安装：

| 文件 | 用途 |
| --- | --- |
| `JBS_Reference05.rbxlx` | 可供 Studio 打开的本地测试场景；未在 Studio 中打开验证 |
| `JBS_Reference05.rbxmx` | 含 Bootstrap 和全部模块的模型；放入 StarterPlayerScripts |
| `JBS_Reference05.client.lua` | 同源构建的单文件 LocalScript，适合直接粘贴到 Studio LocalScript |

编辑模块后运行 `python3 tools/build.py` 重新生成模型与单文件。单文件里的配置也是生成副本；建议修改 `src/Config.lua` 后重建。Rojo 用户可使用 `default.project.json`，本机未运行 Rojo。

## 素材接入

所有资源 ID 当前为空，**没有真实 Roblox 上传或权限验证**。下列名称对应 `src/Config.lua` 的 `AssetIds` 键。填入你有权限使用的真实 `rbxassetid://...` 图片 ID，并在目标体验确认加载权限。代码只允许这种形式的非零 ID；它不会将 PNG 本地路径写进 Roblox 图片字段。

| 键 | 本地 PNG | 像素尺寸 | 运行时接入 |
| --- | --- | --- | --- |
| logo_jbs | assets/logo_jbs.png | 237 × 150 | 待上传、待验证 |
| hero_banner | assets/hero_banner.png | 2119 × 742 | 关闭自动角色时的旧横幅，待上传 |
| hero_clean | assets/hero_clean.png | 2116 × 743 | 自动角色无人物底图，待上传、待原生验证 |
| sidebar_art | assets/sidebar_art.png | 248 × 245 | 显式关闭背面时的旧装饰，待上传 |
| sidebar_clean | assets/sidebar_clean.png | 1254 × 1254 | 自动背面无人物底图，待上传、待验证 |
| control_art | assets/control_art.png | 269 × 154 | 待上传、待验证 |
| frame_atlas | assets/frame_atlas.png | 1024 × 512 | 待上传、待验证 |
| icon_atlas | assets/icon_atlas.png | 512 × 640 | 待上传、待验证 |

`assets/manifest.json` 给出来源裁切坐标、尺寸、哈希、图标矩形、边框转角与接入状态；`src/AssetData.lua` 为其生成映射。边框使用 8 个分片：4 个固定转角、4 条单轴伸缩边，中心透明。切片参数不依赖有歧义的图集九宫格坐标。横幅和独立品牌图使用等比 Fit；图标保持比例、默认平滑采样。

素材来自用户提供的扁平图五。`reference/JBS_reference_05.png` 保留原图；`tools/prepare_assets.py` 与 `assets/source/crop-recipe.json` 是可编辑拆分来源，**不代表恢复了原始分层**。所有功能文字、状态、身份、开关与按钮都由原生控件创建。边框中间的原有文字和控件已清除。图标从原图提取浅色轮廓，停止图标单独保留亮粉轮廓。

旧裁片保留来源记录；横幅文字局部编辑和无人物底图为生成式编辑，manifest 标明真实尺寸与哈希，不属于原始分层。2560 × 1440 会放大原始艺术像素，锐度上限来自附件；严格高密度验收仍需要更高分辨率原素材。Roblox 上传可能改变图片尺寸，上传后须核对图集原始尺寸并在实际显示密度下检查。

## 业务接入契约

编辑 `src/BusinessBindings.lua`，仅包装已有函数。默认 `Tasks`、`Actions`、`Controls` 都为空。

- `Tasks[id].Start(context)` 启动一个已有任务，返回一个可重复调用、仅清理自己资源的函数。ID 包含 `rebirth/train/spin/petbuy/boss/packrebirth/fasttrain/eategg`。
- `Start` 若让出执行权，每次恢复必须检查 `context.Cancelled`；取消后仍返回清理函数。若启动本身抛错，业务适配负责清理尚未返回的部分资源。后台错误通过 `context.ReportError(message)` 上报。
- `Actions[page]` 含真实 `Options = {{Id=..., Label=...}}` 以及 `Perform(id, context)`；当前传送使用 page `teleport`；保留选择类操作接口供现有接线兼容。UI 拒绝不在当前选项里的 ID。
- `Controls.buyPet(parameters, context)` 和 `Controls.giftEggs(parameters, context)` 对应购买一次、送蛋。参数包含 `pet/eggTarget/giftAmount`。持续任务通过 `context.Parameters/Choices` 读取本次启动快照。
- `GetOptions(page)` 只读宠物商店和同服玩家；没有商店时用旧版宠物兜底，没有玩家时保持空列表。
- `GetEnvironment()` 返回真实 `Title/Detail/Badge/Kind`；`Kind` 为 `good/error/neutral`。没有适配时，Studio 显示本地环境；其他地方显示实际 PlaceId 和“未确认”。`Config.TargetPlaceIds` 默认空，必须由集成人填写经核实的目标。
- `GetIdentity(player)` 可返回真实 `Name/Tag`。没有授权数据时使用玩家 DisplayName 和“普通用户”。本地版本来自 `Config.Version`，不会宣称“最新”。
- `Changed` 可提供只读状态变化信号。环境和身份读取应同步、只读，不执行游戏动作。
- `LoadState/SaveState` 可接入已有持久化。默认只在 PlayerGui 属性内保留页面、选项、动效与尺寸，**不跨退出游戏保存**。没有客户端 DataStore 或执行器文件接口。

运行中修改功能选择会保存为下一次开始使用的配置，并显示提示。开始使用当次选择快照，重复开始不创建额外任务。停止只清理本脚本拥有的任务；清理失败会进入错误并阻止再次启动，直到重试停止成功。一次性操作也会接收到停止/销毁的取消信号，但已经完成的外部动作不能自动撤销。

关闭和最小化都只隐藏界面，保留可见“恢复 JBS”按钮，不自动停止业务。单独销毁角色模块只释放展示；整个 UI 最终销毁调用 `app.Destroy()`；会取消自己的连接、Tween、加载任务，并执行自己持有的业务清理。违反清理契约的业务会明确报错，不能承诺替它清理未知资源。

默认不添加热键。需要时设置 `Config.Hotkey`；文本框获得焦点或输入已处理时不会抢占按键。

## 结构

`Bootstrap.client.lua` 入口；`Runtime.lua` 挂载/去重/持久化；`Config.lua` 配置；`Theme.lua` 尺寸/颜色；`Assets.lua` 资源状态；`AssetData.lua` 素材映射；`Components.lua` 原生控件；`View.lua` 三栏与页面；`Controller.lua` 生命周期；`LegacyPages.lua` 旧版功能页；`LegacyCatalog.lua` 生成的共用名称清单；`Motion.lua` 可取消动画；`Cleanup.lua` 连接清理；`BusinessAdapter.lua` 和 `BusinessBindings.lua` 接入边界。

所有页面创建一次、事件绑定一次。没有动画水印墙、CanvasGroup、远程加载器、执行器 API 或永久扫光循环。主横幅正面与侧栏背面共用事件驱动的静态 3D 外观来源，不逐帧复制动作。页面进入、开关、悬停、窗口使用可取消 Tween；减少动态时保留相同素材与布局。原生 `Activated` 支持鼠标、触摸和选中控件确认；拖动仅绑定标题空白区，窗口按钮不在拖动范围内。

## 验证与证据

- `evidence/offline-tests.txt`：真实 Luau 执行器上的离线 API 替身测试日志，不是 Roblox 运行。
- `evidence/verification.json`、`evidence/stage2-report.json`：机器可读验收边界与本轮结果。
- `evidence/offline-dual-avatar-tests.txt`：第二阶段双视图实际离线日志；不是原生测试。
- `tests/NativeDualAvatarQA.client.lua`：当前正背面原生测试入口，场景内默认禁用；旧 NativeAvatarQA 仅测试正面。
- `tests/NativeQA.client.lua`：待在 Studio 手动启用的测试脚本，明确使用“演示数据”。正常入口不运行它。脚本记录实例/连接增长及静态、动效、减少动态的帧间隔；需要另做指针、触摸、键盘与截图验收。
- `design-qa.md`：原生视觉结论为 blocked，说明资源与环境缺口。

本机已安装 Roblox 客户端，但未发现 Roblox Studio，也没有可控制的原生测试会话。因此原生截图/录屏、字体回退、触摸手感、图集加载、GPU/帧耗时和真实游戏效果均未验证。不得用推演图、模拟连接数或编译通过代替这些证据。

下一步：填写所需真实资源 ID，在 Studio Play 中运行入口及默认禁用的 NativeDualAvatarQA，保存正背面原生截图、四种模式性能与30次显隐记录。代码完成不等于原生已验收；第二阶段交付后等待用户确认。

## 官方接口核对

[Luau](https://create.roblox.com/docs/luau) · [ImageLabel 图集与平滑采样](https://create.roblox.com/docs/reference/engine/classes/ImageLabel) · [九宫格边角规则](https://create.roblox.com/docs/ui/9-slice) · [UIGradient](https://create.roblox.com/docs/reference/engine/classes/UIGradient) · [尺寸约束](https://create.roblox.com/docs/ui/size-modifiers) · [Tween 完成/取消状态](https://create.roblox.com/docs/reference/engine/classes/TweenBase) · [资源预加载](https://create.roblox.com/docs/reference/engine/classes/ContentProvider) · [MicroProfiler](https://create.roblox.com/docs/performance-optimization/microprofiler)。
