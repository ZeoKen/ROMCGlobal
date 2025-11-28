local Enviroment_201 = {
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
      0.448282420635223,
      0.359736561775208,
      0.811320781707764,
      1
    },
    fogMode = 1,
    fogStartDistance = 5,
    fogEndDistance = 80,
    globalFogTuner = 0,
    heightFogMode = 1,
    heightFogCutoff = 9.99999974737875E-6,
    heightFogStart = 0,
    heightFogEnd = 200,
    scatteringDensity = 1.60000002384186,
    scatteringFalloff = 4,
    scatteringExponent = 3,
    heightFogMinOpacity = 0,
    radiusFogFactor = 1,
    nearFogColor = {
      0.194375216960907,
      0.294119536876678,
      0.528301894664764,
      1
    },
    nearFogDistance = 60,
    farFogColor = {
      0.448282420635223,
      0.359736561775208,
      0.811320781707764,
      1
    },
    farFogDistance = 160,
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
  flare = {flareFadeSpeed = 1, flareStrength = 0.495999991893768},
  customskybox = {
    texPath = "Enviroment/CustomSkyboxes/sky_prt_hunt1_d",
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
return Enviroment_201
