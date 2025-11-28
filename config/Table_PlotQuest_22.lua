Table_PlotQuest_22 = {
  [1] = {
    id = 1,
    Type = "play_effect_ui",
    Params = {path = "BtoW"}
  },
  [2] = {
    id = 2,
    Type = "startfilter",
    Params = {
      fliter = {37}
    }
  },
  [3] = {
    id = 3,
    Type = "onoff_camerapoint",
    Params = {groupid = 3, on = true}
  },
  [4] = {
    id = 4,
    Type = "change_bgm",
    Params = {
      ath = "DazzlingSnow",
      time = 0
    }
  },
  [5] = {
    id = 5,
    Type = "summon",
    Params = {
      npcid = 803310,
      npcuid = 803310,
      pos = {
        -29.3,
        11.58,
        32.98
      },
      dir = 317
    }
  },
  [6] = {
    id = 6,
    Type = "play_effect_scene",
    Params = {
      id = 1,
      path = "Common/black_hole",
      pos = {
        -37.23,
        9.76,
        42.62
      },
      ignoreNavMesh = 1
    }
  },
  [7] = {
    id = 7,
    Type = "addbutton",
    Params = {
      id = 1,
      text = "##216549",
      eventtype = "goon"
    }
  },
  [8] = {
    id = 8,
    Type = "wait_ui",
    Params = {button = 1}
  },
  [9] = {
    id = 9,
    Type = "move",
    Params = {
      npcuid = 803310,
      pos = {
        -33.13,
        11.58,
        36.84
      },
      dir = 330,
      spd = 1
    }
  },
  [10] = {
    id = 10,
    Type = "playdialog",
    Params = {id = 320656}
  },
  [11] = {
    id = 11,
    Type = "wait_time",
    Params = {time = 3000}
  },
  [12] = {
    id = 12,
    Type = "move",
    Params = {
      npcuid = 803310,
      pos = {
        -35.46,
        11.58,
        40.03
      },
      dir = 330,
      spd = 1
    }
  },
  [13] = {
    id = 13,
    Type = "playdialog",
    Params = {id = 320657}
  },
  [14] = {
    id = 14,
    Type = "wait_time",
    Params = {time = 3000}
  },
  [15] = {
    id = 15,
    Type = "move",
    Params = {
      npcuid = 803310,
      pos = {
        -38.09,
        11.58,
        43.74
      },
      dir = 330,
      spd = 1
    }
  },
  [16] = {
    id = 16,
    Type = "dialog",
    Params = {
      dialog = {320550}
    }
  },
  [17] = {
    id = 17,
    Type = "wait_time",
    Params = {time = 3000}
  },
  [18] = {
    id = 18,
    Type = "onoff_camerapoint",
    Params = {
      groupid = 3,
      on = false,
      returnDefaultTime = 1500
    }
  },
  [19] = {
    id = 19,
    Type = "remove_effect_scene",
    Params = {
      id = 1,
      path = "Common/black_hole",
      pos = {
        -37.23,
        12.76,
        42.62
      },
      ignoreNavMesh = 1
    }
  },
  [20] = {
    id = 20,
    Type = "remove_npc",
    Params = {npcuid = 803310}
  },
  [21] = {
    id = 21,
    Type = "endfilter",
    Params = {
      fliter = {37}
    }
  },
  [22] = {
    id = 22,
    Type = "wait_time",
    Params = {time = 1000}
  }
}
Table_PlotQuest_22_fields = {
  "id",
  "Type",
  "Params"
}
return Table_PlotQuest_22
