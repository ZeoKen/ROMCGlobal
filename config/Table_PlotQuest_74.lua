Table_PlotQuest_74 = {
  [1] = {
    id = 1,
    Type = "play_effect_ui",
    Params = {path = "BtoW"}
  },
  [2] = {
    id = 2,
    Type = "startfilter",
    Params = {
      fliter = {39}
    }
  },
  [3] = {
    id = 3,
    Type = "onoff_camerapoint",
    Params = {groupid = 0, on = true}
  },
  [4] = {
    id = 4,
    Type = "showview",
    Params = {panelid = 800, showtype = 1}
  },
  [5] = {
    id = 5,
    Type = "set_dir",
    Params = {player = 1, dir = 8}
  },
  [6] = {
    id = 6,
    Type = "summon",
    Params = {
      npcid = 807793,
      npcuid = 807793,
      pos = {
        6.16,
        0.49,
        -8.35
      },
      dir = 179.4,
      groupid = 1,
      scale = 2
    }
  },
  [7] = {
    id = 7,
    Type = "play_effect_scene",
    Params = {
      id = 20,
      path = "Common/ShinEffect",
      pos = {
        7.62,
        3.02,
        -11.12
      },
      ignoreNavMesh = 1
    }
  },
  [8] = {
    id = 8,
    Type = "play_effect_scene",
    Params = {
      id = 21,
      path = "Common/ShinEffect",
      pos = {
        4.55,
        2.41,
        -10.08
      },
      ignoreNavMesh = 1
    }
  },
  [9] = {
    id = 9,
    Type = "action",
    Params = {
      player = 1,
      id = 10,
      loop = true
    }
  },
  [10] = {
    id = 10,
    Type = "dialog",
    Params = {
      dialog = {603254}
    }
  },
  [11] = {
    id = 11,
    Type = "play_sound",
    Params = {
      path = "Common/Task_rainbow"
    }
  },
  [12] = {
    id = 12,
    Type = "play_effect_scene",
    Params = {
      id = 1,
      path = "Skill/Cruel_tower_LV2",
      pos = {
        6.16,
        0.13,
        -12.56
      },
      ignoreNavMesh = 1
    }
  },
  [13] = {
    id = 13,
    Type = "wait_time",
    Params = {time = 1000}
  },
  [14] = {
    id = 14,
    Type = "addbutton",
    Params = {
      id = 1,
      text = "##204012",
      eventtype = "goon"
    }
  },
  [15] = {
    id = 15,
    Type = "wait_ui",
    Params = {button = 1}
  },
  [16] = {
    id = 16,
    Type = "play_sound",
    Params = {
      path = "Skill/Saint_attack"
    }
  },
  [17] = {
    id = 17,
    Type = "play_effect",
    Params = {
      id = 2,
      path = "Skill/LightOfHeal_hit",
      player = 1,
      effectpos = 2
    }
  },
  [18] = {
    id = 18,
    Type = "wait_time",
    Params = {time = 500}
  },
  [19] = {
    id = 19,
    Type = "play_effect",
    Params = {
      id = 3,
      path = "Skill/SnipeDead_attack",
      player = 1,
      effectpos = 2
    }
  },
  [20] = {
    id = 20,
    Type = "play_effect_scene",
    Params = {
      id = 4,
      path = "Skill/LotteryCard_buff",
      pos = {
        6.16,
        0.13,
        -12.56
      },
      ignoreNavMesh = 1
    }
  },
  [21] = {
    id = 21,
    Type = "wait_time",
    Params = {time = 500}
  },
  [22] = {
    id = 22,
    Type = "dialog",
    Params = {
      dialog = {603255}
    }
  },
  [23] = {
    id = 23,
    Type = "addbutton",
    Params = {
      id = 2,
      text = "##204012",
      eventtype = "goon"
    }
  },
  [24] = {
    id = 24,
    Type = "wait_ui",
    Params = {button = 2}
  },
  [25] = {
    id = 25,
    Type = "play_sound",
    Params = {
      path = "Skill/Saint_attack"
    }
  },
  [26] = {
    id = 26,
    Type = "play_effect",
    Params = {
      id = 5,
      path = "Skill/LightOfHeal_hit",
      player = 1,
      effectpos = 2
    }
  },
  [27] = {
    id = 27,
    Type = "wait_time",
    Params = {time = 500}
  },
  [28] = {
    id = 28,
    Type = "play_effect",
    Params = {
      id = 6,
      path = "Skill/LightOfHeal_attack",
      player = 1,
      effectpos = 2
    }
  },
  [29] = {
    id = 29,
    Type = "play_effect_scene",
    Params = {
      id = 7,
      path = "Common/DontForgetWolf",
      pos = {
        6.18,
        0.13,
        -11.81
      }
    }
  },
  [30] = {
    id = 30,
    Type = "wait_time",
    Params = {time = 500}
  },
  [31] = {
    id = 31,
    Type = "play_sound",
    Params = {
      path = "Common/save"
    }
  },
  [32] = {
    id = 32,
    Type = "play_effect_scene",
    Params = {
      id = 50,
      path = "Skill/Quicken_atk",
      pos = {
        9.09,
        1.75,
        -14.34
      },
      ignoreNavMesh = 1,
      onshot = 1
    }
  },
  [33] = {
    id = 33,
    Type = "play_effect_scene",
    Params = {
      id = 51,
      path = "Skill/SoldierCat3_skill_hitbuff",
      pos = {
        9.09,
        1.75,
        -14.34
      },
      ignoreNavMesh = 1
    }
  },
  [34] = {
    id = 34,
    Type = "wait_time",
    Params = {time = 500}
  },
  [35] = {
    id = 35,
    Type = "play_sound",
    Params = {
      path = "Common/save"
    }
  },
  [36] = {
    id = 36,
    Type = "play_effect_scene",
    Params = {
      id = 52,
      path = "Skill/Quicken_atk",
      pos = {
        11.44,
        1.67,
        -8.53
      },
      ignoreNavMesh = 1,
      onshot = 1
    }
  },
  [37] = {
    id = 37,
    Type = "play_effect_scene",
    Params = {
      id = 53,
      path = "Skill/SoldierCat3_skill_hitbuff",
      pos = {
        11.44,
        1.67,
        -8.53
      },
      ignoreNavMesh = 1
    }
  },
  [38] = {
    id = 38,
    Type = "wait_time",
    Params = {time = 500}
  },
  [39] = {
    id = 39,
    Type = "play_sound",
    Params = {
      path = "Common/save"
    }
  },
  [40] = {
    id = 40,
    Type = "play_effect_scene",
    Params = {
      id = 54,
      path = "Skill/Quicken_atk",
      pos = {
        2.94,
        1.3,
        -11.84
      },
      ignoreNavMesh = 1,
      onshot = 1
    }
  },
  [41] = {
    id = 41,
    Type = "play_effect_scene",
    Params = {
      id = 55,
      path = "Skill/SoldierCat3_skill_hitbuff",
      pos = {
        2.94,
        1.3,
        -11.84
      },
      ignoreNavMesh = 1
    }
  },
  [42] = {
    id = 42,
    Type = "wait_time",
    Params = {time = 500}
  },
  [43] = {
    id = 43,
    Type = "play_sound",
    Params = {
      path = "Common/save"
    }
  },
  [44] = {
    id = 44,
    Type = "play_effect_scene",
    Params = {
      id = 56,
      path = "Skill/Quicken_atk",
      pos = {
        -0.79,
        1.75,
        -8.97
      },
      ignoreNavMesh = 1,
      onshot = 1
    }
  },
  [45] = {
    id = 45,
    Type = "play_effect_scene",
    Params = {
      id = 57,
      path = "Skill/SoldierCat3_skill_hitbuff",
      pos = {
        -0.79,
        1.75,
        -8.97
      },
      ignoreNavMesh = 1
    }
  },
  [46] = {
    id = 46,
    Type = "wait_time",
    Params = {time = 500}
  },
  [47] = {
    id = 47,
    Type = "play_sound",
    Params = {
      path = "Common/save"
    }
  },
  [48] = {
    id = 48,
    Type = "play_effect_scene",
    Params = {
      id = 58,
      path = "Skill/Quicken_atk",
      pos = {
        0.62,
        2.22,
        -5.21
      },
      ignoreNavMesh = 1,
      onshot = 1
    }
  },
  [49] = {
    id = 49,
    Type = "play_effect_scene",
    Params = {
      id = 59,
      path = "Skill/SoldierCat3_skill_hitbuff",
      pos = {
        0.62,
        2.22,
        -5.21
      },
      ignoreNavMesh = 1
    }
  },
  [50] = {
    id = 50,
    Type = "wait_time",
    Params = {time = 1000}
  },
  [51] = {
    id = 51,
    Type = "dialog",
    Params = {
      dialog = {603256}
    }
  },
  [52] = {
    id = 52,
    Type = "addbutton",
    Params = {
      id = 3,
      text = "##204012",
      eventtype = "goon"
    }
  },
  [53] = {
    id = 53,
    Type = "wait_ui",
    Params = {button = 3}
  },
  [54] = {
    id = 54,
    Type = "play_sound",
    Params = {
      path = "Skill/shanxianbo"
    }
  },
  [55] = {
    id = 55,
    Type = "play_effect",
    Params = {
      id = 8,
      path = "Skill/LightOfHeal_hit",
      player = 1,
      effectpos = 2
    }
  },
  [56] = {
    id = 56,
    Type = "wait_time",
    Params = {time = 500}
  },
  [57] = {
    id = 57,
    Type = "play_effect",
    Params = {
      id = 9,
      path = "Skill/LightOfHeal_attack",
      player = 1,
      effectpos = 2
    }
  },
  [58] = {
    id = 58,
    Type = "play_effect_scene",
    Params = {
      id = 10,
      path = "Skill/WolfDancing_buff1",
      pos = {
        6.18,
        0.13,
        -11.81
      }
    }
  },
  [59] = {
    id = 59,
    Type = "wait_time",
    Params = {time = 500}
  },
  [60] = {
    id = 60,
    Type = "play_sound",
    Params = {
      path = "Common/Task_rainbow"
    }
  },
  [61] = {
    id = 61,
    Type = "play_effect_scene",
    Params = {
      id = 60,
      path = "Skill/Quicken_atk_huge",
      pos = {
        9.09,
        1.75,
        -14.34
      },
      ignoreNavMesh = 1,
      onshot = 1
    }
  },
  [62] = {
    id = 62,
    Type = "play_effect_scene",
    Params = {
      id = 61,
      path = "Skill/Quicken_buff_huge",
      pos = {
        9.09,
        1.75,
        -14.34
      },
      ignoreNavMesh = 1
    }
  },
  [63] = {
    id = 63,
    Type = "play_effect_scene",
    Params = {
      id = 62,
      path = "Skill/Quicken_atk_huge",
      pos = {
        11.44,
        1.67,
        -8.53
      },
      ignoreNavMesh = 1,
      onshot = 1
    }
  },
  [64] = {
    id = 64,
    Type = "play_effect_scene",
    Params = {
      id = 63,
      path = "Skill/Quicken_buff_huge",
      pos = {
        11.44,
        1.67,
        -8.53
      },
      ignoreNavMesh = 1
    }
  },
  [65] = {
    id = 65,
    Type = "play_effect_scene",
    Params = {
      id = 64,
      path = "Skill/Quicken_atk_huge",
      pos = {
        2.94,
        1.3,
        -11.84
      },
      ignoreNavMesh = 1,
      onshot = 1
    }
  },
  [66] = {
    id = 66,
    Type = "play_effect_scene",
    Params = {
      id = 65,
      path = "Skill/Quicken_buff_huge",
      pos = {
        2.94,
        1.3,
        -11.84
      },
      ignoreNavMesh = 1
    }
  },
  [67] = {
    id = 67,
    Type = "play_effect_scene",
    Params = {
      id = 66,
      path = "Skill/Quicken_atk_huge",
      pos = {
        -0.79,
        1.75,
        -8.97
      },
      ignoreNavMesh = 1,
      onshot = 1
    }
  },
  [68] = {
    id = 68,
    Type = "play_effect_scene",
    Params = {
      id = 67,
      path = "Skill/Quicken_buff_huge",
      pos = {
        -0.79,
        1.75,
        -8.97
      },
      ignoreNavMesh = 1
    }
  },
  [69] = {
    id = 69,
    Type = "play_effect_scene",
    Params = {
      id = 68,
      path = "Skill/Quicken_atk_huge",
      pos = {
        0.62,
        2.22,
        -5.21
      },
      ignoreNavMesh = 1,
      onshot = 1
    }
  },
  [70] = {
    id = 70,
    Type = "play_effect_scene",
    Params = {
      id = 69,
      path = "Skill/Quicken_buff_huge",
      pos = {
        0.62,
        2.22,
        -5.21
      },
      ignoreNavMesh = 1
    }
  },
  [71] = {
    id = 71,
    Type = "wait_time",
    Params = {time = 500}
  },
  [72] = {
    id = 72,
    Type = "play_sound",
    Params = {
      path = "Common/Task_Shiny"
    }
  },
  [73] = {
    id = 73,
    Type = "play_effect_scene",
    Params = {
      id = 70,
      path = "Skill/SoldierCat3_bron",
      pos = {
        9.09,
        1.75,
        -14.34
      },
      onshot = 1
    }
  },
  [74] = {
    id = 74,
    Type = "play_effect_scene",
    Params = {
      id = 71,
      path = "Skill/SoldierCat3_bron",
      pos = {
        11.44,
        1.67,
        -8.53
      },
      onshot = 1
    }
  },
  [75] = {
    id = 75,
    Type = "play_effect_scene",
    Params = {
      id = 72,
      path = "Skill/SoldierCat3_bron",
      pos = {
        2.94,
        1.3,
        -11.84
      },
      onshot = 1
    }
  },
  [76] = {
    id = 76,
    Type = "play_effect_scene",
    Params = {
      id = 73,
      path = "Skill/SoldierCat3_bron",
      pos = {
        -0.79,
        1.75,
        -8.97
      },
      onshot = 1
    }
  },
  [77] = {
    id = 77,
    Type = "play_effect_scene",
    Params = {
      id = 74,
      path = "Skill/SoldierCat3_bron",
      pos = {
        0.62,
        2.22,
        -5.21
      },
      onshot = 1
    }
  },
  [78] = {
    id = 78,
    Type = "wait_time",
    Params = {time = 1500}
  },
  [79] = {
    id = 79,
    Type = "dialog",
    Params = {
      dialog = {603257}
    }
  },
  [80] = {
    id = 80,
    Type = "action",
    Params = {npcuid = 807993, id = 3}
  },
  [81] = {
    id = 81,
    Type = "wait_time",
    Params = {time = 800}
  },
  [82] = {
    id = 82,
    Type = "showview",
    Params = {panelid = 800, showtype = 2}
  },
  [83] = {
    id = 83,
    Type = "endfilter",
    Params = {
      fliter = {39}
    }
  },
  [84] = {
    id = 84,
    Type = "onoff_camerapoint",
    Params = {
      groupid = 0,
      on = false,
      returnDefaultTime = 5000
    }
  }
}
Table_PlotQuest_74_fields = {
  "id",
  "Type",
  "Params"
}
return Table_PlotQuest_74
