Table_EndlessBattleFieldEvent = {
  [1] = {
    id = 1,
    Type = "coin",
    Name = "##3502101",
    Desc = "##3489802",
    Icon = "battlefield_map_icon_2",
    MapId = {151, 152},
    MaxTime = 300,
    AreaCenter = {
      -98.67,
      4.06,
      82.27
    },
    AreaRange = 25,
    Misc = {win_num = 100},
    RobotNpc = {
      1,
      2,
      3,
      4
    },
    ShowScore = 1
  },
  [2] = {
    id = 2,
    Type = "escort",
    Name = "##3502102",
    Desc = "##3489804",
    Icon = "battlefield_map_icon_4",
    MapId = {151, 152},
    MaxTime = 300,
    AreaCenter = {
      -42.87,
      0,
      44.78
    },
    AreaRange = 30,
    Misc = {escort_npcid = 850801},
    RobotNpc = {
      1,
      2,
      3,
      4
    }
  },
  [3] = {
    id = 3,
    Type = "occupy",
    Name = "##3489805",
    Desc = "##3489806",
    Icon = "battlefield_map_icon_6",
    MapId = {151, 152},
    MaxTime = 300,
    AreaCenter = {
      41.69,
      -1.31,
      -42.48
    },
    AreaRange = 30,
    Misc = {
      occupy_points = {
        [1] = {
          center = {
            41.69,
            -1.31,
            -42.48
          },
          scale = {
            2.258451,
            2.258451,
            2.258451
          },
          rotation = {
            0,
            24.9,
            0
          },
          range = 8.5,
          interval = 1,
          occupy_score = 10
        },
        [2] = {
          center = {
            23.92,
            -1.09,
            -48.47
          },
          scale = {
            1.595627,
            1.595627,
            1.595627
          },
          rotation = {
            0,
            163.4,
            0
          },
          range = 6,
          interval = 1,
          occupy_score = 10
        },
        [3] = {
          center = {
            35.37,
            -1.2726,
            -25.06
          },
          scale = {
            1.595627,
            2.223028,
            1.595627
          },
          rotation = {
            0,
            -19.84,
            0
          },
          range = 6,
          interval = 1,
          occupy_score = 10
        },
        [4] = {
          center = {
            49.15,
            -1.26,
            -59.77
          },
          scale = {
            1.595627,
            2.293395,
            1.595627
          },
          rotation = {
            0,
            -22,
            0
          },
          range = 6,
          interval = 1,
          occupy_score = 10
        },
        [5] = {
          center = {
            59.65,
            -1.22,
            -35.26
          },
          scale = {
            1.595627,
            1.595627,
            1.595627
          },
          rotation = {
            0,
            -27.89999,
            0
          },
          range = 6,
          interval = 1,
          occupy_score = 10
        }
      }
    },
    RobotNpc = {
      1,
      2,
      3,
      4
    }
  },
  [4] = {
    id = 4,
    Type = "kill_boss",
    Name = "##3489807",
    Desc = "##3502103",
    Icon = "battlefield_map_icon_5",
    MapId = {151, 152},
    MaxTime = 240,
    AreaCenter = {
      98.96,
      7.55,
      -88.28
    },
    AreaRange = 25,
    Misc = {monster_id = 78113},
    RobotNpc = {
      1,
      2,
      3,
      4
    }
  },
  [5] = {
    id = 5,
    Type = "kill_monster",
    Name = "##3489809",
    Desc = "##3502864",
    Icon = "battlefield_map_icon_3",
    MapId = {151},
    MaxTime = 300,
    AreaCenter = {
      -78.19,
      1.03,
      -25.89
    },
    AreaRange = 25,
    Misc = {
      win_num = 90,
      monster_pool = {
        [3] = {
          num = 40,
          pool = {78121}
        },
        [4] = {
          num = 16,
          pool = {78122, 78123}
        },
        [5] = {
          num = 4,
          pool = {78124}
        }
      }
    },
    RobotNpc = {
      1,
      2,
      3,
      4
    },
    ShowScore = 1
  },
  [6] = {
    id = 6,
    Type = "kill_monster",
    Name = "##3489811",
    Desc = "##3502864",
    Icon = "battlefield_map_icon_3",
    MapId = {151},
    MaxTime = 300,
    AreaCenter = {
      77.47,
      -1.41,
      25.07
    },
    AreaRange = 25,
    Misc = {
      win_num = 90,
      monster_pool = {
        [3] = {
          num = 40,
          pool = {78115}
        },
        [4] = {
          num = 16,
          pool = {78125, 78126}
        },
        [5] = {
          num = 4,
          pool = {78127}
        }
      }
    },
    RobotNpc = {
      1,
      2,
      3,
      4
    },
    ShowScore = 1
  },
  [7] = {
    id = 7,
    Type = "statue",
    Name = "##3489890",
    Desc = "##3489814",
    Icon = "battlefield_map_icon_1",
    MapId = {151, 152},
    MaxTime = 360,
    AreaCenter = {
      -0.088,
      -3.964,
      0.257
    },
    AreaRange = 20,
    Misc = {
      monster_id = {
        [1] = {
          78101,
          78102,
          78103,
          78104,
          78105,
          78106
        },
        [2] = {
          78107,
          78108,
          78109,
          78110,
          78111,
          78112
        }
      },
      statue_groupid = {
        [1] = 78101,
        [2] = 78107
      }
    },
    RobotNpc = {
      1,
      2,
      3,
      4
    }
  },
  [8] = {
    id = 8,
    Type = "kill_monster",
    Name = "##3489809",
    Desc = "##3502864",
    Icon = "battlefield_map_icon_3",
    MapId = {152},
    MaxTime = 300,
    AreaCenter = {
      -78.19,
      1.03,
      -25.89
    },
    AreaRange = 25,
    Misc = {
      win_num = 90,
      monster_pool = {
        [3] = {
          num = 40,
          pool = {78121}
        },
        [4] = {
          num = 16,
          pool = {78122, 78123}
        },
        [5] = {
          num = 4,
          pool = {78124}
        }
      }
    },
    RobotNpc = {
      1,
      2,
      3,
      4
    },
    ShowScore = 1
  },
  [9] = {
    id = 9,
    Type = "kill_monster",
    Name = "##3489811",
    Desc = "##3502864",
    Icon = "battlefield_map_icon_3",
    MapId = {152},
    MaxTime = 300,
    AreaCenter = {
      77.47,
      -1.41,
      25.07
    },
    AreaRange = 25,
    Misc = {
      win_num = 90,
      monster_pool = {
        [3] = {
          num = 40,
          pool = {78115}
        },
        [4] = {
          num = 16,
          pool = {78125, 78126}
        },
        [5] = {
          num = 4,
          pool = {78127}
        }
      }
    },
    RobotNpc = {
      1,
      2,
      3,
      4
    },
    ShowScore = 1
  }
}
Table_EndlessBattleFieldEvent_fields = {
  "id",
  "Type",
  "Name",
  "Desc",
  "Icon",
  "MapId",
  "MaxTime",
  "AreaCenter",
  "AreaRange",
  "Misc",
  "RobotNpc",
  "ShowScore"
}
return Table_EndlessBattleFieldEvent
