local Enviroment_270 = {
  global = {
    sunDir = {
      0.744909584522247,
      -0.517250418663025,
      0.421380817890167,
      0
    },
    sunColor = {
      0,
      0,
      0,
      1
    }
  },
  lighting = {
    ambientMode = 0,
    ambientLight = {
      1,
      1,
      1,
      1
    },
    ambientIntensity = 1,
    defaultReflectionMode = 0,
    defaultReflectionResolution = 0,
    reflectionBounces = 1,
    reflectionIntensity = 0
  },
  fog = {
    fog = true,
    fogColor = {
      1,
      0.90191262960434,
      0.74117648601532,
      1
    },
    fogMode = 1,
    fogStartDistance = 8,
    fogEndDistance = 80,
    globalFogTuner = 0,
    heightFogMode = 1,
    heightFogCutoff = 9.99999974737875E-6,
    heightFogStart = -30,
    heightFogEnd = 100,
    scatteringDensity = 0,
    scatteringFalloff = 4,
    scatteringExponent = 0,
    heightFogMinOpacity = 0,
    radiusFogFactor = 1,
    nearFogColor = {
      1,
      0.789289116859436,
      0.65200001001358,
      1
    },
    nearFogDistance = 6,
    farFogColor = {
      1,
      0.90191262960434,
      0.74117648601532,
      1
    },
    farFogDistance = 35,
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
          17.5,
          7.5,
          20
        },
        worldToLocalMatrix = {
          {
            1,
            0,
            0,
            0
          },
          {
            0,
            1,
            0,
            -17.4200000762939
          },
          {
            0,
            0,
            1,
            9.69999980926514
          },
          {
            0,
            0,
            0,
            1
          }
        },
        radius = 1,
        priority = 0,
        worldCenter = {
          0,
          17.4200000762939,
          -9.69999980926514
        },
        worldRange = 27.6134033203125
      },
      fog = {
        fog = true,
        weight = 1,
        blendDuration = 0.5,
        fogMode = 1,
        fogStartDistance = 10,
        fogEndDistance = 60,
        globalFogTuner = 0,
        heightFogMode = 1,
        heightFogCutoff = 9.99999974737875E-6,
        heightFogStart = -30,
        heightFogEnd = 150,
        scatteringDensity = 1,
        scatteringFalloff = 1,
        scatteringExponent = 11,
        heightFogMinOpacity = 0,
        radiusFogFactor = 1,
        nearFogColor = {
          0.988235354423523,
          0.549019634723663,
          0.254901975393295,
          1
        },
        nearFogDistance = 0,
        farFogColor = {
          0.443137288093567,
          0.443137288093567,
          0.639215707778931,
          0
        },
        farFogDistance = 30,
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
    intensity = 1.20000004768372,
    bExposure = false,
    scatter = 0.899999976158142,
    clamp = 0,
    highQualityFiltering = false,
    dirtIntensity = 0
  }
}
return Enviroment_270
