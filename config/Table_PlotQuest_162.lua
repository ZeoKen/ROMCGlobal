Table_PlotQuest_162 = {
  [1] = {
    id = 1,
    Type = "action",
    Params = {npcuid = 1, id = 850}
  },
  [2] = {
    id = 2,
    Type = "wait_time",
    Params = {time = 600}
  },
  [3] = {
    id = 3,
    Type = "play_effect_scene",
    Params = {
      id = 4,
      path = "Skill/Eff_chase_Puddle_hit",
      pos = {
        -3.07,
        -1.8,
        0.93
      },
      ignoreNavMesh = 1
    }
  },
  [4] = {
    id = 4,
    Type = "play_effect",
    Params = {
      path = "Skill/Eff_chase_WaterBomb_hit",
      player = 1,
      ep = 7
    }
  },
  [5] = {
    id = 5,
    Type = "play_effect",
    Params = {
      path = "Skill/Eff_chase_WaterBomb_hit",
      npcuid = 2,
      ep = 3
    }
  },
  [6] = {
    id = 6,
    Type = "shakescreen",
    Params = {amplitude = 20, time = 600}
  },
  [7] = {
    id = 7,
    Type = "action",
    Params = {player = 1, id = 838}
  },
  [8] = {
    id = 8,
    Type = "action",
    Params = {npcuid = 2, id = 5}
  },
  [9] = {
    id = 9,
    Type = "wait_time",
    Params = {time = 600}
  },
  [10] = {
    id = 10,
    Type = "remove_effect",
    Params = {
      path = "Skill/Eff_chase_WaterBomb_hit",
      player = 1,
      ep = 7
    }
  },
  [11] = {
    id = 11,
    Type = "remove_effect",
    Params = {
      path = "Skill/Eff_chase_WaterBomb_hit",
      npcuid = 2,
      ep = 3
    }
  },
  [12] = {
    id = 12,
    Type = "remove_effect_scene",
    Params = {id = 3}
  },
  [13] = {
    id = 13,
    Type = "remove_effect_scene",
    Params = {id = 4}
  },
  [14] = {
    id = 14,
    Type = "action",
    Params = {
      npcuid = 2,
      id = 0,
      loop = true
    }
  },
  [15] = {
    id = 15,
    Type = "action",
    Params = {
      player = 1,
      id = 101,
      loop = true
    }
  },
  [16] = {
    id = 16,
    Type = "wait_time",
    Params = {time = 700}
  },
  [17] = {
    id = 17,
    Type = "action",
    Params = {
      npcuid = 1,
      id = 0,
      loop = true
    }
  }
}
Table_PlotQuest_162_fields = {
  "id",
  "Type",
  "Params"
}
return Table_PlotQuest_162
