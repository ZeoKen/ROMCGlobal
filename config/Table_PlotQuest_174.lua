Table_PlotQuest_174 = {
  [1] = {
    id = 1,
    Type = "wait_time",
    Params = {time = 500}
  },
  [2] = {
    id = 2,
    Type = "change_uv_speed",
    Params = {
      id = 1,
      path = "Skill/Eff_Chasing01",
      pos = {
        0,
        0,
        0
      },
      ignoreNavMesh = 1,
      meshName = "shikongsuodaoda11",
      speed = 0.6
    }
  },
  [3] = {
    id = 3,
    Type = "change_uv_speed",
    Params = {
      id = 1,
      path = "Skill/Eff_Chasing01",
      pos = {
        0,
        0,
        0
      },
      ignoreNavMesh = 1,
      meshName = "shikongsuodaoda12",
      speed = 0.39
    }
  },
  [4] = {
    id = 4,
    Type = "change_uv_speed",
    Params = {
      id = 1,
      path = "Skill/Eff_Chasing01",
      pos = {
        0,
        0,
        0
      },
      ignoreNavMesh = 1,
      meshName = "shikongsuodaoda13",
      speed = 0.06
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
      path = "Skill/Eff_chase_quicken",
      npcuid = 2,
      ep = 6,
      loop = true
    }
  },
  [7] = {
    id = 7,
    Type = "remove_effect",
    Params = {
      path = "Skill/Eff_chase_quicken",
      npcuid = 1,
      ep = 2,
      loop = true
    }
  },
  [8] = {
    id = 8,
    Type = "change_uv_speed",
    Params = {
      id = 1,
      path = "Skill/Eff_Chasing01",
      pos = {
        0,
        0,
        0
      },
      ignoreNavMesh = 1,
      meshName = "shikongsuodaoda11",
      speed = 0.4
    }
  },
  [9] = {
    id = 9,
    Type = "change_uv_speed",
    Params = {
      id = 1,
      path = "Skill/Eff_Chasing01",
      pos = {
        0,
        0,
        0
      },
      ignoreNavMesh = 1,
      meshName = "shikongsuodaoda12",
      speed = 0.26
    }
  },
  [10] = {
    id = 10,
    Type = "change_uv_speed",
    Params = {
      id = 1,
      path = "Skill/Eff_Chasing01",
      pos = {
        0,
        0,
        0
      },
      ignoreNavMesh = 1,
      meshName = "shikongsuodaoda13",
      speed = 0.04
    }
  },
  [11] = {
    id = 11,
    Type = "wait_time",
    Params = {time = 600}
  },
  [12] = {
    id = 12,
    Type = "change_uv_speed",
    Params = {
      id = 1,
      path = "Skill/Eff_Chasing01",
      pos = {
        0,
        0,
        0
      },
      ignoreNavMesh = 1,
      meshName = "shikongsuodaoda11",
      speed = 0.2
    }
  },
  [13] = {
    id = 13,
    Type = "change_uv_speed",
    Params = {
      id = 1,
      path = "Skill/Eff_Chasing01",
      pos = {
        0,
        0,
        0
      },
      ignoreNavMesh = 1,
      meshName = "shikongsuodaoda12",
      speed = 0.13
    }
  },
  [14] = {
    id = 14,
    Type = "change_uv_speed",
    Params = {
      id = 1,
      path = "Skill/Eff_Chasing01",
      pos = {
        0,
        0,
        0
      },
      ignoreNavMesh = 1,
      meshName = "shikongsuodaoda13",
      speed = 0.02
    }
  },
  [15] = {
    id = 15,
    Type = "wait_time",
    Params = {time = 600}
  },
  [16] = {
    id = 16,
    Type = "remove_effect_scene",
    Params = {id = 99}
  },
  [17] = {
    id = 17,
    Type = "action",
    Params = {
      npcuid = 2,
      id = 0,
      loop = true
    }
  },
  [18] = {
    id = 18,
    Type = "action",
    Params = {
      player = 1,
      id = 101,
      loop = true
    }
  },
  [19] = {
    id = 19,
    Type = "action",
    Params = {
      npcuid = 1,
      id = 822,
      loop = true
    }
  },
  [20] = {
    id = 20,
    Type = "wait_time",
    Params = {time = 500}
  },
  [21] = {
    id = 21,
    Type = "action",
    Params = {npcuid = 1, id = 839}
  },
  [22] = {
    id = 22,
    Type = "wait_time",
    Params = {time = 1100}
  },
  [23] = {
    id = 23,
    Type = "emoji",
    Params = {npcuid = 1, id = 7}
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
Table_PlotQuest_174_fields = {
  "id",
  "Type",
  "Params"
}
return Table_PlotQuest_174
