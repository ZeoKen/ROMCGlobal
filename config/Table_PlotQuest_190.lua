Table_PlotQuest_190 = {
  [1] = {
    id = 1,
    Type = "showview",
    Params = {panelid = 800, showtype = 1}
  },
  [2] = {
    id = 2,
    Type = "move",
    Params = {
      player = 1,
      pos = {
        0.0,
        0.13,
        -0.99
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
        0.0,
        0.13,
        -0.99
      },
      distance = 1
    }
  },
  [4] = {
    id = 4,
    Type = "set_dir",
    Params = {player = 1, dir = 0}
  },
  [5] = {
    id = 5,
    Type = "showview",
    Params = {panelid = 800, showtype = 2}
  }
}
Table_PlotQuest_190_fields = {
  "id",
  "Type",
  "Params"
}
return Table_PlotQuest_190
