local Enviroment_167 = {
  global = {
    sunDir = {
      -0.108421385288239,
      -0.993839979171753,
      0.0229574292898178,
      0
    },
    sunColor = {
      0.952830195426941,
      0.897899746894836,
      0.710128128528595,
      1
    }
  },
  fog = {
    fog = true,
    fogColor = {
      0.337486654520035,
      0.766296982765198,
      0.905660390853882,
      1
    },
    fogMode = 1,
    fogStartDistance = 10,
    fogEndDistance = 80,
    globalFogTuner = 0,
    heightFogMode = 1,
    heightFogCutoff = 9.99999974737875E-6,
    heightFogStart = -20,
    heightFogEnd = 200,
    scatteringDensity = 1,
    scatteringFalloff = 4,
    scatteringExponent = 2,
    heightFogMinOpacity = 0.100000001490116,
    radiusFogFactor = 1,
    nearFogColor = {
      0.294117659330368,
      0.423529446125031,
      0.69803923368454,
      1
    },
    nearFogDistance = 30,
    farFogColor = {
      0.337486654520035,
      0.766296982765198,
      0.905660390853882,
      1
    },
    farFogDistance = 100,
    enableLocalHeightFog = 1,
    localHeightFogStart = -60,
    localHeightFogEnd = -10,
    localHeightFogColor = {
      0.572935223579407,
      0.798143267631531,
      0.971698105335236,
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
          200,
          50,
          200
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
        fogEndDistance = 100,
        globalFogTuner = 0.100000001490116,
        heightFogMode = 1,
        heightFogCutoff = 9.99999974737875E-6,
        heightFogStart = 0,
        heightFogEnd = 500,
        scatteringDensity = 1,
        scatteringFalloff = 1,
        scatteringExponent = 2,
        heightFogMinOpacity = 0.100000001490116,
        radiusFogFactor = 1,
        nearFogColor = {
          0.294117659330368,
          0.423529446125031,
          0.69803923368454,
          1
        },
        nearFogDistance = 10,
        farFogColor = {
          0.337486654520035,
          0.766296982765198,
          0.905660390853882,
          1
        },
        farFogDistance = 50,
        enableLocalHeightFog = 1,
        localHeightFogStart = -60,
        localHeightFogEnd = -20,
        localHeightFogColor = {
          0.584313750267029,
          0.800000071525574,
          0.960784375667572,
          0
        }
      }
    }
  },
  flare = {flareFadeSpeed = 1, flareStrength = 0.495999991893768},
  customskybox = {
    texPath = "Enviroment/CustomSkyboxes/sky_pldl_002_d",
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
return Enviroment_167
