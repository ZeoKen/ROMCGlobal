Table_PlotQuest_33 = {
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
      fliter = {39}
    }
  },
  [4] = {
    id = 4,
    Type = "camera_filter",
    Params = {filterid = 5, on = 1}
  },
  [5] = {
    id = 5,
    Type = "wait_time",
    Params = {time = 500}
  },
  [6] = {
    id = 6,
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
  [7] = {
    id = 7,
    Type = "summon",
    Params = {
      npcid = 806499,
      npcuid = 806499,
      pos = {
        6.13,
        -1.22,
        -11.51
      },
      dir = 188.1,
      groupid = 1,
      waitaction = "play_wave"
    }
  },
  [8] = {
    id = 8,
    Type = "play_effect_scene",
    Params = {
      id = 1,
      path = "Common/bloom",
      pos = {
        6.13,
        -1.22,
        -11.51
      }
    }
  },
  [9] = {
    id = 9,
    Type = "dialog",
    Params = {
      dialog = {600557, 600556}
    }
  },
  [10] = {
    id = 10,
    Type = "play_effect_scene",
    Params = {
      id = 2,
      path = "Skill/Detonator_slow",
      pos = {
        6.13,
        -1.22,
        -11.51
      },
      onshot = 1
    }
  },
  [11] = {
    id = 11,
    Type = "play_effect_scene",
    Params = {
      id = 3,
      path = "Skill/SoldierCat3_die",
      pos = {
        6.13,
        -1.22,
        -11.51
      },
      onshot = 1
    }
  },
  [12] = {
    id = 12,
    Type = "wait_time",
    Params = {time = 500}
  },
  [13] = {
    id = 13,
    Type = "remove_npc",
    Params = {npcuid = 806499}
  },
  [14] = {
    id = 14,
    Type = "wait_time",
    Params = {time = 500}
  },
  [15] = {
    id = 15,
    Type = "play_effect_scene",
    Params = {
      id = 4,
      path = "Common/bloom",
      pos = {
        7.62,
        -1.22,
        -11.24
      },
      ignoreNavMesh = 1
    }
  },
  [16] = {
    id = 16,
    Type = "wait_time",
    Params = {time = 500}
  },
  [17] = {
    id = 17,
    Type = "play_effect_scene",
    Params = {
      id = 5,
      path = "Common/bloom",
      pos = {
        8.92,
        -1.31,
        -10.64
      },
      ignoreNavMesh = 1
    }
  },
  [18] = {
    id = 18,
    Type = "wait_time",
    Params = {time = 500}
  },
  [19] = {
    id = 19,
    Type = "play_effect_scene",
    Params = {
      id = 6,
      path = "Common/bloom",
      pos = {
        9.61,
        -0.98,
        -10.0
      },
      ignoreNavMesh = 1
    }
  },
  [20] = {
    id = 20,
    Type = "wait_time",
    Params = {time = 500}
  },
  [21] = {
    id = 21,
    Type = "play_effect_scene",
    Params = {
      id = 7,
      path = "Common/bloom",
      pos = {
        10.47,
        -0.78,
        -8.76
      },
      ignoreNavMesh = 1
    }
  },
  [22] = {
    id = 22,
    Type = "wait_time",
    Params = {time = 500}
  },
  [23] = {
    id = 23,
    Type = "play_effect_scene",
    Params = {
      id = 8,
      path = "Common/bloom",
      pos = {
        11.59,
        -0.81,
        -7.5
      },
      ignoreNavMesh = 1
    }
  },
  [24] = {
    id = 24,
    Type = "wait_time",
    Params = {time = 500}
  },
  [25] = {
    id = 25,
    Type = "action",
    Params = {npcuid = 806503, id = 504}
  },
  [26] = {
    id = 26,
    Type = "wait_time",
    Params = {time = 4000}
  },
  [27] = {
    id = 27,
    Type = "play_effect_scene",
    Params = {
      id = 9,
      path = "Skill/SoldierCat3_die",
      pos = {
        6.77,
        -0.94,
        -11.1
      },
      onshot = 1,
      ignoreNavMesh = 1
    }
  },
  [28] = {
    id = 28,
    Type = "play_effect_scene",
    Params = {
      id = 10,
      path = "Skill/SoldierCat3_die",
      pos = {
        8.24,
        -0.86,
        -10.66
      },
      onshot = 1,
      ignoreNavMesh = 1
    }
  },
  [29] = {
    id = 29,
    Type = "play_effect_scene",
    Params = {
      id = 11,
      path = "Skill/SoldierCat3_die",
      pos = {
        9.32,
        -0.83,
        -10.06
      },
      onshot = 1,
      ignoreNavMesh = 1
    }
  },
  [30] = {
    id = 30,
    Type = "play_effect_scene",
    Params = {
      id = 12,
      path = "Skill/SoldierCat3_die",
      pos = {
        10.32,
        -1.34,
        -7.57
      },
      onshot = 1,
      ignoreNavMesh = 1
    }
  },
  [31] = {
    id = 31,
    Type = "play_effect_scene",
    Params = {
      id = 13,
      path = "Skill/Detonator_slow",
      pos = {
        6.77,
        -0.94,
        -11.1
      },
      onshot = 1,
      ignoreNavMesh = 1
    }
  },
  [32] = {
    id = 32,
    Type = "play_effect_scene",
    Params = {
      id = 14,
      path = "Skill/Detonator_slow",
      pos = {
        8.24,
        -0.86,
        -10.66
      },
      onshot = 1,
      ignoreNavMesh = 1
    }
  },
  [33] = {
    id = 33,
    Type = "play_effect_scene",
    Params = {
      id = 15,
      path = "Skill/Detonator_slow",
      pos = {
        9.32,
        -0.83,
        -10.06
      },
      onshot = 1,
      ignoreNavMesh = 1
    }
  },
  [34] = {
    id = 34,
    Type = "play_effect_scene",
    Params = {
      id = 16,
      path = "Skill/Detonator_slow",
      pos = {
        10.32,
        -1.34,
        -7.57
      },
      onshot = 1,
      ignoreNavMesh = 1
    }
  },
  [35] = {
    id = 35,
    Type = "wait_time",
    Params = {time = 500}
  },
  [36] = {
    id = 36,
    Type = "remove_effect_scene",
    Params = {id = 1}
  },
  [37] = {
    id = 37,
    Type = "remove_effect_scene",
    Params = {id = 4}
  },
  [38] = {
    id = 38,
    Type = "remove_effect_scene",
    Params = {id = 5}
  },
  [39] = {
    id = 39,
    Type = "remove_effect_scene",
    Params = {id = 6}
  },
  [40] = {
    id = 40,
    Type = "remove_effect_scene",
    Params = {id = 7}
  },
  [41] = {
    id = 41,
    Type = "remove_effect_scene",
    Params = {id = 8}
  },
  [42] = {
    id = 42,
    Type = "wait_time",
    Params = {time = 6000}
  },
  [43] = {
    id = 43,
    Type = "remove_npc",
    Params = {npcuid = 806503}
  },
  [44] = {
    id = 44,
    Type = "camera_filter",
    Params = {filterid = 5, on = 0}
  },
  [45] = {
    id = 45,
    Type = "endfilter",
    Params = {
      fliter = {39}
    }
  },
  [46] = {
    id = 46,
    Type = "onoff_camerapoint",
    Params = {
      groupid = 0,
      on = false,
      returnDefaultTime = 1500
    }
  }
}
Table_PlotQuest_33_fields = {
  "id",
  "Type",
  "Params"
}
return Table_PlotQuest_33
