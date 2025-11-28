Table_FateSelectTarget = {
  [1001] = {
    id = 1001,
    ActID = 106001,
    Type = 3,
    TargetType = "finish_servant_daily",
    TargetNum = 3,
    Param = _EmptyTable,
    RewardCount = 1,
    Description = "##3462129",
    Goto = _EmptyTable
  },
  [1002] = {
    id = 1002,
    ActID = 106001,
    Type = 3,
    TargetType = "kill_monster",
    TargetNum = 300,
    Param = _EmptyTable,
    RewardCount = 1,
    Description = "##3462130",
    Goto = _EmptyTable
  },
  [1003] = {
    id = 1003,
    ActID = 106001,
    Type = 4,
    TargetType = "get_servant_coin",
    TargetNum = 1000,
    Param = _EmptyTable,
    RewardCount = 5,
    Description = "##3462131",
    Goto = _EmptyTable
  },
  [1004] = {
    id = 1004,
    ActID = 106001,
    Type = 4,
    TargetType = "finish_raid",
    TargetNum = 1,
    Param = {raid_type = 28},
    RewardCount = 3,
    Description = "##3462132",
    Goto = {8194}
  },
  [1005] = {
    id = 1005,
    ActID = 106001,
    Type = 4,
    TargetType = "finish_raid",
    TargetNum = 1,
    Param = {raid_type = 43},
    RewardCount = 3,
    Description = "##3462133",
    Goto = {8192}
  },
  [1006] = {
    id = 1006,
    ActID = 106001,
    Type = 4,
    TargetType = "finish_raid",
    TargetNum = 1,
    Param = {raid_type = 68},
    RewardCount = 3,
    Description = "##3462134",
    Goto = {8254}
  },
  [1007] = {
    id = 1007,
    ActID = 106001,
    Type = 0,
    TargetType = "login",
    TargetNum = 7,
    Param = _EmptyTable,
    RewardCount = 5,
    Description = "##3501008",
    Goto = _EmptyTable
  },
  [1008] = {
    id = 1008,
    ActID = 106001,
    Type = 0,
    TargetType = "login",
    TargetNum = 15,
    Param = _EmptyTable,
    RewardCount = 10,
    Description = "##3462136",
    Goto = _EmptyTable
  },
  [1009] = {
    id = 1009,
    ActID = 106001,
    Type = 0,
    TargetType = "login",
    TargetNum = 30,
    Param = _EmptyTable,
    RewardCount = 10,
    Description = "##3462137",
    Goto = _EmptyTable
  },
  [1010] = {
    id = 1010,
    ActID = 106001,
    Type = 0,
    TargetType = "finish_raid",
    TargetNum = 1,
    Param = {raid_type = 4, min_difficulty = 30},
    RewardCount = 2,
    Description = "##3462138",
    Goto = {8193}
  },
  [1011] = {
    id = 1011,
    ActID = 106001,
    Type = 0,
    TargetType = "finish_raid",
    TargetNum = 1,
    Param = {raid_type = 4, min_difficulty = 50},
    RewardCount = 3,
    Description = "##3462139",
    Goto = {8193}
  },
  [1012] = {
    id = 1012,
    ActID = 106001,
    Type = 0,
    TargetType = "finish_raid",
    TargetNum = 1,
    Param = {raid_type = 4, min_difficulty = 70},
    RewardCount = 5,
    Description = "##3462140",
    Goto = {8193}
  },
  [1013] = {
    id = 1013,
    ActID = 106001,
    Type = 0,
    TargetType = "finish_raid",
    TargetNum = 1,
    Param = {raid_type = 4, min_difficulty = 90},
    RewardCount = 10,
    Description = "##3462141",
    Goto = {8193}
  },
  [1014] = {
    id = 1014,
    ActID = 106001,
    Type = 0,
    TargetType = "finish_raid",
    TargetNum = 1,
    Param = {raid_type = 4, min_difficulty = 100},
    RewardCount = 10,
    Description = "##3462142",
    Goto = {8193}
  }
}
Table_FateSelectTarget_fields = {
  "id",
  "ActID",
  "Type",
  "TargetType",
  "TargetNum",
  "Param",
  "RewardCount",
  "Description",
  "Goto"
}
return Table_FateSelectTarget
