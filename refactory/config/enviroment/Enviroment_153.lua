local Enviroment_153 = {
  global = {
    sunDir = {
      -0.325409233570099,
      -0.323172211647034,
      0.888632953166962,
      0
    },
    sunColor = {
      0.933333396911621,
      0.890196144580841,
      0.705882370471954,
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
      0.501960813999176,
      0.798448026180267,
      1,
      1
    },
    fogMode = 1,
    fogStartDistance = 30,
    fogEndDistance = 140,
    globalFogTuner = 0,
    heightFogMode = 1,
    heightFogCutoff = 9.99999974737875E-6,
    heightFogStart = -30,
    heightFogEnd = 180,
    scatteringDensity = 1.39999997615814,
    scatteringFalloff = 4,
    scatteringExponent = 11.3999996185303,
    heightFogMinOpacity = 0,
    radiusFogFactor = 1,
    nearFogColor = {
      0.5686274766922,
      0.910405278205872,
      0.980392158031464,
      1
    },
    nearFogDistance = 100,
    farFogColor = {
      0.501960813999176,
      0.798448026180267,
      1,
      1
    },
    farFogDistance = 120,
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
            -81
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
        fogStartDistance = 45,
        fogEndDistance = 200,
        globalFogTuner = 0,
        heightFogMode = 1,
        heightFogCutoff = 0,
        heightFogStart = 0,
        heightFogEnd = 200,
        scatteringDensity = 1.39999997615814,
        scatteringFalloff = 1,
        scatteringExponent = 11.3999996185303,
        heightFogMinOpacity = 0,
        radiusFogFactor = 1,
        nearFogColor = {
          0.580392181873322,
          0.901960849761963,
          0.968627512454987,
          1
        },
        nearFogDistance = 100,
        farFogColor = {
          0.513725519180298,
          0.800000071525574,
          0.988235354423523,
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
return Enviroment_153
