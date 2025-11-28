Table_PlotQuest_157 = {
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
        tag = {
          -5.53,
          -1.19,
          -3.69
        },
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
    Type = "action",
    Params = {player = 1, id = 827}
  },
  [7] = {
    id = 7,
    Type = "action",
    Params = {
      npcuid = 2,
      id = 827,
      pos = {
        0.0,
        -1.8,
        1.0
      },
      time = 1550
    }
  },
  [8] = {
    id = 8,
    Type = "wait_time",
    Params = {time = 500}
  },
  [9] = {
    id = 9,
    Type = "remove_effect",
    Params = {
      path = "Skill/Eff_chase_WaterBomb_bullet",
      npcuid = 1,
      ep = 4,
      toEp = {
        tag = {
          -5.53,
          -1.19,
          -3.69
        },
        time = 1000
      },
      loop = true
    }
  },
  [10] = {
    id = 10,
    Type = "wait_time",
    Params = {time = 500}
  },
  [11] = {
    id = 11,
    Type = "action",
    Params = {
      npcuid = 1,
      id = 0,
      loop = true
    }
  },
  [12] = {
    id = 12,
    Type = "wait_time",
    Params = {time = 550}
  },
  [13] = {
    id = 13,
    Type = "action",
    Params = {
      npcuid = 2,
      id = 0,
      loop = true
    }
  },
  [14] = {
    id = 14,
    Type = "action",
    Params = {
      player = 1,
      id = 101,
      loop = true
    }
  }
}
Table_PlotQuest_157_fields = {
  "id",
  "Type",
  "Params"
}
return Table_PlotQuest_157
