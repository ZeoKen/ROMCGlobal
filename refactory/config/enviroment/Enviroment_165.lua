local Enviroment_165 = {
  global = {
    sunDir = {
      -0.751342713832855,
      -0.19497512280941,
      0.630451321601868,
      0
    },
    sunColor = {
      0.737254917621613,
      0.531011998653412,
      0.423529416322708,
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
      0.330644488334656,
      0.314702719449997,
      0.641509413719177,
      1
    },
    fogMode = 1,
    fogStartDistance = 10,
    fogEndDistance = 160,
    globalFogTuner = 0,
    heightFogMode = 1,
    heightFogCutoff = 9.99999974737875E-6,
    heightFogStart = 0,
    heightFogEnd = 200,
    scatteringDensity = 1,
    scatteringFalloff = 4,
    scatteringExponent = 4,
    heightFogMinOpacity = 0.100000001490116,
    radiusFogFactor = 1,
    nearFogColor = {
      0.416463136672974,
      0.271938413381577,
      0.594339609146118,
      1
    },
    nearFogDistance = 60,
    farFogColor = {
      0.330644488334656,
      0.314702719449997,
      0.641509413719177,
      1
    },
    farFogDistance = 100,
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
            -24.5
          },
          {
            0,
            1,
            0,
            -85
          },
          {
            0,
            0,
            1,
            16.6000003814697
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
        fogStartDistance = 0,
        fogEndDistance = 160,
        globalFogTuner = 0,
        heightFogMode = 1,
        heightFogCutoff = 9.99999974737875E-6,
        heightFogStart = 0,
        heightFogEnd = 300,
        scatteringDensity = 1,
        scatteringFalloff = 1,
        scatteringExponent = 4,
        heightFogMinOpacity = 0.100000001490116,
        radiusFogFactor = 1,
        nearFogColor = {
          0.329411774873734,
          0.231372565031052,
          0.447058856487274,
          1
        },
        nearFogDistance = 0,
        farFogColor = {
          0.352941185235977,
          0.337254911661148,
          0.650980412960052,
          1
        },
        farFogDistance = 200,
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
    texPath = "Enviroment/CustomSkyboxes/sky_comodo_001_d",
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
return Enviroment_165
