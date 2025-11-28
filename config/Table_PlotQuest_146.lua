Table_PlotQuest_146 = {
  [1] = {
    id = 1,
    Type = "wait_time",
    Params = {time = 10}
  },
  [2] = {
    id = 2,
    Type = "stop_sound",
    Params = {audio_index = 3}
  },
  [3] = {
    id = 3,
    Type = "action",
    Params = {player = 1, id = 835}
  },
  [4] = {
    id = 4,
    Type = "play_sound",
    Params = {
      path = "Skill/EarthDrive_attack"
    }
  },
  [5] = {
    id = 5,
    Type = "wait_time",
    Params = {time = 500}
  },
  [6] = {
    id = 6,
    Type = "play_effect",
    Params = {
      path = "Skill/Eff_chase_lingting_bullet_Red",
      player = 1,
      ep = 3
    }
  },
  [7] = {
    id = 7,
    Type = "remove_effect",
    Params = {
      path = "Skill/Eff_chase_Lingting_atk_Red",
      npcuid = 1,
      ep = 2,
      loop = true
    }
  },
  [8] = {
    id = 8,
    Type = "remove_effect",
    Params = {
      path = "Skill/Eff_Chasing_playeratk_Red",
      player = 1,
      ep = 5,
      loop = true
    }
  },
  [9] = {
    id = 9,
    Type = "play_effect",
    Params = {
      path = "Skill/Eff_chase_lingting_hit_Red",
      npcuid = 1,
      ep = 3
    }
  },
  [10] = {
    id = 10,
    Type = "wait_time",
    Params = {time = 100}
  },
  [11] = {
    id = 11,
    Type = "play_effect",
    Params = {
      path = "Skill/Eff_chase_lingting_hit_Red",
      npcuid = 1,
      ep = 3
    }
  },
  [12] = {
    id = 12,
    Type = "play_sound",
    Params = {
      path = "Skill/wataru_SE_N10"
    }
  },
  [13] = {
    id = 13,
    Type = "play_sound",
    Params = {
      path = "Skill/EarthDrive_attack"
    }
  },
  [14] = {
    id = 14,
    Type = "action",
    Params = {npcuid = 1, id = 846}
  },
  [15] = {
    id = 15,
    Type = "shakescreen",
    Params = {amplitude = 35, time = 1000}
  },
  [16] = {
    id = 16,
    Type = "wait_time",
    Params = {time = 200}
  },
  [17] = {
    id = 17,
    Type = "play_sound",
    Params = {
      path = "Skill/wataru_SE_N10"
    }
  },
  [18] = {
    id = 18,
    Type = "wait_time",
    Params = {time = 150}
  },
  [19] = {
    id = 19,
    Type = "play_effect",
    Params = {
      path = "Skill/Eff_chase_lingting_hit02_Red",
      npcuid = 1,
      ep = 3
    }
  },
  [20] = {
    id = 20,
    Type = "play_effect_scene",
    Params = {
      id = 97,
      path = "Skill/Eff_chase_lingting_hit03_Red",
      pos = {
        0,
        0,
        0
      },
      ignoreNavMesh = 1,
      onshot = 1
    }
  },
  [21] = {
    id = 21,
    Type = "wait_time",
    Params = {time = 50}
  },
  [22] = {
    id = 22,
    Type = "action",
    Params = {player = 1, id = 837}
  },
  [23] = {
    id = 23,
    Type = "wait_time",
    Params = {time = 300}
  },
  [24] = {
    id = 24,
    Type = "random_jump",
    Params = {
      id = {
        {25, 4},
        {27, 4},
        {29, 4},
        {31, 4},
        {33, 4},
        {35, 4},
        {37, 4},
        {39, 4},
        {40, 68}
      }
    }
  },
  [25] = {
    id = 25,
    Type = "emoji",
    Params = {npcuid = 1, id = 12}
  },
  [26] = {
    id = 26,
    Type = "random_jump",
    Params = {
      id = {
        {46, 100}
      }
    }
  },
  [27] = {
    id = 27,
    Type = "emoji",
    Params = {npcuid = 1, id = 14}
  },
  [28] = {
    id = 28,
    Type = "random_jump",
    Params = {
      id = {
        {46, 100}
      }
    }
  },
  [29] = {
    id = 29,
    Type = "talk",
    Params = {npcuid = 1, talkid = 551627}
  },
  [30] = {
    id = 30,
    Type = "random_jump",
    Params = {
      id = {
        {46, 100}
      }
    }
  },
  [31] = {
    id = 31,
    Type = "talk",
    Params = {npcuid = 1, talkid = 551628}
  },
  [32] = {
    id = 32,
    Type = "random_jump",
    Params = {
      id = {
        {46, 100}
      }
    }
  },
  [33] = {
    id = 33,
    Type = "talk",
    Params = {npcuid = 1, talkid = 551679}
  },
  [34] = {
    id = 34,
    Type = "random_jump",
    Params = {
      id = {
        {46, 100}
      }
    }
  },
  [35] = {
    id = 35,
    Type = "talk",
    Params = {npcuid = 1, talkid = 551653}
  },
  [36] = {
    id = 36,
    Type = "random_jump",
    Params = {
      id = {
        {46, 100}
      }
    }
  },
  [37] = {
    id = 37,
    Type = "talk",
    Params = {npcuid = 1, talkid = 551654}
  },
  [38] = {
    id = 38,
    Type = "random_jump",
    Params = {
      id = {
        {46, 100}
      }
    }
  },
  [39] = {
    id = 39,
    Type = "talk",
    Params = {npcuid = 1, talkid = 551655}
  },
  [40] = {
    id = 40,
    Type = "random_jump",
    Params = {
      id = {
        {41, 15},
        {43, 15},
        {45, 15},
        {46, 55}
      }
    }
  },
  [41] = {
    id = 41,
    Type = "emoji",
    Params = {npcuid = 2, id = 12}
  },
  [42] = {
    id = 42,
    Type = "random_jump",
    Params = {
      id = {
        {46, 100}
      }
    }
  },
  [43] = {
    id = 43,
    Type = "emoji",
    Params = {npcuid = 2, id = 12}
  },
  [44] = {
    id = 44,
    Type = "random_jump",
    Params = {
      id = {
        {46, 100}
      }
    }
  },
  [45] = {
    id = 45,
    Type = "emoji",
    Params = {npcuid = 2, id = 12}
  },
  [46] = {
    id = 46,
    Type = "action",
    Params = {
      npcuid = 1,
      id = 840,
      loop = true
    }
  },
  [47] = {
    id = 47,
    Type = "wait_time",
    Params = {time = 700}
  },
  [48] = {
    id = 48,
    Type = "action",
    Params = {
      player = 1,
      id = 101,
      loop = true
    }
  }
}
Table_PlotQuest_146_fields = {
  "id",
  "Type",
  "Params"
}
return Table_PlotQuest_146
