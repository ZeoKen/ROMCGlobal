Table_PlotQuest_86 = {
  [1] = {
    id = 1,
    Type = "move",
    Params = {
      player = 1,
      pos = {
        -1.46,
        0.07,
        47.04
      },
      spd = 1,
      dir = 0
    }
  },
  [2] = {
    id = 2,
    Type = "wait_pos",
    Params = {
      player = 1,
      pos = {
        -1.46,
        0.07,
        47.04
      },
      distance = 1
    }
  },
  [3] = {
    id = 3,
    Type = "set_dir",
    Params = {player = 1, dir = 0}
  },
  [4] = {
    id = 4,
    Type = "wait_time",
    Params = {time = 2000}
  }
}
Table_PlotQuest_86_fields = {
  "id",
  "Type",
  "Params"
}
return Table_PlotQuest_86
