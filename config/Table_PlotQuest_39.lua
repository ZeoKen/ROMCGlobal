Table_PlotQuest_39 = {
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
    Type = "startfilter",
    Params = {
      fliter = {38}
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
      npcid = 806111,
      npcuid = 806111,
      pos = {
        0.86,
        -0.15,
        -4.38
      },
      dir = 181.3536,
      groupid = 1,
      ignoreNavMesh = 1,
      waitaction = "state1001"
    }
  },
  [6] = {
    id = 6,
    Type = "wait_time",
    Params = {time = 2000}
  },
  [7] = {
    id = 7,
    Type = "play_sound",
    Params = {
      path = "Skill/NPC_Starball_wing"
    }
  },
  [8] = {
    id = 8,
    Type = "play_effect_scene",
    Params = {
      id = 1,
      path = "Skill/LotteryCard_buff",
      pos = {
        -0.6,
        0.61,
        -2.79
      },
      ignoreNavMesh = 1
    }
  },
  [9] = {
    id = 9,
    Type = "wait_time",
    Params = {time = 1000}
  },
  [10] = {
    id = 10,
    Type = "play_effect_scene",
    Params = {
      id = 2,
      path = "Skill/LotteryCard_buff",
      pos = {
        2.45,
        0.61,
        -2.9
      },
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
    Type = "play_effect_scene",
    Params = {
      id = 3,
      path = "Skill/LotteryCard_buff",
      pos = {
        2.4,
        0.61,
        -5.97
      },
      ignoreNavMesh = 1
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
      id = 4,
      path = "Skill/LotteryCard_buff",
      pos = {
        -0.62,
        0.61,
        -5.86
      },
      ignoreNavMesh = 1
    }
  },
  [15] = {
    id = 15,
    Type = "wait_time",
    Params = {time = 4000}
  },
  [16] = {
    id = 16,
    Type = "action",
    Params = {npcuid = 806111, id = 502}
  },
  [17] = {
    id = 17,
    Type = "play_effect_scene",
    Params = {
      id = 5,
      path = "Skill/AngleOffer_buff",
      pos = {
        0.9,
        0.8,
        -4.36
      },
      ignoreNavMesh = 1
    }
  },
  [18] = {
    id = 18,
    Type = "wait_time",
    Params = {time = 4000}
  },
  [19] = {
    id = 19,
    Type = "remove_effect_scene",
    Params = {id = 5}
  },
  [20] = {
    id = 20,
    Type = "play_effect_scene",
    Params = {
      id = 6,
      path = "Skill/LightOfHeal_attack",
      pos = {
        0.9,
        0.8,
        -4.36
      },
      ignoreNavMesh = 1,
      onshot = 1
    }
  },
  [21] = {
    id = 21,
    Type = "wait_time",
    Params = {time = 3000}
  },
  [22] = {
    id = 22,
    Type = "remove_effect_scene",
    Params = {id = 1}
  },
  [23] = {
    id = 23,
    Type = "remove_effect_scene",
    Params = {id = 2}
  },
  [24] = {
    id = 24,
    Type = "remove_effect_scene",
    Params = {id = 3}
  },
  [25] = {
    id = 25,
    Type = "remove_effect_scene",
    Params = {id = 4}
  },
  [26] = {
    id = 26,
    Type = "remove_npc",
    Params = {npcuid = 806111}
  },
  [27] = {
    id = 27,
    Type = "endfilter",
    Params = {
      fliter = {38}
    }
  },
  [28] = {
    id = 28,
    Type = "onoff_camerapoint",
    Params = {
      groupid = 0,
      on = false,
      returnDefaultTime = 1500
    }
  }
}
Table_PlotQuest_39_fields = {
  "id",
  "Type",
  "Params"
}
return Table_PlotQuest_39
