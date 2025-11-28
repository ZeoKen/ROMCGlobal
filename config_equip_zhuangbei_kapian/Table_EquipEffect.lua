Table_EquipEffect_t = {
  AttrRate = {
    {
      {0.04, 500},
      {0.08, 400},
      {0.12, 100}
    },
    {
      {0.03, 100},
      {0.035, 100},
      {0.04, 100},
      {0.045, 100},
      {0.05, 100},
      {0.055, 100},
      {0.06, 100},
      {0.065, 100},
      {0.07, 100},
      {0.075, 100}
    },
    {
      {0.015, 2500},
      {0.03, 2000},
      {0.045, 500}
    },
    {
      {0.03, 500},
      {0.06, 400},
      {0.09, 100}
    },
    {
      {0.02, 500},
      {0.04, 400},
      {0.06, 100}
    },
    {
      {0.04, 100},
      {0.05, 100},
      {0.06, 100},
      {0.065, 100},
      {0.07, 100},
      {0.075, 100},
      {0.08, 100},
      {0.085, 100},
      {0.09, 100},
      {0.1, 100}
    },
    {
      {0.04, 2500},
      {0.08, 2000},
      {0.12, 500}
    },
    {
      {0.08, 500},
      {0.12, 400},
      {0.24, 100}
    },
    {
      {0.05, 2500},
      {0.1, 2000},
      {0.15, 500}
    },
    {
      {0.05, 500},
      {0.1, 400},
      {0.15, 100}
    },
    {
      {-0.06, 2500},
      {-0.12, 2000},
      {-0.18, 500}
    },
    {
      {0.08, 500},
      {0.16, 400},
      {0.24, 100}
    },
    {
      {0.06, 500},
      {0.12, 400},
      {0.18, 100}
    },
    {
      {0.12, 500},
      {0.24, 400},
      {0.36, 100}
    },
    {
      {0.1, 2500},
      {0.2, 2000},
      {0.3, 500}
    },
    {
      {0.08, 100}
    },
    {
      {0.15, 100}
    },
    {
      {0.06, 2500},
      {0.12, 2000},
      {0.18, 500}
    },
    {
      {0.12, 100}
    },
    {
      {0.06, 500},
      {0.13, 400},
      {0.2, 100}
    },
    {
      {0.06, 250},
      {0.13, 200},
      {0.2, 50}
    },
    {
      {0.03, 100}
    },
    {
      {0.03, 2500},
      {0.06, 2000},
      {0.09, 500}
    },
    {
      {0.08, 2500},
      {0.16, 2000},
      {0.24, 500}
    },
    {
      {0.06, 100}
    },
    {
      {0.15, 500},
      {0.3, 400},
      {0.45, 100}
    },
    {
      {0.05, 100}
    },
    {
      {0.02, 2500},
      {0.04, 2000},
      {0.06, 500}
    },
    {
      {0.02, 100}
    },
    {
      {0.1, 500},
      {0.2, 400},
      {0.3, 100}
    },
    {
      {0.06, 2500},
      {0.13, 2000},
      {0.2, 500}
    },
    {
      {0.08, 500},
      {0.16, 400},
      {0.24, 1500}
    }
  },
  AttrType = {
    {"MDefPer"},
    {"NpcResPer"},
    {
      "DamIncrease"
    },
    {"DamReduc"},
    {"MDamReduc"},
    {"MaxHpPer"},
    {"DefPer"},
    {"NpcDamPer"},
    {
      "NormalAtkDam"
    },
    {
      "NormalAtkRes"
    },
    {"SkillRes"},
    {"MDamSpike"},
    {"DamReduc", "MDamReduc"},
    {
      "DelayCDChangePer"
    },
    {"FireAtk"},
    {"IgnoreMDef"},
    {"DamSpike"},
    {
      "MDamIncrease"
    },
    {"IgnoreDef"},
    {"WaterAtk"},
    {"MAtkPer"},
    {
      "DamIncrease",
      "MDamIncrease"
    },
    {"CriDamPer"},
    {"MidDamPer"},
    {
      "SmallDamPer"
    },
    {"AtkPer"},
    {"DefPer", "MDefPer"},
    {"BigDamPer"},
    {
      "BeHealEncPer"
    },
    {"SkillDam"},
    {
      "BigResPer",
      "SmallResPer",
      "MidResPer"
    },
    {
      "BeWindDamPer",
      "BeEarthDamPer",
      "BeWaterDamPer",
      "BeFireDamPer",
      "BeNeutralDamPer"
    },
    {
      "DemiHumanResPer"
    },
    {
      "BePoisonDamPer",
      "BeHolyDamPer",
      "BeShadowDamPer",
      "BeGhostDamPer",
      "BeNeutralDamPer"
    },
    {"MaxSpPer"},
    {
      "WindAtk",
      "EarthAtk",
      "WaterAtk",
      "FireAtk",
      "NeutralAtk"
    },
    {"MidResPer"},
    {"HealEncPer"}
  }
}
Table_EquipEffect = {
  [42128001] = {
    id = 42128001,
    EquipID = 42128,
    AttrType = Table_EquipEffect_t.AttrType[3],
    AttrRate = Table_EquipEffect_t.AttrRate[9],
    Dsc = "##1110946"
  },
  [42128002] = {
    id = 42128002,
    EquipID = 42128,
    AttrType = Table_EquipEffect_t.AttrType[13],
    AttrRate = Table_EquipEffect_t.AttrRate[10],
    Dsc = "##312072"
  },
  [42128003] = {
    id = 42128003,
    EquipID = 42128,
    AttrType = Table_EquipEffect_t.AttrType[27],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##312088"
  },
  [42128004] = {
    id = 42128004,
    EquipID = 42128,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[10]
  },
  [42128005] = {
    id = 42128005,
    EquipID = 42128,
    AttrType = Table_EquipEffect_t.AttrType[28],
    AttrRate = Table_EquipEffect_t.AttrRate[21],
    Dsc = "##1123619"
  },
  [42128006] = {
    id = 42128006,
    EquipID = 42128,
    AttrType = Table_EquipEffect_t.AttrType[24],
    AttrRate = Table_EquipEffect_t.AttrRate[20],
    Dsc = "##1123620"
  },
  [42128007] = {
    id = 42128007,
    EquipID = 42128,
    AttrType = Table_EquipEffect_t.AttrType[25],
    AttrRate = Table_EquipEffect_t.AttrRate[21],
    Dsc = "##1123621"
  },
  [42129001] = {
    id = 42129001,
    EquipID = 42129,
    AttrType = Table_EquipEffect_t.AttrType[3],
    AttrRate = Table_EquipEffect_t.AttrRate[9],
    Dsc = "##1110946"
  },
  [42129002] = {
    id = 42129002,
    EquipID = 42129,
    AttrType = Table_EquipEffect_t.AttrType[13],
    AttrRate = Table_EquipEffect_t.AttrRate[10],
    Dsc = "##312072"
  },
  [42129003] = {
    id = 42129003,
    EquipID = 42129,
    AttrType = Table_EquipEffect_t.AttrType[27],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##312088"
  },
  [42129004] = {
    id = 42129004,
    EquipID = 42129,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[10]
  },
  [42129005] = {
    id = 42129005,
    EquipID = 42129,
    AttrType = Table_EquipEffect_t.AttrType[28],
    AttrRate = Table_EquipEffect_t.AttrRate[21],
    Dsc = "##1123619"
  },
  [42129006] = {
    id = 42129006,
    EquipID = 42129,
    AttrType = Table_EquipEffect_t.AttrType[24],
    AttrRate = Table_EquipEffect_t.AttrRate[20],
    Dsc = "##1123620"
  },
  [42129007] = {
    id = 42129007,
    EquipID = 42129,
    AttrType = Table_EquipEffect_t.AttrType[25],
    AttrRate = Table_EquipEffect_t.AttrRate[21],
    Dsc = "##1123621"
  },
  [42129008] = {
    id = 42129008,
    EquipID = 42129,
    GroupID = 2,
    AttrType = Table_EquipEffect_t.AttrType[2],
    AttrRate = Table_EquipEffect_t.AttrRate[2],
    Dsc = "##1211215"
  },
  [42131001] = {
    id = 42131001,
    EquipID = 42131,
    AttrType = Table_EquipEffect_t.AttrType[17],
    AttrRate = Table_EquipEffect_t.AttrRate[9],
    Dsc = "##1110947"
  },
  [42131002] = {
    id = 42131002,
    EquipID = 42131,
    AttrType = Table_EquipEffect_t.AttrType[13],
    AttrRate = Table_EquipEffect_t.AttrRate[10],
    Dsc = "##312072"
  },
  [42131003] = {
    id = 42131003,
    EquipID = 42131,
    AttrType = Table_EquipEffect_t.AttrType[27],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##312088"
  },
  [42131004] = {
    id = 42131004,
    EquipID = 42131,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[10]
  },
  [42131005] = {
    id = 42131005,
    EquipID = 42131,
    AttrType = Table_EquipEffect_t.AttrType[28],
    AttrRate = Table_EquipEffect_t.AttrRate[21],
    Dsc = "##1123619"
  },
  [42131006] = {
    id = 42131006,
    EquipID = 42131,
    AttrType = Table_EquipEffect_t.AttrType[24],
    AttrRate = Table_EquipEffect_t.AttrRate[20],
    Dsc = "##1123620"
  },
  [42131007] = {
    id = 42131007,
    EquipID = 42131,
    AttrType = Table_EquipEffect_t.AttrType[25],
    AttrRate = Table_EquipEffect_t.AttrRate[21],
    Dsc = "##1123621"
  },
  [42132001] = {
    id = 42132001,
    EquipID = 42132,
    AttrType = Table_EquipEffect_t.AttrType[17],
    AttrRate = Table_EquipEffect_t.AttrRate[9],
    Dsc = "##1110947"
  },
  [42132002] = {
    id = 42132002,
    EquipID = 42132,
    AttrType = Table_EquipEffect_t.AttrType[13],
    AttrRate = Table_EquipEffect_t.AttrRate[10],
    Dsc = "##312072"
  },
  [42132003] = {
    id = 42132003,
    EquipID = 42132,
    AttrType = Table_EquipEffect_t.AttrType[27],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##312088"
  },
  [42132004] = {
    id = 42132004,
    EquipID = 42132,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[10]
  },
  [42132005] = {
    id = 42132005,
    EquipID = 42132,
    AttrType = Table_EquipEffect_t.AttrType[28],
    AttrRate = Table_EquipEffect_t.AttrRate[21],
    Dsc = "##1123619"
  },
  [42132006] = {
    id = 42132006,
    EquipID = 42132,
    AttrType = Table_EquipEffect_t.AttrType[24],
    AttrRate = Table_EquipEffect_t.AttrRate[20],
    Dsc = "##1123620"
  },
  [42132007] = {
    id = 42132007,
    EquipID = 42132,
    AttrType = Table_EquipEffect_t.AttrType[25],
    AttrRate = Table_EquipEffect_t.AttrRate[21],
    Dsc = "##1123621"
  },
  [42132008] = {
    id = 42132008,
    EquipID = 42132,
    GroupID = 2,
    AttrType = Table_EquipEffect_t.AttrType[2],
    AttrRate = Table_EquipEffect_t.AttrRate[2],
    Dsc = "##1211215"
  },
  [42134001] = {
    id = 42134001,
    EquipID = 42134,
    AttrType = Table_EquipEffect_t.AttrType[17],
    AttrRate = Table_EquipEffect_t.AttrRate[9],
    Dsc = "##1110947"
  },
  [42134002] = {
    id = 42134002,
    EquipID = 42134,
    AttrType = Table_EquipEffect_t.AttrType[13],
    AttrRate = Table_EquipEffect_t.AttrRate[10],
    Dsc = "##312072"
  },
  [42134003] = {
    id = 42134003,
    EquipID = 42134,
    AttrType = Table_EquipEffect_t.AttrType[27],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##312088"
  },
  [42134004] = {
    id = 42134004,
    EquipID = 42134,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[10]
  },
  [42134005] = {
    id = 42134005,
    EquipID = 42134,
    AttrType = Table_EquipEffect_t.AttrType[28],
    AttrRate = Table_EquipEffect_t.AttrRate[21],
    Dsc = "##1123619"
  },
  [42134006] = {
    id = 42134006,
    EquipID = 42134,
    AttrType = Table_EquipEffect_t.AttrType[24],
    AttrRate = Table_EquipEffect_t.AttrRate[20],
    Dsc = "##1123620"
  },
  [42134007] = {
    id = 42134007,
    EquipID = 42134,
    AttrType = Table_EquipEffect_t.AttrType[25],
    AttrRate = Table_EquipEffect_t.AttrRate[21],
    Dsc = "##1123621"
  },
  [42135001] = {
    id = 42135001,
    EquipID = 42135,
    AttrType = Table_EquipEffect_t.AttrType[17],
    AttrRate = Table_EquipEffect_t.AttrRate[9],
    Dsc = "##1110947"
  },
  [42135002] = {
    id = 42135002,
    EquipID = 42135,
    AttrType = Table_EquipEffect_t.AttrType[13],
    AttrRate = Table_EquipEffect_t.AttrRate[10],
    Dsc = "##312072"
  },
  [42135003] = {
    id = 42135003,
    EquipID = 42135,
    AttrType = Table_EquipEffect_t.AttrType[27],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##312088"
  },
  [42135004] = {
    id = 42135004,
    EquipID = 42135,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[10]
  },
  [42135005] = {
    id = 42135005,
    EquipID = 42135,
    AttrType = Table_EquipEffect_t.AttrType[28],
    AttrRate = Table_EquipEffect_t.AttrRate[21],
    Dsc = "##1123619"
  },
  [42135006] = {
    id = 42135006,
    EquipID = 42135,
    AttrType = Table_EquipEffect_t.AttrType[24],
    AttrRate = Table_EquipEffect_t.AttrRate[20],
    Dsc = "##1123620"
  },
  [42135007] = {
    id = 42135007,
    EquipID = 42135,
    AttrType = Table_EquipEffect_t.AttrType[25],
    AttrRate = Table_EquipEffect_t.AttrRate[21],
    Dsc = "##1123621"
  },
  [42135008] = {
    id = 42135008,
    EquipID = 42135,
    GroupID = 2,
    AttrType = Table_EquipEffect_t.AttrType[2],
    AttrRate = Table_EquipEffect_t.AttrRate[2],
    Dsc = "##1211215"
  },
  [42137001] = {
    id = 42137001,
    EquipID = 42137,
    AttrType = Table_EquipEffect_t.AttrType[23],
    AttrRate = Table_EquipEffect_t.AttrRate[15],
    Dsc = "##312079"
  },
  [42137002] = {
    id = 42137002,
    EquipID = 42137,
    AttrType = Table_EquipEffect_t.AttrType[13],
    AttrRate = Table_EquipEffect_t.AttrRate[10],
    Dsc = "##312072"
  },
  [42137003] = {
    id = 42137003,
    EquipID = 42137,
    AttrType = Table_EquipEffect_t.AttrType[27],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##312088"
  },
  [42137004] = {
    id = 42137004,
    EquipID = 42137,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[10]
  },
  [42137005] = {
    id = 42137005,
    EquipID = 42137,
    AttrType = Table_EquipEffect_t.AttrType[28],
    AttrRate = Table_EquipEffect_t.AttrRate[21],
    Dsc = "##1123619"
  },
  [42137006] = {
    id = 42137006,
    EquipID = 42137,
    AttrType = Table_EquipEffect_t.AttrType[24],
    AttrRate = Table_EquipEffect_t.AttrRate[20],
    Dsc = "##1123620"
  },
  [42137007] = {
    id = 42137007,
    EquipID = 42137,
    AttrType = Table_EquipEffect_t.AttrType[25],
    AttrRate = Table_EquipEffect_t.AttrRate[21],
    Dsc = "##1123621"
  },
  [42138001] = {
    id = 42138001,
    EquipID = 42138,
    AttrType = Table_EquipEffect_t.AttrType[23],
    AttrRate = Table_EquipEffect_t.AttrRate[15],
    Dsc = "##312079"
  },
  [42138002] = {
    id = 42138002,
    EquipID = 42138,
    AttrType = Table_EquipEffect_t.AttrType[13],
    AttrRate = Table_EquipEffect_t.AttrRate[10],
    Dsc = "##312072"
  },
  [42138003] = {
    id = 42138003,
    EquipID = 42138,
    AttrType = Table_EquipEffect_t.AttrType[27],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##312088"
  },
  [42138004] = {
    id = 42138004,
    EquipID = 42138,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[10]
  },
  [42138005] = {
    id = 42138005,
    EquipID = 42138,
    AttrType = Table_EquipEffect_t.AttrType[28],
    AttrRate = Table_EquipEffect_t.AttrRate[21],
    Dsc = "##1123619"
  },
  [42138006] = {
    id = 42138006,
    EquipID = 42138,
    AttrType = Table_EquipEffect_t.AttrType[24],
    AttrRate = Table_EquipEffect_t.AttrRate[20],
    Dsc = "##1123620"
  },
  [42138007] = {
    id = 42138007,
    EquipID = 42138,
    AttrType = Table_EquipEffect_t.AttrType[25],
    AttrRate = Table_EquipEffect_t.AttrRate[21],
    Dsc = "##1123621"
  },
  [42138008] = {
    id = 42138008,
    EquipID = 42138,
    GroupID = 2,
    AttrType = Table_EquipEffect_t.AttrType[2],
    AttrRate = Table_EquipEffect_t.AttrRate[2],
    Dsc = "##1211215"
  },
  [42140001] = {
    id = 42140001,
    EquipID = 42140,
    AttrType = Table_EquipEffect_t.AttrType[26],
    AttrRate = Table_EquipEffect_t.AttrRate[24],
    Dsc = "##312080"
  },
  [42140002] = {
    id = 42140002,
    EquipID = 42140,
    AttrType = Table_EquipEffect_t.AttrType[13],
    AttrRate = Table_EquipEffect_t.AttrRate[10],
    Dsc = "##312072"
  },
  [42140003] = {
    id = 42140003,
    EquipID = 42140,
    AttrType = Table_EquipEffect_t.AttrType[27],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##312088"
  },
  [42140004] = {
    id = 42140004,
    EquipID = 42140,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[10]
  },
  [42140005] = {
    id = 42140005,
    EquipID = 42140,
    AttrType = Table_EquipEffect_t.AttrType[28],
    AttrRate = Table_EquipEffect_t.AttrRate[21],
    Dsc = "##1123619"
  },
  [42140006] = {
    id = 42140006,
    EquipID = 42140,
    AttrType = Table_EquipEffect_t.AttrType[24],
    AttrRate = Table_EquipEffect_t.AttrRate[20],
    Dsc = "##1123620"
  },
  [42140007] = {
    id = 42140007,
    EquipID = 42140,
    AttrType = Table_EquipEffect_t.AttrType[25],
    AttrRate = Table_EquipEffect_t.AttrRate[21],
    Dsc = "##1123621"
  },
  [42141001] = {
    id = 42141001,
    EquipID = 42141,
    AttrType = Table_EquipEffect_t.AttrType[26],
    AttrRate = Table_EquipEffect_t.AttrRate[24],
    Dsc = "##312080"
  },
  [42141002] = {
    id = 42141002,
    EquipID = 42141,
    AttrType = Table_EquipEffect_t.AttrType[13],
    AttrRate = Table_EquipEffect_t.AttrRate[10],
    Dsc = "##312072"
  },
  [42141003] = {
    id = 42141003,
    EquipID = 42141,
    AttrType = Table_EquipEffect_t.AttrType[27],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##312088"
  },
  [42141004] = {
    id = 42141004,
    EquipID = 42141,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[10]
  },
  [42141005] = {
    id = 42141005,
    EquipID = 42141,
    AttrType = Table_EquipEffect_t.AttrType[28],
    AttrRate = Table_EquipEffect_t.AttrRate[21],
    Dsc = "##1123619"
  },
  [42141006] = {
    id = 42141006,
    EquipID = 42141,
    AttrType = Table_EquipEffect_t.AttrType[24],
    AttrRate = Table_EquipEffect_t.AttrRate[20],
    Dsc = "##1123620"
  },
  [42141007] = {
    id = 42141007,
    EquipID = 42141,
    AttrType = Table_EquipEffect_t.AttrType[25],
    AttrRate = Table_EquipEffect_t.AttrRate[21],
    Dsc = "##1123621"
  },
  [42141008] = {
    id = 42141008,
    EquipID = 42141,
    GroupID = 2,
    AttrType = Table_EquipEffect_t.AttrType[2],
    AttrRate = Table_EquipEffect_t.AttrRate[2],
    Dsc = "##1211215"
  },
  [42143001] = {
    id = 42143001,
    EquipID = 42143,
    AttrType = Table_EquipEffect_t.AttrType[26],
    AttrRate = Table_EquipEffect_t.AttrRate[24],
    Dsc = "##312080"
  },
  [42143002] = {
    id = 42143002,
    EquipID = 42143,
    AttrType = Table_EquipEffect_t.AttrType[13],
    AttrRate = Table_EquipEffect_t.AttrRate[10],
    Dsc = "##312072"
  },
  [42143003] = {
    id = 42143003,
    EquipID = 42143,
    AttrType = Table_EquipEffect_t.AttrType[27],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##312088"
  },
  [42143004] = {
    id = 42143004,
    EquipID = 42143,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[10]
  },
  [42143005] = {
    id = 42143005,
    EquipID = 42143,
    AttrType = Table_EquipEffect_t.AttrType[28],
    AttrRate = Table_EquipEffect_t.AttrRate[21],
    Dsc = "##1123619"
  },
  [42143006] = {
    id = 42143006,
    EquipID = 42143,
    AttrType = Table_EquipEffect_t.AttrType[24],
    AttrRate = Table_EquipEffect_t.AttrRate[20],
    Dsc = "##1123620"
  },
  [42143007] = {
    id = 42143007,
    EquipID = 42143,
    AttrType = Table_EquipEffect_t.AttrType[25],
    AttrRate = Table_EquipEffect_t.AttrRate[21],
    Dsc = "##1123621"
  },
  [42144001] = {
    id = 42144001,
    EquipID = 42144,
    AttrType = Table_EquipEffect_t.AttrType[26],
    AttrRate = Table_EquipEffect_t.AttrRate[24],
    Dsc = "##312080"
  },
  [42144002] = {
    id = 42144002,
    EquipID = 42144,
    AttrType = Table_EquipEffect_t.AttrType[13],
    AttrRate = Table_EquipEffect_t.AttrRate[10],
    Dsc = "##312072"
  },
  [42144003] = {
    id = 42144003,
    EquipID = 42144,
    AttrType = Table_EquipEffect_t.AttrType[27],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##312088"
  },
  [42144004] = {
    id = 42144004,
    EquipID = 42144,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[10]
  },
  [42144005] = {
    id = 42144005,
    EquipID = 42144,
    AttrType = Table_EquipEffect_t.AttrType[28],
    AttrRate = Table_EquipEffect_t.AttrRate[21],
    Dsc = "##1123619"
  },
  [42144006] = {
    id = 42144006,
    EquipID = 42144,
    AttrType = Table_EquipEffect_t.AttrType[24],
    AttrRate = Table_EquipEffect_t.AttrRate[20],
    Dsc = "##1123620"
  },
  [42144007] = {
    id = 42144007,
    EquipID = 42144,
    AttrType = Table_EquipEffect_t.AttrType[25],
    AttrRate = Table_EquipEffect_t.AttrRate[21],
    Dsc = "##1123621"
  },
  [42144008] = {
    id = 42144008,
    EquipID = 42144,
    GroupID = 2,
    AttrType = Table_EquipEffect_t.AttrType[2],
    AttrRate = Table_EquipEffect_t.AttrRate[2],
    Dsc = "##1211215"
  },
  [42146001] = {
    id = 42146001,
    EquipID = 42146,
    AttrType = Table_EquipEffect_t.AttrType[22],
    AttrRate = Table_EquipEffect_t.AttrRate[9],
    Dsc = "##312087"
  },
  [42146002] = {
    id = 42146002,
    EquipID = 42146,
    AttrType = Table_EquipEffect_t.AttrType[13],
    AttrRate = Table_EquipEffect_t.AttrRate[10],
    Dsc = "##312072"
  },
  [42146003] = {
    id = 42146003,
    EquipID = 42146,
    AttrType = Table_EquipEffect_t.AttrType[27],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##312088"
  },
  [42146004] = {
    id = 42146004,
    EquipID = 42146,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[10]
  },
  [42146005] = {
    id = 42146005,
    EquipID = 42146,
    AttrType = Table_EquipEffect_t.AttrType[28],
    AttrRate = Table_EquipEffect_t.AttrRate[21],
    Dsc = "##1123619"
  },
  [42146006] = {
    id = 42146006,
    EquipID = 42146,
    AttrType = Table_EquipEffect_t.AttrType[24],
    AttrRate = Table_EquipEffect_t.AttrRate[20],
    Dsc = "##1123620"
  },
  [42146007] = {
    id = 42146007,
    EquipID = 42146,
    AttrType = Table_EquipEffect_t.AttrType[25],
    AttrRate = Table_EquipEffect_t.AttrRate[21],
    Dsc = "##1123621"
  },
  [42147001] = {
    id = 42147001,
    EquipID = 42147,
    AttrType = Table_EquipEffect_t.AttrType[22],
    AttrRate = Table_EquipEffect_t.AttrRate[9],
    Dsc = "##312087"
  },
  [42147002] = {
    id = 42147002,
    EquipID = 42147,
    AttrType = Table_EquipEffect_t.AttrType[13],
    AttrRate = Table_EquipEffect_t.AttrRate[10],
    Dsc = "##312072"
  },
  [42147003] = {
    id = 42147003,
    EquipID = 42147,
    AttrType = Table_EquipEffect_t.AttrType[27],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##312088"
  },
  [42147004] = {
    id = 42147004,
    EquipID = 42147,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[10]
  },
  [42147005] = {
    id = 42147005,
    EquipID = 42147,
    AttrType = Table_EquipEffect_t.AttrType[28],
    AttrRate = Table_EquipEffect_t.AttrRate[21],
    Dsc = "##1123619"
  },
  [42147006] = {
    id = 42147006,
    EquipID = 42147,
    AttrType = Table_EquipEffect_t.AttrType[24],
    AttrRate = Table_EquipEffect_t.AttrRate[20],
    Dsc = "##1123620"
  },
  [42147007] = {
    id = 42147007,
    EquipID = 42147,
    AttrType = Table_EquipEffect_t.AttrType[25],
    AttrRate = Table_EquipEffect_t.AttrRate[21],
    Dsc = "##1123621"
  },
  [42147008] = {
    id = 42147008,
    EquipID = 42147,
    GroupID = 2,
    AttrType = Table_EquipEffect_t.AttrType[2],
    AttrRate = Table_EquipEffect_t.AttrRate[2],
    Dsc = "##1211215"
  },
  [42149001] = {
    id = 42149001,
    EquipID = 42149,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[9]
  },
  [42149002] = {
    id = 42149002,
    EquipID = 42149,
    AttrType = Table_EquipEffect_t.AttrType[13],
    AttrRate = Table_EquipEffect_t.AttrRate[10],
    Dsc = "##312072"
  },
  [42149003] = {
    id = 42149003,
    EquipID = 42149,
    AttrType = Table_EquipEffect_t.AttrType[27],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##312088"
  },
  [42149004] = {
    id = 42149004,
    EquipID = 42149,
    AttrType = Table_EquipEffect_t.AttrType[35],
    AttrRate = Table_EquipEffect_t.AttrRate[32],
    Dsc = "##1123376"
  },
  [42149005] = {
    id = 42149005,
    EquipID = 42149,
    AttrType = Table_EquipEffect_t.AttrType[29],
    AttrRate = Table_EquipEffect_t.AttrRate[30],
    Dsc = "##1123393"
  },
  [42149006] = {
    id = 42149006,
    EquipID = 42149,
    AttrType = Table_EquipEffect_t.AttrType[37],
    AttrRate = Table_EquipEffect_t.AttrRate[20],
    Dsc = "##1123642"
  },
  [42150001] = {
    id = 42150001,
    EquipID = 42150,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[9]
  },
  [42150002] = {
    id = 42150002,
    EquipID = 42150,
    AttrType = Table_EquipEffect_t.AttrType[13],
    AttrRate = Table_EquipEffect_t.AttrRate[10],
    Dsc = "##312072"
  },
  [42150003] = {
    id = 42150003,
    EquipID = 42150,
    AttrType = Table_EquipEffect_t.AttrType[27],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##312088"
  },
  [42150004] = {
    id = 42150004,
    EquipID = 42150,
    AttrType = Table_EquipEffect_t.AttrType[35],
    AttrRate = Table_EquipEffect_t.AttrRate[32],
    Dsc = "##1123376"
  },
  [42150005] = {
    id = 42150005,
    EquipID = 42150,
    AttrType = Table_EquipEffect_t.AttrType[29],
    AttrRate = Table_EquipEffect_t.AttrRate[30],
    Dsc = "##1123393"
  },
  [42150006] = {
    id = 42150006,
    EquipID = 42150,
    AttrType = Table_EquipEffect_t.AttrType[37],
    AttrRate = Table_EquipEffect_t.AttrRate[20],
    Dsc = "##1123642"
  },
  [42150007] = {
    id = 42150007,
    EquipID = 42150,
    GroupID = 2,
    AttrType = Table_EquipEffect_t.AttrType[2],
    AttrRate = Table_EquipEffect_t.AttrRate[2],
    Dsc = "##1211215"
  },
  [42152001] = {
    id = 42152001,
    EquipID = 42152,
    AttrType = Table_EquipEffect_t.AttrType[18],
    AttrRate = Table_EquipEffect_t.AttrRate[9],
    Dsc = "##1123327"
  },
  [42152002] = {
    id = 42152002,
    EquipID = 42152,
    AttrType = Table_EquipEffect_t.AttrType[13],
    AttrRate = Table_EquipEffect_t.AttrRate[10],
    Dsc = "##312072"
  },
  [42152003] = {
    id = 42152003,
    EquipID = 42152,
    AttrType = Table_EquipEffect_t.AttrType[27],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##312088"
  },
  [42152004] = {
    id = 42152004,
    EquipID = 42152,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[10]
  },
  [42152005] = {
    id = 42152005,
    EquipID = 42152,
    AttrType = Table_EquipEffect_t.AttrType[36],
    AttrRate = Table_EquipEffect_t.AttrRate[20],
    Dsc = "##1123644"
  },
  [42152006] = {
    id = 42152006,
    EquipID = 42152,
    AttrType = Table_EquipEffect_t.AttrType[35],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123376"
  },
  [42153001] = {
    id = 42153001,
    EquipID = 42153,
    AttrType = Table_EquipEffect_t.AttrType[18],
    AttrRate = Table_EquipEffect_t.AttrRate[9],
    Dsc = "##1123327"
  },
  [42153002] = {
    id = 42153002,
    EquipID = 42153,
    AttrType = Table_EquipEffect_t.AttrType[13],
    AttrRate = Table_EquipEffect_t.AttrRate[10],
    Dsc = "##312072"
  },
  [42153003] = {
    id = 42153003,
    EquipID = 42153,
    AttrType = Table_EquipEffect_t.AttrType[27],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##312088"
  },
  [42153004] = {
    id = 42153004,
    EquipID = 42153,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[10]
  },
  [42153005] = {
    id = 42153005,
    EquipID = 42153,
    AttrType = Table_EquipEffect_t.AttrType[36],
    AttrRate = Table_EquipEffect_t.AttrRate[20],
    Dsc = "##1123644"
  },
  [42153006] = {
    id = 42153006,
    EquipID = 42153,
    AttrType = Table_EquipEffect_t.AttrType[35],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123376"
  },
  [42153007] = {
    id = 42153007,
    EquipID = 42153,
    GroupID = 2,
    AttrType = Table_EquipEffect_t.AttrType[2],
    AttrRate = Table_EquipEffect_t.AttrRate[2],
    Dsc = "##1211215"
  },
  [42155001] = {
    id = 42155001,
    EquipID = 42155,
    AttrType = Table_EquipEffect_t.AttrType[12],
    AttrRate = Table_EquipEffect_t.AttrRate[9],
    Dsc = "##1123353"
  },
  [42155002] = {
    id = 42155002,
    EquipID = 42155,
    AttrType = Table_EquipEffect_t.AttrType[13],
    AttrRate = Table_EquipEffect_t.AttrRate[10],
    Dsc = "##312072"
  },
  [42155003] = {
    id = 42155003,
    EquipID = 42155,
    AttrType = Table_EquipEffect_t.AttrType[27],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##312088"
  },
  [42155004] = {
    id = 42155004,
    EquipID = 42155,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[10]
  },
  [42155005] = {
    id = 42155005,
    EquipID = 42155,
    AttrType = Table_EquipEffect_t.AttrType[36],
    AttrRate = Table_EquipEffect_t.AttrRate[20],
    Dsc = "##1123644"
  },
  [42155006] = {
    id = 42155006,
    EquipID = 42155,
    AttrType = Table_EquipEffect_t.AttrType[35],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123376"
  },
  [42156001] = {
    id = 42156001,
    EquipID = 42156,
    AttrType = Table_EquipEffect_t.AttrType[12],
    AttrRate = Table_EquipEffect_t.AttrRate[9],
    Dsc = "##1123353"
  },
  [42156002] = {
    id = 42156002,
    EquipID = 42156,
    AttrType = Table_EquipEffect_t.AttrType[13],
    AttrRate = Table_EquipEffect_t.AttrRate[10],
    Dsc = "##312072"
  },
  [42156003] = {
    id = 42156003,
    EquipID = 42156,
    AttrType = Table_EquipEffect_t.AttrType[27],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##312088"
  },
  [42156004] = {
    id = 42156004,
    EquipID = 42156,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[10]
  },
  [42156005] = {
    id = 42156005,
    EquipID = 42156,
    AttrType = Table_EquipEffect_t.AttrType[36],
    AttrRate = Table_EquipEffect_t.AttrRate[20],
    Dsc = "##1123644"
  },
  [42156006] = {
    id = 42156006,
    EquipID = 42156,
    AttrType = Table_EquipEffect_t.AttrType[35],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123376"
  },
  [42156007] = {
    id = 42156007,
    EquipID = 42156,
    GroupID = 2,
    AttrType = Table_EquipEffect_t.AttrType[2],
    AttrRate = Table_EquipEffect_t.AttrRate[2],
    Dsc = "##1211215"
  },
  [42158001] = {
    id = 42158001,
    EquipID = 42158,
    AttrType = Table_EquipEffect_t.AttrType[12],
    AttrRate = Table_EquipEffect_t.AttrRate[9],
    Dsc = "##1123353"
  },
  [42158002] = {
    id = 42158002,
    EquipID = 42158,
    AttrType = Table_EquipEffect_t.AttrType[13],
    AttrRate = Table_EquipEffect_t.AttrRate[10],
    Dsc = "##312072"
  },
  [42158003] = {
    id = 42158003,
    EquipID = 42158,
    AttrType = Table_EquipEffect_t.AttrType[27],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##312088"
  },
  [42158004] = {
    id = 42158004,
    EquipID = 42158,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[10]
  },
  [42158005] = {
    id = 42158005,
    EquipID = 42158,
    AttrType = Table_EquipEffect_t.AttrType[36],
    AttrRate = Table_EquipEffect_t.AttrRate[20],
    Dsc = "##1123644"
  },
  [42158006] = {
    id = 42158006,
    EquipID = 42158,
    AttrType = Table_EquipEffect_t.AttrType[35],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123376"
  },
  [42159001] = {
    id = 42159001,
    EquipID = 42159,
    AttrType = Table_EquipEffect_t.AttrType[12],
    AttrRate = Table_EquipEffect_t.AttrRate[9],
    Dsc = "##1123353"
  },
  [42159002] = {
    id = 42159002,
    EquipID = 42159,
    AttrType = Table_EquipEffect_t.AttrType[13],
    AttrRate = Table_EquipEffect_t.AttrRate[10],
    Dsc = "##312072"
  },
  [42159003] = {
    id = 42159003,
    EquipID = 42159,
    AttrType = Table_EquipEffect_t.AttrType[27],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##312088"
  },
  [42159004] = {
    id = 42159004,
    EquipID = 42159,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[10]
  },
  [42159005] = {
    id = 42159005,
    EquipID = 42159,
    AttrType = Table_EquipEffect_t.AttrType[36],
    AttrRate = Table_EquipEffect_t.AttrRate[20],
    Dsc = "##1123644"
  },
  [42159006] = {
    id = 42159006,
    EquipID = 42159,
    AttrType = Table_EquipEffect_t.AttrType[35],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123376"
  },
  [42159007] = {
    id = 42159007,
    EquipID = 42159,
    GroupID = 2,
    AttrType = Table_EquipEffect_t.AttrType[2],
    AttrRate = Table_EquipEffect_t.AttrRate[2],
    Dsc = "##1211215"
  },
  [42161001] = {
    id = 42161001,
    EquipID = 42161,
    AttrType = Table_EquipEffect_t.AttrType[21],
    AttrRate = Table_EquipEffect_t.AttrRate[24],
    Dsc = "##312074"
  },
  [42161002] = {
    id = 42161002,
    EquipID = 42161,
    AttrType = Table_EquipEffect_t.AttrType[13],
    AttrRate = Table_EquipEffect_t.AttrRate[10],
    Dsc = "##312072"
  },
  [42161003] = {
    id = 42161003,
    EquipID = 42161,
    AttrType = Table_EquipEffect_t.AttrType[27],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##312088"
  },
  [42161004] = {
    id = 42161004,
    EquipID = 42161,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[10]
  },
  [42161005] = {
    id = 42161005,
    EquipID = 42161,
    AttrType = Table_EquipEffect_t.AttrType[36],
    AttrRate = Table_EquipEffect_t.AttrRate[20],
    Dsc = "##1123644"
  },
  [42161006] = {
    id = 42161006,
    EquipID = 42161,
    AttrType = Table_EquipEffect_t.AttrType[35],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123376"
  },
  [42162001] = {
    id = 42162001,
    EquipID = 42162,
    AttrType = Table_EquipEffect_t.AttrType[21],
    AttrRate = Table_EquipEffect_t.AttrRate[24],
    Dsc = "##312074"
  },
  [42162002] = {
    id = 42162002,
    EquipID = 42162,
    AttrType = Table_EquipEffect_t.AttrType[13],
    AttrRate = Table_EquipEffect_t.AttrRate[10],
    Dsc = "##312072"
  },
  [42162003] = {
    id = 42162003,
    EquipID = 42162,
    AttrType = Table_EquipEffect_t.AttrType[27],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##312088"
  },
  [42162004] = {
    id = 42162004,
    EquipID = 42162,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[10]
  },
  [42162005] = {
    id = 42162005,
    EquipID = 42162,
    AttrType = Table_EquipEffect_t.AttrType[36],
    AttrRate = Table_EquipEffect_t.AttrRate[20],
    Dsc = "##1123644"
  },
  [42162006] = {
    id = 42162006,
    EquipID = 42162,
    AttrType = Table_EquipEffect_t.AttrType[35],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123376"
  },
  [42162007] = {
    id = 42162007,
    EquipID = 42162,
    GroupID = 2,
    AttrType = Table_EquipEffect_t.AttrType[2],
    AttrRate = Table_EquipEffect_t.AttrRate[2],
    Dsc = "##1211215"
  },
  [42164001] = {
    id = 42164001,
    EquipID = 42164,
    AttrType = Table_EquipEffect_t.AttrType[35],
    AttrRate = Table_EquipEffect_t.AttrRate[24],
    Dsc = "##1123376"
  },
  [42164002] = {
    id = 42164002,
    EquipID = 42164,
    AttrType = Table_EquipEffect_t.AttrType[13],
    AttrRate = Table_EquipEffect_t.AttrRate[10],
    Dsc = "##312072"
  },
  [42164003] = {
    id = 42164003,
    EquipID = 42164,
    AttrType = Table_EquipEffect_t.AttrType[27],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##312088"
  },
  [42164004] = {
    id = 42164004,
    EquipID = 42164,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[10]
  },
  [42164005] = {
    id = 42164005,
    EquipID = 42164,
    AttrType = Table_EquipEffect_t.AttrType[29],
    AttrRate = Table_EquipEffect_t.AttrRate[30],
    Dsc = "##1123393"
  },
  [42164006] = {
    id = 42164006,
    EquipID = 42164,
    AttrType = Table_EquipEffect_t.AttrType[37],
    AttrRate = Table_EquipEffect_t.AttrRate[20],
    Dsc = "##1123642"
  },
  [42165001] = {
    id = 42165001,
    EquipID = 42165,
    AttrType = Table_EquipEffect_t.AttrType[35],
    AttrRate = Table_EquipEffect_t.AttrRate[24],
    Dsc = "##1123376"
  },
  [42165002] = {
    id = 42165002,
    EquipID = 42165,
    AttrType = Table_EquipEffect_t.AttrType[13],
    AttrRate = Table_EquipEffect_t.AttrRate[10],
    Dsc = "##312072"
  },
  [42165003] = {
    id = 42165003,
    EquipID = 42165,
    AttrType = Table_EquipEffect_t.AttrType[27],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##312088"
  },
  [42165004] = {
    id = 42165004,
    EquipID = 42165,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[10]
  },
  [42165005] = {
    id = 42165005,
    EquipID = 42165,
    AttrType = Table_EquipEffect_t.AttrType[29],
    AttrRate = Table_EquipEffect_t.AttrRate[30],
    Dsc = "##1123393"
  },
  [42165006] = {
    id = 42165006,
    EquipID = 42165,
    AttrType = Table_EquipEffect_t.AttrType[37],
    AttrRate = Table_EquipEffect_t.AttrRate[20],
    Dsc = "##1123642"
  },
  [42165007] = {
    id = 42165007,
    EquipID = 42165,
    GroupID = 2,
    AttrType = Table_EquipEffect_t.AttrType[2],
    AttrRate = Table_EquipEffect_t.AttrRate[2],
    Dsc = "##1211215"
  },
  [42167001] = {
    id = 42167001,
    EquipID = 42167,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[9]
  },
  [42167002] = {
    id = 42167002,
    EquipID = 42167,
    AttrType = Table_EquipEffect_t.AttrType[13],
    AttrRate = Table_EquipEffect_t.AttrRate[10],
    Dsc = "##312072"
  },
  [42167003] = {
    id = 42167003,
    EquipID = 42167,
    AttrType = Table_EquipEffect_t.AttrType[27],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##312088"
  },
  [42167004] = {
    id = 42167004,
    EquipID = 42167,
    AttrType = Table_EquipEffect_t.AttrType[35],
    AttrRate = Table_EquipEffect_t.AttrRate[32],
    Dsc = "##1123376"
  },
  [42167005] = {
    id = 42167005,
    EquipID = 42167,
    AttrType = Table_EquipEffect_t.AttrType[29],
    AttrRate = Table_EquipEffect_t.AttrRate[30],
    Dsc = "##1123393"
  },
  [42167006] = {
    id = 42167006,
    EquipID = 42167,
    AttrType = Table_EquipEffect_t.AttrType[37],
    AttrRate = Table_EquipEffect_t.AttrRate[20],
    Dsc = "##1123642"
  },
  [42168001] = {
    id = 42168001,
    EquipID = 42168,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[9]
  },
  [42168002] = {
    id = 42168002,
    EquipID = 42168,
    AttrType = Table_EquipEffect_t.AttrType[13],
    AttrRate = Table_EquipEffect_t.AttrRate[10],
    Dsc = "##312072"
  },
  [42168003] = {
    id = 42168003,
    EquipID = 42168,
    AttrType = Table_EquipEffect_t.AttrType[27],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##312088"
  },
  [42168004] = {
    id = 42168004,
    EquipID = 42168,
    AttrType = Table_EquipEffect_t.AttrType[35],
    AttrRate = Table_EquipEffect_t.AttrRate[32],
    Dsc = "##1123376"
  },
  [42168005] = {
    id = 42168005,
    EquipID = 42168,
    AttrType = Table_EquipEffect_t.AttrType[29],
    AttrRate = Table_EquipEffect_t.AttrRate[30],
    Dsc = "##1123393"
  },
  [42168006] = {
    id = 42168006,
    EquipID = 42168,
    AttrType = Table_EquipEffect_t.AttrType[37],
    AttrRate = Table_EquipEffect_t.AttrRate[20],
    Dsc = "##1123642"
  },
  [42168007] = {
    id = 42168007,
    EquipID = 42168,
    GroupID = 2,
    AttrType = Table_EquipEffect_t.AttrType[2],
    AttrRate = Table_EquipEffect_t.AttrRate[2],
    Dsc = "##1211215"
  },
  [42170001] = {
    id = 42170001,
    EquipID = 42170,
    AttrType = Table_EquipEffect_t.AttrType[32],
    AttrRate = Table_EquipEffect_t.AttrRate[31],
    Dsc = "##1123386"
  },
  [42170002] = {
    id = 42170002,
    EquipID = 42170,
    AttrType = Table_EquipEffect_t.AttrType[13],
    AttrRate = Table_EquipEffect_t.AttrRate[10],
    Dsc = "##312072"
  },
  [42170003] = {
    id = 42170003,
    EquipID = 42170,
    AttrType = Table_EquipEffect_t.AttrType[27],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##312088"
  },
  [42170004] = {
    id = 42170004,
    EquipID = 42170,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[10]
  },
  [42170005] = {
    id = 42170005,
    EquipID = 42170,
    AttrType = Table_EquipEffect_t.AttrType[29],
    AttrRate = Table_EquipEffect_t.AttrRate[30],
    Dsc = "##1123393"
  },
  [42170006] = {
    id = 42170006,
    EquipID = 42170,
    AttrType = Table_EquipEffect_t.AttrType[37],
    AttrRate = Table_EquipEffect_t.AttrRate[20],
    Dsc = "##1123642"
  },
  [42171001] = {
    id = 42171001,
    EquipID = 42171,
    AttrType = Table_EquipEffect_t.AttrType[32],
    AttrRate = Table_EquipEffect_t.AttrRate[31],
    Dsc = "##1123386"
  },
  [42171002] = {
    id = 42171002,
    EquipID = 42171,
    AttrType = Table_EquipEffect_t.AttrType[13],
    AttrRate = Table_EquipEffect_t.AttrRate[10],
    Dsc = "##312072"
  },
  [42171003] = {
    id = 42171003,
    EquipID = 42171,
    AttrType = Table_EquipEffect_t.AttrType[27],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##312088"
  },
  [42171004] = {
    id = 42171004,
    EquipID = 42171,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[10]
  },
  [42171005] = {
    id = 42171005,
    EquipID = 42171,
    AttrType = Table_EquipEffect_t.AttrType[29],
    AttrRate = Table_EquipEffect_t.AttrRate[30],
    Dsc = "##1123393"
  },
  [42171006] = {
    id = 42171006,
    EquipID = 42171,
    AttrType = Table_EquipEffect_t.AttrType[37],
    AttrRate = Table_EquipEffect_t.AttrRate[20],
    Dsc = "##1123642"
  },
  [42171007] = {
    id = 42171007,
    EquipID = 42171,
    GroupID = 2,
    AttrType = Table_EquipEffect_t.AttrType[2],
    AttrRate = Table_EquipEffect_t.AttrRate[2],
    Dsc = "##1211215"
  },
  [42176001] = {
    id = 42176001,
    EquipID = 42176,
    AttrType = Table_EquipEffect_t.AttrType[34],
    AttrRate = Table_EquipEffect_t.AttrRate[31],
    Dsc = "##1123381"
  },
  [42176002] = {
    id = 42176002,
    EquipID = 42176,
    AttrType = Table_EquipEffect_t.AttrType[13],
    AttrRate = Table_EquipEffect_t.AttrRate[10],
    Dsc = "##312072"
  },
  [42176003] = {
    id = 42176003,
    EquipID = 42176,
    AttrType = Table_EquipEffect_t.AttrType[27],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##312088"
  },
  [42176004] = {
    id = 42176004,
    EquipID = 42176,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[10]
  },
  [42176005] = {
    id = 42176005,
    EquipID = 42176,
    AttrType = Table_EquipEffect_t.AttrType[29],
    AttrRate = Table_EquipEffect_t.AttrRate[30],
    Dsc = "##1123393"
  },
  [42176006] = {
    id = 42176006,
    EquipID = 42176,
    AttrType = Table_EquipEffect_t.AttrType[37],
    AttrRate = Table_EquipEffect_t.AttrRate[20],
    Dsc = "##1123642"
  },
  [42177001] = {
    id = 42177001,
    EquipID = 42177,
    AttrType = Table_EquipEffect_t.AttrType[34],
    AttrRate = Table_EquipEffect_t.AttrRate[31],
    Dsc = "##1123381"
  },
  [42177002] = {
    id = 42177002,
    EquipID = 42177,
    AttrType = Table_EquipEffect_t.AttrType[13],
    AttrRate = Table_EquipEffect_t.AttrRate[10],
    Dsc = "##312072"
  },
  [42177003] = {
    id = 42177003,
    EquipID = 42177,
    AttrType = Table_EquipEffect_t.AttrType[27],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##312088"
  },
  [42177004] = {
    id = 42177004,
    EquipID = 42177,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[10]
  },
  [42177005] = {
    id = 42177005,
    EquipID = 42177,
    AttrType = Table_EquipEffect_t.AttrType[29],
    AttrRate = Table_EquipEffect_t.AttrRate[30],
    Dsc = "##1123393"
  },
  [42177006] = {
    id = 42177006,
    EquipID = 42177,
    AttrType = Table_EquipEffect_t.AttrType[37],
    AttrRate = Table_EquipEffect_t.AttrRate[20],
    Dsc = "##1123642"
  },
  [42177007] = {
    id = 42177007,
    EquipID = 42177,
    GroupID = 2,
    AttrType = Table_EquipEffect_t.AttrType[2],
    AttrRate = Table_EquipEffect_t.AttrRate[2],
    Dsc = "##1211215"
  },
  [42179001] = {
    id = 42179001,
    EquipID = 42179,
    AttrType = Table_EquipEffect_t.AttrType[33],
    AttrRate = Table_EquipEffect_t.AttrRate[9],
    Dsc = "##1123666"
  },
  [42179002] = {
    id = 42179002,
    EquipID = 42179,
    AttrType = Table_EquipEffect_t.AttrType[13],
    AttrRate = Table_EquipEffect_t.AttrRate[10],
    Dsc = "##312072"
  },
  [42179003] = {
    id = 42179003,
    EquipID = 42179,
    AttrType = Table_EquipEffect_t.AttrType[27],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##312088"
  },
  [42179004] = {
    id = 42179004,
    EquipID = 42179,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[10]
  },
  [42179005] = {
    id = 42179005,
    EquipID = 42179,
    AttrType = Table_EquipEffect_t.AttrType[29],
    AttrRate = Table_EquipEffect_t.AttrRate[30],
    Dsc = "##1123393"
  },
  [42179006] = {
    id = 42179006,
    EquipID = 42179,
    AttrType = Table_EquipEffect_t.AttrType[37],
    AttrRate = Table_EquipEffect_t.AttrRate[20],
    Dsc = "##1123642"
  },
  [42180001] = {
    id = 42180001,
    EquipID = 42180,
    AttrType = Table_EquipEffect_t.AttrType[33],
    AttrRate = Table_EquipEffect_t.AttrRate[9],
    Dsc = "##1123666"
  },
  [42180002] = {
    id = 42180002,
    EquipID = 42180,
    AttrType = Table_EquipEffect_t.AttrType[13],
    AttrRate = Table_EquipEffect_t.AttrRate[10],
    Dsc = "##312072"
  },
  [42180003] = {
    id = 42180003,
    EquipID = 42180,
    AttrType = Table_EquipEffect_t.AttrType[27],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##312088"
  },
  [42180004] = {
    id = 42180004,
    EquipID = 42180,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[10]
  },
  [42180005] = {
    id = 42180005,
    EquipID = 42180,
    AttrType = Table_EquipEffect_t.AttrType[29],
    AttrRate = Table_EquipEffect_t.AttrRate[30],
    Dsc = "##1123393"
  },
  [42180006] = {
    id = 42180006,
    EquipID = 42180,
    AttrType = Table_EquipEffect_t.AttrType[37],
    AttrRate = Table_EquipEffect_t.AttrRate[20],
    Dsc = "##1123642"
  },
  [42180007] = {
    id = 42180007,
    EquipID = 42180,
    GroupID = 2,
    AttrType = Table_EquipEffect_t.AttrType[2],
    AttrRate = Table_EquipEffect_t.AttrRate[2],
    Dsc = "##1211215"
  },
  [42185001] = {
    id = 42185001,
    EquipID = 42185,
    AttrType = Table_EquipEffect_t.AttrType[22],
    AttrRate = Table_EquipEffect_t.AttrRate[25],
    Dsc = "##312087"
  },
  [42186001] = {
    id = 42186001,
    EquipID = 42186,
    AttrType = Table_EquipEffect_t.AttrType[3],
    AttrRate = Table_EquipEffect_t.AttrRate[25],
    Dsc = "##1110946"
  },
  [42187001] = {
    id = 42187001,
    EquipID = 42187,
    AttrType = Table_EquipEffect_t.AttrType[18],
    AttrRate = Table_EquipEffect_t.AttrRate[25],
    Dsc = "##1123327"
  },
  [42188001] = {
    id = 42188001,
    EquipID = 42188,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[25]
  },
  [42189001] = {
    id = 42189001,
    EquipID = 42189,
    AttrType = Table_EquipEffect_t.AttrType[23],
    AttrRate = Table_EquipEffect_t.AttrRate[19],
    Dsc = "##312079"
  },
  [42609001] = {
    id = 42609001,
    EquipID = 42609,
    AttrType = Table_EquipEffect_t.AttrType[18],
    AttrRate = Table_EquipEffect_t.AttrRate[18],
    Dsc = "##1123327"
  },
  [42609002] = {
    id = 42609002,
    EquipID = 42609,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123328"
  },
  [42609003] = {
    id = 42609003,
    EquipID = 42609,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123329"
  },
  [42609004] = {
    id = 42609004,
    EquipID = 42609,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[13]
  },
  [42609005] = {
    id = 42609005,
    EquipID = 42609,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[14],
    Dsc = "##1123330"
  },
  [42609006] = {
    id = 42609006,
    EquipID = 42609,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[14],
    Dsc = "##1123331"
  },
  [42610001] = {
    id = 42610001,
    EquipID = 42610,
    AttrType = Table_EquipEffect_t.AttrType[18],
    AttrRate = Table_EquipEffect_t.AttrRate[18],
    Dsc = "##1123327"
  },
  [42610002] = {
    id = 42610002,
    EquipID = 42610,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123328"
  },
  [42610003] = {
    id = 42610003,
    EquipID = 42610,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123329"
  },
  [42610004] = {
    id = 42610004,
    EquipID = 42610,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[13]
  },
  [42610005] = {
    id = 42610005,
    EquipID = 42610,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[14],
    Dsc = "##1123330"
  },
  [42610006] = {
    id = 42610006,
    EquipID = 42610,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[14],
    Dsc = "##1123331"
  },
  [42610007] = {
    id = 42610007,
    EquipID = 42610,
    GroupID = 2,
    AttrType = Table_EquipEffect_t.AttrType[2],
    AttrRate = Table_EquipEffect_t.AttrRate[2],
    Dsc = "##1211215"
  },
  [42625001] = {
    id = 42625001,
    EquipID = 42625,
    AttrType = Table_EquipEffect_t.AttrType[3],
    AttrRate = Table_EquipEffect_t.AttrRate[18],
    Dsc = "##1110946"
  },
  [42625002] = {
    id = 42625002,
    EquipID = 42625,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123328"
  },
  [42625003] = {
    id = 42625003,
    EquipID = 42625,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123329"
  },
  [42625004] = {
    id = 42625004,
    EquipID = 42625,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[13]
  },
  [42625005] = {
    id = 42625005,
    EquipID = 42625,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[14],
    Dsc = "##1123330"
  },
  [42625006] = {
    id = 42625006,
    EquipID = 42625,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[14],
    Dsc = "##1123331"
  },
  [42626001] = {
    id = 42626001,
    EquipID = 42626,
    AttrType = Table_EquipEffect_t.AttrType[3],
    AttrRate = Table_EquipEffect_t.AttrRate[18],
    Dsc = "##1110946"
  },
  [42626002] = {
    id = 42626002,
    EquipID = 42626,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123328"
  },
  [42626003] = {
    id = 42626003,
    EquipID = 42626,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123329"
  },
  [42626004] = {
    id = 42626004,
    EquipID = 42626,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[13]
  },
  [42626005] = {
    id = 42626005,
    EquipID = 42626,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[14],
    Dsc = "##1123330"
  },
  [42626006] = {
    id = 42626006,
    EquipID = 42626,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[14],
    Dsc = "##1123331"
  },
  [42626007] = {
    id = 42626007,
    EquipID = 42626,
    GroupID = 2,
    AttrType = Table_EquipEffect_t.AttrType[2],
    AttrRate = Table_EquipEffect_t.AttrRate[2],
    Dsc = "##1211215"
  },
  [42628001] = {
    id = 42628001,
    EquipID = 42628,
    AttrType = Table_EquipEffect_t.AttrType[3],
    AttrRate = Table_EquipEffect_t.AttrRate[18],
    Dsc = "##1110946"
  },
  [42628002] = {
    id = 42628002,
    EquipID = 42628,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123328"
  },
  [42628003] = {
    id = 42628003,
    EquipID = 42628,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123329"
  },
  [42628004] = {
    id = 42628004,
    EquipID = 42628,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[13]
  },
  [42628005] = {
    id = 42628005,
    EquipID = 42628,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[14],
    Dsc = "##1123330"
  },
  [42628006] = {
    id = 42628006,
    EquipID = 42628,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[14],
    Dsc = "##1123331"
  },
  [42629001] = {
    id = 42629001,
    EquipID = 42629,
    AttrType = Table_EquipEffect_t.AttrType[3],
    AttrRate = Table_EquipEffect_t.AttrRate[18],
    Dsc = "##1110946"
  },
  [42629002] = {
    id = 42629002,
    EquipID = 42629,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123328"
  },
  [42629003] = {
    id = 42629003,
    EquipID = 42629,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123329"
  },
  [42629004] = {
    id = 42629004,
    EquipID = 42629,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[13]
  },
  [42629005] = {
    id = 42629005,
    EquipID = 42629,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[14],
    Dsc = "##1123330"
  },
  [42629006] = {
    id = 42629006,
    EquipID = 42629,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[14],
    Dsc = "##1123331"
  },
  [42629007] = {
    id = 42629007,
    EquipID = 42629,
    GroupID = 2,
    AttrType = Table_EquipEffect_t.AttrType[2],
    AttrRate = Table_EquipEffect_t.AttrRate[2],
    Dsc = "##1211215"
  },
  [42631001] = {
    id = 42631001,
    EquipID = 42631,
    AttrType = Table_EquipEffect_t.AttrType[19],
    AttrRate = Table_EquipEffect_t.AttrRate[15],
    Dsc = "##312089"
  },
  [42631002] = {
    id = 42631002,
    EquipID = 42631,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123328"
  },
  [42631003] = {
    id = 42631003,
    EquipID = 42631,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123329"
  },
  [42631004] = {
    id = 42631004,
    EquipID = 42631,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[13]
  },
  [42631005] = {
    id = 42631005,
    EquipID = 42631,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[14],
    Dsc = "##1123330"
  },
  [42631006] = {
    id = 42631006,
    EquipID = 42631,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[14],
    Dsc = "##1123331"
  },
  [42632001] = {
    id = 42632001,
    EquipID = 42632,
    AttrType = Table_EquipEffect_t.AttrType[19],
    AttrRate = Table_EquipEffect_t.AttrRate[15],
    Dsc = "##312089"
  },
  [42632002] = {
    id = 42632002,
    EquipID = 42632,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123328"
  },
  [42632003] = {
    id = 42632003,
    EquipID = 42632,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123329"
  },
  [42632004] = {
    id = 42632004,
    EquipID = 42632,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[13]
  },
  [42632005] = {
    id = 42632005,
    EquipID = 42632,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[14],
    Dsc = "##1123330"
  },
  [42632006] = {
    id = 42632006,
    EquipID = 42632,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[14],
    Dsc = "##1123331"
  },
  [42632007] = {
    id = 42632007,
    EquipID = 42632,
    GroupID = 2,
    AttrType = Table_EquipEffect_t.AttrType[2],
    AttrRate = Table_EquipEffect_t.AttrRate[2],
    Dsc = "##1211215"
  },
  [42634001] = {
    id = 42634001,
    EquipID = 42634,
    AttrType = Table_EquipEffect_t.AttrType[16],
    AttrRate = Table_EquipEffect_t.AttrRate[15],
    Dsc = "##312078"
  },
  [42634002] = {
    id = 42634002,
    EquipID = 42634,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123328"
  },
  [42634003] = {
    id = 42634003,
    EquipID = 42634,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123329"
  },
  [42634004] = {
    id = 42634004,
    EquipID = 42634,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[13]
  },
  [42634005] = {
    id = 42634005,
    EquipID = 42634,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[14],
    Dsc = "##1123330"
  },
  [42634006] = {
    id = 42634006,
    EquipID = 42634,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[14],
    Dsc = "##1123331"
  },
  [42635001] = {
    id = 42635001,
    EquipID = 42635,
    AttrType = Table_EquipEffect_t.AttrType[16],
    AttrRate = Table_EquipEffect_t.AttrRate[15],
    Dsc = "##312078"
  },
  [42635002] = {
    id = 42635002,
    EquipID = 42635,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123328"
  },
  [42635003] = {
    id = 42635003,
    EquipID = 42635,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123329"
  },
  [42635004] = {
    id = 42635004,
    EquipID = 42635,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[13]
  },
  [42635005] = {
    id = 42635005,
    EquipID = 42635,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[14],
    Dsc = "##1123330"
  },
  [42635006] = {
    id = 42635006,
    EquipID = 42635,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[14],
    Dsc = "##1123331"
  },
  [42635007] = {
    id = 42635007,
    EquipID = 42635,
    GroupID = 2,
    AttrType = Table_EquipEffect_t.AttrType[2],
    AttrRate = Table_EquipEffect_t.AttrRate[2],
    Dsc = "##1211215"
  },
  [42637001] = {
    id = 42637001,
    EquipID = 42637,
    AttrType = Table_EquipEffect_t.AttrType[14],
    AttrRate = Table_EquipEffect_t.AttrRate[11],
    Dsc = "##1123348"
  },
  [42637002] = {
    id = 42637002,
    EquipID = 42637,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123328"
  },
  [42637003] = {
    id = 42637003,
    EquipID = 42637,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123329"
  },
  [42637004] = {
    id = 42637004,
    EquipID = 42637,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[13]
  },
  [42637005] = {
    id = 42637005,
    EquipID = 42637,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[14],
    Dsc = "##1123330"
  },
  [42637006] = {
    id = 42637006,
    EquipID = 42637,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[14],
    Dsc = "##1123331"
  },
  [42638001] = {
    id = 42638001,
    EquipID = 42638,
    AttrType = Table_EquipEffect_t.AttrType[14],
    AttrRate = Table_EquipEffect_t.AttrRate[11],
    Dsc = "##1123348"
  },
  [42638002] = {
    id = 42638002,
    EquipID = 42638,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123328"
  },
  [42638003] = {
    id = 42638003,
    EquipID = 42638,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123329"
  },
  [42638004] = {
    id = 42638004,
    EquipID = 42638,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[13]
  },
  [42638005] = {
    id = 42638005,
    EquipID = 42638,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[14],
    Dsc = "##1123330"
  },
  [42638006] = {
    id = 42638006,
    EquipID = 42638,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[14],
    Dsc = "##1123331"
  },
  [42638007] = {
    id = 42638007,
    EquipID = 42638,
    GroupID = 2,
    AttrType = Table_EquipEffect_t.AttrType[2],
    AttrRate = Table_EquipEffect_t.AttrRate[2],
    Dsc = "##1211215"
  },
  [42640001] = {
    id = 42640001,
    EquipID = 42640,
    AttrType = Table_EquipEffect_t.AttrType[12],
    AttrRate = Table_EquipEffect_t.AttrRate[18],
    Dsc = "##1123353"
  },
  [42640002] = {
    id = 42640002,
    EquipID = 42640,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123328"
  },
  [42640003] = {
    id = 42640003,
    EquipID = 42640,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123329"
  },
  [42640004] = {
    id = 42640004,
    EquipID = 42640,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[13]
  },
  [42640005] = {
    id = 42640005,
    EquipID = 42640,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[14],
    Dsc = "##1123330"
  },
  [42640006] = {
    id = 42640006,
    EquipID = 42640,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[14],
    Dsc = "##1123331"
  },
  [42641001] = {
    id = 42641001,
    EquipID = 42641,
    AttrType = Table_EquipEffect_t.AttrType[12],
    AttrRate = Table_EquipEffect_t.AttrRate[18],
    Dsc = "##1123353"
  },
  [42641002] = {
    id = 42641002,
    EquipID = 42641,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123328"
  },
  [42641003] = {
    id = 42641003,
    EquipID = 42641,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123329"
  },
  [42641004] = {
    id = 42641004,
    EquipID = 42641,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[13]
  },
  [42641005] = {
    id = 42641005,
    EquipID = 42641,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[14],
    Dsc = "##1123330"
  },
  [42641006] = {
    id = 42641006,
    EquipID = 42641,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[14],
    Dsc = "##1123331"
  },
  [42641007] = {
    id = 42641007,
    EquipID = 42641,
    GroupID = 2,
    AttrType = Table_EquipEffect_t.AttrType[2],
    AttrRate = Table_EquipEffect_t.AttrRate[2],
    Dsc = "##1211215"
  },
  [42643001] = {
    id = 42643001,
    EquipID = 42643,
    AttrType = Table_EquipEffect_t.AttrType[26],
    AttrRate = Table_EquipEffect_t.AttrRate[15],
    Dsc = "##312080"
  },
  [42643002] = {
    id = 42643002,
    EquipID = 42643,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123328"
  },
  [42643003] = {
    id = 42643003,
    EquipID = 42643,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123329"
  },
  [42643004] = {
    id = 42643004,
    EquipID = 42643,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[13]
  },
  [42643005] = {
    id = 42643005,
    EquipID = 42643,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[14],
    Dsc = "##1123330"
  },
  [42643006] = {
    id = 42643006,
    EquipID = 42643,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[14],
    Dsc = "##1123331"
  },
  [42644001] = {
    id = 42644001,
    EquipID = 42644,
    AttrType = Table_EquipEffect_t.AttrType[26],
    AttrRate = Table_EquipEffect_t.AttrRate[15],
    Dsc = "##312080"
  },
  [42644002] = {
    id = 42644002,
    EquipID = 42644,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123328"
  },
  [42644003] = {
    id = 42644003,
    EquipID = 42644,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123329"
  },
  [42644004] = {
    id = 42644004,
    EquipID = 42644,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[13]
  },
  [42644005] = {
    id = 42644005,
    EquipID = 42644,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[14],
    Dsc = "##1123330"
  },
  [42644006] = {
    id = 42644006,
    EquipID = 42644,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[14],
    Dsc = "##1123331"
  },
  [42644007] = {
    id = 42644007,
    EquipID = 42644,
    GroupID = 2,
    AttrType = Table_EquipEffect_t.AttrType[2],
    AttrRate = Table_EquipEffect_t.AttrRate[2],
    Dsc = "##1211215"
  },
  [42646001] = {
    id = 42646001,
    EquipID = 42646,
    AttrType = Table_EquipEffect_t.AttrType[17],
    AttrRate = Table_EquipEffect_t.AttrRate[18],
    Dsc = "##1110947"
  },
  [42646002] = {
    id = 42646002,
    EquipID = 42646,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123328"
  },
  [42646003] = {
    id = 42646003,
    EquipID = 42646,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123329"
  },
  [42646004] = {
    id = 42646004,
    EquipID = 42646,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[13]
  },
  [42646005] = {
    id = 42646005,
    EquipID = 42646,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[14],
    Dsc = "##1123330"
  },
  [42646006] = {
    id = 42646006,
    EquipID = 42646,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[14],
    Dsc = "##1123331"
  },
  [42647001] = {
    id = 42647001,
    EquipID = 42647,
    AttrType = Table_EquipEffect_t.AttrType[17],
    AttrRate = Table_EquipEffect_t.AttrRate[18],
    Dsc = "##1110947"
  },
  [42647002] = {
    id = 42647002,
    EquipID = 42647,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123328"
  },
  [42647003] = {
    id = 42647003,
    EquipID = 42647,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123329"
  },
  [42647004] = {
    id = 42647004,
    EquipID = 42647,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[13]
  },
  [42647005] = {
    id = 42647005,
    EquipID = 42647,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[14],
    Dsc = "##1123330"
  },
  [42647006] = {
    id = 42647006,
    EquipID = 42647,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[14],
    Dsc = "##1123331"
  },
  [42647007] = {
    id = 42647007,
    EquipID = 42647,
    GroupID = 2,
    AttrType = Table_EquipEffect_t.AttrType[2],
    AttrRate = Table_EquipEffect_t.AttrRate[2],
    Dsc = "##1211215"
  },
  [42649001] = {
    id = 42649001,
    EquipID = 42649,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[18]
  },
  [42649002] = {
    id = 42649002,
    EquipID = 42649,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123328"
  },
  [42649003] = {
    id = 42649003,
    EquipID = 42649,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123329"
  },
  [42649004] = {
    id = 42649004,
    EquipID = 42649,
    AttrType = Table_EquipEffect_t.AttrType[38],
    AttrRate = Table_EquipEffect_t.AttrRate[30],
    Dsc = "##1123368"
  },
  [42649005] = {
    id = 42649005,
    EquipID = 42649,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[14],
    Dsc = "##1123330"
  },
  [42649006] = {
    id = 42649006,
    EquipID = 42649,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[14],
    Dsc = "##1123331"
  },
  [42650001] = {
    id = 42650001,
    EquipID = 42650,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[18]
  },
  [42650002] = {
    id = 42650002,
    EquipID = 42650,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123328"
  },
  [42650003] = {
    id = 42650003,
    EquipID = 42650,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123329"
  },
  [42650004] = {
    id = 42650004,
    EquipID = 42650,
    AttrType = Table_EquipEffect_t.AttrType[38],
    AttrRate = Table_EquipEffect_t.AttrRate[30],
    Dsc = "##1123368"
  },
  [42650005] = {
    id = 42650005,
    EquipID = 42650,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[14],
    Dsc = "##1123330"
  },
  [42650006] = {
    id = 42650006,
    EquipID = 42650,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[14],
    Dsc = "##1123331"
  },
  [42650007] = {
    id = 42650007,
    EquipID = 42650,
    GroupID = 2,
    AttrType = Table_EquipEffect_t.AttrType[2],
    AttrRate = Table_EquipEffect_t.AttrRate[2],
    Dsc = "##1211215"
  },
  [42652001] = {
    id = 42652001,
    EquipID = 42652,
    AttrType = Table_EquipEffect_t.AttrType[31],
    AttrRate = Table_EquipEffect_t.AttrRate[24],
    Dsc = "##1123371"
  },
  [42652002] = {
    id = 42652002,
    EquipID = 42652,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123328"
  },
  [42652003] = {
    id = 42652003,
    EquipID = 42652,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123329"
  },
  [42652004] = {
    id = 42652004,
    EquipID = 42652,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[13]
  },
  [42652005] = {
    id = 42652005,
    EquipID = 42652,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[14],
    Dsc = "##1123330"
  },
  [42652006] = {
    id = 42652006,
    EquipID = 42652,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[14],
    Dsc = "##1123331"
  },
  [42653001] = {
    id = 42653001,
    EquipID = 42653,
    AttrType = Table_EquipEffect_t.AttrType[31],
    AttrRate = Table_EquipEffect_t.AttrRate[24],
    Dsc = "##1123371"
  },
  [42653002] = {
    id = 42653002,
    EquipID = 42653,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123328"
  },
  [42653003] = {
    id = 42653003,
    EquipID = 42653,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123329"
  },
  [42653004] = {
    id = 42653004,
    EquipID = 42653,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[13]
  },
  [42653005] = {
    id = 42653005,
    EquipID = 42653,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[14],
    Dsc = "##1123330"
  },
  [42653006] = {
    id = 42653006,
    EquipID = 42653,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[14],
    Dsc = "##1123331"
  },
  [42653007] = {
    id = 42653007,
    EquipID = 42653,
    GroupID = 2,
    AttrType = Table_EquipEffect_t.AttrType[2],
    AttrRate = Table_EquipEffect_t.AttrRate[2],
    Dsc = "##1211215"
  },
  [42655001] = {
    id = 42655001,
    EquipID = 42655,
    AttrType = Table_EquipEffect_t.AttrType[35],
    AttrRate = Table_EquipEffect_t.AttrRate[24],
    Dsc = "##1123376"
  },
  [42655002] = {
    id = 42655002,
    EquipID = 42655,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123328"
  },
  [42655003] = {
    id = 42655003,
    EquipID = 42655,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123329"
  },
  [42655004] = {
    id = 42655004,
    EquipID = 42655,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[13]
  },
  [42655005] = {
    id = 42655005,
    EquipID = 42655,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[14],
    Dsc = "##1123330"
  },
  [42655006] = {
    id = 42655006,
    EquipID = 42655,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[14],
    Dsc = "##1123331"
  },
  [42656001] = {
    id = 42656001,
    EquipID = 42656,
    AttrType = Table_EquipEffect_t.AttrType[35],
    AttrRate = Table_EquipEffect_t.AttrRate[24],
    Dsc = "##1123376"
  },
  [42656002] = {
    id = 42656002,
    EquipID = 42656,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123328"
  },
  [42656003] = {
    id = 42656003,
    EquipID = 42656,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123329"
  },
  [42656004] = {
    id = 42656004,
    EquipID = 42656,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[13]
  },
  [42656005] = {
    id = 42656005,
    EquipID = 42656,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[14],
    Dsc = "##1123330"
  },
  [42656006] = {
    id = 42656006,
    EquipID = 42656,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[14],
    Dsc = "##1123331"
  },
  [42656007] = {
    id = 42656007,
    EquipID = 42656,
    GroupID = 2,
    AttrType = Table_EquipEffect_t.AttrType[2],
    AttrRate = Table_EquipEffect_t.AttrRate[2],
    Dsc = "##1211215"
  },
  [42658001] = {
    id = 42658001,
    EquipID = 42658,
    AttrType = Table_EquipEffect_t.AttrType[34],
    AttrRate = Table_EquipEffect_t.AttrRate[24],
    Dsc = "##1123381"
  },
  [42658002] = {
    id = 42658002,
    EquipID = 42658,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123328"
  },
  [42658003] = {
    id = 42658003,
    EquipID = 42658,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123329"
  },
  [42658004] = {
    id = 42658004,
    EquipID = 42658,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[13]
  },
  [42658005] = {
    id = 42658005,
    EquipID = 42658,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[14],
    Dsc = "##1123330"
  },
  [42658006] = {
    id = 42658006,
    EquipID = 42658,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[14],
    Dsc = "##1123331"
  },
  [42659001] = {
    id = 42659001,
    EquipID = 42659,
    AttrType = Table_EquipEffect_t.AttrType[34],
    AttrRate = Table_EquipEffect_t.AttrRate[24],
    Dsc = "##1123381"
  },
  [42659002] = {
    id = 42659002,
    EquipID = 42659,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123328"
  },
  [42659003] = {
    id = 42659003,
    EquipID = 42659,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123329"
  },
  [42659004] = {
    id = 42659004,
    EquipID = 42659,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[13]
  },
  [42659005] = {
    id = 42659005,
    EquipID = 42659,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[14],
    Dsc = "##1123330"
  },
  [42659006] = {
    id = 42659006,
    EquipID = 42659,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[14],
    Dsc = "##1123331"
  },
  [42659007] = {
    id = 42659007,
    EquipID = 42659,
    GroupID = 2,
    AttrType = Table_EquipEffect_t.AttrType[2],
    AttrRate = Table_EquipEffect_t.AttrRate[2],
    Dsc = "##1211215"
  },
  [42661001] = {
    id = 42661001,
    EquipID = 42661,
    AttrType = Table_EquipEffect_t.AttrType[32],
    AttrRate = Table_EquipEffect_t.AttrRate[24],
    Dsc = "##1123386"
  },
  [42661002] = {
    id = 42661002,
    EquipID = 42661,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123328"
  },
  [42661003] = {
    id = 42661003,
    EquipID = 42661,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123329"
  },
  [42661004] = {
    id = 42661004,
    EquipID = 42661,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[13]
  },
  [42661005] = {
    id = 42661005,
    EquipID = 42661,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[14],
    Dsc = "##1123330"
  },
  [42661006] = {
    id = 42661006,
    EquipID = 42661,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[14],
    Dsc = "##1123331"
  },
  [42662001] = {
    id = 42662001,
    EquipID = 42662,
    AttrType = Table_EquipEffect_t.AttrType[32],
    AttrRate = Table_EquipEffect_t.AttrRate[24],
    Dsc = "##1123386"
  },
  [42662002] = {
    id = 42662002,
    EquipID = 42662,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123328"
  },
  [42662003] = {
    id = 42662003,
    EquipID = 42662,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123329"
  },
  [42662004] = {
    id = 42662004,
    EquipID = 42662,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[13]
  },
  [42662005] = {
    id = 42662005,
    EquipID = 42662,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[14],
    Dsc = "##1123330"
  },
  [42662006] = {
    id = 42662006,
    EquipID = 42662,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[14],
    Dsc = "##1123331"
  },
  [42662007] = {
    id = 42662007,
    EquipID = 42662,
    GroupID = 2,
    AttrType = Table_EquipEffect_t.AttrType[2],
    AttrRate = Table_EquipEffect_t.AttrRate[2],
    Dsc = "##1211215"
  },
  [42664001] = {
    id = 42664001,
    EquipID = 42664,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[18]
  },
  [42664002] = {
    id = 42664002,
    EquipID = 42664,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123328"
  },
  [42664003] = {
    id = 42664003,
    EquipID = 42664,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123329"
  },
  [42664004] = {
    id = 42664004,
    EquipID = 42664,
    AttrType = Table_EquipEffect_t.AttrType[29],
    AttrRate = Table_EquipEffect_t.AttrRate[26],
    Dsc = "##1123393"
  },
  [42664005] = {
    id = 42664005,
    EquipID = 42664,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[14],
    Dsc = "##1123330"
  },
  [42664006] = {
    id = 42664006,
    EquipID = 42664,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[14],
    Dsc = "##1123331"
  },
  [42665001] = {
    id = 42665001,
    EquipID = 42665,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[18]
  },
  [42665002] = {
    id = 42665002,
    EquipID = 42665,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123328"
  },
  [42665003] = {
    id = 42665003,
    EquipID = 42665,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123329"
  },
  [42665004] = {
    id = 42665004,
    EquipID = 42665,
    AttrType = Table_EquipEffect_t.AttrType[29],
    AttrRate = Table_EquipEffect_t.AttrRate[26],
    Dsc = "##1123393"
  },
  [42665005] = {
    id = 42665005,
    EquipID = 42665,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[14],
    Dsc = "##1123330"
  },
  [42665006] = {
    id = 42665006,
    EquipID = 42665,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[14],
    Dsc = "##1123331"
  },
  [42665007] = {
    id = 42665007,
    EquipID = 42665,
    GroupID = 2,
    AttrType = Table_EquipEffect_t.AttrType[2],
    AttrRate = Table_EquipEffect_t.AttrRate[2],
    Dsc = "##1211215"
  },
  [42667001] = {
    id = 42667001,
    EquipID = 42667,
    AttrType = Table_EquipEffect_t.AttrType[21],
    AttrRate = Table_EquipEffect_t.AttrRate[15],
    Dsc = "##312074"
  },
  [42667002] = {
    id = 42667002,
    EquipID = 42667,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123328"
  },
  [42667003] = {
    id = 42667003,
    EquipID = 42667,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123329"
  },
  [42667004] = {
    id = 42667004,
    EquipID = 42667,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[13]
  },
  [42667005] = {
    id = 42667005,
    EquipID = 42667,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[14],
    Dsc = "##1123330"
  },
  [42667006] = {
    id = 42667006,
    EquipID = 42667,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[14],
    Dsc = "##1123331"
  },
  [42668001] = {
    id = 42668001,
    EquipID = 42668,
    AttrType = Table_EquipEffect_t.AttrType[21],
    AttrRate = Table_EquipEffect_t.AttrRate[15],
    Dsc = "##312074"
  },
  [42668002] = {
    id = 42668002,
    EquipID = 42668,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123328"
  },
  [42668003] = {
    id = 42668003,
    EquipID = 42668,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123329"
  },
  [42668004] = {
    id = 42668004,
    EquipID = 42668,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[13]
  },
  [42668005] = {
    id = 42668005,
    EquipID = 42668,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[14],
    Dsc = "##1123330"
  },
  [42668006] = {
    id = 42668006,
    EquipID = 42668,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[14],
    Dsc = "##1123331"
  },
  [42668007] = {
    id = 42668007,
    EquipID = 42668,
    GroupID = 2,
    AttrType = Table_EquipEffect_t.AttrType[2],
    AttrRate = Table_EquipEffect_t.AttrRate[2],
    Dsc = "##1211215"
  },
  [42673001] = {
    id = 42673001,
    EquipID = 42673,
    AttrType = Table_EquipEffect_t.AttrType[22],
    AttrRate = Table_EquipEffect_t.AttrRate[16],
    Dsc = "##312087"
  },
  [42674001] = {
    id = 42674001,
    EquipID = 42674,
    AttrType = Table_EquipEffect_t.AttrType[19],
    AttrRate = Table_EquipEffect_t.AttrRate[17],
    Dsc = "##312089"
  },
  [42675001] = {
    id = 42675001,
    EquipID = 42675,
    AttrType = Table_EquipEffect_t.AttrType[16],
    AttrRate = Table_EquipEffect_t.AttrRate[17],
    Dsc = "##312078"
  },
  [42676001] = {
    id = 42676001,
    EquipID = 42676,
    AttrType = Table_EquipEffect_t.AttrType[17],
    AttrRate = Table_EquipEffect_t.AttrRate[16],
    Dsc = "##1110947"
  },
  [42677001] = {
    id = 42677001,
    EquipID = 42677,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[16]
  },
  [43071001] = {
    id = 43071001,
    EquipID = 43071,
    AttrType = Table_EquipEffect_t.AttrType[9],
    AttrRate = Table_EquipEffect_t.AttrRate[7],
    Dsc = "##1186390"
  },
  [43071002] = {
    id = 43071002,
    EquipID = 43071,
    AttrType = Table_EquipEffect_t.AttrType[10],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1186391"
  },
  [43071003] = {
    id = 43071003,
    EquipID = 43071,
    AttrType = Table_EquipEffect_t.AttrType[11],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1186392"
  },
  [43071004] = {
    id = 43071004,
    EquipID = 43071,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[1]
  },
  [43071005] = {
    id = 43071005,
    EquipID = 43071,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[8],
    Dsc = "##1123330"
  },
  [43071006] = {
    id = 43071006,
    EquipID = 43071,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[8],
    Dsc = "##1123331"
  },
  [43072001] = {
    id = 43072001,
    EquipID = 43072,
    AttrType = Table_EquipEffect_t.AttrType[9],
    AttrRate = Table_EquipEffect_t.AttrRate[7],
    Dsc = "##1186390"
  },
  [43072002] = {
    id = 43072002,
    EquipID = 43072,
    AttrType = Table_EquipEffect_t.AttrType[10],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1186391"
  },
  [43072003] = {
    id = 43072003,
    EquipID = 43072,
    AttrType = Table_EquipEffect_t.AttrType[11],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1186392"
  },
  [43072004] = {
    id = 43072004,
    EquipID = 43072,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[1]
  },
  [43072005] = {
    id = 43072005,
    EquipID = 43072,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[8],
    Dsc = "##1123330"
  },
  [43072006] = {
    id = 43072006,
    EquipID = 43072,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[8],
    Dsc = "##1123331"
  },
  [43072007] = {
    id = 43072007,
    EquipID = 43072,
    GroupID = 2,
    AttrType = Table_EquipEffect_t.AttrType[2],
    AttrRate = Table_EquipEffect_t.AttrRate[2],
    Dsc = "##1211215"
  },
  [43077001] = {
    id = 43077001,
    EquipID = 43077,
    AttrType = Table_EquipEffect_t.AttrType[30],
    AttrRate = Table_EquipEffect_t.AttrRate[7],
    Dsc = "##1186393"
  },
  [43077002] = {
    id = 43077002,
    EquipID = 43077,
    AttrType = Table_EquipEffect_t.AttrType[10],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1186391"
  },
  [43077003] = {
    id = 43077003,
    EquipID = 43077,
    AttrType = Table_EquipEffect_t.AttrType[11],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1186392"
  },
  [43077004] = {
    id = 43077004,
    EquipID = 43077,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[1]
  },
  [43077005] = {
    id = 43077005,
    EquipID = 43077,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[8],
    Dsc = "##1123330"
  },
  [43077006] = {
    id = 43077006,
    EquipID = 43077,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[8],
    Dsc = "##1123331"
  },
  [43078001] = {
    id = 43078001,
    EquipID = 43078,
    AttrType = Table_EquipEffect_t.AttrType[30],
    AttrRate = Table_EquipEffect_t.AttrRate[7],
    Dsc = "##1186393"
  },
  [43078002] = {
    id = 43078002,
    EquipID = 43078,
    AttrType = Table_EquipEffect_t.AttrType[10],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1186391"
  },
  [43078003] = {
    id = 43078003,
    EquipID = 43078,
    AttrType = Table_EquipEffect_t.AttrType[11],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1186392"
  },
  [43078004] = {
    id = 43078004,
    EquipID = 43078,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[1]
  },
  [43078005] = {
    id = 43078005,
    EquipID = 43078,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[8],
    Dsc = "##1123330"
  },
  [43078006] = {
    id = 43078006,
    EquipID = 43078,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[8],
    Dsc = "##1123331"
  },
  [43078007] = {
    id = 43078007,
    EquipID = 43078,
    GroupID = 2,
    AttrType = Table_EquipEffect_t.AttrType[2],
    AttrRate = Table_EquipEffect_t.AttrRate[2],
    Dsc = "##1211215"
  },
  [43080001] = {
    id = 43080001,
    EquipID = 43080,
    AttrType = Table_EquipEffect_t.AttrType[9],
    AttrRate = Table_EquipEffect_t.AttrRate[7],
    Dsc = "##1186390"
  },
  [43080002] = {
    id = 43080002,
    EquipID = 43080,
    AttrType = Table_EquipEffect_t.AttrType[10],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1186391"
  },
  [43080003] = {
    id = 43080003,
    EquipID = 43080,
    AttrType = Table_EquipEffect_t.AttrType[11],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1186392"
  },
  [43080004] = {
    id = 43080004,
    EquipID = 43080,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[1]
  },
  [43080005] = {
    id = 43080005,
    EquipID = 43080,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[8],
    Dsc = "##1123330"
  },
  [43080006] = {
    id = 43080006,
    EquipID = 43080,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[8],
    Dsc = "##1123331"
  },
  [43081001] = {
    id = 43081001,
    EquipID = 43081,
    AttrType = Table_EquipEffect_t.AttrType[9],
    AttrRate = Table_EquipEffect_t.AttrRate[7],
    Dsc = "##1186390"
  },
  [43081002] = {
    id = 43081002,
    EquipID = 43081,
    AttrType = Table_EquipEffect_t.AttrType[10],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1186391"
  },
  [43081003] = {
    id = 43081003,
    EquipID = 43081,
    AttrType = Table_EquipEffect_t.AttrType[11],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1186392"
  },
  [43081004] = {
    id = 43081004,
    EquipID = 43081,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[1]
  },
  [43081005] = {
    id = 43081005,
    EquipID = 43081,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[8],
    Dsc = "##1123330"
  },
  [43081006] = {
    id = 43081006,
    EquipID = 43081,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[8],
    Dsc = "##1123331"
  },
  [43081007] = {
    id = 43081007,
    EquipID = 43081,
    GroupID = 2,
    AttrType = Table_EquipEffect_t.AttrType[2],
    AttrRate = Table_EquipEffect_t.AttrRate[2],
    Dsc = "##1211215"
  },
  [43083001] = {
    id = 43083001,
    EquipID = 43083,
    AttrType = Table_EquipEffect_t.AttrType[11],
    AttrRate = Table_EquipEffect_t.AttrRate[7],
    Dsc = "##1186392"
  },
  [43083002] = {
    id = 43083002,
    EquipID = 43083,
    AttrType = Table_EquipEffect_t.AttrType[10],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1186391"
  },
  [43083003] = {
    id = 43083003,
    EquipID = 43083,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[10],
    Dsc = "##1123328"
  },
  [43083004] = {
    id = 43083004,
    EquipID = 43083,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[10],
    Dsc = "##1123329"
  },
  [43083005] = {
    id = 43083005,
    EquipID = 43083,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[8],
    Dsc = "##1123330"
  },
  [43083006] = {
    id = 43083006,
    EquipID = 43083,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[8],
    Dsc = "##1123331"
  },
  [43084001] = {
    id = 43084001,
    EquipID = 43084,
    AttrType = Table_EquipEffect_t.AttrType[11],
    AttrRate = Table_EquipEffect_t.AttrRate[7],
    Dsc = "##1186392"
  },
  [43084002] = {
    id = 43084002,
    EquipID = 43084,
    AttrType = Table_EquipEffect_t.AttrType[10],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1186391"
  },
  [43084003] = {
    id = 43084003,
    EquipID = 43084,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[10],
    Dsc = "##1123328"
  },
  [43084004] = {
    id = 43084004,
    EquipID = 43084,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[10],
    Dsc = "##1123329"
  },
  [43084005] = {
    id = 43084005,
    EquipID = 43084,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[8],
    Dsc = "##1123330"
  },
  [43084006] = {
    id = 43084006,
    EquipID = 43084,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[8],
    Dsc = "##1123331"
  },
  [43084007] = {
    id = 43084007,
    EquipID = 43084,
    GroupID = 2,
    AttrType = Table_EquipEffect_t.AttrType[2],
    AttrRate = Table_EquipEffect_t.AttrRate[2],
    Dsc = "##1211215"
  },
  [43086001] = {
    id = 43086001,
    EquipID = 43086,
    AttrType = Table_EquipEffect_t.AttrType[30],
    AttrRate = Table_EquipEffect_t.AttrRate[7],
    Dsc = "##1186393"
  },
  [43086002] = {
    id = 43086002,
    EquipID = 43086,
    AttrType = Table_EquipEffect_t.AttrType[10],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1186391"
  },
  [43086003] = {
    id = 43086003,
    EquipID = 43086,
    AttrType = Table_EquipEffect_t.AttrType[11],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1186392"
  },
  [43086004] = {
    id = 43086004,
    EquipID = 43086,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[1]
  },
  [43086005] = {
    id = 43086005,
    EquipID = 43086,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[8],
    Dsc = "##1123330"
  },
  [43086006] = {
    id = 43086006,
    EquipID = 43086,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[8],
    Dsc = "##1123331"
  },
  [43087001] = {
    id = 43087001,
    EquipID = 43087,
    AttrType = Table_EquipEffect_t.AttrType[30],
    AttrRate = Table_EquipEffect_t.AttrRate[7],
    Dsc = "##1186393"
  },
  [43087002] = {
    id = 43087002,
    EquipID = 43087,
    AttrType = Table_EquipEffect_t.AttrType[10],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1186391"
  },
  [43087003] = {
    id = 43087003,
    EquipID = 43087,
    AttrType = Table_EquipEffect_t.AttrType[11],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1186392"
  },
  [43087004] = {
    id = 43087004,
    EquipID = 43087,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[1]
  },
  [43087005] = {
    id = 43087005,
    EquipID = 43087,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[8],
    Dsc = "##1123330"
  },
  [43087006] = {
    id = 43087006,
    EquipID = 43087,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[8],
    Dsc = "##1123331"
  },
  [43087007] = {
    id = 43087007,
    EquipID = 43087,
    GroupID = 2,
    AttrType = Table_EquipEffect_t.AttrType[2],
    AttrRate = Table_EquipEffect_t.AttrRate[2],
    Dsc = "##1211215"
  },
  [43089001] = {
    id = 43089001,
    EquipID = 43089,
    AttrType = Table_EquipEffect_t.AttrType[11],
    AttrRate = Table_EquipEffect_t.AttrRate[7],
    Dsc = "##1186392"
  },
  [43089002] = {
    id = 43089002,
    EquipID = 43089,
    AttrType = Table_EquipEffect_t.AttrType[10],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1186391"
  },
  [43089003] = {
    id = 43089003,
    EquipID = 43089,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[1]
  },
  [43089004] = {
    id = 43089004,
    EquipID = 43089,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[8],
    Dsc = "##1123330"
  },
  [43089005] = {
    id = 43089005,
    EquipID = 43089,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[8],
    Dsc = "##1123331"
  },
  [43089006] = {
    id = 43089006,
    EquipID = 43089,
    AttrType = Table_EquipEffect_t.AttrType[31],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123371"
  },
  [43090001] = {
    id = 43090001,
    EquipID = 43090,
    AttrType = Table_EquipEffect_t.AttrType[11],
    AttrRate = Table_EquipEffect_t.AttrRate[7],
    Dsc = "##1186392"
  },
  [43090002] = {
    id = 43090002,
    EquipID = 43090,
    AttrType = Table_EquipEffect_t.AttrType[10],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1186391"
  },
  [43090003] = {
    id = 43090003,
    EquipID = 43090,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[1]
  },
  [43090004] = {
    id = 43090004,
    EquipID = 43090,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[8],
    Dsc = "##1123330"
  },
  [43090005] = {
    id = 43090005,
    EquipID = 43090,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[8],
    Dsc = "##1123331"
  },
  [43090006] = {
    id = 43090006,
    EquipID = 43090,
    AttrType = Table_EquipEffect_t.AttrType[31],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123371"
  },
  [43090007] = {
    id = 43090007,
    EquipID = 43090,
    GroupID = 2,
    AttrType = Table_EquipEffect_t.AttrType[2],
    AttrRate = Table_EquipEffect_t.AttrRate[2],
    Dsc = "##1211215"
  },
  [43092001] = {
    id = 43092001,
    EquipID = 43092,
    AttrType = Table_EquipEffect_t.AttrType[11],
    AttrRate = Table_EquipEffect_t.AttrRate[7],
    Dsc = "##1186392"
  },
  [43092002] = {
    id = 43092002,
    EquipID = 43092,
    AttrType = Table_EquipEffect_t.AttrType[10],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1186391"
  },
  [43092003] = {
    id = 43092003,
    EquipID = 43092,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[1]
  },
  [43092004] = {
    id = 43092004,
    EquipID = 43092,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[8],
    Dsc = "##1123330"
  },
  [43092005] = {
    id = 43092005,
    EquipID = 43092,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[8],
    Dsc = "##1123331"
  },
  [43092006] = {
    id = 43092006,
    EquipID = 43092,
    AttrType = Table_EquipEffect_t.AttrType[31],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123371"
  },
  [43093001] = {
    id = 43093001,
    EquipID = 43093,
    AttrType = Table_EquipEffect_t.AttrType[11],
    AttrRate = Table_EquipEffect_t.AttrRate[7],
    Dsc = "##1186392"
  },
  [43093002] = {
    id = 43093002,
    EquipID = 43093,
    AttrType = Table_EquipEffect_t.AttrType[10],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1186391"
  },
  [43093003] = {
    id = 43093003,
    EquipID = 43093,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[1]
  },
  [43093004] = {
    id = 43093004,
    EquipID = 43093,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[8],
    Dsc = "##1123330"
  },
  [43093005] = {
    id = 43093005,
    EquipID = 43093,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[8],
    Dsc = "##1123331"
  },
  [43093006] = {
    id = 43093006,
    EquipID = 43093,
    AttrType = Table_EquipEffect_t.AttrType[31],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123371"
  },
  [43093007] = {
    id = 43093007,
    EquipID = 43093,
    GroupID = 2,
    AttrType = Table_EquipEffect_t.AttrType[2],
    AttrRate = Table_EquipEffect_t.AttrRate[2],
    Dsc = "##1211215"
  },
  [43095001] = {
    id = 43095001,
    EquipID = 43095,
    AttrType = Table_EquipEffect_t.AttrType[11],
    AttrRate = Table_EquipEffect_t.AttrRate[7],
    Dsc = "##1186392"
  },
  [43095002] = {
    id = 43095002,
    EquipID = 43095,
    AttrType = Table_EquipEffect_t.AttrType[10],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1186391"
  },
  [43095003] = {
    id = 43095003,
    EquipID = 43095,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[1]
  },
  [43095004] = {
    id = 43095004,
    EquipID = 43095,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[8],
    Dsc = "##1123330"
  },
  [43095005] = {
    id = 43095005,
    EquipID = 43095,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[8],
    Dsc = "##1123331"
  },
  [43095006] = {
    id = 43095006,
    EquipID = 43095,
    AttrType = Table_EquipEffect_t.AttrType[31],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123371"
  },
  [43096001] = {
    id = 43096001,
    EquipID = 43096,
    AttrType = Table_EquipEffect_t.AttrType[11],
    AttrRate = Table_EquipEffect_t.AttrRate[7],
    Dsc = "##1186392"
  },
  [43096002] = {
    id = 43096002,
    EquipID = 43096,
    AttrType = Table_EquipEffect_t.AttrType[10],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1186391"
  },
  [43096003] = {
    id = 43096003,
    EquipID = 43096,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[1]
  },
  [43096004] = {
    id = 43096004,
    EquipID = 43096,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[8],
    Dsc = "##1123330"
  },
  [43096005] = {
    id = 43096005,
    EquipID = 43096,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[8],
    Dsc = "##1123331"
  },
  [43096006] = {
    id = 43096006,
    EquipID = 43096,
    AttrType = Table_EquipEffect_t.AttrType[31],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123371"
  },
  [43096007] = {
    id = 43096007,
    EquipID = 43096,
    GroupID = 2,
    AttrType = Table_EquipEffect_t.AttrType[2],
    AttrRate = Table_EquipEffect_t.AttrRate[2],
    Dsc = "##1211215"
  },
  [43098001] = {
    id = 43098001,
    EquipID = 43098,
    AttrType = Table_EquipEffect_t.AttrType[9],
    AttrRate = Table_EquipEffect_t.AttrRate[7],
    Dsc = "##1186390"
  },
  [43098002] = {
    id = 43098002,
    EquipID = 43098,
    AttrType = Table_EquipEffect_t.AttrType[10],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1186391"
  },
  [43098003] = {
    id = 43098003,
    EquipID = 43098,
    AttrType = Table_EquipEffect_t.AttrType[11],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1186392"
  },
  [43098004] = {
    id = 43098004,
    EquipID = 43098,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[1]
  },
  [43098005] = {
    id = 43098005,
    EquipID = 43098,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[8],
    Dsc = "##1123330"
  },
  [43098006] = {
    id = 43098006,
    EquipID = 43098,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[8],
    Dsc = "##1123331"
  },
  [43099001] = {
    id = 43099001,
    EquipID = 43099,
    AttrType = Table_EquipEffect_t.AttrType[9],
    AttrRate = Table_EquipEffect_t.AttrRate[7],
    Dsc = "##1186390"
  },
  [43099002] = {
    id = 43099002,
    EquipID = 43099,
    AttrType = Table_EquipEffect_t.AttrType[10],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1186391"
  },
  [43099003] = {
    id = 43099003,
    EquipID = 43099,
    AttrType = Table_EquipEffect_t.AttrType[11],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1186392"
  },
  [43099004] = {
    id = 43099004,
    EquipID = 43099,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[1]
  },
  [43099005] = {
    id = 43099005,
    EquipID = 43099,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[8],
    Dsc = "##1123330"
  },
  [43099006] = {
    id = 43099006,
    EquipID = 43099,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[8],
    Dsc = "##1123331"
  },
  [43099007] = {
    id = 43099007,
    EquipID = 43099,
    GroupID = 2,
    AttrType = Table_EquipEffect_t.AttrType[2],
    AttrRate = Table_EquipEffect_t.AttrRate[2],
    Dsc = "##1211215"
  },
  [43101001] = {
    id = 43101001,
    EquipID = 43101,
    AttrType = Table_EquipEffect_t.AttrType[11],
    AttrRate = Table_EquipEffect_t.AttrRate[27],
    Dsc = "##1186392"
  },
  [43102001] = {
    id = 43102001,
    EquipID = 43102,
    AttrType = Table_EquipEffect_t.AttrType[9],
    AttrRate = Table_EquipEffect_t.AttrRate[27],
    Dsc = "##1186390"
  },
  [43103001] = {
    id = 43103001,
    EquipID = 43103,
    AttrType = Table_EquipEffect_t.AttrType[30],
    AttrRate = Table_EquipEffect_t.AttrRate[27],
    Dsc = "##1186393"
  },
  [43104001] = {
    id = 43104001,
    EquipID = 43104,
    AttrType = Table_EquipEffect_t.AttrType[30],
    AttrRate = Table_EquipEffect_t.AttrRate[27],
    Dsc = "##1186393"
  },
  [43105001] = {
    id = 43105001,
    EquipID = 43105,
    AttrType = Table_EquipEffect_t.AttrType[9],
    AttrRate = Table_EquipEffect_t.AttrRate[27],
    Dsc = "##1186390"
  },
  [43593001] = {
    id = 43593001,
    EquipID = 43593,
    AttrType = Table_EquipEffect_t.AttrType[13],
    AttrRate = Table_EquipEffect_t.AttrRate[28],
    Dsc = "##312072"
  },
  [43593002] = {
    id = 43593002,
    EquipID = 43593,
    AttrType = Table_EquipEffect_t.AttrType[32],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123386"
  },
  [43593003] = {
    id = 43593003,
    EquipID = 43593,
    AttrType = Table_EquipEffect_t.AttrType[34],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123381"
  },
  [43593004] = {
    id = 43593004,
    EquipID = 43593,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[5]
  },
  [43593005] = {
    id = 43593005,
    EquipID = 43593,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123330"
  },
  [43593006] = {
    id = 43593006,
    EquipID = 43593,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123331"
  },
  [43594001] = {
    id = 43594001,
    EquipID = 43594,
    AttrType = Table_EquipEffect_t.AttrType[13],
    AttrRate = Table_EquipEffect_t.AttrRate[28],
    Dsc = "##312072"
  },
  [43594002] = {
    id = 43594002,
    EquipID = 43594,
    AttrType = Table_EquipEffect_t.AttrType[32],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123386"
  },
  [43594003] = {
    id = 43594003,
    EquipID = 43594,
    AttrType = Table_EquipEffect_t.AttrType[34],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123381"
  },
  [43594004] = {
    id = 43594004,
    EquipID = 43594,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[5]
  },
  [43594005] = {
    id = 43594005,
    EquipID = 43594,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123330"
  },
  [43594006] = {
    id = 43594006,
    EquipID = 43594,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123331"
  },
  [43594007] = {
    id = 43594007,
    EquipID = 43594,
    GroupID = 2,
    AttrType = Table_EquipEffect_t.AttrType[2],
    AttrRate = Table_EquipEffect_t.AttrRate[2],
    Dsc = "##1211215"
  },
  [43596001] = {
    id = 43596001,
    EquipID = 43596,
    AttrType = Table_EquipEffect_t.AttrType[17],
    AttrRate = Table_EquipEffect_t.AttrRate[28],
    Dsc = "##1110947"
  },
  [43596002] = {
    id = 43596002,
    EquipID = 43596,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123328"
  },
  [43596003] = {
    id = 43596003,
    EquipID = 43596,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123329"
  },
  [43596004] = {
    id = 43596004,
    EquipID = 43596,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[5]
  },
  [43596005] = {
    id = 43596005,
    EquipID = 43596,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123330"
  },
  [43596006] = {
    id = 43596006,
    EquipID = 43596,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123331"
  },
  [43597001] = {
    id = 43597001,
    EquipID = 43597,
    AttrType = Table_EquipEffect_t.AttrType[17],
    AttrRate = Table_EquipEffect_t.AttrRate[28],
    Dsc = "##1110947"
  },
  [43597002] = {
    id = 43597002,
    EquipID = 43597,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123328"
  },
  [43597003] = {
    id = 43597003,
    EquipID = 43597,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123329"
  },
  [43597004] = {
    id = 43597004,
    EquipID = 43597,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[5]
  },
  [43597005] = {
    id = 43597005,
    EquipID = 43597,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123330"
  },
  [43597006] = {
    EquipID = 43597,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123331"
  },
  [43597007] = {
    id = 43597007,
    EquipID = 43597,
    GroupID = 2,
    AttrType = Table_EquipEffect_t.AttrType[2],
    AttrRate = Table_EquipEffect_t.AttrRate[2],
    Dsc = "##1211215"
  },
  [43599001] = {
    id = 43599001,
    EquipID = 43599,
    AttrType = Table_EquipEffect_t.AttrType[17],
    AttrRate = Table_EquipEffect_t.AttrRate[28],
    Dsc = "##1110947"
  },
  [43599002] = {
    id = 43599002,
    EquipID = 43599,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123328"
  },
  [43599003] = {
    id = 43599003,
    EquipID = 43599,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123329"
  },
  [43599004] = {
    id = 43599004,
    EquipID = 43599,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[5]
  },
  [43599005] = {
    id = 43599005,
    EquipID = 43599,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123330"
  },
  [43599006] = {
    id = 43599006,
    EquipID = 43599,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123331"
  },
  [43600001] = {
    id = 43600001,
    EquipID = 43600,
    AttrType = Table_EquipEffect_t.AttrType[17],
    AttrRate = Table_EquipEffect_t.AttrRate[28],
    Dsc = "##1110947"
  },
  [43600002] = {
    id = 43600002,
    EquipID = 43600,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123328"
  },
  [43600003] = {
    id = 43600003,
    EquipID = 43600,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123329"
  },
  [43600004] = {
    id = 43600004,
    EquipID = 43600,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[5]
  },
  [43600005] = {
    id = 43600005,
    EquipID = 43600,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123330"
  },
  [43600006] = {
    id = 43600006,
    EquipID = 43600,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123331"
  },
  [43600007] = {
    id = 43600007,
    EquipID = 43600,
    GroupID = 2,
    AttrType = Table_EquipEffect_t.AttrType[2],
    AttrRate = Table_EquipEffect_t.AttrRate[2],
    Dsc = "##1211215"
  },
  [43602001] = {
    id = 43602001,
    EquipID = 43602,
    AttrType = Table_EquipEffect_t.AttrType[3],
    AttrRate = Table_EquipEffect_t.AttrRate[28],
    Dsc = "##1110946"
  },
  [43602002] = {
    id = 43602002,
    EquipID = 43602,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123328"
  },
  [43602003] = {
    id = 43602003,
    EquipID = 43602,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123329"
  },
  [43602004] = {
    id = 43602004,
    EquipID = 43602,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[5]
  },
  [43602005] = {
    id = 43602005,
    EquipID = 43602,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123330"
  },
  [43602006] = {
    id = 43602006,
    EquipID = 43602,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123331"
  },
  [43603001] = {
    id = 43603001,
    EquipID = 43603,
    AttrType = Table_EquipEffect_t.AttrType[3],
    AttrRate = Table_EquipEffect_t.AttrRate[28],
    Dsc = "##1110946"
  },
  [43603002] = {
    id = 43603002,
    EquipID = 43603,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123328"
  },
  [43603003] = {
    id = 43603003,
    EquipID = 43603,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123329"
  },
  [43603004] = {
    id = 43603004,
    EquipID = 43603,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[5]
  },
  [43603005] = {
    id = 43603005,
    EquipID = 43603,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123330"
  },
  [43603006] = {
    id = 43603006,
    EquipID = 43603,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123331"
  },
  [43603007] = {
    id = 43603007,
    EquipID = 43603,
    GroupID = 2,
    AttrType = Table_EquipEffect_t.AttrType[2],
    AttrRate = Table_EquipEffect_t.AttrRate[2],
    Dsc = "##1211215"
  },
  [43605001] = {
    id = 43605001,
    EquipID = 43605,
    AttrType = Table_EquipEffect_t.AttrType[18],
    AttrRate = Table_EquipEffect_t.AttrRate[28],
    Dsc = "##1123327"
  },
  [43605002] = {
    id = 43605002,
    EquipID = 43605,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123328"
  },
  [43605003] = {
    id = 43605003,
    EquipID = 43605,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123329"
  },
  [43605004] = {
    id = 43605004,
    EquipID = 43605,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[5]
  },
  [43605005] = {
    id = 43605005,
    EquipID = 43605,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123330"
  },
  [43605006] = {
    id = 43605006,
    EquipID = 43605,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123331"
  },
  [43606001] = {
    id = 43606001,
    EquipID = 43606,
    AttrType = Table_EquipEffect_t.AttrType[18],
    AttrRate = Table_EquipEffect_t.AttrRate[28],
    Dsc = "##1123327"
  },
  [43606002] = {
    id = 43606002,
    EquipID = 43606,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123328"
  },
  [43606003] = {
    id = 43606003,
    EquipID = 43606,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123329"
  },
  [43606004] = {
    id = 43606004,
    EquipID = 43606,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[5]
  },
  [43606005] = {
    id = 43606005,
    EquipID = 43606,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123330"
  },
  [43606006] = {
    id = 43606006,
    EquipID = 43606,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123331"
  },
  [43606007] = {
    id = 43606007,
    EquipID = 43606,
    GroupID = 2,
    AttrType = Table_EquipEffect_t.AttrType[2],
    AttrRate = Table_EquipEffect_t.AttrRate[2],
    Dsc = "##1211215"
  },
  [43608001] = {
    id = 43608001,
    EquipID = 43608,
    AttrType = Table_EquipEffect_t.AttrType[22],
    AttrRate = Table_EquipEffect_t.AttrRate[28],
    Dsc = "##312087"
  },
  [43608002] = {
    id = 43608002,
    EquipID = 43608,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123328"
  },
  [43608003] = {
    id = 43608003,
    EquipID = 43608,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123329"
  },
  [43608004] = {
    id = 43608004,
    EquipID = 43608,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[5]
  },
  [43608005] = {
    id = 43608005,
    EquipID = 43608,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123330"
  },
  [43608006] = {
    id = 43608006,
    EquipID = 43608,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123331"
  },
  [43609001] = {
    id = 43609001,
    EquipID = 43609,
    AttrType = Table_EquipEffect_t.AttrType[22],
    AttrRate = Table_EquipEffect_t.AttrRate[28],
    Dsc = "##312087"
  },
  [43609002] = {
    id = 43609002,
    EquipID = 43609,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123328"
  },
  [43609003] = {
    id = 43609003,
    EquipID = 43609,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123329"
  },
  [43609004] = {
    id = 43609004,
    EquipID = 43609,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[5]
  },
  [43609005] = {
    id = 43609005,
    EquipID = 43609,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123330"
  },
  [43609006] = {
    id = 43609006,
    EquipID = 43609,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123331"
  },
  [43609007] = {
    id = 43609007,
    EquipID = 43609,
    GroupID = 2,
    AttrType = Table_EquipEffect_t.AttrType[2],
    AttrRate = Table_EquipEffect_t.AttrRate[2],
    Dsc = "##1211215"
  },
  [43611001] = {
    id = 43611001,
    EquipID = 43611,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[28]
  },
  [43611002] = {
    id = 43611002,
    EquipID = 43611,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123328"
  },
  [43611003] = {
    id = 43611003,
    EquipID = 43611,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123329"
  },
  [43611004] = {
    id = 43611004,
    EquipID = 43611,
    AttrType = Table_EquipEffect_t.AttrType[33],
    AttrRate = Table_EquipEffect_t.AttrRate[5],
    Dsc = "##1123666"
  },
  [43611005] = {
    id = 43611005,
    EquipID = 43611,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123330"
  },
  [43611006] = {
    id = 43611006,
    EquipID = 43611,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123331"
  },
  [43612001] = {
    id = 43612001,
    EquipID = 43612,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[28]
  },
  [43612002] = {
    id = 43612002,
    EquipID = 43612,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123328"
  },
  [43612003] = {
    id = 43612003,
    EquipID = 43612,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123329"
  },
  [43612004] = {
    id = 43612004,
    EquipID = 43612,
    AttrType = Table_EquipEffect_t.AttrType[33],
    AttrRate = Table_EquipEffect_t.AttrRate[5],
    Dsc = "##1123666"
  },
  [43612005] = {
    id = 43612005,
    EquipID = 43612,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123330"
  },
  [43612006] = {
    id = 43612006,
    EquipID = 43612,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123331"
  },
  [43612007] = {
    id = 43612007,
    EquipID = 43612,
    GroupID = 2,
    AttrType = Table_EquipEffect_t.AttrType[2],
    AttrRate = Table_EquipEffect_t.AttrRate[2],
    Dsc = "##1211215"
  },
  [43614001] = {
    id = 43614001,
    EquipID = 43614,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[28]
  },
  [43614002] = {
    id = 43614002,
    EquipID = 43614,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123328"
  },
  [43614003] = {
    id = 43614003,
    EquipID = 43614,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123329"
  },
  [43614004] = {
    id = 43614004,
    EquipID = 43614,
    AttrType = Table_EquipEffect_t.AttrType[33],
    AttrRate = Table_EquipEffect_t.AttrRate[5],
    Dsc = "##1123666"
  },
  [43614005] = {
    id = 43614005,
    EquipID = 43614,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123330"
  },
  [43614006] = {
    id = 43614006,
    EquipID = 43614,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123331"
  },
  [43615001] = {
    id = 43615001,
    EquipID = 43615,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[28]
  },
  [43615002] = {
    id = 43615002,
    EquipID = 43615,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123328"
  },
  [43615003] = {
    id = 43615003,
    EquipID = 43615,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123329"
  },
  [43615004] = {
    id = 43615004,
    EquipID = 43615,
    AttrType = Table_EquipEffect_t.AttrType[33],
    AttrRate = Table_EquipEffect_t.AttrRate[5],
    Dsc = "##1123666"
  },
  [43615005] = {
    id = 43615005,
    EquipID = 43615,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123330"
  },
  [43615006] = {
    id = 43615006,
    EquipID = 43615,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123331"
  },
  [43615007] = {
    id = 43615007,
    EquipID = 43615,
    GroupID = 2,
    AttrType = Table_EquipEffect_t.AttrType[2],
    AttrRate = Table_EquipEffect_t.AttrRate[2],
    Dsc = "##1211215"
  },
  [43617001] = {
    id = 43617001,
    EquipID = 43617,
    AttrType = Table_EquipEffect_t.AttrType[12],
    AttrRate = Table_EquipEffect_t.AttrRate[28],
    Dsc = "##1123353"
  },
  [43617002] = {
    id = 43617002,
    EquipID = 43617,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123328"
  },
  [43617003] = {
    id = 43617003,
    EquipID = 43617,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123329"
  },
  [43617004] = {
    id = 43617004,
    EquipID = 43617,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[5]
  },
  [43617005] = {
    id = 43617005,
    EquipID = 43617,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123330"
  },
  [43617006] = {
    id = 43617006,
    EquipID = 43617,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123331"
  },
  [43618001] = {
    id = 43618001,
    EquipID = 43618,
    AttrType = Table_EquipEffect_t.AttrType[12],
    AttrRate = Table_EquipEffect_t.AttrRate[28],
    Dsc = "##1123353"
  },
  [43618002] = {
    id = 43618002,
    EquipID = 43618,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123328"
  },
  [43618003] = {
    id = 43618003,
    EquipID = 43618,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123329"
  },
  [43618004] = {
    id = 43618004,
    EquipID = 43618,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[5]
  },
  [43618005] = {
    id = 43618005,
    EquipID = 43618,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123330"
  },
  [43618006] = {
    id = 43618006,
    EquipID = 43618,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123331"
  },
  [43618007] = {
    id = 43618007,
    EquipID = 43618,
    GroupID = 2,
    AttrType = Table_EquipEffect_t.AttrType[2],
    AttrRate = Table_EquipEffect_t.AttrRate[2],
    Dsc = "##1211215"
  },
  [43620001] = {
    id = 43620001,
    EquipID = 43620,
    AttrType = Table_EquipEffect_t.AttrType[3],
    AttrRate = Table_EquipEffect_t.AttrRate[28],
    Dsc = "##1110946"
  },
  [43620002] = {
    id = 43620002,
    EquipID = 43620,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123328"
  },
  [43620003] = {
    id = 43620003,
    EquipID = 43620,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123329"
  },
  [43620004] = {
    id = 43620004,
    EquipID = 43620,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[5]
  },
  [43620005] = {
    id = 43620005,
    EquipID = 43620,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123330"
  },
  [43620006] = {
    id = 43620006,
    EquipID = 43620,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123331"
  },
  [43621001] = {
    id = 43621001,
    EquipID = 43621,
    AttrType = Table_EquipEffect_t.AttrType[3],
    AttrRate = Table_EquipEffect_t.AttrRate[28],
    Dsc = "##1110946"
  },
  [43621002] = {
    id = 43621002,
    EquipID = 43621,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123328"
  },
  [43621003] = {
    id = 43621003,
    EquipID = 43621,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123329"
  },
  [43621004] = {
    id = 43621004,
    EquipID = 43621,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[5]
  },
  [43621005] = {
    id = 43621005,
    EquipID = 43621,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123330"
  },
  [43621006] = {
    id = 43621006,
    EquipID = 43621,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123331"
  },
  [43621007] = {
    id = 43621007,
    EquipID = 43621,
    GroupID = 2,
    AttrType = Table_EquipEffect_t.AttrType[2],
    AttrRate = Table_EquipEffect_t.AttrRate[2],
    Dsc = "##1211215"
  },
  [43623001] = {
    id = 43623001,
    EquipID = 43623,
    AttrType = Table_EquipEffect_t.AttrType[22],
    AttrRate = Table_EquipEffect_t.AttrRate[22],
    Dsc = "##312087"
  },
  [43624001] = {
    id = 43624001,
    EquipID = 43624,
    AttrType = Table_EquipEffect_t.AttrType[17],
    AttrRate = Table_EquipEffect_t.AttrRate[22],
    Dsc = "##1110947"
  },
  [43625001] = {
    id = 43625001,
    EquipID = 43625,
    AttrType = Table_EquipEffect_t.AttrType[12],
    AttrRate = Table_EquipEffect_t.AttrRate[22],
    Dsc = "##1123353"
  },
  [43626001] = {
    id = 43626001,
    EquipID = 43626,
    AttrType = Table_EquipEffect_t.AttrType[17],
    AttrRate = Table_EquipEffect_t.AttrRate[22],
    Dsc = "##1110947"
  },
  [43627001] = {
    id = 43627001,
    EquipID = 43627,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[22]
  },
  [44091001] = {
    id = 44091001,
    EquipID = 44091,
    AttrType = Table_EquipEffect_t.AttrType[21],
    AttrRate = Table_EquipEffect_t.AttrRate[9],
    Dsc = "##312074"
  },
  [44091002] = {
    id = 44091002,
    EquipID = 44091,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123328"
  },
  [44091003] = {
    id = 44091003,
    EquipID = 44091,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123329"
  },
  [44091004] = {
    id = 44091004,
    EquipID = 44091,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[5]
  },
  [44091005] = {
    id = 44091005,
    EquipID = 44091,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123330"
  },
  [44091006] = {
    id = 44091006,
    EquipID = 44091,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123331"
  },
  [44092001] = {
    id = 44092001,
    EquipID = 44092,
    AttrType = Table_EquipEffect_t.AttrType[21],
    AttrRate = Table_EquipEffect_t.AttrRate[9],
    Dsc = "##312074"
  },
  [44092002] = {
    id = 44092002,
    EquipID = 44092,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123328"
  },
  [44092003] = {
    id = 44092003,
    EquipID = 44092,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123329"
  },
  [44092004] = {
    id = 44092004,
    EquipID = 44092,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[5]
  },
  [44092005] = {
    id = 44092005,
    EquipID = 44092,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123330"
  },
  [44092006] = {
    id = 44092006,
    EquipID = 44092,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123331"
  },
  [44092007] = {
    id = 44092007,
    EquipID = 44092,
    GroupID = 2,
    AttrType = Table_EquipEffect_t.AttrType[8],
    AttrRate = Table_EquipEffect_t.AttrRate[6],
    Dsc = "##1207802"
  },
  [44094001] = {
    id = 44094001,
    EquipID = 44094,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[28]
  },
  [44094002] = {
    id = 44094002,
    EquipID = 44094,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123328"
  },
  [44094003] = {
    id = 44094003,
    EquipID = 44094,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123329"
  },
  [44094004] = {
    id = 44094004,
    EquipID = 44094,
    AttrType = Table_EquipEffect_t.AttrType[33],
    AttrRate = Table_EquipEffect_t.AttrRate[5],
    Dsc = "##1123666"
  },
  [44094005] = {
    id = 44094005,
    EquipID = 44094,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123330"
  },
  [44094006] = {
    id = 44094006,
    EquipID = 44094,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123331"
  },
  [44095001] = {
    id = 44095001,
    EquipID = 44095,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[28]
  },
  [44095002] = {
    id = 44095002,
    EquipID = 44095,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123328"
  },
  [44095003] = {
    id = 44095003,
    EquipID = 44095,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123329"
  },
  [44095004] = {
    id = 44095004,
    EquipID = 44095,
    AttrType = Table_EquipEffect_t.AttrType[33],
    AttrRate = Table_EquipEffect_t.AttrRate[5],
    Dsc = "##1123666"
  },
  [44095005] = {
    id = 44095005,
    EquipID = 44095,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123330"
  },
  [44095006] = {
    id = 44095006,
    EquipID = 44095,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123331"
  },
  [44095007] = {
    id = 44095007,
    EquipID = 44095,
    GroupID = 2,
    AttrType = Table_EquipEffect_t.AttrType[8],
    AttrRate = Table_EquipEffect_t.AttrRate[6],
    Dsc = "##1207802"
  },
  [44097001] = {
    id = 44097001,
    EquipID = 44097,
    AttrType = Table_EquipEffect_t.AttrType[35],
    AttrRate = Table_EquipEffect_t.AttrRate[7],
    Dsc = "##1123376"
  },
  [44097002] = {
    id = 44097002,
    EquipID = 44097,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123328"
  },
  [44097003] = {
    id = 44097003,
    EquipID = 44097,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123329"
  },
  [44097004] = {
    id = 44097004,
    EquipID = 44097,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[5]
  },
  [44097005] = {
    id = 44097005,
    EquipID = 44097,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123330"
  },
  [44097006] = {
    id = 44097006,
    EquipID = 44097,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123331"
  },
  [44098001] = {
    id = 44098001,
    EquipID = 44098,
    AttrType = Table_EquipEffect_t.AttrType[35],
    AttrRate = Table_EquipEffect_t.AttrRate[7],
    Dsc = "##1123376"
  },
  [44098002] = {
    id = 44098002,
    EquipID = 44098,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123328"
  },
  [44098003] = {
    id = 44098003,
    EquipID = 44098,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123329"
  },
  [44098004] = {
    id = 44098004,
    EquipID = 44098,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[5]
  },
  [44098005] = {
    id = 44098005,
    EquipID = 44098,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123330"
  },
  [44098006] = {
    id = 44098006,
    EquipID = 44098,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123331"
  },
  [44098007] = {
    id = 44098007,
    EquipID = 44098,
    GroupID = 2,
    AttrType = Table_EquipEffect_t.AttrType[8],
    AttrRate = Table_EquipEffect_t.AttrRate[6],
    Dsc = "##1207802"
  },
  [44100001] = {
    id = 44100001,
    EquipID = 44100,
    AttrType = Table_EquipEffect_t.AttrType[17],
    AttrRate = Table_EquipEffect_t.AttrRate[3],
    Dsc = "##1110947"
  },
  [44100002] = {
    id = 44100002,
    EquipID = 44100,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123328"
  },
  [44100003] = {
    id = 44100003,
    EquipID = 44100,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123329"
  },
  [44100004] = {
    id = 44100004,
    EquipID = 44100,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[5]
  },
  [44100005] = {
    id = 44100005,
    EquipID = 44100,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123330"
  },
  [44100006] = {
    id = 44100006,
    EquipID = 44100,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123331"
  },
  [44101001] = {
    id = 44101001,
    EquipID = 44101,
    AttrType = Table_EquipEffect_t.AttrType[17],
    AttrRate = Table_EquipEffect_t.AttrRate[3],
    Dsc = "##1110947"
  },
  [44101002] = {
    id = 44101002,
    EquipID = 44101,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123328"
  },
  [44101003] = {
    id = 44101003,
    EquipID = 44101,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123329"
  },
  [44101004] = {
    id = 44101004,
    EquipID = 44101,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[5]
  },
  [44101005] = {
    id = 44101005,
    EquipID = 44101,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123330"
  },
  [44101006] = {
    id = 44101006,
    EquipID = 44101,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123331"
  },
  [44101007] = {
    id = 44101007,
    EquipID = 44101,
    GroupID = 2,
    AttrType = Table_EquipEffect_t.AttrType[8],
    AttrRate = Table_EquipEffect_t.AttrRate[6],
    Dsc = "##1207802"
  },
  [44103001] = {
    id = 44103001,
    EquipID = 44103,
    AttrType = Table_EquipEffect_t.AttrType[12],
    AttrRate = Table_EquipEffect_t.AttrRate[23],
    Dsc = "##1123353"
  },
  [44103002] = {
    id = 44103002,
    EquipID = 44103,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123328"
  },
  [44103003] = {
    id = 44103003,
    EquipID = 44103,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123329"
  },
  [44103004] = {
    id = 44103004,
    EquipID = 44103,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[5]
  },
  [44103005] = {
    id = 44103005,
    EquipID = 44103,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123330"
  },
  [44103006] = {
    id = 44103006,
    EquipID = 44103,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123331"
  },
  [44104001] = {
    id = 44104001,
    EquipID = 44104,
    AttrType = Table_EquipEffect_t.AttrType[12],
    AttrRate = Table_EquipEffect_t.AttrRate[23],
    Dsc = "##1123353"
  },
  [44104002] = {
    id = 44104002,
    EquipID = 44104,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123328"
  },
  [44104003] = {
    id = 44104003,
    EquipID = 44104,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123329"
  },
  [44104004] = {
    id = 44104004,
    EquipID = 44104,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[5]
  },
  [44104005] = {
    id = 44104005,
    EquipID = 44104,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123330"
  },
  [44104006] = {
    id = 44104006,
    EquipID = 44104,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123331"
  },
  [44104007] = {
    id = 44104007,
    EquipID = 44104,
    GroupID = 2,
    AttrType = Table_EquipEffect_t.AttrType[8],
    AttrRate = Table_EquipEffect_t.AttrRate[6],
    Dsc = "##1207802"
  },
  [44106001] = {
    id = 44106001,
    EquipID = 44106,
    AttrType = Table_EquipEffect_t.AttrType[23],
    AttrRate = Table_EquipEffect_t.AttrRate[7],
    Dsc = "##312079"
  },
  [44106002] = {
    id = 44106002,
    EquipID = 44106,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123328"
  },
  [44106003] = {
    id = 44106003,
    EquipID = 44106,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123329"
  },
  [44106004] = {
    id = 44106004,
    EquipID = 44106,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[5]
  },
  [44106005] = {
    id = 44106005,
    EquipID = 44106,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123330"
  },
  [44106006] = {
    id = 44106006,
    EquipID = 44106,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123331"
  },
  [44107001] = {
    id = 44107001,
    EquipID = 44107,
    AttrType = Table_EquipEffect_t.AttrType[23],
    AttrRate = Table_EquipEffect_t.AttrRate[7],
    Dsc = "##312079"
  },
  [44107002] = {
    id = 44107002,
    EquipID = 44107,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123328"
  },
  [44107003] = {
    id = 44107003,
    EquipID = 44107,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123329"
  },
  [44107004] = {
    id = 44107004,
    EquipID = 44107,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[5]
  },
  [44107005] = {
    id = 44107005,
    EquipID = 44107,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123330"
  },
  [44107006] = {
    id = 44107006,
    EquipID = 44107,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123331"
  },
  [44107007] = {
    id = 44107007,
    EquipID = 44107,
    GroupID = 2,
    AttrType = Table_EquipEffect_t.AttrType[8],
    AttrRate = Table_EquipEffect_t.AttrRate[6],
    Dsc = "##1207802"
  },
  [44109001] = {
    id = 44109001,
    EquipID = 44109,
    AttrType = Table_EquipEffect_t.AttrType[21],
    AttrRate = Table_EquipEffect_t.AttrRate[9],
    Dsc = "##312074"
  },
  [44109002] = {
    id = 44109002,
    EquipID = 44109,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123328"
  },
  [44109003] = {
    id = 44109003,
    EquipID = 44109,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123329"
  },
  [44109004] = {
    id = 44109004,
    EquipID = 44109,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[5]
  },
  [44109005] = {
    id = 44109005,
    EquipID = 44109,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123330"
  },
  [44109006] = {
    id = 44109006,
    EquipID = 44109,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123331"
  },
  [44110001] = {
    id = 44110001,
    EquipID = 44110,
    AttrType = Table_EquipEffect_t.AttrType[21],
    AttrRate = Table_EquipEffect_t.AttrRate[9],
    Dsc = "##312074"
  },
  [44110002] = {
    id = 44110002,
    EquipID = 44110,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123328"
  },
  [44110003] = {
    id = 44110003,
    EquipID = 44110,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123329"
  },
  [44110004] = {
    id = 44110004,
    EquipID = 44110,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[5]
  },
  [44110005] = {
    id = 44110005,
    EquipID = 44110,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123330"
  },
  [44110006] = {
    id = 44110006,
    EquipID = 44110,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123331"
  },
  [44110007] = {
    id = 44110007,
    EquipID = 44110,
    GroupID = 2,
    AttrType = Table_EquipEffect_t.AttrType[8],
    AttrRate = Table_EquipEffect_t.AttrRate[6],
    Dsc = "##1207802"
  },
  [44112001] = {
    id = 44112001,
    EquipID = 44112,
    AttrType = Table_EquipEffect_t.AttrType[20],
    AttrRate = Table_EquipEffect_t.AttrRate[7],
    Dsc = "##1186494"
  },
  [44112002] = {
    id = 44112002,
    EquipID = 44112,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123328"
  },
  [44112003] = {
    id = 44112003,
    EquipID = 44112,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123329"
  },
  [44112004] = {
    id = 44112004,
    EquipID = 44112,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[5]
  },
  [44112005] = {
    id = 44112005,
    EquipID = 44112,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123330"
  },
  [44112006] = {
    id = 44112006,
    EquipID = 44112,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123331"
  },
  [44113001] = {
    id = 44113001,
    EquipID = 44113,
    AttrType = Table_EquipEffect_t.AttrType[20],
    AttrRate = Table_EquipEffect_t.AttrRate[7],
    Dsc = "##1186494"
  },
  [44113002] = {
    id = 44113002,
    EquipID = 44113,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123328"
  },
  [44113003] = {
    id = 44113003,
    EquipID = 44113,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123329"
  },
  [44113004] = {
    id = 44113004,
    EquipID = 44113,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[5]
  },
  [44113005] = {
    id = 44113005,
    EquipID = 44113,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123330"
  },
  [44113006] = {
    id = 44113006,
    EquipID = 44113,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123331"
  },
  [44113007] = {
    id = 44113007,
    EquipID = 44113,
    GroupID = 2,
    AttrType = Table_EquipEffect_t.AttrType[8],
    AttrRate = Table_EquipEffect_t.AttrRate[6],
    Dsc = "##1207802"
  },
  [44115001] = {
    id = 44115001,
    EquipID = 44115,
    AttrType = Table_EquipEffect_t.AttrType[15],
    AttrRate = Table_EquipEffect_t.AttrRate[7],
    Dsc = "##1186495"
  },
  [44115002] = {
    id = 44115002,
    EquipID = 44115,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123328"
  },
  [44115003] = {
    id = 44115003,
    EquipID = 44115,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123329"
  },
  [44115004] = {
    id = 44115004,
    EquipID = 44115,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[5]
  },
  [44115005] = {
    id = 44115005,
    EquipID = 44115,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123330"
  },
  [44115006] = {
    id = 44115006,
    EquipID = 44115,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123331"
  },
  [44116001] = {
    id = 44116001,
    EquipID = 44116,
    AttrType = Table_EquipEffect_t.AttrType[15],
    AttrRate = Table_EquipEffect_t.AttrRate[7],
    Dsc = "##1186495"
  },
  [44116002] = {
    id = 44116002,
    EquipID = 44116,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123328"
  },
  [44116003] = {
    id = 44116003,
    EquipID = 44116,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123329"
  },
  [44116004] = {
    id = 44116004,
    EquipID = 44116,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[5]
  },
  [44116005] = {
    id = 44116005,
    EquipID = 44116,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123330"
  },
  [44116006] = {
    id = 44116006,
    EquipID = 44116,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123331"
  },
  [44116007] = {
    id = 44116007,
    EquipID = 44116,
    GroupID = 2,
    AttrType = Table_EquipEffect_t.AttrType[8],
    AttrRate = Table_EquipEffect_t.AttrRate[6],
    Dsc = "##1207802"
  },
  [44118001] = {
    id = 44118001,
    EquipID = 44118,
    AttrType = Table_EquipEffect_t.AttrType[3],
    AttrRate = Table_EquipEffect_t.AttrRate[3],
    Dsc = "##1110946"
  },
  [44118002] = {
    id = 44118002,
    EquipID = 44118,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123328"
  },
  [44118003] = {
    id = 44118003,
    EquipID = 44118,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123329"
  },
  [44118004] = {
    id = 44118004,
    EquipID = 44118,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[5]
  },
  [44118005] = {
    id = 44118005,
    EquipID = 44118,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123330"
  },
  [44118006] = {
    id = 44118006,
    EquipID = 44118,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123331"
  },
  [44119001] = {
    id = 44119001,
    EquipID = 44119,
    AttrType = Table_EquipEffect_t.AttrType[3],
    AttrRate = Table_EquipEffect_t.AttrRate[3],
    Dsc = "##1110946"
  },
  [44119002] = {
    id = 44119002,
    EquipID = 44119,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123328"
  },
  [44119003] = {
    id = 44119003,
    EquipID = 44119,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123329"
  },
  [44119004] = {
    id = 44119004,
    EquipID = 44119,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[5]
  },
  [44119005] = {
    id = 44119005,
    EquipID = 44119,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123330"
  },
  [44119006] = {
    id = 44119006,
    EquipID = 44119,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123331"
  },
  [44119007] = {
    id = 44119007,
    EquipID = 44119,
    GroupID = 2,
    AttrType = Table_EquipEffect_t.AttrType[8],
    AttrRate = Table_EquipEffect_t.AttrRate[6],
    Dsc = "##1207802"
  },
  [44121001] = {
    id = 44121001,
    EquipID = 44121,
    AttrType = Table_EquipEffect_t.AttrType[12],
    AttrRate = Table_EquipEffect_t.AttrRate[23],
    Dsc = "##1123353"
  },
  [44121002] = {
    id = 44121002,
    EquipID = 44121,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123328"
  },
  [44121003] = {
    id = 44121003,
    EquipID = 44121,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123329"
  },
  [44121004] = {
    id = 44121004,
    EquipID = 44121,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[5]
  },
  [44121005] = {
    id = 44121005,
    EquipID = 44121,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123330"
  },
  [44121006] = {
    id = 44121006,
    EquipID = 44121,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123331"
  },
  [44122001] = {
    id = 44122001,
    EquipID = 44122,
    AttrType = Table_EquipEffect_t.AttrType[12],
    AttrRate = Table_EquipEffect_t.AttrRate[23],
    Dsc = "##1123353"
  },
  [44122002] = {
    id = 44122002,
    EquipID = 44122,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123328"
  },
  [44122003] = {
    id = 44122003,
    EquipID = 44122,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123329"
  },
  [44122004] = {
    id = 44122004,
    EquipID = 44122,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[5]
  },
  [44122005] = {
    id = 44122005,
    EquipID = 44122,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123330"
  },
  [44122006] = {
    id = 44122006,
    EquipID = 44122,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123331"
  },
  [44122007] = {
    id = 44122007,
    EquipID = 44122,
    GroupID = 2,
    AttrType = Table_EquipEffect_t.AttrType[8],
    AttrRate = Table_EquipEffect_t.AttrRate[6],
    Dsc = "##1207802"
  },
  [44124001] = {
    id = 44124001,
    EquipID = 44124,
    AttrType = Table_EquipEffect_t.AttrType[3],
    AttrRate = Table_EquipEffect_t.AttrRate[3],
    Dsc = "##1110946"
  },
  [44124002] = {
    id = 44124002,
    EquipID = 44124,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123328"
  },
  [44124003] = {
    id = 44124003,
    EquipID = 44124,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123329"
  },
  [44124004] = {
    id = 44124004,
    EquipID = 44124,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[5]
  },
  [44124005] = {
    id = 44124005,
    EquipID = 44124,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123330"
  },
  [44124006] = {
    id = 44124006,
    EquipID = 44124,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123331"
  },
  [44125001] = {
    id = 44125001,
    EquipID = 44125,
    AttrType = Table_EquipEffect_t.AttrType[3],
    AttrRate = Table_EquipEffect_t.AttrRate[3],
    Dsc = "##1110946"
  },
  [44125002] = {
    id = 44125002,
    EquipID = 44125,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123328"
  },
  [44125003] = {
    id = 44125003,
    EquipID = 44125,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123329"
  },
  [44125004] = {
    id = 44125004,
    EquipID = 44125,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[5]
  },
  [44125005] = {
    id = 44125005,
    EquipID = 44125,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123330"
  },
  [44125006] = {
    id = 44125006,
    EquipID = 44125,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123331"
  },
  [44125007] = {
    id = 44125007,
    EquipID = 44125,
    GroupID = 2,
    AttrType = Table_EquipEffect_t.AttrType[8],
    AttrRate = Table_EquipEffect_t.AttrRate[6],
    Dsc = "##1207802"
  },
  [44127001] = {
    id = 44127001,
    EquipID = 44127,
    AttrType = Table_EquipEffect_t.AttrType[9],
    AttrRate = Table_EquipEffect_t.AttrRate[3],
    Dsc = "##1186390"
  },
  [44127002] = {
    id = 44127002,
    EquipID = 44127,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123328"
  },
  [44127003] = {
    id = 44127003,
    EquipID = 44127,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123329"
  },
  [44127004] = {
    id = 44127004,
    EquipID = 44127,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[5]
  },
  [44127005] = {
    id = 44127005,
    EquipID = 44127,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123330"
  },
  [44127006] = {
    id = 44127006,
    EquipID = 44127,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123331"
  },
  [44128001] = {
    id = 44128001,
    EquipID = 44128,
    AttrType = Table_EquipEffect_t.AttrType[9],
    AttrRate = Table_EquipEffect_t.AttrRate[3],
    Dsc = "##1186390"
  },
  [44128002] = {
    id = 44128002,
    EquipID = 44128,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123328"
  },
  [44128003] = {
    id = 44128003,
    EquipID = 44128,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123329"
  },
  [44128004] = {
    id = 44128004,
    EquipID = 44128,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[5]
  },
  [44128005] = {
    id = 44128005,
    EquipID = 44128,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123330"
  },
  [44128006] = {
    id = 44128006,
    EquipID = 44128,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123331"
  },
  [44128007] = {
    id = 44128007,
    EquipID = 44128,
    GroupID = 2,
    AttrType = Table_EquipEffect_t.AttrType[8],
    AttrRate = Table_EquipEffect_t.AttrRate[6],
    Dsc = "##1207802"
  },
  [44133001] = {
    id = 44133001,
    EquipID = 44133,
    AttrType = Table_EquipEffect_t.AttrType[17],
    AttrRate = Table_EquipEffect_t.AttrRate[3],
    Dsc = "##1110947"
  },
  [44133002] = {
    id = 44133002,
    EquipID = 44133,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123328"
  },
  [44133003] = {
    id = 44133003,
    EquipID = 44133,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123329"
  },
  [44133004] = {
    id = 44133004,
    EquipID = 44133,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[5]
  },
  [44133005] = {
    id = 44133005,
    EquipID = 44133,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123330"
  },
  [44133006] = {
    id = 44133006,
    EquipID = 44133,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123331"
  },
  [44134001] = {
    id = 44134001,
    EquipID = 44134,
    AttrType = Table_EquipEffect_t.AttrType[17],
    AttrRate = Table_EquipEffect_t.AttrRate[3],
    Dsc = "##1110947"
  },
  [44134002] = {
    id = 44134002,
    EquipID = 44134,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123328"
  },
  [44134003] = {
    id = 44134003,
    EquipID = 44134,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123329"
  },
  [44134004] = {
    id = 44134004,
    EquipID = 44134,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[5]
  },
  [44134005] = {
    id = 44134005,
    EquipID = 44134,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123330"
  },
  [44134006] = {
    id = 44134006,
    EquipID = 44134,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123331"
  },
  [44134007] = {
    id = 44134007,
    EquipID = 44134,
    GroupID = 2,
    AttrType = Table_EquipEffect_t.AttrType[8],
    AttrRate = Table_EquipEffect_t.AttrRate[6],
    Dsc = "##1207802"
  },
  [44136001] = {
    id = 44136001,
    EquipID = 44136,
    AttrType = Table_EquipEffect_t.AttrType[3],
    AttrRate = Table_EquipEffect_t.AttrRate[3],
    Dsc = "##1110946"
  },
  [44136002] = {
    id = 44136002,
    EquipID = 44136,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123328"
  },
  [44136003] = {
    id = 44136003,
    EquipID = 44136,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123329"
  },
  [44136004] = {
    id = 44136004,
    EquipID = 44136,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[5]
  },
  [44136005] = {
    id = 44136005,
    EquipID = 44136,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123330"
  },
  [44136006] = {
    id = 44136006,
    EquipID = 44136,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123331"
  },
  [44137001] = {
    id = 44137001,
    EquipID = 44137,
    AttrType = Table_EquipEffect_t.AttrType[3],
    AttrRate = Table_EquipEffect_t.AttrRate[3],
    Dsc = "##1110946"
  },
  [44137002] = {
    id = 44137002,
    EquipID = 44137,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123328"
  },
  [44137003] = {
    id = 44137003,
    EquipID = 44137,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123329"
  },
  [44137004] = {
    id = 44137004,
    EquipID = 44137,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[5]
  },
  [44137005] = {
    id = 44137005,
    EquipID = 44137,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123330"
  },
  [44137006] = {
    id = 44137006,
    EquipID = 44137,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123331"
  },
  [44137007] = {
    id = 44137007,
    EquipID = 44137,
    GroupID = 2,
    AttrType = Table_EquipEffect_t.AttrType[8],
    AttrRate = Table_EquipEffect_t.AttrRate[6],
    Dsc = "##1207802"
  },
  [44140001] = {
    id = 44140001,
    EquipID = 44140,
    AttrType = Table_EquipEffect_t.AttrType[3],
    AttrRate = Table_EquipEffect_t.AttrRate[29],
    Dsc = "##1110946"
  },
  [44141001] = {
    id = 44141001,
    EquipID = 44141,
    AttrType = Table_EquipEffect_t.AttrType[21],
    AttrRate = Table_EquipEffect_t.AttrRate[25],
    Dsc = "##312074"
  },
  [44142001] = {
    id = 44142001,
    EquipID = 44142,
    AttrType = Table_EquipEffect_t.AttrType[23],
    AttrRate = Table_EquipEffect_t.AttrRate[27],
    Dsc = "##312079"
  },
  [44143001] = {
    id = 44143001,
    EquipID = 44143,
    AttrType = Table_EquipEffect_t.AttrType[3],
    AttrRate = Table_EquipEffect_t.AttrRate[29],
    Dsc = "##1110946"
  },
  [44144001] = {
    id = 44144001,
    EquipID = 44144,
    AttrType = Table_EquipEffect_t.AttrType[21],
    AttrRate = Table_EquipEffect_t.AttrRate[25],
    Dsc = "##312074"
  },
  [44145001] = {
    id = 44145001,
    EquipID = 44145,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[22]
  },
  [142128001] = {
    id = 142128001,
    EquipID = 142128,
    AttrType = Table_EquipEffect_t.AttrType[3],
    AttrRate = Table_EquipEffect_t.AttrRate[9],
    Dsc = "##1110946"
  },
  [142128002] = {
    id = 142128002,
    EquipID = 142128,
    AttrType = Table_EquipEffect_t.AttrType[13],
    AttrRate = Table_EquipEffect_t.AttrRate[10],
    Dsc = "##312072"
  },
  [142128003] = {
    id = 142128003,
    EquipID = 142128,
    AttrType = Table_EquipEffect_t.AttrType[27],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##312088"
  },
  [142128004] = {
    id = 142128004,
    EquipID = 142128,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[10]
  },
  [142128005] = {
    id = 142128005,
    EquipID = 142128,
    AttrType = Table_EquipEffect_t.AttrType[28],
    AttrRate = Table_EquipEffect_t.AttrRate[21],
    Dsc = "##1123619"
  },
  [142128006] = {
    id = 142128006,
    EquipID = 142128,
    AttrType = Table_EquipEffect_t.AttrType[24],
    AttrRate = Table_EquipEffect_t.AttrRate[20],
    Dsc = "##1123620"
  },
  [142128007] = {
    id = 142128007,
    EquipID = 142128,
    AttrType = Table_EquipEffect_t.AttrType[25],
    AttrRate = Table_EquipEffect_t.AttrRate[21],
    Dsc = "##1123621"
  },
  [142129001] = {
    id = 142129001,
    EquipID = 142129,
    AttrType = Table_EquipEffect_t.AttrType[3],
    AttrRate = Table_EquipEffect_t.AttrRate[9],
    Dsc = "##1110946"
  },
  [142129002] = {
    id = 142129002,
    EquipID = 142129,
    AttrType = Table_EquipEffect_t.AttrType[13],
    AttrRate = Table_EquipEffect_t.AttrRate[10],
    Dsc = "##312072"
  },
  [142129003] = {
    id = 142129003,
    EquipID = 142129,
    AttrType = Table_EquipEffect_t.AttrType[27],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##312088"
  },
  [142129004] = {
    id = 142129004,
    EquipID = 142129,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[10]
  },
  [142129005] = {
    id = 142129005,
    EquipID = 142129,
    AttrType = Table_EquipEffect_t.AttrType[28],
    AttrRate = Table_EquipEffect_t.AttrRate[21],
    Dsc = "##1123619"
  },
  [142129006] = {
    id = 142129006,
    EquipID = 142129,
    AttrType = Table_EquipEffect_t.AttrType[24],
    AttrRate = Table_EquipEffect_t.AttrRate[20],
    Dsc = "##1123620"
  },
  [142129007] = {
    id = 142129007,
    EquipID = 142129,
    AttrType = Table_EquipEffect_t.AttrType[25],
    AttrRate = Table_EquipEffect_t.AttrRate[21],
    Dsc = "##1123621"
  },
  [142129008] = {
    id = 142129008,
    EquipID = 142129,
    GroupID = 2,
    AttrType = Table_EquipEffect_t.AttrType[2],
    AttrRate = Table_EquipEffect_t.AttrRate[2],
    Dsc = "##1211215"
  },
  [142131001] = {
    id = 142131001,
    EquipID = 142131,
    AttrType = Table_EquipEffect_t.AttrType[17],
    AttrRate = Table_EquipEffect_t.AttrRate[9],
    Dsc = "##1110947"
  },
  [142131002] = {
    id = 142131002,
    EquipID = 142131,
    AttrType = Table_EquipEffect_t.AttrType[13],
    AttrRate = Table_EquipEffect_t.AttrRate[10],
    Dsc = "##312072"
  },
  [142131003] = {
    id = 142131003,
    EquipID = 142131,
    AttrType = Table_EquipEffect_t.AttrType[27],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##312088"
  },
  [142131004] = {
    id = 142131004,
    EquipID = 142131,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[10]
  },
  [142131005] = {
    id = 142131005,
    EquipID = 142131,
    AttrType = Table_EquipEffect_t.AttrType[28],
    AttrRate = Table_EquipEffect_t.AttrRate[21],
    Dsc = "##1123619"
  },
  [142131006] = {
    id = 142131006,
    EquipID = 142131,
    AttrType = Table_EquipEffect_t.AttrType[24],
    AttrRate = Table_EquipEffect_t.AttrRate[20],
    Dsc = "##1123620"
  },
  [142131007] = {
    id = 142131007,
    EquipID = 142131,
    AttrType = Table_EquipEffect_t.AttrType[25],
    AttrRate = Table_EquipEffect_t.AttrRate[21],
    Dsc = "##1123621"
  },
  [142132001] = {
    id = 142132001,
    AttrType = Table_EquipEffect_t.AttrType[17],
    AttrRate = Table_EquipEffect_t.AttrRate[9],
    Dsc = "##1110947"
  },
  [142132002] = {
    id = 142132002,
    AttrType = Table_EquipEffect_t.AttrType[13],
    AttrRate = Table_EquipEffect_t.AttrRate[10],
    Dsc = "##312072"
  },
  [142132003] = {
    id = 142132003,
    AttrType = Table_EquipEffect_t.AttrType[27],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##312088"
  },
  [142132004] = {
    id = 142132004,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[10]
  },
  [142132005] = {
    id = 142132005,
    AttrType = Table_EquipEffect_t.AttrType[28],
    AttrRate = Table_EquipEffect_t.AttrRate[21],
    Dsc = "##1123619"
  },
  [142132006] = {
    id = 142132006,
    AttrType = Table_EquipEffect_t.AttrType[24],
    AttrRate = Table_EquipEffect_t.AttrRate[20],
    Dsc = "##1123620"
  },
  [142132007] = {
    id = 142132007,
    AttrType = Table_EquipEffect_t.AttrType[25],
    AttrRate = Table_EquipEffect_t.AttrRate[21],
    Dsc = "##1123621"
  },
  [142132008] = {
    id = 142132008,
    GroupID = 2,
    AttrType = Table_EquipEffect_t.AttrType[2],
    AttrRate = Table_EquipEffect_t.AttrRate[2],
    Dsc = "##1211215"
  },
  [142134001] = {
    id = 142134001,
    EquipID = 142134,
    AttrType = Table_EquipEffect_t.AttrType[17],
    AttrRate = Table_EquipEffect_t.AttrRate[9],
    Dsc = "##1110947"
  },
  [142134002] = {
    id = 142134002,
    EquipID = 142134,
    AttrType = Table_EquipEffect_t.AttrType[13],
    AttrRate = Table_EquipEffect_t.AttrRate[10],
    Dsc = "##312072"
  },
  [142134003] = {
    id = 142134003,
    EquipID = 142134,
    AttrType = Table_EquipEffect_t.AttrType[27],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##312088"
  },
  [142134004] = {
    id = 142134004,
    EquipID = 142134,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[10]
  },
  [142134005] = {
    id = 142134005,
    EquipID = 142134,
    AttrType = Table_EquipEffect_t.AttrType[28],
    AttrRate = Table_EquipEffect_t.AttrRate[21],
    Dsc = "##1123619"
  },
  [142134006] = {
    id = 142134006,
    EquipID = 142134,
    AttrType = Table_EquipEffect_t.AttrType[24],
    AttrRate = Table_EquipEffect_t.AttrRate[20],
    Dsc = "##1123620"
  },
  [142134007] = {
    id = 142134007,
    EquipID = 142134,
    AttrType = Table_EquipEffect_t.AttrType[25],
    AttrRate = Table_EquipEffect_t.AttrRate[21],
    Dsc = "##1123621"
  },
  [142135001] = {
    id = 142135001,
    EquipID = 142135,
    AttrType = Table_EquipEffect_t.AttrType[17],
    AttrRate = Table_EquipEffect_t.AttrRate[9],
    Dsc = "##1110947"
  },
  [142135002] = {
    id = 142135002,
    EquipID = 142135,
    AttrType = Table_EquipEffect_t.AttrType[13],
    AttrRate = Table_EquipEffect_t.AttrRate[10],
    Dsc = "##312072"
  },
  [142135003] = {
    id = 142135003,
    EquipID = 142135,
    AttrType = Table_EquipEffect_t.AttrType[27],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##312088"
  },
  [142135004] = {
    id = 142135004,
    EquipID = 142135,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[10]
  },
  [142135005] = {
    id = 142135005,
    EquipID = 142135,
    AttrType = Table_EquipEffect_t.AttrType[28],
    AttrRate = Table_EquipEffect_t.AttrRate[21],
    Dsc = "##1123619"
  },
  [142135006] = {
    id = 142135006,
    EquipID = 142135,
    AttrType = Table_EquipEffect_t.AttrType[24],
    AttrRate = Table_EquipEffect_t.AttrRate[20],
    Dsc = "##1123620"
  },
  [142135007] = {
    id = 142135007,
    EquipID = 142135,
    AttrType = Table_EquipEffect_t.AttrType[25],
    AttrRate = Table_EquipEffect_t.AttrRate[21],
    Dsc = "##1123621"
  },
  [142135008] = {
    id = 142135008,
    EquipID = 142135,
    GroupID = 2,
    AttrType = Table_EquipEffect_t.AttrType[2],
    AttrRate = Table_EquipEffect_t.AttrRate[2],
    Dsc = "##1211215"
  },
  [142137001] = {
    id = 142137001,
    EquipID = 142137,
    AttrType = Table_EquipEffect_t.AttrType[23],
    AttrRate = Table_EquipEffect_t.AttrRate[15],
    Dsc = "##312079"
  },
  [142137002] = {
    id = 142137002,
    EquipID = 142137,
    AttrType = Table_EquipEffect_t.AttrType[13],
    AttrRate = Table_EquipEffect_t.AttrRate[10],
    Dsc = "##312072"
  },
  [142137003] = {
    id = 142137003,
    EquipID = 142137,
    AttrType = Table_EquipEffect_t.AttrType[27],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##312088"
  },
  [142137004] = {
    id = 142137004,
    EquipID = 142137,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[10]
  },
  [142137005] = {
    id = 142137005,
    EquipID = 142137,
    AttrType = Table_EquipEffect_t.AttrType[28],
    AttrRate = Table_EquipEffect_t.AttrRate[21],
    Dsc = "##1123619"
  },
  [142137006] = {
    id = 142137006,
    EquipID = 142137,
    AttrType = Table_EquipEffect_t.AttrType[24],
    AttrRate = Table_EquipEffect_t.AttrRate[20],
    Dsc = "##1123620"
  },
  [142137007] = {
    id = 142137007,
    EquipID = 142137,
    AttrType = Table_EquipEffect_t.AttrType[25],
    AttrRate = Table_EquipEffect_t.AttrRate[21],
    Dsc = "##1123621"
  },
  [142138001] = {
    id = 142138001,
    EquipID = 142138,
    AttrType = Table_EquipEffect_t.AttrType[23],
    AttrRate = Table_EquipEffect_t.AttrRate[15],
    Dsc = "##312079"
  },
  [142138002] = {
    id = 142138002,
    EquipID = 142138,
    AttrType = Table_EquipEffect_t.AttrType[13],
    AttrRate = Table_EquipEffect_t.AttrRate[10],
    Dsc = "##312072"
  },
  [142138003] = {
    id = 142138003,
    EquipID = 142138,
    AttrType = Table_EquipEffect_t.AttrType[27],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##312088"
  },
  [142138004] = {
    id = 142138004,
    EquipID = 142138,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[10]
  },
  [142138005] = {
    id = 142138005,
    EquipID = 142138,
    AttrType = Table_EquipEffect_t.AttrType[28],
    AttrRate = Table_EquipEffect_t.AttrRate[21],
    Dsc = "##1123619"
  },
  [142138006] = {
    id = 142138006,
    EquipID = 142138,
    AttrType = Table_EquipEffect_t.AttrType[24],
    AttrRate = Table_EquipEffect_t.AttrRate[20],
    Dsc = "##1123620"
  },
  [142138007] = {
    id = 142138007,
    EquipID = 142138,
    AttrType = Table_EquipEffect_t.AttrType[25],
    AttrRate = Table_EquipEffect_t.AttrRate[21],
    Dsc = "##1123621"
  },
  [142138008] = {
    id = 142138008,
    EquipID = 142138,
    GroupID = 2,
    AttrType = Table_EquipEffect_t.AttrType[2],
    AttrRate = Table_EquipEffect_t.AttrRate[2],
    Dsc = "##1211215"
  },
  [142140001] = {
    id = 142140001,
    EquipID = 142140,
    AttrType = Table_EquipEffect_t.AttrType[26],
    AttrRate = Table_EquipEffect_t.AttrRate[24],
    Dsc = "##312080"
  },
  [142140002] = {
    id = 142140002,
    EquipID = 142140,
    AttrType = Table_EquipEffect_t.AttrType[13],
    AttrRate = Table_EquipEffect_t.AttrRate[10],
    Dsc = "##312072"
  },
  [142140003] = {
    id = 142140003,
    EquipID = 142140,
    AttrType = Table_EquipEffect_t.AttrType[27],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##312088"
  },
  [142140004] = {
    id = 142140004,
    EquipID = 142140,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[10]
  },
  [142140005] = {
    id = 142140005,
    EquipID = 142140,
    AttrType = Table_EquipEffect_t.AttrType[28],
    AttrRate = Table_EquipEffect_t.AttrRate[21],
    Dsc = "##1123619"
  },
  [142140006] = {
    id = 142140006,
    EquipID = 142140,
    AttrType = Table_EquipEffect_t.AttrType[24],
    AttrRate = Table_EquipEffect_t.AttrRate[20],
    Dsc = "##1123620"
  },
  [142140007] = {
    id = 142140007,
    EquipID = 142140,
    AttrType = Table_EquipEffect_t.AttrType[25],
    AttrRate = Table_EquipEffect_t.AttrRate[21],
    Dsc = "##1123621"
  },
  [142141001] = {
    id = 142141001,
    EquipID = 142141,
    AttrType = Table_EquipEffect_t.AttrType[26],
    AttrRate = Table_EquipEffect_t.AttrRate[24],
    Dsc = "##312080"
  },
  [142141002] = {
    id = 142141002,
    EquipID = 142141,
    AttrType = Table_EquipEffect_t.AttrType[13],
    AttrRate = Table_EquipEffect_t.AttrRate[10],
    Dsc = "##312072"
  },
  [142141003] = {
    id = 142141003,
    EquipID = 142141,
    AttrType = Table_EquipEffect_t.AttrType[27],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##312088"
  },
  [142141004] = {
    id = 142141004,
    EquipID = 142141,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[10]
  },
  [142141005] = {
    id = 142141005,
    EquipID = 142141,
    AttrType = Table_EquipEffect_t.AttrType[28],
    AttrRate = Table_EquipEffect_t.AttrRate[21],
    Dsc = "##1123619"
  },
  [142141006] = {
    id = 142141006,
    EquipID = 142141,
    AttrType = Table_EquipEffect_t.AttrType[24],
    AttrRate = Table_EquipEffect_t.AttrRate[20],
    Dsc = "##1123620"
  },
  [142141007] = {
    id = 142141007,
    EquipID = 142141,
    AttrType = Table_EquipEffect_t.AttrType[25],
    AttrRate = Table_EquipEffect_t.AttrRate[21],
    Dsc = "##1123621"
  },
  [142141008] = {
    id = 142141008,
    EquipID = 142141,
    GroupID = 2,
    AttrType = Table_EquipEffect_t.AttrType[2],
    AttrRate = Table_EquipEffect_t.AttrRate[2],
    Dsc = "##1211215"
  },
  [142143001] = {
    id = 142143001,
    EquipID = 142143,
    AttrType = Table_EquipEffect_t.AttrType[26],
    AttrRate = Table_EquipEffect_t.AttrRate[24],
    Dsc = "##312080"
  },
  [142143002] = {
    id = 142143002,
    EquipID = 142143,
    AttrType = Table_EquipEffect_t.AttrType[13],
    AttrRate = Table_EquipEffect_t.AttrRate[10],
    Dsc = "##312072"
  },
  [142143003] = {
    id = 142143003,
    EquipID = 142143,
    AttrType = Table_EquipEffect_t.AttrType[27],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##312088"
  },
  [142143004] = {
    id = 142143004,
    EquipID = 142143,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[10]
  },
  [142143005] = {
    id = 142143005,
    EquipID = 142143,
    AttrType = Table_EquipEffect_t.AttrType[28],
    AttrRate = Table_EquipEffect_t.AttrRate[21],
    Dsc = "##1123619"
  },
  [142143006] = {
    id = 142143006,
    EquipID = 142143,
    AttrType = Table_EquipEffect_t.AttrType[24],
    AttrRate = Table_EquipEffect_t.AttrRate[20],
    Dsc = "##1123620"
  },
  [142143007] = {
    id = 142143007,
    EquipID = 142143,
    AttrType = Table_EquipEffect_t.AttrType[25],
    AttrRate = Table_EquipEffect_t.AttrRate[21],
    Dsc = "##1123621"
  },
  [142144001] = {
    id = 142144001,
    EquipID = 142144,
    AttrType = Table_EquipEffect_t.AttrType[26],
    AttrRate = Table_EquipEffect_t.AttrRate[24],
    Dsc = "##312080"
  },
  [142144002] = {
    id = 142144002,
    EquipID = 142144,
    AttrType = Table_EquipEffect_t.AttrType[13],
    AttrRate = Table_EquipEffect_t.AttrRate[10],
    Dsc = "##312072"
  },
  [142144003] = {
    id = 142144003,
    EquipID = 142144,
    AttrType = Table_EquipEffect_t.AttrType[27],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##312088"
  },
  [142144004] = {
    id = 142144004,
    EquipID = 142144,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[10]
  },
  [142144005] = {
    id = 142144005,
    EquipID = 142144,
    AttrType = Table_EquipEffect_t.AttrType[28],
    AttrRate = Table_EquipEffect_t.AttrRate[21],
    Dsc = "##1123619"
  },
  [142144006] = {
    id = 142144006,
    EquipID = 142144,
    AttrType = Table_EquipEffect_t.AttrType[24],
    AttrRate = Table_EquipEffect_t.AttrRate[20],
    Dsc = "##1123620"
  },
  [142144007] = {
    id = 142144007,
    EquipID = 142144,
    AttrType = Table_EquipEffect_t.AttrType[25],
    AttrRate = Table_EquipEffect_t.AttrRate[21],
    Dsc = "##1123621"
  },
  [142144008] = {
    id = 142144008,
    EquipID = 142144,
    GroupID = 2,
    AttrType = Table_EquipEffect_t.AttrType[2],
    AttrRate = Table_EquipEffect_t.AttrRate[2],
    Dsc = "##1211215"
  },
  [142146001] = {
    id = 142146001,
    EquipID = 142146,
    AttrType = Table_EquipEffect_t.AttrType[22],
    AttrRate = Table_EquipEffect_t.AttrRate[9],
    Dsc = "##312087"
  },
  [142146002] = {
    id = 142146002,
    EquipID = 142146,
    AttrType = Table_EquipEffect_t.AttrType[13],
    AttrRate = Table_EquipEffect_t.AttrRate[10],
    Dsc = "##312072"
  },
  [142146003] = {
    id = 142146003,
    EquipID = 142146,
    AttrType = Table_EquipEffect_t.AttrType[27],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##312088"
  },
  [142146004] = {
    id = 142146004,
    EquipID = 142146,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[10]
  },
  [142146005] = {
    id = 142146005,
    EquipID = 142146,
    AttrType = Table_EquipEffect_t.AttrType[28],
    AttrRate = Table_EquipEffect_t.AttrRate[21],
    Dsc = "##1123619"
  },
  [142146006] = {
    id = 142146006,
    EquipID = 142146,
    AttrType = Table_EquipEffect_t.AttrType[24],
    AttrRate = Table_EquipEffect_t.AttrRate[20],
    Dsc = "##1123620"
  },
  [142146007] = {
    id = 142146007,
    EquipID = 142146,
    AttrType = Table_EquipEffect_t.AttrType[25],
    AttrRate = Table_EquipEffect_t.AttrRate[21],
    Dsc = "##1123621"
  },
  [142147001] = {
    id = 142147001,
    EquipID = 142147,
    AttrType = Table_EquipEffect_t.AttrType[22],
    AttrRate = Table_EquipEffect_t.AttrRate[9],
    Dsc = "##312087"
  },
  [142147002] = {
    id = 142147002,
    EquipID = 142147,
    AttrType = Table_EquipEffect_t.AttrType[13],
    AttrRate = Table_EquipEffect_t.AttrRate[10],
    Dsc = "##312072"
  },
  [142147003] = {
    id = 142147003,
    EquipID = 142147,
    AttrType = Table_EquipEffect_t.AttrType[27],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##312088"
  },
  [142147004] = {
    id = 142147004,
    EquipID = 142147,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[10]
  },
  [142147005] = {
    id = 142147005,
    EquipID = 142147,
    AttrType = Table_EquipEffect_t.AttrType[28],
    AttrRate = Table_EquipEffect_t.AttrRate[21],
    Dsc = "##1123619"
  },
  [142147006] = {
    id = 142147006,
    EquipID = 142147,
    AttrType = Table_EquipEffect_t.AttrType[24],
    AttrRate = Table_EquipEffect_t.AttrRate[20],
    Dsc = "##1123620"
  },
  [142147007] = {
    id = 142147007,
    EquipID = 142147,
    AttrType = Table_EquipEffect_t.AttrType[25],
    AttrRate = Table_EquipEffect_t.AttrRate[21],
    Dsc = "##1123621"
  },
  [142147008] = {
    id = 142147008,
    EquipID = 142147,
    GroupID = 2,
    AttrType = Table_EquipEffect_t.AttrType[2],
    AttrRate = Table_EquipEffect_t.AttrRate[2],
    Dsc = "##1211215"
  },
  [142149001] = {
    id = 142149001,
    EquipID = 142149,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[9]
  },
  [142149002] = {
    id = 142149002,
    EquipID = 142149,
    AttrType = Table_EquipEffect_t.AttrType[13],
    AttrRate = Table_EquipEffect_t.AttrRate[10],
    Dsc = "##312072"
  },
  [142149003] = {
    id = 142149003,
    EquipID = 142149,
    AttrType = Table_EquipEffect_t.AttrType[27],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##312088"
  },
  [142149004] = {
    id = 142149004,
    EquipID = 142149,
    AttrType = Table_EquipEffect_t.AttrType[35],
    AttrRate = Table_EquipEffect_t.AttrRate[32],
    Dsc = "##1123376"
  },
  [142149005] = {
    id = 142149005,
    EquipID = 142149,
    AttrType = Table_EquipEffect_t.AttrType[29],
    AttrRate = Table_EquipEffect_t.AttrRate[30],
    Dsc = "##1123393"
  },
  [142149006] = {
    id = 142149006,
    EquipID = 142149,
    AttrType = Table_EquipEffect_t.AttrType[37],
    AttrRate = Table_EquipEffect_t.AttrRate[20],
    Dsc = "##1123642"
  },
  [142150001] = {
    id = 142150001,
    EquipID = 142150,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[9]
  },
  [142150002] = {
    id = 142150002,
    EquipID = 142150,
    AttrType = Table_EquipEffect_t.AttrType[13],
    AttrRate = Table_EquipEffect_t.AttrRate[10],
    Dsc = "##312072"
  },
  [142150003] = {
    id = 142150003,
    EquipID = 142150,
    AttrType = Table_EquipEffect_t.AttrType[27],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##312088"
  },
  [142150004] = {
    id = 142150004,
    EquipID = 142150,
    AttrType = Table_EquipEffect_t.AttrType[35],
    AttrRate = Table_EquipEffect_t.AttrRate[32],
    Dsc = "##1123376"
  },
  [142150005] = {
    id = 142150005,
    EquipID = 142150,
    AttrType = Table_EquipEffect_t.AttrType[29],
    AttrRate = Table_EquipEffect_t.AttrRate[30],
    Dsc = "##1123393"
  },
  [142150006] = {
    id = 142150006,
    EquipID = 142150,
    AttrType = Table_EquipEffect_t.AttrType[37],
    AttrRate = Table_EquipEffect_t.AttrRate[20],
    Dsc = "##1123642"
  },
  [142150007] = {
    id = 142150007,
    EquipID = 142150,
    GroupID = 2,
    AttrType = Table_EquipEffect_t.AttrType[2],
    AttrRate = Table_EquipEffect_t.AttrRate[2],
    Dsc = "##1211215"
  },
  [142152001] = {
    id = 142152001,
    EquipID = 142152,
    AttrType = Table_EquipEffect_t.AttrType[18],
    AttrRate = Table_EquipEffect_t.AttrRate[9],
    Dsc = "##1123327"
  },
  [142152002] = {
    id = 142152002,
    EquipID = 142152,
    AttrType = Table_EquipEffect_t.AttrType[13],
    AttrRate = Table_EquipEffect_t.AttrRate[10],
    Dsc = "##312072"
  },
  [142152003] = {
    id = 142152003,
    EquipID = 142152,
    AttrType = Table_EquipEffect_t.AttrType[27],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##312088"
  },
  [142152004] = {
    id = 142152004,
    EquipID = 142152,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[10]
  },
  [142152005] = {
    id = 142152005,
    EquipID = 142152,
    AttrType = Table_EquipEffect_t.AttrType[36],
    AttrRate = Table_EquipEffect_t.AttrRate[20],
    Dsc = "##1123644"
  },
  [142152006] = {
    id = 142152006,
    EquipID = 142152,
    AttrType = Table_EquipEffect_t.AttrType[35],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123376"
  },
  [142153001] = {
    id = 142153001,
    EquipID = 142153,
    AttrType = Table_EquipEffect_t.AttrType[18],
    AttrRate = Table_EquipEffect_t.AttrRate[9],
    Dsc = "##1123327"
  },
  [142153002] = {
    id = 142153002,
    EquipID = 142153,
    AttrType = Table_EquipEffect_t.AttrType[13],
    AttrRate = Table_EquipEffect_t.AttrRate[10],
    Dsc = "##312072"
  },
  [142153003] = {
    id = 142153003,
    EquipID = 142153,
    AttrType = Table_EquipEffect_t.AttrType[27],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##312088"
  },
  [142153004] = {
    id = 142153004,
    EquipID = 142153,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[10]
  },
  [142153005] = {
    id = 142153005,
    EquipID = 142153,
    AttrType = Table_EquipEffect_t.AttrType[36],
    AttrRate = Table_EquipEffect_t.AttrRate[20],
    Dsc = "##1123644"
  },
  [142153006] = {
    id = 142153006,
    EquipID = 142153,
    AttrType = Table_EquipEffect_t.AttrType[35],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123376"
  },
  [142153007] = {
    id = 142153007,
    EquipID = 142153,
    GroupID = 2,
    AttrType = Table_EquipEffect_t.AttrType[2],
    AttrRate = Table_EquipEffect_t.AttrRate[2],
    Dsc = "##1211215"
  },
  [142155001] = {
    id = 142155001,
    EquipID = 142155,
    AttrType = Table_EquipEffect_t.AttrType[12],
    AttrRate = Table_EquipEffect_t.AttrRate[9],
    Dsc = "##1123353"
  },
  [142155002] = {
    id = 142155002,
    EquipID = 142155,
    AttrType = Table_EquipEffect_t.AttrType[13],
    AttrRate = Table_EquipEffect_t.AttrRate[10],
    Dsc = "##312072"
  },
  [142155003] = {
    id = 142155003,
    EquipID = 142155,
    AttrType = Table_EquipEffect_t.AttrType[27],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##312088"
  },
  [142155004] = {
    id = 142155004,
    EquipID = 142155,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[10]
  },
  [142155005] = {
    id = 142155005,
    EquipID = 142155,
    AttrType = Table_EquipEffect_t.AttrType[36],
    AttrRate = Table_EquipEffect_t.AttrRate[20],
    Dsc = "##1123644"
  },
  [142155006] = {
    id = 142155006,
    EquipID = 142155,
    AttrType = Table_EquipEffect_t.AttrType[35],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123376"
  },
  [142156001] = {
    id = 142156001,
    EquipID = 142156,
    AttrType = Table_EquipEffect_t.AttrType[12],
    AttrRate = Table_EquipEffect_t.AttrRate[9],
    Dsc = "##1123353"
  },
  [142156002] = {
    id = 142156002,
    EquipID = 142156,
    AttrType = Table_EquipEffect_t.AttrType[13],
    AttrRate = Table_EquipEffect_t.AttrRate[10],
    Dsc = "##312072"
  },
  [142156003] = {
    id = 142156003,
    EquipID = 142156,
    AttrType = Table_EquipEffect_t.AttrType[27],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##312088"
  },
  [142156004] = {
    id = 142156004,
    EquipID = 142156,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[10]
  },
  [142156005] = {
    id = 142156005,
    EquipID = 142156,
    AttrType = Table_EquipEffect_t.AttrType[36],
    AttrRate = Table_EquipEffect_t.AttrRate[20],
    Dsc = "##1123644"
  },
  [142156006] = {
    id = 142156006,
    EquipID = 142156,
    AttrType = Table_EquipEffect_t.AttrType[35],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123376"
  },
  [142156007] = {
    id = 142156007,
    EquipID = 142156,
    GroupID = 2,
    AttrType = Table_EquipEffect_t.AttrType[2],
    AttrRate = Table_EquipEffect_t.AttrRate[2],
    Dsc = "##1211215"
  },
  [142158001] = {
    id = 142158001,
    EquipID = 142158,
    AttrType = Table_EquipEffect_t.AttrType[12],
    AttrRate = Table_EquipEffect_t.AttrRate[9],
    Dsc = "##1123353"
  },
  [142158002] = {
    id = 142158002,
    EquipID = 142158,
    AttrType = Table_EquipEffect_t.AttrType[13],
    AttrRate = Table_EquipEffect_t.AttrRate[10],
    Dsc = "##312072"
  },
  [142158003] = {
    id = 142158003,
    EquipID = 142158,
    AttrType = Table_EquipEffect_t.AttrType[27],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##312088"
  },
  [142158004] = {
    id = 142158004,
    EquipID = 142158,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[10]
  },
  [142158005] = {
    id = 142158005,
    EquipID = 142158,
    AttrType = Table_EquipEffect_t.AttrType[36],
    AttrRate = Table_EquipEffect_t.AttrRate[20],
    Dsc = "##1123644"
  },
  [142158006] = {
    id = 142158006,
    EquipID = 142158,
    AttrType = Table_EquipEffect_t.AttrType[35],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123376"
  },
  [142159001] = {
    id = 142159001,
    EquipID = 142159,
    AttrType = Table_EquipEffect_t.AttrType[12],
    AttrRate = Table_EquipEffect_t.AttrRate[9],
    Dsc = "##1123353"
  },
  [142159002] = {
    id = 142159002,
    EquipID = 142159,
    AttrType = Table_EquipEffect_t.AttrType[13],
    AttrRate = Table_EquipEffect_t.AttrRate[10],
    Dsc = "##312072"
  },
  [142159003] = {
    id = 142159003,
    EquipID = 142159,
    AttrType = Table_EquipEffect_t.AttrType[27],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##312088"
  },
  [142159004] = {
    id = 142159004,
    EquipID = 142159,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[10]
  },
  [142159005] = {
    id = 142159005,
    EquipID = 142159,
    AttrType = Table_EquipEffect_t.AttrType[36],
    AttrRate = Table_EquipEffect_t.AttrRate[20],
    Dsc = "##1123644"
  },
  [142159006] = {
    id = 142159006,
    EquipID = 142159,
    AttrType = Table_EquipEffect_t.AttrType[35],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123376"
  },
  [142159007] = {
    id = 142159007,
    EquipID = 142159,
    GroupID = 2,
    AttrType = Table_EquipEffect_t.AttrType[2],
    AttrRate = Table_EquipEffect_t.AttrRate[2],
    Dsc = "##1211215"
  },
  [142161001] = {
    id = 142161001,
    EquipID = 142161,
    AttrType = Table_EquipEffect_t.AttrType[21],
    AttrRate = Table_EquipEffect_t.AttrRate[24],
    Dsc = "##312074"
  },
  [142161002] = {
    id = 142161002,
    EquipID = 142161,
    AttrType = Table_EquipEffect_t.AttrType[13],
    AttrRate = Table_EquipEffect_t.AttrRate[10],
    Dsc = "##312072"
  },
  [142161003] = {
    id = 142161003,
    EquipID = 142161,
    AttrType = Table_EquipEffect_t.AttrType[27],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##312088"
  },
  [142161004] = {
    id = 142161004,
    EquipID = 142161,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[10]
  },
  [142161005] = {
    id = 142161005,
    EquipID = 142161,
    AttrType = Table_EquipEffect_t.AttrType[36],
    AttrRate = Table_EquipEffect_t.AttrRate[20],
    Dsc = "##1123644"
  },
  [142161006] = {
    id = 142161006,
    EquipID = 142161,
    AttrType = Table_EquipEffect_t.AttrType[35],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123376"
  },
  [142162001] = {
    id = 142162001,
    EquipID = 142162,
    AttrType = Table_EquipEffect_t.AttrType[21],
    AttrRate = Table_EquipEffect_t.AttrRate[24],
    Dsc = "##312074"
  },
  [142162002] = {
    id = 142162002,
    EquipID = 142162,
    AttrType = Table_EquipEffect_t.AttrType[13],
    AttrRate = Table_EquipEffect_t.AttrRate[10],
    Dsc = "##312072"
  },
  [142162003] = {
    id = 142162003,
    EquipID = 142162,
    AttrType = Table_EquipEffect_t.AttrType[27],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##312088"
  },
  [142162004] = {
    id = 142162004,
    EquipID = 142162,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[10]
  },
  [142162005] = {
    id = 142162005,
    EquipID = 142162,
    AttrType = Table_EquipEffect_t.AttrType[36],
    AttrRate = Table_EquipEffect_t.AttrRate[20],
    Dsc = "##1123644"
  },
  [142162006] = {
    id = 142162006,
    EquipID = 142162,
    AttrType = Table_EquipEffect_t.AttrType[35],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123376"
  },
  [142162007] = {
    id = 142162007,
    EquipID = 142162,
    GroupID = 2,
    AttrType = Table_EquipEffect_t.AttrType[2],
    AttrRate = Table_EquipEffect_t.AttrRate[2],
    Dsc = "##1211215"
  },
  [142164001] = {
    id = 142164001,
    EquipID = 142164,
    AttrType = Table_EquipEffect_t.AttrType[35],
    AttrRate = Table_EquipEffect_t.AttrRate[24],
    Dsc = "##1123376"
  },
  [142164002] = {
    id = 142164002,
    EquipID = 142164,
    AttrType = Table_EquipEffect_t.AttrType[13],
    AttrRate = Table_EquipEffect_t.AttrRate[10],
    Dsc = "##312072"
  },
  [142164003] = {
    id = 142164003,
    EquipID = 142164,
    AttrType = Table_EquipEffect_t.AttrType[27],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##312088"
  },
  [142164004] = {
    id = 142164004,
    EquipID = 142164,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[10]
  },
  [142164005] = {
    id = 142164005,
    EquipID = 142164,
    AttrType = Table_EquipEffect_t.AttrType[29],
    AttrRate = Table_EquipEffect_t.AttrRate[30],
    Dsc = "##1123393"
  },
  [142164006] = {
    id = 142164006,
    EquipID = 142164,
    AttrType = Table_EquipEffect_t.AttrType[37],
    AttrRate = Table_EquipEffect_t.AttrRate[20],
    Dsc = "##1123642"
  },
  [142165001] = {
    id = 142165001,
    EquipID = 142165,
    AttrType = Table_EquipEffect_t.AttrType[35],
    AttrRate = Table_EquipEffect_t.AttrRate[24],
    Dsc = "##1123376"
  },
  [142165002] = {
    id = 142165002,
    EquipID = 142165,
    AttrType = Table_EquipEffect_t.AttrType[13],
    AttrRate = Table_EquipEffect_t.AttrRate[10],
    Dsc = "##312072"
  },
  [142165003] = {
    id = 142165003,
    EquipID = 142165,
    AttrType = Table_EquipEffect_t.AttrType[27],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##312088"
  },
  [142165004] = {
    id = 142165004,
    EquipID = 142165,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[10]
  },
  [142165005] = {
    id = 142165005,
    EquipID = 142165,
    AttrType = Table_EquipEffect_t.AttrType[29],
    AttrRate = Table_EquipEffect_t.AttrRate[30],
    Dsc = "##1123393"
  },
  [142165006] = {
    id = 142165006,
    EquipID = 142165,
    AttrType = Table_EquipEffect_t.AttrType[37],
    AttrRate = Table_EquipEffect_t.AttrRate[20],
    Dsc = "##1123642"
  },
  [142165007] = {
    id = 142165007,
    EquipID = 142165,
    GroupID = 2,
    AttrType = Table_EquipEffect_t.AttrType[2],
    AttrRate = Table_EquipEffect_t.AttrRate[2],
    Dsc = "##1211215"
  },
  [142167001] = {
    id = 142167001,
    EquipID = 142167,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[9]
  },
  [142167002] = {
    id = 142167002,
    EquipID = 142167,
    AttrType = Table_EquipEffect_t.AttrType[13],
    AttrRate = Table_EquipEffect_t.AttrRate[10],
    Dsc = "##312072"
  },
  [142167003] = {
    id = 142167003,
    EquipID = 142167,
    AttrType = Table_EquipEffect_t.AttrType[27],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##312088"
  },
  [142167004] = {
    id = 142167004,
    EquipID = 142167,
    AttrType = Table_EquipEffect_t.AttrType[35],
    AttrRate = Table_EquipEffect_t.AttrRate[32],
    Dsc = "##1123376"
  },
  [142167005] = {
    id = 142167005,
    EquipID = 142167,
    AttrType = Table_EquipEffect_t.AttrType[29],
    AttrRate = Table_EquipEffect_t.AttrRate[30],
    Dsc = "##1123393"
  },
  [142167006] = {
    id = 142167006,
    EquipID = 142167,
    AttrType = Table_EquipEffect_t.AttrType[37],
    AttrRate = Table_EquipEffect_t.AttrRate[20],
    Dsc = "##1123642"
  },
  [142168001] = {
    id = 142168001,
    EquipID = 142168,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[9]
  },
  [142168002] = {
    id = 142168002,
    EquipID = 142168,
    AttrType = Table_EquipEffect_t.AttrType[13],
    AttrRate = Table_EquipEffect_t.AttrRate[10],
    Dsc = "##312072"
  },
  [142168003] = {
    id = 142168003,
    EquipID = 142168,
    AttrType = Table_EquipEffect_t.AttrType[27],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##312088"
  },
  [142168004] = {
    id = 142168004,
    EquipID = 142168,
    AttrType = Table_EquipEffect_t.AttrType[35],
    AttrRate = Table_EquipEffect_t.AttrRate[32],
    Dsc = "##1123376"
  },
  [142168005] = {
    id = 142168005,
    EquipID = 142168,
    AttrType = Table_EquipEffect_t.AttrType[29],
    AttrRate = Table_EquipEffect_t.AttrRate[30],
    Dsc = "##1123393"
  },
  [142168006] = {
    id = 142168006,
    EquipID = 142168,
    AttrType = Table_EquipEffect_t.AttrType[37],
    AttrRate = Table_EquipEffect_t.AttrRate[20],
    Dsc = "##1123642"
  },
  [142168007] = {
    id = 142168007,
    EquipID = 142168,
    GroupID = 2,
    AttrType = Table_EquipEffect_t.AttrType[2],
    AttrRate = Table_EquipEffect_t.AttrRate[2],
    Dsc = "##1211215"
  },
  [142170001] = {
    id = 142170001,
    EquipID = 142170,
    AttrType = Table_EquipEffect_t.AttrType[32],
    AttrRate = Table_EquipEffect_t.AttrRate[31],
    Dsc = "##1123386"
  },
  [142170002] = {
    id = 142170002,
    EquipID = 142170,
    AttrType = Table_EquipEffect_t.AttrType[13],
    AttrRate = Table_EquipEffect_t.AttrRate[10],
    Dsc = "##312072"
  },
  [142170003] = {
    id = 142170003,
    EquipID = 142170,
    AttrType = Table_EquipEffect_t.AttrType[27],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##312088"
  },
  [142170004] = {
    id = 142170004,
    EquipID = 142170,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[10]
  },
  [142170005] = {
    id = 142170005,
    EquipID = 142170,
    AttrType = Table_EquipEffect_t.AttrType[29],
    AttrRate = Table_EquipEffect_t.AttrRate[30],
    Dsc = "##1123393"
  },
  [142170006] = {
    id = 142170006,
    EquipID = 142170,
    AttrType = Table_EquipEffect_t.AttrType[37],
    AttrRate = Table_EquipEffect_t.AttrRate[20],
    Dsc = "##1123642"
  },
  [142171001] = {
    id = 142171001,
    EquipID = 142171,
    AttrType = Table_EquipEffect_t.AttrType[32],
    AttrRate = Table_EquipEffect_t.AttrRate[31],
    Dsc = "##1123386"
  },
  [142171002] = {
    id = 142171002,
    EquipID = 142171,
    AttrType = Table_EquipEffect_t.AttrType[13],
    AttrRate = Table_EquipEffect_t.AttrRate[10],
    Dsc = "##312072"
  },
  [142171003] = {
    id = 142171003,
    EquipID = 142171,
    AttrType = Table_EquipEffect_t.AttrType[27],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##312088"
  },
  [142171004] = {
    id = 142171004,
    EquipID = 142171,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[10]
  },
  [142171005] = {
    id = 142171005,
    EquipID = 142171,
    AttrType = Table_EquipEffect_t.AttrType[29],
    AttrRate = Table_EquipEffect_t.AttrRate[30],
    Dsc = "##1123393"
  },
  [142171006] = {
    id = 142171006,
    EquipID = 142171,
    AttrType = Table_EquipEffect_t.AttrType[37],
    AttrRate = Table_EquipEffect_t.AttrRate[20],
    Dsc = "##1123642"
  },
  [142171007] = {
    id = 142171007,
    EquipID = 142171,
    GroupID = 2,
    AttrType = Table_EquipEffect_t.AttrType[2],
    AttrRate = Table_EquipEffect_t.AttrRate[2],
    Dsc = "##1211215"
  },
  [142176001] = {
    id = 142176001,
    EquipID = 142176,
    AttrType = Table_EquipEffect_t.AttrType[34],
    AttrRate = Table_EquipEffect_t.AttrRate[31],
    Dsc = "##1123381"
  },
  [142176002] = {
    id = 142176002,
    EquipID = 142176,
    AttrType = Table_EquipEffect_t.AttrType[13],
    AttrRate = Table_EquipEffect_t.AttrRate[10],
    Dsc = "##312072"
  },
  [142176003] = {
    id = 142176003,
    EquipID = 142176,
    AttrType = Table_EquipEffect_t.AttrType[27],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##312088"
  },
  [142176004] = {
    id = 142176004,
    EquipID = 142176,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[10]
  },
  [142176005] = {
    id = 142176005,
    EquipID = 142176,
    AttrType = Table_EquipEffect_t.AttrType[29],
    AttrRate = Table_EquipEffect_t.AttrRate[30],
    Dsc = "##1123393"
  },
  [142176006] = {
    id = 142176006,
    EquipID = 142176,
    AttrType = Table_EquipEffect_t.AttrType[37],
    AttrRate = Table_EquipEffect_t.AttrRate[20],
    Dsc = "##1123642"
  },
  [142177001] = {
    id = 142177001,
    EquipID = 142177,
    AttrType = Table_EquipEffect_t.AttrType[34],
    AttrRate = Table_EquipEffect_t.AttrRate[31],
    Dsc = "##1123381"
  },
  [142177002] = {
    id = 142177002,
    EquipID = 142177,
    AttrType = Table_EquipEffect_t.AttrType[13],
    AttrRate = Table_EquipEffect_t.AttrRate[10],
    Dsc = "##312072"
  },
  [142177003] = {
    id = 142177003,
    EquipID = 142177,
    AttrType = Table_EquipEffect_t.AttrType[27],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##312088"
  },
  [142177004] = {
    id = 142177004,
    EquipID = 142177,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[10]
  },
  [142177005] = {
    id = 142177005,
    EquipID = 142177,
    AttrType = Table_EquipEffect_t.AttrType[29],
    AttrRate = Table_EquipEffect_t.AttrRate[30],
    Dsc = "##1123393"
  },
  [142177006] = {
    id = 142177006,
    EquipID = 142177,
    AttrType = Table_EquipEffect_t.AttrType[37],
    AttrRate = Table_EquipEffect_t.AttrRate[20],
    Dsc = "##1123642"
  },
  [142177007] = {
    id = 142177007,
    EquipID = 142177,
    GroupID = 2,
    AttrType = Table_EquipEffect_t.AttrType[2],
    AttrRate = Table_EquipEffect_t.AttrRate[2],
    Dsc = "##1211215"
  },
  [142179001] = {
    id = 142179001,
    EquipID = 142179,
    AttrType = Table_EquipEffect_t.AttrType[33],
    AttrRate = Table_EquipEffect_t.AttrRate[9],
    Dsc = "##1123666"
  },
  [142179002] = {
    id = 142179002,
    EquipID = 142179,
    AttrType = Table_EquipEffect_t.AttrType[13],
    AttrRate = Table_EquipEffect_t.AttrRate[10],
    Dsc = "##312072"
  },
  [142179003] = {
    id = 142179003,
    EquipID = 142179,
    AttrType = Table_EquipEffect_t.AttrType[27],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##312088"
  },
  [142179004] = {
    id = 142179004,
    EquipID = 142179,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[10]
  },
  [142179005] = {
    id = 142179005,
    EquipID = 142179,
    AttrType = Table_EquipEffect_t.AttrType[29],
    AttrRate = Table_EquipEffect_t.AttrRate[30],
    Dsc = "##1123393"
  },
  [142179006] = {
    id = 142179006,
    EquipID = 142179,
    AttrType = Table_EquipEffect_t.AttrType[37],
    AttrRate = Table_EquipEffect_t.AttrRate[20],
    Dsc = "##1123642"
  },
  [142180001] = {
    id = 142180001,
    EquipID = 142180,
    AttrType = Table_EquipEffect_t.AttrType[33],
    AttrRate = Table_EquipEffect_t.AttrRate[9],
    Dsc = "##1123666"
  },
  [142180002] = {
    id = 142180002,
    EquipID = 142180,
    AttrType = Table_EquipEffect_t.AttrType[13],
    AttrRate = Table_EquipEffect_t.AttrRate[10],
    Dsc = "##312072"
  },
  [142180003] = {
    id = 142180003,
    EquipID = 142180,
    AttrType = Table_EquipEffect_t.AttrType[27],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##312088"
  },
  [142180004] = {
    id = 142180004,
    EquipID = 142180,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[10]
  },
  [142180005] = {
    id = 142180005,
    EquipID = 142180,
    AttrType = Table_EquipEffect_t.AttrType[29],
    AttrRate = Table_EquipEffect_t.AttrRate[30],
    Dsc = "##1123393"
  },
  [142180006] = {
    id = 142180006,
    EquipID = 142180,
    AttrType = Table_EquipEffect_t.AttrType[37],
    AttrRate = Table_EquipEffect_t.AttrRate[20],
    Dsc = "##1123642"
  },
  [142180007] = {
    id = 142180007,
    EquipID = 142180,
    GroupID = 2,
    AttrType = Table_EquipEffect_t.AttrType[2],
    AttrRate = Table_EquipEffect_t.AttrRate[2],
    Dsc = "##1211215"
  },
  [142185001] = {
    id = 142185001,
    EquipID = 142185,
    AttrType = Table_EquipEffect_t.AttrType[22],
    AttrRate = Table_EquipEffect_t.AttrRate[25],
    Dsc = "##312087"
  },
  [142186001] = {
    id = 142186001,
    EquipID = 142186,
    AttrType = Table_EquipEffect_t.AttrType[3],
    AttrRate = Table_EquipEffect_t.AttrRate[25],
    Dsc = "##1110946"
  },
  [142187001] = {
    id = 142187001,
    EquipID = 142187,
    AttrType = Table_EquipEffect_t.AttrType[18],
    AttrRate = Table_EquipEffect_t.AttrRate[25],
    Dsc = "##1123327"
  },
  [142188001] = {
    id = 142188001,
    EquipID = 142188,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[25]
  },
  [142189001] = {
    id = 142189001,
    EquipID = 142189,
    AttrType = Table_EquipEffect_t.AttrType[23],
    AttrRate = Table_EquipEffect_t.AttrRate[19],
    Dsc = "##312079"
  },
  [142609001] = {
    id = 142609001,
    EquipID = 142609,
    AttrType = Table_EquipEffect_t.AttrType[18],
    AttrRate = Table_EquipEffect_t.AttrRate[18],
    Dsc = "##1123327"
  },
  [142609002] = {
    id = 142609002,
    EquipID = 142609,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123328"
  },
  [142609003] = {
    id = 142609003,
    EquipID = 142609,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123329"
  },
  [142609004] = {
    id = 142609004,
    EquipID = 142609,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[13]
  },
  [142609005] = {
    id = 142609005,
    EquipID = 142609,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[14],
    Dsc = "##1123330"
  },
  [142609006] = {
    id = 142609006,
    EquipID = 142609,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[14],
    Dsc = "##1123331"
  },
  [142610001] = {
    id = 142610001,
    EquipID = 142610,
    AttrType = Table_EquipEffect_t.AttrType[18],
    AttrRate = Table_EquipEffect_t.AttrRate[18],
    Dsc = "##1123327"
  },
  [142610002] = {
    id = 142610002,
    EquipID = 142610,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123328"
  },
  [142610003] = {
    id = 142610003,
    EquipID = 142610,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123329"
  },
  [142610004] = {
    id = 142610004,
    EquipID = 142610,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[13]
  },
  [142610005] = {
    id = 142610005,
    EquipID = 142610,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[14],
    Dsc = "##1123330"
  },
  [142610006] = {
    id = 142610006,
    EquipID = 142610,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[14],
    Dsc = "##1123331"
  },
  [142610007] = {
    id = 142610007,
    EquipID = 142610,
    GroupID = 2,
    AttrType = Table_EquipEffect_t.AttrType[2],
    AttrRate = Table_EquipEffect_t.AttrRate[2],
    Dsc = "##1211215"
  },
  [142625001] = {
    id = 142625001,
    EquipID = 142625,
    AttrType = Table_EquipEffect_t.AttrType[3],
    AttrRate = Table_EquipEffect_t.AttrRate[18],
    Dsc = "##1110946"
  },
  [142625002] = {
    id = 142625002,
    EquipID = 142625,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123328"
  },
  [142625003] = {
    id = 142625003,
    EquipID = 142625,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123329"
  },
  [142625004] = {
    id = 142625004,
    EquipID = 142625,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[13]
  },
  [142625005] = {
    id = 142625005,
    EquipID = 142625,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[14],
    Dsc = "##1123330"
  },
  [142625006] = {
    id = 142625006,
    EquipID = 142625,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[14],
    Dsc = "##1123331"
  },
  [142626001] = {
    id = 142626001,
    EquipID = 142626,
    AttrType = Table_EquipEffect_t.AttrType[3],
    AttrRate = Table_EquipEffect_t.AttrRate[18],
    Dsc = "##1110946"
  },
  [142626002] = {
    id = 142626002,
    EquipID = 142626,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123328"
  },
  [142626003] = {
    id = 142626003,
    EquipID = 142626,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123329"
  },
  [142626004] = {
    id = 142626004,
    EquipID = 142626,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[13]
  },
  [142626005] = {
    id = 142626005,
    EquipID = 142626,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[14],
    Dsc = "##1123330"
  },
  [142626006] = {
    id = 142626006,
    EquipID = 142626,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[14],
    Dsc = "##1123331"
  },
  [142626007] = {
    id = 142626007,
    EquipID = 142626,
    GroupID = 2,
    AttrType = Table_EquipEffect_t.AttrType[2],
    AttrRate = Table_EquipEffect_t.AttrRate[2],
    Dsc = "##1211215"
  },
  [142628001] = {
    id = 142628001,
    EquipID = 142628,
    AttrType = Table_EquipEffect_t.AttrType[3],
    AttrRate = Table_EquipEffect_t.AttrRate[18],
    Dsc = "##1110946"
  },
  [142628002] = {
    id = 142628002,
    EquipID = 142628,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123328"
  },
  [142628003] = {
    id = 142628003,
    EquipID = 142628,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123329"
  },
  [142628004] = {
    id = 142628004,
    EquipID = 142628,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[13]
  },
  [142628005] = {
    id = 142628005,
    EquipID = 142628,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[14],
    Dsc = "##1123330"
  },
  [142628006] = {
    id = 142628006,
    EquipID = 142628,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[14],
    Dsc = "##1123331"
  },
  [142629001] = {
    id = 142629001,
    EquipID = 142629,
    AttrType = Table_EquipEffect_t.AttrType[3],
    AttrRate = Table_EquipEffect_t.AttrRate[18],
    Dsc = "##1110946"
  },
  [142629002] = {
    id = 142629002,
    EquipID = 142629,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123328"
  },
  [142629003] = {
    id = 142629003,
    EquipID = 142629,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123329"
  },
  [142629004] = {
    id = 142629004,
    EquipID = 142629,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[13]
  },
  [142629005] = {
    id = 142629005,
    EquipID = 142629,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[14],
    Dsc = "##1123330"
  },
  [142629006] = {
    id = 142629006,
    EquipID = 142629,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[14],
    Dsc = "##1123331"
  },
  [142629007] = {
    id = 142629007,
    EquipID = 142629,
    GroupID = 2,
    AttrType = Table_EquipEffect_t.AttrType[2],
    AttrRate = Table_EquipEffect_t.AttrRate[2],
    Dsc = "##1211215"
  },
  [142631001] = {
    id = 142631001,
    EquipID = 142631,
    AttrType = Table_EquipEffect_t.AttrType[19],
    AttrRate = Table_EquipEffect_t.AttrRate[15],
    Dsc = "##312089"
  },
  [142631002] = {
    id = 142631002,
    EquipID = 142631,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123328"
  },
  [142631003] = {
    id = 142631003,
    EquipID = 142631,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123329"
  },
  [142631004] = {
    id = 142631004,
    EquipID = 142631,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[13]
  },
  [142631005] = {
    id = 142631005,
    EquipID = 142631,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[14],
    Dsc = "##1123330"
  },
  [142631006] = {
    id = 142631006,
    EquipID = 142631,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[14],
    Dsc = "##1123331"
  },
  [142632001] = {
    id = 142632001,
    EquipID = 142632,
    AttrType = Table_EquipEffect_t.AttrType[19],
    AttrRate = Table_EquipEffect_t.AttrRate[15],
    Dsc = "##312089"
  },
  [142632002] = {
    id = 142632002,
    EquipID = 142632,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123328"
  },
  [142632003] = {
    id = 142632003,
    EquipID = 142632,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123329"
  },
  [142632004] = {
    id = 142632004,
    EquipID = 142632,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[13]
  },
  [142632005] = {
    id = 142632005,
    EquipID = 142632,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[14],
    Dsc = "##1123330"
  },
  [142632006] = {
    id = 142632006,
    EquipID = 142632,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[14],
    Dsc = "##1123331"
  },
  [142632007] = {
    id = 142632007,
    EquipID = 142632,
    GroupID = 2,
    AttrType = Table_EquipEffect_t.AttrType[2],
    AttrRate = Table_EquipEffect_t.AttrRate[2],
    Dsc = "##1211215"
  },
  [142634001] = {
    id = 142634001,
    EquipID = 142634,
    AttrType = Table_EquipEffect_t.AttrType[16],
    AttrRate = Table_EquipEffect_t.AttrRate[15],
    Dsc = "##312078"
  },
  [142634002] = {
    id = 142634002,
    EquipID = 142634,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123328"
  },
  [142634003] = {
    id = 142634003,
    EquipID = 142634,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123329"
  },
  [142634004] = {
    id = 142634004,
    EquipID = 142634,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[13]
  },
  [142634005] = {
    id = 142634005,
    EquipID = 142634,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[14],
    Dsc = "##1123330"
  },
  [142634006] = {
    id = 142634006,
    EquipID = 142634,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[14],
    Dsc = "##1123331"
  },
  [142635001] = {
    id = 142635001,
    EquipID = 142635,
    AttrType = Table_EquipEffect_t.AttrType[16],
    AttrRate = Table_EquipEffect_t.AttrRate[15],
    Dsc = "##312078"
  },
  [142635002] = {
    id = 142635002,
    EquipID = 142635,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123328"
  },
  [142635003] = {
    id = 142635003,
    EquipID = 142635,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123329"
  },
  [142635004] = {
    id = 142635004,
    EquipID = 142635,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[13]
  },
  [142635005] = {
    id = 142635005,
    EquipID = 142635,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[14],
    Dsc = "##1123330"
  },
  [142635006] = {
    id = 142635006,
    EquipID = 142635,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[14],
    Dsc = "##1123331"
  },
  [142635007] = {
    id = 142635007,
    EquipID = 142635,
    GroupID = 2,
    AttrType = Table_EquipEffect_t.AttrType[2],
    AttrRate = Table_EquipEffect_t.AttrRate[2],
    Dsc = "##1211215"
  },
  [142637001] = {
    id = 142637001,
    EquipID = 142637,
    AttrType = Table_EquipEffect_t.AttrType[14],
    AttrRate = Table_EquipEffect_t.AttrRate[11],
    Dsc = "##1123348"
  },
  [142637002] = {
    id = 142637002,
    EquipID = 142637,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123328"
  },
  [142637003] = {
    id = 142637003,
    EquipID = 142637,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123329"
  },
  [142637004] = {
    id = 142637004,
    EquipID = 142637,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[13]
  },
  [142637005] = {
    id = 142637005,
    EquipID = 142637,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[14],
    Dsc = "##1123330"
  },
  [142637006] = {
    id = 142637006,
    EquipID = 142637,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[14],
    Dsc = "##1123331"
  },
  [142638001] = {
    id = 142638001,
    EquipID = 142638,
    AttrType = Table_EquipEffect_t.AttrType[14],
    AttrRate = Table_EquipEffect_t.AttrRate[11],
    Dsc = "##1123348"
  },
  [142638002] = {
    id = 142638002,
    EquipID = 142638,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123328"
  },
  [142638003] = {
    id = 142638003,
    EquipID = 142638,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123329"
  },
  [142638004] = {
    id = 142638004,
    EquipID = 142638,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[13]
  },
  [142638005] = {
    id = 142638005,
    EquipID = 142638,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[14],
    Dsc = "##1123330"
  },
  [142638006] = {
    id = 142638006,
    EquipID = 142638,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[14],
    Dsc = "##1123331"
  },
  [142638007] = {
    id = 142638007,
    EquipID = 142638,
    GroupID = 2,
    AttrType = Table_EquipEffect_t.AttrType[2],
    AttrRate = Table_EquipEffect_t.AttrRate[2],
    Dsc = "##1211215"
  },
  [142640001] = {
    id = 142640001,
    EquipID = 142640,
    AttrType = Table_EquipEffect_t.AttrType[12],
    AttrRate = Table_EquipEffect_t.AttrRate[18],
    Dsc = "##1123353"
  },
  [142640002] = {
    id = 142640002,
    EquipID = 142640,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123328"
  },
  [142640003] = {
    id = 142640003,
    EquipID = 142640,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123329"
  },
  [142640004] = {
    id = 142640004,
    EquipID = 142640,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[13]
  },
  [142640005] = {
    id = 142640005,
    EquipID = 142640,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[14],
    Dsc = "##1123330"
  },
  [142640006] = {
    id = 142640006,
    EquipID = 142640,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[14],
    Dsc = "##1123331"
  },
  [142641001] = {
    id = 142641001,
    EquipID = 142641,
    AttrType = Table_EquipEffect_t.AttrType[12],
    AttrRate = Table_EquipEffect_t.AttrRate[18],
    Dsc = "##1123353"
  },
  [142641002] = {
    id = 142641002,
    EquipID = 142641,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123328"
  },
  [142641003] = {
    id = 142641003,
    EquipID = 142641,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123329"
  },
  [142641004] = {
    id = 142641004,
    EquipID = 142641,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[13]
  },
  [142641005] = {
    id = 142641005,
    EquipID = 142641,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[14],
    Dsc = "##1123330"
  },
  [142641006] = {
    id = 142641006,
    EquipID = 142641,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[14],
    Dsc = "##1123331"
  },
  [142641007] = {
    id = 142641007,
    EquipID = 142641,
    GroupID = 2,
    AttrType = Table_EquipEffect_t.AttrType[2],
    AttrRate = Table_EquipEffect_t.AttrRate[2],
    Dsc = "##1211215"
  },
  [142643001] = {
    id = 142643001,
    EquipID = 142643,
    AttrType = Table_EquipEffect_t.AttrType[26],
    AttrRate = Table_EquipEffect_t.AttrRate[15],
    Dsc = "##312080"
  },
  [142643002] = {
    id = 142643002,
    EquipID = 142643,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123328"
  },
  [142643003] = {
    id = 142643003,
    EquipID = 142643,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123329"
  },
  [142643004] = {
    id = 142643004,
    EquipID = 142643,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[13]
  },
  [142643005] = {
    id = 142643005,
    EquipID = 142643,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[14],
    Dsc = "##1123330"
  },
  [142643006] = {
    id = 142643006,
    EquipID = 142643,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[14],
    Dsc = "##1123331"
  },
  [142644001] = {
    id = 142644001,
    EquipID = 142644,
    AttrType = Table_EquipEffect_t.AttrType[26],
    AttrRate = Table_EquipEffect_t.AttrRate[15],
    Dsc = "##312080"
  },
  [142644002] = {
    id = 142644002,
    EquipID = 142644,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123328"
  },
  [142644003] = {
    id = 142644003,
    EquipID = 142644,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123329"
  },
  [142644004] = {
    id = 142644004,
    EquipID = 142644,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[13]
  },
  [142644005] = {
    id = 142644005,
    EquipID = 142644,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[14],
    Dsc = "##1123330"
  },
  [142644006] = {
    id = 142644006,
    EquipID = 142644,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[14],
    Dsc = "##1123331"
  },
  [142644007] = {
    id = 142644007,
    EquipID = 142644,
    GroupID = 2,
    AttrType = Table_EquipEffect_t.AttrType[2],
    AttrRate = Table_EquipEffect_t.AttrRate[2],
    Dsc = "##1211215"
  },
  [142646001] = {
    id = 142646001,
    EquipID = 142646,
    AttrType = Table_EquipEffect_t.AttrType[17],
    AttrRate = Table_EquipEffect_t.AttrRate[18],
    Dsc = "##1110947"
  },
  [142646002] = {
    id = 142646002,
    EquipID = 142646,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123328"
  },
  [142646003] = {
    id = 142646003,
    EquipID = 142646,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123329"
  },
  [142646004] = {
    id = 142646004,
    EquipID = 142646,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[13]
  },
  [142646005] = {
    id = 142646005,
    EquipID = 142646,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[14],
    Dsc = "##1123330"
  },
  [142646006] = {
    id = 142646006,
    EquipID = 142646,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[14],
    Dsc = "##1123331"
  },
  [142647001] = {
    id = 142647001,
    EquipID = 142647,
    AttrType = Table_EquipEffect_t.AttrType[17],
    AttrRate = Table_EquipEffect_t.AttrRate[18],
    Dsc = "##1110947"
  },
  [142647002] = {
    id = 142647002,
    EquipID = 142647,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123328"
  },
  [142647003] = {
    id = 142647003,
    EquipID = 142647,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123329"
  },
  [142647004] = {
    id = 142647004,
    EquipID = 142647,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[13]
  },
  [142647005] = {
    id = 142647005,
    EquipID = 142647,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[14],
    Dsc = "##1123330"
  },
  [142647006] = {
    id = 142647006,
    EquipID = 142647,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[14],
    Dsc = "##1123331"
  },
  [142647007] = {
    id = 142647007,
    EquipID = 142647,
    GroupID = 2,
    AttrType = Table_EquipEffect_t.AttrType[2],
    AttrRate = Table_EquipEffect_t.AttrRate[2],
    Dsc = "##1211215"
  },
  [142649001] = {
    id = 142649001,
    EquipID = 142649,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[18]
  },
  [142649002] = {
    id = 142649002,
    EquipID = 142649,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123328"
  },
  [142649003] = {
    id = 142649003,
    EquipID = 142649,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123329"
  },
  [142649004] = {
    id = 142649004,
    EquipID = 142649,
    AttrType = Table_EquipEffect_t.AttrType[38],
    AttrRate = Table_EquipEffect_t.AttrRate[30],
    Dsc = "##1123368"
  },
  [142649005] = {
    id = 142649005,
    EquipID = 142649,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[14],
    Dsc = "##1123330"
  },
  [142649006] = {
    id = 142649006,
    EquipID = 142649,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[14],
    Dsc = "##1123331"
  },
  [142650001] = {
    id = 142650001,
    EquipID = 142650,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[18]
  },
  [142650002] = {
    id = 142650002,
    EquipID = 142650,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123328"
  },
  [142650003] = {
    id = 142650003,
    EquipID = 142650,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123329"
  },
  [142650004] = {
    id = 142650004,
    EquipID = 142650,
    AttrType = Table_EquipEffect_t.AttrType[38],
    AttrRate = Table_EquipEffect_t.AttrRate[30],
    Dsc = "##1123368"
  },
  [142650005] = {
    id = 142650005,
    EquipID = 142650,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[14],
    Dsc = "##1123330"
  },
  [142650006] = {
    id = 142650006,
    EquipID = 142650,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[14],
    Dsc = "##1123331"
  },
  [142650007] = {
    id = 142650007,
    EquipID = 142650,
    GroupID = 2,
    AttrType = Table_EquipEffect_t.AttrType[2],
    AttrRate = Table_EquipEffect_t.AttrRate[2],
    Dsc = "##1211215"
  },
  [142652001] = {
    id = 142652001,
    EquipID = 142652,
    AttrType = Table_EquipEffect_t.AttrType[31],
    AttrRate = Table_EquipEffect_t.AttrRate[24],
    Dsc = "##1123371"
  },
  [142652002] = {
    id = 142652002,
    EquipID = 142652,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123328"
  },
  [142652003] = {
    id = 142652003,
    EquipID = 142652,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123329"
  },
  [142652004] = {
    id = 142652004,
    EquipID = 142652,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[13]
  },
  [142652005] = {
    id = 142652005,
    EquipID = 142652,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[14],
    Dsc = "##1123330"
  },
  [142652006] = {
    id = 142652006,
    EquipID = 142652,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[14],
    Dsc = "##1123331"
  },
  [142653001] = {
    id = 142653001,
    EquipID = 142653,
    AttrType = Table_EquipEffect_t.AttrType[31],
    AttrRate = Table_EquipEffect_t.AttrRate[24],
    Dsc = "##1123371"
  },
  [142653002] = {
    id = 142653002,
    EquipID = 142653,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123328"
  },
  [142653003] = {
    id = 142653003,
    EquipID = 142653,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123329"
  },
  [142653004] = {
    id = 142653004,
    EquipID = 142653,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[13]
  },
  [142653005] = {
    id = 142653005,
    EquipID = 142653,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[14],
    Dsc = "##1123330"
  },
  [142653006] = {
    id = 142653006,
    EquipID = 142653,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[14],
    Dsc = "##1123331"
  },
  [142653007] = {
    id = 142653007,
    EquipID = 142653,
    GroupID = 2,
    AttrType = Table_EquipEffect_t.AttrType[2],
    AttrRate = Table_EquipEffect_t.AttrRate[2],
    Dsc = "##1211215"
  },
  [142655001] = {
    id = 142655001,
    EquipID = 142655,
    AttrType = Table_EquipEffect_t.AttrType[35],
    AttrRate = Table_EquipEffect_t.AttrRate[24],
    Dsc = "##1123376"
  },
  [142655002] = {
    id = 142655002,
    EquipID = 142655,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123328"
  },
  [142655003] = {
    id = 142655003,
    EquipID = 142655,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123329"
  },
  [142655004] = {
    id = 142655004,
    EquipID = 142655,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[13]
  },
  [142655005] = {
    id = 142655005,
    EquipID = 142655,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[14],
    Dsc = "##1123330"
  },
  [142655006] = {
    id = 142655006,
    EquipID = 142655,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[14],
    Dsc = "##1123331"
  },
  [142656001] = {
    id = 142656001,
    EquipID = 142656,
    AttrType = Table_EquipEffect_t.AttrType[35],
    AttrRate = Table_EquipEffect_t.AttrRate[24],
    Dsc = "##1123376"
  },
  [142656002] = {
    id = 142656002,
    EquipID = 142656,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123328"
  },
  [142656003] = {
    id = 142656003,
    EquipID = 142656,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123329"
  },
  [142656004] = {
    id = 142656004,
    EquipID = 142656,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[13]
  },
  [142656005] = {
    id = 142656005,
    EquipID = 142656,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[14],
    Dsc = "##1123330"
  },
  [142656006] = {
    id = 142656006,
    EquipID = 142656,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[14],
    Dsc = "##1123331"
  },
  [142656007] = {
    id = 142656007,
    EquipID = 142656,
    GroupID = 2,
    AttrType = Table_EquipEffect_t.AttrType[2],
    AttrRate = Table_EquipEffect_t.AttrRate[2],
    Dsc = "##1211215"
  },
  [142658001] = {
    id = 142658001,
    EquipID = 142658,
    AttrType = Table_EquipEffect_t.AttrType[34],
    AttrRate = Table_EquipEffect_t.AttrRate[24],
    Dsc = "##1123381"
  },
  [142658002] = {
    id = 142658002,
    EquipID = 142658,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123328"
  },
  [142658003] = {
    id = 142658003,
    EquipID = 142658,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123329"
  },
  [142658004] = {
    id = 142658004,
    EquipID = 142658,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[13]
  },
  [142658005] = {
    id = 142658005,
    EquipID = 142658,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[14],
    Dsc = "##1123330"
  },
  [142658006] = {
    id = 142658006,
    EquipID = 142658,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[14],
    Dsc = "##1123331"
  },
  [142659001] = {
    id = 142659001,
    EquipID = 142659,
    AttrType = Table_EquipEffect_t.AttrType[34],
    AttrRate = Table_EquipEffect_t.AttrRate[24],
    Dsc = "##1123381"
  },
  [142659002] = {
    id = 142659002,
    EquipID = 142659,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123328"
  },
  [142659003] = {
    id = 142659003,
    EquipID = 142659,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123329"
  },
  [142659004] = {
    id = 142659004,
    EquipID = 142659,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[13]
  },
  [142659005] = {
    id = 142659005,
    EquipID = 142659,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[14],
    Dsc = "##1123330"
  },
  [142659006] = {
    id = 142659006,
    EquipID = 142659,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[14],
    Dsc = "##1123331"
  },
  [142659007] = {
    id = 142659007,
    EquipID = 142659,
    GroupID = 2,
    AttrType = Table_EquipEffect_t.AttrType[2],
    AttrRate = Table_EquipEffect_t.AttrRate[2],
    Dsc = "##1211215"
  },
  [142661001] = {
    id = 142661001,
    EquipID = 142661,
    AttrType = Table_EquipEffect_t.AttrType[32],
    AttrRate = Table_EquipEffect_t.AttrRate[24],
    Dsc = "##1123386"
  },
  [142661002] = {
    id = 142661002,
    EquipID = 142661,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123328"
  },
  [142661003] = {
    id = 142661003,
    EquipID = 142661,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123329"
  },
  [142661004] = {
    id = 142661004,
    EquipID = 142661,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[13]
  },
  [142661005] = {
    id = 142661005,
    EquipID = 142661,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[14],
    Dsc = "##1123330"
  },
  [142661006] = {
    id = 142661006,
    EquipID = 142661,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[14],
    Dsc = "##1123331"
  },
  [142662001] = {
    id = 142662001,
    EquipID = 142662,
    AttrType = Table_EquipEffect_t.AttrType[32],
    AttrRate = Table_EquipEffect_t.AttrRate[24],
    Dsc = "##1123386"
  },
  [142662002] = {
    id = 142662002,
    EquipID = 142662,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123328"
  },
  [142662003] = {
    id = 142662003,
    EquipID = 142662,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123329"
  },
  [142662004] = {
    id = 142662004,
    EquipID = 142662,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[13]
  },
  [142662005] = {
    id = 142662005,
    EquipID = 142662,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[14],
    Dsc = "##1123330"
  },
  [142662006] = {
    id = 142662006,
    EquipID = 142662,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[14],
    Dsc = "##1123331"
  },
  [142662007] = {
    id = 142662007,
    EquipID = 142662,
    GroupID = 2,
    AttrType = Table_EquipEffect_t.AttrType[2],
    AttrRate = Table_EquipEffect_t.AttrRate[2],
    Dsc = "##1211215"
  },
  [142664001] = {
    id = 142664001,
    EquipID = 142664,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[18]
  },
  [142664002] = {
    id = 142664002,
    EquipID = 142664,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123328"
  },
  [142664003] = {
    id = 142664003,
    EquipID = 142664,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123329"
  },
  [142664004] = {
    id = 142664004,
    EquipID = 142664,
    AttrType = Table_EquipEffect_t.AttrType[29],
    AttrRate = Table_EquipEffect_t.AttrRate[26],
    Dsc = "##1123393"
  },
  [142664005] = {
    id = 142664005,
    EquipID = 142664,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[14],
    Dsc = "##1123330"
  },
  [142664006] = {
    id = 142664006,
    EquipID = 142664,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[14],
    Dsc = "##1123331"
  },
  [142665001] = {
    id = 142665001,
    EquipID = 142665,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[18]
  },
  [142665002] = {
    id = 142665002,
    EquipID = 142665,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123328"
  },
  [142665003] = {
    id = 142665003,
    EquipID = 142665,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123329"
  },
  [142665004] = {
    id = 142665004,
    EquipID = 142665,
    AttrType = Table_EquipEffect_t.AttrType[29],
    AttrRate = Table_EquipEffect_t.AttrRate[26],
    Dsc = "##1123393"
  },
  [142665005] = {
    id = 142665005,
    EquipID = 142665,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[14],
    Dsc = "##1123330"
  },
  [142665006] = {
    id = 142665006,
    EquipID = 142665,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[14],
    Dsc = "##1123331"
  },
  [142665007] = {
    id = 142665007,
    EquipID = 142665,
    GroupID = 2,
    AttrType = Table_EquipEffect_t.AttrType[2],
    AttrRate = Table_EquipEffect_t.AttrRate[2],
    Dsc = "##1211215"
  },
  [142667001] = {
    id = 142667001,
    EquipID = 142667,
    AttrType = Table_EquipEffect_t.AttrType[21],
    AttrRate = Table_EquipEffect_t.AttrRate[15],
    Dsc = "##312074"
  },
  [142667002] = {
    id = 142667002,
    EquipID = 142667,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123328"
  },
  [142667003] = {
    id = 142667003,
    EquipID = 142667,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123329"
  },
  [142667004] = {
    id = 142667004,
    EquipID = 142667,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[13]
  },
  [142667005] = {
    id = 142667005,
    EquipID = 142667,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[14],
    Dsc = "##1123330"
  },
  [142667006] = {
    id = 142667006,
    EquipID = 142667,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[14],
    Dsc = "##1123331"
  },
  [142668001] = {
    id = 142668001,
    EquipID = 142668,
    AttrType = Table_EquipEffect_t.AttrType[21],
    AttrRate = Table_EquipEffect_t.AttrRate[15],
    Dsc = "##312074"
  },
  [142668002] = {
    id = 142668002,
    EquipID = 142668,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123328"
  },
  [142668003] = {
    id = 142668003,
    EquipID = 142668,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[12],
    Dsc = "##1123329"
  },
  [142668004] = {
    id = 142668004,
    EquipID = 142668,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[13]
  },
  [142668005] = {
    id = 142668005,
    EquipID = 142668,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[14],
    Dsc = "##1123330"
  },
  [142668006] = {
    id = 142668006,
    EquipID = 142668,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[14],
    Dsc = "##1123331"
  },
  [142668007] = {
    id = 142668007,
    EquipID = 142668,
    GroupID = 2,
    AttrType = Table_EquipEffect_t.AttrType[2],
    AttrRate = Table_EquipEffect_t.AttrRate[2],
    Dsc = "##1211215"
  },
  [142673001] = {
    id = 142673001,
    EquipID = 142673,
    AttrType = Table_EquipEffect_t.AttrType[22],
    AttrRate = Table_EquipEffect_t.AttrRate[16],
    Dsc = "##312087"
  },
  [142674001] = {
    id = 142674001,
    EquipID = 142674,
    AttrType = Table_EquipEffect_t.AttrType[19],
    AttrRate = Table_EquipEffect_t.AttrRate[17],
    Dsc = "##312089"
  },
  [142675001] = {
    id = 142675001,
    EquipID = 142675,
    AttrType = Table_EquipEffect_t.AttrType[16],
    AttrRate = Table_EquipEffect_t.AttrRate[17],
    Dsc = "##312078"
  },
  [142676001] = {
    id = 142676001,
    EquipID = 142676,
    AttrType = Table_EquipEffect_t.AttrType[17],
    AttrRate = Table_EquipEffect_t.AttrRate[16],
    Dsc = "##1110947"
  },
  [142677001] = {
    id = 142677001,
    EquipID = 142677,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[16]
  },
  [143071001] = {
    id = 143071001,
    EquipID = 143071,
    AttrType = Table_EquipEffect_t.AttrType[9],
    AttrRate = Table_EquipEffect_t.AttrRate[7],
    Dsc = "##1186390"
  },
  [143071002] = {
    id = 143071002,
    EquipID = 143071,
    AttrType = Table_EquipEffect_t.AttrType[10],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1186391"
  },
  [143071003] = {
    id = 143071003,
    EquipID = 143071,
    AttrType = Table_EquipEffect_t.AttrType[11],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1186392"
  },
  [143071004] = {
    id = 143071004,
    EquipID = 143071,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[1]
  },
  [143071005] = {
    id = 143071005,
    EquipID = 143071,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[8],
    Dsc = "##1123330"
  },
  [143071006] = {
    id = 143071006,
    EquipID = 143071,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[8],
    Dsc = "##1123331"
  },
  [143072001] = {
    id = 143072001,
    EquipID = 143072,
    AttrType = Table_EquipEffect_t.AttrType[9],
    AttrRate = Table_EquipEffect_t.AttrRate[7],
    Dsc = "##1186390"
  },
  [143072002] = {
    id = 143072002,
    EquipID = 143072,
    AttrType = Table_EquipEffect_t.AttrType[10],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1186391"
  },
  [143072003] = {
    id = 143072003,
    EquipID = 143072,
    AttrType = Table_EquipEffect_t.AttrType[11],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1186392"
  },
  [143072004] = {
    id = 143072004,
    EquipID = 143072,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[1]
  },
  [143072005] = {
    id = 143072005,
    EquipID = 143072,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[8],
    Dsc = "##1123330"
  },
  [143072006] = {
    id = 143072006,
    EquipID = 143072,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[8],
    Dsc = "##1123331"
  },
  [143072007] = {
    id = 143072007,
    EquipID = 143072,
    GroupID = 2,
    AttrType = Table_EquipEffect_t.AttrType[2],
    AttrRate = Table_EquipEffect_t.AttrRate[2],
    Dsc = "##1211215"
  },
  [143077001] = {
    id = 143077001,
    EquipID = 143077,
    AttrType = Table_EquipEffect_t.AttrType[30],
    AttrRate = Table_EquipEffect_t.AttrRate[7],
    Dsc = "##1186393"
  },
  [143077002] = {
    id = 143077002,
    EquipID = 143077,
    AttrType = Table_EquipEffect_t.AttrType[10],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1186391"
  },
  [143077003] = {
    id = 143077003,
    EquipID = 143077,
    AttrType = Table_EquipEffect_t.AttrType[11],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1186392"
  },
  [143077004] = {
    id = 143077004,
    EquipID = 143077,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[1]
  },
  [143077005] = {
    id = 143077005,
    EquipID = 143077,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[8],
    Dsc = "##1123330"
  },
  [143077006] = {
    id = 143077006,
    EquipID = 143077,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[8],
    Dsc = "##1123331"
  },
  [143078001] = {
    id = 143078001,
    EquipID = 143078,
    AttrType = Table_EquipEffect_t.AttrType[30],
    AttrRate = Table_EquipEffect_t.AttrRate[7],
    Dsc = "##1186393"
  },
  [143078002] = {
    id = 143078002,
    EquipID = 143078,
    AttrType = Table_EquipEffect_t.AttrType[10],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1186391"
  },
  [143078003] = {
    id = 143078003,
    EquipID = 143078,
    AttrType = Table_EquipEffect_t.AttrType[11],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1186392"
  },
  [143078004] = {
    id = 143078004,
    EquipID = 143078,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[1]
  },
  [143078005] = {
    id = 143078005,
    EquipID = 143078,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[8],
    Dsc = "##1123330"
  },
  [143078006] = {
    id = 143078006,
    EquipID = 143078,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[8],
    Dsc = "##1123331"
  },
  [143078007] = {
    id = 143078007,
    EquipID = 143078,
    GroupID = 2,
    AttrType = Table_EquipEffect_t.AttrType[2],
    AttrRate = Table_EquipEffect_t.AttrRate[2],
    Dsc = "##1211215"
  },
  [143080001] = {
    id = 143080001,
    EquipID = 143080,
    AttrType = Table_EquipEffect_t.AttrType[9],
    AttrRate = Table_EquipEffect_t.AttrRate[7],
    Dsc = "##1186390"
  },
  [143080002] = {
    id = 143080002,
    EquipID = 143080,
    AttrType = Table_EquipEffect_t.AttrType[10],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1186391"
  },
  [143080003] = {
    id = 143080003,
    EquipID = 143080,
    AttrType = Table_EquipEffect_t.AttrType[11],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1186392"
  },
  [143080004] = {
    id = 143080004,
    EquipID = 143080,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[1]
  },
  [143080005] = {
    id = 143080005,
    EquipID = 143080,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[8],
    Dsc = "##1123330"
  },
  [143080006] = {
    id = 143080006,
    EquipID = 143080,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[8],
    Dsc = "##1123331"
  },
  [143081001] = {
    id = 143081001,
    EquipID = 143081,
    AttrType = Table_EquipEffect_t.AttrType[9],
    AttrRate = Table_EquipEffect_t.AttrRate[7],
    Dsc = "##1186390"
  },
  [143081002] = {
    id = 143081002,
    EquipID = 143081,
    AttrType = Table_EquipEffect_t.AttrType[10],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1186391"
  },
  [143081003] = {
    id = 143081003,
    EquipID = 143081,
    AttrType = Table_EquipEffect_t.AttrType[11],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1186392"
  },
  [143081004] = {
    id = 143081004,
    EquipID = 143081,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[1]
  },
  [143081005] = {
    id = 143081005,
    EquipID = 143081,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[8],
    Dsc = "##1123330"
  },
  [143081006] = {
    id = 143081006,
    EquipID = 143081,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[8],
    Dsc = "##1123331"
  },
  [143081007] = {
    id = 143081007,
    EquipID = 143081,
    GroupID = 2,
    AttrType = Table_EquipEffect_t.AttrType[2],
    AttrRate = Table_EquipEffect_t.AttrRate[2],
    Dsc = "##1211215"
  },
  [143083001] = {
    id = 143083001,
    EquipID = 143083,
    AttrType = Table_EquipEffect_t.AttrType[11],
    AttrRate = Table_EquipEffect_t.AttrRate[7],
    Dsc = "##1186392"
  },
  [143083002] = {
    id = 143083002,
    EquipID = 143083,
    AttrType = Table_EquipEffect_t.AttrType[10],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1186391"
  },
  [143083003] = {
    id = 143083003,
    EquipID = 143083,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[10],
    Dsc = "##1123328"
  },
  [143083004] = {
    id = 143083004,
    EquipID = 143083,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[10],
    Dsc = "##1123329"
  },
  [143083005] = {
    id = 143083005,
    EquipID = 143083,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[8],
    Dsc = "##1123330"
  },
  [143083006] = {
    id = 143083006,
    EquipID = 143083,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[8],
    Dsc = "##1123331"
  },
  [143084001] = {
    id = 143084001,
    EquipID = 143084,
    AttrType = Table_EquipEffect_t.AttrType[11],
    AttrRate = Table_EquipEffect_t.AttrRate[7],
    Dsc = "##1186392"
  },
  [143084002] = {
    id = 143084002,
    EquipID = 143084,
    AttrType = Table_EquipEffect_t.AttrType[10],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1186391"
  },
  [143084003] = {
    id = 143084003,
    EquipID = 143084,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[10],
    Dsc = "##1123328"
  },
  [143084004] = {
    id = 143084004,
    EquipID = 143084,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[10],
    Dsc = "##1123329"
  },
  [143084005] = {
    id = 143084005,
    EquipID = 143084,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[8],
    Dsc = "##1123330"
  },
  [143084006] = {
    id = 143084006,
    EquipID = 143084,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[8],
    Dsc = "##1123331"
  },
  [143084007] = {
    id = 143084007,
    EquipID = 143084,
    GroupID = 2,
    AttrType = Table_EquipEffect_t.AttrType[2],
    AttrRate = Table_EquipEffect_t.AttrRate[2],
    Dsc = "##1211215"
  },
  [143086001] = {
    id = 143086001,
    EquipID = 143086,
    AttrType = Table_EquipEffect_t.AttrType[30],
    AttrRate = Table_EquipEffect_t.AttrRate[7],
    Dsc = "##1186393"
  },
  [143086002] = {
    id = 143086002,
    EquipID = 143086,
    AttrType = Table_EquipEffect_t.AttrType[10],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1186391"
  },
  [143086003] = {
    id = 143086003,
    EquipID = 143086,
    AttrType = Table_EquipEffect_t.AttrType[11],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1186392"
  },
  [143086004] = {
    id = 143086004,
    EquipID = 143086,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[1]
  },
  [143086005] = {
    id = 143086005,
    EquipID = 143086,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[8],
    Dsc = "##1123330"
  },
  [143086006] = {
    id = 143086006,
    EquipID = 143086,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[8],
    Dsc = "##1123331"
  },
  [143087001] = {
    id = 143087001,
    EquipID = 143087,
    AttrType = Table_EquipEffect_t.AttrType[30],
    AttrRate = Table_EquipEffect_t.AttrRate[7],
    Dsc = "##1186393"
  },
  [143087002] = {
    id = 143087002,
    EquipID = 143087,
    AttrType = Table_EquipEffect_t.AttrType[10],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1186391"
  },
  [143087003] = {
    id = 143087003,
    EquipID = 143087,
    AttrType = Table_EquipEffect_t.AttrType[11],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1186392"
  },
  [143087004] = {
    id = 143087004,
    EquipID = 143087,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[1]
  },
  [143087005] = {
    id = 143087005,
    EquipID = 143087,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[8],
    Dsc = "##1123330"
  },
  [143087006] = {
    id = 143087006,
    EquipID = 143087,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[8],
    Dsc = "##1123331"
  },
  [143087007] = {
    id = 143087007,
    EquipID = 143087,
    GroupID = 2,
    AttrType = Table_EquipEffect_t.AttrType[2],
    AttrRate = Table_EquipEffect_t.AttrRate[2],
    Dsc = "##1211215"
  },
  [143089001] = {
    id = 143089001,
    EquipID = 143089,
    AttrType = Table_EquipEffect_t.AttrType[11],
    AttrRate = Table_EquipEffect_t.AttrRate[7],
    Dsc = "##1186392"
  },
  [143089002] = {
    id = 143089002,
    EquipID = 143089,
    AttrType = Table_EquipEffect_t.AttrType[10],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1186391"
  },
  [143089003] = {
    id = 143089003,
    EquipID = 143089,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[1]
  },
  [143089004] = {
    id = 143089004,
    EquipID = 143089,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[8],
    Dsc = "##1123330"
  },
  [143089005] = {
    id = 143089005,
    EquipID = 143089,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[8],
    Dsc = "##1123331"
  },
  [143089006] = {
    id = 143089006,
    EquipID = 143089,
    AttrType = Table_EquipEffect_t.AttrType[31],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123371"
  },
  [143090001] = {
    id = 143090001,
    EquipID = 143090,
    AttrType = Table_EquipEffect_t.AttrType[11],
    AttrRate = Table_EquipEffect_t.AttrRate[7],
    Dsc = "##1186392"
  },
  [143090002] = {
    id = 143090002,
    EquipID = 143090,
    AttrType = Table_EquipEffect_t.AttrType[10],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1186391"
  },
  [143090003] = {
    id = 143090003,
    EquipID = 143090,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[1]
  },
  [143090004] = {
    id = 143090004,
    EquipID = 143090,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[8],
    Dsc = "##1123330"
  },
  [143090005] = {
    id = 143090005,
    EquipID = 143090,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[8],
    Dsc = "##1123331"
  },
  [143090006] = {
    id = 143090006,
    EquipID = 143090,
    AttrType = Table_EquipEffect_t.AttrType[31],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123371"
  },
  [143090007] = {
    id = 143090007,
    EquipID = 143090,
    GroupID = 2,
    AttrType = Table_EquipEffect_t.AttrType[2],
    AttrRate = Table_EquipEffect_t.AttrRate[2],
    Dsc = "##1211215"
  },
  [143092001] = {
    id = 143092001,
    EquipID = 143092,
    AttrType = Table_EquipEffect_t.AttrType[11],
    AttrRate = Table_EquipEffect_t.AttrRate[7],
    Dsc = "##1186392"
  },
  [143092002] = {
    id = 143092002,
    EquipID = 143092,
    AttrType = Table_EquipEffect_t.AttrType[10],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1186391"
  },
  [143092003] = {
    id = 143092003,
    EquipID = 143092,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[1]
  },
  [143092004] = {
    id = 143092004,
    EquipID = 143092,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[8],
    Dsc = "##1123330"
  },
  [143092005] = {
    id = 143092005,
    EquipID = 143092,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[8],
    Dsc = "##1123331"
  },
  [143092006] = {
    id = 143092006,
    EquipID = 143092,
    AttrType = Table_EquipEffect_t.AttrType[31],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123371"
  },
  [143093001] = {
    id = 143093001,
    EquipID = 143093,
    AttrType = Table_EquipEffect_t.AttrType[11],
    AttrRate = Table_EquipEffect_t.AttrRate[7],
    Dsc = "##1186392"
  },
  [143093002] = {
    id = 143093002,
    EquipID = 143093,
    AttrType = Table_EquipEffect_t.AttrType[10],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1186391"
  },
  [143093003] = {
    id = 143093003,
    EquipID = 143093,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[1]
  },
  [143093004] = {
    id = 143093004,
    EquipID = 143093,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[8],
    Dsc = "##1123330"
  },
  [143093005] = {
    id = 143093005,
    EquipID = 143093,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[8],
    Dsc = "##1123331"
  },
  [143093006] = {
    id = 143093006,
    EquipID = 143093,
    AttrType = Table_EquipEffect_t.AttrType[31],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123371"
  },
  [143093007] = {
    id = 143093007,
    EquipID = 143093,
    GroupID = 2,
    AttrType = Table_EquipEffect_t.AttrType[2],
    AttrRate = Table_EquipEffect_t.AttrRate[2],
    Dsc = "##1211215"
  },
  [143095001] = {
    id = 143095001,
    EquipID = 143095,
    AttrType = Table_EquipEffect_t.AttrType[11],
    AttrRate = Table_EquipEffect_t.AttrRate[7],
    Dsc = "##1186392"
  },
  [143095002] = {
    id = 143095002,
    EquipID = 143095,
    AttrType = Table_EquipEffect_t.AttrType[10],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1186391"
  },
  [143095003] = {
    id = 143095003,
    EquipID = 143095,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[1]
  },
  [143095004] = {
    id = 143095004,
    EquipID = 143095,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[8],
    Dsc = "##1123330"
  },
  [143095005] = {
    id = 143095005,
    EquipID = 143095,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[8],
    Dsc = "##1123331"
  },
  [143095006] = {
    id = 143095006,
    EquipID = 143095,
    AttrType = Table_EquipEffect_t.AttrType[31],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123371"
  },
  [143096001] = {
    id = 143096001,
    EquipID = 143096,
    AttrType = Table_EquipEffect_t.AttrType[11],
    AttrRate = Table_EquipEffect_t.AttrRate[7],
    Dsc = "##1186392"
  },
  [143096002] = {
    id = 143096002,
    EquipID = 143096,
    AttrType = Table_EquipEffect_t.AttrType[10],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1186391"
  },
  [143096003] = {
    id = 143096003,
    EquipID = 143096,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[1]
  },
  [143096004] = {
    id = 143096004,
    EquipID = 143096,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[8],
    Dsc = "##1123330"
  },
  [143096005] = {
    id = 143096005,
    EquipID = 143096,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[8],
    Dsc = "##1123331"
  },
  [143096006] = {
    id = 143096006,
    EquipID = 143096,
    AttrType = Table_EquipEffect_t.AttrType[31],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123371"
  },
  [143096007] = {
    id = 143096007,
    EquipID = 143096,
    GroupID = 2,
    AttrType = Table_EquipEffect_t.AttrType[2],
    AttrRate = Table_EquipEffect_t.AttrRate[2],
    Dsc = "##1211215"
  },
  [143098001] = {
    id = 143098001,
    EquipID = 143098,
    AttrType = Table_EquipEffect_t.AttrType[9],
    AttrRate = Table_EquipEffect_t.AttrRate[7],
    Dsc = "##1186390"
  },
  [143098002] = {
    id = 143098002,
    EquipID = 143098,
    AttrType = Table_EquipEffect_t.AttrType[10],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1186391"
  },
  [143098003] = {
    id = 143098003,
    EquipID = 143098,
    AttrType = Table_EquipEffect_t.AttrType[11],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1186392"
  },
  [143098004] = {
    id = 143098004,
    EquipID = 143098,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[1]
  },
  [143098005] = {
    id = 143098005,
    EquipID = 143098,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[8],
    Dsc = "##1123330"
  },
  [143098006] = {
    id = 143098006,
    EquipID = 143098,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[8],
    Dsc = "##1123331"
  },
  [143099001] = {
    id = 143099001,
    EquipID = 143099,
    AttrType = Table_EquipEffect_t.AttrType[9],
    AttrRate = Table_EquipEffect_t.AttrRate[7],
    Dsc = "##1186390"
  },
  [143099002] = {
    id = 143099002,
    EquipID = 143099,
    AttrType = Table_EquipEffect_t.AttrType[10],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1186391"
  },
  [143099003] = {
    id = 143099003,
    EquipID = 143099,
    AttrType = Table_EquipEffect_t.AttrType[11],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1186392"
  },
  [143099004] = {
    id = 143099004,
    EquipID = 143099,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[1]
  },
  [143099005] = {
    id = 143099005,
    EquipID = 143099,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[8],
    Dsc = "##1123330"
  },
  [143099006] = {
    id = 143099006,
    EquipID = 143099,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[8],
    Dsc = "##1123331"
  },
  [143099007] = {
    id = 143099007,
    EquipID = 143099,
    GroupID = 2,
    AttrType = Table_EquipEffect_t.AttrType[2],
    AttrRate = Table_EquipEffect_t.AttrRate[2],
    Dsc = "##1211215"
  },
  [143101001] = {
    id = 143101001,
    EquipID = 143101,
    AttrType = Table_EquipEffect_t.AttrType[11],
    AttrRate = Table_EquipEffect_t.AttrRate[27],
    Dsc = "##1186392"
  },
  [143102001] = {
    id = 143102001,
    EquipID = 143102,
    AttrType = Table_EquipEffect_t.AttrType[9],
    AttrRate = Table_EquipEffect_t.AttrRate[27],
    Dsc = "##1186390"
  },
  [143103001] = {
    id = 143103001,
    EquipID = 143103,
    AttrType = Table_EquipEffect_t.AttrType[30],
    AttrRate = Table_EquipEffect_t.AttrRate[27],
    Dsc = "##1186393"
  },
  [143104001] = {
    id = 143104001,
    EquipID = 143104,
    AttrType = Table_EquipEffect_t.AttrType[30],
    AttrRate = Table_EquipEffect_t.AttrRate[27],
    Dsc = "##1186393"
  },
  [143105001] = {
    id = 143105001,
    EquipID = 143105,
    AttrType = Table_EquipEffect_t.AttrType[9],
    AttrRate = Table_EquipEffect_t.AttrRate[27],
    Dsc = "##1186390"
  },
  [143593001] = {
    id = 143593001,
    EquipID = 143593,
    AttrType = Table_EquipEffect_t.AttrType[13],
    AttrRate = Table_EquipEffect_t.AttrRate[28],
    Dsc = "##312072"
  },
  [143593002] = {
    id = 143593002,
    EquipID = 143593,
    AttrType = Table_EquipEffect_t.AttrType[32],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123386"
  },
  [143593003] = {
    id = 143593003,
    EquipID = 143593,
    AttrType = Table_EquipEffect_t.AttrType[34],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123381"
  },
  [143593004] = {
    id = 143593004,
    EquipID = 143593,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[5]
  },
  [143593005] = {
    id = 143593005,
    EquipID = 143593,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123330"
  },
  [143593006] = {
    id = 143593006,
    EquipID = 143593,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123331"
  },
  [143594001] = {
    id = 143594001,
    EquipID = 143594,
    AttrType = Table_EquipEffect_t.AttrType[13],
    AttrRate = Table_EquipEffect_t.AttrRate[28],
    Dsc = "##312072"
  },
  [143594002] = {
    id = 143594002,
    EquipID = 143594,
    AttrType = Table_EquipEffect_t.AttrType[32],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123386"
  },
  [143594003] = {
    id = 143594003,
    EquipID = 143594,
    AttrType = Table_EquipEffect_t.AttrType[34],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123381"
  },
  [143594004] = {
    id = 143594004,
    EquipID = 143594,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[5]
  },
  [143594005] = {
    id = 143594005,
    EquipID = 143594,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123330"
  },
  [143594006] = {
    id = 143594006,
    EquipID = 143594,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123331"
  },
  [143594007] = {
    id = 143594007,
    EquipID = 143594,
    GroupID = 2,
    AttrType = Table_EquipEffect_t.AttrType[2],
    AttrRate = Table_EquipEffect_t.AttrRate[2],
    Dsc = "##1211215"
  },
  [143596001] = {
    id = 143596001,
    EquipID = 143596,
    AttrType = Table_EquipEffect_t.AttrType[17],
    AttrRate = Table_EquipEffect_t.AttrRate[28],
    Dsc = "##1110947"
  },
  [143596002] = {
    id = 143596002,
    EquipID = 143596,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123328"
  },
  [143596003] = {
    id = 143596003,
    EquipID = 143596,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123329"
  },
  [143596004] = {
    id = 143596004,
    EquipID = 143596,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[5]
  },
  [143596005] = {
    id = 143596005,
    EquipID = 143596,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123330"
  },
  [143596006] = {
    id = 143596006,
    EquipID = 143596,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123331"
  },
  [143597001] = {
    id = 143597001,
    EquipID = 143597,
    AttrType = Table_EquipEffect_t.AttrType[17],
    AttrRate = Table_EquipEffect_t.AttrRate[28],
    Dsc = "##1110947"
  },
  [143597002] = {
    id = 143597002,
    EquipID = 143597,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123328"
  },
  [143597003] = {
    id = 143597003,
    EquipID = 143597,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123329"
  },
  [143597004] = {
    id = 143597004,
    EquipID = 143597,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[5]
  },
  [143597005] = {
    id = 143597005,
    EquipID = 143597,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123330"
  },
  [143597006] = {
    id = 143597006,
    EquipID = 143597,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123331"
  },
  [143597007] = {
    id = 143597007,
    EquipID = 143597,
    GroupID = 2,
    AttrType = Table_EquipEffect_t.AttrType[2],
    AttrRate = Table_EquipEffect_t.AttrRate[2],
    Dsc = "##1211215"
  },
  [143599001] = {
    id = 143599001,
    EquipID = 143599,
    AttrType = Table_EquipEffect_t.AttrType[17],
    AttrRate = Table_EquipEffect_t.AttrRate[28],
    Dsc = "##1110947"
  },
  [143599002] = {
    id = 143599002,
    EquipID = 143599,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123328"
  },
  [143599003] = {
    id = 143599003,
    EquipID = 143599,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123329"
  },
  [143599004] = {
    id = 143599004,
    EquipID = 143599,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[5]
  },
  [143599005] = {
    id = 143599005,
    EquipID = 143599,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123330"
  },
  [143599006] = {
    id = 143599006,
    EquipID = 143599,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123331"
  },
  [143600001] = {
    id = 143600001,
    EquipID = 143600,
    AttrType = Table_EquipEffect_t.AttrType[17],
    AttrRate = Table_EquipEffect_t.AttrRate[28],
    Dsc = "##1110947"
  },
  [143600002] = {
    id = 143600002,
    EquipID = 143600,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123328"
  },
  [143600003] = {
    id = 143600003,
    EquipID = 143600,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123329"
  },
  [143600004] = {
    id = 143600004,
    EquipID = 143600,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[5]
  },
  [143600005] = {
    id = 143600005,
    EquipID = 143600,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123330"
  },
  [143600006] = {
    id = 143600006,
    EquipID = 143600,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123331"
  },
  [143600007] = {
    id = 143600007,
    EquipID = 143600,
    GroupID = 2,
    AttrType = Table_EquipEffect_t.AttrType[2],
    AttrRate = Table_EquipEffect_t.AttrRate[2],
    Dsc = "##1211215"
  },
  [143602001] = {
    id = 143602001,
    EquipID = 143602,
    AttrType = Table_EquipEffect_t.AttrType[3],
    AttrRate = Table_EquipEffect_t.AttrRate[28],
    Dsc = "##1110946"
  },
  [143602002] = {
    id = 143602002,
    EquipID = 143602,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123328"
  },
  [143602003] = {
    id = 143602003,
    EquipID = 143602,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123329"
  },
  [143602004] = {
    id = 143602004,
    EquipID = 143602,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[5]
  },
  [143602005] = {
    id = 143602005,
    EquipID = 143602,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123330"
  },
  [143602006] = {
    id = 143602006,
    EquipID = 143602,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123331"
  },
  [143603001] = {
    id = 143603001,
    EquipID = 143603,
    AttrType = Table_EquipEffect_t.AttrType[3],
    AttrRate = Table_EquipEffect_t.AttrRate[28],
    Dsc = "##1110946"
  },
  [143603002] = {
    id = 143603002,
    EquipID = 143603,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123328"
  },
  [143603003] = {
    id = 143603003,
    EquipID = 143603,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123329"
  },
  [143603004] = {
    id = 143603004,
    EquipID = 143603,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[5]
  },
  [143603005] = {
    id = 143603005,
    EquipID = 143603,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123330"
  },
  [143603006] = {
    id = 143603006,
    EquipID = 143603,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123331"
  },
  [143603007] = {
    id = 143603007,
    EquipID = 143603,
    GroupID = 2,
    AttrType = Table_EquipEffect_t.AttrType[2],
    AttrRate = Table_EquipEffect_t.AttrRate[2],
    Dsc = "##1211215"
  },
  [143605001] = {
    id = 143605001,
    EquipID = 143605,
    AttrType = Table_EquipEffect_t.AttrType[18],
    AttrRate = Table_EquipEffect_t.AttrRate[28],
    Dsc = "##1123327"
  },
  [143605002] = {
    id = 143605002,
    EquipID = 143605,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123328"
  },
  [143605003] = {
    id = 143605003,
    EquipID = 143605,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123329"
  },
  [143605004] = {
    id = 143605004,
    EquipID = 143605,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[5]
  },
  [143605005] = {
    id = 143605005,
    EquipID = 143605,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123330"
  },
  [143605006] = {
    id = 143605006,
    EquipID = 143605,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123331"
  },
  [143606001] = {
    id = 143606001,
    EquipID = 143606,
    AttrType = Table_EquipEffect_t.AttrType[18],
    AttrRate = Table_EquipEffect_t.AttrRate[28],
    Dsc = "##1123327"
  },
  [143606002] = {
    id = 143606002,
    EquipID = 143606,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123328"
  },
  [143606003] = {
    id = 143606003,
    EquipID = 143606,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123329"
  },
  [143606004] = {
    id = 143606004,
    EquipID = 143606,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[5]
  },
  [143606005] = {
    id = 143606005,
    EquipID = 143606,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123330"
  },
  [143606006] = {
    id = 143606006,
    EquipID = 143606,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123331"
  },
  [143606007] = {
    id = 143606007,
    EquipID = 143606,
    GroupID = 2,
    AttrType = Table_EquipEffect_t.AttrType[2],
    AttrRate = Table_EquipEffect_t.AttrRate[2],
    Dsc = "##1211215"
  },
  [143608001] = {
    id = 143608001,
    EquipID = 143608,
    AttrType = Table_EquipEffect_t.AttrType[22],
    AttrRate = Table_EquipEffect_t.AttrRate[28],
    Dsc = "##312087"
  },
  [143608002] = {
    id = 143608002,
    EquipID = 143608,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123328"
  },
  [143608003] = {
    id = 143608003,
    EquipID = 143608,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123329"
  },
  [143608004] = {
    id = 143608004,
    EquipID = 143608,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[5]
  },
  [143608005] = {
    id = 143608005,
    EquipID = 143608,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123330"
  },
  [143608006] = {
    id = 143608006,
    EquipID = 143608,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123331"
  },
  [143609001] = {
    id = 143609001,
    EquipID = 143609,
    AttrType = Table_EquipEffect_t.AttrType[22],
    AttrRate = Table_EquipEffect_t.AttrRate[28],
    Dsc = "##312087"
  },
  [143609002] = {
    id = 143609002,
    EquipID = 143609,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123328"
  },
  [143609003] = {
    id = 143609003,
    EquipID = 143609,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123329"
  },
  [143609004] = {
    id = 143609004,
    EquipID = 143609,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[5]
  },
  [143609005] = {
    id = 143609005,
    EquipID = 143609,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123330"
  },
  [143609006] = {
    id = 143609006,
    EquipID = 143609,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123331"
  },
  [143609007] = {
    id = 143609007,
    EquipID = 143609,
    GroupID = 2,
    AttrType = Table_EquipEffect_t.AttrType[2],
    AttrRate = Table_EquipEffect_t.AttrRate[2],
    Dsc = "##1211215"
  },
  [143611001] = {
    id = 143611001,
    EquipID = 143611,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[28]
  },
  [143611002] = {
    id = 143611002,
    EquipID = 143611,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123328"
  },
  [143611003] = {
    id = 143611003,
    EquipID = 143611,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123329"
  },
  [143611004] = {
    id = 143611004,
    EquipID = 143611,
    AttrType = Table_EquipEffect_t.AttrType[33],
    AttrRate = Table_EquipEffect_t.AttrRate[5],
    Dsc = "##1123666"
  },
  [143611005] = {
    id = 143611005,
    EquipID = 143611,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123330"
  },
  [143611006] = {
    id = 143611006,
    EquipID = 143611,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123331"
  },
  [143612001] = {
    id = 143612001,
    EquipID = 143612,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[28]
  },
  [143612002] = {
    id = 143612002,
    EquipID = 143612,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123328"
  },
  [143612003] = {
    id = 143612003,
    EquipID = 143612,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123329"
  },
  [143612004] = {
    id = 143612004,
    EquipID = 143612,
    AttrType = Table_EquipEffect_t.AttrType[33],
    AttrRate = Table_EquipEffect_t.AttrRate[5],
    Dsc = "##1123666"
  },
  [143612005] = {
    id = 143612005,
    EquipID = 143612,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123330"
  },
  [143612006] = {
    id = 143612006,
    EquipID = 143612,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123331"
  },
  [143612007] = {
    id = 143612007,
    EquipID = 143612,
    GroupID = 2,
    AttrType = Table_EquipEffect_t.AttrType[2],
    AttrRate = Table_EquipEffect_t.AttrRate[2],
    Dsc = "##1211215"
  },
  [143614001] = {
    id = 143614001,
    EquipID = 143614,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[28]
  },
  [143614002] = {
    id = 143614002,
    EquipID = 143614,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123328"
  },
  [143614003] = {
    id = 143614003,
    EquipID = 143614,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123329"
  },
  [143614004] = {
    id = 143614004,
    EquipID = 143614,
    AttrType = Table_EquipEffect_t.AttrType[33],
    AttrRate = Table_EquipEffect_t.AttrRate[5],
    Dsc = "##1123666"
  },
  [143614005] = {
    id = 143614005,
    EquipID = 143614,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123330"
  },
  [143614006] = {
    id = 143614006,
    EquipID = 143614,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123331"
  },
  [143615001] = {
    id = 143615001,
    EquipID = 143615,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[28]
  },
  [143615002] = {
    id = 143615002,
    EquipID = 143615,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123328"
  },
  [143615003] = {
    id = 143615003,
    EquipID = 143615,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123329"
  },
  [143615004] = {
    id = 143615004,
    EquipID = 143615,
    AttrType = Table_EquipEffect_t.AttrType[33],
    AttrRate = Table_EquipEffect_t.AttrRate[5],
    Dsc = "##1123666"
  },
  [143615005] = {
    id = 143615005,
    EquipID = 143615,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123330"
  },
  [143615006] = {
    id = 143615006,
    EquipID = 143615,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123331"
  },
  [143615007] = {
    id = 143615007,
    EquipID = 143615,
    GroupID = 2,
    AttrType = Table_EquipEffect_t.AttrType[2],
    AttrRate = Table_EquipEffect_t.AttrRate[2],
    Dsc = "##1211215"
  },
  [143617001] = {
    id = 143617001,
    EquipID = 143617,
    AttrType = Table_EquipEffect_t.AttrType[12],
    AttrRate = Table_EquipEffect_t.AttrRate[28],
    Dsc = "##1123353"
  },
  [143617002] = {
    id = 143617002,
    EquipID = 143617,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123328"
  },
  [143617003] = {
    id = 143617003,
    EquipID = 143617,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123329"
  },
  [143617004] = {
    id = 143617004,
    EquipID = 143617,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[5]
  },
  [143617005] = {
    id = 143617005,
    EquipID = 143617,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123330"
  },
  [143617006] = {
    id = 143617006,
    EquipID = 143617,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123331"
  },
  [143618001] = {
    id = 143618001,
    EquipID = 143618,
    AttrType = Table_EquipEffect_t.AttrType[12],
    AttrRate = Table_EquipEffect_t.AttrRate[28],
    Dsc = "##1123353"
  },
  [143618002] = {
    id = 143618002,
    EquipID = 143618,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123328"
  },
  [143618003] = {
    id = 143618003,
    EquipID = 143618,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123329"
  },
  [143618004] = {
    id = 143618004,
    EquipID = 143618,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[5]
  },
  [143618005] = {
    id = 143618005,
    EquipID = 143618,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123330"
  },
  [143618006] = {
    id = 143618006,
    EquipID = 143618,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123331"
  },
  [143618007] = {
    id = 143618007,
    EquipID = 143618,
    GroupID = 2,
    AttrType = Table_EquipEffect_t.AttrType[2],
    AttrRate = Table_EquipEffect_t.AttrRate[2],
    Dsc = "##1211215"
  },
  [143620001] = {
    id = 143620001,
    EquipID = 143620,
    AttrType = Table_EquipEffect_t.AttrType[3],
    AttrRate = Table_EquipEffect_t.AttrRate[28],
    Dsc = "##1110946"
  },
  [143620002] = {
    id = 143620002,
    EquipID = 143620,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123328"
  },
  [143620003] = {
    id = 143620003,
    EquipID = 143620,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123329"
  },
  [143620004] = {
    id = 143620004,
    EquipID = 143620,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[5]
  },
  [143620005] = {
    id = 143620005,
    EquipID = 143620,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123330"
  },
  [143620006] = {
    id = 143620006,
    EquipID = 143620,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123331"
  },
  [143621001] = {
    id = 143621001,
    EquipID = 143621,
    AttrType = Table_EquipEffect_t.AttrType[3],
    AttrRate = Table_EquipEffect_t.AttrRate[28],
    Dsc = "##1110946"
  },
  [143621002] = {
    id = 143621002,
    EquipID = 143621,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123328"
  },
  [143621003] = {
    id = 143621003,
    EquipID = 143621,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123329"
  },
  [143621004] = {
    id = 143621004,
    EquipID = 143621,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[5]
  },
  [143621005] = {
    id = 143621005,
    EquipID = 143621,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123330"
  },
  [143621006] = {
    id = 143621006,
    EquipID = 143621,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123331"
  },
  [143621007] = {
    id = 143621007,
    EquipID = 143621,
    GroupID = 2,
    AttrType = Table_EquipEffect_t.AttrType[2],
    AttrRate = Table_EquipEffect_t.AttrRate[2],
    Dsc = "##1211215"
  },
  [143623001] = {
    id = 143623001,
    EquipID = 143623,
    AttrType = Table_EquipEffect_t.AttrType[22],
    AttrRate = Table_EquipEffect_t.AttrRate[22],
    Dsc = "##312087"
  },
  [143624001] = {
    id = 143624001,
    EquipID = 143624,
    AttrType = Table_EquipEffect_t.AttrType[17],
    AttrRate = Table_EquipEffect_t.AttrRate[22],
    Dsc = "##1110947"
  },
  [143625001] = {
    id = 143625001,
    EquipID = 143625,
    AttrType = Table_EquipEffect_t.AttrType[12],
    AttrRate = Table_EquipEffect_t.AttrRate[22],
    Dsc = "##1123353"
  },
  [143626001] = {
    id = 143626001,
    EquipID = 143626,
    AttrType = Table_EquipEffect_t.AttrType[17],
    AttrRate = Table_EquipEffect_t.AttrRate[22],
    Dsc = "##1110947"
  },
  [143627001] = {
    id = 143627001,
    EquipID = 143627,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[22]
  },
  [144091001] = {
    id = 144091001,
    EquipID = 144091,
    AttrType = Table_EquipEffect_t.AttrType[21],
    AttrRate = Table_EquipEffect_t.AttrRate[9],
    Dsc = "##312074"
  },
  [144091002] = {
    id = 144091002,
    EquipID = 144091,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123328"
  },
  [144091003] = {
    id = 144091003,
    EquipID = 144091,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123329"
  },
  [144091004] = {
    id = 144091004,
    EquipID = 144091,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[5]
  },
  [144091005] = {
    id = 144091005,
    EquipID = 144091,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123330"
  },
  [144091006] = {
    id = 144091006,
    EquipID = 144091,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123331"
  },
  [144092001] = {
    id = 144092001,
    EquipID = 144092,
    AttrType = Table_EquipEffect_t.AttrType[21],
    AttrRate = Table_EquipEffect_t.AttrRate[9],
    Dsc = "##312074"
  },
  [144092002] = {
    id = 144092002,
    EquipID = 144092,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123328"
  },
  [144092003] = {
    id = 144092003,
    EquipID = 144092,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123329"
  },
  [144092004] = {
    id = 144092004,
    EquipID = 144092,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[5]
  },
  [144092005] = {
    id = 144092005,
    EquipID = 144092,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123330"
  },
  [144092006] = {
    id = 144092006,
    EquipID = 144092,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123331"
  },
  [144092007] = {
    id = 144092007,
    EquipID = 144092,
    GroupID = 2,
    AttrType = Table_EquipEffect_t.AttrType[8],
    AttrRate = Table_EquipEffect_t.AttrRate[6],
    Dsc = "##1207802"
  },
  [144094001] = {
    id = 144094001,
    EquipID = 144094,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[28]
  },
  [144094002] = {
    id = 144094002,
    EquipID = 144094,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123328"
  },
  [144094003] = {
    id = 144094003,
    EquipID = 144094,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123329"
  },
  [144094004] = {
    id = 144094004,
    EquipID = 144094,
    AttrType = Table_EquipEffect_t.AttrType[33],
    AttrRate = Table_EquipEffect_t.AttrRate[5],
    Dsc = "##1123666"
  },
  [144094005] = {
    id = 144094005,
    EquipID = 144094,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123330"
  },
  [144094006] = {
    id = 144094006,
    EquipID = 144094,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123331"
  },
  [144095001] = {
    id = 144095001,
    EquipID = 144095,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[28]
  },
  [144095002] = {
    id = 144095002,
    EquipID = 144095,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123328"
  },
  [144095003] = {
    id = 144095003,
    EquipID = 144095,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123329"
  },
  [144095004] = {
    id = 144095004,
    EquipID = 144095,
    AttrType = Table_EquipEffect_t.AttrType[33],
    AttrRate = Table_EquipEffect_t.AttrRate[5],
    Dsc = "##1123666"
  },
  [144095005] = {
    id = 144095005,
    EquipID = 144095,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123330"
  },
  [144095006] = {
    id = 144095006,
    EquipID = 144095,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123331"
  },
  [144095007] = {
    id = 144095007,
    EquipID = 144095,
    GroupID = 2,
    AttrType = Table_EquipEffect_t.AttrType[8],
    AttrRate = Table_EquipEffect_t.AttrRate[6],
    Dsc = "##1207802"
  },
  [144097001] = {
    id = 144097001,
    EquipID = 144097,
    AttrType = Table_EquipEffect_t.AttrType[35],
    AttrRate = Table_EquipEffect_t.AttrRate[7],
    Dsc = "##1123376"
  },
  [144097002] = {
    id = 144097002,
    EquipID = 144097,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123328"
  },
  [144097003] = {
    id = 144097003,
    EquipID = 144097,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123329"
  },
  [144097004] = {
    id = 144097004,
    EquipID = 144097,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[5]
  },
  [144097005] = {
    id = 144097005,
    EquipID = 144097,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123330"
  },
  [144097006] = {
    id = 144097006,
    EquipID = 144097,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123331"
  },
  [144098001] = {
    id = 144098001,
    EquipID = 144098,
    AttrType = Table_EquipEffect_t.AttrType[35],
    AttrRate = Table_EquipEffect_t.AttrRate[7],
    Dsc = "##1123376"
  },
  [144098002] = {
    id = 144098002,
    EquipID = 144098,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123328"
  },
  [144098003] = {
    id = 144098003,
    EquipID = 144098,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123329"
  },
  [144098004] = {
    id = 144098004,
    EquipID = 144098,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[5]
  },
  [144098005] = {
    id = 144098005,
    EquipID = 144098,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123330"
  },
  [144098006] = {
    id = 144098006,
    EquipID = 144098,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123331"
  },
  [144098007] = {
    id = 144098007,
    EquipID = 144098,
    GroupID = 2,
    AttrType = Table_EquipEffect_t.AttrType[8],
    AttrRate = Table_EquipEffect_t.AttrRate[6],
    Dsc = "##1207802"
  },
  [144100001] = {
    id = 144100001,
    EquipID = 144100,
    AttrType = Table_EquipEffect_t.AttrType[17],
    AttrRate = Table_EquipEffect_t.AttrRate[3],
    Dsc = "##1110947"
  },
  [144100002] = {
    id = 144100002,
    EquipID = 144100,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123328"
  },
  [144100003] = {
    id = 144100003,
    EquipID = 144100,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123329"
  },
  [144100004] = {
    id = 144100004,
    EquipID = 144100,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[5]
  },
  [144100005] = {
    id = 144100005,
    EquipID = 144100,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123330"
  },
  [144100006] = {
    id = 144100006,
    EquipID = 144100,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123331"
  },
  [144101001] = {
    id = 144101001,
    EquipID = 144101,
    AttrType = Table_EquipEffect_t.AttrType[17],
    AttrRate = Table_EquipEffect_t.AttrRate[3],
    Dsc = "##1110947"
  },
  [144101002] = {
    id = 144101002,
    EquipID = 144101,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123328"
  },
  [144101003] = {
    id = 144101003,
    EquipID = 144101,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123329"
  },
  [144101004] = {
    id = 144101004,
    EquipID = 144101,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[5]
  },
  [144101005] = {
    id = 144101005,
    EquipID = 144101,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123330"
  },
  [144101006] = {
    id = 144101006,
    EquipID = 144101,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123331"
  },
  [144101007] = {
    id = 144101007,
    EquipID = 144101,
    GroupID = 2,
    AttrType = Table_EquipEffect_t.AttrType[8],
    AttrRate = Table_EquipEffect_t.AttrRate[6],
    Dsc = "##1207802"
  },
  [144103001] = {
    id = 144103001,
    EquipID = 144103,
    AttrType = Table_EquipEffect_t.AttrType[12],
    AttrRate = Table_EquipEffect_t.AttrRate[23],
    Dsc = "##1123353"
  },
  [144103002] = {
    id = 144103002,
    EquipID = 144103,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123328"
  },
  [144103003] = {
    id = 144103003,
    EquipID = 144103,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123329"
  },
  [144103004] = {
    id = 144103004,
    EquipID = 144103,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[5]
  },
  [144103005] = {
    id = 144103005,
    EquipID = 144103,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123330"
  },
  [144103006] = {
    id = 144103006,
    EquipID = 144103,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123331"
  },
  [144104001] = {
    id = 144104001,
    EquipID = 144104,
    AttrType = Table_EquipEffect_t.AttrType[12],
    AttrRate = Table_EquipEffect_t.AttrRate[23],
    Dsc = "##1123353"
  },
  [144104002] = {
    id = 144104002,
    EquipID = 144104,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123328"
  },
  [144104003] = {
    id = 144104003,
    EquipID = 144104,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123329"
  },
  [144104004] = {
    id = 144104004,
    EquipID = 144104,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[5]
  },
  [144104005] = {
    id = 144104005,
    EquipID = 144104,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123330"
  },
  [144104006] = {
    id = 144104006,
    EquipID = 144104,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123331"
  },
  [144104007] = {
    id = 144104007,
    EquipID = 144104,
    GroupID = 2,
    AttrType = Table_EquipEffect_t.AttrType[8],
    AttrRate = Table_EquipEffect_t.AttrRate[6],
    Dsc = "##1207802"
  },
  [144106001] = {
    id = 144106001,
    EquipID = 144106,
    AttrType = Table_EquipEffect_t.AttrType[23],
    AttrRate = Table_EquipEffect_t.AttrRate[7],
    Dsc = "##312079"
  },
  [144106002] = {
    id = 144106002,
    EquipID = 144106,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123328"
  },
  [144106003] = {
    id = 144106003,
    EquipID = 144106,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123329"
  },
  [144106004] = {
    id = 144106004,
    EquipID = 144106,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[5]
  },
  [144106005] = {
    id = 144106005,
    EquipID = 144106,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123330"
  },
  [144106006] = {
    id = 144106006,
    EquipID = 144106,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123331"
  },
  [144107001] = {
    id = 144107001,
    EquipID = 144107,
    AttrType = Table_EquipEffect_t.AttrType[23],
    AttrRate = Table_EquipEffect_t.AttrRate[7],
    Dsc = "##312079"
  },
  [144107002] = {
    id = 144107002,
    EquipID = 144107,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123328"
  },
  [144107003] = {
    id = 144107003,
    EquipID = 144107,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123329"
  },
  [144107004] = {
    id = 144107004,
    EquipID = 144107,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[5]
  },
  [144107005] = {
    id = 144107005,
    EquipID = 144107,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123330"
  },
  [144107006] = {
    id = 144107006,
    EquipID = 144107,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123331"
  },
  [144107007] = {
    id = 144107007,
    EquipID = 144107,
    GroupID = 2,
    AttrType = Table_EquipEffect_t.AttrType[8],
    AttrRate = Table_EquipEffect_t.AttrRate[6],
    Dsc = "##1207802"
  },
  [144109001] = {
    id = 144109001,
    EquipID = 144109,
    AttrType = Table_EquipEffect_t.AttrType[21],
    AttrRate = Table_EquipEffect_t.AttrRate[9],
    Dsc = "##312074"
  },
  [144109002] = {
    id = 144109002,
    EquipID = 144109,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123328"
  },
  [144109003] = {
    id = 144109003,
    EquipID = 144109,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123329"
  },
  [144109004] = {
    id = 144109004,
    EquipID = 144109,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[5]
  },
  [144109005] = {
    id = 144109005,
    EquipID = 144109,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123330"
  },
  [144109006] = {
    id = 144109006,
    EquipID = 144109,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123331"
  },
  [144110001] = {
    id = 144110001,
    EquipID = 144110,
    AttrType = Table_EquipEffect_t.AttrType[21],
    AttrRate = Table_EquipEffect_t.AttrRate[9],
    Dsc = "##312074"
  },
  [144110002] = {
    id = 144110002,
    EquipID = 144110,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123328"
  },
  [144110003] = {
    id = 144110003,
    EquipID = 144110,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123329"
  },
  [144110004] = {
    id = 144110004,
    EquipID = 144110,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[5]
  },
  [144110005] = {
    id = 144110005,
    EquipID = 144110,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123330"
  },
  [144110006] = {
    id = 144110006,
    EquipID = 144110,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123331"
  },
  [144110007] = {
    id = 144110007,
    EquipID = 144110,
    GroupID = 2,
    AttrType = Table_EquipEffect_t.AttrType[8],
    AttrRate = Table_EquipEffect_t.AttrRate[6],
    Dsc = "##1207802"
  },
  [144112001] = {
    id = 144112001,
    EquipID = 144112,
    AttrType = Table_EquipEffect_t.AttrType[20],
    AttrRate = Table_EquipEffect_t.AttrRate[7],
    Dsc = "##1186494"
  },
  [144112002] = {
    id = 144112002,
    EquipID = 144112,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123328"
  },
  [144112003] = {
    id = 144112003,
    EquipID = 144112,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123329"
  },
  [144112004] = {
    id = 144112004,
    EquipID = 144112,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[5]
  },
  [144112005] = {
    id = 144112005,
    EquipID = 144112,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123330"
  },
  [144112006] = {
    id = 144112006,
    EquipID = 144112,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123331"
  },
  [144113001] = {
    id = 144113001,
    EquipID = 144113,
    AttrType = Table_EquipEffect_t.AttrType[20],
    AttrRate = Table_EquipEffect_t.AttrRate[7],
    Dsc = "##1186494"
  },
  [144113002] = {
    id = 144113002,
    EquipID = 144113,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123328"
  },
  [144113003] = {
    id = 144113003,
    EquipID = 144113,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123329"
  },
  [144113004] = {
    id = 144113004,
    EquipID = 144113,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[5]
  },
  [144113005] = {
    id = 144113005,
    EquipID = 144113,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123330"
  },
  [144113006] = {
    id = 144113006,
    EquipID = 144113,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123331"
  },
  [144113007] = {
    id = 144113007,
    EquipID = 144113,
    GroupID = 2,
    AttrType = Table_EquipEffect_t.AttrType[8],
    AttrRate = Table_EquipEffect_t.AttrRate[6],
    Dsc = "##1207802"
  },
  [144115001] = {
    id = 144115001,
    EquipID = 144115,
    AttrType = Table_EquipEffect_t.AttrType[15],
    AttrRate = Table_EquipEffect_t.AttrRate[7],
    Dsc = "##1186495"
  },
  [144115002] = {
    id = 144115002,
    EquipID = 144115,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123328"
  },
  [144115003] = {
    id = 144115003,
    EquipID = 144115,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123329"
  },
  [144115004] = {
    id = 144115004,
    EquipID = 144115,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[5]
  },
  [144115005] = {
    id = 144115005,
    EquipID = 144115,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123330"
  },
  [144115006] = {
    id = 144115006,
    EquipID = 144115,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123331"
  },
  [144116001] = {
    id = 144116001,
    EquipID = 144116,
    AttrType = Table_EquipEffect_t.AttrType[15],
    AttrRate = Table_EquipEffect_t.AttrRate[7],
    Dsc = "##1186495"
  },
  [144116002] = {
    id = 144116002,
    EquipID = 144116,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123328"
  },
  [144116003] = {
    id = 144116003,
    EquipID = 144116,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123329"
  },
  [144116004] = {
    id = 144116004,
    EquipID = 144116,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[5]
  },
  [144116005] = {
    id = 144116005,
    EquipID = 144116,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123330"
  },
  [144116006] = {
    id = 144116006,
    EquipID = 144116,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123331"
  },
  [144116007] = {
    id = 144116007,
    EquipID = 144116,
    GroupID = 2,
    AttrType = Table_EquipEffect_t.AttrType[8],
    AttrRate = Table_EquipEffect_t.AttrRate[6],
    Dsc = "##1207802"
  },
  [144118001] = {
    id = 144118001,
    EquipID = 144118,
    AttrType = Table_EquipEffect_t.AttrType[3],
    AttrRate = Table_EquipEffect_t.AttrRate[3],
    Dsc = "##1110946"
  },
  [144118002] = {
    id = 144118002,
    EquipID = 144118,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123328"
  },
  [144118003] = {
    id = 144118003,
    EquipID = 144118,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123329"
  },
  [144118004] = {
    id = 144118004,
    EquipID = 144118,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[5]
  },
  [144118005] = {
    id = 144118005,
    EquipID = 144118,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123330"
  },
  [144118006] = {
    id = 144118006,
    EquipID = 144118,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123331"
  },
  [144119001] = {
    id = 144119001,
    EquipID = 144119,
    AttrType = Table_EquipEffect_t.AttrType[3],
    AttrRate = Table_EquipEffect_t.AttrRate[3],
    Dsc = "##1110946"
  },
  [144119002] = {
    id = 144119002,
    EquipID = 144119,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123328"
  },
  [144119003] = {
    id = 144119003,
    EquipID = 144119,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123329"
  },
  [144119004] = {
    id = 144119004,
    EquipID = 144119,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[5]
  },
  [144119005] = {
    id = 144119005,
    EquipID = 144119,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123330"
  },
  [144119006] = {
    id = 144119006,
    EquipID = 144119,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123331"
  },
  [144119007] = {
    id = 144119007,
    EquipID = 144119,
    GroupID = 2,
    AttrType = Table_EquipEffect_t.AttrType[8],
    AttrRate = Table_EquipEffect_t.AttrRate[6],
    Dsc = "##1207802"
  },
  [144121001] = {
    id = 144121001,
    EquipID = 144121,
    AttrType = Table_EquipEffect_t.AttrType[12],
    AttrRate = Table_EquipEffect_t.AttrRate[23],
    Dsc = "##1123353"
  },
  [144121002] = {
    id = 144121002,
    EquipID = 144121,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123328"
  },
  [144121003] = {
    id = 144121003,
    EquipID = 144121,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123329"
  },
  [144121004] = {
    id = 144121004,
    EquipID = 144121,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[5]
  },
  [144121005] = {
    id = 144121005,
    EquipID = 144121,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123330"
  },
  [144121006] = {
    id = 144121006,
    EquipID = 144121,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123331"
  },
  [144122001] = {
    id = 144122001,
    EquipID = 144122,
    AttrType = Table_EquipEffect_t.AttrType[12],
    AttrRate = Table_EquipEffect_t.AttrRate[23],
    Dsc = "##1123353"
  },
  [144122002] = {
    id = 144122002,
    EquipID = 144122,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123328"
  },
  [144122003] = {
    id = 144122003,
    EquipID = 144122,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123329"
  },
  [144122004] = {
    id = 144122004,
    EquipID = 144122,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[5]
  },
  [144122005] = {
    id = 144122005,
    EquipID = 144122,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123330"
  },
  [144122006] = {
    id = 144122006,
    EquipID = 144122,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123331"
  },
  [144122007] = {
    id = 144122007,
    EquipID = 144122,
    GroupID = 2,
    AttrType = Table_EquipEffect_t.AttrType[8],
    AttrRate = Table_EquipEffect_t.AttrRate[6],
    Dsc = "##1207802"
  },
  [144124001] = {
    id = 144124001,
    EquipID = 144124,
    AttrType = Table_EquipEffect_t.AttrType[3],
    AttrRate = Table_EquipEffect_t.AttrRate[3],
    Dsc = "##1110946"
  },
  [144124002] = {
    id = 144124002,
    EquipID = 144124,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123328"
  },
  [144124003] = {
    id = 144124003,
    EquipID = 144124,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123329"
  },
  [144124004] = {
    id = 144124004,
    EquipID = 144124,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[5]
  },
  [144124005] = {
    id = 144124005,
    EquipID = 144124,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123330"
  },
  [144124006] = {
    id = 144124006,
    EquipID = 144124,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123331"
  },
  [144125001] = {
    id = 144125001,
    EquipID = 144125,
    AttrType = Table_EquipEffect_t.AttrType[3],
    AttrRate = Table_EquipEffect_t.AttrRate[3],
    Dsc = "##1110946"
  },
  [144125002] = {
    id = 144125002,
    EquipID = 144125,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123328"
  },
  [144125003] = {
    id = 144125003,
    EquipID = 144125,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123329"
  },
  [144125004] = {
    id = 144125004,
    EquipID = 144125,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[5]
  },
  [144125005] = {
    id = 144125005,
    EquipID = 144125,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123330"
  },
  [144125006] = {
    id = 144125006,
    EquipID = 144125,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123331"
  },
  [144125007] = {
    id = 144125007,
    EquipID = 144125,
    GroupID = 2,
    AttrType = Table_EquipEffect_t.AttrType[8],
    AttrRate = Table_EquipEffect_t.AttrRate[6],
    Dsc = "##1207802"
  },
  [144127001] = {
    id = 144127001,
    EquipID = 144127,
    AttrType = Table_EquipEffect_t.AttrType[9],
    AttrRate = Table_EquipEffect_t.AttrRate[3],
    Dsc = "##1186390"
  },
  [144127002] = {
    id = 144127002,
    EquipID = 144127,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123328"
  },
  [144127003] = {
    id = 144127003,
    EquipID = 144127,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123329"
  },
  [144127004] = {
    id = 144127004,
    EquipID = 144127,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[5]
  },
  [144127005] = {
    id = 144127005,
    EquipID = 144127,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123330"
  },
  [144127006] = {
    id = 144127006,
    EquipID = 144127,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123331"
  },
  [144128001] = {
    id = 144128001,
    EquipID = 144128,
    AttrType = Table_EquipEffect_t.AttrType[9],
    AttrRate = Table_EquipEffect_t.AttrRate[3],
    Dsc = "##1186390"
  },
  [144128002] = {
    id = 144128002,
    EquipID = 144128,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123328"
  },
  [144128003] = {
    id = 144128003,
    EquipID = 144128,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123329"
  },
  [144128004] = {
    id = 144128004,
    EquipID = 144128,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[5]
  },
  [144128005] = {
    id = 144128005,
    EquipID = 144128,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123330"
  },
  [144128006] = {
    id = 144128006,
    EquipID = 144128,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123331"
  },
  [144128007] = {
    id = 144128007,
    EquipID = 144128,
    GroupID = 2,
    AttrType = Table_EquipEffect_t.AttrType[8],
    AttrRate = Table_EquipEffect_t.AttrRate[6],
    Dsc = "##1207802"
  },
  [144133001] = {
    id = 144133001,
    EquipID = 144133,
    AttrType = Table_EquipEffect_t.AttrType[17],
    AttrRate = Table_EquipEffect_t.AttrRate[3],
    Dsc = "##1110947"
  },
  [144133002] = {
    id = 144133002,
    EquipID = 144133,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123328"
  },
  [144133003] = {
    id = 144133003,
    EquipID = 144133,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123329"
  },
  [144133004] = {
    id = 144133004,
    EquipID = 144133,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[5]
  },
  [144133005] = {
    id = 144133005,
    EquipID = 144133,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123330"
  },
  [144133006] = {
    id = 144133006,
    EquipID = 144133,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123331"
  },
  [144134001] = {
    id = 144134001,
    EquipID = 144134,
    AttrType = Table_EquipEffect_t.AttrType[17],
    AttrRate = Table_EquipEffect_t.AttrRate[3],
    Dsc = "##1110947"
  },
  [144134002] = {
    id = 144134002,
    EquipID = 144134,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123328"
  },
  [144134003] = {
    id = 144134003,
    EquipID = 144134,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123329"
  },
  [144134004] = {
    id = 144134004,
    EquipID = 144134,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[5]
  },
  [144134005] = {
    id = 144134005,
    EquipID = 144134,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123330"
  },
  [144134006] = {
    id = 144134006,
    EquipID = 144134,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123331"
  },
  [144134007] = {
    id = 144134007,
    EquipID = 144134,
    GroupID = 2,
    AttrType = Table_EquipEffect_t.AttrType[8],
    AttrRate = Table_EquipEffect_t.AttrRate[6],
    Dsc = "##1207802"
  },
  [144136001] = {
    id = 144136001,
    EquipID = 144136,
    AttrType = Table_EquipEffect_t.AttrType[3],
    AttrRate = Table_EquipEffect_t.AttrRate[3],
    Dsc = "##1110946"
  },
  [144136002] = {
    id = 144136002,
    EquipID = 144136,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123328"
  },
  [144136003] = {
    id = 144136003,
    EquipID = 144136,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123329"
  },
  [144136004] = {
    id = 144136004,
    EquipID = 144136,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[5]
  },
  [144136005] = {
    id = 144136005,
    EquipID = 144136,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123330"
  },
  [144136006] = {
    id = 144136006,
    EquipID = 144136,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123331"
  },
  [144137001] = {
    id = 144137001,
    EquipID = 144137,
    AttrType = Table_EquipEffect_t.AttrType[3],
    AttrRate = Table_EquipEffect_t.AttrRate[3],
    Dsc = "##1110946"
  },
  [144137002] = {
    id = 144137002,
    EquipID = 144137,
    AttrType = Table_EquipEffect_t.AttrType[4],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123328"
  },
  [144137003] = {
    id = 144137003,
    EquipID = 144137,
    AttrType = Table_EquipEffect_t.AttrType[5],
    AttrRate = Table_EquipEffect_t.AttrRate[4],
    Dsc = "##1123329"
  },
  [144137004] = {
    id = 144137004,
    EquipID = 144137,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[5]
  },
  [144137005] = {
    id = 144137005,
    EquipID = 144137,
    AttrType = Table_EquipEffect_t.AttrType[7],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123330"
  },
  [144137006] = {
    id = 144137006,
    EquipID = 144137,
    AttrType = Table_EquipEffect_t.AttrType[1],
    AttrRate = Table_EquipEffect_t.AttrRate[1],
    Dsc = "##1123331"
  },
  [144137007] = {
    id = 144137007,
    EquipID = 144137,
    GroupID = 2,
    AttrType = Table_EquipEffect_t.AttrType[8],
    AttrRate = Table_EquipEffect_t.AttrRate[6],
    Dsc = "##1207802"
  },
  [144140001] = {
    id = 144140001,
    EquipID = 144140,
    AttrType = Table_EquipEffect_t.AttrType[3],
    AttrRate = Table_EquipEffect_t.AttrRate[29],
    Dsc = "##1110946"
  },
  [144141001] = {
    id = 144141001,
    EquipID = 144141,
    AttrType = Table_EquipEffect_t.AttrType[21],
    AttrRate = Table_EquipEffect_t.AttrRate[25],
    Dsc = "##312074"
  },
  [144142001] = {
    id = 144142001,
    EquipID = 144142,
    AttrType = Table_EquipEffect_t.AttrType[23],
    AttrRate = Table_EquipEffect_t.AttrRate[27],
    Dsc = "##312079"
  },
  [144143001] = {
    id = 144143001,
    EquipID = 144143,
    AttrType = Table_EquipEffect_t.AttrType[3],
    AttrRate = Table_EquipEffect_t.AttrRate[29],
    Dsc = "##1110946"
  },
  [144144001] = {
    id = 144144001,
    EquipID = 144144,
    AttrType = Table_EquipEffect_t.AttrType[21],
    AttrRate = Table_EquipEffect_t.AttrRate[25],
    Dsc = "##312074"
  },
  [144145001] = {
    id = 144145001,
    EquipID = 144145,
    AttrType = Table_EquipEffect_t.AttrType[6],
    AttrRate = Table_EquipEffect_t.AttrRate[22]
  }
}
local cell_mt = {
  __index = {
    AttrRate = _EmptyTable,
    AttrType = _EmptyTable,
    Dsc = "##312081",
    EquipID = 142132,
    GroupID = 1,
    id = 43597006
  }
}
for _, d in pairs(Table_EquipEffect) do
  setmetatable(d, cell_mt)
end
