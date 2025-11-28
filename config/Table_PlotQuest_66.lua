Table_PlotQuest_66 = {
  [1] = {
    id = 1,
    Type = "onoff_camerapoint",
    Params = {
      groupid = 2,
      on = true,
      returnDefaultTime = 1500
    }
  },
  [2] = {
    id = 2,
    Type = "startfilter",
    Params = {
      fliter = {39}
    }
  },
  [3] = {
    id = 3,
    Type = "showview",
    Params = {panelid = 800, showtype = 1}
  },
  [4] = {
    id = 4,
    Type = "camera_filter",
    Params = {filterid = 0, on = 1}
  },
  [5] = {
    id = 5,
    Type = "summon",
    Params = {
      npcid = 807253,
      npcuid = 253,
      groupid = 1,
      pos = {
        0.06,
        -4.23,
        24.33
      },
      dir = 180,
      ignoreNavMesh = 1
    }
  },
  [6] = {
    id = 6,
    Type = "wait_time",
    Params = {time = 2000}
  },
  [7] = {
    id = 7,
    Type = "action",
    Params = {npcuid = 253, id = 502}
  },
  [8] = {
    id = 8,
    Type = "shakescreen",
    Params = {amplitude = 30, time = 4000}
  },
  [9] = {
    id = 9,
    Type = "wait_time",
    Params = {time = 1800}
  },
  [10] = {
    id = 10,
    Type = "remove_npc",
    Params = {npcuid = 253}
  },
  [11] = {
    id = 11,
    Type = "summon",
    Params = {
      npcid = 807253,
      npcuid = 2531,
      groupid = 1,
      pos = {
        0.06,
        -4.23,
        24.33
      },
      dir = 180,
      ignoreNavMesh = 1,
      waitaction = "state2002"
    }
  },
  [12] = {
    id = 12,
    Type = "wait_time",
    Params = {time = 2000}
  },
  [13] = {
    id = 13,
    Type = "endfilter",
    Params = {
      fliter = {39}
    }
  },
  [14] = {
    id = 14,
    Type = "remove_npc",
    Params = {npcuid = 2531}
  },
  [15] = {
    id = 15,
    Type = "showview",
    Params = {panelid = 800, showtype = 2}
  },
  [16] = {
    id = 16,
    Type = "onoff_camerapoint",
    Params = {
      groupid = 2,
      on = false,
      returnDefaultTime = 1500
    }
  },
  [17] = {
    id = 17,
    Type = "camera_filter",
    Params = {filterid = 1, on = 0}
  },
  [18] = {
    id = 18,
    Type = "reset_camera",
    Params = _EmptyTable
  }
}
Table_PlotQuest_66_fields = {
  "id",
  "Type",
  "Params"
}
return Table_PlotQuest_66
