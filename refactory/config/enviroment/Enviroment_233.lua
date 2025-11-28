local Enviroment_233 = {
  global = {
    sunDir = {
      0.0594400465488434,
      -0.99619460105896,
      0.0637417584657669,
      0
    },
    sunColor = {
      1,
      0.959416151046753,
      0.820754706859589,
      1
    }
  },
  fog = {
    fog = true,
    fogColor = {
      0.288625836372375,
      0.559618473052979,
      0.886792421340942,
      1
    },
    fogMode = 1,
    fogStartDistance = 12,
    fogEndDistance = 110,
    globalFogTuner = 0,
    heightFogMode = 1,
    heightFogCutoff = 9.99999974737875E-6,
    heightFogStart = -20,
    heightFogEnd = 256,
    scatteringDensity = 1.10000002384186,
    scatteringFalloff = 4,
    scatteringExponent = 40,
    heightFogMinOpacity = 0,
    radiusFogFactor = 1,
    nearFogColor = {
      0.223211094737053,
      0.588817536830902,
      0.830188691616058,
      1
    },
    nearFogDistance = 10,
    farFogColor = {
      0.288625836372375,
      0.559618473052979,
      0.886792421340942,
      1
    },
    farFogDistance = 80,
    enableLocalHeightFog = 0,
    localHeightFogStart = 0,
    localHeightFogEnd = 1,
    localHeightFogColor = {
      0,
      0,
      0,
      0
    }
  },
  wind = {
    sheenColorNear = {
      0.301886796951294,
      0.255606979131699,
      0.131007477641106,
      1
    },
    sheenColorFar = {
      0.443137288093567,
      0.368627458810806,
      0.0980392247438431,
      1
    },
    sheenDistanceNear = 31,
    sheenDistanceFar = 39,
    sheenScatterMinInten = 0.5,
    sheenPower = 6,
    windTexTiling = {
      5,
      5,
      0,
      0
    },
    windAngle = 170,
    windWaveSpeed = 0.150000005960464,
    windBendStrength = 0.152999997138977,
    windWaveSwingEffect = 0.100000001490116,
    windMask = 0.5,
    windSheenInten = 1,
    windWaveDisorderFreq = 0.238999992609024
  },
  volumes = {
    [1] = {
      volume = {
        type = 0,
        center = {
          0,
          0,
          0
        },
        extents = {
          225,
          50,
          225
        },
        worldToLocalMatrix = {
          {
            1,
            0,
            0,
            17.7000007629395
          },
          {
            0,
            1,
            0,
            -71.6999969482422
          },
          {
            0,
            0,
            1,
            -17.2999992370605
          },
          {
            0,
            0,
            0,
            1
          }
        },
        radius = 40,
        priority = 0
      },
      fog = {
        fog = true,
        weight = 1,
        blendDuration = 5,
        fogMode = 1,
        fogStartDistance = 0,
        fogEndDistance = 260,
        globalFogTuner = 0,
        heightFogMode = 1,
        heightFogCutoff = 9.99999974737875E-6,
        heightFogStart = -200,
        heightFogEnd = 900,
        scatteringDensity = 0,
        scatteringFalloff = 1,
        scatteringExponent = 4,
        heightFogMinOpacity = 0,
        radiusFogFactor = 1,
        nearFogColor = {
          0.157351404428482,
          0.659078001976013,
          0.981132090091705,
          1
        },
        nearFogDistance = 0,
        farFogColor = {
          0.679245293140411,
          0.907902121543884,
          1,
          0
        },
        farFogDistance = 300,
        enableLocalHeightFog = 0,
        localHeightFogStart = 0,
        localHeightFogEnd = 1,
        localHeightFogColor = {
          0,
          0,
          0,
          0
        }
      }
    }
  },
  flare = {flareFadeSpeed = 1, flareStrength = 0.495999991893768},
  bloom = {
    index = 0,
    version = 1,
    threshold = 0.600000023841858,
    intensity = 0.75,
    bExposure = false,
    scatter = 0.899999976158142,
    clamp = 0,
    highQualityFiltering = false,
    dirtIntensity = 0
  }
}
return Enviroment_233
