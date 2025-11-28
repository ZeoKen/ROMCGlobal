local Enviroment_168 = {
  global = {
    sunDir = {
      -0.970337986946106,
      -0.240228027105331,
      0.0271041858941317,
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
      0.457547187805176,
      0.740885674953461,
      1,
      1
    },
    fogMode = 1,
    fogStartDistance = 10,
    fogEndDistance = 700,
    globalFogTuner = -0.00999999977648258,
    heightFogMode = 1,
    heightFogCutoff = 9.99999974737875E-6,
    heightFogStart = 0,
    heightFogEnd = 1000,
    scatteringDensity = 0,
    scatteringFalloff = 4,
    scatteringExponent = 0,
    heightFogMinOpacity = 0,
    radiusFogFactor = 1,
    nearFogColor = {
      0.91372549533844,
      0.846253097057343,
      0.168627426028252,
      0
    },
    nearFogDistance = 10,
    farFogColor = {
      0.457547187805176,
      0.740885674953461,
      1,
      1
    },
    farFogDistance = 100,
    enableLocalHeightFog = 1,
    localHeightFogStart = -193.5,
    localHeightFogEnd = -5,
    localHeightFogColor = {
      0.173913806676865,
      0.395258784294128,
      0.916999995708466,
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
          750,
          50,
          750
        },
        worldToLocalMatrix = {
          {
            1,
            0,
            0,
            -70
          },
          {
            0,
            1,
            0,
            -69.6999969482422
          },
          {
            0,
            0,
            1,
            -2.20000004768372
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
        fogEndDistance = 650,
        globalFogTuner = 0,
        heightFogMode = 1,
        heightFogCutoff = 9.99999974737875E-6,
        heightFogStart = 0,
        heightFogEnd = 1500,
        scatteringDensity = 0,
        scatteringFalloff = 1,
        scatteringExponent = 0,
        heightFogMinOpacity = 0,
        radiusFogFactor = 1,
        nearFogColor = {
          0.90588241815567,
          0.843137323856354,
          0.200000017881393,
          0
        },
        nearFogDistance = 20,
        farFogColor = {
          0.474509835243225,
          0.74117648601532,
          0.988235354423523,
          1
        },
        farFogDistance = 150,
        enableLocalHeightFog = 1,
        localHeightFogStart = -100,
        localHeightFogEnd = 0,
        localHeightFogColor = {
          0.203921586275101,
          0.415686309337616,
          0.909803986549377,
          1
        }
      }
    }
  },
  flare = {flareFadeSpeed = 1, flareStrength = 0.495999991893768},
  customskybox = {
    texPath = "Enviroment/CustomSkyboxes/sky_pldl_004_d",
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
return Enviroment_168
