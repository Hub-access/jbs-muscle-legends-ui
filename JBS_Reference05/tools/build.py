"""Build Studio XML model + single-file LocalScript from the same module source."""
from pathlib import Path
import json,re,hashlib,xml.etree.ElementTree as ET
ROOT=Path(__file__).resolve().parents[1]
from sync_catalog import lua
manifest=json.loads((ROOT/'assets/manifest.json').read_text())
data='-- 图片裁片资料（由 assets/manifest.json 自动生成）；资源 ID 请在 Config.lua 填写。\nreturn '+lua(manifest['assets'])+'\n'
(ROOT/'src/AssetData.lua').write_text(data)
assets=ROOT/'src/Assets.lua'
source=assets.read_text().replace('Assets.Meta = -- INSERT_ASSET_META\n{}','Assets.Meta = require(script.Parent.AssetData)')
assets.write_text(source)
modules={p.stem:p.read_text() for p in sorted((ROOT/'src').glob('*.lua')) if not p.name.endswith('.client.lua')}
def bundle(bootstrap):
    parts=['-- 自动生成的单文件发布入口。请修改 src/ 内有中文注释的模块，再运行 tools/build.py。\nlocal factories,cache={},{}\nlocal function requireModule(name)\n if cache[name]~=nil then return cache[name] end\n assert(factories[name],name)\n local value=factories[name]();cache[name]=value;return value\nend\n']
    for name,body in modules.items():
        body=re.sub(r'require\(script.Parent.([A-Za-z0-9_]+)\)',lambda m:'requireModule("'+m[1]+'")',body)
        parts.append('factories["'+name+'"] = function()\n'+body+'\nend\n')
    parts.append(bootstrap)
    return ''.join(parts)
startup='local app=requireModule("Runtime").Mount()\nif app then app.Scope:Connect(script.Destroying,function() app.Destroy() end) end\n'
(ROOT/'JBS_Reference05.client.lua').write_text(bundle(startup))
(ROOT/'tests/modules.bundle.luau').write_text(bundle('return {Library=requireModule("Library"),Runtime=requireModule("Runtime"),Controller=requireModule("Controller"),Adapter=requireModule("BusinessAdapter"),Motion=requireModule("Motion"),Assets=requireModule("Assets"),AvatarSnapshot=requireModule("AvatarSnapshot"),AvatarFit=requireModule("AvatarFit"),AvatarRefresh=requireModule("AvatarRefresh"),HeroAvatar=requireModule("HeroAvatar")}\n'))
def item(parent,kind,name,source=None):
    el=ET.SubElement(parent,'Item',{'class':kind,'referent':'RBX'+hashlib.sha256((kind+name).encode()).hexdigest()[:18]})
    props=ET.SubElement(el,'Properties');ET.SubElement(props,'string',{'name':'Name'}).text=name
    if source is not None:ET.SubElement(props,'ProtectedString',{'name':'Source'}).text=source
    return el
root=ET.Element('roblox',{'version':'4'});ET.SubElement(root,'External').text='null';ET.SubElement(root,'External').text='nil'
folder=item(root,'Folder','JBS_Reference05')
for name,body in modules.items():item(folder,'ModuleScript',name,body)
item(folder,'LocalScript','Bootstrap',(ROOT/'src/Bootstrap.client.lua').read_text())
ET.ElementTree(root).write(ROOT/'JBS_Reference05.rbxmx',encoding='utf-8',xml_declaration=True)
place=ET.Element('roblox',{'version':'4'});ET.SubElement(place,'External').text='null';ET.SubElement(place,'External').text='nil'
starter=item(place,'StarterPlayer','StarterPlayer');scripts=item(starter,'StarterPlayerScripts','StarterPlayerScripts');scripts.append(folder)
for qa_name in ('NativeAvatarQA','NativeDualAvatarQA'):
    qa=item(scripts,'LocalScript',qa_name,(ROOT/f'tests/{qa_name}.client.lua').read_text())
    ET.SubElement(qa.find('Properties'),'bool',{'name':'Disabled'}).text='true'
workspace=item(place,'Workspace','Workspace')
# Only the standalone QA place gets a floor/spawn. The importable UI model stays UI-only.
# An empty Workspace makes spawned avatars fall and respawn during a 30-cycle avatar test.
def test_part(kind,name,size,position):
    part=item(workspace,kind,name);props=part.find('Properties')
    ET.SubElement(props,'bool',{'name':'Anchored'}).text='true'
    vec=ET.SubElement(props,'Vector3',{'name':'size'})
    for axis,value in zip('XYZ',size):ET.SubElement(vec,axis).text=str(value)
    cf=ET.SubElement(props,'CoordinateFrame',{'name':'CFrame'})
    for axis,value in zip('XYZ',position):ET.SubElement(cf,axis).text=str(value)
    for row in range(3):
        for col in range(3):ET.SubElement(cf,f'R{row}{col}').text='1' if row==col else '0'
    return props
test_part('Part','JBS_QA_Floor',(100,2,100),(0,-2,0))
spawn_props=test_part('SpawnLocation','JBS_QA_Spawn',(6,1,6),(0,0,0))
ET.SubElement(spawn_props,'bool',{'name':'Neutral'}).text='true'
ET.SubElement(spawn_props,'float',{'name':'Duration'}).text='0'
ET.ElementTree(place).write(ROOT/'JBS_Reference05.rbxlx',encoding='utf-8',xml_declaration=True)
# 可复用库入口：只有 return，不含 Runtime.Mount 或自动执行的 LocalScript。
package=ROOT.parent
library_source=bundle('return requireModule("Library")\n')
(package/'JBS_UI.lua').write_text(library_source)
library_model=ET.Element('roblox',{'version':'4'})
item(library_model,'ModuleScript','JBS_UI',library_source)
ET.ElementTree(library_model).write(package/'JBS_UI.rbxmx',encoding='utf-8',xml_declaration=True)
# 单独的 Studio 示例场景：导入模型不会自启动；只有打开此演示场景 Play 才运行示例。
demo=ET.Element('roblox',{'version':'4'})
storage=item(demo,'ReplicatedStorage','ReplicatedStorage')
item(storage,'ModuleScript','JBS_UI',library_source)
demo_starter=item(demo,'StarterPlayer','StarterPlayer')
demo_scripts=item(demo_starter,'StarterPlayerScripts','StarterPlayerScripts')
example=package/'examples/QuickStart.client.lua'
if example.exists():
    item(demo_scripts,'LocalScript','JBS_UI_Example',example.read_text())
    demo.append(workspace)
    ET.ElementTree(demo).write(package/'examples/JBS_UI_Demo.rbxlx',encoding='utf-8',xml_declaration=True)
print('Built native module model, local place, and single-file entry from identical sources.')
