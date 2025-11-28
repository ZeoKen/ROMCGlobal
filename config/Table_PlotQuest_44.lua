Table_PlotQuest_44 = {
  [1] = {
    id = 1,
    Type = "onoff_camerapoint",
    Params = {groupid = 1, on = false}
  },
  [2] = {
    id = 2,
    Type = "onoff_camerapoint",
    Params = {groupid = 0, on = true}
  },
  [3] = {
    id = 3,
    Type = "play_effect_ui",
    Params = {path = "BtoW"}
  },
  [4] = {
    id = 4,
    Type = "startfilter",
    Params = {
      fliter = {38}
    }
  },
  [5] = {
    id = 5,
    Type = "showview",
    Params = {panelid = 800, showtype = 1}
  },
  [6] = {
    id = 6,
    Type = "camera_filter",
    Params = {filterid = 2, on = 1}
  },
  [7] = {
    id = 7,
    Type = "wait_time",
    Params = {time = 1500}
  },
  [8] = {
    id = 8,
    Type = "summon",
    Params = {
      npcid = 806523,
      npcuid = 523,
      groupid = 1,
      pos = {
        3.33,
        0.06,
        15.87
      },
      dir = 37,
      scale = 1.2
    }
  },
  [9] = {
    id = 9,
    Type = "summon",
    Params = {
      npcid = 806351,
      npcuid = 351,
      groupid = 1,
      pos = {
        8.89,
        0.24,
        20.65
      },
      dir = 180
    }
  },
  [10] = {
    id = 10,
    Type = "summon",
    Params = {
      npcid = 806350,
      npcuid = 350,
      groupid = 1,
      pos = {
        7.83,
        0.03,
        21.37
      },
      dir = 178
    }
  },
  [11] = {
    id = 11,
    Type = "summon",
    Params = {
      npcid = 806349,
      npcuid = 349,
      groupid = 1,
      pos = {
        6.41,
        0.03,
        21.3
      },
      dir = 178,
      scale = 2
    }
  },
  [12] = {
    id = 12,
    Type = "wait_time",
    Params = {time = 2000}
  },
  [13] = {
    id = 13,
    Type = "remove_npc",
    Params = {npcuid = 523}
  },
  [14] = {
    id = 14,
    Type = "summon",
    Params = {
      npcid = 806523,
      npcuid = 5231,
      groupid = 1,
      pos = {
        3.33,
        0.06,
        15.87
      },
      dir = 37,
      waitaction = "functional_action",
      scale = 1.2
    }
  },
  [15] = {
    id = 15,
    Type = "wait_time",
    Params = {time = 1000}
  },
  [16] = {
    id = 16,
    Type = "remove_npc",
    Params = {npcuid = 349}
  },
  [17] = {
    id = 17,
    Type = "summon",
    Params = {
      npcid = 806349,
      npcuid = 3491,
      groupid = 1,
      pos = {
        6.41,
        0.03,
        21.3
      },
      dir = 178,
      waitaction = "reading",
      scale = 2
    }
  },
  [18] = {
    id = 18,
    Type = "wait_time",
    Params = {time = 100}
  },
  [19] = {
    id = 19,
    Type = "play_sound",
    Params = {
      path = "Common/Task_collision"
    }
  },
  [20] = {
    id = 20,
    Type = "summon",
    Params = {
      npcid = 806443,
      npcuid = 443,
      groupid = 1,
      pos = {
        4.21,
        0.78,
        17.8
      },
      dir = 190
    }
  },
  [21] = {
    id = 21,
    Type = "wait_time",
    Params = {time = 3000}
  },
  [22] = {
    id = 22,
    Type = "dialog",
    Params = {
      dialog = {500298},
      npcuid = 350
    }
  },
  [23] = {
    id = 23,
    Type = "wait_time",
    Params = {time = 1000}
  },
  [24] = {
    id = 24,
    Type = "action",
    Params = {npcuid = 350, id = 23}
  },
  [25] = {
    id = 25,
    Type = "wait_time",
    Params = {time = 2000}
  },
  [26] = {
    id = 26,
    Type = "remove_npc",
    Params = {npcuid = 5231}
  },
  [27] = {
    id = 27,
    Type = "summon",
    Params = {
      npcid = 806523,
      npcuid = 5232,
      groupid = 1,
      pos = {
        3.33,
        0.06,
        15.87
      },
      dir = 37,
      scale = 1.2
    }
  },
  [28] = {
    id = 28,
    Type = "remove_npc",
    Params = {npcuid = 3491}
  },
  [29] = {
    id = 29,
    Type = "summon",
    Params = {
      npcid = 806349,
      npcuid = 349,
      groupid = 1,
      pos = {
        6.41,
        0.03,
        21.3
      },
      dir = 178,
      scale = 2
    }
  },
  [30] = {
    id = 30,
    Type = "play_sound",
    Params = {
      path = "Skill/LordOfVermilion"
    }
  },
  [31] = {
    id = 31,
    Type = "play_effect_scene",
    Params = {
      id = 2,
      path = "Skill/LordOfVermilion",
      pos = {
        3.33,
        0.06,
        15.87
      },
      onshot = 1,
      ignoreNavMesh = 1
    }
  },
  [32] = {
    id = 32,
    Type = "action",
    Params = {npcuid = 5232, id = 5}
  },
  [33] = {
    id = 33,
    Type = "wait_time",
    Params = {time = 1000}
  },
  [34] = {
    id = 34,
    Type = "play_sound",
    Params = {
      path = "Skill/LordOfVermilion"
    }
  },
  [35] = {
    id = 35,
    Type = "play_effect_scene",
    Params = {
      id = 5,
      path = "Skill/LordOfVermilion",
      pos = {
        3.33,
        0.06,
        15.87
      },
      onshot = 1,
      ignoreNavMesh = 1
    }
  },
  [36] = {
    id = 36,
    Type = "action",
    Params = {npcuid = 5232, id = 5}
  },
  [37] = {
    id = 37,
    Type = "wait_time",
    Params = {time = 1000}
  },
  [38] = {
    id = 38,
    Type = "play_sound",
    Params = {
      path = "Skill/LordOfVermilion"
    }
  },
  [39] = {
    id = 39,
    Type = "play_effect_scene",
    Params = {
      id = 4,
      path = "Skill/LordOfVermilion",
      pos = {
        3.33,
        0.06,
        15.87
      },
      onshot = 1,
      ignoreNavMesh = 1
    }
  },
  [40] = {
    id = 40,
    Type = "action",
    Params = {npcuid = 5232, id = 5}
  },
  [41] = {
    id = 41,
    Type = "remove_npc",
    Params = {npcuid = 443}
  },
  [42] = {
    id = 42,
    Type = "wait_time",
    Params = {time = 1000}
  },
  [43] = {
    id = 43,
    Type = "play_sound",
    Params = {
      path = "Skill/Roundabout_hit"
    }
  },
  [44] = {
    id = 44,
    Type = "play_effect_scene",
    Params = {
      id = 3,
      path = "Skill/Roundabout_hit",
      pos = {
        3.33,
        0.06,
        15.87
      },
      onshot = 1,
      ignoreNavMesh = 1
    }
  },
  [45] = {
    id = 45,
    Type = "wait_time",
    Params = {time = 2000}
  },
  [46] = {
    id = 46,
    Type = "remove_effect_scene",
    Params = {id = 2}
  },
  [47] = {
    id = 47,
    Type = "remove_effect_scene",
    Params = {id = 3}
  },
  [48] = {
    id = 48,
    Type = "remove_effect_scene",
    Params = {id = 4}
  },
  [49] = {
    id = 49,
    Type = "remove_effect_scene",
    Params = {id = 5}
  },
  [50] = {
    id = 50,
    Type = "remove_npc",
    Params = {npcuid = 5232}
  },
  [51] = {
    id = 51,
    Type = "remove_npc",
    Params = {npcuid = 3492}
  },
  [52] = {
    id = 52,
    Type = "remove_npc",
    Params = {npcuid = 350}
  },
  [53] = {
    id = 53,
    Type = "remove_npc",
    Params = {npcuid = 351}
  },
  [54] = {
    id = 54,
    Type = "endfilter",
    Params = {
      fliter = {38}
    }
  },
  [55] = {
    id = 55,
    Type = "showview",
    Params = {panelid = 800, showtype = 2}
  },
  [56] = {
    id = 56,
    Type = "onoff_camerapoint",
    Params = {
      groupid = 0,
      on = false,
      returnDefaultTime = 1500
    }
  },
  [57] = {
    id = 57,
    Type = "onoff_camerapoint",
    Params = {
      groupid = 1,
      on = true,
      returnDefaultTime = 1500
    }
  },
  [58] = {
    id = 58,
    Type = "camera_filter",
    Params = {filterid = 2, on = 0}
  }
}
Table_PlotQuest_44_fields = {
  "id",
  "Type",
  "Params"
}
return Table_PlotQuest_44
