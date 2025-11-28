local Enviroment_183 = {
  global = {
    sunDir = {
      -0.633264780044556,
      -0.438371121883392,
      -0.637814104557037,
      0
    },
    sunColor = {
      0.0313725508749485,
      0.254901975393295,
      0.337254911661148,
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
      0.119259513914585,
      0.269817173480988,
      0.377358496189117,
      1
    },
    fogMode = 1,
    fogStartDistance = 5,
    fogEndDistance = 80,
    globalFogTuner = 0.100000001490116,
    heightFogMode = 1,
    heightFogCutoff = 9.99999974737875E-6,
    heightFogStart = -20,
    heightFogEnd = 600,
    scatteringDensity = 1.39999997615814,
    scatteringFalloff = 4,
    scatteringExponent = 11.3999996185303,
    heightFogMinOpacity = 0,
    radiusFogFactor = 1,
    nearFogColor = {
      0.0634122267365456,
      0.359008342027664,
      0.707547187805176,
      1
    },
    nearFogDistance = 5,
    farFogColor = {
      0.119259513914585,
      0.269817173480988,
      0.377358496189117,
      1
    },
    farFogDistance = 50,
    enableLocalHeightFog = 1,
    localHeightFogStart = -250,
    localHeightFogEnd = 0,
    localHeightFogColor = {
      0.175418302416801,
      0.323534280061722,
      0.50943398475647,
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
          200
        },
        worldToLocalMatrix = {
          {
            1,
            0,
            0,
            -26.7000007629395
          },
          {
            0,
            1,
            0,
            -75.9000015258789
          },
          {
            0,
            0,
            1,
            24.7999992370605
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
        globalFogTuner = 0.100000001490116,
        heightFogMode = 1,
        heightFogCutoff = 0,
        heightFogStart = -30,
        heightFogEnd = 800,
        scatteringDensity = 1.39999997615814,
        scatteringFalloff = 1,
        scatteringExponent = 11.3999996185303,
        heightFogMinOpacity = 0,
        radiusFogFactor = 1,
        nearFogColor = {
          0.0980392247438431,
          0.38039219379425,
          0.709803938865662,
          1
        },
        nearFogDistance = 10,
        farFogColor = {
          0.149019613862038,
          0.294117659330368,
          0.39607846736908,
          0
        },
        farFogDistance = 100,
        enableLocalHeightFog = 1,
        localHeightFogStart = -70,
        localHeightFogEnd = 0,
        localHeightFogColor = {
          0.207843154668808,
          0.34901961684227,
          0.521568655967712,
          0
        }
      }
    }
  },
  flare = {flareFadeSpeed = 1, flareStrength = 0.495999991893768},
  customskybox = {
    texPath = "Enviroment/CustomSkyboxes/skybox_room_dis",
    tint = {
      1,
      1,
      1,
      1
    },
    rotation = 334,
    exposure = 1,
    finite = true,
    sunsize = 0,
    applyFog = true
  },
  bloom = {
    index = 1,
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
return Enviroment_183
