Table_PlotQuest_61 = {
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
      waitaction = "state2002"
    }
  },
  [5] = {
    id = 5,
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
      waitaction = "state2002"
    }
  },
  [6] = {
    id = 6,
    Type = "play_camera_anim",
    Params = {name = "Camera9", time = 15}
  },
  [7] = {
    id = 7,
    Type = "wait_time",
    Params = {time = 2000}
  },
  [8] = {
    id = 8,
    Type = "action",
    Params = {npcuid = 806834, id = 504}
  },
  [9] = {
    id = 9,
    Type = "action",
    Params = {npcuid = 806835, id = 504}
  },
  [10] = {
    id = 10,
    Type = "wait_time",
    Params = {time = 3000}
  },
  [11] = {
    id = 11,
    Type = "action",
    Params = {npcuid = 806834, id = 506}
  },
  [12] = {
    id = 12,
    Type = "action",
    Params = {npcuid = 806835, id = 506}
  },
  [13] = {
    id = 13,
    Type = "wait_time",
    Params = {time = 1000}
  },
  [14] = {
    id = 14,
    Type = "summon",
    Params = {
      npcid = 807237,
      npcuid = 237,
      groupid = 1,
      pos = {
        2.58,
        10.36,
        52.69
      },
      dir = 180,
      ignoreNavMesh = 1
    }
  },
  [15] = {
    id = 15,
    Type = "wait_time",
    Params = {time = 5000}
  },
  [16] = {
    id = 16,
    Type = "remove_npc",
    Params = {npcuid = 806834}
  },
  [17] = {
    id = 17,
    Type = "remove_npc",
    Params = {npcuid = 806835}
  },
  [18] = {
    id = 18,
    Type = "endfilter",
    Params = {
      fliter = {20}
    }
  },
  [19] = {
    id = 19,
    Type = "remove_npc",
    Params = {npcuid = 237}
  },
  [20] = {
    id = 20,
    Type = "showview",
    Params = {panelid = 800, showtype = 2}
  },
  [21] = {
    id = 21,
    Type = "camera_filter",
    Params = {filterid = 2, on = 0}
  },
  [22] = {
    id = 22,
    Type = "onoff_camerapoint",
    Params = {
      groupid = 0,
      on = false,
      returnDefaultTime = 1500
    }
  },
  [23] = {
    id = 23,
    Type = "reset_camera",
    Params = _EmptyTable
  }
}
Table_PlotQuest_61_fields = {
  "id",
  "Type",
  "Params"
}
return Table_PlotQuest_61
