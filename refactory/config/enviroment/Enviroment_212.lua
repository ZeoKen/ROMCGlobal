local Enviroment_212 = {
  global = {
    sunDir = {
      0,
      0,
      1,
      0
    },
    sunColor = {
      1,
      1,
      1,
      1
    }
  },
  fog = {
    fog = true,
    fogColor = {
      0.547169804573059,
      0.345852613449097,
      0.345852613449097,
      1
    },
    fogMode = 1,
    fogStartDistance = 0,
    fogEndDistance = 120,
    globalFogTuner = 0,
    heightFogMode = 0,
    radiusFogFactor = 1,
    nearFogColor = {
      0.243137270212173,
      0.592156887054443,
      0.831372618675232,
      1
    },
    nearFogDistance = 100,
    farFogColor = {
      0.547169804573059,
      0.345852613449097,
      0.345852613449097,
      1
    },
    farFogDistance = 50,
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
  flare = {flareFadeSpeed = 1, flareStrength = 0},
  customskybox = {
    texPath = "Enviroment/CustomSkyboxes/sky_othello_night",
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
    applyFog = false
  },
  bloom = {
    index = 1,
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
return Enviroment_212
