"""Library behavior checks with real Luau and an offline engine double, not Roblox."""
from pathlib import Path
import argparse, subprocess, json, xml.etree.ElementTree as ET
ROOT=Path(__file__).resolve().parents[1]
parser=argparse.ArgumentParser()
parser.add_argument('--luau',required=True)
parser.add_argument('--compiler',required=True)
args=parser.parse_args()
subprocess.run(['python3',str(ROOT/'tools/build.py')],check=True)
files=[ROOT.parent/'JBS_UI.lua']+list((ROOT.parent/'examples').glob('*.lua'))
for p in files:
    subprocess.run([args.compiler,str(p)],check=True,stdout=subprocess.DEVNULL)
source=(ROOT.parent/'JBS_UI.lua').read_text()
model=ET.parse(ROOT.parent/'JBS_UI.rbxmx').getroot()
items=list(model.iter('Item'))
assert len(items)==1 and items[0].get('class')=='ModuleScript'
assert items[0].find("Properties/ProtectedString[@name='Source']").text==source
demo=ET.parse(ROOT.parent/'examples/JBS_UI_Demo.rbxlx').getroot()
demo_module=next(x for x in demo.iter('Item') if x.get('class')=='ModuleScript')
assert demo_module.find("Properties/ProtectedString[@name='Source']").text==source
demo_script=next(x for x in demo.iter('Item') if x.get('class')=='LocalScript')
assert demo_script.find("Properties/ProtectedString[@name='Source']").text==(ROOT.parent/'examples/QuickStart.client.lua').read_text()
scratch=Path.cwd()/'work/JBS_Reference05';scratch.mkdir(parents=True,exist_ok=True)
# Execute the exported artifact independently as well: merely requiring it must allocate nothing.
inert=(ROOT/'tests/mock-engine.luau').read_text()+'\nlocal before=instanceCount();local count=activeConnections()\nlocal UI=(function()\n'+source+'\nend)()\nassert(type(UI.CreateWindow)=="function" and type(UI.CreateJBS)=="function")\nassert(instanceCount()==before and activeConnections()==count)\nprint("PASS exported library require is inert")\n'
inert_path=scratch/'library-inert.generated.luau';inert_path.write_text(inert)
first=subprocess.run([args.luau,str(inert_path)],text=True,capture_output=True)
assert first.returncode==0,first.stdout+first.stderr
parts=[(ROOT/'tests/mock-engine.luau').read_text(),(ROOT/'tests/avatar-engine.luau').read_text(),
       'local Modules=(function()\n'+(ROOT/'tests/modules.bundle.luau').read_text()+'\nend)()',
       (ROOT/'tests/library-stress.luau').read_text()]
path=scratch/'library.generated.luau';path.write_text('\n'.join(parts))
result=subprocess.run([args.luau,str(path)],text=True,capture_output=True)
log='Offline library engine double, NOT Roblox native testing.\n'+first.stdout+result.stdout+result.stderr
log=log.replace(str(Path.cwd()),'<LOCAL_PROJECT>')
(ROOT/'evidence/offline-library-tests.txt').write_text(log)
print(log)
if result.returncode:raise SystemExit(result.returncode)
report={'library_version':'1.0.0','library_offline_status':'passed','exported_module_require':'inert',
        'source_model_demo_equality':'passed','example_compile_files':len(files),
        'native_runtime':'not_verified','native_performance':'not_measured','resource_uploads':'pending'}
(ROOT/'evidence/library-verification.json').write_text(json.dumps(report,indent=2)+'\n')
