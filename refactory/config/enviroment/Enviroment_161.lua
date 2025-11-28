local Enviroment_161 = {
  global = {
    sunDir = {
      0.970382273197174,
      -0.121194541454315,
      0.208974182605743,
      0
    },
    sunColor = {
      1,
      0.821268022060394,
      0.321568608283997,
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
      1,
      0.715715408325195,
      0.292452812194824,
      1
    },
    fogMode = 1,
    fogStartDistance = 10,
    fogEndDistance = 100,
    globalFogTuner = 0,
    heightFogMode = 1,
    heightFogCutoff = 9.99999974737875E-6,
    heightFogStart = -50,
    heightFogEnd = 150,
    scatteringDensity = 1,
    scatteringFalloff = 1,
    scatteringExponent = 2,
    heightFogMinOpacity = 0,
    radiusFogFactor = 1,
    nearFogColor = {
      0.971698105335236,
      0.54188859462738,
      0.320843726396561,
      1
    },
    nearFogDistance = 50,
    farFogColor = {
      1,
      0.715715408325195,
      0.292452812194824,
      1
    },
    farFogDistance = 100,
    enableLocalHeightFog = 0,
    localHeightFogStart = 0,
    localHeightFogEnd = 0,
    localHeightFogColor = {
      1,
      1,
      1,
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
          125,
          50,
          125
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
            -83
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
        fogEndDistance = 240,
        globalFogTuner = 0,
        heightFogMode = 1,
        heightFogCutoff = 9.99999974737875E-6,
        heightFogStart = -30,
        heightFogEnd = 200,
        scatteringDensity = 0.810000002384186,
        scatteringFalloff = 1,
        scatteringExponent = 2.19000005722046,
        heightFogMinOpacity = 0,
        radiusFogFactor = 1,
        nearFogColor = {
          0.972549080848694,
          0.564705908298492,
          0.34901961684227,
          1
        },
        nearFogDistance = 50,
        farFogColor = {
          1,
          0.729411780834198,
          0.321568638086319,
          0
        },
        farFogDistance = 200,
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
    texPath = "Enviroment/CustomSkyboxes/sky_izlude_diedai_sky",
    tint = {
      1,
      1,
      1,
      1
    },
    rotation = 286.5,
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
return Enviroment_161
