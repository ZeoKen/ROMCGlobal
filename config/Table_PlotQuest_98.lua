Table_PlotQuest_98 = {
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
    Type = "onoff_camerapoint",
    Params = {groupid = 0, on = true}
  },
  [4] = {
    id = 4,
    Type = "summon",
    Params = {
      npcid = 803741,
      npcuid = 803741,
      groupid = 1,
      pos = {
        32.63,
        14.26,
        34.1
      },
      dir = 347.7,
      ignoreNavMesh = 1
    }
  },
  [5] = {
    id = 5,
    Type = "summon",
    Params = {
      npcid = 803742,
      npcuid = 803742,
      groupid = 1,
      pos = {
        34.09,
        15.49,
        33.92
      },
      dir = 347.7,
      ignoreNavMesh = 1
    }
  },
  [6] = {
    id = 6,
    Type = "summon",
    Params = {
      npcid = 803743,
      npcuid = 803743,
      groupid = 1,
      pos = {
        36.02,
        15.48,
        33.44
      },
      dir = 347.7,
      ignoreNavMesh = 1
    }
  },
  [7] = {
    id = 7,
    Type = "summon",
    Params = {
      npcid = 803744,
      npcuid = 803744,
      groupid = 1,
      pos = {
        37.47,
        14.26,
        32.91
      },
      dir = 347.7,
      ignoreNavMesh = 1
    }
  },
  [8] = {
    id = 8,
    Type = "summon",
    Params = {
      npcid = 803767,
      npcuid = 803767,
      groupid = 1,
      pos = {
        33.79,
        11.28,
        30.33
      },
      dir = 7
    }
  },
  [9] = {
    id = 9,
    Type = "wait_time",
    Params = {time = 2000}
  },
  [10] = {
    id = 10,
    Type = "move",
    Params = {
      npcuid = 803767,
      pos = {
        35.0,
        12.0,
        35.39
      },
      dir = 7,
      spd = 0.6
    }
  },
  [11] = {
    id = 11,
    Type = "wait_time",
    Params = {time = 3000}
  },
  [12] = {
    id = 12,
    Type = "dialog",
    Params = {
      dialog = {451466}
    }
  },
  [13] = {
    id = 13,
    Type = "action",
    Params = {npcuid = 803767, id = 21}
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
      path = "Common/FMagic_forging_FA"
    }
  },
  [16] = {
    id = 16,
    Type = "play_effect_scene",
    Params = {
      id = 1,
      path = "Skill/FirePillar",
      pos = {
        33.97,
        12.4,
        36.51
      },
      ignoreNavMesh = 1
    }
  },
  [17] = {
    id = 17,
    Type = "play_effect_scene",
    Params = {
      id = 2,
      path = "Skill/FirePillar",
      pos = {
        36.73,
        12.4,
        36.25
      },
      ignoreNavMesh = 1
    }
  },
  [18] = {
    id = 18,
    Type = "wait_time",
    Params = {time = 1000}
  },
  [19] = {
    id = 19,
    Type = "play_effect_scene",
    Params = {
      id = 3,
      path = "Skill/FirePillar",
      pos = {
        33.16,
        12.0,
        35.02
      },
      ignoreNavMesh = 1
    }
  },
  [20] = {
    id = 20,
    Type = "play_effect_scene",
    Params = {
      id = 4,
      path = "Skill/FirePillar",
      pos = {
        36.57,
        12.0,
        34.37
      },
      ignoreNavMesh = 1
    }
  },
  [21] = {
    id = 21,
    Type = "dialog",
    Params = {
      dialog = {451467}
    }
  },
  [22] = {
    id = 22,
    Type = "summon",
    Params = {
      npcid = 803768,
      npcuid = 803768,
      groupid = 1,
      pos = {
        33.03,
        12.15,
        36.48
      },
      dir = 27
    }
  },
  [23] = {
    id = 23,
    Type = "dialog",
    Params = {
      dialog = {451468}
    }
  },
  [24] = {
    id = 24,
    Type = "action",
    Params = {npcuid = 803768, id = 23}
  },
  [25] = {
    id = 25,
    Type = "remove_effect_scene",
    Params = {id = 3}
  },
  [26] = {
    id = 26,
    Type = "remove_effect_scene",
    Params = {id = 4}
  },
  [27] = {
    id = 27,
    Type = "dialog",
    Params = {
      dialog = {451469}
    }
  },
  [28] = {
    id = 28,
    Type = "set_dir",
    Params = {npcuid = 803767, dir = 190}
  },
  [29] = {
    id = 29,
    Type = "wait_time",
    Params = {time = 1000}
  },
  [30] = {
    id = 30,
    Type = "dialog",
    Params = {
      dialog = {451470}
    }
  },
  [31] = {
    id = 31,
    Type = "action",
    Params = {npcuid = 803767, id = 10}
  },
  [32] = {
    id = 32,
    Type = "wait_time",
    Params = {time = 1000}
  },
  [33] = {
    id = 33,
    Type = "remove_npc",
    Params = {npcuid = 803767}
  },
  [34] = {
    id = 34,
    Type = "summon",
    Params = {
      npcid = 803767,
      npcuid = 803767,
      groupid = 1,
      pos = {
        35.0,
        12.0,
        35.39
      },
      dir = 190,
      waitaction = "pray"
    }
  },
  [35] = {
    id = 35,
    Type = "wait_time",
    Params = {time = 1000}
  },
  [36] = {
    id = 36,
    Type = "play_sound",
    Params = {
      path = "Common/Heal"
    }
  },
  [37] = {
    id = 37,
    Type = "play_effect_scene",
    Params = {
      id = 15,
      path = "Common/AddMF",
      pos = {
        35.0,
        12.0,
        35.39
      }
    }
  },
  [38] = {
    id = 38,
    Type = "summon",
    Params = {
      npcid = 803774,
      npcuid = 803774,
      groupid = 1,
      pos = {
        37.25,
        15.39,
        34.27
      },
      dir = 347.7,
      ignoreNavMesh = 1
    }
  },
  [39] = {
    id = 39,
    Type = "summon",
    Params = {
      npcid = 803775,
      npcuid = 803775,
      groupid = 1,
      pos = {
        34.41,
        15.61,
        34.83
      },
      dir = 17.06,
      ignoreNavMesh = 1
    }
  },
  [40] = {
    id = 40,
    Type = "summon",
    Params = {
      npcid = 803776,
      npcuid = 803776,
      groupid = 1,
      pos = {
        33.14,
        15.39,
        34.93
      },
      dir = 30.22,
      ignoreNavMesh = 1
    }
  },
  [41] = {
    id = 41,
    Type = "summon",
    Params = {
      npcid = 803777,
      npcuid = 803777,
      groupid = 1,
      pos = {
        35.82,
        15.61,
        34.49
      },
      dir = 3.48,
      ignoreNavMesh = 1
    }
  },
  [42] = {
    id = 42,
    Type = "wait_time",
    Params = {time = 1000}
  },
  [43] = {
    id = 43,
    Type = "play_sound",
    Params = {
      path = "Common/Heal"
    }
  },
  [44] = {
    id = 44,
    Type = "play_effect",
    Params = {
      id = 16,
      path = "Skill/Eff_Totem_Laser",
      npcuid = 803774,
      ep = 2,
      ignoreNavMesh = 1
    }
  },
  [45] = {
    id = 45,
    Type = "play_effect",
    Params = {
      id = 17,
      path = "Skill/Eff_Totem_Laser",
      npcuid = 803775,
      ep = 2,
      ignoreNavMesh = 1
    }
  },
  [46] = {
    id = 46,
    Type = "play_effect",
    Params = {
      id = 18,
      path = "Skill/Eff_Totem_Laser",
      npcuid = 803776,
      ep = 2,
      ignoreNavMesh = 1
    }
  },
  [47] = {
    id = 47,
    Type = "play_effect",
    Params = {
      id = 19,
      path = "Skill/Eff_Totem_Laser",
      npcuid = 803777,
      ep = 2,
      ignoreNavMesh = 1
    }
  },
  [48] = {
    id = 48,
    Type = "wait_time",
    Params = {time = 3000}
  },
  [49] = {
    id = 49,
    Type = "play_effect_scene",
    Params = {
      id = 5,
      path = "Skill/Detonator_slow",
      pos = {
        32.63,
        14.26,
        34.1
      },
      onshot = 1,
      ignoreNavMesh = 1
    }
  },
  [50] = {
    id = 50,
    Type = "play_effect_scene",
    Params = {
      id = 6,
      path = "Skill/Detonator_slow",
      pos = {
        34.09,
        15.49,
        33.92
      },
      onshot = 1,
      ignoreNavMesh = 1
    }
  },
  [51] = {
    id = 51,
    Type = "play_effect_scene",
    Params = {
      id = 7,
      path = "Skill/Detonator_slow",
      pos = {
        36.02,
        15.48,
        33.44
      },
      onshot = 1,
      ignoreNavMesh = 1
    }
  },
  [52] = {
    id = 52,
    Type = "play_effect_scene",
    Params = {
      id = 8,
      path = "Skill/Detonator_slow",
      pos = {
        37.47,
        14.26,
        32.91
      },
      onshot = 1,
      ignoreNavMesh = 1
    }
  },
  [53] = {
    id = 53,
    Type = "wait_time",
    Params = {time = 2000}
  },
  [54] = {
    id = 54,
    Type = "remove_npc",
    Params = {id = 803741}
  },
  [55] = {
    id = 55,
    Type = "remove_npc",
    Params = {id = 803742}
  },
  [56] = {
    id = 56,
    Type = "remove_npc",
    Params = {id = 803743}
  },
  [57] = {
    id = 57,
    Type = "remove_npc",
    Params = {id = 803744}
  },
  [58] = {
    id = 58,
    Type = "play_sound",
    Params = {
      path = "Common/Teleport"
    }
  },
  [59] = {
    id = 59,
    Type = "play_effect",
    Params = {
      id = 16,
      path = "Common/MaxViewOn",
      npcuid = 803767,
      ep = 2
    }
  },
  [60] = {
    id = 60,
    Type = "wait_time",
    Params = {time = 2000}
  },
  [61] = {
    id = 61,
    Type = "play_effect_scene",
    Params = {
      id = 9,
      path = "Skill/Detonator_slow",
      pos = {
        33.97,
        12.4,
        36.51
      },
      onshot = 1,
      ignoreNavMesh = 1
    }
  },
  [62] = {
    id = 62,
    Type = "play_effect_scene",
    Params = {
      id = 10,
      path = "Skill/Detonator_slow",
      pos = {
        36.73,
        12.4,
        36.25
      },
      onshot = 1,
      ignoreNavMesh = 1
    }
  },
  [63] = {
    id = 63,
    Type = "play_effect_scene",
    Params = {
      id = 11,
      path = "Skill/Detonator_slow",
      pos = {
        34.98,
        13.53,
        38.12
      },
      onshot = 1,
      ignoreNavMesh = 1
    }
  },
  [64] = {
    id = 64,
    Type = "play_effect_scene",
    Params = {
      id = 12,
      path = "Skill/Detonator_slow",
      pos = {
        36.22,
        13.63,
        38.27
      },
      onshot = 1,
      ignoreNavMesh = 1
    }
  },
  [65] = {
    id = 65,
    Type = "play_effect_scene",
    Params = {
      id = 13,
      path = "Skill/Detonator_slow",
      pos = {
        34.0,
        13.25,
        37.29
      },
      onshot = 1,
      ignoreNavMesh = 1
    }
  },
  [66] = {
    id = 66,
    Type = "play_effect_scene",
    Params = {
      id = 14,
      path = "Skill/Detonator_slow",
      pos = {
        36.71,
        13.25,
        37.29
      },
      onshot = 1,
      ignoreNavMesh = 1
    }
  },
  [67] = {
    id = 67,
    Type = "wait_time",
    Params = {time = 2000}
  },
  [68] = {
    id = 68,
    Type = "remove_effect_scene",
    Params = {id = 1}
  },
  [69] = {
    id = 69,
    Type = "remove_effect_scene",
    Params = {id = 2}
  },
  [70] = {
    id = 70,
    Type = "wait_time",
    Params = {time = 1000}
  },
  [71] = {
    id = 71,
    Type = "onoff_camerapoint",
    Params = {
      groupid = 0,
      on = false,
      returnDefaultTime = 1500
    }
  },
  [72] = {
    id = 72,
    Type = "endfilter",
    Params = {
      fliter = {38}
    }
  }
}
Table_PlotQuest_98_fields = {
  "id",
  "Type",
  "Params"
}
return Table_PlotQuest_98
