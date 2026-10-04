-- Executes production snapshot, fit and lifecycle code against an explicit offline engine double.
local passed=0
local function check(value,message)assert(value,message);passed+=1 end
local Snapshot,Fit,Hero=Modules.AvatarSnapshot,Modules.AvatarFit,Modules.HeroAvatar
local baseInstances=instanceCount()
local sourceFolder=Instance.new("Folder")
local function part(model,name,size,cfValue)
 local p=Instance.new("Part");p.Name=name;p.Size=size;p.CFrame=cfValue;p.Parent=model;return p
end
local function joint(model,a,b,offset)
 local j=Instance.new("Motor6D");j.Part0=a;j.Part1=b;j.C0=offset;j.Parent=model;return j
end
local function fixture(width,r15)
 local m=Instance.new("Model");m.Name=r15 and "TestR15"or"TestR6"
 local h=Instance.new("Humanoid");h.Parent=m
 local root=part(m,"HumanoidRootPart",Vector3.new(2,2,1),CFrame.new(100,20,-80)*CFrame.Angles(0,1.2,0));root.Transparency=1
 local torso=part(m,r15 and "UpperTorso"or"Torso",Vector3.new(width,2,1),CFrame.new(105,20,-90))
 local head=part(m,"Head",Vector3.new(2,1,1),CFrame.new(107,30,-90));head.LocalTransparencyModifier=1
 local arm=part(m,r15 and "LeftUpperArm"or"Left Arm",Vector3.new(width/2,3,2),CFrame.new(999,300,-90))
 joint(m,root,torso,CFrame.identity);joint(m,torso,head,CFrame.new(0,1.5,0))
 local shoulder=joint(m,torso,arm,CFrame.new(-width*.7,0,0));shoulder.Transform=CFrame.Angles(0,1,0)
 local leg=part(m,r15 and "LeftUpperLeg"or"Left Leg",Vector3.new(1,2,1),CFrame.new());joint(m,torso,leg,CFrame.new(-.5,-2,0))
 local shirt=Instance.new("Shirt");shirt.ShirtTemplate="rbxassetid://1";shirt.Parent=m -- fixture, not production asset
 local scriptObject=Instance.new("LocalScript");scriptObject.Parent=m
 local tool=Instance.new("Tool");tool.Parent=m;part(tool,"Handle",Vector3.new(10,10,10),CFrame.new(200,200,200))
 local gui=Instance.new("BillboardGui");gui.Name="CustomLabel";gui.Parent=head
 m.Archivable=false;head.Archivable=false;m.Parent=sourceFolder
 return m
end
local function accessory(m,height)
 local acc=Instance.new("Accessory");acc.Name="TestHat"
 local handle=part(acc,"Handle",Vector3.new(2,height,1),CFrame.new())
 local weld=Instance.new("Weld");weld.Part0=m.Head;weld.Part1=handle;weld.C0=CFrame.new(0,height/2,0);weld.Parent=handle
 acc.Parent=m;return acc
end
local r6=fixture(4,false);local r15=fixture(2,true)
local sourceHeadCF=r6.Head.CFrame;local sourceShoulder=r6:FindFirstChildWhichIsA("Motor6D")
local currentModels=instanceCount()
local copy,err=Snapshot.FromCharacter(r6)
check(copy~=nil,err or "snapshot")
check(not r6.Archivable and not r6.Head.Archivable,"restores all false Archivable flags")
check(r6.Head.CFrame==sourceHeadCF and r6.Head.LocalTransparencyModifier==1,"real pose/transparency unchanged")
check(copy.model.Head.LocalTransparencyModifier==0 and copy.model.HumanoidRootPart.Transparency==1,"copy visibility retains invisible root")
check(copy.model.Head.Position.Y==1.5 and copy.model.Head.Position.X==0,"neutral pose removes captured animation/world yaw")
check(not copy.model:FindFirstChildWhichIsA("LocalScript",true)and not copy.model:FindFirstChild("Tool"),"strips scripts/tool")
check(#copy.report.unsupported==1,"reports unsupported 2D label")
check(copy.model:FindFirstChildOfClass("Shirt").ShirtTemplate=="rbxassetid://1","preserves clothing")
copy.model:Destroy();check(instanceCount()==currentModels,"snapshot released")
r6.failClone=true;copy,err=Snapshot.FromCharacter(r6)
check(copy==nil and err~=nil and not r6.Archivable and not r6.Head.Archivable,"Clone failure restores descendants")
r6.failClone=false
local outside=part(sourceFolder,"Outside",Vector3.new(1,1,1),CFrame.new())
local ex=Instance.new("Weld");ex.Part0=r6.Head;ex.Part1=outside;ex.Parent=r6
local ref=Instance.new("ObjectValue");ref.Value=outside;ref.Parent=r6
copy=assert(Snapshot.FromCharacter(r6))
for _,v in ipairs(copy.model:GetDescendants())do
 if v:IsA("JointInstance")then check(v.Part0:IsDescendantOf(copy.model)and v.Part1:IsDescendantOf(copy.model),"no external joint reference")end
end
check(copy.model:FindFirstChildOfClass("ObjectValue")==nil,"removes business object reference")
copy.model:Destroy();ex:Destroy();ref:Destroy();outside:Destroy()
local hidden=part(r6,"HiddenHelper",Vector3.new(5000,5000,5000),CFrame.new(3000,0,0));hidden.Transparency=1
local hat=accessory(r6,4)
copy=assert(Snapshot.FromCharacter(r6));check(copy.bounds.maxY>=5.5 and copy.bounds.maxX<10,"high hat included, invisible helper excluded")
for _,wh in ipairs({{450,260},{200,400},{1000,200}})do
 local f=Fit.Compute(copy.bounds,wh[1],wh[2],35)
 check((copy.bounds.maxX-copy.bounds.minX)/2<=f.nearDistance*f.tanX,"horizontal framing")
 check((copy.bounds.maxY-math.max(copy.bounds.minY,copy.bounds.fitBottom))/2<=f.nearDistance*f.tanY,"head-to-hip framing")
end
check(Fit.Compute(copy.bounds,0,0,35)==nil,"zero sized viewport waits for layout")
copy.model:Destroy();hat:Destroy();hidden:Destroy()
local qaPlayer=Instance.new("Player");qaPlayer.UserId=924618;qaPlayer.Character=r6
local viewport=Instance.new("ViewportFrame");viewport.Parent=sourceFolder;viewport.AbsoluteSize=Vector2.new(450,260)
local label=Instance.new("TextLabel")
local requests={};local calls=0;local accountFailure=false
services.Players.CreateHumanoidModelFromUserIdAsync=function(_,id)
 calls+=1;check(id==qaPlayer.UserId,"uses current player UserId only")
 if accountFailure then error("injected account error")end
 local co=coroutine.running();table.insert(requests,co);return coroutine.yield()
end
local hero=Hero.new(qaPlayer,viewport,label,{MinInterval=.5})
hero:SetVisible(true);advance(.6)
check(hero.source=="character"and hero.buildCount==1 and calls==0,"existing Character wins without account request")
check(hero.active.model~=r6 and r6.Parent==sourceFolder,"source never reparented")
local stable=hero:Diagnostics();local stableInstances=instanceCount();local stableConnections=activeConnections()
for i=1,30 do
 hero:SetVisible(false)
 check(hero:Diagnostics().activeModels==0 and hero:Diagnostics().worlds==0 and queuedCount()==0,"hidden releases model/world/timers")
 local oldBuilds=hero.buildCount;r6.Head.Color=Color3.new(i/30,.5,.8);advance(.7)
 check(hero.buildCount==oldBuilds,"hidden appearance change does not build")
 hero:SetVisible(true);advance(.7)
 check(hero.source=="character"and hero:Diagnostics().activeModels==1,"restore latest source")
 check(instanceCount()==stableInstances and activeConnections()==stableConnections,"30 cycles bounded instances/connections")
end
local builds=hero.buildCount
for i=1,50 do r6.Head.CFrame=CFrame.new(i,i,i)end;advance(2)
check(hero.buildCount==builds,"movement is not appearance")
for i=1,20 do r6.Head.Size=Vector3.new(2+i*.01,1,1)end;advance(.6)
check(hero.buildCount==builds+1,"appearance burst collapses")
local lateHat=accessory(r6,3);advance(.7)
check(hero.active.model:FindFirstChild("TestHat")~=nil,"late accessory arrives")
lateHat:Destroy();advance(.7)
check(not hero.active.model:FindFirstChild("TestHat")and activeConnections()==stableConnections,"removing accessory releases listeners")
local firstBuild=hero.buildCount
for i=1,30 do r6.Head.Size=Vector3.new(2+i*.01,1,1);advance(.1)end
check(hero.buildCount>firstBuild and hero.buildCount-firstBuild<=6,"continuous changes bounded and not starved")
qaPlayer.CharacterRemoving:Fire(r6);qaPlayer.Character=nil;advance(1.8)
check(#requests==1,"missing character starts one fallback")
qaPlayer.Character=r15;qaPlayer.CharacterAdded:Fire(r15);advance(.7)
check(hero.source=="character"and hero.active.model:FindFirstChild("UpperTorso")~=nil,"respawn switches to different test body")
local late=fixture(9,false);late.Parent=nil
check(coroutine.resume(table.remove(requests,1),late),"resolve old account request")
check(late._destroyed and hero.active.model:FindFirstChild("UpperTorso")~=nil,"late old fallback cannot overwrite new character")
hero:SetCharacter(nil);qaPlayer.Character=nil;advance(1.8)
local account=fixture(3,false);account.Parent=nil
check(coroutine.resume(table.remove(requests,1),account),"resolve valid fallback")
check(hero.source=="account"and string.find(label.Text,"备用")~=nil,"account fallback honestly labelled")
hero:SetCharacter(r6);advance(.7);check(hero.source=="character","ready game body replaces account fallback")
hero:SetCharacter(nil);advance(1.8);check(hero.pendingFallback~=nil,"pending request before destruction")
hero:Destroy();check(hero:Diagnostics().connections==0 and hero:Diagnostics().scheduledTasks==0,"destroy disconnects all owned listeners/timers")
local abandoned=fixture(3,true);abandoned.Parent=nil
check(coroutine.resume(table.remove(requests,1),abandoned),"resolve after destruction")
check(abandoned._destroyed and hero:Diagnostics().activeModels==0,"destroyed request cleans result")
local second=Hero.new(qaPlayer,viewport,label,{MinInterval=.5,ReadyAttempts=3});accountFailure=true
second:SetVisible(true);advance(10)
check(second.fallbackAttempts==2 and second.pendingFallback==nil and second.lastError~=nil,"account failure bounded retries")
second:Destroy();accountFailure=false
-- A slow engine request must not multiply across Destroy / Mount cycles.
local callsBefore = calls
for _ = 1, 30 do
    local transient = Hero.new(qaPlayer, viewport, label, {MinInterval=.5,ReadyAttempts=2})
    transient:SetVisible(true);advance(1.8)
    check(transient:Diagnostics().packageAccountRequests == 1,"remount adopts the one package request")
    transient:Destroy()
end
check(calls == callsBefore + 1 and #requests == 1,"30 destroyed viewers did not create 30 account requests")
local unused=fixture(3,false);unused.Parent=nil
check(coroutine.resume(table.remove(requests,1),unused),"resolve shared abandoned request")
check(unused._destroyed,"request without subscribers destroys model")
-- Exercise the full production View/Runtime integration with the 3D option ON.
player.Character=r6;player.UserId=qaPlayer.UserId
local integrated=Modules.Runtime.Mount({Bindings={LoadState=function()return {page="home",reduced=true}end,SaveState=function()end}})
advance(.7)
check(integrated.View.heroAvatar.source=="character","default native UI mounts player preview")
check(integrated.Screen:FindFirstChild("CleanCityBackground",true)~=nil and integrated.Screen:FindFirstChild("OriginalBrandForeground",true)~=nil,"native three-layer hero exists")
check(integrated.Screen:FindFirstChild("NativeArtPending",true).Visible,"unuploaded art clearly labelled")
check(integrated.Screen:FindFirstChild("Hero",true):IsA("Frame"),"live hero does not use baked character banner")
integrated.Screen.Enabled=false
check(integrated.View.heroAvatar:Diagnostics().activeModels==0,"screen disable suspends viewer")
integrated.Screen.Enabled=true;advance(2)
check(integrated.View.heroAvatar.source=="character","screen enable resumes viewer")
integrated.Controller:SetPage("pets")
check(not integrated.View.heroAvatar.views.front.visible and integrated.View.heroAvatar.views.back.visible,"navigation away suspends front and preserves visible back")
integrated.Controller:SetPage("home");advance(2)
check(integrated.View.heroAvatar.source=="character","navigation home restores viewer")
integrated.Destroy();player.Character=nil
qaPlayer:Destroy();viewport:Destroy();label:Destroy();sourceFolder:Destroy()
check(activeConnections()==0 and instanceCount()==baseInstances and queuedCount()==0,"all fixture resources restored")
print("PASS",passed,"avatar assertions; 30 hide/restore cycles; source/respawn/late accessory/races/failure/cleanup")
print("OFFLINE ENGINE DOUBLE ONLY. No native screenshots, layered-clothing fidelity, FPS or real-account verification.")
