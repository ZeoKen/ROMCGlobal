local Scene_sc_aebtfb_004 = {
  PVE = {
    bps = {
      {
        ID = 1,
        position = {
          13.4359998703003,
          16.3479995727539,
          -137.600006103516
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
          70.2974548339844,
          18.4966316223145,
          74.5706329345703
        },
        nextSceneID = 63,
        nextSceneBornPointID = 6,
        type = 0,
        range = 1.29999995231628
      }
    }
  },
  Raids = {
    [7200] = {
      bps = {
        {
          ID = 1,
          position = {
            -4.19000005722046,
            -9.4399995803833,
            1.8400000333786
          },
          range = 0,
          dir = 0
        },
        {
          ID = 2,
          position = {
            -0.0599999986588955,
            -9.18000030517578,
            25.7000007629395
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
            0.0299999993294477,
            -9,
            56.6500015258789
          },
          nextSceneID = 126,
          nextSceneBornPointID = 1,
          type = 0,
          range = 1
        }
      },
      nps = {
        {
          uniqueID = 1,
          ID = 276100,
          position = {
            0.0399999991059303,
            -8.97999954223633,
            51.2299995422363
          },
          dir = 180,
          xdir = 360
        },
        {
          uniqueID = 10,
          ID = 9341,
          position = {
            -2.00999999046326,
            -9.34000015258789,
            20.25
          },
          dir = 180,
          xdir = 360
        },
        {
          uniqueID = 11024,
          ID = 11024,
          position = {
            -5,
            -9.5,
            27.2000007629395
          },
          dir = 90,
          xdir = 360
        }
      }
    }
  },
  MapInfo = {
    [0] = {
      MinPos = {x = -45.0999984741211, y = -19.5},
      Size = {x = 90, y = 90}
    }
  }
}
return Scene_sc_aebtfb_004
