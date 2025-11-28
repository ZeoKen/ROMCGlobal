Table_PlotQuest_153 = {
  [1] = {
    id = 1,
    Type = "action",
    Params = {npcuid = 1, id = 842}
  },
  [2] = {
    id = 2,
    Type = "wait_time",
    Params = {time = 500}
  },
  [3] = {
    id = 3,
    Type = "remove_effect",
    Params = {
      path = "Skill/Eff_chase_WaterBomb_bullet",
      npcuid = 1,
      ep = 4,
      loop = true
    }
  },
  [4] = {
    id = 4,
    Type = "play_effect",
    Params = {
      path = "Skill/Eff_chase_WaterBomb_bullet",
      npcuid = 1,
      ep = 4,
      toEp = {
        me = 1,
        ep = 6,
        time = 1000
      },
      loop = true
    }
  },
  [5] = {
    id = 5,
    Type = "wait_time",
    Params = {time = 500}
  },
  [6] = {
    id = 6,
    Type = "wait_time",
    Params = {time = 500}
  },
  [7] = {
    id = 7,
    Type = "play_effect",
    Params = {
      path = "Skill/Eff_chase_WaterBomb_hit",
      player = 1,
      ep = 7
    }
  },
  [8] = {
    id = 8,
    Type = "play_effect",
    Params = {
      path = "Skill/Eff_chase_WaterBomb_hit",
      npcuid = 2,
      ep = 3
    }
  },
  [9] = {
    id = 9,
    Type = "remove_effect",
    Params = {
      path = "Skill/Eff_chase_WaterBomb_bullet",
      npcuid = 1,
      ep = 4,
      toEp = {
        me = 1,
        ep = 6,
        time = 1000
      },
      loop = true
    }
  },
  [10] = {
    id = 10,
    Type = "shakescreen",
    Params = {amplitude = 20, time = 600}
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
    Type = "wait_time",
    Params = {time = 500}
  },
  [14] = {
    id = 14,
    Type = "action",
    Params = {
      npcuid = 1,
      id = 0,
      loop = true
    }
  },
  [15] = {
    id = 15,
    Type = "wait_time",
    Params = {time = 100}
  },
  [16] = {
    id = 16,
    Type = "remove_effect",
    Params = {
      path = "Skill/Eff_chase_WaterBomb_hit",
      player = 1,
      ep = 7
    }
  },
  [17] = {
    id = 17,
    Type = "remove_effect",
    Params = {
      path = "Skill/Eff_chase_WaterBomb_hit",
      npcuid = 2,
      ep = 3
    }
  },
  [18] = {
    id = 18,
    Type = "action",
    Params = {
      npcuid = 2,
      id = 0,
      loop = true
    }
  },
  [19] = {
    id = 19,
    Type = "action",
    Params = {
      player = 1,
      id = 101,
      loop = true
    }
  }
}
Table_PlotQuest_153_fields = {
  "id",
  "Type",
  "Params"
}
return Table_PlotQuest_153
