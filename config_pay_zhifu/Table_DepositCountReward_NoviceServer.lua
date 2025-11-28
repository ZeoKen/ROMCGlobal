Table_DepositCountReward = {
  [1] = {
    id = 1,
    DepositID = 7,
    AccLimit = 1,
    Count = 1,
    Mail = 100288,
    RewardItems = {
      {itemid = 6730, count = 1}
    },
    Des = "本次购买特典额外获赠：离线战斗资格证",
    TF_Open = 1,
    Release_Open = 1,
    Des2 = ""
  },
  [2] = {
    id = 2,
    DepositID = 299,
    AccLimit = 1,
    Count = 1,
    Mail = 12550,
    RewardItems = {
      {itemid = 6730, count = 1},
      {itemid = 151, count = 30}
    },
    Des = "本次购买特典额外获赠：离线战斗资格证",
    TF_Open = 1,
    Release_Open = 1,
    Des2 = "首次购买，6折优惠，再返{itemicon=151}x30"
  }
}
Table_DepositCountReward_fields = {
  "id",
  "DepositID",
  "AccLimit",
  "Count",
  "Mail",
  "RewardItems",
  "Des",
  "TF_Open",
  "Release_Open",
  "Des2"
}
return Table_DepositCountReward
