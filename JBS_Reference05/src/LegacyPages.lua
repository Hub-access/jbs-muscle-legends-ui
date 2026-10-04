--[[
    旧版功能页的布局：传送、宠物、Boss、换包重生。
    只创建控件、转交点击；游戏动作必须经过 BusinessAdapter。
    看懂方法：x/y 是位置，w/h 是宽高，单位都按 1672 × 941 设计画布计算。
    改名字先看 catalog/PreviousUI.json；改控件位置在本文件修改数字。
]]
local Catalog = require(script.Parent.LegacyCatalog)
local Theme = require(script.Parent.Theme)
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
