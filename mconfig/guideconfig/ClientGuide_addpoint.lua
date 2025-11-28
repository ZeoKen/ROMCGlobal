ClientGuide_addpoint = {
  [1] = {
    events = {
      [1] = {
        type = "clicktarget",
        target = "mainview_myselfheadcell",
        tostep = 2
      }
    },
    display = {
      target = "mainview_myselfheadcell",
      uieffect = "ufx_task_ui_prf",
      effectoffset = {
        0,
        0,
        0
      }
    }
  },
  [2] = {
    events = {
      [1] = {type = "clickmask", tostep = 3}
    },
    display = {
      uieffect = "00HlightArrow",
      effectoffset = {
        108.5,
        -294.9,
        0
      },
      tiptext = "此处为玩家可用于消耗的素质点数",
      tipuioffset = {
        -61,
        -212.7,
        0
      }
    }
  },
  [3] = {
    events = {
      [1] = {type = "clickmask", tostep = 4}
    },
    display = {
      uieffect = "00HlightArrow",
      effectoffset = {
        481.8,
        119.1,
        0
      },
      tiptext = "点击右侧按钮可自由分配素质点",
      tipuioffset = {
        301.8,
        197.4,
        0
      }
    }
  },
  [4] = {
    events = {
      [1] = {type = "clickmask", tostep = 0}
    },
    display = {
      uieffect = "00HlightArrow",
      effectoffset = {
        310.3,
        -278.6,
        0
      },
      tiptext = "也可点击“加点方案”查看职业流派推荐加点并进行一键加点",
      tipuioffset = {
        130.9,
        -196.9,
        0
      }
    }
  }
}
