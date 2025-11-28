local Enviroment_236 = {
  global = {
    sunDir = {
      0.109539493918419,
      -0.496991276741028,
      -0.860814154148102,
      0
    },
    sunColor = {
      0.574798762798309,
      0.425920009613037,
      0.879999995231628,
      1
    }
  },
  fog = {
    fog = true,
    fogColor = {
      0.610655665397644,
      0.532786905765533,
      1,
      1
    },
    fogMode = 1,
    fogStartDistance = 18,
    fogEndDistance = 90,
    globalFogTuner = 0.0500000007450581,
    heightFogMode = 1,
    heightFogCutoff = 9.99999974737875E-6,
    heightFogStart = 0,
    heightFogEnd = 360,
    scatteringDensity = 2.17000007629395,
    scatteringFalloff = 4,
    scatteringExponent = 17.7999992370605,
    heightFogMinOpacity = 0,
    radiusFogFactor = 1,
    nearFogColor = {
      0.346938848495483,
      0.261224508285522,
      0.800000011920929,
      1
    },
    nearFogDistance = 30,
    farFogColor = {
      0.610655665397644,
      0.532786905765533,
      1,
      1
    },
    farFogDistance = 180,
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
          25,
          15,
          25
        },
        worldToLocalMatrix = {
          {
            0.896661102771759,
            0,
            -0.442717641592026,
            -75.8980941772461
          },
          {
            0,
            1,
            0,
            -53.6199989318848
          },
          {
            0.442717641592026,
            0,
            0.896661102771759,
            -14.3548393249512
          },
          {
            0,
            0,
            0,
            1
          }
        },
        radius = 18.5,
        priority = 0
      },
      fog = {
        fog = true,
        weight = 1,
        blendDuration = 1,
        fogMode = 1,
        fogStartDistance = 15,
        fogEndDistance = 180,
        globalFogTuner = 0.0799999982118607,
        heightFogMode = 1,
        heightFogCutoff = 9.99999974737875E-6,
        heightFogStart = 0,
        heightFogEnd = 360,
        scatteringDensity = 0.360000014305115,
        scatteringFalloff = 1,
        scatteringExponent = 1.07000005245209,
        heightFogMinOpacity = 0,
        radiusFogFactor = 1,
        nearFogColor = {
          0.425804436206818,
          0.184313699603081,
          0.564705908298492,
          1
        },
        nearFogDistance = 50,
        farFogColor = {
          0.649498581886292,
          0.532156884670258,
          0.901960790157318,
          1
        },
        farFogDistance = 220,
        enableLocalHeightFog = 1,
        localHeightFogStart = 12,
        localHeightFogEnd = 50,
        localHeightFogColor = {
          0.231372565031052,
          0.303836047649384,
          0.878431379795074,
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
          30,
          20,
          30
        },
        worldToLocalMatrix = {
          {
            0.829539835453033,
            0,
            -0.558447539806366,
            92.000846862793
          },
          {
            0,
            1,
            0,
            -34.2000007629395
          },
          {
            0.558447539806366,
            0,
            0.829539835453033,
            60.8501777648926
          },
          {
            0,
            0,
            0,
            1
          }
        },
        radius = 18.5,
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
        scatteringDensity = 0.360000014305115,
        scatteringFalloff = 1,
        scatteringExponent = 1.07000005245209,
        heightFogMinOpacity = 0,
        radiusFogFactor = 1,
        nearFogColor = {
          0.425804436206818,
          0.184313699603081,
          0.564705908298492,
          1
        },
        nearFogDistance = 50,
        farFogColor = {
          0.623985707759857,
          0.492470562458038,
          0.901960790157318,
          1
        },
        farFogDistance = 160,
        enableLocalHeightFog = 1,
        localHeightFogStart = 18,
        localHeightFogEnd = 30,
        localHeightFogColor = {
          1,
          0.307919293642044,
          0.174528300762177,
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
return Enviroment_236
