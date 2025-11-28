Table_PlotQuest_149 = {
  [1] = {
    id = 1,
    Type = "startfilter",
    Params = {
      fliter = {39}
    }
  },
  [2] = {
    id = 2,
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
  [3] = {
    id = 3,
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
      dir = 179.9,
      ignoreNavMesh = 1
    }
  },
  [4] = {
    id = 4,
    Type = "summon",
    Params = {
      npcid = 9348,
      npcuid = 2,
      groupid = 2,
      pos = {
        0.0,
        -1.21,
        1.0
      },
      dir = 0,
      ignoreNavMesh = 1
    }
  },
  [5] = {
    id = 5,
    Type = "wait_time",
    Params = {time = 100}
  },
  [6] = {
    id = 6,
    Type = "summon_mount_npc",
    Params = {
      npcid = 9348,
      npcuid = 2,
      player = 1
    }
  },
  [7] = {
    id = 7,
    Type = "action",
    Params = {
      npcuid = 1,
      id = 840,
      loop = true
    }
  },
  [8] = {
    id = 8,
    Type = "action",
    Params = {
      npcuid = 2,
      id = 822,
      loop = true
    }
  },
  [9] = {
    id = 9,
    Type = "action",
    Params = {
      player = 1,
      id = 100,
      loop = true
    }
  }
}
Table_PlotQuest_149_fields = {
  "id",
  "Type",
  "Params"
}
return Table_PlotQuest_149
