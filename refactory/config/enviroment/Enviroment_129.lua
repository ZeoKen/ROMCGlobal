local Enviroment_129 = {
  global = {
    sunDir = {
      -0.335996478796005,
      -0.87868195772171,
      0.339152693748474,
      0
    },
    sunColor = {
      0.583125710487366,
      0.812114477157593,
      0.858490586280823,
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
      0.501957952976227,
      0.794237196445465,
      0.886792421340942,
      1
    },
    fogMode = 1,
    fogStartDistance = 10,
    fogEndDistance = 120,
    globalFogTuner = 0.111000001430511,
    heightFogMode = 1,
    heightFogCutoff = 9.99999974737875E-6,
    heightFogStart = -10,
    heightFogEnd = 200,
    scatteringDensity = 3.46000003814697,
    scatteringFalloff = 4,
    scatteringExponent = 13,
    heightFogMinOpacity = 0,
    radiusFogFactor = 1,
    nearFogColor = {
      0.36445352435112,
      0.755773842334747,
      0.99056601524353,
      1
    },
    nearFogDistance = 0,
    farFogColor = {
      0.501957952976227,
      0.794237196445465,
      0.886792421340942,
      1
    },
    farFogDistance = 160,
    enableLocalHeightFog = 0,
    localHeightFogStart = 0,
    localHeightFogEnd = 1,
    localHeightFogColor = {
      0.274118900299072,
      0.464990794658661,
      0.518867909908295,
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
          200,
          50,
          250
        },
        worldToLocalMatrix = {
          {
            1,
            0,
            0,
            -18.2999992370605
          },
          {
            0,
            1,
            0,
            -79.0999984741211
          },
          {
            0,
            0,
            1,
            7.5
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
        fogEndDistance = 220,
        globalFogTuner = 0.0500000007450581,
        heightFogMode = 1,
        heightFogCutoff = 9.99999974737875E-6,
        heightFogStart = 0,
        heightFogEnd = 500,
        scatteringDensity = 3.46000003814697,
        scatteringFalloff = 1,
        scatteringExponent = 13,
        heightFogMinOpacity = 0,
        radiusFogFactor = 1,
        nearFogColor = {
          0.384313762187958,
          0.756862819194794,
          0.980392217636108,
          1
        },
        nearFogDistance = 0,
        farFogColor = {
          0.513725519180298,
          0.796078503131866,
          0.878431439399719,
          1
        },
        farFogDistance = 300,
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
return Enviroment_129
