Table_PlotQuest_150 = {
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
    Type = "play_effect",
    Params = {
      path = "Skill/Eff_chase_WaterBomb_bullet",
      npcuid = 1,
      ep = 4,
      loop = true
    }
  },
  [3] = {
    id = 3,
    Type = "wait_time",
    Params = {time = 100}
  }
}
Table_PlotQuest_150_fields = {
  "id",
  "Type",
  "Params"
}
return Table_PlotQuest_150
