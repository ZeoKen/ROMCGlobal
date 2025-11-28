Table_PlotQuest_168 = {
  [1] = {
    id = 1,
    Type = "remove_effect",
    Params = {
      path = "Skill/Eff_Chasing_soul02",
      player = 1,
      ep = 3,
      loop = true
    }
  },
  [2] = {
    id = 2,
    Type = "play_effect",
    Params = {
      path = "Skill/Eff_Chasing_soul03",
      player = 1,
      ep = 3,
      loop = true
    }
  },
  [3] = {
    id = 3,
    Type = "wait_time",
    Params = {time = 100}
  }
}
Table_PlotQuest_168_fields = {
  "id",
  "Type",
  "Params"
}
return Table_PlotQuest_168
