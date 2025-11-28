local Scene_catufo = {
  PVE = {
    bps = {
      {
        ID = 1,
        position = {
          0.087615966796875,
          0.310000002384186,
          9.38034057617188
        },
        range = 0
      },
      {
        ID = 2,
        position = {
          -7.13174438476563,
          0.150000005960464,
          -0.24969482421875
        },
        range = 0
      },
      {
        ID = 3,
        position = {
          1.2486572265625,
          0.310000002384186,
          -8.96966552734375
        },
        range = 0
      }
    },
    eps = {
      {
        ID = 2,
        commonEffectID = 16,
        position = {
          4.699951171875,
          0.0700000002980232,
          1.03976440429688
        },
        nextSceneID = 11,
        nextSceneBornPointID = 3,
        type = 0,
        range = 1.29999995231628
      }
    }
  },
  Raids = {
    [10006] = {
      nps = {
        {
          uniqueID = 4360,
          ID = 4360,
          position = {
            0.65991747379303,
            0.0450000762939453,
            -2.83029937744141
          }
        }
      }
    }
  },
  MapInfo = {
    [0] = {
      MinPos = {x = -17.0953025817871, y = -19.3536586761475},
      Size = {x = 35, y = 35}
    }
  }
}
return Scene_catufo
