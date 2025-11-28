Table_PlotQuest_158 = {
  [1] = {
    id = 1,
    Type = "action",
    Params = {
      npcuid = 1,
      id = 21,
      loop = true
    }
  },
  [2] = {
    id = 2,
    Type = "play_effect_scene",
    Params = {
      id = 3,
      path = "Skill/Eff_chase_Puddle_atk",
      pos = {
        0.0,
        -1.8,
        1.0
      },
      ignoreNavMesh = 1
    }
  },
  [3] = {
    id = 3,
    Type = "wait_time",
    Params = {time = 100}
  }
}
Table_PlotQuest_158_fields = {
  "id",
  "Type",
  "Params"
}
return Table_PlotQuest_158
