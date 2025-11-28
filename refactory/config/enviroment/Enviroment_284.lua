local Enviroment_284 = {
  global = {
    sunDir = {
      -0.663946926593781,
      -0.642051815986633,
      0.383332788944244,
      0
    },
    sunColor = {
      1,
      0.959416151046753,
      0.820754706859589,
      1
    }
  },
  fog = {
    fog = true,
    fogColor = {
      0.466666698455811,
      0.960784375667572,
      0.866666734218597,
      1
    },
    fogMode = 1,
    fogStartDistance = 10,
    fogEndDistance = 180,
    globalFogTuner = 0,
    heightFogMode = 1,
    heightFogCutoff = 9.99999974737875E-6,
    heightFogStart = -80,
    heightFogEnd = 250,
    scatteringDensity = 0.0199999995529652,
    scatteringFalloff = 4,
    scatteringExponent = 1.5,
    heightFogMinOpacity = 0.109999999403954,
    radiusFogFactor = 1,
    nearFogColor = {
      0.917675316333771,
      0.99056601524353,
      0.626112461090088,
      1
    },
    nearFogDistance = 40,
    farFogColor = {
      0.466666698455811,
      0.960784375667572,
      0.866666734218597,
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
  wind = {
    sheenColorNear = {
      0.301886796951294,
      0.255606979131699,
      0.131007477641106,
      1
    },
    sheenColorFar = {
      0.443137288093567,
      0.368627458810806,
      0.0980392247438431,
      1
    },
    sheenDistanceNear = 31,
    sheenDistanceFar = 39,
    sheenScatterMinInten = 0.5,
    sheenPower = 6,
    windTexTiling = {
      5,
      5,
      0,
      0
    },
    windAngle = 170,
    windWaveSpeed = 0.150000005960464,
    windBendStrength = 0.152999997138977,
    windWaveSwingEffect = 0.100000001490116,
    windMask = 0.5,
    windSheenInten = 1,
    windWaveDisorderFreq = 0.238999992609024
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
          1650,
          250,
          1650
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
            -282
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
        priority = 0,
        worldCenter = {
          0,
          282,
          0
        },
        worldRange = 2346.80639648438
      },
      fog = {fog = false}
    }
  },
  flare = {flareFadeSpeed = 1, flareStrength = 0.495999991893768},
  customskybox = {
    texPath = "Enviroment/CustomSkyboxes/sky_sc_lxlzc_d",
    tint = {
      1,
      1,
      1,
      1
    },
    rotation = 18.6000003814697,
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
return Enviroment_284
