local Enviroment_141 = {
  global = {
    sunDir = {
      0.744909584522247,
      -0.517250418663025,
      0.421380817890167,
      0
    },
    sunColor = {
      0.933333396911621,
      0.890196144580841,
      0.705882370471954,
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
      0.383000016212463,
      0.556114375591278,
      1,
      1
    },
    fogMode = 1,
    fogStartDistance = 15,
    fogEndDistance = 80,
    globalFogTuner = 0.0500000007450581,
    heightFogMode = 1,
    heightFogCutoff = 9.99999974737875E-6,
    heightFogStart = -10,
    heightFogEnd = 40,
    scatteringDensity = 1.39999997615814,
    scatteringFalloff = 4,
    scatteringExponent = 11.3999996185303,
    heightFogMinOpacity = 0,
    radiusFogFactor = 0,
    nearFogColor = {
      0.5686274766922,
      0.910405278205872,
      0.980392158031464,
      1
    },
    nearFogDistance = 100,
    farFogColor = {
      0.383000016212463,
      0.556114375591278,
      1,
      1
    },
    farFogDistance = 120,
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
          100,
          50,
          100
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
            -65
          },
          {
            0,
            0,
            1,
            0
          },
          {
            0,
            0,
            0,
            1
          }
        },
        radius = 1,
        priority = 0
      },
      fog = {
        fog = true,
        weight = 1,
        blendDuration = 0.5,
        fogMode = 1,
        fogStartDistance = 30,
        fogEndDistance = 120,
        globalFogTuner = 0.0500000007450581,
        heightFogMode = 1,
        heightFogCutoff = 0,
        heightFogStart = -20,
        heightFogEnd = 100,
        scatteringDensity = 1.39999997615814,
        scatteringFalloff = 1,
        scatteringExponent = 11.3999996185303,
        heightFogMinOpacity = 0,
        radiusFogFactor = 0,
        nearFogColor = {
          1,
          1,
          1,
          1
        },
        nearFogDistance = 100,
        farFogColor = {
          0.403921604156494,
          0.5686274766922,
          0.988235354423523,
          1
        },
        farFogDistance = 130,
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
  customskybox = {
    texPath = "Assets/Art/Public/Texture/Scene/v1/Surface texture/surface_h/surface_room_card_xingkongqiang",
    tint = {
      1,
      1,
      1,
      1
    },
    rotation = 130,
    exposure = 1,
    finite = true,
    sunsize = 0,
    applyFog = false
  },
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
return Enviroment_141
