Table_PlotQuest_58 = {
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
    Params = {time = 4000}
  },
  [4] = {
    id = 4,
    Type = "play_camera_anim",
    Params = {name = "Camera2", time = 6}
  },
  [5] = {
    id = 5,
    Type = "wait_time",
    Params = {time = 2000}
  },
  [6] = {
    id = 6,
    Type = "play_sound",
    Params = {
      path = "Common/Ghost_warning"
    }
  },
  [7] = {
    id = 7,
    Type = "wait_time",
    Params = {time = 500}
  },
  [8] = {
    id = 8,
    Type = "play_sound",
    Params = {
      path = "Common/HailaAltal_4001"
    }
  },
  [9] = {
    id = 9,
    Type = "wait_time",
    Params = {time = 3000}
  },
  [10] = {
    id = 10,
    Type = "play_sound",
    Params = {
      path = "Common/Cardroom_Resetcards"
    }
  },
  [11] = {
    id = 11,
    Type = "wait_time",
    Params = {time = 500}
  },
  [12] = {
    id = 12,
    Type = "endfilter",
    Params = {
      fliter = {22}
    }
  }
}
Table_PlotQuest_58_fields = {
  "id",
  "Type",
  "Params"
}
return Table_PlotQuest_58
