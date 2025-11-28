local Enviroment_72 = {
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
      0.306603789329529,
      0.337270051240921,
      1,
      1
    },
    fogMode = 1,
    fogStartDistance = 40,
    fogEndDistance = 400,
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
      0.306603789329529,
      0.337270051240921,
      1,
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
          200
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
            -70
          },
          {
            0,
            0,
            1,
            32.7000007629395
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
          0.329411774873734,
          0.360784322023392,
          0.988235354423523,
          1
        },
        farFogDistance = 130,
        enableLocalHeightFog = 1,
        localHeightFogStart = -50,
        localHeightFogEnd = -1,
        localHeightFogColor = {
          0.329411774873734,
          0.360784322023392,
          0.988235354423523,
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
    exposure = 0.439999997615814
  }
}
return Enviroment_72
