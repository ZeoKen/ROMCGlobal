local Enviroment_211 = {
  global = {
    sunDir = {
      -0.324391633272171,
      -0.906308114528656,
      0.270879626274109,
      0
    },
    sunColor = {
      1,
      0.953134477138519,
      0.792452812194824,
      1
    }
  },
  fog = {
    fog = true,
    fogColor = {
      0.603773593902588,
      0.887057423591614,
      1,
      1
    },
    fogMode = 1,
    fogStartDistance = 7,
    fogEndDistance = 85,
    globalFogTuner = 0,
    heightFogMode = 1,
    heightFogCutoff = 9.99999974737875E-6,
    heightFogStart = -200,
    heightFogEnd = 900,
    scatteringDensity = 1.17999994754791,
    scatteringFalloff = 4,
    scatteringExponent = 40,
    heightFogMinOpacity = 0,
    radiusFogFactor = 1,
    nearFogColor = {
      0,
      0.578822135925293,
      0.952830195426941,
      1
    },
    nearFogDistance = 0,
    farFogColor = {
      0.603773593902588,
      0.887057423591614,
      1,
      1
    },
    farFogDistance = 65,
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
          100,
          50,
          100
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
            -68
          },
          {
            0,
            0,
            1,
            -9.89999961853027
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
        fogStartDistance = 15,
        fogEndDistance = 120,
        globalFogTuner = 0,
        heightFogMode = 1,
        heightFogCutoff = 0,
        heightFogStart = 0,
        heightFogEnd = 800,
        scatteringDensity = 1.17999994754791,
        scatteringFalloff = 1,
        scatteringExponent = 40,
        heightFogMinOpacity = 0,
        radiusFogFactor = 1,
        nearFogColor = {
          0.0392156876623631,
          0.588235318660736,
          0.945098102092743,
          1
        },
        nearFogDistance = 0,
        farFogColor = {
          0.61176472902298,
          0.878431439399719,
          0.988235354423523,
          1
        },
        farFogDistance = 70,
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
    texPath = "Enviroment/CustomSkyboxes/sky_characterchoose_d",
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
return Enviroment_211
