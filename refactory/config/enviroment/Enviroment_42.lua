local Enviroment_42 = {
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
      0.125540658831596,
      0.261456906795502,
      0.316176474094391,
      0
    },
    fogMode = 1,
    fogStartDistance = 20,
    fogEndDistance = 80
  },
  flare = {flareFadeSpeed = 1, flareStrength = 0},
  skybox = {
    type = 3,
    atmoshpereThickness = 0.5,
    skyTint = {
      0.102941155433655,
      0.331845670938492,
      1,
      0
    },
    ground = {
      0,
      0.116632878780365,
      0.676470577716827,
      0
    },
    exposure = 0.25,
    cubemap = "Enviroment/skystars/new_sky_2",
    cubemapAlpha = "Enviroment/skystars/new_sky_2_a",
    cubemapRotation = 319,
    cubemapTint = {
      0.816531419754028,
      0.801470577716827,
      1,
      1
    }
  },
  bloom = {index = 1}
}
return Enviroment_42
