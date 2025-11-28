local Enviroment_138 = {
  global = {
    sunDir = {
      0.327253878116608,
      -0.922470331192017,
      -0.204824760556221,
      0
    },
    sunColor = {
      1,
      1,
      1,
      1
    }
  },
  lighting = {
    ambientMode = 0,
    ambientLight = {
      1,
      1,
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
      0.890441179275513,
      0.851000010967255,
      1,
      1
    },
    fogMode = 1,
    fogStartDistance = 40,
    fogEndDistance = 260,
    globalFogTuner = 0,
    heightFogMode = 1,
    heightFogCutoff = 9.99999974737875E-6,
    heightFogStart = 0,
    heightFogEnd = 110,
    scatteringDensity = 0,
    scatteringFalloff = 4,
    scatteringExponent = 0,
    heightFogMinOpacity = 0,
    radiusFogFactor = 1,
    nearFogColor = {
      1,
      0.623239457607269,
      0.25,
      1
    },
    nearFogDistance = 40,
    farFogColor = {
      0.890441179275513,
      0.851000010967255,
      1,
      1
    },
    farFogDistance = 340,
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
          0.5,
          0.5,
          0.5
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
            0
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
          0,
          0
        },
        worldRange = 0.866025388240814
      },
      fog = {fog = false}
    }
  },
  flare = {flareFadeSpeed = 1, flareStrength = 0.495999991893768},
  customskybox = {
    texPath = "Enviroment/CustomSkyboxes/surface_pronteraneo1_n_sky",
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
    index = 1,
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
return Enviroment_138
