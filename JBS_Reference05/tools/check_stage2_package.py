"""Check delivery consistency only. This is not Roblox render/performance validation."""
from pathlib import Path
import hashlib, json, struct, xml.etree.ElementTree as ET
ROOT=Path(__file__).resolve().parents[1]
expected={p.stem:p.read_text() for p in (ROOT/'src').glob('*.lua') if not p.name.endswith('.client.lua')}
checked=[]
for filename in ['JBS_Reference05.rbxmx','JBS_Reference05.rbxlx']:
    xml=ET.parse(ROOT/filename).getroot()
    found={el.find("Properties/string[@name='Name']").text:el.find("Properties/ProtectedString[@name='Source']").text for el in xml.iter('Item') if el.get('class')=='ModuleScript'}
    assert found==expected, f'{filename}: embedded module differs from src'
    checked.append(filename)
place=ET.parse(ROOT/'JBS_Reference05.rbxlx').getroot()
qa_names=[]
for el in place.iter('Item'):
    if el.get('class')!='LocalScript': continue
    name=el.find("Properties/string[@name='Name']").text
    if name not in ('NativeAvatarQA','NativeDualAvatarQA'): continue
    assert el.find("Properties/bool[@name='Disabled']").text=='true', name+' must be opt-in'
    assert el.find("Properties/ProtectedString[@name='Source']").text==(ROOT/f'tests/{name}.client.lua').read_text()
    qa_names.append(name)
assert len(qa_names)==2
model=ET.parse(ROOT/'JBS_Reference05.rbxmx').getroot()
assert not any(el.get('class')=='Workspace' for el in model.iter('Item'))
assert any(el.get('class')=='SpawnLocation' for el in place.iter('Item'))
assets=json.loads((ROOT/'assets/manifest.json').read_text())['assets']
for key,meta in assets.items():
    data=(ROOT/meta['file']).read_bytes()
    assert hashlib.sha256(data).hexdigest()==meta['sha256'], key+' hash'
    assert list(struct.unpack('>II',data[16:24]))==meta['size'], key+' pixels'
assert assets['hero_clean']['runtime_id']==assets['sidebar_clean']['runtime_id']==''
result={'method':'XML/source equality, default-disabled QA, PNG hashes/sizes; not Roblox execution',
        'generated_modules_match_source':True,'modules_per_entry':len(expected),'entries_checked':checked,
        'qa_source_matches_and_disabled':sorted(qa_names),'qa_floor_and_spawn_place_only':True,
        'asset_count':len(assets),'asset_hashes_and_dimensions_match':True,'avatar_runtime_ids':'empty / pending upload',
        'native_render':'not_verified'}
(ROOT/'evidence/stage2-package-checks.json').write_text(json.dumps(result,ensure_ascii=False,indent=2)+'\n')
print(json.dumps(result,ensure_ascii=False))
