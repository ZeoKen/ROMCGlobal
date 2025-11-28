Table_PlotQuest_120 = {
  [1] = {
    id = 1,
    Type = "play_sound",
    Params = {
      path = "Skill/RO2.0_zhuizhu_shuixuli_1",
      audio_index = 1,
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
    Type = "random_jump",
    Params = {
      id = {
        {5, 5},
        {7, 5},
        {9, 5},
        {11, 5},
        {13, 5},
        {15, 5},
        {17, 5},
        {18, 65}
      }
    }
  },
  [5] = {
    id = 5,
    Type = "playdialog",
    Params = {id = 551622}
  },
  [6] = {
    id = 6,
    Type = "random_jump",
    Params = {
      id = {
        {26, 100}
      }
    }
  },
  [7] = {
    id = 7,
    Type = "playdialog",
    Params = {id = 551623}
  },
  [8] = {
    id = 8,
    Type = "random_jump",
    Params = {
      id = {
        {26, 100}
      }
    }
  },
  [9] = {
    id = 9,
    Type = "playdialog",
    Params = {id = 551624}
  },
  [10] = {
    id = 10,
    Type = "random_jump",
    Params = {
      id = {
        {26, 100}
      }
    }
  },
  [11] = {
    id = 11,
    Type = "playdialog",
    Params = {id = 551625}
  },
  [12] = {
    id = 12,
    Type = "random_jump",
    Params = {
      id = {
        {26, 100}
      }
    }
  },
  [13] = {
    id = 13,
    Type = "playdialog",
    Params = {id = 551649}
  },
  [14] = {
    id = 14,
    Type = "random_jump",
    Params = {
      id = {
        {26, 100}
      }
    }
  },
  [15] = {
    id = 15,
    Type = "playdialog",
    Params = {id = 551651}
  },
  [16] = {
    id = 16,
    Type = "random_jump",
    Params = {
      id = {
        {26, 100}
      }
    }
  },
  [17] = {
    id = 17,
    Type = "playdialog",
    Params = {id = 551652}
  },
  [18] = {
    id = 18,
    Type = "random_jump",
    Params = {
      id = {
        {19, 10},
        {21, 10},
        {23, 10},
        {25, 10},
        {26, 60}
      }
    }
  },
  [19] = {
    id = 19,
    Type = "emoji",
    Params = {npcuid = 2, id = 1}
  },
  [20] = {
    id = 20,
    Type = "random_jump",
    Params = {
      id = {
        {26, 100}
      }
    }
  },
  [21] = {
    id = 21,
    Type = "emoji",
    Params = {npcuid = 2, id = 7}
  },
  [22] = {
    id = 22,
    Type = "random_jump",
    Params = {
      id = {
        {26, 100}
      }
    }
  },
  [23] = {
    id = 23,
    Type = "emoji",
    Params = {npcuid = 2, id = 15}
  },
  [24] = {
    id = 24,
    Type = "random_jump",
    Params = {
      id = {
        {26, 100}
      }
    }
  },
  [25] = {
    id = 25,
    Type = "emoji",
    Params = {npcuid = 2, id = 40}
  },
  [26] = {
    id = 26,
    Type = "wait_time",
    Params = {time = 100}
  }
}
Table_PlotQuest_120_fields = {
  "id",
  "Type",
  "Params"
}
return Table_PlotQuest_120
