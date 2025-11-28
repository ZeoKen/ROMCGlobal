Table_PlotQuest_141 = {
  [1] = {
    id = 1,
    Type = "wait_time",
    Params = {time = 10}
  },
  [2] = {
    id = 2,
    Type = "stop_sound",
    Params = {audio_index = 3}
  },
  [3] = {
    id = 3,
    Type = "action",
    Params = {npcuid = 1, id = 841}
  },
  [4] = {
    id = 4,
    Type = "play_sound",
    Params = {
      path = "Skill/EarthDrive_attack"
    }
  },
  [5] = {
    id = 5,
    Type = "wait_time",
    Params = {time = 400}
  },
  [6] = {
    id = 6,
    Type = "remove_effect",
    Params = {
      path = "Skill/Eff_chase_Lingting_atk",
      npcuid = 1,
      ep = 2,
      loop = true
    }
  },
  [7] = {
    id = 7,
    Type = "play_effect",
    Params = {
      path = "Skill/Eff_chase_lingting_bullet",
      npcuid = 1,
      ep = 5
    }
  },
  [8] = {
    id = 8,
    Type = "action",
    Params = {player = 1, id = 832}
  },
  [9] = {
    id = 9,
    Type = "wait_time",
    Params = {time = 250}
  },
  [10] = {
    id = 10,
    Type = "play_effect",
    Params = {
      path = "Skill/Eff_chase_lingting_hit",
      player = 1,
      ep = 3
    }
  },
  [11] = {
    id = 11,
    Type = "play_sound",
    Params = {
      path = "Skill/wataru_SE_N10"
    }
  },
  [12] = {
    id = 12,
    Type = "wait_time",
    Params = {time = 250}
  },
  [13] = {
    id = 13,
    Type = "action",
    Params = {player = 1, id = 836}
  },
  [14] = {
    id = 14,
    Type = "shakescreen",
    Params = {amplitude = 25, time = 700}
  },
  [15] = {
    id = 15,
    Type = "wait_time",
    Params = {time = 150}
  },
  [16] = {
    id = 16,
    Type = "action",
    Params = {
      npcuid = 1,
      id = 829,
      loop = true
    }
  },
  [17] = {
    id = 17,
    Type = "play_sound",
    Params = {
      path = "Skill/RO2.0_zhuizhu_shandianxuli",
      audio_index = 3
    }
  },
  [18] = {
    id = 18,
    Type = "play_effect",
    Params = {
      path = "Skill/Eff_chase_Lingting_atk_Red",
      npcuid = 1,
      ep = 2,
      loop = true
    }
  },
  [19] = {
    id = 19,
    Type = "action",
    Params = {
      player = 1,
      id = 834,
      loop = true
    }
  },
  [20] = {
    id = 20,
    Type = "play_effect",
    Params = {
      path = "Skill/Eff_Chasing_playeratk",
      player = 1,
      ep = 5,
      loop = true
    }
  }
}
Table_PlotQuest_141_fields = {
  "id",
  "Type",
  "Params"
}
return Table_PlotQuest_141
