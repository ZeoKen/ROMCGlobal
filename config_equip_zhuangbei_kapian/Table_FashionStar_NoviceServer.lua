Table_FashionStar = {
  [1] = {
    id = 1,
    BatchId = 1,
    Param = {
      ClientItemId = 3042139,
      FashionId = {
        [1] = 3013690,
        [2] = 3013691
      },
      HeadEquipId = {
        [1] = 3013693,
        [2] = 3013694
      }
    },
    ItemCost = _EmptyTable,
    Star = 1,
    Desc = "基础外观",
    Deposit = 400034
  },
  [2] = {
    id = 2,
    BatchId = 1,
    Param = {
      ClientItemId = 3042138,
      NextStarItem = {3042167, 3042168},
      Body = {
        Male = {
          {
            3042140,
            "F0F0F0",
            3042146
          },
          {
            3042141,
            "C46228",
            3042147
          },
          {
            3042142,
            "194D7D",
            3042148
          }
        },
        Female = {
          {
            3042143,
            "404040",
            3042149
          },
          {
            3042144,
            "C46228",
            3042150
          },
          {
            3042145,
            "194D7D",
            3042151
          }
        }
      }
    },
    ItemCost = {
      {3042170, 1}
    },
    Star = 2,
    Desc = "额外配色"
  },
  [3] = {
    id = 3,
    BatchId = 1,
    Param = {
      ClientItemId = 3042138,
      NextStarItem = {
        497,
        498,
        499
      },
      UserPortraitFrame = 1084,
      UserChatFrame = 30,
      UserBackground = 1063
    },
    ItemCost = {
      {3042170, 1},
      {3042169, 1}
    },
    Star = 3,
    Desc = "限定头像框"
  },
  [4] = {
    id = 4,
    BatchId = 1,
    Param = {
      ClientItemId = 3042138,
      NextStarItem = {3042152, 3042153},
      FashionId = {
        [1] = 3042152,
        [2] = 3042153
      },
      HeadEquipId = {
        [1] = 3013693,
        [2] = 3013694
      }
    },
    ItemCost = {
      {3042170, 1},
      {3042169, 2}
    },
    Star = 4,
    Desc = "进阶外观"
  },
  [5] = {
    id = 5,
    BatchId = 1,
    Param = {
      ClientItemId = 3042138,
      NextStarItem = {3042164, 3042165},
      FashionId = {
        [1] = 3042152,
        [2] = 3042153
      },
      HeadEquipId = {
        [1] = 3013693,
        [2] = 3013694
      },
      Video = "waiguanshengxing_jibainew.mp4"
    },
    ItemCost = {
      {3042170, 1},
      {3042169, 5}
    },
    Star = 5,
    Desc = "击败特效\n炫彩称号"
  },
  [6] = {
    id = 6,
    BatchId = 1,
    Param = {
      ClientItemId = 3042138,
      NextStarItem = {3042166},
      FashionId = {
        [1] = 3042152,
        [2] = 3042153
      },
      HeadEquipId = {
        [1] = 3013693,
        [2] = 3013694
      },
      Video = "waiguanshengxing_trail.mp4"
    },
    ItemCost = {
      {3042170, 1},
      {3042169, 7}
    },
    Star = 6,
    Desc = "行走特效"
  },
  [7] = {
    id = 7,
    BatchId = 1,
    Param = {
      NextStarItem = {3042215, 3042216},
      FashionId = {
        [1] = 3042215,
        [2] = 3042216
      },
      HeadEquipId = {
        [1] = 3013693,
        [2] = 3013694
      },
      Video = {
        [1] = {
          "waiguanshengxing_action.mp4"
        },
        [2] = {
          "waiguanshengxing_action.mp4"
        }
      }
    },
    ItemCost = {
      {3042170, 1},
      {3042169, 10}
    },
    Star = 7,
    Desc = "穿戴特效\n专属特效动作"
  }
}
Table_FashionStar_fields = {
  "id",
  "BatchId",
  "Param",
  "ItemCost",
  "Star",
  "Desc",
  "Deposit"
}
return Table_FashionStar
