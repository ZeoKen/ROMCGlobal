Table_PlotQuest_40 = {
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
    Type = "showview",
    Params = {panelid = 800, showpath = 1}
  },
  [4] = {
    id = 4,
    Type = "camera_filter",
    Params = {filterid = 2, on = 1}
  },
  [5] = {
    id = 5,
    Type = "wait_time",
    Params = {time = 3000}
  },
  [6] = {
    id = 6,
    Type = "play_effect_scene",
    Params = {
      id = 1,
      path = "Common/MaxViewOn",
      pos = {
        -4.29,
        0.09,
        -39.27
      },
      onshot = 1,
      ignoreNavMesh = 1
    }
  },
  [7] = {
    id = 7,
    Type = "wait_time",
    Params = {time = 1500}
  },
  [8] = {
    id = 8,
    Type = "play_effect_scene",
    Params = {
      id = 2,
      path = "Skill/DemonKing_crystal_buff",
      pos = {
        -3.22,
        1.44,
        -31.79
      },
      ignoreNavMesh = 1
    }
  },
  [9] = {
    id = 9,
    Type = "wait_time",
    Params = {time = 1500}
  },
  [10] = {
    id = 10,
    Type = "play_effect_scene",
    Params = {
      id = 3,
      path = "Skill/DemonKing_crystal_buff",
      pos = {
        -3.22,
        5.31,
        -31.79
      },
      ignoreNavMesh = 1
    }
  },
  [11] = {
    id = 11,
    Type = "wait_time",
    Params = {time = 1500}
  },
  [12] = {
    id = 12,
    Type = "play_effect_scene",
    Params = {
      id = 4,
      path = "Skill/DemonKing_crystal_buff",
      pos = {
        -3.22,
        9.27,
        -31.79
      },
      ignoreNavMesh = 1
    }
  },
  [13] = {
    id = 13,
    Type = "wait_time",
    Params = {time = 1000}
  },
  [14] = {
    id = 14,
    Type = "action",
    Params = {npcid = 806276, id = 9}
  },
  [15] = {
    id = 15,
    Type = "wait_time",
    Params = {time = 1000}
  },
  [16] = {
    id = 16,
    Type = "play_effect_scene",
    Params = {
      id = 5,
      path = "Skill/CircleSlow_buff",
      pos = {
        -4.31,
        2.05,
        -44.81
      },
      ignoreNavMesh = 1
    }
  },
  [17] = {
    id = 17,
    Type = "wait_time",
    Params = {time = 1000}
  },
  [18] = {
    id = 18,
    Type = "dialog",
    Params = {
      dialog = {500091},
      npcid = 806274
    }
  },
  [19] = {
    id = 19,
    Type = "remove_effect_scene",
    Params = {id = 1}
  },
  [20] = {
    id = 20,
    Type = "remove_effect_scene",
    Params = {id = 2}
  },
  [21] = {
    id = 21,
    Type = "remove_effect_scene",
    Params = {id = 3}
  },
  [22] = {
    id = 22,
    Type = "remove_effect_scene",
    Params = {id = 4}
  },
  [23] = {
    id = 23,
    Type = "remove_effect_scene",
    Params = {id = 5}
  },
  [24] = {
    id = 24,
    Type = "onoff_camerapoint",
    Params = {
      groupid = 0,
      on = false,
      returnDefaultTime = 1500
    }
  },
  [25] = {
    id = 25,
    Type = "showview",
    Params = {panelid = 800, showpath = 2}
  },
  [26] = {
    id = 26,
    Type = "camera_filter",
    Params = {filterid = 2, on = 0}
  }
}
Table_PlotQuest_40_fields = {
  "id",
  "Type",
  "Params"
}
return Table_PlotQuest_40
