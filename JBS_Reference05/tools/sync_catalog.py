"""把唯一的旧版控件清单同步到 Luau 和浏览器；此脚本不运行旧游戏代码。"""
from pathlib import Path
import json
ROOT = Path(__file__).resolve().parents[1]

def lua(value, level=0):
    """保留中文并输出多行表，便于在 VS Code 中阅读。"""
    if isinstance(value, (dict, list)):
        items = value.items() if isinstance(value, dict) else enumerate(value)
        rows = []
        for key, item in items:
            prefix = '[' + json.dumps(key, ensure_ascii=False) + '] = ' if isinstance(value, dict) else ''
            rows.append('    ' * (level + 1) + prefix + lua(item, level + 1) + ',')
        return '{\n' + '\n'.join(rows) + '\n' + '    ' * level + '}'
    if isinstance(value, bool): return 'true' if value else 'false'
    if value is None: return 'nil'
    return json.dumps(value, ensure_ascii=False)

if __name__ == '__main__':
    catalog = json.loads((ROOT / 'catalog/PreviousUI.json').read_text())
    header = '-- 旧版 UI 名称与选项清单（自动生成，中文未改名）。\n-- 修改 catalog/PreviousUI.json，再运行 tools/sync_catalog.py。\n-- 坐标只作为原版资料保存；本模块不会移动角色、购买宠物或启动任务。\n'
    (ROOT / 'src/LegacyCatalog.lua').write_text(header + 'local catalog = ' + lua(catalog) + '\n\n-- 从唯一控件清单建立名称索引，让所有重复入口共用文案。\ncatalog.labels = {}\nfor _, control in ipairs(catalog.controls) do catalog.labels[control.id] = control.label end\nfor _, feature in ipairs(catalog.features) do feature.title = catalog.labels[feature.id] end\nreturn catalog\n')
    browser = ROOT.parent / 'JBS_DynamicPreview/src/catalog.js'
    if browser.parent.exists():
        browser.write_text('// 与原生 Luau 共用的旧版控件清单。\n// 修改 ../JBS_Reference05/catalog/PreviousUI.json 后运行其 tools/sync_catalog.py。\n// 这些名称来源于旧代码；浏览器只展示，不执行 Roblox 业务。\nexport const catalog = ' + json.dumps(catalog, ensure_ascii=False, indent=2) + ';\n\n// 所有重复入口从控件声明取同一个中文名字。\nexport const labels = Object.fromEntries(catalog.controls.map(control => [control.id, control.label]));\nfor (const feature of catalog.features) feature.title = labels[feature.id];\n')
    print('Synced native and browser catalogs.')
