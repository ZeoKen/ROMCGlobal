Table_PlotQuest_82 = {
  [1] = {
    id = 1,
    Type = "onoff_camerapoint",
    Params = {groupid = 3, on = true}
  },
  [2] = {
    id = 2,
    Type = "showview",
    Params = {panelid = 800, showtype = 1}
  },
  [3] = {
    id = 3,
    Type = "startfilter",
    Params = {
      fliter = {20}
    }
  },
  [4] = {
    id = 4,
    Type = "wait_time",
    Params = {time = 1500}
  },
  [5] = {
    id = 5,
    Type = "set_dir",
    Params = {player = 1, dir = 130}
  },
  [6] = {
    id = 6,
    Type = "wait_time",
    Params = {time = 1000}
  },
  [7] = {
    id = 7,
    Type = "action",
    Params = {player = 1, id = 9}
  },
  [8] = {
    id = 8,
    Type = "wait_time",
    Params = {time = 4000}
  },
  [9] = {
    id = 9,
    Type = "showview",
    Params = {panelid = 800, showtype = 2}
  },
  [10] = {
    id = 10,
    Type = "endfilter",
    Params = {
      fliter = {20}
    }
  },
  [11] = {
    id = 11,
    Type = "onoff_camerapoint",
    Params = {
      groupid = 3,
      on = false,
      returnDefaultTime = 1500
    }
  }
}
Table_PlotQuest_82_fields = {
  "id",
  "Type",
  "Params"
}
return Table_PlotQuest_82
