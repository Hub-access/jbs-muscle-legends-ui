--[[
    仅替换原 SidebarArt 内部；名字和外部尺寸沿用 Layout.lua。
    人物已从底图清除，底部标语裁片放在 3D 安全区之外，避免遮住肩背/腰部。
    本模块只造控件，把背面描述交给首页的同一个 HeroAvatar 管理器。
]]
local Theme = require(script.Parent.Theme)
local Sidebar = {}
function Sidebar.Build(view, panel)
    local u, assets = view.u, view.assets
    local holder = u:Box(panel, "SidebarArt", 0, 629, 246, 245)
    holder.ClipsDescendants = true
    local legacyPending = u:Text(panel, "SidebarArtPending", "", 0, 0, 1, 1, 13, Theme.Colors.Muted)
    legacyPending.Visible = false
    local canvas = u:Make("Frame", holder, "LayeredSidebar", {
        BackgroundColor3 = Theme.Colors.Panel,
        BorderSizePixel = 0,
        Size = UDim2.fromScale(1, 1),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        ClipsDescendants = true,
    })
    local meta = assets.Meta.sidebar_clean
    local size = meta and meta.size or { 1254, 1254 }
    u:Make("UIAspectRatioConstraint", canvas, "SidebarArtRatio", {
        AspectRatio = size[1] / size[2],
        AspectType = Enum.AspectType.FitWithinMaxSize,
    })
    local background = u:Make("ImageLabel", canvas, "CleanBackCityBackground", {
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1),
        ScaleType = Enum.ScaleType.Stretch,
        ZIndex = 1,
    })
    assets:Bind(background, "sidebar_clean")
    local viewport = u:Make("ViewportFrame", canvas, "BackAvatarViewport", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0.025, 0, 0, 22),
        Size = UDim2.new(0.95, 0, 0.625, -22),
        BorderSizePixel = 0,
        ZIndex = 2,
        Ambient = Color3.fromRGB(170, 156, 181),
        LightColor = Color3.fromRGB(255, 239, 250),
        LightDirection = Vector3.new(1, -0.8, 1), -- 从背面方向照亮衣服，保持同一温和粉紫光照意图。
        ImageColor3 = Color3.new(1, 1, 1),
    })
    local status = u:Make("TextLabel", canvas, "BackAvatarSourceStatus", {
        BackgroundColor3 = Theme.Colors.Black,
        BackgroundTransparency = 0.22,
        Position = UDim2.fromOffset(0, 0),
        Size = UDim2.new(1, 0, 0, 22),
        Text = "角色更新中…",
        TextColor3 = Theme.Colors.White,
        Font = Theme.Font,
        TextSize = 13,
        TextWrapped = true,
        ZIndex = 4,
    })
    local cropY = math.floor(size[2] * 0.625)
    local foreground = u:Make("ImageLabel", canvas, "BackSloganForeground", {
        BackgroundTransparency = 1,
        Position = UDim2.fromScale(0, cropY / size[2]),
        Size = UDim2.fromScale(1, (size[2] - cropY) / size[2]),
        ScaleType = Enum.ScaleType.Stretch,
        ZIndex = 3,
    })
    assets:Bind(foreground, "sidebar_clean", { 0, cropY, size[1], size[2] - cropY })
    local note = u:Make("TextLabel", canvas, "BackArtPending", {
        BackgroundTransparency = 1,
        Position = UDim2.fromScale(0.02, 0.65),
        Size = UDim2.fromScale(0.96, 0.35),
        Text = "MORE POWER\nMORE POSSIBILITIES\n背面底图待上传",
        Font = Theme.Font,
        TextSize = 13,
        TextColor3 = Theme.Colors.Light,
        TextWrapped = true,
        ZIndex = 3,
    })
    table.insert(view.artGaps, { label = note, key = "sidebar_clean" })
    view.avatarBackSpec = { holder = holder, viewport = viewport, status = status }
end
return Sidebar
