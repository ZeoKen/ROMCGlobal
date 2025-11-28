Table_PlotQuest_94 = {
  [1] = {
    id = 1,
    Type = "startfilter",
    Params = {
      fliter = {39}
    }
  },
  [2] = {
    id = 2,
    Type = "summon",
    Params = {
      npcid = 813021,
      npcuid = 813021,
      pos = {
        -0.54,
        26.0,
        1.62
      },
      dir = 180,
      groupid = 1,
      scale = 2
    }
  },
  [3] = {
    id = 3,
    Type = "summon",
    Params = {
      npcid = 813018,
      npcuid = 813018,
      pos = {
        -0.55,
        26.0,
        3.1
      },
      dir = 180,
      groupid = 1
    }
  },
  [4] = {
    id = 4,
    Type = "showview",
    Params = {panelid = 800, showtype = 1}
  },
  [5] = {
    id = 5,
    Type = "onoff_camerapoint",
    Params = {groupid = 0, on = false}
  },
  [6] = {
    id = 6,
    Type = "onoff_camerapoint",
    Params = {groupid = 1, on = true}
  },
  [7] = {
    id = 7,
    Type = "dialog",
    Params = {
      dialog = {502375}
    }
  },
  [8] = {
    id = 8,
    Type = "addbutton",
    Params = {
      id = 1,
      text = "##299450",
      eventtype = "goon"
    }
  },
  [9] = {
    id = 9,
    Type = "wait_ui",
    Params = {button = 1}
  },
  [10] = {
    id = 10,
    Type = "action",
    Params = {id = 603}
  },
  [11] = {
    id = 11,
    Type = "talk",
    Params = {player = 1, talkid = 502376}
  },
  [12] = {
    id = 12,
    Type = "play_sound",
    Params = {
      path = "Skill/FirePrison_attack"
    }
  },
  [13] = {
    id = 13,
    Type = "play_effect",
    Params = {
      id = 1,
      path = "Skill/Flame_Double_atk",
      player = 1,
      onshot = 1,
      ep = 2
    }
  },
  [14] = {
    id = 14,
    Type = "wait_time",
    Params = {time = 1000}
  },
  [15] = {
    id = 15,
    Type = "play_effect",
    Params = {
      id = 2,
      path = "Skill/Flame_Double_hit",
      npcid = 813021,
      onshot = 1
    }
  },
  [16] = {
    id = 16,
    Type = "talk",
    Params = {npcid = 813021, talkid = 502377}
  },
  [17] = {
    id = 17,
    Type = "wait_time",
    Params = {time = 1000}
  },
  [18] = {
    id = 18,
    Type = "play_effect",
    Params = {
      id = 3,
      path = "Common/KahoPlayshow",
      npcid = 813021,
      onshot = 1
    }
  },
  [19] = {
    id = 19,
    Type = "wait_time",
    Params = {time = 1000}
  },
  [20] = {
    id = 20,
    Type = "remove_npc",
    Params = {npcuid = 813021}
  },
  [21] = {
    id = 21,
    Type = "dialog",
    Params = {
      dialog = {502378}
    }
  },
  [22] = {
    id = 22,
    Type = "addbutton",
    Params = {
      id = 2,
      text = "##299451",
      eventtype = "goon"
    }
  },
  [23] = {
    id = 23,
    Type = "wait_ui",
    Params = {button = 2}
  },
  [24] = {
    id = 24,
    Type = "play_sound",
    Params = {
      path = "Common/Task_rainbow"
    }
  },
  [25] = {
    id = 25,
    Type = "play_effect",
    Params = {
      id = 4,
      path = "Skill/Flame_FieryBoxing_floor",
      player = 1,
      onshot = 1
    }
  },
  [26] = {
    id = 26,
    Type = "wait_time",
    Params = {time = 3000}
  },
  [27] = {
    id = 27,
    Type = "dialog",
    Params = {
      dialog = {502379}
    }
  },
  [28] = {
    id = 28,
    Type = "addbutton",
    Params = {
      id = 3,
      text = "##299452",
      eventtype = "goon"
    }
  },
  [29] = {
    id = 29,
    Type = "wait_ui",
    Params = {button = 3}
  },
  [30] = {
    id = 30,
    Type = "showview",
    Params = {panelid = 800, showtype = 2}
  },
  [31] = {
    id = 31,
    Type = "endfilter",
    Params = {
      fliter = {39}
    }
  },
  [32] = {
    id = 32,
    Type = "onoff_camerapoint",
    Params = {
      groupid = 1,
      on = false,
      returnDefaultTime = 1500
    }
  }
}
Table_PlotQuest_94_fields = {
  "id",
  "Type",
  "Params"
}
return Table_PlotQuest_94
