Table_PlotQuest_62 = {
  [1] = {
    id = 1,
    Type = "play_effect_ui",
    Params = {path = "BtoW"}
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
    Type = "play_camera_anim",
    Params = {name = "Camera1", time = 6}
  },
  [5] = {
    id = 5,
    Type = "summon",
    Params = {
      npcid = 807240,
      npcuid = 240,
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
    Params = {time = 2500}
  },
  [7] = {
    id = 7,
    Type = "action",
    Params = {npcuid = 240, id = 500}
  },
  [8] = {
    id = 8,
    Type = "wait_time",
    Params = {time = 4000}
  },
  [9] = {
    id = 9,
    Type = "endfilter",
    Params = {
      fliter = {39}
    }
  },
  [10] = {
    id = 10,
    Type = "showview",
    Params = {panelid = 800, showtype = 2}
  },
  [11] = {
    id = 11,
    Type = "camera_filter",
    Params = {filterid = 2, on = 0}
  },
  [12] = {
    id = 12,
    Type = "reset_camera",
    Params = _EmptyTable
  },
  [13] = {
    id = 13,
    Type = "remove_npc",
    Params = {npcuid = 240}
  }
}
Table_PlotQuest_62_fields = {
  "id",
  "Type",
  "Params"
}
return Table_PlotQuest_62
