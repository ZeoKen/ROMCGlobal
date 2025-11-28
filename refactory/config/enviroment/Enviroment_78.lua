local Enviroment_78 = {
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
      0.925186514854431,
      0.896226406097412,
      1,
      1
    },
    fogMode = 1,
    fogStartDistance = 10,
    fogEndDistance = 300,
    globalFogTuner = 0.0399999991059303,
    heightFogMode = 1,
    heightFogCutoff = 9.99999974737875E-6,
    heightFogStart = 10,
    heightFogEnd = 160,
    scatteringDensity = 0,
    scatteringFalloff = 1,
    scatteringExponent = 4,
    heightFogMinOpacity = 0,
    radiusFogFactor = 0,
    nearFogColor = {
      1,
      1,
      1,
      1
    },
    nearFogDistance = 100,
    farFogColor = {
      0.925186514854431,
      0.896226406097412,
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
          175,
          50,
          175
        },
        worldToLocalMatrix = {
          {
            1,
            0,
            0,
            -5.80000019073486
          },
          {
            0,
            0.996987342834473,
            -0.0775646716356277,
            -106.938919067383
          },
          {
            0,
            0.0775646716356277,
            0.996987342834473,
            36.3147239685059
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
        fogEndDistance = 150,
        globalFogTuner = 0,
        heightFogMode = 1,
        heightFogCutoff = 0,
        heightFogStart = 10,
        heightFogEnd = 160,
        scatteringDensity = 0,
        scatteringFalloff = 1,
        scatteringExponent = 4,
        heightFogMinOpacity = 0,
        radiusFogFactor = 0,
        nearFogColor = {
          1,
          1,
          1,
          1
        },
        nearFogDistance = 100,
        farFogColor = {
          0.917647123336792,
          0.890196144580841,
          0.988235354423523,
          1
        },
        farFogDistance = 130,
        enableLocalHeightFog = 1,
        localHeightFogStart = -50,
        localHeightFogEnd = 0,
        localHeightFogColor = {
          0.890196084976196,
          0.915757775306702,
          0.988235294818878,
          1
        }
      }
    }
  },
  flare = {flareFadeSpeed = 1, flareStrength = 0.495999991893768},
  skybox = {
    type = 3,
    atmoshpereThickness = 0.550000011920929,
    skyTint = {
      0.0803666785359383,
      0.174011901021004,
      0.405660390853882,
      0
    },
    ground = {
      0.220274150371552,
      0.463910669088364,
      0.707547187805176,
      0
    },
    exposure = 1.14999997615814
  },
  lightmap = {
    mode = 1,
    color = {
      1,
      1,
      1,
      1
    },
    duration = 3
  }
}
return Enviroment_78
