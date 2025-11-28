local Scene_home2_1 = {
  Public = {
    rps = {
      {
        position = {
          10.3900003433228,
          2.22000002861023,
          0.0199999995529652
        },
        type = 1,
        size = {30, 30}
      },
      {
        position = {
          -14.6120004653931,
          0,
          0.119999997317791
        },
        type = 1,
        size = {20, 20}
      }
    }
  },
  PVE = {
    bps = {
      {
        ID = 1,
        position = {
          -0.00999999046325684,
          0.930000007152557,
          -8.31999969482422
        },
        range = 0
      }
    },
    eps = {
      {
        ID = 1,
        commonEffectID = 16,
        position = {
          -0.0800000429153442,
          0.884999990463257,
          -11.8200006484985
        },
        nextSceneID = 1,
        nextSceneBornPointID = 1,
        type = 0,
        range = 1.29999995231628
      }
    }
  },
  Raids = {
    [3008] = {
      bps = {
        {
          ID = 1,
          position = {
            0.0199999995529652,
            0.959999978542328,
            -8.34200000762939
          },
          range = 0
        }
      },
      eps = {
        {
          ID = 1,
          commonEffectID = 16,
          position = {
            -0.110000014305115,
            0.893999993801117,
            -11.8079996109009
          },
          nextSceneID = 3011,
          nextSceneBornPointID = 1,
          type = 0,
          range = 1.29999995231628
        }
      }
    }
  },
  MapInfo = {
    [0] = {
      MinPos = {x = -19.015100479126, y = -22.7444000244141},
      Size = {x = 43, y = 43}
    }
  }
}
return Scene_home2_1
