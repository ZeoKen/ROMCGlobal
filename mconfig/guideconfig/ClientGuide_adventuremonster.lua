ClientGuide_adventuremonster = {
  [1] = {
    events = {
      [1] = {
        type = "clicktarget",
        target = "mainview_morebutton",
        tostep = 2
      }
    },
    display = {
      target = "mainview_morebutton",
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
      [1] = {
        type = "clicktarget",
        target = "mainview_morebord_adventurebutton",
        tostep = 3
      }
    },
    display = {
      target = "mainview_morebord_adventurebutton",
      uieffect = "ufx_task_ui_prf",
      effectoffset = {
        3.5,
        15.07,
        0
      }
    }
  },
  [3] = {
    events = {
      [1] = {
        type = "clicktarget",
        target = "adventureview_monstertab",
        tostep = 4
      }
    },
    display = {
      target = "adventureview_monstertab",
      uieffect = "ufx_task_ui_prf",
      effectoffset = {
        0,
        47.34,
        0
      }
    }
  },
  [4] = {
    events = {
      [1] = {type = "clickmask", tostep = 5}
    },
    display = {
      uieffect = "ufx_task_ui_prf",
      effectoffset = {
        54.31,
        233.2,
        0
      },
      tiptext = "前往魔物出现地点击杀魔物即可解锁魔物",
      tipuioffset = {
        -332.1,
        170.1,
        0
      }
    }
  },
  [5] = {
    events = {
      [1] = {type = "clickmask", tostep = 0}
    },
    display = {
      uieffect = "ufx_task_ui_prf",
      effectoffset = {
        -259.6,
        -12.2,
        0
      },
      tiptext = "使用照相机给魔物拍一张美美的照片即可解锁魔物详情",
      tipuioffset = {
        -183.7,
        81,
        0
      }
    }
  }
}
