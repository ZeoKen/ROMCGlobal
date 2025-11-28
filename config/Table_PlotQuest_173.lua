Table_PlotQuest_173 = {
  [1] = {
    id = 1,
    Type = "play_sound",
    Params = {
      path = "Skill/RO2.0_zhuizhu_shuixuli_1",
      audio_index = 1,
      loop = true
    }
  },
  [2] = {
    id = 2,
    Type = "action",
    Params = {
      npcuid = 1,
      id = 829,
      loop = true
    }
  },
  [4] = {
    id = 4,
    Type = "play_effect",
    Params = {
      path = "Skill/Eff_chase_WaterBomb_atk",
      npcuid = 1,
      ep = 2,
      loop = true
    }
  },
  [5] = {
    id = 5,
    Type = "wait_time",
    Params = {time = 200}
  },
  [6] = {
    id = 6,
    Type = "talk",
    Params = {npcuid = 2, talkid = 551610}
  },
  [7] = {
    id = 7,
    Type = "wait_time",
    Params = {time = 100}
  }
}
Table_PlotQuest_173_fields = {
  "id",
  "Type",
  "Params"
}
return Table_PlotQuest_173
