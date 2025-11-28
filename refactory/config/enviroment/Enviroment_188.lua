local Enviroment_188 = {
  global = {
    sunDir = {
      0,
      0,
      1,
      0
    },
    sunColor = {
      0.270588248968124,
      0.490196108818054,
      1,
      1
    }
  },
  fog = {
    fog = true,
    fogColor = {
      0.163000047206879,
      0.519893407821655,
      1,
      1
    },
    fogMode = 1,
    fogStartDistance = 0,
    fogEndDistance = 300,
    globalFogTuner = -0.0500000007450581,
    heightFogMode = 1,
    heightFogCutoff = 9.99999974737875E-6,
    heightFogStart = -30,
    heightFogEnd = 300,
    scatteringDensity = 0,
    scatteringFalloff = 1,
    scatteringExponent = 11.3999996185303,
    heightFogMinOpacity = 0,
    radiusFogFactor = 1,
    nearFogColor = {
      0.525322616100311,
      0,
      0.650943398475647,
      1
    },
    nearFogDistance = -20,
    farFogColor = {
      0.163000047206879,
      0.519893407821655,
      1,
      1
    },
    farFogDistance = 100,
    enableLocalHeightFog = 1,
    localHeightFogStart = -20,
    localHeightFogEnd = 25.7999992370605,
    localHeightFogColor = {
      0.32106152176857,
      0.0474782511591911,
      0.546000003814697,
      1
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
            -90
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
        fogStartDistance = 0,
        fogEndDistance = 230,
        globalFogTuner = -0.100000001490116,
        heightFogMode = 1,
        heightFogCutoff = 9.99999974737875E-6,
        heightFogStart = 0,
        heightFogEnd = 300,
        scatteringDensity = 0,
        scatteringFalloff = 1,
        scatteringExponent = 11.3999996185303,
        heightFogMinOpacity = 0,
        radiusFogFactor = 1,
        nearFogColor = {
          0.537254929542542,
          0.0392156876623631,
          0.658823549747467,
          1
        },
        nearFogDistance = -20,
        farFogColor = {
          0.196078449487686,
          0.533333361148834,
          0.988235354423523,
          1
        },
        farFogDistance = 100,
        enableLocalHeightFog = 1,
        localHeightFogStart = 0,
        localHeightFogEnd = 30,
        localHeightFogColor = {
          0.345098048448563,
          0.0823529437184334,
          0.556862771511078,
          1
        }
      }
    }
  },
  flare = {flareFadeSpeed = 1, flareStrength = 0.574999988079071},
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
return Enviroment_188
