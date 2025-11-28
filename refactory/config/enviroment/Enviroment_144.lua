local Enviroment_144 = {
  global = {
    sunDir = {
      -0.137196689844131,
      -0.989711165428162,
      -0.040606252849102,
      0
    },
    sunColor = {
      0.366500526666641,
      0.545729577541351,
      0.669811308383942,
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
      0.427254945039749,
      0.368627458810806,
      0.643137276172638,
      1
    },
    fogMode = 1,
    fogStartDistance = 20,
    fogEndDistance = 100,
    globalFogTuner = 0.0700000002980232,
    heightFogMode = 1,
    heightFogCutoff = 9.99999974737875E-6,
    heightFogStart = 300,
    heightFogEnd = 1000,
    scatteringDensity = 1.77999997138977,
    scatteringFalloff = 4,
    scatteringExponent = 4.19999980926514,
    heightFogMinOpacity = 0.296000003814697,
    radiusFogFactor = 1,
    nearFogColor = {
      0.309803932905197,
      0.408029526472092,
      0.678431391716003,
      1
    },
    nearFogDistance = 140,
    farFogColor = {
      0.427254945039749,
      0.368627458810806,
      0.643137276172638,
      1
    },
    farFogDistance = 260,
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
            -34.7999992370605
          },
          {
            0,
            1,
            0,
            -76.3000030517578
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
        fogEndDistance = 130,
        globalFogTuner = 0,
        heightFogMode = 1,
        heightFogCutoff = 0,
        heightFogStart = 300,
        heightFogEnd = 1000,
        scatteringDensity = 1.77999997138977,
        scatteringFalloff = 1,
        scatteringExponent = 4.19999980926514,
        heightFogMinOpacity = 0.296000003814697,
        radiusFogFactor = 1,
        nearFogColor = {
          0.333333343267441,
          0.427451014518738,
          0.682352960109711,
          1
        },
        nearFogDistance = 20,
        farFogColor = {
          0.443137288093567,
          0.388235330581665,
          0.650980412960052,
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
    texPath = "Enviroment/CustomSkyboxes/sky_comodo_001_d",
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
    intensity = 1.20000004768372,
    bExposure = false,
    scatter = 0.899999976158142,
    clamp = 0,
    highQualityFiltering = false,
    dirtIntensity = 0
  }
}
return Enviroment_144
