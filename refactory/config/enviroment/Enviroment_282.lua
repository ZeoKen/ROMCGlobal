local Enviroment_282 = {
  global = {
    sunDir = {
      -0.650486588478088,
      -0.642787516117096,
      -0.40458819270134,
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
      0.301960796117783,
      0.207843154668808,
      0.596078455448151,
      1
    },
    fogMode = 1,
    fogStartDistance = 8,
    fogEndDistance = 80,
    globalFogTuner = 0,
    heightFogMode = 1,
    heightFogCutoff = 9.99999974737875E-6,
    heightFogStart = -30,
    heightFogEnd = 420,
    scatteringDensity = 0,
    scatteringFalloff = 4,
    scatteringExponent = 0,
    heightFogMinOpacity = 0,
    radiusFogFactor = 1,
    nearFogColor = {
      1,
      0.749019622802734,
      0.223529428243637,
      1
    },
    nearFogDistance = 8,
    farFogColor = {
      0.301960796117783,
      0.207843154668808,
      0.596078455448151,
      1
    },
    farFogDistance = 40,
    enableLocalHeightFog = 1,
    localHeightFogStart = 15,
    localHeightFogEnd = 68,
    localHeightFogColor = {
      0.521568655967712,
      0.34901961684227,
      1,
      1
    }
  },
  wind = {
    sheenColorNear = {
      0.235294133424759,
      0.184313729405403,
      0.0509803965687752,
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
          50,
          50,
          50
        },
        worldToLocalMatrix = {
          {
            0.799425661563873,
            0,
            -0.60076504945755,
            -10.9372386932373
          },
          {
            0,
            1,
            0,
            -55.9000015258789
          },
          {
            0.60076504945755,
            0,
            0.799425661563873,
            59.8295669555664
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
          -27.2000007629395,
          55.9000015258789,
          -54.4000015258789
        },
        worldRange = 86.6025390625
      },
      fog = {
        fog = true,
        weight = 1,
        blendDuration = 0.5,
        fogMode = 1,
        fogStartDistance = 8,
        fogEndDistance = 80,
        globalFogTuner = 0,
        heightFogMode = 1,
        heightFogCutoff = 9.99999974737875E-6,
        heightFogStart = -30,
        heightFogEnd = 220,
        scatteringDensity = 0,
        scatteringFalloff = 1,
        scatteringExponent = 4,
        heightFogMinOpacity = 0,
        radiusFogFactor = 1,
        nearFogColor = {
          1,
          0.749019622802734,
          0.223529428243637,
          1
        },
        nearFogDistance = 8,
        farFogColor = {
          0.462745130062103,
          0.337254911661148,
          0.843137323856354,
          0
        },
        farFogDistance = 40,
        enableLocalHeightFog = 1,
        localHeightFogStart = 33.2999992370605,
        localHeightFogEnd = 50,
        localHeightFogColor = {
          0.505882382392883,
          0.372549027204514,
          0.929411828517914,
          0
        }
      }
    }
  },
  flare = {flareFadeSpeed = 1, flareStrength = 0.495999991893768},
  customskybox = {
    texPath = "Assets/Art/scene/enviroment/sky/sky_may_1F_xukong01",
    tint = {
      1,
      1,
      1,
      1
    },
    rotation = 293,
    exposure = 1,
    finite = true,
    sunsize = 0,
    applyFog = false
  },
  lightmap = {
    mode = 0,
    color = {
      1,
      1,
      1,
      1
    },
    duration = 3
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
return Enviroment_282
