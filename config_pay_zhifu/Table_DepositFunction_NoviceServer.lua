Table_DepositFunction = {
  [1] = {
    id = 1,
    Desc = "使用期间，每日战斗次数耗尽前，野外普通魔物的掉率和经验提升%d%%",
    Argument = {
      type = "add",
      param = {33}
    },
    DescArgument = {33}
  },
  [2] = {
    id = 2,
    Desc = "使用期间，战斗获得的Base经验提高%d%%",
    Argument = {
      type = "multiply",
      param = {105}
    },
    DescArgument = {5}
  },
  [3] = {
    id = 3,
    Desc = "使用期间，战斗获得的Job经验提高%d%%",
    Argument = {
      type = "multiply",
      param = {105}
    },
    DescArgument = {5}
  },
  [6] = {
    id = 6,
    Desc = "使用期间，追赶加速中的多职业Job加速效果额外增加%d%%（共%d%%）",
    Argument = _EmptyTable,
    DescArgument = {
      "DiffJobSpeedUp"
    }
  },
  [7] = {
    id = 7,
    Desc = "使用期间，荣誉之证获取量提高%d%%",
    Argument = {
      type = "multiply",
      param = {110}
    },
    DescArgument = {10}
  },
  [8] = {
    id = 8,
    Desc = "使用后，立即获得本月专属头饰[u]%s[/u]",
    Argument = _EmptyTable,
    DescArgument = {"HeadDress"}
  },
  [9] = {
    id = 9,
    Desc = "使用期间，自动战斗技能栏+1",
    Argument = _EmptyTable,
    DescArgument = _EmptyTable
  },
  [10] = {
    id = 10,
    Desc = "使用期间，包包格子+30",
    Argument = _EmptyTable,
    DescArgument = _EmptyTable
  },
  [12] = {
    id = 12,
    Desc = "使用期间，宠物同时可进行的打工场所上限+1",
    Argument = {
      type = "add",
      param = {1}
    },
    DescArgument = _EmptyTable
  },
  [13] = {
    id = 13,
    Desc = "使用期间，新增“卡普拉公司”的宠物打工场所",
    Argument = _EmptyTable,
    DescArgument = _EmptyTable
  },
  [14] = {
    id = 14,
    Desc = "使用期间，当宠物赠送给自己礼物时，获得双份",
    Argument = _EmptyTable,
    DescArgument = _EmptyTable
  },
  [15] = {
    id = 15,
    Desc = "使用期间，通用仓库取出道具没有等级限制",
    Argument = _EmptyTable,
    DescArgument = _EmptyTable
  },
  [16] = {
    id = 16,
    Desc = "使用期间，每日从料理商人处免费吃一份B级料理，还可半价购买一份",
    Argument = _EmptyTable,
    DescArgument = _EmptyTable
  },
  [17] = {
    id = 17,
    Desc = "使用期间，卡普拉公司的传送可以送你去更多地方",
    Argument = _EmptyTable,
    DescArgument = _EmptyTable
  },
  [18] = {
    id = 18,
    Desc = "使用期间，MVP界面增加了mini信息",
    Argument = _EmptyTable,
    DescArgument = _EmptyTable
  },
  [19] = {
    id = 19,
    Desc = "使用期间，伊米尔的记事簿存档栏+1",
    Argument = _EmptyTable,
    DescArgument = _EmptyTable
  },
  [20] = {
    id = 20,
    Desc = "限定特典不可在交易所进行交易",
    Argument = _EmptyTable,
    DescArgument = _EmptyTable
  },
  [22] = {
    id = 22,
    Desc = "使用期间，解锁交易所预购功能",
    Argument = _EmptyTable,
    DescArgument = _EmptyTable
  },
  [23] = {
    id = 23,
    Desc = "以上特权有效期为31天，使用多张月卡将延长特权天数",
    Argument = _EmptyTable,
    DescArgument = _EmptyTable
  },
  [24] = {
    id = 24,
    Desc = "[c][0541b0]「外观特权」[-][/c]",
    Argument = _EmptyTable,
    DescArgument = {"Title"}
  },
  [26] = {
    id = 26,
    Desc = "\n[c][0541b0]「便利特权」[-][/c]",
    Argument = _EmptyTable,
    DescArgument = {"Title"}
  },
  [27] = {
    id = 27,
    Desc = "\n[c][0541b0]「成长特权」[-][/c]",
    Argument = _EmptyTable,
    DescArgument = {"Title"}
  },
  [28] = {
    id = 28,
    Desc = "使用期间，完成日常、周常可领取特权奖励",
    Argument = _EmptyTable,
    DescArgument = _EmptyTable
  },
  [29] = {
    id = 29,
    Desc = "\n[c][0541b0]「更多特权」[-][/c]",
    Argument = _EmptyTable,
    DescArgument = {"Title"}
  },
  [30] = {
    id = 30,
    Desc = "\n[c][0541b0]「特殊说明」[-][/c]",
    Argument = _EmptyTable,
    DescArgument = {"Title"}
  },
  [31] = {
    id = 31,
    Desc = "使用期间，更换/拆卸卡片免费",
    Argument = _EmptyTable,
    DescArgument = _EmptyTable
  },
  [32] = {
    id = 32,
    Desc = "使用期间，玩法时长耗尽前，通关裂隙副本获取经验速度增加%d%%",
    Argument = {
      type = "add",
      param = {33}
    },
    DescArgument = {33}
  }
}
Table_DepositFunction_fields = {
  "id",
  "Desc",
  "Argument",
  "DescArgument"
}
return Table_DepositFunction
