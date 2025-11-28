ClientGuide_joinguild = {
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
        target = "mainview_morebord_guildbutton",
        tostep = 3
      }
    },
    display = {
      target = "mainview_morebord_guildbutton",
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
      [1] = {type = "clickmask", tostep = 4}
    },
    display = {
      uieffect = "ufx_task_ui_prf",
      effectoffset = {
        134,
        170.2,
        0
      },
      tiptext = "查看并选择想要加入的公会",
      tipuioffset = {
        196.6,
        243.1,
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
        310.3,
        -278.6,
        0
      },
      tiptext = "点击按钮即可发出公会申请~",
      tipuioffset = {
        -110.9,
        -333.2,
        0
      }
    }
  }
}
