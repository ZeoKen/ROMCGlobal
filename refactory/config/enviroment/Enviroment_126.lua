local Enviroment_126 = {
  global = {
    sunDir = {
      -0.0601693093776703,
      -0.788010776042938,
      0.612714231014252,
      0
    },
    sunColor = {
      0.933962285518646,
      0.88836932182312,
      0.704877197742462,
      1
    }
  },
  fog = {
    fog = true,
    fogColor = {
      0.5,
      0.854838609695435,
      1,
      0
    },
    fogMode = 1,
    fogStartDistance = 10,
    fogEndDistance = 80,
    globalFogTuner = 0.100000001490116,
    heightFogMode = 1,
    heightFogCutoff = 9.99999974737875E-6,
    heightFogStart = -30,
    heightFogEnd = 160,
    scatteringDensity = 0,
    scatteringFalloff = 1,
    scatteringExponent = 4,
    heightFogMinOpacity = 0,
    radiusFogFactor = 1,
    nearFogColor = {
      0.5686274766922,
      0.980392158031464,
      0.959167182445526,
      1
    },
    nearFogDistance = 50,
    farFogColor = {
      0.5,
      0.854838609695435,
      1,
      0
    },
    farFogDistance = 90,
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
            78.5
          },
          {
            0,
            1,
            0,
            -88
          },
          {
            0,
            0,
            1,
            6.59999990463257
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
        fogStartDistance = 30,
        fogEndDistance = 150,
        globalFogTuner = 0,
        heightFogMode = 1,
        heightFogCutoff = 0,
        heightFogStart = 0,
        heightFogEnd = 160,
        scatteringDensity = 0,
        scatteringFalloff = 1,
        scatteringExponent = 4,
        heightFogMinOpacity = 0,
        radiusFogFactor = 1,
        nearFogColor = {
          0.580392181873322,
          0.968627512454987,
          0.952941238880157,
          1
        },
        nearFogDistance = 50,
        farFogColor = {
          0.513725519180298,
          0.850980460643768,
          0.988235354423523,
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
      }
    }
  },
  flare = {flareFadeSpeed = 1, flareStrength = 0},
  customskybox = {
    texPath = "Enviroment/CustomSkyboxes/sky_pldl_004_d",
    tint = {
      1,
      1,
      1,
      1
    },
    rotation = 0,
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
return Enviroment_126
