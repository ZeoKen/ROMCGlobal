local Enviroment_127 = {
  global = {
    sunDir = {
      0.565874695777893,
      -0.57750004529953,
      -0.588455379009247,
      0
    },
    sunColor = {
      0.584313750267029,
      0.811764776706696,
      0.858823597431183,
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
      0.501960813999176,
      0.796078503131866,
      0.886274576187134,
      1
    },
    fogMode = 1,
    fogStartDistance = 10,
    fogEndDistance = 100,
    globalFogTuner = 0,
    heightFogMode = 1,
    heightFogCutoff = 9.99999974737875E-6,
    heightFogStart = 0,
    heightFogEnd = 350,
    scatteringDensity = 0,
    scatteringFalloff = 1,
    scatteringExponent = 0,
    heightFogMinOpacity = 0,
    radiusFogFactor = 1,
    nearFogColor = {
      0.364705890417099,
      0.756862819194794,
      0.99215692281723,
      1
    },
    nearFogDistance = 80,
    farFogColor = {
      0.501960813999176,
      0.796078503131866,
      0.886274576187134,
      1
    },
    farFogDistance = 150,
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
            -77.6999969482422
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
        fogStartDistance = 20,
        fogEndDistance = 120,
        globalFogTuner = 0,
        heightFogMode = 1,
        heightFogCutoff = 9.99999974737875E-6,
        heightFogStart = 0,
        heightFogEnd = 400,
        scatteringDensity = 0,
        scatteringFalloff = 1,
        scatteringExponent = 0,
        heightFogMinOpacity = 0,
        radiusFogFactor = 1,
        nearFogColor = {
          0.384313762187958,
          0.756862819194794,
          0.980392217636108,
          1
        },
        nearFogDistance = 80,
        farFogColor = {
          0.513725519180298,
          0.796078503131866,
          0.878431439399719,
          1
        },
        farFogDistance = 150,
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
  flare = {flareFadeSpeed = 1, flareStrength = 0},
  customskybox = {
    texPath = "Enviroment/CustomSkyboxes/sky_dis_iz_dis_002_d",
    tint = {
      1,
      1,
      1,
      1
    },
    rotation = 0,
    exposure = 1.21000003814697,
    finite = true,
    sunsize = 0.13400000333786,
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
return Enviroment_127
