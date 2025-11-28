Table_ExchangeShop = {
  [1] = {
    id = 1,
    Name = "1转·等级礼包",
    Icon = "item_3981",
    Source = 1,
    Type = 1,
    ExchangeType = 1,
    ExchangeLimit = _EmptyTable,
    Cost = {151, 30},
    Item = {
      {3981, 1}
    },
    Desc = "职业1转升级礼包"
  },
  [2] = {
    id = 2,
    Name = "2转·等级礼包",
    Icon = "item_3982",
    Source = 1,
    Type = 2,
    ExchangeType = 1,
    ExchangeLimit = _EmptyTable,
    Cost = {151, 98},
    Item = {
      {3982, 1}
    },
    Desc = "职业2转升级礼包"
  },
  [3] = {
    id = 3,
    Name = "2转进阶·等级礼包",
    Icon = "item_3983",
    Source = 1,
    Type = 2,
    ExchangeType = 1,
    ExchangeLimit = _EmptyTable,
    Cost = {151, 168},
    Item = {
      {3983, 1}
    },
    Desc = "职业2转进阶升级礼包"
  },
  [4] = {
    id = 4,
    Name = "1转·Job等级礼包",
    Icon = "item_3984",
    Source = 1,
    Type = 2,
    ExchangeType = 1,
    ExchangeLimit = _EmptyTable,
    Cost = {151, 30},
    Item = {
      {3984, 1}
    },
    Desc = "多职业1转升级礼包"
  },
  [5] = {
    id = 5,
    Name = "2转·Job等级礼包",
    Icon = "item_3985",
    Source = 1,
    Type = 2,
    ExchangeType = 1,
    ExchangeLimit = _EmptyTable,
    Cost = {151, 98},
    Item = {
      {3985, 1}
    },
    Desc = "多职业2转升级礼包"
  },
  [6] = {
    id = 6,
    Name = "卡普拉订单·Ⅰ",
    Icon = "item_12625",
    Source = 1,
    Type = 3,
    ExchangeType = 1,
    ExchangeLimit = {150},
    Cost = {151, 38},
    Item = {
      {5261, 5},
      {140, 1000}
    },
    Desc = "此订单可兑换"
  },
  [7] = {
    id = 7,
    Name = "卡普拉订单·Ⅱ",
    Icon = "item_12626",
    Source = 1,
    Type = 3,
    ExchangeType = 1,
    ExchangeLimit = {255},
    Cost = {151, 68},
    Item = {
      {5261, 10},
      {140, 1500}
    },
    Desc = "此订单可兑换"
  },
  [8] = {
    id = 8,
    Name = "卡普拉订单·Ⅲ",
    Icon = "item_12627",
    Source = 1,
    Type = 3,
    ExchangeType = 1,
    ExchangeLimit = {465},
    Cost = {151, 128},
    Item = {
      {5261, 15},
      {140, 3000}
    },
    Desc = "此订单可兑换"
  },
  [9] = {
    id = 9,
    Name = "卡普拉订单",
    Icon = "item_12636",
    Source = 1,
    Type = 4,
    ExchangeType = 6,
    ExchangeLimit = {
      150,
      255,
      465
    },
    Cost = _EmptyTable,
    Item = _EmptyTable,
    Desc = "此订单可兑换"
  },
  [10] = {
    id = 10,
    Name = "初心订单",
    Icon = "item_12636",
    Source = 1,
    Type = 4,
    ExchangeType = 5,
    ExchangeLimit = {25},
    Cost = _EmptyTable,
    Item = _EmptyTable,
    Desc = "此订单可兑换"
  }
}
Table_ExchangeShop_fields = {
  "id",
  "Name",
  "Icon",
  "Source",
  "Type",
  "ExchangeType",
  "ExchangeLimit",
  "Cost",
  "Item",
  "Desc"
}
return Table_ExchangeShop
