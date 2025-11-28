Table_GuideID_bk_t = {
  EffectPos = {
    {x = 0, y = -40},
    {x = 0, y = -12},
    {x = -999, y = -999},
    {x = -170, y = 0},
    {x = -38.1, y = -10.26}
  },
  hollows = {
    {"SelfUpLeft"},
    {"BgTex"},
    {"rbook"},
    {
      {
        "addPointPageCenterRegion",
        0
      },
      {
        "addPointPageCenterRegion",
        1
      },
      {
        "addPointPageCenterRegion",
        4
      },
      {
        "addPointPageCenterRegion",
        5
      }
    },
    {
      {
        "addPointPageCenterRegion",
        0
      },
      {
        "addPointPageCenterRegion",
        2
      },
      {
        "addPointPageCenterRegion",
        4
      }
    },
    {
      {
        "addPointPageCenterRegion",
        2
      },
      {
        "addPointPageCenterRegion",
        3
      },
      {
        "addPointPageCenterRegion",
        4
      }
    },
    {
      {
        "addPointPageCenterRegion",
        0
      },
      {
        "addPointPageCenterRegion",
        3
      },
      {
        "addPointPageCenterRegion",
        4
      }
    },
    {
      {
        "addPointPageCenterRegion",
        0
      },
      {
        "addPointPageCenterRegion",
        1
      },
      {
        "addPointPageCenterRegion",
        5
      }
    },
    {
      {
        "addPointPageCenterRegion",
        1
      },
      {
        "addPointPageCenterRegion",
        4
      },
      {
        "addPointPageCenterRegion",
        5
      }
    },
    {
      {
        "addPointPageCenterRegion",
        0
      },
      {
        "addPointPageCenterRegion",
        1
      },
      {
        "addPointPageCenterRegion",
        4
      }
    },
    {
      {
        "addPointPageCenterRegion",
        1
      },
      {
        "addPointPageCenterRegion",
        2
      },
      {
        "addPointPageCenterRegion",
        3
      }
    },
    {
      {
        "addPointPageCenterRegion",
        0
      },
      {
        "addPointPageCenterRegion",
        2
      },
      {
        "addPointPageCenterRegion",
        3
      },
      {
        "addPointPageCenterRegion",
        4
      }
    },
    {
      {
        "addPointPageCenterRegion",
        1
      },
      {
        "addPointPageCenterRegion",
        2
      },
      {
        "addPointPageCenterRegion",
        4
      }
    },
    {
      "AutoShortCut"
    },
    {"ShortCut"},
    {
      "ContentsWidget"
    },
    {
      {"Root", 0}
    },
    {
      {
        "addPointPageCenterRegion",
        3
      },
      {
        "addPointPageCenterRegion",
        4
      },
      {
        "addPointPageCenterRegion",
        5
      }
    },
    {
      "DifficultyBg"
    },
    {"ViewportBg"},
    {
      "LuckyPlayerActiveLeb"
    },
    {"zoomArea"},
    {
      "defaultColorWidget"
    },
    {
      "customColorWidget"
    },
    {"GameTime"},
    {"cellBg"},
    {
      "FourthSkillBG"
    },
    {
      "SelectEffect"
    },
    {
      "taskQuestBG"
    }
  },
  offset = {
    {x = 106.2, y = -130.4},
    {x = -187.6, y = 104.99},
    {x = -211.6, y = -110}
  },
  position = {
    {x = -50, y = 150},
    {x = 104, y = -133},
    {x = -232, y = 202},
    {x = -185, y = 41},
    {x = -140, y = 150},
    {x = 10, y = -98},
    {x = -50, y = -85},
    {x = -160, y = 220},
    {x = 177, y = 243},
    {x = 360, y = 193},
    {x = 203, y = -170},
    {x = -437, y = 149},
    {x = -155, y = 86},
    {x = -160, y = 140},
    {x = 300, y = -80},
    {x = 58, y = -151},
    {x = -416, y = -151},
    {x = -85, y = 306},
    {x = 225, y = 178},
    {x = -118, y = -97},
    {x = 50, y = -90},
    {x = 0, y = 0},
    {x = 230, y = 80},
    {
      x = 0,
      y = 0,
      z = 0
    },
    {x = -100, y = -80},
    {x = 129, y = 150},
    {x = 124, y = 42},
    {x = -326, y = -193},
    {x = -2, y = 2},
    {x = -326, y = -168},
    {x = -360, y = -291},
    {x = -4, y = 62},
    {x = 404, y = -95},
    {x = -368, y = -125},
    {x = -450, y = 0},
    {x = -206, y = -3},
    {x = -103, y = 143},
    {x = -57, y = -113},
    {x = -518, y = -126},
    {x = 152, y = 143},
    {x = 212, y = -45}
  },
  rotation = {
    {
      x = 0,
      y = 0,
      z = 0
    },
    {
      x = 180,
      y = 180,
      z = 0
    },
    {
      x = 0,
      y = 180,
      z = 0
    },
    {
      x = 0,
      y = 0,
      z = -180
    }
  }
}
Table_GuideID_bk = {
  [1] = {
    Explain = "打开角色界面",
    ButtonID = 101,
    text = "点击自己的头像",
    position = Table_GuideID_bk_t.position[2],
    rotation = Table_GuideID_bk_t.rotation[2],
    offset = Table_GuideID_bk_t.offset[1],
    press = 1
  },
  [2] = {
    id = 2,
    Explain = "打开角色加点切页",
    uiID = "Charactor",
    ButtonID = 5,
    press = 1,
    FailJump = 1
  },
  [3] = {
    id = 3,
    Explain = "检查人物剩余素质点",
    Preguide = 1,
    optionId = 1,
    uiID = "Charactor",
    ButtonID = 6,
    press = 1
  },
  [4] = {
    id = 4,
    Explain = "点击加点确认按钮",
    Preguide = 471,
    uiID = "Charactor",
    ButtonID = 7,
    press = 1,
    FailJump = 1
  },
  [5] = {
    id = 5,
    Explain = "点击角色界面中的关闭界面按钮×",
    Preguide = 4,
    uiID = "Charactor",
    ButtonID = 8,
    press = 1,
    FailJump = 1
  },
  [6] = {
    id = 6,
    Explain = "检查人物剩余素质点",
    Preguide = 2,
    optionId = 1,
    uiID = "Charactor",
    ButtonID = 12,
    press = 0
  },
  [10] = {
    id = 10,
    Explain = "点击道具商人的杂货铺按钮",
    uiID = "DialogView",
    ButtonID = 10,
    press = 1
  },
  [11] = {
    id = 11,
    Explain = "点击道具商人里面的红色药水一行",
    Preguide = 10,
    uiID = "HappyShop",
    ButtonID = 11,
    targetID = 12001,
    press = 1,
    ServerEvent = "GuideEvent_SessionShopQueryShopConfigCmd",
    FailJump = 1
  },
  [12] = {
    id = 12,
    Explain = "检测购买药水数量是否达到5瓶及以上",
    Preguide = 11,
    optionId = 2,
    uiID = "HappyShop",
    ButtonID = 16,
    text = "长按后能快速增加数量",
    position = Table_GuideID_bk_t.position[4],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 0
  },
  [13] = {
    id = 13,
    Explain = "点击确认购买按钮",
    Preguide = 12,
    uiID = "HappyShop",
    ButtonID = 17,
    press = 1,
    FailJump = 1
  },
  [14] = {
    id = 14,
    Explain = "点击道具商人关闭界面按钮",
    Preguide = 13,
    uiID = "HappyShop",
    ButtonID = 15,
    press = 1,
    FailJump = 1
  },
  [21] = {
    id = 21,
    Explain = "点击角色界面里的“查看技能”",
    Preguide = 1,
    uiID = "Charactor",
    ButtonID = 9,
    press = 1,
    FailJump = 1,
    SpecialID = 0
  },
  [22] = {
    id = 22,
    Explain = "检查剩余技能点数",
    optionId = 3,
    uiID = "SkillView",
    ButtonID = 32,
    press = 0,
    SpecialID = 1,
    IsJump = 1
  },
  [23] = {
    id = 23,
    Explain = "点击技能加点确认按钮",
    Preguide = 22,
    uiID = "SkillView",
    ButtonID = 30,
    press = 1,
    FailJump = 1
  },
  [24] = {
    id = 24,
    Explain = "点击技能界面上的返回按钮",
    Preguide = 23,
    uiID = "SkillView",
    ButtonID = 31,
    press = 1,
    FailJump = 1
  },
  [25] = {
    id = 25,
    Explain = "点击角色加点切页",
    Preguide = 24,
    uiID = "Charactor",
    ButtonID = 5,
    press = 1,
    FailJump = 1
  },
  [30] = {
    id = 30,
    Explain = "打开背包界面",
    uiID = "PackageView",
    ButtonID = 103,
    press = 1
  },
  [31] = {
    id = 31,
    Explain = "点击强化切页",
    Preguide = 30,
    uiID = "PackageView",
    ButtonID = 35,
    press = 1,
    FailJump = 1
  },
  [40] = {
    id = 40,
    Explain = "打开更多界面",
    ButtonID = 102,
    press = 1
  },
  [41] = {
    id = 41,
    Explain = "打开冒险手册界面",
    Preguide = 40,
    ButtonID = 106,
    press = 1,
    FailJump = 1
  },
  [42] = {
    id = 42,
    Explain = "点击魔物切页",
    Preguide = 41,
    uiID = "AdventurePanel",
    ButtonID = 40,
    press = 1,
    FailJump = 1
  },
  [48] = {
    id = 48,
    Explain = "点击魔物卡片切页",
    Preguide = 41,
    uiID = "AdventurePanel",
    ButtonID = 41,
    press = 1,
    FailJump = 1
  },
  [50] = {
    id = 50,
    Explain = "打开乐园团商店",
    uiID = "DialogView",
    ButtonID = 18,
    press = 1
  },
  [51] = {
    id = 51,
    Explain = "点击乐园团商店中的乐园团帽子图纸",
    Preguide = 50,
    uiID = "HappyShop",
    ButtonID = 19,
    targetID = 14076,
    press = 1,
    ServerEvent = "GuideEvent_SessionShopQueryShopConfigCmd",
    FailJump = 1
  },
  [52] = {
    id = 52,
    Explain = "点击乐园团商店中的确认购买按钮",
    Preguide = 51,
    uiID = "HappyShop",
    ButtonID = 17,
    press = 1,
    FailJump = 1
  },
  [55] = {
    id = 55,
    Explain = "点击头饰制作卷轴上的制作按钮",
    Preguide = 492,
    uiID = "PicMakeCell",
    ButtonID = 20,
    press = 1,
    FailJump = 1,
    IsJump = 1
  },
  [56] = {
    id = 56,
    Explain = "点击微笑小姐对话框上的制作头饰按钮",
    uiID = "DialogView",
    ButtonID = 21,
    press = 1,
    FailJump = 1
  },
  [60] = {
    id = 60,
    Explain = "点击冒险技能学习界面中的“战斗技巧”",
    Preguide = 61,
    uiID = "UIViewControllerAdventureSkill",
    ButtonID = 36,
    press = 1,
    FailJump = 1
  },
  [61] = {
    id = 61,
    Explain = "点击学习冒险技能",
    uiID = "DialogView",
    ButtonID = 37,
    press = 1
  },
  [62] = {
    id = 62,
    Explain = "点击学习按钮",
    Preguide = 60,
    uiID = "UIViewAdventureSkillDetail",
    ButtonID = 38,
    press = 1,
    FailJump = 1
  },
  [63] = {
    id = 63,
    Explain = "点击学习冒险技能上的关闭按钮",
    Preguide = 62,
    uiID = "UIViewControllerAdventureSkill",
    ButtonID = 39,
    press = 1,
    FailJump = 1
  },
  [64] = {
    id = 64,
    Explain = "点击冒险技能学习界面中的“魔物锁定”",
    Preguide = 61,
    uiID = "UIViewControllerAdventureSkill",
    ButtonID = 45,
    press = 1,
    FailJump = 1
  },
  [65] = {
    id = 65,
    Explain = "点击进入包包",
    ButtonID = 103,
    press = 1
  },
  [66] = {
    id = 66,
    Explain = "点击进入任务手册",
    Preguide = 65,
    uiID = "PackageView",
    ButtonID = 201,
    press = 1
  },
  [67] = {
    id = 67,
    Explain = "点击使用任务手册",
    ButtonID = 202,
    press = 1
  },
  [70] = {
    id = 70,
    Explain = "使用普通攻击",
    ButtonID = 131,
    press = 1
  },
  [71] = {
    id = 71,
    Explain = "使用重击",
    ButtonID = 132,
    press = 1
  },
  [72] = {
    id = 72,
    Explain = "使用装死",
    ButtonID = 132,
    BubbleID = 27,
    press = 1,
    FailJump = 1
  },
  [73] = {
    id = 73,
    Explain = "打开照相机",
    ButtonID = 110,
    text = "点击打开照相机",
    position = Table_GuideID_bk_t.position[9],
    rotation = Table_GuideID_bk_t.rotation[1],
    offset = Table_GuideID_bk_t.offset[2],
    press = 1,
    FailJump = 1
  },
  [74] = {
    id = 74,
    Explain = "打开更多界面",
    ButtonID = 102,
    text = "照相机藏在这里面哟",
    position = Table_GuideID_bk_t.position[10],
    rotation = Table_GuideID_bk_t.rotation[1],
    offset = Table_GuideID_bk_t.offset[3],
    press = 1,
    FailJump = 1
  },
  [75] = {
    id = 75,
    Explain = "确定照相",
    Preguide = 73,
    uiID = "PhotographPanel",
    ButtonID = 111,
    press = 1,
    FailJump = 1
  },
  [76] = {
    id = 76,
    Explain = "点击小地图按钮",
    ButtonID = 107,
    press = 1,
    FailJump = 1
  },
  [77] = {
    id = 77,
    Explain = "使用紧急治疗",
    ButtonID = 133,
    text = "使用紧急治疗恢复生命值",
    position = Table_GuideID_bk_t.position[11],
    press = 1,
    FailJump = 0
  },
  [78] = {
    id = 78,
    Explain = "自动战斗锁定曼陀罗博士",
    BubbleID = 28,
    press = 0,
    guideLockMonster = 10329
  },
  [79] = {
    id = 79,
    Explain = "打开角色界面",
    ButtonID = 101,
    text = "点击自己的头像",
    position = Table_GuideID_bk_t.position[12],
    rotation = Table_GuideID_bk_t.rotation[2],
    offset = Table_GuideID_bk_t.offset[1],
    press = 1
  },
  [80] = {
    id = 80,
    Explain = "打开角色加点切页",
    Preguide = 79,
    uiID = "Charactor",
    ButtonID = 5,
    press = 1,
    FailJump = 1
  },
  [81] = {
    id = 81,
    Explain = "流派加点提示",
    Preguide = 80,
    uiID = "Charactor",
    text = "流刃流派的素质加点注重  Str、Agi、Dex、Luk",
    position = Table_GuideID_bk_t.position[13],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1,
    FailJump = 1,
    hollows = Table_GuideID_bk_t.hollows[4]
  },
  [82] = {
    id = 82,
    Explain = "使用普通攻击",
    ButtonID = 131,
    text = "使用普通攻击击杀魔物。",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [83] = {
    id = 83,
    Explain = "使用自动攻击",
    ButtonID = 150,
    text = "在列表中选取巨大欢乐跳菇。",
    position = Table_GuideID_bk_t.position[14],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [84] = {
    id = 84,
    Explain = "使用装死",
    ButtonID = 132,
    text = "装死能帮你免受部分怪物的攻击，是回复hp和sp的重要技能。",
    position = Table_GuideID_bk_t.position[11],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [85] = {
    id = 85,
    Explain = "我们已经为你标记了阿历克塞的位置啦~快去找他吧",
    Preguide = 76,
    uiID = "",
    BubbleID = 30,
    press = 0
  },
  [86] = {
    id = 86,
    Explain = "流派加点提示",
    Preguide = 80,
    uiID = "Charactor",
    text = "风魔流派素质加点注重  Str、Vit、Dex",
    position = Table_GuideID_bk_t.position[13],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1,
    FailJump = 1,
    hollows = Table_GuideID_bk_t.hollows[5]
  },
  [87] = {
    id = 87,
    Explain = "流派加点提示",
    Preguide = 80,
    uiID = "Charactor",
    text = "忍法流派素质加点注重  Vit、Int、Dex",
    position = Table_GuideID_bk_t.position[13],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1,
    FailJump = 1,
    hollows = Table_GuideID_bk_t.hollows[6]
  },
  [88] = {
    id = 88,
    Explain = "蝴蝶翅膀",
    ButtonID = 145,
    text = "使用蝴蝶翅膀可以瞬间回到你储存的地点",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [89] = {
    id = 89,
    Explain = "皇家卫士加点提示",
    Preguide = 80,
    uiID = "Charactor",
    text = "皇家卫士素质加点注重  Str、Vit、Dex",
    position = Table_GuideID_bk_t.position[13],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1,
    FailJump = 1,
    hollows = Table_GuideID_bk_t.hollows[5]
  },
  [90] = {
    id = 90,
    Explain = "龙息骑士加点提示",
    Preguide = 80,
    uiID = "Charactor",
    text = "龙息流派素质加点注重  Str、Int、Dex",
    position = Table_GuideID_bk_t.position[13],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1,
    FailJump = 1,
    hollows = Table_GuideID_bk_t.hollows[7]
  },
  [91] = {
    id = 91,
    Explain = "敏骑士加点提示",
    Preguide = 80,
    uiID = "Charactor",
    text = "敏骑流派素质加点注重  Str、Agi、Luk",
    position = Table_GuideID_bk_t.position[13],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1,
    FailJump = 1,
    hollows = Table_GuideID_bk_t.hollows[8]
  },
  [92] = {
    id = 92,
    Explain = "舞娘加点提示",
    Preguide = 80,
    uiID = "Charactor",
    text = "漫游舞者素质加点注重  Vit、Int、Dex",
    position = Table_GuideID_bk_t.position[13],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1,
    FailJump = 1,
    hollows = Table_GuideID_bk_t.hollows[6]
  },
  [93] = {
    id = 93,
    Explain = "诗人加点提示",
    Preguide = 80,
    uiID = "Charactor",
    text = "宫廷乐师素质加点注重  Vit、Int、Dex",
    position = Table_GuideID_bk_t.position[13],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1,
    FailJump = 1,
    hollows = Table_GuideID_bk_t.hollows[6]
  },
  [94] = {
    id = 94,
    Explain = "普攻流派加点提示",
    Preguide = 80,
    uiID = "Charactor",
    text = "普攻流派素质加点注重  Agi、Dex、Luk",
    position = Table_GuideID_bk_t.position[13],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1,
    FailJump = 1,
    hollows = Table_GuideID_bk_t.hollows[9]
  },
  [95] = {
    id = 95,
    Explain = "陷阱流派加点提示",
    Preguide = 80,
    uiID = "Charactor",
    text = "陷阱流派素质加点注重  Vit、Int、Dex",
    position = Table_GuideID_bk_t.position[13],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1,
    FailJump = 1,
    hollows = Table_GuideID_bk_t.hollows[6]
  },
  [96] = {
    id = 96,
    Explain = "弓流逐影加点提示",
    Preguide = 80,
    uiID = "Charactor",
    text = "弓流逐影素质加点注重  Agi、Dex、Luk",
    position = Table_GuideID_bk_t.position[13],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1,
    FailJump = 1,
    hollows = Table_GuideID_bk_t.hollows[9]
  },
  [97] = {
    id = 97,
    Explain = "刀流逐影加点提示",
    Preguide = 80,
    uiID = "Charactor",
    text = "刀流逐影素质加点注重  Str、Agi、Dex",
    position = Table_GuideID_bk_t.position[13],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1,
    FailJump = 1,
    hollows = Table_GuideID_bk_t.hollows[10]
  },
  [98] = {
    id = 98,
    Explain = "拳刃流派加点提示",
    Preguide = 80,
    uiID = "Charactor",
    text = "拳刃流派素质加点注重  Str、Agi、Luk",
    position = Table_GuideID_bk_t.position[13],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1,
    FailJump = 1,
    hollows = Table_GuideID_bk_t.hollows[8]
  },
  [99] = {
    id = 99,
    Explain = "双刀流派加点提示",
    Preguide = 80,
    uiID = "Charactor",
    text = "双刀流派素质加点注重  Str、Agi、Dex",
    position = Table_GuideID_bk_t.position[13],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1,
    FailJump = 1,
    hollows = Table_GuideID_bk_t.hollows[10]
  },
  [100] = {
    id = 100,
    Explain = "\"任务点都标记在地图上，请留意感叹号\"",
    uiID = "",
    BubbleID = 1,
    press = 0
  },
  [101] = {
    id = 101,
    Explain = "\"拖动技能图标，把不需要的技能都替换掉吧！\"",
    uiID = "",
    BubbleID = 3,
    press = 0
  },
  [102] = {
    id = 102,
    Explain = "\"使用蝴蝶翅膀可以瞬间回到这里\"",
    uiID = "",
    BubbleID = 4,
    press = 0
  },
  [110] = {
    id = 110,
    Explain = "点击小地图按钮",
    ButtonID = 107,
    press = 1
  },
  [111] = {
    id = 111,
    Explain = "访问地图上任意“！”可接取任务",
    uiID = "",
    BubbleID = 10,
    press = 0,
    RepeatDeltaTime = 60
  },
  [112] = {
    id = 112,
    Explain = "我们已经为你标记了波伊的位置啦~快去找它吧",
    Preguide = 110,
    uiID = "",
    BubbleID = 15,
    press = 0
  },
  [113] = {
    id = 113,
    Explain = "我们已经为你标记了班尼的位置啦~快去找他吧",
    Preguide = 110,
    uiID = "",
    BubbleID = 17,
    press = 0
  },
  [114] = {
    id = 114,
    Explain = "我们已经为你标记了“尤金”的位置啦~快去找它吧",
    Preguide = 110,
    uiID = "",
    BubbleID = 21,
    press = 0
  },
  [115] = {
    id = 115,
    Explain = "我们已经为你标记了“亚利欧”的位置啦~快去找它吧",
    Preguide = 110,
    uiID = "",
    BubbleID = 22,
    press = 0
  },
  [116] = {
    id = 116,
    Explain = "访问地图上任意“！”可接取任务",
    Preguide = 110,
    uiID = "",
    BubbleID = 24,
    press = 0
  },
  [117] = {
    id = 117,
    Explain = "我们已经为你标记了希格德莉法的位置啦~快去找她吧",
    Preguide = 76,
    uiID = "",
    BubbleID = 25,
    press = 0
  },
  [118] = {
    id = 118,
    Explain = "学院野外",
    Preguide = 76,
    uiID = "",
    press = 0
  },
  [119] = {
    id = 119,
    Explain = "自动战斗锁定教学用凶萌垂耳波利",
    BubbleID = 26,
    press = 0,
    guideLockMonster = 62813
  },
  [120] = {
    id = 120,
    Explain = "自动战斗锁定疯兔",
    BubbleID = 20,
    press = 0,
    guideLockMonster = 10002
  },
  [121] = {
    id = 121,
    Explain = "自动战斗锁定“群叶疯兔”",
    BubbleID = 23,
    press = 0,
    guideLockMonster = 10202
  },
  [125] = {
    id = 125,
    Explain = "空的引导任务，陈涛用",
    uiID = "",
    press = 0
  },
  [130] = {
    id = 130,
    Explain = "自动战斗锁定绿棉虫",
    BubbleID = 20,
    press = 0,
    guideLockMonster = 53437
  },
  [131] = {
    id = 131,
    Explain = "学院技能引导皇家卫士",
    ButtonID = 132,
    text = "【连续盾击】能对敌方单体造成大量伤害。",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [132] = {
    id = 132,
    ButtonID = 133,
    text = "使用【大地猛击】，大范围挥动盾牌，可对自身周围敌人造成群体性物理伤害。",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [133] = {
    id = 133,
    ButtonID = 134,
    text = "【挑衅】敌方单位，使小范围内魔物强制攻击自己。",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [134] = {
    id = 134,
    ButtonID = 135,
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [135] = {
    id = 135,
    ButtonID = 136,
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [136] = {
    id = 136,
    ButtonID = 131,
    text = "使用普通攻击击杀魔物。",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [137] = {
    id = 137,
    Explain = "学院技能引导逐影弓",
    ButtonID = 136,
    text = "【涂毒】能使你在普通攻击时，有概率令敌方中毒。",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [138] = {
    id = 138,
    ButtonID = 132,
    text = "【三连矢】是非常有效的单体伤害技能。",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [139] = {
    id = 139,
    ButtonID = 133,
    text = "【魔力陷阱】可以使范围内的敌方群体持续受到物理伤害，是逐影的范围技能。",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [140] = {
    id = 140,
    ButtonID = 135,
    text = "点击技能5",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [141] = {
    id = 141,
    ButtonID = 134,
    text = "【隐匿】能让你立即进入隐身状态不被敌方单位发现。",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [142] = {
    id = 142,
    ButtonID = 131,
    text = "使用普通攻击击杀魔物。",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [143] = {
    id = 143,
    Explain = "学院技能引导神牧",
    ButtonID = 132,
    text = "使用【圣灵降临】复活希格德莉法。",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [144] = {
    id = 144,
    ButtonID = 133,
    text = "【审判】能对敌方单体造成超高伤害。",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [145] = {
    id = 145,
    ButtonID = 134,
    text = "【治愈之光】以自身为中心，恢复周围友方全体的生命值。",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [146] = {
    id = 146,
    ButtonID = 135,
    text = "【致命感染】能让你在一定时间内免疫异常状态。",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [147] = {
    id = 147,
    ButtonID = 136,
    text = "【隐匿】能让你立即进入隐身状态不被敌方单位发现。",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [148] = {
    id = 148,
    ButtonID = 131,
    text = "使用普通攻击击杀魔物。",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [149] = {
    id = 149,
    Explain = "学院技能引导狮鹫",
    ButtonID = 141,
    text = "皇家卫士能够骑上坐骑攻击，【狮鹫】兽就是他们最好的伙伴。",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [150] = {
    id = 150,
    Explain = "学院技能引导逐影刀",
    ButtonID = 136,
    text = "点击技能6",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [151] = {
    id = 151,
    ButtonID = 132,
    text = "【背刺】能对敌方单体造成超高伤害。",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [152] = {
    id = 152,
    ButtonID = 133,
    text = "【魔力陷阱】可以使范围内的敌方群体持续受到物理伤害，是逐影的范围技能。",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [153] = {
    id = 153,
    ButtonID = 135,
    text = "点击技能5",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [154] = {
    id = 154,
    ButtonID = 134,
    text = "【隐匿】能让你立即进入隐身状态不被敌方单位发现。",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [155] = {
    id = 155,
    ButtonID = 131,
    text = "使用普通攻击击杀魔物。",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [156] = {
    id = 156,
    Explain = "学院技能引导十字切割拳套",
    ButtonID = 136,
    text = "点击技能6",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [157] = {
    id = 157,
    ButtonID = 132,
    text = "【十字斩】能对敌方单体造成大量物理伤害。",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [158] = {
    id = 158,
    ButtonID = 133,
    text = "【回旋利刃】会将武器高速旋转，对自身周围的敌方群体造成物理伤害。",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [159] = {
    id = 159,
    ButtonID = 135,
    text = "点击技能5",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [160] = {
    id = 160,
    ButtonID = 134,
    text = "【隐匿】能让你立即进入隐身状态不被敌方单位发现。",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [161] = {
    id = 161,
    ButtonID = 131,
    text = "使用普通攻击击杀魔物。",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [162] = {
    id = 162,
    Explain = "学院技能引导十字切割短剑",
    ButtonID = 136,
    text = "点击技能6",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [163] = {
    id = 163,
    ButtonID = 132,
    text = "【心灵震波】会从远处发射震波，对敌方单体造成高额物理伤害。",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [164] = {
    id = 164,
    ButtonID = 134,
    text = "【毒雾】可以使范围内的敌方群体受到持续的物理伤害。",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [165] = {
    id = 165,
    ButtonID = 133,
    text = "进入【剧毒武器】状态。",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [166] = {
    id = 166,
    ButtonID = 135,
    text = "【隐匿】能让你立即进入隐身状态不被敌方单位发现。",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [167] = {
    id = 167,
    ButtonID = 131,
    text = "使用普通攻击击杀魔物。",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [168] = {
    id = 168,
    Explain = "学院技能引导忍者流刃",
    ButtonID = 136,
    text = "点击技能6",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [169] = {
    id = 169,
    ButtonID = 132,
    text = "【十文字斩】能对敌方单体造成大量伤害。",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [170] = {
    id = 170,
    ButtonID = 133,
    text = "面对大量魔物，可使用【忍法·千本影】召唤分身协助战斗。",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [171] = {
    id = 171,
    ButtonID = 135,
    text = "点击技能5",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [172] = {
    id = 172,
    ButtonID = 134,
    text = "【雾隐】能让你进入隐身状态，不被敌方单位发现。",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [173] = {
    id = 173,
    ButtonID = 131,
    text = "使用普通攻击击杀魔物。",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [174] = {
    id = 174,
    Explain = "学院技能引导忍者风魔",
    ButtonID = 136,
    text = "点击技能6",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [175] = {
    id = 175,
    ButtonID = 132,
    text = "【飞镖扔】可对敌方单体造成远程物理伤害。",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [176] = {
    id = 176,
    ButtonID = 133,
    text = "【风魔飞镖扔】可对敌方群体造成物理伤害。",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [177] = {
    id = 177,
    ButtonID = 135,
    text = "点击技能5",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [178] = {
    id = 178,
    ButtonID = 134,
    text = "【雾隐】能让你进入隐身状态，不被敌方单位发现。",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [179] = {
    id = 179,
    ButtonID = 131,
    text = "使用普通攻击击杀魔物。",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [180] = {
    id = 180,
    Explain = "学院技能引导忍者忍法",
    ButtonID = 136,
    text = "点击技能6",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [181] = {
    id = 181,
    ButtonID = 132,
    text = "【通灵术·奥加雷】召唤一只雷兽环绕自身，每秒选取周围的一名敌人造成魔法攻击。",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [182] = {
    id = 182,
    ButtonID = 133,
    text = "【通灵术·漩涡丸】召唤一只忍蛙对范围内的敌人进行连续重击，造成水属性魔法伤害。",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [183] = {
    id = 183,
    ButtonID = 135,
    text = "点击技能5",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [184] = {
    id = 184,
    ButtonID = 134,
    text = "【雾隐】能让你进入隐身状态，不被敌方单位发现。",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [185] = {
    id = 185,
    ButtonID = 131,
    text = "使用普通攻击击杀魔物。",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [186] = {
    id = 186,
    Explain = "学院技能引导爆牧",
    ButtonID = 132,
    text = "使用【圣灵降临】复活希格德莉法。",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [187] = {
    id = 187,
    ButtonID = 133,
    text = "【双重圣光】能使你在近身攻击时额外造成伤害。",
    position = Table_GuideID_bk_t.position[11],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [188] = {
    id = 188,
    ButtonID = 134,
    text = "【治愈之光】以自身为中心，恢复周围友方全体的生命值。",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [189] = {
    id = 189,
    ButtonID = 135,
    text = "点击技能5",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [190] = {
    id = 190,
    ButtonID = 136,
    text = "点击技能6",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [191] = {
    id = 191,
    ButtonID = 131,
    text = "使用普通攻击击杀魔物。",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [192] = {
    id = 192,
    Explain = "学院技能引导诗人/舞娘",
    ButtonID = 132,
    text = "使用【回归之歌】复活希格德莉法。",
    position = Table_GuideID_bk_t.position[11],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [193] = {
    id = 193,
    ButtonID = 133,
    text = "【奥义箭乱舞】可对单体目标造成大量伤害。",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [194] = {
    id = 194,
    ButtonID = 134,
    text = "【狂风暴雨】可对范围内敌人造成物理伤害。",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [195] = {
    id = 195,
    ButtonID = 135,
    text = "【循环自然之声】可以治疗自身周围的队友。【临机应变】可以中止施展的歌曲或舞蹈。",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [196] = {
    id = 196,
    ButtonID = 136,
    text = "点击技能6",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [197] = {
    id = 197,
    ButtonID = 131,
    text = "使用普通攻击击杀魔物。",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [198] = {
    id = 198,
    Explain = "学院技能引导游侠ADL",
    ButtonID = 132,
    text = "【狙杀瞄准】能使自身在短时间内增加暴击、物攻等属性。",
    position = Table_GuideID_bk_t.position[11],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [199] = {
    id = 199,
    ButtonID = 133,
    text = "使用【蓄势待发】，可通过牺牲攻速，换取更多的灵巧、暴击、暴伤等属性。",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [200] = {
    id = 200,
    ButtonID = 134,
    text = "【照明箭】可照亮身边5米内所有的潜行敌方单位及陷阱，效果持续时间20秒。",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [201] = {
    id = 201,
    ButtonID = 135,
    text = "点击技能5",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [202] = {
    id = 202,
    ButtonID = 136,
    text = "点击技能6",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [203] = {
    id = 203,
    ButtonID = 131,
    text = "使用普通攻击击杀魔物。",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [204] = {
    id = 204,
    Explain = "学院技能引导游侠炸弹人",
    ButtonID = 132,
    text = "在指定位置生成【电击陷阱】，可对其中敌方造成风属性魔法伤害。",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [205] = {
    id = 205,
    ButtonID = 133,
    text = "【冰霜陷阱】能对经过陷阱上方的敌人造成伤害。手动引爆，还能提升陷阱伤害。",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [206] = {
    id = 206,
    ButtonID = 134,
    text = "【照明箭】可照亮身边5米内所有的潜行敌方单位及陷阱，效果持续时间20秒。",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [207] = {
    id = 207,
    ButtonID = 135,
    text = "点击技能5",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [208] = {
    id = 208,
    ButtonID = 136,
    text = "点击技能6",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [209] = {
    id = 209,
    ButtonID = 131,
    text = "使用普通攻击击杀魔物。",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [210] = {
    id = 210,
    Explain = "学院技能引导龙息骑",
    ButtonID = 132,
    text = "【连刺攻击】使用长矛连续攻击敌人，对敌方单体造成高额物理伤害。",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [211] = {
    id = 211,
    ButtonID = 133,
    text = "【龙之吐息】能对范围内的敌方群体造成物理伤害。",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [212] = {
    id = 212,
    ButtonID = 134,
    text = "【挑衅】敌方单位，使小范围内魔物强制攻击自己。",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [213] = {
    id = 213,
    ButtonID = 135,
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [214] = {
    id = 214,
    ButtonID = 136,
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [215] = {
    id = 215,
    ButtonID = 131,
    text = "使用普通攻击击杀魔物。",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [216] = {
    id = 216,
    Explain = "学院技能引导地龙",
    ButtonID = 141,
    text = "【地龙】可以提高你的移动速度，也是【释放龙之吐息】的前置条件。",
    position = Table_GuideID_bk_t.position[15],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [217] = {
    id = 217,
    Explain = "学院技能引导敏骑",
    ButtonID = 132,
    text = "【伤害增压】提升150物理攻击，并有22%的概率在普通攻击时使目标出血，效果持续160秒。",
    position = Table_GuideID_bk_t.position[11],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [218] = {
    id = 218,
    ButtonID = 133,
    text = "【附魔之刃】会在武器中注入魔力，在使用普通攻击会额外计算魔法攻击。",
    position = Table_GuideID_bk_t.position[11],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [219] = {
    id = 219,
    ButtonID = 134,
    text = "【挑衅】敌方单位，使小范围内魔物强制攻击自己。",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [220] = {
    id = 220,
    ButtonID = 135,
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [221] = {
    id = 221,
    ButtonID = 136,
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [222] = {
    id = 222,
    ButtonID = 131,
    text = "使用普通攻击击杀魔物。",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [223] = {
    id = 223,
    Explain = "学院技能引导地龙",
    ButtonID = 141,
    text = "敏骑能够骑上坐骑攻击，【地龙】兽就是他们最好的伙伴。",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [224] = {
    id = 224,
    Explain = "学院技能引导基因学者",
    ButtonID = 132,
    text = "召唤【地狱植物】对敌方单体进行攻击。",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [225] = {
    id = 225,
    ButtonID = 133,
    text = "【火焰爆炸】能对敌方单体造成火属性物理伤害，同时溅射周围最多5名敌人。",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [226] = {
    id = 226,
    ButtonID = 134,
    text = "【疯狂野草】可对范围内敌方群体造成地属性物理伤害，同时随机解除地面陷阱和魔法效果。",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [227] = {
    id = 227,
    ButtonID = 135,
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [228] = {
    id = 228,
    ButtonID = 136,
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [229] = {
    id = 229,
    ButtonID = 131,
    text = "使用普通攻击击杀魔物。",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [230] = {
    id = 230,
    Explain = "学院技能引导物理猫",
    ButtonID = 132,
    text = "【疯兔胡萝卜重击】可对3米范围内的敌人造成物理攻击，并有30%概率使其眩晕。",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [231] = {
    id = 231,
    ButtonID = 133,
    text = "召唤【野猪之魂】朝指定方向进行冲刺攻击，并击退敌人。",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [232] = {
    id = 232,
    ButtonID = 134,
    text = "【跳跃】可向前方跳跃一段距离。",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [233] = {
    id = 233,
    ButtonID = 135,
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [234] = {
    id = 234,
    ButtonID = 136,
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [235] = {
    id = 235,
    ButtonID = 131,
    text = "使用普通攻击击杀魔物。",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [236] = {
    id = 236,
    Explain = "学院技能引导法猫",
    ButtonID = 132,
    text = "【猕猴桃梗枪】可用猕猴桃的灵魂攻击贯穿敌人，造成地属性魔法伤害。",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [237] = {
    id = 237,
    ButtonID = 133,
    text = "【猫薄荷陨石】能召唤巨大的猫薄荷灵魂从高处坠落，使范围内的敌方受到魔法伤害。",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [238] = {
    id = 238,
    ButtonID = 134,
    text = "【跳跃】可向前方跳跃一段距离。",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [239] = {
    id = 239,
    ButtonID = 135,
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [240] = {
    id = 240,
    ButtonID = 136,
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [241] = {
    id = 241,
    ButtonID = 131,
    text = "使用普通攻击击杀魔物。",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [243] = {
    id = 243,
    Explain = "学院技能引导机匠",
    ButtonID = 132,
    text = "【喷射飞拳】可对敌人造成高额单体伤害。",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [244] = {
    id = 244,
    ButtonID = 133,
    text = "【加农炮】是强力的AOE技能，面对大量的敌人时效果极佳。",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [245] = {
    id = 245,
    ButtonID = 134,
    text = "【侧滑步】可向前方侧滑步一段距离。",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [246] = {
    id = 246,
    ButtonID = 135,
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [247] = {
    id = 247,
    ButtonID = 136,
    text = "使用【魔导机甲】技能后，可以操作魔导机械。",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [248] = {
    id = 248,
    ButtonID = 131,
    text = "使用普通攻击击杀魔物。",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [249] = {
    id = 249,
    Explain = "学院技能引导魔导机甲",
    ButtonID = 141,
    text = "装备【魔导机甲】是释放机匠技能的前置条件。",
    position = Table_GuideID_bk_t.position[15],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [250] = {
    id = 250,
    Explain = "学院技能引导元素使",
    ButtonID = 132,
    text = "【魔力之拳】可以牺牲自身的攻击速度，使随后使用的普通攻击附带魔法效果。",
    position = Table_GuideID_bk_t.position[11],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [251] = {
    id = 251,
    ButtonID = 133,
    text = "【地震术】是强力的AOE技能，面对大量的敌人时效果极佳。",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [252] = {
    id = 252,
    ButtonID = 134,
    text = "【地元素领域】可清除技能范围内的陷阱及魔法效果。",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [253] = {
    id = 253,
    ButtonID = 135,
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [254] = {
    id = 254,
    ButtonID = 136,
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [255] = {
    id = 255,
    ButtonID = 131,
    text = "使用普通攻击击杀魔物。",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [256] = {
    id = 256,
    Explain = "学院技能引导大法师",
    ButtonID = 132,
    text = "使用【魔法理解】后再释放【元素旋涡】，能对怪物造成大量的单体伤害。",
    position = Table_GuideID_bk_t.position[11],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [257] = {
    id = 257,
    ButtonID = 133,
    text = "使用【魔法理解】后再释放【元素旋涡】，能对怪物造成大量的单体伤害。",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [258] = {
    id = 258,
    ButtonID = 134,
    text = "【连锁闪电】能对敌方群体造成高额魔法伤害。",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [259] = {
    id = 259,
    ButtonID = 135,
    text = "使用【白色障壁】，可以使自身无敌一段时间。",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [260] = {
    id = 260,
    ButtonID = 136,
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [261] = {
    id = 261,
    ButtonID = 131,
    text = "使用普通攻击击杀魔物。",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [262] = {
    id = 262,
    Explain = "学院技能引导修罗",
    ButtonID = 132,
    text = "【狂蓄气】能够立即将气弹数量恢复至上限。",
    position = Table_GuideID_bk_t.position[11],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [263] = {
    id = 263,
    ButtonID = 133,
    text = "【罗刹破凰拳】可消耗所有的气弹，对敌方单体造成高额伤害。在狂蓄气效果下可使用该技能。",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [264] = {
    id = 264,
    ButtonID = 134,
    text = "使用【狮子吼】可对指定敌方及周围的群体造成物理伤害，并有概率使其恐惧",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [265] = {
    id = 265,
    ButtonID = 135,
    text = "【霸邪之阵】可使自身或队友在一段时间内获得护盾，抵消伤害。",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [266] = {
    id = 266,
    ButtonID = 136,
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [267] = {
    id = 267,
    ButtonID = 131,
    text = "使用普通攻击击杀魔物。",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [268] = {
    id = 268,
    Explain = "学院技能引导超初",
    ButtonID = 132,
    text = "【手推车攻击】可使用手推车攻击敌方单体，造成高额物理伤害。",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [269] = {
    id = 269,
    ButtonID = 133,
    text = "【手推车爆发】能在60秒内，增加30%的移动速度和100点物理攻击，施放时必须装备手推车。",
    position = Table_GuideID_bk_t.position[11],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [270] = {
    id = 270,
    ButtonID = 134,
    text = "使用【乐园团祝福】，受到乐园团的祝福，可以在30秒内免疫魔法伤害。",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [271] = {
    id = 271,
    ButtonID = 135,
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [272] = {
    id = 272,
    ButtonID = 136,
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [273] = {
    id = 273,
    ButtonID = 131,
    text = "使用普通攻击击杀魔物。",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [274] = {
    id = 274,
    Explain = "学院技能引导手推车",
    ButtonID = 141,
    text = "装备【手推车】是释放超级初心者技能的前置条件。",
    position = Table_GuideID_bk_t.position[15],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [275] = {
    id = 275,
    Explain = "学院技能引导枪手手枪",
    ButtonID = 136,
    text = "点击技能6",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [276] = {
    id = 276,
    ButtonID = 132,
    text = "【迅速淋弹】能对敌方单体造成超高伤害。",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [277] = {
    id = 277,
    ButtonID = 133,
    text = "【亡命之徒】是非常有效的群体伤害技能。",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [278] = {
    id = 278,
    ButtonID = 135,
    text = "点击技能5",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [279] = {
    id = 279,
    ButtonID = 134,
    text = "【烟雾弹】能让你进入隐身状态，不被敌方单位发现。",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [280] = {
    id = 280,
    ButtonID = 131,
    text = "使用普通攻击击杀魔物。",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [281] = {
    id = 281,
    Explain = "学院技能引导枪手来福枪",
    ButtonID = 136,
    text = "点击技能6",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [282] = {
    id = 282,
    ButtonID = 132,
    text = "【弹无虚发】能对敌方单体造成超高伤害。",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [283] = {
    id = 283,
    ButtonID = 133,
    text = "【破片手雷】是非常有效的群体伤害技能。",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [284] = {
    id = 284,
    ButtonID = 135,
    text = "点击技能5",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [285] = {
    id = 285,
    ButtonID = 134,
    text = "【烟雾弹】能让你进入隐身状态，不被敌方单位发现。",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [286] = {
    id = 286,
    ButtonID = 131,
    text = "使用普通攻击击杀魔物。",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [300] = {
    id = 300,
    Explain = "大法师加点提示",
    Preguide = 80,
    uiID = "Charactor",
    text = "大法师的素质加点注重  Vit、Int、Dex",
    position = Table_GuideID_bk_t.position[13],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1,
    FailJump = 1,
    hollows = Table_GuideID_bk_t.hollows[6]
  },
  [301] = {
    id = 301,
    Explain = "元素使加点提示",
    Preguide = 80,
    uiID = "Charactor",
    text = "元素使的素质加点注重  Agi、Vit、Int",
    position = Table_GuideID_bk_t.position[13],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1,
    FailJump = 1,
    hollows = Table_GuideID_bk_t.hollows[11]
  },
  [302] = {
    id = 302,
    Explain = "机匠加点提示",
    Preguide = 80,
    uiID = "Charactor",
    text = "机匠职业素质加点注重  Str、Vit、Dex",
    position = Table_GuideID_bk_t.position[13],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1,
    FailJump = 1,
    hollows = Table_GuideID_bk_t.hollows[5]
  },
  [303] = {
    id = 303,
    Explain = "基因学者加点提示",
    Preguide = 80,
    uiID = "Charactor",
    text = "基因学者素质加点注重  Str、Vit、Int、Dex",
    position = Table_GuideID_bk_t.position[13],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1,
    FailJump = 1,
    hollows = Table_GuideID_bk_t.hollows[12]
  },
  [304] = {
    id = 304,
    Explain = "赞美流牧师加点提示",
    Preguide = 80,
    uiID = "Charactor",
    text = "赞美流牧师素质加点注重Vit、Int、Dex",
    position = Table_GuideID_bk_t.position[13],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1,
    FailJump = 1,
    hollows = Table_GuideID_bk_t.hollows[6]
  },
  [305] = {
    id = 305,
    Explain = "暴力流牧师加点提示",
    Preguide = 80,
    uiID = "Charactor",
    text = "暴力流牧师素质加点注重Str、Agi、Dex、Luk",
    position = Table_GuideID_bk_t.position[13],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1,
    FailJump = 1,
    hollows = Table_GuideID_bk_t.hollows[4]
  },
  [306] = {
    id = 306,
    Explain = "暴力流牧师加点提示",
    Preguide = 80,
    uiID = "Charactor",
    text = "修罗职业素质加点注重  Str、Int、Dex",
    position = Table_GuideID_bk_t.position[13],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1,
    FailJump = 1,
    hollows = Table_GuideID_bk_t.hollows[7]
  },
  [307] = {
    id = 307,
    Explain = "超级初心者加点提示",
    Preguide = 80,
    uiID = "Charactor",
    text = "超级初心者素质加点注重Str、Vit、Dex",
    position = Table_GuideID_bk_t.position[13],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1,
    FailJump = 1,
    hollows = Table_GuideID_bk_t.hollows[5]
  },
  [308] = {
    id = 308,
    Explain = "物理流派加点提示",
    Preguide = 80,
    uiID = "Charactor",
    text = "物理流派素质加点注重  Agi、Vit、Dex",
    position = Table_GuideID_bk_t.position[13],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1,
    FailJump = 1,
    hollows = Table_GuideID_bk_t.hollows[13]
  },
  [309] = {
    id = 309,
    Explain = "法术流派加点提示",
    Preguide = 80,
    uiID = "Charactor",
    text = "法术流派素质加点注重  Vit、Int、Dex",
    position = Table_GuideID_bk_t.position[13],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1,
    FailJump = 1,
    hollows = Table_GuideID_bk_t.hollows[6]
  },
  [310] = {
    id = 310,
    Explain = "",
    uiID = "SkillView",
    press = 1,
    FailJump = 1
  },
  [311] = {
    id = 311,
    Explain = "这里是自动战斗栏，装备在此处的技能会在激活自动战斗时自动使用。",
    uiID = "SkillView",
    text = "这里是自动战斗栏，装备在此处的技能会在激活自动战斗时自动使用。",
    position = Table_GuideID_bk_t.position[16],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1,
    FailJump = 1,
    hollows = Table_GuideID_bk_t.hollows[14]
  },
  [312] = {
    id = 312,
    Explain = "这里是手动技能栏，装备在此处的技能会在主界面显示。",
    Preguide = 311,
    uiID = "SkillView",
    text = "这里是手动技能栏，装备在此处的技能会在主界面显示。",
    position = Table_GuideID_bk_t.position[17],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1,
    FailJump = 1,
    hollows = Table_GuideID_bk_t.hollows[15]
  },
  [313] = {
    id = 313,
    Explain = "这里是技能面板，你可以在此查看和学习技能，其中主动技能为方形，被动技能为圆形。",
    Preguide = 312,
    uiID = "SkillView",
    text = "这里是技能面板，你可以在此查看和学习技能，其中主动技能为方形，被动技能为圆形。",
    position = Table_GuideID_bk_t.position[18],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1,
    FailJump = 1,
    hollows = Table_GuideID_bk_t.hollows[16]
  },
  [314] = {
    id = 314,
    Explain = "点击传送",
    uiID = "DialogView",
    ButtonID = 160,
    press = 1,
    FailJump = 1
  },
  [315] = {
    id = 315,
    Explain = "普隆德拉传送",
    Preguide = 314,
    uiID = "UIMapMapList",
    text = "点击普隆德拉右边的传送，花费 400 Zeny 就可以直接传送到普隆德拉哟~",
    position = Table_GuideID_bk_t.position[19],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1,
    FailJump = 1,
    hollows = Table_GuideID_bk_t.hollows[17]
  },
  [316] = {
    id = 316,
    Explain = "第一次关闭转职界面",
    ButtonID = 200,
    text = "可在此处再次打开职业预览界面哦",
    position = Table_GuideID_bk_t.position[20],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [317] = {
    id = 317,
    Explain = "手枪流派加点提示",
    Preguide = 80,
    uiID = "Charactor",
    text = "手枪流派素质加点注重  Agi、Vit、Dex",
    position = Table_GuideID_bk_t.position[13],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1,
    FailJump = 1,
    hollows = Table_GuideID_bk_t.hollows[13]
  },
  [318] = {
    id = 318,
    Explain = "来复枪流派加点提示",
    Preguide = 80,
    uiID = "Charactor",
    text = "来复枪流派素质加点注重Int、Dex、Luk",
    position = Table_GuideID_bk_t.position[13],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1,
    FailJump = 1,
    hollows = Table_GuideID_bk_t.hollows[18]
  },
  [319] = {
    id = 319,
    Explain = "悟灵士加点提示",
    Preguide = 80,
    uiID = "Charactor",
    text = "悟灵士素质加点注重    Int、Dex、Luk",
    position = Table_GuideID_bk_t.position[13],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1,
    FailJump = 1,
    hollows = Table_GuideID_bk_t.hollows[18]
  },
  [320] = {
    id = 320,
    Explain = "更多-技能按钮",
    ButtonID = 205,
    press = 1
  },
  [321] = {
    id = 321,
    Explain = "技能界面-切页到冒险技能页面",
    uiID = "SkillView",
    ButtonID = 100,
    press = 1
  },
  [322] = {
    id = 322,
    Explain = "技能界面-冒险技能页面的特定技能",
    uiID = "SkillView",
    ButtonID = 206,
    text = "将洞察技能拖拽到手动技能栏",
    position = Table_GuideID_bk_t.position[21],
    press = 1
  },
  [323] = {
    id = 323,
    Explain = "主界面证据按钮强引导",
    ButtonID = 202,
    press = 1
  },
  [324] = {
    id = 324,
    Explain = "证据页面档案按钮强引导",
    uiID = "DetectiveMainPanel",
    ButtonID = 203,
    position = Table_GuideID_bk_t.position[22],
    rotation = Table_GuideID_bk_t.rotation[4],
    press = 1
  },
  [325] = {
    id = 325,
    Explain = "证据页面关闭强引导",
    uiID = "DetectiveMainPanel",
    ButtonID = 204,
    press = 1
  },
  [326] = {
    id = 326,
    Explain = "技能界面-冒险技能页面的特定技能",
    uiID = "SkillView",
    ButtonID = 207,
    text = "将骑士技能拖拽到手动技能栏",
    position = Table_GuideID_bk_t.position[21],
    press = 1
  },
  [327] = {
    id = 327,
    Explain = "主界面任务手册骑士声望引导",
    ButtonID = 208,
    press = 1
  },
  [328] = {
    id = 328,
    Explain = "点击技能界面上的关闭按钮",
    uiID = "SkillView",
    ButtonID = 31,
    press = 1,
    FailJump = 1
  },
  [400] = {
    id = 400,
    Explain = "四个漫画引导",
    uiID = "ColorFillingView",
    ButtonID = 300,
    text = "填色前要先选择颜色",
    position = Table_GuideID_bk_t.position[28],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [401] = {
    id = 401,
    Explain = "四个漫画引导",
    Preguide = 400,
    uiID = "ColorFillingView",
    text = "空白处为可填色区域哦。\n提示：引导结束后才可以进行上色哦！",
    position = Table_GuideID_bk_t.position[29],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1,
    hollows = Table_GuideID_bk_t.hollows[22]
  },
  [402] = {
    id = 402,
    Explain = "四个漫画引导",
    Preguide = 401,
    uiID = "ColorFillingView",
    ButtonID = 302,
    text = "可以通过点击放大按钮进行放大，放大后可以拖动查看想要填色的部位，再次点击缩小按钮进行缩小哦",
    position = Table_GuideID_bk_t.position[30],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [403] = {
    id = 403,
    Explain = "四个漫画引导",
    Preguide = 402,
    uiID = "ColorFillingView",
    ButtonID = 312,
    text = "再次点击缩小",
    position = Table_GuideID_bk_t.position[30],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [404] = {
    id = 404,
    Explain = "四个漫画引导",
    Preguide = 403,
    uiID = "ColorFillingView",
    ButtonID = 303,
    text = "想要更多的颜色，点击色盘！",
    position = Table_GuideID_bk_t.position[31],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [405] = {
    id = 405,
    Explain = "四个漫画引导",
    Preguide = 404,
    uiID = "ColorFillingView",
    ButtonID = 304,
    text = "点击想要使用的颜色",
    position = Table_GuideID_bk_t.position[32],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [406] = {
    id = 406,
    Explain = "四个漫画引导",
    Preguide = 405,
    uiID = "ColorFillingView",
    ButtonID = 305,
    text = "点击想要使用的颜色后，点击添加",
    position = Table_GuideID_bk_t.position[33],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [407] = {
    id = 407,
    Explain = "四个漫画引导",
    Preguide = 406,
    uiID = "ColorFillingView",
    ButtonID = 311,
    text = "添加的颜色显示在这里。\n好啦！冒险家们，发挥自己的创造力吧！",
    position = Table_GuideID_bk_t.position[34],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [408] = {
    id = 408,
    Explain = "四个漫画引导",
    uiID = "ColorFillingView",
    text = "这里是固定颜色选择区域哦~填色开始的地方~",
    position = Table_GuideID_bk_t.position[28],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1,
    FailJump = 1,
    hollows = Table_GuideID_bk_t.hollows[23]
  },
  [409] = {
    id = 409,
    Explain = "四个漫画引导",
    uiID = "ColorFillingView",
    text = "这里是添加颜色选择区域哦~冒险家点击色轮添加的颜色会在这里显示~",
    position = Table_GuideID_bk_t.position[28],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1,
    FailJump = 1,
    hollows = Table_GuideID_bk_t.hollows[24]
  },
  [410] = {
    id = 410,
    Explain = "迪士尼3*5引导",
    ButtonID = 131,
    text = "使用神秘力量驱散迷雾",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [411] = {
    id = 411,
    Explain = "迪士尼3*5引导",
    ButtonID = 136,
    text = "点击使用技能",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [412] = {
    id = 412,
    Explain = "迪士尼3*5引导",
    ButtonID = 136,
    text = "点击使用技能",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [413] = {
    id = 413,
    Explain = "迪士尼3*5引导",
    ButtonID = 136,
    text = "点击使用技能",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [414] = {
    id = 414,
    Explain = "迪士尼3*5引导",
    ButtonID = 136,
    text = "点击使用技能",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [415] = {
    id = 415,
    Explain = "迪士尼3*5引导",
    ButtonID = 136,
    text = "点击使用技能",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [416] = {
    id = 416,
    Explain = "学院技能引导灵媒",
    ButtonID = 132,
    text = "【艾斯敦】能对敌方单体造成超高伤害。",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [417] = {
    id = 417,
    ButtonID = 133,
    text = "【灵魂冲击】是非常有效的群体伤害技能。",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [418] = {
    id = 418,
    ButtonID = 134,
    text = "【灵魂行者】消耗所有的蓝量，能让你提升移速并且免疫所有物理伤害。",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [419] = {
    id = 419,
    ButtonID = 135,
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [420] = {
    id = 420,
    ButtonID = 136,
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [421] = {
    id = 421,
    ButtonID = 131,
    text = "使用普通攻击击杀魔物。",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [422] = {
    id = 422,
    Explain = "剑士一转技能引导【狂击】",
    uiID = "SkillView",
    ButtonID = 422,
    text = "按住【狂击】拖拽到技能栏",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1,
    ButtonID2 = 231,
    isLoop = 0,
    moveTime = 1.5
  },
  [423] = {
    id = 423,
    Explain = "魔法师一转技能引导【圣灵召唤】",
    uiID = "SkillView",
    ButtonID = 423,
    text = "按住【圣灵召唤】拖拽到技能栏",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1,
    ButtonID2 = 231,
    isLoop = 0,
    moveTime = 1.5
  },
  [424] = {
    id = 424,
    Explain = "盗贼一转技能引导【强刃击】",
    uiID = "SkillView",
    ButtonID = 424,
    text = "按住【强刃击】拖拽到技能栏",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1,
    ButtonID2 = 231,
    isLoop = 0,
    moveTime = 1.5
  },
  [425] = {
    id = 425,
    Explain = "弓箭手一转技能引导【二连矢】",
    uiID = "SkillView",
    ButtonID = 425,
    text = "按住【二连矢】拖拽到技能栏",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1,
    ButtonID2 = 231,
    isLoop = 0,
    moveTime = 1.5
  },
  [426] = {
    id = 426,
    Explain = "服事一转技能引导【神圣之击】",
    uiID = "SkillView",
    ButtonID = 426,
    text = "按住【神圣之击】拖拽到技能栏",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1,
    ButtonID2 = 231,
    isLoop = 0,
    moveTime = 1.5
  },
  [427] = {
    id = 427,
    Explain = "商人一转技能引导【手推车攻击】",
    uiID = "SkillView",
    ButtonID = 427,
    text = "按住【手推车攻击】拖拽到技能栏",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1,
    ButtonID2 = 231,
    isLoop = 0,
    moveTime = 1.5
  },
  [428] = {
    id = 428,
    Explain = "进阶初心者一转技能引导【狂击】",
    uiID = "SkillView",
    ButtonID = 428,
    text = "按住【狂击】拖拽到技能栏",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1,
    ButtonID2 = 231,
    isLoop = 0,
    moveTime = 1.5
  },
  [429] = {
    id = 429,
    Explain = "忍者一转技能引导【飞镖扔】",
    uiID = "SkillView",
    ButtonID = 429,
    text = "按住【飞镖扔】拖拽到技能栏",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1,
    ButtonID2 = 231,
    isLoop = 0,
    moveTime = 1.5
  },
  [430] = {
    id = 430,
    Explain = "枪手一转技能引导【迅速淋弹】",
    uiID = "SkillView",
    ButtonID = 430,
    text = "按住【迅速淋弹】拖拽到技能栏",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1,
    ButtonID2 = 231,
    isLoop = 0,
    moveTime = 1.5
  },
  [431] = {
    id = 431,
    Explain = "悟灵士一转技能引导【灵魂冲击】",
    uiID = "SkillView",
    ButtonID = 431,
    text = "按住【灵魂冲击】拖拽到技能栏",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1,
    ButtonID2 = 231,
    isLoop = 0,
    moveTime = 1.5
  },
  [432] = {
    id = 432,
    Explain = "跆拳一转技能引导【飞脚踢】",
    uiID = "SkillView",
    ButtonID = 432,
    text = "按住【飞脚踢】拖拽到技能栏",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1,
    ButtonID2 = 231,
    isLoop = 0,
    moveTime = 1.5
  },
  [433] = {
    id = 433,
    Explain = "术士一转技能引导【狠咬】",
    uiID = "SkillView",
    ButtonID = 433,
    text = "按住【狠咬】拖拽到技能栏",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1,
    ButtonID2 = 231,
    isLoop = 0,
    moveTime = 1.5
  },
  [434] = {
    id = 434,
    Explain = "剑士一转技能引导【狂击】",
    uiID = "SkillView",
    ButtonID = 422,
    text = "按住【狂击】拖拽到自动技能栏",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1,
    ButtonID2 = 332,
    isLoop = 0,
    moveTime = 1.5
  },
  [435] = {
    id = 435,
    Explain = "魔法师一转技能引导【圣灵召唤】",
    uiID = "SkillView",
    ButtonID = 423,
    text = "按住【圣灵召唤】拖拽到自动技能栏",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1,
    ButtonID2 = 332,
    isLoop = 0,
    moveTime = 1.5
  },
  [436] = {
    id = 436,
    Explain = "盗贼一转技能引导【强刃击】",
    uiID = "SkillView",
    ButtonID = 424,
    text = "按住【强刃击】拖拽到自动技能栏",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1,
    ButtonID2 = 332,
    isLoop = 0,
    moveTime = 1.5
  },
  [437] = {
    id = 437,
    Explain = "弓箭手一转技能引导【二连矢】",
    uiID = "SkillView",
    ButtonID = 425,
    text = "按住【二连矢】拖拽到自动技能栏",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1,
    ButtonID2 = 332,
    isLoop = 0,
    moveTime = 1.5
  },
  [438] = {
    id = 438,
    Explain = "服事一转技能引导【神圣之击】",
    uiID = "SkillView",
    ButtonID = 426,
    text = "按住【神圣之击】拖拽到自动技能栏",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1,
    ButtonID2 = 332,
    isLoop = 0,
    moveTime = 1.5
  },
  [439] = {
    id = 439,
    Explain = "商人一转技能引导【手推车攻击】",
    uiID = "SkillView",
    ButtonID = 427,
    text = "按住【手推车攻击】拖拽到自动技能栏",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1,
    ButtonID2 = 332,
    isLoop = 0,
    moveTime = 1.5
  },
  [440] = {
    id = 440,
    Explain = "进阶初心者一转技能引导【狂击】",
    uiID = "SkillView",
    ButtonID = 428,
    text = "按住【狂击】拖拽到自动技能栏",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1,
    ButtonID2 = 332,
    isLoop = 0,
    moveTime = 1.5
  },
  [441] = {
    id = 441,
    Explain = "忍者一转技能引导【飞镖扔】",
    uiID = "SkillView",
    ButtonID = 429,
    text = "按住【飞镖扔】拖拽到自动技能栏",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1,
    ButtonID2 = 332,
    isLoop = 0,
    moveTime = 1.5
  },
  [442] = {
    id = 442,
    Explain = "枪手一转技能引导【迅速淋弹】",
    uiID = "SkillView",
    ButtonID = 430,
    text = "按住【迅速淋弹】拖拽到自动技能栏",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1,
    ButtonID2 = 332,
    isLoop = 0,
    moveTime = 1.5
  },
  [443] = {
    id = 443,
    Explain = "悟灵士一转技能引导【灵魂冲击】",
    uiID = "SkillView",
    ButtonID = 431,
    text = "按住【灵魂冲击】拖拽到自动技能栏",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1,
    ButtonID2 = 332,
    isLoop = 0,
    moveTime = 1.5
  },
  [444] = {
    id = 444,
    Explain = "跆拳一转技能引导【飞脚踢】",
    uiID = "SkillView",
    ButtonID = 432,
    text = "按住【飞脚踢】拖拽到自动技能栏",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1,
    ButtonID2 = 332,
    isLoop = 0,
    moveTime = 1.5
  },
  [445] = {
    id = 445,
    Explain = "术士一转技能引导【狠咬】",
    uiID = "SkillView",
    ButtonID = 433,
    text = "按住【狠咬】拖拽到自动技能栏",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1,
    ButtonID2 = 332,
    isLoop = 0,
    moveTime = 1.5
  },
  [446] = {
    id = 446,
    Explain = "秀逗一转技能引导【炎之矢】",
    uiID = "SkillView",
    ButtonID = 446,
    text = "按住【炎之矢】拖拽到技能栏",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1,
    ButtonID2 = 235,
    isLoop = 0,
    moveTime = 1.5
  },
  [447] = {
    id = 447,
    Explain = "龙神丸一转技能引导【龙神丸】",
    uiID = "SkillView",
    ButtonID = 447,
    text = "按住【龙神丸】拖拽到技能栏",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1,
    ButtonID2 = 235,
    isLoop = 0,
    moveTime = 1.5
  },
  [448] = {
    id = 448,
    Explain = "火焰神一转技能引导【双炎斩】",
    uiID = "SkillView",
    ButtonID = 448,
    text = "按住【双炎斩】拖拽到技能栏",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1,
    ButtonID2 = 235,
    isLoop = 0,
    moveTime = 1.5
  },
  [450] = {
    id = 450,
    Explain = "任务栏引导",
    ButtonID = 450,
    position = Table_GuideID_bk_t.position[35],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [451] = {
    id = 451,
    Explain = "任务追踪GO",
    Preguide = 450,
    ButtonID = 451,
    position = Table_GuideID_bk_t.position[36],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [452] = {
    id = 452,
    Explain = "使用重击",
    ButtonID = 132,
    press = 1
  },
  [453] = {
    id = 453,
    Explain = "使用自动攻击",
    ButtonID = 150,
    text = "在列表中选取绿棉虫。",
    position = Table_GuideID_bk_t.position[14],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [454] = {
    id = 454,
    Explain = "使用装死",
    ButtonID = 133,
    text = "装死能帮你免受部分怪物的攻击，是回复hp和sp的重要技能。",
    position = Table_GuideID_bk_t.position[11],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [455] = {
    id = 455,
    Explain = "使用紧急治疗",
    ButtonID = 134,
    text = "使用紧急治疗恢复生命值",
    position = Table_GuideID_bk_t.position[11],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [456] = {
    id = 456,
    Explain = "战斗时常（打开更多界面）",
    ButtonID = 102,
    press = 1
  },
  [457] = {
    id = 457,
    Explain = "点击设置按钮",
    Preguide = 40,
    ButtonID = 457,
    press = 1,
    FailJump = 1
  },
  [458] = {
    id = 458,
    Explain = "查看游戏设置界面战斗时长",
    Preguide = 457,
    uiID = "SetView",
    text = "每天的战斗时长可以在这里查看哦",
    position = Table_GuideID_bk_t.position[37],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1,
    FailJump = 1,
    hollows = Table_GuideID_bk_t.hollows[25],
    IsJump = 1
  },
  [459] = {
    id = 459,
    Explain = "点击成就切页",
    Preguide = 41,
    uiID = "AdventurePanel",
    ButtonID = 459,
    press = 1,
    FailJump = 1,
    IsJump = 1
  },
  [460] = {
    id = 460,
    Explain = "最近完成成就第一个+",
    Preguide = 459,
    uiID = "AdventurePanel",
    ButtonID = 460,
    EffectPos = Table_GuideID_bk_t.EffectPos[4],
    press = 1,
    FailJump = 0
  },
  [461] = {
    id = 461,
    Explain = "属性界面“-”",
    optionId = 4,
    uiID = "Charactor",
    ButtonID = 461,
    press = 1,
    FailJump = 1
  },
  [462] = {
    id = 462,
    Explain = "属性-加点方案-教学1",
    Preguide = 3,
    uiID = "Charactor",
    ButtonID = 462,
    press = 1,
    FailJump = 1
  },
  [463] = {
    id = 463,
    Explain = "自动战斗“设置”",
    Preguide = 473,
    ButtonID = 463,
    press = 1,
    FailJump = 1
  },
  [464] = {
    id = 464,
    Explain = "自动战斗“绿棉虫”10003",
    Preguide = 453,
    ButtonID = 464,
    press = 1,
    FailJump = 1
  },
  [465] = {
    id = 465,
    Explain = "自动服药勾选",
    Preguide = 463,
    ButtonID = 465,
    press = 1,
    FailJump = 1
  },
  [466] = {
    id = 466,
    Explain = "自动服药快速添加",
    Preguide = 465,
    ButtonID = 466,
    press = 1,
    FailJump = 1
  },
  [467] = {
    id = 467,
    Explain = "自动服药关闭",
    Preguide = 466,
    ButtonID = 467,
    press = 1,
    FailJump = 1
  },
  [468] = {
    id = 468,
    Explain = "好友引导",
    Preguide = 40,
    ButtonID = 468,
    press = 1,
    FailJump = 1
  },
  [469] = {
    id = 469,
    Explain = "好友搜索框",
    Preguide = 468,
    press = 1,
    FailJump = 1
  },
  [470] = {
    id = 470,
    Explain = "点击角色界面中的关闭界面按钮×",
    Preguide = 469,
    uiID = "Charactor",
    ButtonID = 8,
    press = 1,
    FailJump = 1,
    IsJump = 1
  },
  [471] = {
    id = 471,
    Explain = "加点方案推荐",
    Preguide = 462,
    uiID = "Charactor",
    ButtonID = 471,
    text = "点击框框内加点方案，对剩余点数进行自动分配哦",
    position = Table_GuideID_bk_t.position[38],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1,
    FailJump = 1,
    hollows = Table_GuideID_bk_t.hollows[26]
  },
  [472] = {
    id = 472,
    Explain = "属性-加点方案-一转后教学2",
    Preguide = 2,
    ButtonID = 462,
    press = 1,
    IsJump = 1
  },
  [473] = {
    id = 473,
    Explain = "使用自动攻击",
    ButtonID = 150,
    position = Table_GuideID_bk_t.position[14],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [474] = {
    id = 474,
    Explain = "\"使用红色药水可以恢复部分Hp\"",
    ButtonID = 141,
    text = "使用红色药水可以恢复部分Hp",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [475] = {
    id = 475,
    Explain = "点击游戏设置界面关闭按钮×",
    uiID = "Charactor",
    ButtonID = 475,
    press = 1
  },
  [476] = {
    id = 476,
    Explain = "点击进入心之始源",
    ButtonID = 476,
    press = 1
  },
  [477] = {
    id = 477,
    Explain = "点击使用心之始源",
    Preguide = 476,
    uiID = "PackageView",
    ButtonID = 477,
    press = 1
  },
  [478] = {
    id = 478,
    Explain = "添加重击到技能栏",
    uiID = "SkillView",
    ButtonID = 478,
    text = "按住【重击】拖拽到技能栏",
    position = Table_GuideID_bk_t.position[39],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1,
    IsJump = 1,
    ButtonID2 = 232,
    isLoop = 0,
    moveTime = 1
  },
  [479] = {
    id = 479,
    Explain = "点击技能界面上的返回按钮",
    Preguide = 478,
    uiID = "SkillView",
    ButtonID = 31,
    press = 1
  },
  [480] = {
    id = 480,
    Explain = "科技树-长按【注入】按钮注入能量",
    uiID = "NewbieTechTreeContainerView",
    ButtonID = 480,
    text = "长按【注入】按钮增加能量",
    position = Table_GuideID_bk_t.position[40],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1,
    IsJump = 1
  },
  [481] = {
    id = 481,
    Explain = "科技树-点击左上角按钮领打开奖励界面",
    uiID = "NewbieTechTreeContainerView",
    ButtonID = 481,
    press = 1
  },
  [482] = {
    id = 482,
    Explain = "科技树-点击获取奖励",
    uiID = "NewbieTechTreeContainerView",
    ButtonID = 482,
    press = 1
  },
  [483] = {
    id = 483,
    Explain = "科技树-关闭按钮",
    Preguide = 480,
    uiID = "NewbieTechTreeContainerView",
    ButtonID = 483,
    press = 1
  },
  [484] = {
    id = 484,
    Explain = "秀逗一转技能引导【炎之矢】",
    uiID = "SkillView",
    ButtonID = 446,
    text = "按住【炎之矢】拖拽到自动技能栏",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1,
    ButtonID2 = 335,
    isLoop = 0,
    moveTime = 1
  },
  [485] = {
    id = 485,
    Explain = "龙神丸一转技能引导【龙神丸】",
    uiID = "SkillView",
    ButtonID = 447,
    text = "按住【龙神丸】拖拽到自动技能栏",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1,
    ButtonID2 = 335,
    isLoop = 0,
    moveTime = 1
  },
  [486] = {
    id = 486,
    Explain = "火焰神一转技能引导【双炎斩】",
    uiID = "SkillView",
    ButtonID = 448,
    text = "按住【双炎斩】拖拽到自动技能栏",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1,
    ButtonID2 = 335,
    isLoop = 0,
    moveTime = 1
  },
  [487] = {
    id = 487,
    Explain = "执事界面引导",
    uiID = ""
  },
  [488] = {
    id = 488,
    Explain = "心之始源引导“如何获得”",
    uiID = "NewbieTechTreeContainerView",
    ButtonID = 488,
    EffectPos = Table_GuideID_bk_t.EffectPos[5],
    text = "心之刹那还不够哦，让我们看看怎么获取吧！",
    position = Table_GuideID_bk_t.position[40],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1,
    EffectAnchor = 5
  },
  [489] = {
    id = 489,
    Explain = "副本挑战引导",
    Preguide = 1014,
    uiID = "PveView",
    ButtonID = 489,
    text = "挑战成功可获得大量奖励",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1,
    ServerEvent = "ServiceEvent_FuBenCmdSyncPvePassInfoFubenCmd"
  },
  [490] = {
    id = 490,
    Explain = "波利帽图纸",
    Preguide = 65,
    uiID = "PackageView",
    ButtonID = 490,
    press = 1
  },
  [491] = {
    id = 491,
    Explain = "蛋壳帽图纸",
    Preguide = 65,
    uiID = "PackageView",
    ButtonID = 491,
    press = 1
  },
  [492] = {
    id = 492,
    Explain = "点击包裹中图纸的制作按钮",
    uiID = "PicMakeCell",
    ButtonID = 202,
    press = 1,
    FailJump = 1
  },
  [493] = {
    id = 493,
    Explain = "副本挑战假引导",
    Preguide = 1014,
    uiID = "PveView",
    ButtonID = 493,
    text = "挑战成功可获得大量奖励",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1,
    ServerEvent = "ServiceEvent_FuBenCmdSyncPvePassInfoFubenCmd"
  },
  [494] = {
    id = 494,
    Explain = "首次0任务点击界面",
    ButtonID = 494,
    press = 1
  },
  [504] = {
    id = 504,
    Explain = "主界面神树UI",
    ButtonID = 504,
    text = "可在此处快速打开神树之灵界面",
    position = Table_GuideID_bk_t.position[20],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [505] = {
    id = 505,
    Explain = "神树节点引导2",
    Preguide = 513,
    uiID = "TechTreeContainerView",
    ButtonID = 505,
    press = 1
  },
  [506] = {
    id = 506,
    Explain = "神树节点引导3",
    Preguide = 505,
    uiID = "TechTreeContainerView",
    ButtonID = 506,
    press = 1
  },
  [507] = {
    id = 507,
    Explain = "神树节点引导4",
    Preguide = 506,
    uiID = "TechTreeContainerView",
    ButtonID = 507,
    press = 1
  },
  [508] = {
    id = 508,
    Explain = "神树节点引导5",
    Preguide = 507,
    uiID = "TechTreeContainerView",
    ButtonID = 508,
    press = 1
  },
  [509] = {
    id = 509,
    Explain = "学院扭蛋机引导",
    Preguide = 510,
    uiID = "LotteryDollView",
    ButtonID = 509,
    press = 1
  },
  [510] = {
    id = 510,
    Explain = "学院扭蛋机引导对话",
    uiID = "DialogView",
    ButtonID = 510,
    press = 1
  },
  [511] = {
    id = 511,
    Explain = "陆行鸟坐骑装备引导",
    ButtonID = 141,
    text = "点击装备坐骑。",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [512] = {
    id = 512,
    Explain = "世界任务图标教学",
    text = "蓝色图标的就是冒险任务~",
    position = Table_GuideID_bk_t.position[41],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 0,
    hollows = Table_GuideID_bk_t.hollows[29]
  },
  [513] = {
    id = 513,
    Explain = "神树之灵选项",
    uiID = "DialogView",
    ButtonID = 513,
    press = 1
  },
  [514] = {
    id = 514,
    Explain = "世界任务文字引导",
    ButtonID = 514,
    EffectPos = Table_GuideID_bk_t.EffectPos[3],
    position = Table_GuideID_bk_t.position[24],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 0
  },
  [515] = {
    id = 515,
    Explain = "执事icon引导",
    ButtonID = 515,
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [516] = {
    id = 516,
    Explain = "执事立绘引导",
    Preguide = 515,
    uiID = "ChooseServantView",
    text = "选择一名心仪的执事为您服务哟！",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 0,
    IsJump = 1
  },
  [517] = {
    id = 517,
    Explain = "推荐加点引导",
    uiID = "SkillView",
    text = "如果是新手玩家，也可以尝试推荐加点。",
    position = Table_GuideID_bk_t.position[3],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1,
    hollows = Table_GuideID_bk_t.hollows[1]
  },
  [518] = {
    id = 518,
    Explain = "推荐加点引导",
    Preguide = 313,
    uiID = "SkillView",
    text = "如果是新手玩家，也可以尝试推荐加点。",
    position = Table_GuideID_bk_t.position[3],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1,
    hollows = Table_GuideID_bk_t.hollows[1]
  },
  [519] = {
    id = 519,
    Explain = "执事立绘引导",
    Preguide = 516,
    uiID = "ChooseServantView",
    ButtonID = 519,
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [520] = {
    id = 520,
    Explain = "日常执事界面引导",
    uiID = "ServantNewMainView",
    ButtonID = 520,
    EffectPos = Table_GuideID_bk_t.EffectPos[1],
    text = "这是为你精心挑选的每日挑战，完成这些可以领到丰厚奖励！",
    press = 1,
    IsJump = 1
  },
  [521] = {
    id = 521,
    Explain = "感知技能引导",
    uiID = "SkillView",
    ButtonID = 521,
    text = "将【感知】拖拽到手动技能栏",
    position = Table_GuideID_bk_t.position[21],
    press = 1
  },
  [522] = {
    id = 522,
    Explain = "点击进入裁决魔典",
    ButtonID = 522,
    press = 1
  },
  [523] = {
    id = 523,
    Explain = "点击此处可选择是否成为幸运冒险家",
    Preguide = 522,
    uiID = "WildMvpView",
    ButtonID = 523,
    text = "点击此处可选择是否成为幸运冒险家",
    position = Table_GuideID_bk_t.position[25],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 0,
    hollows = Table_GuideID_bk_t.hollows[21],
    IsJump = 1
  },
  [524] = {
    id = 524,
    Explain = "家具商店选项引导",
    ButtonID = 524,
    press = 1
  },
  [525] = {
    id = 525,
    Explain = "选择高原坚木",
    uiID = "PrestigeShopView",
    ButtonID = 525,
    press = 1
  },
  [526] = {
    id = 526,
    Explain = "选择九界原石",
    uiID = "PrestigeShopView",
    ButtonID = 526,
    press = 1
  },
  [528] = {
    id = 528,
    Explain = "乌龟学者换壳引导",
    ButtonID = 528,
    press = 1
  },
  [529] = {
    id = 529,
    Explain = "选乌龟壳",
    uiID = "MountDressingView",
    text = "选择喜欢的龟甲进行装备",
    position = Table_GuideID_bk_t.position[5],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1,
    hollows = Table_GuideID_bk_t.hollows[2],
    IsJump = 1
  },
  [530] = {
    id = 530,
    Explain = "更换乌龟壳",
    uiID = "MountDressingView",
    ButtonID = 530,
    press = 1
  },
  [531] = {
    id = 531,
    Explain = "影子装备选项引导",
    ButtonID = 531,
    press = 1
  },
  [532] = {
    id = 532,
    Explain = "选择需要淬炼的装备+",
    uiID = "EquipQuenchView",
    ButtonID = 532,
    press = 1,
    IsJump = 1
  },
  [533] = {
    id = 533,
    Explain = "选取装备",
    uiID = "EquipQuenchView",
    ButtonID = 533,
    press = 1
  },
  [534] = {
    id = 534,
    Explain = "淬炼选项",
    uiID = "EquipQuenchView",
    ButtonID = 534,
    press = 1
  },
  [535] = {
    id = 535,
    Explain = "选乌龟壳页签",
    uiID = "MountDressingView",
    ButtonID = 535,
    press = 1
  },
  [536] = {
    id = 536,
    Explain = "装备页签1",
    Preguide = 65,
    uiID = "PackageView",
    ButtonID = 536,
    press = 1,
    IsJump = 1
  },
  [537] = {
    id = 537,
    Explain = "点击灌注装备【陈旧的海利翁手环】",
    uiID = "PackageView",
    ButtonID = 537,
    EffectPos = Table_GuideID_bk_t.EffectPos[2],
    text = "穿上忽克连的灌注装备，测试下战斗力吧！",
    position = Table_GuideID_bk_t.position[6],
    rotation = Table_GuideID_bk_t.rotation[3],
    press = 1
  },
  [538] = {
    id = 538,
    Explain = "点击装备按钮【陈旧的海利翁手环】",
    uiID = "PackageView",
    ButtonID = 202,
    press = 1
  },
  [539] = {
    id = 539,
    Explain = "装备页签2",
    Preguide = 65,
    uiID = "PackageView",
    ButtonID = 539,
    text = "点击切换到影子装备专属的装备栏吧！",
    position = Table_GuideID_bk_t.position[7],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1,
    IsJump = 1
  },
  [540] = {
    id = 540,
    Explain = "点击远古装备【陈旧的天神的启示】",
    uiID = "PackageView",
    ButtonID = 540,
    EffectPos = Table_GuideID_bk_t.EffectPos[2],
    text = "把影子装备穿戴到影子装备栏，加持忽克连的灌注装备吧！",
    position = Table_GuideID_bk_t.position[6],
    rotation = Table_GuideID_bk_t.rotation[3],
    press = 1
  },
  [541] = {
    id = 541,
    Explain = "点击装备按钮【陈旧的天神的启示】",
    uiID = "PackageView",
    ButtonID = 202,
    press = 1
  },
  [542] = {
    id = 542,
    Explain = "冒险手册魔物界面说明",
    Preguide = 42,
    uiID = "AdventurePanel",
    ButtonID = 542,
    text = "击败魔物或给魔物拍照可以点亮魔物图鉴哟！",
    position = Table_GuideID_bk_t.position[8],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1,
    hollows = Table_GuideID_bk_t.hollows[3]
  },
  [543] = {
    id = 543,
    Explain = "冒险手册卡片界面说明",
    Preguide = 48,
    uiID = "AdventurePanel",
    ButtonID = 543,
    text = "点亮您获得的卡片，存入卡片可以增加人物属性哦！",
    position = Table_GuideID_bk_t.position[8],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1,
    hollows = Table_GuideID_bk_t.hollows[3]
  },
  [544] = {
    id = 544,
    Explain = "冒险手册关闭按钮",
    uiID = "AdventurePanel",
    ButtonID = 544,
    press = 1,
    FailJump = 1
  },
  [545] = {
    id = 545,
    Explain = "点击打开装备升级界面",
    ButtonID = 545,
    press = 1
  },
  [546] = {
    id = 546,
    Explain = "引导点击装备选项栏+号",
    uiID = "EquipUpgradeView",
    ButtonID = 546,
    press = 1,
    IsJump = 1
  },
  [547] = {
    id = 547,
    Explain = "点击左侧装备选取（第一件）",
    uiID = "EquipUpgradeView",
    ButtonID = 547,
    press = 1
  },
  [548] = {
    id = 548,
    Explain = "点击装备升级",
    uiID = "EquipUpgradeView",
    ButtonID = 548,
    press = 1
  },
  [549] = {
    id = 549,
    Explain = "装备升级关闭界面按钮×",
    uiID = "EquipUpgradeView",
    ButtonID = 549,
    press = 1
  },
  [1001] = {
    id = 1001,
    Explain = "强化功能引导（点击进入包包）",
    ButtonID = 103,
    press = 1,
    SpecialID = 5501
  },
  [1002] = {
    id = 1002,
    Explain = "强化功能引导(点击打开强化界面）",
    Preguide = 1001,
    uiID = "PackageView",
    ButtonID = 35,
    press = 1,
    SpecialID = 7,
    IsJump = 1
  },
  [1003] = {
    id = 1003,
    Explain = "强化功能引导（点击武器栏）",
    Preguide = 1002,
    uiID = "Bag",
    ButtonID = 1003,
    text = "点击要强化的部位",
    position = Table_GuideID_bk_t.position[27],
    rotation = Table_GuideID_bk_t.rotation[3],
    press = 1
  },
  [1004] = {
    id = 1004,
    Explain = "强化功能引导（点击强化按钮）",
    Preguide = 1003,
    uiID = "Bag",
    ButtonID = 1004,
    press = 1
  },
  [1005] = {
    id = 1005,
    Explain = "强化功能引导（点击饰品栏）",
    Preguide = 1039,
    uiID = "Bag",
    ButtonID = 1005,
    text = "点击要强化的部位",
    position = Table_GuideID_bk_t.position[26],
    rotation = Table_GuideID_bk_t.rotation[3],
    press = 1
  },
  [1006] = {
    id = 1006,
    Explain = "公会功能引导（打开更多界面）",
    ButtonID = 102,
    press = 1
  },
  [1007] = {
    id = 1007,
    Explain = "公会功能引导（点击公会界面）",
    Preguide = 1006,
    ButtonID = 1007,
    press = 1
  },
  [1008] = {
    id = 1008,
    Explain = "技能引导（技能按钮）",
    Preguide = 1006,
    ButtonID = 205,
    press = 1
  },
  [1009] = {
    id = 1009,
    Explain = "技能引导（点击四转）",
    Preguide = 1008,
    uiID = "SkillView",
    ButtonID = 1009,
    press = 1,
    IsJump = 1
  },
  [1010] = {
    id = 1010,
    Explain = "技能引导（文本显示,type=7）",
    Preguide = 1009,
    uiID = "SkillView",
    text = "升级四转技能",
    position = Table_GuideID_bk_t.position[22],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 0,
    hollows = Table_GuideID_bk_t.hollows[27]
  },
  [1011] = {
    id = 1011,
    Explain = "阿萨神碑引导（找到背包中的神碑）",
    Preguide = 1001,
    uiID = "PackageView",
    ButtonID = 1011,
    press = 1,
    IsJump = 1
  },
  [1012] = {
    id = 1012,
    Explain = "阿萨神碑引导（使用道具）",
    Preguide = 1011,
    uiID = "PackageView",
    ButtonID = 202,
    press = 1
  },
  [1013] = {
    id = 1013,
    Explain = "阿萨神碑引导（文本显示,type=7）",
    Preguide = 1012,
    uiID = "AstrolabeView",
    text = "特殊卢恩符文即为需要消耗金质勋章的符文",
    position = Table_GuideID_bk_t.position[22],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 0,
    hollows = Table_GuideID_bk_t.hollows[28],
    IsJump = 1
  },
  [1014] = {
    id = 1014,
    Explain = "副本引导（副本按钮）",
    Preguide = 1006,
    ButtonID = 1014,
    press = 1
  },
  [1015] = {
    id = 1015,
    Explain = "副本引导（无限塔）",
    Preguide = 1014,
    uiID = "PveView",
    ButtonID = 1015,
    press = 1,
    SpecialID = 5,
    IsJump = 1
  },
  [1016] = {
    id = 1016,
    Explain = "副本引导（无限塔难度选择）",
    Preguide = 1015,
    uiID = "PveView",
    text = "选择开始的层数",
    position = Table_GuideID_bk_t.position[23],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1,
    hollows = Table_GuideID_bk_t.hollows[19]
  },
  [1017] = {
    id = 1017,
    Explain = "副本引导（蛋糕保卫）",
    Preguide = 1014,
    uiID = "PveView",
    ButtonID = 1017,
    press = 1,
    SpecialID = 3,
    IsJump = 1
  },
  [1018] = {
    id = 1018,
    Explain = "副本引导（神谕）",
    Preguide = 1014,
    uiID = "PveView",
    ButtonID = 1018,
    press = 1,
    SpecialID = 4,
    IsJump = 1
  },
  [1019] = {
    id = 1019,
    Explain = "副本引导（神谕难度选择）",
    Preguide = 1018,
    uiID = "PveView",
    text = "选择要挑战的难度",
    position = Table_GuideID_bk_t.position[23],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1,
    hollows = Table_GuideID_bk_t.hollows[19]
  },
  [1020] = {
    id = 1020,
    Explain = "副本引导（蛋糕保卫）",
    Preguide = 1014,
    uiID = "PveView",
    ButtonID = 1020,
    press = 1,
    SpecialID = 7,
    IsJump = 1
  },
  [1021] = {
    id = 1021,
    Explain = "副本引导（亡者）",
    Preguide = 1014,
    uiID = "PveView",
    ButtonID = 1021,
    press = 1,
    SpecialID = 6,
    IsJump = 1
  },
  [1022] = {
    id = 1022,
    Explain = "副本引导（神树保卫）",
    Preguide = 1014,
    uiID = "PveView",
    ButtonID = 1022,
    press = 1,
    SpecialID = 14,
    IsJump = 1
  },
  [1023] = {
    id = 1023,
    Explain = "副本引导（神树难度选择）",
    Preguide = 1022,
    uiID = "PveView",
    text = "选择要挑战的难度",
    position = Table_GuideID_bk_t.position[23],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1,
    hollows = Table_GuideID_bk_t.hollows[19]
  },
  [1024] = {
    id = 1024,
    Explain = "副本引导（再见故友）",
    Preguide = 1014,
    uiID = "PveView",
    ButtonID = 1024,
    press = 1,
    SpecialID = 15,
    IsJump = 1
  },
  [1025] = {
    id = 1025,
    Explain = "副本引导（故友难度选择）",
    Preguide = 1024,
    uiID = "PveView",
    text = "选择要挑战的难度",
    position = Table_GuideID_bk_t.position[23],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1,
    hollows = Table_GuideID_bk_t.hollows[19]
  },
  [1026] = {
    id = 1026,
    Explain = "副本引导（回廊）",
    Preguide = 1014,
    uiID = "PveView",
    ButtonID = 1026,
    press = 1,
    SpecialID = 8,
    IsJump = 1
  },
  [1027] = {
    id = 1027,
    Explain = "副本引导（回廊难度选择）",
    Preguide = 1026,
    uiID = "PveView",
    text = "选择要挑战的难度",
    position = Table_GuideID_bk_t.position[23],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1,
    hollows = Table_GuideID_bk_t.hollows[19]
  },
  [1028] = {
    id = 1028,
    Explain = "副本引导（神树难度三星）",
    Preguide = 1022,
    uiID = "PveView",
    ButtonID = 1028,
    press = 1
  },
  [1029] = {
    id = 1029,
    Explain = "副本引导（彼岸决战）",
    Preguide = 1014,
    uiID = "PveView",
    ButtonID = 1029,
    press = 1,
    SpecialID = 16,
    IsJump = 1
  },
  [1030] = {
    id = 1030,
    Explain = "副本引导（彼岸决战三星）",
    Preguide = 1029,
    uiID = "PveView",
    ButtonID = 1028,
    press = 1
  },
  [1031] = {
    id = 1031,
    Explain = "符文引导（打开符文之匣）",
    Preguide = 1038,
    uiID = "PackageView",
    ButtonID = 1031,
    press = 1,
    SpecialID = 5670
  },
  [1032] = {
    id = 1032,
    Explain = "符文引导（使用道具）",
    Preguide = 1031,
    uiID = "PackageView",
    ButtonID = 202,
    press = 1
  },
  [1033] = {
    id = 1033,
    Explain = "符文引导（文本显示,type=7）",
    Preguide = 1032,
    uiID = "GemContainerView",
    text = "点击任意空栏位即可镶嵌符文",
    position = Table_GuideID_bk_t.position[22],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 0,
    hollows = Table_GuideID_bk_t.hollows[20]
  },
  [1034] = {
    id = 1034,
    Explain = "副本引导（神树难度三星）",
    Preguide = 1024,
    uiID = "PveView",
    ButtonID = 1028,
    press = 1
  },
  [1035] = {
    id = 1035,
    Explain = "副本引导（博物岛）",
    Preguide = 1014,
    uiID = "PveView",
    ButtonID = 1035,
    press = 1,
    SpecialID = 1,
    IsJump = 1
  },
  [1036] = {
    id = 1036,
    Explain = "副本引导（博物岛难度选择）",
    Preguide = 1035,
    uiID = "PveView",
    text = "选择要挑战的难度",
    position = Table_GuideID_bk_t.position[23],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1,
    hollows = Table_GuideID_bk_t.hollows[19]
  },
  [1037] = {
    id = 1037,
    Explain = "强化功能引导（点击强化按钮）",
    Preguide = 1005,
    uiID = "Bag",
    ButtonID = 1004,
    press = 1
  },
  [1038] = {
    id = 1038,
    Explain = "强化功能引导（点击进入包包）",
    ButtonID = 103,
    press = 1,
    SpecialID = 5670
  },
  [1039] = {
    id = 1039,
    Explain = "强化功能引导(点击打开强化界面）",
    Preguide = 1001,
    uiID = "PackageView",
    ButtonID = 35,
    press = 1,
    SpecialID = 5,
    IsJump = 1
  },
  [1100] = {
    id = 1100,
    Explain = "新手教学治愈术",
    ButtonID = 132,
    text = "使用【治愈术】来治疗同伴",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  },
  [1101] = {
    id = 1101,
    Explain = "新手教学复活术",
    ButtonID = 134,
    text = "【复活术】可将阵亡的同伴复活",
    position = Table_GuideID_bk_t.position[1],
    rotation = Table_GuideID_bk_t.rotation[1],
    press = 1
  }
}
local cell_mt = {
  __index = {
    EffectPos = _EmptyTable,
    Explain = "学院技能引导",
    ServerEvent = "",
    hollows = _EmptyTable,
    id = 1,
    offset = _EmptyTable,
    position = _EmptyTable,
    rotation = _EmptyTable,
    text = "",
    uiID = "MainView"
  }
}
for _, d in pairs(Table_GuideID_bk) do
  setmetatable(d, cell_mt)
end
