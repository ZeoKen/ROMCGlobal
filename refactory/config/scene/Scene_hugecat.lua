local Scene_hugecat = {
  PVE = {
    bps = {
      {
        ID = 1,
        position = {
          -21.3600006103516,
          0.592000007629395,
          -10.039999961853
        },
        range = 0,
        dir = 155.158615112305
      }
    },
    eps = {
      {
        ID = 1,
        commonEffectID = 16,
        exitType = 0,
        position = {
          14.7274608612061,
          19.0496311187744,
          33.0706253051758
        },
        nextSceneID = 1011,
        nextSceneBornPointID = 4,
        type = 0,
        range = 1
      },
      {
        ID = 2,
        commonEffectID = 16,
        exitType = 0,
        position = {
          -35.3325424194336,
          7.18963146209717,
          -81.6093673706055
        },
        nextSceneID = 0,
        nextSceneBornPointID = 3,
        type = 0,
        range = 1
      },
      {
        ID = 3,
        commonEffectID = 16,
        exitType = 0,
        position = {
          31.7074584960938,
          7.445631980896,
          107.430633544922
        },
        nextSceneID = 0,
        nextSceneBornPointID = 4,
        type = 0,
        range = 1
      },
      {
        ID = 4,
        commonEffectID = 16,
        exitType = 0,
        position = {
          161.507461547852,
          8.91963195800781,
          13.2306289672852
        },
        nextSceneID = 0,
        nextSceneBornPointID = 5,
        type = 0,
        range = 1
      }
    },
    nps = {
      {
        uniqueID = 0,
        ID = 10072,
        position = {
          109.930206298828,
          7.82129859924316,
          46.8694610595703
        }
      }
    }
  },
  Raids = {
    [1900107] = {
      bps = {
        {
          ID = 1,
          position = {
            0.242285892367363,
            1.07890605926514,
            -5.19343328475952
          },
          range = 0,
          dir = 0
        }
      },
      eps = {
        {
          ID = 1,
          commonEffectID = 16,
          exitType = 0,
          position = {
            -21.4125366210938,
            0.439631462097168,
            -8.29936599731445
          },
          nextSceneID = 62,
          nextSceneBornPointID = 2,
          type = 0,
          range = 1
        }
      }
    },
    [20006] = {
      bps = {
        {
          ID = 1,
          position = {
            1.14228451251984,
            3.29890632629395,
            -31.8334312438965
          },
          range = 0,
          dir = 0
        }
      },
      nps = {
        {
          uniqueID = 53371,
          ID = 53371,
          position = {
            3.84000325202942,
            6.98000001907349,
            18.2099952697754
          }
        }
      }
    },
    [20007] = {
      bps = {
        {
          ID = 1,
          position = {
            1.14228451251984,
            3.29890632629395,
            -31.8334312438965
          },
          range = 0,
          dir = 0
        }
      },
      nps = {
        {
          uniqueID = 53402,
          ID = 53402,
          position = {
            3.84000325202942,
            6.98000001907349,
            18.2099952697754
          }
        }
      }
    },
    [20005] = {
      bps = {
        {
          ID = 1,
          position = {
            1.14228451251984,
            3.29890632629395,
            -31.8334312438965
          },
          range = 0,
          dir = 0
        }
      },
      nps = {
        {
          uniqueID = 4577,
          ID = 4577,
          position = {
            -25.7299976348877,
            0.759999990463257,
            0.0300045013427734
          }
        }
      }
    }
  },
  MapInfo = {
    [0] = {
      MinPos = {x = -30.4799995422363, y = -25.5599994659424},
      Size = {x = 50, y = 50}
    }
  }
}
return Scene_hugecat
