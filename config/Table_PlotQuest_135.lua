Table_PlotQuest_135 = {
  [1] = {
    id = 1,
    Type = "wait_time",
    Params = {time = 10}
  },
  [2] = {
    id = 2,
    Type = "wait_time",
    Params = {time = 10}
  },
  [3] = {
    id = 3,
    Type = "stop_sound",
    Params = {audio_index = 2}
  },
  [4] = {
    id = 4,
    Type = "action",
    Params = {npcuid = 1, id = 850}
  },
  [5] = {
    id = 5,
    Type = "wait_time",
    Params = {time = 200}
  },
  [6] = {
    id = 6,
    Type = "play_sound",
    Params = {
      path = "Skill/RO2.0_zhuizhu_xuianzhuan"
    }
  },
  [7] = {
    id = 7,
    Type = "action",
    Params = {player = 1, id = 827}
  },
  [8] = {
    id = 8,
    Type = "action",
    Params = {
      npcuid = 2,
      id = 827,
      pos = {
        0.0,
        -1.8,
        1.0
      },
      time = 560
    }
  },
  [9] = {
    id = 9,
    Type = "wait_time",
    Params = {time = 200}
  },
  [10] = {
    id = 10,
    Type = "remove_effect",
    Params = {
      path = "Skill/Eff_chase_WaterBomb_atk",
      npcuid = 1,
      ep = 2,
      loop = true
    }
  },
  [11] = {
    id = 11,
    Type = "play_sound",
    Params = {
      path = "Skill/RO2.0_zhuizhu_shuihuabaozha"
    }
  },
  [12] = {
    id = 12,
    Type = "play_effect",
    Params = {
      path = "Skill/Eff_chase_Puddle_atk02",
      npcuid = 1,
      ep = 2
    }
  },
  [13] = {
    id = 13,
    Type = "play_effect_scene",
    Params = {
      id = 4,
      path = "Skill/Eff_chase_Puddle_hit",
      pos = {
        -3.07,
        -1.8,
        0.93
      },
      ignoreNavMesh = 1,
      onshot = 1
    }
  },
  [14] = {
    id = 14,
    Type = "wait_time",
    Params = {time = 560}
  },
  [15] = {
    id = 15,
    Type = "random_jump",
    Params = {
      id = {
        {16, 4},
        {18, 4},
        {20, 4},
        {22, 4},
        {24, 4},
        {26, 4},
        {28, 4},
        {30, 4},
        {31, 68}
      }
    }
  },
  [16] = {
    id = 16,
    Type = "emoji",
    Params = {npcuid = 1, id = 12}
  },
  [17] = {
    id = 17,
    Type = "random_jump",
    Params = {
      id = {
        {37, 100}
      }
    }
  },
  [18] = {
    id = 18,
    Type = "emoji",
    Params = {npcuid = 1, id = 14}
  },
  [19] = {
    id = 19,
    Type = "random_jump",
    Params = {
      id = {
        {37, 100}
      }
    }
  },
  [20] = {
    id = 20,
    Type = "talk",
    Params = {npcuid = 1, talkid = 551627}
  },
  [21] = {
    id = 21,
    Type = "random_jump",
    Params = {
      id = {
        {37, 100}
      }
    }
  },
  [22] = {
    id = 22,
    Type = "talk",
    Params = {npcuid = 1, talkid = 551628}
  },
  [23] = {
    id = 23,
    Type = "random_jump",
    Params = {
      id = {
        {37, 100}
      }
    }
  },
  [24] = {
    id = 24,
    Type = "talk",
    Params = {npcuid = 1, talkid = 551679}
  },
  [25] = {
    id = 25,
    Type = "random_jump",
    Params = {
      id = {
        {37, 100}
      }
    }
  },
  [26] = {
    id = 26,
    Type = "talk",
    Params = {npcuid = 1, talkid = 551653}
  },
  [27] = {
    id = 27,
    Type = "random_jump",
    Params = {
      id = {
        {37, 100}
      }
    }
  },
  [28] = {
    id = 28,
    Type = "talk",
    Params = {npcuid = 1, talkid = 551654}
  },
  [29] = {
    id = 29,
    Type = "random_jump",
    Params = {
      id = {
        {37, 100}
      }
    }
  },
  [30] = {
    id = 30,
    Type = "talk",
    Params = {npcuid = 1, talkid = 551655}
  },
  [31] = {
    id = 31,
    Type = "random_jump",
    Params = {
      id = {
        {32, 15},
        {34, 15},
        {36, 15},
        {37, 55}
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
        {37, 100}
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
    Type = "random_jump",
    Params = {
      id = {
        {37, 100}
      }
    }
  },
  [36] = {
    id = 36,
    Type = "emoji",
    Params = {npcuid = 2, id = 12}
  },
  [37] = {
    id = 37,
    Type = "remove_effect_scene",
    Params = {id = 3}
  },
  [38] = {
    id = 38,
    Type = "action",
    Params = {
      npcuid = 2,
      id = 0,
      loop = true
    }
  },
  [39] = {
    id = 39,
    Type = "action",
    Params = {
      player = 1,
      id = 101,
      loop = true
    }
  },
  [40] = {
    id = 40,
    Type = "wait_time",
    Params = {time = 740}
  },
  [41] = {
    id = 41,
    Type = "action",
    Params = {
      npcuid = 1,
      id = 840,
      loop = true
    }
  }
}
Table_PlotQuest_135_fields = {
  "id",
  "Type",
  "Params"
}
return Table_PlotQuest_135
