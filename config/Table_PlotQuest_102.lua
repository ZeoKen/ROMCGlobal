Table_PlotQuest_102 = {
  [1] = {
    id = 1,
    Type = "play_effect_ui",
    Params = {path = "BtoW"}
  },
  [2] = {
    id = 2,
    Type = "move",
    Params = {
      player = 1,
      pos = {
        -20.96,
        20.07,
        22.83
      },
      spd = 1,
      dir = 326.5
    }
  },
  [3] = {
    id = 3,
    Type = "wait_time",
    Params = {time = 500}
  },
  [4] = {
    id = 4,
    Type = "wait_pos",
    Params = {
      player = 1,
      pos = {
        -20.96,
        20.07,
        22.83
      },
      distance = 1
    }
  },
  [5] = {
    id = 5,
    Type = "set_dir",
    Params = {player = 1, dir = 326.5}
  }
}
Table_PlotQuest_102_fields = {
  "id",
  "Type",
  "Params"
}
return Table_PlotQuest_102
