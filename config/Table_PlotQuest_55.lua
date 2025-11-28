Table_PlotQuest_55 = {
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
    Type = "play_camera_anim",
    Params = {name = "Camera1", time = 19}
  },
  [5] = {
    id = 5,
    Type = "play_sound",
    Params = {
      path = "Common/GreenGleeman_start"
    }
  },
  [6] = {
    id = 6,
    Type = "wait_time",
    Params = {time = 11500}
  },
  [7] = {
    id = 7,
    Type = "play_sound",
    Params = {
      path = "Common/Ghost_warning"
    }
  },
  [8] = {
    id = 8,
    Type = "wait_time",
    Params = {time = 1000}
  },
  [9] = {
    id = 9,
    Type = "play_sound",
    Params = {
      path = "Common/HailaAltal_4001"
    }
  },
  [10] = {
    id = 10,
    Type = "wait_time",
    Params = {time = 4000}
  },
  [11] = {
    id = 11,
    Type = "play_sound",
    Params = {
      path = "Common/Cardroom_Resetcards"
    }
  },
  [12] = {
    id = 12,
    Type = "wait_time",
    Params = {time = 1500}
  },
  [13] = {
    id = 13,
    Type = "endfilter",
    Params = {
      fliter = {22}
    }
  }
}
Table_PlotQuest_55_fields = {
  "id",
  "Type",
  "Params"
}
return Table_PlotQuest_55
