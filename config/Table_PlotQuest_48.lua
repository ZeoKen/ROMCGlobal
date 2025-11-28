Table_PlotQuest_48 = {
  [1] = {
    id = 1,
    Type = "onoff_camerapoint",
    Params = {
      groupid = 1,
      on = false,
      returnDefaultTime = 1500
    }
  },
  [2] = {
    id = 2,
    Type = "onoff_camerapoint",
    Params = {
      groupid = 0,
      on = true,
      returnDefaultTime = 1500
    }
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
    Type = "showview",
    Params = {panelid = 800, showtype = 1}
  },
  [5] = {
    id = 5,
    Type = "camera_filter",
    Params = {filterid = 2, on = 1}
  },
  [6] = {
    id = 6,
    Type = "wait_time",
    Params = {time = 1500}
  },
  [7] = {
    id = 7,
    Type = "summon",
    Params = {
      npcid = 806720,
      npcuid = 720,
      groupid = 1,
      pos = {
        47.77,
        7.72,
        -48.1
      },
      dir = 181
    }
  },
  [8] = {
    id = 8,
    Type = "shakescreen",
    Params = {amplitude = 10, time = 2000}
  },
  [9] = {
    id = 9,
    Type = "play_effect_scene",
    Params = {
      id = 1,
      path = "Common/DragonWind",
      pos = {
        50.94,
        7.72,
        -48.1
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
    Type = "shakescreen",
    Params = {amplitude = 10, time = 2000}
  },
  [12] = {
    id = 12,
    Type = "play_effect_scene",
    Params = {
      id = 2,
      path = "Common/DragonWind",
      pos = {
        48.05,
        7.61,
        -53.59
      },
      ignoreNavMesh = 1
    }
  },
  [13] = {
    id = 13,
    Type = "wait_time",
    Params = {time = 500}
  },
  [14] = {
    id = 14,
    Type = "play_effect_scene",
    Params = {
      id = 2,
      path = "Common/DragonWind",
      pos = {
        55.65,
        2.97,
        -51.49
      },
      ignoreNavMesh = 1
    }
  },
  [15] = {
    id = 15,
    Type = "wait_time",
    Params = {time = 500}
  },
  [16] = {
    id = 16,
    Type = "shakescreen",
    Params = {amplitude = 10, time = 2000}
  },
  [17] = {
    id = 17,
    Type = "play_effect_scene",
    Params = {
      id = 3,
      path = "Common/DragonWind",
      pos = {
        50.94,
        7.72,
        -49.71
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
    Type = "dialog",
    Params = {
      dialog = {500511},
      npcid = 806720
    }
  },
  [20] = {
    id = 20,
    Type = "remove_npc",
    Params = {npcuid = 720}
  },
  [21] = {
    id = 21,
    Type = "play_effect_scene",
    Params = {
      id = 4,
      path = "Common/DragonWind",
      pos = {
        47.77,
        7.72,
        -48.1
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
    Type = "summon",
    Params = {
      npcid = 806720,
      npcuid = 7201,
      groupid = 1,
      pos = {
        47.77,
        9.95,
        -48.1
      },
      dir = 181,
      waitaction = "be_HeightRaise",
      ignoreNavMesh = 1
    }
  },
  [24] = {
    id = 24,
    Type = "wait_time",
    Params = {time = 2000}
  },
  [25] = {
    id = 25,
    Type = "play_effect_scene",
    Params = {
      id = 5,
      path = "Skill/DragonPrance_atk",
      pos = {
        47.77,
        7.72,
        -48.1
      },
      onshot = 1,
      ignoreNavMesh = 1
    }
  },
  [26] = {
    id = 26,
    Type = "wait_time",
    Params = {time = 100}
  },
  [27] = {
    id = 27,
    Type = "dialog",
    Params = {
      dialog = {500512, 500513},
      npcid = 806720
    }
  },
  [28] = {
    id = 28,
    Type = "remove_npc",
    Params = {npcuid = 7201}
  },
  [29] = {
    id = 29,
    Type = "wait_time",
    Params = {time = 500}
  },
  [30] = {
    id = 30,
    Type = "remove_effect_scene",
    Params = {id = 1}
  },
  [31] = {
    id = 31,
    Type = "remove_effect_scene",
    Params = {id = 2}
  },
  [32] = {
    id = 32,
    Type = "remove_effect_scene",
    Params = {id = 3}
  },
  [33] = {
    id = 33,
    Type = "remove_effect_scene",
    Params = {id = 4}
  },
  [34] = {
    id = 34,
    Type = "remove_effect_scene",
    Params = {id = 5}
  },
  [35] = {
    id = 35,
    Type = "endfilter",
    Params = {
      fliter = {39}
    }
  },
  [36] = {
    id = 36,
    Type = "showview",
    Params = {panelid = 800, showtype = 2}
  },
  [37] = {
    id = 37,
    Type = "onoff_camerapoint",
    Params = {
      groupid = 0,
      on = false,
      returnDefaultTime = 1500
    }
  },
  [38] = {
    id = 38,
    Type = "onoff_camerapoint",
    Params = {
      groupid = 1,
      on = true,
      returnDefaultTime = 1500
    }
  },
  [39] = {
    id = 39,
    Type = "camera_filter",
    Params = {filterid = 2, on = 0}
  }
}
Table_PlotQuest_48_fields = {
  "id",
  "Type",
  "Params"
}
return Table_PlotQuest_48
