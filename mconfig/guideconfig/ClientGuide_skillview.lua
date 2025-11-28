ClientGuide_skillview = {
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
        target = "mainview_morebord_skillbutton",
        tostep = 3
      }
    },
    display = {
      target = "mainview_morebord_skillbutton",
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
      tiptext = "调整技能加点后，点击右侧保存按钮即可生效",
      tipuioffset = {
        -599.9,
        -190.6,
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
        -192.6,
        283.1,
        0
      },
      tiptext = "也可点击“推荐加点”查看职业流派推荐技能加点",
      tipuioffset = {
        -379,
        160.98,
        0
      }
    }
  }
}
