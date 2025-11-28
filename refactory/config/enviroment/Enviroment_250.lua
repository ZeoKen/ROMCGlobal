local Enviroment_250 = {
  global = {
    sunDir = {
      0.0178999807685614,
      -0.939692616462708,
      -0.341551274061203,
      0
    },
    sunColor = {
      0.405660390853882,
      1,
      0.951813638210297,
      1
    }
  },
  fog = {
    fog = true,
    fogColor = {
      0.61176472902298,
      0.533333361148834,
      1,
      1
    },
    fogMode = 1,
    fogStartDistance = 0,
    fogEndDistance = 90,
    globalFogTuner = 0.0299999993294477,
    heightFogMode = 1,
    heightFogCutoff = 9.99999974737875E-6,
    heightFogStart = 0,
    heightFogEnd = 360,
    scatteringDensity = 0,
    scatteringFalloff = 4,
    scatteringExponent = 0,
    heightFogMinOpacity = 0,
    radiusFogFactor = 1,
    nearFogColor = {
      0.397611647844315,
      0.348033100366592,
      0.933962285518646,
      1
    },
    nearFogDistance = 0,
    farFogColor = {
      0.61176472902298,
      0.533333361148834,
      1,
      1
    },
    farFogDistance = 220,
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
          75,
          75,
          75
        },
        worldToLocalMatrix = {
          {
            1,
            0,
            0,
            -263.600006103516
          },
          {
            0,
            1,
            0,
            -8.85000038146973
          },
          {
            0,
            0,
            1,
            311.600006103516
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
        blendDuration = 1.5,
        fogMode = 1,
        fogStartDistance = 15,
        fogEndDistance = 120,
        globalFogTuner = 0.0500000007450581,
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
          0.427451014518738,
          0.184313729405403,
          0.564705908298492,
          1
        },
        nearFogDistance = 50,
        farFogColor = {
          0.623529434204102,
          0.494117677211761,
          0.901960849761963,
          0
        },
        farFogDistance = 160,
        enableLocalHeightFog = 1,
        localHeightFogStart = 15.8400001525879,
        localHeightFogEnd = 30,
        localHeightFogColor = {
          1,
          0.309803932905197,
          0.176470592617989,
          0
        }
      }
    }
  },
  flare = {flareFadeSpeed = 1, flareStrength = 0.495999991893768},
  customskybox = {
    texPath = "Enviroment/CustomSkyboxes/sky_pvp_001_d",
    tint = {
      1,
      1,
      1,
      1
    },
    rotation = 360,
    exposure = 1,
    finite = true,
    sunsize = 0,
    applyFog = false
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
return Enviroment_250
