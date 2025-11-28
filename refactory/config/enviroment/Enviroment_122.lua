local Enviroment_122 = {
  global = {
    sunDir = {
      0,
      0,
      1,
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
      0.288486987352371,
      0.241500526666641,
      0.632075428962708,
      1
    },
    fogMode = 1,
    fogStartDistance = 30,
    fogEndDistance = 600,
    globalFogTuner = 0,
    heightFogMode = 0,
    radiusFogFactor = 0,
    nearFogColor = {
      1,
      1,
      1,
      1
    },
    nearFogDistance = 100,
    farFogColor = {
      0.288486987352371,
      0.241500526666641,
      0.632075428962708,
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
          175,
          50,
          175
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
            -99.3600006103516
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
        fogStartDistance = 30,
        fogEndDistance = 200,
        globalFogTuner = 0,
        heightFogMode = 0,
        radiusFogFactor = 0,
        nearFogColor = {
          1,
          1,
          1,
          1
        },
        nearFogDistance = 100,
        farFogColor = {
          0.278431385755539,
          0.243137270212173,
          0.623529434204102,
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
      }
    }
  },
  flare = {flareFadeSpeed = 1, flareStrength = 0.46900001168251},
  skybox = {type = 1}
}
return Enviroment_122
