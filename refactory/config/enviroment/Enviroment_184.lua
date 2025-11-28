local Enviroment_184 = {
  global = {
    sunDir = {
      0.744912683963776,
      -0.517244577407837,
      0.421382367610931,
      0
    },
    sunColor = {
      1,
      0.921568691730499,
      0.65490198135376,
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
      0.534772574901581,
      0.882045805454254,
      0.992156863212585,
      1
    },
    fogMode = 1,
    fogStartDistance = 10,
    fogEndDistance = 150,
    globalFogTuner = 0,
    heightFogMode = 1,
    heightFogCutoff = 9.99999974737875E-6,
    heightFogStart = -20,
    heightFogEnd = 350,
    scatteringDensity = 1,
    scatteringFalloff = 4,
    scatteringExponent = 12.5,
    heightFogMinOpacity = 0,
    radiusFogFactor = 1,
    nearFogColor = {
      0.235294103622437,
      0.624769926071167,
      1,
      1
    },
    nearFogDistance = 20,
    farFogColor = {
      0.534772574901581,
      0.882045805454254,
      0.992156863212585,
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
            -89.5
          },
          {
            0,
            0,
            1,
            -3.09999990463257
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
        fogStartDistance = 10,
        fogEndDistance = 160,
        globalFogTuner = 0,
        heightFogMode = 1,
        heightFogCutoff = 9.99999974737875E-6,
        heightFogStart = 0,
        heightFogEnd = 500,
        scatteringDensity = 1,
        scatteringFalloff = 1,
        scatteringExponent = 12.5,
        heightFogMinOpacity = 0,
        radiusFogFactor = 1,
        nearFogColor = {
          0.26274511218071,
          0.631372570991516,
          0.988235354423523,
          1
        },
        nearFogDistance = 0,
        farFogColor = {
          0.545098066329956,
          0.878431439399719,
          0.980392217636108,
          1
        },
        farFogDistance = 220,
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
    texPath = "Enviroment/CustomSkyboxes/sky_pldl_002_d",
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
    threshold = 0,
    intensity = 0,
    bExposure = false,
    scatter = 0,
    clamp = 0,
    highQualityFiltering = false,
    dirtIntensity = 0
  }
}
return Enviroment_184
