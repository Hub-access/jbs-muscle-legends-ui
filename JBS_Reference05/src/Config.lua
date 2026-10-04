--[[
    运行配置：版本号、游戏标识、图片资源、快捷键。
    所需美术 PNG 已在 assets/，上传到你有权使用的 Roblox 账号后，把真实 ID 填入 AssetIds。
    空 ID 是“尚未接入”，不是渲染错误；不要把本机图片路径当成 Roblox 资源 ID。
]]
-- 图片上传完成前保留空 ID，避免使用不属于本项目的虚构资源。
return {
    Version = "5.0.0-ui",
    TargetPlaceIds = {}, -- 填入核对过的游戏 PlaceId。
    AssetIds = {
        logo_jbs = "",
        hero_banner = "",
        hero_clean = "", -- assets/hero_clean.png：无人物底图。上传后只填写真实资源 ID。
        sidebar_art = "",
        sidebar_clean = "", -- assets/sidebar_clean.png：无旧人物的背面城市/标语底图。
        control_art = "",
        frame_atlas = "",
        icon_atlas = "",
    },
    ReducedMotion = false,
    DisplayOrder = 50,
    Hotkey = nil,
    SessionAttribute = "JBS5_SessionState",
    EnableDiagnostics = true,
    -- 正背面共用一个外观管理器。Enabled 关闭全部；BackEnabled 可仅关闭背面作性能对照。
    AvatarPreview = {
        Enabled = true,
        BackEnabled = true,
        Debounce = 0.45, -- 集中收到衣服/配饰/颜色变化时，合并为一次重建。
        MaxWait = 1.2, -- 持续变化也不能永久等待；另受下方最小重建间隔限制。
        MinInterval = 1.5, -- 高频体型增长最多约每 1.5 秒重建一次，而非每次增长都 Clone。
        ReadyAttempts = 8, -- 没有完整身体时有限次重试；之后继续靠相关事件唤醒。
        FallbackTimeout = 12,
        FieldOfView = 35,
        BackFieldOfView = 35, -- 背面仍按自己的控件尺寸计算距离，不抄用正面距离。
        MaxDescendants = 2000, -- 超大自定义模型需专用适配，避免无限复制。
    },
}
