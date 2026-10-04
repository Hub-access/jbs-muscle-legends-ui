-- OPT IN: run this LocalScript in Studio only, after inserting the model.
-- Uses explicit demo task bindings. NEVER contacts game remotes or server APIs.
-- The normal package does not include this script in its executable model.
local RunService=game:GetService("RunService")
assert(RunService:IsStudio(),"Native QA is Studio-only")
local player=game:GetService("Players").LocalPlayer
local package=player.PlayerScripts:WaitForChild("JBS_Reference05")
local Runtime=require(package.Runtime)
local Config=require(package.Config)
local parent=player:WaitForChild("PlayerGui")
local owner=parent:FindFirstChild("JBS5_Owner")
if owner then owner:Invoke("Destroy") end
local session=parent:GetAttribute(Config.SessionAttribute)
local saved=nil;local started,stopped=0,0
local app=Runtime.Mount({Config={AvatarPreview={Enabled=false}},Bindings={
	Tasks={train={Start=function() started+=1;return function() stopped+=1 end end}},
	LoadState=function()return saved end,SaveState=function(state)saved=state end,
	GetEnvironment=function()return {Title="原生 UI 测试",Detail="演示数据 · 无游戏业务",Badge="演示",Kind="neutral"}end,
}})
local c=app.Controller
local function settle()task.wait(0.35)end
settle();local before=app.Diagnostics()
for i=1,120 do c:SetPage(({"home","teleport","pets","boss","rebirth","settings"})[(i-1)%6+1])end
for i=1,120 do c:SetWindow("Closed");c:SetWindow("Open")end
for i=1,200 do c:SetSelected("train",i%2==1)end
c:SetSelected("train",true);c:Start();settle()
for i=1,100 do c:Start()end
assert(started==1,"duplicate task startup")
c:Stop();c:Stop();settle();assert(stopped==1,"duplicate task cleanup")
local after=app.Diagnostics()
assert(after.instances==before.instances,"instance growth")
assert(after.connections==before.connections,"connection growth")
local function sample(reduced,animate)
	c:SetReduced(reduced);c:SetPage("home");settle()
	local samples={}
	for i=1,180 do
		if animate and i%12==0 then c:SetSelected("train",i%24==0)end
		table.insert(samples,RunService.RenderStepped:Wait()*1000)
	end
	table.sort(samples);local sum=0;for _,v in ipairs(samples)do sum+=v end
	return {samples=#samples,meanMs=sum/#samples,p50Ms=samples[math.ceil(#samples*.50)],p95Ms=samples[math.ceil(#samples*.95)]}
end
local result={environment="Roblox Studio, explicit demo data",viewport=tostring(workspace.CurrentCamera.ViewportSize),
	before=before,after=after,static=sample(false,false),animated=sample(false,true),reduced=sample(true,false),
	note="Frame intervals include Studio/game overhead; not isolated UI GPU time. Refresh CPU excludes async/network latency. Manual pointer, touch and screenshot checks still required."}
print("JBS_NATIVE_QA "..game:GetService("HttpService"):JSONEncode(result))
app.Destroy();parent:SetAttribute(Config.SessionAttribute,session)
Runtime.Mount() -- Rebuild using the actual Config and BusinessBindings.
