LayerShowHideMode = {ActiveAndDeactive = 1, MoveOutAndMoveIn = 2}
UIViewType = {
  SceneNameLayer = {
    name = "角色场景UI",
    depth = 0
  },
  BlindLayer = {
    name = "场景致盲遮罩",
    depth = 1
  },
  SniperLayer = {
    name = "鹰眼层级",
    depth = 2,
    closeOtherLayer = {
      NormalLayer = {},
      DialogLayer = {},
      ChitchatLayer = {},
      TeamLayer = {}
    }
  },
  MainLayer = {
    name = "主界面",
    depth = 3,
    reEntnerNotDestory = true,
    showHideMode = LayerShowHideMode.ActiveAndDeactive
  },
  ReviveLayer = {
    name = "复活层级",
    depth = 4,
    closeOtherLayer = {
      CheckLayer = {},
      NormalLayer = {},
      PopUpLayer = {},
      TipLayer = {},
      FocusLayer = {},
      DialogLayer = {},
      ChatroomLayer = {},
      ChitchatLayer = {},
      ChatLayer = {},
      ShieldingLayer = {},
      SniperLayer = {}
    },
    hideOtherLayer = {
      GuideLayer = {},
      Popup10Layer = {},
      SystemOpenLayer = {},
      GOGuideLayer = {}
    }
  },
  ChatroomLayer = {
    name = "好友",
    depth = 5,
    closeOtherLayer = {
      FocusLayer = {},
      DialogLayer = {},
      TipLayer = {},
      TeamLayer = {},
      ChatLayer = {},
      SniperLayer = {}
    }
  },
  BoothLayer = {
    name = "摆摊",
    depth = 6,
    hideOtherLayer = {
      MainLayer = {},
      NormalLayer = {}
    },
    closeOtherLayer = {
      FocusLayer = {},
      DialogLayer = {},
      TipLayer = {},
      TeamLayer = {},
      ChatLayer = {},
      SniperLayer = {}
    }
  },
  InterstitialLayer = {
    name = "全屏界面",
    depth = 7,
    coliderColor = Color(0, 0, 0, 0.00392156862745098),
    hideOtherLayer = {
      ChatroomLayer = {},
      DialogLayer = {},
      BoothLayer = {},
      MainLayer = {}
    },
    closeOtherLayer = {
      ChatLayer = {},
      FocusLayer = {},
      TeamLayer = {},
      NormalLayer = {},
      SniperLayer = {}
    }
  },
  ChasingViewLayer = {
    name = "全屏界面",
    depth = 8,
    coliderColor = Color(0, 0, 0, 0.00392156862745098),
    hideOtherLayer = {
      ChatroomLayer = {},
      BoothLayer = {},
      MainLayer = {}
    },
    closeOtherLayer = {
      ChatLayer = {},
      FocusLayer = {},
      TeamLayer = {},
      NormalLayer = {},
      SniperLayer = {}
    }
  },
  ChitchatLayer = {
    name = "聊天栏(左)",
    depth = 9,
    closeOtherLayer = {
      FocusLayer = {},
      DialogLayer = {},
      TipLayer = {},
      TeamLayer = {},
      ChatLayer = {},
      NormalLayer = {}
    },
    reEntnerNotDestory = true
  },
  TeamLayer = {
    name = "组队界面（不屏蔽主界面）",
    depth = 10,
    coliderColor = Color(0, 0, 0, 0.00392156862745098),
    hideOtherLayer = {
      ChatroomLayer = {},
      NormalLayer = {},
      ChitchatLayer = {},
      BoothLayer = {}
    },
    closeOtherLayer = {
      ChatLayer = {},
      TipLayer = {}
    }
  },
  UIScreenEffectLayer = {
    name = "全屏UI特效层",
    depth = 11
  },
  FocusLayer = {
    name = "聚焦层级",
    depth = 12,
    hideOtherLayer = {
      MainLayer = {},
      CheckLayer = {},
      NormalLayer = {},
      TipLayer = {},
      ChatroomLayer = {},
      BoothLayer = {},
      TeamLayer = {}
    },
    closeOtherLayer = {
      ChatLayer = {},
      ChitchatLayer = {},
      SniperLayer = {}
    }
  },
  DialogMaskLayer = {
    name = "对话挡板层级",
    depth = 13,
    hideOtherLayer = {
      ChatroomLayer = {},
      BoothLayer = {},
      MainLayer = {}
    },
    closeOtherLayer = {
      ChatLayer = {},
      FocusLayer = {},
      TeamLayer = {},
      NormalLayer = {},
      SniperLayer = {}
    }
  },
  DialogLayer = {
    name = "对话层级",
    depth = 14,
    coliderColor = Color(0, 0, 0, 0.00392156862745098),
    hideOtherLayer = {
      CheckLayer = {},
      MainLayer = {},
      TeamLayer = {},
      MovieLayer = {}
    },
    closeOtherLayer = {
      FocusLayer = {},
      PopUpLayer = {},
      TipLayer = {},
      ChatLayer = {},
      SniperLayer = {},
      NormalLayer = {},
      ChatroomLayer = {},
      BoothLayer = {},
      ChitchatLayer = {},
      BuildingLayer = {}
    }
  },
  ChatLayer = {
    name = "表情聊天层级",
    depth = 15
  },
  BuildingLayer = {
    name = "建造层级",
    depth = 16,
    hideOtherLayer = {
      MainLayer = {}
    },
    closeOtherLayer = {
      ChatLayer = {},
      DialogLayer = {},
      PopUpLayer = {},
      TipLayer = {},
      ChatroomLayer = {},
      ChitchatLayer = {},
      Lv4PopUpLayer = {},
      CheckLayer = {},
      NormalLayer = {},
      FocusLayer = {},
      SniperLayer = {}
    }
  },
  NormalLayer = {
    name = "二级界面层级",
    depth = 17,
    coliderColor = Color(0, 0, 0, 0.00392156862745098),
    hideOtherLayer = {
      MainLayer = {},
      ChatroomLayer = {}
    },
    closeOtherLayer = {
      ChatLayer = {},
      FocusLayer = {},
      SniperLayer = {},
      ChitchatLayer = {},
      BuildingLayer = {}
    }
  },
  PopUpLayer = {
    name = "三级弹出界面层级",
    depth = 18,
    coliderColor = Color(0, 0, 0, 0.7843137254901961)
  },
  CheckLayer = {
    name = "查看详情层级",
    depth = 19,
    hideOtherLayer = {
      MainLayer = {},
      ChatroomLayer = {},
      ChitchatLayer = {},
      PopUpLayer = {},
      NormalLayer = {},
      TeamLayer = {}
    },
    closeOtherLayer = {
      ChatLayer = {}
    }
  },
  DragLayer = {
    name = "拖动层级",
    depth = 20
  },
  TipLayer = {
    name = "提示界面层级",
    depth = 21
  },
  Lv4PopUpLayer = {
    name = "四级弹出层级",
    depth = 22,
    coliderColor = Color(0, 0, 0, 0.7843137254901961)
  },
  IConfirmLayer = {
    name = "邀请确认层级",
    depth = 23,
    hideOtherLayer = {},
    closeOtherLayer = {
      FocusLayer = {}
    }
  },
  ConfirmLayer = {
    name = "确认框层级",
    depth = 24,
    coliderColor = Color(0, 0, 0, 0.00392156862745098)
  },
  GuideLayer = {
    name = "引导层级",
    depth = 25
  },
  SystemOpenLayer = {
    name = "系统开启层级",
    depth = 26,
    hideOtherLayer = {
      FocusLayer = {},
      CheckLayer = {},
      NormalLayer = {},
      PopUpLayer = {},
      TipLayer = {},
      GuideLayer = {},
      ConfirmLayer = {},
      Popup10Layer = {},
      ChatroomLayer = {},
      ChitchatLayer = {},
      TeamLayer = {}
    },
    closeOtherLayer = {
      ChatLayer = {}
    },
    coliderColor = Color(0, 0, 0, 0.00392156862745098),
    reEntnerNotDestory = true,
    showHideMode = LayerShowHideMode.ActiveAndDeactive
  },
  MovieLayer = {
    name = "观看电影层级",
    depth = 27,
    hideOtherLayer = {
      FocusLayer = {},
      MainLayer = {},
      CheckLayer = {},
      NormalLayer = {},
      PopUpLayer = {},
      TipLayer = {},
      BoardLayer = {},
      GuideLayer = {},
      DragLayer = {},
      ConfirmLayer = {},
      Popup10Layer = {},
      ChatroomLayer = {},
      ChitchatLayer = {}
    },
    closeOtherLayer = {
      ChatLayer = {},
      SniperLayer = {}
    },
    coliderColor = Color(0, 0, 0, 0.00392156862745098)
  },
  GOGuideLayer = {
    name = "引导开始确认层",
    depth = 28,
    closeOtherLayer = {
      FocusLayer = {},
      CheckLayer = {},
      NormalLayer = {},
      PopUpLayer = {},
      TipLayer = {},
      GuideLayer = {},
      ConfirmLayer = {},
      Popup10Layer = {},
      ChatLayer = {},
      ChatroomLayer = {},
      ChitchatLayer = {},
      TeamLayer = {},
      Show3D2DLayer = {},
      ProcessLayer = {},
      SniperLayer = {}
    },
    coliderColor = Color(0, 0, 0, 0.00392156862745098),
    reEntnerNotDestory = true
  },
  Show3D2DLayer = {
    name = "3D/2D展示层级",
    depth = 29,
    hideOtherLayer = {
      FocusLayer = {},
      TipLayer = {},
      Popup10Layer = {},
      DialogLayer = {},
      SystemOpenLayer = {},
      MainLayer = {},
      NormalLayer = {},
      PopUpLayer = {},
      CheckLayer = {},
      TeamLayer = {},
      ChitchatLayer = {},
      ChatroomLayer = {}
    },
    coliderColor = Color(0, 0, 0, 0.7843137254901961)
  },
  ShareLayer = {
    name = "分享层级",
    depth = 30,
    hideOtherLayer = {
      FocusLayer = {},
      TipLayer = {},
      Popup10Layer = {},
      DialogLayer = {},
      SystemOpenLayer = {},
      MainLayer = {},
      NormalLayer = {},
      PopUpLayer = {},
      CheckLayer = {},
      TeamLayer = {},
      ChitchatLayer = {},
      ChatroomLayer = {},
      Show3D2DLayer = {}
    }
  },
  FloatLayer = {
    name = "浮动框层级",
    depth = 31
  },
  Popup10Layer = {
    name = "弹框10层级",
    depth = 32,
    coliderColor = Color(0, 0, 0, 0.00392156862745098),
    reEntnerNotDestory = true,
    closeOtherLayer = {
      TipLayer = {},
      TeamLayer = {},
      ChatLayer = {}
    },
    showHideMode = LayerShowHideMode.ActiveAndDeactive
  },
  PerformanceLayer = {
    name = "画质选择层级",
    depth = 33,
    hideOtherLayer = {
      SystemOpenLayer = {},
      MainLayer = {},
      FloatLayer = {},
      Popup10Layer = {},
      NormalLayer = {},
      PopUpLayer = {},
      ChatLayer = {},
      CheckLayer = {},
      DialogLayer = {},
      DragLayer = {},
      Lv4PopUpLayer = {},
      TipLayer = {},
      ReviveLayer = {},
      BoothLayer = {},
      ChitchatLayer = {},
      GOGuideLayer = {}
    }
  },
  LevelUpLayer = {
    name = "全屏升级层级",
    depth = 34
  },
  LoadingLayer = {
    name = "加载界面层级",
    depth = 35,
    hideOtherLayer = {
      MainLayer = {},
      ChatLayer = {}
    },
    closeOtherLayer = {
      FocusLayer = {}
    },
    coliderColor = Color(0, 0, 0, 0.00392156862745098)
  },
  TouchLayer = {
    name = "UI触摸反馈层级",
    depth = 36
  },
  ToolsLayer = {
    name = "工具层级",
    depth = 37
  },
  WarnLayer = {
    name = "警告框层级",
    depth = 38,
    reEntnerNotDestory = true
  },
  ShieldingLayer = {
    name = "屏保层级",
    depth = 39,
    coliderColor = Color(0, 0, 0, 0.00392156862745098)
  },
  VideoLayer = {
    name = "视频（珍藏品）播放层级",
    depth = 40,
    hideOtherLayer = {
      IConfirmLayer = {},
      BoardLayer = {},
      ConfirmLayer = {},
      Popup10Layer = {},
      ChatroomLayer = {},
      ChitchatLayer = {},
      ReviveLayer = {}
    },
    coliderColor = Color(0, 0, 0, 0.00392156862745098)
  },
  ProcessLayer = {
    name = "弹幕层级",
    depth = 41,
    reEntnerNotDestory = true
  },
  BoardLayer = {
    name = "公告层级",
    depth = 42,
    reEntnerNotDestory = true
  }
}
UIRollBackID = {
  353,
  352,
  3,
  720,
  495,
  1070,
  547,
  1620,
  10030,
  1848,
  3711
}
