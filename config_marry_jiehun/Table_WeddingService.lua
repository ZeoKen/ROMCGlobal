Table_WeddingService = {
  [101] = {
    id = 101,
    Type = 1,
    Desc = "##139583",
    Background = "",
    Price = {
      {id = 100, num = 0}
    },
    Service = _EmptyTable,
    Effect = _EmptyTable,
    SuccessEffect = _EmptyTable
  },
  [102] = {
    id = 102,
    Type = 1,
    Desc = "##139579",
    Background = "",
    Price = {
      {id = 100, num = 6400000}
    },
    Service = _EmptyTable,
    Effect = _EmptyTable,
    SuccessEffect = {
      {
        type = "scene_effect",
        pos = {
          63,
          14,
          63
        },
        effect = "Common/Sakura_Show",
        cleartime = 3600,
        map = 1
      },
      {
        type = "scene_effect",
        pos = {
          0,
          3,
          -3
        },
        effect = "Common/Sakura_Show",
        cleartime = 3600,
        map = 10008
      }
    }
  },
  [103] = {
    id = 103,
    Type = 1,
    Desc = "##139588",
    Background = "",
    Price = {
      {id = 100, num = 6400000}
    },
    Service = _EmptyTable,
    Effect = _EmptyTable,
    SuccessEffect = _EmptyTable
  },
  [104] = {
    id = 104,
    Type = 1,
    Desc = "##139584",
    Background = "",
    Price = {
      {id = 100, num = 26000000}
    },
    Service = _EmptyTable,
    Effect = {
      {
        type = "rangeweather",
        pos = {
          63,
          14,
          63
        },
        weather = 6,
        cleartime = 3600,
        map = 1,
        range = 20
      },
      {
        type = "rangeweather",
        pos = {
          0,
          30,
          -3
        },
        weather = 6,
        cleartime = 3600,
        map = 10008,
        range = 20
      }
    },
    SuccessEffect = _EmptyTable
  },
  [105] = {
    id = 105,
    Type = 1,
    Desc = "##139585",
    Background = "",
    Price = {
      {id = 100, num = 26000000}
    },
    Service = _EmptyTable,
    Effect = {
      {
        type = "rangebgm",
        pos = {
          0,
          3,
          -3
        },
        bgm = "RO2.0_EternalLove",
        cleartime = 3600,
        map = 10008,
        range = 30
      },
      {
        type = "rangebgm",
        pos = {
          18,
          3,
          -5
        },
        bgm = "RO2.0_EternalLove",
        cleartime = 3600,
        map = 1,
        range = 30
      }
    },
    SuccessEffect = _EmptyTable
  },
  [6076] = {
    id = 6076,
    Type = 2,
    Desc = "",
    Background = "marry_pic_1",
    Price = _EmptyTable,
    Service = {101},
    Effect = _EmptyTable,
    SuccessEffect = _EmptyTable
  },
  [6077] = {
    id = 6077,
    Type = 2,
    Desc = "",
    Background = "marry_pic_2",
    Price = _EmptyTable,
    Service = {
      101,
      102,
      103
    },
    Effect = _EmptyTable,
    SuccessEffect = _EmptyTable
  },
  [6078] = {
    id = 6078,
    Type = 2,
    Desc = "",
    Background = "marry_pic_3",
    Price = _EmptyTable,
    Service = {
      101,
      102,
      103,
      104,
      105
    },
    Effect = _EmptyTable,
    SuccessEffect = _EmptyTable
  }
}
Table_WeddingService_fields = {
  "id",
  "Type",
  "Desc",
  "Background",
  "Price",
  "Service",
  "Effect",
  "SuccessEffect"
}
return Table_WeddingService
