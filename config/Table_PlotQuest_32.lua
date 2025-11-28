Table_PlotQuest_32 = {
  [1] = {
    id = 1,
    Type = "onoff_camerapoint",
    Params = {groupid = 0, on = true}
  },
  [2] = {
    id = 2,
    Type = "play_effect_ui",
    Params = {path = "BtoW"}
  },
  [3] = {
    id = 3,
    Type = "startfilter",
    Params = {
      fliter = {38}
    }
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
      npcid = 806509,
      npcuid = 806509,
      pos = {
        11.14,
        -1.54,
        -5.32
      },
      dir = 34.02,
      groupid = 1,
      ignoreNavMesh = 1
    }
  },
  [6] = {
    id = 6,
    Type = "play_effect_scene",
    Params = {
      id = 2,
      path = "Skill/NatureLoop_buff1",
      pos = {
        11.14,
        -1.54,
        -5.32
      },
      ignoreNavMesh = 1
    }
  },
  [7] = {
    id = 7,
    Type = "wait_time",
    Params = {time = 3000}
  },
  [8] = {
    id = 8,
    Type = "play_effect_scene",
    Params = {
      id = 3,
      path = "Skill/IdunApple_buff1",
      pos = {
        11.14,
        -1.54,
        -5.32
      },
      ignoreNavMesh = 1
    }
  },
  [9] = {
    id = 9,
    Type = "wait_time",
    Params = {time = 3000}
  },
  [10] = {
    id = 10,
    Type = "play_effect_scene",
    Params = {
      id = 4,
      path = "Skill/GreatWaves_buff",
      pos = {
        11.14,
        -1.54,
        -5.32
      },
      ignoreNavMesh = 1
    }
  },
  [11] = {
    id = 11,
    Type = "wait_time",
    Params = {time = 2000}
  },
  [12] = {
    id = 12,
    Type = "play_effect_scene",
    Params = {
      id = 5,
      path = "Skill/GreatWaves_atk",
      pos = {
        10.2,
        -1.54,
        -4.78
      },
      ignoreNavMesh = 1,
      onshot = 1
    }
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
      id = 6,
      path = "Skill/GreatWaves_atk",
      pos = {
        15.36,
        -1.54,
        -8.85
      },
      ignoreNavMesh = 1,
      onshot = 1
    }
  },
  [15] = {
    id = 15,
    Type = "wait_time",
    Params = {time = 2000}
  },
  [16] = {
    id = 16,
    Type = "play_effect_scene",
    Params = {
      id = 7,
      path = "Skill/GreatWaves_atk",
      pos = {
        10.2,
        -1.54,
        -4.78
      },
      ignoreNavMesh = 1,
      onshot = 1
    }
  },
  [17] = {
    id = 17,
    Type = "play_effect_scene",
    Params = {
      id = 8,
      path = "Skill/GreatWaves_atk",
      pos = {
        15.36,
        -1.54,
        -8.85
      },
      ignoreNavMesh = 1,
      onshot = 1
    }
  },
  [18] = {
    id = 18,
    Type = "remove_npc",
    Params = {npcuid = 806509}
  },
  [19] = {
    id = 19,
    Type = "summon",
    Params = {
      npcid = 806503,
      npcuid = 806503,
      pos = {
        11.14,
        -1.54,
        -5.32
      },
      dir = 34.02,
      groupid = 1,
      ignoreNavMesh = 1,
      waitaction = "state2002"
    }
  },
  [20] = {
    id = 20,
    Type = "wait_time",
    Params = {time = 1000}
  },
  [21] = {
    id = 21,
    Type = "play_effect_scene",
    Params = {
      id = 8,
      path = "Skill/GreatWaves_atk",
      pos = {
        10.2,
        -1.54,
        -4.78
      },
      ignoreNavMesh = 1,
      onshot = 1
    }
  },
  [22] = {
    id = 22,
    Type = "wait_time",
    Params = {time = 2000}
  },
  [23] = {
    id = 23,
    Type = "remove_effect_scene",
    Params = {id = 4}
  },
  [24] = {
    id = 24,
    Type = "wait_time",
    Params = {time = 2000}
  },
  [25] = {
    id = 25,
    Type = "remove_effect_scene",
    Params = {id = 3}
  },
  [26] = {
    id = 26,
    Type = "remove_effect_scene",
    Params = {id = 2}
  },
  [27] = {
    id = 27,
    Type = "remove_npc",
    Params = {npcuid = 806503}
  },
  [28] = {
    id = 28,
    Type = "endfilter",
    Params = {
      fliter = {38}
    }
  },
  [29] = {
    id = 29,
    Type = "onoff_camerapoint",
    Params = {
      groupid = 0,
      on = false,
      returnDefaultTime = 1500
    }
  }
}
Table_PlotQuest_32_fields = {
  "id",
  "Type",
  "Params"
}
return Table_PlotQuest_32
