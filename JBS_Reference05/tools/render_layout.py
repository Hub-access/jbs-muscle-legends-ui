"""Offline geometry illustration from the actual Luau instance tree; NOT Roblox rendering."""
from pathlib import Path
from PIL import Image,ImageDraw,ImageFont,ImageChops
import subprocess,json,argparse,math
ROOT=Path(__file__).resolve().parents[1]
parser=argparse.ArgumentParser();parser.add_argument('--luau',required=True);args=parser.parse_args()
script=(ROOT/'tests/mock-engine.luau').read_text()+'\nlocal Modules=(function()\n'+(ROOT/'tests/modules.bundle.luau').read_text()+'\nend)()\n'+(ROOT/'tests/dump-scene.luau').read_text()
scratch=Path.cwd()/'work/JBS_Reference05';scratch.mkdir(parents=True,exist_ok=True)
target=scratch/'scene.generated.luau';target.write_text(script)
run=subprocess.run([args.luau,str(target)],capture_output=True,text=True,check=True)
scene=json.loads(run.stdout);(ROOT/'evidence/offline-scene.json').write_text(json.dumps(scene,ensure_ascii=False))
manifest=json.loads((ROOT/'assets/manifest.json').read_text())['assets']
art={key:Image.open(ROOT/item['file']).convert('RGBA') for key,item in manifest.items()}
font_path='/System/Library/Fonts/PingFang.ttc'
if not Path(font_path).exists():
    matches=list(Path('/System/Library/AssetsV2/com_apple_MobileAsset_Font8').glob('*/AssetData/PingFang.ttc'))
    font_path=str(matches[0]) if matches else '/System/Library/Fonts/Hiragino Sans GB.ttc'
def font(size,bold=False):return ImageFont.truetype(font_path,max(10,round(size)),index=0)
def color(value,alpha=255):
    value=value or {'R':0,'G':0,'B':0}
    return tuple(round(value[k]*255) for k in ['R','G','B'])+(alpha,)
def unit(value,parent):return value.get('Scale',0)*parent+value.get('Offset',0)
def dims(value,parent):return (unit(value['X'],parent[0]),unit(value['Y'],parent[1]))
def render(width,height):
    im=Image.new('RGBA',(width,height),(7,4,12,255));scale=max(.75,min(1.5,(width-16)/1672,(height-16)/941))
    root_pos=(max(8,(width-1672*scale)/2),max(8,(height-941*scale)/2))
    def node(n,origin,parent_size,factor,override=None):
        if not n.get('Visible',True):return
        kind=n['ClassName']
        if kind not in ('Frame','TextLabel','TextButton','TextBox','ImageLabel','ScrollingFrame','ScreenGui'):return
        if kind=='ScreenGui': pos=(0,0);size=(width,height)
        else:
            pos=override if override is not None else dims(n['Position'],parent_size)
            size=dims(n['Size'],parent_size)
        if n['Name']=='JBS_Reference05':pos=root_pos;factor=scale;origin=(0,0)
        x=round(origin[0]+pos[0]*(1 if n['Name']=='JBS_Reference05' else factor));y=round(origin[1]+pos[1]*(1 if n['Name']=='JBS_Reference05' else factor))
        w=max(1,round(size[0]*factor));h=max(1,round(size[1]*factor))
        layer=None
        if n.get('BackgroundTransparency',0)<1 and kind!='ScreenGui':
            alpha=round(255*(1-n.get('BackgroundTransparency',0)));layer=Image.new('RGBA',(w,h),color(n.get('BackgroundColor3'),alpha))
            gradient=next((c for c in n['children']if c['ClassName']=='UIGradient'),None)
            if gradient:
                seq=gradient['Color'];pixels=ImageDraw.Draw(layer)
                vertical=gradient.get('Rotation',0)==90;length=h if vertical else w
                for i in range(length):
                    t=i/max(1,length-1);start,end=seq[0],seq[-1]
                    for a,b in zip(seq,seq[1:]):
                        if a['Time']<=t<=b['Time']:start,end=a,b;break
                    f=(t-start['Time'])/max(.0001,end['Time']-start['Time'])
                    rgb=tuple(round((start['Value'][k]*(1-f)+end['Value'][k]*f)*255)for k in ['R','G','B'])+(alpha,)
                    pixels.line((0,i,w,i)if vertical else(i,0,i,h),fill=rgb)
            corner=next((c for c in n['children']if c['ClassName']=='UICorner'),None)
            if corner:
                mask=Image.new('L',(w,h));ImageDraw.Draw(mask).rounded_rectangle((0,0,w,h),radius=min(w,h)/2,fill=255);layer.putalpha(mask)
            if n.get('Rotation'):
                rotated=layer.rotate(-n['Rotation'],resample=Image.Resampling.BICUBIC,expand=True)
                im.alpha_composite(rotated,(x-(rotated.width-w)//2,y-(rotated.height-h)//2));layer=None
            if layer is not None:im.alpha_composite(layer,(x,y))
        if kind=='ImageLabel' and n.get('sourceKey'):
            crop=art[n['sourceKey']].copy()
            if n.get('ImageRectSize'):
                off=n['ImageRectOffset'];s=n['ImageRectSize'];crop=crop.crop((off['X'],off['Y'],off['X']+s['X'],off['Y']+s['Y']))
            if n.get('ImageColor3'):
                tint=Image.new('RGBA',crop.size,color(n['ImageColor3']));crop=ImageChops.multiply(crop,tint)
            if n.get('ScaleType')=='ScaleType.Fit':
                crop.thumbnail((w,h),Image.Resampling.LANCZOS)
                # PIL thumbnail never upsamples; native Fit does. Explicit fit here.
                ratio=min(w/crop.width,h/crop.height);crop=crop.resize((round(crop.width*ratio),round(crop.height*ratio)),Image.Resampling.LANCZOS)
                im.alpha_composite(crop,(x+(w-crop.width)//2,y+(h-crop.height)//2))
            else:im.alpha_composite(crop.resize((w,h),Image.Resampling.LANCZOS),(x,y))
        if kind in ('TextLabel','TextButton','TextBox') and n.get('Text'):
            face=font(n.get('TextSize',20)*factor,'Bold'in n.get('Font',''));text=n['Text'];draw=ImageDraw.Draw(im)
            lines=text.split('\n')
            if n.get('TextWrapped'):
                wrapped=[]
                for line in lines:
                    row=''
                    for c in line:
                        if draw.textlength(row+c,font=face)>w and row:wrapped.append(row);row=c
                        else:row+=c
                    wrapped.append(row)
                lines=wrapped
            line_h=round(n.get('TextSize',20)*factor*1.2);ty=y+(h-line_h*len(lines))/2
            for text in lines:
                while draw.textlength(text,font=face)>w and len(text)>1:text=text[:-2]+'…'
                tx=x+(w-draw.textlength(text,font=face))/2 if n.get('TextXAlignment')=='TextXAlignment.Center' else x
                draw.text((tx,ty),text,font=face,fill=color(n.get('TextColor3')),anchor='lt');ty+=line_h
        children=n['children'];layout=next((c for c in children if c['ClassName']in('UIListLayout','UIGridLayout')),None)
        positions={}
        if layout:
            ordered=sorted([c for c in children if c['ClassName']=='Frame'],key=lambda c:c.get('LayoutOrder',0))
            for i,c in enumerate(ordered):
                if layout['ClassName']=='UIGridLayout':
                    cell=dims(layout['CellSize'],size);gap=dims(layout['CellPadding'],size);cols=layout['FillDirectionMaxCells'];positions[id(c)]=((i%cols)*(cell[0]+gap[0]),(i//cols)*(cell[1]+gap[1]))
                else:positions[id(c)]=(0,i*(dims(c['Size'],size)[1]+layout['Padding']['Offset']))
        for child in sorted(children,key=lambda c:c.get('ZIndex',1)):
            node(child,(x,y),size,factor,positions.get(id(child)))
    node(scene,(0,0),(width,height),1)
    # Always label the evidence, even when included in a side-by-side board.
    draw=ImageDraw.Draw(im);draw.rectangle((0,height-28,width,height),fill=(7,4,12,255))
    draw.text((10,height-24),'OFFLINE LAYOUT / 本地素材排版推演 · 非 Roblox 截图 · 原生资源未接入',font=font(17),fill='#FF6ADE')
    return im.convert('RGB')
for w,h in [(1280,720),(1672,941),(1920,1080),(2560,1440)]:render(w,h).save(ROOT/f'evidence/offline-layout-{w}x{h}.png')
reference=Image.open(ROOT/'reference/JBS_reference_05.png').convert('RGB');layout=Image.open(ROOT/'evidence/offline-layout-1672x941.png')
board=Image.new('RGB',(1672,1962),'#0B0710');d=ImageDraw.Draw(board)
d.text((20,8),'REFERENCE / 用户提供的图五',font=font(22),fill='#FF6ADE');board.paste(reference,(0,40))
d.text((20,989),'OFFLINE ONLY / 实际 Luau 控件树 + 本地素材推演，不代表原生渲染已通过',font=font(22),fill='#FF6ADE');board.paste(layout,(0,1021))
board.save(ROOT/'evidence/reference-vs-offline-layout.png')
print('Saved explicitly labelled offline geometry evidence at 4 viewport sizes.')
