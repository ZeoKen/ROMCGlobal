Table_GuideUI = {
  [1] = {
    id = 1,
    GroupID = 1,
    MainTitle = "等级需达到%s级，可通过以下方式获取经验",
    Text = "裂隙",
    Desc = "通关裂隙副本可获取大量经验",
    Icon = "MapRaid",
    Shortcutpower = {8201},
    complete_con = "BattleTime",
    Params = _EmptyTable
  },
  [2] = {
    id = 2,
    GroupID = 1,
    MainTitle = "等级需达到%s级，可通过以下方式获取经验",
    Text = "委托看板",
    Desc = "每天完成3个委托看板可获取中额经验",
    Icon = "Wanted",
    Shortcutpower = _EmptyTable,
    complete_con = "Wanted",
    Params = _EmptyTable,
    Sysmsg = 43442
  },
  [3] = {
    id = 3,
    GroupID = 1,
    MainTitle = "等级需达到%s级，可通过以下方式获取经验",
    Text = "任务",
    Desc = "完成支线任务可获取少量经验",
    Icon = "RiskBook",
    Shortcutpower = {8312},
    complete_con = "Quest",
    Params = _EmptyTable
  },
  [4] = {
    id = 4,
    GroupID = 1,
    MainTitle = "等级需达到%s级，可通过以下方式获取经验",
    Text = "野外练级",
    Desc = "击杀等级相当的魔物获取经验",
    Icon = "pet_equip_3",
    Shortcutpower = _EmptyTable,
    complete_con = "Teleport",
    Params = _EmptyTable
  },
  [5] = {
    id = 5,
    GroupID = 2,
    MainTitle = "骑士勋级需达到%s级，可通过以下方式提升",
    Text = "骑士任务",
    Desc = "完成地图上骑士任务{mapicon=map_icon_qishi1}可获取大量声望",
    Icon = "xunshoudui",
    Shortcutpower = {8325},
    complete_con = "PrestigeQuest",
    Params = {mapid = 149},
    Sysmsg = 43461
  },
  [6] = {
    id = 6,
    GroupID = 2,
    MainTitle = "骑士勋级需达到%s级，可通过以下方式提升",
    Text = "每日冒险",
    Desc = "每日完成地图上4个冒险任务{mapicon=main_icon_World-mission}可获取大量声望",
    Icon = "DispatchComplete",
    Shortcutpower = {8322},
    complete_con = "WorldQuest",
    Params = {mapid = 149},
    Sysmsg = 43462
  },
  [7] = {
    id = 7,
    GroupID = 2,
    MainTitle = "骑士勋级需达到%s级，可通过以下方式提升",
    Text = "魔物营地",
    Desc = "扫荡地图上魔物营地{mapicon=map_icon_jingying02}可获取中量声望",
    Icon = "mvp_dead_100",
    Shortcutpower = {8327},
    complete_con = "WildMvp",
    Params = {
      mapid = 149,
      type = {1, 2}
    },
    Sysmsg = 43463
  },
  [8] = {
    id = 8,
    GroupID = 2,
    MainTitle = "骑士勋级需达到%s级，可通过以下方式提升",
    Text = "地图事件",
    Desc = "探索地区内的隐藏玩法可获得声望",
    Icon = "ManorBuildType_17",
    Shortcutpower = {8321},
    complete_con = "",
    Params = {mapid = 149, msgid = 43459},
    Sysmsg = 43464
  },
  [9] = {
    id = 9,
    GroupID = 3,
    MainTitle = "收集装备升级所需材料",
    Text = "野外打怪",
    Desc = "击杀疯兔获得柔毛",
    Icon = "fengtu",
    Shortcutpower = {5002},
    complete_con = "",
    Params = _EmptyTable
  },
  [10] = {
    id = 10,
    GroupID = 3,
    MainTitle = "收集装备升级所需材料",
    Text = "野外打怪",
    Desc = "击杀波利获得杰勒比结晶",
    Icon = "Hydra",
    Shortcutpower = {5002},
    complete_con = "",
    Params = _EmptyTable
  },
  [11] = {
    id = 11,
    GroupID = 3,
    MainTitle = "收集装备升级所需材料",
    Text = "裂隙",
    Desc = "通关【虎王的咆哮】副本可获取大量材料",
    Icon = "MapRaid",
    Shortcutpower = {8191},
    complete_con = "",
    Params = {}
  },
  [12] = {
    id = 12,
    GroupID = 4,
    MainTitle = "收集装备升级所需材料",
    Text = "野外打怪",
    Desc = "击杀吸血蝙蝠获得腐烂绷带",
    Icon = "Farmiliar",
    Shortcutpower = {5003},
    complete_con = "",
    Params = _EmptyTable
  },
  [13] = {
    id = 13,
    GroupID = 4,
    MainTitle = "收集装备升级所需材料",
    Text = "野外打怪",
    Desc = "击杀水母获得加勒结晶",
    Icon = "Marina",
    Shortcutpower = {5011},
    complete_con = "",
    Params = _EmptyTable
  },
  [14] = {
    id = 14,
    GroupID = 4,
    MainTitle = "收集装备升级所需材料",
    Text = "裂隙",
    Desc = "通关【虎王的咆哮】勇士难度获取腐烂绷带",
    Icon = "MapRaid",
    Shortcutpower = {8191},
    complete_con = "",
    Params = {}
  },
  [15] = {
    id = 15,
    GroupID = 4,
    MainTitle = "收集装备升级所需材料",
    Text = "裂隙",
    Desc = "通关【海神的风暴】获取加勒结晶",
    Icon = "MapRaid",
    Shortcutpower = {8195},
    complete_con = "",
    Params = {}
  },
  [16] = {
    id = 16,
    GroupID = 5,
    MainTitle = "收集装备升级所需材料",
    Text = "野外打怪",
    Desc = "击杀哥布灵获得粘稠液体",
    Icon = "Goblin",
    Shortcutpower = {5033},
    complete_con = "",
    Params = _EmptyTable
  },
  [17] = {
    id = 17,
    GroupID = 5,
    MainTitle = "收集装备升级所需材料",
    Text = "野外打怪",
    Desc = "击杀噬人花获得亡者遗物",
    Icon = "flora",
    Shortcutpower = {5014},
    complete_con = "",
    Params = _EmptyTable
  },
  [18] = {
    id = 18,
    GroupID = 5,
    MainTitle = "收集装备升级所需材料",
    Text = "裂隙",
    Desc = "通关【海神的风暴】勇士难度可获取大量材料",
    Icon = "MapRaid",
    Shortcutpower = {8195},
    complete_con = "",
    Params = _EmptyTable
  },
  [20] = {
    id = 20,
    GroupID = 6,
    MainTitle = "收集装备升级所需材料",
    Text = "混沌入侵",
    Desc = "击杀【混沌入侵】MINI狸猫可获取变身叶子",
    Icon = "MapRaid",
    Shortcutpower = {8254},
    complete_con = "",
    Params = _EmptyTable
  },
  [21] = {
    id = 21,
    GroupID = 6,
    MainTitle = "收集装备升级所需材料",
    Text = "装备分解",
    Desc = "分解无用装备获取辉光金属",
    Icon = "Waste_Stove",
    Shortcutpower = {20},
    complete_con = "",
    Params = _EmptyTable
  },
  [28] = {
    id = 28,
    GroupID = 8,
    MainTitle = "获取苍翼卫声望，提升苍翼卫等级",
    Text = "每日冒险",
    Desc = "每日前往深渊之湖法芙娜处完成苍翼卫任务可获取大量声望",
    Icon = "DispatchComplete",
    Shortcutpower = {8358},
    complete_con = "WorldQuest",
    Params = {mapid = 154},
    Sysmsg = 43462
  },
  [29] = {
    id = 29,
    GroupID = 8,
    MainTitle = "获取苍翼卫声望，提升苍翼卫等级",
    Text = "魔物营地",
    Desc = "首通地图上的魔物营地{mapicon=map_icon_jingying02}可获取声望，还可获取声望货币",
    Icon = "mvp_dead_100",
    Shortcutpower = {8359},
    complete_con = "WildMvp",
    Params = {
      mapid = 154,
      type = {1, 2}
    },
    Sysmsg = 43463
  },
  [30] = {
    id = 30,
    GroupID = 9,
    MainTitle = "获取赤鳞团声望，提升赤鳞团等级",
    Text = "每日冒险",
    Desc = "每日前往深渊之湖梅德处完成赤鳞团任务可获取大量声望",
    Icon = "DispatchComplete",
    Shortcutpower = {8367},
    complete_con = "WorldQuest",
    Params = {mapid = 154},
    Sysmsg = 43462
  },
  [31] = {
    id = 31,
    GroupID = 9,
    MainTitle = "获取赤鳞团声望，提升赤鳞团等级",
    Text = "魔物营地",
    Desc = "首通地图上的魔物营地{mapicon=map_icon_jingying02}可获取声望，还可获取声望货币",
    Icon = "mvp_dead_100",
    Shortcutpower = {8359},
    complete_con = "WildMvp",
    Params = {
      mapid = 154,
      type = {1, 2}
    },
    Sysmsg = 43463
  }
}
Table_GuideUI_fields = {
  "id",
  "GroupID",
  "MainTitle",
  "Text",
  "Desc",
  "Icon",
  "Shortcutpower",
  "complete_con",
  "Params",
  "Sysmsg"
}
return Table_GuideUI
