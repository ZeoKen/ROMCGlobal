local Enviroment_164 = {
  global = {
    sunDir = {
      -0.696456968784332,
      0,
      -0.717598795890808,
      0
    },
    sunColor = {
      0.780392229557037,
      0.474509835243225,
      0.235294133424759,
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
      0.858823597431183,
      0.607843160629272,
      0.290196090936661,
      1
    },
    fogMode = 1,
    fogStartDistance = 8,
    fogEndDistance = 250,
    globalFogTuner = 0,
    heightFogMode = 1,
    heightFogCutoff = 9.99999974737875E-6,
    heightFogStart = 50,
    heightFogEnd = 150,
    scatteringDensity = 1.5,
    scatteringFalloff = 1,
    scatteringExponent = 4,
    heightFogMinOpacity = 0,
    radiusFogFactor = 1,
    nearFogColor = {
      0.788235366344452,
      0.250980406999588,
      0.160784319043159,
      1
    },
    nearFogDistance = 5,
    farFogColor = {
      0.858823597431183,
      0.607843160629272,
      0.290196090936661,
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
          160,
          50,
          160
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
            -66
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
        fogStartDistance = 20,
        fogEndDistance = 250,
        globalFogTuner = 0,
        heightFogMode = 1,
        heightFogCutoff = 9.99999974737875E-6,
        heightFogStart = 0,
        heightFogEnd = 500,
        scatteringDensity = 1.5,
        scatteringFalloff = 1,
        scatteringExponent = 4,
        heightFogMinOpacity = 0,
        radiusFogFactor = 1,
        nearFogColor = {
          0.788235366344452,
          0.278431385755539,
          0.192156881093979,
          1
        },
        nearFogDistance = 10,
        farFogColor = {
          0.854902029037476,
          0.615686297416687,
          0.313725501298904,
          1
        },
        farFogDistance = 150,
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
  flare = {flareFadeSpeed = 3, flareStrength = 0.611999988555908},
  customskybox = {
    texPath = "Enviroment/CustomSkyboxes/sky_izlude_diedai_d",
    tint = {
      1,
      1,
      1,
      1
    },
    rotation = 174,
    exposure = 1,
    finite = true,
    sunsize = 0,
    applyFog = false
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
return Enviroment_164
