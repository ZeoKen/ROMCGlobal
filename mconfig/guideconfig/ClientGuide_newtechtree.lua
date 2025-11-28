ClientGuide_newtechtree = {
  [1] = {
    events = {
      [1] = {
        type = "clicktarget",
        target = "mainview_techtreebutton",
        tostep = 2
      }
    },
    display = {
      target = "mainview_techtreebutton",
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
      uieffect = "ufx_task_ui_prf",
      effectoffset = {
        144.76,
        -245.4,
        0
      },
      tiptext = "点击注入可消耗心之刹那提升心之始源等级",
      tipuipos = {
        210.1,
        -152,
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
        -248.1,
        308.7,
        0
      },
      tiptext = "心之刹那不足时，点击此处可查看获取方式",
      tipuipos = {
        -456.39,
        181.7,
        0
      }
    }
  }
}
