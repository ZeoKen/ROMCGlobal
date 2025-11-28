Table_PlotQuest_24 = {
  [1] = {
    id = 1,
    Type = "play_effect_ui",
    Params = {path = "BtoW"}
  },
  [2] = {
    id = 2,
    Type = "startfilter",
    Params = {
      fliter = {22}
    }
  },
  [3] = {
    id = 3,
    Type = "wait_time",
    Params = {time = 1000}
  },
  [4] = {
    id = 4,
    Type = "onoff_camerapoint",
    Params = {groupid = 0, on = true}
  },
  [5] = {
    id = 5,
    Type = "addbutton",
    Params = {
      id = 1,
      text = "##298171",
      eventtype = "goon"
    }
  },
  [6] = {
    id = 6,
    Type = "wait_ui",
    Params = {button = 1}
  },
  [7] = {
    id = 7,
    Type = "play_sound",
    Params = {
      path = "Skill/Detoxify"
    }
  },
  [8] = {
    id = 8,
    Type = "play_effect_scene",
    Params = {
      id = 79,
      path = "Skill/Chepet_FlameCircle6",
      pos = {
        -14.38,
        1.0,
        0.98
      },
      onshot = 1,
      ignoreNavMesh = 1
    }
  },
  [9] = {
    id = 9,
    Type = "summon",
    Params = {
      npcid = 802104,
      npcuid = 802104,
      groupid = 1,
      dir = 270,
      pos = {
        -16.8,
        1.63,
        1.11
      },
      ignoreNavMesh = 1
    }
  },
  [10] = {
    id = 10,
    Type = "action",
    Params = {npcuid = 802104, id = 200}
  },
  [11] = {
    id = 11,
    Type = "wait_time",
    Params = {time = 2000}
  },
  [12] = {
    id = 12,
    Type = "summon",
    Params = {
      npcid = 802150,
      npcuid = 802150,
      groupid = 1,
      dir = 270,
      pos = {
        -16.8,
        1.63,
        1.11
      },
      ignoreNavMesh = 1
    }
  },
  [13] = {
    id = 13,
    Type = "action",
    Params = {npcuid = 802150, id = 200}
  },
  [14] = {
    id = 14,
    Type = "wait_time",
    Params = {time = 2500}
  },
  [15] = {
    id = 15,
    Type = "play_effect",
    Params = {
      path = "Common/79smog",
      npcuid = 802104
    }
  },
  [16] = {
    id = 16,
    Type = "remove_npc",
    Params = {npcuid = 802104}
  },
  [17] = {
    id = 17,
    Type = "summon",
    Params = {
      npcid = 802151,
      npcuid = 802151,
      groupid = 1,
      dir = 270,
      pos = {
        -16.8,
        1.63,
        1.11
      },
      ignoreNavMesh = 1
    }
  },
  [18] = {
    id = 18,
    Type = "action",
    Params = {npcuid = 802151, id = 200}
  },
  [19] = {
    id = 19,
    Type = "wait_time",
    Params = {time = 2500}
  },
  [20] = {
    id = 20,
    Type = "play_effect",
    Params = {
      path = "Common/79smog",
      npcuid = 802150
    }
  },
  [21] = {
    id = 21,
    Type = "remove_npc",
    Params = {npcuid = 802150}
  },
  [22] = {
    id = 22,
    Type = "summon",
    Params = {
      npcid = 802152,
      npcuid = 802152,
      groupid = 1,
      dir = 270,
      pos = {
        -16.8,
        1.63,
        1.11
      },
      ignoreNavMesh = 1
    }
  },
  [23] = {
    id = 23,
    Type = "action",
    Params = {npcuid = 802152, id = 200}
  },
  [24] = {
    id = 24,
    Type = "wait_time",
    Params = {time = 2500}
  },
  [25] = {
    id = 25,
    Type = "play_effect",
    Params = {
      path = "Common/79smog",
      npcuid = 802151
    }
  },
  [26] = {
    id = 26,
    Type = "remove_npc",
    Params = {npcuid = 802151}
  },
  [27] = {
    id = 27,
    Type = "summon",
    Params = {
      npcid = 802153,
      npcuid = 802153,
      groupid = 1,
      dir = 270,
      pos = {
        -16.8,
        1.63,
        1.11
      },
      ignoreNavMesh = 1
    }
  },
  [28] = {
    id = 28,
    Type = "action",
    Params = {npcuid = 802153, id = 200}
  },
  [29] = {
    id = 29,
    Type = "wait_time",
    Params = {time = 2500}
  },
  [30] = {
    id = 30,
    Type = "play_effect",
    Params = {
      path = "Common/79smog",
      npcuid = 802152
    }
  },
  [31] = {
    id = 31,
    Type = "remove_npc",
    Params = {npcuid = 802152}
  },
  [32] = {
    id = 32,
    Type = "wait_time",
    Params = {time = 2500}
  },
  [33] = {
    id = 33,
    Type = "play_effect",
    Params = {
      path = "Common/79smog",
      npcuid = 802153
    }
  },
  [34] = {
    id = 34,
    Type = "remove_npc",
    Params = {npcuid = 802153}
  },
  [35] = {
    id = 35,
    Type = "onoff_camerapoint",
    Params = {
      groupid = 0,
      on = false,
      returnDefaultTime = 1500
    }
  },
  [36] = {
    id = 36,
    Type = "endfilter",
    Params = {
      fliter = {22}
    }
  },
  [37] = {
    id = 37,
    Type = "wait_time",
    Params = {time = 1500}
  }
}
Table_PlotQuest_24_fields = {
  "id",
  "Type",
  "Params"
}
return Table_PlotQuest_24
