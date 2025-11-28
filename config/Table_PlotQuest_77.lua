Table_PlotQuest_77 = {
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
    Type = "showview",
    Params = {panelid = 800, showtype = 1}
  },
  [4] = {
    id = 4,
    Type = "onoff_camerapoint",
    Params = {groupid = 3, on = true}
  },
  [5] = {
    id = 5,
    Type = "wait_time",
    Params = {time = 1000}
  },
  [6] = {
    id = 6,
    Type = "summon",
    Params = {
      npcid = 803836,
      npcuid = 803836,
      pos = {
        -0.04,
        2.3,
        18.8
      },
      dir = 180
    }
  },
  [7] = {
    id = 7,
    Type = "play_effect_scene",
    Params = {
      id = 34,
      path = "Common/YellowMF",
      pos = {
        -0.04,
        -0.25,
        18.8
      },
      ignoreNavMesh = 1
    }
  },
  [8] = {
    id = 8,
    Type = "play_effect_scene",
    Params = {
      id = 1,
      path = "Common/MagicBall_water",
      pos = {
        2.69,
        1.7,
        21.68
      },
      ignoreNavMesh = 1
    }
  },
  [9] = {
    id = 9,
    Type = "play_effect_scene",
    Params = {
      id = 2,
      path = "Common/MagicBall_land",
      pos = {
        -2.39,
        1.7,
        21.66
      },
      ignoreNavMesh = 1
    }
  },
  [10] = {
    id = 10,
    Type = "play_effect_scene",
    Params = {
      id = 3,
      path = "Common/MagicBall_fire",
      pos = {
        2.84,
        1.7,
        17.08
      },
      ignoreNavMesh = 1
    }
  },
  [11] = {
    id = 11,
    Type = "play_effect_scene",
    Params = {
      id = 4,
      path = "Common/MagicBall_wind",
      pos = {
        -2.52,
        1.7,
        17.16
      },
      ignoreNavMesh = 1
    }
  },
  [12] = {
    id = 12,
    Type = "wait_time",
    Params = {time = 2000}
  },
  [13] = {
    id = 13,
    Type = "addbutton",
    Params = {
      id = 1,
      text = "##298185",
      eventtype = "goon"
    }
  },
  [14] = {
    id = 14,
    Type = "wait_ui",
    Params = {button = 1}
  },
  [15] = {
    id = 15,
    Type = "play_sound",
    Params = {
      path = "Common/CrystalTower_2_1"
    }
  },
  [16] = {
    id = 16,
    Type = "play_effect",
    Params = {
      id = 9,
      path = "Skill/Flash_atk1_huge",
      onshot = 1,
      player = 1,
      ep = 2
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
      id = 35,
      path = "Skill/WindWard_atk",
      onshot = 1,
      pos = {
        4.66,
        0.43,
        18.34
      },
      ignoreNavMesh = 1
    }
  },
  [19] = {
    id = 19,
    Type = "wait_time",
    Params = {time = 500}
  },
  [20] = {
    id = 20,
    Type = "play_effect_scene",
    Params = {
      id = 36,
      path = "Skill/WindWard_atk",
      onshot = 1,
      pos = {
        3.04,
        0.43,
        16.05
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
    Type = "play_effect_scene",
    Params = {
      id = 37,
      path = "Skill/WindWard_atk",
      onshot = 1,
      pos = {
        -3.36,
        0.43,
        16.01
      },
      ignoreNavMesh = 1
    }
  },
  [23] = {
    id = 23,
    Type = "wait_time",
    Params = {time = 500}
  },
  [24] = {
    id = 24,
    Type = "play_effect_scene",
    Params = {
      id = 38,
      path = "Skill/WindWard_atk",
      onshot = 1,
      pos = {
        -5.35,
        0.43,
        18.56
      },
      ignoreNavMesh = 1
    }
  },
  [25] = {
    id = 25,
    Type = "wait_time",
    Params = {time = 2000}
  },
  [26] = {
    id = 26,
    Type = "addbutton",
    Params = {
      id = 2,
      text = "##298184",
      eventtype = "goon"
    }
  },
  [27] = {
    id = 27,
    Type = "wait_ui",
    Params = {button = 2}
  },
  [28] = {
    id = 28,
    Type = "play_sound",
    Params = {
      path = "Skill/Thunderstorm_attack"
    }
  },
  [29] = {
    id = 29,
    Type = "play_effect_scene",
    Params = {
      id = 94,
      path = "Skill/Thunderstorm_hit",
      onshot = 1,
      pos = {
        -0.04,
        0.2,
        18.8
      },
      ignoreNavMesh = 1
    }
  },
  [30] = {
    id = 30,
    Type = "wait_time",
    Params = {time = 1000}
  },
  [31] = {
    id = 31,
    Type = "play_effect",
    Params = {
      id = 10,
      path = "Skill/Eff_ShenlongBoxing_hit",
      onshot = 1,
      pos = {
        0.08,
        -0.43,
        17.28
      }
    }
  },
  [32] = {
    id = 32,
    Type = "wait_time",
    Params = {time = 1000}
  },
  [33] = {
    id = 33,
    Type = "play_sound",
    Params = {
      path = "Common/Skill_cast"
    }
  },
  [34] = {
    id = 34,
    Type = "play_effect_scene",
    Params = {
      id = 84,
      path = "Skill/MagicFreeze_atk",
      onshot = 1,
      pos = {
        4.66,
        0.43,
        18.34
      },
      ignoreNavMesh = 1
    }
  },
  [35] = {
    id = 35,
    Type = "play_effect_scene",
    Params = {
      id = 80,
      path = "Skill/WindWard_atk",
      onshot = 1,
      pos = {
        -5.35,
        0.43,
        18.56
      },
      ignoreNavMesh = 1
    }
  },
  [36] = {
    id = 36,
    Type = "wait_time",
    Params = {time = 500}
  },
  [37] = {
    id = 37,
    Type = "play_sound",
    Params = {
      path = "Common/Skill_cast"
    }
  },
  [38] = {
    id = 38,
    Type = "play_effect_scene",
    Params = {
      id = 85,
      path = "Skill/MagicFreeze_atk",
      onshot = 1,
      pos = {
        3.04,
        0.43,
        16.05
      },
      ignoreNavMesh = 1
    }
  },
  [39] = {
    id = 39,
    Type = "play_effect_scene",
    Params = {
      id = 81,
      path = "Skill/WindWard_atk",
      onshot = 1,
      pos = {
        -3.36,
        0.43,
        16.01
      },
      ignoreNavMesh = 1
    }
  },
  [40] = {
    id = 40,
    Type = "wait_time",
    Params = {time = 500}
  },
  [41] = {
    id = 41,
    Type = "play_sound",
    Params = {
      path = "Common/Skill_cast"
    }
  },
  [42] = {
    id = 42,
    Type = "play_effect_scene",
    Params = {
      id = 86,
      path = "Skill/MagicFreeze_atk",
      onshot = 1,
      pos = {
        -3.36,
        0.43,
        16.01
      },
      ignoreNavMesh = 1
    }
  },
  [43] = {
    id = 43,
    Type = "play_effect_scene",
    Params = {
      id = 82,
      path = "Skill/WindWard_atk",
      onshot = 1,
      pos = {
        3.04,
        0.43,
        16.05
      },
      ignoreNavMesh = 1
    }
  },
  [44] = {
    id = 44,
    Type = "wait_time",
    Params = {time = 500}
  },
  [45] = {
    id = 45,
    Type = "play_sound",
    Params = {
      path = "Common/Skill_cast"
    }
  },
  [46] = {
    id = 46,
    Type = "play_effect_scene",
    Params = {
      id = 87,
      path = "Skill/MagicFreeze_atk",
      onshot = 1,
      pos = {
        -5.35,
        0.43,
        18.56
      },
      ignoreNavMesh = 1
    }
  },
  [47] = {
    id = 47,
    Type = "play_effect_scene",
    Params = {
      id = 83,
      path = "Skill/WindWard_atk",
      onshot = 1,
      pos = {
        4.66,
        0.43,
        18.34
      },
      ignoreNavMesh = 1
    }
  },
  [48] = {
    id = 48,
    Type = "play_effect_scene",
    Params = {
      id = 5,
      path = "Common/Rhine_fairy",
      pos = {
        2.69,
        1.4,
        21.68
      },
      ignoreNavMesh = 1
    }
  },
  [49] = {
    id = 49,
    Type = "play_sound",
    Params = {
      path = "Common/Increase"
    }
  },
  [50] = {
    id = 50,
    Type = "wait_time",
    Params = {time = 1000}
  },
  [51] = {
    id = 51,
    Type = "play_effect_scene",
    Params = {
      id = 6,
      path = "Common/Rhine_fairy",
      pos = {
        -2.39,
        1.4,
        21.66
      },
      ignoreNavMesh = 1
    }
  },
  [52] = {
    id = 52,
    Type = "play_sound",
    Params = {
      path = "Common/Increase"
    }
  },
  [53] = {
    id = 53,
    Type = "wait_time",
    Params = {time = 1000}
  },
  [54] = {
    id = 54,
    Type = "play_effect_scene",
    Params = {
      id = 7,
      path = "Common/Rhine_fairy",
      pos = {
        2.84,
        1.4,
        17.08
      },
      ignoreNavMesh = 1
    }
  },
  [55] = {
    id = 55,
    Type = "play_sound",
    Params = {
      path = "Common/Increase"
    }
  },
  [56] = {
    id = 56,
    Type = "wait_time",
    Params = {time = 1000}
  },
  [57] = {
    id = 57,
    Type = "play_effect_scene",
    Params = {
      id = 8,
      path = "Common/Rhine_fairy",
      pos = {
        -2.52,
        1.4,
        17.16
      },
      ignoreNavMesh = 1
    }
  },
  [58] = {
    id = 58,
    Type = "play_sound",
    Params = {
      path = "Common/Increase"
    }
  },
  [59] = {
    id = 59,
    Type = "wait_time",
    Params = {time = 2000}
  },
  [60] = {
    id = 60,
    Type = "addbutton",
    Params = {
      id = 3,
      text = "##298186",
      eventtype = "goon"
    }
  },
  [61] = {
    id = 61,
    Type = "wait_ui",
    Params = {button = 3}
  },
  [62] = {
    id = 62,
    Type = "move",
    Params = {
      player = 1,
      pos = {
        0.08,
        -0.43,
        17.28
      },
      spd = 1,
      dir = 1
    }
  },
  [63] = {
    id = 63,
    Type = "wait_pos",
    Params = {
      player = 1,
      pos = {
        0.08,
        -0.43,
        17.28
      },
      distance = 1
    }
  },
  [64] = {
    id = 64,
    Type = "wait_time",
    Params = {time = 1000}
  },
  [65] = {
    id = 65,
    Type = "set_dir",
    Params = {player = 1, dir = 358}
  },
  [66] = {
    id = 66,
    Type = "action",
    Params = {player = 1, id = 88}
  },
  [67] = {
    id = 67,
    Type = "onoff_camerapoint",
    Params = {groupid = 3, on = false}
  },
  [68] = {
    id = 68,
    Type = "onoff_camerapoint",
    Params = {groupid = 2, on = true}
  },
  [69] = {
    id = 69,
    Type = "play_effect_scene",
    Params = {
      id = 11,
      path = "Skill/ThunderSpear_attack",
      pos = {
        0.07,
        0.01,
        18.08
      },
      ignoreNavMesh = 1
    }
  },
  [70] = {
    id = 70,
    Type = "wait_time",
    Params = {time = 2000}
  },
  [71] = {
    id = 71,
    Type = "play_sound",
    Params = {
      path = "Common/1thFireworks15"
    }
  },
  [72] = {
    id = 72,
    Type = "play_effect_scene",
    Params = {
      id = 12,
      path = "Skill/ShiningPunch_6",
      onshot = 1,
      pos = {
        2.69,
        1.5,
        21.68
      },
      ignoreNavMesh = 1,
      dir = {
        12.76,
        -137.1,
        -8.76
      }
    }
  },
  [73] = {
    id = 73,
    Type = "play_effect_scene",
    Params = {
      id = 13,
      path = "Skill/ShiningPunch_6",
      onshot = 1,
      pos = {
        -2.39,
        1.5,
        21.66
      },
      ignoreNavMesh = 1,
      dir = {
        -2.69,
        139.61,
        0.63
      }
    }
  },
  [74] = {
    id = 74,
    Type = "play_effect_scene",
    Params = {
      id = 14,
      path = "Skill/ShiningPunch_6",
      onshot = 1,
      pos = {
        2.84,
        1.5,
        17.08
      },
      ignoreNavMesh = 1,
      dir = {
        12.95,
        -54.82,
        2.19
      }
    }
  },
  [75] = {
    id = 75,
    Type = "play_effect_scene",
    Params = {
      id = 15,
      path = "Skill/ShiningPunch_6",
      onshot = 1,
      pos = {
        -2.52,
        1.5,
        17.16
      },
      ignoreNavMesh = 1,
      dir = {
        12.75,
        50.65,
        4.37
      }
    }
  },
  [76] = {
    id = 76,
    Type = "wait_time",
    Params = {time = 1500}
  },
  [77] = {
    id = 77,
    Type = "play_sound",
    Params = {
      path = "Common/1thFireworks15"
    }
  },
  [78] = {
    id = 78,
    Type = "play_effect_scene",
    Params = {
      id = 12,
      path = "Skill/ShiningPunch_6",
      onshot = 1,
      pos = {
        2.69,
        1.5,
        21.68
      },
      ignoreNavMesh = 1,
      dir = {
        12.76,
        -137.1,
        -8.76
      }
    }
  },
  [79] = {
    id = 79,
    Type = "play_effect_scene",
    Params = {
      id = 13,
      path = "Skill/ShiningPunch_6",
      onshot = 1,
      pos = {
        -2.39,
        1.5,
        21.66
      },
      ignoreNavMesh = 1,
      dir = {
        -2.69,
        139.61,
        0.63
      }
    }
  },
  [80] = {
    id = 80,
    Type = "play_effect_scene",
    Params = {
      id = 14,
      path = "Skill/ShiningPunch_6",
      onshot = 1,
      pos = {
        2.84,
        1.5,
        17.08
      },
      ignoreNavMesh = 1,
      dir = {
        12.95,
        -54.82,
        2.19
      }
    }
  },
  [81] = {
    id = 81,
    Type = "play_effect_scene",
    Params = {
      id = 15,
      path = "Skill/ShiningPunch_6",
      onshot = 1,
      pos = {
        -2.52,
        1.5,
        17.16
      },
      ignoreNavMesh = 1,
      dir = {
        12.75,
        50.65,
        4.37
      }
    }
  },
  [82] = {
    id = 82,
    Type = "wait_time",
    Params = {time = 1500}
  },
  [83] = {
    id = 83,
    Type = "play_sound",
    Params = {
      path = "Common/1thFireworks15"
    }
  },
  [84] = {
    id = 84,
    Type = "play_effect_scene",
    Params = {
      id = 88,
      path = "Skill/ShiningPunch_6",
      onshot = 1,
      pos = {
        2.69,
        1.5,
        21.68
      },
      ignoreNavMesh = 1,
      dir = {
        12.76,
        -137.1,
        -8.76
      }
    }
  },
  [85] = {
    id = 85,
    Type = "play_effect_scene",
    Params = {
      id = 89,
      path = "Skill/ShiningPunch_6",
      onshot = 1,
      pos = {
        -2.39,
        1.5,
        21.66
      },
      ignoreNavMesh = 1,
      dir = {
        -2.69,
        139.61,
        0.63
      }
    }
  },
  [86] = {
    id = 86,
    Type = "play_effect_scene",
    Params = {
      id = 90,
      path = "Skill/ShiningPunch_6",
      onshot = 1,
      pos = {
        2.84,
        1.5,
        17.08
      },
      ignoreNavMesh = 1,
      dir = {
        12.95,
        -54.82,
        2.19
      }
    }
  },
  [87] = {
    id = 87,
    Type = "play_effect_scene",
    Params = {
      id = 91,
      path = "Skill/ShiningPunch_6",
      onshot = 1,
      pos = {
        -2.52,
        1.5,
        17.16
      },
      ignoreNavMesh = 1,
      dir = {
        12.75,
        50.65,
        4.37
      }
    }
  },
  [88] = {
    id = 88,
    Type = "wait_time",
    Params = {time = 1000}
  },
  [89] = {
    id = 89,
    Type = "play_effect_scene",
    Params = {
      id = 16,
      path = "Common/Magatama_playshow_F",
      onshot = 1,
      pos = {
        -0.04,
        2.82,
        18.8
      },
      ignoreNavMesh = 1
    }
  },
  [90] = {
    id = 90,
    Type = "play_sound",
    Params = {
      path = "Common/1thFireworks16"
    }
  },
  [91] = {
    id = 91,
    Type = "wait_time",
    Params = {time = 1000}
  },
  [92] = {
    id = 92,
    Type = "play_effect_scene",
    Params = {
      id = 40,
      path = "Skill/CatLight",
      onshot = 1,
      pos = {
        -2.75,
        -0.37,
        20.61
      },
      ignoreNavMesh = 1,
      dir = {
        -18.92,
        -136.57,
        0
      }
    }
  },
  [93] = {
    id = 93,
    Type = "play_effect_scene",
    Params = {
      id = 41,
      path = "Skill/CatLight",
      onshot = 1,
      pos = {
        -1.5,
        -0.37,
        18.88
      },
      ignoreNavMesh = 1,
      dir = {
        -18.58,
        -147.85,
        0
      }
    }
  },
  [94] = {
    id = 94,
    Type = "play_effect_scene",
    Params = {
      id = 42,
      path = "Skill/CatLight",
      onshot = 1,
      pos = {
        2.76,
        -0.3,
        20.69
      },
      ignoreNavMesh = 1,
      dir = {
        -17.03,
        146.79,
        0
      }
    }
  },
  [95] = {
    id = 95,
    Type = "play_effect_scene",
    Params = {
      id = 43,
      path = "Skill/CatLight",
      onshot = 1,
      pos = {
        2.0,
        -0.37,
        19.2
      },
      ignoreNavMesh = 1,
      dir = {
        -17.58,
        135.07,
        0
      }
    }
  },
  [96] = {
    id = 96,
    Type = "wait_time",
    Params = {time = 3000}
  },
  [97] = {
    id = 97,
    Type = "play_sound",
    Params = {
      path = "Common/snake_appear"
    }
  },
  [98] = {
    id = 98,
    Type = "play_effect_scene",
    Params = {
      id = 92,
      path = "Skill/ThunderSpear_hit02",
      onshot = 1,
      pos = {
        -0.04,
        1.35,
        18.9
      },
      ignoreNavMesh = 1
    }
  },
  [99] = {
    id = 99,
    Type = "remove_npc",
    Params = {npcuid = 803836}
  },
  [100] = {
    id = 100,
    Type = "play_effect_scene",
    Params = {
      id = 93,
      path = "Skill/Eff_Eliminate_area04",
      onshot = 1,
      pos = {
        -0.04,
        1.52,
        18.9
      },
      ignoreNavMesh = 1
    }
  },
  [101] = {
    id = 101,
    Type = "remove_effect_scene",
    Params = {id = 34}
  },
  [102] = {
    id = 102,
    Type = "play_effect_scene",
    Params = {
      id = 44,
      path = "Skill/Eff_LifeFusion_atk",
      onshot = 1,
      pos = {
        -6.79,
        0.3,
        18.16
      }
    }
  },
  [103] = {
    id = 103,
    Type = "play_effect_scene",
    Params = {
      id = 45,
      path = "Skill/Eff_LifeFusion_atk",
      onshot = 1,
      pos = {
        -6.04,
        0.3,
        14.95
      }
    }
  },
  [104] = {
    id = 104,
    Type = "play_effect_scene",
    Params = {
      id = 46,
      path = "Skill/Eff_LifeFusion_atk",
      onshot = 1,
      pos = {
        6.39,
        0.3,
        17.7
      }
    }
  },
  [105] = {
    id = 105,
    Type = "play_effect_scene",
    Params = {
      id = 47,
      path = "Skill/Eff_LifeFusion_atk",
      onshot = 1,
      pos = {
        5.7,
        0.3,
        13.92
      }
    }
  },
  [106] = {
    id = 106,
    Type = "wait_time",
    Params = {time = 500}
  },
  [107] = {
    id = 107,
    Type = "play_sound",
    Params = {
      path = "Common/explosion"
    }
  },
  [108] = {
    id = 108,
    Type = "play_effect_scene",
    Params = {
      id = 17,
      path = "Skill/Starshining_hit",
      onshot = 1,
      pos = {
        -0.04,
        2.82,
        18.8
      },
      ignoreNavMesh = 1
    }
  },
  [109] = {
    id = 109,
    Type = "summon",
    Params = {
      npcid = 803837,
      npcuid = 803837,
      pos = {
        -0.04,
        3.32,
        18.8
      },
      dir = 180
    }
  },
  [110] = {
    id = 110,
    Type = "play_effect_scene",
    Params = {
      id = 30,
      path = "Skill/Eff_tuanben3_xiersu02",
      pos = {
        -0.04,
        0.35,
        18.8
      },
      ignoreNavMesh = 1
    }
  },
  [111] = {
    id = 111,
    Type = "play_effect_scene",
    Params = {
      id = 33,
      path = "Skill/Eff_tuanben3_xiersu01",
      pos = {
        -0.04,
        1.35,
        18.8
      },
      ignoreNavMesh = 1
    }
  },
  [112] = {
    id = 112,
    Type = "play_effect_scene",
    Params = {
      id = 48,
      path = "Skill/HardSunshine_buff",
      pos = {
        -6.79,
        1.1,
        18.16
      },
      ignoreNavMesh = 1
    }
  },
  [113] = {
    id = 113,
    Type = "play_effect_scene",
    Params = {
      id = 49,
      path = "Skill/HardSunshine_buff",
      pos = {
        -6.04,
        1.1,
        14.95
      },
      ignoreNavMesh = 1
    }
  },
  [114] = {
    id = 114,
    Type = "play_effect_scene",
    Params = {
      id = 50,
      path = "Skill/HardSunshine_buff",
      pos = {
        6.39,
        1.1,
        17.7
      },
      ignoreNavMesh = 1
    }
  },
  [115] = {
    id = 115,
    Type = "play_effect_scene",
    Params = {
      id = 51,
      path = "Skill/HardSunshine_buff",
      pos = {
        5.7,
        1.1,
        13.92
      },
      ignoreNavMesh = 1
    }
  },
  [116] = {
    id = 116,
    Type = "play_effect_scene",
    Params = {
      id = 52,
      path = "Common/PhotonForce_Blue",
      pos = {
        -0.06,
        4.25,
        19.91
      },
      ignoreNavMesh = 1
    }
  },
  [117] = {
    id = 117,
    Type = "wait_time",
    Params = {time = 500}
  },
  [118] = {
    id = 118,
    Type = "play_effect_scene",
    Params = {
      id = 96,
      path = "Skill/CrushingImpact_atk",
      pos = {
        5.7,
        1.69,
        13.92
      },
      ignoreNavMesh = 1,
      onshot = 1
    }
  },
  [119] = {
    id = 119,
    Type = "wait_time",
    Params = {time = 2000}
  },
  [120] = {
    id = 120,
    Type = "play_effect_scene",
    Params = {
      id = 97,
      path = "Common/Poring_Skill",
      pos = {
        -0.04,
        0.75,
        18.8
      },
      ignoreNavMesh = 1
    }
  },
  [121] = {
    id = 121,
    Type = "play_effect_scene",
    Params = {
      id = 99,
      path = "Common/Poring_Skill",
      pos = {
        -0.04,
        1.85,
        18.8
      },
      ignoreNavMesh = 1
    }
  },
  [122] = {
    id = 122,
    Type = "dialog",
    Params = {
      dialog = {550826, 550827}
    }
  },
  [123] = {
    id = 123,
    Type = "addbutton",
    Params = {
      id = 4,
      text = "##298187",
      eventtype = "goon"
    }
  },
  [124] = {
    id = 124,
    Type = "wait_ui",
    Params = {button = 4}
  },
  [125] = {
    id = 125,
    Type = "move",
    Params = {
      player = 1,
      pos = {
        0.07,
        -0.31,
        17.04
      },
      spd = 1,
      dir = 6
    }
  },
  [126] = {
    id = 126,
    Type = "wait_time",
    Params = {time = 1000}
  },
  [127] = {
    id = 127,
    Type = "set_dir",
    Params = {player = 1, dir = 358}
  },
  [128] = {
    id = 128,
    Type = "action",
    Params = {player = 1, id = 88}
  },
  [129] = {
    id = 129,
    Type = "wait_time",
    Params = {time = 1000}
  },
  [130] = {
    id = 130,
    Type = "play_sound",
    Params = {
      path = "Common/CrystalTower_2_1"
    }
  },
  [131] = {
    id = 131,
    Type = "play_effect_scene",
    Params = {
      id = 30,
      path = "Skill/Eff_tuanben3_xiersu02",
      pos = {
        -0.04,
        0.25,
        18.8
      },
      ignoreNavMesh = 1
    }
  },
  [132] = {
    id = 132,
    Type = "play_effect_scene",
    Params = {
      id = 33,
      path = "Skill/Eff_tuanben3_xiersu01",
      pos = {
        -0.04,
        1.05,
        18.8
      },
      ignoreNavMesh = 1
    }
  },
  [133] = {
    id = 133,
    Type = "play_effect_scene",
    Params = {
      id = 69,
      path = "Skill/LVUP_Process_2",
      onshot = 1,
      pos = {
        -0.04,
        0.82,
        18.9
      },
      ignoreNavMesh = 1
    }
  },
  [134] = {
    id = 134,
    Type = "wait_time",
    Params = {time = 1000}
  },
  [135] = {
    id = 135,
    Type = "play_effect_scene",
    Params = {
      id = 71,
      path = "Skill/Eff_Eliminate_area04",
      pos = {
        -0.04,
        0.82,
        18.9
      },
      ignoreNavMesh = 1
    }
  },
  [136] = {
    id = 136,
    Type = "dialog",
    Params = {
      dialog = {550828}
    }
  },
  [137] = {
    id = 137,
    Type = "wait_time",
    Params = {time = 500}
  },
  [138] = {
    id = 138,
    Type = "play_effect_scene",
    Params = {
      id = 95,
      path = "Skill/Eff_nvshenchuchang",
      pos = {
        -0.04,
        3.32,
        18.8
      },
      onshot = 1
    }
  },
  [139] = {
    id = 139,
    Type = "play_effect_scene",
    Params = {
      id = 19,
      path = "Skill/SilentKiller",
      onshot = 1,
      pos = {
        -0.04,
        3.32,
        18.8
      },
      ignoreNavMesh = 1
    }
  },
  [140] = {
    id = 140,
    Type = "remove_effect_scene",
    Params = {id = 18}
  },
  [141] = {
    id = 141,
    Type = "remove_effect_scene",
    Params = {id = 11}
  },
  [142] = {
    id = 142,
    Type = "wait_time",
    Params = {time = 1000}
  },
  [143] = {
    id = 143,
    Type = "play_sound",
    Params = {
      path = "Common/Skill_cast"
    }
  },
  [144] = {
    id = 144,
    Type = "play_effect_scene",
    Params = {
      id = 25,
      path = "Skill/Kafra4up_buff",
      pos = {
        -1.9,
        1.64,
        19.75
      },
      ignoreNavMesh = 1
    }
  },
  [145] = {
    id = 145,
    Type = "play_effect_scene",
    Params = {
      id = 56,
      path = "Skill/Kafra4up_buff",
      pos = {
        2.69,
        1.7,
        21.68
      },
      ignoreNavMesh = 1
    }
  },
  [146] = {
    id = 146,
    Type = "play_effect_scene",
    Params = {
      id = 57,
      path = "Skill/Kafra4up_buff",
      pos = {
        -2.39,
        1.7,
        21.66
      },
      ignoreNavMesh = 1
    }
  },
  [147] = {
    id = 147,
    Type = "play_effect_scene",
    Params = {
      id = 58,
      path = "Skill/Kafra4up_buff",
      pos = {
        2.84,
        1.7,
        17.08
      },
      ignoreNavMesh = 1
    }
  },
  [148] = {
    id = 148,
    Type = "play_effect_scene",
    Params = {
      id = 59,
      path = "Skill/Kafra4up_buff",
      pos = {
        -2.52,
        1.4,
        17.16
      },
      ignoreNavMesh = 1
    }
  },
  [149] = {
    id = 149,
    Type = "wait_time",
    Params = {time = 1000}
  },
  [150] = {
    id = 150,
    Type = "play_effect_scene",
    Params = {
      id = 77,
      path = "Skill/Eff_Detale_fanghuzhao_buff",
      pos = {
        -0.04,
        1.32,
        18.8
      }
    }
  },
  [151] = {
    id = 151,
    Type = "wait_time",
    Params = {time = 2000}
  },
  [152] = {
    id = 152,
    Type = "play_effect_scene",
    Params = {
      id = 18,
      path = "Common/DontForgetWolf",
      pos = {
        0.07,
        -0.31,
        17.04
      },
      ignoreNavMesh = 1
    }
  },
  [153] = {
    id = 153,
    Type = "play_sound",
    Params = {
      path = "Skill/attack11"
    }
  },
  [154] = {
    id = 154,
    Type = "play_effect_scene",
    Params = {
      id = 70,
      path = "Skill/Eff_Eliminate_area04",
      pos = {
        -0.04,
        0.12,
        18.9
      },
      ignoreNavMesh = 1
    }
  },
  [155] = {
    id = 155,
    Type = "remove_effect_scene",
    Params = {id = 30}
  },
  [156] = {
    id = 156,
    Type = "wait_time",
    Params = {time = 3000}
  },
  [157] = {
    id = 157,
    Type = "remove_effect_scene",
    Params = {id = 77}
  },
  [158] = {
    id = 158,
    Type = "showview",
    Params = {panelid = 800, showtype = 2}
  },
  [159] = {
    id = 159,
    Type = "remove_npc",
    Params = {npcuid = 803837}
  },
  [160] = {
    id = 160,
    Type = "endfilter",
    Params = {
      fliter = {39}
    }
  }
}
Table_PlotQuest_77_fields = {
  "id",
  "Type",
  "Params"
}
return Table_PlotQuest_77
