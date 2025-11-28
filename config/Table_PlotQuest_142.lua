Table_PlotQuest_142 = {
  [1] = {
    id = 1,
    Type = "stop_sound",
    Params = {audio_index = 3}
  },
  [2] = {
    id = 2,
    Type = "action",
    Params = {npcuid = 1, id = 843}
  },
  [3] = {
    id = 3,
    Type = "random_jump",
    Params = {
      id = {
        {4, 15},
        {6, 15},
        {7, 70}
      }
    }
  },
  [4] = {
    id = 4,
    Type = "playdialog",
    Params = {id = 551649}
  },
  [5] = {
    id = 5,
    Type = "random_jump",
    Params = {
      id = {
        {15, 100}
      }
    }
  },
  [6] = {
    id = 6,
    Type = "playdialog",
    Params = {id = 551650}
  },
  [7] = {
    id = 7,
    Type = "random_jump",
    Params = {
      id = {
        {8, 8},
        {10, 8},
        {12, 8},
        {14, 8},
        {15, 68}
      }
    }
  },
  [8] = {
    id = 8,
    Type = "emoji",
    Params = {npcuid = 2, id = 1}
  },
  [9] = {
    id = 9,
    Type = "random_jump",
    Params = {
      id = {
        {15, 100}
      }
    }
  },
  [10] = {
    id = 10,
    Type = "emoji",
    Params = {npcuid = 2, id = 7}
  },
  [11] = {
    id = 11,
    Type = "random_jump",
    Params = {
      id = {
        {15, 100}
      }
    }
  },
  [12] = {
    id = 12,
    Type = "emoji",
    Params = {npcuid = 2, id = 15}
  },
  [13] = {
    id = 13,
    Type = "random_jump",
    Params = {
      id = {
        {15, 100}
      }
    }
  },
  [14] = {
    id = 14,
    Type = "emoji",
    Params = {npcuid = 2, id = 40}
  },
  [15] = {
    id = 15,
    Type = "play_sound",
    Params = {
      path = "Skill/EarthDrive_attack"
    }
  },
  [16] = {
    id = 16,
    Type = "wait_time",
    Params = {time = 700}
  },
  [17] = {
    id = 17,
    Type = "remove_effect",
    Params = {
      path = "Skill/Eff_chase_Lingting_atk_Red",
      npcuid = 1,
      ep = 2,
      loop = true
    }
  },
  [18] = {
    id = 18,
    Type = "play_effect",
    Params = {
      path = "Skill/Eff_chase_lingting_bullet_Red",
      npcuid = 1,
      ep = 5
    }
  },
  [19] = {
    id = 19,
    Type = "remove_effect",
    Params = {
      path = "Skill/Eff_Chasing_playeratk",
      player = 1,
      ep = 5,
      loop = true
    }
  },
  [20] = {
    id = 20,
    Type = "play_effect",
    Params = {
      path = "Skill/Eff_chase_lingting_hit_Red",
      player = 1,
      ep = 3
    }
  },
  [21] = {
    id = 21,
    Type = "shakescreen",
    Params = {amplitude = 25, time = 600}
  },
  [22] = {
    id = 22,
    Type = "play_sound",
    Params = {
      path = "Skill/wataru_SE_N10"
    }
  },
  [23] = {
    id = 23,
    Type = "action",
    Params = {player = 1, id = 836}
  },
  [24] = {
    id = 24,
    Type = "action",
    Params = {
      npcuid = 1,
      id = 829,
      loop = true
    }
  },
  [25] = {
    id = 25,
    Type = "play_sound",
    Params = {
      path = "Skill/RO2.0_zhuizhu_shandianxuli",
      audio_index = 3
    }
  },
  [26] = {
    id = 26,
    Type = "play_effect",
    Params = {
      path = "Skill/Eff_chase_Lingting_atk_Red",
      npcuid = 1,
      ep = 2,
      loop = true
    }
  },
  [27] = {
    id = 27,
    Type = "wait_time",
    Params = {time = 500}
  },
  [28] = {
    id = 28,
    Type = "action",
    Params = {
      player = 1,
      id = 834,
      loop = true
    }
  },
  [29] = {
    id = 29,
    Type = "play_effect",
    Params = {
      path = "Skill/Eff_Chasing_playeratk_Red",
      player = 1,
      ep = 5,
      loop = true
    }
  }
}
Table_PlotQuest_142_fields = {
  "id",
  "Type",
  "Params"
}
return Table_PlotQuest_142
