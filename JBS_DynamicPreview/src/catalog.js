// 与原生 Luau 共用的旧版控件清单。
// 修改 ../JBS_Reference05/catalog/PreviousUI.json 后运行其 tools/sync_catalog.py。
// 这些名称来源于旧代码；浏览器只展示，不执行 Roblox 业务。
export const catalog = {
  "source": {
    "path": "original-source-not-distributed",
    "sha256": "cbbbdb2ace19bf70cb90641a713364a95961ef6ace9af4be78832d060f9793d7",
    "description": "上一版 JBS 粉紫暗铬 UI 的真实声明；只读取名称和选项，不执行业务代码",
    "note": "原始来源不随本仓库分发；保留哈希与行号用于追溯，当前功能名称已整理在此文件。"
  },
  "pages": [
    [
      "home",
      "主要",
      "home"
    ],
    [
      "teleport",
      "传送",
      "teleport"
    ],
    [
      "pets",
      "宠物",
      "pet"
    ],
    [
      "boss",
      "Boss",
      "boss"
    ],
    [
      "rebirth",
      "换包重生",
      "rebirth"
    ],
    [
      "settings",
      "设置",
      "settings"
    ]
  ],
  "controls": [
    {
      "id": "targetRebirths",
      "page": "home",
      "kind": "Input",
      "label": "目标次数",
      "sourceLine": 779,
      "placeholder": "重生目标，0为无限"
    },
    {
      "id": "rebirth",
      "page": "home",
      "kind": "Toggle",
      "label": "自动重生",
      "sourceLine": 789
    },
    {
      "id": "train",
      "page": "home",
      "kind": "Toggle",
      "label": "自动锻炼",
      "sourceLine": 806
    },
    {
      "id": "spin",
      "page": "home",
      "kind": "Toggle",
      "label": "自动轮盘",
      "sourceLine": 829
    },
    {
      "id": "petChoice",
      "page": "pets",
      "kind": "Dropdown",
      "label": "选择宠物/光环",
      "sourceLine": 887
    },
    {
      "id": "refreshPets",
      "page": "pets",
      "kind": "Button",
      "label": "刷新宠物列表",
      "sourceLine": 896
    },
    {
      "id": "buyPet",
      "page": "pets",
      "kind": "Button",
      "label": "购买一次",
      "sourceLine": 905
    },
    {
      "id": "petbuy",
      "page": "pets",
      "kind": "Toggle",
      "label": "自动购买",
      "sourceLine": 918
    },
    {
      "id": "boss",
      "page": "boss",
      "kind": "Toggle",
      "label": "自动打Boss",
      "sourceLine": 939
    },
    {
      "id": "packrebirth",
      "page": "rebirth",
      "kind": "Toggle",
      "label": "换包重生",
      "sourceLine": 976
    },
    {
      "id": "fasttrain",
      "page": "rebirth",
      "kind": "Toggle",
      "label": "快速锻炼",
      "sourceLine": 999
    },
    {
      "id": "eategg",
      "page": "rebirth",
      "kind": "Toggle",
      "label": "自动吃蛋",
      "sourceLine": 1025
    },
    {
      "id": "eggTarget",
      "page": "rebirth",
      "kind": "Dropdown",
      "label": "送蛋目标",
      "sourceLine": 1047
    },
    {
      "id": "giftAmount",
      "page": "rebirth",
      "kind": "Input",
      "label": "送蛋数量",
      "sourceLine": 1056,
      "placeholder": "0为全部"
    },
    {
      "id": "giftEggs",
      "page": "rebirth",
      "kind": "Button",
      "label": "送蛋",
      "sourceLine": 1066
    },
    {
      "id": "大厅",
      "page": "teleport",
      "kind": "Button",
      "label": "大厅",
      "sourceLine": 846
    },
    {
      "id": "小岛",
      "page": "teleport",
      "kind": "Button",
      "label": "小岛",
      "sourceLine": 847
    },
    {
      "id": "冰霜健身房",
      "page": "teleport",
      "kind": "Button",
      "label": "冰霜健身房",
      "sourceLine": 848
    },
    {
      "id": "神话健身房",
      "page": "teleport",
      "kind": "Button",
      "label": "神话健身房",
      "sourceLine": 849
    },
    {
      "id": "永恒健身房",
      "page": "teleport",
      "kind": "Button",
      "label": "永恒健身房",
      "sourceLine": 850
    },
    {
      "id": "传奇健身房",
      "page": "teleport",
      "kind": "Button",
      "label": "传奇健身房",
      "sourceLine": 851
    },
    {
      "id": "肌肉之王健身房",
      "page": "teleport",
      "kind": "Button",
      "label": "肌肉之王健身房",
      "sourceLine": 852
    },
    {
      "id": "丛林健身房",
      "page": "teleport",
      "kind": "Button",
      "label": "丛林健身房",
      "sourceLine": 853
    },
    {
      "id": "工业健身房",
      "page": "teleport",
      "kind": "Button",
      "label": "工业健身房",
      "sourceLine": 854
    },
    {
      "id": "超载健身房",
      "page": "teleport",
      "kind": "Button",
      "label": "超载健身房",
      "sourceLine": 855
    },
    {
      "id": "无转盘岛",
      "page": "teleport",
      "kind": "Button",
      "label": "无转盘岛",
      "sourceLine": 856
    },
    {
      "id": "熔岩争斗",
      "page": "teleport",
      "kind": "Button",
      "label": "熔岩争斗",
      "sourceLine": 857
    },
    {
      "id": "沙漠争斗",
      "page": "teleport",
      "kind": "Button",
      "label": "沙漠争斗",
      "sourceLine": 858
    },
    {
      "id": "海滩争斗",
      "page": "teleport",
      "kind": "Button",
      "label": "海滩争斗",
      "sourceLine": 859
    }
  ],
  "features": [
    {
      "id": "rebirth",
      "title": "自动重生",
      "description": "完成重生流程",
      "english": "AUTO REBIRTH",
      "icon": "rebirth"
    },
    {
      "id": "train",
      "title": "自动锻炼",
      "description": "训练提升力量",
      "english": "AUTO TRAIN",
      "icon": "train"
    },
    {
      "id": "spin",
      "title": "自动轮盘",
      "description": "旋转幸运轮盘",
      "english": "AUTO SPIN",
      "icon": "spin"
    },
    {
      "id": "petbuy",
      "title": "自动购买",
      "description": "购买所选宠物/光环",
      "english": "AUTO BUY",
      "icon": "pet"
    },
    {
      "id": "boss",
      "title": "自动打Boss",
      "description": "自动寻找 Boss",
      "english": "AUTO BOSS",
      "icon": "boss"
    },
    {
      "id": "packrebirth",
      "title": "换包重生",
      "description": "换包与重生",
      "english": "PACK REBIRTH",
      "icon": "rebirth"
    },
    {
      "id": "fasttrain",
      "title": "快速锻炼",
      "description": "快速训练",
      "english": "FAST TRAIN",
      "icon": "strength"
    },
    {
      "id": "eategg",
      "title": "自动吃蛋",
      "description": "使用蛋白蛋",
      "english": "AUTO EAT",
      "icon": "bolt"
    }
  ],
  "teleports": [
    {
      "id": "大厅",
      "label": "大厅",
      "position": [
        -0.75,
        90.61,
        242.78
      ],
      "sourceLine": 846
    },
    {
      "id": "小岛",
      "label": "小岛",
      "position": [
        -32.14,
        8.51,
        1904.41
      ],
      "sourceLine": 847
    },
    {
      "id": "冰霜健身房",
      "label": "冰霜健身房",
      "position": [
        -2623.41,
        6.99,
        -409.34
      ],
      "sourceLine": 848
    },
    {
      "id": "神话健身房",
      "label": "神话健身房",
      "position": [
        2250.39,
        6.99,
        1072.77
      ],
      "sourceLine": 849
    },
    {
      "id": "永恒健身房",
      "label": "永恒健身房",
      "position": [
        -6758.39,
        6.99,
        -1284.45
      ],
      "sourceLine": 850
    },
    {
      "id": "传奇健身房",
      "label": "传奇健身房",
      "position": [
        4603.4,
        990.99,
        -3897.44
      ],
      "sourceLine": 851
    },
    {
      "id": "肌肉之王健身房",
      "label": "肌肉之王健身房",
      "position": [
        -8625.4,
        16.99,
        -5730.41
      ],
      "sourceLine": 852
    },
    {
      "id": "丛林健身房",
      "label": "丛林健身房",
      "position": [
        -8685.01,
        5.99,
        2392.06
      ],
      "sourceLine": 853
    },
    {
      "id": "工业健身房",
      "label": "工业健身房",
      "position": [
        -5496.68,
        59.04,
        4927.74
      ],
      "sourceLine": 854
    },
    {
      "id": "超载健身房",
      "label": "超载健身房",
      "position": [
        -3045.3,
        165.41,
        4990.69
      ],
      "sourceLine": 855
    },
    {
      "id": "无转盘岛",
      "label": "无转盘岛",
      "position": [
        1952.09,
        1.0,
        6179.98
      ],
      "sourceLine": 856
    },
    {
      "id": "熔岩争斗",
      "label": "熔岩争斗",
      "position": [
        4472.53,
        118.9,
        -8848.54
      ],
      "sourceLine": 857
    },
    {
      "id": "沙漠争斗",
      "label": "沙漠争斗",
      "position": [
        973.62,
        15.92,
        -7277.01
      ],
      "sourceLine": 858
    },
    {
      "id": "海滩争斗",
      "label": "海滩争斗",
      "position": [
        -1880.89,
        15.87,
        -6137.75
      ],
      "sourceLine": 859
    }
  ],
  "fallbackPets": [
    "不稳定幻影",
    "以太仙灵小兔",
    "伏特爪",
    "冰波传奇企鹅",
    "反应堆兽",
    "地狱火",
    "地狱火龙",
    "大超新星",
    "幻影创世龙",
    "星界电光",
    "暗星猎人",
    "核心小狗",
    "橙色刺猬",
    "橙色飞马",
    "永恒巨型攻击",
    "永恒打击利维坦",
    "熵爆炸",
    "电光",
    "白色凤凰",
    "白色飞马",
    "等离子掠夺者",
    "紫色光环",
    "紫色新环",
    "紫色猎鹰",
    "紫色龙",
    "红色光环",
    "红色小猫",
    "红色火龙",
    "红色释火者",
    "终极超新星飞马",
    "绿色光环",
    "绿色蝴蝶",
    "绿色释火者",
    "肌肉之王",
    "肌肉老师",
    "能量闪电",
    "蓝色光环",
    "蓝色凤凰",
    "顶峰霸主",
    "魔法蝴蝶",
    "黄色光环",
    "黄色蝴蝶",
    "黄金维金人",
    "黑暗德古拉",
    "黑暗电光",
    "黑暗蝎尾怪传奇",
    "黑暗闪电",
    "黑暗风暴",
    "黑暗魔像"
  ],
  "notes": {
    "pets": "优先游戏内 cPetShopFolder 名称；49 项为旧版内置兜底，不能视作当前商店库存。",
    "eggTargets": "只读取同一服务器的其他玩家 Name；浏览器未连接 Roblox 时列表为空。",
    "boss": "旧版只有自动打Boss开关，没有固定 Boss 名单。",
    "rebirth": "旧版没有重生方案下拉框；包含换包重生、快速锻炼、自动吃蛋和送蛋。"
  }
};

// 所有重复入口从控件声明取同一个中文名字。
export const labels = Object.fromEntries(catalog.controls.map(control => [control.id, control.label]));
for (const feature of catalog.features) feature.title = labels[feature.id];
