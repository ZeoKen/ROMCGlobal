local Enviroment_203 = {
  global = {
    sunDir = {
      0.469846308231354,
      -0.866025447845459,
      -0.171010136604309,
      0
    },
    sunColor = {
      0.952830195426941,
      0.897899746894836,
      0.710128128528595,
      1
    }
  },
  lighting = {
    ambientMode = 0,
    ambientLight = {
      0.943396210670471,
      0.964764773845673,
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
      0.670588254928589,
      0.800000071525574,
      0.956862807273865,
      1
    },
    fogMode = 1,
    fogStartDistance = 15,
    fogEndDistance = 100,
    globalFogTuner = 0,
    heightFogMode = 1,
    heightFogCutoff = 9.99999974737875E-6,
    heightFogStart = -5,
    heightFogEnd = 60,
    scatteringDensity = 1,
    scatteringFalloff = 4,
    scatteringExponent = 12.5,
    heightFogMinOpacity = 0,
    radiusFogFactor = 1,
    nearFogColor = {
      0.686274528503418,
      0.776052117347717,
      0.909803926944733,
      1
    },
    nearFogDistance = 100,
    farFogColor = {
      0.670588254928589,
      0.800000071525574,
      0.956862807273865,
      1
    },
    farFogDistance = 80,
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
          96.5999984741211,
          71.6500015258789,
          100
        },
        worldToLocalMatrix = {
          {
            0.0439541935920715,
            0,
            -0.999033689498901,
            52.4889526367188
          },
          {
            0,
            1,
            0,
            -37.0999984741211
          },
          {
            0.999033689498901,
            0,
            0.0439541935920715,
            -160.662399291992
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
        fogEndDistance = 80,
        globalFogTuner = 0,
        heightFogMode = 1,
        heightFogCutoff = 9.99999974737875E-6,
        heightFogStart = 0,
        heightFogEnd = 60,
        scatteringDensity = 1,
        scatteringFalloff = 1,
        scatteringExponent = 12.5,
        heightFogMinOpacity = 0,
        radiusFogFactor = 1,
        nearFogColor = {
          0.711529433727264,
          0.821742713451386,
          0.988235294818878,
          1
        },
        nearFogDistance = 90,
        farFogColor = {
          0.694117665290833,
          0.803921639919281,
          0.988235354423523,
          0
        },
        farFogDistance = 80,
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
          200,
          50,
          200
        },
        worldToLocalMatrix = {
          {
            1,
            0,
            0,
            -43.2000007629395
          },
          {
            0,
            1,
            0,
            -81.3000030517578
          },
          {
            0,
            0,
            1,
            118.099998474121
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
        fogEndDistance = 130,
        globalFogTuner = 0,
        heightFogMode = 1,
        heightFogCutoff = 9.99999974737875E-6,
        heightFogStart = 0,
        heightFogEnd = 60,
        scatteringDensity = 1,
        scatteringFalloff = 1,
        scatteringExponent = 12.5,
        heightFogMinOpacity = 0,
        radiusFogFactor = 1,
        nearFogColor = {
          0.690196096897125,
          0.77647066116333,
          0.901960849761963,
          1
        },
        nearFogDistance = 120,
        farFogColor = {
          0.674509823322296,
          0.800000071525574,
          0.94901967048645,
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
  flare = {flareFadeSpeed = 1, flareStrength = 0.495999991893768},
  customskybox = {
    texPath = "Enviroment/CustomSkyboxes/surface_pronteraneo_L_sky",
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
return Enviroment_203
