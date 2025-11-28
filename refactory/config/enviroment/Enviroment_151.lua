local Enviroment_151 = {
  global = {
    sunDir = {
      -0.915387034416199,
      -0.0174522995948792,
      0.402196794748306,
      0
    },
    sunColor = {
      1,
      0.792982876300812,
      0.405660390853882,
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
      0.861822187900543,
      0.377358496189117,
      1
    },
    fogMode = 1,
    fogStartDistance = 12,
    fogEndDistance = 80,
    globalFogTuner = 0,
    heightFogMode = 1,
    heightFogCutoff = 9.99999974737875E-6,
    heightFogStart = -20,
    heightFogEnd = 110,
    scatteringDensity = 1,
    scatteringFalloff = 4,
    scatteringExponent = 2,
    heightFogMinOpacity = 0,
    radiusFogFactor = 1,
    nearFogColor = {
      0.99056601524353,
      0.475580841302872,
      0.233624085783958,
      1
    },
    nearFogDistance = 0,
    farFogColor = {
      1,
      0.861822187900543,
      0.377358496189117,
      1
    },
    farFogDistance = 200,
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
          10,
          10,
          15
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
            0
          },
          {
            0,
            0,
            1,
            -1.27999997138977
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
        blendDuration = 3,
        fogMode = 1,
        fogStartDistance = 12,
        fogEndDistance = 90,
        globalFogTuner = 0,
        heightFogMode = 1,
        heightFogCutoff = 9.99999974737875E-6,
        heightFogStart = -45,
        heightFogEnd = 190,
        scatteringDensity = 1,
        scatteringFalloff = 1,
        scatteringExponent = 2,
        heightFogMinOpacity = 0,
        radiusFogFactor = 1,
        nearFogColor = {
          1,
          0.528619587421417,
          0.235294103622437,
          1
        },
        nearFogDistance = 0,
        farFogColor = {
          1,
          0.801164865493774,
          0.320754706859589,
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
    },
    [2] = {
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
            1.79999995231628
          },
          {
            0,
            1,
            0,
            -83
          },
          {
            0,
            0,
            1,
            -70.5999984741211
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
        fogStartDistance = 12,
        fogEndDistance = 150,
        globalFogTuner = 0,
        heightFogMode = 1,
        heightFogCutoff = 0,
        heightFogStart = 0,
        heightFogEnd = 500,
        scatteringDensity = 1,
        scatteringFalloff = 1,
        scatteringExponent = 2,
        heightFogMinOpacity = 0,
        radiusFogFactor = 1,
        nearFogColor = {
          0.980392217636108,
          0.490196108818054,
          0.26274511218071,
          1
        },
        nearFogDistance = 0,
        farFogColor = {
          0.988235354423523,
          0.858823597431183,
          0.39607846736908,
          1
        },
        farFogDistance = 300,
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
    texPath = "Enviroment/CustomSkyboxes/sky_Guild_baseneo_d",
    tint = {
      1,
      1,
      1,
      1
    },
    rotation = 112,
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
return Enviroment_151
