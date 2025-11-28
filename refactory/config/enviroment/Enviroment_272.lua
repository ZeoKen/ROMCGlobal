local Enviroment_272 = {
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
      0.5686274766922,
      0.885359883308411,
      1,
      1
    },
    fogMode = 1,
    fogStartDistance = 15,
    fogEndDistance = 96,
    globalFogTuner = 0.0500000007450581,
    heightFogMode = 1,
    heightFogCutoff = 9.99999974737875E-6,
    heightFogStart = -30,
    heightFogEnd = 200,
    scatteringDensity = 0,
    scatteringFalloff = 4,
    scatteringExponent = 40,
    heightFogMinOpacity = 0,
    radiusFogFactor = 1,
    nearFogColor = {
      1,
      0.601999998092651,
      0.865842521190643,
      1
    },
    nearFogDistance = 35,
    farFogColor = {
      0.5686274766922,
      0.885359883308411,
      1,
      1
    },
    farFogDistance = 164,
    enableLocalHeightFog = 0,
    localHeightFogStart = 20,
    localHeightFogEnd = 50,
    localHeightFogColor = {
      0.682182252407074,
      0.916682481765747,
      0.99056601524353,
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
          19.5,
          10,
          30.6000003814697
        },
        worldToLocalMatrix = {
          {
            1,
            0,
            0,
            -12.3000001907349
          },
          {
            0,
            1,
            0,
            -6.80000019073486
          },
          {
            0,
            0,
            1,
            64.3000030517578
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
          12.3000001907349,
          6.80000019073486,
          -64.3000030517578
        },
        worldRange = 37.6378784179688
      },
      fog = {
        fog = true,
        weight = 1,
        blendDuration = 0.5,
        fogMode = 1,
        fogStartDistance = 15,
        fogEndDistance = 180,
        globalFogTuner = -0.0500000007450581,
        heightFogMode = 2,
        heightFogCutoff = 9.99999974737875E-6,
        heightFogStart = 0,
        heightFogEnd = 100,
        sphereCenter = {
          0,
          0,
          0
        },
        radiusFogFactor = 1,
        nearFogColor = {
          1,
          0.603921592235565,
          0.866666734218597,
          1
        },
        nearFogDistance = 35,
        farFogColor = {
          0.5686274766922,
          0.886274576187134,
          1,
          0
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
    texPath = "Enviroment/CustomSkyboxes/sky_character_001_d",
    tint = {
      1,
      1,
      1,
      1
    },
    rotation = 327,
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
return Enviroment_272
