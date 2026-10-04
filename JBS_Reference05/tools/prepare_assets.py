"""Lossless reference crops. No AI regeneration or invented layered originals."""
from pathlib import Path
import json, hashlib
from PIL import Image, ImageDraw

ROOT = Path(__file__).resolve().parents[1]
src = Image.open(ROOT/'reference/JBS_reference_05.png').convert('RGBA')
out = ROOT/'assets'
crops = {
    'logo_jbs': (10, 8, 247, 158),
    'hero_banner': (252, 55, 1337, 435),
    'sidebar_art': (0, 629, 248, 874),
    'control_art': (1061, 738, 1330, 892),
}
manifest = {'reference_size': list(src.size), 'layered_original_available': False, 'assets': {}}
for key, box in crops.items():
    im = src.crop(box)
    im.save(out/f'{key}.png')
    manifest['assets'][key] = {'file':f'assets/{key}.png','size':list(im.size), 'source_rect':list(box),'runtime_id':'','status':'pending_upload_and_native_verification','scale':'Fit'}

# Only narrow decorative borders are retained. ALL source controls/text are removed.
# Each patch is rendered independently: corners stay fixed; edges stretch in one axis.
frame = Image.new('RGBA',(1024,512))
frames = {}
for key, box, target, border in [
    ('panel',(1345,75,1671,417),(0,0),24),
    ('card',(621,490,971,602),(352,0),13),
    ('primary',(288,781,660,876),(352,128),13),
]:
    im = src.crop(box); w,h = im.size
    rim=min(border,13)
    ImageDraw.Draw(im).rectangle((rim,rim,w-rim-1,h-rim-1),fill=(0,0,0,0))
    frame.alpha_composite(im,target)
    frames[key]={'rect':[target[0],target[1],w,h],'border':border,'mode':'eight_fixed_corner_and_stretched_edge_patches','center':'transparent'}
frame.alpha_composite(src.crop((1245,0,1490,60)),(352,256))
frame.save(out/'frame_atlas.png')
manifest['assets']['frame_atlas']={'file':'assets/frame_atlas.png','size':list(frame.size),'runtime_id':'','status':'pending_upload_and_native_verification','patches':frames,'decor':{'top_slogan':[352,256,245,60]}}

# Exact supplied icon artwork. Dark icon medallions are deliberate, not emoji.
icons = {
    'home':(27,186,79,232),'teleport':(27,264,78,309),
    'pet':(26,336,82,383),'boss':(26,419,81,470),
    'rebirth':(26,499,81,550),'settings':(27,574,81,624),
    'train':(638,507,712,582),'spin':(1003,506,1077,584),
    'pin':(282,619,357,694),'game':(1371,158,1425,216),
    'version':(1370,336,1422,388),'crown':(1371,750,1424,797),
    'gem':(1370,816,1423,858),'bolt':(277,737,311,780),
    'status':(1362,88,1410,134),'strength':(270,447,308,485),
    'play':(367,797,429,859),'stop':(763,796,831,864),
    'arrow':(566,645,586,671),
}
atlas=Image.new('RGBA',(512,640)); rects={}
for index,(name,box) in enumerate(icons.items()):
    im=src.crop(box); im.thumbnail((92,92),Image.Resampling.LANCZOS)
    x=(index%4)*128+(128-im.width)//2; y=(index//4)*128+(128-im.height)//2
    # Extract luminous icon silhouettes from their dark/pink source backplates.
    # Green channel separates pale icon ink from saturated magenta lighting.
    alpha=im.getchannel('R' if name=='stop' else 'G').point(lambda value: max(0,min(255,(value-100)*3)))
    ink=Image.new('RGBA',im.size,(255,255,255,0)); ink.putalpha(alpha)
    atlas.alpha_composite(ink,(x,y)); rects[name]=[x,y,im.width,im.height]
atlas.save(out/'icon_atlas.png')
manifest['assets']['icon_atlas']={'file':'assets/icon_atlas.png','size':list(atlas.size),'runtime_id':'','status':'pending_upload_and_native_verification','rects':rects,'note':'Original reference crops with pale-ink alpha extraction; no upsampling. Extraction is editable in prepare_assets.py.'}
for item in manifest['assets'].values():
    item['sha256']=hashlib.sha256((ROOT/item['file']).read_bytes()).hexdigest()
(out/'manifest.json').write_text(json.dumps(manifest,ensure_ascii=False,indent=2)+'\n')
(out/'source/crop-recipe.json').write_text(json.dumps({'source':'../../reference/JBS_reference_05.png','art':crops,'icons':icons,'frames':frames},ensure_ascii=False,indent=2)+'\n')

# Source-contact sheet, expressly NOT a runtime screenshot.
sheet=Image.new('RGB',(1672,1100),'#0B0710');d=ImageDraw.Draw(sheet)
d.text((24,12),'SOURCE ASSET CONTACT SHEET - NOT ROBLOX RENDER',fill='#FF6ADE')
sheet.paste(src.convert('RGB').resize((836,470)),(12,45))
sheet.paste(Image.open(out/'hero_banner.png').convert('RGB'),(250,540))
sheet.paste(Image.open(out/'logo_jbs.png').convert('RGB'),(12,540))
sheet.paste(Image.open(out/'sidebar_art.png').convert('RGB'),(12,700))
sheet.paste(Image.open(out/'control_art.png').convert('RGB'),(1350,540))
sheet.paste(frame,(864,20),frame)
sheet.paste(atlas,(1070,45),atlas)
sheet.save(ROOT/'evidence/source-assets-contact-sheet.png')
print('Prepared six lossless assets; runtime upload status remains pending.')
