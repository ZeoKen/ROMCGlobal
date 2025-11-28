Table_PlotQuest_178 = {
  [1] = {
    id = 1,
    Type = "action",
    Params = {
      player = 1,
      id = 831,
      loop = true
    }
  },
  [2] = {
    id = 2,
    Type = "action",
    Params = {
      npcuid = 2,
      id = 821,
      loop = true
    }
  },
  [3] = {
    id = 3,
    Type = "play_effect",
    Params = {
      path = "Skill/Eff_chase_quicken",
      npcuid = 2,
      ep = 6,
      loop = true
    }
  },
  [4] = {
    id = 4,
    Type = "action",
    Params = {npcuid = 1, id = 845}
  },
  [5] = {
    id = 5,
    Type = "wait_time",
    Params = {time = 300}
  },
  [6] = {
    id = 6,
    Type = "change_uv_speed",
    Params = {
      id = 98,
      path = "Skill/Eff_Chasing03",
      pos = {
        0,
        0,
        0
      },
      ignoreNavMesh = 1,
      meshName = "shikongsuodaoda21",
      speed = 0.32
    }
  },
  [7] = {
    id = 7,
    Type = "change_uv_speed",
    Params = {
      id = 98,
      path = "Skill/Eff_Chasing03",
      pos = {
        0,
        0,
        0
      },
      ignoreNavMesh = 1,
      meshName = "shikongsuodaoda22",
      speed = 0.4
    }
  },
  [8] = {
    id = 8,
    Type = "wait_time",
    Params = {time = 650}
  },
  [9] = {
    id = 9,
    Type = "action",
    Params = {
      npcuid = 1,
      id = 822,
      loop = true
    }
  },
  [10] = {
    id = 10,
    Type = "change_uv_speed",
    Params = {
      id = 98,
      path = "Skill/Eff_Chasing03",
      pos = {
        0,
        0,
        0
      },
      ignoreNavMesh = 1,
      meshName = "shikongsuodaoda22",
      speed = 0.48
    }
  },
  [11] = {
    id = 11,
    Type = "change_uv_speed",
    Params = {
      id = 98,
      path = "Skill/Eff_Chasing03",
      pos = {
        0,
        0,
        0
      },
      ignoreNavMesh = 1,
      meshName = "shikongsuodaoda22",
      speed = 0.6
    }
  },
  [12] = {
    id = 12,
    Type = "wait_time",
    Params = {time = 500}
  },
  [13] = {
    id = 13,
    Type = "change_uv_speed",
    Params = {
      id = 98,
      path = "Skill/Eff_Chasing03",
      pos = {
        0,
        0,
        0
      },
      ignoreNavMesh = 1,
      meshName = "shikongsuodaoda22",
      speed = 0.64
    }
  },
  [14] = {
    id = 14,
    Type = "change_uv_speed",
    Params = {
      id = 98,
      path = "Skill/Eff_Chasing03",
      pos = {
        0,
        0,
        0
      },
      ignoreNavMesh = 1,
      meshName = "shikongsuodaoda22",
      speed = 0.8
    }
  },
  [15] = {
    id = 15,
    Type = "action",
    Params = {
      npcuid = 1,
      id = 823,
      loop = true
    }
  },
  [16] = {
    id = 16,
    Type = "play_effect",
    Params = {
      path = "Skill/Eff_chase_quicken",
      npcuid = 1,
      ep = 2,
      loop = true
    }
  },
  [17] = {
    id = 17,
    Type = "play_effect_scene",
    Params = {
      id = 99,
      path = "Skill/Eff_Chasing04",
      pos = {
        0,
        0,
        0
      },
      ignoreNavMesh = 1
    }
  },
  [18] = {
    id = 18,
    Type = "wait_time",
    Params = {time = 500}
  }
}
Table_PlotQuest_178_fields = {
  "id",
  "Type",
  "Params"
}
return Table_PlotQuest_178
