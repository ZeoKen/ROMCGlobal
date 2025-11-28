Table_PlotQuest_95 = {
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
    Type = "move",
    Params = {
      player = 1,
      pos = {
        -13.53,
        0.62,
        22.18
      },
      spd = 1
    }
  },
  [5] = {
    id = 5,
    Type = "set_dir",
    Params = {dir = 131, player = 1}
  },
  [6] = {
    id = 6,
    Type = "wait_pos",
    Params = {
      player = 1,
      pos = {
        -13.53,
        0.62,
        22.18
      },
      distance = 1
    }
  },
  [7] = {
    id = 7,
    Type = "summon",
    Params = {
      npcid = 813024,
      npcuid = 813024,
      pos = {
        -2.92,
        0.7,
        17.03
      },
      dir = 243,
      groupid = 1
    }
  },
  [8] = {
    id = 8,
    Type = "summon",
    Params = {
      npcid = 813026,
      npcuid = 813026,
      pos = {
        -14.12,
        0.62,
        27.58
      },
      dir = 180,
      groupid = 1
    }
  },
  [9] = {
    id = 9,
    Type = "summon",
    Params = {
      npcid = 813027,
      npcuid = 813027,
      pos = {
        -18.65,
        0.62,
        22.73
      },
      dir = 82.3,
      groupid = 1
    }
  },
  [10] = {
    id = 10,
    Type = "summon",
    Params = {
      npcid = 813028,
      npcuid = 813028,
      pos = {
        -13.28,
        0.63,
        18.04
      },
      dir = 2,
      groupid = 1
    }
  },
  [11] = {
    id = 11,
    Type = "summon",
    Params = {
      npcid = 813029,
      npcuid = 813029,
      pos = {
        -9.5,
        0.63,
        22.06
      },
      dir = -80,
      groupid = 1
    }
  },
  [12] = {
    id = 12,
    Type = "addbutton",
    Params = {
      id = 2,
      text = "##299453",
      eventtype = "goon"
    }
  },
  [13] = {
    id = 13,
    Type = "wait_ui",
    Params = {button = 2}
  },
  [14] = {
    id = 14,
    Type = "action",
    Params = {id = 11, npcuid = 813027}
  },
  [15] = {
    id = 15,
    Type = "talk",
    Params = {npcuid = 813027, talkid = 502435}
  },
  [16] = {
    id = 16,
    Type = "action",
    Params = {id = 11, npcuid = 813026}
  },
  [17] = {
    id = 17,
    Type = "talk",
    Params = {npcuid = 813026, talkid = 502436}
  },
  [18] = {
    id = 18,
    Type = "action",
    Params = {id = 11, npcuid = 813028}
  },
  [19] = {
    id = 19,
    Type = "talk",
    Params = {npcuid = 813028, talkid = 502437}
  },
  [20] = {
    id = 20,
    Type = "action",
    Params = {id = 11, npcuid = 813029}
  },
  [21] = {
    id = 21,
    Type = "talk",
    Params = {npcuid = 813029, talkid = 502438}
  },
  [22] = {
    id = 22,
    Type = "action",
    Params = {id = 11}
  },
  [23] = {
    id = 23,
    Type = "play_sound",
    Params = {
      path = "Skill/Begetter_shengminghechengti"
    }
  },
  [24] = {
    id = 24,
    Type = "play_effect_scene",
    Params = {
      id = 10,
      path = "Common/SigeShadow_Ball",
      pos = {
        -9.5,
        1,
        22.06
      },
      ignoreNavMesh = 1,
      scale = 9
    }
  },
  [25] = {
    id = 25,
    Type = "play_effect_scene",
    Params = {
      id = 11,
      path = "Common/MagicBall_land",
      pos = {
        -14.12,
        0.62,
        27.58
      },
      ignoreNavMesh = 1,
      scale = 3
    }
  },
  [26] = {
    id = 26,
    Type = "play_effect_scene",
    Params = {
      id = 12,
      path = "Common/MagicBall_water",
      pos = {
        -13.28,
        0.63,
        18.04
      },
      ignoreNavMesh = 1,
      scale = 3
    }
  },
  [27] = {
    id = 27,
    Type = "play_effect_scene",
    Params = {
      id = 13,
      path = "Common/MagicBall_wind",
      pos = {
        -18.65,
        0.62,
        22.73
      },
      ignoreNavMesh = 1,
      scale = 3
    }
  },
  [28] = {
    id = 28,
    Type = "play_effect_scene",
    Params = {
      id = 14,
      path = "Common/MagicBall_fire",
      pos = {
        -13.53,
        0.62,
        22.18
      },
      ignoreNavMesh = 1,
      scale = 3
    }
  },
  [29] = {
    id = 29,
    Type = "wait_time",
    Params = {time = 2000}
  },
  [30] = {
    id = 30,
    Type = "addbutton",
    Params = {
      id = 1,
      text = "##302307",
      eventtype = "goon"
    }
  },
  [31] = {
    id = 31,
    Type = "wait_ui",
    Params = {button = 1}
  },
  [32] = {
    id = 32,
    Type = "talk",
    Params = {player = 1, talkid = 502439}
  },
  [33] = {
    id = 33,
    Type = "summon",
    Params = {
      npcid = 813035,
      npcuid = 813035,
      pos = {
        -15.74,
        0.69,
        21.05
      },
      dir = 108.4,
      groupid = 1
    }
  },
  [34] = {
    id = 34,
    Type = "summon",
    Params = {
      npcid = 813036,
      npcuid = 813036,
      pos = {
        -13.37,
        0.69,
        19.19
      },
      dir = 6.68,
      groupid = 1
    }
  },
  [35] = {
    id = 35,
    Type = "summon",
    Params = {
      npcid = 813037,
      npcuid = 813037,
      pos = {
        -12.64,
        0.69,
        24.02
      },
      dir = 183,
      groupid = 1
    }
  },
  [36] = {
    id = 36,
    Type = "summon",
    Params = {
      npcid = 813038,
      npcuid = 813038,
      pos = {
        -10.4,
        0.69,
        21.75
      },
      dir = 250,
      groupid = 1
    }
  },
  [37] = {
    id = 37,
    Type = "summon",
    Params = {
      npcid = 813033,
      npcuid = 813033,
      pos = {
        -11.96,
        0.69,
        20.26
      },
      dir = 131.9,
      groupid = 1
    }
  },
  [38] = {
    id = 38,
    Type = "remove_effect_scene",
    Params = {id = 10}
  },
  [39] = {
    id = 39,
    Type = "remove_effect_scene",
    Params = {id = 11}
  },
  [40] = {
    id = 40,
    Type = "remove_effect_scene",
    Params = {id = 12}
  },
  [41] = {
    id = 41,
    Type = "remove_effect_scene",
    Params = {id = 13}
  },
  [42] = {
    id = 42,
    Type = "remove_effect_scene",
    Params = {id = 14}
  },
  [43] = {
    id = 43,
    Type = "play_sound",
    Params = {
      path = "Skill/attack5"
    }
  },
  [44] = {
    id = 44,
    Type = "play_effect",
    Params = {
      id = 17,
      path = "Skill/Eff_YoroiDen01",
      npcuid = 813026
    }
  },
  [45] = {
    id = 45,
    Type = "play_sound",
    Params = {
      path = "Skill/attack5"
    }
  },
  [46] = {
    id = 46,
    Type = "play_effect",
    Params = {
      id = 18,
      path = "Skill/Eff_YoroiDen01",
      npcuid = 813027
    }
  },
  [47] = {
    id = 47,
    Type = "play_sound",
    Params = {
      path = "Skill/attack5"
    }
  },
  [48] = {
    id = 48,
    Type = "play_effect",
    Params = {
      id = 19,
      path = "Skill/Eff_YoroiDen01",
      npcuid = 813028
    }
  },
  [49] = {
    id = 49,
    Type = "play_sound",
    Params = {
      path = "Skill/attack5"
    }
  },
  [50] = {
    id = 50,
    Type = "play_effect",
    Params = {
      id = 20,
      path = "Skill/Eff_YoroiDen01",
      npcuid = 813029
    }
  },
  [51] = {
    id = 51,
    Type = "wait_time",
    Params = {time = 4500}
  },
  [52] = {
    id = 52,
    Type = "play_effect_scene",
    Params = {
      id = 31,
      path = "Skill/Detonator_slow",
      pos = {
        -10.19,
        1.6,
        22.07
      },
      ignoreNavMesh = 1,
      onshot = 1
    }
  },
  [53] = {
    id = 53,
    Type = "play_effect_scene",
    Params = {
      id = 32,
      path = "Skill/Detonator_slow",
      pos = {
        -13.47,
        1.6,
        18.99
      },
      ignoreNavMesh = 1,
      onshot = 1
    }
  },
  [54] = {
    id = 54,
    Type = "play_effect_scene",
    Params = {
      id = 33,
      path = "Skill/Detonator_slow",
      pos = {
        -14.9,
        1.6,
        21.15
      },
      ignoreNavMesh = 1,
      onshot = 1
    }
  },
  [55] = {
    id = 55,
    Type = "play_effect_scene",
    Params = {
      id = 34,
      path = "Skill/Detonator_slow",
      pos = {
        -12.66,
        1.6,
        23.6
      },
      ignoreNavMesh = 1,
      onshot = 1
    }
  },
  [56] = {
    id = 56,
    Type = "wait_time",
    Params = {time = 500}
  },
  [57] = {
    id = 57,
    Type = "remove_npc",
    Params = {npcuid = 813033}
  },
  [58] = {
    id = 58,
    Type = "remove_npc",
    Params = {npcuid = 813035}
  },
  [59] = {
    id = 59,
    Type = "remove_npc",
    Params = {npcuid = 813036}
  },
  [60] = {
    id = 60,
    Type = "remove_npc",
    Params = {npcuid = 813037}
  },
  [61] = {
    id = 61,
    Type = "remove_npc",
    Params = {npcuid = 813038}
  },
  [62] = {
    id = 62,
    Type = "play_effect_scene",
    Params = {
      id = 35,
      path = "Skill/Detonator_slow",
      pos = {
        -11.03,
        1.6,
        21.74
      },
      ignoreNavMesh = 1,
      onshot = 1
    }
  },
  [63] = {
    id = 63,
    Type = "play_effect_scene",
    Params = {
      id = 36,
      path = "Skill/Detonator_slow",
      pos = {
        -13.15,
        1.6,
        19.71
      },
      ignoreNavMesh = 1,
      onshot = 1
    }
  },
  [64] = {
    id = 64,
    Type = "play_effect_scene",
    Params = {
      id = 37,
      path = "Skill/Detonator_slow",
      pos = {
        -14.37,
        1.6,
        21.17
      },
      ignoreNavMesh = 1,
      onshot = 1
    }
  },
  [65] = {
    id = 65,
    Type = "play_effect_scene",
    Params = {
      id = 38,
      path = "Skill/Detonator_slow",
      pos = {
        -12.51,
        1.6,
        22.83
      },
      ignoreNavMesh = 1,
      onshot = 1
    }
  },
  [66] = {
    id = 66,
    Type = "wait_time",
    Params = {time = 500}
  },
  [67] = {
    id = 67,
    Type = "play_effect_scene",
    Params = {
      id = 39,
      path = "Skill/Detonator_slow",
      pos = {
        -12,
        1.6,
        21.55
      },
      ignoreNavMesh = 1
    }
  },
  [68] = {
    id = 68,
    Type = "play_effect_scene",
    Params = {
      id = 40,
      path = "Skill/Detonator_slow",
      pos = {
        -13.01,
        1.6,
        20.57
      },
      ignoreNavMesh = 1
    }
  },
  [69] = {
    id = 69,
    Type = "play_effect_scene",
    Params = {
      id = 41,
      path = "Skill/Detonator_slow",
      pos = {
        -13.61,
        1.6,
        21.2
      },
      ignoreNavMesh = 1
    }
  },
  [70] = {
    id = 70,
    Type = "play_effect_scene",
    Params = {
      id = 42,
      path = "Skill/Detonator_slow",
      pos = {
        -12.6,
        1.6,
        22.15
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
    Type = "play_effect_scene",
    Params = {
      id = 43,
      path = "Skill/Wind_cast",
      pos = {
        -14.03,
        1,
        21.52
      },
      ignoreNavMesh = 1
    }
  },
  [73] = {
    id = 73,
    Type = "play_effect_scene",
    Params = {
      id = 44,
      path = "Skill/Water_cast",
      pos = {
        -12.71,
        1,
        20.36
      },
      ignoreNavMesh = 1
    }
  },
  [74] = {
    id = 74,
    Type = "play_effect_scene",
    Params = {
      id = 45,
      path = "Skill/Light_cast",
      pos = {
        -11.83,
        1,
        21.32
      },
      ignoreNavMesh = 1
    }
  },
  [75] = {
    id = 75,
    Type = "play_effect_scene",
    Params = {
      id = 46,
      path = "Skill/Earth_cast",
      pos = {
        -12.95,
        1,
        22.46
      },
      ignoreNavMesh = 1
    }
  },
  [76] = {
    id = 76,
    Type = "wait_time",
    Params = {time = 1000}
  },
  [77] = {
    id = 77,
    Type = "play_effect",
    Params = {
      id = 30,
      path = "Skill/Flame_HHD_atk",
      player = 1,
      scale = 2,
      onshot = 1
    }
  },
  [78] = {
    id = 78,
    Type = "wait_time",
    Params = {time = 2000}
  },
  [79] = {
    id = 79,
    Type = "remove_effect_scene",
    Params = {id = 43}
  },
  [80] = {
    id = 80,
    Type = "remove_effect_scene",
    Params = {id = 44}
  },
  [81] = {
    id = 81,
    Type = "remove_effect_scene",
    Params = {id = 45}
  },
  [82] = {
    id = 82,
    Type = "remove_effect_scene",
    Params = {id = 46}
  },
  [83] = {
    id = 83,
    Type = "play_effect",
    Params = {
      id = 21,
      path = "Skill/Eff_YoroiDen02",
      npcuid = 813026
    }
  },
  [84] = {
    id = 84,
    Type = "play_effect",
    Params = {
      id = 22,
      path = "Skill/Eff_YoroiDen02",
      npcuid = 813027
    }
  },
  [85] = {
    id = 85,
    Type = "play_effect",
    Params = {
      id = 23,
      path = "Skill/Eff_YoroiDen02",
      npcuid = 813028
    }
  },
  [86] = {
    id = 86,
    Type = "play_effect",
    Params = {
      id = 24,
      path = "Skill/Eff_YoroiDen02",
      npcuid = 813029
    }
  },
  [87] = {
    id = 87,
    Type = "wait_time",
    Params = {time = 1000}
  },
  [88] = {
    id = 88,
    Type = "play_effect",
    Params = {
      id = 1,
      path = "Common/functioal_show_noreason",
      npcuid = 813026
    }
  },
  [89] = {
    id = 89,
    Type = "play_effect",
    Params = {
      id = 2,
      path = "Common/functioal_show_noreason",
      npcuid = 813027
    }
  },
  [90] = {
    id = 90,
    Type = "play_effect",
    Params = {
      id = 3,
      path = "Common/functioal_show_noreason",
      npcuid = 813028
    }
  },
  [91] = {
    id = 91,
    Type = "play_effect",
    Params = {
      id = 4,
      path = "Common/functioal_show_noreason",
      npcuid = 813029
    }
  },
  [92] = {
    id = 92,
    Type = "play_sound",
    Params = {
      path = "Common/save"
    }
  },
  [93] = {
    id = 93,
    Type = "play_effect_scene",
    Params = {
      id = 15,
      path = "Skill/SprirtOfHolySpirit_buff",
      pos = {
        -12.36,
        1.6,
        20.89
      },
      ignoreNavMesh = 1,
      scale = 2
    }
  },
  [94] = {
    id = 94,
    Type = "remove_effect",
    Params = {id = 17}
  },
  [95] = {
    id = 95,
    Type = "remove_effect",
    Params = {id = 18}
  },
  [96] = {
    id = 96,
    Type = "remove_effect",
    Params = {id = 19}
  },
  [97] = {
    id = 97,
    Type = "remove_effect",
    Params = {id = 20}
  },
  [98] = {
    id = 98,
    Type = "remove_effect",
    Params = {id = 21}
  },
  [99] = {
    id = 99,
    Type = "remove_effect",
    Params = {id = 22}
  },
  [100] = {
    id = 100,
    Type = "remove_effect",
    Params = {id = 23}
  },
  [101] = {
    id = 101,
    Type = "remove_effect",
    Params = {id = 24}
  },
  [102] = {
    id = 102,
    Type = "summon",
    Params = {
      npcid = 813034,
      npcuid = 813034,
      pos = {
        -13.05,
        0.69,
        21.57
      },
      dir = 131.9,
      groupid = 1
    }
  },
  [103] = {
    id = 103,
    Type = "onoff_camerapoint",
    Params = {groupid = 0, on = false}
  },
  [104] = {
    id = 104,
    Type = "remove_npc",
    Params = {npcuid = 813034}
  },
  [105] = {
    id = 105,
    Type = "showview",
    Params = {panelid = 800, showtype = 2}
  },
  [106] = {
    id = 106,
    Type = "endfilter",
    Params = {
      fliter = {39}
    }
  }
}
Table_PlotQuest_95_fields = {
  "id",
  "Type",
  "Params"
}
return Table_PlotQuest_95
