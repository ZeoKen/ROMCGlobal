Table_PlotQuest_185 = {
  [1] = {
    id = 1,
    Type = "move",
    Params = {
      player = 1,
      pos = {
        -22.42,
        20.4,
        24.53
      },
      spd = 1,
      dir = 359
    }
  },
  [2] = {
    id = 2,
    Type = "wait_time",
    Params = {time = 500}
  },
  [3] = {
    id = 3,
    Type = "wait_pos",
    Params = {
      player = 1,
      pos = {
        -22.42,
        20.4,
        24.53
      },
      distance = 1
    }
  },
  [4] = {
    id = 4,
    Type = "set_dir",
    Params = {player = 1, dir = 359}
  }
}
Table_PlotQuest_185_fields = {
  "id",
  "Type",
  "Params"
}
return Table_PlotQuest_185
