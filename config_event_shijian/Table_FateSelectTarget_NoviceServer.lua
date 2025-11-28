Table_FateSelectTarget = {
  [1001] = {
    id = 1001,
    ActID = 106001,
    Type = 3,
    TargetType = "finish_servant_daily",
    TargetNum = 3,
    Param = _EmptyTable,
    RewardCount = 1,
    Description = "[c][d57401]【每日】[-][/c][c][6c6c6c]完成任意3个日常任务[-][/c]",
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
    Description = "[c][d57401]【每日】[-][/c][c][6c6c6c]击败任意300个魔物[-][/c]",
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
    Description = "[c][d57401]【每周】[-][/c][c][6c6c6c]获得执事荣誉勋章x1000[-][/c]",
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
    Description = "[c][d57401]【每周】[-][/c][c][6c6c6c]通关任意难度神谕副本[-][/c]",
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
    Description = "[c][d57401]【每周】[-][/c][c][6c6c6c]通关任意难度蛋糕保卫战[-][/c]",
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
    Description = "[c][d57401]【每周】[-][/c][c][6c6c6c]通关任意难度混沌入侵[-][/c]",
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
    Description = "[c][d57401]【挑战】[-][/c][c][6c6c6c]累积登录7天[-][/c]",
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
    Description = "[c][d57401]【挑战】[-][/c][c][6c6c6c]累积登录15天[-][/c]",
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
    Description = "[c][d57401]【挑战】[-][/c][c][6c6c6c]累积登录30天[-][/c]",
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
    Description = "[c][d57401]【挑战】[-][/c][c][6c6c6c]通关恩德勒斯塔30层[-][/c]",
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
    Description = "[c][d57401]【挑战】[-][/c][c][6c6c6c]通关恩德勒斯塔50层[-][/c]",
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
    Description = "[c][d57401]【挑战】[-][/c][c][6c6c6c]通关恩德勒斯塔70层[-][/c]",
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
    Description = "[c][d57401]【挑战】[-][/c][c][6c6c6c]通关恩德勒斯塔90层[-][/c]",
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
    Description = "[c][d57401]【挑战】[-][/c][c][6c6c6c]通关恩德勒斯塔100层[-][/c]",
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
