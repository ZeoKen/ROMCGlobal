local Scene_room_T11 = {
  PVE = {
    bps = {
      {
        ID = 1,
        position = {
          -0.0500000566244125,
          -1.20000004768372,
          2.19000005722046
        },
        range = 0
      }
    }
  },
  Raids = {
    [1900054] = {
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
            0,
            0,
            0
          },
          nextSceneID = 1,
          nextSceneBornPointID = 1,
          type = 0,
          range = 1.29999995231628
        }
      },
      nps = {
        {
          uniqueID = 1,
          ID = 816376,
          position = {
            0,
            0,
            11.0799999237061
          }
        },
        {
          uniqueID = 2,
          ID = 9348,
          position = {
            0,
            0,
            11.0799999237061
          }
        },
        {
          uniqueID = 3,
          ID = 9349,
          position = {
            0,
            0,
            11.0799999237061
          }
        }
      }
    }
  }
}
return Scene_room_T11
