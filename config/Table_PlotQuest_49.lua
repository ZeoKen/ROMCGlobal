Table_PlotQuest_49 = {
  [1] = {
    id = 1,
    Type = "onoff_camerapoint",
    Params = {groupid = 0, on = true}
  },
  [2] = {
    id = 2,
    Type = "play_effect_ui",
    Params = {path = "BtoW"}
  },
  [3] = {
    id = 3,
    Type = "wait_time",
    Params = {time = 500}
  },
  [4] = {
    id = 4,
    Type = "summon",
    Params = {
      npcid = 807020,
      npcuid = 807020,
      pos = {
        -46.35,
        3.8,
        10.9
      },
      dir = 294.8,
      groupid = 1,
      ignoreNavMesh = 1
    }
  },
  [5] = {
    id = 5,
    Type = "summon",
    Params = {
      npcid = 807048,
      npcuid = 807048,
      pos = {
        -46.39,
        2.35,
        10.9
      },
      dir = 117.6098,
      groupid = 1,
      ignoreNavMesh = 1
    }
  },
  [6] = {
    id = 6,
    Type = "wait_time",
    Params = {time = 2000}
  },
  [7] = {
    id = 7,
    Type = "play_effect_scene",
    Params = {
      id = 1,
      path = "Skill/WolfDancing_buff1",
      pos = {
        -46.39,
        2.35,
        10.9
      },
      ignoreNavMesh = 1
    }
  },
  [8] = {
    id = 8,
    Type = "wait_time",
    Params = {time = 3000}
  },
  [9] = {
    id = 9,
    Type = "play_effect_scene",
    Params = {
      id = 2,
      path = "Skill/Eff_Banquet_clock",
      pos = {
        -46.39,
        2.35,
        10.9
      },
      onshot = 1
    }
  },
  [10] = {
    id = 10,
    Type = "remove_npc",
    Params = {npcuid = 807048}
  },
  [11] = {
    id = 11,
    Type = "remove_npc",
    Params = {npcuid = 807020}
  },
  [12] = {
    id = 12,
    Type = "summon",
    Params = {
      npcid = 807060,
      npcuid = 807060,
      pos = {
        -46.39,
        2.35,
        10.9
      },
      dir = 117.6098,
      groupid = 1,
      ignoreNavMesh = 1
    }
  },
  [13] = {
    id = 13,
    Type = "play_effect_scene",
    Params = {
      id = 3,
      path = "Common/ShinEffect",
      pos = {
        -45.13,
        2.93,
        13.94
      },
      ignoreNavMesh = 1
    }
  },
  [14] = {
    id = 14,
    Type = "play_effect_scene",
    Params = {
      id = 4,
      path = "Common/ShinEffect",
      pos = {
        -46.3,
        4.95,
        8.36
      },
      ignoreNavMesh = 1
    }
  },
  [15] = {
    id = 15,
    Type = "play_effect_scene",
    Params = {
      id = 5,
      path = "Common/ShinEffect",
      pos = {
        -45.01,
        7.43,
        11.38
      },
      ignoreNavMesh = 1
    }
  },
  [16] = {
    id = 16,
    Type = "play_effect_scene",
    Params = {
      id = 6,
      path = "Common/ShinEffect",
      pos = {
        -45.45,
        2.92,
        10.57
      },
      ignoreNavMesh = 1
    }
  },
  [17] = {
    id = 17,
    Type = "wait_time",
    Params = {time = 6000}
  },
  [18] = {
    id = 18,
    Type = "remove_effect_scene",
    Params = {id = 5}
  },
  [19] = {
    id = 19,
    Type = "remove_effect_scene",
    Params = {id = 1}
  },
  [20] = {
    id = 20,
    Type = "remove_effect_scene",
    Params = {id = 2}
  },
  [21] = {
    id = 21,
    Type = "remove_effect_scene",
    Params = {id = 3}
  },
  [22] = {
    id = 22,
    Type = "remove_effect_scene",
    Params = {id = 4}
  },
  [23] = {
    id = 23,
    Type = "remove_effect_scene",
    Params = {id = 6}
  },
  [24] = {
    id = 24,
    Type = "endfilter",
    Params = {
      fliter = {18}
    }
  },
  [25] = {
    id = 25,
    Type = "onoff_camerapoint",
    Params = {
      groupid = 0,
      on = false,
      returnDefaultTime = 1500
    }
  }
}
Table_PlotQuest_49_fields = {
  "id",
  "Type",
  "Params"
}
return Table_PlotQuest_49
