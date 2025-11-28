Table_PlotQuest_187 = {
  [1] = {
    id = 1,
    Type = "startfilter",
    Params = {
      fliter = {43}
    }
  },
  [2] = {
    id = 2,
    Type = "move",
    Params = {
      player = 1,
      pos = {
        0.1,
        0.13,
        -4.13
      },
      spd = 1,
      dir = 0
    }
  },
  [3] = {
    id = 3,
    Type = "wait_pos",
    Params = {
      player = 1,
      pos = {
        0.1,
        0.13,
        -4.13
      },
      distance = 1
    }
  },
  [4] = {
    id = 4,
    Type = "set_dir",
    Params = {player = 1, dir = 0}
  }
}
Table_PlotQuest_187_fields = {
  "id",
  "Type",
  "Params"
}
return Table_PlotQuest_187
