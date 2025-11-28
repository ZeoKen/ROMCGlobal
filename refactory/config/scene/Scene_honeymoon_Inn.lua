local Scene_honeymoon_Inn = {
  Public = {
    rps = {
      {
        position = {
          6.35592222213745,
          2.36167907714844,
          14.4693956375122
        },
        type = 1,
        size = {8, 10}
      }
    }
  },
  PVE = {
    bps = {
      {
        ID = 1,
        position = {
          -7.96046829223633,
          1.23703122138977,
          21.1970291137695
        },
        range = 0
      }
    },
    eps = {
      {
        ID = 1,
        commonEffectID = 16,
        position = {
          -7.48046875,
          1.20203113555908,
          25.3070297241211
        },
        nextSceneID = 62,
        nextSceneBornPointID = 2,
        type = 0,
        range = 1.29999995231628
      }
    }
  },
  Raids = {
    [1003184] = {
      bps = {
        {
          ID = 1,
          position = {
            6.92999982833862,
            1.15100002288818,
            2.55999994277954
          },
          range = 0
        }
      }
    },
    [10026] = {
      bps = {
        {
          ID = 1,
          position = {
            -7.98999977111816,
            1.08000004291534,
            21.2000007629395
          },
          range = 0
        }
      },
      eps = {
        {
          ID = 1,
          commonEffectID = 16,
          position = {
            -7.46999979019165,
            1.26999998092651,
            25.2700004577637
          },
          nextSceneID = 62,
          nextSceneBornPointID = 2,
          type = 0,
          range = 1.29999995231628
        }
      }
    }
  },
  MapInfo = {
    [0] = {
      MinPos = {x = -18.2299995422363, y = -10.1800003051758},
      Size = {x = 40, y = 40}
    }
  }
}
return Scene_honeymoon_Inn
