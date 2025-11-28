local Enviroment_174 = {
  global = {
    sunDir = {
      0.744912385940552,
      -0.517244815826416,
      0.421382635831833,
      0
    },
    sunColor = {
      0.705882370471954,
      0.427451014518738,
      0.192156881093979,
      1
    }
  },
  fog = {
    fog = true,
    fogColor = {
      0.829999983310699,
      0.523260831832886,
      0.263434767723084,
      1
    },
    fogMode = 1,
    fogStartDistance = 5,
    fogEndDistance = 150,
    globalFogTuner = 0,
    heightFogMode = 1,
    heightFogCutoff = 9.99999974737875E-6,
    heightFogStart = 0,
    heightFogEnd = 300,
    scatteringDensity = 0,
    scatteringFalloff = 4,
    scatteringExponent = 27,
    heightFogMinOpacity = 0.162200003862381,
    radiusFogFactor = 1,
    nearFogColor = {
      1,
      0.38039219379425,
      0.333333343267441,
      1
    },
    nearFogDistance = 50,
    farFogColor = {
      0.829999983310699,
      0.523260831832886,
      0.263434767723084,
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
            -176.300003051758
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
            -9
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
        fogEndDistance = 170,
        globalFogTuner = 0,
        heightFogMode = 1,
        heightFogCutoff = 0,
        heightFogStart = 0,
        heightFogEnd = 400,
        scatteringDensity = 0,
        scatteringFalloff = 1,
        scatteringExponent = 27,
        heightFogMinOpacity = 0.162200003862381,
        radiusFogFactor = 1,
        nearFogColor = {
          0.988235354423523,
          0.400000035762787,
          0.356862753629684,
          1
        },
        nearFogDistance = 20,
        farFogColor = {
          0.827451050281525,
          0.533333361148834,
          0.290196090936661,
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
          50,
          50,
          150
        },
        worldToLocalMatrix = {
          {
            1,
            0,
            0,
            23.2999992370605
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
            -9.10000038146973
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
        fogEndDistance = 170,
        globalFogTuner = 0,
        heightFogMode = 1,
        heightFogCutoff = 9.99999974737875E-6,
        heightFogStart = 0,
        heightFogEnd = 400,
        scatteringDensity = 0,
        scatteringFalloff = 1,
        scatteringExponent = 27,
        heightFogMinOpacity = 0.162200003862381,
        radiusFogFactor = 1,
        nearFogColor = {
          0.988235354423523,
          0.400000035762787,
          0.356862753629684,
          1
        },
        nearFogDistance = 20,
        farFogColor = {
          0.827451050281525,
          0.533333361148834,
          0.290196090936661,
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
      }
    }
  },
  flare = {flareFadeSpeed = 1, flareStrength = 0.495999991893768},
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
return Enviroment_174
