Table_PlotQuest_71 = {
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
    Params = {groupid = 0, on = true}
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
      npcid = 807077,
      npcuid = 8070771,
      pos = {
        2.17,
        8.73,
        37.63
      },
      dir = 270
    }
  },
  [7] = {
    id = 7,
    Type = "summon",
    Params = {
      npcid = 807077,
      npcuid = 8070772,
      pos = {
        -2.13,
        8.73,
        37.63
      },
      dir = 90
    }
  },
  [8] = {
    id = 8,
    Type = "summon",
    Params = {
      npcid = 807095,
      npcuid = 8070773,
      pos = {
        2.17,
        9.99,
        40.98
      },
      dir = 270
    }
  },
  [9] = {
    id = 9,
    Type = "summon",
    Params = {
      npcid = 807095,
      npcuid = 8070774,
      pos = {
        -2.13,
        9.99,
        40.98
      },
      dir = 90
    }
  },
  [10] = {
    id = 10,
    Type = "summon",
    Params = {
      npcid = 807096,
      npcuid = 8070775,
      pos = {
        2.17,
        11.36,
        44.19
      },
      dir = 270
    }
  },
  [11] = {
    id = 11,
    Type = "summon",
    Params = {
      npcid = 807096,
      npcuid = 8070776,
      pos = {
        -2.13,
        11.36,
        44.19
      },
      dir = 90
    }
  },
  [12] = {
    id = 12,
    Type = "summon",
    Params = {
      npcid = 807097,
      npcuid = 8070777,
      pos = {
        2.17,
        12.66,
        47.4
      },
      dir = 270
    }
  },
  [13] = {
    id = 13,
    Type = "summon",
    Params = {
      npcid = 807097,
      npcuid = 8070778,
      pos = {
        -2.13,
        12.66,
        47.4
      },
      dir = 90
    }
  },
  [14] = {
    id = 14,
    Type = "wait_time",
    Params = {time = 1000}
  },
  [15] = {
    id = 15,
    Type = "play_sound",
    Params = {
      path = "Skill/VenomDust"
    }
  },
  [16] = {
    id = 16,
    Type = "play_effect_scene",
    Params = {
      id = 7,
      path = "Common/MaxViewOn",
      pos = {
        2.17,
        8.73,
        37.63
      }
    }
  },
  [17] = {
    id = 17,
    Type = "play_effect_scene",
    Params = {
      id = 8,
      path = "Common/MaxViewOn",
      pos = {
        -2.13,
        8.73,
        37.63
      }
    }
  },
  [18] = {
    id = 18,
    Type = "wait_time",
    Params = {time = 500}
  },
  [19] = {
    id = 19,
    Type = "action",
    Params = {
      npcuid = 8070771,
      id = 95,
      loop = true
    }
  },
  [20] = {
    id = 20,
    Type = "action",
    Params = {
      npcuid = 8070772,
      id = 95,
      loop = true
    }
  },
  [21] = {
    id = 21,
    Type = "addbutton",
    Params = {
      id = 1,
      text = "##276868",
      eventtype = "goon"
    }
  },
  [22] = {
    id = 22,
    Type = "wait_ui",
    Params = {button = 1}
  },
  [23] = {
    id = 23,
    Type = "move",
    Params = {
      player = 1,
      pos = {
        -0.04,
        9.25,
        39.06
      },
      spd = 1,
      dir = 1
    }
  },
  [24] = {
    id = 24,
    Type = "wait_pos",
    Params = {
      player = 1,
      pos = {
        -0.04,
        9.25,
        39.06
      },
      distance = 1
    }
  },
  [25] = {
    id = 25,
    Type = "wait_time",
    Params = {time = 500}
  },
  [26] = {
    id = 26,
    Type = "play_sound",
    Params = {
      path = "Skill/VenomDust"
    }
  },
  [27] = {
    id = 27,
    Type = "play_effect_scene",
    Params = {
      id = 9,
      path = "Common/MaxViewOn",
      pos = {
        2.17,
        9.99,
        40.98
      }
    }
  },
  [28] = {
    id = 28,
    Type = "play_effect_scene",
    Params = {
      id = 10,
      path = "Common/MaxViewOn",
      pos = {
        -2.13,
        9.99,
        40.98
      }
    }
  },
  [29] = {
    id = 29,
    Type = "wait_time",
    Params = {time = 500}
  },
  [30] = {
    id = 30,
    Type = "action",
    Params = {
      npcuid = 8070773,
      id = 95,
      loop = true
    }
  },
  [31] = {
    id = 31,
    Type = "action",
    Params = {
      npcuid = 8070774,
      id = 95,
      loop = true
    }
  },
  [32] = {
    id = 32,
    Type = "addbutton",
    Params = {
      id = 2,
      text = "##276868",
      eventtype = "goon"
    }
  },
  [33] = {
    id = 33,
    Type = "wait_ui",
    Params = {button = 2}
  },
  [34] = {
    id = 34,
    Type = "move",
    Params = {
      player = 1,
      pos = {
        0.0,
        10.55,
        42.32
      },
      spd = 1,
      dir = 1
    }
  },
  [35] = {
    id = 35,
    Type = "wait_pos",
    Params = {
      player = 1,
      pos = {
        0.0,
        10.55,
        42.32
      },
      distance = 1
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
      path = "Skill/VenomDust"
    }
  },
  [38] = {
    id = 38,
    Type = "play_effect_scene",
    Params = {
      id = 11,
      path = "Common/MaxViewOn",
      pos = {
        2.17,
        11.36,
        44.19
      }
    }
  },
  [39] = {
    id = 39,
    Type = "play_effect_scene",
    Params = {
      id = 12,
      path = "Common/MaxViewOn",
      pos = {
        -2.13,
        11.36,
        44.19
      }
    }
  },
  [40] = {
    id = 40,
    Type = "wait_time",
    Params = {time = 500}
  },
  [41] = {
    id = 41,
    Type = "action",
    Params = {
      npcuid = 8070775,
      id = 95,
      loop = true
    }
  },
  [42] = {
    id = 42,
    Type = "action",
    Params = {
      npcuid = 8070776,
      id = 95,
      loop = true
    }
  },
  [43] = {
    id = 43,
    Type = "addbutton",
    Params = {
      id = 3,
      text = "##276868",
      eventtype = "goon"
    }
  },
  [44] = {
    id = 44,
    Type = "wait_ui",
    Params = {button = 3}
  },
  [45] = {
    id = 45,
    Type = "move",
    Params = {
      player = 1,
      pos = {
        0.04,
        11.55,
        45.58
      },
      spd = 1,
      dir = 1
    }
  },
  [46] = {
    id = 46,
    Type = "wait_pos",
    Params = {
      player = 1,
      pos = {
        0.04,
        11.55,
        45.58
      },
      distance = 1
    }
  },
  [47] = {
    id = 47,
    Type = "wait_time",
    Params = {time = 500}
  },
  [48] = {
    id = 48,
    Type = "play_sound",
    Params = {
      path = "Skill/VenomDust"
    }
  },
  [49] = {
    id = 49,
    Type = "play_effect_scene",
    Params = {
      id = 13,
      path = "Common/MaxViewOn",
      pos = {
        2.17,
        12.66,
        47.4
      }
    }
  },
  [50] = {
    id = 50,
    Type = "play_effect_scene",
    Params = {
      id = 14,
      path = "Common/MaxViewOn",
      pos = {
        -2.13,
        12.66,
        47.4
      }
    }
  },
  [51] = {
    id = 51,
    Type = "wait_time",
    Params = {time = 500}
  },
  [52] = {
    id = 52,
    Type = "action",
    Params = {
      npcuid = 8070777,
      id = 95,
      loop = true
    }
  },
  [53] = {
    id = 53,
    Type = "action",
    Params = {
      npcuid = 8070778,
      id = 95,
      loop = true
    }
  },
  [54] = {
    id = 54,
    Type = "addbutton",
    Params = {
      id = 4,
      text = "##276868",
      eventtype = "goon"
    }
  },
  [55] = {
    id = 55,
    Type = "wait_ui",
    Params = {button = 4}
  },
  [56] = {
    id = 56,
    Type = "move",
    Params = {
      player = 1,
      pos = {
        0.03,
        12.55,
        53.0
      },
      spd = 1,
      dir = 1
    }
  },
  [57] = {
    id = 57,
    Type = "wait_pos",
    Params = {
      player = 1,
      pos = {
        0.03,
        12.55,
        53.0
      },
      distance = 1
    }
  },
  [58] = {
    id = 58,
    Type = "wait_time",
    Params = {time = 2000}
  },
  [59] = {
    id = 59,
    Type = "summon",
    Params = {
      npcid = 807098,
      npcuid = 8070821,
      pos = {
        0.03,
        13.85,
        58.68
      },
      dir = 180,
      waitaction = "attack_wait"
    }
  },
  [60] = {
    id = 60,
    Type = "play_effect_scene",
    Params = {
      id = 15,
      path = "Skill/functioal_show",
      pos = {
        0.03,
        13.85,
        58.68
      },
      onshot = 1,
      ignoreNavMesh = 1
    }
  },
  [61] = {
    id = 61,
    Type = "wait_time",
    Params = {time = 1000}
  },
  [62] = {
    id = 62,
    Type = "remove_npc",
    Params = {npcuid = 8070771}
  },
  [63] = {
    id = 63,
    Type = "remove_npc",
    Params = {npcuid = 8070772}
  },
  [64] = {
    id = 64,
    Type = "remove_npc",
    Params = {npcuid = 8070773}
  },
  [65] = {
    id = 65,
    Type = "remove_npc",
    Params = {npcuid = 8070774}
  },
  [66] = {
    id = 66,
    Type = "remove_npc",
    Params = {npcuid = 8070775}
  },
  [67] = {
    id = 67,
    Type = "remove_npc",
    Params = {npcuid = 8070776}
  },
  [68] = {
    id = 68,
    Type = "remove_npc",
    Params = {npcuid = 8070777}
  },
  [69] = {
    id = 69,
    Type = "remove_npc",
    Params = {npcuid = 8070778}
  },
  [70] = {
    id = 70,
    Type = "action",
    Params = {npcuid = 8070821, id = 729}
  },
  [71] = {
    id = 71,
    Type = "wait_time",
    Params = {time = 15000}
  },
  [72] = {
    id = 72,
    Type = "onoff_camerapoint",
    Params = {groupid = 0, on = false}
  },
  [73] = {
    id = 73,
    Type = "onoff_camerapoint",
    Params = {groupid = 1, on = true}
  },
  [74] = {
    id = 74,
    Type = "wait_time",
    Params = {time = 1500}
  },
  [75] = {
    id = 75,
    Type = "action",
    Params = {npcuid = 8070821, id = 25}
  },
  [76] = {
    id = 76,
    Type = "play_sound",
    Params = {
      path = "Skill/FavorAdjustment_atk"
    }
  },
  [77] = {
    id = 77,
    Type = "play_effect_scene",
    Params = {
      id = 38,
      path = "Skill/FavorAdjustment_atk",
      pos = {
        4.36,
        13.85,
        59.14
      },
      onshot = 1
    }
  },
  [78] = {
    id = 78,
    Type = "play_effect_scene",
    Params = {
      id = 39,
      path = "Skill/FavorAdjustment_atk",
      pos = {
        -3.73,
        13.85,
        59.24
      },
      onshot = 1
    }
  },
  [79] = {
    id = 79,
    Type = "wait_time",
    Params = {time = 1000}
  },
  [80] = {
    id = 80,
    Type = "summon",
    Params = {
      npcid = 807086,
      npcuid = 8070868,
      pos = {
        -3.7,
        14.47,
        56.78
      },
      dir = 131.4326,
      ignoreNavMesh = 1
    }
  },
  [81] = {
    id = 81,
    Type = "summon",
    Params = {
      npcid = 807087,
      npcuid = 8070878,
      pos = {
        3.44,
        14.51,
        56.87
      },
      dir = 223.4546,
      ignoreNavMesh = 1
    }
  },
  [82] = {
    id = 82,
    Type = "summon",
    Params = {
      npcid = 807088,
      npcuid = 8070888,
      pos = {
        2.47,
        17.71,
        59.72
      },
      dir = 201.9084,
      ignoreNavMesh = 1
    }
  },
  [83] = {
    id = 83,
    Type = "summon",
    Params = {
      npcid = 807089,
      npcuid = 8070898,
      pos = {
        -2.37,
        17.62,
        60.14
      },
      dir = 159.7021,
      ignoreNavMesh = 1
    }
  },
  [84] = {
    id = 84,
    Type = "summon",
    Params = {
      npcid = 807090,
      npcuid = 8070899,
      pos = {
        -6.44,
        17.2,
        61.95
      },
      dir = 143.2897,
      ignoreNavMesh = 1
    }
  },
  [85] = {
    id = 85,
    Type = "summon",
    Params = {
      npcid = 807091,
      npcuid = 8070900,
      pos = {
        5.6,
        17.59,
        61.57
      },
      dir = 213.3497,
      ignoreNavMesh = 1
    }
  },
  [86] = {
    id = 86,
    Type = "wait_time",
    Params = {time = 700}
  },
  [87] = {
    id = 87,
    Type = "action",
    Params = {
      npcuid = 8070821,
      id = 8,
      loop = true
    }
  },
  [88] = {
    id = 88,
    Type = "wait_time",
    Params = {time = 1000}
  },
  [89] = {
    id = 89,
    Type = "dialog",
    Params = {
      dialog = {551452}
    }
  },
  [90] = {
    id = 90,
    Type = "addbutton",
    Params = {
      id = 5,
      text = "##298180",
      eventtype = "goon"
    }
  },
  [91] = {
    id = 91,
    Type = "wait_ui",
    Params = {button = 5}
  },
  [92] = {
    id = 92,
    Type = "dialog",
    Params = {
      dialog = {551453, 551459}
    }
  },
  [93] = {
    id = 93,
    Type = "shakescreen",
    Params = {amplitude = 10, time = 2000}
  },
  [94] = {
    id = 94,
    Type = "wait_time",
    Params = {time = 1500}
  },
  [95] = {
    id = 95,
    Type = "action",
    Params = {npcuid = 8070821, id = 26}
  },
  [96] = {
    id = 96,
    Type = "play_sound",
    Params = {
      path = "Skill/Tnts_Dolor_die"
    }
  },
  [97] = {
    id = 97,
    Type = "play_effect_scene",
    Params = {
      id = 21,
      path = "Skill/ShieldATK_atk",
      pos = {
        0.03,
        12.55,
        53.0
      },
      onshot = 1,
      ignoreNavMesh = 1,
      dir = {
        0.0,
        179.0,
        0.0
      }
    }
  },
  [98] = {
    id = 98,
    Type = "play_effect_scene",
    Params = {
      id = 16,
      path = "Skill/Thebest_buff_huge",
      pos = {
        0.03,
        12.55,
        53.0
      }
    }
  },
  [99] = {
    id = 99,
    Type = "wait_time",
    Params = {time = 1000}
  },
  [100] = {
    id = 100,
    Type = "action",
    Params = {
      npcuid = 8070821,
      id = 8,
      loop = true
    }
  },
  [101] = {
    id = 101,
    Type = "play_effect_scene",
    Params = {
      id = 41,
      path = "Skill/LVUP_Process_2",
      pos = {
        0.03,
        12.55,
        53.0
      }
    }
  },
  [102] = {
    id = 102,
    Type = "play_sound",
    Params = {
      path = "Skill/NPC_Starball_wing"
    }
  },
  [103] = {
    id = 103,
    Type = "wait_time",
    Params = {time = 2000}
  },
  [104] = {
    id = 104,
    Type = "dialog",
    Params = {
      dialog = {551460}
    }
  },
  [105] = {
    id = 105,
    Type = "action",
    Params = {npcuid = 8070821, id = 28}
  },
  [106] = {
    id = 106,
    Type = "wait_time",
    Params = {time = 1000}
  },
  [107] = {
    id = 107,
    Type = "play_sound",
    Params = {
      path = "Skill/Thamer_show"
    }
  },
  [108] = {
    id = 108,
    Type = "play_effect_scene",
    Params = {
      id = 42,
      path = "Skill/SwordBursting_atk",
      pos = {
        0.03,
        12.55,
        53.0
      },
      onshot = 1
    }
  },
  [109] = {
    id = 109,
    Type = "wait_time",
    Params = {time = 600}
  },
  [110] = {
    id = 110,
    Type = "remove_effect_scene",
    Params = {id = 41}
  },
  [111] = {
    id = 111,
    Type = "play_sound",
    Params = {
      path = "Skill/Tnts_Dolor_skill2"
    }
  },
  [112] = {
    id = 112,
    Type = "play_effect_scene",
    Params = {
      id = 98,
      path = "Skill/SwordBursting_atk",
      pos = {
        0.03,
        12.55,
        53.0
      },
      onshot = 1
    }
  },
  [113] = {
    id = 113,
    Type = "wait_time",
    Params = {time = 1100}
  },
  [114] = {
    id = 114,
    Type = "play_sound",
    Params = {
      path = "Skill/Whisperer_emaopaoxiao"
    }
  },
  [115] = {
    id = 115,
    Type = "play_effect_scene",
    Params = {
      id = 33,
      path = "Skill/Eff_FreedomShield_atk",
      pos = {
        -0.03,
        13.85,
        56.62
      },
      onshot = 1
    }
  },
  [116] = {
    id = 116,
    Type = "wait_time",
    Params = {time = 100}
  },
  [117] = {
    id = 117,
    Type = "action",
    Params = {
      npcuid = 8070821,
      id = 8,
      loop = true
    }
  },
  [118] = {
    id = 118,
    Type = "dialog",
    Params = {
      dialog = {551461}
    }
  },
  [119] = {
    id = 119,
    Type = "action",
    Params = {npcuid = 8070821, id = 26}
  },
  [120] = {
    id = 120,
    Type = "play_sound",
    Params = {
      path = "Skill/Despero_hand"
    }
  },
  [121] = {
    id = 121,
    Type = "play_effect_scene",
    Params = {
      id = 35,
      path = "Skill/Eff_ShelterValhala_atk",
      pos = {
        -0.03,
        13.85,
        56.62
      },
      onshot = 1
    }
  },
  [122] = {
    id = 122,
    Type = "wait_time",
    Params = {time = 500}
  },
  [123] = {
    id = 123,
    Type = "play_effect_scene",
    Params = {
      id = 43,
      path = "Skill/FeatherBlade_atk",
      pos = {
        0.03,
        12.55,
        53.0
      },
      onshot = 1
    }
  },
  [124] = {
    id = 124,
    Type = "wait_time",
    Params = {time = 400}
  },
  [125] = {
    id = 125,
    Type = "action",
    Params = {
      npcuid = 8070821,
      id = 8,
      loop = true
    }
  },
  [126] = {
    id = 126,
    Type = "wait_time",
    Params = {time = 1800}
  },
  [127] = {
    id = 127,
    Type = "dialog",
    Params = {
      dialog = {551462, 551463}
    }
  },
  [128] = {
    id = 128,
    Type = "action",
    Params = {npcuid = 8070821, id = 11}
  },
  [129] = {
    id = 129,
    Type = "play_sound",
    Params = {
      path = "Skill/skill_makenshi_danatuosizhichu_attack"
    }
  },
  [130] = {
    id = 130,
    Type = "play_effect_scene",
    Params = {
      id = 37,
      path = "Skill/StoneHammer_atk",
      pos = {
        -0.03,
        13.85,
        56.62
      },
      onshot = 1
    }
  },
  [131] = {
    id = 131,
    Type = "wait_time",
    Params = {time = 500}
  },
  [132] = {
    id = 132,
    Type = "wait_time",
    Params = {time = 500}
  },
  [133] = {
    id = 133,
    Type = "action",
    Params = {npcuid = 8070821, id = 23}
  },
  [134] = {
    id = 134,
    Type = "play_sound",
    Params = {
      path = "Skill/Whisperer_emaopaoxiao"
    }
  },
  [135] = {
    id = 135,
    Type = "play_effect_scene",
    Params = {
      id = 97,
      path = "Skill/SummonSlave_Atk",
      pos = {
        -0.03,
        13.85,
        56.62
      },
      onshot = 1
    }
  },
  [136] = {
    id = 136,
    Type = "remove_effect_scene",
    Params = {id = 32}
  },
  [137] = {
    id = 137,
    Type = "remove_effect_scene",
    Params = {id = 34}
  },
  [138] = {
    id = 138,
    Type = "remove_effect_scene",
    Params = {id = 36}
  },
  [139] = {
    id = 139,
    Type = "wait_time",
    Params = {time = 800}
  },
  [140] = {
    id = 140,
    Type = "action",
    Params = {
      npcuid = 8070821,
      id = 8,
      loop = true
    }
  },
  [141] = {
    id = 141,
    Type = "dialog",
    Params = {
      dialog = {551464, 551465}
    }
  },
  [142] = {
    id = 142,
    Type = "wait_time",
    Params = {time = 1000}
  },
  [143] = {
    id = 143,
    Type = "action",
    Params = {npcuid = 8070821, id = 27}
  },
  [144] = {
    id = 144,
    Type = "play_sound",
    Params = {
      path = "Skill/FavorAdjustment_atk"
    }
  },
  [145] = {
    id = 145,
    Type = "play_effect_scene",
    Params = {
      id = 99,
      path = "Skill/FavorAdjustment_atk",
      pos = {
        0.03,
        13.85,
        58.68
      },
      onshot = 1
    }
  },
  [146] = {
    id = 146,
    Type = "wait_time",
    Params = {time = 2000}
  },
  [147] = {
    id = 147,
    Type = "play_effect_scene",
    Params = {
      id = 24,
      path = "Skill/ThorHammer_Buff2",
      pos = {
        0.03,
        15.55,
        48.66
      },
      onshot = 1
    }
  },
  [148] = {
    id = 148,
    Type = "play_effect_scene",
    Params = {
      id = 25,
      path = "Skill/Chepet_FlameCircle1",
      pos = {
        0.03,
        13.1,
        48.66
      },
      onshot = 1,
      ignoreNavMesh = 1
    }
  },
  [149] = {
    id = 149,
    Type = "play_effect_scene",
    Params = {
      id = 26,
      path = "Skill/Chepet_FlameCircle2",
      pos = {
        0.03,
        14.1,
        48.66
      },
      onshot = 1,
      ignoreNavMesh = 1
    }
  },
  [150] = {
    id = 150,
    Type = "play_effect_scene",
    Params = {
      id = 27,
      path = "Skill/Chepet_FlameCircle3",
      pos = {
        0.03,
        15.1,
        48.66
      },
      onshot = 1,
      ignoreNavMesh = 1
    }
  },
  [151] = {
    id = 151,
    Type = "play_effect_scene",
    Params = {
      id = 28,
      path = "Skill/Chepet_FlameCircle4",
      pos = {
        0.03,
        16.1,
        48.66
      },
      onshot = 1,
      ignoreNavMesh = 1
    }
  },
  [152] = {
    id = 152,
    Type = "play_effect_scene",
    Params = {
      id = 29,
      path = "Skill/Chepet_FlameCircle5",
      pos = {
        0.03,
        17.1,
        48.66
      },
      onshot = 1,
      ignoreNavMesh = 1
    }
  },
  [153] = {
    id = 153,
    Type = "play_effect_scene",
    Params = {
      id = 30,
      path = "Skill/Chepet_FlameCircle6",
      pos = {
        0.03,
        18.1,
        48.66
      },
      onshot = 1,
      ignoreNavMesh = 1
    }
  },
  [154] = {
    id = 154,
    Type = "play_effect_scene",
    Params = {
      id = 37,
      path = "Skill/Eff_CounterattackAura_buff",
      pos = {
        0.03,
        12.55,
        53.0
      }
    }
  },
  [155] = {
    id = 155,
    Type = "wait_time",
    Params = {time = 800}
  },
  [156] = {
    id = 156,
    Type = "action",
    Params = {
      npcuid = 8070821,
      id = 8,
      loop = true
    }
  },
  [157] = {
    id = 157,
    Type = "wait_time",
    Params = {time = 700}
  },
  [158] = {
    id = 158,
    Type = "dialog",
    Params = {
      dialog = {551454, 551455}
    }
  },
  [159] = {
    id = 159,
    Type = "wait_time",
    Params = {time = 500}
  },
  [160] = {
    id = 160,
    Type = "play_sound",
    Params = {
      path = "Skill/FavorAdjustment_hit"
    }
  },
  [161] = {
    id = 161,
    Type = "play_effect_scene",
    Params = {
      id = 40,
      path = "Skill/FavorAdjustment_hit",
      pos = {
        0.03,
        12.55,
        53.0
      },
      onshot = 1
    }
  },
  [162] = {
    id = 162,
    Type = "wait_time",
    Params = {time = 500}
  },
  [163] = {
    id = 163,
    Type = "shakescreen",
    Params = {amplitude = 10, time = 2000}
  },
  [164] = {
    id = 164,
    Type = "action",
    Params = {npcuid = 8070899, id = 26}
  },
  [165] = {
    id = 165,
    Type = "action",
    Params = {npcuid = 8070900, id = 26}
  },
  [166] = {
    id = 166,
    Type = "action",
    Params = {npcuid = 8070878, id = 26}
  },
  [167] = {
    id = 167,
    Type = "action",
    Params = {npcuid = 8070868, id = 26}
  },
  [168] = {
    id = 168,
    Type = "action",
    Params = {npcuid = 8070888, id = 26}
  },
  [169] = {
    id = 169,
    Type = "action",
    Params = {npcuid = 8070898, id = 26}
  },
  [170] = {
    id = 170,
    Type = "wait_time",
    Params = {time = 1000}
  },
  [171] = {
    id = 171,
    Type = "shakescreen",
    Params = {amplitude = 30, time = 2000}
  },
  [172] = {
    id = 172,
    Type = "wait_time",
    Params = {time = 500}
  },
  [173] = {
    id = 173,
    Type = "showview",
    Params = {panelid = 800, showtype = 2}
  },
  [174] = {
    id = 174,
    Type = "onoff_camerapoint",
    Params = {groupid = 1, on = false}
  },
  [175] = {
    id = 175,
    Type = "endfilter",
    Params = {
      fliter = {39}
    }
  }
}
Table_PlotQuest_71_fields = {
  "id",
  "Type",
  "Params"
}
return Table_PlotQuest_71
