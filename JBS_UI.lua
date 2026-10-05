-- 自动生成的单文件发布入口。请修改 src/ 内有中文注释的模块，再运行 tools/build.py。
local factories,cache={},{}
local function requireModule(name)
 if cache[name]~=nil then return cache[name] end
 assert(factories[name],name)
 local value=factories[name]();cache[name]=value;return value
end
factories["AssetData"] = function()
-- 图片裁片资料（由 assets/manifest.json 自动生成）；资源 ID 请在 Config.lua 填写。
return {
    ["logo_jbs"] = {
        ["file"] = "assets/logo_jbs.png",
        ["size"] = {
            237,
            150,
        },
        ["source_rect"] = {
            10,
            8,
            247,
            158,
        },
        ["runtime_id"] = "",
        ["status"] = "pending_upload_and_native_verification",
        ["scale"] = "Fit",
        ["sha256"] = "0918c776e116c248e9930b0ef20e690e1b9e9d7c628766e8104e2360d26fe3c0",
    },
    ["hero_banner"] = {
        ["file"] = "assets/hero_banner.png",
        ["size"] = {
            2119,
            742,
        },
        ["source_rect"] = {
            252,
            55,
            1337,
            435,
        },
        ["runtime_id"] = "",
        ["status"] = "pending_upload_and_native_verification",
        ["scale"] = "Fit",
        ["sha256"] = "0b14a483e8ced242b91249aa1cdb7fa3988fea1ef8e02bd14b5af007078c7f58",
        ["copy"] = "The Best Clan In Muscle Legend",
        ["source_note"] = "Original reference crop, then localized English subheading edit; source_rect retained as provenance, not a runtime crop.",
    },
    ["sidebar_art"] = {
        ["file"] = "assets/sidebar_art.png",
        ["size"] = {
            248,
            245,
        },
        ["source_rect"] = {
            0,
            629,
            248,
            874,
        },
        ["runtime_id"] = "",
        ["status"] = "pending_upload_and_native_verification",
        ["scale"] = "Fit",
        ["sha256"] = "10214f7f6f59019dce81260fbe1ceb9c11a5b7742ace0db184c8d58731f3f820",
    },
    ["control_art"] = {
        ["file"] = "assets/control_art.png",
        ["size"] = {
            269,
            154,
        },
        ["source_rect"] = {
            1061,
            738,
            1330,
            892,
        },
        ["runtime_id"] = "",
        ["status"] = "pending_upload_and_native_verification",
        ["scale"] = "Fit",
        ["sha256"] = "dcec252d2914b776d7e6397f47a4d288074b72004a612fd47c59972f39774f10",
    },
    ["frame_atlas"] = {
        ["file"] = "assets/frame_atlas.png",
        ["size"] = {
            1024,
            512,
        },
        ["runtime_id"] = "",
        ["status"] = "pending_upload_and_native_verification",
        ["patches"] = {
            ["panel"] = {
                ["rect"] = {
                    0,
                    0,
                    326,
                    342,
                },
                ["border"] = 24,
                ["mode"] = "eight_fixed_corner_and_stretched_edge_patches",
                ["center"] = "transparent",
            },
            ["card"] = {
                ["rect"] = {
                    352,
                    0,
                    350,
                    112,
                },
                ["border"] = 13,
                ["mode"] = "eight_fixed_corner_and_stretched_edge_patches",
                ["center"] = "transparent",
            },
            ["primary"] = {
                ["rect"] = {
                    352,
                    128,
                    372,
                    95,
                },
                ["border"] = 13,
                ["mode"] = "eight_fixed_corner_and_stretched_edge_patches",
                ["center"] = "transparent",
            },
        },
        ["decor"] = {
            ["top_slogan"] = {
                352,
                256,
                245,
                60,
            },
        },
        ["sha256"] = "cc9155b2a0ce5a93c15b17cc5c9f2af12c9720a23eeee97abc06a5ba68b7eecb",
    },
    ["icon_atlas"] = {
        ["file"] = "assets/icon_atlas.png",
        ["size"] = {
            512,
            640,
        },
        ["runtime_id"] = "",
        ["status"] = "pending_upload_and_native_verification",
        ["rects"] = {
            ["home"] = {
                38,
                41,
                52,
                46,
            },
            ["teleport"] = {
                166,
                41,
                51,
                45,
            },
            ["pet"] = {
                292,
                40,
                56,
                47,
            },
            ["boss"] = {
                420,
                38,
                55,
                51,
            },
            ["rebirth"] = {
                36,
                166,
                55,
                51,
            },
            ["settings"] = {
                165,
                167,
                54,
                50,
            },
            ["train"] = {
                283,
                154,
                74,
                75,
            },
            ["spin"] = {
                411,
                153,
                74,
                78,
            },
            ["pin"] = {
                26,
                282,
                75,
                75,
            },
            ["game"] = {
                165,
                291,
                54,
                58,
            },
            ["version"] = {
                294,
                294,
                52,
                52,
            },
            ["crown"] = {
                421,
                296,
                53,
                47,
            },
            ["gem"] = {
                37,
                427,
                53,
                42,
            },
            ["bolt"] = {
                175,
                426,
                34,
                43,
            },
            ["status"] = {
                296,
                425,
                48,
                46,
            },
            ["strength"] = {
                429,
                429,
                38,
                38,
            },
            ["play"] = {
                33,
                545,
                62,
                62,
            },
            ["stop"] = {
                158,
                542,
                68,
                68,
            },
            ["arrow"] = {
                310,
                563,
                20,
                26,
            },
        },
        ["note"] = "Original reference crops with pale-ink alpha extraction; no upsampling. Extraction is editable in prepare_assets.py.",
        ["sha256"] = "35587e20b267a8bdae88553fecf73382068a8d1f36b3893e4cbf19e33a347f2d",
    },
    ["hero_clean"] = {
        ["file"] = "assets/hero_clean.png",
        ["size"] = {
            2116,
            743,
        },
        ["runtime_id"] = "",
        ["status"] = "pending_upload_and_native_verification",
        ["scale"] = "Fit",
        ["sha256"] = "c9f2b117fbb8ef7d67a6e3273d3723ded4e89f614d3ff4ab2d4f77ac09ea3c26",
        ["copy"] = "The Best Clan In Muscle Legend",
        ["source_note"] = "Imagegen removed baked character and SIGMA from title-case v4. Same PNG reused for background and left 53% brand foreground; no separately regenerated logo. Native resource ID pending.",
    },
    ["sidebar_clean"] = {
        ["file"] = "assets/sidebar_clean.png",
        ["size"] = {
            1254,
            1254,
        },
        ["runtime_id"] = "",
        ["status"] = "pending_upload_and_native_verification",
        ["scale"] = "Fit",
        ["sha256"] = "a629be61435380bf49f422fc9c0ab0bf62b270ef569729911a853f2ff11698f0",
        ["source_note"] = "Generated removal of baked black-haired character from assets/sidebar_art.png; retained MORE POWER / MORE POSSIBILITIES. Same image lower 37.5% reused as foreground, no alpha required.",
    },
}

end
factories["Assets"] = function()
--[[
    图片加载器：先校验资源 ID，再加载，再通知界面显示结果。
    AssetData 描述裁片位置；Config.AssetIds 指定 Roblox 上传后的资源 ID。
    缺失或加载失败时保留原生控件和文字提示，不假装图片已经成功显示。
]]
local ContentProvider = game:GetService("ContentProvider")
local Assets = {}
Assets.__index = Assets
Assets.Meta = requireModule("AssetData")
-- 只接受合法的 rbxassetid://数字；未填写的项目标为未接入。
function Assets.new(ids)
    local self = setmetatable({ ids = {}, status = {}, subscribers = {}, dead = false }, Assets)
    for key in pairs(Assets.Meta) do
        local value = ids[key]
        if type(value) == "string" and value:match("^rbxassetid://[1-9]%d*$") then
            self.ids[key] = value
            self.status[key] = "待加载"
        else
            self.status[key] = "未接入"
        end
    end
    return self
end
-- 将图片控件关联到资源；可用 rect 指定图集中某个小图的区域。
function Assets:Bind(image, key, rect)
    image.ResampleMode = Enum.ResamplerMode.Default
    image.Image = self.ids[key] or ""
    if rect then
        image.ImageRectOffset = Vector2.new(rect[1], rect[2])
        image.ImageRectSize = Vector2.new(rect[3], rect[4])
    end
    image.Visible = self.status[key] == "已加载"
    table.insert(self.subscribers, { image = image, key = key })
end
-- 统计美术资源中已经加载成功的数量。
function Assets:Summary()
    local loaded, total = 0, 0
    for _, status in pairs(self.status) do
        total += 1
        if status == "已加载" then
            loaded += 1
        end
    end
    return loaded, total
end
-- UI 库允许单独删除控件；及时移除该子树的订阅，避免加载结束后访问已销毁图片。
function Assets:UnbindTree(root)
    for index = #self.subscribers, 1, -1 do
        local node = self.subscribers[index].image
        while node do
            if node == root then
                table.remove(self.subscribers, index)
                break
            end
            node = node.Parent
        end
    end
end
-- 异步预加载；每次等待后核对是否已经销毁，避免更新失效界面。
function Assets:Load(changed)
    self.thread = task.spawn(function()
        for key, id in pairs(self.ids) do
            if self.dead then
                return
            end
            local success = false
            local ok = pcall(function()
                ContentProvider:PreloadAsync({ id }, function(_, status)
                    success = status == Enum.AssetFetchStatus.Success
                end)
            end)
            if self.dead then
                return
            end
            self.status[key] = ok and success and "已加载" or "加载失败"
            for _, entry in ipairs(self.subscribers) do
                if entry.key == key then
                    entry.image.Visible = self.status[key] == "已加载"
                end
            end
            changed()
        end
    end)
end
-- 取消本模块的加载工作，并丢弃图片控件引用。
function Assets:Destroy()
    self.dead = true
    if self.thread and coroutine.status(self.thread) ~= "dead" then
        pcall(task.cancel, self.thread)
    end
    table.clear(self.subscribers)
end
return Assets

end
factories["AvatarAccountRequest"] = function()
--[[
    同一模块包内、同一 UserId 至多一个进行中的账号请求。
    UI 销毁只取消订阅；引擎返回时没有订阅者就销毁模型。
    再次 Mount 可接住已有请求，避免网络很慢时反复开关/重建积累请求。
    本模块不缓存完成的账号模型，也不保存 UI/Character 引用。
]]
local Request = {}
local pending = {}
function Request.Subscribe(userId, fetch, callback)
    local entry = pending[userId]
    local start = entry == nil
    if start then
        entry = { listeners = {} }
        pending[userId] = entry
    end
    entry.listeners[callback] = true
    local function unsubscribe()
        entry.listeners[callback] = nil
    end
    if start then
        task.spawn(function()
            local ok, result = pcall(fetch, userId)
            pending[userId] = nil
            local listeners = {}
            for listener in pairs(entry.listeners) do
                table.insert(listeners, listener)
            end
            table.clear(entry.listeners)
            -- 正背面共享管理器正常只有一个订阅者；多个测试容器也不能反复搬动同一个 Model。
            for index, listener in ipairs(listeners) do
                local value, success = result, ok
                if ok and index < #listeners then
                    local copied, clone = pcall(function()
                        return result:Clone()
                    end)
                    success = copied and clone ~= nil
                    value = success and clone or "备用模型无法复制"
                end
                local delivered, problem = pcall(listener, success, value)
                if not delivered then
                    if success and value then
                        value:Destroy()
                    end
                    warn("JBS avatar subscriber:", problem)
                end
            end
            if #listeners == 0 and ok and result then
                result:Destroy()
            end
        end)
    end
    return unsubscribe
end
function Request.PendingCount()
    local count = 0
    for _ in pairs(pending) do
        count += 1
    end
    return count
end
return Request

end
factories["AvatarDisplay"] = function()
--[[
    一个展示区的专用 Camera / WorldModel / Model。没有玩家监听或账号查询。
    Prepare 先准备未挂载的一组实例；Attach 只在共享管理器的短事务中调用。
    每个展示区独立按 AbsoluteSize 取景，不读取 Camera.ViewportSize。
]]
local Fit = requireModule("AvatarFit")
local Display = {}
Display.__index = Display
function Display.new(id, viewport, label, direction, fov)
    return setmetatable({
        id = id,
        viewport = viewport,
        label = label,
        direction = direction,
        fov = fov,
        visible = false,
        current = nil,
    }, Display)
end
function Display.Fit(record, viewport, direction, fov)
    local size = viewport.AbsoluteSize
    local fit = Fit.Compute(record.snapshot.bounds, size.X, size.Y, fov, direction)
    if not fit then
        return
    end -- 初次布局尚未有尺寸；等 AbsoluteSize 事件，不增加轮询。
    record.camera.CFrame =
        CFrame.lookAt(Vector3.new(fit.x, fit.y, fit.z), Vector3.new(fit.x, fit.y, fit.lookZ))
    record.camera.Focus = CFrame.new(fit.x, fit.y, fit.lookZ)
end
function Display.Dispose(record)
    if not record then
        return
    end
    if record.world then
        record.world:Destroy()
    end
    if record.camera then
        record.camera:Destroy()
    end
    -- Prepare 在挂进 world 之前也可能失败，独立清理该路径持有的 model。
    if record.snapshot then
        record.snapshot.model:Destroy()
    end
end
function Display:Prepare(snapshot, appearanceVersion, source)
    local record = { snapshot = snapshot, appearanceVersion = appearanceVersion, source = source }
    local ok, err = pcall(function()
        assert(self.viewport.Parent ~= nil, "展示控件已移除：" .. self.id)
        record.world = Instance.new("WorldModel")
        record.world.Name = "AvatarWorld_" .. self.id
        record.camera = Instance.new("Camera")
        record.camera.Name = "AvatarCamera_" .. self.id
        record.camera.FieldOfViewMode = Enum.FieldOfViewMode.Vertical
        record.camera.FieldOfView = self.fov
        snapshot.model:SetAttribute("JBS_AppearanceVersion", appearanceVersion)
        snapshot.model:SetAttribute("JBS_AppearanceSource", source)
        snapshot.model:SetAttribute("JBS_AvatarView", self.id)
        snapshot.model.Parent = record.world -- world 此时仍在 DataModel 外。
        Display.Fit(record, self.viewport, self.direction, self.fov)
    end)
    if not ok then
        Display.Dispose(record)
        error(err)
    end
    return record
end
function Display:Attach(record)
    assert(self.viewport.Parent ~= nil, "展示控件在提交前已移除：" .. self.id)
    record.world.Parent = self.viewport
    record.camera.Parent = self.viewport
    self.viewport.CurrentCamera = record.camera
end
function Display:Restore(record)
    -- 不把已被隐藏/销毁流程释放的旧模型重新挂回来。
    local camera = record and record.world.Parent == self.viewport and record.camera or nil
    self.viewport.CurrentCamera = camera
end
function Display:Release()
    local old = self.current
    self.current = nil
    pcall(function()
        self.viewport.CurrentCamera = nil
    end)
    Display.Dispose(old)
end
function Display:Resize()
    if self.visible and self.current then
        Display.Fit(self.current, self.viewport, self.direction, self.fov)
    end
end
function Display:Diagnostics()
    local c = self.current
    return {
        visible = self.visible,
        direction = self.direction,
        appearanceVersion = c and c.appearanceVersion or nil,
        source = c and c.source or "none",
        activeModels = c and 1 or 0,
        worlds = c and 1 or 0,
        cameras = c and 1 or 0,
        modelInstances = c and #c.snapshot.model:GetDescendants() + 1 or 0,
    }
end
return Display

end
factories["AvatarFit"] = function()
--[[
    纯数学取景：输入已经筛掉隐藏辅助物的范围，不访问 Workspace 相机。
    独立成模块是为了用 Luau 离线验证宽肩/小体型/高帽/窄窗口。
    fitBottom 允许裁去腿部；头顶和左右轮廓始终参与计算。
]]
local Fit = {}
function Fit.Compute(bounds, width, height, fov, direction)
    if width <= 1 or height <= 1 then
        return nil
    end
    local preferredBottom = direction == "back" and bounds.backFitBottom or bounds.fitBottom
    local bottom = math.max(bounds.minY, math.min(preferredBottom or bounds.fitBottom, bounds.maxY - 0.1))
    local spanX = math.max(0.1, bounds.maxX - bounds.minX)
    local spanY = math.max(0.1, bounds.maxY - bottom)
    local tanY = math.tan(math.rad(math.clamp(fov, 20, 70)) / 2)
    local tanX = tanY * width / height
    -- 用最靠近相机的包围面求距离，因此后面的点也一定在水平/垂直视锥内。
    local distance = math.max(spanX / (2 * tanX), spanY / (2 * tanY)) * 1.10
    return {
        x = (bounds.minX + bounds.maxX) / 2,
        y = (bounds.maxY + bottom) / 2,
        -- 规范化角色朝 -Z。正面相机在 -Z，背面相机在 +Z；没有镜像模型或图片。
        z = direction == "back" and bounds.maxZ + distance or bounds.minZ - distance,
        lookZ = (bounds.minZ + bounds.maxZ) / 2,
        nearDistance = distance,
        tanX = tanX,
        tanY = tanY,
    }
end
return Fit

end
factories["AvatarHeroView"] = function()
--[[
    只替换原 Hero 控件内部，不修改外壳/快捷区/Layout 的尺寸。
    一张经过清理的无人物底图复用两次：全图为背景，左侧裁片为上层品牌保护区。
    裁片直接使用同一 PNG 原像素，避免再生成一次字标造成字体变化；右侧不含旧人物。
    未上传底图时显示明确的原生测试容器，绝不回退到含旧人物的 hero_banner。
]]
local HeroAvatar = requireModule("HeroAvatar")
local Theme = requireModule("Theme")
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

end
factories["AvatarRefresh"] = function()
-- 有最大等待时间的防抖 + 限频。纯函数可用虚拟时间测试，不绑定逐帧事件。
local Refresh = {}
function Refresh.Due(first, latest, lastBuild, debounce, maxWait, minInterval)
    return math.max(math.min(latest + debounce, first + maxWait), lastBuild + minInterval)
end
return Refresh

end
factories["AvatarSidebarView"] = function()
--[[
    仅替换原 SidebarArt 内部；名字和外部尺寸沿用 Layout.lua。
    人物已从底图清除，底部标语裁片放在 3D 安全区之外，避免遮住肩背/腰部。
    本模块只造控件，把背面描述交给首页的同一个 HeroAvatar 管理器。
]]
local Theme = requireModule("Theme")
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

end
factories["AvatarSnapshot"] = function()
--[[
    角色复制与净化。只有 Copy 的 Archivable 短路径会临时写真实角色；
    该路径绝不等待，逐项恢复所有改过的标志。其余代码只接触未挂载副本。
    第一阶段支持有 Head + Torso/UpperTorso 的 R6/R15 及它们的焊接扩展。
    无可靠关节连接的可见部件会使本次快照失败，转明确标注的账号备用。
]]
local Snapshot = {}
local bodyNames = {
    Head = true,
    Torso = true,
    UpperTorso = true,
    LowerTorso = true,
    ["Left Arm"] = true,
    ["Right Arm"] = true,
    ["Left Leg"] = true,
    ["Right Leg"] = true,
    LeftUpperArm = true,
    LeftLowerArm = true,
    LeftHand = true,
    RightUpperArm = true,
    RightLowerArm = true,
    RightHand = true,
    LeftUpperLeg = true,
    LeftLowerLeg = true,
    LeftFoot = true,
    RightUpperLeg = true,
    RightLowerLeg = true,
    RightFoot = true,
}
-- 只允许外观与骨架类型。默认拒绝其他类型，避免遗漏脚本、交互、力或场景引用。
local allowed = {
    Model = true,
    Folder = true,
    Humanoid = true,
    Accessory = true,
    Hat = true,
    BodyColors = true,
    Shirt = true,
    Pants = true,
    ShirtGraphic = true,
    Attachment = true,
    Bone = true,
    WrapLayer = true,
    WrapTarget = true,
    SurfaceAppearance = true,
    CharacterMesh = true,
    Decal = true,
    Texture = true,
    NumberValue = true,
    Vector3Value = true, -- 保留 Humanoid 尺寸值与部件 OriginalSize；均不含实例引用。
    Motor6D = true,
    Motor = true,
    Weld = true,
    ManualWeld = true,
    WeldConstraint = true,
}
local function keep(v)
    return allowed[v.ClassName] or v:IsA("BasePart") or v:IsA("DataModelMesh")
end
local function internal(v, model)
    return v ~= nil and (v == model or v:IsDescendantOf(model))
end
function Snapshot.Copy(character)
    local changed = {}
    local copy
    local ok, err = pcall(function()
        local all = character:GetDescendants()
        table.insert(all, 1, character)
        for _, item in ipairs(all) do
            if not item.Archivable then
                table.insert(changed, item)
                item.Archivable = true
            end
        end
        copy = character:Clone()
        assert(copy, "Character:Clone 返回空模型")
    end)
    -- finally：即使中间设置/Clone 出错，也继续恢复前面改过的每一个实例。
    local restoreErrors = {}
    for i = #changed, 1, -1 do
        local restored, problem = pcall(function()
            changed[i].Archivable = false
        end)
        if not restored then
            table.insert(restoreErrors, tostring(problem))
        end
    end
    if not ok or #restoreErrors > 0 then
        if copy then
            copy:Destroy()
        end
        return nil, tostring(err or table.concat(restoreErrors, "; "))
    end
    return copy
end
local function corners(part, collect)
    local half = part.Size / 2
    -- SpecialMesh 的 Scale/Offset 也参与取景，避免 Part 很小而头发模型很大。
    local mesh = part:FindFirstChildWhichIsA("DataModelMesh")
    local offset = Vector3.zero
    if mesh then
        half = Vector3.new(
            half.X * math.max(1, math.abs(mesh.Scale.X)),
            half.Y * math.max(1, math.abs(mesh.Scale.Y)),
            half.Z * math.max(1, math.abs(mesh.Scale.Z))
        )
        offset = mesh.Offset
    end
    for _, x in ipairs({ -1, 1 }) do
        for _, y in ipairs({ -1, 1 }) do
            for _, z in ipairs({ -1, 1 }) do
                collect(
                    part.CFrame:PointToWorldSpace(offset + Vector3.new(half.X * x, half.Y * y, half.Z * z))
                )
            end
        end
    end
end
local function boundsOf(parts)
    local b = {
        minX = math.huge,
        minY = math.huge,
        minZ = math.huge,
        maxX = -math.huge,
        maxY = -math.huge,
        maxZ = -math.huge,
    }
    for _, part in ipairs(parts) do
        corners(part, function(p)
            b.minX = math.min(b.minX, p.X)
            b.maxX = math.max(b.maxX, p.X)
            b.minY = math.min(b.minY, p.Y)
            b.maxY = math.max(b.maxY, p.Y)
            b.minZ = math.min(b.minZ, p.Z)
            b.maxZ = math.max(b.maxZ, p.Z)
        end)
    end
    return b
end
function Snapshot.Prepare(model)
    assert(model and model:IsA("Model") and model.Parent == nil, "只可净化未挂载的副本")
    local report = { unsupported = {}, excluded = {}, removed = 0 }
    local humanoid = model:FindFirstChildOfClass("Humanoid")
    -- 清理描述/缩放元数据之前先关闭自动缩放，避免净化本身使副本恢复账号默认体型。
    if humanoid then
        humanoid.AutomaticScalingEnabled = false
    end
    -- 先记录不支持的二维头饰/标签；不复制文字，也不凭空补 SIGMA。
    for _, v in ipairs(model:GetDescendants()) do
        if v:IsA("BillboardGui") or v:IsA("SurfaceGui") then
            table.insert(report.unsupported, v.ClassName .. ":" .. v.Name)
        end
    end
    for _, v in ipairs(model:GetDescendants()) do
        if v:IsDescendantOf(model) then
            if not keep(v) then
                report.removed += 1
                v:Destroy()
            else
                -- 标签可能被宿主游戏的 CollectionService 监听，展示副本不应触发其业务。
                for _, tag in ipairs(v:GetTags()) do
                    v:RemoveTag(tag)
                end
                if v:IsA("Model") and v.PrimaryPart and not internal(v.PrimaryPart, model) then
                    v.PrimaryPart = nil
                end
            end
        end
    end
    for _, tag in ipairs(model:GetTags()) do
        model:RemoveTag(tag)
    end
    local root = model:FindFirstChild("HumanoidRootPart")
    local head = model:FindFirstChild("Head")
    local torso = model:FindFirstChild("UpperTorso") or model:FindFirstChild("Torso")
    assert(
        humanoid
            and root
            and head
            and torso
            and root:IsA("BasePart")
            and head:IsA("BasePart")
            and torso:IsA("BasePart"),
        "缺少标准头部/躯干/根部骨架，需游戏专用适配"
    )
    humanoid.AutomaticScalingEnabled = false -- 防止描述重新覆盖游戏自定义体型。
    humanoid.AutoRotate = false
    humanoid.BreakJointsOnDeath = false
    humanoid.RequiresNeck = false
    humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
    humanoid.EvaluateStateMachine = false
    local parts, edges, original = {}, {}, {}
    local originalRoot = root.CFrame
    local function edge(a, b, offset)
        edges[a] = edges[a] or {}
        edges[b] = edges[b] or {}
        table.insert(edges[a], { part = b, offset = offset })
        table.insert(edges[b], { part = a, offset = offset:Inverse() })
    end
    for _, v in ipairs(model:GetDescendants()) do
        if v:IsA("BasePart") then
            table.insert(parts, v)
            original[v] = v.CFrame
            v.Anchored = true
            v.CanCollide = false
            v.CanTouch = false
            v.CanQuery = false
            v.AssemblyLinearVelocity = Vector3.zero
            v.AssemblyAngularVelocity = Vector3.zero
            v.LocalTransparencyModifier = 0 -- 保留 Transparency，隐藏的根部不会显现。
        elseif v:IsA("Bone") then
            v.Transform = CFrame.identity
        end
    end
    -- JointInstance 的 C0/C1 保留角色自身体型。通过图求解中立姿势，
    -- 不只清空 Transform：锚定部件不能依赖下一帧物理求解来更新位置。
    for _, v in ipairs(model:GetDescendants()) do
        if v:IsA("JointInstance") or v:IsA("WeldConstraint") then
            local a, b = v.Part0, v.Part1
            if not internal(a, model) or not internal(b, model) then
                report.removed += 1
                v:Destroy()
            else
                if v:IsA("Motor6D") then
                    v.Transform = CFrame.identity
                end
                local offset = if v:IsA("WeldConstraint")
                    then original[a]:ToObjectSpace(original[b])
                    else v.C0 * v.C1:Inverse()
                edge(a, b, offset)
            end
        end
    end
    root.CFrame = CFrame.identity
    local visited, queue = { [root] = true }, { root }
    local cursor = 1
    while cursor <= #queue do
        local a = queue[cursor]
        cursor += 1
        for _, link in ipairs(edges[a] or {}) do
            if not visited[link.part] then
                visited[link.part] = true
                link.part.CFrame = a.CFrame * link.offset
                table.insert(queue, link.part)
            end
        end
    end
    local body, visible = {}, {}
    for _, part in ipairs(parts) do
        if not visited[part] then
            -- 不冻结游离可见部件的跑跳姿势。隐藏辅助物可留在独立空间。
            assert(part.Transparency >= 0.95, "未连接的可见部件需要适配：" .. part.Name)
            part.CFrame = originalRoot:ToObjectSpace(original[part])
        end
        if part.Transparency < 0.95 and part ~= root then
            if bodyNames[part.Name] and part.Parent == model then
                table.insert(body, part)
            end
            table.insert(visible, part)
        end
    end
    assert(#body >= 2, "可见身体不足，不能可靠取景")
    local bb = boundsOf(body)
    local bodySpan = math.max(bb.maxX - bb.minX, bb.maxY - bb.minY, bb.maxZ - bb.minZ, 0.5)
    local selected = {}
    for _, part in ipairs(visible) do
        local pb = boundsOf({ part })
        local largest = math.max(pb.maxX - pb.minX, pb.maxY - pb.minY, pb.maxZ - pb.minZ)
        local distance = (part.Position - torso.Position).Magnitude
        if largest > bodySpan * 4 or distance > bodySpan * 4 then
            table.insert(report.excluded, part.Name)
            part.Transparency = 1 -- 仅副本排除巨大/远处异常装饰，并在诊断中列明。
        else
            table.insert(selected, part)
        end
    end
    local bounds = boundsOf(selected)
    -- 以躯干下沿附近为裁切起点，优先完整保留头、头饰和肩部。
    local tb = boundsOf({ torso })
    bounds.fitBottom = tb.minY - (tb.maxY - tb.minY) * 0.70
    bounds.backFitBottom = tb.minY - (tb.maxY - tb.minY) * 0.35 -- 侧栏优先头发、肩背和腰部。
    assert(bounds.maxY > bounds.minY, "可见范围无效")
    model.PrimaryPart = root
    model.Name = "SanitizedCharacterClone"
    report.parts = #parts
    report.pose = "neutral-C0-C1; custom animated C0/C1 and skinned meshes need visual QA"
    return { model = model, bounds = bounds, report = report }
end
-- 所有 Prepare 失败都销毁副本；调用者没有半成品需要猜测如何清理。
function Snapshot.FromCharacter(character)
    local copy, reason = Snapshot.Copy(character)
    if not copy then
        return nil, reason
    end
    local ok, result = pcall(Snapshot.Prepare, copy)
    if not ok then
        copy:Destroy()
        return nil, tostring(result)
    end
    return result
end
return Snapshot

end
factories["BusinessAdapter"] = function()
--[[
    界面与游戏业务之间的边界。
    名称和列表可以显示，但只有真实回调存在时按钮才可执行。
    修改接线请看 BusinessBindings.lua；此模块不猜测游戏协议，也不发送 RemoteEvent。
]]
-- 接口层只转交已经接入的回调。
local Catalog = requireModule("LegacyCatalog")
local Adapter = {}
Adapter.__index = Adapter
-- 保存外部提供的任务和操作表，默认空表意味着尚未接入。
function Adapter.new(config, bindings)
    return setmetatable({
        config = config,
        bindings = bindings or {},
        tasks = (bindings and bindings.Tasks) or {},
        actions = (bindings and bindings.Actions) or {},
    }, Adapter)
end
-- 用回调存在性判断功能可用，不用一个开关假装已连接游戏。
function Adapter:Available(id)
    local item = self.tasks[id]
    return type(item) == "table" and type(item.Start) == "function"
end
-- 调用已接入的任务，并要求对方返回专属停止函数。
function Adapter:Start(id, context)
    assert(self:Available(id), "功能未接入: " .. id)
    -- Start 必须返回可重复调用的专属清理函数，只拥有自己的资源。
    -- 每次等待后检查 Cancelled；后台错误通过 ReportError 上报。
    local stop = self.tasks[id].Start(context)
    assert(type(stop) == "function", "Start 必须返回专属清理函数: " .. id)
    return stop
end
-- 返回统一的 {Id, Label} 列表。名称是资料，列出名称并不代表功能已接通。
function Adapter:GetOptions(page)
    local action = self.actions[page]
    if action and action.Options then
        return action.Options
    end
    if self.bindings.GetOptions then
        local ok, options = pcall(self.bindings.GetOptions, page)
        if ok and type(options) == "table" then
            return options
        end
    end
    local options = {}
    if page == "teleport" then
        for _, item in ipairs(Catalog.teleports) do
            table.insert(options, { Id = item.id, Label = item.label })
        end
    elseif page == "pets" then
        for _, name in ipairs(Catalog.fallbackPets) do
            table.insert(options, { Id = name, Label = name })
        end
        table.sort(options, function(a, b)
            return a.Label < b.Label
        end)
    end
    return options
end
-- 一次性按钮的接线，与持续循环 Tasks 分开。没有回调时按钮显示未接入。
function Adapter:CanControl(id)
    return type((self.bindings.Controls or {})[id]) == "function"
end
function Adapter:Control(id, parameters, context)
    assert(self:CanControl(id), "功能未接入: " .. id)
    return self.bindings.Controls[id](parameters, context)
end
-- 选择类操作必须同时具有选项和执行回调。
function Adapter:CanPerform(page)
    return self.actions[page] ~= nil
        and type(self.actions[page].Perform) == "function"
        and #self:GetOptions(page) > 0
end
-- 执行前再次确认所选 ID 仍在允许列表中。
function Adapter:Perform(page, id, context)
    assert(self:CanPerform(page), "功能未接入")
    local found = false
    for _, option in ipairs(self:GetOptions(page)) do
        if option.Id == id then
            found = true
            break
        end
    end
    assert(found, "选择项已失效")
    return self.actions[page].Perform(id, context)
end
-- 显示可核对的 PlaceId 或 Studio 环境，不把界面打开当成游戏连接成功。
function Adapter:Environment()
    if self.bindings.GetEnvironment then
        local ok, value = pcall(self.bindings.GetEnvironment)
        if ok and type(value) == "table" then
            return value
        end
        return { Title = "环境检测错误", Detail = tostring(value), Badge = "错误", Kind = "error" }
    end
    local studio = game:GetService("RunService"):IsStudio()
    if studio then
        return {
            Title = "Studio 本地环境",
            Detail = "目标游戏尚未核对",
            Badge = "本地",
            Kind = "neutral",
        }
    end
    for _, id in ipairs(self.config.TargetPlaceIds) do
        if game.PlaceId == id then
            return {
                Title = "目标环境已匹配",
                Detail = "PlaceId " .. tostring(game.PlaceId),
                Badge = "已匹配",
                Kind = "good",
            }
        end
    end
    return {
        Title = "目标环境未确认",
        Detail = "PlaceId " .. tostring(game.PlaceId),
        Badge = "未确认",
        Kind = "neutral",
    }
end
-- 优先使用接线模块提供的可信身份，否则显示当前玩家。
function Adapter:Identity(player)
    if self.bindings.GetIdentity then
        local ok, value = pcall(self.bindings.GetIdentity, player)
        if ok and type(value) == "table" then
            return value
        end
    end
    return { Name = player.DisplayName, Tag = "普通用户" }
end
return Adapter

end
factories["BusinessBindings"] = function()
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

end
factories["Cleanup"] = function()
--[[
    资源清理箱：记录本界面创建的连接、实例或清理函数。
    Add 放入资源；Connect 绑定并登记事件；Destroy 统一释放。
    只清理本模块拥有的资源，避免影响游戏里的其他界面或脚本。
]]
local Cleanup = {}
Cleanup.__index = Cleanup
-- 为一次界面实例建立独立的资源清单。
function Cleanup.new()
    return setmetatable({ items = {}, dead = false }, Cleanup)
end
-- 登记需要清理的资源；已经销毁后禁止继续添加。
function Cleanup:Add(item)
    if self.dead then
        error("Cannot attach to disposed UI")
    end
    table.insert(self.items, item)
    return item
end
-- 建立一次监听，同时登记它的所有权，避免漏断开。
function Cleanup:Connect(signal, callback)
    return self:Add(signal:Connect(callback))
end
-- 统计仍连接的事件，用于反复操作后的泄漏检查。
function Cleanup:Count()
    local n = 0
    for _, v in ipairs(self.items) do
        if typeof(v) == "RBXScriptConnection" and v.Connected then
            n += 1
        end
    end
    return n
end
-- 逆序清理；一个资源清理出错也继续释放剩余资源。
function Cleanup:Destroy()
    if self.dead then
        return
    end
    self.dead = true
    for i = #self.items, 1, -1 do
        local v = self.items[i]
        local ok, err = pcall(function()
            if type(v) == "function" then
                v()
            elseif typeof(v) == "RBXScriptConnection" then
                v:Disconnect()
            else
                v:Destroy()
            end
        end)
        if not ok then
            warn("JBS cleanup:", err)
        end
    end
    table.clear(self.items)
end
return Cleanup

end
factories["Components"] = function()
--[[
    原生控件工厂：把重复的 Frame、TextLabel、TextButton 封装成易读方法。
    Box = 透明容器；Text = 文字；Panel = 金属边框；Button = 按钮；Toggle = 开关。
    布局参数依次是 x、y、宽、高；所有事件交给 scope 管理，销毁窗口时统一断开。
]]
local Theme = requireModule("Theme")
local Assets = requireModule("Assets")
local C = Theme.Colors
local UI = {}
UI.__index = UI
-- 工厂只使用传入的清理箱、动画器和资源表，不建立额外全局状态。
function UI.new(scope, motion, assets)
    return setmetatable({ scope = scope, motion = motion, assets = assets, buttons = 0 }, UI)
end
-- 统一创建 Instance 并赋值属性，最后挂到父节点。
function UI:Make(class, parent, name, properties)
    local object = Instance.new(class)
    object.Name = name
    for key, value in pairs(properties or {}) do
        object[key] = value
    end
    object.Parent = parent
    return object
end
-- 建立透明 Frame 容器，方便把一组控件一起移动或隐藏。
function UI:Box(parent, name, x, y, w, h)
    return self:Make("Frame", parent, name, {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = UDim2.fromOffset(x, y),
        Size = UDim2.fromOffset(w, h),
    })
end
-- 建立可读的原生文字；过长时截断，避免覆盖旁边控件。
function UI:Text(parent, name, text, x, y, w, h, size, color, bold)
    return self:Make("TextLabel", parent, name, {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = UDim2.fromOffset(x, y),
        Size = UDim2.fromOffset(w, h),
        Text = text,
        TextColor3 = color or C.White,
        Font = bold and Theme.Bold or Theme.Font,
        TextSize = size or 20,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center,
        TextTruncate = Enum.TextTruncate.AtEnd,
        ZIndex = 5,
    })
end
-- 用细 Frame 画分隔线、倒角边和高光。
function UI:Line(parent, name, x, y, w, h, color, rotation)
    return self:Make("Frame", parent, name, {
        BorderSizePixel = 0,
        BackgroundColor3 = color,
        Position = UDim2.fromOffset(x, y),
        Size = UDim2.fromOffset(w, h),
        Rotation = rotation or 0,
        ZIndex = 3,
    })
end
-- 金属面板由原生底色与八块边框裁片组成；不是整图覆盖按钮。
function UI:Panel(parent, name, x, y, w, h, kind)
    local panel = self:Box(parent, name, x, y, w, h)
    panel:SetAttribute("JBSPanelKind", kind or "panel")
    local cut = kind == "card" and 10 or 16
    -- 固定倒角组成八边形底板；边框裁片单独拉伸，文字与按钮保持原生。
    local body = self:Box(panel, "Body", 0, 0, w, h)
    body.ClipsDescendants = true
    local horizontal = self:Line(body, "FillH", cut, 0, w - 2 * cut, h, C.Panel)
    local vertical = self:Line(body, "FillV", 0, cut, w, h - 2 * cut, C.Panel)
    for _, p in ipairs({ { cut, cut }, { w - cut, cut }, { cut, h - cut }, { w - cut, h - cut } }) do
        local side = cut * math.sqrt(2)
        self:Line(body, "CutFacet", p[1] - side / 2, p[2] - side / 2, side, side, C.Panel, 45)
    end
    for _, fill in ipairs({ horizontal, vertical }) do
        self:Make("UIGradient", fill, "MetalShade", {
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromHex("3C103D")),
                ColorSequenceKeypoint.new(0.35, C.Panel),
                ColorSequenceKeypoint.new(1, C.Black),
            }),
            Rotation = 90,
        })
    end
    local border = self:Box(panel, "FallbackEdge", 0, 0, w, h)
    for _, e in ipairs({
        { cut, 1, w - 2 * cut, 2, 0 },
        { cut, h - 3, w - 2 * cut, 2, 0 },
        { 1, cut, 2, h - 2 * cut, 0 },
        { w - 3, cut, 2, h - 2 * cut, 0 },
        { 1, cut / 2, cut * 1.414, 2, -45 },
        { w - cut - 3, cut / 2, cut * 1.414, 2, 45 },
        { 1, h - cut / 2 - 2, cut * 1.414, 2, 45 },
        { w - cut - 3, h - cut / 2 - 2, cut * 1.414, 2, -45 },
    }) do
        self:Line(border, "Edge", e[1], e[2], e[3], e[4], C.Border, e[5])
    end
    self:Line(border, "Specular", cut + 4, 2, math.min(120, w * 0.3), 2, C.Light)
    self:Line(border, "Laser", w - math.min(80, w * 0.2) - cut, h - 4, math.min(80, w * 0.2), 2, C.Pink)
    local meta = Assets.Meta.frame_atlas.patches[kind or "panel"]
    local r = meta.rect
    local b = meta.border
    local xs = { 0, b, r[3] - b }
    local ys = { 0, b, r[4] - b }
    local sw = { b, r[3] - 2 * b, b }
    local sh = { b, r[4] - 2 * b, b }
    local dx = { 0, b, w - b }
    local dy = { 0, b, h - b }
    local dw = { b, w - 2 * b, b }
    local dh = { b, h - 2 * b, b }
    for row = 1, 3 do
        for col = 1, 3 do
            if not (row == 2 and col == 2) then
                local image = self:Make("ImageLabel", panel, "MetalPatch", {
                    BackgroundTransparency = 1,
                    Position = UDim2.fromOffset(dx[col], dy[row]),
                    Size = UDim2.fromOffset(dw[col], dh[row]),
                    ZIndex = 4,
                })
                self.assets:Bind(image, "frame_atlas", { r[1] + xs[col], r[2] + ys[row], sw[col], sh[row] })
            end
        end
    end
    return panel
end
-- 摆放装饰图片；是否可见由资源加载状态决定。
function UI:Art(parent, name, key, x, y, w, h)
    local image = self:Make("ImageLabel", parent, name, {
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(x, y),
        Size = UDim2.fromOffset(w, h),
        ScaleType = Enum.ScaleType.Fit,
        ZIndex = 4,
    })
    self.assets:Bind(image, key)
    return image
end
-- 从同一图集读取图标，减少独立图片资源数量。
function UI:Icon(parent, key, x, y, size)
    local image = self:Make("ImageLabel", parent, "Icon_" .. key, {
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(x, y),
        Size = UDim2.fromOffset(size, size),
        ScaleType = Enum.ScaleType.Fit,
        ImageColor3 = C.Light,
        ZIndex = 5,
    })
    self.assets:Bind(image, "icon_atlas", Assets.Meta.icon_atlas.rects[key])
    return image
end
-- 建立真正可点击和键盘可聚焦的按钮，统一提供悬停与焦点反馈。
function UI:Interact(parent, name, x, y, w, h, callback)
    self.buttons += 1
    local button = self:Make("TextButton", parent, name, {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Text = "",
        AutoButtonColor = false,
        Position = UDim2.fromOffset(x, y),
        Size = UDim2.fromOffset(w, h),
        Selectable = true,
        Active = true,
        ZIndex = 8,
    })
    local focus = self:Make(
        "UIStroke",
        button,
        "KeyboardFocus",
        { Color = C.White, Thickness = 2, Transparency = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }
    )
    self.scope:Connect(button.SelectionGained, function()
        self.motion:To(focus, 0.1, { Transparency = 0 })
    end)
    self.scope:Connect(button.SelectionLost, function()
        self.motion:To(focus, 0.1, { Transparency = 1 })
    end)
    self.scope:Connect(button.MouseEnter, function()
        if button.Active then
            focus.Color = C.Light
            self.motion:To(focus, 0.12, { Transparency = 0.2 })
        end
    end)
    self.scope:Connect(button.MouseLeave, function()
        focus.Color = C.White
        self.motion:To(
            focus,
            0.12,
            { Transparency = game:GetService("GuiService").SelectedObject == button and 0 or 1 }
        )
    end)
    self.scope:Connect(button.Activated, function()
        if button.Active then
            callback()
        end
    end)
    return button
end
-- 把金属外框、文字、真实按钮组合在一起，返回可更新的引用。
function UI:Button(parent, name, text, x, y, w, h, callback, primary)
    local panel = self:Panel(parent, name, x, y, w, h, primary and "primary" or "card")
    if primary then
        local glow = self:Line(panel, "PrimaryFace", 14, 14, w - 28, h - 28, C.Pink)
        self:Make(
            "UIGradient",
            glow,
            "PrimaryGradient",
            { Rotation = 90, Color = ColorSequence.new(C.Pink, Color3.fromHex("820451")) }
        )
    end
    local label = self:Text(panel, "Caption", text, 14, 0, w - 28, h, 26, C.White, true)
    label.TextXAlignment = Enum.TextXAlignment.Center
    local button = self:Interact(panel, name .. "Action", 0, 0, w, h, callback)
    return { root = panel, button = button, label = label }
end
-- 只创建一次开关；Set(value,enabled) 更新位置、颜色和可操作状态。
function UI:Toggle(parent, name, x, y, callback, compact)
    -- 状态只有这一个固定位置：轨道下方。compact 不再把文字塞进滑块。
    local root = self:Box(parent, name, x, y, 64, 48)
    local track = self:Make("Frame", root, "Track", {
        BorderSizePixel = 0,
        BackgroundColor3 = C.Dim,
        Position = UDim2.fromOffset(5, 0),
        Size = UDim2.fromOffset(54, 26),
        ZIndex = 5,
    })
    self:Make("UICorner", track, "Pill", { CornerRadius = UDim.new(1, 0) })
    local knob = self:Make("Frame", track, "Knob", {
        BorderSizePixel = 0,
        BackgroundColor3 = C.White,
        Position = UDim2.fromOffset(3, 3),
        Size = UDim2.fromOffset(20, 20),
        ZIndex = 6,
    })
    self:Make("UICorner", knob, "Pill", { CornerRadius = UDim.new(1, 0) })
    local label = self:Text(root, "Value", "关闭", 0, 29, 64, 19, 13, C.Muted)
    label.TextXAlignment = Enum.TextXAlignment.Center
    local button = self:Interact(root, name .. "Action", 0, 0, 64, 48, callback)
    local last, previousEnabled = nil, nil
    return {
        root = root,
        button = button,
        Set = function(value, enabled)
            if value == last and enabled == previousEnabled then
                return
            end
            last = value
            previousEnabled = enabled
            button.Active = enabled
            button.Selectable = enabled
            label.Text = enabled and (value and "开启" or "关闭") or "未接入"
            self.motion:To(
                knob,
                Theme.Motion.Toggle,
                { Position = UDim2.fromOffset(value and enabled and 31 or 3, 3) }
            )
            self.motion:To(
                track,
                Theme.Motion.Toggle,
                { BackgroundColor3 = enabled and value and C.Pink or C.Dim }
            )
        end,
    }
end
-- 模块标题只保留中文；品牌英文仍在顶栏和 JBS 素材中。
function UI:Heading(parent, title, english, icon)
    self:Icon(parent, icon, 17, 10, 28)
    self:Text(parent, "Heading", title, 56, 5, 240, 38, 20, C.White, true)
    if english then
        self:Text(parent, "English", english, 180, 16, 390, 28, 18, C.Muted)
    end
end
-- 面板在窄窗中改变尺寸时，保留原切角及图集边框，不缩放里面的字体。
function UI:ResizePanel(panel, w, h)
    panel.Size = UDim2.fromOffset(w, h)
    local kind = panel:GetAttribute("JBSPanelKind") or "panel"
    local cut = kind == "card" and 10 or 16
    local function rect(object, x, y, width, height)
        object.Position = UDim2.fromOffset(x, y)
        object.Size = UDim2.fromOffset(math.max(1, width), math.max(1, height))
    end
    local body = panel:FindFirstChild("Body")
    if not body then
        return
    end
    rect(body, 0, 0, w, h)
    rect(body.FillH, cut, 0, w - 2 * cut, h)
    rect(body.FillV, 0, cut, w, h - 2 * cut)
    local corners = { { cut, cut }, { w - cut, cut }, { cut, h - cut }, { w - cut, h - cut } }
    local index = 0
    for _, child in ipairs(body:GetChildren()) do
        if child.Name == "CutFacet" then
            index += 1
            local point = corners[index]
            local side = cut * math.sqrt(2)
            rect(child, point[1] - side / 2, point[2] - side / 2, side, side)
        end
    end
    local edge = panel.FallbackEdge
    rect(edge, 0, 0, w, h)
    local edges = {
        { cut, 1, w - 2 * cut, 2 },
        { cut, h - 3, w - 2 * cut, 2 },
        { 1, cut, 2, h - 2 * cut },
        { w - 3, cut, 2, h - 2 * cut },
        { 1, cut / 2, cut * 1.414, 2 },
        { w - cut - 3, cut / 2, cut * 1.414, 2 },
        { 1, h - cut / 2 - 2, cut * 1.414, 2 },
        { w - cut - 3, h - cut / 2 - 2, cut * 1.414, 2 },
    }
    index = 0
    for _, child in ipairs(edge:GetChildren()) do
        if child.Name == "Edge" then
            index += 1
            local r = edges[index]
            rect(child, r[1], r[2], r[3], r[4])
        end
    end
    rect(edge.Specular, cut + 4, 2, math.min(120, w * 0.3), 2)
    rect(edge.Laser, w - math.min(80, w * 0.2) - cut, h - 4, math.min(80, w * 0.2), 2)
    local b = Assets.Meta.frame_atlas.patches[kind].border
    local dx, dy = { 0, b, w - b }, { 0, b, h - b }
    local dw, dh = { b, w - 2 * b, b }, { b, h - 2 * b, b }
    local pieces = {}
    for _, child in ipairs(panel:GetChildren()) do
        if child.Name == "MetalPatch" then
            table.insert(pieces, child)
        end
    end
    index = 0
    for row = 1, 3 do
        for col = 1, 3 do
            if not (row == 2 and col == 2) then
                index += 1
                rect(pieces[index], dx[col], dy[row], dw[col], dh[row])
            end
        end
    end
    local primary = panel:FindFirstChild("PrimaryFace")
    if primary then
        rect(primary, 14, 14, w - 28, h - 28)
    end
end
return UI

end
factories["Config"] = function()
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

end
factories["Controller"] = function()
--[[
    状态和生命周期：只管理“选了什么、在哪一页、开始/停止到哪一步”。
    selected = 八个开关；choices = 宠物/地点/玩家选择；parameters = 次数与数量。
    每次开始先拍摄参数快照；运行中改选择会保存到下一次开始。
    所有业务都通过 adapter 调用，界面刷新不会意外重复执行任务。
]]
-- 纯状态层：界面更新不会执行业务回调。
local Controller = {}
Controller.__index = Controller
local states = {
    Idle = "未开始",
    Starting = "启动中",
    Running = "运行中",
    Stopping = "停止中",
    Stopped = "已停止",
    Error = "错误",
}
-- 建立状态对象；读取保存的选择，但启动状态始终从未开始重新计算。
function Controller.new(adapter, persisted, save, scheduler)
    local p = persisted or {}
    return setmetatable({
        adapter = adapter,
        page = p.page or "home",
        selected = p.selected or {},
        choices = p.choices or {},
        parameters = p.parameters or { targetRebirths = 0, giftAmount = 0 },
        reduced = p.reduced == true,
        window = "Open",
        sizeMode = p.sizeMode or "Fit",
        phase = "Idle",
        message = "选择已接入的功能，然后开始。",
        listeners = {},
        owned = {},
        save = save or function() end,
        spawn = scheduler or task.spawn,
        dead = false,
        busy = false,
        actionBusy = false,
        epoch = 0,
        inputCount = 0,
        inputTotal = 0,
        inputMax = 0,
    }, Controller)
end
-- 订阅界面更新，并返回取消订阅函数供清理箱使用。
function Controller:Subscribe(fn)
    self.listeners[fn] = true
    return function()
        self.listeners[fn] = nil
    end
end
-- 通知界面重绘；persist 为 true 时顺便保存用户选择。
function Controller:Emit(persist)
    if self.dead then
        return
    end
    if persist then
        local ok, err = pcall(self.save, {
            page = self.page,
            selected = table.clone(self.selected),
            choices = table.clone(self.choices),
            parameters = table.clone(self.parameters),
            reduced = self.reduced,
            sizeMode = self.sizeMode,
        })
        if not ok then
            self.message = "设置保存失败: " .. tostring(err)
        end
    end
    for fn in pairs(self.listeners) do
        fn()
    end
end
-- 将内部英文阶段转为用户能看懂的中文。
function Controller:PhaseText()
    return states[self.phase]
end
-- 只接受已定义的页面标识；重复点击当前页不做重复刷新。
function Controller:SetPage(id)
    if self.dead then
        return
    end
    local valid = { home = true, teleport = true, pets = true, boss = true, rebirth = true, settings = true }
    if not valid[id] or self.page == id then
        return
    end
    self.page = id
    self:Emit(true)
end
-- 只允许已接入的任务被选中；这里保存开关，不执行游戏循环。
function Controller:SetSelected(id, value)
    if self.dead then
        return false
    end
    if not self.adapter:Available(id) then
        self.message = "该功能未接入，无法开启。"
        self:Emit()
        return false
    end
    if self.selected[id] == value then
        return true
    end
    self.selected[id] = value
    self.message = (self.phase == "Running" or self.phase == "Starting")
            and "选择已保存；停止后再次开始时生效。"
        or "功能选择已保存。"
    self:Emit(true)
    return true
end
-- 必须在当前真实列表中找到选项，拒绝任意字符串或过期目标。
function Controller:SetChoice(page, id)
    if self.dead then
        return false
    end
    for _, option in ipairs(self.adapter:GetOptions(page)) do
        if option.Id == id then
            self.choices[page] = id
            self:Emit(true)
            return true
        end
    end
    return false
end
-- 输入框只保存非负整数。空白和不合法内容按旧版含义回到 0。
-- targetRebirths 的 0 表示无限；giftAmount 的 0 表示全部。
function Controller:SetParameter(id, value)
    if self.dead or (id ~= "targetRebirths" and id ~= "giftAmount") then
        return
    end
    local number = tonumber(value) or 0
    if number ~= number or math.abs(number) == math.huge then
        number = 0
    end
    self.parameters[id] = math.max(0, math.floor(number))
    self.message = "参数已保存；持续任务在下次开始时读取。"
    self:Emit(true)
end
-- 只刷新可选名称，不触发购买、传送或送蛋。已消失的选择会被清空。
function Controller:RefreshOptions(page)
    if self.dead then
        return
    end
    local options = self.adapter:GetOptions(page)
    local exists = false
    for _, item in ipairs(options) do
        if item.Id == self.choices[page] then
            exists = true
        end
    end
    if not exists then
        self.choices[page] = nil
    end
    self.message = page == "pets"
            and ("已刷新宠物列表，共 " .. #options .. " 项；未连接时使用旧版内置列表。")
        or "玩家列表已更新。"
    self:Emit(true)
end
-- 执行旧版“购买一次 / 送蛋”按钮；参数先验证，再交给接线模块。
function Controller:PressControl(id)
    if self.dead or self.actionBusy or not self.adapter:CanControl(id) then
        return false
    end
    local key = id == "buyPet" and "pets" or "eggTargets"
    local target = self.choices[key]
    local exists = false
    for _, item in ipairs(self.adapter:GetOptions(key)) do
        if item.Id == target then
            exists = true
        end
    end
    if not exists then
        self.message = id == "buyPet" and "请先选择宠物/光环。"
            or "请先选择当前在线的送蛋目标。"
        self:Emit()
        return false
    end
    self.actionBusy = true
    local context = { Cancelled = false }
    self.actionContext = context
    local parameters = table.clone(self.parameters)
    parameters.pet = self.choices.pets
    parameters.eggTarget = self.choices.eggTargets
    self.message = "正在执行…"
    self:Emit()
    self.spawn(function()
        local ok, result = pcall(function()
            return self.adapter:Control(id, parameters, context)
        end)
        self.actionBusy = false
        if self.dead then
            return
        end
        if context.Cancelled then
            self:Emit()
            return
        end
        self.message = ok and (type(result) == "string" and result or "操作已完成。")
            or ("操作失败: " .. tostring(result))
        self:Emit()
    end)
    return true
end
function Controller:SetReduced(value)
    if not self.dead and self.reduced ~= value then
        self.reduced = value
        self:Emit(true)
    end
end
function Controller:SetSizeMode(value)
    if not self.dead then
        self.sizeMode = value
        self:Emit(true)
    end
end
function Controller:SetWindow(value)
    if not self.dead then
        self.window = value
        self:Emit()
    end
end
-- 停止所有本脚本拥有的任务；清理失败的任务保留，以便再次停止。
function Controller:Drain()
    local failures = {}
    local owned = self.owned
    self.owned = {}
    for id, cleanup in pairs(owned) do
        local ok, err = pcall(cleanup)
        if not ok then
            self.owned[id] = cleanup
            table.insert(failures, id .. ": " .. tostring(err))
        end
    end
    return table.concat(failures, "; ")
end
-- 把运行错误显示出来，同时尝试停止已经启动的其他任务。
function Controller:Fail(message)
    if self.dead then
        return
    end
    if self.context then
        self.context.Cancelled = true
    end
    local cleanupError = self:Drain()
    self.phase = "Error"
    self.message = tostring(message) .. (cleanupError ~= "" and ("; 清理失败: " .. cleanupError) or "")
    self:Emit()
end
-- 冻结本次任务和参数，逐项启动；防止双击或重复加载产生多个循环。
function Controller:Start()
    if self.dead or self.busy or self.phase == "Running" or self.phase == "Stopping" then
        return false
    end
    if next(self.owned) ~= nil then
        self.message = "仍有清理失败的任务；请先重试停止。"
        self:Emit()
        return false
    end
    local ids = {}
    for id, selected in pairs(self.selected) do
        if selected and self.adapter:Available(id) then
            table.insert(ids, id)
        end
    end
    table.sort(ids)
    if #ids == 0 then
        self.message = "没有已选择且已接入的任务。"
        self:Emit()
        return false
    end
    if table.find(ids, "petbuy") then
        local found = false
        for _, option in ipairs(self.adapter:GetOptions("pets")) do
            if option.Id == self.choices.pets then
                found = true
            end
        end
        if not found then
            self.message = "自动购买前请先选择宠物/光环。"
            self:Emit()
            return false
        end
    end
    self.busy = true
    self.epoch += 1
    local context = {
        Cancelled = false,
        Generation = self.epoch,
        Parameters = table.clone(self.parameters),
        Choices = table.clone(self.choices),
    }
    self.context = context
    context.ReportError = function(err)
        if self.context == context and not context.Cancelled then
            self:Fail(err)
        end
    end
    self.phase = "Starting"
    self.message = "正在启动所选任务…"
    self:Emit()
    self.spawn(function()
        local failure = nil
        for _, id in ipairs(ids) do
            if context.Cancelled or self.dead then
                break
            end
            local ok, result = pcall(function()
                return self.adapter:Start(id, context)
            end)
            if not ok then
                failure = tostring(result)
                break
            end
            if context.Cancelled or self.dead then
                local cleaned, err = pcall(result)
                if not cleaned then
                    self.owned[id] = result
                    failure = "取消后清理失败: " .. tostring(err)
                end
                break
            end
            self.owned[id] = result
        end
        self.busy = false
        if self.dead then
            self:Drain()
            return
        end
        if failure then
            self:Fail(failure)
        elseif context.Cancelled then
            if self.phase ~= "Error" then
                self.phase = "Stopped"
                self.message = "已停止本脚本任务。"
                self:Emit()
            end
        else
            self.phase = "Running"
            self.message = "所选任务已启动。"
            self:Emit()
        end
    end)
    return true
end
-- 先发出取消标记，再释放已拥有的任务；不会清理无关游戏资源。
function Controller:Stop()
    if self.dead then
        return
    end
    if self.context then
        self.context.Cancelled = true
    end
    if self.actionContext then
        self.actionContext.Cancelled = true
    end
    self.phase = "Stopping"
    self.message = "正在停止本脚本任务…"
    self:Emit()
    local errorMessage = self:Drain()
    if errorMessage ~= "" then
        self.phase = "Error"
        self.message = "清理失败: " .. errorMessage
        self:Emit()
        return
    end
    if not self.busy then
        self.phase = "Stopped"
        self.message = "已停止本脚本任务。"
        self:Emit()
    end
end
-- 兼容接入的选择类操作（例如传送）；同一时刻只执行一个按钮动作。
function Controller:Perform(page)
    if self.dead or self.actionBusy or not self.adapter:CanPerform(page) then
        return false
    end
    local id = self.choices[page]
    if not id then
        self.message = "请先选择一个有效选项。"
        self:Emit()
        return false
    end
    self.actionBusy = true
    local context = { Cancelled = false }
    self.actionContext = context
    self.message = "正在执行…"
    self:Emit()
    self.spawn(function()
        local ok, result = pcall(function()
            return self.adapter:Perform(page, id, context)
        end)
        self.actionBusy = false
        if self.dead then
            return
        end
        if context.Cancelled then
            self:Emit()
            return
        end
        self.message = ok and (type(result) == "string" and result or "操作已完成。")
            or ("操作失败: " .. tostring(result))
        self:Emit()
    end)
    return true
end
-- 最终销毁；让晚返回的异步启动也看到取消标记。
function Controller:Destroy()
    if self.dead then
        return
    end
    self.dead = true
    if self.context then
        self.context.Cancelled = true
    end
    if self.actionContext then
        self.actionContext.Cancelled = true
    end
    local err = self:Drain()
    if err ~= "" then
        warn("JBS destroy cleanup:", err)
    end
    table.clear(self.listeners)
end
return Controller

end
factories["HeroAvatar"] = function()
--[[
    正背面共享外观的生命周期管理。生产来源始终由 Runtime 传入 LocalPlayer。
    Character 优先；账号模型仅为明确标注的备用。没有 GetUserThumbnail 或固定账号。
    不监听 CFrame/Transform，不使用 RunService，不跟踪游戏动作。

    阅读顺序：new → SetCharacter → MarkDirty → Refresh → Commit。
    隐藏/销毁：取消调度、使请求令牌过期、断开适当监听并清理展示实例。
    Roblox 账号 API 的进行中请求不能可靠取消；晚到模型只销毁，不再挂载。
]]
local Snapshot = requireModule("AvatarSnapshot")
local Display = requireModule("AvatarDisplay")
local RefreshMath = requireModule("AvatarRefresh")
local AccountRequest = requireModule("AvatarAccountRequest")
local HeroAvatar = {}
HeroAvatar.__index = HeroAvatar
local bodyColors =
    { "HeadColor3", "LeftArmColor3", "RightArmColor3", "LeftLegColor3", "RightLegColor3", "TorsoColor3" }
local function appearanceProperties(v)
    if v:IsA("BasePart") then
        local p = { "Size", "Color", "Transparency", "Material" }
        if v:IsA("MeshPart") then
            table.insert(p, "MeshId")
            table.insert(p, "TextureID")
        end
        return p
    elseif v:IsA("DataModelMesh") then
        return { "Scale", "Offset", "MeshId", "TextureId" }
    elseif v:IsA("Decal") then
        return { "Texture", "Color3", "Transparency" }
    elseif v:IsA("Shirt") then
        return { "ShirtTemplate" }
    elseif v:IsA("Pants") then
        return { "PantsTemplate" }
    elseif v:IsA("ShirtGraphic") then
        return { "Graphic" }
    elseif v:IsA("BodyColors") then
        return bodyColors
    elseif v:IsA("SurfaceAppearance") then
        return { "ColorMap", "MetalnessMap", "NormalMap", "RoughnessMap", "AlphaMode" }
    elseif v:IsA("CharacterMesh") then
        return { "BodyPart", "MeshId", "BaseTextureId", "OverlayTextureId" }
    elseif v:IsA("WrapLayer") then
        return { "Enabled", "Order", "Puffiness", "CageMeshId", "ReferenceMeshId" }
    elseif v:IsA("WrapTarget") then
        return { "CageMeshId" }
    elseif v:IsA("NumberValue") and v.Parent and v.Parent:IsA("Humanoid") then
        return { "Value" }
    end
    return {}
end
local function relevant(v)
    return #appearanceProperties(v) > 0
        or v:IsA("Accessory")
        or v:IsA("Humanoid")
        or v:IsA("Attachment")
        or v:IsA("JointInstance")
        or v:IsA("WeldConstraint")
        or v:IsA("BillboardGui")
        or v:IsA("SurfaceGui")
end
local function disconnect(list)
    for _, connection in ipairs(list) do
        connection:Disconnect()
    end
    table.clear(list)
end
function HeroAvatar.new(player, viewport, statusLabel, options, testDependencies)
    options = options or {}
    -- 仅 Studio 测试入口可注入延迟/失败的账号服务；生产配置不接受此字段。
    if testDependencies then
        assert(game:GetService("RunService"):IsStudio(), "测试替身仅限 Studio")
    end
    local self = setmetatable({
        player = player,
        viewport = viewport,
        label = statusLabel,
        visible = false,
        dead = false,
        version = 0,
        revision = 0,
        requestSequence = 0,
        appearanceVersion = 0,
        views = {},
        viewOrder = {},
        commitFailures = 0,
        testDependencies = testDependencies,
        timers = {},
        connections = {},
        characterConnections = {},
        watched = {},
        dirty = true,
        lastBuild = -math.huge,
        buildCount = 0,
        discarded = 0,
        fallbackAttempts = 0,
        readyAttempts = 0,
        state = "等待显示",
        source = "none",
        debounce = math.clamp(options.Debounce or 0.45, 0.3, 0.6),
        maxWait = math.max(0.6, options.MaxWait or 1.2),
        minInterval = math.max(0.5, options.MinInterval or 1.5),
        maxReady = math.clamp(options.ReadyAttempts or 8, 1, 20),
        fallbackTimeout = math.max(3, options.FallbackTimeout or 12),
        fov = math.clamp(options.FieldOfView or 35, 20, 70),
        maxDescendants = options.MaxDescendants or 2000,
    }, HeroAvatar)
    self.fetchAccount = testDependencies and testDependencies.FetchAccount
        or function(userId)
            return game:GetService("Players"):CreateHumanoidModelFromUserIdAsync(userId)
        end
    table.insert(
        self.connections,
        player.CharacterAdded:Connect(function(character)
            self:SetCharacter(character)
        end)
    )
    table.insert(
        self.connections,
        player.CharacterRemoving:Connect(function(character)
            if character == self.character then
                self:SetCharacter(nil)
            end
        end)
    )
    self:AddView("front", viewport, statusLabel, "front", self.fov)
    -- 先连事件再读 Character，防止漏掉“脚本启动之前就已生成”的角色。
    self:SetCharacter(player.Character)
    return self
end
-- 每处只新增尺寸监听；Character/衣服/配饰监听仍由这个管理器唯一持有。
function HeroAvatar:AddView(id, viewport, label, direction, fov)
    assert(not self.dead and not self.views[id], "展示区重复或已销毁")
    local display = Display.new(id, viewport, label, direction, fov or self.fov)
    self.views[id] = display
    table.insert(self.viewOrder, id)
    table.insert(
        self.connections,
        viewport:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
            display:Resize()
        end)
    )
    return display
end
function HeroAvatar:SyncFrontAliases()
    -- 保留第一阶段的诊断/QA 访问方式；真正实例所有权在各 Display.current 中。
    local record = self.views.front.current
    self.active = record and record.snapshot or nil
    self.world = record and record.world or nil
    self.camera = record and record.camera or nil
end
function HeroAvatar:HasDisplay()
    for _, display in pairs(self.views) do
        if display.current then
            return true
        end
    end
    return false
end
function HeroAvatar:CaptureRequest()
    return { character = self.version, request = self.requestSequence, revision = self.revision }
end
function HeroAvatar:IsCurrent(token)
    return not self.dead
        and self.visible
        and token.character == self.version
        and token.request == self.requestSequence
        and token.revision == self.revision
end
function HeroAvatar:SetState(message, compact)
    if self.dead then
        return
    end
    self.state = message
    for id, display in pairs(self.views) do
        display.label.Text = id == "back" and (compact or message) or message
    end
end
function HeroAvatar:CancelTimer(key)
    local thread = self.timers[key]
    self.timers[key] = nil
    if thread then
        pcall(task.cancel, thread)
    end
end
function HeroAvatar:After(key, seconds, callback)
    self:CancelTimer(key)
    self.timers[key] = task.delay(seconds, function()
        self.timers[key] = nil
        if not self.dead then
            callback()
        end
    end)
end
function HeroAvatar:ClearTimers()
    local keys = {}
    for key in pairs(self.timers) do
        table.insert(keys, key)
    end
    for _, key in ipairs(keys) do
        self:CancelTimer(key)
    end
end
function HeroAvatar:CancelAccountSubscription()
    if self.cancelAccount then
        self.cancelAccount()
        self.cancelAccount = nil
    end
    if self.pendingFallback then
        self.pendingFallback.expired = true
        self.pendingFallback = nil
    end
end
function HeroAvatar:Unwatch(v)
    if self.watched[v] then
        disconnect(self.watched[v])
        self.watched[v] = nil
    end
end
function HeroAvatar:Watch(v)
    if self.watched[v] then
        return
    end
    local list = {}
    for _, property in ipairs(appearanceProperties(v)) do
        -- API 版本可能没有某个外观字段；只略过不存在的字段，不监听所有属性替代。
        local ok, signal = pcall(v.GetPropertyChangedSignal, v, property)
        if ok then
            table.insert(
                list,
                signal:Connect(function()
                    self:MarkDirty()
                end)
            )
        end
    end
    if #list > 0 then
        self.watched[v] = list
    end
end
function HeroAvatar:ClearCharacterConnections()
    disconnect(self.characterConnections)
    local instances = {}
    for instance in pairs(self.watched) do
        table.insert(instances, instance)
    end
    for _, instance in ipairs(instances) do
        self:Unwatch(instance)
    end
end
function HeroAvatar:SetCharacter(character)
    if self.dead or self.character == character and self.characterInitialized then
        return
    end
    self.characterInitialized = true
    self:ClearCharacterConnections()
    self:CancelAccountSubscription()
    self.version += 1
    self.revision += 1
    self:ClearTimers()
    self.character = character
    self.characterReady = false
    self.readyAttempts = 0
    self.fallbackAttempts = 0
    self.firstDirty = nil
    if character then
        local descendants = character:GetDescendants()
        if #descendants <= self.maxDescendants then
            for _, v in ipairs(descendants) do
                self:Watch(v)
            end
        end
        table.insert(
            self.characterConnections,
            character.DescendantAdded:Connect(function(v)
                if #character:GetDescendants() <= self.maxDescendants then
                    self:Watch(v)
                end
                if relevant(v) then
                    self.readyAttempts = 0
                    self:MarkDirty()
                end
            end)
        )
        table.insert(
            self.characterConnections,
            character.DescendantRemoving:Connect(function(v)
                self:Unwatch(v)
                for _, child in ipairs(v:GetDescendants()) do
                    self:Unwatch(child)
                end
                if relevant(v) then
                    self:MarkDirty()
                end
            end)
        )
        table.insert(
            self.characterConnections,
            character.AncestryChanged:Connect(function()
                self:MarkDirty()
            end)
        )
    end
    self:MarkDirty()
end
function HeroAvatar:MarkDirty(retry)
    if self.dead then
        return
    end
    self.dirty = true
    if not retry then
        self.revision += 1
        self.requestSequence += 1
        self.commitFailures = 0
        -- 真正的外观变更使旧异步订阅过期；再次订阅仍复用同一未完成引擎请求。
        if self.pendingFallback then
            self:CancelAccountSubscription()
            self:CancelTimer("fallback-timeout")
            self.fallbackAttempts = 0
        end
    end
    if self.visible and self:HasDisplay() then
        self:SetState("外观更新中 · 保留上一版", "更新中 · v" .. self.appearanceVersion)
    end
    local now = os.clock()
    self.firstDirty = self.firstDirty or now
    if not self.visible then
        return
    end -- 仅记录，隐藏时没有复制/账号请求/定时重试。
    local due =
        RefreshMath.Due(self.firstDirty, now, self.lastBuild, self.debounce, self.maxWait, self.minInterval)
    self:After("refresh", math.max(0, due - now), function()
        self:Refresh()
    end)
end
function HeroAvatar:Release()
    for _, display in pairs(self.views) do
        display:Release()
    end
    self:SyncFrontAliases()
    self.source = "none"
end
-- 两处独立显隐：离开首页时释放正面，仍可见的侧栏继续由同一个来源更新。
function HeroAvatar:SetViewVisibility(visibility)
    if self.dead then
        return
    end
    local changed, any = false, false
    for id, display in pairs(self.views) do
        local visible = visibility[id] == true
        if visible ~= display.visible then
            changed = true
            display.visible = visible
            display.viewport.Visible = visible
            if not visible then
                display:Release()
            end
        end
        any = any or visible
    end
    if not changed then
        return
    end
    self.visible = any
    self.version += 1
    self:ClearTimers()
    self:CancelAccountSubscription()
    self:SyncFrontAliases()
    if not any then
        self.source = "none"
        self.characterReady = false
        self.dirty = true
        self.firstDirty = nil
        self:SetState("角色展示已暂停", "展示已暂停")
    else
        self.readyAttempts = 0
        self.fallbackAttempts = 0
        self:SetState("正在读取当前角色…", "角色更新中…")
        self:MarkDirty()
    end
end
-- 保留原单视图 API；测试或整体关闭时同时控制所有已登记展示区。
function HeroAvatar:SetVisible(visible)
    local flags = {}
    for id in pairs(self.views) do
        flags[id] = visible
    end
    self:SetViewVisibility(flags)
end
function HeroAvatar:FitCamera()
    self.views.front:Resize()
end
function HeroAvatar:Commit(snapshot, source, token)
    if not self:IsCurrent(token) or self.committing then
        snapshot.model:Destroy()
        self.discarded += 1
        return false
    end
    self.committing = true
    local nextVersion = self.appearanceVersion + 1
    local candidates, old, models = {}, {}, { snapshot.model }
    local preparedCount = 0
    local ok, problem = pcall(function()
        -- 仅从这一份净化快照复制第二份；不再读取一次真实 Character 或账号资料。
        for _, id in ipairs(self.viewOrder) do
            local display = self.views[id]
            if display.visible then
                if self.testDependencies and self.testDependencies.BeforePrepareView then
                    self.testDependencies.BeforePrepareView(id)
                end
                local currentSnapshot = snapshot
                if preparedCount > 0 then
                    local model, reason = Snapshot.Copy(snapshot.model)
                    assert(model, reason)
                    table.insert(models, model)
                    currentSnapshot = { model = model, bounds = snapshot.bounds, report = snapshot.report }
                end
                local record = display:Prepare(currentSnapshot, nextVersion, source)
                table.insert(candidates, { display = display, record = record })
                old[display] = display.current
                preparedCount += 1
            end
        end
        assert(preparedCount > 0 and self:IsCurrent(token), "外观请求已过期")
        -- 提交段不 yield。旧模型仍保留到全部成功，异常时可回滚专用相机。
        for _, entry in ipairs(candidates) do
            if self.testDependencies and self.testDependencies.BeforeAttachView then
                self.testDependencies.BeforeAttachView(entry.display.id)
            end
            assert(self:IsCurrent(token) and entry.display.visible, "提交期间请求已过期")
            entry.display:Attach(entry.record)
        end
        assert(self:IsCurrent(token), "提交结束前请求已过期")
    end)
    self.committing = false
    if not ok then
        local restored = true
        for _, entry in ipairs(candidates) do
            local display = entry.display
            local previous = display.current == old[display] and old[display] or display.current
            local recovered = pcall(display.Restore, display, previous)
            restored = recovered and restored
        end
        for _, entry in ipairs(candidates) do
            Display.Dispose(entry.record)
        end
        for _, model in ipairs(models) do
            model:Destroy()
        end
        if not restored then
            self:Release()
        end -- 控件已失效时一致降级，不能留半套新旧外观。
        self:SyncFrontAliases()
        if self:IsCurrent(token) then
            self.lastError = tostring(problem)
            self.commitFailures += 1
            local retained = self:HasDisplay()
            self:SetState(
                retained and "外观更新失败 · 保留上一组" or "角色展示失败 · 等待重试",
                retained and "更新失败 · 旧版保留" or "角色展示失败"
            )
            if self.commitFailures < 3 then
                self:After("commit-retry", self.minInterval, function()
                    self:MarkDirty(true)
                end)
            end
        else
            self.discarded += 1
        end
        return false
    end
    -- 对外版本号和所有权一起发布；此前没有把半套候选写进 Display.current。
    for _, entry in ipairs(candidates) do
        entry.display.current = entry.record
    end
    self.appearanceVersion = nextVersion
    self.committedRequest = token.request
    self.source = source
    self.buildCount += 1
    self.commitFailures = 0
    self.lastError = nil
    self:CancelTimer("commit-retry")
    self:SyncFrontAliases()
    for _, entry in ipairs(candidates) do
        Display.Dispose(old[entry.display])
    end
    local detail = source == "character" and "当前游戏角色" or "账号外观备用 · 非游戏体型"
    local compact = source == "character" and "游戏角色" or "账号备用"
    if #snapshot.report.unsupported > 0 then
        detail ..= " · 二维标签未支持"
        compact ..= " · 有限制"
    end
    if #snapshot.report.excluded > 0 then
        detail ..= " · 已排除异常装饰"
        compact ..= " · 有排除"
    end
    self:SetState(detail .. " · v" .. nextVersion, compact .. " · v" .. nextVersion)
    return true
end
function HeroAvatar:Fallback(token)
    if self.dead or not self.visible or self.pendingFallback or self.fallbackAttempts >= 2 then
        return
    end
    if self.source == "account" and self:HasDisplay() then
        local allVisibleReady = self.committedRequest == token.request
        for _, display in pairs(self.views) do
            if display.visible and not display.current then
                allVisibleReady = false
            end
        end
        if allVisibleReady then
            return
        end
        -- 单处恢复时，现有账号副本可作为同一来源；只在无 yield 提交期短暂复制。
        local existing
        for _, display in pairs(self.views) do
            if display.current then
                existing = display.current.snapshot
                break
            end
        end
        local copy, reason = Snapshot.Copy(existing.model)
        if copy then
            self:Commit(
                { model = copy, bounds = existing.bounds, report = existing.report },
                "account",
                token
            )
        else
            self.lastError = reason
            self:SetState("备用外观复制失败 · 保留上一组", "备用更新失败")
        end
        return
    end
    self.fallbackAttempts += 1
    local ticket = { token = token, expired = false }
    self.pendingFallback = ticket
    self:SetState("正在读取账号备用外观…", "账号备用读取中…")
    self:After("fallback-timeout", self.fallbackTimeout, function()
        if self.pendingFallback == ticket then
            ticket.expired = true
            self:SetState("账号备用超时 · 等待角色就绪", "备用超时 · 等待角色")
        end
    end)
    -- 引擎请求由小型共享请求器拥有，窗口只持有可撤销的订阅。
    self.cancelAccount = AccountRequest.Subscribe(self.player.UserId, self.fetchAccount, function(ok, model)
        if self.pendingFallback == ticket then
            self.pendingFallback = nil
            self:CancelTimer("fallback-timeout")
        end
        local stale = not self:IsCurrent(ticket.token) or ticket.expired or self.characterReady
        if stale then
            if ok and model then
                model:Destroy()
            end
            self.discarded += 1
            if not self.dead and self.visible and not self.characterReady and not self.pendingFallback then
                self:MarkDirty(true)
            end
            return
        end
        if ok and model then
            local ready, snapshot = pcall(Snapshot.Prepare, model)
            if ready then
                self:Commit(snapshot, "account", token)
            else
                model:Destroy()
                self.lastError = tostring(snapshot)
                self:SetState(
                    "账号外观不兼容 · 等待游戏角色",
                    "备用不兼容 · 等待角色"
                )
            end
        else
            self.lastError = tostring(model)
            self:SetState("账号外观加载失败 · 等待游戏角色", "备用失败 · 等待角色")
            if self.fallbackAttempts < 2 then
                self:After("fallback-retry", 3, function()
                    self:Fallback(self:CaptureRequest())
                end)
            end
        end
    end)
end
function HeroAvatar:Refresh()
    if self.dead or not self.visible then
        return
    end
    self.dirty = false
    self.firstDirty = nil
    self.lastBuild = os.clock()
    local token = self:CaptureRequest()
    local character = self.character
    local snapshot, reason
    local started = os.clock()
    if character and character.Parent and #character:GetDescendants() <= self.maxDescendants then
        snapshot, reason = Snapshot.FromCharacter(character)
    else
        reason = "Character 未就绪或超出展示部件上限"
    end
    self.lastBuildMs = (os.clock() - started) * 1000
    if snapshot then
        self.characterReady = true
        self:CancelTimer("ready")
        self:CancelTimer("fallback-retry")
        self:CancelTimer("fallback-timeout")
        self:CancelAccountSubscription()
        self:Commit(snapshot, "character", token)
        return
    end
    self.characterReady = false
    self.lastError = reason
    self.readyAttempts += 1
    if self:HasDisplay() then
        self:SetState(
            (self.source == "account" and "账号外观备用" or "保留上次游戏快照")
                .. " · 当前角色待就绪",
            self.source == "account" and "账号备用 · 等待角色" or "上版快照 · 等待角色"
        )
    else
        self:SetState("当前角色待就绪…")
    end
    if self.readyAttempts < self.maxReady then
        self:After("ready", math.max(0.5, self.minInterval), function()
            self:MarkDirty(true) -- 有限就绪重试不代表新外观，不使进行中的账号请求无故过期。
        end)
    end
    -- 首次短暂缺头/衣服给就绪检查机会；两次仍失败才使用账号备用。
    if self.readyAttempts >= 2 then
        self:Fallback(token)
    end
    if self.readyAttempts >= self.maxReady and not self:HasDisplay() and not self.pendingFallback then
        self:SetState("角色暂不可用 · 等待外观变化", "角色暂不可用")
    end
end
function HeroAvatar:Diagnostics()
    local connections = #self.connections + #self.characterConnections
    for _, list in pairs(self.watched) do
        connections += #list
    end
    local timers = 0
    for _ in pairs(self.timers) do
        timers += 1
    end
    local models, worlds, cameras, instances = 0, 0, 0, 0
    local views = {}
    for id, display in pairs(self.views) do
        local d = display:Diagnostics()
        views[id] = d
        models += d.activeModels
        worlds += d.worlds
        cameras += d.cameras
        instances += d.modelInstances
    end
    return {
        appearanceVersion = self.appearanceVersion,
        requestSequence = self.requestSequence,
        committedRequest = self.committedRequest,
        views = views,
        sourceListenerSets = self.dead and 0 or 1,
        state = self.state,
        source = self.source,
        visible = self.visible,
        destroyed = self.dead,
        activeModels = models,
        worlds = worlds,
        cameras = cameras,
        modelInstances = instances,
        connections = connections,
        scheduledTasks = timers,
        pendingAccountRequest = self.pendingFallback ~= nil,
        packageAccountRequests = AccountRequest.PendingCount(),
        builds = self.buildCount,
        discarded = self.discarded,
        lastBuildMs = self.lastBuildMs,
        lastError = self.lastError,
        report = self.active and self.active.report or nil,
        hiddenPolicy = "release display; keep filtered appearance listeners; no background rebuild",
    }
end
function HeroAvatar:Destroy()
    if self.dead then
        return
    end
    self.dead = true
    self.visible = false
    self.version += 1
    self:ClearTimers()
    self:CancelAccountSubscription()
    disconnect(self.connections)
    self:ClearCharacterConnections()
    self:Release()
    self.character = nil
    self.state = "已销毁"
end
return HeroAvatar

end
factories["Layout"] = function()
--[[
    第一阶段排版参数与自适应：只调整现有控件的尺寸/位置，不触碰游戏回调。
    默认 100% 逻辑字号；窗口变窄时快捷卡三列变两列，中栏可滚动。
    面板边框复用 Components.ResizePanel，重排不会新建控件或事件。
]]
local Layout = {}
local function rect(object, x, y, w, h)
    object.Position = UDim2.fromOffset(x, y)
    object.Size = UDim2.fromOffset(math.max(1, w), math.max(1, h))
end
local function text(object, x, y, w, h, size, wrapped)
    rect(object, x, y, w, h)
    object.TextSize = size
    object.TextScaled = false
    object.TextWrapped = wrapped == true
    object.TextTruncate = Enum.TextTruncate.None
    object.LineHeight = 1.35
end
function Layout.Compute(width, height, comfort)
    local scale = comfort and 0.9 or 1
    local w, h = math.min(1672, (width - 16) / scale), math.min(941, (height - 16) / scale)
    local narrow = w < 1500
    local left, right = narrow and 176 or 246, narrow and 288 or 326
    local center = w - left - right - 24
    local columns = center >= 990 and 3 or (center >= 640 and 2 or 1)
    local hero = narrow and math.max(225, center * 380 / 1085) or 310
    local rows = math.ceil(6 / columns)
    local quick = 52 + rows * 112 + (rows - 1) * 14 + 58
    local short = h < 900
    return {
        width = w,
        height = h,
        scale = scale,
        narrow = narrow,
        left = left,
        right = right,
        centerX = left + 12,
        centerW = center,
        rightX = w - right,
        centerH = h - 269,
        columns = columns,
        cardW = (center - 32 - (columns - 1) * 14) / columns,
        heroH = hero,
        quickH = quick,
        statusH = short and 288 or 346,
        settingsY = short and 376 or 434,
        settingsH = short and 302 or 318,
        userY = short and 690 or h - 177,
        userH = short and h - 717 or 150,
        short = short,
    }
end
function Layout.Apply(v, viewportWidth, viewportHeight)
    local l = Layout.Compute(viewportWidth, viewportHeight, v.controller.sizeMode == "Comfort")
    v.layout = l
    local u = v.u
    local function panel(object, x, y, w, h)
        object.Position = UDim2.fromOffset(x, y)
        u:ResizePanel(object, w, h)
    end
    v.scale.Scale = l.scale
    v.root.Size = UDim2.fromOffset(l.width, l.height)
    -- 外壳跟随可用窗口，只有中间内容拥有独立滚动范围。
    v.viewport.CanvasSize = UDim2.fromOffset(viewportWidth, viewportHeight)
    v.homePosition = UDim2.fromOffset(
        math.max(8, (viewportWidth - l.width * l.scale) / 2),
        math.max(8, (viewportHeight - l.height * l.scale) / 2)
    )
    panel(v.shell, 0, 0, l.width, l.height)
    rect(v.center, l.centerX, 62, l.centerW, l.centerH)
    local homeHeight = l.heroH + 12 + l.quickH
    v.pages.home.Size = UDim2.fromOffset(l.centerW, homeHeight)
    v.center.CanvasSize = v.controller.page == "home" and UDim2.fromOffset(0, homeHeight)
        or UDim2.fromOffset(1084, 658)
    panel(v.hero, 0, 0, l.centerW, l.heroH)
    rect(v.hero.Hero, 3, 3, l.centerW - 6, l.heroH - 6)
    rect(v.hero.HeroPending, 20, 20, l.centerW - 40, l.heroH - 40)
    panel(v.quick, 0, l.heroH + 12, l.centerW, l.quickH)
    local rows = math.ceil(6 / l.columns)
    local gridHeight = rows * 112 + (rows - 1) * 14
    rect(v.cardGrid, 16, 52, l.centerW - 32, gridHeight)
    v.gridLayout.CellSize = UDim2.fromOffset(l.cardW, 112)
    v.gridLayout.FillDirectionMaxCells = l.columns
    for _, card in ipairs(v.cards) do
        u:ResizePanel(card.root, l.cardW, 112)
        local actionWidth = card.hit and 30 or 64
        local textWidth = l.cardW - 72 - 16 - actionWidth - 16
        text(card.title, 72, 27, textWidth, 29, 21)
        text(card.description, 72, 60, textWidth, 23, 16)
        rect(
            card.action,
            l.cardW - 16 - actionWidth,
            card.hit and 42 or 32,
            actionWidth,
            card.hit and 27 or 48
        )
        if card.hit then
            rect(card.hit, 0, 0, l.cardW, 112)
        end
    end
    rect(v.parameterRow, 16, 52 + gridHeight + 8, l.centerW - 32, 44)
    rect(v.parameterRow.Divider, 0, 0, l.centerW - 32, 1)
    local sidebar = v.root.Sidebar
    panel(sidebar, 0, 0, l.left, l.height - 27)
    rect(sidebar.Logo, 5, 5, l.left - 10, l.narrow and 118 or 150)
    rect(sidebar.LogoPending, 10, 10, l.left - 20, 120)
    rect(sidebar.Navigation, 8, l.narrow and 135 or 170, l.left - 16, 430)
    sidebar.Navigation.NavigationLayout.Padding = UDim.new(0, l.narrow and 9 or 10)
    for _, nav in pairs(v.nav) do
        local rowHeight = l.narrow and 55 or 62
        u:ResizePanel(nav.shell, l.left - 16, rowHeight)
        rect(nav.face, 6, 5, l.left - 28, rowHeight - 10)
        rect(nav.button, 0, 0, l.left - 16, rowHeight)
        text(
            nav.label,
            l.narrow and 52 or 76,
            0,
            l.left - (l.narrow and 76 or 102),
            rowHeight,
            l.narrow and 20 or 24
        )
        for _, child in ipairs(nav.shell:GetChildren()) do
            if child.Name:sub(1, 5) == "Icon_" then
                rect(child, 14, (rowHeight - 34) / 2, 34, 34)
            end
        end
    end
    local artHeight = math.min(245, l.left * 245 / 248)
    rect(sidebar.SidebarArt, 0, l.height - 65 - artHeight, l.left, artHeight)
    rect(sidebar.SidebarArtPending, 10, l.height - 65 - artHeight, l.left - 20, artHeight)
    text(sidebar.BrandClose, 10, l.height - 61, l.left - 20, 27, l.narrow and 13 or 17)
    local bar = v.root.Topbar
    local barWidth = l.width - l.centerX
    panel(bar, l.centerX, 0, barWidth, 60)
    text(bar.Brand, 28, 5, 370, 46, 18)
    bar.Motto.Visible = not l.narrow
    text(bar.Motto, 410, 8, barWidth - 850, 40, 13)
    rect(bar.BrandSlogan, barWidth - 430, 0, 220, 56)
    rect(v.dragHandle, 14, 4, barWidth - 206, 48)
    for index, name in ipairs({ "Minimize", "Resize", "Close" }) do
        rect(bar:FindFirstChild(name), barWidth - 192 + (index - 1) * 64, 5, 60, 45)
        rect(bar:FindFirstChild(name .. "Icon"), barWidth - 192 + (index - 1) * 64, 5, 60, 45)
    end
    panel(v.controlPanel, l.centerX, l.height - 189, l.centerW, 162)
    local usable = l.centerW - (l.narrow and 40 or 284)
    local buttonWidth = (usable - 14) / 2
    for index, item in ipairs({ { v.start, "play" }, { v.stop, "stop" } }) do
        local button = item[1]
        panel(button.root, 20 + (index - 1) * (buttonWidth + 14), 45, buttonWidth, 64)
        rect(button.button, 0, 0, buttonWidth, 64)
        local titleX = math.max(68, (buttonWidth - 184) / 2 + 56)
        text(button.label, titleX, 0, buttonWidth - titleX - 12, 64, 24)
        rect(button.root:FindFirstChild("Icon_" .. item[2]), titleX - 52, 13, 38, 38)
    end
    local art = v.controlPanel.ControlArt
    rect(art, l.centerW - 238, 10, 225, 129)
    -- 窄窗只收起这处装饰留白，人物图片文件保持原样。
    art.Visible = not l.narrow and v.assets.status.control_art == "已加载"
    v.controlPanel.ControlArtPending.Visible = not l.narrow and v.assets.status.control_art ~= "已加载"
    rect(v.feedbackArea, 24, 115, usable - 8, 36)
    v.banner.Size = UDim2.fromOffset(usable - 16, 36)
    panel(v.statusPanel, l.rightX, 76, l.right, l.statusH)
    local rowHeight = (l.statusH - 64) / 3
    for index, row in ipairs({ v.environment, v.lifecycle, v.version }) do
        local y = 52 + (index - 1) * rowHeight
        rect(row.icon, 22, y + 18, 32, 32)
        text(row.title, 66, y, l.right - 144, 27, 18)
        text(row.detail, 66, y + 30, l.right - 144, 42, 14, true)
        text(row.badge, l.right - 66, y + 5, 46, 26, 13)
        rect(row.separator, 22, y + rowHeight - 6, l.right - 44, 1)
    end
    panel(v.settingsPanel, l.rightX, l.settingsY, l.right, l.settingsH)
    for index = 4, 8 do
        local f = requireModule("Theme").Features[index]
        local y = (l.short and 48 or 52) + (index - 4) * 48
        rect(v.settingsPanel:FindFirstChild("Icon_" .. f.icon), 24, y + 9, 26, 26)
        text(v.settingsPanel:FindFirstChild("Label_" .. f.id), 62, y + 7, l.right - 158, 30, 18)
        rect(v.toggles[f.id].root, l.right - 86, y, 64, 48)
    end
    panel(v.userPanel, l.rightX, l.userY, l.right, l.userH)
    rect(v.userPanel.Icon_crown, 22, 16, 30, 30)
    text(v.userPanel.Username, 64, 11, l.right - 80, 26, 18)
    text(v.userPanel.Permission, 64, 37, l.right - 80, 20, 13)
    rect(v.userPanel.Divider, 22, 62, l.right - 44, 1)
    rect(v.userPanel.Icon_gem, 22, 79, 30, 30)
    text(v.userPanel.Quote, 64, 72, l.right - 82, 24, l.short and 13 or 15)
    text(v.userPanel.Quote2, 64, 96, l.right - 82, 24, l.short and 13 or 15)
    text(v.footer, l.centerX, l.height - 24, l.width - l.centerX, 20, 10)
end
return Layout

end
factories["LegacyCatalog"] = function()
-- 旧版 UI 名称与选项清单（自动生成，中文未改名）。
-- 修改 catalog/PreviousUI.json，再运行 tools/sync_catalog.py。
-- 坐标只作为原版资料保存；本模块不会移动角色、购买宠物或启动任务。
local catalog = {
    ["source"] = {
        ["path"] = "original-source-not-distributed",
        ["sha256"] = "cbbbdb2ace19bf70cb90641a713364a95961ef6ace9af4be78832d060f9793d7",
        ["description"] = "上一版 JBS 粉紫暗铬 UI 的真实声明；只读取名称和选项，不执行业务代码",
        ["note"] = "原始来源不随本仓库分发；保留哈希与行号用于追溯，当前功能名称已整理在此文件。",
    },
    ["pages"] = {
        {
            "home",
            "主要",
            "home",
        },
        {
            "teleport",
            "传送",
            "teleport",
        },
        {
            "pets",
            "宠物",
            "pet",
        },
        {
            "boss",
            "Boss",
            "boss",
        },
        {
            "rebirth",
            "换包重生",
            "rebirth",
        },
        {
            "settings",
            "设置",
            "settings",
        },
    },
    ["controls"] = {
        {
            ["id"] = "targetRebirths",
            ["page"] = "home",
            ["kind"] = "Input",
            ["label"] = "目标次数",
            ["sourceLine"] = 779,
            ["placeholder"] = "重生目标，0为无限",
        },
        {
            ["id"] = "rebirth",
            ["page"] = "home",
            ["kind"] = "Toggle",
            ["label"] = "自动重生",
            ["sourceLine"] = 789,
        },
        {
            ["id"] = "train",
            ["page"] = "home",
            ["kind"] = "Toggle",
            ["label"] = "自动锻炼",
            ["sourceLine"] = 806,
        },
        {
            ["id"] = "spin",
            ["page"] = "home",
            ["kind"] = "Toggle",
            ["label"] = "自动轮盘",
            ["sourceLine"] = 829,
        },
        {
            ["id"] = "petChoice",
            ["page"] = "pets",
            ["kind"] = "Dropdown",
            ["label"] = "选择宠物/光环",
            ["sourceLine"] = 887,
        },
        {
            ["id"] = "refreshPets",
            ["page"] = "pets",
            ["kind"] = "Button",
            ["label"] = "刷新宠物列表",
            ["sourceLine"] = 896,
        },
        {
            ["id"] = "buyPet",
            ["page"] = "pets",
            ["kind"] = "Button",
            ["label"] = "购买一次",
            ["sourceLine"] = 905,
        },
        {
            ["id"] = "petbuy",
            ["page"] = "pets",
            ["kind"] = "Toggle",
            ["label"] = "自动购买",
            ["sourceLine"] = 918,
        },
        {
            ["id"] = "boss",
            ["page"] = "boss",
            ["kind"] = "Toggle",
            ["label"] = "自动打Boss",
            ["sourceLine"] = 939,
        },
        {
            ["id"] = "packrebirth",
            ["page"] = "rebirth",
            ["kind"] = "Toggle",
            ["label"] = "换包重生",
            ["sourceLine"] = 976,
        },
        {
            ["id"] = "fasttrain",
            ["page"] = "rebirth",
            ["kind"] = "Toggle",
            ["label"] = "快速锻炼",
            ["sourceLine"] = 999,
        },
        {
            ["id"] = "eategg",
            ["page"] = "rebirth",
            ["kind"] = "Toggle",
            ["label"] = "自动吃蛋",
            ["sourceLine"] = 1025,
        },
        {
            ["id"] = "eggTarget",
            ["page"] = "rebirth",
            ["kind"] = "Dropdown",
            ["label"] = "送蛋目标",
            ["sourceLine"] = 1047,
        },
        {
            ["id"] = "giftAmount",
            ["page"] = "rebirth",
            ["kind"] = "Input",
            ["label"] = "送蛋数量",
            ["sourceLine"] = 1056,
            ["placeholder"] = "0为全部",
        },
        {
            ["id"] = "giftEggs",
            ["page"] = "rebirth",
            ["kind"] = "Button",
            ["label"] = "送蛋",
            ["sourceLine"] = 1066,
        },
        {
            ["id"] = "大厅",
            ["page"] = "teleport",
            ["kind"] = "Button",
            ["label"] = "大厅",
            ["sourceLine"] = 846,
        },
        {
            ["id"] = "小岛",
            ["page"] = "teleport",
            ["kind"] = "Button",
            ["label"] = "小岛",
            ["sourceLine"] = 847,
        },
        {
            ["id"] = "冰霜健身房",
            ["page"] = "teleport",
            ["kind"] = "Button",
            ["label"] = "冰霜健身房",
            ["sourceLine"] = 848,
        },
        {
            ["id"] = "神话健身房",
            ["page"] = "teleport",
            ["kind"] = "Button",
            ["label"] = "神话健身房",
            ["sourceLine"] = 849,
        },
        {
            ["id"] = "永恒健身房",
            ["page"] = "teleport",
            ["kind"] = "Button",
            ["label"] = "永恒健身房",
            ["sourceLine"] = 850,
        },
        {
            ["id"] = "传奇健身房",
            ["page"] = "teleport",
            ["kind"] = "Button",
            ["label"] = "传奇健身房",
            ["sourceLine"] = 851,
        },
        {
            ["id"] = "肌肉之王健身房",
            ["page"] = "teleport",
            ["kind"] = "Button",
            ["label"] = "肌肉之王健身房",
            ["sourceLine"] = 852,
        },
        {
            ["id"] = "丛林健身房",
            ["page"] = "teleport",
            ["kind"] = "Button",
            ["label"] = "丛林健身房",
            ["sourceLine"] = 853,
        },
        {
            ["id"] = "工业健身房",
            ["page"] = "teleport",
            ["kind"] = "Button",
            ["label"] = "工业健身房",
            ["sourceLine"] = 854,
        },
        {
            ["id"] = "超载健身房",
            ["page"] = "teleport",
            ["kind"] = "Button",
            ["label"] = "超载健身房",
            ["sourceLine"] = 855,
        },
        {
            ["id"] = "无转盘岛",
            ["page"] = "teleport",
            ["kind"] = "Button",
            ["label"] = "无转盘岛",
            ["sourceLine"] = 856,
        },
        {
            ["id"] = "熔岩争斗",
            ["page"] = "teleport",
            ["kind"] = "Button",
            ["label"] = "熔岩争斗",
            ["sourceLine"] = 857,
        },
        {
            ["id"] = "沙漠争斗",
            ["page"] = "teleport",
            ["kind"] = "Button",
            ["label"] = "沙漠争斗",
            ["sourceLine"] = 858,
        },
        {
            ["id"] = "海滩争斗",
            ["page"] = "teleport",
            ["kind"] = "Button",
            ["label"] = "海滩争斗",
            ["sourceLine"] = 859,
        },
    },
    ["features"] = {
        {
            ["id"] = "rebirth",
            ["title"] = "自动重生",
            ["description"] = "完成重生流程",
            ["english"] = "AUTO REBIRTH",
            ["icon"] = "rebirth",
        },
        {
            ["id"] = "train",
            ["title"] = "自动锻炼",
            ["description"] = "训练提升力量",
            ["english"] = "AUTO TRAIN",
            ["icon"] = "train",
        },
        {
            ["id"] = "spin",
            ["title"] = "自动轮盘",
            ["description"] = "旋转幸运轮盘",
            ["english"] = "AUTO SPIN",
            ["icon"] = "spin",
        },
        {
            ["id"] = "petbuy",
            ["title"] = "自动购买",
            ["description"] = "购买所选宠物/光环",
            ["english"] = "AUTO BUY",
            ["icon"] = "pet",
        },
        {
            ["id"] = "boss",
            ["title"] = "自动打Boss",
            ["description"] = "自动寻找 Boss",
            ["english"] = "AUTO BOSS",
            ["icon"] = "boss",
        },
        {
            ["id"] = "packrebirth",
            ["title"] = "换包重生",
            ["description"] = "换包与重生",
            ["english"] = "PACK REBIRTH",
            ["icon"] = "rebirth",
        },
        {
            ["id"] = "fasttrain",
            ["title"] = "快速锻炼",
            ["description"] = "快速训练",
            ["english"] = "FAST TRAIN",
            ["icon"] = "strength",
        },
        {
            ["id"] = "eategg",
            ["title"] = "自动吃蛋",
            ["description"] = "使用蛋白蛋",
            ["english"] = "AUTO EAT",
            ["icon"] = "bolt",
        },
    },
    ["teleports"] = {
        {
            ["id"] = "大厅",
            ["label"] = "大厅",
            ["position"] = {
                -0.75,
                90.61,
                242.78,
            },
            ["sourceLine"] = 846,
        },
        {
            ["id"] = "小岛",
            ["label"] = "小岛",
            ["position"] = {
                -32.14,
                8.51,
                1904.41,
            },
            ["sourceLine"] = 847,
        },
        {
            ["id"] = "冰霜健身房",
            ["label"] = "冰霜健身房",
            ["position"] = {
                -2623.41,
                6.99,
                -409.34,
            },
            ["sourceLine"] = 848,
        },
        {
            ["id"] = "神话健身房",
            ["label"] = "神话健身房",
            ["position"] = {
                2250.39,
                6.99,
                1072.77,
            },
            ["sourceLine"] = 849,
        },
        {
            ["id"] = "永恒健身房",
            ["label"] = "永恒健身房",
            ["position"] = {
                -6758.39,
                6.99,
                -1284.45,
            },
            ["sourceLine"] = 850,
        },
        {
            ["id"] = "传奇健身房",
            ["label"] = "传奇健身房",
            ["position"] = {
                4603.4,
                990.99,
                -3897.44,
            },
            ["sourceLine"] = 851,
        },
        {
            ["id"] = "肌肉之王健身房",
            ["label"] = "肌肉之王健身房",
            ["position"] = {
                -8625.4,
                16.99,
                -5730.41,
            },
            ["sourceLine"] = 852,
        },
        {
            ["id"] = "丛林健身房",
            ["label"] = "丛林健身房",
            ["position"] = {
                -8685.01,
                5.99,
                2392.06,
            },
            ["sourceLine"] = 853,
        },
        {
            ["id"] = "工业健身房",
            ["label"] = "工业健身房",
            ["position"] = {
                -5496.68,
                59.04,
                4927.74,
            },
            ["sourceLine"] = 854,
        },
        {
            ["id"] = "超载健身房",
            ["label"] = "超载健身房",
            ["position"] = {
                -3045.3,
                165.41,
                4990.69,
            },
            ["sourceLine"] = 855,
        },
        {
            ["id"] = "无转盘岛",
            ["label"] = "无转盘岛",
            ["position"] = {
                1952.09,
                1.0,
                6179.98,
            },
            ["sourceLine"] = 856,
        },
        {
            ["id"] = "熔岩争斗",
            ["label"] = "熔岩争斗",
            ["position"] = {
                4472.53,
                118.9,
                -8848.54,
            },
            ["sourceLine"] = 857,
        },
        {
            ["id"] = "沙漠争斗",
            ["label"] = "沙漠争斗",
            ["position"] = {
                973.62,
                15.92,
                -7277.01,
            },
            ["sourceLine"] = 858,
        },
        {
            ["id"] = "海滩争斗",
            ["label"] = "海滩争斗",
            ["position"] = {
                -1880.89,
                15.87,
                -6137.75,
            },
            ["sourceLine"] = 859,
        },
    },
    ["fallbackPets"] = {
        "不稳定幻影",
        "以太仙灵小兔",
        "伏特爪",
        "冰波传奇企鹅",
        "反应堆兽",
        "地狱火",
        "地狱火龙",
        "大超新星",
        "幻影创世龙",
        "星界电光",
        "暗星猎人",
        "核心小狗",
        "橙色刺猬",
        "橙色飞马",
        "永恒巨型攻击",
        "永恒打击利维坦",
        "熵爆炸",
        "电光",
        "白色凤凰",
        "白色飞马",
        "等离子掠夺者",
        "紫色光环",
        "紫色新环",
        "紫色猎鹰",
        "紫色龙",
        "红色光环",
        "红色小猫",
        "红色火龙",
        "红色释火者",
        "终极超新星飞马",
        "绿色光环",
        "绿色蝴蝶",
        "绿色释火者",
        "肌肉之王",
        "肌肉老师",
        "能量闪电",
        "蓝色光环",
        "蓝色凤凰",
        "顶峰霸主",
        "魔法蝴蝶",
        "黄色光环",
        "黄色蝴蝶",
        "黄金维金人",
        "黑暗德古拉",
        "黑暗电光",
        "黑暗蝎尾怪传奇",
        "黑暗闪电",
        "黑暗风暴",
        "黑暗魔像",
    },
    ["notes"] = {
        ["pets"] = "优先游戏内 cPetShopFolder 名称；49 项为旧版内置兜底，不能视作当前商店库存。",
        ["eggTargets"] = "只读取同一服务器的其他玩家 Name；浏览器未连接 Roblox 时列表为空。",
        ["boss"] = "旧版只有自动打Boss开关，没有固定 Boss 名单。",
        ["rebirth"] = "旧版没有重生方案下拉框；包含换包重生、快速锻炼、自动吃蛋和送蛋。",
    },
}

-- 从唯一控件清单建立名称索引，让所有重复入口共用文案。
catalog.labels = {}
for _, control in ipairs(catalog.controls) do catalog.labels[control.id] = control.label end
for _, feature in ipairs(catalog.features) do feature.title = catalog.labels[feature.id] end
return catalog

end
factories["LegacyPages"] = function()
--[[
    旧版功能页的布局：传送、宠物、Boss、换包重生。
    只创建控件、转交点击；游戏动作必须经过 BusinessAdapter。
    看懂方法：x/y 是位置，w/h 是宽高，单位都按 1672 × 941 设计画布计算。
    改名字先看 catalog/PreviousUI.json；改控件位置在本文件修改数字。
]]
local Catalog = requireModule("LegacyCatalog")
local Theme = requireModule("Theme")
local C = Theme.Colors
local Pages = {}

-- 输入框提交后保存数字。原版“空白/0”的含义分别为无限次数或赠送全部。
function Pages.Input(view, parent, id, title, placeholder, x, y, width)
    local u, c = view.u, view.controller
    u:Text(parent, id .. "Label", title, x, y, width, 28, 21, C.White, true)
    local box = u:Make("TextBox", parent, "Input_" .. id, {
        Position = UDim2.fromOffset(x, y + 34),
        Size = UDim2.fromOffset(width, 49),
        BackgroundColor3 = C.Black,
        BorderSizePixel = 0,
        TextColor3 = C.White,
        PlaceholderColor3 = C.Muted,
        Font = Theme.Font,
        TextSize = 21,
        Text = tostring(c.parameters[id] or 0),
        PlaceholderText = placeholder,
        ClearTextOnFocus = false,
        ZIndex = 9,
    })
    u:Make("UIStroke", box, "InputBorder", { Color = C.Border, Thickness = 1 })
    view.scope:Connect(box.FocusLost, function()
        c:SetParameter(id, box.Text)
        box.Text = tostring(c.parameters[id])
    end)
    return box
end

-- 同一个开关可能同时出现在功能页和右侧快捷区，两处共享同一份状态。
function Pages.Toggle(view, parent, id, x, y, width)
    local feature
    for _, item in ipairs(Catalog.features) do
        if item.id == id then
            feature = item
        end
    end
    assert(feature, "未知开关: " .. id)
    view.u:Icon(parent, feature.icon, x, y, 34)
    view.u:Text(parent, id .. "Title", feature.title, x + 48, y, width - 145, 38, 25, C.White, true)
    local toggle = view.u:Toggle(parent, "DetailToggle_" .. id, x + width - 84, y + 4, function()
        view.controller:SetSelected(id, not view.controller.selected[id])
    end)
    table.insert(view.extraToggles, { id = id, widget = toggle })
end

local function action(view, page, id, title, x, y, width)
    local button = view.u:Button(page, id, title, x, y, width, 65, function()
        view.controller:PressControl(id)
    end, false)
    table.insert(view.controlButtons, { id = id, widget = button, title = title })
end

function Pages.Build(view, page, id)
    local u, c = view.u, view.controller
    if id == "teleport" then
        u:Text(
            page,
            "TeleportHint",
            "旧版 14 个传送地点 · 游戏功能未接入时按钮不可用",
            44,
            178,
            1000,
            36,
            22,
            C.Muted
        )
        for index, item in ipairs(Catalog.teleports) do
            local column = (index - 1) % 3
            local row = math.floor((index - 1) / 3)
            local button = u:Button(
                page,
                "Teleport_" .. index,
                item.label,
                44 + column * 336,
                235 + row * 76,
                320,
                62,
                function()
                    if c:SetChoice("teleport", item.id) then
                        c:Perform("teleport")
                    end
                end,
                false
            )
            button.label.TextSize = 22
            table.insert(view.teleportButtons, { id = item.id, widget = button })
        end
    elseif id == "pets" then
        u:Text(page, "PetSection", "宠物商店购买", 44, 177, 950, 42, 28, C.White, true)
        u:Text(page, "PetSelectLabel", Catalog.labels.petChoice, 44, 235, 920, 32, 22, C.Muted)
        local drop = view:Dropdown(
            page,
            "Select_pets",
            view.adapter:GetOptions("pets"),
            44,
            278,
            620,
            function(value)
                c:SetChoice("pets", value)
            end
        )
        drop.page = "pets"
        u:Button(page, "RefreshPets", Catalog.labels.refreshPets, 690, 278, 345, 58, function()
            c:RefreshOptions("pets")
        end, false)
        u:Text(
            page,
            "PetSource",
            "优先读取游戏商店；无法读取时显示旧版 49 项内置列表。",
            44,
            353,
            1000,
            34,
            20,
            C.Muted
        )
        action(view, page, "buyPet", Catalog.labels.buyPet, 44, 420, 450)
        Pages.Toggle(view, page, "petbuy", 560, 427, 470)
        u:Text(
            page,
            "PetNote",
            "购买和自动购买需接入原有业务；这里不代表当前库存或已购买。",
            44,
            567,
            1000,
            36,
            21,
            C.Muted
        )
    elseif id == "boss" then
        u:Text(page, "BossSection", "Boss", 44, 185, 980, 48, 30, C.White, true)
        Pages.Toggle(view, page, "boss", 44, 286, 990)
        local hint = u:Text(
            page,
            "BossHint",
            "旧版由游戏业务自动寻找 Boss。\n此页保留原有“自动打Boss”开关。",
            44,
            404,
            980,
            120,
            24,
            C.Muted
        )
        hint.TextWrapped = true
    elseif id == "rebirth" then
        u:Text(page, "PackSection", "换包重生", 44, 174, 940, 36, 27, C.White, true)
        Pages.Toggle(view, page, "packrebirth", 44, 228, 470)
        Pages.Toggle(view, page, "fasttrain", 565, 228, 470)
        u:Line(page, "PackDivider", 44, 310, 994, 1, C.Border)
        u:Text(page, "EggSection", "蛋白蛋", 44, 332, 400, 36, 27, C.White, true)
        Pages.Toggle(view, page, "eategg", 565, 332, 470)
        u:Text(page, "EggTargetLabel", Catalog.labels.eggTarget, 44, 401, 640, 28, 21, C.White, true)
        local drop = view:Dropdown(
            page,
            "Select_eggTargets",
            view.adapter:GetOptions("eggTargets"),
            44,
            435,
            610,
            function(value)
                c:SetChoice("eggTargets", value)
            end
        )
        drop.page = "eggTargets"
        -- 下拉菜单向上展开，避免超出当前页面和底部控制区。
        drop.list.Position = UDim2.fromOffset(44, 187)
        drop.list.Size = UDim2.fromOffset(610, 240)
        Pages.Input(view, page, "giftAmount", Catalog.labels.giftAmount, "0为全部", 690, 401, 345)
        u:Text(
            page,
            "EggHint",
            "0 为全部 · 目标只显示同服其他玩家；开始送蛋前会再次核对。",
            44,
            506,
            1000,
            33,
            20,
            C.Muted
        )
        action(view, page, "giftEggs", Catalog.labels.giftEggs, 690, 561, 345)
    end
end

-- 刷新已有控件，不重建整页；一轮状态更新不会新建重复的事件监听。
function Pages.Refresh(view)
    local c, adapter = view.controller, view.adapter
    for _, item in ipairs(view.extraToggles) do
        item.widget.Set(c.selected[item.id] == true, adapter:Available(item.id))
    end
    for _, item in ipairs(view.controlButtons) do
        local enabled = adapter:CanControl(item.id) and not c.actionBusy
        item.widget.button.Active = enabled
        item.widget.button.Selectable = enabled
        item.widget.label.Text = adapter:CanControl(item.id) and item.title or (item.title .. " · 未接入")
    end
    local allowed = {}
    for _, option in ipairs(adapter:GetOptions("teleport")) do
        allowed[option.Id] = true
    end
    for _, item in ipairs(view.teleportButtons) do
        local enabled = adapter:CanPerform("teleport") and allowed[item.id] == true and not c.actionBusy
        item.widget.button.Active = enabled
        item.widget.button.Selectable = enabled
        item.widget.label.TextColor3 = enabled and C.White or C.Muted
    end
end
return Pages

end
factories["Library"] = function()
--[[
    JBS UI 库公开入口。require 本模块只得到接口，不创建窗口、不启动游戏任务。
    CreateWindow：用当前 JBS 外观建立你自己的页面和控件。
    CreateJBS：原样创建当前工程的完整预设，业务仍通过原 Bindings 接入。
    用法统一使用冒号：Library:CreateWindow({Id="MyUI", Title="我的界面"})。
]]
local Library = { Version = "1.0.0" }

function Library:CreateWindow(options)
    return requireModule("LibraryWindow").new(options or {})
end

function Library:CreateJBS(options)
    -- 复用已有入口：保留原有授权、配置、启停、热键和当前玩家正背面展示。
    return requireModule("Runtime").Mount(options or {})
end

return Library

end
factories["LibraryControls"] = function()
--[[
    UI 库的页面/右栏共用控件。不包含任何游戏 Remote、坐标或自动任务。
    每个控件有自己的清理箱，删除一个控件不必销毁整个窗口。
    创建控件和 Set(value) 默认静默；真实交互或 Set(value, true) 才执行 Callback。
    Callback 返回 false, "原因" 或抛错时回滚值；等待中的回调不会重复进入。
]]
local Cleanup = requireModule("Cleanup")
local Components = requireModule("Components")
local Theme = requireModule("Theme")
local C = Theme.Colors
local TextService = game:GetService("TextService")
local InputService = game:GetService("UserInputService")
local Controls = {}
Controls.__index = Controls
local Control = {}
Control.__index = Control

local function finite(value)
    return type(value) == "number" and value == value and math.abs(value) < math.huge
end
local function rect(object, x, y, w, h)
    object.Position = UDim2.fromOffset(x, y)
    object.Size = UDim2.fromOffset(math.max(1, w), math.max(1, h))
end
local function options(input)
    if type(input) == "string" then return {Title = input} end
    assert(input == nil or type(input) == "table", "控件参数必须是 table")
    return input or {}
end
local function measured(text, width, size, bold)
    if text == "" then return 0 end
    -- 按可用宽度测量换行，不把长标题自动缩小。最终字形仍以 Roblox 实测为准。
    local bounds = TextService:GetTextSize(text, size, bold and Theme.Bold or Theme.Font,
        Vector2.new(math.max(20, width), 100000))
    return math.max(math.ceil(size * 1.4), math.ceil(bounds.Y * 1.4))
end
local function normalizeOptions(values)
    assert(type(values) == "table", "Dropdown.Options 必须是数组")
    local result, seen = {}, {}
    for _, value in ipairs(values) do
        local id, label
        if type(value) == "string" then id, label = value, value
        elseif type(value) == "table" then id, label = value.Id, value.Label or value.Id end
        assert(type(id) == "string" and id ~= "" and type(label) == "string", "下拉选项使用字符串或 {Id, Label}")
        assert(not seen[id], "下拉选项 Id 重复：" .. id)
        seen[id] = true
        table.insert(result, {Id = id, Label = label})
    end
    return result
end

-- Container 可以是一页内容，也可以是右侧设置区；所有控件使用相同接口。
function Controls.new(window, parent, columns)
    return setmetatable({window = window, parent = parent, rows = {}, width = 300,
        columns = columns or 1, dead = false}, Controls)
end
function Controls:IsVisible()
    return not self.dead and self.window.visible and self.window.Screen.Enabled and self.parent.Visible
end

function Controls:Relayout(width)
    if self.dead then return end
    self.width = math.max(100, width or self.width)
    local columns = math.min(self.columns, math.max(1, math.floor((self.width + 12) / 312)))
    local cardWidth = (self.width - (columns - 1) * 12) / columns
    local y, group, tallest = 0, {}, 0
    local function flush()
        if #group == 0 then return end
        for index, row in ipairs(group) do
            row:_Layout((index - 1) * (cardWidth + 12), y, cardWidth, tallest)
        end
        y += tallest + 12
        group, tallest = {}, 0
    end
    for _, row in ipairs(self.rows) do
        if not row.dead and row.visible then
            if row.kind == "Section" or row.kind == "Divider" then
                flush()
                local h = row:_Measure(self.width)
                row:_Layout(0, y, self.width, h)
                y += h + 12
            else
                table.insert(group, row)
                tallest = math.max(tallest, row:_Measure(cardWidth))
                if #group == columns then flush() end
            end
        end
    end
    flush()
    self.parent.CanvasSize = UDim2.fromOffset(0, math.max(0, y))
end

function Controls:_Create(kind, input)
    assert(not self.dead and not self.window.dead, "页面已经销毁")
    local p = options(input)
    assert(p.Callback == nil or type(p.Callback) == "function", "Callback 必须是函数")
    self.window.sequence += 1
    local id = p.Id or ("control_" .. self.window.sequence)
    assert(type(id) == "string" and id ~= "" and not self.window.controls[id], "控件 Id 为空或重复")
    local scope = Cleanup.new()
    local u = Components.new(scope, self.window.motion, self.window.assets)
    local row = setmetatable({container = self, window = self.window, scope = scope, u = u,
        Id = id, kind = kind, title = p.Title or kind, description = p.Description or "",
        enabled = p.Disabled ~= true, visible = p.Visible ~= false, callback = p.Callback,
        dead = false, busy = false, value = nil}, Control)
    assert(type(row.title) == "string" and type(row.description) == "string", "Title / Description 必须是字符串")
    if kind == "Section" or kind == "Divider" then
        row.Root = u:Box(self.parent, id, 0, 0, 300, 40)
    else
        row.Root = u:Panel(self.parent, id, 0, 0, 300, 100, "card")
    end
    row.Root.Visible = row.visible
    row.TitleLabel = u:Text(row.Root, "Title", row.title, 16, 12, 268, 28, 18, C.White, true)
    row.DescriptionLabel = u:Text(row.Root, "Description", row.description, 16, 40, 268, 20, 14, C.Muted)
    for _, label in ipairs({row.TitleLabel, row.DescriptionLabel}) do
        label.TextWrapped = true
        label.TextTruncate = Enum.TextTruncate.None
        label.LineHeight = 1.4
    end
    self.window.controls[id] = row
    table.insert(self.rows, row)
    return row, p
end

function Control:Get() return self.value end
function Control:SetTitle(value)
    if self.dead then return false end
    assert(type(value) == "string", "标题必须是字符串")
    self.title, self.TitleLabel.Text = value, value
    self.container:Relayout()
    return true
end
function Control:SetDescription(value)
    if self.dead then return false end
    assert(type(value) == "string", "说明必须是字符串")
    self.description, self.DescriptionLabel.Text = value, value
    self.container:Relayout()
    return true
end
function Control:SetEnabled(value)
    if self.dead then return false end
    self.enabled = value == true
    if not self.enabled then self.drag = nil; self.open = false end
    self:_Paint()
    self.container:Relayout()
    return true
end
function Control:SetVisible(value)
    if self.dead then return false end
    self.visible, self.Root.Visible = value == true, value == true
    if not self.visible then self.drag = nil; self.open = false end
    self.container:Relayout()
    return true
end

function Control:_Normalize(value)
    if self.kind == "Toggle" then
        assert(type(value) == "boolean", "开关值必须是 boolean")
    elseif self.kind == "Input" then
        if self.numeric then
            value = tonumber(value)
            assert(finite(value), "请输入有限数值")
            if self.minimum then value = math.max(self.minimum, value) end
            if self.maximum then value = math.min(self.maximum, value) end
            if self.integer then value = math.floor(value) end
        else
            assert(type(value) == "string", "输入值必须是字符串")
        end
    elseif self.kind == "Slider" then
        value = tonumber(value)
        assert(finite(value), "滑块值必须是有限数值")
        value = math.clamp(value, self.minimum, self.maximum)
        value = math.clamp(self.minimum + math.floor((value - self.minimum) / self.step + 0.5) * self.step,
            self.minimum, self.maximum)
        value = tonumber(string.format("%.10g", value))
    elseif self.kind == "Dropdown" then
        if value ~= nil then
            local found = false
            for _, item in ipairs(self.values) do if item.Id == value then found = true end end
            assert(found, "下拉值不在当前 Options 中")
        end
    else error("此控件没有可设置的值") end
    return value
end

-- UI 回调可以 yield。忙碌期间拒绝重复提交，销毁后不再写入失效控件。
function Control:Set(value, fireCallback)
    if self.dead or self.busy then return false, "控件已销毁或回调处理中" end
    local ok, normalized = pcall(self._Normalize, self, value)
    if not ok then self.window:Notify({Title = "输入无效", Content = tostring(normalized)}); self:_Paint(); return false end
    if normalized == self.value then self:_Paint(); return true end
    local old = self.value
    self.value = normalized
    self:_Paint()
    if fireCallback and self.callback then
        self.busy = true; self:_Paint()
        local success, accepted, reason = pcall(self.callback, normalized, self)
        self.busy = false
        if self.dead then return false, "控件已销毁" end
        if not success or accepted == false then
            self.value = old
            self.window:Notify({Title = "操作未完成", Content = tostring(success and (reason or "回调拒绝了本次修改") or accepted)})
            self:_Paint()
            return false
        end
        self:_Paint()
    end
    return true
end

function Control:Press()
    if self.kind ~= "Button" or self.dead or self.busy or not self.enabled or not self.visible or not self.container:IsVisible() then return false end
    if not self.callback then return false end
    self.busy = true; self:_Paint()
    local ok, accepted, reason = pcall(self.callback, self)
    self.busy = false
    if self.dead then return false end
    self:_Paint()
    if not ok or accepted == false then
        self.window:Notify({Title = "操作未完成", Content = tostring(ok and (reason or "回调返回 false") or accepted)})
        return false
    end
    return true
end

function Control:_Paint()
    if self.dead then return end
    local enabled = self.enabled and not self.busy
    if self.kind == "Button" then enabled = enabled and self.callback ~= nil end
    self.TitleLabel.TextColor3 = self.enabled and C.White or C.Muted
    if self.toggle then
        self.toggle.Set(self.value == true, enabled)
        -- 通用库的禁用代表调用者禁用，不把它错误解释成游戏“未接入”。
        self.toggle.root.Value.Text = self.busy and "处理中" or (not self.enabled and "禁用" or (self.value and "开启" or "关闭"))
    end
    if self.action then
        self.action.button.Active, self.action.button.Selectable = enabled, enabled
        if self.kind == "Button" then self.action.label.Text = self.busy and "处理中…" or self.buttonText end
    end
    if self.input then
        self.input.TextEditable = enabled
        self.input.Text = self.value == nil and "" or tostring(self.value)
    end
    if self.kind == "Dropdown" then
        local caption = #self.values == 0 and "暂无选项" or self.placeholder
        for _, item in ipairs(self.values) do if item.Id == self.value then caption = item.Label end end
        self.action.label.Text = caption
        self.action.button.Active = enabled and #self.values > 0
        self.action.button.Selectable = self.action.button.Active
        if not enabled then self.open = false end
        self.list.Visible = self.open == true
        for _, item in ipairs(self.optionRows or {}) do item.hit.Active = enabled; item.hit.Selectable = enabled end
    elseif self.kind == "Slider" then
        local value = self.drag and self.drag.value or self.value
        local ratio = (value - self.minimum) / (self.maximum - self.minimum)
        self.fill.Size = UDim2.fromScale(ratio, 1)
        self.knob.Position = UDim2.new(ratio, -7, 0.5, -7)
        self.hit.Active, self.hit.Selectable = enabled, enabled
        self.input.Text = tostring(value)
    end
end

function Control:_Measure(width)
    if self.kind == "Divider" then return 8 end
    local textWidth = math.max(20, width - 32 - (self.kind == "Toggle" and 80 or 0))
    self.titleHeight = measured(self.title, textWidth, 18, true)
    self.descriptionHeight = measured(self.description, textWidth, 14, false)
    self.contentY = 12 + self.titleHeight + (self.descriptionHeight > 0 and 5 + self.descriptionHeight or 0)
    if self.kind == "Section" then return math.max(40, self.contentY + 8) end
    if self.kind == "Toggle" then return math.max(84, self.contentY + 14) end
    if self.kind == "Label" then return self.contentY + 14 end
    local h = self.contentY + 10 + 44 + 14
    if self.kind == "Dropdown" and self.open then
        self.optionsHeight = 0
        for _, item in ipairs(self.optionRows) do
            self.optionsHeight += math.max(42, measured(item.label.Text, width - 64, 16, false) + 16)
        end
        h += math.min(216, self.optionsHeight) + 8
    end
    return h
end

function Control:_Layout(x, y, width, height)
    rect(self.Root, x, y, width, height)
    if self.kind == "Divider" then rect(self.line, 0, 3, width, 1); return end
    if self.kind ~= "Section" then self.u:ResizePanel(self.Root, width, height) end
    local textWidth = width - 32 - (self.kind == "Toggle" and 80 or 0)
    rect(self.TitleLabel, 16, 12, textWidth, self.titleHeight)
    rect(self.DescriptionLabel, 16, 17 + self.titleHeight, textWidth, self.descriptionHeight)
    self.DescriptionLabel.Visible = self.descriptionHeight > 0
    local actionY = self.contentY + 10
    if self.toggle then rect(self.toggle.root, width - 80, (height - 48) / 2, 64, 48) end
    if self.action then
        rect(self.action.root, 16, actionY, width - 32, 44)
        self.u:ResizePanel(self.action.root, width - 32, 44)
        rect(self.action.button, 0, 0, width - 32, 44)
        rect(self.action.label, 12, 0, width - 56, 44)
        self.action.label.TextSize = 16
    end
    if self.input then
        if self.kind == "Slider" then rect(self.input, width - 106, actionY, 90, 40)
        else rect(self.input, 16, actionY, width - 32, 40) end
    end
    if self.kind == "Slider" then
        rect(self.track, 20, actionY + 17, width - 142, 6)
        rect(self.hit, 12, actionY, width - 126, 40)
    elseif self.kind == "Dropdown" then
        local optionY = 0
        for _, item in ipairs(self.optionRows) do
            local rowHeight = math.max(42, measured(item.label.Text, width - 64, 16, false) + 16)
            rect(item.label, 12, optionY, width - 64, rowHeight)
            rect(item.hit, 0, optionY, width - 40, rowHeight)
            optionY += rowHeight
        end
        self.optionsHeight = optionY
        rect(self.list, 16, actionY + 52, width - 32, math.min(216, optionY))
        self.list.CanvasSize = UDim2.fromOffset(0, optionY)
    end
end

function Control:Destroy()
    if self.dead then return end
    self.dead = true; self.drag = nil
    if self.optionScope then self.optionScope:Destroy() end
    self.scope:Destroy()
    -- Cancel 只取消本控件上的现有动画，不干涉其他控件或游戏脚本。
    for _, object in ipairs(self.Root:GetDescendants()) do self.window.motion:Cancel(object) end
    self.window.motion:Cancel(self.Root)
    self.window.assets:UnbindTree(self.Root)
    self.Root:Destroy()
    self.window.controls[self.Id] = nil
    local index = table.find(self.container.rows, self)
    if index then table.remove(self.container.rows, index) end
    self.container:Relayout()
end

function Controls:Toggle(input)
    local p = options(input)
    assert(p.Default == nil or type(p.Default) == "boolean", "Toggle.Default 必须是 boolean")
    local row = self:_Create("Toggle", p)
    row.toggle = row.u:Toggle(row.Root, "Toggle", 220, 20, function()
        if row.enabled and not row.busy and row.visible and row.container:IsVisible() then row:Set(not row.value, true) end
    end)
    row.value = p.Default == true
    row:_Paint(); self:Relayout(); return row
end

function Controls:Button(input)
    local p = options(input)
    assert(p.ButtonText == nil or type(p.ButtonText) == "string", "ButtonText 必须是字符串")
    local row = self:_Create("Button", p)
    row.buttonText = p.ButtonText or "执行"
    row.action = row.u:Button(row.Root, "Action", row.buttonText, 16, 60, 268, 44, function() row:Press() end, p.Primary == true)
    row:_Paint(); self:Relayout(); return row
end

local function inputBox(row, placeholder)
    local box = row.u:Make("TextBox", row.Root, "Input", {
        BackgroundColor3 = C.Black, BorderSizePixel = 0, TextColor3 = C.White,
        PlaceholderColor3 = C.Muted, PlaceholderText = placeholder or "请输入",
        Font = Theme.Font, TextSize = 16, ClearTextOnFocus = false, MultiLine = false,
        TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 6,
    })
    row.u:Make("UIPadding", box, "Padding", {PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10)})
    row.u:Make("UIStroke", box, "Border", {Color = C.Border, Thickness = 1})
    row.scope:Connect(box.FocusLost, function()
        if row.enabled and not row.busy and row.visible and row.container:IsVisible() then row:Set(box.Text, true) else row:_Paint() end
    end)
    return box
end
function Controls:Input(input)
    local p = table.clone(options(input))
    assert(p.Min == nil or finite(p.Min), "Min 必须为有限数值")
    assert(p.Max == nil or finite(p.Max), "Max 必须为有限数值")
    assert(not (p.Min and p.Max) or p.Min <= p.Max, "Min 不能大于 Max")
    if p.Numeric and p.Integer then
        if p.Min then p.Min = math.ceil(p.Min) end
        if p.Max then p.Max = math.floor(p.Max) end
        assert(not (p.Min and p.Max) or p.Min <= p.Max, "范围中没有可用整数")
    end
    if p.Default ~= nil then
        assert(p.Numeric and finite(tonumber(p.Default)) or (not p.Numeric and type(p.Default) == "string"), "Input.Default 类型不正确")
    end
    local row = self:_Create("Input", p)
    row.numeric, row.integer, row.minimum, row.maximum = p.Numeric == true, p.Integer == true, p.Min, p.Max
    row.input = inputBox(row, p.Placeholder)
    row.value = row:_Normalize(p.Default == nil and (row.numeric and 0 or "") or p.Default)
    row:_Paint(); self:Relayout(); return row
end

function Control:SetOptions(values, fireCallback)
    assert(self.kind == "Dropdown", "SetOptions 只用于下拉框")
    if self.dead or self.busy then return false end
    local normalized = normalizeOptions(values)
    local oldValues, oldValue = self.values, self.value
    self.values = normalized
    local retained = false
    for _, item in ipairs(normalized) do if item.Id == self.value then retained = true end end
    if not retained and not self:Set(nil, fireCallback) then
        self.values, self.value = oldValues, oldValue
        self:_Paint(); return false
    end
    if self.optionScope then self.optionScope:Destroy() end
    self.optionScope, self.optionRows = Cleanup.new(), {}
    for _, child in ipairs(self.list:GetDescendants()) do self.window.motion:Cancel(child) end
    for _, child in ipairs(self.list:GetChildren()) do child:Destroy() end
    local u = Components.new(self.optionScope, self.window.motion, self.window.assets)
    for index, item in ipairs(normalized) do
        local label = u:Text(self.list, "OptionLabel_" .. index, item.Label, 12, 0, 240, 42, 16, C.White)
        label.TextWrapped, label.TextTruncate, label.LineHeight = true, Enum.TextTruncate.None, 1.4
        local hit = u:Interact(self.list, "Option_" .. index, 0, 0, 260, 42, function()
            if self.dead or not self.enabled or self.busy or not self.visible or not self.open or not self.container:IsVisible() then return end
            self.open = false; self.list.Visible = false
            self:Set(item.Id, true)
            self.container:Relayout()
        end)
        table.insert(self.optionRows, {label = label, hit = hit})
    end
    self.open = false; self:_Paint(); self.container:Relayout(); return true
end
function Controls:Dropdown(input)
    local p = options(input)
    local values = normalizeOptions(p.Options or {})
    if p.Default ~= nil then
        local found = false
        for _, item in ipairs(values) do if item.Id == p.Default then found = true end end
        assert(found, "Dropdown.Default 不在 Options 内")
    end
    local row = self:_Create("Dropdown", p)
    row.values, row.optionRows, row.placeholder = {}, {}, p.Placeholder or "请选择"
    row.list = row.u:Make("ScrollingFrame", row.Root, "Options", {
        BackgroundColor3 = C.Black, BorderSizePixel = 0, Visible = false,
        ScrollBarThickness = 4, ScrollBarImageColor3 = C.Light, ClipsDescendants = true,
        ScrollingDirection = Enum.ScrollingDirection.Y, CanvasSize = UDim2.fromOffset(0, 0),
    })
    row.action = row.u:Button(row.Root, "Selection", "请选择", 16, 60, 268, 44, function()
        if not row.enabled or row.busy or #row.values == 0 or not row.container:IsVisible() then return end
        row.open = not row.open; row:_Paint()
        -- 展开菜单只占自己的卡片，不覆盖下一行；换行后的选项高度也参与测量。
        row.container:Relayout()
    end)
    row:SetOptions(values); row:Set(p.Default); self:Relayout(); return row
end

function Controls:Slider(input)
    local p = options(input)
    local minimum, maximum, step = p.Min or 0, p.Max or 100, p.Step or 1
    assert(finite(minimum) and finite(maximum) and maximum > minimum, "Slider 需要 Min < Max")
    assert(finite(step) and step > 0, "Step 必须大于 0")
    assert(p.Default == nil or finite(tonumber(p.Default)), "Slider.Default 必须是有限数值")
    local row = self:_Create("Slider", p)
    row.minimum, row.maximum, row.step = minimum, maximum, step
    row.value = row:_Normalize(p.Default or minimum)
    row.input = inputBox(row, "数值")
    row.track = row.u:Line(row.Root, "Track", 20, 77, 150, 6, C.Dim)
    row.fill = row.u:Line(row.track, "Fill", 0, 0, 1, 6, C.Pink)
    row.knob = row.u:Line(row.track, "Knob", 0, 0, 14, 14, C.White)
    row.u:Make("UICorner", row.knob, "Round", {CornerRadius = UDim.new(1, 0)})
    row.hit = row.u:Interact(row.Root, "SliderHit", 12, 60, 170, 40, function() end)
    local function point(event)
        local width = row.track.AbsoluteSize.X
        if width <= 0 then return row.value end
        local ratio = math.clamp((event.Position.X - row.track.AbsolutePosition.X) / width, 0, 1)
        return row:_Normalize(minimum + ratio * (maximum - minimum))
    end
    row.scope:Connect(row.hit.InputBegan, function(event)
        if not row.enabled or row.busy or not row.visible or not row.container:IsVisible() then return end
        if event.UserInputType == Enum.UserInputType.MouseButton1 or event.UserInputType == Enum.UserInputType.Touch then
            row.drag = {input = event, value = point(event)}; row:_Paint()
        end
    end)
    row.scope:Connect(InputService.InputChanged, function(event)
        if row.drag and not row.container:IsVisible() then row.drag = nil; row:_Paint(); return end
        if row.drag and (event == row.drag.input or (row.drag.input.UserInputType == Enum.UserInputType.MouseButton1
            and event.UserInputType == Enum.UserInputType.MouseMovement)) then
            row.drag.value = point(event); row:_Paint()
        end
    end)
    row.scope:Connect(InputService.InputEnded, function(event)
        if row.drag and not row.container:IsVisible() then row.drag = nil; row:_Paint(); return end
        if row.drag and (event == row.drag.input or (row.drag.input.UserInputType == Enum.UserInputType.MouseButton1
            and event.UserInputType == Enum.UserInputType.MouseButton1)) then
            local value = row.drag.value; row.drag = nil; row:Set(value, true)
        end
    end)
    row.scope:Connect(InputService.InputBegan, function(event, processed)
        if processed or not row.enabled or row.busy or not row.visible or not row.container:IsVisible()
            or InputService:GetFocusedTextBox() or game:GetService("GuiService").SelectedObject ~= row.hit then return end
        if event.KeyCode == Enum.KeyCode.Left then row:Set(row.value - step, true)
        elseif event.KeyCode == Enum.KeyCode.Right then row:Set(row.value + step, true)
        elseif event.KeyCode == Enum.KeyCode.Home then row:Set(minimum, true)
        elseif event.KeyCode == Enum.KeyCode.End then row:Set(maximum, true) end
    end)
    row:_Paint(); self:Relayout(); return row
end

function Controls:Label(input)
    local row = self:_Create("Label", input); self:Relayout(); return row
end
function Controls:Section(input)
    local row = self:_Create("Section", input); self:Relayout(); return row
end
function Controls:Divider()
    local row = self:_Create("Divider", {Title = ""})
    row.TitleLabel.Visible, row.DescriptionLabel.Visible = false, false
    row.line = row.u:Line(row.Root, "DividerLine", 0, 3, 300, 1, C.Border)
    self:Relayout(); return row
end
function Controls:Destroy()
    if self.dead then return end
    self.dead = true
    for _, row in ipairs(table.clone(self.rows)) do row:Destroy() end
    table.clear(self.rows)
end
return Controls

end
factories["LibraryWindow"] = function()
--[[
    通用 UI 库窗口：复用现有金属控件、颜色、素材、角色双视图和拖动逻辑。
    页面/右侧设置由调用者添加，库不内置训练、传送、购买或授权逻辑。
    桌面保留三栏；窄窗口把区域上下排列并滚动，文字仍用正常字号。
]]
local Cleanup = requireModule("Cleanup")
local Components = requireModule("Components")
local Motion = requireModule("Motion")
local Assets = requireModule("Assets")
local Defaults = requireModule("Config")
local Theme = requireModule("Theme")
local View = requireModule("View")
local Controls = requireModule("LibraryControls")
local C = Theme.Colors
local Window = {}
Window.__index = Window
local registry = setmetatable({}, {__mode = "k"})
local function rect(object, x, y, w, h)
    object.Position = UDim2.fromOffset(x, y)
    object.Size = UDim2.fromOffset(math.max(1, w), math.max(1, h))
end
local function config(options)
    local result = table.clone(Defaults)
    result.AssetIds = table.clone(Defaults.AssetIds)
    for key, value in pairs(options.AssetIds or {}) do result.AssetIds[key] = value end
    result.AvatarPreview = table.clone(Defaults.AvatarPreview)
    if options.AvatarPreview == false then result.AvatarPreview.Enabled = false
    elseif type(options.AvatarPreview) == "table" then
        for key, value in pairs(options.AvatarPreview) do result.AvatarPreview[key] = value end
    end
    result.DisplayOrder = options.DisplayOrder or Defaults.DisplayOrder
    return result
end

-- 构造失败时也回收已创建的连接/实例；重复 Id 恢复原窗口，不堆叠第二套界面。
function Window.new(options)
    assert(type(options) == "table", "CreateWindow 参数必须是 table")
    local player = game:GetService("Players").LocalPlayer
    assert(player, "JBS UI 库请从客户端 LocalScript 调用")
    local parent = options.Parent or player:WaitForChild("PlayerGui")
    local id = options.Id or "JBS_UI"
    assert(type(id) == "string" and #id <= 64 and id:match("^[%w_-]+$"), "窗口 Id 使用 1–64 个英文字母、数字、下划线或连字符")
    registry[parent] = registry[parent] or {}
    local existing = registry[parent][id]
    if existing and not existing.dead then existing:Show(); return existing, false end
    local ownerName = "JBSUI_Owner_" .. id
    local owner = parent:FindFirstChild(ownerName)
    if owner then
        if owner:IsA("BindableFunction") and owner:GetAttribute("JBSUILibrary") == true then owner:Invoke("Restore") end
        return nil, "同 Id 窗口已存在；没有替换或销毁其他界面"
    end
    local self = setmetatable({Id = id, parent = parent, player = player, options = options,
        config = config(options), scope = Cleanup.new(), motion = Motion.new(options.ReducedMotion == true),
        tabs = {}, tabOrder = {}, controls = {}, sequence = 0, tabSequence = 0, artGaps = {},
        visible = true, dead = false, controller = {window = "Open", page = "home"}}, Window)
    self.assets = Assets.new(self.config.AssetIds)
    self.u = Components.new(self.scope, self.motion, self.assets)
    local ok, err = pcall(function()
        self.Screen = self.u:Make("ScreenGui", parent, id, {ResetOnSpawn = false,
            IgnoreGuiInset = false, DisplayOrder = self.config.DisplayOrder, ZIndexBehavior = Enum.ZIndexBehavior.Sibling})
        self:_Build()
        self.owner = self.u:Make("BindableFunction", parent, ownerName)
        self.owner:SetAttribute("JBSUILibrary", true)
        self.owner.OnInvoke = function(command)
            if command == "Restore" then self:Show(); return true end
            return false
        end
        self.scope:Connect(self.Screen.Destroying, function() self:Destroy() end)
        if options.Hotkey then
            local input = game:GetService("UserInputService")
            self.scope:Connect(input.InputBegan, function(event, processed)
                if not processed and not input:GetFocusedTextBox() and event.KeyCode == options.Hotkey then
                    self:SetVisible(not self.visible)
                end
            end)
        end
        self:SetActions({Start = options.OnStart, Stop = options.OnStop})
        self:Resize()
        self.assets:Load(function() if not self.dead then self:_RefreshArt() end end)
    end)
    if not ok then self:Destroy(); error(err, 2) end
    registry[parent][id] = self
    return self, true
end

function Window:_Scroller(parent, name)
    return self.u:Make("ScrollingFrame", parent, name, {BackgroundTransparency = 1, BorderSizePixel = 0,
        ScrollBarThickness = 4, ScrollBarImageColor3 = C.Light, ClipsDescendants = true,
        CanvasSize = UDim2.fromOffset(0, 0), ScrollingDirection = Enum.ScrollingDirection.Y})
end
function Window:_Art(parent, name, key, x, y, w, h)
    local note = self.u:Text(parent, name .. "Pending", "JBS\n美术资源待上传", x, y, w, h, 18, C.Muted, true)
    note.TextXAlignment, note.TextWrapped = Enum.TextXAlignment.Center, true
    table.insert(self.artGaps, {label = note, key = key})
    return self.u:Art(parent, name, key, x, y, w, h)
end
function Window:_Build()
    local u = self.u
    self.viewport = self:_Scroller(self.Screen, "WindowViewport")
    self.viewport.Size = UDim2.fromScale(1, 1)
    self.root = u:Box(self.viewport, "JBSLibraryWindow", 0, 0, 1672, 941)
    self.shell = u:Panel(self.root, "Shell", 0, 0, 1672, 941)
    self.topbar = u:Panel(self.root, "Topbar", 258, 0, 1414, 60, "card")
    self.title = u:Text(self.topbar, "Title", self.options.Title or "JBS · MUSCLE LEGENDS", 22, 5, 620, 48, 20, C.Light, true)
    self.dragHandle = u:Interact(self.topbar, "DragHandle", 10, 0, 900, 60, function() end)
    self.dragHandle.Selectable = false
    self.windowButtons = {}
    for _, spec in ipairs({
        {"Minimize", "—", function() self:Hide() end},
        {"Resize", "□", function() self.expanded = not self.expanded; self:Resize() end},
        {"Close", "×", function() self:Hide() end},
    }) do
        local label = u:Text(self.topbar, spec[1] .. "Label", spec[2], 0, 5, 54, 46, 25, C.White)
        label.TextXAlignment = Enum.TextXAlignment.Center
        table.insert(self.windowButtons, {label = label, hit = u:Interact(self.topbar, spec[1], 0, 5, 54, 46, spec[3])})
    end
    self.sidebar = u:Panel(self.root, "Sidebar", 0, 0, 246, 914)
    self.logo = self:_Art(self.sidebar, "Logo", "logo_jbs", 8, 6, 230, 147)
    self.navigation = self:_Scroller(self.sidebar, "Navigation")
    self.center = self:_Scroller(self.root, "Center")
    self.hero = u:Panel(self.center, "HeroFrame", 0, 0, 1076, 310)
    if self.config.AvatarPreview.Enabled ~= false then
        if self.config.AvatarPreview.BackEnabled ~= false then requireModule("AvatarSidebarView").Build(self, self.sidebar) end
        requireModule("AvatarHeroView").Build(self)
    else
        self:_Art(self.hero, "Hero", "hero_clean", 3, 3, 1070, 304)
        self:_Art(self.sidebar, "SidebarArt", "sidebar_clean", 0, 629, 246, 245)
    end
    self.brandClose = u:Text(self.sidebar, "BrandClose", "力量不止 · 传奇永在", 10, 875, 226, 24, 16, C.Light)
    self.pagesPanel = u:Panel(self.center, "Pages", 0, 322, 1076, 350)
    self.pageTitle = u:Text(self.pagesPanel, "PageTitle", "添加页面开始使用", 20, 8, 800, 32, 20, C.White, true)
    self.pageHost = u:Box(self.pagesPanel, "PageHost", 16, 50, 1044, 284)
    self.controlPanel = u:Panel(self.root, "Controls", 258, 752, 1076, 162)
    u:Heading(self.controlPanel, self.options.ControlsTitle or "脚本控制", nil, "bolt")
    self.start = u:Button(self.controlPanel, "Start", "开始脚本", 20, 45, 390, 64,
        function() self:_Action("Start") end, true)
    self.stop = u:Button(self.controlPanel, "Stop", "停止脚本", 424, 45, 390, 64,
        function() self:_Action("Stop") end)
    self.feedback = self:_Scroller(self.controlPanel, "Feedback")
    self.feedback.AutomaticCanvasSize = Enum.AutomaticSize.Y
    self.banner = u:Text(self.feedback, "Message", "", 0, 0, 760, 34, 14, C.Light)
    self.banner.TextWrapped, self.banner.TextTruncate = true, Enum.TextTruncate.None
    self.banner.AutomaticSize, self.banner.LineHeight = Enum.AutomaticSize.Y, 1.4
    self.statusPanel = u:Panel(self.root, "Status", 1346, 76, 326, 300)
    u:Heading(self.statusPanel, "脚本状态", nil, "status")
    self.statusRows = {}
    for i, id in ipairs({"connection", "script", "version"}) do
        self.statusRows[id] = View.StatusRow(self, self.statusPanel, id, ({"game", "settings", "version"})[i], 52 + (i - 1) * 78, "", "", "")
    end
    self:SetStatus("connection", {Title = "界面已创建", Detail = "游戏连接由接入方提供", Badge = "UI"})
    self:SetStatus("script", {Title = "等待操作", Detail = "只执行你绑定的回调", Badge = "就绪"})
    self:SetStatus("version", {Title = "JBS UI 1.0.0", Detail = "本地库版本", Badge = "本地"})
    self.settingsPanel = u:Panel(self.root, "Settings", 1346, 388, 326, 330)
    u:Heading(self.settingsPanel, self.options.SettingsTitle or "脚本设置", nil, "settings")
    self.settingsHost = self:_Scroller(self.settingsPanel, "SettingsContent")
    self.settings = Controls.new(self, self.settingsHost, 1)
    self.userPanel = u:Panel(self.root, "User", 1346, 752, 326, 150)
    u:Icon(self.userPanel, "crown", 20, 18, 34)
    self.username = u:Text(self.userPanel, "Username", self.player.DisplayName, 66, 14, 240, 30, 18, C.White, true)
    self.tag = u:Text(self.userPanel, "Tag", self.options.UserTag or "当前玩家", 66, 46, 240, 24, 14, C.Muted)
    self.quote = u:Text(self.userPanel, "Quote", "MORE POWER · MORE POSSIBILITIES", 18, 88, 290, 42, 14, C.Light)
    self.quote.TextWrapped = true
    self.footer = u:Text(self.root, "Footer", self.options.Footer or "The Best Clan In Muscle Legend", 258, 915, 1414, 22, 13, C.Light)
    self.footer.TextXAlignment = Enum.TextXAlignment.Center
    self.restore = u:Button(self.Screen, "Restore", "恢复 JBS", 16, 16, 170, 52, function() self:Show() end, true)
    self.restore.root.Visible = false
    self.scope:Connect(self.viewport:GetPropertyChangedSignal("AbsoluteSize"), function() self:Resize() end)
    View.BindDragging(self)
end

function Window:_RefreshArt()
    for _, gap in ipairs(self.artGaps) do gap.label.Visible = self.assets.status[gap.key] ~= "已加载" end
    -- 紧凑布局没有左侧装饰位，不让异步加载完成重新显示隐藏的图片。
    if self.compact then
        self.logo.Visible = false; self.sidebar.LogoPending.Visible = false
        local art, note = self.sidebar:FindFirstChild("SidebarArt"), self.sidebar:FindFirstChild("SidebarArtPending")
        if art then art.Visible = false end
        if note then note.Visible = false end
    end
    self:RefreshAvatarVisibility()
end
function Window:RefreshAvatarVisibility()
    if not self.heroAvatar then return end
    View.RefreshAvatarVisibility(self)
end

function Window:Resize()
    if self.dead or not self.viewport then return end
    local size = self.viewport.AbsoluteSize
    if size.X <= 0 or size.Y <= 0 then return end
    local w = math.max(280, math.min(self.expanded and size.X - 16 or 1672, size.X - 16))
    local h = math.max(704, math.min(941, size.Y - 16))
    self.compact = w < 1000
    local left, right = w < 1500 and 176 or 246, w < 1500 and 288 or 326
    local centerX, centerW = left + 12, w - left - right - 24
    local centerY, centerH, heroH = 62, h - 254, w < 1500 and 235 or 310
    local sideX, sideY, sideW, sideH = 0, 0, left, h - 27
    local rightX, statusY, statusH = w - right, 76, 288
    local settingsY, settingsH, userY, userH = 376, math.max(150, h - 553), h - 165, 138
    local controlY = h - 189
    if self.compact then
        -- 手机/窄窗只改变排列，不把全页字体一起缩小。
        sideX, sideY, sideW, sideH = 0, 72, w, 132
        centerX, centerW, centerY, centerH, heroH = 0, w, 216, 600, math.max(170, w * 0.29)
        controlY = centerY + centerH + 12
        rightX, right, statusY, statusH = 0, w, controlY + 174, 288
        settingsY, settingsH = statusY + statusH + 12, 320
        userY, userH = settingsY + settingsH + 12, 138
        h = userY + userH + 28
    end
    self.layout = {width = w, height = h, centerWidth = centerW, compact = self.compact}
    local function panel(object, x, y, width, height)
        object.Position = UDim2.fromOffset(x, y); self.u:ResizePanel(object, width, height)
    end
    rect(self.root, math.max(8, (size.X - w) / 2), 8, w, h)
    self.homePosition = self.root.Position
    panel(self.shell, 0, 0, w, h)
    self.viewport.CanvasSize = UDim2.fromOffset(0, h + 16)
    local topX, topW = self.compact and 0 or centerX, self.compact and w or w - centerX
    panel(self.topbar, topX, 0, topW, 60)
    rect(self.title, 22, 5, topW - 206, 48)
    rect(self.dragHandle, 10, 0, topW - 190, 60)
    for i, button in ipairs(self.windowButtons) do
        rect(button.label, topW - 178 + (i - 1) * 56, 5, 54, 46)
        rect(button.hit, topW - 178 + (i - 1) * 56, 5, 54, 46)
    end
    panel(self.sidebar, sideX, sideY, sideW, sideH)
    local navY, navH = self.compact and 12 or 146, self.compact and 108 or math.max(100, sideH - 410)
    rect(self.navigation, 8, navY, sideW - 16, navH)
    self.logo.Visible = not self.compact and self.assets.status.logo_jbs == "已加载"
    self.sidebar.LogoPending.Visible = not self.compact and self.assets.status.logo_jbs ~= "已加载"
    rect(self.logo, 5, 5, sideW - 10, 132)
    rect(self.sidebar.LogoPending, 10, 10, sideW - 20, 120)
    local sideArt = self.sidebar:FindFirstChild("SidebarArt")
    if sideArt then
        local artH = math.min(245, sideW)
        rect(sideArt, 0, sideH - artH - 39, sideW, artH)
        sideArt.Visible = not self.compact and (self.heroAvatar ~= nil or self.assets.status.sidebar_clean == "已加载")
        local note = self.sidebar:FindFirstChild("SidebarArtPending")
        if note then rect(note, 0, sideH - artH - 39, sideW, artH); note.Visible = not self.compact and not self.heroAvatar and self.assets.status.sidebar_clean ~= "已加载" end
    end
    self.brandClose.Visible = not self.compact
    rect(self.brandClose, 10, sideH - 32, sideW - 20, 24)
    local navOffset = 0
    for _, tab in ipairs(self.tabOrder) do
        local titleWidth = sideW - 44
        local bounds = game:GetService("TextService"):GetTextSize(tab.Title, 18, Theme.Bold, Vector2.new(titleWidth, 100000))
        local rowHeight = math.max(54, math.ceil(bounds.Y * 1.4) + 16)
        panel(tab.nav.root, 0, navOffset, sideW - 16, rowHeight)
        rect(tab.nav.label, 14, 8, titleWidth, rowHeight - 16)
        tab.nav.label.TextSize, tab.nav.label.TextWrapped, tab.nav.label.TextTruncate = 18, true, Enum.TextTruncate.None
        rect(tab.nav.button, 0, 0, sideW - 16, rowHeight)
        navOffset += rowHeight + 10
    end
    self.navigation.CanvasSize = UDim2.fromOffset(0, navOffset)
    rect(self.center, centerX, centerY, centerW, centerH)
    panel(self.hero, 0, 0, centerW, heroH)
    rect(self.hero.Hero, 3, 3, centerW - 6, heroH - 6)
    local heroPending = self.hero:FindFirstChild("HeroPending")
    if heroPending then rect(heroPending, 20, 20, centerW - 40, heroH - 40) end
    local pageH = math.max(260, centerH - heroH - 12)
    panel(self.pagesPanel, 0, heroH + 12, centerW, pageH)
    rect(self.pageTitle, 20, 8, centerW - 40, 32)
    rect(self.pageHost, 16, 50, centerW - 32, pageH - 66)
    self.center.CanvasSize = UDim2.fromOffset(0, heroH + 12 + pageH)
    for _, tab in ipairs(self.tabOrder) do
        rect(tab.Root, 0, 0, centerW - 32, pageH - 66)
        tab:Relayout(centerW - 40)
    end
    panel(self.controlPanel, centerX, controlY, centerW, 162)
    local buttonW = (centerW - 54) / 2
    for index, button in ipairs({self.start, self.stop}) do
        panel(button.root, 20 + (index - 1) * (buttonW + 14), 45, buttonW, 64)
        rect(button.button, 0, 0, buttonW, 64); rect(button.label, 12, 0, buttonW - 24, 64)
        button.label.TextSize = 18
    end
    rect(self.feedback, 24, 115, centerW - 48, 36)
    rect(self.banner, 0, 0, centerW - 56, 34)
    panel(self.statusPanel, rightX, statusY, right, statusH)
    for index, id in ipairs({"connection", "script", "version"}) do
        local row, y = self.statusRows[id], 52 + (index - 1) * 78
        rect(row.icon, 18, y + 15, 28, 28)
        rect(row.title, 58, y, right - 140, 26)
        rect(row.detail, 58, y + 28, right - 140, 44)
        row.title.TextSize, row.detail.TextSize = 18, 14
        row.detail.TextWrapped, row.detail.TextTruncate = true, Enum.TextTruncate.None
        rect(row.badge, right - 68, y + 3, 50, 26); row.badge.TextSize = 13
        rect(row.separator, 18, y + 74, right - 36, 1)
    end
    panel(self.settingsPanel, rightX, settingsY, right, settingsH)
    rect(self.settingsHost, 12, 48, right - 24, settingsH - 62)
    self.settings:Relayout(right - 32)
    panel(self.userPanel, rightX, userY, right, userH)
    rect(self.username, 66, 14, right - 84, 30); rect(self.tag, 66, 46, right - 84, 24)
    rect(self.quote, 18, 88, right - 36, 42)
    rect(self.footer, 16, h - 25, w - 32, 22)
    self:RefreshAvatarVisibility()
end

function Window:Tab(options)
    assert(not self.dead, "窗口已销毁")
    if type(options) == "string" then options = {Title = options} end
    options = options or {}
    self.tabSequence += 1
    local id = options.Id or ("tab_" .. self.tabSequence)
    assert(type(id) == "string" and id ~= "" and not self.tabs[id], "Tab.Id 为空或重复")
    local columns = options.Columns or 1
    assert(columns == 1 or columns == 2 or columns == 3, "Columns 只能是 1、2、3")
    assert(options.Title == nil or type(options.Title) == "string", "Tab.Title 必须是字符串")
    local root = self:_Scroller(self.pageHost, "Page_" .. id)
    root.Visible = false
    local tab = Controls.new(self, root, columns)
    tab.Id, tab.Title, tab.Root = id, options.Title or id, root
    tab.navScope = Cleanup.new()
    tab.nav = Components.new(tab.navScope, self.motion, self.assets):Button(self.navigation,
        "Tab_" .. id, tab.Title, 0, 0, 230, 62, function() self:SelectTab(id) end)
    tab.Destroy = function()
        if self.tabs[id] == tab then return self:RemoveTab(id) end
        return false -- 旧 Tab 引用不能销毁后来复用了同一 Id 的新 Tab。
    end
    self.tabs[id] = tab; table.insert(self.tabOrder, tab)
    if not self.activeTab then self:SelectTab(id) end
    self:Resize()
    return tab
end
function Window:RemoveTab(id)
    local tab = self.tabs[id]
    if not tab then return false end
    Controls.Destroy(tab)
    tab.navScope:Destroy()
    for _, object in ipairs(tab.nav.root:GetDescendants()) do self.motion:Cancel(object) end
    self.assets:UnbindTree(tab.nav.root)
    tab.nav.root:Destroy(); tab.Root:Destroy()
    self.tabs[id] = nil
    table.remove(self.tabOrder, table.find(self.tabOrder, tab))
    if self.activeTab == id then
        self.activeTab = nil
        if not self.dead then
            if self.tabOrder[1] then self:SelectTab(self.tabOrder[1].Id)
            else self.pageTitle.Text = "添加页面开始使用" end
        end
    end
    if not self.dead then self:Resize() end
    return true
end
function Window:SelectTab(id)
    if self.dead or not self.tabs[id] then return false end
    self.activeTab = id
    for _, tab in ipairs(self.tabOrder) do
        tab.Root.Visible = tab.Id == id
        tab.nav.label.TextColor3 = tab.Id == id and C.Light or C.White
        for _, control in ipairs(tab.rows) do
            control.drag = nil
            if control.kind == "Dropdown" then control.open = false; control:_Paint() end
            if control.kind == "Slider" then control:_Paint() end
        end
        tab:Relayout()
    end
    self.pageTitle.Text = self.tabs[id].Title
    return true
end
function Window:Sidebar() return self.settings end
function Window:GetControl(id) return self.controls[id] end
function Window:GetValues()
    local values = {}
    for id, control in pairs(self.controls) do if control.value ~= nil then values[id] = control.value end end
    return values
end
function Window:SetStatus(id, info)
    if self.dead then return false end
    local row = self.statusRows[id]
    assert(row, "状态 Id 使用 connection、script 或 version")
    for key, label in pairs({Title = row.title, Detail = row.detail, Badge = row.badge}) do
        if info[key] ~= nil then label.Text = tostring(info[key]) end
    end
    if info.Color then row.badge.BackgroundColor3 = info.Color end
    return true
end
function Window:Notify(message)
    if self.dead then return false end
    if type(message) == "string" then message = {Content = message} end
    self.banner.Text = (message.Title and tostring(message.Title) .. " · " or "") .. tostring(message.Content or "")
    self.feedback.CanvasPosition = Vector2.zero
    return true
end
function Window:_PaintActions()
    for _, pair in ipairs({{"Start", self.start}, {"Stop", self.stop}}) do
        local active = not self.actionBusy and type(self.actions[pair[1]]) == "function"
        pair[2].button.Active, pair[2].button.Selectable = active, active
    end
end
function Window:SetActions(callbacks)
    if self.dead then return false end
    for _, key in ipairs({"Start", "Stop"}) do assert(callbacks[key] == nil or type(callbacks[key]) == "function", key .. " 必须是函数") end
    self.actions = {Start = callbacks.Start, Stop = callbacks.Stop}
    self:_PaintActions()
    if not self.actions.Start and not self.actions.Stop then self:Notify("开始 / 停止回调尚未绑定") end
    return true
end
function Window:_Action(name)
    if self.dead or self.actionBusy or not self.actions[name] then return false end
    self.actionBusy = true; self:_PaintActions()
    local ok, accepted, reason = pcall(self.actions[name], self:GetValues(), self)
    self.actionBusy = false
    if self.dead then return false end
    self:_PaintActions()
    if not ok or accepted == false then self:Notify({Title = "回调未完成", Content = tostring(ok and reason or accepted)}); return false end
    self:Notify(name == "Start" and "已调用开始回调" or "已调用停止回调")
    return true
end
function Window:SetVisible(value)
    if self.dead then return false end
    self.visible = value == true
    self.controller.window = self.visible and "Open" or "Closed"
    self.viewport.Visible, self.restore.root.Visible = self.visible, not self.visible
    for _, control in pairs(self.controls) do
        control.drag = nil
        if control.kind == "Dropdown" then control.open = false; control:_Paint() end
        if control.kind == "Slider" then control:_Paint() end
    end
    for _, tab in ipairs(self.tabOrder) do tab:Relayout() end
    self.settings:Relayout()
    self:RefreshAvatarVisibility()
    return true
end
function Window:Show() return self:SetVisible(true) end
function Window:Hide() return self:SetVisible(false) end
function Window:SetReducedMotion(value) if not self.dead then self.motion:SetReduced(value == true) end end
function Window:OnDestroy(callback)
    assert(type(callback) == "function", "OnDestroy 需要函数")
    self.scope:Add(callback)
    return callback
end
function Window:Diagnostics()
    local count = self.scope:Count()
    for _, tab in ipairs(self.tabOrder) do count += tab.navScope:Count() end
    local controls = 0
    for _, control in pairs(self.controls) do
        controls += 1; count += control.scope:Count() + (control.optionScope and control.optionScope:Count() or 0)
    end
    return {destroyed = self.dead, controls = controls, tabs = #self.tabOrder, connections = count,
        instances = self.dead and 0 or #self.Screen:GetDescendants() + 1,
        avatar = self.heroAvatar and self.heroAvatar:Diagnostics() or {enabled = false}}
end
function Window:Destroy()
    if self.dead then return end
    self.dead = true
    if registry[self.parent] and registry[self.parent][self.Id] == self then registry[self.parent][self.Id] = nil end
    if self.settings then self.settings:Destroy() end
    for _, tab in ipairs(table.clone(self.tabOrder)) do self:RemoveTab(tab.Id) end
    self.scope:Destroy()
    self.motion:Destroy()
    self.assets:Destroy()
    if self.owner then self.owner.OnInvoke = nil; self.owner:Destroy() end
    if self.Screen then self.Screen:Destroy() end
    table.clear(self.tabs); table.clear(self.tabOrder); table.clear(self.controls)
end
return Window

end
factories["Motion"] = function()
--[[
    动效管理：基于 Roblox TweenService 平滑改变位置和颜色。
    一个对象同时只允许一个本模块动画；新动画会取消旧动画。
    减少动态时直接设置最终值，仍保留清晰的界面和点击反馈。
]]
local TweenService = game:GetService("TweenService")
local Motion = {}
Motion.__index = Motion
-- 记录当前动画与用户的减少动态偏好。
function Motion.new(reduced)
    return setmetatable({ active = {}, reduced = reduced, dead = false }, Motion)
end
-- 先移除完成事件，再取消动画，防止旧回调覆盖新状态。
function Motion:Cancel(object)
    local entry = self.active[object]
    if entry then
        self.active[object] = nil
        entry.connection:Disconnect()
        entry.tween:Cancel()
        entry.tween:Destroy()
    end
end
-- 把对象属性变到目标值；动画取消不会误触发正常完成回调。
function Motion:To(object, duration, properties, done)
    if self.dead then
        return
    end
    self:Cancel(object)
    if self.reduced then
        for k, v in pairs(properties) do
            object[k] = v
        end
        if done then
            done()
        end
        return
    end
    local tween = TweenService:Create(
        object,
        TweenInfo.new(duration, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
        properties
    )
    local entry = { tween = tween, properties = properties }
    entry.connection = tween.Completed:Connect(function(state)
        if self.active[object] ~= entry then
            return
        end
        self.active[object] = nil
        entry.connection:Disconnect()
        tween:Destroy()
        if not self.dead and state == Enum.PlaybackState.Completed and done then
            done()
        end
    end)
    self.active[object] = entry
    tween:Play()
end
-- 切换为减少动态时，把所有未完成动画立即放到目标位置。
function Motion:SetReduced(value)
    self.reduced = value
    if value then
        local objects = {}
        for object in pairs(self.active) do
            table.insert(objects, object)
        end
        for _, object in ipairs(objects) do
            local properties = self.active[object].properties
            self:Cancel(object)
            for key, value in pairs(properties) do
                object[key] = value
            end
        end
    end
end
-- 返回本模块仍在管理的动画数，供诊断使用。
function Motion:Count()
    local n = 0
    for _ in pairs(self.active) do
        n += 1
    end
    return n
end
-- 结束本模块所有动画并断开完成事件。
function Motion:Destroy()
    if self.dead then
        return
    end
    self.dead = true
    local objects = {}
    for object in pairs(self.active) do
        table.insert(objects, object)
    end
    for _, object in ipairs(objects) do
        self:Cancel(object)
    end
end
return Motion

end
factories["Runtime"] = function()
--[[
    启动与销毁总入口，把配置、状态、界面、资源和业务适配器组装起来。
    同一 PlayerGui 中通过 JBS5_Owner 找到已有界面，重复运行只恢复窗口。
    默认使用本次游戏会话存储；跨次登录存储需要你的 LoadState / SaveState。
]]
local Cleanup = requireModule("Cleanup")
local Motion = requireModule("Motion")
local Assets = requireModule("Assets")
local Adapter = requireModule("BusinessAdapter")
local Controller = requireModule("Controller")
local View = requireModule("View")
local Catalog = requireModule("LegacyCatalog")
local Defaults = requireModule("Config")
local DefaultBindings = requireModule("BusinessBindings")
local HttpService = game:GetService("HttpService")
local Runtime = {}
local function sanitize(data, config)
    if type(data) ~= "table" then
        data = {}
    end
    local validPages =
        { home = true, teleport = true, pets = true, boss = true, rebirth = true, settings = true }
    local allowedTasks = {}
    for _, feature in ipairs(Catalog.features) do
        allowedTasks[feature.id] = true
    end
    local selected = {}
    if type(data.selected) == "table" then
        for k, v in pairs(data.selected) do
            if allowedTasks[k] and type(v) == "boolean" then
                selected[k] = v
            end
        end
    end
    local choices = {}
    if type(data.choices) == "table" then
        for k, v in pairs(data.choices) do
            if (validPages[k] or k == "eggTargets") and type(v) == "string" then
                choices[k] = v
            end
        end
    end
    local parameters = { targetRebirths = 0, giftAmount = 0 }
    for id in pairs(parameters) do
        local value = type(data.parameters) == "table" and tonumber(data.parameters[id]) or 0
        if value and value == value and math.abs(value) ~= math.huge then
            parameters[id] = math.max(0, math.floor(value))
        end
    end
    local reduced = config.ReducedMotion
    if type(data.reduced) == "boolean" then
        reduced = data.reduced
    end
    return {
        page = validPages[data.page] and data.page or "home",
        selected = selected,
        choices = choices,
        parameters = parameters,
        reduced = reduced,
        sizeMode = data.sizeMode == "Comfort" and "Comfort" or "Fit",
    }
end
-- 一次完整启动：去重 → 读设置 → 创建组件 → 绑定事件 → 加载美术。
function Runtime.Mount(options)
    options = options or {}
    local player = game:GetService("Players").LocalPlayer
    assert(player, "JBS 必须从客户端 LocalScript 运行")
    local parent = options.Parent or player:WaitForChild("PlayerGui")
    local owner = parent:FindFirstChild("JBS5_Owner")
    if owner and owner:IsA("BindableFunction") and owner:GetAttribute("JBSReference05") == true then
        owner:Invoke("Restore")
        return nil, "已恢复现有窗口，未重复启动"
    end
    local config = table.clone(Defaults)
    for k, v in pairs(options.Config or {}) do
        config[k] = v
    end
    local bindings = options.Bindings or DefaultBindings
    local scope = Cleanup.new()
    local adapter = Adapter.new(config, bindings)
    local persisted = nil
    if bindings.LoadState then
        local ok, result = pcall(bindings.LoadState)
        if ok then
            persisted = result
        end
    else
        local raw = parent:GetAttribute(config.SessionAttribute)
        if type(raw) == "string" then
            local ok, result = pcall(HttpService.JSONDecode, HttpService, raw)
            if ok then
                persisted = result
            end
        end
    end
    local controller = Controller.new(adapter, sanitize(persisted, config), function(state)
        if bindings.SaveState then
            bindings.SaveState(state)
        else
            parent:SetAttribute(config.SessionAttribute, HttpService:JSONEncode(state))
        end
    end)
    local motion = Motion.new(controller.reduced)
    local assets = Assets.new(config.AssetIds)
    local screen = Instance.new("ScreenGui")
    screen.Name = "JBS_Reference05"
    screen.ResetOnSpawn = false
    screen.IgnoreGuiInset = false
    screen.DisplayOrder = config.DisplayOrder
    screen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screen.Parent = parent
    local view
    local built, buildError = pcall(function()
        view = View.new(screen, scope, motion, assets, controller, adapter, player, config)
    end)
    if not built then
        controller:Destroy()
        scope:Destroy()
        motion:Destroy()
        assets:Destroy()
        screen:Destroy()
        error(buildError)
    end
    local api = {
        Controller = controller,
        View = view,
        Screen = screen,
        Assets = assets,
        Scope = scope,
        Motion = motion,
    }
    function api.Restore()
        controller:SetWindow("Open")
    end
    function api.Close()
        controller:SetWindow("Closed")
    end
    function api.Diagnostics()
        return {
            avatar = view.heroAvatar and view.heroAvatar:Diagnostics() or { enabled = false },
            instances = #screen:GetDescendants() + 1,
            connections = scope:Count(),
            tweens = motion:Count(),
            refreshCount = view.refreshCount,
            refreshMeanMs = view.refreshCount and view.refreshTotal / view.refreshCount or 0,
            refreshMaxMs = view.refreshMax,
            phase = controller.phase,
            assetStatus = table.clone(assets.status),
            businessWorkerPending = controller.busy,
        }
    end
    function api.Destroy()
        if api.dead then
            return
        end
        api.dead = true
        controller:Destroy()
        motion:Destroy()
        assets:Destroy()
        scope:Destroy()
        if owner then
            owner.OnInvoke = nil
            owner:Destroy()
        end
        screen:Destroy()
    end
    owner = Instance.new("BindableFunction")
    owner.Name = "JBS5_Owner"
    owner:SetAttribute("JBSReference05", true)
    owner.OnInvoke = function(command)
        if command == "Restore" then
            api.Restore()
            return true
        elseif command == "Destroy" then
            api.Destroy()
            return true
        elseif command == "Diagnostics" then
            return api.Diagnostics()
        end
        return false
    end
    owner.Parent = parent
    scope:Add(controller:Subscribe(function()
        view:Refresh()
    end))
    scope:Connect(screen.Destroying, function()
        api.Destroy()
    end)
    if bindings.Changed then
        scope:Connect(bindings.Changed, function()
            view:Refresh()
        end)
    end
    if config.Hotkey then
        scope:Connect(game:GetService("UserInputService").InputBegan, function(event, processed)
            if
                not processed
                and event.KeyCode == config.Hotkey
                and not game:GetService("UserInputService"):GetFocusedTextBox()
            then
                controller:SetWindow(controller.window == "Open" and "Minimized" or "Open")
            end
        end)
    end
    assets:Load(function()
        if not api.dead then
            view:Refresh()
        end
    end)
    return api
end
return Runtime

end
factories["Theme"] = function()
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
    Features = requireModule("LegacyCatalog").features,
    Pages = {
        { "home", "主要", "home" },
        { "teleport", "传送", "teleport" },
        { "pets", "宠物", "pet" },
        { "boss", "Boss", "boss" },
        { "rebirth", "换包重生", "rebirth" },
        { "settings", "设置", "settings" },
    },
}

end
factories["View"] = function()
--[[
    主界面布局：左侧导航、中间主视觉/功能页、右侧状态、底部启停。
    阅读 BuildHome 了解首页，BuildPages 了解翻页；旧版业务页细节在 LegacyPages.lua。
    Refresh 只更新显示，不启动游戏功能。窗口隐藏与脚本停止是两个不同动作。
]]
local Catalog = requireModule("LegacyCatalog")
local Theme = requireModule("Theme")
local LegacyPages = requireModule("LegacyPages")
local Layout = requireModule("Layout")
local Components = requireModule("Components")
local C = Theme.Colors
local View = {}
View.__index = View
local function textChanged(label, value)
    if label.Text ~= value then
        label.Text = value
    end
end
-- 先建立全窗口容器，再创建所有页；之后切页只改变 Visible。
function View.new(screen, scope, motion, assets, controller, adapter, player, config)
    local self = setmetatable({
        scope = scope,
        motion = motion,
        assets = assets,
        controller = controller,
        adapter = adapter,
        player = player,
        nav = {},
        pages = {},
        toggles = {},
        extraToggles = {},
        controlButtons = {},
        teleportButtons = {},
        artGaps = {},
        dropdowns = {},
        windowGeneration = 0,
        pageGeneration = 0,
        frameTimes = {},
        config = config,
    }, View)
    local u = Components.new(scope, motion, assets)
    self.u = u
    self.viewport = u:Make("ScrollingFrame", screen, "Viewport", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Size = UDim2.fromScale(1, 1),
        CanvasSize = UDim2.fromOffset(0, 0),
        ScrollBarThickness = 5,
        ScrollBarImageColor3 = C.Light,
        ScrollingDirection = Enum.ScrollingDirection.XY,
    })
    self.root = u:Box(self.viewport, "JBS_Reference05", 0, 0, 1672, 941)
    self.scale = u:Make("UIScale", self.root, "ResponsiveScale", { Scale = 1 })
    self.shell = u:Panel(self.root, "OuterShell", 0, 0, 1672, 941, "panel")
    self.center = u:Make("ScrollingFrame", self.root, "CenterViewport", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = UDim2.fromOffset(258, 62),
        Size = UDim2.fromOffset(1076, 672),
        CanvasSize = UDim2.fromOffset(0, 672),
        ScrollBarThickness = 4,
        ScrollBarImageColor3 = C.Light,
        ScrollingDirection = Enum.ScrollingDirection.XY,
        ClipsDescendants = true,
    })
    self:BuildSidebar()
    self:BuildTopbar()
    self:BuildHome()
    self:BuildPages()
    self:BuildControl()
    self:BuildRight()
    self.footer = u:Text(
        self.root,
        "Footer",
        "J B S   ·   M U S C L E  L E G E N D S   ·   R O B L O X",
        252,
        911,
        1420,
        28,
        16,
        C.Light
    )
    self.footer.TextXAlignment = Enum.TextXAlignment.Center
    self.restore = u:Button(screen, "Restore", "恢复 JBS", 16, 16, 180, 54, function()
        controller:SetWindow("Open")
    end, true)
    self.restore.root.Visible = false
    self.feedbackArea = u:Make("ScrollingFrame", self.controlPanel, "FeedbackArea", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = UDim2.fromOffset(24, 115),
        Size = UDim2.fromOffset(760, 36),
        CanvasSize = UDim2.fromOffset(0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ScrollBarThickness = 3,
        ClipsDescendants = true,
    })
    self.banner = u:Text(self.feedbackArea, "Feedback", "", 0, 0, 760, 36, 14, C.Light)
    self.banner.TextWrapped = true
    self.banner.TextTruncate = Enum.TextTruncate.None
    self.banner.LineHeight = 1.35
    self.banner.AutomaticSize = Enum.AutomaticSize.Y
    u:Make("Frame", screen, "SafeBounds", { Visible = false, Size = UDim2.fromScale(1, 1) })
    scope:Connect(self.viewport:GetPropertyChangedSignal("AbsoluteSize"), function()
        self:Resize()
    end)
    self:BindDragging()
    self:Resize()
    self:Refresh()
    return self
end
-- 装饰图未接入时显示明确占位说明，不阻止其他控件使用。
function View:Art(parent, name, key, x, y, w, h, message)
    local fallback =
        self.u:Text(parent, name .. "Pending", message, x + 20, y + 12, w - 40, h - 24, 24, C.Muted, true)
    fallback.TextWrapped = true
    fallback.TextXAlignment = Enum.TextXAlignment.Center
    table.insert(self.artGaps, { label = fallback, key = key })
    return self.u:Art(parent, name, key, x, y, w, h)
end
-- 六个导航按钮共用控制器的 page 状态。
function View:BuildSidebar()
    local u = self.u
    local c = self.controller
    local panel = u:Panel(self.root, "Sidebar", 0, 0, 246, 914, "panel")
    self:Art(panel, "Logo", "logo_jbs", 8, 6, 230, 147, "品牌字标\n美术资源未接入")
    local nav = u:Box(panel, "Navigation", 8, 177, 230, 450)
    u:Make("UIListLayout", nav, "NavigationLayout", {
        FillDirection = Enum.FillDirection.Vertical,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 12),
    })
    for i, page in ipairs(Theme.Pages) do
        local row = u:Panel(nav, "Nav_" .. page[1], 0, 0, 230, 66, "card")
        row.LayoutOrder = i
        local face = u:Line(row, "SelectedFace", 10, 6, 210, 54, C.Pink)
        u:Make(
            "UIGradient",
            face,
            "SelectionGradient",
            { Color = ColorSequence.new(C.Pink, Color3.fromHex("57103F")) }
        )
        u:Icon(row, page[3], 21, 10, 43)
        local caption = u:Text(row, "Label", page[2], 85, 0, 133, 66, 27, C.White, true)
        local hit = u:Interact(row, "Navigate", 0, 0, 230, 66, function()
            c:SetPage(page[1])
        end)
        self.nav[page[1]] = { face = face, label = caption, button = hit, shell = row }
    end
    if
        self.config.AvatarPreview
        and self.config.AvatarPreview.Enabled ~= false
        and self.config.AvatarPreview.BackEnabled ~= false
    then
        requireModule("AvatarSidebarView").Build(self, panel)
    else
        self:Art(panel, "SidebarArt", "sidebar_art", 0, 629, 246, 245, "人物装饰\n美术资源未接入")
    end
    u:Text(panel, "BrandClose", "力量不止 · 传奇永在", 20, 875, 215, 24, 20, C.White, true)
end
-- 把拖动区与最小化/尺寸/关闭按钮分开，避免点击被拖拽吞掉。
function View:BuildTopbar()
    local u = self.u
    local c = self.controller
    local bar = u:Panel(self.root, "Topbar", 252, 0, 1420, 60, "card")
    u:Text(bar, "Brand", "JBS  MUSCLE LEGENDS   >>>", 68, 4, 360, 48, 20, C.Light, true)
    u:Text(bar, "Motto", "TRAIN HARDER  ·  BECOME STRONGER", 450, 9, 535, 40, 17, C.Muted)
    local slogan = u:Art(bar, "BrandSlogan", "frame_atlas", 990, 0, 220, 56)
    slogan.ImageRectOffset = Vector2.new(352, 256)
    slogan.ImageRectSize = Vector2.new(245, 60)
    self.dragHandle = u:Interact(bar, "TitleDragArea", 14, 4, 1190, 48, function() end)
    self.dragHandle.Selectable = false
    for _, button in ipairs({
        {
            "Minimize",
            "—",
            1220,
            function()
                c:SetWindow("Minimized")
            end,
        },
        {
            "Resize",
            "□",
            1284,
            function()
                c:SetSizeMode(c.sizeMode == "Fit" and "Comfort" or "Fit")
            end,
        },
        {
            "Close",
            "×",
            1348,
            function()
                c:SetWindow("Closed")
            end,
        },
    }) do
        local label = u:Text(bar, button[1] .. "Icon", button[2], button[3], 5, 60, 45, 30, C.White)
        label.TextXAlignment = Enum.TextXAlignment.Center
        u:Interact(bar, button[1], button[3], 5, 60, 45, button[4])
    end
end
-- 首页保留图五主视觉、三个开关和三个功能页入口。
function View:BuildHome()
    local u, c = self.u, self.controller
    local page = u:Box(self.center, "Page_home", 0, 0, 1076, 672)
    self.pages.home = page
    self.hero = u:Panel(page, "HeroFrame", 0, 0, 1076, 310, "panel")
    if self.config.AvatarPreview and self.config.AvatarPreview.Enabled ~= false then
        requireModule("AvatarHeroView").Build(self)
    else
        self:Art(self.hero, "Hero", "hero_banner", 3, 3, 1070, 304, "主视觉美术资源未接入")
    end
    self.quick = u:Panel(page, "QuickFunctions", 0, 322, 1076, 350, "panel")
    u:Heading(self.quick, "快捷功能", nil, "strength")
    self.cardGrid = u:Box(self.quick, "Cards", 16, 52, 1044, 238)
    self.gridLayout = u:Make("UIGridLayout", self.cardGrid, "CardGrid", {
        CellSize = UDim2.fromOffset(338, 112),
        CellPadding = UDim2.fromOffset(14, 14),
        SortOrder = Enum.SortOrder.LayoutOrder,
        FillDirectionMaxCells = 3,
    })
    self.cards = {}
    for index = 1, 3 do
        local f = Theme.Features[index]
        local card = u:Panel(self.cardGrid, "Card_" .. f.id, 0, 0, 338, 112, "card")
        card.LayoutOrder = index
        local icon = u:Icon(card, f.icon, 16, 34, 44)
        local title = u:Text(card, "Title", f.title, 72, 27, 170, 29, 21, C.White, true)
        local description = u:Text(card, "Description", f.description, 72, 60, 170, 23, 16, C.Muted)
        self.toggles[f.id] = u:Toggle(card, "Toggle_" .. f.id, 258, 32, function()
            c:SetSelected(f.id, not c.selected[f.id])
        end)
        table.insert(
            self.cards,
            {
                root = card,
                icon = icon,
                title = title,
                description = description,
                action = self.toggles[f.id].root,
            }
        )
    end
    for index, f in ipairs({
        { "teleport", "传送地点", "14 个传送地点", "pin" },
        { "pets", "宠物商店购买", "选择宠物 / 光环", "pet" },
        { "boss", "自动打Boss", "自动寻找 Boss", "boss" },
    }) do
        local card = u:Panel(self.cardGrid, "Card_" .. f[1], 0, 0, 338, 112, "card")
        card.LayoutOrder = index + 3
        local icon = u:Icon(card, f[4], 16, 34, 44)
        local title = u:Text(card, "Title", f[2], 72, 27, 212, 29, 21, C.White, true)
        local description = u:Text(card, "Description", f[3], 72, 60, 212, 23, 16, C.Muted)
        local arrow = u:Icon(card, "arrow", 294, 42, 27)
        local hit = u:Interact(card, "Open_" .. f[1], 0, 0, 338, 112, function()
            c:SetPage(f[1])
        end)
        table.insert(
            self.cards,
            { root = card, icon = icon, title = title, description = description, action = arrow, hit = hit }
        )
    end
    -- 原输入框的提交回调继续由 LegacyPages.Input 提供，只移动到卡片下方。
    self.parameterRow = u:Box(self.quick, "ParameterRow", 16, 298, 1044, 44)
    u:Line(self.parameterRow, "Divider", 0, 0, 1044, 1, C.Border)
    u:Text(self.parameterRow, "TargetLabel", Catalog.labels.targetRebirths, 10, 8, 110, 28, 18, C.White, true)
    self.targetInput = LegacyPages.Input(
        self,
        self.parameterRow,
        "targetRebirths",
        "",
        "重生目标，0为无限",
        130,
        -26,
        180
    )
    self.targetInput.Position = UDim2.fromOffset(130, 8)
    self.targetInput.Size = UDim2.fromOffset(180, 32)
    self.targetInput.TextSize = 18
    u:Text(self.parameterRow, "TargetHint", "0 为无限", 326, 8, 190, 28, 14, C.Muted)
end
-- 下拉菜单使用可复用行池：重新读取宠物名单只改文字，已有行不会重复绑定。
function View:Dropdown(parent, name, options, x, y, w, choose)
    local u = self.u
    local state = { open = false, value = nil, options = {}, rows = {} }
    state.button = u:Button(parent, name, "请选择", x, y, w, 58, function()
        -- 展开前重新读取，避免玩家离开后仍显示过期名字。
        if state.page then
            state.SetOptions(self.adapter:GetOptions(state.page))
        end
        if #state.options == 0 then
            return
        end
        state.open = not state.open
        state.list.Visible = state.open
    end, false)
    state.list = u:Make("ScrollingFrame", parent, name .. "Options", {
        Visible = false,
        BackgroundColor3 = C.Black,
        BorderSizePixel = 0,
        Position = UDim2.fromOffset(x, y + 60),
        Size = UDim2.fromOffset(w, 240),
        CanvasSize = UDim2.fromOffset(0, 0),
        ScrollBarThickness = 5,
        ZIndex = 30,
    })
    state.SetOptions = function(nextOptions)
        state.options = nextOptions
        state.list.CanvasSize = UDim2.fromOffset(0, #nextOptions * 48)
        for index, option in ipairs(nextOptions) do
            if not state.rows[index] then
                local label =
                    u:Text(state.list, "Option_" .. index, "", 16, (index - 1) * 48, w - 32, 46, 22, C.White)
                label.ZIndex = 31
                local hit = u:Interact(state.list, "Choose_" .. index, 0, (index - 1) * 48, w, 48, function()
                    local current = state.options[index]
                    state.open = false
                    state.list.Visible = false
                    if current then
                        choose(current.Id)
                    end
                end)
                hit.ZIndex = 32
                state.rows[index] = { label = label, hit = hit }
            end
            state.rows[index].label.Text = option.Label
        end
        for index, row in ipairs(state.rows) do
            row.label.Visible = index <= #nextOptions
            row.hit.Visible = index <= #nextOptions
        end
        state.button.button.Active = #nextOptions > 0
        state.button.button.Selectable = #nextOptions > 0
        if #nextOptions == 0 then
            state.open = false
            state.list.Visible = false
        end
    end
    state.Set = function(value)
        state.value = value
        local title = #state.options > 0 and "请选择" or "暂无可用选项"
        for _, option in ipairs(state.options) do
            if option.Id == value then
                title = option.Label
            end
        end
        textChanged(state.button.label, title)
    end
    state.SetOptions(options)
    table.insert(self.dropdowns, state)
    return state
end
-- 建立设置页及四个旧版业务页；实际旧版布局委托给 LegacyPages。
function View:BuildPages()
    local u = self.u
    local c = self.controller
    for _, p in ipairs(Theme.Pages) do
        if p[1] ~= "home" then
            local page = u:Panel(self.center, "Page_" .. p[1], 0, 0, 1084, 658, "panel")
            page.Visible = false
            self.pages[p[1]] = page
            u:Icon(page, p[3], 36, 28, 52)
            u:Text(page, "Title", p[2], 112, 24, 840, 64, 34, C.White, true)
            u:Text(page, "Subtitle", "JBS · MUSCLE LEGENDS", 40, 106, 930, 34, 21, C.Muted)
            u:Line(page, "Divider", 38, 153, 1008, 2, C.Border)
            if p[1] == "settings" then
                u:Text(page, "EffectsHeading", "界面动效", 44, 188, 800, 40, 26, C.White, true)
                u:Text(
                    page,
                    "EffectsHint",
                    "减少动态保留相同的图片、颜色和静态清晰度。",
                    44,
                    234,
                    952,
                    40,
                    22,
                    C.Muted
                )
                self.effects = self:Dropdown(
                    page,
                    "Effects",
                    { { Id = "full", Label = "完整效果" }, { Id = "reduced", Label = "减少动态" } },
                    44,
                    299,
                    620,
                    function(value)
                        c:SetReduced(value == "reduced")
                    end
                )
                u:Text(
                    page,
                    "Persistence",
                    "页面、选项与动效在本次 PlayerGui 会话中保留。",
                    44,
                    408,
                    970,
                    46,
                    22,
                    C.Muted
                )
                u:Text(
                    page,
                    "Persistence2",
                    "跨次登录存储可通过 BusinessBindings.LoadState / SaveState 接入。",
                    44,
                    457,
                    970,
                    46,
                    20,
                    C.Muted
                )
                self.assetReport = u:Text(page, "Assets", "", 44, 548, 980, 74, 21, C.Light)
                self.assetReport.TextWrapped = true
            else
                LegacyPages.Build(self, page, p[1])
            end
        end
    end
end
-- 开始与停止只调用状态控制器，避免在界面层直接开循环。
function View:BuildControl()
    local u, c = self.u, self.controller
    local panel = u:Panel(self.root, "ScriptControl", 258, 746, 1076, 162, "panel")
    self.controlPanel = panel
    u:Heading(panel, "脚本控制", nil, "bolt")
    self.start = u:Button(panel, "Start", "开始脚本", 20, 45, 380, 64, function()
        c:Start()
    end, true)
    self.stop = u:Button(panel, "Stop", "停止脚本", 414, 45, 380, 64, function()
        c:Stop()
    end, false)
    for _, item in ipairs({ { self.start, "play" }, { self.stop, "stop" } }) do
        u:Icon(item[1].root, item[2], 64, 13, 38)
        item[1].label.Position = UDim2.fromOffset(112, 0)
        item[1].label.Size = UDim2.fromOffset(230, 64)
        item[1].label.TextSize = 24
        item[1].label.TextXAlignment = Enum.TextXAlignment.Left
    end
    self:Art(panel, "ControlArt", "control_art", 838, 9, 225, 129, "美术资源未接入")
end
-- 统一创建状态行，后续只替换标题、描述与徽标文字。
function View:StatusRow(parent, name, icon, y, title, detail, badge)
    local u = self.u
    local image = u:Icon(parent, icon, 22, y + 17, 32)
    local row = {
        icon = image,
        title = u:Text(parent, name .. "Title", title, 88, y, 215, 32, 19, C.White, true),
        detail = u:Text(parent, name .. "Detail", detail, 88, y + 36, 215, 28, 19, C.Muted),
        badge = u:Text(parent, name .. "Badge", badge, 241, y + 4, 65, 27, 19, C.White, true),
    }
    row.title.Size = UDim2.fromOffset(149, 32)
    row.badge.TextXAlignment = Enum.TextXAlignment.Center
    row.badge.BackgroundTransparency = 0.2
    row.badge.BackgroundColor3 = C.Dim
    u:Make("UICorner", row.badge, "StatusPill", { CornerRadius = UDim.new(1, 0) })
    row.separator = u:Line(parent, "Separator", 24, y + 78, 280, 1, C.Border)
    return row
end
-- 右侧五个快捷开关与旧版对应页面共享状态。
function View:BuildRight()
    local u = self.u
    local c = self.controller
    local status = u:Panel(self.root, "Status", 1346, 76, 326, 346, "panel")
    self.statusPanel = status
    u:Heading(status, "脚本状态", nil, "status")
    self.environment = self:StatusRow(status, "Environment", "game", 86, "", "", "")
    self.lifecycle =
        self:StatusRow(status, "Lifecycle", "settings", 172, "脚本未开始", "等待操作", "未开始")
    self.version = self:StatusRow(
        status,
        "Version",
        "version",
        258,
        "版本 " .. self.config.Version,
        "本地配置版本",
        "本地"
    )
    local settings = u:Panel(self.root, "Settings", 1346, 434, 326, 318, "panel")
    self.settingsPanel = settings
    u:Heading(settings, "脚本设置", nil, "settings")
    for i = 4, #Theme.Features do
        local f = Theme.Features[i]
        local y = 75 + (i - 4) * 42
        u:Icon(settings, f.icon, 28, y + 1, 28)
        u:Text(settings, "Label_" .. f.id, f.title, 64, y, 175, 32, 20, C.White)
        self.toggles[f.id] = u:Toggle(settings, "Toggle_" .. f.id, 236, y, function()
            c:SetSelected(f.id, not c.selected[f.id])
        end, true)
    end
    local identity = self.adapter:Identity(self.player)
    local user = u:Panel(self.root, "User", 1346, 764, 326, 150, "panel")
    self.userPanel = user
    u:Icon(user, "crown", 26, 21, 49)
    u:Text(user, "Username", identity.Name or self.player.DisplayName, 92, 19, 204, 31, 22, C.White, true)
    u:Text(user, "Permission", identity.Tag or "普通用户", 92, 51, 205, 27, 19, C.Light)
    u:Line(user, "Divider", 24, 87, 280, 1, C.Border)
    u:Icon(user, "gem", 26, 103, 44)
    u:Text(user, "Quote", "强大的不是脚本，", 93, 99, 213, 28, 20, C.Muted)
    u:Text(user, "Quote2", "而是永不放弃的你。", 93, 129, 213, 28, 20, C.Muted)
end
-- 保持默认逻辑字号；窄窗重排卡片并只滚动中间内容。
function View:Resize()
    local size = self.viewport.AbsoluteSize
    if size.X <= 0 or size.Y <= 0 then
        return
    end
    Layout.Apply(self, size.X, size.Y)
    self.motion:Cancel(self.root)
    self.root.Position = self.homePosition
    if self.controller.window ~= "Open" then
        self.viewport.Visible = false
    end
end
-- 鼠标与触摸共用拖动逻辑，只绑定一次移动和结束事件。
function View:BindDragging()
    local input = game:GetService("UserInputService")
    local drag = nil
    self.scope:Connect(self.dragHandle.InputBegan, function(event)
        if
            event.UserInputType == Enum.UserInputType.MouseButton1
            or event.UserInputType == Enum.UserInputType.Touch
        then
            drag = { input = event, point = event.Position, origin = self.root.Position }
        end
    end)
    self.scope:Connect(input.InputChanged, function(event)
        if not drag then
            return
        end
        if event.UserInputType ~= Enum.UserInputType.MouseMovement and event ~= drag.input then
            return
        end
        local delta = event.Position - drag.point
        local s = self.viewport.AbsoluteSize
        self.root.Position = UDim2.fromOffset(
            math.clamp(drag.origin.X.Offset + delta.X, 8, math.max(8, s.X - 180)),
            math.clamp(drag.origin.Y.Offset + delta.Y, 8, math.max(8, s.Y - 60))
        )
        self.homePosition = self.root.Position
    end)
    self.scope:Connect(input.InputEnded, function(event)
        if drag and (event == drag.input or event.UserInputType == Enum.UserInputType.MouseButton1) then
            drag = nil
        end
    end)
end
-- 业务状态与角色显示解耦：切页/关闭窗口暂停展示，不停止任何业务回调。
function View:RefreshAvatarVisibility()
    if not self.heroAvatar then
        return
    end
    local visibility = {}
    for id, holder in pairs(self.avatarHolders) do
        local visible = self.controller.window == "Open"
        local point, size = holder.AbsolutePosition, holder.AbsoluteSize
        local left, top, right, bottom = point.X, point.Y, point.X + size.X, point.Y + size.Y
        local node = holder
        while node and visible do
            if node:IsA("GuiObject") and not node.Visible then visible = false end
            if node:IsA("ScreenGui") and not node.Enabled then visible = false end
            -- 中间内容滚动后，完全离开裁切区域的主横幅也释放展示；不只看 Visible。
            if node:IsA("GuiObject") and (node.ClipsDescendants or node:IsA("ScrollingFrame")) then
                local p, s = node.AbsolutePosition, node.AbsoluteSize
                if size.X > 0 and size.Y > 0 and s.X > 0 and s.Y > 0 then
                    left = math.max(left, p.X)
                    top = math.max(top, p.Y)
                    right = math.min(right, p.X + s.X)
                    bottom = math.min(bottom, p.Y + s.Y)
                    if right <= left or bottom <= top then
                        visible = false
                    end
                end
            end
            node = node.Parent
        end
        visibility[id] = visible and (id ~= "front" or self.controller.page == "home")
    end
    self.heroAvatar:SetViewVisibility(visibility)
end
-- 状态变化后更新现有实例；不重建页面，不调用业务启动。
function View:Refresh()
    local began = os.clock()
    local c = self.controller
    if c.dead then
        return
    end
    if self.lastReduced ~= c.reduced then
        self.lastReduced = c.reduced
        self.motion:SetReduced(c.reduced)
    end
    for id, nav in pairs(self.nav) do
        local selected = c.page == id
        nav.face.Visible = selected
        for _, child in ipairs(nav.shell:GetChildren()) do
            if child.Name == "Body" or child.Name == "FallbackEdge" then
                child.Visible = selected
            elseif child.Name == "MetalPatch" then
                child.Visible = selected and self.assets.status.frame_atlas == "已加载"
            end
        end
    end
    if self.lastPage ~= c.page then
        self.pageGeneration += 1
        for id, page in pairs(self.pages) do
            page.Visible = c.page == id
        end
        for _, dropdown in ipairs(self.dropdowns) do
            dropdown.open = false
            dropdown.list.Visible = false
        end
        local page = self.pages[c.page] or self.pages.home
        local origin = UDim2.fromOffset(0, 0)
        page.Position = UDim2.fromOffset(8, 0)
        self.motion:To(page, Theme.Motion.Page, { Position = origin })
        self.lastPage = c.page
        self.center.CanvasPosition = Vector2.zero
        self:Resize()
    end
    for id, toggle in pairs(self.toggles) do
        toggle.Set(c.selected[id] == true, self.adapter:Available(id))
    end
    for _, dropdown in ipairs(self.dropdowns) do
        if dropdown.page then
            dropdown.SetOptions(self.adapter:GetOptions(dropdown.page))
            dropdown.Set(c.choices[dropdown.page])
        end
    end
    LegacyPages.Refresh(self)
    self.effects.Set(c.reduced and "reduced" or "full")
    local env = self.adapter:Environment()
    textChanged(self.environment.title, env.Title or "环境未知")
    textChanged(self.environment.detail, env.Detail or "未提供检测数据")
    textChanged(self.environment.badge, env.Badge or "未知")
    self.environment.badge.BackgroundColor3 = env.Kind == "good" and C.Green
        or (env.Kind == "error" and C.Error or C.Dim)
    textChanged(self.lifecycle.title, "脚本" .. c:PhaseText())
    textChanged(self.lifecycle.badge, c:PhaseText())
    textChanged(
        self.lifecycle.detail,
        c.phase == "Error" and "请查看底部错误提示"
            or (c.phase == "Running" and "所选任务已启动" or "仅管理本脚本任务")
    )
    self.lifecycle.badge.BackgroundColor3 = c.phase == "Running" and C.Pink
        or (c.phase == "Error" and C.Error or C.Dim)
    textChanged(self.banner, c.message)
    self.banner.TextColor3 = c.phase == "Error" and C.Error or C.Light
    self.start.button.Active = not c.busy and c.phase ~= "Running" and c.phase ~= "Stopping"
    self.start.button.Selectable = self.start.button.Active
    textChanged(self.start.label, c.phase == "Starting" and "启动中…" or "开始脚本")
    textChanged(self.stop.label, c.phase == "Stopping" and "停止中…" or "停止脚本")
    local loaded, total = self.assets:Summary()
    textChanged(
        self.assetReport,
        "美术资源 "
            .. loaded
            .. " / "
            .. total
            .. " 已加载。未接入或失败时显示降级界面。"
    )
    for _, gap in ipairs(self.artGaps) do
        gap.label.Visible = self.assets.status[gap.key] ~= "已加载"
            and not (gap.key == "control_art" and self.layout and self.layout.narrow)
    end
    -- 异步图片加载也会触发 Refresh；窄窗仍须保留按钮宽度。
    if self.layout and self.layout.narrow then
        self.controlPanel.ControlArt.Visible = false
    end
    if self.lastMode ~= c.sizeMode then
        self.lastMode = c.sizeMode
        self:Resize()
    end
    if self.lastWindow ~= c.window then
        self.lastWindow = c.window
        self.windowGeneration += 1
        local generation = self.windowGeneration
        if c.window == "Open" then
            self.viewport.Visible = true
            self.restore.root.Visible = false
            local p = self.homePosition
            self.root.Position = UDim2.fromOffset(p.X.Offset, p.Y.Offset + 10)
            self.motion:To(self.root, Theme.Motion.Open, { Position = p })
        else
            self.restore.root.Visible = true
            local p = self.homePosition
            self.motion:To(
                self.root,
                Theme.Motion.Hide,
                { Position = UDim2.fromOffset(p.X.Offset, p.Y.Offset + 10) },
                function()
                    if not c.dead and generation == self.windowGeneration and c.window ~= "Open" then
                        self.viewport.Visible = false
                    end
                end
            )
        end
    elseif c.reduced then
        self.viewport.Visible = c.window == "Open"
    end
    self:RefreshAvatarVisibility()
    local ms = (os.clock() - began) * 1000
    self.refreshCount = (self.refreshCount or 0) + 1
    self.refreshTotal = (self.refreshTotal or 0) + ms
    self.refreshMax = math.max(self.refreshMax or 0, ms)
end
return View

end
return requireModule("Library")
