Table_PlotQuest_126 = {
  [1] = {
    id = 1,
    Type = "play_sound",
    Params = {
      path = "Skill/RO2.0_zhuizhu_shuixuli_2",
      audio_index = 2,
      loop = true
    }
  },
  [2] = {
    id = 2,
    Type = "action",
    Params = {
      npcuid = 1,
      id = 21,
      loop = true
    }
  },
  [3] = {
    id = 3,
    Type = "play_effect",
    Params = {
      path = "Skill/Eff_chase_WaterBomb_atk",
      npcuid = 1,
      ep = 2,
      loop = true
    }
  },
  [4] = {
    id = 4,
    Type = "play_effect_scene",
    Params = {
      id = 3,
      path = "Skill/Eff_chase_Puddle_atk",
      pos = {
        0.0,
        -1.8,
        1.0
      },
      ignoreNavMesh = 1
    }
  },
  [5] = {
    id = 5,
    Type = "random_jump",
    Params = {
      id = {
        {6, 5},
        {8, 5},
        {10, 5},
        {12, 5},
        {14, 5},
        {16, 5},
        {18, 5},
        {19, 65}
      }
    }
  },
  [6] = {
    id = 6,
    Type = "playdialog",
    Params = {id = 551622}
  },
  [7] = {
    id = 7,
    Type = "random_jump",
    Params = {
      id = {
        {27, 100}
      }
    }
  },
  [8] = {
    id = 8,
    Type = "playdialog",
    Params = {id = 551623}
  },
  [9] = {
    id = 9,
    Type = "random_jump",
    Params = {
      id = {
        {27, 100}
      }
    }
  },
  [10] = {
    id = 10,
    Type = "playdialog",
    Params = {id = 551624}
  },
  [11] = {
    id = 11,
    Type = "random_jump",
    Params = {
      id = {
        {27, 100}
      }
    }
  },
  [12] = {
    id = 12,
    Type = "playdialog",
    Params = {id = 551625}
  },
  [13] = {
    id = 13,
    Type = "random_jump",
    Params = {
      id = {
        {27, 100}
      }
    }
  },
  [14] = {
    id = 14,
    Type = "playdialog",
    Params = {id = 551649}
  },
  [15] = {
    id = 15,
    Type = "random_jump",
    Params = {
      id = {
        {27, 100}
      }
    }
  },
  [16] = {
    id = 16,
    Type = "playdialog",
    Params = {id = 551651}
  },
  [17] = {
    id = 17,
    Type = "random_jump",
    Params = {
      id = {
        {27, 100}
      }
    }
  },
  [18] = {
    id = 18,
    Type = "playdialog",
    Params = {id = 551652}
  },
  [19] = {
    id = 19,
    Type = "random_jump",
    Params = {
      id = {
        {20, 10},
        {22, 10},
        {24, 10},
        {26, 10},
        {27, 60}
      }
    }
  },
  [20] = {
    id = 20,
    Type = "emoji",
    Params = {npcuid = 2, id = 1}
  },
  [21] = {
    id = 21,
    Type = "random_jump",
    Params = {
      id = {
        {27, 100}
      }
    }
  },
  [22] = {
    id = 22,
    Type = "emoji",
    Params = {npcuid = 2, id = 7}
  },
  [23] = {
    id = 23,
    Type = "random_jump",
    Params = {
      id = {
        {27, 100}
      }
    }
  },
  [24] = {
    id = 24,
    Type = "emoji",
    Params = {npcuid = 2, id = 15}
  },
  [25] = {
    id = 25,
    Type = "random_jump",
    Params = {
      id = {
        {27, 100}
      }
    }
  },
  [26] = {
    id = 26,
    Type = "emoji",
    Params = {npcuid = 2, id = 40}
  },
  [27] = {
    id = 27,
    Type = "wait_time",
    Params = {time = 100}
  }
}
Table_PlotQuest_126_fields = {
  "id",
  "Type",
  "Params"
}
return Table_PlotQuest_126
