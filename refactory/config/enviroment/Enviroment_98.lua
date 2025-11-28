local Enviroment_98 = {
  global = {
    sunDir = {
      0.68755716085434,
      -0.707106828689575,
      0.165121287107468,
      0
    },
    sunColor = {
      1,
      0.759763360023499,
      0.330188691616058,
      1
    }
  },
  fog = {
    fog = true,
    fogColor = {
      1,
      0.833071410655975,
      0.537735819816589,
      1
    },
    fogMode = 1,
    fogStartDistance = 5,
    fogEndDistance = 120,
    globalFogTuner = 0.100000001490116,
    heightFogMode = 1,
    heightFogCutoff = 9.99999974737875E-6,
    heightFogStart = -20,
    heightFogEnd = 120,
    scatteringDensity = 1.9099999666214,
    scatteringFalloff = 4,
    scatteringExponent = 13.1000003814697,
    heightFogMinOpacity = 0,
    radiusFogFactor = 1,
    nearFogColor = {
      0.981132090091705,
      0.69122987985611,
      0.222143113613129,
      1
    },
    nearFogDistance = 20,
    farFogColor = {
      1,
      0.833071410655975,
      0.537735819816589,
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
  },
  wind = {
    sheenColorNear = {
      0.415094316005707,
      0.332256197929382,
      0.121395498514175,
      1
    },
    sheenColorFar = {
      0.77358490228653,
      0.550617039203644,
      0.211641147732735,
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
            -75.1999969482422
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
        fogStartDistance = 30,
        fogEndDistance = 140,
        globalFogTuner = 0,
        heightFogMode = 1,
        heightFogCutoff = 9.99999974737875E-6,
        heightFogStart = 0,
        heightFogEnd = 120,
        scatteringDensity = 1.9099999666214,
        scatteringFalloff = 1,
        scatteringExponent = 13.1000003814697,
        heightFogMinOpacity = 0,
        radiusFogFactor = 1,
        nearFogColor = {
          0.968627512454987,
          0.694117665290833,
          0.250980406999588,
          1
        },
        nearFogDistance = 30,
        farFogColor = {
          0.988235354423523,
          0.827451050281525,
          0.549019634723663,
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
    rotation = 248,
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
return Enviroment_98
