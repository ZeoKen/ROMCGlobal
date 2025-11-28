Table_PlotQuest_93 = {
  [1] = {
    id = 1,
    Type = "startfilter",
    Params = {
      fliter = {20}
    }
  },
  [2] = {
    id = 2,
    Type = "showview",
    Params = {panelid = 800, showtype = 1}
  },
  [3] = {
    id = 3,
    Type = "onoff_camerapoint",
    Params = {groupid = 0, on = false}
  },
  [4] = {
    id = 4,
    Type = "onoff_camerapoint",
    Params = {groupid = 1, on = true}
  },
  [5] = {
    id = 5,
    Type = "dialog",
    Params = {
      dialog = {502338}
    }
  },
  [6] = {
    id = 6,
    Type = "addbutton",
    Params = {
      id = 1,
      text = "##299448",
      eventtype = "goon"
    }
  },
  [7] = {
    id = 7,
    Type = "wait_ui",
    Params = {button = 1}
  },
  [8] = {
    id = 8,
    Type = "action",
    Params = {id = 603}
  },
  [9] = {
    id = 9,
    Type = "play_sound",
    Params = {
      path = "Skill/FirePrison_attack"
    }
  },
  [10] = {
    id = 10,
    Type = "play_effect",
    Params = {
      id = 1,
      path = "Common/KahoPlayshow",
      player = 1,
      ep = 2,
      onshot = 1
    }
  },
  [11] = {
    id = 11,
    Type = "wait_time",
    Params = {time = 4000}
  },
  [12] = {
    id = 12,
    Type = "dialog",
    Params = {
      dialog = {502339}
    }
  },
  [13] = {
    id = 13,
    Type = "addbutton",
    Params = {
      id = 2,
      text = "##299449",
      eventtype = "goon"
    }
  },
  [14] = {
    id = 14,
    Type = "wait_ui",
    Params = {button = 2}
  },
  [15] = {
    id = 15,
    Type = "action",
    Params = {id = 603}
  },
  [16] = {
    id = 16,
    Type = "play_sound",
    Params = {
      path = "Skill/FireWall_fire"
    }
  },
  [17] = {
    id = 17,
    Type = "play_effect_scene",
    Params = {
      id = 2,
      path = "Common/Odins_punish",
      pos = {
        -0.46,
        26.07,
        -0.66
      }
    }
  },
  [18] = {
    id = 18,
    Type = "wait_time",
    Params = {time = 4000}
  },
  [19] = {
    id = 19,
    Type = "action",
    Params = {id = 9}
  },
  [20] = {
    id = 20,
    Type = "dialog",
    Params = {
      dialog = {502340}
    }
  },
  [21] = {
    id = 21,
    Type = "addbutton",
    Params = {
      id = 3,
      text = "##299447",
      eventtype = "goon"
    }
  },
  [22] = {
    id = 22,
    Type = "wait_ui",
    Params = {button = 3}
  },
  [23] = {
    id = 23,
    Type = "remove_effect_scene",
    Params = {id = 2}
  },
  [24] = {
    id = 24,
    Type = "showview",
    Params = {panelid = 800, showtype = 2}
  },
  [25] = {
    id = 25,
    Type = "endfilter",
    Params = {
      fliter = {20}
    }
  },
  [26] = {
    id = 26,
    Type = "onoff_camerapoint",
    Params = {groupid = 1, on = false}
  }
}
Table_PlotQuest_93_fields = {
  "id",
  "Type",
  "Params"
}
return Table_PlotQuest_93
