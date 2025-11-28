Table_PlotQuest_164 = {
  [1] = {
    id = 1,
    Type = "action",
    Params = {npcuid = 1, id = 850}
  },
  [2] = {
    id = 2,
    Type = "action",
    Params = {player = 1, id = 827}
  },
  [3] = {
    id = 3,
    Type = "action",
    Params = {
      npcuid = 2,
      id = 827,
      pos = {
        2.6,
        -1.8,
        1.57
      },
      time = 1550
    }
  },
  [4] = {
    id = 4,
    Type = "wait_time",
    Params = {time = 600}
  },
  [5] = {
    id = 5,
    Type = "play_effect_scene",
    Params = {
      id = 4,
      path = "Skill/Eff_chase_Puddle_hit",
      pos = {
        0.0,
        -1.8,
        1.0
      },
      ignoreNavMesh = 1
    }
  },
  [6] = {
    id = 6,
    Type = "wait_time",
    Params = {time = 600}
  },
  [7] = {
    id = 7,
    Type = "remove_effect_scene",
    Params = {id = 3}
  },
  [8] = {
    id = 8,
    Type = "remove_effect_scene",
    Params = {id = 4}
  },
  [9] = {
    id = 9,
    Type = "wait_time",
    Params = {time = 350}
  },
  [10] = {
    id = 10,
    Type = "action",
    Params = {
      npcuid = 2,
      id = 0,
      loop = true
    }
  },
  [11] = {
    id = 11,
    Type = "action",
    Params = {
      player = 1,
      id = 101,
      loop = true
    }
  },
  [12] = {
    id = 12,
    Type = "wait_time",
    Params = {time = 350}
  },
  [13] = {
    id = 13,
    Type = "action",
    Params = {
      npcuid = 1,
      id = 0,
      loop = true
    }
  }
}
Table_PlotQuest_164_fields = {
  "id",
  "Type",
  "Params"
}
return Table_PlotQuest_164
