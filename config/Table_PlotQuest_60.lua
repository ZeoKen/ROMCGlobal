Table_PlotQuest_60 = {
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
    Type = "showview",
    Params = {panelid = 800, showtype = 1}
  },
  [4] = {
    id = 4,
    Type = "onoff_camerapoint",
    Params = {groupid = 0, on = true}
  },
  [5] = {
    id = 5,
    Type = "summon",
    Params = {
      npcid = 807561,
      npcuid = 807561,
      pos = {
        -0.02,
        0.24,
        0.94
      },
      dir = 354.2154,
      ignoreNavMesh = 1
    }
  },
  [6] = {
    id = 6,
    Type = "summon",
    Params = {
      npcid = 807549,
      npcuid = 807549,
      pos = {
        1.0,
        0.0,
        -7.0
      },
      dir = 180
    }
  },
  [7] = {
    id = 7,
    Type = "summon",
    Params = {
      npcid = 807550,
      npcuid = 807550,
      pos = {
        -0.5,
        0.0,
        -7.0
      },
      dir = 180
    }
  },
  [8] = {
    id = 8,
    Type = "summon",
    Params = {
      npcid = 807551,
      npcuid = 807551,
      pos = {
        -2.0,
        0.0,
        -7.0
      },
      dir = 180
    }
  },
  [9] = {
    id = 9,
    Type = "summon",
    Params = {
      npcid = 807552,
      npcuid = 807552,
      pos = {
        2.5,
        0.0,
        -7.0
      },
      dir = 180
    }
  },
  [10] = {
    id = 10,
    Type = "play_effect_scene",
    Params = {
      id = 1,
      path = "Skill/AnniHilate_Buff",
      pos = {
        1.0,
        0.0,
        -7.0
      },
      ignoreNavMesh = 1
    }
  },
  [11] = {
    id = 11,
    Type = "play_effect_scene",
    Params = {
      id = 2,
      path = "Skill/AnniHilate_Buff",
      pos = {
        -0.5,
        0.0,
        -7.0
      },
      ignoreNavMesh = 1
    }
  },
  [12] = {
    id = 12,
    Type = "play_effect_scene",
    Params = {
      id = 3,
      path = "Skill/AnniHilate_Buff",
      pos = {
        -2.0,
        0.0,
        -7.0
      },
      ignoreNavMesh = 1
    }
  },
  [13] = {
    id = 13,
    Type = "play_effect_scene",
    Params = {
      id = 4,
      path = "Skill/AnniHilate_Buff",
      pos = {
        2.5,
        0.0,
        -7.0
      },
      ignoreNavMesh = 1
    }
  },
  [14] = {
    id = 14,
    Type = "play_effect_scene",
    Params = {
      id = 5,
      path = "Skill/Deluge_buff",
      pos = {
        -0.02,
        0.24,
        0.94
      },
      ignoreNavMesh = 1
    }
  },
  [15] = {
    id = 15,
    Type = "wait_time",
    Params = {time = 3000}
  },
  [16] = {
    id = 16,
    Type = "action",
    Params = {npcuid = 807561, id = 502}
  },
  [17] = {
    id = 17,
    Type = "wait_time",
    Params = {time = 5000}
  },
  [18] = {
    id = 18,
    Type = "dialog",
    Params = {
      dialog = {750220}
    }
  },
  [19] = {
    id = 19,
    Type = "wait_time",
    Params = {time = 2000}
  },
  [20] = {
    id = 20,
    Type = "action",
    Params = {npcuid = 807561, id = 504}
  },
  [21] = {
    id = 21,
    Type = "wait_time",
    Params = {time = 5000}
  },
  [22] = {
    id = 22,
    Type = "onoff_camerapoint",
    Params = {
      groupid = 0,
      on = false,
      returnDefaultTime = 1500
    }
  },
  [23] = {
    id = 23,
    Type = "wait_time",
    Params = {time = 2000}
  },
  [24] = {
    id = 24,
    Type = "showview",
    Params = {panelid = 800, showtype = 2}
  },
  [25] = {
    id = 25,
    Type = "endfilter",
    Params = {
      fliter = {37}
    }
  }
}
Table_PlotQuest_60_fields = {
  "id",
  "Type",
  "Params"
}
return Table_PlotQuest_60
