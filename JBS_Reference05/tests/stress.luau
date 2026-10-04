-- Existing UI/business regression explicitly disables the separately tested 3D feature.
local function mount(options)
    options = options or {}; options.Config = options.Config or {}
    options.Config.AvatarPreview = {Enabled = false}
    return Modules.Runtime.Mount(options)
end
local passed=0
local function check(value,message)assert(value,message);passed+=1 end
local baseline=instanceCount()
local api=mount();local c=api.Controller
local initial=api.Diagnostics();local initialConnections=activeConnections()
local function activate(name)
	local button=api.Screen:FindFirstChild(name,true);assert(button,name);button.Activated:Fire()
end
check(c.phase=="Idle","must start idle")
check(not c:Start() and c.phase=="Idle","empty adapter must never claim running")
check(not c:SetSelected("train",true),"unbound feature must reject")
for n=1,120 do
	local page=({"home","teleport","pets","boss","rebirth","settings"})[(n-1)%6+1]
	api.Screen:FindFirstChild("Nav_"..page,true):FindFirstChild("Navigate").Activated:Fire()
end
for n=1,120 do
	activate(n%2==0 and "Close" or "Minimize");check(c.window~="Open","window hides")
	activate("RestoreAction");check(c.window=="Open" and api.View.viewport.Visible,"window restores")
end
activate("EffectsAction");check(api.View.effects.list.Visible,"actual dropdown opens")
api.View.effects.list:FindFirstChild("Choose_2").Activated:Fire()
check(c.reduced and not api.View.effects.list.Visible,"dropdown selection applies")
local before=api.Diagnostics()
check(before.instances==initial.instances,"page/window operations created instances")
check(activeConnections()==initialConnections,"page/window operations grew connections")
local duplicate,message=mount();check(duplicate==nil and message~=nil,"duplicate mount creates no new UI")
check(api.Diagnostics().instances==before.instances,"duplicate mount grew tree")
-- Test view race with delayed real Luau callbacks and a cancelled tween.
c:SetReduced(false);autoTween=false
c:SetWindow("Closed");local closing=pendingTweens[#pendingTweens]
c:SetWindow("Open");closing.Completed:Fire(Enum.PlaybackState.Completed)
flushTweens();check(api.View.viewport.Visible,"stale close completion hid restored window")
-- Resize while closing must not strand the visibility transition.
c:SetWindow("Closed");api.View:Resize();check(not api.View.viewport.Visible,"resize cancelled close but left window visible")
c:SetWindow("Open");flushTweens();autoTween=true
api.Destroy();check(activeConnections()==0,"destroy leaked UI connections");check(instanceCount()==baseline,"destroy leaked instances")

local started,stopped,performed=0,0,0
local bindings={Tasks={train={Start=function(context)
	started+=1;return function()stopped+=1 end
end}},Actions={teleport={Options={{Id="a",Label="授权测试目标"}},Perform=function(id)check(id=="a","option id");performed+=1;return "演示数据：已执行离线测试" end}}}
api=mount({Bindings=bindings});c=api.Controller
check(c.page=="settings","session preserves last page after destroy/rebuild")
local stable=api.Diagnostics()
for i=1,200 do api.Screen:FindFirstChild("Toggle_trainAction",true).Activated:Fire()end
check(c.selected.train==false,"200 toggles final state")
check(started==0,"selection must not invoke business")
c:SetSelected("train",true);check(c:Start(),"start accepts bound selected job");check(c.phase=="Running","running after start")
for i=1,100 do c:Start();api.View:Refresh()end
check(started==1,"repeated start/refresh duplicated job")
c:SetWindow("Closed");check(stopped==0 and c.phase=="Running","hide must not stop business")
c:Stop();c:Stop();check(stopped==1,"stop must be exactly once")
for i=1,50 do c:Start();c:Stop()end
check(started==51 and stopped==51,"balanced ownership")
c:SetPage("teleport");c:SetChoice("teleport","a");c:Perform("teleport");check(performed==1,"action must execute exactly once")
check(not c:SetChoice("teleport","invented"),"arbitrary destination rejected")
check(api.Diagnostics().instances==stable.instances,"toggle/start stress grew instances")
check(api.Diagnostics().connections==stable.connections,"toggle/start stress grew bindings")
api.Destroy();check(activeConnections()==0,"integrated cleanup connections")

-- Cooperative cancellation: yielded startup returns a cleanup after Stop.
local resumedStop=0;local delayedThread
local asynchronous={Tasks={train={Start=function(context)
	delayedThread=coroutine.running();coroutine.yield();return function()resumedStop+=1 end
end}}}
api=mount({Bindings=asynchronous});c=api.Controller
c:SetSelected("train",true);c:Start();check(c.phase=="Starting","yielded start shows Starting")
c:Stop();check(c.phase=="Stopping" and not c:Start(),"restart blocked until cancelled startup settles")
check(coroutine.resume(delayedThread),"resume startup")
check(c.phase=="Stopped" and resumedStop==1,"late start cleaned once")
c:Start();api.Destroy();check(coroutine.resume(delayedThread),"destroy then late startup")
check(resumedStop==2,"destroy owns late cleanup")

-- Startup rollback and cleanup failures must remain errors.
local rollback=0
api=mount({Bindings={Tasks={a={Start=function()return function()rollback+=1 end end},b={Start=function()error("injected start failure")end}}}})
c=api.Controller;c:SetSelected("a",true);c:SetSelected("b",true);c:Start()
check(c.phase=="Error" and rollback==1,"partial startup rollback")
api.Destroy()
api=mount({Bindings={Tasks={train={Start=function()return function()error("injected stop failure")end end}}}})
c=api.Controller;c:SetSelected("train",true);c:Start();c:Stop();check(c.phase=="Error","cleanup error must surface")
check(not c:Start(),"failed cleanup must block duplicate startup");api.Destroy()

-- Asset loading failure must preserve controls and honestly report failure.
contentFails=true
api=mount({Config={AssetIds={hero_banner="rbxassetid://123"}}}) -- TEST FIXTURE ONLY, never shipped Config.
check(api.Assets.status.hero_banner=="加载失败","asset failure must be recorded")
check(api.View.artGaps[2].label.Visible,"missing hero fallback")
activate("Minimize");activate("RestoreAction");check(api.View.viewport.Visible,"asset failure did not break controls")
api.Destroy();contentFails=false
check(activeConnections()==0,"final connection leak")
check(instanceCount()==baseline,"final instance leak")
-- 本次旧版控件同步：参数、动态列表、重复入口、一次性操作及取消。
api=mount();c=api.Controller
check(#c.adapter:GetOptions("teleport")==14,"all original teleport destinations")
check(#c.adapter:GetOptions("pets")==49,"all original fallback pet names")
check(#c.adapter:GetOptions("eggTargets")==0,"never invent online players")
local names={}
for _,option in ipairs(c.adapter:GetOptions("teleport")) do names[option.Label]=true end
check(names["大厅"] and names["无转盘岛"] and names["海滩争斗"],"original teleport labels")
local targetInput=api.Screen:FindFirstChild("Input_targetRebirths",true)
targetInput.Text="12";targetInput.FocusLost:Fire()
check(c.parameters.targetRebirths==12,"actual input commits target")
local giftInput=api.Screen:FindFirstChild("Input_giftAmount",true)
giftInput.Text="-8";giftInput.FocusLost:Fire()
check(c.parameters.giftAmount==0 and giftInput.Text=="0","negative amount normalizes")
c:SetParameter("targetRebirths","invalid")
check(c.parameters.targetRebirths==0,"invalid target uses unlimited default")
c:SetParameter("targetRebirths",12)
local stableOptions=api.Diagnostics()
for i=1,100 do activate("RefreshPetsAction") end
check(api.Diagnostics().instances==stableOptions.instances,"refresh reused pet rows")
check(api.Diagnostics().connections==stableOptions.connections,"refresh did not duplicate bindings")
local petsDrop
for _,drop in ipairs(api.View.dropdowns) do if drop.page=="pets" then petsDrop=drop end end
petsDrop.list:FindFirstChild("Choose_7").Activated:Fire()
check(c.choices.pets=="地狱火龙","actual pet row selects original name")
check(not api.Screen:FindFirstChild("buyPetAction",true).Active,"unconnected buy stays disabled")
check(not c:PressControl("buyPet"),"unconnected buy cannot run")
api.Destroy()
local controlCalls=0
local actualPetOptions={{Id="地狱火龙",Label="地狱火龙"}}
local actualPlayers={{Id="OfflineFixturePlayer",Label="离线测试玩家"}} -- 仅测试夹具，不进入产品名单。
local receivedContext
local connected={
    Tasks={petbuy={Start=function(context)receivedContext=context;return function()end end}},
    GetOptions=function(page) if page=="pets" then return actualPetOptions elseif page=="eggTargets" then return actualPlayers end end,
    Controls={
        buyPet=function(parameters)check(parameters.pet=="地狱火龙","purchase uses selected actual name");controlCalls+=1;return "offline purchase fixture" end,
        giftEggs=function(parameters)check(parameters.eggTarget=="OfflineFixturePlayer" and parameters.giftAmount==3,"gift uses selected player and amount");controlCalls+=1 end,
    },
}
api=mount({Bindings=connected});c=api.Controller
check(c.parameters.targetRebirths==12,"parameters persist across window reconstruction")
c:SetChoice("pets","地狱火龙")
activate("DetailToggle_petbuyAction")
check(c.selected.petbuy==true,"detail petbuy switch updates shared state")
activate("Toggle_petbuyAction")
check(c.selected.petbuy==false,"sidebar switch updates same state")
c:SetSelected("petbuy",true);c:Start()
check(receivedContext.Choices.pets=="地狱火龙" and receivedContext.Parameters.targetRebirths==12,"task receives parameter snapshot")
c:SetParameter("targetRebirths",99)
check(receivedContext.Parameters.targetRebirths==12,"running snapshot is immutable from UI edits")
c:Stop()
activate("buyPetAction");check(controlCalls==1,"actual purchase button executes once")
c:SetChoice("eggTargets","OfflineFixturePlayer");c:SetParameter("giftAmount",3)
activate("giftEggsAction");check(controlCalls==2,"actual gift button executes once")
actualPlayers={}
check(not c:PressControl("giftEggs") and controlCalls==2,"departed player cannot receive action")
actualPetOptions={}
c:RefreshOptions("pets")
check(c.choices.pets==nil,"refresh removes disappeared selection")
check(not c:Start(),"automatic buying requires valid selection")
api.Destroy()
check(activeConnections()==0 and instanceCount()==baseline,"new controls clean up")

-- 第一阶段布局回归：离线控件几何，不冒充 Roblox 字体/图片渲染。
api=mount();c=api.Controller;c:SetPage("home")
local view=api.View
local layoutBefore=api.Diagnostics()
for _,viewport in ipairs({{1696,1010,3},{1280,900,2}}) do
    view.viewport.AbsoluteSize=Vector2.new(viewport[1],viewport[2]);view:Resize()
    local l=view.layout
    check(l.scale==1,"narrow window must not shrink all text")
    check(l.columns==viewport[3],"quick cards responsive columns")
    check(view.root.Size.X.Offset<viewport[1] and view.root.Size.Y.Offset<viewport[2],"shell fits viewport")
    for _,card in ipairs(view.cards) do
        check(card.title.Position.X.Offset+card.title.Size.X.Offset+16<=card.action.Position.X.Offset,"card reserves action gap")
        check(card.description.Position.X.Offset==card.title.Position.X.Offset,"card text aligns")
        check(card.description.TextSize==16 and not card.title.TextScaled,"essential text remains readable")
    end
    check(view.parameterRow.Position.Y.Offset>=view.cardGrid.Position.Y.Offset+view.cardGrid.Size.Y.Offset+8,"target row below six cards")
    check(view.feedbackArea.Position.Y.Offset>=view.start.root.Position.Y.Offset+view.start.root.Size.Y.Offset+6,"message does not touch button")
    for _,row in ipairs({view.environment,view.lifecycle,view.version}) do
        check(row.detail.Position.X.Offset+row.detail.Size.X.Offset+12<=row.badge.Position.X.Offset,"status text outside capsule")
    end
    for i=1,20 do view:Resize();view:Refresh() end
    check(api.Diagnostics().instances==layoutBefore.instances,"resizing reuses existing controls")
    check(api.Diagnostics().connections==layoutBefore.connections,"resizing preserves one callback per control")
end
api.Destroy();check(activeConnections()==0 and instanceCount()==baseline,"layout cleanup")

print("PASS",passed,"assertions; 120 page changes; 120 hide/restore cycles; 200 toggles; 100 duplicate starts; 50 start/stop cycles")
print("MOCK ONLY: initial instances",initial.instances,"connections",initial.connections,"native rendering/FPS not measured")
