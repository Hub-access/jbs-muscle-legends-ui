-- Offline test double. Does not simulate Roblox rendering/network/server acceptance.
local connections,instances={},{}
local function signal()
	local list={};local s={}
	function s:Connect(fn)
		local c={Connected=true,fn=fn,_connection=true};function c:Disconnect() self.Connected=false end
		table.insert(list,c);table.insert(connections,c);return c
	end
	function s:Fire(...)
		for _,c in ipairs(table.clone(list)) do if c.Connected then c.fn(...) end end
	end
	return s
end
local originalTypeof=typeof
local function typeof(v) if type(v)=="table" and v._connection then return "RBXScriptConnection" end;return originalTypeof(v) end
local Enum=setmetatable({},{__index=function(t,k)
	local e=setmetatable({},{__index=function(t2,k2) local v=k.."."..k2;rawset(t2,k2,v);return v end});rawset(t,k,e);return e
end})
local Vector2={};local vectorMT={}
function Vector2.new(x,y) return setmetatable({X=x or 0,Y=y or 0},vectorMT) end
vectorMT.__sub=function(a,b)return Vector2.new(a.X-b.X,a.Y-b.Y)end
vectorMT.__add=function(a,b)return Vector2.new(a.X+b.X,a.Y+b.Y)end
Vector2.zero=Vector2.new(0,0)
local UDim={new=function(s,o)return {Scale=s,Offset=o}end}
local UDim2={new=function(xs,xo,ys,yo)return {X=UDim.new(xs,xo),Y=UDim.new(ys,yo)}end}
function UDim2.fromOffset(x,y)return UDim2.new(0,x,0,y)end
function UDim2.fromScale(x,y)return UDim2.new(x,0,y,0)end
local Color3={}
function Color3.fromHex(s)return {R=tonumber(s:sub(1,2),16)/255,G=tonumber(s:sub(3,4),16)/255,B=tonumber(s:sub(5,6),16)/255}end
local ColorSequence={new=function(a,b) return b and {{Time=0,Value=a},{Time=1,Value=b}} or a end}
local ColorSequenceKeypoint={new=function(t,v)return {Time=t,Value=v}end}
local TweenInfo={new=function(...)return {...}end}
local events={FocusLost=true,Activated=true,MouseEnter=true,MouseLeave=true,InputBegan=true,InputChanged=true,InputEnded=true,SelectionGained=true,SelectionLost=true,Destroying=true,Event=true}
local methods={};local mt={}
mt.__index=function(self,k)
	if methods[k] then return methods[k] end
	local d=rawget(self,"_data");if d[k]~=nil then return d[k] end
	if events[k] then d[k]=signal();return d[k] end
	if k=="AbsoluteSize" then return Vector2.new(1920,1080) end
	if k=="AbsolutePosition" then return Vector2.new(0,0) end
	for _,c in ipairs(self._children) do if c.Name==k then return c end end
end
mt.__newindex=function(self,k,v)
	local d=rawget(self,"_data")
	if k=="Parent" then
		if d.Parent then local ix=table.find(d.Parent._children,self);if ix then table.remove(d.Parent._children,ix) end end
		if v then table.insert(v._children,self) end
	end
	local old=d[k];d[k]=v
	if old~=v and self._signals[k] then self._signals[k]:Fire() end
end
local Instance={}
function Instance.new(class)
	local v=setmetatable({_data={ClassName=class,Name=class,Visible=true,Enabled=true,Text="",BackgroundTransparency=0,BorderSizePixel=1,Size=UDim2.fromOffset(100,100),Position=UDim2.fromOffset(0,0),ZIndex=1},_children={},_signals={},_attributes={}},mt)
	table.insert(instances,v);return v
end
function methods:IsA(class)return self.ClassName==class end
function methods:GetChildren()return table.clone(self._children)end
function methods:GetDescendants()
	local result={};for _,c in ipairs(self._children)do table.insert(result,c);for _,v in ipairs(c:GetDescendants())do table.insert(result,v)end end;return result
end
function methods:FindFirstChild(name,recursive)
	for _,c in ipairs(self._children)do if c.Name==name then return c end end
	if recursive then for _,c in ipairs(self._children)do local result=c:FindFirstChild(name,true);if result then return result end end end
end
function methods:WaitForChild(name)return self:FindFirstChild(name)end
function methods:GetPropertyChangedSignal(k) if not self._signals[k]then self._signals[k]=signal()end;return self._signals[k]end
function methods:SetAttribute(k,v)self._attributes[k]=v end
function methods:GetAttribute(k)return self._attributes[k]end
function methods:Invoke(...)return self.OnInvoke(...)end
function methods:Destroy()
	if self._destroyed then return end;self._destroyed=true;self.Destroying:Fire()
	for _,c in ipairs(self:GetChildren())do c:Destroy()end
	self.Parent=nil
end
local task={};local scheduled={}
function task.spawn(fn,...)
	local co=coroutine.create(fn);local ok,err=coroutine.resume(co,...);assert(ok,err);table.insert(scheduled,co);return co
end
function task.wait()coroutine.yield()end
function task.cancel(co)coroutine.close(co)end
local pendingTweens={};local autoTween=true
local TweenService={}
function TweenService:Create(object,info,properties)
	local t={Completed=signal(),object=object,properties=properties}
	function t:Play()table.insert(pendingTweens,self);if autoTween then self:Finish()end end
	function t:Finish()for k,v in pairs(self.properties)do self.object[k]=v end;self.Completed:Fire(Enum.PlaybackState.Completed)end
	function t:Cancel()self.cancelled=true;self.Completed:Fire(Enum.PlaybackState.Cancelled)end
	function t:Destroy()self.destroyed=true end
	return t
end
local player=Instance.new("Player");player.Name="OfflineTest";player.DisplayName="离线测试用户"
local playerGui=Instance.new("PlayerGui");playerGui.Name="PlayerGui";playerGui.Parent=player
local RunService={IsStudio=function()return true end,Heartbeat=signal(),RenderStepped=signal()}
local UserInputService={InputBegan=signal(),InputChanged=signal(),InputEnded=signal(),GetFocusedTextBox=function()return nil end}
local GuiService={SelectedObject=nil}
local encodedValues={}
local HttpService={JSONEncode=function(_,v)local id="mock-state-"..tostring(#encodedValues+1);table.insert(encodedValues,v);return id end,
	JSONDecode=function(_,v)return encodedValues[tonumber(v:match("%d+$"))]end}
local contentFails=false
local ContentProvider={PreloadAsync=function(_,ids,fn)for _,id in ipairs(ids)do fn(id,contentFails and Enum.AssetFetchStatus.Failure or Enum.AssetFetchStatus.Success)end end}
local services={Players={LocalPlayer=player,GetPlayers=function() return {player} end},RunService=RunService,UserInputService=UserInputService,GuiService=GuiService,HttpService=HttpService,TweenService=TweenService,ContentProvider=ContentProvider}
local game={PlaceId=0,GetService=function(_,id)assert(services[id],id);return services[id]end}
local function warn(...)print("WARNING",...)end
local function activeConnections()local count=0;for _,c in ipairs(connections)do if c.Connected then count+=1 end end;return count end
local function instanceCount()local count=0;for _,v in ipairs(instances)do if not v._destroyed then count+=1 end end;return count end
local function flushTweens()
	for _,t in ipairs(pendingTweens)do if not t.cancelled and not t.destroyed then t:Finish()end end
	table.clear(pendingTweens)
end
