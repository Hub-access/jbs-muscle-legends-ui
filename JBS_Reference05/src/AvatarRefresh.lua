-- 有最大等待时间的防抖 + 限频。纯函数可用虚拟时间测试，不绑定逐帧事件。
local Refresh = {}
function Refresh.Due(first, latest, lastBuild, debounce, maxWait, minInterval)
    return math.max(math.min(latest + debounce, first + maxWait), lastBuild + minInterval)
end
return Refresh
