local Enviroment_256 = {
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
    fogStartDistance = 8,
    fogEndDistance = 75,
    globalFogTuner = 0,
    heightFogMode = 1,
    heightFogCutoff = 9.99999974737875E-6,
    heightFogStart = -30,
    heightFogEnd = 200,
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
    nearFogDistance = 8,
    farFogColor = {
      0.654113948345184,
      0.523858845233917,
      0.992156863212585,
      1
    },
    farFogDistance = 120,
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
  volumes = {},
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
return Enviroment_256
