Table_Pet_WorkSpace = {
  [1] = {
    id = 1,
    Name = "烹饪中心",
    Gate = "Cookroom",
    UnlockMenu = {
      type = "menu",
      params = {1908}
    },
    Level = 70,
    Frequency = 30,
    Max_reward = 95,
    Reward = {3649},
    Work_limit = _EmptyTable,
    PlayTimeRewardRatio = {600, 150},
    Desc = "可烹饪宠物都喜欢的冒险丸子哟~",
    Reward_desc = _EmptyTable
  },
  [2] = {
    id = 2,
    Name = "道具店",
    Gate = "Shoproom",
    UnlockMenu = _EmptyTable,
    Level = 45,
    Frequency = 50,
    Max_reward = 55,
    Reward = {3659},
    Work_limit = _EmptyTable,
    PlayTimeRewardRatio = {600, 30},
    Desc = "有望获得老板娘赏赐的道具哦~",
    Reward_desc = {
      [3659] = "每次打工完成后可随机获得华丽金属、坠星陨铁、各类A级料理、各类B级料理、普通魔物素材及各类消耗品中的一种"
    }
  },
  [3] = {
    id = 3,
    Name = "卡普拉公司",
    Gate = "Capraroom",
    UnlockMenu = {
      type = "menu",
      params = {1902}
    },
    Level = 45,
    Frequency = 60,
    Max_reward = 60,
    Reward = {3669},
    Work_limit = _EmptyTable,
    PlayTimeRewardRatio = {600, 15},
    Desc = "卡普拉公司的礼物静待你拿取~",
    Reward_desc = {
      [3669] = "每次打工完成后可随机获得各类染料、神秘佣兵券、莫拉硬币、信仰之证、各类装备制作材料、各类饰品材料中的一种"
    }
  },
  [4] = {
    id = 4,
    Name = "宠物协会",
    Gate = "Petroom",
    UnlockMenu = {
      type = "menu",
      params = {1905}
    },
    Level = 50,
    Frequency = 60,
    Max_reward = 50,
    Reward = {3679},
    Work_limit = _EmptyTable,
    PlayTimeRewardRatio = {600, 30},
    Desc = "在这里打工会结交宠物朋友呢！",
    Reward_desc = {
      [3679] = "每次打工完成后可随机获得七彩贝壳或宠物经验药水中的一种"
    }
  },
  [5] = {
    id = 5,
    Name = "料理协会",
    Gate = "Foodroom",
    UnlockMenu = {
      type = "menu",
      params = {1906}
    },
    Level = 55,
    Frequency = 35,
    Max_reward = 60,
    Reward = {3689},
    Work_limit = _EmptyTable,
    PlayTimeRewardRatio = {600, 30},
    Desc = "想要吃热腾腾的饭菜要过来呀！",
    Reward_desc = {
      [3689] = "每次打工完成后可随机获得各类星级料理或各类料理食材中的一种"
    }
  },
  [6] = {
    id = 6,
    Name = "微笑小姐",
    Gate = "Missroom",
    UnlockMenu = {
      type = "menu",
      params = {9510}
    },
    Level = 55,
    Frequency = 25,
    Max_reward = 100,
    Reward = {3699},
    Work_limit = _EmptyTable,
    PlayTimeRewardRatio = {600, 150},
    Desc = "微笑小姐当然要送乐园币啦~",
    Reward_desc = _EmptyTable
  },
  [7] = {
    id = 7,
    Name = "公会",
    Gate = "Guildroom",
    UnlockMenu = {
      type = "menu",
      params = {1903}
    },
    Level = 60,
    Frequency = 45,
    Max_reward = 70,
    Reward = {3709},
    Work_limit = {
      500010,
      500110,
      500030
    },
    PlayTimeRewardRatio = {600, 50},
    Desc = "在公会里帮衬有助于团结哦~",
    Reward_desc = {
      [3709] = "每次打工完成后可随机获得贡献或荣誉之证中的一种"
    }
  },
  [8] = {
    id = 8,
    Name = "竞技场",
    Gate = "Arenaroom",
    UnlockMenu = {
      type = "menu",
      params = {1904}
    },
    Level = 70,
    Frequency = 35,
    Max_reward = 50,
    Reward = {3719},
    Work_limit = {500010, 500110},
    PlayTimeRewardRatio = {600, 50},
    Desc = "打工获得斗士的硬币，童叟无欺！",
    Reward_desc = _EmptyTable
  },
  [9] = {
    id = 9,
    Name = "宠物乐园",
    Gate = "Pet_paradise",
    UnlockMenu = _EmptyTable,
    Level = 50,
    Frequency = 3,
    Max_reward = 50,
    Reward = {3699},
    Work_limit = _EmptyTable,
    PlayTimeRewardRatio = {600, 50},
    Desc = "不占用打工上限的限时开放场所！",
    Reward_desc = _EmptyTable,
    ActID = 25
  }
}
Table_Pet_WorkSpace_fields = {
  "id",
  "Name",
  "Gate",
  "UnlockMenu",
  "Level",
  "Frequency",
  "Max_reward",
  "Reward",
  "Work_limit",
  "PlayTimeRewardRatio",
  "Desc",
  "Reward_desc",
  "ActID"
}
return Table_Pet_WorkSpace
