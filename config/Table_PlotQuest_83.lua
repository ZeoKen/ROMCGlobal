Table_PlotQuest_83 = {
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
    Params = {groupid = 2, on = true}
  },
  [4] = {
    id = 4,
    Type = "showview",
    Params = {panelid = 800, showtype = 1}
  },
  [5] = {
    id = 5,
    Type = "move",
    Params = {
      player = 1,
      pos = {
        4.82,
        1.61,
        13.61
      },
      spd = 1,
      dir = 180
    }
  },
  [6] = {
    id = 6,
    Type = "wait_pos",
    Params = {
      player = 1,
      pos = {
        4.82,
        1.61,
        13.61
      },
      distance = 1
    }
  },
  [7] = {
    id = 7,
    Type = "set_dir",
    Params = {player = 1, dir = 180}
  },
  [8] = {
    id = 8,
    Type = "summon",
    Params = {
      npcid = 807658,
      npcuid = 807658,
      pos = {
        9.5,
        1.48,
        9.11
      },
      dir = 337.48,
      groupid = 1,
      scale = 1.3,
      ignoreNavMesh = 1
    }
  },
  [9] = {
    id = 9,
    Type = "summon",
    Params = {
      npcid = 807659,
      npcuid = 807659,
      pos = {
        6.55,
        1.56,
        9.54
      },
      dir = 14.8,
      groupid = 1,
      scale = 1.3,
      ignoreNavMesh = 1
    }
  },
  [10] = {
    id = 10,
    Type = "summon",
    Params = {
      npcid = 807660,
      npcuid = 807660,
      pos = {
        2.86,
        1.56,
        10.29
      },
      dir = 30.63,
      groupid = 1,
      scale = 1.3,
      ignoreNavMesh = 1
    }
  },
  [11] = {
    id = 11,
    Type = "summon",
    Params = {
      npcid = 807661,
      npcuid = 807661,
      pos = {
        0.41,
        1.61,
        9.54
      },
      dir = 14.55,
      groupid = 1,
      scale = 1.4,
      ignoreNavMesh = 1
    }
  },
  [12] = {
    id = 12,
    Type = "summon",
    Params = {
      npcid = 807652,
      npcuid = 807652,
      pos = {
        4.75,
        1.59,
        12.32
      },
      dir = 14.55,
      groupid = 1,
      scale = 0.6
    }
  },
  [13] = {
    id = 13,
    Type = "play_effect_scene",
    Params = {
      id = 1,
      path = "Skill/BlessingFaith_buff1",
      pos = {
        4.75,
        1.59,
        12.32
      }
    }
  },
  [14] = {
    id = 14,
    Type = "play_effect_scene",
    Params = {
      id = 2,
      path = "Skill/EarthDrive_buff",
      pos = {
        4.75,
        3.15,
        12.32
      },
      ignoreNavMesh = 1
    }
  },
  [15] = {
    id = 15,
    Type = "wait_time",
    Params = {time = 2000}
  },
  [16] = {
    id = 16,
    Type = "action",
    Params = {player = 1, id = 88}
  },
  [17] = {
    id = 17,
    Type = "wait_time",
    Params = {time = 3000}
  },
  [18] = {
    id = 18,
    Type = "play_sound",
    Params = {
      path = "Skill/Lightbringer_baizaoyin"
    }
  },
  [19] = {
    id = 19,
    Type = "play_effect_scene",
    Params = {
      id = 3,
      path = "Skill/Mechanic_whiteNoise_atk",
      pos = {
        4.76,
        1.59,
        13.58
      },
      onshot = 1
    }
  },
  [20] = {
    id = 20,
    Type = "remove_npc",
    Params = {npcuid = 807652}
  },
  [21] = {
    id = 21,
    Type = "remove_effect_scene",
    Params = {id = 1}
  },
  [22] = {
    id = 22,
    Type = "remove_effect_scene",
    Params = {id = 2}
  },
  [23] = {
    id = 23,
    Type = "wait_time",
    Params = {time = 1000}
  },
  [24] = {
    id = 24,
    Type = "play_effect_scene",
    Params = {
      id = 4,
      path = "Skill/Mechanic_Command",
      pos = {
        6.36,
        1.58,
        11.76
      },
      onshot = 1,
      ignoreNavMesh = 1
    }
  },
  [25] = {
    id = 25,
    Type = "wait_time",
    Params = {time = 300}
  },
  [26] = {
    id = 26,
    Type = "play_effect_scene",
    Params = {
      id = 5,
      path = "Skill/Mechanic_Command",
      pos = {
        4.81,
        1.61,
        13.56
      },
      onshot = 1,
      ignoreNavMesh = 1
    }
  },
  [27] = {
    id = 27,
    Type = "wait_time",
    Params = {time = 300}
  },
  [28] = {
    id = 28,
    Type = "play_effect_scene",
    Params = {
      id = 6,
      path = "Skill/Mechanic_Command",
      pos = {
        2.8,
        1.58,
        11.92
      },
      onshot = 1,
      ignoreNavMesh = 1
    }
  },
  [29] = {
    id = 29,
    Type = "wait_time",
    Params = {time = 300}
  },
  [30] = {
    id = 30,
    Type = "play_effect_scene",
    Params = {
      id = 7,
      path = "Skill/Mechanic_Command",
      pos = {
        4.87,
        0.81,
        9.64
      },
      onshot = 1,
      ignoreNavMesh = 1
    }
  },
  [31] = {
    id = 31,
    Type = "wait_time",
    Params = {time = 300}
  },
  [32] = {
    id = 32,
    Type = "play_effect_scene",
    Params = {
      id = 8,
      path = "Skill/Mechanic_Command",
      pos = {
        6.36,
        1.58,
        11.76
      },
      onshot = 1,
      ignoreNavMesh = 1
    }
  },
  [33] = {
    id = 33,
    Type = "wait_time",
    Params = {time = 300}
  },
  [34] = {
    id = 34,
    Type = "play_effect_scene",
    Params = {
      id = 9,
      path = "Skill/Mechanic_Command",
      pos = {
        4.81,
        1.61,
        13.56
      },
      onshot = 1,
      ignoreNavMesh = 1
    }
  },
  [35] = {
    id = 35,
    Type = "wait_time",
    Params = {time = 300}
  },
  [36] = {
    id = 36,
    Type = "play_effect_scene",
    Params = {
      id = 10,
      path = "Skill/Mechanic_Command",
      pos = {
        2.8,
        1.58,
        11.92
      },
      onshot = 1,
      ignoreNavMesh = 1
    }
  },
  [37] = {
    id = 37,
    Type = "wait_time",
    Params = {time = 300}
  },
  [38] = {
    id = 38,
    Type = "play_effect_scene",
    Params = {
      id = 11,
      path = "Skill/Mechanic_Command",
      pos = {
        4.87,
        0.81,
        9.64
      },
      onshot = 1,
      ignoreNavMesh = 1
    }
  },
  [39] = {
    id = 39,
    Type = "dialog",
    Params = {
      dialog = {603513, 603514}
    }
  },
  [40] = {
    id = 40,
    Type = "play_effect_scene",
    Params = {
      id = 12,
      path = "Skill/SnipeDead_attack",
      pos = {
        6.71,
        1.62,
        13.72
      },
      onshot = 1
    }
  },
  [41] = {
    id = 41,
    Type = "wait_time",
    Params = {time = 300}
  },
  [42] = {
    id = 42,
    Type = "play_effect_scene",
    Params = {
      id = 13,
      path = "Skill/SnipeDead_attack",
      pos = {
        6.09,
        1.58,
        12.56
      },
      onshot = 1
    }
  },
  [43] = {
    id = 43,
    Type = "wait_time",
    Params = {time = 300}
  },
  [44] = {
    id = 44,
    Type = "play_effect_scene",
    Params = {
      id = 14,
      path = "Skill/SnipeDead_attack",
      pos = {
        4.77,
        1.58,
        11.97
      },
      onshot = 1
    }
  },
  [45] = {
    id = 45,
    Type = "wait_time",
    Params = {time = 300}
  },
  [46] = {
    id = 46,
    Type = "play_effect_scene",
    Params = {
      id = 15,
      path = "Skill/SnipeDead_attack",
      pos = {
        3.31,
        1.58,
        12.46
      },
      onshot = 1
    }
  },
  [47] = {
    id = 47,
    Type = "wait_time",
    Params = {time = 300}
  },
  [48] = {
    id = 48,
    Type = "play_effect_scene",
    Params = {
      id = 16,
      path = "Skill/SnipeDead_attack",
      pos = {
        2.86,
        1.58,
        13.73
      },
      onshot = 1
    }
  },
  [49] = {
    id = 49,
    Type = "wait_time",
    Params = {time = 300}
  },
  [50] = {
    id = 50,
    Type = "play_effect_scene",
    Params = {
      id = 17,
      path = "Skill/SnipeDead_attack",
      pos = {
        3.44,
        1.63,
        14.98
      },
      onshot = 1
    }
  },
  [51] = {
    id = 51,
    Type = "wait_time",
    Params = {time = 300}
  },
  [52] = {
    id = 52,
    Type = "play_effect_scene",
    Params = {
      id = 18,
      path = "Skill/SnipeDead_attack",
      pos = {
        4.86,
        1.65,
        15.66
      },
      onshot = 1
    }
  },
  [53] = {
    id = 53,
    Type = "wait_time",
    Params = {time = 300}
  },
  [54] = {
    id = 54,
    Type = "play_effect_scene",
    Params = {
      id = 19,
      path = "Skill/SnipeDead_attack",
      pos = {
        6.28,
        1.56,
        15.08
      },
      onshot = 1
    }
  },
  [55] = {
    id = 55,
    Type = "wait_time",
    Params = {time = 300}
  },
  [56] = {
    id = 56,
    Type = "play_effect_scene",
    Params = {
      id = 20,
      path = "Skill/SnipeDead_attack",
      pos = {
        6.71,
        1.62,
        13.72
      },
      onshot = 1
    }
  },
  [57] = {
    id = 57,
    Type = "wait_time",
    Params = {time = 300}
  },
  [58] = {
    id = 58,
    Type = "play_effect_scene",
    Params = {
      id = 21,
      path = "Skill/SnipeDead_attack",
      pos = {
        6.09,
        1.58,
        12.56
      },
      onshot = 1
    }
  },
  [59] = {
    id = 59,
    Type = "wait_time",
    Params = {time = 300}
  },
  [60] = {
    id = 60,
    Type = "play_effect_scene",
    Params = {
      id = 22,
      path = "Skill/SnipeDead_attack",
      pos = {
        4.77,
        1.58,
        11.97
      },
      onshot = 1
    }
  },
  [61] = {
    id = 61,
    Type = "wait_time",
    Params = {time = 300}
  },
  [62] = {
    id = 62,
    Type = "play_effect_scene",
    Params = {
      id = 23,
      path = "Skill/SnipeDead_attack",
      pos = {
        3.31,
        1.58,
        12.46
      },
      onshot = 1
    }
  },
  [63] = {
    id = 63,
    Type = "wait_time",
    Params = {time = 300}
  },
  [64] = {
    id = 64,
    Type = "play_effect_scene",
    Params = {
      id = 24,
      path = "Skill/SnipeDead_attack",
      pos = {
        2.86,
        1.58,
        13.73
      },
      onshot = 1
    }
  },
  [65] = {
    id = 65,
    Type = "wait_time",
    Params = {time = 300}
  },
  [66] = {
    id = 66,
    Type = "play_effect_scene",
    Params = {
      id = 25,
      path = "Skill/SnipeDead_attack",
      pos = {
        3.44,
        1.63,
        14.98
      },
      onshot = 1
    }
  },
  [67] = {
    id = 67,
    Type = "wait_time",
    Params = {time = 300}
  },
  [68] = {
    id = 68,
    Type = "play_effect_scene",
    Params = {
      id = 26,
      path = "Skill/SnipeDead_attack",
      pos = {
        4.86,
        1.65,
        15.66
      },
      onshot = 1
    }
  },
  [69] = {
    id = 69,
    Type = "wait_time",
    Params = {time = 300}
  },
  [70] = {
    id = 70,
    Type = "play_effect_scene",
    Params = {
      id = 27,
      path = "Skill/SnipeDead_attack",
      pos = {
        6.28,
        1.56,
        15.08
      },
      onshot = 1
    }
  },
  [71] = {
    id = 71,
    Type = "wait_time",
    Params = {time = 300}
  },
  [72] = {
    id = 72,
    Type = "play_effect_scene",
    Params = {
      id = 28,
      path = "Skill/SnipeDead_attack",
      pos = {
        6.71,
        1.62,
        13.72
      },
      onshot = 1
    }
  },
  [73] = {
    id = 73,
    Type = "wait_time",
    Params = {time = 300}
  },
  [74] = {
    id = 74,
    Type = "play_effect_scene",
    Params = {
      id = 29,
      path = "Skill/SnipeDead_attack",
      pos = {
        6.09,
        1.58,
        12.56
      },
      onshot = 1
    }
  },
  [75] = {
    id = 75,
    Type = "wait_time",
    Params = {time = 300}
  },
  [76] = {
    id = 76,
    Type = "play_effect_scene",
    Params = {
      id = 30,
      path = "Skill/SnipeDead_attack",
      pos = {
        4.77,
        1.58,
        11.97
      },
      onshot = 1
    }
  },
  [77] = {
    id = 77,
    Type = "wait_time",
    Params = {time = 300}
  },
  [78] = {
    id = 78,
    Type = "play_effect_scene",
    Params = {
      id = 31,
      path = "Skill/SnipeDead_attack",
      pos = {
        3.31,
        1.58,
        12.46
      },
      onshot = 1
    }
  },
  [79] = {
    id = 79,
    Type = "wait_time",
    Params = {time = 300}
  },
  [80] = {
    id = 80,
    Type = "play_effect_scene",
    Params = {
      id = 32,
      path = "Skill/SnipeDead_attack",
      pos = {
        2.86,
        1.58,
        13.73
      },
      onshot = 1
    }
  },
  [81] = {
    id = 81,
    Type = "wait_time",
    Params = {time = 300}
  },
  [82] = {
    id = 82,
    Type = "play_effect_scene",
    Params = {
      id = 33,
      path = "Skill/SnipeDead_attack",
      pos = {
        3.44,
        1.63,
        14.98
      },
      onshot = 1
    }
  },
  [83] = {
    id = 83,
    Type = "wait_time",
    Params = {time = 300}
  },
  [84] = {
    id = 84,
    Type = "play_effect_scene",
    Params = {
      id = 34,
      path = "Skill/SnipeDead_attack",
      pos = {
        4.86,
        1.65,
        15.66
      },
      onshot = 1
    }
  },
  [85] = {
    id = 85,
    Type = "wait_time",
    Params = {time = 300}
  },
  [86] = {
    id = 86,
    Type = "play_effect_scene",
    Params = {
      id = 35,
      path = "Skill/SnipeDead_attack",
      pos = {
        6.28,
        1.56,
        15.08
      },
      onshot = 1
    }
  },
  [87] = {
    id = 87,
    Type = "play_effect_scene",
    Params = {
      id = 36,
      path = "Skill/MonsterInvincible",
      pos = {
        4.82,
        2.5,
        13.61
      },
      ignoreNavMesh = 1
    }
  },
  [88] = {
    id = 88,
    Type = "dialog",
    Params = {
      dialog = {
        603515,
        603516,
        603517,
        603518,
        603519
      }
    }
  },
  [89] = {
    id = 89,
    Type = "addbutton",
    Params = {
      id = 1,
      text = "##297795",
      eventtype = "goon"
    }
  },
  [90] = {
    id = 90,
    Type = "wait_ui",
    Params = {button = 1}
  },
  [91] = {
    id = 91,
    Type = "play_effect_scene",
    Params = {
      id = 37,
      path = "Common/BigCatGate",
      pos = {
        4.82,
        1.61,
        13.61
      }
    }
  },
  [92] = {
    id = 92,
    Type = "play_sound",
    Params = {
      path = "Skill/Lightbringer_guangzipao"
    }
  },
  [93] = {
    id = 93,
    Type = "play_effect_scene",
    Params = {
      id = 38,
      path = "Skill/Mechanic_Electrostatic",
      pos = {
        6.55,
        1.56,
        9.54
      },
      onshot = 1,
      ignoreNavMesh = 1
    }
  },
  [94] = {
    id = 94,
    Type = "play_effect_scene",
    Params = {
      id = 39,
      path = "Skill/Mechanic_Electrostatic",
      pos = {
        2.86,
        1.56,
        10.29
      },
      onshot = 1,
      ignoreNavMesh = 1
    }
  },
  [95] = {
    id = 95,
    Type = "play_effect_scene",
    Params = {
      id = 40,
      path = "Skill/Mechanic_Electrostatic",
      pos = {
        9.5,
        1.48,
        9.11
      },
      onshot = 1,
      ignoreNavMesh = 1
    }
  },
  [96] = {
    id = 96,
    Type = "play_effect_scene",
    Params = {
      id = 41,
      path = "Skill/Mechanic_Electrostatic",
      pos = {
        0.41,
        1.61,
        9.54
      },
      onshot = 1,
      ignoreNavMesh = 1
    }
  },
  [97] = {
    id = 97,
    Type = "wait_time",
    Params = {time = 500}
  },
  [98] = {
    id = 98,
    Type = "play_sound",
    Params = {
      path = "Skill/Lightbringer_guangzipao"
    }
  },
  [99] = {
    id = 99,
    Type = "play_effect_scene",
    Params = {
      id = 100,
      path = "Skill/Mechanic_Electrostatic",
      pos = {
        6.55,
        1.56,
        9.54
      },
      onshot = 1,
      ignoreNavMesh = 1
    }
  },
  [100] = {
    id = 100,
    Type = "play_effect_scene",
    Params = {
      id = 101,
      path = "Skill/Mechanic_Electrostatic",
      pos = {
        2.86,
        1.56,
        10.29
      },
      onshot = 1,
      ignoreNavMesh = 1
    }
  },
  [101] = {
    id = 101,
    Type = "play_effect_scene",
    Params = {
      id = 102,
      path = "Skill/Mechanic_Electrostatic",
      pos = {
        9.5,
        1.48,
        9.11
      },
      onshot = 1,
      ignoreNavMesh = 1
    }
  },
  [102] = {
    id = 102,
    Type = "play_effect_scene",
    Params = {
      id = 103,
      path = "Skill/Mechanic_Electrostatic",
      pos = {
        0.41,
        1.61,
        9.54
      },
      onshot = 1,
      ignoreNavMesh = 1
    }
  },
  [103] = {
    id = 103,
    Type = "wait_time",
    Params = {time = 500}
  },
  [104] = {
    id = 104,
    Type = "play_sound",
    Params = {
      path = "Skill/Lightbringer_guangzipao"
    }
  },
  [105] = {
    id = 105,
    Type = "play_effect_scene",
    Params = {
      id = 104,
      path = "Skill/Mechanic_Electrostatic",
      pos = {
        6.55,
        1.56,
        9.54
      },
      onshot = 1,
      ignoreNavMesh = 1
    }
  },
  [106] = {
    id = 106,
    Type = "play_effect_scene",
    Params = {
      id = 105,
      path = "Skill/Mechanic_Electrostatic",
      pos = {
        2.86,
        1.56,
        10.29
      },
      onshot = 1,
      ignoreNavMesh = 1
    }
  },
  [107] = {
    id = 107,
    Type = "play_effect_scene",
    Params = {
      id = 106,
      path = "Skill/Mechanic_Electrostatic",
      pos = {
        9.5,
        1.48,
        9.11
      },
      onshot = 1,
      ignoreNavMesh = 1
    }
  },
  [108] = {
    id = 108,
    Type = "play_effect_scene",
    Params = {
      id = 107,
      path = "Skill/Mechanic_Electrostatic",
      pos = {
        0.41,
        1.61,
        9.54
      },
      onshot = 1,
      ignoreNavMesh = 1
    }
  },
  [109] = {
    id = 109,
    Type = "play_effect_scene",
    Params = {
      id = 108,
      path = "Skill/Task_magic2",
      pos = {
        6.55,
        1.56,
        9.54
      },
      ignoreNavMesh = 1
    }
  },
  [110] = {
    id = 110,
    Type = "play_effect_scene",
    Params = {
      id = 109,
      path = "Skill/Task_magic2",
      pos = {
        2.86,
        1.56,
        10.29
      },
      ignoreNavMesh = 1
    }
  },
  [111] = {
    id = 111,
    Type = "play_effect_scene",
    Params = {
      id = 110,
      path = "Skill/Task_magic2",
      pos = {
        9.5,
        1.48,
        9.11
      },
      ignoreNavMesh = 1
    }
  },
  [112] = {
    id = 112,
    Type = "play_effect_scene",
    Params = {
      id = 111,
      path = "Skill/Task_magic2",
      pos = {
        0.41,
        1.61,
        9.54
      },
      ignoreNavMesh = 1
    }
  },
  [113] = {
    id = 113,
    Type = "dialog",
    Params = {
      dialog = {603520}
    }
  },
  [114] = {
    id = 114,
    Type = "addbutton",
    Params = {
      id = 2,
      text = "##297899",
      eventtype = "goon"
    }
  },
  [115] = {
    id = 115,
    Type = "wait_ui",
    Params = {button = 2}
  },
  [116] = {
    id = 116,
    Type = "remove_effect_scene",
    Params = {id = 37}
  },
  [117] = {
    id = 117,
    Type = "play_effect_scene",
    Params = {
      id = 112,
      path = "Skill/MoonSlave_atk",
      pos = {
        4.82,
        1.61,
        13.61
      },
      onshot = 1
    }
  },
  [118] = {
    id = 118,
    Type = "wait_time",
    Params = {time = 500}
  },
  [119] = {
    id = 119,
    Type = "play_effect_scene",
    Params = {
      id = 42,
      path = "Skill/Mechanic_Electrostatic",
      pos = {
        4.82,
        1.61,
        13.61
      },
      onshot = 1
    }
  },
  [120] = {
    id = 120,
    Type = "play_effect_scene",
    Params = {
      id = 43,
      path = "Skill/Mechanic_Restart_buff",
      pos = {
        9.5,
        1.48,
        9.11
      },
      onshot = 1,
      ignoreNavMesh = 1
    }
  },
  [121] = {
    id = 121,
    Type = "play_effect_scene",
    Params = {
      id = 44,
      path = "Skill/Mechanic_Restart_buff",
      pos = {
        6.55,
        1.56,
        9.54
      },
      onshot = 1,
      ignoreNavMesh = 1
    }
  },
  [122] = {
    id = 122,
    Type = "play_effect_scene",
    Params = {
      id = 45,
      path = "Skill/Mechanic_Restart_buff",
      pos = {
        2.86,
        1.56,
        10.29
      },
      onshot = 1,
      ignoreNavMesh = 1
    }
  },
  [123] = {
    id = 123,
    Type = "play_effect_scene",
    Params = {
      id = 46,
      path = "Skill/Mechanic_Restart_buff",
      pos = {
        0.41,
        1.61,
        9.54
      },
      onshot = 1,
      ignoreNavMesh = 1
    }
  },
  [124] = {
    id = 124,
    Type = "wait_time",
    Params = {time = 1000}
  },
  [125] = {
    id = 125,
    Type = "play_sound",
    Params = {
      path = "Skill/MagicCatch_attack"
    }
  },
  [126] = {
    id = 126,
    Type = "play_effect_scene",
    Params = {
      id = 47,
      path = "Skill/MagicRiot_attack",
      pos = {
        9.5,
        1.48,
        9.11
      },
      onshot = 1,
      ignoreNavMesh = 1
    }
  },
  [127] = {
    id = 127,
    Type = "play_effect_scene",
    Params = {
      id = 112,
      path = "Skill/Mechanic_Electrostatic",
      pos = {
        9.5,
        1.48,
        9.11
      },
      onshot = 1,
      ignoreNavMesh = 1
    }
  },
  [128] = {
    id = 128,
    Type = "remove_npc",
    Params = {npcuid = 807658}
  },
  [129] = {
    id = 129,
    Type = "summon",
    Params = {
      npcid = 807671,
      npcuid = 807671,
      pos = {
        9.5,
        1.48,
        9.11
      },
      dir = 322.49,
      groupid = 1,
      scale = 1.3
    }
  },
  [130] = {
    id = 130,
    Type = "wait_time",
    Params = {time = 800}
  },
  [131] = {
    id = 131,
    Type = "play_sound",
    Params = {
      path = "Skill/MagicCatch_attack"
    }
  },
  [132] = {
    id = 132,
    Type = "play_effect_scene",
    Params = {
      id = 48,
      path = "Skill/MagicRiot_attack",
      pos = {
        6.55,
        1.56,
        9.54
      },
      onshot = 1,
      ignoreNavMesh = 1
    }
  },
  [133] = {
    id = 133,
    Type = "play_effect_scene",
    Params = {
      id = 113,
      path = "Skill/Mechanic_Electrostatic",
      pos = {
        6.55,
        1.56,
        9.54
      },
      onshot = 1,
      ignoreNavMesh = 1
    }
  },
  [134] = {
    id = 134,
    Type = "remove_npc",
    Params = {npcuid = 807659}
  },
  [135] = {
    id = 135,
    Type = "summon",
    Params = {
      npcid = 807672,
      npcuid = 807672,
      pos = {
        6.55,
        1.56,
        9.54
      },
      dir = 344.14,
      groupid = 1,
      scale = 1.3,
      ignoreNavMesh = 1
    }
  },
  [136] = {
    id = 136,
    Type = "wait_time",
    Params = {time = 800}
  },
  [137] = {
    id = 137,
    Type = "play_sound",
    Params = {
      path = "Skill/MagicCatch_attack"
    }
  },
  [138] = {
    id = 138,
    Type = "play_effect_scene",
    Params = {
      id = 49,
      path = "Skill/MagicRiot_attack",
      pos = {
        2.86,
        1.56,
        10.29
      },
      onshot = 1,
      ignoreNavMesh = 1
    }
  },
  [139] = {
    id = 139,
    Type = "play_effect_scene",
    Params = {
      id = 114,
      path = "Skill/Mechanic_Electrostatic",
      pos = {
        2.86,
        1.56,
        10.29
      },
      onshot = 1,
      ignoreNavMesh = 1
    }
  },
  [140] = {
    id = 140,
    Type = "remove_npc",
    Params = {npcuid = 807660}
  },
  [141] = {
    id = 141,
    Type = "summon",
    Params = {
      npcid = 807673,
      npcuid = 807673,
      pos = {
        2.86,
        1.56,
        10.29
      },
      dir = 21.99,
      groupid = 1,
      scale = 1.3,
      ignoreNavMesh = 1
    }
  },
  [142] = {
    id = 142,
    Type = "wait_time",
    Params = {time = 800}
  },
  [143] = {
    id = 143,
    Type = "play_sound",
    Params = {
      path = "Skill/MagicCatch_attack"
    }
  },
  [144] = {
    id = 144,
    Type = "play_effect_scene",
    Params = {
      id = 50,
      path = "Skill/MagicRiot_attack",
      pos = {
        0.41,
        1.61,
        9.54
      },
      onshot = 1,
      ignoreNavMesh = 1
    }
  },
  [145] = {
    id = 145,
    Type = "play_effect_scene",
    Params = {
      id = 115,
      path = "Skill/Mechanic_Electrostatic",
      pos = {
        0.41,
        1.61,
        9.54
      },
      onshot = 1,
      ignoreNavMesh = 1
    }
  },
  [146] = {
    id = 146,
    Type = "remove_npc",
    Params = {npcuid = 807661}
  },
  [147] = {
    id = 147,
    Type = "summon",
    Params = {
      npcid = 807674,
      npcuid = 807674,
      pos = {
        0.41,
        1.61,
        9.54
      },
      dir = 25.92,
      groupid = 1,
      scale = 1.4,
      ignoreNavMesh = 1
    }
  },
  [148] = {
    id = 148,
    Type = "addbutton",
    Params = {
      id = 2,
      text = "##298190",
      eventtype = "goon"
    }
  },
  [149] = {
    id = 149,
    Type = "wait_ui",
    Params = {button = 2}
  },
  [150] = {
    id = 150,
    Type = "play_effect_scene",
    Params = {
      id = 55,
      path = "Skill/MentalShock_buff",
      pos = {
        4.82,
        1.61,
        13.61
      },
      onshot = 1
    }
  },
  [151] = {
    id = 151,
    Type = "wait_time",
    Params = {time = 1200}
  },
  [152] = {
    id = 152,
    Type = "showview",
    Params = {panelid = 800, showtype = 2}
  },
  [153] = {
    id = 153,
    Type = "endfilter",
    Params = {
      fliter = {39}
    }
  },
  [154] = {
    id = 154,
    Type = "onoff_camerapoint",
    Params = {
      groupid = 2,
      on = false,
      returnDefaultTime = 1500
    }
  }
}
Table_PlotQuest_83_fields = {
  "id",
  "Type",
  "Params"
}
return Table_PlotQuest_83
