# JBS UI 库 · 中文接入说明

`JBS_UI.lua` 返回一个可复用的 `Library`。加载它不会创建界面、读取玩家外观或启动游戏任务。调用 `CreateWindow` 才建立窗口；调用 `CreateJBS` 才建立当前完整 JBS 预设。

外观复用本工程的粉紫颜色、切角金属面板、图片资源、中文控件和当前玩家正背面展示。库不包含购买、训练、传送或授权绕过逻辑；游戏行为由你传入的回调处理。

## 1. 在 Roblox Studio 中使用

1. 下载根目录 `JBS_UI.rbxmx`，导入到 `ReplicatedStorage`。导入后应看到名为 `JBS_UI` 的 **ModuleScript**。模型里没有会自动运行的 LocalScript。
2. 在 `StarterPlayer > StarterPlayerScripts` 添加 **LocalScript**，复制下方示例或 `examples/QuickStart.client.lua`。
3. 点击 **Play**。UI 库使用当前客户端的 `LocalPlayer`。

也可以直接打开 `examples/JBS_UI_Demo.rbxlx`，其中已经放好库和示例。该场景是待实机验收的接入示例，不是已经验证的原生效果截图。

```lua
local Library = require(game:GetService("ReplicatedStorage"):WaitForChild("JBS_UI"))

local Window, created = Library:CreateWindow({
    Id = "MyJBS",                   -- 同一父容器下唯一的窗口标识
    Title = "JBS · 我的界面",
    Hotkey = Enum.KeyCode.RightShift,
    AvatarPreview = {Enabled = true, BackEnabled = true},
})
if not Window or not created then return end -- 防止重复添加相同的页面和控件

local Main = Window:Tab({Id = "main", Title = "主要", Columns = 3})
local Training = Main:Toggle({
    Id = "training",
    Title = "自动锻炼",
    Description = "在回调里接入你的业务",
    Default = false,
    Callback = function(enabled, control)
        print(enabled, control.Id) -- 这里目前只打印，没有游戏操作
    end,
})

Main:Button({Title = "查看状态", ButtonText = "显示", Callback = function()
    Window:Notify({Title = "当前选择", Content = tostring(Training:Get())})
end})
```

普通 Roblox 客户端使用 `require(ModuleScript)`。GitHub Raw 地址提供的是源码，不是 Roblox 图片 ID 或可在客户端 `require(数字ID)` 的发布资源。不要把普通 LocalScript 的加载方式写成依赖第三方执行环境的远程 `loadstring`。

原生脚本位置与模块机制参见 [Roblox 官方模块文档](https://create.roblox.com/docs/scripting/module) 和 [脚本类型与运行位置](https://create.roblox.com/docs/scripting/locations)。

## 2. 创建窗口

```lua
Library:CreateWindow(options) --> Window, createdOrMessage
```

| 参数 | 含义 / 默认值 |
| --- | --- |
| `Id` | 默认 `JBS_UI`。1–64 个英文字母、数字、下划线或连字符；同父容器不能重复 |
| `Title` | 顶栏标题，默认 `JBS · MUSCLE LEGENDS` |
| `Parent` | 默认当前玩家 `PlayerGui`；通常不用传 |
| `Hotkey` | 可选 `Enum.KeyCode`，默认不监听快捷键；输入文字时不触发 |
| `AssetIds` | 真实资源映射，和当前工程 `Config.AssetIds` 使用相同键；默认空 ID |
| `AvatarPreview` | 默认启用当前玩家正背面；`false` 关闭，或传 `{Enabled=true, BackEnabled=false}` 仅保留正面 |
| `ReducedMotion` | `true` 时直接应用状态，不播放现有渐变动画；默认 `false` |
| `DisplayOrder` | ScreenGui 显示层级，默认 50 |
| `SettingsTitle` / `ControlsTitle` | 右栏/底部标题，默认“脚本设置”/“脚本控制” |
| `Footer` / `UserTag` | 页脚和用户卡说明；不会自动推断会员或授权状态 |
| `OnStart` / `OnStop` | 底部按钮回调，可稍后用 `SetActions` 绑定；默认禁用对应按钮 |

同一个已加载的库、同一个 `Parent + Id` 再次调用会返回原 `Window, false` 并恢复它。若另一份独立加载的库已经占用相同 Id，则返回 `nil, 提示` 并尝试恢复现有窗口，不销毁任何其他窗口。不同 Id 可以并存，状态互不串用。

默认桌面三栏；较窄时上下排列，内容可以滚动，不把整页字号一起缩小。普通屏幕的最终字形、触摸和边缘仍需 Studio 实测。

## 3. 页面与右侧设置

```lua
local Main = Window:Tab({Id = "main", Title = "主要", Columns = 3})
local Pets = Window:Tab({Id = "pets", Title = "宠物"}) -- 默认 1 列
local Right = Window:Sidebar()                      -- 右侧，固定 1 列

Window:SelectTab("pets")
Window:RemoveTab("pets") -- 或 Pets:Destroy()
```

`Columns` 支持 1、2、3；可用宽度不足时自动减少列数。`Section` 与 `Divider` 横跨当前页。页面和右栏共用下面的控件方法。删除页面会一并清理它的控件、导航事件和图片订阅。

## 4. 通用控件

共有参数：`Id`、`Title`、`Description`、`Disabled`、`Visible`。`Id` 在整个窗口内唯一；不提供时自动生成。标题和说明是正常字号的独立区域；操作区不压进文字区。

| 创建方法 | 专属参数 | Callback 收到什么 |
| --- | --- | --- |
| `Tab:Toggle({...})` | `Default` 布尔值，默认 false | `value, control` |
| `Tab:Button({...})` | `ButtonText` 默认“执行”；`Primary=true` 高亮 | `control` |
| `Tab:Input({...})` | `Default`、`Placeholder`；`Numeric=true`、`Integer=true`、`Min`、`Max` | `value, control` |
| `Tab:Dropdown({...})` | `Options`、`Default`、`Placeholder` | 选项的 `Id, control`，或清空时 nil |
| `Tab:Slider({...})` | `Min` 默认 0、`Max` 默认 100、`Step` 默认 1、`Default` | `number, control` |
| `Tab:Label({...})` | `Title`、`Description` | 无 |
| `Tab:Section("分类标题")` | 也可传 `{Title, Description}` | 无；是分组标题，不是嵌套容器 |
| `Tab:Divider()` | 无 | 无 |

输入框在失去焦点时提交。数值输入拒绝 NaN、无穷和非数值文本，按范围限制；整数模式向下取整，并将边界调整到有效整数范围。滑块拖动只更新预览，松开时提交一次；也可直接输入，或选中滑块后按左右/Home/End。

下拉选项支持字符串，或 `{Id="稳定标识", Label="显示名称"}`。稳定 Id 和显示名称可以不同，回调始终接收 Id。

```lua
local Destination = Main:Dropdown({
    Id = "destination",
    Title = "传送地点",
    Options = {{Id = "lobby", Label = "大厅"}, {Id = "island", Label = "小岛"}},
    Default = "lobby",
    Callback = function(id)
        -- 由你的业务检查权限、解析地点、决定是否执行。
        -- return false, "当前不可用" 可以拒绝选择并回滚。
        print(id)
    end,
})

Destination:SetOptions({{Id = "lobby", Label = "大厅"}})
-- 原选择仍存在就保留；被移除则清空。刷新选项默认不会调用 Callback。
```

控件返回对象提供：

| 方法 | 行为 |
| --- | --- |
| `control:Get()` | 读取当前值；Button/Label 等无值控件为 nil |
| `control:Set(value)` | 静默更新有值控件；不会启动业务 |
| `control:Set(value, true)` | 更新并执行 Callback；相同值不重复执行 |
| `control:SetEnabled(bool)` | 禁用/恢复交互；禁用仍允许调用者静默更新值 |
| `control:SetVisible(bool)` | 显隐并重新分配空间 |
| `control:SetTitle(text)` / `SetDescription(text)` | 更新文案与换行高度 |
| `dropdown:SetOptions(values, fireCallback?)` | 更新选项；可选参数默认 false；若回调拒绝清空，则恢复此前选项和值 |
| `button:Press()` | 通过和真实点击相同的保护执行按钮回调；隐藏/禁用/忙碌时不执行 |
| `control:Destroy()` | 清理自己的实例、事件、动画和图片订阅 |

`control.Root`、`TitleLabel` 等是高级调试引用。直接改内部布局可能被下次重排覆盖，普通接入请使用公开方法。

## 5. 回调规则

- 创建控件时不触发 Callback，避免默认开关意外启动任务。
- `Set` 默认静默；真实点击或 `Set(value, true)` 才通知业务。
- Callback 返回 `false, "原因"` 或抛异常，值控件恢复先前值，底部显示原因。
- Callback 可以等待；等待期间该控件进入忙碌状态，拒绝重复提交。
- 回调返回前控件若已销毁，库不会继续写入失效界面。库不会强制终止你自己创建的业务线程；请通过 `Window:OnDestroy` 管理它们。
- `Hide` 和 `Show` 只控制界面和角色展示，不代表开始/停止游戏业务。

## 6. 开始、停止、通知和状态

```lua
Window:SetActions({
    Start = function(values, window)
        -- values 是当前所有有值控件的快照，以控件 Id 为键。
        print(values.training)
    end,
    Stop = function(values, window)
        -- 在这里停止你自己启动的任务。
    end,
})

Window:Notify({Title = "提示", Content = "操作结果"})
Window:SetStatus("script", {Title = "等待操作", Detail = "自定义说明", Badge = "就绪"})
Window:SetReducedMotion(true)
Window:OnDestroy(function() print("清理你自己的连接与任务") end)
```

`SetStatus` 支持 `connection`、`script`、`version` 三行；可传 `Title`、`Detail`、`Badge` 和 `Color`。初始状态明确是 UI 就绪，不伪造游戏在线、Premium 或授权成功。

其他窗口方法：`GetControl(id)`、`GetValues()`、`Hide()`、`Show()`、`SetVisible(bool)`、`Diagnostics()`、`Destroy()`。右上角 × 是隐藏；彻底关闭请调用 `Destroy`。

## 7. 一键使用当前完整 JBS 预设

```lua
local app, reason = Library:CreateJBS({
    Config = {Hotkey = Enum.KeyCode.RightShift},
    -- Bindings = require(你的业务 ModuleScript),
})
if not app then warn(reason); return end
-- 原预设返回原接口：app.Destroy() / app.Close() / app.Restore()，使用点号。
```

`CreateJBS` 原样委托给 `Runtime.Mount`，保留当前页面顺序、目标次数、传送地点、宠物名、状态控制、配置和授权流程。其返回值是原预设接口，不支持通用窗口的 `Tab` 方法；需要自定义页面时使用 `CreateWindow`。

完整名称清单在 `JBS_Reference05/catalog/PreviousUI.json`，接线约定在 `JBS_Reference05/src/BusinessBindings.lua`。库不会把固定游戏业务带进通用控件，也不会把未接入状态改成运行成功。

## 8. 图片和角色

`AssetIds` 使用 `logo_jbs`、`frame_atlas`、`icon_atlas`、`hero_clean`、`sidebar_clean` 等现有键。所需 PNG 与来源在 `JBS_Reference05/assets/`。本库没有虚构资源 ID；未上传时保留可交互的原生底色、边框与明确提示。

默认的角色展示直接复用现有双视图管理器：优先当前 `LocalPlayer.Character`，同一外观来源，正面与背面各有独立模型、WorldModel 和相机。窄窗没有左侧装饰位时暂停背面；隐藏或销毁窗口按现有策略释放展示。账号备用仍有明确状态标识。

## 9. 修改源码与验证

| 文件 | 用途 |
| --- | --- |
| `JBS_Reference05/src/Library.lua` | 对外入口，保持加载无副作用 |
| `JBS_Reference05/src/LibraryWindow.lua` | 窗口、页面、右栏、状态、生命周期 |
| `JBS_Reference05/src/LibraryControls.lua` | 通用控件、回调与值、布局、事件清理 |
| `JBS_Reference05/src/Components.lua` / `Theme.lua` | 原有金属组件和粉紫主题，库直接复用 |
| `JBS_Reference05/tools/build.py` | 从同一份源码生成库、导入模型和示例场景 |
| `JBS_Reference05/tools/test_library.py` | 库行为与交付一致性检查 |

```sh
python3 JBS_Reference05/tools/build.py
python3 JBS_Reference05/tools/test.py --luau /path/to/luau --compiler /path/to/luau-compile
python3 JBS_Reference05/tools/test_library.py --luau /path/to/luau --compiler /path/to/luau-compile
python3 JBS_Reference05/tools/check_stage2_package.py
```

已通过 117 项库离线断言、364 项 UI 断言、210 项正面角色断言和 187 项双视图断言；单文件模块加载无实例/事件副作用，模型与示例内嵌源码一致。日志位于 `JBS_Reference05/evidence/`。

**尚未进行 Roblox 原生实测。** 离线检查不证明实际字体、触摸命中、资源权限、3D 服装显示或帧率。浏览器演示保持原样，不作为本库的原生验证。
