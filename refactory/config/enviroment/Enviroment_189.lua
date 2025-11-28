local Enviroment_189 = {
  global = {
    sunDir = {
      0.744912683963776,
      -0.517244577407837,
      0.421382367610931,
      0
    },
    sunColor = {
      0.501960813999176,
      0.772549092769623,
      0.996078491210938,
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
      0.606034517288208,
      0.8558189868927,
      0.949999988079071,
      1
    },
    fogMode = 1,
    fogStartDistance = 0,
    fogEndDistance = 85,
    globalFogTuner = 0,
    heightFogMode = 1,
    heightFogCutoff = 9.99999974737875E-6,
    heightFogStart = -20,
    heightFogEnd = 800,
    scatteringDensity = 0,
    scatteringFalloff = 4,
    scatteringExponent = 12.5,
    heightFogMinOpacity = 0,
    radiusFogFactor = 1,
    nearFogColor = {
      0.475000023841858,
      0.725000143051147,
      0.850000023841858,
      1
    },
    nearFogDistance = 50,
    farFogColor = {
      0.606034517288208,
      0.8558189868927,
      0.949999988079071,
      1
    },
    farFogDistance = 200,
    enableLocalHeightFog = 1,
    localHeightFogStart = -70,
    localHeightFogEnd = -7,
    localHeightFogColor = {
      0.639215707778931,
      0.90588241815567,
      1,
      1
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
          125,
          50,
          125
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
            -68
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
        fogStartDistance = 10,
        fogEndDistance = 110,
        globalFogTuner = 0,
        heightFogMode = 1,
        heightFogCutoff = 9.99999974737875E-6,
        heightFogStart = 0,
        heightFogEnd = 800,
        scatteringDensity = 0,
        scatteringFalloff = 1,
        scatteringExponent = 12.5,
        heightFogMinOpacity = 0,
        radiusFogFactor = 1,
        nearFogColor = {
          0.490196108818054,
          0.729411780834198,
          0.847058892250061,
          1
        },
        nearFogDistance = 50,
        farFogColor = {
          0.615686297416687,
          0.850980460643768,
          0.941176533699036,
          1
        },
        farFogDistance = 200,
        enableLocalHeightFog = 1,
        localHeightFogStart = -30,
        localHeightFogEnd = -7,
        localHeightFogColor = {
          0.647058844566345,
          0.898039281368256,
          0.988235354423523,
          0
        }
      }
    }
  },
  flare = {flareFadeSpeed = 1, flareStrength = 0.495999991893768},
  customskybox = {
    texPath = "Enviroment/CustomSkyboxes/sky_teampve6_e",
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
return Enviroment_189
