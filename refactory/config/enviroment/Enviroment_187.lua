local Enviroment_187 = {
  global = {
    sunDir = {
      -0.370278418064117,
      -0.262484043836594,
      0.891064524650574,
      0
    },
    sunColor = {
      1,
      0.558486521244049,
      0.146226406097412,
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
      1,
      0.568848609924316,
      0.25943398475647,
      1
    },
    fogMode = 1,
    fogStartDistance = 0,
    fogEndDistance = 85,
    globalFogTuner = 0,
    heightFogMode = 1,
    heightFogCutoff = 9.99999974737875E-6,
    heightFogStart = 0,
    heightFogEnd = 350,
    scatteringDensity = 5.53999996185303,
    scatteringFalloff = 1,
    scatteringExponent = 12.3999996185303,
    heightFogMinOpacity = 0,
    radiusFogFactor = 1,
    nearFogColor = {
      1,
      0.466569900512695,
      0.297169804573059,
      1
    },
    nearFogDistance = 30,
    farFogColor = {
      1,
      0.568848609924316,
      0.25943398475647,
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
            7.59999990463257
          },
          {
            0,
            1,
            0,
            -69.8000030517578
          },
          {
            0,
            0,
            1,
            60.7999992370605
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
        fogEndDistance = 115,
        globalFogTuner = 0,
        heightFogMode = 1,
        heightFogCutoff = 0,
        heightFogStart = 0,
        heightFogEnd = 350,
        scatteringDensity = 5.53999996185303,
        scatteringFalloff = 1,
        scatteringExponent = 12.3999996185303,
        heightFogMinOpacity = 0,
        radiusFogFactor = 1,
        nearFogColor = {
          0.988235354423523,
          0.48235297203064,
          0.321568638086319,
          1
        },
        nearFogDistance = 40,
        farFogColor = {
          0.988235354423523,
          0.580392181873322,
          0.286274522542953,
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
    texPath = "Enviroment/CustomSkyboxes/sky_Guild_baseneo_d",
    tint = {
      1,
      1,
      1,
      1
    },
    rotation = 156,
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
return Enviroment_187
