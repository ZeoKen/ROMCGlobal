local Enviroment_65 = {
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
    ambientIntensity = 0,
    defaultReflectionMode = 0,
    defaultReflectionResolution = 0,
    reflectionBounces = 1,
    reflectionIntensity = 0
  },
  fog = {
    fog = true,
    fogColor = {
      0.232289105653763,
      0.357893317937851,
      0.566037774085999,
      1
    },
    fogMode = 1,
    fogStartDistance = 60,
    fogEndDistance = 300,
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
      0.232289105653763,
      0.357893317937851,
      0.566037774085999,
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
          100,
          50,
          100
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
            -66
          },
          {
            0,
            0,
            1,
            6.40000009536743
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
        fogEndDistance = 160,
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
          0.258823543787003,
          0.376470625400543,
          0.576470613479614,
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
  flare = {flareFadeSpeed = 1, flareStrength = 0},
  skybox = {
    type = 3,
    atmoshpereThickness = 0.560000002384186,
    skyTint = {
      0.761663258075714,
      0.308823525905609,
      1,
      0
    },
    ground = {
      0.341043740510941,
      0.166414365172386,
      0.595588207244873,
      0
    },
    exposure = 0.600000023841858,
    cubemap = "Enviroment/skyclouds/sky_luoyang_night",
    cubemapRotation = 210,
    cubemapTint = {
      1,
      1,
      1,
      1
    }
  },
  lightmap = {
    mode = 1,
    color = {
      0.67471170425415,
      0.543832302093506,
      0.952830195426941,
      1
    },
    duration = 3
  }
}
return Enviroment_65
