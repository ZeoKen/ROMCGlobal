ClientGuide_equipstrength = {
  [1] = {
    events = {
      [1] = {
        type = "clicktarget",
        target = "mainview_bagbutton",
        tostep = 2
      }
    },
    display = {
      target = "mainview_bagbutton",
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
        target = "packageview_strengthtab",
        tostep = 3
      }
    },
    display = {
      target = "packageview_strengthtab",
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
        -80.9,
        236.8,
        0
      },
      tiptext = "选择需要强化的部位，右侧即可出现对应的强化选项",
      tipuioffset = {
        -453.3,
        185.3,
        0
      }
    }
  }
}
