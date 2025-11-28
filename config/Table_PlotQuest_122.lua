Table_PlotQuest_122 = {
  [1] = {
    id = 1,
    Type = "wait_time",
    Params = {time = 10}
  },
  [2] = {
    id = 2,
    Type = "stop_sound",
    Params = {audio_index = 1}
  },
  [3] = {
    id = 3,
    Type = "action",
    Params = {npcuid = 1, id = 842}
  },
  [4] = {
    id = 4,
    Type = "wait_time",
    Params = {time = 500}
  },
  [5] = {
    id = 5,
    Type = "play_sound",
    Params = {
      path = "Skill/RO2.0_zhuizhu_shuiqiu"
    }
  },
  [6] = {
    id = 6,
    Type = "play_effect",
    Params = {
      path = "Skill/Eff_chase_WaterBomb_atk02",
      npcuid = 1,
      ep = 2
    }
  },
  [7] = {
    id = 7,
    Type = "remove_effect",
    Params = {
      path = "Skill/Eff_chase_WaterBomb_atk",
      npcuid = 1,
      ep = 2,
      loop = true
    }
  },
  [8] = {
    id = 8,
    Type = "play_effect",
    Params = {
      path = "Skill/Eff_chase_WaterBomb_bullet",
      npcuid = 1,
      ep = 4,
      toEp = {
        tag = {
          -0.45,
          -0.08,
          -3.04
        },
        time = 400
      },
      loop = true
    }
  },
  [9] = {
    id = 9,
    Type = "play_sound",
    Params = {
      path = "Skill/RO2.0_zhuizhu_xuianzhuan"
    }
  },
  [10] = {
    id = 10,
    Type = "action",
    Params = {player = 1, id = 827}
  },
  [11] = {
    id = 11,
    Type = "action",
    Params = {
      npcuid = 2,
      id = 827,
      pos = {
        2.6,
        -1.8,
        1.57
      },
      time = 560
    }
  },
  [12] = {
    id = 12,
    Type = "wait_time",
    Params = {time = 860}
  },
  [13] = {
    id = 13,
    Type = "random_jump",
    Params = {
      id = {
        {14, 4},
        {16, 4},
        {18, 4},
        {20, 4},
        {22, 4},
        {24, 4},
        {26, 4},
        {28, 4},
        {29, 68}
      }
    }
  },
  [14] = {
    id = 14,
    Type = "emoji",
    Params = {npcuid = 1, id = 12}
  },
  [15] = {
    id = 15,
    Type = "random_jump",
    Params = {
      id = {
        {35, 100}
      }
    }
  },
  [16] = {
    id = 16,
    Type = "emoji",
    Params = {npcuid = 1, id = 14}
  },
  [17] = {
    id = 17,
    Type = "random_jump",
    Params = {
      id = {
        {35, 100}
      }
    }
  },
  [18] = {
    id = 18,
    Type = "talk",
    Params = {npcuid = 1, talkid = 551627}
  },
  [19] = {
    id = 19,
    Type = "random_jump",
    Params = {
      id = {
        {35, 100}
      }
    }
  },
  [20] = {
    id = 20,
    Type = "talk",
    Params = {npcuid = 1, talkid = 551628}
  },
  [21] = {
    id = 21,
    Type = "random_jump",
    Params = {
      id = {
        {35, 100}
      }
    }
  },
  [22] = {
    id = 22,
    Type = "talk",
    Params = {npcuid = 1, talkid = 551679}
  },
  [23] = {
    id = 23,
    Type = "random_jump",
    Params = {
      id = {
        {35, 100}
      }
    }
  },
  [24] = {
    id = 24,
    Type = "talk",
    Params = {npcuid = 1, talkid = 551653}
  },
  [25] = {
    id = 25,
    Type = "random_jump",
    Params = {
      id = {
        {35, 100}
      }
    }
  },
  [26] = {
    id = 26,
    Type = "talk",
    Params = {npcuid = 1, talkid = 551654}
  },
  [27] = {
    id = 27,
    Type = "random_jump",
    Params = {
      id = {
        {35, 100}
      }
    }
  },
  [28] = {
    id = 28,
    Type = "talk",
    Params = {npcuid = 1, talkid = 551655}
  },
  [29] = {
    id = 29,
    Type = "random_jump",
    Params = {
      id = {
        {30, 15},
        {32, 15},
        {34, 15},
        {35, 55}
      }
    }
  },
  [30] = {
    id = 30,
    Type = "emoji",
    Params = {npcuid = 2, id = 12}
  },
  [31] = {
    id = 31,
    Type = "random_jump",
    Params = {
      id = {
        {35, 100}
      }
    }
  },
  [32] = {
    id = 32,
    Type = "emoji",
    Params = {npcuid = 2, id = 12}
  },
  [33] = {
    id = 33,
    Type = "random_jump",
    Params = {
      id = {
        {35, 100}
      }
    }
  },
  [34] = {
    id = 34,
    Type = "emoji",
    Params = {npcuid = 2, id = 12}
  },
  [35] = {
    id = 35,
    Type = "action",
    Params = {
      npcuid = 1,
      id = 840,
      loop = true
    }
  },
  [36] = {
    id = 36,
    Type = "action",
    Params = {
      npcuid = 2,
      id = 0,
      loop = true
    }
  },
  [37] = {
    id = 37,
    Type = "action",
    Params = {
      player = 1,
      id = 101,
      loop = true
    }
  }
}
Table_PlotQuest_122_fields = {
  "id",
  "Type",
  "Params"
}
return Table_PlotQuest_122
