Table_PlotQuest_46 = {
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
      fliter = {39}
    }
  },
  [4] = {
    id = 4,
    Type = "wait_time",
    Params = {time = 500}
  },
  [5] = {
    id = 5,
    Type = "summon",
    Params = {
      npcid = 803602,
      npcuid = 803602,
      pos = {
        -38.42,
        7.11,
        20.1
      },
      dir = 180,
      groupid = 1,
      ignoreNavMesh = 1,
      scale = 1.5
    }
  },
  [6] = {
    id = 6,
    Type = "wait_time",
    Params = {time = 4000}
  },
  [7] = {
    id = 7,
    Type = "play_sound",
    Params = {
      path = "Common/Cardroom_Cardfalling"
    }
  },
  [8] = {
    id = 8,
    Type = "play_effect_scene",
    Params = {
      id = 1,
      path = "Skill/AnniHilate_Buff",
      pos = {
        -38.42,
        7.11,
        20.1
      },
      ignorenavmesh = 1
    }
  },
  [9] = {
    id = 9,
    Type = "wait_time",
    Params = {time = 2000}
  },
  [10] = {
    id = 10,
    Type = "play_sound",
    Params = {
      path = "Skill/attack8"
    }
  },
  [11] = {
    id = 11,
    Type = "play_effect_scene",
    Params = {
      id = 2,
      path = "Skill/Amphibious",
      pos = {
        -38.42,
        6.71,
        20.1
      },
      ignorenavmesh = 1,
      onshot = 1
    }
  },
  [12] = {
    id = 12,
    Type = "remove_npc",
    Params = {npcuid = 803602}
  },
  [13] = {
    id = 13,
    Type = "summon",
    Params = {
      npcid = 803612,
      npcuid = 803612,
      pos = {
        -38.42,
        7.11,
        20.1
      },
      dir = 180,
      groupid = 1,
      ignoreNavMesh = 1,
      scale = 1.5,
      waitaction = "state2002"
    }
  },
  [14] = {
    id = 14,
    Type = "remove_effect_scene",
    Params = {id = 1}
  },
  [15] = {
    id = 15,
    Type = "action",
    Params = {npcuid = 803612, id = 502}
  },
  [16] = {
    id = 16,
    Type = "wait_time",
    Params = {time = 2000}
  },
  [17] = {
    id = 17,
    Type = "play_effect_scene",
    Params = {
      id = 19,
      path = "Skill/Abyssknight_attack",
      pos = {
        -38.42,
        7,
        20.1
      },
      ignorenavmesh = 1,
      onshot = 1
    }
  },
  [18] = {
    id = 18,
    Type = "wait_time",
    Params = {time = 1000}
  },
  [19] = {
    id = 19,
    Type = "play_effect_scene",
    Params = {
      id = 20,
      path = "Common/With_dandelion",
      pos = {
        -40.84,
        7.24,
        20.75
      },
      ignorenavmesh = 1
    }
  },
  [20] = {
    id = 20,
    Type = "play_effect_scene",
    Params = {
      id = 21,
      path = "Common/With_dandelion",
      pos = {
        -41.88,
        8.92,
        21.19
      },
      ignorenavmesh = 1
    }
  },
  [21] = {
    id = 21,
    Type = "play_effect_scene",
    Params = {
      id = 22,
      path = "Common/With_dandelion",
      pos = {
        -40.24,
        8.23,
        21.19
      },
      ignorenavmesh = 1
    }
  },
  [22] = {
    id = 22,
    Type = "play_effect_scene",
    Params = {
      id = 23,
      path = "Common/With_dandelion",
      pos = {
        -35.29,
        9.4,
        20.77
      },
      ignorenavmesh = 1
    }
  },
  [23] = {
    id = 23,
    Type = "play_effect_scene",
    Params = {
      id = 24,
      path = "Common/With_dandelion",
      pos = {
        -36.28,
        7.86,
        20.77
      },
      ignorenavmesh = 1
    }
  },
  [24] = {
    id = 24,
    Type = "play_effect_scene",
    Params = {
      id = 25,
      path = "Common/With_dandelion",
      pos = {
        -33.81,
        7.86,
        20.77
      },
      ignorenavmesh = 1
    }
  },
  [25] = {
    id = 25,
    Type = "wait_time",
    Params = {time = 4000}
  },
  [26] = {
    id = 26,
    Type = "play_sound",
    Params = {
      path = "Common/Cardroom_Cardfalling"
    }
  },
  [27] = {
    id = 27,
    Type = "play_effect_scene",
    Params = {
      id = 3,
      path = "Skill/AnniHilate_Buff",
      pos = {
        -42.39,
        7.24,
        20.75
      },
      ignorenavmesh = 1
    }
  },
  [28] = {
    id = 28,
    Type = "play_effect_scene",
    Params = {
      id = 6,
      path = "Skill/AnniHilate_Buff",
      pos = {
        -34.74,
        7.24,
        20.77
      },
      ignorenavmesh = 1
    }
  },
  [29] = {
    id = 29,
    Type = "wait_time",
    Params = {time = 2000}
  },
  [30] = {
    id = 30,
    Type = "remove_effect_scene",
    Params = {id = 3}
  },
  [31] = {
    id = 31,
    Type = "remove_effect_scene",
    Params = {id = 6}
  },
  [32] = {
    id = 32,
    Type = "play_sound",
    Params = {
      path = "Skill/attack8"
    }
  },
  [33] = {
    id = 33,
    Type = "play_effect_scene",
    Params = {
      id = 7,
      path = "Skill/Amphibious",
      pos = {
        -42.39,
        6.8,
        20.75
      },
      ignorenavmesh = 1,
      onshot = 1
    }
  },
  [34] = {
    id = 34,
    Type = "summon",
    Params = {
      npcid = 803599,
      npcuid = 803599,
      pos = {
        -42.39,
        7.24,
        20.75
      },
      dir = 180,
      groupid = 1,
      ignoreNavMesh = 1,
      scale = 1.1,
      waitaction = "state2002"
    }
  },
  [35] = {
    id = 35,
    Type = "play_effect_scene",
    Params = {
      id = 10,
      path = "Skill/Amphibious",
      pos = {
        -34.74,
        6.8,
        20.77
      },
      ignorenavmesh = 1,
      onshot = 1
    }
  },
  [36] = {
    id = 36,
    Type = "summon",
    Params = {
      npcid = 803611,
      npcuid = 803611,
      pos = {
        -34.74,
        7.24,
        20.77
      },
      dir = 180,
      groupid = 1,
      ignoreNavMesh = 1,
      scale = 1.1,
      waitaction = "state2002"
    }
  },
  [37] = {
    id = 37,
    Type = "wait_time",
    Params = {time = 2000}
  },
  [38] = {
    id = 38,
    Type = "play_sound",
    Params = {
      path = "Common/Cardroom_Cardfalling"
    }
  },
  [39] = {
    id = 39,
    Type = "play_effect_scene",
    Params = {
      id = 11,
      path = "Skill/AnniHilate_Buff",
      pos = {
        -45.16,
        7.24,
        16.22
      },
      ignorenavmesh = 1
    }
  },
  [40] = {
    id = 40,
    Type = "play_effect_scene",
    Params = {
      id = 12,
      path = "Skill/AnniHilate_Buff",
      pos = {
        -32.02,
        7.24,
        16.17
      },
      ignorenavmesh = 1
    }
  },
  [41] = {
    id = 41,
    Type = "play_effect_scene",
    Params = {
      id = 13,
      path = "Skill/AnniHilate_Buff",
      pos = {
        -45.17,
        7.24,
        27.6
      },
      ignorenavmesh = 1
    }
  },
  [42] = {
    id = 42,
    Type = "play_effect_scene",
    Params = {
      id = 14,
      path = "Skill/AnniHilate_Buff",
      pos = {
        -31.93,
        7.24,
        27.62
      },
      ignorenavmesh = 1
    }
  },
  [43] = {
    id = 43,
    Type = "wait_time",
    Params = {time = 2000}
  },
  [44] = {
    id = 44,
    Type = "remove_effect_scene",
    Params = {id = 11}
  },
  [45] = {
    id = 45,
    Type = "remove_effect_scene",
    Params = {id = 12}
  },
  [46] = {
    id = 46,
    Type = "remove_effect_scene",
    Params = {id = 13}
  },
  [47] = {
    id = 47,
    Type = "remove_effect_scene",
    Params = {id = 14}
  },
  [48] = {
    id = 48,
    Type = "play_sound",
    Params = {
      path = "Skill/attack8"
    }
  },
  [49] = {
    id = 49,
    Type = "play_effect_scene",
    Params = {
      id = 15,
      path = "Skill/Amphibious",
      pos = {
        -45.16,
        6.8,
        16.22
      },
      ignorenavmesh = 1,
      onshot = 1
    }
  },
  [50] = {
    id = 50,
    Type = "play_effect_scene",
    Params = {
      id = 16,
      path = "Skill/Amphibious",
      pos = {
        -32.02,
        6.8,
        16.17
      },
      ignorenavmesh = 1,
      onshot = 1
    }
  },
  [51] = {
    id = 51,
    Type = "play_effect_scene",
    Params = {
      id = 17,
      path = "Skill/Amphibious",
      pos = {
        -45.17,
        6.8,
        27.6
      },
      ignorenavmesh = 1,
      onshot = 1
    }
  },
  [52] = {
    id = 52,
    Type = "play_effect_scene",
    Params = {
      id = 18,
      path = "Skill/Amphibious",
      pos = {
        -31.93,
        6.8,
        27.62
      },
      ignorenavmesh = 1,
      onshot = 1
    }
  },
  [53] = {
    id = 53,
    Type = "summon",
    Params = {
      npcid = 803609,
      npcuid = 803609,
      pos = {
        -45.16,
        7.24,
        16.22
      },
      dir = 180,
      groupid = 1,
      ignoreNavMesh = 1,
      scale = 1.1,
      waitaction = "state2002"
    }
  },
  [54] = {
    id = 54,
    Type = "summon",
    Params = {
      npcid = 803605,
      npcuid = 803605,
      pos = {
        -32.02,
        7.24,
        16.17
      },
      dir = 180,
      groupid = 1,
      ignoreNavMesh = 1,
      scale = 1.1,
      waitaction = "state2002"
    }
  },
  [55] = {
    id = 55,
    Type = "summon",
    Params = {
      npcid = 803608,
      npcuid = 803608,
      pos = {
        -45.17,
        7.24,
        27.6
      },
      dir = 180,
      groupid = 1,
      ignoreNavMesh = 1,
      scale = 1.1,
      waitaction = "state2002"
    }
  },
  [56] = {
    id = 56,
    Type = "summon",
    Params = {
      npcid = 803610,
      npcuid = 803610,
      pos = {
        -31.93,
        7.24,
        27.62
      },
      dir = 180,
      groupid = 1,
      ignoreNavMesh = 1,
      scale = 1.1,
      waitaction = "state2002"
    }
  },
  [57] = {
    id = 57,
    Type = "wait_time",
    Params = {time = 3000}
  },
  [58] = {
    id = 58,
    Type = "endfilter",
    Params = {
      fliter = {39}
    }
  },
  [59] = {
    id = 59,
    Type = "onoff_camerapoint",
    Params = {
      groupid = 1,
      on = false,
      returnDefaultTime = 1500
    }
  }
}
Table_PlotQuest_46_fields = {
  "id",
  "Type",
  "Params"
}
return Table_PlotQuest_46
