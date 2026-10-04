--[[
    外观总表：颜色、字体、布局、动效时长。
    想换配色先改 Colors；自适应尺寸看 Layout.lua（下方 Layout 为桌面基准）。
    Features 的中文名称来自 LegacyCatalog，避免浏览器和 Luau 各改一套。
]]
local C = Color3.fromHex
return {
    Colors = {
        Pink = C("FF35C8"),
        Light = C("FF6ADE"),
        Purple = C("A849FF"),
        Panel = C("1D0D29"),
        Black = C("0B0710"),
        White = C("F8EEFA"),
        Muted = C("C5ADD9"),
        Dim = C("756083"),
        Green = C("48EA9C"),
        Error = C("FF7596"),
        Border = C("843C8E"),
    },
    Font = Enum.Font.Gotham,
    Bold = Enum.Font.GothamBold,
    Width = 1672,
    Height = 941,
    MinScale = 1,
    Motion = { Open = 0.26, Hide = 0.14, Hover = 0.12, Toggle = 0.14, Page = 0.16 },
    Layout = {
        Left = { 0, 0, 246, 914 },
        Top = { 258, 0, 1414, 60 },
        Hero = { 258, 62, 1076, 310 },
        Quick = { 258, 384, 1076, 348 },
        Control = { 258, 752, 1076, 162 },
        Status = { 1346, 76, 326, 346 },
        Settings = { 1346, 434, 326, 318 },
        User = { 1346, 764, 326, 150 },
    },
    -- 首页三项和右侧五项都来自旧版真实开关；显示名称集中维护。
    Features = require(script.Parent.LegacyCatalog).features,
    Pages = {
        { "home", "主要", "home" },
        { "teleport", "传送", "teleport" },
        { "pets", "宠物", "pet" },
        { "boss", "Boss", "boss" },
        { "rebirth", "换包重生", "rebirth" },
        { "settings", "设置", "settings" },
    },
}
