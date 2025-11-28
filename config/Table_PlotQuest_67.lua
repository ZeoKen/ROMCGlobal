Table_PlotQuest_67 = {
  [1] = {
    id = 1,
    Type = "play_effect_ui",
    Params = {path = "BtoW"}
  },
  [2] = {
    id = 2,
    Type = "wait_time",
    Params = {time = 1000}
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
    Type = "wait_time",
    Params = {time = 1000}
  },
  [6] = {
    id = 6,
    Type = "play_effect_scene",
    Params = {
      id = 1,
      path = "Common/Magatama_playshow_F",
      pos = {
        0.0,
        0.0,
        0.0
      },
      onshot = 1
    }
  },
  [7] = {
    id = 7,
    Type = "wait_time",
    Params = {time = 7000}
  },
  [8] = {
    id = 8,
    Type = "addbutton",
    Params = {
      id = 1,
      text = "##298177",
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
    Type = "onoff_camerapoint",
    Params = {groupid = 0, on = true}
  },
  [11] = {
    id = 11,
    Type = "play_effect_scene",
    Params = {
      id = 11,
      path = "Common/Magatama_playshow_F",
      pos = {
        -3.93,
        0.83,
        0.03
      },
      onshot = 1
    }
  },
  [12] = {
    id = 12,
    Type = "wait_time",
    Params = {time = 7000}
  },
  [13] = {
    id = 13,
    Type = "summon",
    Params = {
      npcid = 807761,
      npcuid = 807761,
      pos = {
        -3.93,
        1.33,
        0.03
      },
      dir = 90,
      ignoreNavMesh = 1
    }
  },
  [14] = {
    id = 14,
    Type = "play_effect_scene",
    Params = {
      id = 5,
      path = "Common/PhotonForce_Mix",
      pos = {
        -3.93,
        1.83,
        0.03
      },
      ignoreNavMesh = 1
    }
  },
  [15] = {
    id = 15,
    Type = "play_effect_scene",
    Params = {
      id = 6,
      path = "Skill/Task_magic2_blk",
      pos = {
        -3.93,
        1.83,
        0.03
      },
      ignoreNavMesh = 1
    }
  },
  [16] = {
    id = 16,
    Type = "play_effect_scene",
    Params = {
      id = 21,
      path = "Skill/eff_921_playshow",
      pos = {
        -3.93,
        1.16,
        0.03
      },
      onshot = 1,
      ignoreNavMesh = 1,
      dir = {
        0.0,
        90.0,
        0.0
      }
    }
  },
  [17] = {
    id = 17,
    Type = "wait_time",
    Params = {time = 8000}
  },
  [18] = {
    id = 18,
    Type = "dialog",
    Params = {
      dialog = {751060}
    }
  },
  [19] = {
    id = 19,
    Type = "addbutton",
    Params = {
      id = 2,
      text = "##104798",
      eventtype = "goon"
    }
  },
  [20] = {
    id = 20,
    Type = "wait_ui",
    Params = {button = 2}
  },
  [21] = {
    id = 21,
    Type = "onoff_camerapoint",
    Params = {groupid = 0, on = false}
  },
  [22] = {
    id = 22,
    Type = "remove_npc",
    Params = {npcuid = 807761}
  },
  [23] = {
    id = 23,
    Type = "remove_effect_scene",
    Params = {id = 5}
  },
  [24] = {
    id = 24,
    Type = "remove_effect_scene",
    Params = {id = 6}
  },
  [25] = {
    id = 25,
    Type = "onoff_camerapoint",
    Params = {groupid = 1, on = true}
  },
  [26] = {
    id = 26,
    Type = "play_effect_scene",
    Params = {
      id = 12,
      path = "Common/Magatama_playshow_F",
      pos = {
        0.01,
        0.83,
        4.06
      },
      onshot = 1
    }
  },
  [27] = {
    id = 27,
    Type = "wait_time",
    Params = {time = 7000}
  },
  [28] = {
    id = 28,
    Type = "summon",
    Params = {
      npcid = 807760,
      npcuid = 807760,
      pos = {
        0.01,
        1.33,
        4.06
      },
      dir = 180,
      ignoreNavMesh = 1
    }
  },
  [29] = {
    id = 29,
    Type = "play_effect_scene",
    Params = {
      id = 3,
      path = "Common/PhotonForce_Mix",
      pos = {
        0.01,
        1.83,
        4.06
      },
      ignoreNavMesh = 1
    }
  },
  [30] = {
    id = 30,
    Type = "play_effect_scene",
    Params = {
      id = 4,
      path = "Skill/Task_magic2_blk",
      pos = {
        0.01,
        1.83,
        4.06
      },
      ignoreNavMesh = 1
    }
  },
  [31] = {
    id = 31,
    Type = "play_effect_scene",
    Params = {
      id = 22,
      path = "Skill/eff_921_playshow",
      pos = {
        0.01,
        1.16,
        4.06
      },
      onshot = 1,
      ignoreNavMesh = 1,
      dir = {
        0.0,
        180.0,
        0.0
      }
    }
  },
  [32] = {
    id = 32,
    Type = "wait_time",
    Params = {time = 8000}
  },
  [33] = {
    id = 33,
    Type = "dialog",
    Params = {
      dialog = {751061}
    }
  },
  [34] = {
    id = 34,
    Type = "addbutton",
    Params = {
      id = 3,
      text = "##298176",
      eventtype = "goon"
    }
  },
  [35] = {
    id = 35,
    Type = "wait_ui",
    Params = {button = 3}
  },
  [36] = {
    id = 36,
    Type = "onoff_camerapoint",
    Params = {groupid = 1, on = false}
  },
  [37] = {
    id = 37,
    Type = "remove_effect_scene",
    Params = {id = 3}
  },
  [38] = {
    id = 38,
    Type = "remove_effect_scene",
    Params = {id = 4}
  },
  [39] = {
    id = 39,
    Type = "remove_npc",
    Params = {npcuid = 807760}
  },
  [40] = {
    id = 40,
    Type = "onoff_camerapoint",
    Params = {groupid = 2, on = true}
  },
  [41] = {
    id = 41,
    Type = "play_effect_scene",
    Params = {
      id = 13,
      path = "Common/Magatama_playshow_F",
      pos = {
        4.17,
        0.84,
        -0.03
      },
      onshot = 1
    }
  },
  [42] = {
    id = 42,
    Type = "wait_time",
    Params = {time = 7000}
  },
  [43] = {
    id = 43,
    Type = "summon",
    Params = {
      npcid = 807762,
      npcuid = 807762,
      pos = {
        4.17,
        1.34,
        -0.03
      },
      dir = 315,
      ignoreNavMesh = 1
    }
  },
  [44] = {
    id = 44,
    Type = "play_effect_scene",
    Params = {
      id = 7,
      path = "Common/PhotonForce_Mix",
      pos = {
        4.17,
        1.84,
        -0.03
      },
      ignoreNavMesh = 1
    }
  },
  [45] = {
    id = 45,
    Type = "play_effect_scene",
    Params = {
      id = 8,
      path = "Skill/Task_magic2_blk",
      pos = {
        4.17,
        1.84,
        -0.03
      },
      ignoreNavMesh = 1
    }
  },
  [46] = {
    id = 46,
    Type = "play_effect_scene",
    Params = {
      id = 23,
      path = "Skill/eff_921_playshow",
      pos = {
        4.17,
        1.16,
        -0.03
      },
      onshot = 1,
      ignoreNavMesh = 1,
      dir = {
        0.0,
        270.0,
        0.0
      }
    }
  },
  [47] = {
    id = 47,
    Type = "wait_time",
    Params = {time = 8000}
  },
  [48] = {
    id = 48,
    Type = "dialog",
    Params = {
      dialog = {751062}
    }
  },
  [49] = {
    id = 49,
    Type = "addbutton",
    Params = {
      id = 4,
      text = "##298175",
      eventtype = "goon"
    }
  },
  [50] = {
    id = 50,
    Type = "wait_ui",
    Params = {button = 4}
  },
  [51] = {
    id = 51,
    Type = "move",
    Params = {
      player = 1,
      pos = {
        0.0,
        0.0,
        0.0
      },
      spd = 1,
      dir = 180
    }
  },
  [52] = {
    id = 52,
    Type = "wait_time",
    Params = {time = 1000}
  },
  [53] = {
    id = 53,
    Type = "set_dir",
    Params = {player = 1, dir = 180}
  },
  [54] = {
    id = 54,
    Type = "onoff_camerapoint",
    Params = {
      groupid = 2,
      on = false,
      returnDefaultTime = 1500
    }
  },
  [55] = {
    id = 55,
    Type = "showview",
    Params = {panelid = 800, showtype = 2}
  },
  [56] = {
    id = 56,
    Type = "endfilter",
    Params = {
      fliter = {37}
    }
  }
}
Table_PlotQuest_67_fields = {
  "id",
  "Type",
  "Params"
}
return Table_PlotQuest_67
