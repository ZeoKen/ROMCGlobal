Table_PlotQuest_43 = {
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
      fliter = {20}
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
  [10] = {
    id = 10,
    Type = "wait_time",
    Params = {time = 1000}
  },
  [11] = {
    id = 11,
    Type = "play_effect_scene",
    Params = {
      id = 1,
      path = "effect",
      effect = "Skill/DemonKing_crystal_buff",
      pos = {
        -3.22,
        1.44,
        -31.79
      },
      ignoreNavMesh = 1
    }
  },
  [12] = {
    id = 12,
    Type = "wait_time",
    Params = {time = 1000}
  },
  [13] = {
    id = 13,
    Type = "play_effect_scene",
    Params = {
      id = 2,
      path = "effect",
      effect = "Skill/DemonKing_crystal_buff",
      pos = {
        -3.22,
        5.31,
        -31.79
      },
      ignoreNavMesh = 1
    }
  },
  [14] = {
    id = 14,
    Type = "wait_time",
    Params = {time = 1000}
  },
  [15] = {
    id = 15,
    Type = "play_effect_scene",
    Params = {
      id = 3,
      path = "effect",
      effect = "Skill/DemonKing_crystal_buff",
      pos = {
        -3.22,
        9.27,
        -31.79
      },
      ignoreNavMesh = 1
    }
  },
  [16] = {
    id = 16,
    Type = "play_effect_scene",
    Params = {
      id = 4,
      path = "effect",
      effect = "Common/PhotonForce_Yellow",
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
      dialog = {500096}
    }
  },
  [19] = {
    id = 19,
    Type = "wait_time",
    Params = {time = 8000}
  },
  [20] = {
    id = 20,
    Type = "remove_effect_scene",
    Params = {id = 1}
  },
  [21] = {
    id = 21,
    Type = "remove_effect_scene",
    Params = {id = 2}
  },
  [22] = {
    id = 22,
    Type = "remove_effect_scene",
    Params = {id = 3}
  },
  [23] = {
    id = 23,
    Type = "remove_effect_scene",
    Params = {id = 4}
  },
  [24] = {
    id = 24,
    Type = "onoff_camerapoint",
    Params = {groupid = 0, on = false}
  },
  [25] = {
    id = 25,
    Type = "play_effect_ui",
    Params = {path = "BtoW"}
  },
  [26] = {
    id = 26,
    Type = "startfilter",
    Params = {
      fliter = {20}
    }
  },
  [27] = {
    id = 27,
    Type = "showview",
    Params = {panelid = 800, showtype = 2}
  },
  [28] = {
    id = 28,
    Type = "camera_filter",
    Params = {filterid = 2, on = 0}
  }
}
Table_PlotQuest_43_fields = {
  "id",
  "Type",
  "Params"
}
return Table_PlotQuest_43
