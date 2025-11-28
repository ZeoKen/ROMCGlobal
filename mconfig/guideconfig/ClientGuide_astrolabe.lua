ClientGuide_astrolabe = {
  [1] = {
    events = {
      [1] = {
        type = "guideparam",
        param = {trace_packageview_astrolabepos = 1}
      },
      [2] = {
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
        target = "packageview_astrolabeitem",
        tostep = 3
      }
    },
    display = {
      target = "packageview_astrolabeitem",
      uieffect = "ufx_task_ui_prf",
      effectoffset = {
        0,
        0,
        0
      }
    }
  },
  [3] = {
    event = {
      [1] = {
        type = "clicktarget",
        target = "itemtip_applybutton",
        tostep = 0
      }
    },
    display = {
      target = "itemtip_applybutton",
      uieffect = "ufx_task_ui_prf",
      effectoffset = {
        0,
        0,
        0
      }
    }
  }
}
