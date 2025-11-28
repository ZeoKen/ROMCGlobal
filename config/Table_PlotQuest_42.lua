Table_PlotQuest_42 = {
  [1] = {
    id = 1,
    Type = "onoff_camerapoint",
    Params = {groupid = 1, on = true}
  },
  [2] = {
    id = 2,
    Type = "play_effect_ui",
    Params = {path = "BtoW"}
  },
  [3] = {
    id = 3,
    Type = "startfilter",
    Params = {
      fliter = {37}
    }
  },
  [4] = {
    id = 4,
    Type = "showview",
    Params = {panelid = 800, showtype = 1}
  },
  [5] = {
    id = 5,
    Type = "camera_filter",
    Params = {filterid = 2, on = 1}
  },
  [6] = {
    id = 6,
    Type = "wait_time",
    Params = {time = 4000}
  },
  [7] = {
    id = 7,
    Type = "endfilter",
    Params = {
      fliter = {37}
    }
  },
  [8] = {
    id = 8,
    Type = "showview",
    Params = {panelid = 800, showtype = 2}
  },
  [9] = {
    id = 9,
    Type = "onoff_camerapoint",
    Params = {
      groupid = 1,
      on = false,
      returnDefaultTime = 1500
    }
  },
  [10] = {
    id = 10,
    Type = "camera_filter",
    Params = {filterid = 2, on = 0}
  }
}
Table_PlotQuest_42_fields = {
  "id",
  "Type",
  "Params"
}
return Table_PlotQuest_42
