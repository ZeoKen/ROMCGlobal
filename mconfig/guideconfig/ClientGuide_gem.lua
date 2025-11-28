ClientGuide_gem = {
  [1] = {
    events = {
      [1] = {
        type = "guideparam",
        param = {trace_packageview_gempos = 1}
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
        target = "packageview_gemitem",
        tostep = 3
      }
    },
    display = {
      target = "packageview_gemitem",
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
        target = "itemtip_embedgembutton",
        tostep = 4
      }
    },
    display = {
      target = "itemtip_embedgembutton",
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
      [1] = {type = "clickmask", tostep = 5}
    },
    display = {
      uieffect = "ufx_task_ui_prf",
      effectoffset = {
        172.8,
        -78.9,
        0
      },
      tiptext = "点击小六边形放置属性符文",
      tipuioffset = {
        237.6,
        7.7,
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
        92.2,
        -27.2,
        0
      },
      tiptext = "点击大六边形放置技能符文，只有相连的属性符文满足技能符文所需的类型时才会生效",
      tipuioffset = {
        160,
        56.9,
        0
      }
    }
  }
}
