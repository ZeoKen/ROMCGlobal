Table_PlotQuest_65 = {
  [1] = {
    id = 1,
    Type = "play_effect_ui",
    Params = {path = "BtoW"}
  },
  [2] = {
    id = 2,
    Type = "startfilter",
    Params = {
      fliter = {39}
    }
  },
  [3] = {
    id = 3,
    Type = "onoff_camerapoint",
    Params = {groupid = 0, on = true}
  },
  [4] = {
    id = 4,
    Type = "showview",
    Params = {panelid = 800, showtype = 1}
  },
  [5] = {
    id = 5,
    Type = "set_dir",
    Params = {player = 1, dir = 180}
  },
  [6] = {
    id = 6,
    Type = "summon",
    Params = {
      npcid = 807647,
      npcuid = 1,
      pos = {
        9.31,
        2.22,
        36.24
      },
      dir = 347.99,
      groupid = 1,
      scale = 2
    }
  },
  [7] = {
    id = 7,
    Type = "summon",
    Params = {
      npcid = 807648,
      npcuid = 2,
      pos = {
        0.7,
        2.29,
        36.76
      },
      dir = 10.98,
      groupid = 1,
      scale = 2
    }
  },
  [8] = {
    id = 8,
    Type = "summon",
    Params = {
      npcid = 807656,
      npcuid = 3,
      pos = {
        3.84,
        2.34,
        42.03
      },
      dir = 147.87,
      groupid = 1,
      scale = 0.6,
      waitaction = "die"
    }
  },
  [9] = {
    id = 9,
    Type = "action",
    Params = {player = 1, id = 8}
  },
  [10] = {
    id = 10,
    Type = "play_effect_scene",
    Params = {
      id = 2,
      path = "Common/BigCatGate",
      pos = {
        4.9,
        2.4,
        41.03
      }
    }
  },
  [11] = {
    id = 11,
    Type = "play_effect_scene",
    Params = {
      id = 1,
      path = "Skill/MentalStrength_buff",
      pos = {
        3.84,
        2.34,
        42.03
      }
    }
  },
  [12] = {
    id = 12,
    Type = "wait_time",
    Params = {time = 500}
  },
  [13] = {
    id = 13,
    Type = "action",
    Params = {player = 1, id = 11}
  },
  [14] = {
    id = 14,
    Type = "wait_time",
    Params = {time = 1000}
  },
  [15] = {
    id = 15,
    Type = "play_effect_scene",
    Params = {
      id = 3,
      path = "Common/Storming",
      pos = {
        4.75,
        2.41,
        40.39
      }
    }
  },
  [16] = {
    id = 16,
    Type = "dialog",
    Params = {
      dialog = {603496}
    }
  },
  [17] = {
    id = 17,
    Type = "addbutton",
    Params = {
      id = 1,
      text = "##298174",
      eventtype = "goon"
    }
  },
  [18] = {
    id = 18,
    Type = "wait_ui",
    Params = {button = 1}
  },
  [19] = {
    id = 19,
    Type = "play_sound",
    Params = {
      path = "Skill/longshen_jinzhongzhao"
    }
  },
  [20] = {
    id = 20,
    Type = "play_effect_scene",
    Params = {
      id = 4,
      path = "Skill/Mechanic_Revolution_atk",
      pos = {
        4.9,
        2.4,
        41.03
      }
    }
  },
  [21] = {
    id = 21,
    Type = "wait_time",
    Params = {time = 3000}
  },
  [22] = {
    id = 22,
    Type = "action",
    Params = {player = 1, id = 21}
  },
  [23] = {
    id = 23,
    Type = "dialog",
    Params = {
      dialog = {603497}
    }
  },
  [24] = {
    id = 24,
    Type = "onoff_camerapoint",
    Params = {groupid = 0, on = false}
  },
  [25] = {
    id = 25,
    Type = "onoff_camerapoint",
    Params = {groupid = 1, on = true}
  },
  [26] = {
    id = 26,
    Type = "wait_time",
    Params = {time = 1000}
  },
  [27] = {
    id = 27,
    Type = "addbutton",
    Params = {
      id = 2,
      text = "##169486",
      eventtype = "goon"
    }
  },
  [28] = {
    id = 28,
    Type = "wait_ui",
    Params = {button = 2}
  },
  [29] = {
    id = 29,
    Type = "set_dir",
    Params = {player = 1, dir = 221}
  },
  [30] = {
    id = 30,
    Type = "action",
    Params = {player = 1, id = 26}
  },
  [31] = {
    id = 31,
    Type = "play_sound",
    Params = {
      path = "Skill/Lightbringer_guangzipao"
    }
  },
  [32] = {
    id = 32,
    Type = "play_effect",
    Params = {
      id = 5,
      path = "Skill/Mechanic_PhotonGun_atk",
      player = 1,
      effectpos = 2
    }
  },
  [33] = {
    id = 33,
    Type = "wait_time",
    Params = {time = 500}
  },
  [34] = {
    id = 34,
    Type = "action",
    Params = {npcuid = 2, id = 7}
  },
  [35] = {
    id = 35,
    Type = "wait_time",
    Params = {time = 500}
  },
  [36] = {
    id = 36,
    Type = "play_sound",
    Params = {
      path = "Skill/OccultImpaction_hit"
    }
  },
  [37] = {
    id = 37,
    Type = "play_effect_scene",
    Params = {
      id = 50,
      path = "Skill/Eff_ArcanCut_atk",
      pos = {
        0.89,
        2.09,
        36.18
      },
      ignoreNavMesh = 1,
      onshot = 1
    }
  },
  [38] = {
    id = 38,
    Type = "remove_npc",
    Params = {npcuid = 2}
  },
  [39] = {
    id = 39,
    Type = "summon",
    Params = {
      npcid = 807648,
      npcuid = 4,
      pos = {
        -0.07,
        2.27,
        34.62
      },
      dir = 207.72,
      groupid = 1,
      scale = 2,
      waitaction = "die"
    }
  },
  [40] = {
    id = 40,
    Type = "wait_time",
    Params = {time = 1000}
  },
  [41] = {
    id = 41,
    Type = "addbutton",
    Params = {
      id = 3,
      text = "##169486",
      eventtype = "goon"
    }
  },
  [42] = {
    id = 42,
    Type = "wait_ui",
    Params = {button = 3}
  },
  [43] = {
    id = 43,
    Type = "set_dir",
    Params = {player = 1, dir = 140}
  },
  [44] = {
    id = 44,
    Type = "action",
    Params = {player = 1, id = 26}
  },
  [45] = {
    id = 45,
    Type = "play_sound",
    Params = {
      path = "Skill/Lightbringer_guangzipao"
    }
  },
  [46] = {
    id = 46,
    Type = "play_effect",
    Params = {
      id = 7,
      path = "Skill/Mechanic_PhotonGun_atk",
      player = 1,
      effectpos = 2
    }
  },
  [47] = {
    id = 47,
    Type = "wait_time",
    Params = {time = 500}
  },
  [48] = {
    id = 48,
    Type = "action",
    Params = {npcuid = 1, id = 7}
  },
  [49] = {
    id = 49,
    Type = "wait_time",
    Params = {time = 500}
  },
  [50] = {
    id = 50,
    Type = "play_sound",
    Params = {
      path = "Skill/OccultImpaction_hit"
    }
  },
  [51] = {
    id = 51,
    Type = "play_effect_scene",
    Params = {
      id = 50,
      path = "Skill/Eff_ArcanCut_atk",
      pos = {
        9.07,
        2.09,
        35.84
      },
      ignoreNavMesh = 1,
      onshot = 1
    }
  },
  [52] = {
    id = 52,
    Type = "remove_npc",
    Params = {npcuid = 1}
  },
  [53] = {
    id = 53,
    Type = "summon",
    Params = {
      npcid = 807647,
      npcuid = 5,
      pos = {
        7.61,
        2.28,
        37.34
      },
      dir = 347,
      groupid = 1,
      scale = 2,
      waitaction = "die"
    }
  },
  [54] = {
    id = 54,
    Type = "wait_time",
    Params = {time = 2000}
  },
  [55] = {
    id = 55,
    Type = "set_dir",
    Params = {player = 1, dir = 180}
  },
  [56] = {
    id = 56,
    Type = "wait_time",
    Params = {time = 500}
  },
  [57] = {
    id = 57,
    Type = "action",
    Params = {player = 1, id = 9}
  },
  [58] = {
    id = 58,
    Type = "play_effect_scene",
    Params = {
      id = 9,
      path = "Skill/Eff_ShelterValhala_atk",
      pos = {
        4.9,
        2.4,
        41.03
      },
      onshot = 1
    }
  },
  [59] = {
    id = 59,
    Type = "wait_time",
    Params = {time = 1500}
  },
  [60] = {
    id = 60,
    Type = "showview",
    Params = {panelid = 800, showtype = 2}
  },
  [61] = {
    id = 61,
    Type = "endfilter",
    Params = {
      fliter = {39}
    }
  },
  [62] = {
    id = 62,
    Type = "onoff_camerapoint",
    Params = {
      groupid = 1,
      on = false,
      returnDefaultTime = 1500
    }
  }
}
Table_PlotQuest_65_fields = {
  "id",
  "Type",
  "Params"
}
return Table_PlotQuest_65
