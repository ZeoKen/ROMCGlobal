Table_PlotQuest_78 = {
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
    Type = "showview",
    Params = {panelid = 800, showtype = 1}
  },
  [4] = {
    id = 4,
    Type = "summon",
    Params = {
      npcid = 809339,
      npcuid = 809339,
      pos = {
        -3.78,
        1.39,
        6.51
      },
      dir = 138.6,
      ignoreNavMesh = 1,
      waitaction = "pose_S6"
    }
  },
  [5] = {
    id = 5,
    Type = "summon",
    Params = {
      npcid = 809340,
      npcuid = 809340,
      pos = {
        0.0,
        2.49,
        7.32
      },
      dir = 180,
      ignoreNavMesh = 1
    }
  },
  [6] = {
    id = 6,
    Type = "play_camera_anim",
    Params = {name = "Camera1", time = 99999}
  },
  [7] = {
    id = 7,
    Type = "wait_time",
    Params = {time = 12000}
  },
  [8] = {
    id = 8,
    Type = "action",
    Params = {
      npcuid = 809340,
      id = 502,
      loop = true
    }
  },
  [9] = {
    id = 9,
    Type = "wait_time",
    Params = {time = 3000}
  },
  [10] = {
    id = 10,
    Type = "play_effect_ui",
    Params = {path = "BtoW"}
  },
  [11] = {
    id = 11,
    Type = "showview",
    Params = {panelid = 800, showtype = 2}
  },
  [12] = {
    id = 12,
    Type = "endfilter",
    Params = {
      fliter = {38}
    }
  },
  [13] = {
    id = 13,
    Type = "reset_camera",
    Params = _EmptyTable
  }
}
Table_PlotQuest_78_fields = {
  "id",
  "Type",
  "Params"
}
return Table_PlotQuest_78
