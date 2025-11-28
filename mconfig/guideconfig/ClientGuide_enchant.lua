ClientGuide_enchant = {
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
      [1] = {
        type = "clicktarget",
        target = "packageview_enchantbutton",
        tostep = 4
      }
    },
    display = {
      target = "packageview_enchantbutton",
      uieffect = "ufx_task_ui_prf",
      effectoffset = {
        0,
        0,
        0
      }
    }
  },
  [4] = {
    events = {
      [1] = {type = "clickmask", tostep = 0}
    },
    display = {
      uieffect = "ufx_task_ui_prf",
      effectoffset = {
        -52.9,
        215.8,
        0
      },
      tiptext = "选择需要附魔的装备,右侧即可出现对应的附魔选项",
      tipuioffset = {
        -311.2,
        75.5,
        0
      }
    }
  }
}
