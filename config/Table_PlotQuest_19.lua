Table_PlotQuest_19 = {
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
    Type = "play_camera_anim",
    Params = {name = "Camera5", time = 5}
  },
  [6] = {
    id = 6,
    Type = "wait_time",
    Params = {time = 5000}
  },
  [7] = {
    id = 7,
    Type = "play_sound",
    Params = {
      path = "Common/JumpFly"
    }
  },
  [8] = {
    id = 8,
    Type = "scene_action",
    Params = {
      name = "line1",
      scene_objname = "AirshipPass(Clone)"
    }
  },
  [9] = {
    id = 9,
    Type = "play_camera_anim",
    Params = {name = "Camera6", time = 11}
  },
  [10] = {
    id = 10,
    Type = "wait_time",
    Params = {time = 11000}
  },
  [11] = {
    id = 11,
    Type = "scene_action",
    Params = {
      name = "wait",
      scene_objname = "AirshipPass(Clone)"
    }
  },
  [12] = {
    id = 12,
    Type = "endfilter",
    Params = {
      fliter = {22}
    }
  }
}
Table_PlotQuest_19_fields = {
  "id",
  "Type",
  "Params"
}
return Table_PlotQuest_19
