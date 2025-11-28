local Enviroment_62 = {
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
      0.147977918386459,
      0.572647988796234,
      0.875,
      1
    },
    fogMode = 1,
    fogStartDistance = 60,
    fogEndDistance = 250,
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
      0.147977918386459,
      0.572647988796234,
      0.875,
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
          150,
          30,
          150
        },
        worldToLocalMatrix = {
          {
            1,
            0,
            0,
            16.1000003814697
          },
          {
            0,
            1,
            0,
            -65.0999984741211
          },
          {
            0,
            0,
            1,
            -37.0999984741211
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
          0.180392161011696,
          0.584313750267029,
          0.870588302612305,
          1
        },
        farFogDistance = 130,
        enableLocalHeightFog = 1,
        localHeightFogStart = -100,
        localHeightFogEnd = -10,
        localHeightFogColor = {
          0.180392161011696,
          0.435192972421646,
          0.87058824300766,
          0
        }
      }
    }
  }
}
return Enviroment_62
