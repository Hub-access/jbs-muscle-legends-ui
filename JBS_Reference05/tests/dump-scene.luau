-- OFFLINE ART-BOUND SCENE. local-source keys are only consumed by render_layout.py.
-- They are never assigned to production Config or a Roblox ContentId.
local app=Modules.Runtime.Mount()
app.Controller:SetPage("home")
app.Controller:SetReduced(true)
for _,binding in ipairs(app.Assets.subscribers)do
	binding.image.Visible=true;binding.image:SetAttribute("OfflineSourceKey",binding.key)
	app.Assets.status[binding.key]="已加载"
end
app.View:Refresh()
local function escape(s)return '"'..s:gsub('\\','\\\\'):gsub('"','\\"'):gsub('\n','\\n'):gsub('\r','\\r'):gsub('\t','\\t')..'"'end
local function json(v)
	if type(v)=="string"then return escape(v)end
	if type(v)=="number"or type(v)=="boolean"then return tostring(v)end
	if v==nil then return "null"end
	local entries={}
	if #v>0 then for _,value in ipairs(v)do table.insert(entries,json(value))end;return "["..table.concat(entries,",").."]"end
	for key,value in pairs(v)do table.insert(entries,escape(tostring(key))..":"..json(value))end
	return "{"..table.concat(entries,",").."}"
end
local properties={"Name","ClassName","Visible","Enabled","Size","Position","ZIndex","BackgroundTransparency","BackgroundColor3","Rotation","Text","TextSize","TextColor3","TextXAlignment","TextWrapped","Font","ImageRectOffset","ImageRectSize","ImageColor3","ScaleType","Scale","Color","CornerRadius","CellSize","CellPadding","FillDirectionMaxCells","LayoutOrder","Padding","FillDirection","ClipsDescendants","CanvasSize"}
local function export(node)
	local result={};for _,key in ipairs(properties)do local value=node[key];if value~=nil then result[key]=value end end
	result.sourceKey=node:GetAttribute("OfflineSourceKey");result.children={}
	for _,child in ipairs(node:GetChildren())do table.insert(result.children,export(child))end
	return result
end
print(json(export(app.Screen)))
app.Destroy()
