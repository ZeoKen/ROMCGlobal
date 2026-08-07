Table_NpcAchieve_t = {
  Condition = {
    {
      group = 3,
      level = 2,
      type = "prestige"
    },
    {
      group = 3,
      level = 3,
      type = "prestige"
    },
    {
      group = 3,
      level = 4,
      type = "prestige"
    },
    {
      group = 3,
      level = 5,
      type = "prestige"
    },
    {
      group = 3,
      level = 6,
      type = "prestige"
    },
    {
      group = 3,
      level = 7,
      type = "prestige"
    },
    {
      group = 3,
      level = 8,
      type = "prestige"
    },
    {
      group = 3,
      level = 9,
      type = "prestige"
    }
  },
  Reward = {
    {
      {52120, 500}
    },
    {
      {52120, 1500}
    },
    {
      {52120, 3000}
    },
    {
      {52358, 2}
    },
    {
      {7300, 10}
    },
    {
      {3006025, 1}
    },
    {
      {52120, 1000}
    },
    {
      {52120, 2000}
    },
    {
      {52425, 50}
    },
    {
      {52425, 100}
    },
    {
      {52425, 200}
    },
    {
      {52425, 400}
    },
    {
      {52913, 2}
    },
    {
      {52913, 3}
    },
    {
      {52913, 5}
    },
    {
      {52912, 1}
    },
    {
      {52913, 10}
    },
    {
      {52170, 500}
    },
    {
      {52170, 1000}
    },
    {
      {52170, 2000}
    },
    {
      {52170, 3000}
    },
    {
      {52358, 3}
    },
    {
      {3720, 3}
    },
    {
      {3720, 6}
    },
    {
      {52170, 4000}
    },
    {
      {5797, 4}
    },
    {
      {5798, 4}
    },
    {
      {5797, 6}
    },
    {
      {5798, 6}
    },
    {
      {5798, 8}
    },
    {
      {52913, 4}
    },
    {
      {8368, 1}
    },
    {
      {8369, 1}
    },
    {
      {8370, 1}
    },
    {
      {8371, 1}
    },
    {
      {8372, 1}
    },
    {
      {8373, 1}
    },
    {
      {8374, 1}
    },
    {
      {8375, 1}
    },
    {
      {8376, 1}
    },
    {
      {8377, 1}
    },
    {
      {8378, 1}
    },
    {
      {8379, 1}
    },
    {
      {8380, 1}
    },
    {
      {8381, 1}
    },
    {
      {8382, 1}
    }
  }
}
Table_NpcAchieve = {
  [1] = {
    Param1 = 54550,
    TargetNum = 50,
    Title = "清剿堕龙Ⅰ",
    Desc = "累计清剿堕龙或堕龙祭司等魔物%s/50次",
    Reward = Table_NpcAchieve_t.Reward[1]
  },
  [2] = {
    id = 2,
    Param1 = 54550,
    TargetNum = 250,
    Title = "清剿堕龙Ⅱ",
    Desc = "累计清剿堕龙或堕龙祭司等魔物%s/250次",
    Reward = Table_NpcAchieve_t.Reward[2]
  },
  [3] = {
    id = 3,
    Condition = Table_NpcAchieve_t.Condition[1],
    Param1 = 54550,
    TargetNum = 500,
    Title = "清剿堕龙Ⅲ",
    Desc = "累计清剿堕龙或堕龙祭司等魔物%s/500次",
    Reward = Table_NpcAchieve_t.Reward[3]
  },
  [4] = {
    id = 4,
    Condition = Table_NpcAchieve_t.Condition[2],
    Param1 = 54550,
    TargetNum = 1500,
    Title = "清剿堕龙Ⅳ",
    Desc = "累计清剿堕龙或堕龙祭司等魔物%s/1500次",
    Reward = Table_NpcAchieve_t.Reward[4]
  },
  [5] = {
    id = 5,
    Condition = Table_NpcAchieve_t.Condition[3],
    Param1 = 54550,
    TargetNum = 2500,
    Title = "清剿堕龙Ⅴ",
    Desc = "累计清剿堕龙或堕龙祭司等魔物%s/2500次",
    Reward = Table_NpcAchieve_t.Reward[4]
  },
  [6] = {
    id = 6,
    Condition = Table_NpcAchieve_t.Condition[4],
    Param1 = 54550,
    TargetNum = 3500,
    Title = "清剿堕龙Ⅵ",
    Desc = "累计清剿堕龙或堕龙祭司等魔物%s/3500次",
    Reward = Table_NpcAchieve_t.Reward[5]
  },
  [7] = {
    id = 7,
    Condition = Table_NpcAchieve_t.Condition[5],
    Param1 = 54550,
    TargetNum = 5000,
    Title = "清剿堕龙Ⅶ",
    Desc = "累计清剿堕龙或堕龙祭司等魔物%s/5000次",
    Reward = Table_NpcAchieve_t.Reward[6]
  },
  [8] = {
    id = 8,
    Param1 = 54557,
    TargetNum = 25,
    Title = "歼灭时空垃圾Ⅰ",
    Desc = "累计击杀时空束缚者或扰乱者%s/25次",
    Reward = Table_NpcAchieve_t.Reward[1]
  },
  [9] = {
    id = 9,
    Param1 = 54557,
    TargetNum = 50,
    Title = "歼灭时空垃圾Ⅱ",
    Desc = "累计击杀时空束缚者或扰乱者%s/50次",
    Reward = Table_NpcAchieve_t.Reward[7]
  },
  [10] = {
    id = 10,
    Condition = Table_NpcAchieve_t.Condition[1],
    Param1 = 54557,
    TargetNum = 150,
    Title = "歼灭时空垃圾Ⅲ",
    Desc = "累计击杀时空束缚者或扰乱者%s/150次",
    Reward = Table_NpcAchieve_t.Reward[8]
  },
  [11] = {
    id = 11,
    Condition = Table_NpcAchieve_t.Condition[2],
    Param1 = 54557,
    TargetNum = 250,
    Title = "歼灭时空垃圾Ⅳ",
    Desc = "累计击杀时空束缚者或扰乱者%s/250次",
    Reward = Table_NpcAchieve_t.Reward[3]
  },
  [12] = {
    id = 12,
    Condition = Table_NpcAchieve_t.Condition[3],
    Param1 = 54557,
    TargetNum = 400,
    Title = "歼灭时空垃圾Ⅴ",
    Desc = "累计击杀时空束缚者或扰乱者%s/400次",
    Reward = Table_NpcAchieve_t.Reward[4]
  },
  [13] = {
    id = 13,
    Condition = Table_NpcAchieve_t.Condition[4],
    Param1 = 54557,
    TargetNum = 600,
    Title = "歼灭时空垃圾Ⅵ",
    Desc = "累计击杀时空束缚者或扰乱者%s/600次",
    Reward = Table_NpcAchieve_t.Reward[4]
  },
  [14] = {
    id = 14,
    Condition = Table_NpcAchieve_t.Condition[5],
    Param1 = 54557,
    TargetNum = 800,
    Title = "歼灭时空垃圾Ⅶ",
    Desc = "累计击杀时空束缚者或扰乱者%s/800次",
    Reward = Table_NpcAchieve_t.Reward[5]
  },
  [15] = {
    id = 15,
    Condition = Table_NpcAchieve_t.Condition[6],
    Param1 = 54557,
    TargetNum = 1000,
    Title = "歼灭时空垃圾Ⅷ",
    Desc = "累计击杀时空束缚者或扰乱者%s/1000次",
    Reward = Table_NpcAchieve_t.Reward[6]
  },
  [16] = {
    id = 16,
    Param1 = 54555,
    TargetNum = 25,
    Title = "摧毁失控炮台Ⅰ",
    Reward = Table_NpcAchieve_t.Reward[9]
  },
  [17] = {
    id = 17,
    Param1 = 54555,
    TargetNum = 50,
    Title = "摧毁失控炮台Ⅱ",
    Desc = "累计摧毁失控炮台%s/50次",
    Reward = Table_NpcAchieve_t.Reward[10]
  },
  [18] = {
    id = 18,
    Condition = Table_NpcAchieve_t.Condition[1],
    Param1 = 54555,
    TargetNum = 150,
    Title = "摧毁失控炮台Ⅲ",
    Desc = "累计摧毁失控炮台%s/150次",
    Reward = Table_NpcAchieve_t.Reward[11]
  },
  [19] = {
    id = 19,
    Condition = Table_NpcAchieve_t.Condition[2],
    Param1 = 54555,
    TargetNum = 250,
    Title = "摧毁失控炮台Ⅳ",
    Desc = "累计摧毁失控炮台%s/250次",
    Reward = Table_NpcAchieve_t.Reward[12]
  },
  [20] = {
    id = 20,
    Condition = Table_NpcAchieve_t.Condition[3],
    Param1 = 54555,
    TargetNum = 400,
    Title = "摧毁失控炮台Ⅴ",
    Desc = "累计摧毁失控炮台%s/400次",
    Reward = Table_NpcAchieve_t.Reward[4]
  },
  [21] = {
    id = 21,
    Condition = Table_NpcAchieve_t.Condition[4],
    Param1 = 54555,
    TargetNum = 600,
    Title = "摧毁失控炮台Ⅵ",
    Desc = "累计摧毁失控炮台%s/600次",
    Reward = Table_NpcAchieve_t.Reward[4]
  },
  [22] = {
    id = 22,
    Condition = Table_NpcAchieve_t.Condition[5],
    Param1 = 54555,
    TargetNum = 800,
    Title = "摧毁失控炮台Ⅶ",
    Desc = "累计摧毁失控炮台%s/800次",
    Reward = Table_NpcAchieve_t.Reward[5]
  },
  [23] = {
    id = 23,
    Condition = Table_NpcAchieve_t.Condition[6],
    Param1 = 54555,
    TargetNum = 1000,
    Title = "摧毁失控炮台Ⅷ",
    Desc = "累计摧毁失控炮台%s/1000次",
    Reward = Table_NpcAchieve_t.Reward[6]
  },
  [24] = {
    id = 24,
    GroupID = 2,
    Type = 62,
    Param1 = 4,
    Title = "击败异界MiniⅠ",
    Desc = "累计获得异界Mini的击退奖励 %s/5次",
    Reward = Table_NpcAchieve_t.Reward[13]
  },
  [25] = {
    id = 25,
    GroupID = 2,
    Type = 62,
    Param1 = 4,
    TargetNum = 10,
    Title = "击败异界MiniⅡ",
    Desc = "累计获得异界Mini的击退奖励 %s/10次",
    Reward = Table_NpcAchieve_t.Reward[13]
  },
  [26] = {
    id = 26,
    GroupID = 2,
    Type = 62,
    Condition = Table_NpcAchieve_t.Condition[1],
    Param1 = 4,
    TargetNum = 15,
    Title = "击败异界MiniⅢ",
    Desc = "累计获得异界Mini的击退奖励 %s/15次",
    Reward = Table_NpcAchieve_t.Reward[13]
  },
  [27] = {
    id = 27,
    GroupID = 2,
    Type = 62,
    Condition = Table_NpcAchieve_t.Condition[2],
    Param1 = 4,
    TargetNum = 20,
    Title = "击败异界MiniⅣ",
    Desc = "累计获得异界Mini的击退奖励 %s/20次",
    Reward = Table_NpcAchieve_t.Reward[14]
  },
  [28] = {
    id = 28,
    GroupID = 2,
    Type = 62,
    Condition = Table_NpcAchieve_t.Condition[3],
    Param1 = 4,
    TargetNum = 30,
    Title = "击败异界MiniⅤ",
    Desc = "累计获得异界Mini的击退奖励 %s/30次",
    Reward = Table_NpcAchieve_t.Reward[14]
  },
  [29] = {
    id = 29,
    GroupID = 2,
    Type = 62,
    Condition = Table_NpcAchieve_t.Condition[4],
    Param1 = 4,
    TargetNum = 40,
    Title = "击败异界MiniⅥ",
    Desc = "累计获得异界Mini的击退奖励 %s/40次",
    Reward = Table_NpcAchieve_t.Reward[14]
  },
  [30] = {
    id = 30,
    GroupID = 2,
    Type = 62,
    Condition = Table_NpcAchieve_t.Condition[5],
    Param1 = 4,
    TargetNum = 50,
    Title = "击败异界MiniⅦ",
    Desc = "累计获得异界Mini的击退奖励 %s/50次",
    Reward = Table_NpcAchieve_t.Reward[15]
  },
  [31] = {
    id = 31,
    GroupID = 2,
    Type = 62,
    Condition = Table_NpcAchieve_t.Condition[6],
    Param1 = 4,
    TargetNum = 70,
    Title = "击败异界MiniⅧ",
    Desc = "累计获得异界Mini的击退奖励 %s/70次",
    Reward = Table_NpcAchieve_t.Reward[15]
  },
  [32] = {
    id = 32,
    GroupID = 2,
    Type = 62,
    Condition = Table_NpcAchieve_t.Condition[7],
    Param1 = 4,
    TargetNum = 100,
    Title = "击败异界MiniⅨ",
    Desc = "累计获得异界Mini的击退奖励 %s/100次",
    Reward = Table_NpcAchieve_t.Reward[16]
  },
  [33] = {
    id = 33,
    GroupID = 2,
    Type = 62,
    Param1 = 5,
    TargetNum = 1,
    Title = "击败异界MVPⅠ",
    Desc = "累计获得异界MVP的击退奖励 %s/1次",
    Reward = Table_NpcAchieve_t.Reward[14]
  },
  [34] = {
    id = 34,
    GroupID = 2,
    Type = 62,
    Param1 = 5,
    Title = "击败异界MVPⅡ",
    Desc = "累计获得异界MVP的击退奖励 %s/5次",
    Reward = Table_NpcAchieve_t.Reward[14]
  },
  [35] = {
    id = 35,
    GroupID = 2,
    Type = 62,
    Condition = Table_NpcAchieve_t.Condition[1],
    Param1 = 5,
    TargetNum = 10,
    Title = "击败异界MVPⅢ",
    Desc = "累计获得异界MVP的击退奖励 %s/10次",
    Reward = Table_NpcAchieve_t.Reward[14]
  },
  [36] = {
    id = 36,
    GroupID = 2,
    Type = 62,
    Condition = Table_NpcAchieve_t.Condition[2],
    Param1 = 5,
    TargetNum = 15,
    Title = "击败异界MVPⅣ",
    Desc = "累计获得异界MVP的击退奖励 %s/15次",
    Reward = Table_NpcAchieve_t.Reward[15]
  },
  [37] = {
    id = 37,
    GroupID = 2,
    Type = 62,
    Condition = Table_NpcAchieve_t.Condition[3],
    Param1 = 5,
    TargetNum = 20,
    Title = "击败异界MVPⅤ",
    Desc = "累计获得异界MVP的击退奖励 %s/20次",
    Reward = Table_NpcAchieve_t.Reward[15]
  },
  [38] = {
    id = 38,
    GroupID = 2,
    Type = 62,
    Condition = Table_NpcAchieve_t.Condition[4],
    Param1 = 5,
    TargetNum = 25,
    Title = "击败异界MVPⅥ",
    Desc = "累计获得异界MVP的击退奖励 %s/25次",
    Reward = Table_NpcAchieve_t.Reward[15]
  },
  [39] = {
    id = 39,
    GroupID = 2,
    Type = 62,
    Condition = Table_NpcAchieve_t.Condition[5],
    Param1 = 5,
    TargetNum = 30,
    Title = "击败异界MVPⅦ",
    Desc = "累计获得异界MVP的击退奖励 %s/30次",
    Reward = Table_NpcAchieve_t.Reward[17]
  },
  [40] = {
    id = 40,
    GroupID = 2,
    Type = 62,
    Condition = Table_NpcAchieve_t.Condition[6],
    Param1 = 5,
    TargetNum = 40,
    Title = "击败异界MVPⅧ",
    Desc = "累计获得异界MVP的击退奖励 %s/40次",
    Reward = Table_NpcAchieve_t.Reward[17]
  },
  [41] = {
    id = 41,
    GroupID = 2,
    Type = 62,
    Condition = Table_NpcAchieve_t.Condition[7],
    Param1 = 5,
    TargetNum = 50,
    Title = "击败异界MVPⅨ",
    Desc = "累计获得异界MVP的击退奖励 %s/50次",
    Reward = Table_NpcAchieve_t.Reward[16]
  },
  [42] = {
    id = 42,
    GroupID = 3,
    Param1 = 852257,
    Title = "采集堕龙蛋Ⅰ",
    Desc = "累计采集堕龙蛋%s/5次",
    Reward = Table_NpcAchieve_t.Reward[18]
  },
  [43] = {
    id = 43,
    GroupID = 3,
    Param1 = 852257,
    TargetNum = 15,
    Title = "采集堕龙蛋Ⅱ",
    Desc = "累计采集堕龙蛋%s/15次",
    Reward = Table_NpcAchieve_t.Reward[19]
  },
  [44] = {
    id = 44,
    GroupID = 3,
    Condition = Table_NpcAchieve_t.Condition[1],
    Param1 = 852257,
    TargetNum = 25,
    Title = "采集堕龙蛋Ⅲ",
    Desc = "累计采集堕龙蛋%s/25次",
    Reward = Table_NpcAchieve_t.Reward[20]
  },
  [45] = {
    id = 45,
    GroupID = 3,
    Condition = Table_NpcAchieve_t.Condition[2],
    Param1 = 852257,
    TargetNum = 50,
    Title = "采集堕龙蛋Ⅳ",
    Desc = "累计采集堕龙蛋%s/50次",
    Reward = Table_NpcAchieve_t.Reward[21]
  },
  [46] = {
    id = 46,
    GroupID = 3,
    Condition = Table_NpcAchieve_t.Condition[3],
    Param1 = 852257,
    TargetNum = 100,
    Title = "采集堕龙蛋Ⅴ",
    Desc = "累计采集堕龙蛋%s/100次",
    Reward = Table_NpcAchieve_t.Reward[22]
  },
  [47] = {
    id = 47,
    GroupID = 3,
    Condition = Table_NpcAchieve_t.Condition[4],
    Param1 = 852257,
    TargetNum = 150,
    Title = "采集堕龙蛋Ⅵ",
    Desc = "累计采集堕龙蛋%s/150次",
    Reward = Table_NpcAchieve_t.Reward[23]
  },
  [48] = {
    id = 48,
    GroupID = 3,
    Condition = Table_NpcAchieve_t.Condition[5],
    Param1 = 852257,
    TargetNum = 250,
    Title = "采集堕龙蛋Ⅶ",
    Desc = "累计采集堕龙蛋%s/250次",
    Reward = Table_NpcAchieve_t.Reward[24]
  },
  [49] = {
    id = 49,
    GroupID = 3,
    Param1 = 852260,
    TargetNum = 1,
    Title = "摧毁法器Ⅰ",
    Desc = "累计摧毁邪龙法器%s/1次",
    Reward = Table_NpcAchieve_t.Reward[19]
  },
  [50] = {
    id = 50,
    GroupID = 3,
    Param1 = 852260,
    Title = "摧毁法器Ⅱ",
    Desc = "累计摧毁邪龙法器%s/5次",
    Reward = Table_NpcAchieve_t.Reward[20]
  },
  [51] = {
    id = 51,
    GroupID = 3,
    Condition = Table_NpcAchieve_t.Condition[1],
    Param1 = 852260,
    TargetNum = 20,
    Title = "摧毁法器Ⅲ",
    Desc = "累计摧毁邪龙法器%s/20次",
    Reward = Table_NpcAchieve_t.Reward[25]
  },
  [52] = {
    id = 52,
    GroupID = 3,
    Condition = Table_NpcAchieve_t.Condition[2],
    Param1 = 852260,
    TargetNum = 40,
    Title = "摧毁法器Ⅳ",
    Desc = "累计摧毁邪龙法器%s/40次",
    Reward = Table_NpcAchieve_t.Reward[22]
  },
  [53] = {
    id = 53,
    GroupID = 3,
    Condition = Table_NpcAchieve_t.Condition[3],
    Param1 = 852260,
    TargetNum = 75,
    Title = "摧毁法器Ⅴ",
    Desc = "累计摧毁邪龙法器%s/75次",
    Reward = Table_NpcAchieve_t.Reward[23]
  },
  [54] = {
    id = 54,
    GroupID = 3,
    Condition = Table_NpcAchieve_t.Condition[4],
    Param1 = 852260,
    TargetNum = 100,
    Title = "摧毁法器Ⅵ",
    Desc = "累计摧毁邪龙法器%s/100次",
    Reward = Table_NpcAchieve_t.Reward[24]
  },
  [55] = {
    id = 55,
    GroupID = 3,
    Param1 = 852258,
    Title = "解救盟友Ⅰ",
    Desc = "累计解救被俘虏的士兵%s/5次",
    Reward = Table_NpcAchieve_t.Reward[10]
  },
  [56] = {
    id = 56,
    GroupID = 3,
    Param1 = 852258,
    TargetNum = 15,
    Title = "解救盟友Ⅱ",
    Desc = "累计解救被俘虏的士兵%s/15次",
    Reward = Table_NpcAchieve_t.Reward[11]
  },
  [57] = {
    id = 57,
    GroupID = 3,
    Param1 = 852258,
    TargetNum = 30,
    Title = "解救盟友Ⅲ",
    Desc = "累计解救被俘虏的士兵%s/30次",
    Reward = Table_NpcAchieve_t.Reward[12]
  },
  [58] = {
    id = 58,
    GroupID = 3,
    Condition = Table_NpcAchieve_t.Condition[1],
    Param1 = 852258,
    TargetNum = 50,
    Title = "解救盟友Ⅳ",
    Desc = "累计解救被俘虏的士兵%s/50次",
    Reward = Table_NpcAchieve_t.Reward[22]
  },
  [59] = {
    id = 59,
    GroupID = 3,
    Condition = Table_NpcAchieve_t.Condition[2],
    Param1 = 852258,
    TargetNum = 75,
    Title = "解救盟友Ⅴ",
    Desc = "累计解救被俘虏的士兵%s/75次",
    Reward = Table_NpcAchieve_t.Reward[23]
  },
  [60] = {
    id = 60,
    GroupID = 3,
    Condition = Table_NpcAchieve_t.Condition[3],
    Param1 = 852258,
    TargetNum = 100,
    Title = "解救盟友Ⅵ",
    Desc = "累计解救被俘虏的士兵%s/100次",
    Reward = Table_NpcAchieve_t.Reward[24]
  },
  [61] = {
    id = 61,
    GroupID = 4,
    Type = 52,
    Param1 = 154,
    Title = "清剿营地Ⅰ",
    Desc = "累计开启深渊之湖魔物营地的宝箱%s/5次",
    Reward = Table_NpcAchieve_t.Reward[26]
  },
  [62] = {
    id = 62,
    GroupID = 4,
    Type = 52,
    Param1 = 154,
    TargetNum = 15,
    Title = "清剿营地Ⅱ",
    Desc = "累计开启深渊之湖魔物营地的宝箱%s/15次",
    Reward = Table_NpcAchieve_t.Reward[26]
  },
  [63] = {
    id = 63,
    GroupID = 4,
    Type = 52,
    Condition = Table_NpcAchieve_t.Condition[1],
    Param1 = 154,
    TargetNum = 25,
    Title = "清剿营地Ⅲ",
    Desc = "累计开启深渊之湖魔物营地的宝箱%s/25次",
    Reward = Table_NpcAchieve_t.Reward[27]
  },
  [64] = {
    id = 64,
    GroupID = 4,
    Type = 52,
    Condition = Table_NpcAchieve_t.Condition[2],
    Param1 = 154,
    TargetNum = 35,
    Title = "清剿营地Ⅳ",
    Desc = "累计开启深渊之湖魔物营地的宝箱%s/35次",
    Reward = Table_NpcAchieve_t.Reward[28]
  },
  [65] = {
    id = 65,
    GroupID = 4,
    Type = 52,
    Condition = Table_NpcAchieve_t.Condition[3],
    Param1 = 154,
    TargetNum = 45,
    Title = "清剿营地Ⅴ",
    Desc = "累计开启深渊之湖魔物营地的宝箱%s/45次",
    Reward = Table_NpcAchieve_t.Reward[28]
  },
  [66] = {
    id = 66,
    GroupID = 4,
    Type = 52,
    Condition = Table_NpcAchieve_t.Condition[4],
    Param1 = 154,
    TargetNum = 60,
    Title = "清剿营地Ⅵ",
    Desc = "累计开启深渊之湖魔物营地的宝箱%s/60次",
    Reward = Table_NpcAchieve_t.Reward[29]
  },
  [67] = {
    id = 67,
    GroupID = 4,
    Type = 52,
    Condition = Table_NpcAchieve_t.Condition[5],
    Param1 = 154,
    TargetNum = 75,
    Title = "清剿营地Ⅶ",
    Desc = "累计开启深渊之湖魔物营地的宝箱%s/75次",
    Reward = Table_NpcAchieve_t.Reward[29]
  },
  [68] = {
    id = 68,
    GroupID = 4,
    Type = 52,
    Condition = Table_NpcAchieve_t.Condition[6],
    Param1 = 154,
    TargetNum = 100,
    Title = "清剿营地Ⅷ",
    Desc = "累计开启深渊之湖魔物营地的宝箱%s/100次",
    Reward = Table_NpcAchieve_t.Reward[29]
  },
  [69] = {
    id = 69,
    GroupID = 4,
    Type = 52,
    Condition = Table_NpcAchieve_t.Condition[7],
    Param1 = 154,
    TargetNum = 125,
    Title = "清剿营地Ⅸ",
    Desc = "累计开启深渊之湖魔物营地的宝箱%s/125次",
    Reward = Table_NpcAchieve_t.Reward[30]
  },
  [70] = {
    id = 70,
    GroupID = 4,
    Type = 52,
    Condition = Table_NpcAchieve_t.Condition[8],
    Param1 = 154,
    TargetNum = 150,
    Title = "清剿营地Ⅹ",
    Desc = "累计开启深渊之湖魔物营地的宝箱%s/150次",
    Reward = Table_NpcAchieve_t.Reward[30]
  },
  [71] = {
    id = 71,
    GroupID = 5,
    Type = 53,
    Param1 = 1,
    Title = "寻找西尔芙Ⅰ",
    Desc = "累计找到藏在深渊之湖天空的%s/5个西尔芙并拍照",
    Reward = Table_NpcAchieve_t.Reward[14]
  },
  [72] = {
    id = 72,
    GroupID = 5,
    Type = 53,
    Param1 = 2,
    TargetNum = 8,
    Title = "寻找西尔芙Ⅱ",
    Desc = "累计找到藏在深渊之湖角落的%s/8个西尔芙并收集",
    Reward = Table_NpcAchieve_t.Reward[14]
  },
  [73] = {
    id = 73,
    GroupID = 5,
    Type = 53,
    Param1 = 3,
    TargetNum = 4,
    Title = "寻找西尔芙Ⅲ",
    Desc = "累计找到藏在深渊之湖角落的%s/4个西尔芙并击杀",
    Reward = Table_NpcAchieve_t.Reward[14]
  },
  [74] = {
    id = 74,
    GroupID = 5,
    Type = 53,
    Param1 = 4,
    TargetNum = 4,
    Title = "寻找西尔芙Ⅳ",
    Desc = "累计找到藏在深渊之湖木桩旁的%s/4个西尔芙",
    Reward = Table_NpcAchieve_t.Reward[14]
  },
  [75] = {
    id = 75,
    GroupID = 5,
    Type = 56,
    TargetNum = 100,
    Title = "记忆分解Ⅰ",
    Desc = "累计分解任意记忆%s/100个",
    Reward = Table_NpcAchieve_t.Reward[13]
  },
  [76] = {
    id = 76,
    GroupID = 5,
    Type = 56,
    Param1 = 4,
    TargetNum = 10,
    Title = "记忆分解Ⅱ",
    Desc = "累计分解紫色或金色记忆%s/10个",
    Reward = Table_NpcAchieve_t.Reward[14]
  },
  [77] = {
    id = 77,
    GroupID = 5,
    Type = 55,
    Param1 = 4,
    TargetNum = 1,
    Title = "装备记忆Ⅰ",
    Desc = "全身部位均装备满级紫色或金色记忆",
    Reward = Table_NpcAchieve_t.Reward[15]
  },
  [78] = {
    id = 78,
    GroupID = 5,
    Type = 57,
    TargetNum = 6,
    Title = "突破能量Ⅰ",
    Desc = "能量格首次突破",
    Reward = Table_NpcAchieve_t.Reward[15]
  },
  [79] = {
    id = 79,
    GroupID = 5,
    Type = 57,
    TargetNum = 10,
    Title = "突破能量Ⅱ",
    Desc = "能量格突破至10格",
    Reward = Table_NpcAchieve_t.Reward[17]
  },
  [80] = {
    id = 80,
    GroupID = 5,
    Type = 58,
    TargetNum = 2,
    Title = "传承技能Ⅰ",
    Desc = "累计传承被动技能2个",
    Reward = Table_NpcAchieve_t.Reward[14]
  },
  [81] = {
    id = 81,
    GroupID = 5,
    Type = 58,
    Title = "传承技能Ⅱ",
    Desc = "累计传承被动技能5个",
    Reward = Table_NpcAchieve_t.Reward[15]
  },
  [82] = {
    id = 82,
    GroupID = 5,
    Type = 58,
    Param1 = 1,
    TargetNum = 1,
    Title = "传承技能Ⅲ",
    Desc = "累计传承主动技能1个",
    Reward = Table_NpcAchieve_t.Reward[14]
  },
  [83] = {
    id = 83,
    GroupID = 5,
    Type = 58,
    Param1 = 1,
    TargetNum = 2,
    Title = "传承技能Ⅳ",
    Desc = "累计传承主动技能2个",
    Reward = Table_NpcAchieve_t.Reward[15]
  },
  [84] = {
    id = 84,
    GroupID = 5,
    Type = 59,
    Param1 = 9,
    TargetNum = 1,
    Title = "传承技能Ⅴ",
    Desc = "将任意一个传承技能升至9级",
    Reward = Table_NpcAchieve_t.Reward[15]
  },
  [85] = {
    id = 85,
    GroupID = 5,
    Type = 59,
    Param1 = 10,
    TargetNum = 1,
    Title = "传承技能Ⅵ",
    Desc = "将任意一个传承技能升至10级",
    Reward = Table_NpcAchieve_t.Reward[17]
  },
  [86] = {
    id = 86,
    GroupID = 6,
    Type = 54,
    TargetNum = 4200000000,
    Title = "龙毁世界Ⅰ",
    Desc = "累计在龙毁世界对时空巨龙造成%s/4200000000点伤害",
    Reward = Table_NpcAchieve_t.Reward[13]
  },
  [87] = {
    id = 87,
    GroupID = 6,
    Type = 60,
    Param1 = 276614,
    TargetNum = 25,
    Title = "龙毁世界Ⅱ",
    Desc = "在龙毁世界参与击杀时空巨龙共计%s/25次",
    Reward = Table_NpcAchieve_t.Reward[14]
  },
  [88] = {
    id = 88,
    GroupID = 6,
    Param1 = 276621,
    TargetNum = 500,
    Title = "龙毁世界Ⅲ",
    Desc = "在龙毁世界击杀堕落之龙共计%s/500只",
    Reward = Table_NpcAchieve_t.Reward[14]
  },
  [89] = {
    id = 89,
    GroupID = 6,
    Type = 32,
    Param1 = 4703,
    Title = "记忆之战Ⅰ",
    Desc = "通关幽灵皇宫勇士难度并获得萨克莱的传奇记忆累计%s/5个",
    Reward = Table_NpcAchieve_t.Reward[13]
  },
  [90] = {
    id = 90,
    GroupID = 6,
    Type = 32,
    Param1 = 4706,
    Title = "记忆之战Ⅱ",
    Desc = "通关残影终焉勇士难度并获得萨克莱的传奇记忆Ⅱ累计%s/5个",
    Reward = Table_NpcAchieve_t.Reward[13]
  },
  [91] = {
    id = 91,
    GroupID = 6,
    Type = 32,
    Param1 = 4714,
    Title = "记忆之战Ⅲ",
    Desc = "通关时之空间勇士难度并获得逆时的银河累计%s/5个",
    Reward = Table_NpcAchieve_t.Reward[31]
  },
  [92] = {
    id = 92,
    GroupID = 7,
    Type = 64,
    Param1 = 1,
    TargetNum = 3,
    Title = "融雪筑梦I",
    Desc = "制作融雪边境区域家具%s/3件",
    Reward = Table_NpcAchieve_t.Reward[32]
  },
  [93] = {
    id = 93,
    GroupID = 7,
    Type = 64,
    Param1 = 1,
    TargetNum = 6,
    Title = "融雪筑梦II",
    Desc = "制作融雪边境区域家具%s/6件",
    Reward = Table_NpcAchieve_t.Reward[33]
  },
  [94] = {
    id = 94,
    GroupID = 7,
    Type = 64,
    Param1 = 1,
    TargetNum = 9,
    Title = "融雪筑梦III",
    Desc = "制作融雪边境区域家具%s/9件",
    Reward = Table_NpcAchieve_t.Reward[34]
  },
  [95] = {
    id = 95,
    GroupID = 7,
    Type = 64,
    Param1 = 1,
    TargetNum = 12,
    Title = "融雪筑梦IV",
    Desc = "制作融雪边境区域家具%s/12件",
    Reward = Table_NpcAchieve_t.Reward[35]
  },
  [96] = {
    id = 96,
    GroupID = 7,
    Type = 64,
    Param1 = 1,
    TargetNum = 15,
    Title = "融雪筑梦V",
    Desc = "制作融雪边境区域家具%s/15件",
    Reward = Table_NpcAchieve_t.Reward[36]
  },
  [97] = {
    id = 97,
    GroupID = 8,
    Type = 64,
    Param1 = 2,
    TargetNum = 3,
    Title = "霜原改造I",
    Desc = "制作霜雪之原区域家具%s/3件",
    Reward = Table_NpcAchieve_t.Reward[37]
  },
  [98] = {
    id = 98,
    GroupID = 8,
    Type = 64,
    Param1 = 2,
    TargetNum = 6,
    Title = "霜原改造II",
    Desc = "制作霜雪之原区域家具%s/6件",
    Reward = Table_NpcAchieve_t.Reward[38]
  },
  [99] = {
    id = 99,
    GroupID = 8,
    Type = 64,
    Param1 = 2,
    TargetNum = 9,
    Title = "霜原改造III",
    Desc = "制作霜雪之原区域家具%s/9件",
    Reward = Table_NpcAchieve_t.Reward[39]
  },
  [100] = {
    id = 100,
    GroupID = 8,
    Type = 64,
    Param1 = 2,
    TargetNum = 12,
    Title = "霜原改造IV",
    Desc = "制作霜雪之原区域家具%s/12件",
    Reward = Table_NpcAchieve_t.Reward[40]
  },
  [101] = {
    id = 101,
    GroupID = 8,
    Type = 64,
    Param1 = 2,
    TargetNum = 15,
    Title = "霜原改造V",
    Desc = "制作霜雪之原区域家具%s/15件",
    Reward = Table_NpcAchieve_t.Reward[41]
  },
  [102] = {
    id = 102,
    GroupID = 9,
    Type = 64,
    Param1 = 3,
    TargetNum = 3,
    Title = "冰封建构I",
    Desc = "制作冰封之城区域家具%s/3件",
    Reward = Table_NpcAchieve_t.Reward[42]
  },
  [103] = {
    id = 103,
    GroupID = 9,
    Type = 64,
    Param1 = 3,
    TargetNum = 6,
    Title = "冰封建构II",
    Desc = "制作冰封之城区域家具%s/6件",
    Reward = Table_NpcAchieve_t.Reward[43]
  },
  [104] = {
    id = 104,
    GroupID = 9,
    Type = 64,
    Param1 = 3,
    TargetNum = 9,
    Desc = "制作冰封之城区域家具%s/9件",
    Reward = Table_NpcAchieve_t.Reward[44]
  },
  [105] = {
    id = 105,
    GroupID = 9,
    Type = 64,
    Param1 = 3,
    TargetNum = 12,
    Title = "冰封建构IV",
    Desc = "制作冰封之城区域家具%s/12件",
    Reward = Table_NpcAchieve_t.Reward[45]
  },
  [106] = {
    id = 106,
    GroupID = 9,
    Type = 64,
    Param1 = 3,
    TargetNum = 15,
    Title = "冰封建构V",
    Desc = "制作冰封之城区域家具%s/15件",
    Reward = Table_NpcAchieve_t.Reward[46]
  }
}
local cell_mt = {
  __index = {
    Condition = _EmptyTable,
    Desc = "累计摧毁失控炮台%s/25次",
    GroupID = 1,
    Reward = _EmptyTable,
    TargetNum = 5,
    Title = "冰封建构III",
    Type = 61,
    id = 1
  }
}
for _, d in pairs(Table_NpcAchieve) do
  setmetatable(d, cell_mt)
end
