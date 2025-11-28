local Enviroment_152 = {
  global = {
    sunDir = {
      0.129256457090378,
      -0.987751603126526,
      0.0874052345752716,
      0
    },
    sunColor = {
      0.485048055648804,
      0.943396210670471,
      0.93309623003006,
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
      0.470588237047195,
      0.827971577644348,
      0.972549021244049,
      1
    },
    fogMode = 1,
    fogStartDistance = 20,
    fogEndDistance = 160,
    globalFogTuner = 0,
    heightFogMode = 1,
    heightFogCutoff = 9.99999974737875E-6,
    heightFogStart = -50,
    heightFogEnd = 300,
    scatteringDensity = 0,
    scatteringFalloff = 4,
    scatteringExponent = 0,
    heightFogMinOpacity = 0,
    radiusFogFactor = 1,
    nearFogColor = {
      0.293075829744339,
      0.422783464193344,
      0.698113203048706,
      1
    },
    nearFogDistance = 60,
    farFogColor = {
      0.470588237047195,
      0.827971577644348,
      0.972549021244049,
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
          175,
          50,
          175
        },
        worldToLocalMatrix = {
          {
            1,
            0,
            0,
            7
          },
          {
            0,
            1,
            0,
            -80.1999969482422
          },
          {
            0,
            0,
            1,
            10.6000003814697
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
        fogStartDistance = 40,
        fogEndDistance = 110,
        globalFogTuner = 0,
        heightFogMode = 1,
        heightFogCutoff = 9.99999974737875E-6,
        heightFogStart = 0,
        heightFogEnd = 400,
        scatteringDensity = 0,
        scatteringFalloff = 1,
        scatteringExponent = 0,
        heightFogMinOpacity = 0,
        radiusFogFactor = 1,
        nearFogColor = {
          0.415686309337616,
          0.701960802078247,
          0.815686345100403,
          1
        },
        nearFogDistance = 100,
        farFogColor = {
          0.486274540424347,
          0.823529481887817,
          0.960784375667572,
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
return Enviroment_152
