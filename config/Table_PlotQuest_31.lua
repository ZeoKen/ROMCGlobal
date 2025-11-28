Table_PlotQuest_31 = {
  [1] = {
    id = 1,
    Type = "play_effect_ui",
    Params = {path = "BtoW"}
  },
  [2] = {
    id = 2,
    Type = "showview",
    Params = {panelid = 800, showtype = 1}
  },
  [3] = {
    id = 3,
    Type = "onoff_camerapoint",
    Params = {groupid = 0, on = true}
  },
  [4] = {
    id = 4,
    Type = "wait_time",
    Params = {time = 3000}
  },
  [5] = {
    id = 5,
    Type = "summon",
    Params = {
      npcid = 802233,
      npcuid = 802233,
      pos = {
        -2.37,
        6.49,
        17.98
      },
      dir = 2.8
    }
  },
  [6] = {
    id = 6,
    Type = "wait_time",
    Params = {time = 3000}
  },
  [7] = {
    id = 7,
    Type = "play_effect_scene",
    Params = {
      id = 1,
      path = "Skill/Teleport",
      pos = {
        -2.38,
        6.76,
        17.89
      },
      onshot = 1
    }
  },
  [8] = {
    id = 8,
    Type = "play_sound",
    Params = {
      path = "Common/Teleport"
    }
  },
  [9] = {
    id = 9,
    Type = "remove_npc",
    Params = {npcuid = 802233}
  },
  [10] = {
    id = 10,
    Type = "wait_time",
    Params = {time = 3000}
  },
  [11] = {
    id = 11,
    Type = "showview",
    Params = {panelid = 800, showtype = 2}
  },
  [12] = {
    id = 12,
    Type = "onoff_camerapoint",
    Params = {
      groupid = 0,
      on = false,
      returnDefaultTime = 1500
    }
  }
}
Table_PlotQuest_31_fields = {
  "id",
  "Type",
  "Params"
}
return Table_PlotQuest_31
