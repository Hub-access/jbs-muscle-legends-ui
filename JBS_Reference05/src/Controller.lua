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
