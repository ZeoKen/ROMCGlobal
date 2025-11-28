local Enviroment_261 = {
  global = {
    sunDir = {
      0.147976130247116,
      -0.104528464376926,
      0.98345148563385,
      0
    },
    sunColor = {
      0.905882358551025,
      0.852048635482788,
      0.527223527431488,
      1
    }
  },
  fog = {
    fog = true,
    fogColor = {
      0.914377868175507,
      0.937254905700684,
      0.511741161346436,
      1
    },
    fogMode = 1,
    fogStartDistance = 0,
    fogEndDistance = 150,
    globalFogTuner = 0.0399999991059303,
    heightFogMode = 1,
    heightFogCutoff = 9.99999974737875E-6,
    heightFogStart = 0,
    heightFogEnd = 250,
    scatteringDensity = 1.37000000476837,
    scatteringFalloff = 4,
    scatteringExponent = 11.8999996185303,
    heightFogMinOpacity = 0.224000006914139,
    radiusFogFactor = 1,
    nearFogColor = {
      0.0192307606339455,
      0.46538457274437,
      0.600000023841858,
      1
    },
    nearFogDistance = 0,
    farFogColor = {
      0.914377868175507,
      0.937254905700684,
      0.511741161346436,
      1
    },
    farFogDistance = 180,
    enableLocalHeightFog = 1,
    localHeightFogStart = -24,
    localHeightFogEnd = -9,
    localHeightFogColor = {
      0,
      0.502499878406525,
      0.736999988555908,
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
          35,
          35,
          35
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
            22.2800006866455
          },
          {
            0,
            0,
            1,
            132.300003051758
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
        fogEndDistance = 150,
        globalFogTuner = 0.0399999991059303,
        heightFogMode = 1,
        heightFogCutoff = 0,
        heightFogStart = 0,
        heightFogEnd = 250,
        scatteringDensity = 1.37000000476837,
        scatteringFalloff = 1,
        scatteringExponent = 11.8999996185303,
        heightFogMinOpacity = 0.224000006914139,
        radiusFogFactor = 1,
        nearFogColor = {
          0.0196078438311815,
          0.466666698455811,
          0.600000023841858,
          1
        },
        nearFogDistance = 0,
        farFogColor = {
          0.917647063732147,
          0.937254905700684,
          0.572549045085907,
          0
        },
        farFogDistance = 180,
        enableLocalHeightFog = 1,
        localHeightFogStart = -33.2999992370605,
        localHeightFogEnd = -22.6000003814697,
        localHeightFogColor = {
          0,
          0.501960813999176,
          0.737254917621613,
          0
        }
      }
    }
  },
  flare = {flareFadeSpeed = 1, flareStrength = 0.495999991893768},
  customskybox = {
    texPath = "Enviroment/CustomSkyboxes/sky_Guild_baseneo2_d",
    tint = {
      0.470588207244873,
      0.751692056655884,
      1,
      1
    },
    rotation = 185,
    exposure = 1.39999997615814,
    finite = true,
    sunsize = 0,
    applyFog = true
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
return Enviroment_261
