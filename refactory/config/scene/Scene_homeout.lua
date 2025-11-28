local Scene_homeout = {
  PVE = {
    bps = {
      {
        ID = 1,
        position = {
          -14.8599996566772,
          1.32000005245209,
          -25.7000007629395
        },
        range = 0
      }
    }
  },
  Raids = {
    [3011] = {
      bps = {
        {
          ID = 1,
          position = {
            -10.7399997711182,
            1.11000001430511,
            -28.9200000762939
          },
          range = 0
        },
        {
          ID = 2,
          position = {
            -10.6899995803833,
            1.25999999046326,
            -29.019998550415
          },
          range = 0
        },
        {
          ID = 3,
          position = {
            -19.3500003814697,
            1.28999996185303,
            -29.189998626709
          },
          range = 0
        }
      },
      eps = {
        {
          ID = 1,
          commonEffectID = 16,
          position = {
            -10.6099996566772,
            1.91299998760223,
            -22.0100002288818
          },
          nextSceneID = 3007,
          nextSceneBornPointID = 2,
          type = 0,
          range = 1.29999995231628
        },
        {
          ID = 2,
          commonEffectID = 16,
          position = {
            -10.6099996566772,
            1.9190000295639,
            -22
          },
          nextSceneID = 3007,
          nextSceneBornPointID = 2,
          type = 0,
          range = 1.29999995231628
        },
        {
          ID = 3,
          commonEffectID = 16,
          position = {
            -19.2299995422363,
            1.28999996185303,
            -25.1299991607666
          },
          nextSceneID = 3007,
          nextSceneBornPointID = 2,
          type = 0,
          range = 1.29999995231628
        }
      }
    }
  },
  MapInfo = {
    [0] = {
      MinPos = {x = -59.2000007629395, y = -88.5999984741211},
      Size = {x = 100, y = 100}
    }
  }
}
return Scene_homeout
