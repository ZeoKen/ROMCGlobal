local Enviroment_143 = {
  global = {
    sunDir = {
      0.364100158214569,
      -0.779615819454193,
      -0.509539604187012,
      0
    },
    sunColor = {
      0.679245293140411,
      0.505562782287598,
      0.448558211326599,
      1
    }
  },
  fog = {
    fog = true,
    fogColor = {
      0.304341107606888,
      0.327751964330673,
      0.60400003194809,
      0
    },
    fogMode = 1,
    fogStartDistance = 10,
    fogEndDistance = 200,
    globalFogTuner = 0,
    heightFogMode = 1,
    heightFogCutoff = 9.99999974737875E-6,
    heightFogStart = -20,
    heightFogEnd = 300,
    scatteringDensity = 0,
    scatteringFalloff = 1,
    scatteringExponent = 0,
    heightFogMinOpacity = 0,
    radiusFogFactor = 1,
    nearFogColor = {
      0.367883175611496,
      0.332846730947495,
      0.600000023841858,
      1
    },
    nearFogDistance = 70,
    farFogColor = {
      0.304341107606888,
      0.327751964330673,
      0.60400003194809,
      0
    },
    farFogDistance = 100,
    enableLocalHeightFog = 1,
    localHeightFogStart = -10,
    localHeightFogEnd = 5,
    localHeightFogColor = {
      0.349999994039536,
      0.0799999907612801,
      0.149999991059303,
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
          130,
          130,
          130
        },
        worldToLocalMatrix = {
          {
            0.999042272567749,
            0,
            -0.0437554270029068,
            66.9686584472656
          },
          {
            0,
            1,
            0,
            -32
          },
          {
            0.0437554270029068,
            0,
            0.999042272567749,
            -4.67423439025879
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
        fogStartDistance = 10,
        fogEndDistance = 120,
        globalFogTuner = 0,
        heightFogMode = 1,
        heightFogCutoff = 9.99999974737875E-6,
        heightFogStart = -20,
        heightFogEnd = 300,
        scatteringDensity = 0.5,
        scatteringFalloff = 1,
        scatteringExponent = 3.20000004768372,
        heightFogMinOpacity = 0,
        radiusFogFactor = 1,
        nearFogColor = {
          0.367883175611496,
          0.332846730947495,
          0.600000023841858,
          1
        },
        nearFogDistance = 70,
        farFogColor = {
          0.304341107606888,
          0.327751964330673,
          0.60400003194809,
          0
        },
        farFogDistance = 100,
        enableLocalHeightFog = 1,
        localHeightFogStart = -10,
        localHeightFogEnd = 5,
        localHeightFogColor = {
          0.349999994039536,
          0.0799999907612801,
          0.149999991059303,
          0
        }
      }
    },
    [2] = {
      volume = {
        type = 0,
        center = {
          0,
          0,
          0
        },
        extents = {
          130,
          130,
          130
        },
        worldToLocalMatrix = {
          {
            1,
            0,
            0,
            63.4000015258789
          },
          {
            0,
            1,
            0,
            -439.899993896484
          },
          {
            0,
            0,
            1,
            -618
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
        fogStartDistance = 10,
        fogEndDistance = 130,
        globalFogTuner = 0,
        heightFogMode = 1,
        heightFogCutoff = 9.99999974737875E-6,
        heightFogStart = -20,
        heightFogEnd = 300,
        scatteringDensity = 0.600000023841858,
        scatteringFalloff = 1,
        scatteringExponent = 3.20000004768372,
        heightFogMinOpacity = 0,
        radiusFogFactor = 1,
        nearFogColor = {
          0.367883175611496,
          0.332846730947495,
          0.600000023841858,
          1
        },
        nearFogDistance = 70,
        farFogColor = {
          0.304341107606888,
          0.327751964330673,
          0.60400003194809,
          0
        },
        farFogDistance = 100,
        enableLocalHeightFog = 1,
        localHeightFogStart = 420,
        localHeightFogEnd = 446,
        localHeightFogColor = {
          0.34901961684227,
          0.0784313753247261,
          0.10959979891777,
          0
        }
      }
    }
  },
  flare = {flareFadeSpeed = 0, flareStrength = 0},
  customskybox = {
    texPath = "Enviroment/CustomSkyboxes/sky_prt_hunt1_d",
    tint = {
      1,
      1,
      1,
      1
    },
    rotation = 0,
    exposure = 1,
    finite = true,
    sunsize = 0,
    applyFog = true
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
return Enviroment_143
