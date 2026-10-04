--[[
    图片加载器：先校验资源 ID，再加载，再通知界面显示结果。
    AssetData 描述裁片位置；Config.AssetIds 指定 Roblox 上传后的资源 ID。
    缺失或加载失败时保留原生控件和文字提示，不假装图片已经成功显示。
]]
local ContentProvider = game:GetService("ContentProvider")
local Assets = {}
Assets.__index = Assets
Assets.Meta = require(script.Parent.AssetData)
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
