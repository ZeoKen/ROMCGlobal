Table_PlotQuest_145 = {
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
    Type = "action",
    Params = {player = 1, id = 837}
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
      path = "Skill/EarthDrive_attack"
    }
  },
  [6] = {
    id = 6,
    Type = "wait_time",
    Params = {time = 300}
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
    Type = "play_effect",
    Params = {
      path = "Skill/Eff_chase_lingting_bullet_Red",
      npcuid = 1,
      ep = 5
    }
  },
  [9] = {
    id = 9,
    Type = "remove_effect",
    Params = {
      path = "Skill/Eff_Chasing_playeratk_Red",
      player = 1,
      ep = 5,
      loop = true
    }
  },
  [10] = {
    id = 10,
    Type = "play_effect",
    Params = {
      path = "Skill/Eff_chase_lingting_hit_Red",
      player = 1,
      ep = 3
    }
  },
  [11] = {
    id = 11,
    Type = "shakescreen",
    Params = {amplitude = 25, time = 660}
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
    Type = "action",
    Params = {player = 1, id = 866}
  },
  [14] = {
    id = 14,
    Type = "action",
    Params = {npcuid = 2, id = 5}
  },
  [15] = {
    id = 15,
    Type = "random_jump",
    Params = {
      id = {
        {16, 15},
        {18, 15},
        {20, 70}
      }
    }
  },
  [16] = {
    id = 16,
    Type = "emoji",
    Params = {npcuid = 1, id = 5}
  },
  [17] = {
    id = 17,
    Type = "random_jump",
    Params = {
      id = {
        {21, 100}
      }
    }
  },
  [18] = {
    id = 18,
    Type = "emoji",
    Params = {npcuid = 1, id = 9}
  },
  [19] = {
    id = 19,
    Type = "random_jump",
    Params = {
      id = {
        {20, 30},
        {21, 70}
      }
    }
  },
  [20] = {
    id = 20,
    Type = "emoji",
    Params = {npcuid = 2, id = 15}
  },
  [21] = {
    id = 21,
    Type = "wait_time",
    Params = {time = 660}
  },
  [22] = {
    id = 22,
    Type = "action",
    Params = {
      npcuid = 2,
      id = 0,
      loop = true
    }
  },
  [23] = {
    id = 23,
    Type = "action",
    Params = {
      player = 1,
      id = 101,
      loop = true
    }
  },
  [24] = {
    id = 24,
    Type = "action",
    Params = {
      npcuid = 1,
      id = 840,
      loop = true
    }
  }
}
Table_PlotQuest_145_fields = {
  "id",
  "Type",
  "Params"
}
return Table_PlotQuest_145
