Table_PlotQuest_90 = {
  [1] = {
    id = 1,
    Type = "play_effect_ui",
    Params = {path = "BtoW"}
  },
  [2] = {
    id = 2,
    Type = "startfilter",
    Params = {
      fliter = {38}
    }
  },
  [3] = {
    id = 3,
    Type = "showview",
    Params = {panelid = 800, showtype = 1}
  },
  [4] = {
    id = 4,
    Type = "change_bgm",
    Params = {path = "SoulGarden", time = 0}
  },
  [5] = {
    id = 5,
    Type = "summon",
    Params = {
      npcid = 801850,
      npcuid = 801850,
      pos = {
        -0.06,
        3.04,
        34.26
      },
      dir = 180
    }
  },
  [6] = {
    id = 6,
    Type = "wait_time",
    Params = {time = 1500}
  },
  [7] = {
    id = 7,
    Type = "play_camera_anim",
    Params = {name = "Camera4"}
  },
  [8] = {
    id = 8,
    Type = "wait_time",
    Params = {time = 1000}
  },
  [9] = {
    id = 9,
    Type = "action",
    Params = {npcuid = 801850, id = 9}
  },
  [10] = {
    id = 10,
    Type = "wait_time",
    Params = {time = 1200}
  },
  [11] = {
    id = 11,
    Type = "dialog",
    Params = {
      dialog = {
        410300,
        410301,
        410302
      }
    }
  },
  [12] = {
    id = 12,
    Type = "action",
    Params = {npcuid = 801850, id = 201}
  },
  [13] = {
    id = 13,
    Type = "wait_time",
    Params = {time = 1500}
  },
  [14] = {
    id = 14,
    Type = "action",
    Params = {npcuid = 801850, id = 11}
  },
  [15] = {
    id = 15,
    Type = "play_sound",
    Params = {
      path = "Skill/Sanctuary"
    }
  },
  [16] = {
    id = 16,
    Type = "play_effect",
    Params = {
      path = "Skill/Pray_attack",
      npcuid = 801850
    }
  },
  [17] = {
    id = 17,
    Type = "wait_time",
    Params = {time = 1000}
  },
  [18] = {
    id = 18,
    Type = "play_camera_anim",
    Params = {name = "Camera5", time = 2}
  },
  [19] = {
    id = 19,
    Type = "wait_time",
    Params = {time = 1200}
  },
  [20] = {
    id = 20,
    Type = "play_camera_anim",
    Params = {name = "Camera6"}
  },
  [21] = {
    id = 21,
    Type = "dialog",
    Params = {
      dialog = {410303, 410304}
    }
  },
  [22] = {
    id = 22,
    Type = "fullScreenEffect",
    Params = {
      on = true,
      path = "UI/Eff_Blink_ui"
    }
  },
  [23] = {
    id = 23,
    Type = "wait_time",
    Params = {time = 4000}
  },
  [24] = {
    id = 24,
    Type = "move",
    Params = {
      npcuid = 801850,
      pos = {
        -0.2,
        2.97,
        39.48
      },
      spd = 0.5
    }
  },
  [25] = {
    id = 25,
    Type = "wait_time",
    Params = {time = 3000}
  },
  [26] = {
    id = 26,
    Type = "play_effect_ui",
    Params = {path = "BtoW"}
  },
  [27] = {
    id = 27,
    Type = "fullScreenEffect",
    Params = {
      on = false,
      path = "UI/Eff_Blink_ui"
    }
  },
  [28] = {
    id = 28,
    Type = "showview",
    Params = {panelid = 800, showtype = 2}
  },
  [29] = {
    id = 29,
    Type = "endfilter",
    Params = {
      fliter = {38}
    }
  }
}
Table_PlotQuest_90_fields = {
  "id",
  "Type",
  "Params"
}
return Table_PlotQuest_90
