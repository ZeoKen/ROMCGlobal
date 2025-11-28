Table_PlotQuest_180 = {
  [1] = {
    id = 1,
    Type = "startfilter",
    Params = {
      fliter = {39}
    }
  },
  [2] = {
    id = 2,
    Type = "play_effect_ui",
    Params = {path = "BtoW"}
  },
  [3] = {
    id = 3,
    Type = "play_effect_scene",
    Params = {
      id = 1,
      path = "Skill/Eff_Chasing01",
      pos = {
        0,
        0,
        0
      },
      ignoreNavMesh = 1
    }
  },
  [4] = {
    id = 4,
    Type = "summon",
    Params = {
      npcid = 816376,
      npcuid = 1,
      groupid = 1,
      pos = {
        0.8,
        -0.0,
        11.09
      },
      dir = 0,
      ignoreNavMesh = 1
    }
  },
  [5] = {
    id = 5,
    Type = "summon",
    Params = {
      npcid = 9349,
      npcuid = 2,
      groupid = 2,
      pos = {
        0.0,
        -1.8,
        1.0
      },
      dir = 0,
      ignoreNavMesh = 1
    }
  },
  [6] = {
    id = 6,
    Type = "wait_time",
    Params = {time = 100}
  },
  [7] = {
    id = 7,
    Type = "summon_mount_npc",
    Params = {
      npcid = 9349,
      npcuid = 2,
      player = 1
    }
  },
  [8] = {
    id = 8,
    Type = "play_effect",
    Params = {
      path = "Skill/Eff_Chasing_soul01",
      player = 1,
      ep = 3,
      loop = true
    }
  },
  [9] = {
    id = 9,
    Type = "action",
    Params = {
      npcuid = 1,
      id = 840,
      loop = true
    }
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
  }
}
Table_PlotQuest_180_fields = {
  "id",
  "Type",
  "Params"
}
return Table_PlotQuest_180
