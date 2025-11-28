Table_PlotQuest_25 = {
  [1] = {
    id = 1,
    Type = "play_effect_ui",
    Params = {path = "BtoW"}
  },
  [2] = {
    id = 2,
    Type = "startfilter",
    Params = {
      fliter = {22}
    }
  },
  [3] = {
    id = 3,
    Type = "wait_time",
    Params = {time = 500}
  },
  [4] = {
    id = 4,
    Type = "play_camera_anim",
    Params = {name = "Camera7", time = 10}
  },
  [5] = {
    id = 5,
    Type = "wait_time",
    Params = {time = 4000}
  },
  [6] = {
    id = 6,
    Type = "play_sound",
    Params = {
      path = "Skill/EarthDrive_attack"
    }
  },
  [7] = {
    id = 7,
    Type = "play_effect_scene",
    Params = {
      id = 1,
      path = "Skill/EarthDrive_attack",
      pos = {
        -99.1,
        4.0,
        -8.15
      },
      onshot = 1,
      ignoreNavMesh = 1
    }
  },
  [8] = {
    id = 8,
    Type = "scene_action",
    Params = {uniqueid = 802199, id = 504}
  },
  [9] = {
    id = 9,
    Type = "wait_time",
    Params = {time = 3000}
  },
  [10] = {
    id = 10,
    Type = "reset_camera",
    Params = _EmptyTable
  },
  [11] = {
    id = 11,
    Type = "wait_time",
    Params = {time = 5000}
  },
  [12] = {
    id = 12,
    Type = "endfilter",
    Params = {
      fliter = {22}
    }
  }
}
Table_PlotQuest_25_fields = {
  "id",
  "Type",
  "Params"
}
return Table_PlotQuest_25
