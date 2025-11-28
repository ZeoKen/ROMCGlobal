ClientGuide_hireservant = {
  [1] = {
    events = {
      [1] = {
        type = "clicktarget",
        target = "mainview_servantbutton",
        tostep = 2
      }
    },
    display = {
      target = "mainview_servantbutton",
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
        type = "targetshow",
        target = "chooseservantview_confirmbord",
        tostep = 3
      },
      [2] = {
        type = "targethide",
        target = "chooseservantview_servant5",
        tostep = 1
      }
    },
    display = {
      targets = {
        [1] = "chooseservantview_servant5"
      },
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
        target = "chooseservantview_confirmbutton",
        tostep = 0
      },
      [2] = {
        type = "targethide",
        target = "chooseservantview_confirmbord",
        tostep = 2
      }
    },
    display = {
      target = "chooseservantview_confirmbutton",
      uieffect = "ufx_task_ui_prf",
      effectoffset = {
        0,
        0,
        0
      }
    }
  }
}
