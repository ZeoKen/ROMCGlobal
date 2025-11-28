Table_PlotQuest_137 = {
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
    Type = "action",
    Params = {npcuid = 1, id = 842}
  },
  [4] = {
    id = 4,
    Type = "wait_time",
    Params = {time = 400}
  },
  [5] = {
    id = 5,
    Type = "play_sound",
    Params = {
      path = "Skill/DrugDragonFire_Atk"
    }
  },
  [6] = {
    id = 6,
    Type = "play_effect_scene",
    Params = {
      id = 6,
      path = "Skill/Eff_chase_wave_atk",
      pos = {
        0.89,
        -0.85,
        17.18
      },
      ignoreNavMesh = 1,
      dir = {
        0.0,
        0.0,
        0.0
      },
      toEp = {
        pos = {
          -0.81,
          -0.85,
          -8.93
        },
        time = 700
      }
    }
  },
  [7] = {
    id = 7,
    Type = "wait_time",
    Params = {time = 100}
  },
  [8] = {
    id = 8,
    Type = "remove_effect_scene",
    Params = {id = 5}
  },
  [9] = {
    id = 9,
    Type = "wait_time",
    Params = {time = 100}
  },
  [10] = {
    id = 10,
    Type = "play_sound",
    Params = {
      path = "Skill/RO2.0_zhuizhu_shuishouji"
    }
  },
  [11] = {
    id = 11,
    Type = "action",
    Params = {player = 1, id = 838}
  },
  [12] = {
    id = 12,
    Type = "action",
    Params = {npcuid = 2, id = 5}
  },
  [13] = {
    id = 13,
    Type = "shakescreen",
    Params = {amplitude = 20, time = 1000}
  },
  [14] = {
    id = 14,
    Type = "play_effect",
    Params = {
      path = "Skill/Eff_chase_WaterBomb_hit",
      player = 1,
      ep = 7
    }
  },
  [15] = {
    id = 15,
    Type = "play_effect",
    Params = {
      path = "Skill/Eff_chase_WaterBomb_hit",
      npcuid = 2,
      ep = 3
    }
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
    Type = "action",
    Params = {
      npcuid = 1,
      id = 840,
      loop = true
    }
  },
  [23] = {
    id = 23,
    Type = "wait_time",
    Params = {time = 660}
  },
  [24] = {
    id = 24,
    Type = "action",
    Params = {
      npcuid = 2,
      id = 0,
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
Table_PlotQuest_137_fields = {
  "id",
  "Type",
  "Params"
}
return Table_PlotQuest_137
