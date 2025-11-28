local Enviroment_147 = {
  global = {
    sunDir = {
      -0.0766745507717133,
      -0.786856234073639,
      0.612354695796967,
      0
    },
    sunColor = {
      0.721965134143829,
      0.971431910991669,
      0.981132090091705,
      1
    }
  },
  lighting = {
    ambientMode = 0,
    ambientLight = {
      0.943396210670471,
      0.964764773845673,
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
      0.682182252407074,
      0.916682481765747,
      0.99056601524353,
      1
    },
    fogMode = 1,
    fogStartDistance = 10,
    fogEndDistance = 65,
    globalFogTuner = 0.565999984741211,
    heightFogMode = 1,
    heightFogCutoff = 9.99999974737875E-6,
    heightFogStart = 155,
    heightFogEnd = 200,
    scatteringDensity = 2.80999994277954,
    scatteringFalloff = 4,
    scatteringExponent = 16,
    heightFogMinOpacity = 0,
    radiusFogFactor = 1,
    nearFogColor = {
      0.36445352435112,
      0.755773842334747,
      0.99056601524353,
      1
    },
    nearFogDistance = 90,
    farFogColor = {
      0.682182252407074,
      0.916682481765747,
      0.99056601524353,
      1
    },
    farFogDistance = 160,
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
            0.766044437885284,
            0,
            0.64278769493103,
            37.7655792236328
          },
          {
            0,
            1,
            0,
            -73.6999969482422
          },
          {
            -0.64278769493103,
            0,
            0.766044437885284,
            9.69232845306396
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
        fogEndDistance = 100,
        globalFogTuner = 0.100000001490116,
        heightFogMode = 1,
        heightFogCutoff = 9.99999974737875E-6,
        heightFogStart = 0,
        heightFogEnd = 200,
        scatteringDensity = 2.80999994277954,
        scatteringFalloff = 1,
        scatteringExponent = 16,
        heightFogMinOpacity = 0,
        radiusFogFactor = 1,
        nearFogColor = {
          0.384313762187958,
          0.756862819194794,
          0.980392217636108,
          1
        },
        nearFogDistance = 100,
        farFogColor = {
          0.686274528503418,
          0.909803986549377,
          0.980392217636108,
          1
        },
        farFogDistance = 180,
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
    texPath = "Enviroment/CustomSkyboxes/sky_dis_iz_dis_002_d",
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
  lightmap = {
    mode = 0,
    color = {
      1,
      1,
      1,
      1
    },
    duration = 3
  },
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
return Enviroment_147
