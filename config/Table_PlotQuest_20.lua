Table_PlotQuest_20 = {
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
    Params = {time = 2000}
  },
  [4] = {
    id = 4,
    Type = "play_sound",
    Params = {
      path = "Common/JumpFly"
    }
  },
  [5] = {
    id = 5,
    Type = "scene_action",
    Params = {
      name = "line1",
      scene_objname = "AirshipPass(Clone)"
    }
  },
  [6] = {
    id = 6,
    Type = "play_camera_anim",
    Params = {name = "Camera6", time = 11}
  },
  [7] = {
    id = 7,
    Type = "wait_time",
    Params = {time = 10000}
  },
  [8] = {
    id = 8,
    Type = "scene_action",
    Params = {
      name = "wait",
      scene_objname = "AirshipPass(Clone)"
    }
  },
  [9] = {
    id = 9,
    Type = "endfilter",
    Params = {
      fliter = {22}
    }
  }
}
Table_PlotQuest_20_fields = {
  "id",
  "Type",
  "Params"
}
return Table_PlotQuest_20
