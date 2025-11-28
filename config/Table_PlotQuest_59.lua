Table_PlotQuest_59 = {
  [1] = {
    id = 1,
    Type = "play_effect_ui",
    Params = {path = "BtoW"}
  },
  [2] = {
    id = 2,
    Type = "startfilter",
    Params = {
      fliter = {37}
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
    Params = {groupid = 1, on = true}
  },
  [5] = {
    id = 5,
    Type = "change_bgm",
    Params = {
      path = "room_church",
      time = 0
    }
  },
  [6] = {
    id = 6,
    Type = "summon",
    Params = {
      npcid = 807554,
      npcuid = 807554,
      pos = {
        0.0,
        0.0,
        -8.86
      },
      dir = 180
    }
  },
  [7] = {
    id = 7,
    Type = "summon",
    Params = {
      npcid = 807553,
      npcuid = 807553,
      pos = {
        0.0,
        0.0,
        -10.83
      },
      dir = 0
    }
  },
  [8] = {
    id = 8,
    Type = "summon",
    Params = {
      npcid = 807558,
      npcuid = 807558,
      pos = {
        1.11,
        0.0,
        -7.45
      },
      dir = 180
    }
  },
  [9] = {
    id = 9,
    Type = "summon",
    Params = {
      npcid = 807559,
      npcuid = 807559,
      pos = {
        2.39,
        0.11,
        -7.45
      },
      dir = 180
    }
  },
  [10] = {
    id = 10,
    Type = "summon",
    Params = {
      npcid = 807561,
      npcuid = 807561,
      pos = {
        -0.02,
        0.24,
        0.94
      },
      dir = 0,
      ignoreNavMesh = 1,
      waitaction = "state3002"
    }
  },
  [11] = {
    id = 11,
    Type = "summon",
    Params = {
      npcid = 807562,
      npcuid = 807562,
      pos = {
        -3.49,
        0.0,
        -9.55
      },
      dir = 90,
      scale = 2
    }
  },
  [12] = {
    id = 12,
    Type = "action",
    Params = {npcuid = 807554, id = 25}
  },
  [13] = {
    id = 13,
    Type = "wait_time",
    Params = {time = 2000}
  },
  [14] = {
    id = 14,
    Type = "play_effect_scene",
    Params = {
      id = 2,
      path = "Skill/Diamond_buff",
      pos = {
        1.0,
        0.0,
        -9.1
      }
    }
  },
  [15] = {
    id = 15,
    Type = "play_effect_scene",
    Params = {
      id = 3,
      path = "Skill/Diamond_buff",
      pos = {
        -1.0,
        0.0,
        -9.1
      }
    }
  },
  [16] = {
    id = 16,
    Type = "wait_time",
    Params = {time = 1000}
  },
  [17] = {
    id = 17,
    Type = "action",
    Params = {npcuid = 807554, id = 22}
  },
  [18] = {
    id = 18,
    Type = "wait_time",
    Params = {time = 2000}
  },
  [19] = {
    id = 19,
    Type = "dialog",
    Params = {
      dialog = {750191, 750192}
    }
  },
  [20] = {
    id = 20,
    Type = "play_effect",
    Params = {
      path = "Common/FreezeFlower_White",
      npcuid = 807554,
      ep = 2
    }
  },
  [21] = {
    id = 21,
    Type = "wait_time",
    Params = {time = 2000}
  },
  [22] = {
    id = 22,
    Type = "dialog",
    Params = {
      dialog = {750193}
    }
  },
  [23] = {
    id = 23,
    Type = "play_effect_scene",
    Params = {
      id = 1,
      path = "Skill/Task_magic2",
      pos = {
        0.0,
        0.0,
        -8.86
      }
    }
  },
  [24] = {
    id = 24,
    Type = "wait_time",
    Params = {time = 1000}
  },
  [25] = {
    id = 25,
    Type = "dialog",
    Params = {
      dialog = {
        750194,
        750195,
        750196,
        750197,
        750198,
        750199,
        750200,
        750201,
        750202,
        750203,
        750204
      }
    }
  },
  [26] = {
    id = 26,
    Type = "action",
    Params = {npcuid = 807554, id = 308}
  },
  [27] = {
    id = 27,
    Type = "wait_time",
    Params = {time = 2000}
  },
  [28] = {
    id = 28,
    Type = "dialog",
    Params = {
      dialog = {750205}
    }
  },
  [29] = {
    id = 29,
    Type = "play_effect_scene",
    Params = {
      id = 4,
      path = "Skill/StormHeart_buff",
      pos = {
        0.0,
        0.0,
        -8.86
      }
    }
  },
  [30] = {
    id = 30,
    Type = "wait_time",
    Params = {time = 1000}
  },
  [31] = {
    id = 31,
    Type = "action",
    Params = {npcuid = 807562, id = 23}
  },
  [32] = {
    id = 32,
    Type = "play_effect_scene",
    Params = {
      id = 2,
      path = "Skill/Eff_ColdSpit",
      pos = {
        1.0,
        0.0,
        -9.1
      },
      onshot = 1
    }
  },
  [33] = {
    id = 33,
    Type = "wait_time",
    Params = {time = 2000}
  },
  [34] = {
    id = 34,
    Type = "dialog",
    Params = {
      dialog = {750206}
    }
  },
  [35] = {
    id = 35,
    Type = "wait_time",
    Params = {time = 0}
  },
  [36] = {
    id = 36,
    Type = "dialog",
    Params = {
      dialog = {750207}
    }
  },
  [37] = {
    id = 37,
    Type = "action",
    Params = {npcuid = 807562, id = 21}
  },
  [38] = {
    id = 38,
    Type = "wait_time",
    Params = {time = 1000}
  },
  [39] = {
    id = 39,
    Type = "play_effect",
    Params = {
      path = "Skill/FreezeFlower_White",
      npcuid = 807554,
      ep = 2
    }
  },
  [40] = {
    id = 40,
    Type = "wait_time",
    Params = {time = 1000}
  },
  [41] = {
    id = 41,
    Type = "dialog",
    Params = {
      dialog = {750208}
    }
  },
  [42] = {
    id = 42,
    Type = "action",
    Params = {npcuid = 807562, id = 5}
  },
  [43] = {
    id = 43,
    Type = "wait_time",
    Params = {time = 1000}
  },
  [44] = {
    id = 44,
    Type = "play_effect",
    Params = {
      path = "Skill/StormGust",
      npcuid = 807562,
      ep = 2
    }
  },
  [45] = {
    id = 45,
    Type = "wait_time",
    Params = {time = 2000}
  },
  [46] = {
    id = 46,
    Type = "remove_npc",
    Params = {npcuid = 807562}
  },
  [47] = {
    id = 47,
    Type = "summon",
    Params = {
      npcid = 807563,
      npcuid = 807563,
      pos = {
        -3.49,
        -5.05,
        -9.55
      },
      dir = 180,
      behavior = 1024,
      scale = 2,
      ignoreNavMesh = 1
    }
  },
  [48] = {
    id = 48,
    Type = "wait_time",
    Params = {time = 0}
  },
  [49] = {
    id = 49,
    Type = "play_effect_scene",
    Params = {
      id = 5,
      path = "Skill/Detonator_slow",
      pos = {
        0.0,
        0.0,
        -8.86
      }
    }
  },
  [50] = {
    id = 50,
    Type = "wait_time",
    Params = {time = 1000}
  },
  [51] = {
    id = 51,
    Type = "remove_effect_scene",
    Params = {id = 1}
  },
  [52] = {
    id = 52,
    Type = "remove_effect_scene",
    Params = {id = 2}
  },
  [53] = {
    id = 53,
    Type = "remove_effect_scene",
    Params = {id = 3}
  },
  [54] = {
    id = 54,
    Type = "remove_effect_scene",
    Params = {id = 4}
  },
  [55] = {
    id = 55,
    Type = "remove_effect_scene",
    Params = {id = 5}
  },
  [56] = {
    id = 56,
    Type = "remove_npc",
    Params = {npcuid = 807554}
  },
  [57] = {
    id = 57,
    Type = "dialog",
    Params = {
      dialog = {750209}
    }
  },
  [58] = {
    id = 58,
    Type = "wait_time",
    Params = {time = 0}
  },
  [59] = {
    id = 59,
    Type = "play_effect_scene",
    Params = {
      id = 6,
      path = "Skill/StormHeart_buff",
      pos = {
        -0.02,
        0.24,
        0.94
      }
    }
  },
  [60] = {
    id = 60,
    Type = "wait_time",
    Params = {time = 1000}
  },
  [61] = {
    id = 61,
    Type = "action",
    Params = {npcuid = 807561, id = 500}
  },
  [62] = {
    id = 62,
    Type = "wait_time",
    Params = {time = 1000}
  },
  [63] = {
    id = 63,
    Type = "dialog",
    Params = {
      dialog = {750210}
    }
  },
  [64] = {
    id = 64,
    Type = "wait_time",
    Params = {time = 1000}
  },
  [65] = {
    id = 65,
    Type = "onoff_camerapoint",
    Params = {
      groupid = 1,
      on = false,
      returnDefaultTime = 1500
    }
  },
  [66] = {
    id = 66,
    Type = "wait_time",
    Params = {time = 2000}
  },
  [67] = {
    id = 67,
    Type = "showview",
    Params = {panelid = 800, showtype = 2}
  },
  [68] = {
    id = 68,
    Type = "endfilter",
    Params = {
      fliter = {37}
    }
  }
}
Table_PlotQuest_59_fields = {
  "id",
  "Type",
  "Params"
}
return Table_PlotQuest_59
