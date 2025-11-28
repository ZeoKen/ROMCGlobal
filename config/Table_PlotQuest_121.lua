Table_PlotQuest_121 = {
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
        me = 1,
        ep = 6,
        time = 300
      },
      loop = true
    }
  },
  [9] = {
    id = 9,
    Type = "wait_time",
    Params = {time = 300}
  },
  [10] = {
    id = 10,
    Type = "play_effect",
    Params = {
      path = "Skill/Eff_chase_WaterBomb_hit",
      player = 1,
      ep = 7
    }
  },
  [11] = {
    id = 11,
    Type = "play_effect",
    Params = {
      path = "Skill/Eff_chase_WaterBomb_hit",
      npcuid = 2,
      ep = 3
    }
  },
  [12] = {
    id = 12,
    Type = "shakescreen",
    Params = {amplitude = 20, time = 660}
  },
  [13] = {
    id = 13,
    Type = "play_sound",
    Params = {
      path = "Skill/RO2.0_zhuizhu_shuishouji"
    }
  },
  [14] = {
    id = 14,
    Type = "action",
    Params = {player = 1, id = 838}
  },
  [15] = {
    id = 15,
    Type = "action",
    Params = {npcuid = 2, id = 5}
  },
  [16] = {
    id = 16,
    Type = "random_jump",
    Params = {
      id = {
        {17, 15},
        {19, 15},
        {20, 70}
      }
    }
  },
  [17] = {
    id = 17,
    Type = "emoji",
    Params = {npcuid = 1, id = 5}
  },
  [18] = {
    id = 18,
    Type = "random_jump",
    Params = {
      id = {
        {22, 100}
      }
    }
  },
  [19] = {
    id = 19,
    Type = "emoji",
    Params = {npcuid = 1, id = 9}
  },
  [20] = {
    id = 20,
    Type = "random_jump",
    Params = {
      id = {
        {21, 30},
        {22, 70}
      }
    }
  },
  [21] = {
    id = 21,
    Type = "emoji",
    Params = {npcuid = 2, id = 15}
  },
  [22] = {
    id = 22,
    Type = "wait_time",
    Params = {time = 660}
  },
  [23] = {
    id = 23,
    Type = "action",
    Params = {
      npcuid = 2,
      id = 0,
      loop = true
    }
  },
  [24] = {
    id = 24,
    Type = "action",
    Params = {
      player = 1,
      id = 101,
      loop = true
    }
  },
  [25] = {
    id = 25,
    Type = "wait_time",
    Params = {time = 240}
  },
  [26] = {
    id = 26,
    Type = "action",
    Params = {
      npcuid = 1,
      id = 840,
      loop = true
    }
  }
}
Table_PlotQuest_121_fields = {
  "id",
  "Type",
  "Params"
}
return Table_PlotQuest_121
