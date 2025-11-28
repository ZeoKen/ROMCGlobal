local Enviroment_155 = {
  global = {
    sunDir = {
      -0.6063192486763,
      -0.68199896812439,
      -0.408967584371567,
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
    ambientMode = 4,
    ambientIntensity = 1,
    defaultReflectionMode = 0,
    defaultReflectionResolution = 0,
    reflectionBounces = 1,
    reflectionIntensity = 0
  },
  fog = {
    fog = true,
    fogColor = {
      0.0606922991573811,
      0.212654396891594,
      0.262999981641769,
      1
    },
    fogMode = 1,
    fogStartDistance = 0,
    fogEndDistance = 45,
    globalFogTuner = -0.330000013113022,
    heightFogMode = 1,
    heightFogCutoff = 9.99999974737875E-6,
    heightFogStart = -30,
    heightFogEnd = 50,
    scatteringDensity = 1.39999997615814,
    scatteringFalloff = 4,
    scatteringExponent = 11.3999996185303,
    heightFogMinOpacity = 0,
    radiusFogFactor = 1,
    nearFogColor = {
      0,
      0.172255292534828,
      0.184000000357628,
      1
    },
    nearFogDistance = 0,
    farFogColor = {
      0.0606922991573811,
      0.212654396891594,
      0.262999981641769,
      1
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
          128.770004272461,
          12.0500001907349,
          77.25
        },
        worldToLocalMatrix = {
          {
            1,
            0,
            0,
            73.9000015258789
          },
          {
            0,
            1,
            0,
            1.10000002384186
          },
          {
            0,
            0,
            1,
            -154.699996948242
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
        fogStartDistance = 13,
        fogEndDistance = 35,
        globalFogTuner = 0,
        heightFogMode = 1,
        heightFogCutoff = 9.99999974737875E-6,
        heightFogStart = -30,
        heightFogEnd = 100,
        scatteringDensity = 0,
        scatteringFalloff = 1,
        scatteringExponent = 0,
        heightFogMinOpacity = 0,
        radiusFogFactor = 1,
        nearFogColor = {
          0.258721947669983,
          0.437221884727478,
          0.962264180183411,
          1
        },
        nearFogDistance = 0,
        farFogColor = {
          0.431372612714767,
          0.878470659255981,
          0.980392158031464,
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
    },
    [2] = {
      volume = {
        type = 0,
        center = {
          0,
          0,
          0
        },
        extents = {
          47.2000007629395,
          37.75,
          48.25
        },
        worldToLocalMatrix = {
          {
            1,
            0,
            0,
            19.8700008392334
          },
          {
            0,
            1,
            0,
            -19.2000007629395
          },
          {
            0,
            0,
            1,
            62.4000015258789
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
        fogEndDistance = 129.199996948242,
        globalFogTuner = 0,
        heightFogMode = 1,
        heightFogCutoff = 9.99999974737875E-6,
        heightFogStart = -30,
        heightFogEnd = 50,
        scatteringDensity = 1.39999997615814,
        scatteringFalloff = 1,
        scatteringExponent = 11.3999996185303,
        heightFogMinOpacity = 0,
        radiusFogFactor = 1,
        nearFogColor = {
          0.494838029146194,
          0.562773883342743,
          0.754716992378235,
          1
        },
        nearFogDistance = 0,
        farFogColor = {
          0.905660390853882,
          0.686967730522156,
          0.388750463724136,
          0
        },
        farFogDistance = 39.9000015258789,
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
    rotation = 113,
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
return Enviroment_155
