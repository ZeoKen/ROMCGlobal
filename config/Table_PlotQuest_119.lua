Table_PlotQuest_119 = {
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
    Type = "set_dir",
    Params = {player = 1, dir = 177}
  },
  [4] = {
    id = 4,
    Type = "addbutton",
    Params = {
      id = 1,
      text = "##309004",
      eventtype = "goon"
    }
  },
  [5] = {
    id = 5,
    Type = "wait_ui",
    Params = {button = 1}
  },
  [6] = {
    id = 6,
    Type = "play_sound",
    Params = {
      path = "Common/wataru_zhuanzhi7"
    }
  },
  [7] = {
    id = 7,
    Type = "play_effect_scene",
    Params = {
      id = 1,
      path = "Skill/Eff_nvshenchuchang",
      pos = {
        0.08,
        3.37,
        -4.59
      },
      onshot = 1,
      ignoreNavMesh = 1
    }
  },
  [8] = {
    id = 8,
    Type = "play_effect_scene",
    Params = {
      id = 2,
      path = "Skill/Eff_nvshenchuchang",
      pos = {
        0.08,
        3.37,
        -4.59
      },
      onshot = 1,
      ignoreNavMesh = 1
    }
  },
  [9] = {
    id = 9,
    Type = "endfilter",
    Params = {
      fliter = {7}
    }
  }
}
Table_PlotQuest_119_fields = {
  "id",
  "Type",
  "Params"
}
return Table_PlotQuest_119
