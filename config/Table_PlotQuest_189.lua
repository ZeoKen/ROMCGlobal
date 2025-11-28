Table_PlotQuest_189 = {
  [1] = {
    id = 1,
    Type = "showview",
    Params = {panelid = 800, showtype = 1}
  },
  [2] = {
    id = 2,
    Type = "startfilter",
    Params = {
      fliter = {47}
    }
  },
  [3] = {
    id = 3,
    Type = "move",
    Params = {
      player = 1,
      pos = {
        -0.32,
        0.0,
        -0.01
      },
      spd = 1,
      dir = 161.4
    }
  },
  [4] = {
    id = 4,
    Type = "wait_pos",
    Params = {
      player = 1,
      pos = {
        -0.32,
        0.0,
        -0.01
      },
      distance = 1
    }
  },
  [5] = {
    id = 5,
    Type = "set_dir",
    Params = {player = 1, dir = 161.4}
  },
  [6] = {
    id = 6,
    Type = "action",
    Params = {
      player = 1,
      id = 311,
      loop = true
    }
  },
  [7] = {
    id = 7,
    Type = "showview",
    Params = {panelid = 800, showtype = 2}
  }
}
Table_PlotQuest_189_fields = {
  "id",
  "Type",
  "Params"
}
return Table_PlotQuest_189
