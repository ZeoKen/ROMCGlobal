Table_PlotQuest_6 = {
  [1] = {
    id = 1,
    Type = "play_effect_ui",
    Params = {path = "BtoW"}
  },
  [2] = {
    id = 2,
    Type = "wait_time",
    Params = {time = 6000}
  },
  [3] = {
    id = 3,
    Type = "shakescreen",
    Params = {amplitude = 10, time = 3000}
  },
  [4] = {
    id = 4,
    Type = "wait_time",
    Params = {time = 3000}
  },
  [5] = {
    id = 5,
    Type = "onoff_camerapoint",
    Params = {
      groupid = 0,
      on = true,
      returnDefaultTime = 1500
    }
  },
  [6] = {
    id = 6,
    Type = "wait_time",
    Params = {time = 5000}
  },
  [7] = {
    id = 7,
    Type = "onoff_camerapoint",
    Params = {
      groupid = 0,
      on = false,
      returnDefaultTime = 1500
    }
  },
  [8] = {
    id = 8,
    Type = "onoff_camerapoint",
    Params = {
      groupid = 4,
      on = true,
      returnDefaultTime = 1500
    }
  },
  [9] = {
    id = 9,
    Type = "wait_time",
    Params = {time = 2000}
  },
  [10] = {
    id = 10,
    Type = "scene_action",
    Params = {uniqueid = 5757, id = 502}
  },
  [11] = {
    id = 11,
    Type = "play_sound",
    Params = {
      path = "Common/CrystalTower_2_1"
    }
  },
  [12] = {
    id = 12,
    Type = "wait_time",
    Params = {time = 2000}
  },
  [13] = {
    id = 13,
    Type = "wait_time",
    Params = {time = 6000}
  },
  [14] = {
    id = 14,
    Type = "onoff_camerapoint",
    Params = {
      groupid = 4,
      on = false,
      returnDefaultTime = 1500
    }
  },
  [15] = {
    id = 15,
    Type = "onoff_camerapoint",
    Params = {
      groupid = 8,
      on = true,
      returnDefaultTime = 1500
    }
  },
  [16] = {
    id = 16,
    Type = "wait_time",
    Params = {time = 3000}
  },
  [17] = {
    id = 17,
    Type = "onoff_camerapoint",
    Params = {
      groupid = 8,
      on = false,
      returnDefaultTime = 1500
    }
  }
}
Table_PlotQuest_6_fields = {
  "id",
  "Type",
  "Params"
}
return Table_PlotQuest_6
