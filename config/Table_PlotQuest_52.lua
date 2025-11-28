Table_PlotQuest_52 = {
  [1] = {
    id = 1,
    Type = "play_effect_ui",
    Params = {path = "BtoW"}
  },
  [2] = {
    id = 2,
    Type = "startfilter",
    Params = {
      fliter = {20}
    }
  },
  [3] = {
    id = 3,
    Type = "showview",
    Params = {panelid = 800, showtype = 1}
  },
  [4] = {
    id = 4,
    Type = "play_camera_anim",
    Params = {name = "Camera7", time = 18}
  },
  [5] = {
    id = 5,
    Type = "summon",
    Params = {
      npcid = 806834,
      npcuid = 806834,
      groupid = 1,
      pos = {
        -36.46,
        10.17,
        52.7
      },
      dir = 90,
      ignoreNavMesh = 1,
      waitaction = "state1002"
    }
  },
  [6] = {
    id = 6,
    Type = "summon",
    Params = {
      npcid = 806835,
      npcuid = 806835,
      groupid = 1,
      pos = {
        40.85,
        10.18,
        52.8
      },
      dir = 270,
      ignoreNavMesh = 1,
      waitaction = "state1002"
    }
  },
  [7] = {
    id = 7,
    Type = "wait_time",
    Params = {time = 1000}
  },
  [8] = {
    id = 8,
    Type = "play_effect_scene",
    Params = {
      id = 1,
      path = "Skill/DemonKing_Invincible",
      pos = {
        2.5,
        10.2,
        71.2
      },
      ignoreNavMesh = 1
    }
  },
  [9] = {
    id = 9,
    Type = "wait_time",
    Params = {time = 2000}
  },
  [10] = {
    id = 10,
    Type = "play_camera_anim",
    Params = {name = "Camera8", time = 9}
  },
  [11] = {
    id = 11,
    Type = "wait_time",
    Params = {time = 4000}
  },
  [12] = {
    id = 12,
    Type = "action",
    Params = {npcuid = 806834, id = 502}
  },
  [13] = {
    id = 13,
    Type = "wait_time",
    Params = {time = 3000}
  },
  [14] = {
    id = 14,
    Type = "play_camera_anim",
    Params = {name = "Camera6", time = 6}
  },
  [15] = {
    id = 15,
    Type = "wait_time",
    Params = {time = 1000}
  },
  [16] = {
    id = 16,
    Type = "action",
    Params = {npcuid = 806835, id = 502}
  },
  [17] = {
    id = 17,
    Type = "wait_time",
    Params = {time = 4000}
  },
  [18] = {
    id = 18,
    Type = "remove_effect_scene",
    Params = {id = 1}
  },
  [19] = {
    id = 19,
    Type = "remove_npc",
    Params = {npcuid = 806834}
  },
  [20] = {
    id = 20,
    Type = "remove_npc",
    Params = {npcuid = 806835}
  },
  [21] = {
    id = 21,
    Type = "endfilter",
    Params = {
      fliter = {20}
    }
  },
  [22] = {
    id = 22,
    Type = "showview",
    Params = {panelid = 800, showtype = 2}
  },
  [23] = {
    id = 23,
    Type = "camera_filter",
    Params = {filterid = 2, on = 0}
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
    Type = "reset_camera",
    Params = _EmptyTable
  }
}
Table_PlotQuest_52_fields = {
  "id",
  "Type",
  "Params"
}
return Table_PlotQuest_52
