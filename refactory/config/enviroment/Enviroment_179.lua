local Enviroment_179 = {
  global = {
    sunDir = {
      -0.677809953689575,
      -0.706366240978241,
      -0.204011723399162,
      0
    },
    sunColor = {
      1,
      1,
      1,
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
      0,
      0.361262977123261,
      0.624000012874603,
      1
    },
    fogMode = 1,
    fogStartDistance = 10,
    fogEndDistance = 100,
    globalFogTuner = -0.0199999995529652,
    heightFogMode = 1,
    heightFogCutoff = 9.99999974737875E-6,
    heightFogStart = -20,
    heightFogEnd = 300,
    scatteringDensity = 0,
    scatteringFalloff = 4,
    scatteringExponent = 0,
    heightFogMinOpacity = 0.643999993801117,
    radiusFogFactor = 1,
    nearFogColor = {
      0.0705882385373116,
      0.662745118141174,
      1,
      1
    },
    nearFogDistance = 5,
    farFogColor = {
      0,
      0.361262977123261,
      0.624000012874603,
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
          150,
          50,
          150
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
            -60
          },
          {
            0,
            0,
            1,
            -27.2999992370605
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
        fogStartDistance = 20,
        fogEndDistance = 100,
        globalFogTuner = 0,
        heightFogMode = 1,
        heightFogCutoff = 9.99999974737875E-6,
        heightFogStart = 0,
        heightFogEnd = 300,
        scatteringDensity = 0,
        scatteringFalloff = 1,
        scatteringExponent = 0,
        heightFogMinOpacity = 0.643999993801117,
        radiusFogFactor = 1,
        nearFogColor = {
          0.105882361531258,
          0.666666686534882,
          0.988235354423523,
          1
        },
        nearFogDistance = 10,
        farFogColor = {
          0.0392156876623631,
          0.38039219379425,
          0.631372570991516,
          1
        },
        farFogDistance = 90,
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
    texPath = "Enviroment/CustomSkyboxes/surface_pronteraneo_n_sky",
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
    applyFog = true
  },
  bloom = {
    index = 1,
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
return Enviroment_179
