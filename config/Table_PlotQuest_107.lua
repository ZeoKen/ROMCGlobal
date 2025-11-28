Table_PlotQuest_107 = {
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
      npcid = 808362,
      npcuid = 808362,
      pos = {
        0.12,
        1.84,
        -8.79
      },
      dir = 182,
      groupid = 1,
      ignoreNavMesh = 1,
      waitaction = "walk"
    }
  },
  [4] = {
    id = 4,
    Type = "move",
    Params = {
      player = 1,
      pos = {
        0.04,
        3.45,
        -4.53
      },
      spd = 1,
      dir = 179.6842
    }
  },
  [5] = {
    id = 5,
    Type = "set_dir",
    Params = {player = 1, dir = 179.6842}
  },
  [6] = {
    id = 6,
    Type = "play_sound",
    Params = {
      path = "Common/wataru_zhuanzhi3"
    }
  },
  [7] = {
    id = 7,
    Type = "wait_time",
    Params = {time = 1400}
  },
  [8] = {
    id = 8,
    Type = "play_sound",
    Params = {
      path = "Common/wataru_zhuanzhi5"
    }
  },
  [9] = {
    id = 9,
    Type = "action",
    Params = {
      player = 1,
      id = 200,
      loop = true
    }
  },
  [10] = {
    id = 10,
    Type = "action",
    Params = {npcuid = 808362, id = 766}
  },
  [11] = {
    id = 11,
    Type = "play_effect_scene",
    Params = {
      id = 21,
      path = "Skill/Eff_nvshenchuchang",
      pos = {
        0.15,
        -3.56,
        -12.54
      },
      onshot = 1,
      ignoreNavMesh = 1
    }
  },
  [12] = {
    id = 12,
    Type = "wait_time",
    Params = {time = 500}
  },
  [13] = {
    id = 13,
    Type = "play_sound",
    Params = {
      path = "Common/wataru_zhuanzhi4"
    }
  },
  [14] = {
    id = 14,
    Type = "play_effect_scene",
    Params = {
      id = 1,
      path = "Skill/Eff_Ryujinmaru_longquan_atk",
      pos = {
        1.5,
        2.7,
        -8.94
      },
      onshot = 1,
      ignoreNavMesh = 1
    }
  },
  [15] = {
    id = 15,
    Type = "play_effect_scene",
    Params = {
      id = 2,
      path = "Skill/Eff_Ryujinmaru_longquan_atk",
      pos = {
        -0.18,
        3.01,
        -8.34
      },
      onshot = 1,
      ignoreNavMesh = 1
    }
  },
  [16] = {
    id = 16,
    Type = "play_effect_scene",
    Params = {
      id = 3,
      path = "Skill/Eff_Ryujinmaru_longquan_atk",
      pos = {
        -0.87,
        2.9,
        -10.26
      },
      onshot = 1,
      ignoreNavMesh = 1
    }
  },
  [17] = {
    id = 17,
    Type = "play_sound",
    Params = {
      path = "Common/wataru_zhuanzhi2"
    }
  },
  [18] = {
    id = 18,
    Type = "action",
    Params = {npcuid = 808362, id = 730}
  },
  [19] = {
    id = 19,
    Type = "wait_time",
    Params = {time = 600}
  },
  [20] = {
    id = 20,
    Type = "play_effect_scene",
    Params = {
      id = 7,
      path = "Skill/Eff_Luoyang_bird_03",
      pos = {
        0.19,
        -2.69,
        -9.17
      },
      onshot = 1,
      ignoreNavMesh = 1
    }
  },
  [21] = {
    id = 21,
    Type = "play_effect_scene",
    Params = {
      id = 20,
      path = "Skill/Eff_Ryujinmaru_longlei_atk",
      pos = {
        0.03,
        2.09,
        -9.38
      },
      onshot = 1,
      ignoreNavMesh = 1
    }
  },
  [22] = {
    id = 22,
    Type = "wait_time",
    Params = {time = 1800}
  },
  [23] = {
    id = 23,
    Type = "play_sound",
    Params = {
      path = "Common/wataru_zhuanzhi6"
    }
  },
  [24] = {
    id = 24,
    Type = "remove_npc",
    Params = {npcuid = 808362}
  },
  [25] = {
    id = 25,
    Type = "wait_time",
    Params = {time = 500}
  },
  [26] = {
    id = 26,
    Type = "addbutton",
    Params = {
      id = 1,
      text = "##309146",
      eventtype = "goon"
    }
  },
  [27] = {
    id = 27,
    Type = "wait_ui",
    Params = {button = 1}
  },
  [28] = {
    id = 28,
    Type = "play_sound",
    Params = {
      path = "Common/wataru_zhuanzhi7"
    }
  },
  [29] = {
    id = 29,
    Type = "play_effect",
    Params = {
      id = 8,
      path = "Skill/Eff_Ryujinmaru_shine",
      player = 1,
      effectpos = 2
    }
  },
  [30] = {
    id = 30,
    Type = "play_effect_scene",
    Params = {
      id = 9,
      path = "Skill/Eff_Ryujinmaru_UpwardDrift",
      pos = {
        -0.13,
        1.35,
        -4.26
      },
      ignoreNavMesh = 1
    }
  },
  [31] = {
    id = 31,
    Type = "wait_time",
    Params = {time = 1000}
  },
  [32] = {
    id = 32,
    Type = "addbutton",
    Params = {
      id = 2,
      text = "##309145",
      eventtype = "goon"
    }
  },
  [33] = {
    id = 33,
    Type = "wait_ui",
    Params = {button = 2}
  },
  [34] = {
    id = 34,
    Type = "play_sound",
    Params = {
      path = "Skill/Arcane_kuangfengzhiren"
    }
  },
  [35] = {
    id = 35,
    Type = "action",
    Params = {
      player = 1,
      id = 730,
      time = 999000
    }
  },
  [36] = {
    id = 36,
    Type = "wait_time",
    Params = {time = 1000}
  },
  [37] = {
    id = 37,
    Type = "play_sound",
    Params = {
      path = "Common/wataru_zhuanzhi4"
    }
  },
  [38] = {
    id = 38,
    Type = "play_effect_scene",
    Params = {
      id = 10,
      path = "Skill/Eff_Ryujinmaru_dan_atk",
      pos = {
        0.18,
        1.82,
        -8.46
      },
      onshot = 1,
      ignoreNavMesh = 1
    }
  },
  [39] = {
    id = 39,
    Type = "play_effect_scene",
    Params = {
      id = 11,
      path = "Skill/Eff_Ryujinmaru_fenghuang_buff",
      pos = {
        0.2,
        2.1,
        -13.64
      },
      ignoreNavMesh = 1
    }
  },
  [40] = {
    id = 40,
    Type = "wait_time",
    Params = {time = 1000}
  },
  [41] = {
    id = 41,
    Type = "play_sound",
    Params = {
      path = "Common/wataru_zhuanzhi4"
    }
  },
  [42] = {
    id = 42,
    Type = "play_effect_scene",
    Params = {
      id = 15,
      path = "Skill/Eff_Ryujinmaru_UpwardDrift",
      pos = {
        0.09,
        1.45,
        -10.33
      },
      ignoreNavMesh = 1
    }
  },
  [43] = {
    id = 43,
    Type = "play_effect_scene",
    Params = {
      id = 16,
      path = "Skill/Eff_Ryujinmaru_UpwardDrift",
      pos = {
        -0.12,
        0.8,
        -12.93
      },
      ignoreNavMesh = 1
    }
  },
  [44] = {
    id = 44,
    Type = "play_effect_scene",
    Params = {
      id = 12,
      path = "Skill/Eff_Ryujinmaru_dan_atk",
      pos = {
        0.18,
        1.82,
        -8.46
      },
      onshot = 1,
      ignoreNavMesh = 1
    }
  },
  [45] = {
    id = 45,
    Type = "play_effect_scene",
    Params = {
      id = 13,
      path = "Skill/Eff_Ryujinmaru_fenghuang_buff",
      pos = {
        0.07,
        1.0,
        -12.21
      },
      ignoreNavMesh = 1
    }
  },
  [46] = {
    id = 46,
    Type = "play_effect_scene",
    Params = {
      id = 23,
      path = "Skill/Eff_Ryujinmaru_longya_bullet",
      pos = {
        0.07,
        2.12,
        -12.35
      },
      onshot = 1,
      ignoreNavMesh = 1
    }
  },
  [47] = {
    id = 47,
    Type = "wait_time",
    Params = {time = 800}
  },
  [48] = {
    id = 48,
    Type = "addbutton",
    Params = {
      id = 3,
      text = "##297334",
      eventtype = "goon"
    }
  },
  [49] = {
    id = 49,
    Type = "wait_ui",
    Params = {button = 3}
  },
  [50] = {
    id = 50,
    Type = "play_effect_scene",
    Params = {
      id = 14,
      path = "Skill/Eff_Ryujinmaru_control_buff_01",
      pos = {
        -0.41,
        1.92,
        -12.77
      },
      onshot = 1,
      ignoreNavMesh = 1
    }
  },
  [51] = {
    id = 51,
    Type = "play_sound",
    Params = {
      path = "Common/wataru_zhuanzhi1"
    }
  },
  [52] = {
    id = 52,
    Type = "wait_time",
    Params = {time = 200}
  },
  [53] = {
    id = 53,
    Type = "action",
    Params = {
      player = 1,
      id = 500,
      time = 999000
    }
  },
  [54] = {
    id = 54,
    Type = "wait_time",
    Params = {time = 1000}
  },
  [55] = {
    id = 55,
    Type = "play_effect_scene",
    Params = {
      id = 24,
      path = "Skill/Eff_Ryujinmaru_longwang_buff_01",
      pos = {
        -0.21,
        1.75,
        -12.92
      },
      onshot = 1,
      ignoreNavMesh = 1
    }
  },
  [56] = {
    id = 56,
    Type = "play_sound",
    Params = {
      path = "Common/wataru_zhuanzhi7"
    }
  },
  [57] = {
    id = 57,
    Type = "play_effect_scene",
    Params = {
      id = 25,
      path = "Skill/Eff_Ryujinmaru_surround",
      pos = {
        0.05,
        4.57,
        -5.01
      },
      onshot = 1,
      ignoreNavMesh = 1
    }
  },
  [58] = {
    id = 58,
    Type = "play_sound",
    Params = {
      path = "Common/wataru_zhuanzhi9"
    }
  },
  [59] = {
    id = 59,
    Type = "wait_time",
    Params = {time = 2500}
  },
  [60] = {
    id = 60,
    Type = "endfilter",
    Params = {
      fliter = {7}
    }
  }
}
Table_PlotQuest_107_fields = {
  "id",
  "Type",
  "Params"
}
return Table_PlotQuest_107
