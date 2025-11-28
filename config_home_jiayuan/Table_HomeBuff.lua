Table_HomeBuff = {
  [1] = {
    id = 1,
    Score = 100,
    Func = {RestoreSpdPer = 0.05},
    Buff = 6201,
    Desc = "##123172"
  },
  [2] = {
    id = 2,
    Score = 200,
    Func = {RestoreSpdPer = 0.05, SpRestoreSpdPer = 0.05},
    Buff = 6201,
    Desc = "##123169"
  },
  [3] = {
    id = 3,
    Score = 300,
    Func = {
      RestoreSpdPer = 0.05,
      SpRestoreSpdPer = 0.05,
      user_baseexp = {500}
    },
    Buff = 6201,
    Desc = "##123166"
  },
  [4] = {
    id = 4,
    Score = 400,
    Func = {
      RestoreSpdPer = 0.05,
      SpRestoreSpdPer = 0.05,
      user_baseexp = {500},
      user_jobexp = {500}
    },
    Buff = 6201,
    Desc = "##123165"
  },
  [5] = {
    id = 5,
    Score = 500,
    Func = {
      RestoreSpdPer = 0.05,
      SpRestoreSpdPer = 0.05,
      user_baseexp = {500},
      user_jobexp = {500},
      pet_houseexp = {1000}
    },
    Buff = 6201,
    Desc = "##123173"
  },
  [6] = {
    id = 6,
    Score = 600,
    Func = {
      RestoreSpdPer = 0.05,
      SpRestoreSpdPer = 0.05,
      user_baseexp = {500},
      user_jobexp = {500},
      pet_houseexp = {1000},
      pet_housefriendexp = {1000}
    },
    Buff = 6201,
    Desc = "##123171"
  },
  [7] = {
    id = 7,
    Score = 700,
    Func = {
      RestoreSpdPer = 0.05,
      SpRestoreSpdPer = 0.05,
      user_baseexp = {500},
      user_jobexp = {500},
      pet_houseexp = {1000},
      pet_housefriendexp = {1000},
      pet_workspace = {1}
    },
    Buff = 6201,
    Desc = "##123168"
  },
  [8] = {
    id = 8,
    Score = 800,
    Func = {
      RestoreSpdPer = 0.05,
      SpRestoreSpdPer = 0.05,
      user_baseexp = {500},
      user_jobexp = {500},
      pet_houseexp = {1000},
      pet_housefriendexp = {1000},
      pet_workspace = {1},
      pack_slot = {20}
    },
    Buff = 6201,
    Desc = "##123167"
  },
  [9] = {
    id = 9,
    Score = 900,
    Func = {
      RestoreSpdPer = 0.05,
      SpRestoreSpdPer = 0.05,
      user_baseexp = {500},
      user_jobexp = {500},
      pet_houseexp = {1000},
      pet_housefriendexp = {1000},
      pet_workspace = {1},
      pack_slot = {20},
      map_reward = {300},
      refinereduce = {9500}
    },
    Buff = 6201,
    Desc = "##3462247"
  },
  [10] = {
    id = 10,
    Score = 1000,
    Func = {
      RestoreSpdPer = 0.05,
      SpRestoreSpdPer = 0.05,
      user_baseexp = {500},
      user_jobexp = {500},
      pet_houseexp = {1000},
      pet_housefriendexp = {1000},
      pet_workspace = {1},
      pack_slot = {20},
      map_reward = {300},
      Str = 3,
      Vit = 3,
      Dex = 3,
      Agi = 3,
      Int = 3,
      Luk = 3,
      enchantreduce = {9000},
      refinereduce = {9500}
    },
    Buff = 6201,
    Desc = "##3462248"
  }
}
Table_HomeBuff_fields = {
  "id",
  "Score",
  "Func",
  "Buff",
  "Desc"
}
return Table_HomeBuff
