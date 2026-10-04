--[[
    只替换原 Hero 控件内部，不修改外壳/快捷区/Layout 的尺寸。
    一张经过清理的无人物底图复用两次：全图为背景，左侧裁片为上层品牌保护区。
    裁片直接使用同一 PNG 原像素，避免再生成一次字标造成字体变化；右侧不含旧人物。
    未上传底图时显示明确的原生测试容器，绝不回退到含旧人物的 hero_banner。
]]
local HeroAvatar = require(script.Parent.HeroAvatar)
local Theme = require(script.Parent.Theme)
local HeroView = {}
function HeroView.Build(view)
    local u, assets = view.u, view.assets
    local holder = u:Box(view.hero, "Hero", 3, 3, 1070, 304)
    holder.ClipsDescendants = true
    -- 兼容现有 Layout.Apply 的命名；缺图提示另放在左侧安全区。
    local oldPending = u:Text(view.hero, "HeroPending", "", 0, 0, 1, 1, 14, Theme.Colors.Muted)
    oldPending.Visible = false
    local canvas = u:Make("Frame", holder, "LayeredHero", {
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        ClipsDescendants = true,
    })
    local meta = assets.Meta.hero_clean
    local size = meta and meta.size or { 2116, 743 }
    u:Make("UIAspectRatioConstraint", canvas, "OriginalBannerRatio", {
        AspectRatio = size[1] / size[2],
        AspectType = Enum.AspectType.FitWithinMaxSize,
    })
    local backdrop = u:Make("ImageLabel", canvas, "CleanCityBackground", {
        BackgroundColor3 = Theme.Colors.Panel,
        BackgroundTransparency = 0,
        BorderSizePixel = 0,
        Size = UDim2.fromScale(1, 1),
        ScaleType = Enum.ScaleType.Stretch,
        ZIndex = 1,
    })
    assets:Bind(backdrop, "hero_clean")
    local note = u:Make("TextLabel", canvas, "NativeArtPending", {
        BackgroundTransparency = 1,
        Position = UDim2.fromScale(0.02, 0.14),
        Size = UDim2.fromScale(0.49, 0.72),
        Text = "JBS 力量传奇\nThe Best Clan In Muscle Legend\n\n原生角色测试区\n无人物底图尚未上传",
        TextColor3 = Theme.Colors.Light,
        Font = Theme.Font,
        TextSize = 16,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Center,
        ZIndex = 3,
    })
    table.insert(view.artGaps, { label = note, key = "hero_clean" })
    local slot = u:Make("Frame", canvas, "HeroAvatarSlot", {
        BackgroundTransparency = 1,
        Position = UDim2.fromScale(0.535, 0.015),
        Size = UDim2.fromScale(0.455, 0.97),
        ClipsDescendants = true,
        ZIndex = 2,
    })
    local viewport = u:Make("ViewportFrame", slot, "AvatarViewport", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, -26),
        BorderSizePixel = 0,
        Ambient = Color3.fromRGB(170, 156, 181),
        LightColor = Color3.fromRGB(255, 239, 250),
        LightDirection = Vector3.new(-1, -0.8, -1),
        ImageColor3 = Color3.new(1, 1, 1),
        ZIndex = 2,
    })
    local label = u:Make("TextLabel", slot, "AvatarSourceStatus", {
        BackgroundColor3 = Theme.Colors.Black,
        BackgroundTransparency = 0.22,
        Position = UDim2.new(0, 0, 1, -26),
        Size = UDim2.new(1, 0, 0, 26),
        Text = "正在读取当前角色…",
        TextColor3 = Theme.Colors.White,
        Font = Theme.Font,
        TextSize = 13,
        TextWrapped = true,
        ZIndex = 4,
    })
    -- 上层品牌裁片：与背景完全同一张图、同一显示比例；人物安全区从 53.5% 开始。
    local cropWidth = math.floor(size[1] * 0.53)
    local foreground = u:Make("ImageLabel", canvas, "OriginalBrandForeground", {
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(cropWidth / size[1], 1),
        ScaleType = Enum.ScaleType.Stretch,
        ZIndex = 3,
    })
    assets:Bind(foreground, "hero_clean", { 0, 0, cropWidth, size[2] })
    view.heroAvatar = HeroAvatar.new(view.player, viewport, label, view.config.AvatarPreview)
    view.avatarHolders = { front = holder }
    if view.avatarBackSpec then
        local back = view.avatarBackSpec
        view.heroAvatar:AddView(
            "back",
            back.viewport,
            back.status,
            "back",
            view.config.AvatarPreview.BackFieldOfView or 35
        )
        view.avatarHolders.back = back.holder
    end
    view.scope:Add(function()
        view.heroAvatar:Destroy()
    end)
    -- 外层任意祖先隐藏/ScreenGui 关闭也暂停，不依赖 Visible=false 自动停止工作。
    local observed = {}
    for _, avatarHolder in pairs(view.avatarHolders) do
        -- 布局/滚动/拖动导致控件离开裁切区时重查显隐；不挂逐帧监听。
        for _, property in ipairs({ "AbsolutePosition", "AbsoluteSize" }) do
            view.scope:Connect(avatarHolder:GetPropertyChangedSignal(property), function()
                view:RefreshAvatarVisibility()
            end)
        end
        local ancestor = avatarHolder
        while ancestor do
            if not observed[ancestor] then
                observed[ancestor] = true
                local property = ancestor:IsA("GuiObject") and "Visible"
                    or ancestor:IsA("ScreenGui") and "Enabled"
                if property then
                    view.scope:Connect(ancestor:GetPropertyChangedSignal(property), function()
                        view:RefreshAvatarVisibility()
                    end)
                end
            end
            ancestor = ancestor.Parent
        end
    end
    view.scope:Connect(view.center:GetPropertyChangedSignal("CanvasPosition"), function()
        view:RefreshAvatarVisibility()
    end)
    view.heroAvatarHolder = holder
end
return HeroView
