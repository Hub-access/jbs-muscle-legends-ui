-- Extends mock-engine for deterministic lifecycle tests. NOT Roblox rendering/physics.
local Vector3 = {}; local v3mt = {}
function Vector3.new(x,y,z) return setmetatable({X=x or 0,Y=y or 0,Z=z or 0},v3mt) end
v3mt.__add=function(a,b)return Vector3.new(a.X+b.X,a.Y+b.Y,a.Z+b.Z)end
v3mt.__sub=function(a,b)return Vector3.new(a.X-b.X,a.Y-b.Y,a.Z-b.Z)end
v3mt.__mul=function(a,n)return Vector3.new(a.X*n,a.Y*n,a.Z*n)end
v3mt.__div=function(a,n)return Vector3.new(a.X/n,a.Y/n,a.Z/n)end
v3mt.__index=function(a,k)if k=="Magnitude"then return math.sqrt(a.X*a.X+a.Y*a.Y+a.Z*a.Z)end end
Vector3.zero=Vector3.new()
local CFrame={};local cfmethods={};local cfmt={__index=cfmethods}
local identity={1,0,0,0,1,0,0,0,1}
local function cf(p,r)return setmetatable({Position=p,r=r or table.clone(identity)},cfmt)end
function CFrame.new(x,y,z)if type(x)=="table"then return cf(x)end;return cf(Vector3.new(x,y,z))end
local function rotate(r,v)return Vector3.new(r[1]*v.X+r[2]*v.Y+r[3]*v.Z,r[4]*v.X+r[5]*v.Y+r[6]*v.Z,r[7]*v.X+r[8]*v.Y+r[9]*v.Z)end
function cfmethods:PointToWorldSpace(v)return self.Position+rotate(self.r,v)end
function cfmethods:Inverse()
    local r=self.r;local inverse={r[1],r[4],r[7],r[2],r[5],r[8],r[3],r[6],r[9]}
    return cf(rotate(inverse,self.Position*-1),inverse)
end
cfmt.__mul=function(a,b)
    local r={};for row=0,2 do for col=1,3 do
        r[row*3+col]=0;for k=1,3 do r[row*3+col]+=a.r[row*3+k]*b.r[(k-1)*3+col]end
    end end
    return cf(a:PointToWorldSpace(b.Position),r)
end
function cfmethods:ToObjectSpace(b)return self:Inverse()*b end
function CFrame.Angles(_,y,_z) -- Tests use a world yaw; no fake renderer is provided.
    assert(_==0 and _z==0,"mock supports yaw only")
    return cf(Vector3.zero,{math.cos(y),0,math.sin(y),0,1,0,-math.sin(y),0,math.cos(y)})
end
function CFrame.lookAt(p,target)local value=cf(p);value.target=target;return value end
CFrame.identity=CFrame.new()
function Color3.new(r,g,b)return {R=r,G=g,B=b}end
function Color3.fromRGB(r,g,b)return Color3.new(r/255,g/255,b/255)end
local inherited={
 Part={BasePart=true},MeshPart={BasePart=true},UnionOperation={BasePart=true},
 SpecialMesh={DataModelMesh=true},BlockMesh={DataModelMesh=true},CylinderMesh={DataModelMesh=true},
 Motor6D={JointInstance=true},Motor={JointInstance=true},Weld={JointInstance=true},ManualWeld={JointInstance=true},
 Texture={Decal=true},Bone={Attachment=true},Hat={Accessory=true},
 Frame={GuiObject=true},ScrollingFrame={GuiObject=true},ImageLabel={GuiObject=true},TextLabel={GuiObject=true},
 ViewportFrame={GuiObject=true},TextButton={GuiObject=true},TextBox={GuiObject=true},
}
function methods:IsA(class)return self.ClassName==class or inherited[self.ClassName] and inherited[self.ClassName][class] or false end
function methods:IsDescendantOf(parent)local p=self.Parent;while p do if p==parent then return true end;p=p.Parent end;return false end
function methods:FindFirstChildOfClass(class)for _,child in ipairs(self._children)do if child.ClassName==class then return child end end end
function methods:FindFirstChildWhichIsA(class,recursive)
 for _,v in ipairs(recursive and self:GetDescendants() or self:GetChildren())do if v:IsA(class)then return v end end
end
function methods:GetTags()return table.clone(self._tags or {})end
function methods:AddTag(tag)self._tags=self._tags or {};table.insert(self._tags,tag)end
function methods:RemoveTag(tag)local i=table.find(self._tags or {},tag);if i then table.remove(self._tags,i)end end
events.CharacterAdded=true;events.CharacterRemoving=true;events.DescendantAdded=true;events.DescendantRemoving=true;events.AncestryChanged=true
local baseNew=Instance.new
Instance.new=function(class)
 local v=baseNew(class);v.Archivable=true
 if v:IsA("BasePart")then v.CFrame=CFrame.identity;v.Size=Vector3.new(1,1,1);v.Transparency=0;v.LocalTransparencyModifier=0;v.Color=Color3.new(.2,.6,.9)end
 if v:IsA("JointInstance")then v.C0=CFrame.identity;v.C1=CFrame.identity;v.Transform=CFrame.identity end
 return v
end
local oldIndex=mt.__index;local oldNewIndex=mt.__newindex
local faultAssignments={} -- 用一次真实属性赋值异常检验双视图提交回滚，而非只检查条件分支。
mt.__index=function(self,k)
 if k=="Position"and methods.IsA(self,"BasePart")then return self.CFrame.Position end
 return oldIndex(self,k)
end
mt.__newindex=function(self,k,v)
 if faultAssignments[self]==k then faultAssignments[self]=nil;error("injected property assignment failure: "..k)end
 if k=="Parent"and self.Parent~=v then
    local subtree={self};for _,child in ipairs(self:GetDescendants())do table.insert(subtree,child)end
    local old=self.Parent
    while old do for _,child in ipairs(subtree)do old.DescendantRemoving:Fire(child)end;old=old.Parent end
    oldNewIndex(self,k,v)
    local parent=v;while parent do for _,child in ipairs(subtree)do parent.DescendantAdded:Fire(child)end;parent=parent.Parent end
    self.AncestryChanged:Fire(self,v)
 else oldNewIndex(self,k,v)end
end
function methods:Clone()
 if self.failClone then error("injected Clone failure")end
 if not self.Archivable then return nil end
 local remap={}
 local function copy(source)
    if not source.Archivable then return nil end
    local out=Instance.new(source.ClassName);remap[source]=out
    for k,v in pairs(source._data)do
        if k~="Parent"and not events[k]then out[k]=v end
    end
    for _,tag in ipairs(source:GetTags())do out:AddTag(tag)end
    for _,child in ipairs(source:GetChildren())do local clone=copy(child);if clone then clone.Parent=out end end
    return out
 end
 local result=copy(self)
 for _,out in pairs(remap)do for k,v in pairs(out._data)do if remap[v]then out[k]=remap[v]end end end
 return result
end
-- Controlled virtual time: timers and yielding account calls can be completed in any order.
local now=0;local os={clock=function()return now end}
local queued={}
task.delay=function(seconds,fn)
 local co=coroutine.create(fn);table.insert(queued,{at=now+seconds,co=co});return co
end
local function advance(seconds)
 local target=now+seconds;local safety=0
 while true do
    table.sort(queued,function(a,b)return a.at<b.at end)
    local item=queued[1];if not item or item.at>target then break end
    table.remove(queued,1);now=item.at
    if coroutine.status(item.co)~="dead"then local ok,err=coroutine.resume(item.co);assert(ok,err)end
    safety+=1;assert(safety<10000,"unbounded scheduler")
 end
 now=target
end
local function queuedCount()local n=0;for _,item in ipairs(queued)do if coroutine.status(item.co)~="dead"then n+=1 end end;return n end
