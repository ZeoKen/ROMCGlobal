Table_PlotQuest_147 = {
  [1] = {
    id = 1,
    Type = "action",
    Params = {
      npcuid = 2,
      id = 827,
      pos = {
        0.0,
        -1.21,
        1.0
      },
      time = 600
    }
  },
  [2] = {
    id = 2,
    Type = "action",
    Params = {
      player = 1,
      id = 837,
      pos = {
        0.0,
        -1.21,
        1.0
      },
      time = 600
    }
  },
  [3] = {
    id = 3,
    Type = "wait_time",
    Params = {time = 1600}
  },
  [4] = {
    id = 4,
    Type = "action",
    Params = {
      npcuid = 2,
      id = 822,
      loop = true
    }
  },
  [5] = {
    id = 5,
    Type = "action",
    Params = {
      player = 1,
      id = 100,
      loop = true
    }
  }
}
Table_PlotQuest_147_fields = {
  "id",
  "Type",
  "Params"
}
return Table_PlotQuest_147
