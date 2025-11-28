ClientGuide_battletime = {
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
        target = "mainview_morebord_setbutton",
        tostep = 3
      }
    },
    display = {
      target = "mainview_morebord_setbutton",
      uieffect = "ufx_task_ui_prf",
      effectoffset = {
        0,
        0,
        0
      }
    }
  },
  [3] = {
    events = {
      [1] = {type = "clickmask", tostep = 0}
    },
    display = {
      uieffect = "ufx_task_ui_prf",
      effectoffset = {
        87,
        178.5,
        0
      },
      tiptext = "每天的战斗时长可以在这里查看哦",
      tipuioffset = {
        167.5,
        236,
        0
      }
    }
  }
}
