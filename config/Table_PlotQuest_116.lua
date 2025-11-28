Table_PlotQuest_116 = {
  [1] = {
    id = 1,
    Type = "showview",
    Params = {panelid = 800, showtype = 1}
  },
  [2] = {
    id = 2,
    Type = "startfilter",
    Params = {
      fliter = {7}
    }
  },
  [3] = {
    id = 3,
    Type = "summon",
    Params = {
      npcid = 816445,
      npcuid = 816445,
      pos = {
        -108.03,
        15.19,
        1.59
      },
      dir = 92,
      groupid = 1,
      ignoreNavMesh = 1
    }
  },
  [4] = {
    id = 4,
    Type = "set_dir",
    Params = {player = 1, dir = 93}
  },
  [5] = {
    id = 5,
    Type = "wait_time",
    Params = {time = 3000}
  },
  [6] = {
    id = 6,
    Type = "action",
    Params = {player = 1, id = 9}
  },
  [7] = {
    id = 7,
    Type = "action",
    Params = {npcuid = 816445, id = 9}
  },
  [8] = {
    id = 8,
    Type = "wait_time",
    Params = {time = 7000}
  },
  [9] = {
    id = 9,
    Type = "remove_npc",
    Params = {npcuid = 816445}
  },
  [10] = {
    id = 10,
    Type = "showview",
    Params = {panelid = 800, showtype = 2}
  },
  [11] = {
    id = 11,
    Type = "endfilter",
    Params = {
      fliter = {7}
    }
  }
}
Table_PlotQuest_116_fields = {
  "id",
  "Type",
  "Params"
}
return Table_PlotQuest_116
