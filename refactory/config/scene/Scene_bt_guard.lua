local Scene_bt_guard = {
  PVE = {
    bps = {
      {
        ID = 1,
        position = {
          26.6599998474121,
          0.239999994635582,
          -17.3099994659424
        },
        range = 0,
        dir = 0
      }
    }
  },
  Raids = {
    [1900100] = {
      bps = {
        {
          ID = 1,
          position = {
            16.5200004577637,
            0,
            -16.9400005340576
          },
          range = 0,
          dir = 0
        },
        {
          ID = 2,
          position = {
            26.4300003051758,
            0,
            -12.2200002670288
          },
          range = 0,
          dir = 0
        }
      },
      nps = {
        {
          uniqueID = 1,
          ID = 453040,
          position = {
            13.1599998474121,
            -0.0700000002980232,
            -12.0299997329712
          },
          dir = 180,
          xdir = 360
        },
        {
          uniqueID = 2,
          ID = 893178,
          position = {
            16,
            0.189999997615814,
            -14
          },
          dir = 180,
          xdir = 360
        },
        {
          uniqueID = 3,
          ID = 453010,
          position = {
            3.60999989509583,
            0.190000057220459,
            7.32999992370605
          },
          dir = 180,
          xdir = 360
        },
        {
          uniqueID = 4,
          ID = 453030,
          position = {
            10.4300003051758,
            0.190000057220459,
            7.34999990463257
          },
          dir = 180,
          xdir = 360
        },
        {
          uniqueID = 5,
          ID = 453020,
          position = {
            16.8299999237061,
            0.190000057220459,
            7.30999994277954
          },
          dir = 180,
          xdir = 360
        },
        {
          uniqueID = 6,
          ID = 893179,
          position = {
            16,
            0.189999997615814,
            -14
          },
          dir = 180,
          xdir = 360
        }
      }
    },
    [1003100] = {
      bps = {
        {
          ID = 1,
          position = {
            17.1200008392334,
            0,
            -8.52999973297119
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
            25.5499992370605,
            0,
            0
          },
          nextSceneID = 1,
          nextSceneBornPointID = 1,
          type = 0,
          range = 1
        }
      },
      nps = {
        {
          uniqueID = 2,
          ID = 801802,
          position = {
            17.2999992370605,
            0,
            -9.5
          },
          dir = 180,
          xdir = 360
        },
        {
          uniqueID = 1,
          ID = 453040,
          position = {
            12.9300003051758,
            0,
            -11.2200002670288
          },
          dir = 180,
          xdir = 360
        }
      }
    }
  },
  MapInfo = {
    [0] = {
      MinPos = {x = -8.81000137329102, y = -29.203332901001},
      Size = {x = 55, y = 55}
    }
  }
}
return Scene_bt_guard
