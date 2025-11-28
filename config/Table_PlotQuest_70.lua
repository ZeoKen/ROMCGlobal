Table_PlotQuest_70 = {
  [1] = {
    id = 1,
    Type = "startfilter",
    Params = {
      fliter = {39}
    }
  },
  [2] = {
    id = 2,
    Type = "showview",
    Params = {panelid = 800, showtype = 1}
  },
  [3] = {
    id = 3,
    Type = "onoff_camerapoint",
    Params = {groupid = 0, on = true}
  },
  [4] = {
    id = 4,
    Type = "play_effect_scene",
    Params = {
      id = 64,
      path = "Common/With_dandelion",
      pos = {
        -5.38,
        -8.26,
        7
      },
      ignoreNavMesh = 1,
      scale = 10
    }
  },
  [5] = {
    id = 5,
    Type = "play_effect_scene",
    Params = {
      id = 65,
      path = "Common/With_dandelion",
      pos = {
        5.38,
        -8.26,
        7
      },
      ignoreNavMesh = 1,
      scale = 10
    }
  },
  [6] = {
    id = 6,
    Type = "play_effect_scene",
    Params = {
      id = 1,
      path = "Common/PoemOfBragi",
      pos = {
        -6.48,
        0.02,
        -4.85
      },
      scale = 2
    }
  },
  [7] = {
    id = 7,
    Type = "play_effect_scene",
    Params = {
      id = 2,
      path = "Common/PoemOfBragi",
      pos = {
        6.63,
        0.02,
        -4.85
      },
      scale = 2
    }
  },
  [8] = {
    id = 8,
    Type = "play_effect_scene",
    Params = {
      id = 3,
      path = "Common/DontForgetWolf",
      pos = {
        0.02,
        1.34,
        6.44
      }
    }
  },
  [9] = {
    id = 9,
    Type = "play_effect_scene",
    Params = {
      id = 4,
      path = "Common/Strengthen_Yellow",
      pos = {
        0.02,
        3.72,
        6.32
      },
      ignoreNavMesh = 1
    }
  },
  [10] = {
    id = 10,
    Type = "wait_time",
    Params = {time = 500}
  },
  [11] = {
    id = 11,
    Type = "set_dir",
    Params = {player = 1, dir = 0}
  },
  [12] = {
    id = 12,
    Type = "dialog",
    Params = {
      dialog = {502228}
    }
  },
  [13] = {
    id = 13,
    Type = "play_effect_scene",
    Params = {
      id = 5,
      path = "Common/SpeedTime",
      pos = {
        0.02,
        3.72,
        6.32
      },
      onshot = 1,
      ignoreNavMesh = 1
    }
  },
  [14] = {
    id = 14,
    Type = "remove_effect_scene",
    Params = {id = 4}
  },
  [15] = {
    id = 15,
    Type = "play_effect_scene",
    Params = {
      id = 6,
      path = "Common/TowerManager",
      pos = {
        0.02,
        3.72,
        6.32
      },
      scale = 2,
      ignoreNavMesh = 1
    }
  },
  [16] = {
    id = 16,
    Type = "play_effect",
    Params = {
      id = 7,
      path = "Skill/Eff_OdeHope_buff",
      player = 1,
      ep = 3
    }
  },
  [17] = {
    id = 17,
    Type = "wait_time",
    Params = {time = 500}
  },
  [18] = {
    id = 18,
    Type = "play_effect_scene",
    Params = {
      id = 8,
      path = "Skill/MagicRod_attack",
      pos = {
        -6.48,
        0.02,
        -4.85
      },
      onshot = 1
    }
  },
  [19] = {
    id = 19,
    Type = "play_effect_scene",
    Params = {
      id = 9,
      path = "Skill/MagicRod_attack",
      pos = {
        6.63,
        0.02,
        -4.85
      },
      onshot = 1
    }
  },
  [20] = {
    id = 20,
    Type = "play_effect",
    Params = {
      id = 10,
      path = "Skill/Eff_TimeDomain_ait",
      player = 1,
      effectpos = 5
    }
  },
  [21] = {
    id = 21,
    Type = "addbutton",
    Params = {
      id = 2,
      text = "##120998",
      eventtype = "goon"
    }
  },
  [22] = {
    id = 22,
    Type = "wait_ui",
    Params = {button = 2}
  },
  [23] = {
    id = 23,
    Type = "move",
    Params = {
      player = 1,
      pos = {
        0.0,
        0.04,
        -8.0
      },
      spd = 1,
      dir = 0
    }
  },
  [24] = {
    id = 24,
    Type = "wait_pos",
    Params = {
      player = 1,
      pos = {
        0.0,
        0.04,
        -8.0
      },
      distance = 1
    }
  },
  [25] = {
    id = 25,
    Type = "set_dir",
    Params = {player = 1, dir = 0}
  },
  [26] = {
    id = 26,
    Type = "play_effect_scene",
    Params = {
      id = 24,
      path = "Common/SpeedTime",
      pos = {
        0.02,
        3.72,
        6.32
      },
      onshot = 1,
      ignoreNavMesh = 1
    }
  },
  [27] = {
    id = 27,
    Type = "remove_effect_scene",
    Params = {id = 6}
  },
  [28] = {
    id = 28,
    Type = "play_effect_scene",
    Params = {
      id = 25,
      path = "Common/TowerManager",
      pos = {
        0.02,
        3.72,
        6.32
      },
      scale = 3,
      ignoreNavMesh = 1
    }
  },
  [29] = {
    id = 29,
    Type = "wait_time",
    Params = {time = 500}
  },
  [31] = {
    id = 31,
    Type = "play_effect_scene",
    Params = {
      id = 66,
      path = "Common/With_dandelion",
      pos = {
        0.25,
        -36.67,
        8
      },
      ignoreNavMesh = 1,
      scale = 25
    }
  },
  [32] = {
    id = 32,
    Type = "play_effect_scene",
    Params = {
      id = 67,
      path = "Common/With_dandelion",
      pos = {
        6.43,
        -3.2,
        8
      },
      ignoreNavMesh = 1,
      scale = 3
    }
  },
  [33] = {
    id = 33,
    Type = "play_effect_scene",
    Params = {
      id = 68,
      path = "Common/With_dandelion",
      pos = {
        -5.81,
        -3.03,
        8
      },
      ignoreNavMesh = 1,
      scale = 3
    }
  },
  [34] = {
    id = 34,
    Type = "play_effect_scene",
    Params = {
      id = 60,
      path = "Common/With_dandelion",
      pos = {
        -5.19,
        -3.03,
        9.75
      },
      ignoreNavMesh = 1,
      scale = 5
    }
  },
  [35] = {
    id = 35,
    Type = "play_effect_scene",
    Params = {
      id = 61,
      path = "Common/With_dandelion",
      pos = {
        5.44,
        -3.03,
        9.75
      },
      ignoreNavMesh = 1,
      scale = 5
    }
  },
  [36] = {
    id = 36,
    Type = "play_effect_scene",
    Params = {
      id = 62,
      path = "Common/With_dandelion",
      pos = {
        -2.52,
        -2.19,
        9.75
      },
      ignoreNavMesh = 1,
      scale = 5
    }
  },
  [37] = {
    id = 37,
    Type = "play_effect_scene",
    Params = {
      id = 63,
      path = "Common/With_dandelion",
      pos = {
        2.65,
        -2.19,
        9.75
      },
      ignoreNavMesh = 1,
      scale = 5
    }
  },
  [38] = {
    id = 38,
    Type = "play_effect_scene",
    Params = {
      id = 11,
      path = "Skill/AngleOfHope_attack",
      pos = {
        0.03,
        2.17,
        -5.55
      },
      onshot = 1,
      ignoreNavMesh = 1
    }
  },
  [39] = {
    id = 39,
    Type = "summon",
    Params = {
      npcid = 807371,
      npcuid = 371,
      groupid = 1,
      pos = {
        0.03,
        2.17,
        -5.55
      },
      dir = 180,
      ignoreNavMesh = 1,
      scale = 2
    }
  },
  [40] = {
    id = 40,
    Type = "dialog",
    Params = {
      dialog = {502229}
    }
  },
  [41] = {
    id = 41,
    Type = "play_sound",
    Params = {
      path = "Skill/SnipeDead_attack"
    }
  },
  [42] = {
    id = 42,
    Type = "play_effect_scene",
    Params = {
      id = 12,
      path = "Skill/SnipeDead_attack",
      pos = {
        -6.17,
        1.95,
        3.82
      },
      onshot = 1
    }
  },
  [43] = {
    id = 43,
    Type = "play_effect_scene",
    Params = {
      id = 13,
      path = "Skill/SnipeDead_attack",
      pos = {
        -2.3,
        1.3,
        6.62
      },
      onshot = 1
    }
  },
  [44] = {
    id = 44,
    Type = "play_effect_scene",
    Params = {
      id = 14,
      path = "Skill/SnipeDead_attack",
      pos = {
        2.68,
        1.32,
        6.03
      },
      onshot = 1
    }
  },
  [45] = {
    id = 45,
    Type = "play_effect_scene",
    Params = {
      id = 15,
      path = "Skill/SnipeDead_attack",
      pos = {
        6.36,
        1.74,
        4.21
      },
      onshot = 1
    }
  },
  [46] = {
    id = 46,
    Type = "wait_time",
    Params = {time = 500}
  },
  [47] = {
    id = 47,
    Type = "play_effect_scene",
    Params = {
      id = 16,
      path = "Skill/SnipeDead_buff",
      pos = {
        -6.17,
        1.95,
        3.82
      },
      ignoreNavMesh = 1
    }
  },
  [48] = {
    id = 48,
    Type = "play_effect_scene",
    Params = {
      id = 17,
      path = "Skill/SnipeDead_buff",
      pos = {
        -2.3,
        1.3,
        6.62
      },
      ignoreNavMesh = 1
    }
  },
  [49] = {
    id = 49,
    Type = "play_effect_scene",
    Params = {
      id = 18,
      path = "Skill/SnipeDead_buff",
      pos = {
        2.68,
        1.32,
        6.03
      },
      ignoreNavMesh = 1
    }
  },
  [50] = {
    id = 50,
    Type = "play_effect_scene",
    Params = {
      id = 19,
      path = "Skill/SnipeDead_buff",
      pos = {
        6.36,
        1.74,
        4.21
      },
      ignoreNavMesh = 1
    }
  },
  [51] = {
    id = 51,
    Type = "wait_time",
    Params = {time = 500}
  },
  [52] = {
    id = 52,
    Type = "play_sound",
    Params = {
      path = "Skill/SnipeDead_attack"
    }
  },
  [53] = {
    id = 53,
    Type = "play_effect_scene",
    Params = {
      id = 20,
      path = "Skill/SnipeDead_attack",
      pos = {
        0.03,
        2.17,
        -3.55
      },
      onshot = 1
    }
  },
  [54] = {
    id = 54,
    Type = "remove_npc",
    Params = {npcuid = 371}
  },
  [55] = {
    id = 55,
    Type = "play_effect",
    Params = {
      id = 21,
      path = "Skill/Rebirth_atk",
      player = 1,
      ep = 3,
      onshot = 1
    }
  },
  [56] = {
    id = 56,
    Type = "wait_time",
    Params = {time = 1000}
  },
  [57] = {
    id = 57,
    Type = "addbutton",
    Params = {
      id = 4,
      text = "##120998",
      eventtype = "goon"
    }
  },
  [58] = {
    id = 58,
    Type = "wait_ui",
    Params = {button = 4}
  },
  [59] = {
    id = 59,
    Type = "move",
    Params = {
      player = 1,
      pos = {
        0.0,
        0.04,
        -4.58
      },
      spd = 1,
      dir = 0
    }
  },
  [60] = {
    id = 60,
    Type = "wait_pos",
    Params = {
      player = 1,
      pos = {
        0.0,
        0.04,
        -4.58
      },
      distance = 1
    }
  },
  [61] = {
    id = 61,
    Type = "set_dir",
    Params = {player = 1, dir = 0}
  },
  [62] = {
    id = 62,
    Type = "play_effect_scene",
    Params = {
      id = 26,
      path = "Common/SpeedTime",
      pos = {
        0.02,
        3.72,
        6.32
      },
      onshot = 1,
      ignoreNavMesh = 1
    }
  },
  [63] = {
    id = 63,
    Type = "remove_effect_scene",
    Params = {id = 25}
  },
  [64] = {
    id = 64,
    Type = "play_effect_scene",
    Params = {
      id = 27,
      path = "Common/TowerManager",
      pos = {
        0.02,
        3.72,
        6.32
      },
      scale = 3,
      ignoreNavMesh = 1
    }
  },
  [65] = {
    id = 65,
    Type = "wait_time",
    Params = {time = 1000}
  },
  [66] = {
    id = 66,
    Type = "play_sound",
    Params = {
      path = "Common/1thFireworks4"
    }
  },
  [67] = {
    id = 67,
    Type = "play_effect_scene",
    Params = {
      id = 28,
      path = "Common/Firework_Kafra3",
      pos = {
        5.47,
        2,
        4
      },
      onshot = 1
    }
  },
  [68] = {
    id = 68,
    Type = "play_effect_scene",
    Params = {
      id = 29,
      path = "Common/Firework_Kafra3",
      pos = {
        -5.47,
        2,
        5
      },
      onshot = 1
    }
  },
  [69] = {
    id = 69,
    Type = "play_sound",
    Params = {
      path = "Common/1thFireworks4"
    }
  },
  [70] = {
    id = 70,
    Type = "play_effect_scene",
    Params = {
      id = 30,
      path = "Common/Firework_Kafra3",
      pos = {
        5.47,
        0.8,
        -5.27
      },
      onshot = 1
    }
  },
  [71] = {
    id = 71,
    Type = "play_effect_scene",
    Params = {
      id = 31,
      path = "Common/Firework_Kafra3",
      pos = {
        -5.47,
        0.8,
        -5.27
      },
      onshot = 1
    }
  },
  [72] = {
    id = 72,
    Type = "play_effect_scene",
    Params = {
      id = 32,
      path = "Common/Firework_Kafra3",
      pos = {
        3.47,
        2,
        4
      },
      onshot = 1
    }
  },
  [73] = {
    id = 73,
    Type = "play_effect_scene",
    Params = {
      id = 33,
      path = "Common/Firework_Kafra3",
      pos = {
        -3.47,
        2,
        5
      },
      onshot = 1
    }
  },
  [74] = {
    id = 74,
    Type = "wait_time",
    Params = {time = 500}
  },
  [75] = {
    id = 75,
    Type = "play_effect",
    Params = {
      id = 35,
      path = "Skill/Scaring_atk",
      player = 1,
      ep = 0,
      onshot = 1
    }
  },
  [76] = {
    id = 76,
    Type = "wait_time",
    Params = {time = 1000}
  },
  [77] = {
    id = 77,
    Type = "play_sound",
    Params = {
      path = "Skill/shanxianbo"
    }
  },
  [78] = {
    id = 78,
    Type = "play_effect_scene",
    Params = {
      id = 36,
      path = "Skill/LightOfHeal_hit",
      pos = {
        0,
        0.18,
        3.28
      },
      onshot = 1,
      ignoreNavMesh = 1
    }
  },
  [79] = {
    id = 79,
    Type = "wait_time",
    Params = {time = 200}
  },
  [80] = {
    id = 80,
    Type = "play_sound",
    Params = {
      path = "Skill/shanxianbo"
    }
  },
  [81] = {
    id = 81,
    Type = "play_effect_scene",
    Params = {
      id = 37,
      path = "Skill/LightOfHeal_hit",
      pos = {
        -2.6,
        1.51,
        6.83
      },
      onshot = 1,
      ignoreNavMesh = 1
    }
  },
  [82] = {
    id = 82,
    Type = "play_effect_scene",
    Params = {
      id = 38,
      path = "Skill/LightOfHeal_hit",
      pos = {
        2.6,
        1.51,
        6.83
      },
      onshot = 1,
      ignoreNavMesh = 1
    }
  },
  [83] = {
    id = 83,
    Type = "wait_time",
    Params = {time = 200}
  },
  [84] = {
    id = 84,
    Type = "play_sound",
    Params = {
      path = "Skill/shanxianbo"
    }
  },
  [85] = {
    id = 85,
    Type = "play_effect_scene",
    Params = {
      id = 39,
      path = "Skill/LightOfHeal_hit",
      pos = {
        -4.26,
        1.51,
        6.83
      },
      onshot = 1,
      ignoreNavMesh = 1
    }
  },
  [86] = {
    id = 86,
    Type = "play_effect_scene",
    Params = {
      id = 40,
      path = "Skill/LightOfHeal_hit",
      pos = {
        4.26,
        1.51,
        6.83
      },
      onshot = 1,
      ignoreNavMesh = 1
    }
  },
  [87] = {
    id = 87,
    Type = "wait_time",
    Params = {time = 200}
  },
  [88] = {
    id = 88,
    Type = "play_sound",
    Params = {
      path = "Skill/shanxianbo"
    }
  },
  [89] = {
    id = 89,
    Type = "play_effect_scene",
    Params = {
      id = 41,
      path = "Skill/LightOfHeal_hit",
      pos = {
        -6.15,
        1.51,
        6.83
      },
      onshot = 1,
      ignoreNavMesh = 1
    }
  },
  [90] = {
    id = 90,
    Type = "play_effect_scene",
    Params = {
      id = 42,
      path = "Skill/LightOfHeal_hit",
      pos = {
        6.15,
        1.51,
        6.83
      },
      onshot = 1,
      ignoreNavMesh = 1
    }
  },
  [91] = {
    id = 91,
    Type = "wait_time",
    Params = {time = 200}
  },
  [92] = {
    id = 92,
    Type = "play_sound",
    Params = {
      path = "Skill/shanxianbo"
    }
  },
  [93] = {
    id = 93,
    Type = "play_effect_scene",
    Params = {
      id = 69,
      path = "Skill/LightOfHeal_hit",
      pos = {
        -1.21,
        0,
        3.53
      },
      onshot = 1,
      ignoreNavMesh = 1
    }
  },
  [94] = {
    id = 94,
    Type = "play_effect_scene",
    Params = {
      id = 70,
      path = "Skill/LightOfHeal_hit",
      pos = {
        1.3,
        0,
        3.53
      },
      onshot = 1,
      ignoreNavMesh = 1
    }
  },
  [95] = {
    id = 95,
    Type = "play_effect_scene",
    Params = {
      id = 71,
      path = "Skill/LightOfHeal_hit",
      pos = {
        -5.2,
        0,
        3.53
      },
      onshot = 1,
      ignoreNavMesh = 1
    }
  },
  [96] = {
    id = 96,
    Type = "play_effect_scene",
    Params = {
      id = 72,
      path = "Skill/LightOfHeal_hit",
      pos = {
        5.43,
        0,
        3.53
      },
      onshot = 1,
      ignoreNavMesh = 1
    }
  },
  [97] = {
    id = 97,
    Type = "play_effect_scene",
    Params = {
      id = 33,
      path = "Common/FreezeFlower_White",
      pos = {
        -6.21,
        2.0,
        3.84
      },
      onshot = 1,
      ignoreNavMesh = 1
    }
  },
  [98] = {
    id = 98,
    Type = "play_effect_scene",
    Params = {
      id = 34,
      path = "Common/FreezeFlower_White",
      pos = {
        6.15,
        2.0,
        3.84
      },
      onshot = 1,
      ignoreNavMesh = 1
    }
  },
  [99] = {
    id = 99,
    Type = "summon",
    Params = {
      npcid = 807371,
      npcuid = 10,
      groupid = 1,
      pos = {
        -6.21,
        2.08,
        3.84
      },
      dir = 151,
      ignoreNavMesh = 1,
      scale = 2
    }
  },
  [100] = {
    id = 100,
    Type = "summon",
    Params = {
      npcid = 807371,
      npcuid = 11,
      groupid = 1,
      pos = {
        6.15,
        2.08,
        3.84
      },
      dir = -155,
      ignoreNavMesh = 1,
      scale = 2
    }
  },
  [101] = {
    id = 101,
    Type = "play_sound",
    Params = {
      path = "Skill/shanxianbo"
    }
  },
  [102] = {
    id = 102,
    Type = "play_effect_scene",
    Params = {
      id = 35,
      path = "Skill/LightOfHeal_hit",
      pos = {
        -2.24,
        1.33,
        6.58
      },
      onshot = 1,
      ignoreNavMesh = 1
    }
  },
  [103] = {
    id = 103,
    Type = "play_effect_scene",
    Params = {
      id = 36,
      path = "Skill/LightOfHeal_hit",
      pos = {
        2.87,
        1.33,
        6.58
      },
      onshot = 1,
      ignoreNavMesh = 1
    }
  },
  [104] = {
    id = 104,
    Type = "wait_time",
    Params = {time = 500}
  },
  [105] = {
    id = 105,
    Type = "play_effect_scene",
    Params = {
      id = 37,
      path = "Common/FreezeFlower_White",
      pos = {
        -2.24,
        1.33,
        6.58
      },
      onshot = 1,
      ignoreNavMesh = 1
    }
  },
  [106] = {
    id = 106,
    Type = "play_effect_scene",
    Params = {
      id = 38,
      path = "Common/FreezeFlower_White",
      pos = {
        2.87,
        1.33,
        6.58
      },
      onshot = 1,
      ignoreNavMesh = 1
    }
  },
  [107] = {
    id = 107,
    Type = "summon",
    Params = {
      npcid = 807371,
      npcuid = 12,
      groupid = 1,
      pos = {
        -2.24,
        1.33,
        6.58
      },
      dir = 180,
      ignoreNavMesh = 1,
      scale = 2
    }
  },
  [108] = {
    id = 108,
    Type = "summon",
    Params = {
      npcid = 807371,
      npcuid = 13,
      groupid = 1,
      pos = {
        2.87,
        1.33,
        6.58
      },
      dir = 180,
      ignoreNavMesh = 1,
      scale = 2
    }
  },
  [109] = {
    id = 109,
    Type = "wait_time",
    Params = {time = 1000}
  },
  [110] = {
    id = 110,
    Type = "play_sound",
    Params = {
      path = "Skill/tutupeng"
    }
  },
  [111] = {
    id = 111,
    Type = "play_effect_scene",
    Params = {
      id = 39,
      path = "Skill/Pray_attack",
      pos = {
        0.02,
        1.34,
        6.44
      },
      onshot = 1
    }
  },
  [112] = {
    id = 112,
    Type = "play_effect",
    Params = {
      id = 40,
      path = "Skill/Pray_attack",
      player = 1,
      onshot = 1
    }
  },
  [113] = {
    id = 113,
    Type = "wait_time",
    Params = {time = 1000}
  },
  [114] = {
    id = 114,
    Type = "action",
    Params = {npcuid = 6, id = 313}
  },
  [115] = {
    id = 115,
    Type = "action",
    Params = {npcuid = 7, id = 313}
  },
  [116] = {
    id = 116,
    Type = "wait_time",
    Params = {time = 1000}
  },
  [117] = {
    id = 117,
    Type = "dialog",
    Params = {
      dialog = {502230}
    }
  },
  [118] = {
    id = 118,
    Type = "addbutton",
    Params = {
      id = 3,
      text = "##120998",
      eventtype = "goon"
    }
  },
  [119] = {
    id = 119,
    Type = "wait_ui",
    Params = {button = 3}
  },
  [120] = {
    id = 120,
    Type = "move",
    Params = {
      player = 1,
      pos = {
        0.0,
        0.04,
        0.55
      },
      spd = 1,
      dir = 0
    }
  },
  [121] = {
    id = 121,
    Type = "wait_pos",
    Params = {
      player = 1,
      pos = {
        0.0,
        0.04,
        0.55
      },
      distance = 1
    }
  },
  [122] = {
    id = 122,
    Type = "set_dir",
    Params = {player = 1, dir = 0}
  },
  [123] = {
    id = 123,
    Type = "play_effect_scene",
    Params = {
      id = 41,
      path = "Common/SpeedTime",
      pos = {
        0.02,
        3.72,
        6.32
      },
      onshot = 1,
      ignoreNavMesh = 1
    }
  },
  [124] = {
    id = 124,
    Type = "remove_effect_scene",
    Params = {id = 27}
  },
  [125] = {
    id = 125,
    Type = "play_effect_scene",
    Params = {
      id = 42,
      path = "Common/TowerManager",
      pos = {
        0.02,
        3.72,
        6.32
      },
      scale = 4,
      ignoreNavMesh = 1
    }
  },
  [127] = {
    id = 127,
    Type = "play_effect",
    Params = {
      id = 43,
      path = "Skill/AngleOfHope_attack",
      npcuid = 10,
      ep = 0,
      onshot = 1
    }
  },
  [128] = {
    id = 128,
    Type = "play_effect",
    Params = {
      id = 44,
      path = "Skill/AngleOfHope_attack",
      npcuid = 11,
      ep = 0,
      onshot = 1
    }
  },
  [129] = {
    id = 129,
    Type = "play_effect",
    Params = {
      id = 45,
      path = "Skill/AngleOfHope_attack",
      npcuid = 12,
      ep = 0,
      onshot = 1
    }
  },
  [130] = {
    id = 130,
    Type = "play_effect",
    Params = {
      id = 46,
      path = "Skill/AngleOfHope_attack",
      npcuid = 13,
      ep = 0,
      onshot = 1
    }
  },
  [131] = {
    id = 131,
    Type = "play_sound",
    Params = {
      path = "Skill/KyrieEleison_b"
    }
  },
  [132] = {
    id = 132,
    Type = "play_effect",
    Params = {
      id = 45,
      path = "Skill/Eff_OdeHope_buff",
      player = 1,
      ep = 3
    }
  },
  [133] = {
    id = 133,
    Type = "wait_time",
    Params = {time = 1000}
  },
  [134] = {
    id = 134,
    Type = "play_effect",
    Params = {
      id = 46,
      path = "Skill/Eff_Baptism_buff",
      player = 1,
      ep = 3
    }
  },
  [135] = {
    id = 135,
    Type = "remove_effect_scene",
    Params = {id = 64}
  },
  [136] = {
    id = 136,
    Type = "remove_effect_scene",
    Params = {id = 65}
  },
  [137] = {
    id = 137,
    Type = "onoff_camerapoint",
    Params = {groupid = 0, on = false}
  },
  [138] = {
    id = 138,
    Type = "onoff_camerapoint",
    Params = {groupid = 1, on = true}
  },
  [139] = {
    id = 139,
    Type = "wait_time",
    Params = {time = 1000}
  },
  [140] = {
    id = 140,
    Type = "play_sound",
    Params = {
      path = "Skill/LightingArrow"
    }
  },
  [141] = {
    id = 141,
    Type = "play_effect_scene",
    Params = {
      id = 47,
      path = "Common/Angel_playshow_M",
      pos = {
        0.07,
        1.39,
        5.65
      },
      onshot = 1
    }
  },
  [142] = {
    id = 142,
    Type = "wait_time",
    Params = {time = 500}
  },
  [143] = {
    id = 143,
    Type = "remove_effect",
    Params = {id = 3}
  },
  [144] = {
    id = 144,
    Type = "remove_effect",
    Params = {id = 42}
  },
  [145] = {
    id = 145,
    Type = "summon",
    Params = {
      npcid = 807287,
      npcuid = 1,
      groupid = 1,
      pos = {
        0.07,
        1.39,
        5.65
      },
      dir = 180,
      ignoreNavMesh = 1,
      scale = 1.8
    }
  },
  [146] = {
    id = 146,
    Type = "action",
    Params = {id = 3, npcuid = 10}
  },
  [147] = {
    id = 147,
    Type = "action",
    Params = {id = 3, npcuid = 11}
  },
  [148] = {
    id = 148,
    Type = "action",
    Params = {id = 3, npcuid = 12}
  },
  [149] = {
    id = 149,
    Type = "action",
    Params = {id = 3, npcuid = 13}
  },
  [150] = {
    id = 150,
    Type = "wait_time",
    Params = {time = 1000}
  },
  [151] = {
    id = 151,
    Type = "play_sound",
    Params = {
      path = "Common/MonsterEvolve"
    }
  },
  [152] = {
    id = 152,
    Type = "play_effect_scene",
    Params = {
      id = 48,
      path = "Common/DontForgetWolf",
      pos = {
        5.69,
        1.24,
        6.5
      }
    }
  },
  [153] = {
    id = 153,
    Type = "play_effect_scene",
    Params = {
      id = 49,
      path = "Common/DontForgetWolf",
      pos = {
        -5.13,
        1.24,
        6.25
      }
    }
  },
  [154] = {
    id = 154,
    Type = "wait_time",
    Params = {time = 1000}
  },
  [155] = {
    id = 155,
    Type = "dialog",
    Params = {
      dialog = {502245}
    }
  },
  [156] = {
    id = 156,
    Type = "play_sound",
    Params = {
      path = "Skill/Lucky_Cat_dissappear"
    }
  },
  [157] = {
    id = 157,
    Type = "play_effect_scene",
    Params = {
      id = 50,
      path = "Skill/AngleOfHope_hit1",
      pos = {
        -5.2,
        1.34,
        9.02
      },
      onshot = 1
    }
  },
  [158] = {
    id = 158,
    Type = "play_effect_scene",
    Params = {
      id = 51,
      path = "Skill/AngleOfHope_hit1",
      pos = {
        -2.84,
        1.34,
        9.02
      },
      onshot = 1
    }
  },
  [159] = {
    id = 159,
    Type = "play_effect_scene",
    Params = {
      id = 52,
      path = "Skill/AngleOfHope_hit1",
      pos = {
        2.84,
        1.34,
        9.02
      },
      onshot = 1
    }
  },
  [160] = {
    id = 160,
    Type = "play_effect_scene",
    Params = {
      id = 53,
      path = "Skill/AngleOfHope_hit1",
      pos = {
        5.2,
        1.34,
        9.02
      },
      onshot = 1
    }
  },
  [161] = {
    id = 161,
    Type = "action",
    Params = {id = 3, npcuid = 10}
  },
  [162] = {
    id = 162,
    Type = "action",
    Params = {id = 3, npcuid = 11}
  },
  [163] = {
    id = 163,
    Type = "action",
    Params = {id = 3, npcuid = 12}
  },
  [164] = {
    id = 164,
    Type = "action",
    Params = {id = 3, npcuid = 13}
  },
  [165] = {
    id = 165,
    Type = "action",
    Params = {id = 21, npcuid = 1}
  },
  [166] = {
    id = 166,
    Type = "play_effect_scene",
    Params = {
      id = 54,
      path = "Skill/AngleOffer_Atk",
      pos = {
        -0.06,
        -0.5,
        6.63
      },
      onshot = 1,
      ignoreNavMesh = 1
    }
  },
  [167] = {
    id = 167,
    Type = "wait_time",
    Params = {time = 500}
  },
  [168] = {
    id = 168,
    Type = "play_sound",
    Params = {
      path = "Skill/AdvancedDetoxification_hit"
    }
  },
  [169] = {
    id = 169,
    Type = "play_effect",
    Params = {
      id = 55,
      path = "Skill/Eff_CrownBader_atk",
      player = 1,
      ep = 0,
      onshot = 1
    }
  },
  [170] = {
    id = 170,
    Type = "wait_time",
    Params = {time = 1000}
  },
  [171] = {
    id = 171,
    Type = "play_effect",
    Params = {
      id = 56,
      path = "Skill/BlessingFaith_buff1",
      player = 1
    }
  },
  [172] = {
    id = 172,
    Type = "showview",
    Params = {panelid = 800, showtype = 2}
  },
  [173] = {
    id = 173,
    Type = "endfilter",
    Params = {
      fliter = {39}
    }
  },
  [174] = {
    id = 174,
    Type = "onoff_camerapoint",
    Params = {groupid = 1}
  }
}
Table_PlotQuest_70_fields = {
  "id",
  "Type",
  "Params"
}
return Table_PlotQuest_70
