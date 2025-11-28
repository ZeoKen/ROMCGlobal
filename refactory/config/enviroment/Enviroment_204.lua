local Enviroment_204 = {
  global = {
    sunDir = {
      0.389331459999084,
      -0.707106947898865,
      -0.590272128582001,
      0
    },
    sunColor = {
      0.433962285518646,
      0.818578600883484,
      1,
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
      0.654113948345184,
      0.523858845233917,
      0.992156863212585,
      1
    },
    fogMode = 1,
    fogStartDistance = 12,
    fogEndDistance = 90,
    globalFogTuner = 0.0299999993294477,
    heightFogMode = 1,
    heightFogCutoff = 9.99999974737875E-6,
    heightFogStart = -200,
    heightFogEnd = 1600,
    scatteringDensity = 0,
    scatteringFalloff = 4,
    scatteringExponent = 0,
    heightFogMinOpacity = 0,
    radiusFogFactor = 1,
    nearFogColor = {
      0.524542093276978,
      0.484172523021698,
      0.992156863212585,
      1
    },
    nearFogDistance = 0,
    farFogColor = {
      0.654113948345184,
      0.523858845233917,
      0.992156863212585,
      1
    },
    farFogDistance = 220,
    enableLocalHeightFog = 0,
    localHeightFogStart = -6,
    localHeightFogEnd = 0.5,
    localHeightFogColor = {
      0.407912880182266,
      0.256270587444305,
      0.537254929542542,
      0
    }
  },
  wind = {
    sheenColorNear = {
      0.301960796117783,
      0.254901975393295,
      0.129411771893501,
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
        type = 1,
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
            1,
            0,
            0,
            138.850006103516
          },
          {
            0,
            1,
            0,
            -16.8400001525879
          },
          {
            0,
            0,
            1,
            89.6100006103516
          },
          {
            0,
            0,
            0,
            1
          }
        },
        radius = 38.7999992370605,
        priority = 0
      },
      fog = {
        fog = true,
        weight = 1,
        blendDuration = 0.5,
        fogMode = 1,
        fogStartDistance = 8,
        fogEndDistance = 70,
        globalFogTuner = 0,
        heightFogMode = 1,
        heightFogCutoff = 9.99999974737875E-6,
        heightFogStart = -30,
        heightFogEnd = 200,
        scatteringDensity = 0,
        scatteringFalloff = 1,
        scatteringExponent = 0,
        heightFogMinOpacity = 0,
        radiusFogFactor = 1,
        nearFogColor = {
          0.243137240409851,
          0.852298319339752,
          1,
          1
        },
        nearFogDistance = 8,
        farFogColor = {
          0.254000008106232,
          0.754636645317078,
          0.996078431606293,
          0
        },
        farFogDistance = 50,
        enableLocalHeightFog = 0,
        localHeightFogStart = 10,
        localHeightFogEnd = 16,
        localHeightFogColor = {
          0,
          0.461988210678101,
          1,
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
    rotation = 132,
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
return Enviroment_204
