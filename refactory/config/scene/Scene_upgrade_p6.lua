local Scene_upgrade_p6 = {
  PVE = {
    bps = {
      {
        ID = 1,
        position = {
          -7.74860382080078E-6,
          0,
          1.52587890625E-5
        },
        range = 0
      },
      {
        ID = 2,
        position = {
          -8.22544097900391E-6,
          0.120000839233398,
          1.52587890625E-5
        },
        range = 0
      },
      {
        ID = 3,
        position = {
          -8.22544097900391E-6,
          0.120000839233398,
          3.0517578125E-5
        },
        range = 0
      },
      {
        ID = 4,
        position = {
          -8.22544097900391E-6,
          0.120000839233398,
          1.52587890625E-5
        },
        range = 0
      }
    },
    eps = {
      {
        ID = 1,
        commonEffectID = 16,
        position = {
          -8.70227813720703E-6,
          0.239999771118164,
          11.160026550293
        },
        nextSceneID = 2,
        nextSceneBornPointID = 1,
        type = 0,
        range = 1.29999995231628
      },
      {
        ID = 2,
        commonEffectID = 16,
        position = {
          -8.70227813720703E-6,
          0.239999771118164,
          11.160041809082
        },
        nextSceneID = 26,
        nextSceneBornPointID = 1,
        type = 0,
        range = 1.29999995231628
      },
      {
        ID = 3,
        commonEffectID = 16,
        position = {
          -8.70227813720703E-6,
          0.239999771118164,
          11.1600532531738
        },
        nextSceneID = 42,
        nextSceneBornPointID = 1,
        type = 0,
        range = 1.29999995231628
      },
      {
        ID = 4,
        commonEffectID = 16,
        position = {
          -8.70227813720703E-6,
          0.239999771118164,
          11.160041809082
        },
        nextSceneID = 26,
        nextSceneBornPointID = 1,
        type = 0,
        range = 1.29999995231628
      }
    }
  },
  Raids = {
    [1003175] = {
      bps = {
        {
          ID = 4,
          position = {
            -8.22544097900391E-6,
            0.120000839233398,
            1.52587890625E-5
          },
          range = 0
        }
      },
      eps = {
        {
          ID = 4,
          commonEffectID = 16,
          position = {
            -8.70227813720703E-6,
            0.239999771118164,
            11.160041809082
          },
          nextSceneID = 26,
          nextSceneBornPointID = 1,
          type = 0,
          range = 1.29999995231628
        }
      }
    },
    [1000351] = {
      bps = {
        {
          ID = 3,
          position = {
            -8.22544097900391E-6,
            0.120000839233398,
            3.0517578125E-5
          },
          range = 0
        }
      },
      eps = {
        {
          ID = 3,
          commonEffectID = 16,
          position = {
            -8.70227813720703E-6,
            0.239999771118164,
            11.1600532531738
          },
          nextSceneID = 42,
          nextSceneBornPointID = 1,
          type = 0,
          range = 1.29999995231628
        }
      }
    },
    [1003174] = {
      bps = {
        {
          ID = 2,
          position = {
            -8.22544097900391E-6,
            0.120000839233398,
            1.52587890625E-5
          },
          range = 0
        }
      },
      eps = {
        {
          ID = 2,
          commonEffectID = 16,
          position = {
            -8.70227813720703E-6,
            0.239999771118164,
            11.160041809082
          },
          nextSceneID = 26,
          nextSceneBornPointID = 1,
          type = 0,
          range = 1.29999995231628
        }
      }
    },
    [1000349] = {
      bps = {
        {
          ID = 1,
          position = {
            -7.74860382080078E-6,
            0,
            1.52587890625E-5
          },
          range = 0
        }
      },
      eps = {
        {
          ID = 1,
          commonEffectID = 16,
          position = {
            -8.70227813720703E-6,
            0.239999771118164,
            11.160026550293
          },
          nextSceneID = 2,
          nextSceneBornPointID = 1,
          type = 0,
          range = 1.29999995231628
        }
      }
    }
  },
  MapInfo = {
    [0] = {
      MinPos = {x = -16.0799999237061, y = -15.7399997711182},
      Size = {x = 32, y = 32}
    }
  }
}
return Scene_upgrade_p6
