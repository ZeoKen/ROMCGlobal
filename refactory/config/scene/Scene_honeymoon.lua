local Scene_honeymoon = {
  PVE = {
    bps = {
      {
        ID = 1,
        position = {
          0,
          0,
          0
        },
        range = 0
      }
    },
    eps = {
      {
        ID = 1,
        commonEffectID = 16,
        position = {
          -1.74300003051758,
          0,
          -2.87899994850159
        },
        nextSceneID = 62,
        nextSceneBornPointID = 2,
        type = 0,
        range = 1.29999995231628
      }
    }
  },
  Raids = {
    [3006] = {
      bps = {
        {
          ID = 1,
          position = {
            -2.23000001907349,
            4.53999996185303,
            8.56999969482422
          },
          range = 0
        }
      },
      eps = {
        {
          ID = 1,
          commonEffectID = 16,
          position = {
            6.82999992370605,
            4.5,
            -6.36999988555908
          },
          nextSceneID = 1,
          nextSceneBornPointID = 1,
          type = 0,
          range = 1.29999995231628
        }
      }
    }
  },
  MapInfo = {
    [0] = {
      MinPos = {x = -17.9599990844727, y = -14.0699996948242},
      Size = {x = 35, y = 35}
    }
  }
}
return Scene_honeymoon
