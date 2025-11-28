Table_PlotQuest_69 = {
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
    Type = "showview",
    Params = {panelid = 800, showtype = 1}
  },
  [4] = {
    id = 4,
    Type = "onoff_camerapoint",
    Params = {groupid = 0, on = true}
  },
  [5] = {
    id = 5,
    Type = "set_dir",
    Params = {player = 1, dir = 270}
  },
  [6] = {
    id = 6,
    Type = "play_effect_scene",
    Params = {
      id = 211,
      path = "Skill/Rinbelungen_buff1",
      pos = {
        -1.95,
        3.11,
        -2.01
      },
      ignoreNavMesh = 1
    }
  },
  [7] = {
    id = 7,
    Type = "play_effect_scene",
    Params = {
      id = 212,
      path = "Skill/AngleOffer_buff",
      pos = {
        -2.16,
        2.79,
        -1.96
      },
      ignoreNavMesh = 1
    }
  },
  [8] = {
    id = 8,
    Type = "play_effect_scene",
    Params = {
      id = 213,
      path = "Skill/BlessingFaith_buff2",
      pos = {
        -2.04,
        4.05,
        -2.01
      },
      ignoreNavMesh = 1
    }
  },
  [9] = {
    id = 9,
    Type = "wait_time",
    Params = {time = 2000}
  },
  [10] = {
    id = 10,
    Type = "dialog",
    Params = {
      dialog = {
        750742,
        750743,
        750744
      }
    }
  },
  [11] = {
    id = 11,
    Type = "addbutton",
    Params = {
      id = 1,
      text = "##298179",
      eventtype = "goon"
    }
  },
  [12] = {
    id = 12,
    Type = "wait_ui",
    Params = {button = 1}
  },
  [13] = {
    id = 13,
    Type = "change_bgm",
    Params = {
      path = "Task_daoshi",
      time = 0
    }
  },
  [14] = {
    id = 14,
    Type = "action",
    Params = {
      player = 1,
      id = 88,
      loop = true
    }
  },
  [15] = {
    id = 15,
    Type = "wait_time",
    Params = {time = 500}
  },
  [16] = {
    id = 16,
    Type = "play_effect_scene",
    Params = {
      id = 214,
      path = "Skill/MonsterInvincible",
      pos = {
        -0.5,
        4.2,
        -2.03
      },
      ignoreNavMesh = 1
    }
  },
  [17] = {
    id = 17,
    Type = "wait_time",
    Params = {time = 500}
  },
  [18] = {
    id = 18,
    Type = "dialog",
    Params = {
      dialog = {750745}
    }
  },
  [19] = {
    id = 19,
    Type = "camera_filter",
    Params = {filterid = 4, on = 1}
  },
  [20] = {
    id = 20,
    Type = "play_sound",
    Params = {
      path = "Common/Magic_cast"
    }
  },
  [21] = {
    id = 21,
    Type = "play_effect_scene",
    Params = {
      id = 1,
      path = "Skill/FullMoon_atk",
      pos = {
        -7.16,
        3.54,
        3.15
      },
      onshot = 1
    }
  },
  [22] = {
    id = 22,
    Type = "play_effect_scene",
    Params = {
      id = 2,
      path = "Skill/FullMoon_atk",
      pos = {
        3.13,
        3.54,
        2.95
      },
      onshot = 1
    }
  },
  [23] = {
    id = 23,
    Type = "play_effect_scene",
    Params = {
      id = 3,
      path = "Skill/FullMoon_atk",
      pos = {
        -7.25,
        3.54,
        -6.87
      },
      onshot = 1
    }
  },
  [24] = {
    id = 24,
    Type = "play_effect_scene",
    Params = {
      id = 4,
      path = "Skill/FullMoon_atk",
      pos = {
        2.98,
        3.54,
        -7.01
      },
      onshot = 1
    }
  },
  [25] = {
    id = 25,
    Type = "wait_time",
    Params = {time = 1000}
  },
  [26] = {
    id = 26,
    Type = "play_effect_scene",
    Params = {
      id = 5,
      path = "Common/PhotonForce_Purple",
      pos = {
        -7.11,
        3.7,
        3.02
      },
      ignoreNavMesh = 1
    }
  },
  [27] = {
    id = 27,
    Type = "play_effect_scene",
    Params = {
      id = 6,
      path = "Common/PhotonForce_Purple",
      pos = {
        3.13,
        3.7,
        3.02
      },
      ignoreNavMesh = 1
    }
  },
  [28] = {
    id = 28,
    Type = "play_effect_scene",
    Params = {
      id = 7,
      path = "Common/PhotonForce_Purple",
      pos = {
        -7.16,
        3.7,
        -6.91
      },
      ignoreNavMesh = 1
    }
  },
  [29] = {
    id = 29,
    Type = "play_effect_scene",
    Params = {
      id = 8,
      path = "Common/PhotonForce_Purple",
      pos = {
        3.0,
        3.7,
        -7.01
      },
      ignoreNavMesh = 1
    }
  },
  [30] = {
    id = 30,
    Type = "play_effect_scene",
    Params = {
      id = 15,
      path = "Skill/Eff_FireShield_buff",
      pos = {
        -7.11,
        3.7,
        3.02
      },
      ignoreNavMesh = 1
    }
  },
  [31] = {
    id = 31,
    Type = "play_effect_scene",
    Params = {
      id = 16,
      path = "Skill/Eff_FireShield_buff",
      pos = {
        3.13,
        3.7,
        3.02
      },
      ignoreNavMesh = 1
    }
  },
  [32] = {
    id = 32,
    Type = "play_effect_scene",
    Params = {
      id = 17,
      path = "Skill/Eff_FireShield_buff",
      pos = {
        -7.16,
        3.7,
        -6.91
      },
      ignoreNavMesh = 1
    }
  },
  [33] = {
    id = 33,
    Type = "play_effect_scene",
    Params = {
      id = 18,
      path = "Skill/Eff_FireShield_buff",
      pos = {
        3.0,
        3.7,
        -7.01
      },
      ignoreNavMesh = 1
    }
  },
  [34] = {
    id = 34,
    Type = "wait_time",
    Params = {time = 1000}
  },
  [35] = {
    id = 35,
    Type = "addbutton",
    Params = {
      id = 2,
      text = "##298179",
      eventtype = "goon"
    }
  },
  [36] = {
    id = 36,
    Type = "wait_ui",
    Params = {button = 2}
  },
  [37] = {
    id = 37,
    Type = "dialog",
    Params = {
      dialog = {750746}
    }
  },
  [38] = {
    id = 38,
    Type = "play_sound",
    Params = {
      path = "Common/Magic_cast"
    }
  },
  [39] = {
    id = 39,
    Type = "play_effect_scene",
    Params = {
      id = 80,
      path = "Skill/AngleOfHope_hit1",
      pos = {
        0.94,
        3.29,
        -4.97
      },
      onshot = 1
    }
  },
  [40] = {
    id = 40,
    Type = "play_effect_scene",
    Params = {
      id = 81,
      path = "Skill/AngleOfHope_hit1",
      pos = {
        0.94,
        3.29,
        0.92
      },
      onshot = 1
    }
  },
  [41] = {
    id = 41,
    Type = "play_effect_scene",
    Params = {
      id = 82,
      path = "Skill/AngleOfHope_hit1",
      pos = {
        -4.97,
        3.29,
        0.92
      },
      onshot = 1
    }
  },
  [42] = {
    id = 42,
    Type = "play_effect_scene",
    Params = {
      id = 83,
      path = "Skill/AngleOfHope_hit1",
      pos = {
        -4.97,
        3.29,
        -5.02
      },
      onshot = 1
    }
  },
  [43] = {
    id = 43,
    Type = "wait_time",
    Params = {time = 800}
  },
  [44] = {
    id = 44,
    Type = "play_effect_scene",
    Params = {
      id = 70,
      path = "Skill/Eff_Electrification_hit",
      pos = {
        0.94,
        3.29,
        -4.97
      }
    }
  },
  [45] = {
    id = 45,
    Type = "play_effect_scene",
    Params = {
      id = 71,
      path = "Skill/Eff_Electrification_hit",
      pos = {
        0.94,
        3.29,
        0.92
      }
    }
  },
  [46] = {
    id = 46,
    Type = "play_effect_scene",
    Params = {
      id = 72,
      path = "Skill/Eff_Electrification_hit",
      pos = {
        -4.97,
        3.29,
        0.92
      }
    }
  },
  [47] = {
    id = 47,
    Type = "play_effect_scene",
    Params = {
      id = 73,
      path = "Skill/Eff_Electrification_hit",
      pos = {
        -4.97,
        3.29,
        -5.02
      }
    }
  },
  [48] = {
    id = 48,
    Type = "play_effect_scene",
    Params = {
      id = 84,
      path = "Skill/AngleOfHope_hit1",
      pos = {
        0.43,
        3.29,
        -3.32
      },
      onshot = 1
    }
  },
  [49] = {
    id = 49,
    Type = "play_effect_scene",
    Params = {
      id = 85,
      path = "Skill/AngleOfHope_hit1",
      pos = {
        -0.65,
        3.29,
        0.65
      },
      onshot = 1
    }
  },
  [50] = {
    id = 50,
    Type = "play_effect_scene",
    Params = {
      id = 86,
      path = "Skill/AngleOfHope_hit1",
      pos = {
        -4.26,
        3.29,
        -0.81
      },
      onshot = 1
    }
  },
  [51] = {
    id = 51,
    Type = "play_effect_scene",
    Params = {
      id = 87,
      path = "Skill/AngleOfHope_hit1",
      pos = {
        -3.42,
        3.29,
        -4.45
      },
      onshot = 1
    }
  },
  [52] = {
    id = 52,
    Type = "wait_time",
    Params = {time = 800}
  },
  [53] = {
    id = 53,
    Type = "play_effect_scene",
    Params = {
      id = 74,
      path = "Skill/Eff_Electrification_hit",
      pos = {
        0.43,
        3.29,
        -3.32
      }
    }
  },
  [54] = {
    id = 54,
    Type = "play_effect_scene",
    Params = {
      id = 75,
      path = "Skill/Eff_Electrification_hit",
      pos = {
        -0.65,
        3.29,
        0.65
      }
    }
  },
  [55] = {
    id = 55,
    Type = "play_effect_scene",
    Params = {
      id = 76,
      path = "Skill/Eff_Electrification_hit",
      pos = {
        -4.26,
        3.29,
        -0.81
      }
    }
  },
  [56] = {
    id = 56,
    Type = "play_effect_scene",
    Params = {
      id = 77,
      path = "Skill/Eff_Electrification_hit",
      pos = {
        -3.42,
        3.29,
        -4.45
      }
    }
  },
  [57] = {
    id = 57,
    Type = "play_effect_scene",
    Params = {
      id = 88,
      path = "Skill/AngleOfHope_hit1",
      pos = {
        -0.6,
        3.29,
        -2.08
      },
      onshot = 1
    }
  },
  [58] = {
    id = 58,
    Type = "play_effect_scene",
    Params = {
      id = 89,
      path = "Skill/AngleOfHope_hit1",
      pos = {
        -1.98,
        3.29,
        -0.57
      },
      onshot = 1
    }
  },
  [59] = {
    id = 59,
    Type = "play_effect_scene",
    Params = {
      id = 90,
      path = "Skill/AngleOfHope_hit1",
      pos = {
        -3.69,
        3.29,
        -2.0
      },
      onshot = 1
    }
  },
  [60] = {
    id = 60,
    Type = "play_effect_scene",
    Params = {
      id = 91,
      path = "Skill/AngleOfHope_hit1",
      pos = {
        -2.07,
        3.29,
        -3.8
      },
      onshot = 1
    }
  },
  [61] = {
    id = 61,
    Type = "wait_time",
    Params = {time = 800}
  },
  [62] = {
    id = 62,
    Type = "play_effect_scene",
    Params = {
      id = 78,
      path = "Skill/Eff_Electrification_hit",
      pos = {
        -0.6,
        3.29,
        -2.08
      }
    }
  },
  [63] = {
    id = 63,
    Type = "play_effect_scene",
    Params = {
      id = 79,
      path = "Skill/Eff_Electrification_hit",
      pos = {
        -1.98,
        3.29,
        -0.57
      }
    }
  },
  [64] = {
    id = 64,
    Type = "play_effect_scene",
    Params = {
      id = 93,
      path = "Skill/Eff_Electrification_hit",
      pos = {
        -3.69,
        3.29,
        -2.0
      }
    }
  },
  [65] = {
    id = 65,
    Type = "play_effect_scene",
    Params = {
      id = 94,
      path = "Skill/Eff_Electrification_hit",
      pos = {
        -2.07,
        3.29,
        -3.8
      }
    }
  },
  [66] = {
    id = 66,
    Type = "play_effect_scene",
    Params = {
      id = 99,
      path = "Skill/Pray_attack",
      pos = {
        -2.05,
        4.34,
        -2.17
      },
      ignoreNavMesh = 1
    }
  },
  [67] = {
    id = 67,
    Type = "wait_time",
    Params = {time = 500}
  },
  [68] = {
    id = 68,
    Type = "play_effect_scene",
    Params = {
      id = 10,
      path = "Common/PhotonForce_Blue",
      pos = {
        -2.05,
        4.84,
        -2.17
      },
      ignoreNavMesh = 1
    }
  },
  [69] = {
    id = 69,
    Type = "wait_time",
    Params = {time = 1000}
  },
  [70] = {
    id = 70,
    Type = "addbutton",
    Params = {
      id = 3,
      text = "##298179",
      eventtype = "goon"
    }
  },
  [71] = {
    id = 71,
    Type = "wait_ui",
    Params = {button = 3}
  },
  [72] = {
    id = 72,
    Type = "dialog",
    Params = {
      dialog = {750747}
    }
  },
  [73] = {
    id = 73,
    Type = "play_sound",
    Params = {
      path = "Common/Magic_cast"
    }
  },
  [74] = {
    id = 74,
    Type = "play_effect_scene",
    Params = {
      id = 9,
      path = "Skill/DragonWater_hit",
      pos = {
        -2.05,
        3.47,
        -2.17
      },
      onshot = 1
    }
  },
  [75] = {
    id = 75,
    Type = "play_effect_scene",
    Params = {
      id = 59,
      path = "Skill/Eff_ElementBalance_buff",
      pos = {
        -2.17,
        5.39,
        -2.06
      },
      onshot = 1
    }
  },
  [76] = {
    id = 76,
    Type = "wait_time",
    Params = {time = 1000}
  },
  [77] = {
    id = 77,
    Type = "play_effect_scene",
    Params = {
      id = 19,
      path = "Skill/AdvancedDetoxification_attack",
      pos = {
        -2.05,
        3.78,
        -1.66
      },
      onshot = 1
    }
  },
  [78] = {
    id = 78,
    Type = "wait_time",
    Params = {time = 1000}
  },
  [79] = {
    id = 79,
    Type = "play_effect_scene",
    Params = {
      id = 41,
      path = "Skill/Eff_LightningMeteor_hit",
      pos = {
        -7.16,
        4.74,
        3.04
      },
      onshot = 1
    }
  },
  [80] = {
    id = 80,
    Type = "play_effect_scene",
    Params = {
      id = 42,
      path = "Skill/Eff_LightningMeteor_hit",
      pos = {
        3.04,
        4.74,
        3.04
      },
      onshot = 1
    }
  },
  [81] = {
    id = 81,
    Type = "play_effect_scene",
    Params = {
      id = 43,
      path = "Skill/Eff_LightningMeteor_hit",
      pos = {
        3.04,
        4.74,
        -6.86
      },
      onshot = 1
    }
  },
  [82] = {
    id = 82,
    Type = "play_effect_scene",
    Params = {
      id = 44,
      path = "Skill/Eff_LightningMeteor_hit",
      pos = {
        -7.19,
        4.74,
        -6.99
      },
      onshot = 1
    }
  },
  [83] = {
    id = 83,
    Type = "wait_time",
    Params = {time = 500}
  },
  [84] = {
    id = 84,
    Type = "play_effect_scene",
    Params = {
      id = 31,
      path = "Skill/PoemOfBragi_buff2",
      pos = {
        -7.2,
        2.7,
        -6.93
      },
      ignoreNavMesh = 1
    }
  },
  [85] = {
    id = 85,
    Type = "play_effect_scene",
    Params = {
      id = 36,
      path = "Skill/PoemOfBragi_buff2",
      pos = {
        -7.16,
        2.7,
        3.03
      },
      ignoreNavMesh = 1
    }
  },
  [86] = {
    id = 86,
    Type = "play_effect_scene",
    Params = {
      id = 34,
      path = "Skill/PoemOfBragi_buff2",
      pos = {
        3.14,
        2.7,
        3.0
      },
      ignoreNavMesh = 1
    }
  },
  [87] = {
    id = 87,
    Type = "play_effect_scene",
    Params = {
      id = 35,
      path = "Skill/PoemOfBragi_buff2",
      pos = {
        3.02,
        2.7,
        -6.95
      },
      ignoreNavMesh = 1
    }
  },
  [88] = {
    id = 88,
    Type = "wait_time",
    Params = {time = 800}
  },
  [89] = {
    id = 89,
    Type = "play_effect_scene",
    Params = {
      id = 151,
      path = "Skill/Eff_LightningMeteor_hit",
      pos = {
        -2.15,
        4.07,
        -4.89
      },
      onshot = 1
    }
  },
  [90] = {
    id = 90,
    Type = "play_effect_scene",
    Params = {
      id = 152,
      path = "Skill/Eff_LightningMeteor_hit",
      pos = {
        -1.0,
        4.07,
        -4.47
      },
      onshot = 1
    }
  },
  [91] = {
    id = 91,
    Type = "play_effect_scene",
    Params = {
      id = 153,
      path = "Skill/Eff_LightningMeteor_hit",
      pos = {
        -0.03,
        4.07,
        -3.7
      },
      onshot = 1
    }
  },
  [92] = {
    id = 92,
    Type = "play_effect_scene",
    Params = {
      id = 154,
      path = "Skill/Eff_LightningMeteor_hit",
      pos = {
        0.76,
        4.07,
        -2.67
      },
      onshot = 1
    }
  },
  [93] = {
    id = 93,
    Type = "play_effect_scene",
    Params = {
      id = 155,
      path = "Skill/Eff_LightningMeteor_hit",
      pos = {
        1.06,
        4.07,
        -1.68
      },
      onshot = 1
    }
  },
  [94] = {
    id = 94,
    Type = "play_effect_scene",
    Params = {
      id = 156,
      path = "Skill/Eff_LightningMeteor_hit",
      pos = {
        0.72,
        4.07,
        -0.59
      },
      onshot = 1
    }
  },
  [95] = {
    id = 95,
    Type = "play_effect_scene",
    Params = {
      id = 157,
      path = "Skill/Eff_LightningMeteor_hit",
      pos = {
        0.03,
        4.07,
        0.33
      },
      onshot = 1
    }
  },
  [96] = {
    id = 96,
    Type = "play_effect_scene",
    Params = {
      id = 158,
      path = "Skill/Eff_LightningMeteor_hit",
      pos = {
        -1.06,
        4.07,
        0.93
      },
      onshot = 1
    }
  },
  [97] = {
    id = 97,
    Type = "play_effect_scene",
    Params = {
      id = 159,
      path = "Skill/Eff_LightningMeteor_hit",
      pos = {
        -2.21,
        4.07,
        1.12
      },
      onshot = 1
    }
  },
  [98] = {
    id = 98,
    Type = "play_effect_scene",
    Params = {
      id = 160,
      path = "Skill/Eff_LightningMeteor_hit",
      pos = {
        -3.52,
        4.07,
        0.87
      },
      onshot = 1
    }
  },
  [99] = {
    id = 99,
    Type = "play_effect_scene",
    Params = {
      id = 161,
      path = "Skill/Eff_LightningMeteor_hit",
      pos = {
        -4.55,
        4.07,
        0.27
      },
      onshot = 1
    }
  },
  [100] = {
    id = 100,
    Type = "play_effect_scene",
    Params = {
      id = 162,
      path = "Skill/Eff_LightningMeteor_hit",
      pos = {
        -5.06,
        4.07,
        -0.67
      },
      onshot = 1
    }
  },
  [101] = {
    id = 101,
    Type = "play_effect_scene",
    Params = {
      id = 163,
      path = "Skill/Eff_LightningMeteor_hit",
      pos = {
        -5.31,
        4.07,
        -1.76
      },
      onshot = 1
    }
  },
  [102] = {
    id = 102,
    Type = "play_effect_scene",
    Params = {
      id = 164,
      path = "Skill/Eff_LightningMeteor_hit",
      pos = {
        -4.97,
        4.07,
        -2.9
      },
      onshot = 1
    }
  },
  [103] = {
    id = 103,
    Type = "play_effect_scene",
    Params = {
      id = 165,
      path = "Skill/Eff_LightningMeteor_hit",
      pos = {
        -4.28,
        4.07,
        -3.93
      },
      onshot = 1
    }
  },
  [104] = {
    id = 104,
    Type = "play_effect_scene",
    Params = {
      id = 166,
      path = "Skill/Eff_LightningMeteor_hit",
      pos = {
        -3.32,
        4.07,
        -4.56
      },
      onshot = 1
    }
  },
  [105] = {
    id = 105,
    Type = "wait_time",
    Params = {time = 800}
  },
  [106] = {
    id = 106,
    Type = "play_effect_scene",
    Params = {
      id = 45,
      path = "Skill/Eff_LightningMeteor_hit",
      pos = {
        -2.78,
        5.67,
        -2.31
      },
      onshot = 1
    }
  },
  [107] = {
    id = 107,
    Type = "play_effect_scene",
    Params = {
      id = 46,
      path = "Skill/Eff_LightningMeteor_hit",
      pos = {
        -1.75,
        5.67,
        -1.24
      },
      onshot = 1
    }
  },
  [108] = {
    id = 108,
    Type = "play_effect_scene",
    Params = {
      id = 47,
      path = "Skill/Eff_LightningMeteor_hit",
      pos = {
        -1.92,
        4.48,
        -2.64
      },
      onshot = 1
    }
  },
  [109] = {
    id = 109,
    Type = "wait_time",
    Params = {time = 500}
  },
  [110] = {
    id = 110,
    Type = "play_effect_scene",
    Params = {
      id = 37,
      path = "Skill/PoemOfBragi_buff2",
      pos = {
        -1.74,
        3.42,
        -1.27
      },
      ignoreNavMesh = 1
    }
  },
  [111] = {
    id = 111,
    Type = "play_effect_scene",
    Params = {
      id = 33,
      path = "Skill/PoemOfBragi_buff2",
      pos = {
        -2.72,
        3.68,
        -2.32
      },
      ignoreNavMesh = 1
    }
  },
  [112] = {
    id = 112,
    Type = "play_effect_scene",
    Params = {
      id = 32,
      path = "Skill/PoemOfBragi_buff2",
      pos = {
        -1.85,
        2.54,
        -2.66
      },
      ignoreNavMesh = 1
    }
  },
  [113] = {
    id = 113,
    Type = "wait_time",
    Params = {time = 1000}
  },
  [114] = {
    id = 114,
    Type = "addbutton",
    Params = {
      id = 4,
      text = "##298179",
      eventtype = "goon"
    }
  },
  [115] = {
    id = 115,
    Type = "wait_ui",
    Params = {button = 4}
  },
  [116] = {
    id = 116,
    Type = "dialog",
    Params = {
      dialog = {750748}
    }
  },
  [117] = {
    id = 117,
    Type = "play_sound",
    Params = {
      path = "Common/Magic_cast"
    }
  },
  [118] = {
    id = 118,
    Type = "play_effect_scene",
    Params = {
      id = 51,
      path = "Skill/Detonator_slow",
      pos = {
        -2.15,
        4.27,
        -4.89
      },
      onshot = 1
    }
  },
  [119] = {
    id = 119,
    Type = "wait_time",
    Params = {time = 100}
  },
  [120] = {
    id = 120,
    Type = "play_effect_scene",
    Params = {
      id = 52,
      path = "Skill/Detonator_slow",
      pos = {
        -1.0,
        4.27,
        -4.47
      },
      onshot = 1
    }
  },
  [121] = {
    id = 121,
    Type = "wait_time",
    Params = {time = 100}
  },
  [122] = {
    id = 122,
    Type = "play_effect_scene",
    Params = {
      id = 53,
      path = "Skill/Detonator_slow",
      pos = {
        -0.03,
        4.27,
        -3.7
      },
      onshot = 1
    }
  },
  [123] = {
    id = 123,
    Type = "wait_time",
    Params = {time = 100}
  },
  [124] = {
    id = 124,
    Type = "play_effect_scene",
    Params = {
      id = 54,
      path = "Skill/Detonator_slow",
      pos = {
        0.76,
        4.27,
        -2.67
      },
      onshot = 1
    }
  },
  [125] = {
    id = 125,
    Type = "wait_time",
    Params = {time = 100}
  },
  [126] = {
    id = 126,
    Type = "play_effect_scene",
    Params = {
      id = 55,
      path = "Skill/Detonator_slow",
      pos = {
        1.06,
        4.27,
        -1.68
      },
      onshot = 1
    }
  },
  [127] = {
    id = 127,
    Type = "wait_time",
    Params = {time = 100}
  },
  [128] = {
    id = 128,
    Type = "play_effect_scene",
    Params = {
      id = 56,
      path = "Skill/Detonator_slow",
      pos = {
        0.72,
        4.27,
        -0.59
      },
      onshot = 1
    }
  },
  [129] = {
    id = 129,
    Type = "wait_time",
    Params = {time = 100}
  },
  [130] = {
    id = 130,
    Type = "play_effect_scene",
    Params = {
      id = 57,
      path = "Skill/Detonator_slow",
      pos = {
        0.03,
        4.27,
        0.33
      },
      onshot = 1
    }
  },
  [131] = {
    id = 131,
    Type = "wait_time",
    Params = {time = 100}
  },
  [132] = {
    id = 132,
    Type = "play_effect_scene",
    Params = {
      id = 58,
      path = "Skill/Detonator_slow",
      pos = {
        -1.06,
        4.27,
        0.93
      },
      onshot = 1
    }
  },
  [133] = {
    id = 133,
    Type = "wait_time",
    Params = {time = 100}
  },
  [134] = {
    id = 134,
    Type = "play_effect_scene",
    Params = {
      id = 59,
      path = "Skill/Detonator_slow",
      pos = {
        -2.21,
        4.27,
        1.12
      },
      onshot = 1
    }
  },
  [135] = {
    id = 135,
    Type = "wait_time",
    Params = {time = 100}
  },
  [136] = {
    id = 136,
    Type = "play_effect_scene",
    Params = {
      id = 60,
      path = "Skill/Detonator_slow",
      pos = {
        -3.52,
        4.27,
        0.87
      },
      onshot = 1
    }
  },
  [137] = {
    id = 137,
    Type = "wait_time",
    Params = {time = 100}
  },
  [138] = {
    id = 138,
    Type = "play_effect_scene",
    Params = {
      id = 61,
      path = "Skill/Detonator_slow",
      pos = {
        -4.55,
        4.27,
        0.27
      },
      onshot = 1
    }
  },
  [139] = {
    id = 139,
    Type = "wait_time",
    Params = {time = 100}
  },
  [140] = {
    id = 140,
    Type = "play_effect_scene",
    Params = {
      id = 62,
      path = "Skill/Detonator_slow",
      pos = {
        -5.06,
        4.27,
        -0.67
      },
      onshot = 1
    }
  },
  [141] = {
    id = 141,
    Type = "wait_time",
    Params = {time = 100}
  },
  [142] = {
    id = 142,
    Type = "play_effect_scene",
    Params = {
      id = 63,
      path = "Skill/Detonator_slow",
      pos = {
        -5.31,
        4.27,
        -1.76
      },
      onshot = 1
    }
  },
  [143] = {
    id = 143,
    Type = "wait_time",
    Params = {time = 100}
  },
  [144] = {
    id = 144,
    Type = "play_effect_scene",
    Params = {
      id = 64,
      path = "Skill/Detonator_slow",
      pos = {
        -4.97,
        4.27,
        -2.9
      },
      onshot = 1
    }
  },
  [145] = {
    id = 145,
    Type = "wait_time",
    Params = {time = 100}
  },
  [146] = {
    id = 146,
    Type = "play_effect_scene",
    Params = {
      id = 65,
      path = "Skill/Detonator_slow",
      pos = {
        -4.28,
        4.27,
        -3.93
      },
      onshot = 1
    }
  },
  [147] = {
    id = 147,
    Type = "wait_time",
    Params = {time = 100}
  },
  [148] = {
    id = 148,
    Type = "play_effect_scene",
    Params = {
      id = 66,
      path = "Skill/Detonator_slow",
      pos = {
        -3.32,
        4.27,
        -4.56
      },
      onshot = 1
    }
  },
  [149] = {
    id = 149,
    Type = "wait_time",
    Params = {time = 1000}
  },
  [150] = {
    id = 150,
    Type = "dialog",
    Params = {
      dialog = {750749}
    }
  },
  [151] = {
    id = 151,
    Type = "play_sound",
    Params = {
      path = "Common/Magic_cast"
    }
  },
  [152] = {
    id = 152,
    Type = "play_effect_scene",
    Params = {
      id = 67,
      path = "Skill/LVUP_Process_2",
      pos = {
        -1.99,
        3.39,
        -1.97
      },
      onshot = 1
    }
  },
  [153] = {
    id = 153,
    Type = "wait_time",
    Params = {time = 1500}
  },
  [154] = {
    id = 154,
    Type = "play_effect_scene",
    Params = {
      id = 167,
      path = "Skill/LVUP_Process_2",
      pos = {
        0.46,
        3.39,
        -4.57
      },
      onshot = 1
    }
  },
  [155] = {
    id = 155,
    Type = "play_effect_scene",
    Params = {
      id = 168,
      path = "Skill/LVUP_Process_2",
      pos = {
        -4.71,
        3.39,
        -4.57
      },
      onshot = 1
    }
  },
  [156] = {
    id = 156,
    Type = "play_effect_scene",
    Params = {
      id = 169,
      path = "Skill/LVUP_Process_2",
      pos = {
        -4.71,
        3.39,
        0.47
      },
      onshot = 1
    }
  },
  [157] = {
    id = 157,
    Type = "play_effect_scene",
    Params = {
      id = 170,
      path = "Skill/LVUP_Process_2",
      pos = {
        0.37,
        3.39,
        0.47
      },
      onshot = 1
    }
  },
  [158] = {
    id = 158,
    Type = "wait_time",
    Params = {time = 1500}
  },
  [159] = {
    id = 159,
    Type = "play_effect_scene",
    Params = {
      id = 20,
      path = "Skill/PoemOfBragi_buff1",
      pos = {
        -2.05,
        3.47,
        -2.17
      }
    }
  },
  [160] = {
    id = 160,
    Type = "play_sound",
    Params = {
      path = "Common/JobChange"
    }
  },
  [161] = {
    id = 161,
    Type = "play_effect_scene",
    Params = {
      id = 19,
      path = "Common/65JobChange",
      pos = {
        -2.05,
        3.47,
        -2.17
      },
      onshot = 1
    }
  },
  [162] = {
    id = 162,
    Type = "move",
    Params = {
      player = 1,
      pos = {
        -1.12,
        3.39,
        -1.96
      },
      spd = 1,
      dir = 270
    }
  },
  [163] = {
    id = 163,
    Type = "wait_pos",
    Params = {
      player = 1,
      pos = {
        -1.12,
        3.39,
        -1.96
      },
      distance = 1
    }
  },
  [164] = {
    id = 164,
    Type = "set_dir",
    Params = {player = 1, dir = 90}
  },
  [165] = {
    id = 165,
    Type = "action",
    Params = {
      player = 1,
      id = 10,
      loop = true
    }
  },
  [166] = {
    id = 166,
    Type = "wait_time",
    Params = {time = 1000}
  },
  [167] = {
    id = 167,
    Type = "onoff_camerapoint",
    Params = {
      groupid = 0,
      on = false,
      returnDefaultTime = 1500
    }
  },
  [168] = {
    id = 168,
    Type = "showview",
    Params = {panelid = 800, showtype = 2}
  },
  [169] = {
    id = 169,
    Type = "endfilter",
    Params = {
      fliter = {39}
    }
  }
}
Table_PlotQuest_69_fields = {
  "id",
  "Type",
  "Params"
}
return Table_PlotQuest_69
