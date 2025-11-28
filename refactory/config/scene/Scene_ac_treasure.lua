local Scene_ac_treasure = {
  Public = {
    rps = {
      {
        position = {
          9.083984375,
          -2.943359375,
          -33.2015609741211
        },
        type = 1,
        size = {30, 120}
      }
    }
  },
  PVE = {
    bps = {
      {
        ID = 1,
        position = {
          5.19999217987061,
          -0.932999610900879,
          -80.9179916381836
        },
        range = 0
      }
    },
    eps = {
      {
        ID = 1,
        commonEffectID = 16,
        position = {
          4.6199951171875,
          -0.923999786376953,
          -84.6899719238281
        },
        nextSceneID = 1080,
        nextSceneBornPointID = 1,
        type = 0,
        range = 1
      }
    }
  },
  Raids = {
    [1003192] = {
      bps = {
        {
          ID = 1,
          position = {
            5.22000217437744,
            -0.790000915527344,
            -80.9100036621094
          },
          range = 0
        }
      },
      eps = {
        {
          ID = 1,
          commonEffectID = 16,
          position = {
            4.62999534606934,
            -0.886999607086182,
            -84.6699752807617
          },
          nextSceneID = 1080,
          nextSceneBornPointID = 1,
          type = 0,
          range = 1
        }
      }
    },
    [1003191] = {
      bps = {
        {
          ID = 2,
          position = {
            5.22000217437744,
            -0.790000915527344,
            -80.9100036621094
          },
          range = 0
        }
      },
      eps = {
        {
          ID = 2,
          commonEffectID = 16,
          position = {
            4.62999534606934,
            -0.886999607086182,
            -84.6699752807617
          },
          nextSceneID = 1080,
          nextSceneBornPointID = 1,
          type = 0,
          range = 1
        }
      }
    }
  },
  MapInfo = {
    [0] = {
      MinPos = {x = -87.3000030517578, y = -94.6999969482422},
      Size = {x = 140, y = 140}
    }
  }
}
return Scene_ac_treasure
