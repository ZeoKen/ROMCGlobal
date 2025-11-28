Table_PlotQuest_140 = {
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
    Params = {npcuid = 1, id = 841}
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
    Type = "remove_effect",
    Params = {
      path = "Skill/Eff_chase_Lingting_atk",
      npcuid = 1,
      ep = 2,
      loop = true
    }
  },
  [7] = {
    id = 7,
    Type = "play_effect",
    Params = {
      path = "Skill/Eff_chase_lingting_bullet",
      npcuid = 1,
      ep = 5
    }
  },
  [8] = {
    id = 8,
    Type = "wait_time",
    Params = {time = 100}
  },
  [9] = {
    id = 9,
    Type = "play_effect",
    Params = {
      path = "Skill/Eff_chase_lingting_hit",
      player = 1,
      ep = 3
    }
  },
  [10] = {
    id = 10,
    Type = "play_effect",
    Params = {
      path = "Skill/Eff_chase_lingting_hit",
      npcuid = 2,
      ep = 6
    }
  },
  [11] = {
    id = 11,
    Type = "play_sound",
    Params = {
      path = "Skill/wataru_SE_N10"
    }
  },
  [12] = {
    id = 12,
    Type = "action",
    Params = {player = 1, id = 866}
  },
  [13] = {
    id = 13,
    Type = "action",
    Params = {npcuid = 2, id = 5}
  },
  [14] = {
    id = 14,
    Type = "random_jump",
    Params = {
      id = {
        {15, 15},
        {17, 15},
        {18, 70}
      }
    }
  },
  [15] = {
    id = 15,
    Type = "emoji",
    Params = {npcuid = 1, id = 5}
  },
  [16] = {
    id = 16,
    Type = "random_jump",
    Params = {
      id = {
        {20, 100}
      }
    }
  },
  [17] = {
    id = 17,
    Type = "emoji",
    Params = {npcuid = 1, id = 9}
  },
  [18] = {
    id = 18,
    Type = "random_jump",
    Params = {
      id = {
        {19, 30},
        {20, 70}
      }
    }
  },
  [19] = {
    id = 19,
    Type = "emoji",
    Params = {npcuid = 2, id = 15}
  },
  [20] = {
    id = 20,
    Type = "shakescreen",
    Params = {amplitude = 25, time = 800}
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
    Type = "wait_time",
    Params = {time = 140}
  },
  [24] = {
    id = 24,
    Type = "action",
    Params = {
      npcuid = 1,
      id = 840,
      loop = true
    }
  },
  [25] = {
    id = 25,
    Type = "action",
    Params = {
      player = 1,
      id = 101,
      loop = true
    }
  }
}
Table_PlotQuest_140_fields = {
  "id",
  "Type",
  "Params"
}
return Table_PlotQuest_140
