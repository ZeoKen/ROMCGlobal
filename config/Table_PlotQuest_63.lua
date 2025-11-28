Table_PlotQuest_63 = {
  [1] = {
    id = 1,
    Type = "onoff_camerapoint",
    Params = {
      groupid = 0,
      on = true,
      returnDefaultTime = 1500
    }
  },
  [2] = {
    id = 2,
    Type = "startfilter",
    Params = {
      fliter = {39}
    }
  },
  [3] = {
    id = 3,
    Type = "showview",
    Params = {panelid = 800, showtype = 1}
  },
  [4] = {
    id = 4,
    Type = "camera_filter",
    Params = {filterid = 2, on = 1}
  },
  [5] = {
    id = 5,
    Type = "wait_time",
    Params = {time = 1500}
  },
  [6] = {
    id = 6,
    Type = "summon",
    Params = {
      npcid = 807250,
      npcuid = 250,
      groupid = 1,
      pos = {
        -0.11,
        2.18,
        14.64
      },
      dir = 180,
      ignoreNavMesh = 1,
      waitaction = "state2002"
    }
  },
  [7] = {
    id = 7,
    Type = "summon",
    Params = {
      npcid = 807241,
      npcuid = 241,
      groupid = 1,
      pos = {
        0.06,
        -4.23,
        24.33
      },
      dir = 180,
      ignoreNavMesh = 1
    }
  },
  [8] = {
    id = 8,
    Type = "play_effect_scene",
    Params = {
      id = 1,
      path = "Skill/Altar_protective",
      pos = {
        -0.36,
        3.44,
        14.66
      },
      ignoreNavMesh = 1
    }
  },
  [9] = {
    id = 9,
    Type = "play_effect_scene",
    Params = {
      id = 15,
      path = "Skill/TeamDefend_atk",
      pos = {
        -0.11,
        2.18,
        14.64
      },
      ignoreNavMesh = 1
    }
  },
  [10] = {
    id = 10,
    Type = "summon",
    Params = {
      npcid = 807275,
      npcuid = 807275,
      groupid = 1,
      pos = {
        0.03,
        0.68,
        9.68
      },
      dir = 180,
      ignoreNavMesh = 1
    }
  },
  [11] = {
    id = 11,
    Type = "wait_time",
    Params = {time = 1000}
  },
  [12] = {
    id = 12,
    Type = "dialog",
    Params = {
      dialog = {
        501404,
        501405,
        501406,
        501407,
        501408,
        501409
      }
    }
  },
  [13] = {
    id = 13,
    Type = "wait_time",
    Params = {time = 1000}
  },
  [14] = {
    id = 14,
    Type = "play_effect_scene",
    Params = {
      id = 14,
      path = "Skill/OutbreakOfTrolley_attack",
      pos = {
        0.03,
        0.68,
        9.68
      },
      ignoreNavMesh = 1
    }
  },
  [15] = {
    id = 15,
    Type = "remove_npc",
    Params = {npcuid = 807275}
  },
  [16] = {
    id = 16,
    Type = "wait_time",
    Params = {time = 500}
  },
  [17] = {
    id = 17,
    Type = "camera_filter",
    Params = {filterid = 2, on = 0}
  },
  [18] = {
    id = 18,
    Type = "play_effect_scene",
    Params = {
      id = 2,
      path = "Skill/PupetMaster_hit",
      pos = {
        -0.36,
        3.44,
        14.66
      },
      ignoreNavMesh = 1
    }
  },
  [19] = {
    id = 19,
    Type = "remove_effect_scene",
    Params = {id = 1}
  },
  [20] = {
    id = 20,
    Type = "move",
    Params = {
      player = 1,
      pos = {
        -0.04,
        0.68,
        4.1
      },
      spd = 1,
      dir = 0
    }
  },
  [21] = {
    id = 21,
    Type = "set_dir",
    Params = {player = 1, dir = 0}
  },
  [22] = {
    id = 22,
    Type = "wait_time",
    Params = {time = 1000}
  },
  [23] = {
    id = 23,
    Type = "play_effect",
    Params = {
      id = 3,
      path = "Skill/SkillRelease",
      npcuid = 250,
      ep = 2,
      ignoreNavMesh = 1
    }
  },
  [24] = {
    id = 24,
    Type = "wait_time",
    Params = {time = 2000}
  },
  [25] = {
    id = 25,
    Type = "remove_effect_scene",
    Params = {id = 2}
  },
  [26] = {
    id = 26,
    Type = "set_dir",
    Params = {player = 1, dir = 0}
  },
  [27] = {
    id = 27,
    Type = "play_effect_scene",
    Params = {
      id = 4,
      path = "Skill/Detoxification_buff",
      pos = {
        -0.04,
        0.68,
        4.1
      }
    }
  },
  [28] = {
    id = 28,
    Type = "wait_time",
    Params = {time = 1000}
  },
  [29] = {
    id = 29,
    Type = "play_effect_scene",
    Params = {
      id = 5,
      path = "Skill/AbsorbingEnergy_body",
      pos = {
        -0.04,
        0.68,
        4.1
      }
    }
  },
  [30] = {
    id = 30,
    Type = "wait_time",
    Params = {time = 1000}
  },
  [31] = {
    id = 31,
    Type = "addbutton",
    Params = {
      id = 1,
      text = "##116877",
      eventtype = "goon"
    }
  },
  [32] = {
    id = 32,
    Type = "action",
    Params = {player = 1, id = 11}
  },
  [33] = {
    id = 33,
    Type = "wait_ui",
    Params = {button = 1}
  },
  [34] = {
    id = 34,
    Type = "play_effect",
    Params = {
      id = 6,
      path = "Skill/AbsorbingEnergy",
      player = 1,
      ep = 2,
      ignoreNavMesh = 1
    }
  },
  [35] = {
    id = 35,
    Type = "wait_time",
    Params = {time = 500}
  },
  [36] = {
    id = 36,
    Type = "onoff_camerapoint",
    Params = {
      groupid = 0,
      on = false,
      returnDefaultTime = 1500
    }
  },
  [37] = {
    id = 37,
    Type = "onoff_camerapoint",
    Params = {
      groupid = 2,
      on = true,
      returnDefaultTime = 1500
    }
  },
  [38] = {
    id = 38,
    Type = "wait_time",
    Params = {time = 500}
  },
  [39] = {
    id = 39,
    Type = "play_effect",
    Params = {
      id = 8,
      path = "Skill/ThunderSpear_hit02",
      npcuid = 241,
      ep = 6,
      ignoreNavMesh = 1
    }
  },
  [40] = {
    id = 40,
    Type = "shakescreen",
    Params = {amplitude = 20, time = 3000}
  },
  [41] = {
    id = 41,
    Type = "wait_time",
    Params = {time = 2000}
  },
  [42] = {
    id = 42,
    Type = "play_effect",
    Params = {
      id = 11,
      path = "Skill/AbsorbingEnergy",
      player = 1,
      ep = 2,
      ignoreNavMesh = 1
    }
  },
  [43] = {
    id = 43,
    Type = "wait_time",
    Params = {time = 1000}
  },
  [44] = {
    id = 44,
    Type = "play_effect",
    Params = {
      id = 10,
      path = "Skill/ThunderSpear_hit02",
      npcuid = 241,
      ep = 6,
      ignoreNavMesh = 1
    }
  },
  [45] = {
    id = 45,
    Type = "wait_time",
    Params = {time = 1000}
  },
  [46] = {
    id = 46,
    Type = "shakescreen",
    Params = {amplitude = 20, time = 3000}
  },
  [47] = {
    id = 47,
    Type = "shakescreen",
    Params = {amplitude = 20, time = 3000}
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
    Type = "remove_effect",
    Params = {id = 6}
  },
  [51] = {
    id = 51,
    Type = "remove_effect",
    Params = {id = 7}
  },
  [52] = {
    id = 52,
    Type = "remove_effect",
    Params = {id = 8}
  },
  [53] = {
    id = 53,
    Type = "remove_effect",
    Params = {id = 9}
  },
  [54] = {
    id = 54,
    Type = "remove_effect",
    Params = {id = 10}
  },
  [55] = {
    id = 55,
    Type = "remove_effect",
    Params = {id = 11}
  },
  [56] = {
    id = 56,
    Type = "remove_effect",
    Params = {id = 12}
  },
  [57] = {
    id = 57,
    Type = "remove_effect",
    Params = {id = 13}
  },
  [58] = {
    id = 58,
    Type = "action",
    Params = {npcuid = 241, id = 7}
  },
  [59] = {
    id = 59,
    Type = "shakescreen",
    Params = {amplitude = 30, time = 3000}
  },
  [60] = {
    id = 60,
    Type = "wait_time",
    Params = {time = 1000}
  },
  [61] = {
    id = 61,
    Type = "remove_npc",
    Params = {npcuid = 241}
  },
  [62] = {
    id = 62,
    Type = "onoff_camerapoint",
    Params = {
      groupid = 2,
      on = false,
      returnDefaultTime = 1500
    }
  },
  [63] = {
    id = 63,
    Type = "onoff_camerapoint",
    Params = {
      groupid = 3,
      on = true,
      returnDefaultTime = 1500
    }
  },
  [64] = {
    id = 64,
    Type = "remove_npc",
    Params = {npcuid = 250}
  },
  [65] = {
    id = 65,
    Type = "endfilter",
    Params = {
      fliter = {39}
    }
  },
  [66] = {
    id = 66,
    Type = "showview",
    Params = {panelid = 800, showtype = 2}
  },
  [67] = {
    id = 67,
    Type = "onoff_camerapoint",
    Params = {
      groupid = 3,
      on = false,
      returnDefaultTime = 1500
    }
  },
  [68] = {
    id = 68,
    Type = "reset_camera",
    Params = _EmptyTable
  }
}
Table_PlotQuest_63_fields = {
  "id",
  "Type",
  "Params"
}
return Table_PlotQuest_63
