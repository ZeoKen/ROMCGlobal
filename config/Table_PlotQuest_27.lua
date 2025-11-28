Table_PlotQuest_27 = {
  [1] = {
    id = 1,
    Type = "play_effect_ui",
    Params = {path = "BtoW"}
  },
  [2] = {
    id = 2,
    Type = "startfilter",
    Params = {
      fliter = {38}
    }
  },
  [3] = {
    id = 3,
    Type = "camera_filter",
    Params = {filterid = 6, on = 1}
  },
  [4] = {
    id = 4,
    Type = "wait_time",
    Params = {time = 500}
  },
  [5] = {
    id = 5,
    Type = "summon",
    Params = {
      npcid = 803386,
      npcuid = 803386,
      groupid = 1,
      pos = {
        -40.01,
        -0.06,
        11.76
      },
      dir = 6.93
    }
  },
  [6] = {
    id = 6,
    Type = "summon",
    Params = {
      npcid = 803387,
      npcuid = 803387,
      groupid = 1,
      pos = {
        -38.39,
        -0.08,
        11.75
      },
      dir = 343.1
    }
  },
  [7] = {
    id = 7,
    Type = "summon",
    Params = {
      npcid = 803388,
      npcuid = 803388,
      groupid = 1,
      pos = {
        -43.65,
        -0.06,
        5.95
      },
      dir = 262.68
    }
  },
  [8] = {
    id = 8,
    Type = "dialog",
    Params = {
      dialog = {321783},
      npcuid = 803386
    }
  },
  [9] = {
    id = 9,
    Type = "dialog",
    Params = {
      dialog = {321784},
      npcuid = 803387
    }
  },
  [10] = {
    id = 10,
    Type = "dialog",
    Params = {
      dialog = {321785},
      npcuid = 803386
    }
  },
  [11] = {
    id = 11,
    Type = "dialog",
    Params = {
      dialog = {321786},
      npcuid = 803388
    }
  },
  [12] = {
    id = 12,
    Type = "action",
    Params = {npcuid = 803388, id = 23}
  },
  [13] = {
    id = 13,
    Type = "play_sound",
    Params = {
      path = "Skill/GraniteArmor_attack"
    }
  },
  [14] = {
    id = 14,
    Type = "play_effect_scene",
    Params = {
      id = 1,
      path = "Skill/GraniteArmor_attack",
      pos = {
        -45.48,
        0.74,
        7.8
      },
      onshot = 1,
      ignoreNavMesh = 1
    }
  },
  [15] = {
    id = 15,
    Type = "wait_time",
    Params = {time = 1000}
  },
  [16] = {
    id = 16,
    Type = "play_sound",
    Params = {
      path = "Common/Cardroom_Meteorite"
    }
  },
  [17] = {
    id = 17,
    Type = "play_effect_scene",
    Params = {
      id = 2,
      path = "Skill/TheTigerGUN_attack",
      pos = {
        -45.48,
        0.74,
        7.8
      },
      onshot = 1,
      ignoreNavMesh = 1
    }
  },
  [18] = {
    id = 18,
    Type = "dialog",
    Params = {
      dialog = {321787},
      npcuid = 803388
    }
  },
  [19] = {
    id = 19,
    Type = "summon",
    Params = {
      npcid = 803385,
      npcuid = 803385,
      groupid = 1,
      pos = {
        -43.65,
        -0.06,
        7.51
      },
      dir = 91.22
    }
  },
  [20] = {
    id = 20,
    Type = "remove_npc",
    Params = {npcuid = 803386}
  },
  [21] = {
    id = 21,
    Type = "remove_npc",
    Params = {npcuid = 803387}
  },
  [22] = {
    id = 22,
    Type = "remove_npc",
    Params = {npcuid = 803388}
  },
  [23] = {
    id = 23,
    Type = "summon",
    Params = {
      npcid = 803386,
      npcuid = 803386,
      groupid = 1,
      pos = {
        -40.01,
        -0.06,
        11.76
      },
      dir = 218.8
    }
  },
  [24] = {
    id = 24,
    Type = "summon",
    Params = {
      npcid = 803387,
      npcuid = 803387,
      groupid = 1,
      pos = {
        -38.39,
        -0.08,
        11.75
      },
      dir = 226.3
    }
  },
  [25] = {
    id = 25,
    Type = "summon",
    Params = {
      npcid = 803388,
      npcuid = 803388,
      groupid = 1,
      pos = {
        -43.65,
        -0.06,
        5.95
      },
      dir = 358.9
    }
  },
  [26] = {
    id = 26,
    Type = "dialog",
    Params = {
      dialog = {321788},
      npcuid = 803388
    }
  },
  [27] = {
    id = 27,
    Type = "dialog",
    Params = {
      dialog = {321789},
      npcuid = 803386
    }
  },
  [28] = {
    id = 28,
    Type = "remove_npc",
    Params = {npcuid = 803387}
  },
  [29] = {
    id = 29,
    Type = "play_effect_scene",
    Params = {
      id = 3,
      path = "Common/Darkflame",
      pos = {
        -43.65,
        0.3,
        7.51
      },
      onshot = 1,
      ignoreNavMesh = 1
    }
  },
  [30] = {
    id = 30,
    Type = "dialog",
    Params = {
      dialog = {321790},
      npcid = 803390
    }
  },
  [31] = {
    id = 31,
    Type = "action",
    Params = {npcuid = 803385, id = 9}
  },
  [32] = {
    id = 32,
    Type = "play_effect_scene",
    Params = {
      id = 4,
      path = "Skill/AncientSun_buff1",
      pos = {
        -40.68,
        -0.05,
        7.63
      }
    }
  },
  [33] = {
    id = 33,
    Type = "summon",
    Params = {
      npcid = 803391,
      npcuid = 803391,
      groupid = 1,
      pos = {
        -41.47,
        -0.06,
        7.51
      },
      dir = 92.36
    }
  },
  [34] = {
    id = 34,
    Type = "summon",
    Params = {
      npcid = 803389,
      npcuid = 803389,
      groupid = 1,
      pos = {
        -39.83,
        -0.06,
        8.3
      },
      dir = 245.02
    }
  },
  [35] = {
    id = 35,
    Type = "summon",
    Params = {
      npcid = 803390,
      npcuid = 803390,
      groupid = 1,
      pos = {
        -39.8,
        -0.06,
        6.54
      },
      dir = 297.8
    }
  },
  [36] = {
    id = 36,
    Type = "dialog",
    Params = {
      dialog = {321791},
      npcuid = 803389
    }
  },
  [37] = {
    id = 37,
    Type = "dialog",
    Params = {
      dialog = {321792},
      npcuid = 803390
    }
  },
  [38] = {
    id = 38,
    Type = "dialog",
    Params = {
      dialog = {321793},
      npcuid = 803391
    }
  },
  [39] = {
    id = 39,
    Type = "dialog",
    Params = {
      dialog = {321794},
      npcuid = 803390
    }
  },
  [40] = {
    id = 40,
    Type = "dialog",
    Params = {
      dialog = {321795},
      npcuid = 803391
    }
  },
  [41] = {
    id = 41,
    Type = "dialog",
    Params = {
      dialog = {321796},
      npcuid = 803391
    }
  },
  [42] = {
    id = 42,
    Type = "dialog",
    Params = {
      dialog = {321797},
      npcuid = 803389
    }
  },
  [43] = {
    id = 43,
    Type = "dialog",
    Params = {
      dialog = {321798},
      npcuid = 803391
    }
  },
  [44] = {
    id = 44,
    Type = "dialog",
    Params = {
      dialog = {321799},
      npcuid = 803390
    }
  },
  [45] = {
    id = 45,
    Type = "remove_npc",
    Params = {npcuid = 803389}
  },
  [46] = {
    id = 46,
    Type = "remove_npc",
    Params = {npcuid = 803390}
  },
  [47] = {
    id = 47,
    Type = "summon",
    Params = {
      npcid = 803346,
      npcuid = 803346,
      groupid = 1,
      pos = {
        -39.8,
        -0.06,
        6.54
      },
      dir = 297.8
    }
  },
  [48] = {
    id = 48,
    Type = "summon",
    Params = {
      npcid = 803340,
      npcuid = 803340,
      groupid = 1,
      pos = {
        -39.83,
        -0.06,
        8.3
      },
      dir = 245.02
    }
  },
  [49] = {
    id = 49,
    Type = "dialog",
    Params = {
      dialog = {321800},
      npcuid = 803346
    }
  },
  [50] = {
    id = 50,
    Type = "dialog",
    Params = {
      dialog = {321801},
      npcuid = 803346
    }
  },
  [51] = {
    id = 51,
    Type = "dialog",
    Params = {
      dialog = {321802},
      npcuid = 803391
    }
  },
  [52] = {
    id = 52,
    Type = "dialog",
    Params = {
      dialog = {321803},
      npcuid = 803346
    }
  },
  [53] = {
    id = 53,
    Type = "dialog",
    Params = {
      dialog = {321804},
      npcuid = 803346
    }
  },
  [54] = {
    id = 54,
    Type = "dialog",
    Params = {
      dialog = {321805},
      npcuid = 803391
    }
  },
  [55] = {
    id = 55,
    Type = "remove_npc",
    Params = {npcuid = 803346}
  },
  [56] = {
    id = 56,
    Type = "remove_npc",
    Params = {npcuid = 803340}
  },
  [57] = {
    id = 57,
    Type = "remove_npc",
    Params = {npcuid = 803391}
  },
  [58] = {
    id = 58,
    Type = "remove_effect_scene",
    Params = {id = 4}
  },
  [59] = {
    id = 59,
    Type = "action",
    Params = {npcuid = 803385, id = 25}
  },
  [60] = {
    id = 60,
    Type = "play_effect_scene",
    Params = {
      id = 5,
      path = "Skill/Odins_punish",
      pos = {
        -43.65,
        -0.06,
        7.51
      }
    }
  },
  [61] = {
    id = 61,
    Type = "dialog",
    Params = {
      dialog = {321806},
      npcuid = 803388
    }
  },
  [62] = {
    id = 62,
    Type = "remove_npc",
    Params = {npcuid = 803388}
  },
  [63] = {
    id = 63,
    Type = "play_sound",
    Params = {
      path = "Skill/FavorAdjustment_atk"
    }
  },
  [64] = {
    id = 64,
    Type = "play_effect_scene",
    Params = {
      id = 6,
      path = "Common/LavaMeco_fire",
      pos = {
        -45.48,
        0.79,
        5.97
      },
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
    Type = "play_effect_scene",
    Params = {
      id = 7,
      path = "Common/LavaMeco_fire",
      pos = {
        -45.48,
        0.91,
        13.22
      },
      ignoreNavMesh = 1
    }
  },
  [67] = {
    id = 67,
    Type = "play_effect_scene",
    Params = {
      id = 8,
      path = "Common/LavaMeco_fire",
      pos = {
        -41.2,
        -0.03,
        10.19
      },
      ignoreNavMesh = 1
    }
  },
  [68] = {
    id = 68,
    Type = "wait_time",
    Params = {time = 1000}
  },
  [69] = {
    id = 69,
    Type = "play_effect_scene",
    Params = {
      id = 9,
      path = "Common/LavaMeco_fire",
      pos = {
        -40.63,
        1.02,
        13.67
      },
      ignoreNavMesh = 1
    }
  },
  [70] = {
    id = 70,
    Type = "play_effect_scene",
    Params = {
      id = 10,
      path = "Common/LavaMeco_fire",
      pos = {
        -40.99,
        -0.05,
        5.63
      },
      ignoreNavMesh = 1
    }
  },
  [71] = {
    id = 71,
    Type = "play_effect_scene",
    Params = {
      id = 11,
      path = "Common/LavaMeco_fire",
      pos = {
        -38.6,
        0.89,
        13.27
      },
      ignoreNavMesh = 1
    }
  },
  [72] = {
    id = 72,
    Type = "play_effect_scene",
    Params = {
      id = 12,
      path = "Common/LavaMeco_fire",
      pos = {
        -37.17,
        0.89,
        14.55
      },
      ignoreNavMesh = 1
    }
  },
  [73] = {
    id = 73,
    Type = "play_effect_scene",
    Params = {
      id = 13,
      path = "Common/LavaMeco_fire",
      pos = {
        -39.32,
        0.0,
        10.4
      },
      ignoreNavMesh = 1
    }
  },
  [74] = {
    id = 74,
    Type = "play_effect_scene",
    Params = {
      id = 14,
      path = "Common/LavaMeco_fire",
      pos = {
        -41.81,
        0.0,
        7.58
      },
      ignoreNavMesh = 1
    }
  },
  [75] = {
    id = 75,
    Type = "play_effect_scene",
    Params = {
      id = 15,
      path = "Common/LavaMeco_fire",
      pos = {
        -37.72,
        0.0,
        8.06
      },
      ignoreNavMesh = 1
    }
  },
  [76] = {
    id = 76,
    Type = "play_effect_scene",
    Params = {
      id = 16,
      path = "Common/LavaMeco_fire",
      pos = {
        -37.72,
        0.0,
        5.47
      },
      ignoreNavMesh = 1
    }
  },
  [77] = {
    id = 77,
    Type = "play_effect_scene",
    Params = {
      id = 17,
      path = "Common/LavaMeco_fire",
      pos = {
        -45.05,
        1.34,
        10.86
      },
      ignoreNavMesh = 1
    }
  },
  [78] = {
    id = 78,
    Type = "play_effect_scene",
    Params = {
      id = 18,
      path = "Common/LavaMeco_fire",
      pos = {
        -40.92,
        1.09,
        10.19
      },
      ignoreNavMesh = 1
    }
  },
  [79] = {
    id = 79,
    Type = "play_effect_scene",
    Params = {
      id = 19,
      path = "Common/LavaMeco_fire",
      pos = {
        -44.28,
        0.34,
        14.93
      },
      ignoreNavMesh = 1
    }
  },
  [80] = {
    id = 80,
    Type = "dialog",
    Params = {
      dialog = {321807}
    }
  },
  [81] = {
    id = 81,
    Type = "summon",
    Params = {
      npcid = 803387,
      npcuid = 803387,
      groupid = 1,
      pos = {
        -38.39,
        -0.08,
        11.75
      },
      dir = 226.3
    }
  },
  [82] = {
    id = 82,
    Type = "dialog",
    Params = {
      dialog = {321808},
      npcuid = 803387
    }
  },
  [83] = {
    id = 83,
    Type = "dialog",
    Params = {
      dialog = {321809},
      npcuid = 803386
    }
  },
  [84] = {
    id = 84,
    Type = "dialog",
    Params = {
      dialog = {321810},
      npcuid = 803386
    }
  },
  [85] = {
    id = 85,
    Type = "play_effect",
    Params = {
      path = "Skill/Teleport",
      npcuid = 803386
    }
  },
  [86] = {
    id = 86,
    Type = "play_effect",
    Params = {
      path = "Skill/Teleport",
      npcuid = 803387
    }
  },
  [87] = {
    id = 87,
    Type = "remove_npc",
    Params = {npcuid = 803386}
  },
  [88] = {
    id = 88,
    Type = "remove_npc",
    Params = {npcuid = 803387}
  },
  [89] = {
    id = 89,
    Type = "dialog",
    Params = {
      dialog = {321811},
      npcuid = 803346
    }
  },
  [90] = {
    id = 90,
    Type = "showview",
    Params = {panelid = 800, showtype = 2}
  },
  [91] = {
    id = 91,
    Type = "endfilter",
    Params = {
      fliter = {38}
    }
  },
  [92] = {
    id = 92,
    Type = "camera_filter",
    Params = {filterid = 6, on = 0}
  }
}
Table_PlotQuest_27_fields = {
  "id",
  "Type",
  "Params"
}
return Table_PlotQuest_27
