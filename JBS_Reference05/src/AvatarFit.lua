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
