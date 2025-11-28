local Scene_upgrade_p7 = {
  PVE = {
    bps = {
      {
        ID = 1,
        position = {
          -0.600000023841858,
          0.150000095367432,
          -65.1999969482422
        },
        range = 0
      },
      {
        ID = 2,
        position = {
          -56.4000015258789,
          0,
          31.2999992370605
        },
        range = 0
      },
      {
        ID = 3,
        position = {
          57.9000015258789,
          0.0900001525878906,
          25.2000007629395
        },
        range = 0
      }
    },
    eps = {
      {
        ID = 1,
        commonEffectID = 16,
        position = {
          2.25746011734009,
          -0.0303678512573242,
          -18.7893714904785
        },
        nextSceneID = 1,
        nextSceneBornPointID = 1,
        type = 0,
        range = 1.29999995231628
      }
    },
    nps = {
      {
        uniqueID = 1058,
        ID = 1058,
        position = {
          15.3199996948242,
          4.49129962921143,
          25.3600006103516
        }
      }
    }
  },
  Raids = {
    [1083] = {
      bps = {
        {
          ID = 1,
          position = {
            -13.6305475234985,
            0.21129897236824,
            -8.02997398376465
          },
          range = 0
        }
      },
      nps = {
        {
          uniqueID = 1,
          ID = 806073,
          position = {
            -3.23000001907349,
            0,
            7.30999994277954
          }
        }
      }
    }
  },
  MapInfo = {
    [0] = {
      MinPos = {x = -75, y = -75},
      Size = {x = 150, y = 150}
    }
  }
}
return Scene_upgrade_p7
