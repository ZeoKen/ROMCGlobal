Table_PlotQuest_28 = {
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
      npcid = 806119,
      npcuid = 806119,
      pos = {
        168.63,
        13.58,
        80.73
      },
      dir = 273,
      groupid = 1
    }
  },
  [6] = {
    id = 6,
    Type = "summon",
    Params = {
      npcid = 806120,
      npcuid = 806120,
      pos = {
        168.59,
        13.57,
        86.67
      },
      dir = 272,
      groupid = 1
    }
  },
  [7] = {
    id = 7,
    Type = "summon",
    Params = {
      npcid = 806121,
      npcuid = 806121,
      pos = {
        174.43,
        13.58,
        86.71
      },
      dir = 272,
      groupid = 1
    }
  },
  [8] = {
    id = 8,
    Type = "summon",
    Params = {
      npcid = 806122,
      npcuid = 806122,
      pos = {
        174.43,
        13.59,
        80.78
      },
      dir = 272,
      groupid = 1
    }
  },
  [9] = {
    id = 9,
    Type = "summon",
    Params = {
      npcid = 806141,
      npcuid = 806141,
      pos = {
        171.47,
        12.85,
        83.9
      },
      dir = 272,
      groupid = 1,
      ignoreNavMesh = 1,
      scale = 0.8,
      waitaction = "state1002"
    }
  },
  [10] = {
    id = 10,
    Type = "summon",
    Params = {
      npcid = 806133,
      npcuid = 806133,
      pos = {
        168.01,
        13.14,
        76.77
      },
      dir = 23.56458,
      groupid = 1
    }
  },
  [11] = {
    id = 11,
    Type = "play_effect_scene",
    Params = {
      id = 17,
      path = "Skill/MentalStrength_buff",
      pos = {
        168.01,
        13.88,
        76.77
      },
      ignoreNavMesh = 1
    }
  },
  [12] = {
    id = 12,
    Type = "play_effect_scene",
    Params = {
      id = 1,
      path = "Skill/LotteryCard_buff",
      pos = {
        168.63,
        13.58,
        80.73
      }
    }
  },
  [13] = {
    id = 13,
    Type = "play_effect_scene",
    Params = {
      id = 2,
      path = "Skill/LotteryCard_buff",
      pos = {
        168.59,
        13.57,
        86.67
      }
    }
  },
  [14] = {
    id = 14,
    Type = "play_effect_scene",
    Params = {
      id = 3,
      path = "Skill/LotteryCard_buff",
      pos = {
        174.43,
        13.58,
        86.71
      }
    }
  },
  [15] = {
    id = 15,
    Type = "play_effect_scene",
    Params = {
      id = 4,
      path = "Skill/LotteryCard_buff",
      pos = {
        174.43,
        13.59,
        80.78
      }
    }
  },
  [16] = {
    id = 16,
    Type = "play_effect_scene",
    Params = {
      id = 5,
      path = "Skill/AngleOffer_buff",
      pos = {
        171.47,
        14.2,
        83.9
      }
    }
  },
  [17] = {
    id = 17,
    Type = "wait_time",
    Params = {time = 1000}
  },
  [18] = {
    id = 18,
    Type = "action",
    Params = {npcuid = 806141, id = 502}
  },
  [19] = {
    id = 19,
    Type = "wait_time",
    Params = {time = 8000}
  },
  [20] = {
    id = 20,
    Type = "remove_effect_scene",
    Params = {id = 5}
  },
  [21] = {
    id = 21,
    Type = "remove_effect_scene",
    Params = {id = 1}
  },
  [22] = {
    id = 22,
    Type = "remove_effect_scene",
    Params = {id = 2}
  },
  [23] = {
    id = 23,
    Type = "remove_effect_scene",
    Params = {id = 3}
  },
  [24] = {
    id = 24,
    Type = "remove_effect_scene",
    Params = {id = 4}
  },
  [25] = {
    id = 25,
    Type = "remove_effect_scene",
    Params = {id = 17}
  },
  [26] = {
    id = 26,
    Type = "remove_npc",
    Params = {npcuid = 806119}
  },
  [27] = {
    id = 27,
    Type = "remove_npc",
    Params = {npcuid = 806120}
  },
  [28] = {
    id = 28,
    Type = "remove_npc",
    Params = {npcuid = 806121}
  },
  [29] = {
    id = 29,
    Type = "remove_npc",
    Params = {npcuid = 806122}
  },
  [30] = {
    id = 30,
    Type = "remove_npc",
    Params = {npcuid = 806133}
  },
  [31] = {
    id = 31,
    Type = "remove_npc",
    Params = {npcuid = 806141}
  },
  [32] = {
    id = 32,
    Type = "endfilter",
    Params = {
      fliter = {39}
    }
  },
  [33] = {
    id = 33,
    Type = "onoff_camerapoint",
    Params = {
      groupid = 1,
      on = false,
      returnDefaultTime = 1500
    }
  }
}
Table_PlotQuest_28_fields = {
  "id",
  "Type",
  "Params"
}
return Table_PlotQuest_28
