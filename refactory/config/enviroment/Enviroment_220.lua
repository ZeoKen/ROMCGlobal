local Enviroment_220 = {
  global = {
    sunDir = {
      0,
      -1.00000011920929,
      -7.45058059692383E-8,
      0
    },
    sunColor = {
      0.270202934741974,
      0.788334667682648,
      0.867924511432648,
      1
    }
  },
  fog = {
    fog = true,
    fogColor = {
      0.00703098857775331,
      0.315359652042389,
      0.745283007621765,
      1
    },
    fogMode = 1,
    fogStartDistance = 10,
    fogEndDistance = 120,
    globalFogTuner = 0.0500000007450581,
    heightFogMode = 1,
    heightFogCutoff = 9.99999974737875E-6,
    heightFogStart = 0,
    heightFogEnd = 350,
    scatteringDensity = 0,
    scatteringFalloff = 4,
    scatteringExponent = 0,
    heightFogMinOpacity = 0,
    radiusFogFactor = 1,
    nearFogColor = {
      0.0185119118541479,
      0.812044978141785,
      0.981132090091705,
      1
    },
    nearFogDistance = 40,
    farFogColor = {
      0.00703098857775331,
      0.315359652042389,
      0.745283007621765,
      1
    },
    farFogDistance = 160,
    enableLocalHeightFog = 0,
    localHeightFogStart = 110,
    localHeightFogEnd = 130,
    localHeightFogColor = {
      0.367924511432648,
      0.906855046749115,
      1,
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
          22.5,
          22.5,
          22.5
        },
        worldToLocalMatrix = {
          {
            1,
            0,
            0,
            25.6000003814697
          },
          {
            0,
            -0.119047619402409,
            0,
            16.9166679382324
          },
          {
            0,
            0,
            1,
            -31.8600006103516
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
        fogStartDistance = 0,
        fogEndDistance = 104.050003051758,
        globalFogTuner = 0,
        heightFogMode = 1,
        heightFogCutoff = 9.99999974737875E-6,
        heightFogStart = 0,
        heightFogEnd = 300,
        scatteringDensity = 0,
        scatteringFalloff = 1,
        scatteringExponent = 0,
        heightFogMinOpacity = 0,
        radiusFogFactor = 1,
        nearFogColor = {
          0.0608757548034191,
          0.225347056984901,
          0.358490586280823,
          1
        },
        nearFogDistance = 80,
        farFogColor = {
          0.0797436833381653,
          0.385144978761673,
          0.528301894664764,
          1
        },
        farFogDistance = 160,
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
    texPath = "Enviroment/CustomSkyboxes/sky_qianshui",
    tint = {
      1,
      1,
      1,
      1
    },
    rotation = 124,
    exposure = 1,
    finite = true,
    sunsize = 0,
    applyFog = true
  },
  bloom = {
    index = 0,
    version = 1,
    threshold = 0.600000023841858,
    intensity = 1,
    bExposure = false,
    scatter = 0.899999976158142,
    clamp = 0,
    highQualityFiltering = false,
    dirtIntensity = 0
  }
}
return Enviroment_220
