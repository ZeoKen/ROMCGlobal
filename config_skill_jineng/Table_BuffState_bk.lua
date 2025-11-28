Table_BuffState_bk_t = {
  Logic = {
    {
      effectaround = {
        "Skill/SummonSpiritSphere_Gold,none",
        "Skill/SummonSpiritSphere_Red,none"
      }
    },
    {
      effectaround = {
        "Skill/Monk_DragonBall02,none",
        "Skill/Monk_DragonBall03,none"
      }
    },
    {
      effectaround = {
        "Skill/InfiniteSing_buff2,none"
      }
    },
    {
      effectaround = {
        "Skill/Eff_IceBreak_buff,none"
      }
    },
    {
      effectaround = {
        "Skill/sfx_mmmy_hudie_buff01_prf,none"
      }
    },
    {
      effectaround = {
        "Skill/Bloody_BloodInfection,none"
      }
    }
  },
  Myself = {
    {
      shake = {
        curve = 1,
        range = 0.1,
        time = 1
      }
    }
  },
  Offset = {
    {
      -2.47,
      -1.2,
      0
    },
    {
      0,
      1.5,
      0
    },
    {
      0,
      -0.62,
      0
    },
    {
      0,
      0.8,
      0
    },
    {
      0,
      0.1,
      0
    },
    {
      0,
      -0.3,
      0
    },
    {
      0,
      -1,
      0
    },
    {
      0,
      -0.75,
      -0.06
    },
    {
      0,
      2.3,
      -1.6
    },
    {
      0,
      2,
      1.5
    },
    {
      0,
      1,
      0.4
    }
  }
}
Table_BuffState_bk = {
  [1] = {
    EP = 1,
    Effect = "Skill/Silence,none",
    SE_start = "State/Silence_begin"
  },
  [3] = {
    id = 3,
    EP = 2,
    Effect = "Skill/Stone,none",
    SE_end = "Common/StoneCurse_end"
  },
  [5] = {
    id = 5,
    EP = 1,
    Effect = "Skill/Blind,none",
    SE_start = "State/Blind_begin"
  },
  [6] = {
    id = 6,
    EP = 1,
    Effect = "Skill/ poisoning,none",
    SE_start = "Common/poison"
  },
  [7] = {
    id = 7,
    EP = 1,
    Effect = "Skill/Slow,none"
  },
  [8] = {
    id = 8,
    EP = 2,
    Effect = "Skill/Paralysis,none"
  },
  [9] = {
    id = 9,
    EP = 2,
    Effect = "Skill/Curse,none",
    SE_start = "State/Curse_begin"
  },
  [10] = {
    id = 10,
    EP = 1,
    Effect = "Common/59Fear,none"
  },
  [11] = {
    id = 11,
    EP = 2,
    Effect = "Skill/Burn,none"
  },
  [12] = {
    id = 12,
    EP = 1,
    Effect = "Skill/KyrieEleisonShield,none"
  },
  [13] = {
    id = 13,
    EP = 2,
    Effect = "Skill/IncreaseSpeed,none"
  },
  [14] = {
    id = 14,
    EP = 1,
    Effect = "Skill/AngelusShield,none"
  },
  [15] = {
    id = 15,
    EP = 5,
    Effect = "Skill/FlameShock_Buff,none"
  },
  [17] = {
    id = 17,
    EP = 2,
    Effect = "Skill/SpreadMagic,none"
  },
  [20] = {
    id = 20,
    EP = 3,
    Effect = "Skill/skill_shield,none"
  },
  [21] = {
    id = 21,
    EP = 1,
    Effect = "Skill/skill_coquetry,none"
  },
  [100] = {
    id = 100,
    EP = 1,
    Effect = "Skill/AngelusShield,none"
  },
  [106] = {
    id = 106,
    EP = 3,
    Effect_start = "Skill/WaterAttributeHit",
    Effect_hit = "Skill/WaterAttributeHit",
    SE_hit = "Skill/Skill_Monster_30068_Windblade_Attack_01",
    Myself = Table_BuffState_bk_t.Myself[1]
  },
  [124] = {
    id = 124,
    EP = 1,
    Effect = "Skill/LVUP_Process"
  },
  [133] = {
    id = 133,
    EP = 0,
    Effect = "Skill/LotteryCard_buff"
  },
  [140] = {
    id = 140,
    EP = 2,
    Effect = "Skill/RoseBloom,none"
  },
  [141] = {
    id = 141,
    EP = 3,
    Effect = "Skill/SakuraPerfume,none"
  },
  [162] = {
    id = 162,
    EP = 2,
    Effect = "Skill/RageSpear_buff,none"
  },
  [163] = {
    id = 163,
    EP = 3,
    Effect = "Skill/Task_YmirsHeart_continued,none"
  },
  [164] = {
    id = 164,
    EP = 3,
    Effect = "Skill/DarkFantasy,none"
  },
  [165] = {
    id = 165,
    EP = 3,
    Effect = "Skill/MentalStrength_buff,none"
  },
  [166] = {
    id = 166,
    EP = 3,
    Effect = "Skill/MartyrsReckoning_buff,none"
  },
  [167] = {
    id = 167,
    EP = 3,
    Effect = "Skill/SoulDrain,none"
  },
  [177] = {
    id = 177,
    EP = 2,
    Effect = "Common/DarkNPCfoot"
  },
  [182] = {
    id = 182,
    EP = 2,
    Effect = "Common/DarkNPCfoot_Small"
  },
  [190] = {
    id = 190,
    EP = 0,
    Effect = "Common/PoisonEffect_Red,none"
  },
  [191] = {
    id = 191,
    EP = 0,
    Effect = "Common/PoisonEffect_Purple,none"
  },
  [192] = {
    id = 192,
    EP = 0,
    Effect = "Common/PoisonEffect_Black,none"
  },
  [193] = {
    id = 193,
    EP = 0,
    Effect = "Common/PoisonEffect_Green,none"
  },
  [200] = {
    id = 200,
    EP = 3,
    Effect = "Common/88Perfume_1,none"
  },
  [201] = {
    id = 201,
    EP = 3,
    Effect = "Common/97Perfume_2,none"
  },
  [204] = {
    id = 204,
    EP = 0,
    Effect = "Skill/Goddess_atk,none"
  },
  [209] = {
    id = 209,
    EP = 0,
    Effect = "Common/MysteltainnECP"
  },
  [215] = {
    id = 215,
    EP = 3,
    Effect = "Common/Withu_day,none"
  },
  [216] = {
    id = 216,
    EP = 3,
    Effect = "Skill/Eff_Blessing_buff,none"
  },
  [217] = {
    id = 217,
    EP = 3,
    Effect = "Skill/Eff_Heart_bubble,none"
  },
  [218] = {
    id = 218,
    EP = 3,
    Effect = "Skill/SakuraPerfume,none"
  },
  [219] = {
    id = 219,
    EP = 3,
    Effect = "Common/Star_rain,none"
  },
  [220] = {
    id = 220,
    EP = 2,
    Effect = "Common/With_dandelion,none"
  },
  [221] = {
    id = 221,
    EP = 3,
    Effect = "Common/PhotonForce_Blue,none"
  },
  [222] = {
    id = 222,
    EP = 2,
    Effect = "Common/Poison_apple,none"
  },
  [223] = {
    id = 223,
    EP = 3,
    Effect = "Skill/MagicRod_hit,none"
  },
  [224] = {
    id = 224,
    EP = 3,
    Effect = "Common/LandDragonBody,none"
  },
  [225] = {
    id = 225,
    EP = 2,
    Effect = "Common/Snowing,none"
  },
  [226] = {
    id = 226,
    EP = 2,
    Effect = "Common/Runes,none"
  },
  [227] = {
    id = 227,
    EP = 3,
    Effect = "Skill/CandySpread,none"
  },
  [228] = {
    id = 228,
    EP = 2,
    Effect = "Skill/LotteryCard_buff,none"
  },
  [229] = {
    id = 229,
    EP = 2,
    Effect = "Skill/MissingYou,none"
  },
  [230] = {
    id = 230,
    EP = 2,
    Effect = "Skill/Eff_CryogenicCyclone_buff,none"
  },
  [231] = {
    id = 231,
    EP = 2,
    Effect = "Common/Rhine_fairy,none"
  },
  [232] = {
    id = 232,
    EP = 3,
    Effect = "Skill/MonsterInvincible,none"
  },
  [234] = {
    id = 234,
    EP = 2,
    Effect = "Common/ShinEffect,none"
  },
  [235] = {
    id = 235,
    EP = 2,
    Effect = "Common/Cloudy,none"
  },
  [256] = {
    id = 256,
    EP = 6,
    Effect = "Skill/Eff_chase_fracture"
  },
  [301] = {
    id = 301,
    EP = 3,
    Effect = "Common/105BrightGold,none"
  },
  [302] = {
    id = 302,
    EP = 2,
    Effect_start = "Common/107Transform,none"
  },
  [303] = {
    id = 303,
    EP = 3,
    Effect = "Skill/Sakura_gift"
  },
  [304] = {
    id = 304,
    EP = 3,
    Effect = "Skill/Eff_8Thread_sun_small"
  },
  [305] = {
    id = 305,
    EP = 3,
    Effect = "Skill/Eff_DevilHorn_buff"
  },
  [306] = {
    id = 306,
    EP = 1,
    Effect = "Common/Worried"
  },
  [307] = {
    id = 307,
    EP = 0,
    Effect = "Skill/FalconEyes_Buff"
  },
  [308] = {
    id = 308,
    EP = 3,
    Effect = "Skill/poisoning_card"
  },
  [309] = {
    id = 309,
    EP = 1,
    Effect = "Skill/Sleep"
  },
  [310] = {
    id = 310,
    EP = 0,
    Effect = "Skill/DragonHowl_buff"
  },
  [311] = {
    id = 311,
    EP = 0,
    Effect = "Common/PhotonForce_Red"
  },
  [312] = {
    id = 312,
    EP = 0,
    Effect = "Common/PhotonForce_Purple"
  },
  [313] = {
    id = 313,
    EP = 0,
    Effect = "Common/PhotonForce_Green"
  },
  [314] = {
    id = 314,
    EP = 0,
    Effect = "Common/PhotonForce_Blue"
  },
  [315] = {
    id = 315,
    EP = 0,
    Effect = "Common/SpiritLantern"
  },
  [316] = {
    id = 316,
    EP = 0,
    Effect = "Common/gunman_SpiritLantern"
  },
  [317] = {
    id = 317,
    EP = 5,
    Effect = "Common/eff_ychb_shuihu"
  },
  [318] = {
    id = 318,
    EP = 0,
    Effect = "Common/Collection_EmirHeart"
  },
  [319] = {
    id = 319,
    EP = 2,
    Effect = "Common/eff_ychb_diaoyu"
  },
  [320] = {
    id = 320,
    EP = 2,
    Effect = "Common/gunman_tielian"
  },
  [321] = {
    id = 321,
    EP = 0,
    Effect = "Skill/Eff_smoke_04_grow"
  },
  [322] = {
    id = 322,
    EP = 3,
    Effect = "Common/WarnRing",
    EffectScale = 6
  },
  [323] = {
    id = 323,
    EP = 3,
    Effect = "Skill/FlameLand_buff2",
    EffectScale = 1.5
  },
  [324] = {
    id = 324,
    EP = 3,
    Effect = "Skill/FlameLand_buff2",
    EffectScale = 3
  },
  [325] = {
    id = 325,
    EP = 3,
    Effect = "Common/MonsterSmog"
  },
  [326] = {
    id = 326,
    EP = 0,
    Effect = "Common/Collection_Sunlingt_buff"
  },
  [640] = {
    id = 640,
    EP = 2,
    Effect = "Skill/BloodyPlague_buff",
    EffectScale = 1
  },
  [1800] = {
    id = 1800,
    EP = 0,
    Effect = "Skill/sfx_hurricane_buff_prf",
    SE_hit = "Skill/skill_magic_tornado_hit_01"
  },
  [4080] = {
    id = 4080,
    EP = 2,
    Effect = "Common/74GuideArrow"
  },
  [4081] = {
    id = 4081,
    EP = 2,
    Effect = "Common/73GuideArea"
  },
  [4110] = {
    id = 4110,
    EP = 3,
    Effect = "Skill/Eff_MagicMirror_change"
  },
  [4132] = {
    id = 4132,
    EP = 3,
    Effect = "Skill/SakuraPerfume,none"
  },
  [4133] = {
    id = 4133,
    EP = 3,
    Effect = "Common/103Dark_buff,none"
  },
  [4141] = {
    id = 4141,
    EP = 2,
    Effect = "Common/78Protect,none"
  },
  [4142] = {
    id = 4142,
    EP = 3,
    Effect = "Skill/Moonmirror_buff,none"
  },
  [4143] = {
    id = 4143,
    EP = 2,
    Effect = "Common/Withu_night,none"
  },
  [4152] = {
    id = 4152,
    EP = 2,
    Effect = "Common/Cherry_blossom"
  },
  [4153] = {
    id = 4153,
    EP = 3,
    Effect = "Common/SigeShadow_Body"
  },
  [4154] = {
    id = 4154,
    EP = 3,
    Effect = "Common/Snowing"
  },
  [4170] = {
    id = 4170,
    EP = 2,
    Effect = "Skill/Eff_ProhibitionApplication_buff,none"
  },
  [4171] = {
    id = 4171,
    EP = 3,
    Effect = "Skill/Eff_Asphyxia_buff"
  },
  [4172] = {
    id = 4172,
    EP = 3,
    Effect = "Common/MonsterSmog"
  },
  [4429] = {
    id = 4429,
    EP = 3,
    Effect = "Skill/sfx_Invincibleshied_prf"
  },
  [4803] = {
    id = 4803,
    EP = 7,
    Effect = "Skill/Eff_tuanben03_BossBody"
  },
  [4804] = {
    id = 4804,
    EP = 3,
    Effect = "Common/PhotonForce_Purple",
    EffectScale = 2
  },
  [6007] = {
    id = 6007,
    EP = 3,
    Effect = "Common/103Dark_buff,none"
  },
  [6021] = {
    id = 6021,
    EP = 3,
    Effect = "Common/constellation_aries,none"
  },
  [6022] = {
    id = 6022,
    EP = 3,
    Effect = "Common/constellation_taurus,none"
  },
  [6023] = {
    id = 6023,
    EP = 3,
    Effect = "Common/constellation_gemini,none"
  },
  [6024] = {
    id = 6024,
    EP = 3,
    Effect = "Common/constellation_cancer,none"
  },
  [6025] = {
    id = 6025,
    EP = 3,
    Effect = "Common/constellation_leo,none"
  },
  [6026] = {
    id = 6026,
    EP = 3,
    Effect = "Common/constellation_virgo,none"
  },
  [6027] = {
    id = 6027,
    EP = 3,
    Effect = "Common/constellation_libra,none"
  },
  [6028] = {
    id = 6028,
    EP = 3,
    Effect = "Common/constellation_scorpio,none"
  },
  [6029] = {
    id = 6029,
    EP = 3,
    Effect = "Common/constellation_sagittarius,none"
  },
  [6030] = {
    id = 6030,
    EP = 3,
    Effect = "Common/constellation_capricornus,none"
  },
  [6031] = {
    id = 6031,
    EP = 3,
    Effect = "Common/constellation_aquarius,none"
  },
  [6032] = {
    id = 6032,
    EP = 3,
    Effect = "Common/constellation_pisces,none"
  },
  [6040] = {
    id = 6040,
    EP = 2,
    Effect = "Skill/HardSunshine_buff,none"
  },
  [6041] = {
    id = 6041,
    EP = 2,
    Effect = "Skill/BrightMoonlight_buff,none"
  },
  [6042] = {
    id = 6042,
    EP = 1,
    Effect = "Skill/CandySpread,none"
  },
  [6047] = {
    id = 6047,
    EP = 3,
    Effect = "Skill/Morocc_refl"
  },
  [6050] = {
    id = 6050,
    EP = 2,
    Effect = "Common/Morocc_breath,none"
  },
  [6064] = {
    id = 6064,
    EP = 2,
    Effect = "Common/Flying_egg,none"
  },
  [6065] = {
    id = 6065,
    EP = 2,
    Effect = "Common/With_love"
  },
  [6066] = {
    id = 6066,
    EP = 0,
    Effect = "Common/Runes,none"
  },
  [6067] = {
    id = 6067,
    EP = 2,
    Effect_start = "Skill/Eff_Regiment_Promote,none"
  },
  [6072] = {
    id = 6072,
    EP = 1,
    Effect = "Common/Storming_eye_Flame,none"
  },
  [6214] = {
    id = 6214,
    EP = 0,
    Effect_start = "Skill/Evilsoul_Atk,none"
  },
  [6215] = {
    id = 6215,
    EP = 0,
    Effect = "Skill/FearBomb_buff,none"
  },
  [6216] = {
    id = 6216,
    EP = 0,
    Effect_start = "Skill/FearBomb_atk,none"
  },
  [6217] = {
    id = 6217,
    EP = 0,
    Effect = "Skill/InsurgencyFlame_buff,none"
  },
  [6219] = {id = 6219, EP = 0},
  [6220] = {
    id = 6220,
    EP = 0,
    Effect = "Skill/Eff_Flamingo,none"
  },
  [6221] = {
    id = 6221,
    EP = 0,
    Effect_start = "Skill/Eff_Thunderbolt_hit,none",
    Effect_hit = "Skill/Eff_Thunderbolt_hit,none"
  },
  [6222] = {
    id = 6222,
    EP = 0,
    Effect = "Common/With_Agni,none"
  },
  [6223] = {
    id = 6223,
    EP = 0,
    Effect = "Common/With_Akuja,none"
  },
  [6224] = {
    id = 6224,
    EP = 0,
    Effect = "Common/With_Ventus,none"
  },
  [6225] = {
    id = 6225,
    EP = 0,
    Effect = "Common/With_Tera,none"
  },
  [6226] = {
    id = 6226,
    EP = 0,
    Effect = "Skill/Eff_Three_ghosts"
  },
  [6227] = {
    id = 6227,
    EP = 0,
    Effect = "Skill/Eff_Forsake,none"
  },
  [6228] = {
    id = 6228,
    EP = 1,
    Effect = "Common/Girls_heart,none"
  },
  [6229] = {
    id = 6229,
    EP = 0,
    Effect = "Skill/Eff_Star_moon,none"
  },
  [6231] = {
    id = 6231,
    EP = 3,
    Effect = "Skill/Eff_Grim_reaper,none"
  },
  [6233] = {
    id = 6233,
    EP = 0,
    Effect = "Common/Cherry_blossom,none"
  },
  [6234] = {
    id = 6234,
    EP = 2,
    Effect = "Skill/Eff_Golden_particle,none"
  },
  [6239] = {
    id = 6239,
    EP = 0,
    Effect = "Common/PoisonEffect_Green,none"
  },
  [6240] = {id = 6240, EP = 0},
  [6241] = {id = 6241, EP = 0},
  [6247] = {id = 6247, EP = 0},
  [6250] = {
    id = 6250,
    EP = 0,
    Effect = "Common/Paper_plane,none"
  },
  [6251] = {
    id = 6251,
    EP = 0,
    Effect = "Skill/Eff_Translucent"
  },
  [6253] = {
    id = 6253,
    EP = 0,
    Effect = "Skill/Task_GetWet,none"
  },
  [6259] = {
    id = 6259,
    EP = 0,
    Effect = "Common/Vampiring,none"
  },
  [6422] = {
    id = 6422,
    EP = 0,
    Effect_start = "Common/20Buff_up,none"
  },
  [6437] = {
    id = 6437,
    EP = 2,
    Effect = "Skill/CircleSilent_buff"
  },
  [6445] = {
    id = 6445,
    EP = 2,
    Effect = "Common/DarkPartical,none"
  },
  [6446] = {
    id = 6446,
    EP = 1,
    Effect = "Skill/Eff_Anger_buff,none"
  },
  [6510] = {
    id = 6510,
    EP = 0,
    Effect = "Common/DarkPartical,none"
  },
  [6520] = {
    id = 6520,
    EP = 3,
    Effect = "Skill/Eff_Heart_bubble,none"
  },
  [6612] = {
    id = 6612,
    EP = 2,
    Effect_start = "Skill/sfx_festival_water_prf"
  },
  [6613] = {
    id = 6613,
    EP = 3,
    Effect = "Skill/sfx_festival_water_buff_prf"
  },
  [6646] = {
    id = 6646,
    EP = 3,
    Effect = "Common/HotPartical,none"
  },
  [6652] = {
    id = 6652,
    EP = 2,
    Effect = "Skill/Eff_08Toys_FlyingShoes"
  },
  [6655] = {
    id = 6655,
    EP = 1,
    Effect_start = "Skill/Eff_08Toys_scroll_buff"
  },
  [6657] = {
    id = 6657,
    EP = 3,
    Effect = "Skill/Eff_08Toys_scroll"
  },
  [6669] = {
    id = 6669,
    EP = 1,
    Effect = "Skill/Eff_08Toys_TurnAgainst"
  },
  [6671] = {
    id = 6671,
    EP = 1,
    Effect = "Skill/Eff_08Toys_taunt"
  },
  [6682] = {
    id = 6682,
    EP = 2,
    Effect_start = "Common/Clown"
  },
  [6704] = {
    id = 6704,
    EP = 3,
    Effect = "Skill/Eff_Dragonkilling_buff"
  },
  [6705] = {
    id = 6705,
    EP = 1,
    Effect_start = "Skill/Eff_Dragonkilling_atk"
  },
  [6706] = {
    id = 6706,
    EP = 3,
    Effect = "Skill/Eff_gongming_buff"
  },
  [6708] = {
    id = 6708,
    EP = 3,
    Effect = "Skill/Eff_gongzhen_buff"
  },
  [6710] = {
    id = 6710,
    EP = 3,
    Effect = "Skill/Eff_gongsheng_buff"
  },
  [6712] = {
    id = 6712,
    EP = 3,
    Effect = "Skill/Eff_gongxing_buff"
  },
  [6714] = {
    id = 6714,
    EP = 3,
    Effect = "Skill/Eff_Thunderbolt_buff"
  },
  [6717] = {
    id = 6717,
    EP = 0,
    Effect_start = "Skill/Eff_Thunderbolt_hit"
  },
  [6724] = {
    id = 6724,
    Logic = Table_BuffState_bk_t.Logic[3],
    EP = 3,
    Effect = "Common/Around,none",
    Effect_around = "Skill/InfiniteSing_buff2,none"
  },
  [6726] = {
    id = 6726,
    EP = 2,
    Effect_start = "Skill/Eff_PeaceEnvoy_buff"
  },
  [6730] = {
    id = 6730,
    EP = 0,
    Effect = "Skill/WarHorn_buff,none"
  },
  [6731] = {
    id = 6731,
    EP = 0,
    Effect = "Skill/BlastStep_buff,none"
  },
  [6739] = {
    id = 6739,
    EP = 2,
    Effect = "Skill/EverForce_buff"
  },
  [6742] = {
    id = 6742,
    EP = 0,
    Effect = "Skill/Collection_EternalMoonlight,none"
  },
  [6743] = {
    id = 6743,
    EP = 1,
    Effect = "Skill/Collection_SongRainbow,none"
  },
  [6744] = {
    id = 6744,
    EP = 1,
    Effect = "Common/Collection_Sunlingt_buff,none"
  },
  [6745] = {
    id = 6745,
    EP = 1,
    Effect = "Common/Collection_DarkClouds_buff,none"
  },
  [6746] = {
    id = 6746,
    EP = 1,
    Effect = "Common/Collection_Rain_buff,none"
  },
  [6747] = {
    id = 6747,
    EP = 2,
    Effect = "Common/Collection_Robin_buff,none"
  },
  [6748] = {
    id = 6748,
    EP = 0,
    Effect = "Common/Collection_EmirHeart,none"
  },
  [6751] = {
    id = 6751,
    EP = 2,
    Effect = "Skill/Collection_HearPyramid,none"
  },
  [6753] = {
    id = 6753,
    EP = 1,
    Effect = "Common/Collection_Snow_buff,none"
  },
  [6754] = {
    id = 6754,
    EP = 1,
    Effect = "Common/Collection_Coin,none"
  },
  [6755] = {
    id = 6755,
    EP = 0,
    Effect = "Common/DarkPartical_1,none"
  },
  [6756] = {
    id = 6756,
    EP = 0,
    Effect = "Common/DarkPartical_2,none"
  },
  [6757] = {
    id = 6757,
    EP = 0,
    Effect = "Common/DarkPartical,none"
  },
  [6766] = {
    id = 6766,
    EP = 0,
    Effect = "Common/Star_rain,none"
  },
  [6787] = {
    id = 6787,
    EP = 0,
    Effect = "Skill/BrightMoonlight_buff,none"
  },
  [6809] = {
    id = 6809,
    EP = 0,
    Effect = "Common/103Dark_buff"
  },
  [6810] = {
    id = 6810,
    EP = 0,
    Effect = "Skill/Evilsoul_hit"
  },
  [6857] = {
    id = 6857,
    EP = 2,
    Effect = "Common/eff_aixin_huodong,none"
  },
  [6860] = {
    id = 6860,
    EP = 3,
    Effect = "Common/FlameHorse_Head,none"
  },
  [6882] = {
    id = 6882,
    EP = 2,
    Effect = "Skill/Netherworld_12pvp,none"
  },
  [6884] = {
    id = 6884,
    EP = 2,
    Effect = "Skill/Eff_duyu,none"
  },
  [6936] = {
    id = 6936,
    EP = 3,
    Effect = "Common/120ChocolateSmell_1,none"
  },
  [6942] = {
    id = 6942,
    EP = 2,
    Effect = "Common/Eff_6v6CircleSole_black"
  },
  [6944] = {
    id = 6944,
    EP = 2,
    Effect_start = "Skill/Heal",
    Effect_hit = "Skill/Heal"
  },
  [6950] = {
    id = 6950,
    EP = 1,
    Effect = "Skill/sfx_zyhd_buff_prf"
  },
  [8015] = {
    id = 8015,
    EP = 3,
    Effect = "Skill/sfx_xgc_buff_01_prf,none"
  },
  [8017] = {
    id = 8017,
    EP = 2,
    Effect = "Common/Clown",
    SE_start = "UI/ui_found_01"
  },
  [10000] = {id = 10000},
  [10001] = {id = 10001},
  [10012] = {
    id = 10012,
    EP = 2,
    Effect = "Skill/RoseBloom"
  },
  [10013] = {
    id = 10013,
    EP = 7,
    Effect = "Common/Kongming_latern"
  },
  [10074] = {
    id = 10074,
    EP = 2,
    Effect = "Skill/sfx_zhys_floor_prf,none",
    EffectScale = 0.7
  },
  [10081] = {
    id = 10081,
    EP = 2,
    Effect = "Skill/sfx_zhys_hit_prf,none",
    EffectScale = 1.3
  },
  [10082] = {
    id = 10082,
    EP = 2,
    Effect = "Skill/sfx_Eff_ShadowSeparation03_prf,none",
    EffectScale = 1.3
  },
  [10083] = {
    id = 10083,
    EP = 2,
    Effect = "Skill/sfx_Eff_ShadowSeparation01_prf,none",
    EffectScale = 1.3
  },
  [10084] = {
    id = 10084,
    EP = 2,
    Effect = "Skill/Eff_violet4_buff_Secret,none",
    EffectScale = 0.7
  },
  [10085] = {
    id = 10085,
    EP = 1,
    Effect = "Skill/sfx_zhys_buff_prf,none",
    EffectScale = 1.3
  },
  [10130] = {
    id = 10130,
    EP = 2,
    Effect = "Skill/sfx_pve3_zhua_atk_prf,none",
    EffectScale = 1
  },
  [10131] = {
    id = 10131,
    EP = 3,
    Effect = "Skill/CrazyFlame_buff1,none",
    EffectScale = 0.5
  },
  [10132] = {
    id = 10132,
    EP = 2,
    Effect = "Skill/CrazyFlame_buff1,none",
    EffectScale = 0.6
  },
  [10133] = {
    id = 10133,
    EP = 2,
    Effect = "Skill/Eff_tuanben3_dihuo_prf,none",
    EffectScale = 1
  },
  [10134] = {
    id = 10134,
    EP = 2,
    Effect = "Skill/sfx_absorbed_buff_prf,none",
    EffectScale = 1
  },
  [10171] = {
    id = 10171,
    EP = 3,
    Effect_start = "Skill/sfx_morocc_atk_prf",
    SE_start = "Skill/skill_magic_monrockeyesgather_attack_01"
  },
  [10172] = {
    id = 10172,
    EP = 10,
    Effect = "Skill/sfx_morocc_buff01_prf"
  },
  [10173] = {
    id = 10173,
    EP = 0,
    Effect_start = "Skill/sfx_morocc_death_prf",
    SE_start = "Skill/skill_magic_monrockeyescvanish_attack_01"
  },
  [10200] = {
    id = 10200,
    EP = 0,
    Effect_start = "Skill/sfx_morocc_carttornado_floor_prf",
    SE_start = "Skill/skill_magic_tornado_attack_01",
    SE_hit = "Skill/skill_magic_tornado_hit_01"
  },
  [10231] = {
    id = 10231,
    EP = 0,
    Effect_start = "Skill/sfx_morocc_yan_atk_prf",
    SE_start = "Skill/skill_magic_lasereyes_attack_01"
  },
  [10300] = {
    id = 10300,
    EP = 2,
    Effect = "Skill/Eff_shugenchaorao,none",
    EffectScale = 1
  },
  [10301] = {
    id = 10301,
    EP = 2,
    Effect = "Skill/sfx_taqk_03_prf,none",
    EffectScale = 1.1
  },
  [10302] = {
    id = 10302,
    EP = 2,
    Effect = "Skill/MudFlatDeep,none",
    EffectScale = 0.4
  },
  [10303] = {
    id = 10303,
    EP = 2,
    Effect = "Skill/MagicPoison_buff,none",
    EffectScale = 2
  },
  [10304] = {
    id = 10304,
    EP = 2,
    Effect = "Skill/Eff_Monster75_duye_atk,none",
    EffectScale = 2
  },
  [10332] = {
    id = 10332,
    EP = 3,
    Effect_start = "Skill/sfx_nagasiren_qp_atk_prf"
  },
  [10333] = {
    id = 10333,
    EP = 3,
    Effect = "Skill/sfx_suosi_qp_buff_prf"
  },
  [10350] = {
    id = 10350,
    EP = 0,
    Effect = "Skill/sfx_suosi_judu_buff02_prf"
  },
  [10351] = {
    id = 10351,
    EP = 0,
    Effect = "Skill/sfx_suosi_judu_buff02_prf",
    EffectScale = 1.67
  },
  [10352] = {
    id = 10352,
    EP = 0,
    Effect = "Skill/sfx_suosi_judu_buff02_prf",
    EffectScale = 2.33
  },
  [10353] = {
    id = 10353,
    EP = 0,
    Effect = "Skill/sfx_suosi_judu_buff02_prf",
    EffectScale = 3.33
  },
  [10354] = {
    id = 10354,
    EP = 2,
    Effect_start = "Skill/sfx_suosi_judu_buff01_prf"
  },
  [10450] = {
    id = 10450,
    EP = 3,
    Effect_start = "Skill/sfx_rockelementturtle_charge_atk_prf"
  },
  [10510] = {
    id = 10510,
    EP = 3,
    Effect_start = "Skill/sfx_wgd_du_01_prf"
  },
  [10587] = {
    id = 10587,
    EP = 3,
    Effect = "Skill/sfx_magicdragon_fire_prf"
  },
  [10588] = {
    id = 10588,
    EP = 3,
    Effect = "Skill/sfx_magicdragon_poison_prf"
  },
  [10597] = {
    id = 10597,
    EP = 2,
    Effect = "Skill/sfx_magicdragon_fire_buff_01_prf"
  },
  [10791] = {
    id = 10791,
    EP = 1,
    Effect = "Skill/Eff_MVP2_sharen_buff01"
  },
  [10792] = {
    id = 10792,
    EP = 1,
    Effect = "Skill/Eff_MVP2_sharen_buff02"
  },
  [10793] = {
    id = 10793,
    EP = 1,
    Effect = "Skill/Eff_MVP2_sharen_buff03"
  },
  [11270] = {
    id = 11270,
    EP = 3,
    Effect = "Skill/sfx_ysfb_feng_01_prf",
    EffectScale = 3
  },
  [11271] = {
    id = 11271,
    EP = 3,
    Effect = "Skill/sfx_ysfb_huo_01_prf",
    EffectScale = 3
  },
  [11272] = {
    id = 11272,
    EP = 3,
    Effect = "Skill/sfx_ysfb_shui_01_prf",
    EffectScale = 3
  },
  [11273] = {
    id = 11273,
    EP = 3,
    Effect = "Skill/sfx_ysfb_di_01_prf",
    EffectScale = 3
  },
  [11274] = {
    id = 11274,
    EP = 3,
    Effect = "Skill/sfx_ysfb_wu_01_prf",
    EffectScale = 3
  },
  [11275] = {
    id = 11275,
    EP = 3,
    Effect = "Skill/sfx_ysfb_seng_seng_prf",
    EffectScale = 3
  },
  [11276] = {
    id = 11276,
    EP = 3,
    Effect = "Skill/sfx_ysfb_an_01_prf",
    EffectScale = 3
  },
  [11277] = {
    id = 11277,
    EP = 3,
    Effect = "Skill/sfx_ysfb_du_01_prf",
    EffectScale = 3
  },
  [11278] = {
    id = 11278,
    EP = 3,
    Effect = "Skill/sfx_ysfb_busi_01_prf",
    EffectScale = 3
  },
  [11279] = {
    id = 11279,
    EP = 3,
    Effect = "Skill/sfx_ysfb_nian_01_prf",
    EffectScale = 3
  },
  [11283] = {
    id = 11283,
    EP = 2,
    Effect = "Skill/sfx_syl_floor_prf"
  },
  [11284] = {
    id = 11284,
    EP = 0,
    Effect = "Skill/Eff_WinterFenbuhr_buff,none",
    Follow = 1
  },
  [11297] = {
    id = 11297,
    EP = 2,
    Effect = "Skill/sfx_eff_winterfenbuhr_buff_prf"
  },
  [11298] = {
    id = 11298,
    EP = 3,
    Effect = "Skill/sfx_rootofcorruption_js_buff_001_prf"
  },
  [11299] = {
    id = 11299,
    EP = 3,
    Effect = "Skill/sfx_darklaicorpse_buff_001_prf"
  },
  [11300] = {
    id = 11300,
    EP = 2,
    Effect = "Skill/Garm_Ice_bom"
  },
  [11301] = {
    id = 11301,
    EP = 3,
    Effect = "Skill/sfx_boss_dispersion_buff_prf"
  },
  [11322] = {
    id = 11322,
    EP = 3,
    Effect = "Skill/sfx_rootofcorruption_jsbf_hit001_prf"
  },
  [11323] = {
    id = 11323,
    EP = 1,
    Effect = "Skill/sfx_gczc_box_buff_prf"
  },
  [11324] = {
    id = 11324,
    EP = 2,
    Effect = "Skill/DefendingAura_buff"
  },
  [11327] = {
    id = 11327,
    EP = 2,
    Effect = "Skill/sfx_darklaicorpse_tf_buff_002_prf"
  },
  [11329] = {
    id = 11329,
    EP = 2,
    Effect = "Skill/sfx_darklaicorpse_xg_buff_001_prf"
  },
  [11330] = {
    id = 11330,
    EP = 3,
    Effect = "Skill/sfx_earlymutantdragon_buff_prf"
  },
  [11334] = {
    id = 11334,
    EP = 3,
    Effect = "Skill/Blew_attack"
  },
  [11339] = {
    id = 11339,
    EP = 3,
    Effect = "Skill/sfx_earlymutantdragon_huochong_floor_prf"
  },
  [11340] = {
    id = 11340,
    EP = 3,
    Effect = "Skill/sfx_darklaicorpse_buff_yan_001_prf"
  },
  [11353] = {
    id = 11353,
    EP = 3,
    Effect = "Skill/sfx_darklaicorpse_buff_yan_buff_prf"
  },
  [11355] = {
    id = 11355,
    EP = 3,
    Effect = "Skill/sfx_gczc_boss_red_prf",
    EffectScale = 2,
    Offset = Table_BuffState_bk_t.Offset[10]
  },
  [11356] = {
    id = 11356,
    EP = 3,
    Effect = "Skill/sfx_gczc_boss_red_prf",
    EffectScale = 2,
    Offset = Table_BuffState_bk_t.Offset[11]
  },
  [11379] = {
    id = 11379,
    EP = 3,
    Effect = "Skill/MartyrsReckoning_buff",
    EffectScale = 2
  },
  [11382] = {
    id = 11382,
    EP = 3,
    Effect = "Skill/sfx_mysteltainnwarrior_buff_01_prf"
  },
  [11383] = {
    id = 11383,
    EP = 3,
    Effect = "Skill/sfx_mysteltainnwarrior_buff_02_prf"
  },
  [11384] = {
    id = 11384,
    EP = 3,
    Effect = "Skill/sfx_mysteltainnwarrior_buff_03_prf"
  },
  [11391] = {
    id = 11391,
    EP = 3,
    Effect = "Skill/sfx_mysteltainnwarrior_ready_prf"
  },
  [11392] = {
    id = 11392,
    EP = 2,
    Effect = "Skill/sfx_mysteltainnwarrior_fushi_sing_prf"
  },
  [11422] = {
    id = 11422,
    EP = 2,
    Effect = "Skill/sfx_baphometancient_ld_buff_prf"
  },
  [11500] = {
    id = 11500,
    EP = 2,
    Effect = "Skill/CrimsonRock_DM",
    Offset = Table_BuffState_bk_t.Offset[5]
  },
  [11530] = {
    id = 11530,
    EP = 3,
    Effect_start = "Skill/sfx_centausprince_yhfs_buff_prf",
    SE_start = "Skill/sfx_skill_prince_hellfire_explo_01"
  },
  [11531] = {
    id = 11531,
    EP = 3,
    Effect = "Skill/sfx_centausprince_yhfs_qiu_01_prf"
  },
  [11532] = {
    id = 11532,
    EP = 3,
    Effect = "Skill/sfx_centausprince_yhfs_qiu_02_prf"
  },
  [11533] = {
    id = 11533,
    EP = 3,
    Effect = "Skill/sfx_centausprince_yhfs_qiu_03_prf"
  },
  [11534] = {
    id = 11534,
    EP = 3,
    Effect = "Skill/sfx_centausprince_yhfs_qiu_04_prf"
  },
  [11560] = {
    id = 11560,
    EP = 2,
    Effect_hit = "Skill/sfx_eternalflower_buff_prf"
  },
  [11580] = {
    id = 11580,
    EP = 2,
    Effect = "Skill/sfx_centausprince_zx_buff_01_prf",
    SE_start_Loop = "Skill/sfx_skill_prince_burining_heart_act_01"
  },
  [11590] = {
    id = 11590,
    EP = 2,
    Effect_hit = "Skill/sfx_centausprince_zx_buff_02_prf",
    SE_hit = "Skill/sfx_skill_prince_burining_heart_hit_01"
  },
  [11600] = {
    id = 11600,
    EP = 1,
    Effect = "Skill/sfx_centausprince_hl_buff_prf"
  },
  [11695] = {
    id = 11695,
    EP = 2,
    Effect = "Skill/Absorbed_buff,none"
  },
  [11698] = {
    id = 11698,
    EP = 2,
    Effect = "SKill/sfx_3291_MJSX_sing_prf"
  },
  [11700] = {
    id = 11700,
    EP = 2,
    Effect = "Skill/sfx_3291_DQ_sing01_prf",
    EffectScale = 1
  },
  [11702] = {
    id = 11702,
    EP = 2,
    Effect_hit = "Skill/sfx_3291_MH_buff_prf",
    Effect_hitScale = 1
  },
  [11710] = {
    id = 11710,
    EP = 2,
    Effect = "Skill/sfx_3291_ground01_prf",
    EffectScale = 1
  },
  [11711] = {
    id = 11711,
    EP = 2,
    Effect = "Skill/sfx_3291_ground02_prf",
    EffectScale = 1
  },
  [11717] = {
    id = 11717,
    EP = 2,
    Effect = "Skill/sfx_mojianchuansongmen_buff01_prf",
    EffectScale = 1
  },
  [11718] = {
    id = 11718,
    EP = 2,
    Effect = "Skill/sfx_mojianchuansongmen_buff02_prf",
    EffectScale = 1
  },
  [11740] = {
    id = 11740,
    EP = 2,
    Effect = "Skill/sfx_3291_SH_sing_prf",
    EffectScale = 1
  },
  [11742] = {
    id = 11742,
    EP = 2,
    Effect = "Skill/sfx_mojian_warning01_buff_prf",
    EffectScale = 1
  },
  [11750] = {
    id = 11750,
    EP = 1,
    Effect = "Skill/sfx_3291_SKLDBY_buff_prf",
    EffectScale = 1.5
  },
  [11751] = {
    id = 11751,
    EP = 1,
    Effect_hit = "Skill/sfx_3291_SKLDBY_disappear_prf",
    Effect_hitScale = 2
  },
  [11760] = {
    id = 11760,
    EP = 1,
    Effect = "Skill/sfx_3291_DQ_sing_prf",
    EffectScale = 1
  },
  [11761] = {
    id = 11761,
    EP = 2,
    Effect_hit = "Skill/sfx_3291_DQ_atk_prf"
  },
  [11770] = {
    id = 11770,
    EP = 1,
    Effect = "Skill/sfx_3291_HZ_sing_prf",
    EffectScale = 1
  },
  [11771] = {
    id = 11771,
    EP = 2,
    Effect = "Skill/sfx_3291_hengzhan_yujing_prf",
    EffectScale = 1
  },
  [20241] = {
    id = 20241,
    EP = 3,
    Effect = "Skill/Dispersion_buff,none"
  },
  [26360] = {
    id = 26360,
    EP = 2,
    Effect = "Skill/Rain_Cloud,none"
  },
  [34151] = {
    id = 34151,
    EP = 0,
    Effect_start = "Skill/NPC_starball_wing",
    SE_start = "Skill/NPC_Starball_wing"
  },
  [41091] = {
    id = 41091,
    EP = 3,
    Effect = "Skill/Solarglory_buff"
  },
  [41092] = {
    id = 41092,
    EP = 3,
    Effect_start = "Skill/Solarglory_hit"
  },
  [41094] = {
    id = 41094,
    EP = 3,
    Effect_start = "Skill/Solarglory"
  },
  [41121] = {
    id = 41121,
    EP = 3,
    Effect = "Skill/Lunaring_buff"
  },
  [41122] = {
    id = 41122,
    EP = 3,
    Effect_start = "Skill/Lunaring_buff2"
  },
  [41124] = {
    id = 41124,
    EP = 3,
    Effect_start = "Skill/Lunaring"
  },
  [41151] = {
    id = 41151,
    EP = 3,
    Effect = "Skill/Starshining_buff"
  },
  [41152] = {
    id = 41152,
    EP = 3,
    Effect_start = "Skill/Starshining_hit",
    Effect = "Skill/Starshining_buff2"
  },
  [41181] = {
    id = 41181,
    EP = 3,
    Effect = "Skill/SunconterATK_buff"
  },
  [41411] = {
    id = 41411,
    EP = 3,
    Effect = "Skill/Moonmirror_buff"
  },
  [41412] = {
    id = 41412,
    EP = 3,
    Effect_start = "Skill/Moonmirror_hit"
  },
  [41441] = {
    id = 41441,
    EP = 3,
    Effect = "Skill/Starwithered_buff"
  },
  [41442] = {
    id = 41442,
    EP = 3,
    Effect_start = "Skill/Starwithered_hit"
  },
  [44493] = {
    id = 44493,
    EP = 2,
    Effect_start = "Skill/Eff_shenqi_kongju"
  },
  [44522] = {
    id = 44522,
    EP = 1,
    Effect = "Skill/Eff_shenqi_iaxie_buff"
  },
  [45233] = {
    id = 45233,
    EP = 1,
    Effect = "Skill/eff_Guilt_gun_buff"
  },
  [45265] = {
    id = 45265,
    EP = 2,
    Effect = "Skill/eff_Guilt_rifle"
  },
  [50021] = {
    id = 50021,
    EP = 1,
    Effect = "Skill/Curse,none"
  },
  [52960] = {
    id = 52960,
    EP = 0,
    Effect_start = "Skill/Freath"
  },
  [57121] = {
    id = 57121,
    EP = 1,
    Effect = "Skill/sfx_magicdragon_buff_prf"
  },
  [80000] = {id = 80000, EP = 3},
  [80010] = {
    id = 80010,
    EP = 1,
    Effect = "Skill/Dizzy,none"
  },
  [80020] = {
    id = 80020,
    EP = 1,
    Effect = "Skill/Sleep,none"
  },
  [80031] = {
    id = 80031,
    EP = 1,
    Effect_start = "Skill/Provoke,none",
    Effect_hit = "Skill/Provoke,none"
  },
  [80170] = {
    id = 80170,
    EP = 0,
    Effect_start = "Skill/LordAura,none",
    Effect_hit = "Skill/LordAura,none"
  },
  [80230] = {
    id = 80230,
    EP = 2,
    Effect = "Skill/HeartOfSteel_buff,none"
  },
  [85030] = {
    id = 85030,
    EP = 3,
    Effect = "Skill/FireHunt,none"
  },
  [85060] = {
    id = 85060,
    EP = 3,
    Effect = "Skill/EnergyCoat,none"
  },
  [85070] = {
    id = 85070,
    EP = 0,
    Effect = "Skill/Frozen,none",
    Effect_end = "Skill/FrozenBroken,none",
    SE_start = "Skill/StoneCurse",
    SE_end = "Common/Frozen_explosion"
  },
  [85090] = {
    id = 85090,
    EP = 0,
    Effect = "Skill/ poisoning,none",
    Effect_end = "Skill/FrozenBroken,none",
    SE_start = "Skill/StoneCurse",
    SE_end = "Common/Frozen_explosion"
  },
  [85100] = {
    id = 85100,
    EP = 2,
    Effect = "Skill/HallucinationWalk,none"
  },
  [85110] = {
    id = 85110,
    EP = 2,
    Effect = "Skill/Stone,none",
    SE_end = "Common/StoneCurse_end"
  },
  [85160] = {
    id = 85160,
    EP = 1,
    Effect = "Skill/FlameShock_Buff,none",
    Effect_end = "Skill/FlameShock_Boom,none",
    SE_end = "Skill/FlameShock_boom"
  },
  [90020] = {
    id = 90020,
    EP = 2,
    Effect = "Skill/AnkleSnarehit,none"
  },
  [90050] = {
    id = 90050,
    EP = 1,
    Effect = "Skill/poisoning,none",
    SE_start = "Common/poison"
  },
  [90140] = {
    id = 90140,
    EP = 1,
    Effect = "Skill/LightingArrow_buff,none"
  },
  [90150] = {
    id = 90150,
    EP = 1,
    Effect_start = "Skill/WeaponPerfection_hit,none",
    Effect_hit = "Skill/WeaponPerfection_hit,none",
    SE_start = "Skill/WeaponPerfection",
    SE_hit = "Skill/WeaponPerfection"
  },
  [90160] = {
    id = 90160,
    EP = 2,
    Effect_start = "Skill/PowerThrust_hit,none",
    Effect_hit = "Skill/PowerThrust_hit,none",
    SE_hit = "Skill/PowerThrust"
  },
  [90200] = {
    id = 90200,
    EP = 3,
    Effect = "Skill/FalconEyes_Buff,none",
    SE_start = "Common/poison"
  },
  [95020] = {
    id = 95020,
    EP = 1,
    Effect_start = "Skill/Blessing,none",
    Effect_hit = "Skill/Blessing,none",
    SE_hit = "Common/blessing"
  },
  [95030] = {
    id = 95030,
    EP = 0,
    Effect = "Skill/LightHunt,none",
    SE_start = "Skill/Ef_sight"
  },
  [95060] = {
    id = 95060,
    EP = 3,
    Effect = "Skill/Parry,none"
  },
  [95080] = {
    id = 95080,
    EP = 2,
    Effect_start = "Skill/Magnificat,none",
    Effect_hit = "Skill/Magnificat,none"
  },
  [95100] = {
    id = 95100,
    EP = 1,
    Effect_start = "Skill/Aspersio,none",
    Effect_hit = "Skill/Aspersio,none"
  },
  [95110] = {
    id = 95110,
    EP = 1,
    Effect_start = "Skill/DivineProtection,none",
    Effect_hit = "Skill/DivineProtection,none"
  },
  [95140] = {
    id = 95140,
    EP = 1,
    Effect_start = "Skill/Angelus,none",
    Effect_hit = "Skill/Angelus,none"
  },
  [95160] = {
    id = 95160,
    EP = 3,
    Effect = "Skill/TurnUndead,none"
  },
  [95170] = {
    id = 95170,
    EP = 0,
    Effect_start = "Skill/ResurrectionPrepare,Skill/LowBuff_B",
    Effect_hit = "Skill/ResurrectionPrepare,Skill/LowBuff_B"
  },
  [95171] = {
    id = 95171,
    EP = 0,
    Effect_start = "Skill/Resurrection,Skill/LowBuff_B",
    Effect_hit = "Skill/Resurrection,Skill/LowBuff_B"
  },
  [95190] = {
    id = 95190,
    EP = 1,
    Effect_start = "Skill/Basilica,none",
    Effect_hit = "Skill/Basilica,none"
  },
  [95210] = {
    id = 95210,
    EP = 3,
    Effect = "Skill/Assumptio_buff,none"
  },
  [95270] = {
    id = 95270,
    EP = 3,
    Effect = "Skill/poisoning_card,none",
    Effect_end = "Skill/VenomSplasher,none",
    SE_start = "Common/poison"
  },
  [95300] = {
    id = 95300,
    EP = 3,
    Effect_end = "Skill/RemoveHidden,none"
  },
  [95310] = {
    id = 95310,
    EP = 2,
    Effect = "Common/78Protect,none"
  },
  [95340] = {
    id = 95340,
    EP = 1,
    Effect = "Skill/Dizzy,none"
  },
  [95380] = {
    id = 95380,
    EP = 2,
    Effect_start = "Skill/Detoxify,none",
    Effect_hit = "Skill/Detoxify,none"
  },
  [95400] = {
    id = 95400,
    EP = 2,
    Effect = "Skill/poisoning,none",
    Effect_end = "Skill/VenomSplasher,none",
    SE_end = "Skill/VenomExplosion"
  },
  [95410] = {
    id = 95410,
    EP = 3,
    Effect = "Skill/LightHP_buff,none"
  },
  [95450] = {
    id = 95450,
    EP = 2,
    Effect = "Skill/EnchantDeadlyPoison,none"
  },
  [95480] = {
    id = 95480,
    EP = 2,
    Effect_start = "Skill/SilentKiller,none",
    Effect_hit = "Skill/SilentKiller,none"
  },
  [95500] = {
    id = 95500,
    EP = 1,
    Effect = "Skill/sfx_cike_qhzr_buff_prf,none",
    Effect_hit = "Skill/MaximumPowerThrust_hit,none"
  },
  [96010] = {
    id = 96010,
    EP = 1,
    Effect_start = "Skill/Suffragium,none",
    Effect_hit = "Skill/Suffragium,none"
  },
  [96030] = {
    id = 96030,
    EP = 1,
    Effect_start = "Skill/DecreaseAGI,none",
    Effect_hit = "Skill/DecreaseAGI,none",
    SE_start = "Skill/DecreaseAGI"
  },
  [96040] = {
    id = 96040,
    EP = 1,
    Effect_start = "Skill/LexDivina,none",
    Effect = "Skill/Silence,none",
    SE_start = "Common/silence"
  },
  [96041] = {
    id = 96041,
    EP = 3,
    Effect = "Skill/NOSay_buff,none"
  },
  [96050] = {
    id = 96050,
    EP = 1,
    Effect_start = "Skill/LexAeterna,none",
    Effect_hit = "Skill/LexAeterna,none"
  },
  [96090] = {
    id = 96090,
    EP = 1,
    Effect_start = "Skill/CrazyUproar_attack,none",
    Effect_hit = "Skill/CrazyUproar_attack,none"
  },
  [96150] = {
    id = 96150,
    EP = 3,
    Effect_start = "Skill/PowerThrust_hit,none",
    Effect_hit = "Skill/PowerThrust_hit,none"
  },
  [96151] = {
    id = 96151,
    EP = 3,
    Effect_start = "Skill/sfx_PowerThrust_buff_prf,none",
    Effect_hit = "Skill/sfx_PowerThrust_buff_prf,none"
  },
  [96180] = {
    id = 96180,
    EP = 3,
    Effect_start = "Skill/AdrenalineRush_attack,none",
    Effect_hit = "Skill/AdrenalineRush_attack,none"
  },
  [96220] = {
    id = 96220,
    EP = 2,
    Effect_start = "Skill/ShatteringStrike_attack,none",
    Effect_hit = "Skill/ShatteringStrike_attack,none"
  },
  [96250] = {
    id = 96250,
    EP = 3,
    Effect_start = "Skill/MaximumPowerThrust_hit,none",
    Effect_hit = "Skill/MaximumPowerThrust_hit,none"
  },
  [100200] = {
    id = 100200,
    EP = 2,
    Effect = "Skill/HallucinationWalk,none"
  },
  [100500] = {
    id = 100500,
    Logic = Table_BuffState_bk_t.Logic[1],
    EP = 1,
    Effect = "Common/Around,none",
    Effect_around = "Skill/SummonSpiritSphere,none"
  },
  [100501] = {
    id = 100501,
    EP = 1,
    Effect = "Common/Around,none",
    Effect_around = "Skill/SummonSpiritSphere_Gold,none"
  },
  [100510] = {
    id = 100510,
    EP = 3,
    Effect = "Skill/Fury_buff,none"
  },
  [100660] = {
    id = 100660,
    EP = 3,
    Effect = "Skill/MentalStrength_buff,none"
  },
  [100680] = {
    id = 100680,
    EP = 3,
    Effect = "Skill/Root_buff,none"
  },
  [103070] = {
    id = 103070,
    EP = 0,
    Effect = "Skill/GreeneryWall_buff,none"
  },
  [103100] = {
    id = 103100,
    EP = 3,
    Effect = "Skill/WarHorn_buff,none"
  },
  [103200] = {
    id = 103200,
    EP = 0,
    Effect = "Skill/BloodLust_buff,none"
  },
  [103800] = {
    id = 103800,
    EP = 1,
    Effect = "Skill/SelfDestruction_buff,none"
  },
  [103900] = {
    id = 103900,
    EP = 3,
    Effect_start = "Skill/MagicDevour_hit,none",
    Effect_hit = "Skill/MagicDevour_hit,none"
  },
  [104010] = {
    id = 104010,
    EP = 3,
    Effect_start = "Skill/AlchemicalWeapon_hit,none",
    Effect_hit = "Skill/AlchemicalWeapon_hit,none"
  },
  [104080] = {
    id = 104080,
    EP = 0,
    Effect = "Skill/LifeRepair,none"
  },
  [106100] = {
    id = 106100,
    EP = 3,
    Effect = "Skill/Disappear_buff,none"
  },
  [106152] = {
    id = 106152,
    EP = 0,
    Effect = "Skill/CloseConfine_buff,none"
  },
  [106180] = {
    id = 106180,
    EP = 1,
    Effect_start = "Skill/DivestAccessory_hit,none",
    Effect_hit = "Skill/DivestAccessory_hit,none"
  },
  [106181] = {
    id = 106181,
    EP = 1,
    Effect_start = "Skill/sfx_DivestAccessory_star_buff_prf,none",
    Effect_hit = "Skill/sfx_DivestAccessory_star_buff_prf,none"
  },
  [106190] = {
    id = 106190,
    EP = 1,
    Effect_start = "Skill/DivestShield_hit,none",
    Effect_hit = "Skill/DivestShield_hit,none"
  },
  [106191] = {
    id = 106191,
    EP = 1,
    Effect_start = "Skill/sfx_DivestShield_star_buff_prf,none",
    Effect_hit = "Skill/sfx_DivestShield_star_buff_prf,none"
  },
  [107001] = {
    id = 107001,
    EP = 3,
    Effect = "Skill/TyrSword_Buff,none"
  },
  [107012] = {
    id = 107012,
    EP = 3,
    Effect = "Skill/WinterCrystal_Buff2,none"
  },
  [107013] = {
    id = 107013,
    EP = 3,
    Effect = "Skill/WinterCrystal_Buff1,none"
  },
  [107021] = {
    id = 107021,
    EP = 1,
    Effect = "Skill/EternalSpear_Buff,none"
  },
  [107030] = {
    id = 107030,
    EP = 3,
    Effect = "Skill/WarTerminator_Buff,none"
  },
  [107043] = {
    id = 107043,
    EP = 0,
    Effect = "Skill/ThorHammer_Buff2,none"
  },
  [107050] = {
    id = 107050,
    EP = 1,
    Effect = "Skill/GodsGaze_Buff,none"
  },
  [107070] = {
    id = 107070,
    EP = 3,
    Effect = "Skill/AnniHilate_Buff,none"
  },
  [107200] = {
    id = 107200,
    EP = 3,
    Effect = "Skill/GuardianAngel_buff,none"
  },
  [107220] = {
    id = 107220,
    EP = 1,
    Effect = "Skill/FearBomb_buff,none"
  },
  [107230] = {
    id = 107230,
    EP = 0,
    Effect = "Skill/StormHeart_buff,none"
  },
  [107360] = {
    id = 107360,
    EP = 2,
    Effect = "Skill/jianrenkexing"
  },
  [107382] = {
    id = 107382,
    EP = 1,
    Effect = "Skill/Eff_6v6Switch"
  },
  [107383] = {
    id = 107383,
    EP = 1,
    Effect = "Skill/Eff_6v6Circle_white"
  },
  [107384] = {
    id = 107384,
    EP = 1,
    Effect = "Skill/Eff_6v6Circle_black"
  },
  [107385] = {
    id = 107385,
    EP = 1,
    Effect = "Skill/Eff_6v6Circle_Sure"
  },
  [107433] = {
    id = 107433,
    EP = 3,
    Effect = "Skill/sfx_hudun_feng_buff_02_prf"
  },
  [107435] = {
    id = 107435,
    EP = 3,
    Effect = "Skill/sfx_hudun_di_buff_03_prf"
  },
  [107437] = {
    id = 107437,
    EP = 3,
    Effect = "Skill/sfx_hudun_shui_buff_04_prf"
  },
  [107439] = {
    id = 107439,
    EP = 3,
    Effect = "Skill/sfx_hudun_huo_buff_01_prf"
  },
  [107441] = {
    id = 107441,
    EP = 3,
    Effect = "Skill/sfx_hudun_seng_buff_05_prf"
  },
  [107480] = {
    id = 107480,
    EP = 3,
    Effect = "Skill/sfx_sgz_buff_01_prf"
  },
  [115000] = {
    id = 115000,
    EP = 1,
    Effect = "Skill/Sacrifice_buff,none"
  },
  [115060] = {
    id = 115060,
    EP = 3,
    Effect = "Skill/ResistantSouls_buff,none"
  },
  [115070] = {
    id = 115070,
    EP = 0,
    Effect = "Skill/ShieldReflect_buff,none"
  },
  [115080] = {
    id = 115080,
    EP = 0,
    Effect = "Skill/DefendingAura_buff,none"
  },
  [115090] = {
    id = 115090,
    EP = 3,
    Effect = "Skill/MartyrsReckoning_buff,none"
  },
  [115091] = {
    id = 115091,
    EP = 3,
    Effect = "Skill/sfx_MartyrsReckoning_buff_prf,none"
  },
  [115150] = {
    id = 115150,
    EP = 0,
    Effect = "Skill/MartyrsDefense_buff2,none"
  },
  [115151] = {
    id = 115151,
    EP = 3,
    Effect = "Skill/MartyrsDefense_buff,none"
  },
  [116010] = {
    id = 116010,
    EP = 2,
    Effect = "Skill/HighlyToxicWeapon_buff,none"
  },
  [116013] = {
    id = 116013,
    EP = 3,
    Effect = "Skill/HighlyToxicWeapon_buff2,none"
  },
  [116053] = {
    id = 116053,
    EP = 1,
    Effect = "Skill/AggravateWound_buff,none"
  },
  [116070] = {
    id = 116070,
    EP = 2,
    Effect = "Skill/BlastStep_buff,none"
  },
  [116090] = {
    id = 116090,
    EP = 3,
    Effect = "Skill/WeaponBlock_buff,none"
  },
  [116202] = {
    id = 116202,
    EP = 3,
    Effect = "Skill/CrazyFlame_buff2,none"
  },
  [116210] = {
    id = 116210,
    EP = 3,
    Effect = "Skill/ThornTrap_buff,none"
  },
  [116220] = {
    id = 116220,
    EP = 1,
    Effect = "Skill/LifeFusion_buff,none"
  },
  [116240] = {
    id = 116240,
    EP = 1,
    Effect = "Skill/OutbreakOfTrolley_buff,none"
  },
  [116250] = {
    id = 116250,
    EP = 1,
    Effect = "Skill/MandalaHowl_buff2,none"
  },
  [116260] = {
    id = 116260,
    EP = 3,
    Effect = "Skill/Lifelink_buff1,none"
  },
  [116311] = {
    id = 116311,
    EP = 0,
    Effect = "Skill/CrazyNight_buff,none"
  },
  [116320] = {
    id = 116320,
    EP = 0,
    Effect = "Skill/SliverDash_buff,none"
  },
  [116330] = {
    id = 116330,
    EP = 0,
    Effect = "Skill/BreakBone_buff,none"
  },
  [116410] = {
    id = 116410,
    EP = 3,
    Effect = "Skill/FatalInfection_buff,none"
  },
  [116411] = {
    id = 116411,
    EP = 3,
    Effect = "Skill/sfx_FatalInfection_buff_prf,none"
  },
  [116430] = {
    id = 116430,
    EP = 2,
    Effect = "Skill/ThreateningIntimidation_buff,none"
  },
  [116440] = {
    id = 116440,
    EP = 3,
    Effect_start = "Skill/MagicTrap_hit,none"
  },
  [116451] = {
    id = 116451,
    EP = 3,
    Effect = "Skill/ChaosPanic_buff2,none"
  },
  [116460] = {
    id = 116460,
    EP = 3,
    Effect_start = "Skill/BloodthirstyDesire_hit,none"
  },
  [116470] = {
    id = 116470,
    EP = 1,
    Effect = "Skill/DeathMark_buff,none"
  },
  [116481] = {
    id = 116481,
    EP = 3,
    Effect = "Skill/BlackHoleTrap_buff2,none"
  },
  [116482] = {
    id = 116482,
    EP = 3,
    Effect = "Skill/12_BlackHoleTrap_buff2,none"
  },
  [116600] = {
    id = 116600,
    EP = 3,
    Effect = "Skill/EarthDrive_buff,none"
  },
  [116621] = {
    id = 116621,
    EP = 3,
    Effect = "Skill/GunArray_BloodCross_buff,none"
  },
  [116623] = {
    id = 116623,
    EP = 1,
    Effect_start = "Skill/HeavySplit_hit,none",
    Effect_hit = "Skill/HeavySplit_hit,none"
  },
  [116640] = {
    id = 116640,
    EP = 2,
    Effect_start = "Skill/Fearless_buff,none"
  },
  [116650] = {
    id = 116650,
    EP = 3,
    Effect_start = "Skill/Saint_buff,none"
  },
  [116660] = {
    id = 116660,
    EP = 0,
    Effect_start = "Skill/Devout_buff,none"
  },
  [116670] = {
    id = 116670,
    EP = 3,
    Effect = "Skill/SprirtOfHolySpirit_buff,none"
  },
  [116690] = {
    id = 116690,
    EP = 0,
    Effect_start = "Skill/CommandCharge_buff,none"
  },
  [116720] = {
    id = 116720,
    EP = 0,
    Effect = "Skill/KinsProtect_buff,none"
  },
  [116810] = {
    id = 116810,
    EP = 2,
    Effect = "Skill/WhitePrison_buff,none"
  },
  [116811] = {
    id = 116811,
    EP = 2,
    Effect = "Skill/sfx_WhitePrison_buff_prf,none"
  },
  [116820] = {
    id = 116820,
    EP = 3,
    Effect = "Skill/Pogonip_buff2,none"
  },
  [116830] = {
    id = 116830,
    GroupID = 1,
    EffectGroup = "Common/Around,none",
    EffectGroup_around = "Skill/ELEBallFire,none",
    EP = 3
  },
  [116831] = {
    id = 116831,
    GroupID = 1,
    EffectGroup = "Common/Around,none",
    EffectGroup_around = "Skill/ELEBallWater,none",
    EP = 3
  },
  [116832] = {
    id = 116832,
    GroupID = 1,
    EffectGroup = "Common/Around,none",
    EffectGroup_around = "Skill/ELEBallWind,none",
    EP = 3
  },
  [116833] = {
    id = 116833,
    GroupID = 1,
    EffectGroup = "Common/Around,none",
    EffectGroup_around = "Skill/ELEBallLand,none",
    EP = 3
  },
  [116834] = {
    id = 116834,
    GroupID = 1,
    EffectGroup = "Common/Around,none",
    EffectGroup_around = "Skill/sfx_fw_ELEBall_prf,none",
    EP = 3
  },
  [116860] = {
    id = 116860,
    EP = 2,
    Effect = "Skill/MagicCatch_buff,none"
  },
  [116890] = {
    id = 116890,
    EP = 0,
    Effect = "Skill/Monkcat_skill_hitbuff,none"
  },
  [117050] = {
    id = 117050,
    EP = 3,
    Effect = "Skill/Acupoint-Silent_buff,none"
  },
  [117060] = {id = 117060},
  [117070] = {
    id = 117070,
    EP = 1,
    Effect = "Skill/DeathAwakening_buff,none"
  },
  [117080] = {
    id = 117080,
    EP = 0,
    Effect_start = "Skill/Outstanding_buff,none"
  },
  [117091] = {
    id = 117091,
    EP = 1,
    Effect = "Skill/HowlsOfLion_buff,none"
  },
  [117101] = {
    id = 117101,
    EP = 3,
    Effect = "Skill/Mantra_buff,none"
  },
  [117110] = {
    id = 117110,
    EP = 2,
    Effect = "Skill/DragonPrance_buff_blue,none"
  },
  [117111] = {
    id = 117111,
    EP = 2,
    Effect = "Skill/12_DragonPrance_buff_blue,none"
  },
  [117210] = {
    id = 117210,
    EP = 1,
    Effect = "Skill/Veto_buff,none"
  },
  [117230] = {
    id = 117230,
    EP = 3,
    Effect = "Skill/Pentecost_buff,none"
  },
  [117231] = {
    id = 117231,
    EP = 2,
    Effect_start = "Skill/HomunculusResurrection,none"
  },
  [117240] = {
    id = 117240,
    EP = 3,
    Effect = "Skill/Detoxification_buff,none"
  },
  [117260] = {
    id = 117260,
    EP = 3,
    Effect_start = "Skill/Sacrament_buff,none"
  },
  [117270] = {
    id = 117270,
    EP = 3,
    Effect = "Skill/Pray_buff,none"
  },
  [117280] = {
    id = 117280,
    EP = 3,
    Effect = "Skill/Hymn_buff,none"
  },
  [117410] = {
    id = 117410,
    EP = 2,
    Effect = "Skill/KeepOnWait_buff,none"
  },
  [117450] = {
    id = 117450,
    EP = 1,
    Effect = "Skill/PreyTrack_buff,none"
  },
  [117620] = {
    id = 117620,
    EP = 1,
    Effect = "Skill/DragonRoar_buff,none"
  },
  [117630] = {
    id = 117630,
    EP = 5,
    Effect = "Skill/EdgeOfEnchantment_buff,none"
  },
  [117640] = {
    id = 117640,
    EP = 2,
    Effect = "Skill/ThrowHelve_buff,none"
  },
  [117860] = {
    id = 117860,
    EP = 2,
    Effect = "Skill/Suspension_buff,none"
  },
  [117880] = {
    id = 117880,
    EP = 0,
    Effect = "Skill/MagneticField_buff1,none"
  },
  [117881] = {
    id = 117881,
    EP = 0,
    Effect = "Skill/MagneticField_buff2,none"
  },
  [117890] = {
    id = 117890,
    EP = 2,
    Effect = "Skill/MediumParticleBarrier_buff1,none"
  },
  [117891] = {
    id = 117891,
    EP = 2,
    Effect = "Skill/MediumParticleBarrier_buff2,none"
  },
  [117940] = {
    id = 117940,
    EP = 0,
    Effect = "Skill/OpticsField_buff,none"
  },
  [118100] = {
    id = 118100,
    EP = 3,
    Effect = "Skill/SpellBreaker_buff,none"
  },
  [118170] = {
    id = 118170,
    EP = 0,
    Effect = "Skill/FogWall_buff,none"
  },
  [118190] = {
    id = 118190,
    EP = 0,
    Effect = "Skill/FlameWeb_buff,none"
  },
  [118210] = {
    id = 118210,
    EP = 0,
    Effect = "Skill/HPSwitch_buff,none"
  },
  [118241] = {
    id = 118241,
    EP = 1,
    Effect = "Skill/SoulBurn_buff,none"
  },
  [118250] = {
    id = 118250,
    EP = 3,
    Effect = "Skill/MagicRod_buff,none"
  },
  [118260] = {
    id = 118260,
    EP = 3,
    Effect_start = "Skill/Dispell_hit,none"
  },
  [118262] = {
    id = 118262,
    EP = 3,
    Effect = "Skill/Dispersion_buff,none"
  },
  [118280] = {
    id = 118280,
    EP = 3,
    Effect = "Skill/WarmWind_attack,none"
  },
  [118284] = {
    id = 118284,
    EP = 0,
    Effect = "Skill/Eff_WarmWind_buff02,none"
  },
  [118290] = {
    id = 118290,
    EP = 0,
    Effect = "Skill/DarkHole_buff,none"
  },
  [118300] = {
    id = 118300,
    EP = 1,
    Effect = "Skill/GroupHypnotism_buff,none"
  },
  [118310] = {
    id = 118310,
    EP = 0,
    Effect = "Skill/Diamond_buff,none"
  },
  [118340] = {
    id = 118340,
    EP = 5,
    Effect = "Skill/MagicRiot_buff,none"
  },
  [118370] = {
    id = 118370,
    EP = 7,
    Effect = "Skill/FireCloak_buff,none"
  },
  [118380] = {
    id = 118380,
    EP = 3,
    Effect = "Skill/WaterProtect_buff,none"
  },
  [118390] = {
    id = 118390,
    EP = 3,
    Effect = "Skill/HardSkin_buff,none"
  },
  [118400] = {
    id = 118400,
    EP = 4,
    Effect = "Skill/WindWard_buff,none"
  },
  [118460] = {
    id = 118460,
    EP = 0,
    Effect = "Skill/MentalShock_buff,none"
  },
  [118652] = {
    id = 118652,
    EP = 2,
    Effect = "Skill/SlowChain_buff,none"
  },
  [118660] = {
    id = 118660,
    EP = 0,
    Effect = "Skill/Humming_buff1,none"
  },
  [118661] = {
    id = 118661,
    EP = 0,
    Effect = "Skill/Humming_buff2,none"
  },
  [118670] = {
    id = 118670,
    EP = 0,
    Effect = "Skill/ServiceYou_buff1,none"
  },
  [118671] = {
    id = 118671,
    EP = 0,
    Effect = "Skill/ServiceYou_buff2,none"
  },
  [118680] = {
    id = 118680,
    EP = 0,
    Effect = "Skill/RememberMe_buff1,none"
  },
  [118681] = {
    id = 118681,
    EP = 0,
    Effect = "Skill/RememberMe_buff2,none"
  },
  [118690] = {
    id = 118690,
    EP = 0,
    Effect = "Skill/Godkess_buff1,none"
  },
  [118691] = {
    id = 118691,
    EP = 0,
    Effect = "Skill/Godkess_buff2,none"
  },
  [118700] = {
    id = 118700,
    EP = 0,
    Effect = "Skill/LoveSong_buff1,none"
  },
  [118701] = {
    id = 118701,
    EP = 0,
    Effect = "Skill/LoveSong_buff2,none"
  },
  [118710] = {
    id = 118710,
    EP = 0,
    Effect = "Skill/NatureLoop_buff1,none"
  },
  [118711] = {
    id = 118711,
    EP = 0,
    Effect = "Skill/NatureLoop_buff2,none"
  },
  [118721] = {
    id = 118721,
    EP = 0,
    Effect = "Skill/UglyDance_buff2,none"
  },
  [118722] = {
    id = 118722,
    EP = 0,
    Effect = "Skill/UglyDance_buff1,none"
  },
  [118730] = {
    id = 118730,
    EP = 3,
    Effect = "Skill/EverChaos_buff2,none"
  },
  [118750] = {
    id = 118750,
    EP = 0,
    Effect = "Skill/RichKing_atk,none"
  },
  [118751] = {
    id = 118751,
    EP = 0,
    Effect = "Skill/sfx_RichKing_buff_prf,none"
  },
  [118760] = {
    id = 118760,
    EP = 0,
    Effect = "Skill/DrumsOfWar_buff2,none"
  },
  [118780] = {
    id = 118780,
    EP = 0,
    Effect = "Skill/Siegfried_buff2,none"
  },
  [118790] = {
    id = 118790,
    EP = 4,
    Effect = "Skill/Rinbelungen_buff2,none"
  },
  [118800] = {
    id = 118800,
    EP = 0,
    Effect = "Skill/ReradDew_buff2,none"
  },
  [118810] = {
    id = 118810,
    EP = 4,
    Effect = "Skill/AncientSun_buff2,none"
  },
  [118820] = {
    id = 118820,
    EP = 0,
    Effect = "Skill/CatalystWard_buff2,none"
  },
  [118830] = {
    id = 118830,
    EP = 0,
    Effect = "Skill/WolfDancing_buff2,none"
  },
  [118840] = {
    id = 118840,
    EP = 1,
    Effect = "Skill/InfiniteSing_buff2,none"
  },
  [118891] = {
    id = 118891,
    EP = 0,
    Effect = "Skill/ColdJokes_hit,none"
  },
  [118901] = {
    id = 118901,
    EP = 3,
    Effect_start = "Skill/TarotOfFate5_hit,none",
    Effect_hit = "Skill/TarotOfFate5_hit,none"
  },
  [118902] = {
    id = 118902,
    EP = 3,
    Effect_start = "Skill/TarotOfFate3_hit,none",
    Effect_hit = "Skill/TarotOfFate3_hit,none"
  },
  [118903] = {
    id = 118903,
    EP = 3,
    Effect_start = "Skill/TarotOfFate6_hit,none",
    Effect_hit = "Skill/TarotOfFate6_hit,none"
  },
  [118904] = {
    id = 118904,
    EP = 3,
    Effect_start = "Skill/TarotOfFate4_hit,none",
    Effect_hit = "Skill/TarotOfFate4_hit,none"
  },
  [118905] = {
    id = 118905,
    EP = 3,
    Effect_start = "Skill/TarotOfFate1_hit,none",
    Effect_hit = "Skill/TarotOfFate1_hit,none"
  },
  [118906] = {
    id = 118906,
    EP = 3,
    Effect_start = "Skill/TarotOfFate2_hit,none",
    Effect_hit = "Skill/TarotOfFate2_hit,none"
  },
  [118909] = {
    id = 118909,
    EP = 1,
    Effect_start = "Skill/sfx_wn_myzl_buff_prf,none",
    Effect_hit = "Skill/sfx_wn_myzl_buff_prf,none"
  },
  [118913] = {
    id = 118913,
    EP = 1,
    Effect = "Skill/RestLullaby_buff2,none"
  },
  [118914] = {
    id = 118914,
    EP = 0,
    Effect = "Skill/RestLullaby_buff1,none"
  },
  [119030] = {
    id = 119030,
    EP = 0,
    Effect = "Skill/AssassinDusk_buff1,none"
  },
  [119031] = {
    id = 119031,
    EP = 4,
    Effect = "Skill/AssassinDusk_buff2,none"
  },
  [119040] = {
    id = 119040,
    EP = 0,
    Effect = "Skill/Whistle_buff1,none"
  },
  [119041] = {
    id = 119041,
    EP = 0,
    Effect = "Skill/Whistle_buff2,none"
  },
  [119050] = {
    id = 119050,
    EP = 0,
    Effect = "Skill/IdunApple_buff1,none"
  },
  [119051] = {
    id = 119051,
    EP = 0,
    Effect = "Skill/IdunApple_buff2,none"
  },
  [119060] = {
    id = 119060,
    EP = 0,
    Effect = "Skill/PoemOfBragi_buff1,none"
  },
  [119061] = {
    id = 119061,
    EP = 0,
    Effect = "Skill/PoemOfBragi_buff2,none"
  },
  [119070] = {
    id = 119070,
    EP = 0,
    Effect = "Skill/RaidSong_buff1,none"
  },
  [119071] = {
    id = 119071,
    EP = 4,
    Effect = "Skill/RaidSong_buff2,none"
  },
  [119080] = {
    id = 119080,
    EP = 0,
    Effect = "Skill/Noise_buff1,none"
  },
  [119081] = {
    id = 119081,
    EP = 1,
    Effect = "Skill/Noise_buff2,none"
  },
  [120000] = {
    id = 120000,
    EP = 3,
    Effect_end = "Skill/RemoveHidden,none"
  },
  [120020] = {
    id = 120020,
    EP = 0,
    Effect = "Skill/Frozen,none",
    Effect_end = "Skill/FrozenBroken,none",
    SE_start = "Skill/StoneCurse",
    SE_end = "Common/Frozen_explosion"
  },
  [120030] = {
    id = 120030,
    EP = 3,
    Effect = "Skill/poisoning,none",
    SE_start = "Common/poison"
  },
  [120031] = {
    id = 120031,
    EP = 2,
    Effect = "Skill/HallucinationWalk,none"
  },
  [120032] = {
    id = 120032,
    EP = 3,
    Effect = "Skill/Spines_buff2,none"
  },
  [120040] = {
    id = 120040,
    EP = 1,
    Effect = "Skill/Dizzy,none"
  },
  [120150] = {
    id = 120150,
    EP = 1,
    Effect = "Skill/sfx_physics_refle_buff_prf"
  },
  [120160] = {
    id = 120160,
    EP = 2,
    Effect = "Skill/RageSpear_buff,none"
  },
  [120220] = {
    id = 120220,
    EP = 1,
    Effect_start = "Skill/HeadSmoke",
    Effect_hit = "Skill/HeadSmoke"
  },
  [120221] = {
    id = 120221,
    EP = 1,
    Effect = "Common/59Fear,none"
  },
  [120260] = {
    id = 120260,
    EP = 2,
    Effect_start = "Common/117ChocolateGet1,none",
    Effect = "Common/120ChocolateSmell_1,none"
  },
  [120270] = {
    id = 120270,
    EP = 2,
    Effect_start = "Common/117ChocolateGet1,none",
    Effect = "Common/121ChocolateSmell_2,none"
  },
  [120290] = {
    id = 120290,
    EP = 3,
    Effect = "Skill/Abyssknight_buff"
  },
  [121030] = {
    id = 121030,
    EP = 0,
    Effect = "Skill/FoolBlessing_buff,none"
  },
  [121031] = {
    id = 121031,
    EP = 0,
    Effect = "Skill/12_FoolBlessing_buff,none"
  },
  [121060] = {
    id = 121060,
    EP = 2,
    Effect = "Skill/Galaxymusic_buff,none"
  },
  [121070] = {
    id = 121070,
    EP = 2,
    Effect = "Skill/Dreamusic_buff,none"
  },
  [121120] = {
    id = 121120,
    EP = 3,
    Effect = "Skill/Gear_wind_buff,none"
  },
  [121121] = {
    id = 121121,
    EP = 3,
    Effect = "Skill/Gear_land_buff,none"
  },
  [121122] = {
    id = 121122,
    EP = 3,
    Effect = "Skill/Gear_water_buff,none"
  },
  [121123] = {
    id = 121123,
    EP = 3,
    Effect = "Skill/Gear_fire_buff,none"
  },
  [122000] = {
    id = 122000,
    EP = 0,
    Effect = "Common/wetbody_buff,none"
  },
  [123010] = {
    id = 123010,
    EP = 3,
    Effect = "Skill/Eff_Doram_fushen_light,none"
  },
  [123020] = {
    id = 123020,
    EP = 0,
    Effect = "Skill/Eff_Doram_mozhu,none"
  },
  [123040] = {
    id = 123040,
    EP = 1,
    Effect_start = "Skill/Eff_Doram_shrimp,none",
    Effect_hit = "Skill/Eff_Doram_shrimp,none"
  },
  [123050] = {
    id = 123050,
    EP = 2,
    Effect_start = "Skill/Eff_Doram_ShrimpGroup,none",
    Effect_hit = "Skill/Eff_Doram_ShrimpGroup,none"
  },
  [123060] = {
    id = 123060,
    EP = 2,
    Effect_start = "Skill/Eff_Doram_Tuna,none",
    Effect_hit = "Skill/Eff_Doram_Tuna,none"
  },
  [123080] = {
    id = 123080,
    EP = 1,
    Effect = "Skill/Eff_Doram_mouse_buff,none"
  },
  [123090] = {
    id = 123090,
    EP = 2,
    Effect = "Skill/Eff_Doram_Twining,none"
  },
  [123100] = {
    id = 123100,
    EP = 1,
    Effect_start = "Skill/Eff_Doram_beetle,none",
    Effect_hit = "Skill/Eff_Doram_beetle,none"
  },
  [123130] = {
    id = 123130,
    EP = 2,
    Effect = "Skill/Eff_Doram_Tuna02,none"
  },
  [123131] = {
    id = 123131,
    EP = 2,
    Effect = "Skill/Eff_Doram_Tuna02_12pvp,none"
  },
  [123150] = {
    id = 123150,
    EP = 1,
    Effect_start = "Skill/Eff_Doram_NightVision,none",
    Effect_hit = "Skill/Eff_Doram_NightVision,none"
  },
  [123181] = {
    id = 123181,
    EP = 1,
    Effect_start = "Skill/Eff_Doram_lick,none",
    Effect_hit = "Skill/Eff_Doram_lick,none"
  },
  [123200] = {
    id = 123200,
    EP = 3,
    Effect = "Skill/Eff_Doram_DriedFish_buff,none"
  },
  [123240] = {
    id = 123240,
    EP = 2,
    Effect = "Skill/Eff_Doram_powder_buffe,none"
  },
  [123250] = {
    id = 123250,
    EP = 3,
    Effect = "Skill/Eff_Doram_MeowGrass_buffe,none"
  },
  [123260] = {
    id = 123260,
    EP = 1,
    Effect_start = "Skill/Eff_Doram_Fierce,none",
    Effect_hit = "Skill/Eff_Doram_Fierce,none"
  },
  [123261] = {
    id = 123261,
    EP = 1,
    Effect_start = "Skill/sfx_Doram_Fierce_buff_prf,none",
    Effect_hit = "Skill/sfx_Doram_Fierce_buff_prf,none"
  },
  [123280] = {
    id = 123280,
    EP = 1,
    Effect_start = "Skill/Eff_Doram_CatAtk,none",
    Effect_hit = "Skill/Eff_Doram_CatAtk,none"
  },
  [123310] = {
    id = 123310,
    EP = 2,
    Effect_start = "Skill/Eff_Doram_Hunting,none",
    Effect_hit = "Skill/Eff_Doram_Hunting,none"
  },
  [123331] = {
    id = 123331,
    EP = 2,
    Effect = "Skill/sfx_cxm_alienship_catmeteor_prf,nbne"
  },
  [123340] = {
    id = 123340,
    EP = 2,
    Effect_start = "Skill/BloodThirsty_atk,none"
  },
  [124004] = {
    id = 124004,
    EP = 3,
    Effect = "Skill/Eff_LifeFusion_buff,none"
  },
  [124005] = {
    id = 124005,
    EP = 0,
    Effect = "Skill/Eff_ShelterValhala_buff,none",
    Follow = 1
  },
  [124006] = {
    id = 124006,
    EP = 0,
    Effect = "Skill/Eff_HesperusLit_buff",
    Follow = 1
  },
  [124007] = {
    id = 124007,
    EP = 0,
    Effect = "Skill/Eff_HolyLight_buff",
    Follow = 1
  },
  [124160] = {
    id = 124160,
    EP = 3,
    Effect = "Skill/Eff_Guardian_buff,none"
  },
  [124161] = {
    id = 124161,
    EP = 3,
    Effect = "Skill/Eff_Guardian_buff02,none"
  },
  [124170] = {
    id = 124170,
    EP = 2,
    Effect = "Skill/Eff_DevilHorn_buff,none"
  },
  [124171] = {
    id = 124171,
    Effect = "Skill/Eff_DevilHorn_buff02,none",
    CP = 4
  },
  [124173] = {
    id = 124173,
    EP = 2,
    Effect = "Skill/Eff_DevilHorn_buff_12pvp,none"
  },
  [124174] = {
    id = 124174,
    Effect = "Skill/Eff_DevilHorn_buff02_12pvp,none",
    CP = 4
  },
  [124180] = {
    id = 124180,
    EP = 1,
    Effect = "Skill/Eff_DeathBind_buff,none"
  },
  [124181] = {
    id = 124181,
    EP = 1,
    Effect = "Skill/sfx_DeathBind_buff_prf,none"
  },
  [124200] = {
    id = 124200,
    EP = 3,
    Effect_start = "Skill/Eff_Asphyxia_start,none",
    Effect = "Skill/Eff_Asphyxia_buff,none"
  },
  [125100] = {
    id = 125100,
    EP = 3,
    Effect = "Skill/Eff_Electrification_hit,none"
  },
  [125120] = {
    id = 125120,
    EP = 3,
    Effect = "Skill/Eff_ElementBalance_buff,none"
  },
  [125150] = {
    id = 125150,
    EP = 2,
    Effect = "Skill/Eff_WaterAsphyxia_buff,none"
  },
  [125160] = {
    id = 125160,
    EP = 3,
    Effect_start = "Skill/Eff_Infinite_atk,none",
    Effect_hit = "Skill/Eff_Infinite_atk,none"
  },
  [125170] = {
    id = 125170,
    EP = 1,
    Effect = "Skill/Eff_ProhibitionApplication_buff,none"
  },
  [125190] = {
    id = 125190,
    EP = 3,
    Effect = "Skill/Eff_FireShield_buff,none"
  },
  [126130] = {
    id = 126130,
    EP = 3,
    Effect_start = "Skill/Eff_BackTime_buff,none",
    Effect_hit = "Skill/Eff_BackTime_buff,none"
  },
  [126160] = {
    id = 126160,
    EP = 1,
    Effect = "Skill/Eff_SpaceQuiet_buff,none"
  },
  [126161] = {
    id = 126161,
    EP = 0,
    Effect = "Skill/Eff_SpaceQuiet_buff02,none",
    SE_start = "Skill/skill_weapon_soundneedle_attack"
  },
  [126170] = {
    id = 126170,
    EP = 1,
    Effect = "Skill/Eff_TwistedBomb_buff01,none"
  },
  [126171] = {
    id = 126171,
    EP = 3,
    Effect_start = "Skill/Eff_TwistedBomb_buff02,none",
    Effect_hit = "Skill/Eff_TwistedBomb_buff02,none",
    SE_hit = "Skill/Chronomancer_niuquzhadan"
  },
  [127100] = {
    id = 127100,
    EP = 3,
    Effect = "Skill/Monk_cover_buff,none"
  },
  [127110] = {
    id = 127110,
    EP = 1,
    Effect = "Skill/Monk_Unparalleled_buff,none"
  },
  [127130] = {
    id = 127130,
    EP = 1,
    Effect = "Skill/Eff_UnableAttack_buff,none"
  },
  [127180] = {
    id = 127180,
    Logic = Table_BuffState_bk_t.Logic[2],
    EP = 3,
    Effect = "Common/Around,none",
    Effect_around = "Skill/Monk_DragonBall,none"
  },
  [127190] = {
    id = 127190,
    EP = 3,
    Effect = "Skill/Monk_MeansRetreat_buff,none"
  },
  [127210] = {
    id = 127210,
    EP = 0,
    Effect_hit = "Skill/Monk_Inherit_hit,none"
  },
  [127220] = {
    id = 127220,
    EP = 1,
    Effect = "Skill/Monk_Desperate_buff,none"
  },
  [127242] = {
    id = 127242,
    EP = 3,
    Effect = "Skill/Rune_WindArmor_buf,none"
  },
  [128010] = {
    id = 128010,
    EP = 2,
    Effect = "Skill/Lunar_MagicPuppet_buff,none"
  },
  [128011] = {
    id = 128011,
    EP = 2,
    Effect = "Skill/Sun_MagicPuppet,none"
  },
  [128050] = {
    id = 128050,
    EP = 2,
    Effect = "Skill/Eff_StriveGlory_buff,none"
  },
  [128060] = {
    id = 128060,
    EP = 0,
    Effect = "Skill/Sun_LamentYang_buff01,none"
  },
  [128061] = {
    id = 128061,
    EP = 3,
    Effect = "Skill/Sun_LamentYang_buff02,none"
  },
  [128070] = {
    id = 128070,
    EP = 0,
    Effect = "Skill/Lunar_BloodMoonDance_buff1,none"
  },
  [128071] = {
    id = 128071,
    EP = 3,
    Effect = "Skill/Lunar_BloodMoonDance_buff2,none"
  },
  [128080] = {
    id = 128080,
    EP = 3,
    Effect = "Skill/Sun_SongChaos_hit,none"
  },
  [128081] = {
    id = 128081,
    EP = 3,
    Effect = "Skill/Lunar_DanceChaos_hit,none"
  },
  [128090] = {
    id = 128090,
    EP = 0,
    Effect = "Skill/Sun_SongSun_buff01,none"
  },
  [128091] = {
    id = 128091,
    EP = 3,
    Effect = "Skill/Sun_SongSun_buff02,none"
  },
  [128100] = {
    id = 128100,
    EP = 0,
    Effect = "Skill/Lunar_DarkDance_buff01,none"
  },
  [128101] = {
    id = 128101,
    EP = 3,
    Effect = "Skill/Lunar_DarkDance_buff02,none"
  },
  [128120] = {
    id = 128120,
    EP = 1,
    Effect = "Skill/Eff_SunMoonEnd_buff,none"
  },
  [128121] = {
    id = 128121,
    EP = 1,
    Effect = "Skill/sfx_SunMoonEnd_prf,none"
  },
  [128122] = {
    id = 128122,
    EP = 1,
    Effect = "Skill/sfx_SunMoonEnd_01_prf,none"
  },
  [128123] = {
    id = 128123,
    EP = 1,
    Effect = "Skill/sfx_SunMoonEnd_02_prf,none"
  },
  [128124] = {
    id = 128124,
    EP = 1,
    Effect = "Skill/sfx_SunMoonEnd_03_prf,none"
  },
  [128125] = {
    id = 128125,
    EP = 1,
    Effect = "Skill/sfx_SunMoonEnd_04_prf,none"
  },
  [128131] = {
    id = 128131,
    EP = 2,
    Effect = "Skill/Eff_SunMoonRotation_buff01,none"
  },
  [128132] = {
    id = 128132,
    EP = 2,
    Effect = "Skill/Eff_SunMoonRotation_buff02,none"
  },
  [128150] = {
    id = 128150,
    EP = 1,
    Effect = "Skill/Lunar_FreyaDesire_buff,none"
  },
  [129000] = {
    id = 129000,
    EP = 3,
    Effect = "Skill/Eff_blessing_buff,none"
  },
  [129030] = {
    id = 129030,
    EP = 1,
    Effect_start = "Skill/Eff_OdeHope_buff,none",
    Effect_hit = "Skill/Eff_OdeHope_buff,none"
  },
  [129040] = {
    id = 129040,
    EP = 5,
    Effect = "Skill/Eff_BlessedHammer_buff,none"
  },
  [129050] = {
    id = 129050,
    EP = 3,
    Effect = "Skill/Eff_Baptism_buff,none"
  },
  [129060] = {
    id = 129060,
    EP = 7,
    Effect = "Skill/Eff_HoddleWing_buff01,none"
  },
  [129061] = {
    id = 129061,
    EP = 2,
    Effect = "Skill/Eff_HoddleWing_buff02,none"
  },
  [129070] = {
    id = 129070,
    EP = 11,
    Effect = "Skill/Eff_CrownBader_buff01,none"
  },
  [129090] = {
    id = 129090,
    EP = 0,
    Effect = "Skill/Eff_WinterFenbuhr_buff,none",
    Follow = 1
  },
  [129091] = {
    id = 129091,
    EP = 3,
    Effect_start = "Skill/Eff_WinterFenbuhr_hit,none",
    Effect_hit = "Skill/Eff_WinterFenbuhr_hit,none"
  },
  [129100] = {
    id = 129100,
    EP = 1,
    Effect = "Skill/Eff_TherapeuticBarrier_buff,none"
  },
  [129110] = {
    id = 129110,
    EP = 1,
    Effect_start = "Skill/Eff_Painliberation_buff,none",
    Effect_hit = "Skill/Eff_Painliberation_buff,none"
  },
  [129120] = {
    id = 129120,
    EP = 1,
    Effect = "Skill/Eff_Contaminated_buff,none"
  },
  [129130] = {
    id = 129130,
    EP = 1,
    Effect = "Skill/Eff_ShadowSlaughter_buff,none"
  },
  [129500] = {
    id = 129500,
    EP = 2,
    Effect = "Skill/Eff_GeneDestroy_buff,none"
  },
  [129520] = {
    id = 129520,
    EP = 3,
    Effect = "Skill/Eff_VineArmor_buff,none"
  },
  [129540] = {
    id = 129540,
    Effect = "Skill/Eff_LifeFusion_buff,none",
    CP = 4
  },
  [129541] = {
    id = 129541,
    Effect = "Skill/Eff_LifeFusion_buff02,none",
    CP = 4
  },
  [129542] = {
    id = 129542,
    Effect = "Skill/Eff_LifeFusion_buff03,none",
    CP = 4
  },
  [129543] = {
    id = 129543,
    Effect = "Skill/Eff_LifeFusion_buff04,none",
    CP = 4
  },
  [129544] = {
    id = 129544,
    Effect = "Skill/Eff_TabuSynthesis_buff,none",
    CP = 4
  },
  [129545] = {
    id = 129545,
    Effect = "Skill/Eff_TabuSynthesis_buff02,none",
    CP = 5
  },
  [129546] = {
    id = 129546,
    Effect = "Skill/Eff_TabuSynthesis_buff03,none",
    CP = 7
  },
  [129549] = {
    id = 129549,
    EP = 2,
    Effect_start = "Skill/Eff_LifeFusion_End,none"
  },
  [129560] = {
    id = 129560,
    EP = 3,
    Effect = "Skill/Eff_VampireGrass_buff,none"
  },
  [130000] = {
    id = 130000,
    EP = 2,
    Effect = "Skill/Eff_FreedomShield_buff,none"
  },
  [130010] = {
    id = 130010,
    EP = 1,
    Effect = "Skill/Eff_StrengthShield_buff,none"
  },
  [130020] = {
    id = 130020,
    EP = 2,
    Effect = "Skill/Eff_HolyShield_buff,none"
  },
  [130050] = {
    id = 130050,
    EP = 0,
    Effect = "Skill/Eff_CounterattackAura_buff,none"
  },
  [130090] = {
    id = 130090,
    EP = 0,
    Effect = "Skill/Eff_ShelterValhala_buff,none",
    Follow = 1
  },
  [130091] = {
    id = 130091,
    EP = 0,
    Effect = "Skill/Eff_ShelterValhala_buff_12pvp,none",
    Follow = 1
  },
  [130100] = {
    id = 130100,
    EP = 0,
    Effect = "Skill/Eff_HolyLight_buff",
    Follow = 1
  },
  [130503] = {
    id = 130503,
    EP = 3,
    Effect_start = "Skill/Eff_SoulHarvest_buff,none",
    Effect_hit = "Skill/Eff_SoulHarvest_buff,none"
  },
  [130510] = {
    id = 130510,
    EP = 2,
    Effect = "Skill/Eff_SoulWalking_buff,none"
  },
  [130540] = {
    id = 130540,
    EP = 2,
    Effect_start = "Skill/Eff_SpiritualSacrifice_buff,none",
    Effect_hit = "Skill/Eff_SpiritualSacrifice_buff,none"
  },
  [130545] = {
    id = 130545,
    EP = 0,
    Effect = "Skill/Eff_CorruptedSoul_atk02,none"
  },
  [130580] = {
    id = 130580,
    EP = 3,
    Effect = "Skill/Eff_SoulArmor_buff,none"
  },
  [131020] = {
    id = 131020,
    EP = 1,
    Effect = "Skill/Eff_StarsStars_buff,none"
  },
  [131030] = {
    id = 131030,
    EP = 2,
    Effect = "Skill/Eff_CryogenicCyclone_buff,none",
    Follow = 1
  },
  [131070] = {
    id = 131070,
    EP = 1,
    Effect = "Skill/Eff_MeteorFission_buff,none"
  },
  [131080] = {
    id = 131080,
    EP = 3,
    Effect = "Skill/Eff_InfiniteStars_buff,none"
  },
  [131090] = {
    id = 131090,
    EP = 3,
    Effect = "Skill/Eff_StarsBolts_buff,none"
  },
  [131100] = {
    id = 131100,
    EP = 3,
    Effect = "Skill/Eff_GuardianStars_buff,none"
  },
  [131101] = {
    id = 131101,
    EP = 2,
    Effect = "Skill/sfx_GuardianStars_buff_prf,none"
  },
  [131500] = {
    id = 131500,
    EP = 3,
    Effect_start = "Skill/Eff_DolanTricks_hit,none"
  },
  [131520] = {
    id = 131520,
    EP = 0,
    Effect_start = "Skill/Eff_ChangeCats_buff,none"
  },
  [131530] = {
    id = 131530,
    EP = 3,
    Effect_start = "Skill/Eff_HailingConcentric_buff,none"
  },
  [131580] = {
    id = 131580,
    EP = 1,
    Effect = "Skill/Eff_NaturalRage_buff,none"
  },
  [131610] = {
    id = 131610,
    EP = 2,
    Effect_start = "Skill/Eff_SharkBuddy_buff,none"
  },
  [131620] = {
    id = 131620,
    EP = 2,
    Effect_start = "Skill/Eff_PepperBombBlast_buff,none"
  },
  [131621] = {
    id = 131621,
    EP = 1,
    Effect = "Skill/Eff_PepperBomb_buff01,none"
  },
  [131622] = {
    id = 131622,
    EP = 1,
    Effect = "Skill/Eff_PepperBomb_buff02,none"
  },
  [131623] = {
    id = 131623,
    EP = 1,
    Effect = "Skill/Eff_PepperBomb_buff03,none"
  },
  [131624] = {
    id = 131624,
    EP = 2,
    Effect_start = "Skill/sfx_PepperBombBlast_buff_prf,none"
  },
  [131625] = {
    id = 131625,
    EP = 1,
    Effect = "Skill/sfx_PepperBomb_buff01_prf,none"
  },
  [131626] = {
    id = 131626,
    EP = 1,
    Effect = "Skill/sfx_PepperBomb_buff02_prf,none"
  },
  [131627] = {
    id = 131627,
    EP = 1,
    Effect = "Skill/sfx_PepperBomb_buff03_prf,none"
  },
  [131700] = {
    id = 131700,
    EP = 2,
    Effect = "Skill/Rune_Tornado_atk,none"
  },
  [132000] = {
    id = 132000,
    EP = 1,
    Effect = "Skill/Eff_RuneProhibit_buff,none"
  },
  [132010] = {
    id = 132010,
    EP = 3,
    Effect_start = "Skill/Eff_StateSteal_hit,none"
  },
  [132040] = {
    id = 132040,
    EP = 0,
    Effect = "Skill/Eff_NightFalls_atk,none",
    Follow = 1
  },
  [132041] = {
    id = 132041,
    EP = 0,
    Effect = "Skill/12_Eff_NightFalls_atk,none",
    Follow = 1
  },
  [132050] = {
    id = 132050,
    EP = 0,
    Effect_start = "Skill/Eff_SplitBlasting_atk,none"
  },
  [132070] = {
    id = 132070,
    EP = 2,
    Effect = "Skill/Eff_SDedication_buff,none"
  },
  [132310] = {
    id = 132310,
    EP = 2,
    Effect = "Skill/Mechanic_Artificial_buff,none"
  },
  [132370] = {
    id = 132370,
    EP = 1,
    Effect = "Skill/Mechanic_NegativeCharge_buff,none"
  },
  [132371] = {
    id = 132371,
    EP = 1,
    Effect = "Skill/Mechanic_PositiveCharge_buff,none"
  },
  [132390] = {
    id = 132390,
    EP = 2,
    Effect = "Skill/Mechanic_Overload,none"
  },
  [132602] = {
    id = 132602,
    EP = 0,
    Effect_start = "Skill/Mechanic_whiteNoise_atk,none",
    Effect_hit = "Skill/Mechanic_whiteNoise_atk,none"
  },
  [132702] = {
    id = 132702,
    EP = 3,
    Effect_start = "Skill/Eff_Ninja_GasChopping_buff,none"
  },
  [132790] = {
    id = 132790,
    EP = 3,
    Effect = "Skill/Eff_Ninja_wind_buff,none"
  },
  [132791] = {
    id = 132791,
    EP = 3,
    Effect = "Skill/Eff_Ninja_land_buff,none"
  },
  [132792] = {
    id = 132792,
    EP = 3,
    Effect = "Skill/Eff_Ninja_water_buff,none"
  },
  [132793] = {
    id = 132793,
    EP = 3,
    Effect = "Skill/Eff_Ninja_fire_buff,none"
  },
  [132820] = {
    id = 132820,
    EP = 1,
    Effect = "Skill/Eff_Ninja_huanhuo_buff,none"
  },
  [132850] = {
    id = 132850,
    EP = 3,
    Effect = "Skill/Eff_Ninja_nian_atk,none"
  },
  [132860] = {
    id = 132860,
    EP = 3,
    Effect = "Skill/Eff_Ninja_ye_buff,none"
  },
  [132870] = {
    id = 132870,
    EP = 1,
    Effect = "Skill/Eff_Ninja_Curse_buff,none"
  },
  [132900] = {
    id = 132900,
    EP = 3,
    Effect = "Skill/Eff_Ninja_change_buff,none"
  },
  [132920] = {
    id = 132920,
    EP = 1,
    Effect = "Skill/Eff_Ninja_empty_buff,none"
  },
  [133071] = {
    id = 133071,
    EP = 1,
    Effect = "Skill/Eff_Ninja_Dodge_buff,none"
  },
  [133085] = {
    id = 133085,
    EP = 2,
    Effect = "Skill/Eff_Ninja_Broken_atk,none"
  },
  [133113] = {
    id = 133113,
    EP = 2,
    Effect = "Skill/Eff_Ninja_fuwen01_buff,none"
  },
  [133130] = {
    id = 133130,
    EP = 2,
    Effect = "Skill/Eff_Ninja_Thunderbolt_buff,none",
    Follow = 1
  },
  [133131] = {
    id = 133131,
    EP = 2,
    Effect = "Skill/sfx_Ninja_Thunderbolt_buff_prf,none",
    Follow = 1
  },
  [133160] = {
    id = 133160,
    EP = 1,
    Effect = "Skill/Eff_Ninja_poxiao_buff,none"
  },
  [133260] = {
    id = 133260,
    EP = 3,
    Effect = "Skill/Eff_Ninja_huanxiang_buff,none"
  },
  [133290] = {
    id = 133290,
    EP = 3,
    Effect = "Skill/Eff_Ninja_fuwen02_buff,none"
  },
  [133352] = {
    id = 133352,
    EP = 0,
    Effect = "Skill/sfx_Eff_Ninja_Darts_buff_prf"
  },
  [133560] = {
    id = 133560,
    EP = 1,
    Effect = "Skill/gunman_mqws_buff,none"
  },
  [133570] = {
    id = 133570,
    EP = 3,
    Effect = "Skill/gunman_fdzj_buff02,none"
  },
  [133571] = {
    id = 133571,
    EP = 2,
    Effect_start = "Skill/gunman_fdzj_buff,none",
    Effect_hit = "Skill/gunman_fdzj_buff,none"
  },
  [133611] = {
    id = 133611,
    EP = 2,
    Effect_start = "Skill/gunman_smyb_buff_01,none",
    Effect_hit = "Skill/gunman_smyb_buff_01,none"
  },
  [133612] = {
    id = 133612,
    EP = 2,
    Effect_start = "Skill/gunman_smyb_buff_02,none",
    Effect_hit = "Skill/gunman_smyb_buff_02,none"
  },
  [133613] = {
    id = 133613,
    EP = 2,
    Effect_start = "Skill/gunman_smyb_buff_03,none",
    Effect_hit = "Skill/gunman_smyb_buff_03,none"
  },
  [133650] = {
    id = 133650,
    EP = 1,
    Effect = "Skill/gunman_xzly_buff,none"
  },
  [133660] = {
    id = 133660,
    EP = 2,
    Effect = "Skill/gunman_lsdz_buff,none"
  },
  [133700] = {
    id = 133700,
    EP = 3,
    Effect_start = "Skill/gunman_qj_rifle_buff,none",
    Effect_hit = "Skill/gunman_qj_rifle_buff,none"
  },
  [133740] = {
    id = 133740,
    EP = 2,
    Effect = "Skill/gunman_djzn_buff,none"
  },
  [133750] = {
    id = 133750,
    EP = 3,
    Effect = "Skill/gunman_bjsd_buff,none"
  },
  [133770] = {
    id = 133770,
    EP = 1,
    Effect = "Skill/gunman_xs_buff01,none"
  },
  [133771] = {
    id = 133771,
    EP = 3,
    Effect_start = "Skill/gunman_xs_buff02,none",
    Effect_hit = "Skill/gunman_xs_buff02,none"
  },
  [133820] = {
    id = 133820,
    EP = 1,
    Effect_start = "Skill/gunman_jdgt_buff",
    Effect_hit = "Skill/gunman_jdgt_buff"
  },
  [133830] = {
    id = 133830,
    EP = 3,
    Effect = "Skill/gunman_qxz_buff,none"
  },
  [133920] = {
    id = 133920,
    EP = 5,
    Effect = "Skill/gunman_hlqk_buff,none"
  },
  [133950] = {
    id = 133950,
    EP = 3,
    Effect = "Skill/gunman_dlts_buff,none"
  },
  [134520] = {
    id = 134520,
    EP = 3,
    Effect = "Skill/sfx_fw_NJ_Thunderbolt_prf,none"
  },
  [134541] = {
    id = 134541,
    EP = 3,
    Effect = "Skill/sfx_fw_VineArmor_prf,none"
  },
  [135020] = {
    id = 135020,
    Effect = "Skill/sfx_Psychic_lhxz_buff_prf,none",
    CP = 8
  },
  [135023] = {
    id = 135023,
    EP = 7,
    Effect = "Skill/sfx_Psychic_lhxz_buff02_prf,none"
  },
  [135050] = {
    id = 135050,
    EP = 1,
    Effect_start = "Skill/sfx_Psychic_slys_buff_prf,none"
  },
  [135100] = {
    id = 135100,
    EP = 1,
    Effect = "Skill/sfx_Psychic_xzam_buff_prf,none"
  },
  [135110] = {
    id = 135110,
    EP = 1,
    Effect = "Skill/sfx_Psychic_xs_buff_prf,none"
  },
  [135150] = {
    id = 135150,
    EP = 2,
    Effect = "Skill/sfx_Psychic_xw_buff_prf,none"
  },
  [135190] = {
    id = 135190,
    EP = 1,
    Effect = "Skill/sfx_Psychic_dlzz_buff_prf,none"
  },
  [135210] = {
    id = 135210,
    EP = 2,
    Effect = "Skill/sfx_Psychic_ls_buff_prf,none"
  },
  [135220] = {
    id = 135220,
    EP = 3,
    Effect_start = "Skill/sfx_Psychic_zhsp_hit_prf,none"
  },
  [135250] = {
    id = 135250,
    EP = 1,
    Effect = "Skill/sfx_Psychic_wd_buff_prf,none"
  },
  [135260] = {
    id = 135260,
    EP = 1,
    Effect = "Skill/sfx_Psychic_rz_buff_prf,none"
  },
  [135270] = {
    id = 135270,
    EP = 1,
    Effect = "Skill/sfx_Psychic_dfs_buff_prf,none"
  },
  [135280] = {
    id = 135280,
    EP = 1,
    Effect = "Skill/sfx_Psychic_qj_buff_prf,none"
  },
  [135290] = {
    id = 135290,
    EP = 1,
    Effect = "Skill/sfx_Psychic_qs_buff_prf,none"
  },
  [135300] = {
    id = 135300,
    EP = 1,
    Effect = "Skill/sfx_Psychic_ms_buff_prf,none"
  },
  [135310] = {
    id = 135310,
    EP = 1,
    Effect = "Skill/sfx_Psychic_zhs_buff_prf,none"
  },
  [135320] = {
    id = 135320,
    EP = 1,
    Effect = "Skill/sfx_Psychic_szj_buff_prf,none"
  },
  [135330] = {
    id = 135330,
    EP = 1,
    Effect = "Skill/sfx_Psychic_lm_buff_prf,none"
  },
  [135350] = {
    id = 135350,
    EP = 1,
    Effect = "Skill/sfx_Psychic_xz_buff_prf,none"
  },
  [135360] = {
    id = 135360,
    EP = 1,
    Effect = "Skill/sfx_Psychic_lhlj_buff_01_prf,none"
  },
  [135361] = {
    id = 135361,
    EP = 1,
    Effect = "Skill/sfx_Psychic_lhlj_buff_02_prf,none"
  },
  [136000] = {
    id = 136000,
    EP = 2,
    Effect = "Skill/sfx_tq_paobu_buff_prf,none"
  },
  [136080] = {
    id = 136080,
    EP = 2,
    Effect = "Skill/sfx_tq_typa_buff_prf,none"
  },
  [136081] = {
    id = 136081,
    EP = 2,
    Effect = "Skill/sfx_tq_ylpa_buff_prf,none"
  },
  [136090] = {
    id = 136090,
    EP = 3,
    Effect = "Skill/sfx_tq_xxwn_buff_prf,none"
  },
  [136100] = {
    id = 136100,
    EP = 3,
    Effect = "Skill/sfx_tq_yz_buff_prf,none"
  },
  [136110] = {
    id = 136110,
    EP = 1,
    Effect_start = "Skill/sfx_tq_tyze_buff_prf"
  },
  [136120] = {
    id = 136120,
    EP = 1,
    Effect_start = "Skill/sfx_tq_ylze_buff_prf"
  },
  [136210] = {
    id = 136210,
    EP = 3,
    Effect = "Skill/sfx_tq_xxpa_buff_prf,none"
  },
  [136360] = {
    id = 136360,
    EP = 3,
    Effect_start = "Skill/sfx_tq_yuzhou_buff_prf,none"
  },
  [136422] = {
    id = 136422,
    EP = 3,
    Effect = "Skill/sfx_herodnts_buff03_prf,none"
  },
  [136480] = {
    id = 136480,
    EP = 1,
    Effect = "Skill/sfx_herodnts_buff01_01_prf"
  },
  [136481] = {
    id = 136481,
    EP = 1,
    Effect = "Skill/sfx_herodnts_buff01_02_prf"
  },
  [136482] = {
    id = 136482,
    EP = 1,
    Effect = "Skill/sfx_herodnts_buff01_03_prf"
  },
  [136500] = {
    id = 136500,
    EP = 1,
    Effect = "Skill/sfx_herondhg_shjs_buff_prf,none"
  },
  [136510] = {
    id = 136510,
    EP = 2,
    Effect = "Skill/sfx_herondhg_zrzx_buff_prf,none"
  },
  [136521] = {
    id = 136521,
    EP = 2,
    Effect = "Skill/sfx_herondhg_lqy_buff2_prf,none"
  },
  [136522] = {
    id = 136522,
    EP = 2,
    Effect = "Skill/sfx_herondhg_lqy_buff1_prf,none"
  },
  [136532] = {
    id = 136532,
    EP = 2,
    Effect = "Skill/sfx_herondhg_jszs_buff_prf,none",
    Follow = 1
  },
  [136602] = {
    id = 136602,
    EP = 0,
    Effect = "Skill/sfx_herondhg_lycf_buff_prf,none"
  },
  [136610] = {
    id = 136610,
    EP = 3,
    Effect = "Skill/sfx_herondhg_zshh_buff1_prf,none"
  },
  [136611] = {
    id = 136611,
    EP = 1,
    Effect = "Skill/sfx_herondhg_zshh_buff2_prf,none"
  },
  [136710] = {
    id = 136710,
    EP = 2,
    Effect = "Skill/sfx_qiyu_buff_04_prf,none"
  },
  [136723] = {
    id = 136723,
    EP = 3,
    Effect_start = "Skill/sfx_qiyu_buff_01_prf",
    Effect_hit = "Skill/sfx_qiyu_buff_01_prf"
  },
  [136732] = {
    id = 136732,
    EP = 3,
    Effect_start = "Skill/sfx_qiyu_buff_03_prf",
    Effect_hit = "Skill/sfx_qiyu_buff_03_prf"
  },
  [136760] = {
    id = 136760,
    EP = 2,
    Effect_start = "Skill/sfx_qiyu_buff_05_prf",
    Effect_hit = "Skill/sfx_qiyu_buff_05_prf"
  },
  [136780] = {
    id = 136780,
    EP = 1,
    Effect = "Skill/sfx_qiyu_zzbuff01_prf,none"
  },
  [136781] = {
    id = 136781,
    EP = 1,
    Effect = "Skill/sfx_qiyu_zzbuff02_prf,none"
  },
  [136900] = {
    id = 136900,
    EP = 3,
    Effect_start = "Skill/sfx_genos_buff_03_prf",
    Effect_hit = "Skill/sfx_genos_buff_03_prf"
  },
  [136910] = {
    id = 136910,
    EP = 2,
    Effect = "Skill/sfx_genos_buff_02_prf,none",
    Effect_end = "Skill/sfx_genos_buff_02_prf,none"
  },
  [136920] = {
    id = 136920,
    EP = 2,
    Effect = "Skill/sfx_genos_saomiao_prf,none"
  },
  [136981] = {
    id = 136981,
    EP = 3,
    Effect = "Skill/sfx_genos_buff_01_prf"
  },
  [136984] = {
    id = 136984,
    EP = 1,
    Effect = "Skill/sfx_genos_buff_05_prf"
  },
  [136985] = {
    id = 136985,
    EP = 2,
    Effect = "Skill/sfx_genos_jdgr_buff_prf"
  },
  [137000] = {
    id = 137000,
    EP = 2,
    Effect = "Skill/sfx_hela_Perfume_buff_prf,none"
  },
  [137010] = {
    id = 137010,
    EP = 3,
    Effect = "Skill/sfx_hela_poison_buff_prf,none"
  },
  [137031] = {
    id = 137031,
    EP = 1,
    Effect_start = "Skill/sfx_hela_attributeup_down_prf",
    Effect_hit = "Skill/sfx_hela_attributeup_down_prf"
  },
  [137033] = {
    id = 137033,
    EP = 1,
    Effect_start = "Skill/sfx_hela_attributeup_buff_prf",
    Effect_hit = "Skill/sfx_hela_attributeup_buff_prf"
  },
  [137040] = {
    id = 137040,
    EP = 1,
    Effect_start = "Skill/sfx_hela_buff01_prf"
  },
  [137041] = {
    id = 137041,
    EP = 1,
    Effect_start = "Skill/sfx_hela_buff02_prf"
  },
  [137042] = {
    id = 137042,
    EP = 1,
    Effect_start = "Skill/sfx_hela_buff03_prf"
  },
  [137043] = {
    id = 137043,
    EP = 1,
    Effect_start = "Skill/sfx_hela_buff04_prf"
  },
  [137044] = {
    id = 137044,
    EP = 1,
    Effect_start = "Skill/sfx_hela_buff05_prf"
  },
  [137045] = {
    id = 137045,
    EP = 1,
    Effect_start = "Skill/sfx_hela_buff06_prf"
  },
  [137060] = {
    id = 137060,
    EP = 3,
    Effect = "Skill/sfx_hela_lineage_buff_prf,none"
  },
  [137080] = {
    id = 137080,
    EP = 1,
    Effect_start = "Skill/sfx_hela_forget_buff_prf"
  },
  [137091] = {
    id = 137091,
    EP = 3,
    Effect_start = "Skill/sfx_hela_deadly_hit_prf",
    Effect_hit = "Skill/sfx_hela_deadly_hit_prf"
  },
  [137092] = {
    id = 137092,
    EP = 1,
    Effect = "Skill/sfx_hela_aggravatewound_buff_prf"
  },
  [137104] = {
    id = 137104,
    EP = 2,
    Effect_start = "Skill/sfx_hela_Garm_buff_prf"
  },
  [137110] = {
    id = 137110,
    EP = 3,
    Effect = "Skill/sfx_hela_dog_buff02_prf,none"
  },
  [137112] = {
    id = 137112,
    EP = 3,
    Effect = "Skill/sfx_hela_dog_buff01_prf,none"
  },
  [137120] = {
    id = 137120,
    EP = 3,
    Effect = "Skill/sfx_hela_party_buff_prf,none"
  },
  [137200] = {
    id = 137200,
    EP = 1,
    Effect_start = "Skill/sfx_equipmaster_buff05_prf",
    Effect_hit = "Skill/sfx_equipmaster_buff05_prf"
  },
  [137232] = {
    id = 137232,
    EP = 1,
    Effect_start = "Skill/sfx_equipmaster_ddzz_buff_prf",
    Effect_hit = "Skill/sfx_equipmaster_ddzz_buff_prf",
    SE_start = "Skill/Refinefailed_2"
  },
  [137240] = {
    id = 137240,
    EP = 1,
    Effect_start = "Skill/sfx_equipmaster_xytz_atk_01_prf",
    Effect_hit = "Skill/sfx_equipmaster_xytz_atk_01_prf",
    SE_start = "Common/Refinesuccess_02",
    SE_hit = "Common/Refinesuccess_02"
  },
  [137250] = {
    id = 137250,
    EP = 0,
    Effect = "Skill/sfx_equipmaster_hsxyj_buff_prf,none"
  },
  [137261] = {
    id = 137261,
    EP = 2,
    Effect = "Skill/sfx_equipmaster_buff03_prf"
  },
  [137336] = {
    id = 137336,
    EP = 3,
    Effect = "Skill/sfx_equipmaster_buff04_prf"
  },
  [137350] = {
    id = 137350,
    EP = 3,
    Effect = "Skill/sfx_lasgrace_nws_buff_prf,none"
  },
  [137380] = {
    id = 137380,
    EP = 11,
    Effect = "Skill/sfx_lasgrace_sszf_buff_prf,none"
  },
  [137390] = {
    id = 137390,
    EP = 11,
    Effect = "Skill/sfx_lasgrace_xxy_buff_01_prf"
  },
  [137391] = {
    id = 137391,
    EP = 11,
    Effect = "Skill/sfx_lasgrace_xxy_buff_02_prf"
  },
  [137392] = {
    id = 137392,
    EP = 11,
    Effect = "Skill/sfx_lasgrace_xxy_buff_03_prf"
  },
  [137393] = {
    id = 137393,
    EP = 11,
    Effect = "Skill/sfx_lasgrace_xxy_buff_04_prf"
  },
  [137394] = {
    id = 137394,
    EP = 3,
    Effect = "Skill/sfx_lasgrace_xxy_hudun_buff_01_prf"
  },
  [137410] = {
    id = 137410,
    EP = 2,
    Effect_start = "Skill/sfx_lasgrace_hsyy_buff_prf",
    Effect_hit = "Skill/sfx_lasgrace_hsyy_buff_prf",
    SE_start = "Skill/sfx_hero_lasgrace_holyarmor_buff_01"
  },
  [137414] = {
    id = 137414,
    EP = 2,
    Effect_start = "Skill/sfx_lasgrace_hsyy_buff_01_prf",
    Effect_hit = "Skill/sfx_lasgrace_hsyy_buff_01_prf"
  },
  [137420] = {
    id = 137420,
    EP = 1,
    Effect = "Skill/sfx_lasgrace_xyfs_buff_prf,none"
  },
  [137421] = {
    id = 137421,
    EP = 2,
    Effect_start = "Skill/sfx_lasgrace_xyfs_buff01_prf,none",
    Effect_hit = "Skill/sfx_lasgrace_xyfs_buff01_prf,none"
  },
  [137440] = {
    id = 137440,
    EP = 0,
    Effect = "Skill/sfx_lasgrace_tsjl_buff_prf,none",
    Follow = 1
  },
  [137500] = {
    id = 137500,
    EP = 2,
    Effect = "Skill/sfx_magicsnake_skpz_buff_prf,none",
    Effect_end = "Skill/sfx_magicsnake_skpz_buff02_prf,none"
  },
  [137512] = {
    id = 137512,
    EP = 1,
    Effect = "Skill/sfx_magicsnake_myjl_buff_prf,none"
  },
  [137520] = {
    id = 137520,
    EP = 1,
    Effect = "Skill/sfx_magicsnake_sjtz_buff_01_prf,none"
  },
  [137521] = {
    id = 137521,
    EP = 1,
    Effect = "Skill/sfx_magicsnake_sjtz_buff_02_prf,none"
  },
  [137522] = {
    id = 137522,
    EP = 1,
    Effect = "Skill/sfx_magicsnake_sjtz_buff_03_prf,none"
  },
  [137540] = {
    id = 137540,
    EP = 2,
    Effect = "Skill/sfx_magicsnake_anjf_buff_01_prf,none"
  },
  [137551] = {
    id = 137551,
    EP = 3,
    Effect = "Skill/sfx_magicsnake_sgdl_buff_prf,none"
  },
  [137564] = {
    id = 137564,
    EP = 2,
    Effect = "Skill/sfx_magicsnake_cd_atk_prf,none",
    Follow = 1
  },
  [137582] = {
    id = 137582,
    EP = 2,
    Effect = "Skill/sfx_magicsnake_sy_hit_prf,none"
  },
  [137597] = {
    id = 137597,
    EP = 2,
    Effect = "Skill/sfx_magicsnake_ds_buff_01_prf,none"
  },
  [137700] = {
    id = 137700,
    EP = 2,
    Effect = "Skill/sfx_heinrich_dzy_buff01_prf,none"
  },
  [137705] = {
    id = 137705,
    EP = 0,
    Effect_start = "Skill/sfx_heinrich_dzy_buff02_prf,none",
    Effect_hit = "Skill/sfx_heinrich_dzy_buff02_prf,none",
    SE_start = "Skill/skill_hero_haiyinlixi_shadow_buff_attack_01"
  },
  [137706] = {
    id = 137706,
    EP = 0,
    Effect_start = "Skill/sfx_heinrich_dzy_buff03_prf,none",
    Effect_hit = "Skill/sfx_heinrich_dzy_buff03_prf,none",
    SE_start = "Skill/skill_hero_haiyinlixi_shadow_buff_attack_01"
  },
  [137707] = {
    id = 137707,
    EP = 0,
    Effect_start = "Skill/sfx_heinrich_dzy_buff04_prf,none",
    Effect_hit = "Skill/sfx_heinrich_dzy_buff04_prf,none",
    SE_start = "Skill/skill_hero_haiyinlixi_shadow_buff_attack_01"
  },
  [137730] = {
    id = 137730,
    EP = 2,
    Effect = "Skill/sfx_heinrich_ty_buff_prf,none"
  },
  [137741] = {
    id = 137741,
    EP = 1,
    Effect = "Skill/sfx_heinrich_rfsm_buff02_prf,none"
  },
  [137791] = {
    id = 137791,
    EP = 3,
    Effect_start = "Skill/sfx_heinrich_tzy_buff_prf,none",
    Effect_hit = "Skill/sfx_heinrich_tzy_buff_prf,none"
  },
  [137821] = {
    id = 137821,
    EP = 3,
    Effect_start = "Skill/sfx_heinrich_gqbb_hit_prf",
    Effect_hit = "Skill/sfx_heinrich_gqbb_hit_prf"
  },
  [137830] = {
    id = 137830,
    EP = 1,
    Effect = "Skill/sfx_heinrich_gqbb_buff_prf,none"
  },
  [137870] = {
    id = 137870,
    EP = 1,
    Effect_start = "Skill/sfx_heinrich_rfsm_buff_003_prf",
    Effect_hit = "Skill/sfx_heinrich_rfsm_buff_003_prf"
  },
  [137871] = {
    id = 137871,
    EP = 1,
    Effect_start = "Skill/sfx_heinrich_rfsm_buff_004_prf",
    Effect_hit = "Skill/sfx_heinrich_rfsm_buff_004_prf"
  },
  [137872] = {
    id = 137872,
    EP = 1,
    Effect_start = "Skill/sfx_heinrich_rfsm_buff_005_prf",
    Effect_hit = "Skill/sfx_heinrich_rfsm_buff_005_prf"
  },
  [137873] = {
    id = 137873,
    EP = 1,
    Effect_start = "Skill/sfx_heinrich_rfsm_buff_006_prf",
    Effect_hit = "Skill/sfx_heinrich_rfsm_buff_006_prf"
  },
  [137874] = {
    id = 137874,
    EP = 1,
    Effect_start = "Skill/sfx_heinrich_rfsm_buff_007_prf",
    Effect_hit = "Skill/sfx_heinrich_rfsm_buff_007_prf"
  },
  [137875] = {
    id = 137875,
    EP = 1,
    Effect_start = "Skill/sfx_heinrich_rfsm_buff_008_prf",
    Effect_hit = "Skill/sfx_heinrich_rfsm_buff_008_prf"
  },
  [137876] = {
    id = 137876,
    EP = 1,
    Effect_start = "Skill/sfx_heinrich_rfsm_buff_009_prf",
    Effect_hit = "Skill/sfx_heinrich_rfsm_buff_009_prf"
  },
  [137877] = {
    id = 137877,
    EP = 1,
    Effect_start = "Skill/sfx_heinrich_rfsm_buff_010_prf",
    Effect_hit = "Skill/sfx_heinrich_rfsm_buff_010_prf"
  },
  [137878] = {
    id = 137878,
    EP = 1,
    Effect_start = "Skill/sfx_heinrich_rfsm_buff_011_prf",
    Effect_hit = "Skill/sfx_heinrich_rfsm_buff_011_prf"
  },
  [137879] = {
    id = 137879,
    EP = 1,
    Effect_start = "Skill/sfx_heinrich_rfsm_buff_012_prf",
    Effect_hit = "Skill/sfx_heinrich_rfsm_buff_012_prf"
  },
  [138021] = {
    id = 138021,
    EP = 2,
    Effect_start = "Skill/sfx_uncleerufu_jfby_buff_01_prf,none"
  },
  [138030] = {
    id = 138030,
    EP = 2,
    Effect = "Skill/sfx_uncleerufu_fmwq_buff_prf,none"
  },
  [138040] = {
    id = 138040,
    EP = 1,
    Effect = "Skill/sfx_uncleerufu_xcjj_buff_prf,none"
  },
  [138042] = {
    id = 138042,
    EP = 2,
    Effect_start = "Skill/sfx_uncleerufu_xcjj_jj_buff_prf,none"
  },
  [138050] = {
    id = 138050,
    EP = 3,
    Effect = "Skill/sfx_uncleerufu_gxmc_buff_prf,none"
  },
  [138080] = {
    id = 138080,
    EP = 1,
    Effect = "Skill/sfx_uncleerufu_txzj_buff_02_prf,none"
  },
  [138082] = {
    id = 138082,
    EP = 2,
    Effect = "Skill/sfx_uncleerufu_txzj_buff_01_prf,none"
  },
  [138083] = {
    id = 138083,
    EP = 2,
    Effect_start = "Skill/sfx_uncleerufu_txzj_jj_buff_prf,none"
  },
  [138300] = {
    id = 138300,
    EP = 1,
    Effect_start = "Skill/sfx_thor_bwddl_buff_02_prf,none",
    Effect_hit = "Skill/sfx_thor_bwddl_buff_02_prf,none"
  },
  [138301] = {
    id = 138301,
    EP = 1,
    Effect_start = "Skill/sfx_thor_bwddl_buff_03_prf,none",
    Effect_hit = "Skill/sfx_thor_bwddl_buff_03_prf,none"
  },
  [138320] = {
    id = 138320,
    EP = 3,
    Effect = "Skill/sfx_thor_tszl_buff_01_prf,none"
  },
  [138321] = {
    id = 138321,
    EP = 3,
    Effect = "Skill/sfx_thor_tszl_buff_02_prf,none"
  },
  [138352] = {
    id = 138352,
    EP = 1,
    Effect = "Skill/sfx_thor_zsyl_buff_prf,none"
  },
  [138370] = {
    id = 138370,
    EP = 3,
    Effect = "Skill/sfx_thor_jdyl_buff_prf,none"
  },
  [138380] = {
    id = 138380,
    EP = 0,
    Effect = "Skill/sfx_thor_dnhd_buff_01_prf,none"
  },
  [138381] = {
    id = 138381,
    EP = 3,
    Effect = "Skill/sfx_thor_dnhd_buff_02_prf,none"
  },
  [138401] = {
    id = 138401,
    EP = 3,
    Effect_start = "Skill/sfx_thor_cj_bomb_buff_prf,none",
    Effect_hit = "Skill/sfx_thor_cj_bomb_buff_prf,none"
  },
  [138406] = {
    id = 138406,
    EP = 2,
    Effect = "Skill/sfx_thor_cj_floor_buff_prf,none",
    EffectScale = 2
  },
  [138511] = {
    id = 138511,
    EP = 3,
    Effect = "Skill/sfx_fenrir_tt_buff_prf,none"
  },
  [138520] = {
    id = 138520,
    EP = 3,
    Effect_start = "Skill/sfx_fenrir_blsy_buff_prf,none",
    Effect_hit = "Skill/sfx_fenrir_blsy_buff_prf,none"
  },
  [138530] = {
    id = 138530,
    EP = 1,
    Effect = "Skill/sfx_fenrir_bszj_buff_prf,none"
  },
  [138540] = {
    id = 138540,
    EP = 3,
    Effect = "Skill/sfx_fenrir_syjs_buff_prf,none"
  },
  [138550] = {
    id = 138550,
    EP = 2,
    Effect = "Skill/sfx_fenrir_zsym_buff_01_prf,none"
  },
  [138551] = {
    id = 138551,
    EP = 2,
    Effect = "Skill/sfx_fenrir_zsym_buff_02_prf,none"
  },
  [138580] = {
    id = 138580,
    EP = 11,
    Effect_start = "Skill/sfx_fenrir_ty_buff_prf,none",
    Effect_hit = "Skill/sfx_fenrir_ty_buff_prf,none",
    SE_start = "Skill/sfx_skill_fenlier_moonswallow_attack_01"
  },
  [138581] = {
    id = 138581,
    EP = 2,
    Effect = "Skill/sfx_fenrir_bl_floor_prf,none"
  },
  [138660] = {
    id = 138660,
    EP = 5,
    Effect = "Skill/sfx_callisge_zmcj_buff_prf,none"
  },
  [138670] = {
    id = 138670,
    EP = 2,
    Effect_start = "Skill/sfx_callisge_skill_atk_02_prf,none",
    Effect_hit = "Skill/sfx_callisge_qstdry_buff_prf,none"
  },
  [138701] = {
    id = 138701,
    EP = 1,
    Effect = "Skill/sfx_callisge_ey_buff_01_prf"
  },
  [138710] = {
    id = 138710,
    EP = 0,
    Effect = "Skill/sfx_callisge_lshy_buff_prf,none"
  },
  [138725] = {
    id = 138725,
    EP = 3,
    Effect = "Skill/sfx_callisge_jw_hit_prf,none"
  },
  [138730] = {
    id = 138730,
    EP = 1,
    Effect = "Skill/sfx_callisge_ey_buff_02_prf"
  },
  [138742] = {
    id = 138742,
    EP = 1,
    Effect = "Skill/sfx_callisge_fx_buff_01_prf,none"
  },
  [138830] = {
    id = 138830,
    EP = 1,
    Effect = "Skill/sfx_sarah_lhly_red_buff_02_prf,none"
  },
  [138831] = {
    id = 138831,
    EP = 1,
    Effect = "Skill/sfx_sarah_lhly_black_buff_02_prf,none"
  },
  [138832] = {
    id = 138832,
    EP = 1,
    Effect = "Skill/sfx_sarah_lhly_pink_buff_02_prf,none"
  },
  [138840] = {
    id = 138840,
    EP = 1,
    Effect = "Skill/sfx_sarah_lhly_red_buff_01_prf,none"
  },
  [138841] = {
    id = 138841,
    EP = 1,
    Effect = "Skill/sfx_sarah_lhly_black_buff_01_prf,none"
  },
  [138842] = {
    id = 138842,
    EP = 1,
    Effect = "Skill/sfx_sarah_lhly_pink_buff_01_prf,none"
  },
  [138850] = {
    id = 138850,
    EP = 3,
    Effect = "Skill/sfx_sarah_fzfy_zy_buff_02_prf,none"
  },
  [138851] = {
    id = 138851,
    EP = 3,
    Effect = "Skill/sfx_sarah_fzfy_ch_buff_02_prf,none"
  },
  [138852] = {
    id = 138852,
    EP = 3,
    Effect = "Skill/sfx_sarah_fzfy_fx_buff_02_prf,none"
  },
  [138854] = {
    id = 138854,
    EP = 3,
    Effect = "Skill/sfx_sarah_fzfy_jj_buff_02_prf,none"
  },
  [138855] = {
    id = 138855,
    EP = 3,
    Effect = "Skill/sfx_sarah_fzfy_zh_buff_02_prf,none"
  },
  [138858] = {
    id = 138858,
    EP = 3,
    Effect = "Skill/sfx_sarah_fzfy_hd_buff_02_prf,none"
  },
  [138903] = {
    id = 138903,
    EP = 3,
    Effect = "Skill/sfx_alinia_wd_Buff_01_prf,none"
  },
  [138930] = {
    id = 138930,
    EP = 3,
    Effect = "Skill/sfx_alinia_chzd_Buff_01_prf,none"
  },
  [138940] = {
    id = 138940,
    EP = 3,
    Effect = "Skill/sfx_alinia_slys_buff_feng_02_prf"
  },
  [138941] = {
    id = 138941,
    EP = 3,
    Effect = "Skill/sfx_alinia_slys_buff_di_02_prf"
  },
  [138942] = {
    id = 138942,
    EP = 3,
    Effect = "Skill/sfx_alinia_slys_buff_shui_02_prf"
  },
  [138943] = {
    id = 138943,
    EP = 3,
    Effect = "Skill/sfx_alinia_slys_buff_huo_02_prf"
  },
  [138944] = {
    id = 138944,
    EP = 3,
    Effect = "Skill/sfx_alinia_slys_buff_seng_02_prf"
  },
  [138951] = {
    id = 138951,
    EP = 3,
    Effect = "Skill/sfx_alinia_zyzf_Buff_01_prf,none"
  },
  [138962] = {
    id = 138962,
    EP = 1,
    Effect = "Skill/sfx_alinia_dlxf_Buff_01_prf,none",
    Effect_end = "Skill/sfx_alinia_xlh_release_01_prf,none"
  },
  [139063] = {
    id = 139063,
    EP = 1,
    Effect_hit = "Skill/sfx_cookingaang_tofu_buff3_prf"
  },
  [139064] = {
    id = 139064,
    EP = 1,
    Effect_start = "Skill/sfx_cookingaang_crystal_buff_prf",
    Effect_hit = "Skill/sfx_cookingaang_crystal_buff_prf"
  },
  [139065] = {
    id = 139065,
    EP = 1,
    Effect_start = "Skill/sfx_cookingaang_pot_buff_prf",
    Effect_hit = "Skill/sfx_cookingaang_pot_buff_prf"
  },
  [139066] = {
    id = 139066,
    EP = 3,
    Effect = "Skill/sfx_cookingaang_tofu_buff2_prf,none"
  },
  [139067] = {
    id = 139067,
    EP = 2,
    Effect = "Skill/sfx_cookingaang_tofu_buff1_prf,none"
  },
  [139081] = {
    id = 139081,
    EP = 3,
    Effect = "Skill/sfx_cookingaang_wheat_buff_prf,none"
  },
  [139090] = {
    id = 139090,
    EP = 1,
    Effect = "Skill/sfx_cookingaang_snapper_buff_prf"
  },
  [139160] = {
    id = 139160,
    EP = 3,
    Effect = "Skill/sfx_cookingaang_rice_buff_prf,none"
  },
  [139161] = {
    id = 139161,
    EP = 0,
    Effect = "Skill/sfx_cookingaang_rice_atk_prf,none"
  },
  [139170] = {
    id = 139170,
    EP = 2,
    Effect = "Skill/sfx_cookingaang_afei_atk_prf"
  },
  [139180] = {
    id = 139180,
    EP = 2,
    Effect = "Skill/sfx_cookingaang_food_buff1_prf"
  },
  [139181] = {
    id = 139181,
    EP = 2,
    Effect = "Skill/sfx_cookingaang_food_buff2_prf"
  },
  [139182] = {
    id = 139182,
    EP = 2,
    Effect = "Skill/sfx_cookingaang_food_buff3_prf"
  },
  [139300] = {
    id = 139300,
    EP = 2,
    Effect_start = "Skill/sfx_morocc_wjha_buff_prf",
    SE_start = "Skill/sfx_skill_mengluoke_chain_explo_01"
  },
  [139310] = {
    id = 139310,
    EP = 0,
    Effect = "Skill/sfx_morocc_jmgh_buff_prf,none"
  },
  [139320] = {
    id = 139320,
    EP = 2,
    Effect_start = "Skill/sfx_morocc_emdy_buff_prf"
  },
  [139331] = {
    id = 139331,
    EP = 2,
    Effect = "Skill/sfx_morocc_hazj_buff01_prf",
    Effect_end = "Skill/sfx_morocc_hazj_buff_disappear_prf,none"
  },
  [139332] = {
    id = 139332,
    EP = 2,
    Effect = "Skill/sfx_morocc_hazj_buff02_prf",
    Effect_end = "Skill/sfx_morocc_hazj_buff_disappear_prf,none"
  },
  [139333] = {
    id = 139333,
    EP = 2,
    Effect = "Skill/sfx_morocc_hazj_buff03_prf",
    Effect_end = "Skill/sfx_morocc_hazj_buff_disappear_prf,none"
  },
  [139334] = {
    id = 139334,
    EP = 2,
    Effect = "Skill/sfx_morocc_hazj_buff04_prf",
    Effect_end = "Skill/sfx_morocc_hazj_buff_disappear_prf,none"
  },
  [139335] = {
    id = 139335,
    EP = 2,
    Effect = "Skill/sfx_morocc_hazj_buff05_prf",
    Effect_end = "Skill/sfx_morocc_hazj_buff_disappear_prf,none"
  },
  [139340] = {
    id = 139340,
    EP = 0,
    Effect = "Skill/sfx_morocc_bs_jmgh_prf,none"
  },
  [139350] = {
    id = 139350,
    EP = 0,
    Effect = "Skill/sfx_morocc_bs_mwly_prf,none"
  },
  [139381] = {
    id = 139381,
    EP = 0,
    Effect = "Skill/sfx_morocc_asxfb_ground_prf,none"
  },
  [139400] = {
    id = 139400,
    EP = 2,
    Effect = "Skill/sfx_morocc_azhd_buff_prf"
  },
  [151035] = {
    id = 151035,
    EP = 0,
    Effect = "Skill/KinsProtect_buff_12pvp"
  },
  [151050] = {
    id = 151050,
    EP = 4,
    Effect = "Skill/PortalThree_12v12_01"
  },
  [151051] = {
    id = 151051,
    EP = 4,
    Effect = "Skill/PortalThree_12v12_02"
  },
  [151052] = {
    id = 151052,
    EP = 4,
    Effect = "Skill/PortalThree_12v12_03"
  },
  [151100] = {
    id = 151100,
    EP = 1,
    Effect = "Skill/Eff_Attack_12pvp"
  },
  [151110] = {
    id = 151110,
    EP = 1,
    Effect = "Skill/Eff_Defense_12pvp"
  },
  [152010] = {
    id = 152010,
    EP = 2,
    Effect = "Skill/Rune_05_12pvp,none",
    Follow = 1
  },
  [152020] = {
    id = 152020,
    EP = 2,
    Effect = "Skill/Rune_06_12pvp,none",
    Follow = 1
  },
  [152021] = {
    id = 152021,
    EP = 2,
    Effect = "Skill/Rune_06_12pvp,none",
    EffectScale = 2.25
  },
  [152022] = {
    id = 152022,
    EP = 2,
    Effect = "Skill/Punishment_buff1,none",
    EffectScale = 1
  },
  [152023] = {
    id = 152023,
    EP = 2,
    Effect_start = "Skill/Dragon_Chaochondrite,none"
  },
  [152024] = {
    id = 152024,
    EP = 2,
    Effect = "Skill/sfx_himemmeth_floor_prf,none",
    EffectScale = 0.8
  },
  [152025] = {
    id = 152025,
    EP = 2,
    Effect = "Skill/sfx_himemmeth_floor_prf,none",
    EffectScale = 1.2
  },
  [152026] = {
    id = 152026,
    EP = 2,
    Effect = "Skill/sfx_himenmeth_buff_prf,none",
    EffectScale = 1
  },
  [152027] = {
    id = 152027,
    EP = 0,
    Effect = "Skill/Eff_ShadowSlaughter_buff,none",
    EffectScale = 2
  },
  [152028] = {
    id = 152028,
    EP = 0,
    SE_start = "Common/sfx_skill_task_evilstorm_01"
  },
  [152029] = {
    id = 152029,
    EP = 0,
    Effect = "Common/73GuideArea",
    EffectScale = 5
  },
  [152030] = {
    id = 152030,
    EP = 2,
    Effect = "Skill/Rune_04_12pvp,none",
    Follow = 1
  },
  [152040] = {
    id = 152040,
    EP = 2,
    Effect = "Skill/Rune_03_12pvp,none",
    Follow = 1
  },
  [152050] = {
    id = 152050,
    EP = 2,
    Effect = "Skill/Rune_01_12pvp,none",
    Follow = 1
  },
  [152060] = {
    id = 152060,
    EP = 2,
    Effect = "Skill/Rune_02_12pvp,none",
    Follow = 1
  },
  [153080] = {
    id = 153080,
    EP = 0,
    Effect_start = "Skill/Eff_emengchuanran_hit_12pvp"
  },
  [153201] = {
    id = 153201,
    EP = 2,
    Effect = "Skill/HolyCross_12pvp,none"
  },
  [153220] = {
    id = 153220,
    EP = 2,
    Effect = "Skill/Maintenance_12pvp,none"
  },
  [153230] = {
    id = 153230,
    EP = 2,
    Effect = "Skill/CrownThorns_12pvp,none"
  },
  [153240] = {
    id = 153240,
    EP = 3,
    Effect = "Skill/Netherworld_12pvp,none"
  },
  [153360] = {
    id = 153360,
    EP = 1,
    Effect = "Skill/PortalThree_12v12_guang"
  },
  [153370] = {
    id = 153370,
    EP = 2,
    Effect = "Skill/PortalThree_12v12_guang"
  },
  [153380] = {
    id = 153380,
    EP = 3,
    Effect = "Skill/PortalThree_12v12_guang"
  },
  [153390] = {
    id = 153390,
    EP = 4,
    Effect = "Skill/PortalThree_12v12_02"
  },
  [154020] = {
    id = 154020,
    EP = 3,
    Effect = "Skill/Eff_Blossom_hudun_buff01,none"
  },
  [154021] = {
    id = 154021,
    EP = 3,
    Effect = "Skill/Eff_Blossom_hudun_buff02,none"
  },
  [154022] = {
    id = 154022,
    EP = 3,
    Effect = "Skill/Eff_Blossom_hudun_buff03,none"
  },
  [154023] = {
    id = 154023,
    EP = 3,
    Effect = "Skill/Eff_Blossom_hudun_buff04,none"
  },
  [154050] = {
    id = 154050,
    EP = 2,
    Effect = "Skill/Eff_Blossom_shengshengbuxi_buff,none"
  },
  [154081] = {
    id = 154081,
    EP = 2,
    Effect = "Skill/Eff_Blossom_cuixi_buff01,none"
  },
  [154082] = {
    id = 154082,
    EP = 2,
    Effect = "Skill/Eff_Blossom_cuixi_buff02,none"
  },
  [154083] = {
    id = 154083,
    EP = 2,
    Effect = "Skill/Eff_Blossom_cuixi_buff03,none"
  },
  [154084] = {
    id = 154084,
    EP = 2,
    Effect = "Skill/Eff_Blossom_cuixi_buff04,none"
  },
  [154090] = {
    id = 154090,
    EP = 3,
    Effect = "Skill/Eff_Blossom_cuixi_atk,none"
  },
  [154100] = {
    id = 154100,
    EP = 5,
    Effect = "Skill/Eff_Blosso_feng_buff,none"
  },
  [154284] = {
    id = 154284,
    EP = 2,
    Effect = "Skill/Eff_Brooke01_StrSoul_buff,none"
  },
  [154291] = {
    id = 154291,
    EP = 2,
    Effect = "Skill/Eff_Brooke01_scrfic_buff,none"
  },
  [154900] = {
    id = 154900,
    EP = 2,
    Effect = "Skill/Eff_EvilUnique_zhao01"
  },
  [154911] = {
    id = 154911,
    EP = 1,
    Effect = "Skill/Eff_EvilUnique_shentan01"
  },
  [154921] = {
    id = 154921,
    EP = 1,
    Effect = "Skill/Eff_EvilUnique_shentan02"
  },
  [154931] = {
    id = 154931,
    EP = 1,
    Effect = "Skill/Eff_EvilUnique_shentan03"
  },
  [154941] = {
    id = 154941,
    EP = 1,
    Effect = "Skill/Eff_EvilUnique_shentan04"
  },
  [155030] = {
    id = 155030,
    EP = 2,
    Effect = "Skill/Eff_EvilUnique_zhao03"
  },
  [155060] = {
    id = 155060,
    EP = 2,
    Effect = "Skill/Eff_EvilUnique_jiaoying,none"
  },
  [155070] = {
    id = 155070,
    EP = 2,
    Effect = "Skill/Eff_EvilUnique_maoxue"
  },
  [155080] = {
    id = 155080,
    EP = 2,
    Effect = "Skill/Eff_EvilUnique_yumao02"
  },
  [155200] = {
    id = 155200,
    EP = 2,
    Effect = "Skill/Eff_LibraWitch_huixiang_buff"
  },
  [155210] = {
    id = 155210,
    EP = 3,
    Effect = "Skill/Eff_LibraWitch_qushi_buff"
  },
  [155220] = {
    id = 155220,
    EP = 2,
    Effect = "Skill/Eff_LibraWitch_jinggu_atk02"
  },
  [155230] = {
    id = 155230,
    EP = 0,
    Effect = "Skill/Eff_Hujin_yumao_buff"
  },
  [155231] = {
    id = 155231,
    EP = 0,
    Effect = "Skill/Eff_Hujin_yumao_hit"
  },
  [155241] = {
    id = 155241,
    EP = 1,
    Effect = "Skill/Eff_Hujin_jiu_buff"
  },
  [155250] = {
    id = 155250,
    EP = 3,
    Effect = "Skill/Eff_LibraWitch_qushi_buff02"
  },
  [155260] = {
    id = 155260,
    EP = 0,
    Effect = "Skill/Eff_Hujin_yumao_atk"
  },
  [155400] = {
    id = 155400,
    EP = 6,
    Effect = "Skill/Eff_Fossil_fire_xiong"
  },
  [155401] = {
    id = 155401,
    EP = 5,
    Effect = "Skill/Eff_Fossil_fire_chibangL"
  },
  [155402] = {
    id = 155402,
    EP = 9,
    Effect = "Skill/Eff_Fossil_fire_chibangR"
  },
  [155403] = {
    id = 155403,
    EP = 8,
    Effect = "Skill/Eff_Fossil_fire_weibaR"
  },
  [155404] = {
    id = 155404,
    EP = 4,
    Effect = "Skill/Eff_Fossil_fire_kou"
  },
  [155405] = {
    id = 155405,
    EP = 6,
    Effect = "Skill/Eff_Fossil_posion_xiong"
  },
  [155406] = {
    id = 155406,
    EP = 5,
    Effect = "Skill/Eff_Fossil_posion_chibangL"
  },
  [155407] = {
    id = 155407,
    EP = 9,
    Effect = "Skill/Eff_Fossil_posion_chibangR"
  },
  [155408] = {
    id = 155408,
    EP = 7,
    Effect = "Skill/Eff_Fossil_posion_weibaL"
  },
  [155409] = {
    id = 155409,
    EP = 4,
    Effect = "Skill/Eff_Fossil_posion_kou"
  },
  [155410] = {
    id = 155410,
    EP = 2,
    Effect_start = "Skill/Eff_Fossil_fire_ switch"
  },
  [155411] = {
    id = 155411,
    EP = 2,
    Effect_start = "Skill/Eff_Fossil_posion_ switch"
  },
  [155510] = {
    id = 155510,
    EP = 0,
    Effect = "Skill/Eff_Fossil_poison_buff01"
  },
  [155520] = {
    id = 155520,
    EP = 0,
    Effect = "Skill/Eff_Fossil_fire_buff01"
  },
  [155560] = {
    id = 155560,
    EP = 1,
    Effect = "Skill/Eff_Fossil_fire_buff02"
  },
  [155570] = {
    id = 155570,
    EP = 1,
    Effect = "Skill/Eff_Fossil_poison_buff02"
  },
  [155575] = {
    id = 155575,
    EP = 0,
    Effect = "Skill/Eff_Fossil_poison_floor01"
  },
  [155576] = {
    id = 155576,
    EP = 0,
    Effect = "Skill/Eff_Fossil_fire_floor01"
  },
  [155620] = {
    id = 155620,
    EP = 2,
    Effect_start = "Skill/Eff_Fossil_poison_floor"
  },
  [155621] = {
    id = 155621,
    EP = 2,
    Effect_start = "Skill/Eff_Fossil_fire_floor"
  },
  [155640] = {
    id = 155640,
    EP = 3,
    Effect = "Skill/Eff_Fossil_charge_tip"
  },
  [155820] = {
    id = 155820,
    EP = 0,
    Effect = "Common/sfx_newcopy_zuzhou_prf"
  },
  [155821] = {
    id = 155821,
    EP = 2,
    Effect = "Common/sfx_newcopy_jitan_hei_prf"
  },
  [155822] = {
    id = 155822,
    EP = 2,
    Effect = "Common/sfx_newcopy_jitan_jin_prf"
  },
  [155823] = {
    id = 155823,
    EP = 2,
    Effect = "Common/sfx_newcopy_map_prf"
  },
  [155901] = {
    id = 155901,
    EP = 1,
    Effect = "Skill/Eff_FlameShock_Buff02,none"
  },
  [156005] = {
    id = 156005,
    EP = 2,
    Effect = "Skill/Eff_piece_lie_buff"
  },
  [156009] = {
    id = 156009,
    EP = 2,
    Effect = "Skill/Eff_piece_fuhuo_buff"
  },
  [156011] = {
    id = 156011,
    EP = 2,
    Effect = "Skill/Eff_piece_fen_buff"
  },
  [156013] = {
    id = 156013,
    EP = 2,
    Effect = "Skill/Eff_piece_chong_buff"
  },
  [156071] = {
    id = 156071,
    EP = 0,
    Effect = "Skill/Mefractioon_buff_mijing_Secret03"
  },
  [156102] = {
    id = 156102,
    EP = 0,
    Effect = "Skill/eff_k_lzgh_floor"
  },
  [156111] = {
    id = 156111,
    EP = 2,
    Effect = "Skill/eff_w_bsbz_buff"
  },
  [156122] = {
    id = 156122,
    EP = 0,
    Effect = "Skill/eff_w_mlzf_buff"
  },
  [156130] = {
    id = 156130,
    EP = 2,
    Effect = "Skill/eff_p_xyqf_buff"
  },
  [156154] = {
    id = 156154,
    EP = 0,
    Effect_start = "Skill/eff_sktz_buff",
    Follow = 1,
    SE_start = "Skill/skill_weapon_clockbomb_attack"
  },
  [156201] = {
    id = 156201,
    EP = 1,
    Effect = "Skill/eff_m_qtjx_buff"
  },
  [156312] = {
    id = 156312,
    EP = 0,
    Effect = "Skill/Eff_Megalith_Damnation"
  },
  [156350] = {
    id = 156350,
    EP = 1,
    Effect = "Skill/Eff_Megalith_Tearing"
  },
  [156500] = {
    id = 156500,
    EP = 3,
    Effect = "Skill/sfx_cw_mx_sing_prf"
  },
  [156520] = {
    id = 156520,
    EP = 0,
    Effect = "Skill/Heal_pet"
  },
  [156561] = {
    id = 156561,
    EP = 3,
    Effect = "Skill/BossViolent"
  },
  [156563] = {
    id = 156563,
    EP = 3,
    Effect = "Skill/sfx_pve3_sing_prf"
  },
  [156570] = {
    id = 156570,
    EP = 3,
    Effect = "Skill/Eff_SoulArmor_buff"
  },
  [156575] = {
    id = 156575,
    EP = 1,
    Effect = "Skill/UFOBoom",
    SE_start_Loop = "State/sfx_buff_mechanical_breakdown_loop"
  },
  [156576] = {
    id = 156576,
    EP = 2,
    Effect = "Common/cfx_energy_buff2_prf",
    SE_start_Loop = "State/sfx_buff_energy_transfer_loop"
  },
  [156577] = {
    id = 156577,
    EP = 2,
    Effect = "Common/cfx_energy_buff1_prf",
    SE_start_Loop = "State/sfx_buff_energy_transfer_loop"
  },
  [156592] = {
    id = 156592,
    EP = 5,
    Effect = "Skill/sfx_jiqibarthe_liedi_buff01_prf"
  },
  [156810] = {
    id = 156810,
    EP = 2,
    Effect = "Skill/sfx_qlyf01_buff_prf"
  },
  [156811] = {
    id = 156811,
    EP = 1,
    Effect = "Skill/sfx_qlyf02_buff_prf"
  },
  [156820] = {
    id = 156820,
    EP = 3,
    Effect = "Skill/sfx_fwhf_hit_prf"
  },
  [156830] = {
    id = 156830,
    EP = 1,
    Effect = "Skill/sfx_jmkh_hit01_prf",
    Effect_hit = "Skill/sfx_jmkh_hit01_prf"
  },
  [156831] = {
    id = 156831,
    EP = 1,
    Effect = "Skill/sfx_jmkh_hit02_prf",
    Effect_hit = "Skill/sfx_jmkh_hit02_prf"
  },
  [156832] = {
    id = 156832,
    EP = 1,
    Effect = "Skill/sfx_jmkh_hit03_prf",
    Effect_hit = "Skill/sfx_jmkh_hit03_prf"
  },
  [156840] = {
    id = 156840,
    EP = 1,
    Effect = "Skill/sfx_bzbz_buff_prf"
  },
  [156841] = {
    id = 156841,
    EP = 0,
    Effect = "Skill/sfx_bzbz_hit_prf"
  },
  [156843] = {
    id = 156843,
    EP = 0,
    Effect = "Skill/sfx_bzbz_buff02_prf"
  },
  [156861] = {
    id = 156861,
    EP = 2,
    Effect = "Skill/SafetyWall"
  },
  [156871] = {
    id = 156871,
    EP = 2,
    Effect = "Skill/AngelPower"
  },
  [157201] = {
    id = 157201,
    EP = 0,
    Effect = "Skill/sfx_lavagolem_yszl_floor_prf"
  },
  [157220] = {
    id = 157220,
    EP = 0,
    Effect = "Skill/sfx_lavagolem_sl_buff02_prf"
  },
  [157222] = {
    id = 157222,
    EP = 1,
    Effect = "Skill/sfx_lavagolem_sl_buff_prf"
  },
  [157230] = {
    id = 157230,
    EP = 0,
    Effect = "Skill/sfx_lavagolem_ls_buff_prf"
  },
  [157250] = {
    id = 157250,
    EP = 0,
    Effect = "Skill/sfx_lavagolem_yj_buff_prf"
  },
  [157294] = {
    id = 157294,
    EP = 0,
    Effect = "Skill/sfx_lavagolem_tjys_floor_prf"
  },
  [157360] = {
    id = 157360,
    EP = 0,
    Effect = "Skill/sfx_lavagolem_com_buff_prf"
  },
  [157636] = {
    id = 157636,
    EP = 0,
    Effect = "Skill/Home",
    EffectScale = 3
  },
  [157700] = {
    id = 157700,
    EP = 1,
    Effect = "Skill/sfx_wavetotem_bj_buff03_prf"
  },
  [157701] = {
    id = 157701,
    EP = 1,
    Effect = "Skill/sfx_wavetotem_bj_buff02_prf"
  },
  [157702] = {
    id = 157702,
    EP = 1,
    Effect = "Skill/sfx_wavetotem_bj_buff_prf"
  },
  [157706] = {
    id = 157706,
    EP = 1,
    Effect = "Skill/sfx_wavetotem_bjboss_buff_prf"
  },
  [157707] = {
    id = 157707,
    EP = 1,
    Effect = "Skill/sfx_wavetotem_bjboss_buff03_prf"
  },
  [157708] = {
    id = 157708,
    EP = 1,
    Effect = "Skill/sfx_wavetotem_bjboss_buff02_prf"
  },
  [157710] = {
    id = 157710,
    EP = 0,
    Effect = "Skill/sfx_wavetotem_ly_buff_prf"
  },
  [157720] = {
    id = 157720,
    EP = 0,
    Effect = "Skill/sfx_wavetotem_jrbj_atk_prf"
  },
  [158000] = {
    id = 158000,
    EP = 2,
    Effect = "Skill/sfx_nagasiren_zz_buff_prf"
  },
  [158001] = {
    id = 158001,
    EP = 3,
    Effect_hit = "Skill/sfx_nagasiren_zz_hit_prf"
  },
  [158020] = {
    id = 158020,
    EP = 1,
    Effect = "Skill/sfx_nagasiren_jc_buff_prf"
  },
  [158030] = {
    id = 158030,
    EP = 1,
    Effect = "Skill/sfx_nagasiren_jd_buff_prf"
  },
  [158044] = {
    id = 158044,
    EP = 0,
    Effect = "Skill/sfx_nagasiren_hl_buff_prf"
  },
  [158046] = {
    id = 158046,
    EP = 0,
    Effect = "Skill/sfx_nagasiren_hl_atk_prf"
  },
  [158305] = {
    id = 158305,
    EP = 2,
    Effect = "Skill/sfx_wavetotem_aoe_atk_prf"
  },
  [158603] = {
    id = 158603,
    EP = 1,
    Effect = "Common/FlameHorse_tail"
  },
  [158631] = {
    id = 158631,
    EP = 2,
    Effect = "Skill/sfx_wavetotem_ttsx_atk_prf"
  },
  [158655] = {
    id = 158655,
    EP = 3,
    Effect = "Skill/KinsProtect_buff,none"
  },
  [158670] = {
    id = 158670,
    EP = 2,
    Effect = "Common/Stage3_buff,none"
  },
  [158681] = {
    id = 158681,
    EP = 2,
    Effect = "Skill/sfx_pve5_detoxi_floor_prf,none",
    EffectScale = 0.5
  },
  [158682] = {
    id = 158682,
    EP = 2,
    Effect = "Skill/sfx_pve5_advancedetoxi_floor_prf,none",
    EffectScale = 0.5
  },
  [158760] = {
    id = 158760,
    EP = 0,
    Effect = "Skill/Eff_Ninja_open_floor03",
    EffectScale = 2.3
  },
  [158761] = {
    id = 158761,
    EP = 0,
    Effect = "Skill/Eff_Ninja_open_floor04",
    EffectScale = 2.3
  },
  [158762] = {
    id = 158762,
    EP = 0,
    Effect = "Skill/Eff_Ninja_open_floor02",
    EffectScale = 2.3
  },
  [158763] = {
    id = 158763,
    EP = 0,
    Effect = "Skill/Eff_Ninja_open_floor01",
    EffectScale = 2.3
  },
  [158790] = {
    id = 158790,
    EP = 0,
    Effect = "Skill/Eff_MVP2_fushe_atk"
  },
  [158801] = {
    id = 158801,
    EP = 3,
    Effect = "Skill/Assumptio_buff,none",
    EffectScale = 1.5
  },
  [158820] = {
    id = 158820,
    EP = 5,
    Effect = "Skill/sfx_pve4_heihuo02_prf,none"
  },
  [158821] = {
    id = 158821,
    EP = 5,
    Effect = "Skill/sfx_pve4_heihuo01_prf,none"
  },
  [158940] = {
    id = 158940,
    EP = 2,
    Effect = "Skill/GravitationalField_buff,none"
  },
  [158972] = {
    id = 158972,
    EP = 2,
    Effect = "Skill/sfx_taqk_02_prf,none"
  },
  [158976] = {
    id = 158976,
    EP = 2,
    Effect = "Skill/sfx_taqk_04_prf,none",
    EffectScale = 2
  },
  [158978] = {
    id = 158978,
    EP = 2,
    Effect = "Skill/sfx_taqk_03_prf,none",
    EffectScale = 1.2
  },
  [158979] = {
    id = 158979,
    EP = 2,
    Effect = "Skill/sfx_taqk_01_prf,none",
    EffectScale = 1.5
  },
  [159110] = {
    id = 159110,
    EP = 0,
    Effect_start = "Common/Clown"
  },
  [159111] = {
    id = 159111,
    EP = 0,
    Effect = "Skill/sfx_pve3_bomb_buff_prf"
  },
  [159112] = {
    id = 159112,
    EP = 3,
    Effect = "Skill/sfx_pve3_su_buff_prf"
  },
  [159113] = {
    id = 159113,
    EP = 2,
    Effect = "Skill/sfx_pve3_charge_buff_prf"
  },
  [159120] = {
    id = 159120,
    EP = 3,
    Effect = "Skill/CircleSP_buff,none"
  },
  [159186] = {
    id = 159186,
    EP = 3,
    Effect_start = "Skill/Eff_Ninja_atk_hit,LowHit"
  },
  [159201] = {
    id = 159201,
    EP = 6,
    Effect = "Skill/sfx_pve3_body_buff_prf"
  },
  [159260] = {
    id = 159260,
    EP = 2,
    Effect_start = "Skill/Blew_attack"
  },
  [159371] = {
    id = 159371,
    EP = 1,
    Effect = "Skill/MartyrsDefense_buff,none",
    EffectScale = 0.5
  },
  [159392] = {
    id = 159392,
    EP = 2,
    Effect = "Skill/sfx_mvp_jiaoyin_prf,none"
  },
  [159400] = {
    id = 159400,
    EP = 2,
    Effect = "Skill/PlayerLock,none",
    EffectScale = 0.5
  },
  [159430] = {
    id = 159430,
    EP = 2,
    Effect = "Skill/sfx_paoji_warning02_buff_prf,none"
  },
  [159431] = {
    id = 159431,
    EP = 2,
    Effect = "Skill/sfx_paoji_warning01_buff_prf,none"
  },
  [159795] = {
    id = 159795,
    EP = 0,
    Effect = "Skill/Eff_FireRing",
    EffectScale = 0.4
  },
  [159796] = {
    id = 159796,
    EP = 1,
    Effect = "Common/PhotonForce_Mix"
  },
  [159797] = {
    id = 159797,
    EP = 0,
    Effect = "Common/PinkMF"
  },
  [159798] = {
    id = 159798,
    EP = 0,
    Effect = "Common/Strengthen_Blue"
  },
  [159799] = {
    id = 159799,
    EP = 0,
    Effect = "Common/Strengthen_Purple"
  },
  [159800] = {
    id = 159800,
    EP = 0,
    Effect = "Common/Strengthen_Red"
  },
  [159801] = {
    id = 159801,
    EP = 0,
    Effect = "Common/Strengthen_Yellow"
  },
  [159850] = {
    id = 159850,
    EP = 2,
    Effect = "Skill/DarkStrike_cast"
  },
  [159851] = {
    id = 159851,
    EP = 2,
    Effect = "Skill/MudSpace_buff"
  },
  [159852] = {
    id = 159852,
    EP = 0,
    Effect = "Skill/Task_NecromancerSummons"
  },
  [159853] = {
    id = 159853,
    EP = 0,
    Effect = "Skill/Bloody_Assault_buff,none"
  },
  [159854] = {
    id = 159854,
    EP = 0,
    Effect = "Skill/Bloody_Coagulation_buff,none"
  },
  [159880] = {
    id = 159880,
    EP = 3,
    Effect = "Skill/sfx_KinsProtect_buff_prf,none",
    EffectScale = 1.5
  },
  [159910] = {
    id = 159910,
    EP = 2,
    Effect = "Skill/Eff_MVP2_wange_buff",
    EffectScale = 0.5
  },
  [159918] = {
    id = 159918,
    EP = 2,
    Effect = "Skill/sfx_linghzzhe_wange_buff_prf",
    EffectScale = 0.5
  },
  [160041] = {
    id = 160041,
    EP = 0,
    Effect = "Skill/sfx_mvp_nuqi_buff_prf,none"
  },
  [160042] = {
    id = 160042,
    EP = 0,
    Effect_start = "Skill/sfx_mvp_atk_buff_prf,none"
  },
  [160231] = {
    id = 160231,
    EP = 1,
    Effect = "Skill/BossDefense,none"
  },
  [160232] = {
    id = 160232,
    EP = 1,
    Effect = "Skill/BossVampire,none"
  },
  [160233] = {
    id = 160233,
    EP = 1,
    Effect = "Skill/BossViolent,none"
  },
  [160236] = {
    id = 160236,
    EP = 3,
    Effect = "Common/90YmirsHeart_continued2,none"
  },
  [160254] = {
    id = 160254,
    EP = 1,
    Effect = "Skill/sfx_phy_mag_refle_prf"
  },
  [160670] = {
    id = 160670,
    EP = 3,
    Effect = "Skill/Knight_Snowstorm,none"
  },
  [160680] = {
    id = 160680,
    EP = 3,
    Effect = "Skill/Chepet_FlameShoot3,none"
  },
  [160690] = {
    id = 160690,
    EP = 2,
    Effect = "Skill/Chepet_FlameCircle6,none"
  },
  [160691] = {
    id = 160691,
    EP = 2,
    Effect = "Skill/Chepet_FlameCircle5,none"
  },
  [160692] = {
    id = 160692,
    EP = 2,
    Effect = "Skill/Chepet_FlameCircle4,none"
  },
  [160693] = {
    id = 160693,
    EP = 2,
    Effect = "Skill/Chepet_FlameCircle3,none"
  },
  [160694] = {
    id = 160694,
    EP = 2,
    Effect = "Skill/Chepet_FlameCircle2,none"
  },
  [160695] = {
    id = 160695,
    EP = 2,
    Effect = "Skill/Chepet_FlameCircle1,none"
  },
  [160696] = {
    id = 160696,
    EP = 2,
    Effect = "Skill/Chepet_FlameCircleTrailer6,none"
  },
  [160697] = {
    id = 160697,
    EP = 2,
    Effect = "Skill/Chepet_FlameCircleTrailer5,none"
  },
  [160698] = {
    id = 160698,
    EP = 2,
    Effect = "Skill/Chepet_FlameCircleTrailer4,none"
  },
  [160699] = {
    id = 160699,
    EP = 2,
    Effect = "Skill/Chepet_FlameCircleTrailer3,none"
  },
  [160700] = {
    id = 160700,
    EP = 2,
    Effect = "Skill/Chepet_FlameCircleTrailer2,none"
  },
  [160701] = {
    id = 160701,
    EP = 2,
    Effect = "Skill/Chepet_FlameCircleTrailer1,none"
  },
  [160720] = {
    id = 160720,
    EP = 2,
    Effect = "Skill/IceSnowOde,none"
  },
  [160930] = {
    id = 160930,
    EP = 0,
    Effect_start = "Skill/MagicDevour_atk,none"
  },
  [161010] = {
    id = 161010,
    EP = 0,
    Effect_start = "Skill/EleDefence_Land_buff,none"
  },
  [161020] = {
    id = 161020,
    EP = 0,
    Effect_start = "Skill/EleDefence_Death,none"
  },
  [161030] = {
    id = 161030,
    EP = 0,
    Effect_start = "Skill/MonsterReflex_buff,none"
  },
  [161090] = {
    id = 161090,
    EP = 3,
    Effect = "Skill/BreakArmor_hit,none"
  },
  [161111] = {
    id = 161111,
    EP = 2,
    Effect_start = "Skill/Thunderstorm,none",
    SE_start = "Skill/Thunderstorm_attack"
  },
  [161230] = {
    id = 161230,
    EP = 3,
    Effect = "Skill/DemonKing_Invincible,none"
  },
  [161250] = {
    id = 161250,
    EP = 2,
    Effect = "Skill/Cardroom_fire,none"
  },
  [161266] = {
    id = 161266,
    EP = 0,
    Effect = "Skill/Eff_Lina_Sandstorm_floor"
  },
  [161267] = {
    id = 161267,
    EP = 0,
    Effect = "Skill/Chepet_FlameCircleTrailer2_red"
  },
  [161281] = {
    id = 161281,
    EP = 3,
    Effect = "Skill/ELEBallWater",
    EffectScale = 6
  },
  [161285] = {
    id = 161285,
    EP = 2,
    Effect = "Skill/sfx_armyturtle_waterpolo_sing_prf"
  },
  [161300] = {
    id = 161300,
    EP = 0,
    Effect = "Skill/TheFireBurning_buff,none"
  },
  [161310] = {
    id = 161310,
    EP = 0,
    Effect = "Skill/BurningImprint_buff,none"
  },
  [161320] = {
    id = 161320,
    EP = 3,
    Effect = "Skill/InsurgencyFlame_buff,none"
  },
  [161330] = {
    id = 161330,
    EP = 2,
    Effect = "Skill/FirePrison_buff,none"
  },
  [161341] = {
    id = 161341,
    EP = 3,
    Effect = "Skill/BoliBlessing_buff,none"
  },
  [161350] = {
    id = 161350,
    EP = 1,
    Effect = "Skill/ToLove_buff,none"
  },
  [161370] = {
    id = 161370,
    EP = 3,
    Effect_start = "Skill/MagicBreak,none"
  },
  [161490] = {
    id = 161490,
    EP = 2,
    Effect = "Skill/FireEject_buff,none"
  },
  [161670] = {
    id = 161670,
    EP = 0,
    Effect = "Skill/GuardRing_buff,none"
  },
  [161690] = {
    id = 161690,
    EP = 0,
    Effect = "Skill/Hurricane_buff,none"
  },
  [161701] = {
    id = 161701,
    EP = 0,
    Effect = "Skill/FireCow_buff,none"
  },
  [161710] = {
    id = 161710,
    EP = 1,
    Effect = "Skill/Blowout_buff,none"
  },
  [161711] = {
    id = 161711,
    EP = 3,
    Effect_start = "Skill/Blowout_buff,none"
  },
  [161720] = {
    id = 161720,
    EP = 1,
    Effect = "Skill/DoomSeed_buff,none"
  },
  [161730] = {
    id = 161730,
    EP = 2,
    Effect = "Skill/Chivalry_buff,none"
  },
  [161732] = {
    id = 161732,
    EP = 3,
    Effect = "Skill/MetalArmor_buff,none"
  },
  [161750] = {
    id = 161750,
    EP = 0,
    Effect = "Skill/BloodyPlague_buff,none"
  },
  [161753] = {
    id = 161753,
    EP = 0,
    Effect = "Skill/BloodThirsty_buff,none"
  },
  [161761] = {
    id = 161761,
    EP = 3,
    Effect = "Skill/Wolves_buff,none"
  },
  [161763] = {
    id = 161763,
    EP = 0,
    Effect = "Skill/OldWolf_buff,none"
  },
  [161770] = {
    id = 161770,
    EP = 0,
    Effect = "Skill/BloodFlow_buff,none"
  },
  [161780] = {
    id = 161780,
    EP = 3,
    Effect = "Skill/GuardOfMoon_buff,none"
  },
  [161790] = {
    id = 161790,
    EP = 3,
    Effect = "Skill/GuardOfLight_buff,none"
  },
  [161800] = {
    id = 161800,
    EP = 0,
    Effect = "Skill/MoonSlave_buff,none"
  },
  [161820] = {
    id = 161820,
    EP = 0,
    Effect = "Skill/LunarEclipse_buff,none"
  },
  [161830] = {
    id = 161830,
    EP = 0,
    Effect = "Skill/FullMoon_buff,none"
  },
  [161840] = {
    id = 161840,
    EP = 0,
    Effect = "Skill/Mefractioon_buff,none"
  },
  [162110] = {
    id = 162110,
    EP = 3,
    Effect = "Skill/FrozenZone_buff2,none"
  },
  [162120] = {
    id = 162120,
    EP = 3,
    Effect = "Skill/FlameLand_buff2,none"
  },
  [162130] = {
    id = 162130,
    EP = 3,
    Effect = "Skill/Spines_buff2,none"
  },
  [162140] = {
    id = 162140,
    EP = 0,
    Effect_start = "Skill/DragonHowl_buff"
  },
  [162150] = {
    id = 162150,
    EP = 0,
    Effect = "Skill/AngleOffer_buff,none"
  },
  [162160] = {
    id = 162160,
    EP = 1,
    Effect = "Skill/BoothMark_buff,none"
  },
  [162430] = {
    id = 162430,
    EP = 0,
    Effect = "Common/Boss_soul,none"
  },
  [162480] = {
    id = 162480,
    EP = 0,
    Effect = "Common/BossTrack_soul,none"
  },
  [162491] = {
    id = 162491,
    EP = 0,
    Effect = "Skill/Cardroom_Methane_001"
  },
  [162640] = {
    id = 162640,
    EP = 0,
    Effect = "Skill/Absorbed_buff,none"
  },
  [162680] = {
    id = 162680,
    EP = 3,
    Effect = "Skill/BloodLust_buff,none"
  },
  [162740] = {
    id = 162740,
    EP = 0,
    Effect = "Skill/Cardroom_Meteorite_yujing_loop,none"
  },
  [162780] = {
    id = 162780,
    EP = 3,
    Effect = "Skill/MercyHeart_buff2,none"
  },
  [162800] = {
    id = 162800,
    EP = 3,
    Effect = "Skill/SwordBursting_buff,none"
  },
  [162820] = {
    id = 162820,
    EP = 1,
    Effect = "Skill/FlameSign_buff,none"
  },
  [162840] = {
    id = 162840,
    EP = 3,
    Effect = "Skill/CardBoss_A,none"
  },
  [162856] = {
    id = 162856,
    EP = 3,
    Effect_start = "Common/BeCrystal"
  },
  [162857] = {
    id = 162857,
    EP = 3,
    Effect = "Common/BeCrystal_buff"
  },
  [162871] = {
    id = 162871,
    EP = 3,
    Effect = "Common/CrystalShield_wait"
  },
  [162876] = {
    id = 162876,
    EP = 2,
    Effect = "Skill/Chepet_FlameCircleTrailer2_red"
  },
  [162877] = {
    id = 162877,
    EP = 2,
    Effect = "Skill/Chepet_FlameCircleTrailer2_blue"
  },
  [163020] = {
    id = 163020,
    EP = 0,
    Effect = "Skill/PlayThunder_buff,none"
  },
  [163021] = {
    id = 163021,
    EP = 1,
    Effect = "Skill/EleImprinting_buff,none"
  },
  [163100] = {
    id = 163100,
    EP = 0,
    Effect_start = "Skill/ReleaseTheSword,none"
  },
  [163170] = {
    id = 163170,
    EP = 3,
    Effect = "Skill/CrazyFlame_buff2,none"
  },
  [163200] = {
    id = 163200,
    EP = 3,
    Effect = "Skill/ValhallaShield_buff2,none"
  },
  [163254] = {
    id = 163254,
    EP = 3,
    Effect_start = "Skill/CharmWave_hit"
  },
  [163260] = {
    id = 163260,
    EP = 3,
    Effect = "Skill/BoliAtk_huge"
  },
  [163270] = {
    id = 163270,
    EP = 0,
    Effect = "Skill/OrruneTrap_buff"
  },
  [163300] = {
    id = 163300,
    EP = 2,
    Effect = "Common/Eff_Gravitational_buff"
  },
  [163301] = {
    id = 163301,
    EP = 2,
    Effect_start = "Skill/Eff_ArcanCut_atk"
  },
  [163320] = {
    id = 163320,
    EP = 0,
    Effect = "Skill/ArcaneLight"
  },
  [163330] = {
    id = 163330,
    EP = 0,
    Effect = "Skill/ElightMatrix"
  },
  [163350] = {
    id = 163350,
    EP = 3,
    Effect = "Skill/Eff_Orrune_Shield"
  },
  [163352] = {
    id = 163352,
    EP = 0,
    Effect = "Skill/Eff_ArcanCut_buff"
  },
  [163353] = {
    id = 163353,
    EP = 2,
    Effect = "Skill/eff_sairen_buff"
  },
  [163363] = {
    id = 163363,
    EP = 1,
    Effect = "Skill/ArcaneKey_02_head"
  },
  [163420] = {
    id = 163420,
    EP = 1,
    Effect = "Skill/FavorAdjustment_buff"
  },
  [163510] = {
    id = 163510,
    EP = 3,
    Effect = "Skill/BeeTwine_buff"
  },
  [163580] = {
    id = 163580,
    EP = 1,
    Effect = "Skill/ArcanCut_target"
  },
  [163590] = {
    id = 163590,
    EP = 2,
    Effect = "Common/DarkNPCFoot,none"
  },
  [163591] = {
    id = 163591,
    EP = 0,
    Effect = "Common/Darkflame,none"
  },
  [163600] = {
    id = 163600,
    EP = 3,
    Effect_start = "Skill/DestoryMyself_hit"
  },
  [163660] = {
    id = 163660,
    EP = 0,
    Effect_start = "Skill/Eff_Detale_fanghuzhao_buff,none"
  },
  [163690] = {
    id = 163690,
    EP = 0,
    Effect = "Skill/Eff_Petit_fanghuzhao_buff,none"
  },
  [163730] = {
    id = 163730,
    EP = 0,
    Effect = "Skill/Eff_Specialre_laolong_atk"
  },
  [163735] = {
    id = 163735,
    EP = 1,
    Effect = "Skill/Eff_specialre_jiejie_hit"
  },
  [163770] = {
    id = 163770,
    EP = 0,
    Effect = "Skill/Eff_Specialre_jiejie_buff"
  },
  [164007] = {
    id = 164007,
    EP = 2,
    Effect = "Skill/Eff_beiaiguanghuan_buff01"
  },
  [164018] = {
    id = 164018,
    EP = 2,
    Effect = "Skill/Eff_kunaoguanghuan_buff01"
  },
  [164050] = {
    id = 164050,
    EP = 1,
    Effect = "Skill/Eff_shouhufanqiu_buff"
  },
  [164091] = {
    id = 164091,
    EP = 0,
    Effect = "Skill/Eff_beiaiguanghuan_buff02"
  },
  [164093] = {
    id = 164093,
    EP = 0,
    Effect = "Skill/Eff_kunaoguanghuan_buff02"
  },
  [164101] = {
    id = 164101,
    EP = 2,
    Effect = "Skill/Eff_kunaozhihun_hit"
  },
  [164102] = {
    id = 164102,
    EP = 1,
    Effect = "Skill/Eff_kunaozhihun_buff"
  },
  [164103] = {
    id = 164103,
    EP = 0,
    Effect = "Skill/Eff_kunaozhihun_buff02"
  },
  [164104] = {
    id = 164104,
    EP = 2,
    Effect = "Skill/Mefractioon_buff_mijing_Secret01"
  },
  [164105] = {
    id = 164105,
    EP = 2,
    Effect = "Skill/Mefractioon_buff_mijing_Secret02"
  },
  [164110] = {
    id = 164110,
    EP = 7,
    Effect = "Skill/Eff_tuanben03_BossBody"
  },
  [164301] = {
    id = 164301,
    EP = 1,
    Effect = "Skill/Eff_FlameShock02,none",
    Effect_end = "Skill/FlameShock_Boom,none",
    SE_end = "Skill/FlameShock_boom"
  },
  [164310] = {
    id = 164310,
    EP = 0,
    Effect = "Skill/Eff_Frozen02,none",
    Effect_end = "Skill/FrozenBroken,none",
    SE_start = "Skill/StoneCurse",
    SE_end = "Common/Frozen_explosion"
  },
  [164320] = {
    id = 164320,
    EP = 5,
    Effect = "Skill/Eff_FlameShock_Buff02,none"
  },
  [164512] = {
    id = 164512,
    EP = 2,
    Effect = "Skill/Eff_emengchuanran_hit"
  },
  [164513] = {
    id = 164513,
    EP = 1,
    Effect = "Skill/Eff_emengchuanran_buff02"
  },
  [164514] = {
    id = 164514,
    EP = 0,
    Effect = "Skill/Eff_emengchuanran_buff01"
  },
  [164530] = {
    id = 164530,
    EP = 2,
    Effect = "Skill/Eff_emeng_01"
  },
  [164580] = {
    id = 164580,
    EP = 2,
    Effect = "Skill/Eff_emengxianjing_buff"
  },
  [164582] = {
    id = 164582,
    EP = 2,
    Effect = "Skill/Eff_emengxianjing_atk"
  },
  [164590] = {
    id = 164590,
    EP = 2,
    Effect = "Skill/Eff_mojianshifang"
  },
  [164600] = {
    id = 164600,
    EP = 2,
    Effect = "Skill/Eff_mengyanhongzha_buff"
  },
  [164602] = {
    id = 164602,
    EP = 2,
    Effect = "Skill/Eff_mengyanhongzha_atk"
  },
  [164626] = {
    id = 164626,
    EP = 0,
    Effect = "Skill/Eff_kuangluanzhi_Crit"
  },
  [164680] = {
    id = 164680,
    EP = 1,
    Effect = "Skill/Eff_emengzhizhong_buff"
  },
  [164681] = {
    id = 164681,
    EP = 2,
    Effect = "Skill/Eff_qingxingbaozhu_buff"
  },
  [164682] = {
    id = 164682,
    EP = 2,
    Effect = "Skill/Eff_juewang_bao"
  },
  [164683] = {
    id = 164683,
    EP = 2,
    Effect = "Skill/Eff_mengyanzhizhu_ruquan"
  },
  [164684] = {
    id = 164684,
    EP = 0,
    Effect = "Skill/Eff_tuanben3_dihuo"
  },
  [164685] = {
    id = 164685,
    EP = 0,
    Effect = "Skill/Eff_tuanben3_fazhen"
  },
  [164686] = {
    id = 164686,
    EP = 2,
    Effect = "Skill/Eff_kaichang_buff"
  },
  [164687] = {
    id = 164687,
    EP = 2,
    Effect = "Skill/Eff_tuanben3_shifang"
  },
  [164710] = {
    id = 164710,
    EP = 0,
    Effect = "Skill/Eff_kuangluanzhi_Crit"
  },
  [164730] = {
    id = 164730,
    EP = 2,
    Effect = "Skill/Eff_tuanben3_fazhen"
  },
  [164731] = {
    id = 164731,
    EP = 3,
    Effect = "Skill/Eff_tuanben3_xiersu01"
  },
  [164732] = {
    id = 164732,
    EP = 2,
    Effect = "Skill/Eff_tuanben3_xiersu02"
  },
  [164733] = {
    id = 164733,
    EP = 2,
    Effect = "Skill/Eff_KneelDown_hit"
  },
  [164734] = {
    id = 164734,
    EP = 3,
    Effect = "Skill/Eff_Thame_siwang"
  },
  [164850] = {
    id = 164850,
    EP = 0,
    Effect = "Skill/NightmareClaw_hit"
  },
  [164851] = {
    id = 164851,
    EP = 2,
    Effect = "Skill/NightmareClaw_buff01"
  },
  [164852] = {
    id = 164852,
    EP = 2,
    Effect = "Skill/NightmareClaw_buff02"
  },
  [164875] = {
    id = 164875,
    EP = 0,
    Effect = "Skill/DecelerationZone_buff"
  },
  [165030] = {
    id = 165030,
    EP = 0,
    Effect = "Skill/Eff_laolong_goddess"
  },
  [165032] = {
    id = 165032,
    EP = 1,
    Effect = "Skill/Eff_laolong_goddess_buff"
  },
  [165290] = {
    id = 165290,
    EP = 2,
    Effect = "Skill/Eff_tuanben3_baohuzhao"
  },
  [165500] = {
    id = 165500,
    EP = 2,
    Effect = "Skill/Eff_gules6x6_Secret"
  },
  [165503] = {
    id = 165503,
    EP = 2,
    Effect = "Skill/Eff_gules8x8_buff_Secret"
  },
  [165504] = {
    id = 165504,
    EP = 2,
    Effect = "Skill/Eff_gules8x8_atk_Secret"
  },
  [165509] = {
    id = 165509,
    EP = 2,
    Effect = "Skill/Eff_green3_buff_Secret"
  },
  [165514] = {
    id = 165514,
    EP = 2,
    Effect = "Skill/Eff_gules24_buff_Secret"
  },
  [165515] = {
    id = 165515,
    EP = 2,
    Effect = "Skill/Eff_gules24_atk_Secret"
  },
  [165517] = {
    id = 165517,
    EP = 2,
    Effect = "Skill/Eff_violet4_buff_Secret"
  },
  [165552] = {
    id = 165552,
    EP = 1,
    Effect = "Skill/Eff_taluopai_ningshi_buff"
  },
  [165774] = {
    id = 165774,
    EP = 0,
    Effect = "Skill/Eff_MonomerDamage_mijing"
  },
  [165775] = {
    id = 165775,
    EP = 0,
    Effect = "Skill/eff_FlameWeb_mijing"
  },
  [165776] = {
    id = 165776,
    EP = 0,
    Effect = "Skill/Eff_magicDevour_mijing"
  },
  [165777] = {
    id = 165777,
    EP = 0,
    Effect = "Skill/eff_Requiem_mijing"
  },
  [165778] = {
    id = 165778,
    EP = 2,
    Effect = "Skill/Mefractioon_buff_mijing"
  },
  [165779] = {
    id = 165779,
    EP = 2,
    Effect = "Skill/Mefractioon_buff_mijing02"
  },
  [165780] = {
    id = 165780,
    EP = 3,
    Effect = "Skill/Eff_Asphyxia_buff_mijing"
  },
  [165781] = {
    id = 165781,
    EP = 3,
    Effect = "Skill/FalconEyes_Buff_mijing"
  },
  [165782] = {
    id = 165782,
    EP = 0,
    Effect = "Skill/eff_Vampiring_mijing"
  },
  [165783] = {
    id = 165783,
    EP = 1,
    Effect = "Skill/Eff_yggdrasilberry"
  },
  [165784] = {
    id = 165784,
    EP = 3,
    Effect = "Skill/Eff_MagicRiot_mijing"
  },
  [165785] = {
    id = 165785,
    EP = 0,
    Effect = "Skill/eff_Storming_eye_mijing"
  },
  [165786] = {
    id = 165786,
    EP = 0,
    Effect = "Skill/eff_MartyrsReckoning_mijing"
  },
  [165787] = {
    id = 165787,
    EP = 0,
    Effect = "Skill/eff_FrozenZone_mijing"
  },
  [165788] = {
    id = 165788,
    EP = 0,
    Effect = "Skill/eff_Pogonip_mijing"
  },
  [165789] = {
    id = 165789,
    EP = 1,
    Effect = "Skill/Eff_Humming_mijing"
  },
  [165791] = {
    id = 165791,
    EP = 2,
    Effect = "Skill/HeartOfSteel_buff"
  },
  [165792] = {
    id = 165792,
    EP = 2,
    Effect = "Skill/NatureLoop_buff2_mijing"
  },
  [165793] = {
    id = 165793,
    EP = 2,
    Effect = "Skill/Root_buff"
  },
  [165794] = {
    id = 165794,
    EP = 2,
    Effect = "Skill/eff_blood_mijing"
  },
  [165911] = {
    id = 165911,
    EP = 2,
    Effect = "Skill/Eff_BackTime_buff_mijing"
  },
  [165990] = {
    id = 165990,
    EP = 3,
    Effect = "Skill/DemonKing_Invincible,none"
  },
  [166300] = {
    id = 166300,
    EP = 2,
    Effect = "Skill/Osiris_BandageBandage_buff"
  },
  [166350] = {
    id = 166350,
    EP = 2,
    Effect = "Skill/Mummy_PoisonFog_buff"
  },
  [166360] = {
    id = 166360,
    EP = 2,
    Effect = "Skill/Time_TimeBomb_buff"
  },
  [166370] = {
    id = 166370,
    EP = 2,
    Effect = "Skill/Time_OpenBoundary_buff,none"
  },
  [166612] = {
    id = 166612,
    EP = 1,
    Effect = "Skill/Eff_StarsStars_buff"
  },
  [166613] = {
    id = 166613,
    EP = 1,
    Effect = "Skill/Eff_taluopai_jianban_buff"
  },
  [166614] = {
    id = 166614,
    EP = 1,
    Effect = "Skill/Eff_UnableAttack_buff"
  },
  [166617] = {
    id = 166617,
    EP = 3,
    Effect = "Skill/Eff_taluopai_04"
  },
  [171001] = {
    id = 171001,
    EP = 3,
    Effect = "Skill/Trick_tower_LV2,none"
  },
  [171011] = {
    id = 171011,
    EP = 3,
    Effect = "Skill/Trick_tower_LV3,none"
  },
  [171020] = {
    id = 171020,
    EP = 3,
    Effect = "Skill/Trick_tower_LV4,none"
  },
  [171101] = {
    id = 171101,
    EP = 3,
    Effect = "Skill/Violent_tower_LV2,none"
  },
  [171112] = {
    id = 171112,
    EP = 3,
    Effect = "Skill/Violent_tower_LV3,none"
  },
  [171120] = {
    id = 171120,
    EP = 3,
    Effect = "Skill/Violent_tower_LV4,none"
  },
  [171201] = {
    id = 171201,
    EP = 3,
    Effect = "Skill/Cruel_tower_LV2,none"
  },
  [171211] = {
    id = 171211,
    EP = 0,
    Effect = "Common/DefensiveField_buff,none"
  },
  [171213] = {
    id = 171213,
    EP = 3,
    Effect = "Skill/Cruel_tower_LV3,none"
  },
  [171220] = {
    id = 171220,
    EP = 3,
    Effect = "Skill/Cruel_tower_LV4,none"
  },
  [171320] = {
    id = 171320,
    EP = 0,
    Effect = "Common/TreatmentGuardian_buff,none"
  },
  [173010] = {
    id = 173010,
    EP = 2,
    Effect = "Skill/Eff_PrayRain"
  },
  [173040] = {
    id = 173040,
    EP = 0,
    Effect = "Skill/Eff_Flash"
  },
  [173071] = {
    id = 173071,
    EP = 2,
    Effect_start = "Skill/Eff_Gravitational_atk_9"
  },
  [173080] = {
    id = 173080,
    EP = 2,
    Effect = "Skill/Eff_Clays"
  },
  [173101] = {
    id = 173101,
    EP = 0,
    Effect_start = "Skill/Eff_Detonation"
  },
  [173140] = {
    id = 173140,
    EP = 2,
    Effect = "Skill/Eff_InnerRing"
  },
  [173142] = {
    id = 173142,
    EP = 2,
    Effect = "Skill/Eff_Central"
  },
  [173144] = {
    id = 173144,
    EP = 2,
    Effect = "Skill/Eff_OuterRing"
  },
  [173191] = {
    id = 173191,
    EP = 2,
    Effect = "Skill/BloodyPlague_buff"
  },
  [173250] = {
    id = 173250,
    EP = 2,
    Effect = "Skill/Eff_FengPiao"
  },
  [173290] = {
    id = 173290,
    EP = 0,
    Effect = "Skill/Eff_FireRing"
  },
  [173320] = {
    id = 173320,
    EP = 0,
    Effect = "Skill/Eff_IceRing"
  },
  [173350] = {
    id = 173350,
    EP = 0,
    Effect = "Skill/Fearless_buff"
  },
  [173500] = {
    id = 173500,
    EP = 2,
    Effect = "Skill/Bloody_Assault_buff,none"
  },
  [173510] = {
    id = 173510,
    Logic = Table_BuffState_bk_t.Logic[6],
    EP = 2,
    Effect = "Common/Around,none",
    Effect_around = "Skill/Bloody_BloodInfection,none"
  },
  [173520] = {
    id = 173520,
    EP = 2,
    Effect_start = "Skill/Bloody_Outbreak_hit02"
  },
  [173521] = {
    id = 173521,
    EP = 2,
    Effect_start = "Skill/Bloody_Outbreak_hit"
  },
  [173535] = {
    id = 173535,
    EP = 2,
    Effect = "Skill/Bloody_Coagulation_buff,none"
  },
  [173560] = {
    id = 173560,
    EP = 2,
    Effect = "Skill/Goblin_ImmuneShield_buff"
  },
  [173561] = {
    id = 173561,
    EP = 3,
    Effect = "Skill/sfx_goblin_ImmuneShield_buff_prf"
  },
  [173570] = {
    id = 173570,
    EP = 2,
    Effect = "Skill/Goblin_ImmuneShield_buff02"
  },
  [173571] = {
    id = 173571,
    EP = 3,
    Effect = "Skill/sfx_goblin_ImmuneShield_buff02_prf"
  },
  [173670] = {
    id = 173670,
    EP = 1,
    Effect = "Skill/Eff_KingPoison_buff01,none"
  },
  [173680] = {
    id = 173680,
    EP = 1,
    Effect = "Skill/Eff_KingPoison_buff02,none"
  },
  [173690] = {
    id = 173690,
    EP = 1,
    Effect = "Skill/Eff_KingPoison_buff03,none"
  },
  [173692] = {
    id = 173692,
    EP = 1,
    Effect = "Skill/Eff_KingPoisonTop_buff,none"
  },
  [173740] = {
    id = 173740,
    Logic = Table_BuffState_bk_t.Logic[4],
    EP = 3,
    Effect = "Common/Around,none",
    Effect_around = "Skill/Eff_IceBreak_buff,none"
  },
  [173750] = {
    id = 173750,
    EP = 3,
    Effect = "Skill/Eff_FrostArmor_buff,none"
  },
  [173770] = {
    id = 173770,
    EP = 3,
    Effect = "Skill/Eff_SharkArmor_buff,none"
  },
  [173820] = {
    id = 173820,
    EP = 3,
    Effect = "Skill/Eff_shuilao,none"
  },
  [173830] = {
    id = 173830,
    EP = 0,
    Effect = "Skill/Eff_LceFireRain,none"
  },
  [173850] = {
    id = 173850,
    EP = 2,
    Effect = "Skill/Eff_shugenchaorao,none"
  },
  [173890] = {
    id = 173890,
    EP = 0,
    Effect = "Skill/Osiris_VenomDust_atk_R4,none"
  },
  [173894] = {
    id = 173894,
    EP = 0,
    Effect = "Skill/CrimsonRock_DM"
  },
  [173898] = {
    id = 173898,
    EP = 0,
    Effect = "Skill/StormGust_DM,none"
  },
  [173910] = {
    id = 173910,
    EP = 3,
    Effect = "Skill/Eff_longzuxuetong_buff"
  },
  [173940] = {
    id = 173940,
    EP = 3,
    Effect = "Skill/Eff_cangtianlongxue_buff"
  },
  [173941] = {
    id = 173941,
    EP = 0,
    Effect = "Skill/Eff_cangtianlongxue_hit"
  },
  [173942] = {
    id = 173942,
    EP = 0,
    Effect = "Skill/Eff_cangtianlongxue_buff2"
  },
  [173946] = {
    id = 173946,
    EP = 3,
    Effect = "Skill/Eff_cangtianlongxue_atk"
  },
  [173950] = {
    id = 173950,
    EP = 1,
    Effect = "Skill/Eff_julongshixian_buff02"
  },
  [173951] = {
    id = 173951,
    EP = 1,
    Effect = "Skill/Eff_julongshixian_buff01"
  },
  [173953] = {
    id = 173953,
    EP = 3,
    Effect = "Skill/Eff_DragonBones_hit"
  },
  [173990] = {
    id = 173990,
    EP = 3,
    Effect = "Skill/Eff_anselong_buff"
  },
  [174000] = {
    id = 174000,
    EP = 3,
    Effect = "Skill/Eff_baonuelong_buff"
  },
  [174001] = {
    id = 174001,
    EP = 3,
    Effect = "Skill/Eff_youlong_buff"
  },
  [174070] = {
    id = 174070,
    EP = 0,
    Effect = "Skill/Eff_MapleLeaves,none"
  },
  [174100] = {
    id = 174100,
    EP = 0,
    Effect = "Skill/Dragon_WithSnow"
  },
  [174140] = {
    id = 174140,
    EP = 2,
    Effect = "Skill/Dragon_Clock"
  },
  [174200] = {
    id = 174200,
    EP = 3,
    Effect = "Skill/Dragon_SelfDestruct_buff"
  },
  [174210] = {
    id = 174210,
    EP = 1,
    Effect = "Skill/Dragon_ButterflyStorm_buff"
  },
  [174320] = {
    id = 174320,
    EP = 2,
    Effect = "Skill/Dragon_Harden"
  },
  [174370] = {
    id = 174370,
    EP = 3,
    Effect = "Skill/Samurai_WarriorFire_buff"
  },
  [174380] = {
    id = 174380,
    EP = 3,
    Effect = "Skill/Samurai_WarriorWater_buff"
  },
  [174390] = {
    id = 174390,
    EP = 1,
    Effect = "Skill/Samurai_contract_buff"
  },
  [174400] = {
    id = 174400,
    EP = 2,
    Effect = "Skill/Samurai_WarriorWaterDea_buff"
  },
  [174410] = {
    id = 174410,
    EP = 2,
    Effect = "Skill/Samurai_WarriorFireDea_buff"
  },
  [174420] = {
    id = 174420,
    EP = 1,
    Effect = "Skill/Samurai_SamuraiGrudge_hit"
  },
  [174430] = {
    id = 174430,
    EP = 1,
    Effect = "Skill/Samurai_contract_buff"
  },
  [174440] = {
    id = 174440,
    EP = 1,
    Effect = "Skill/Samurai_Resurrection_buff"
  },
  [174450] = {
    id = 174450,
    EP = 1,
    Effect = "Skill/Samurai_IncreaseSpeed_buff"
  },
  [174600] = {
    id = 174600,
    EP = 6,
    Effect = "Skill/Kafra1up_buff,none"
  },
  [174610] = {
    id = 174610,
    EP = 0,
    Effect = "Skill/Task_GoddessTears2"
  },
  [174740] = {
    id = 174740,
    EP = 0,
    Effect = "Skill/Eff_codragon_gale_buff_xy"
  },
  [174742] = {
    id = 174742,
    EP = 0,
    Effect_start = "Skill/Eff_codragon_gale_hit_xy"
  },
  [174793] = {
    id = 174793,
    EP = 3,
    Effect = "Skill/Eff_codragon_halo_buff_xy"
  },
  [174795] = {
    id = 174795,
    EP = 0,
    Effect = "Skill/Eff_codragon_gale_floor_xy"
  },
  [174804] = {
    id = 174804,
    EP = 0,
    Effect = "Skill/Eff_shugenchaorao"
  },
  [174805] = {
    id = 174805,
    EP = 1,
    Effect = "Skill/Veto_buff,none"
  },
  [174824] = {
    id = 174824,
    EP = 3,
    Effect = "Skill/DisneyMVP_waike_buff"
  },
  [174825] = {
    id = 174825,
    EP = 3,
    Effect = "Skill/DisneyMVP_lansenianye_buff"
  },
  [174826] = {
    id = 174826,
    EP = 1,
    Effect = "Skill/DisneyMVP_baoshi_buff"
  },
  [174827] = {
    id = 174827,
    EP = 2,
    Effect = "Skill/Dark_Illusion_yazhi"
  },
  [174836] = {
    id = 174836,
    EP = 2,
    Effect = "Skill/DisneyMVP_baoshi_atk"
  },
  [174844] = {
    id = 174844,
    EP = 1,
    Effect = "Skill/Dark_Illusion_huimie_buff"
  },
  [174855] = {
    id = 174855,
    EP = 0,
    Effect = "Skill/Orc_Lord_shuxing_buff"
  },
  [174859] = {
    id = 174859,
    EP = 3,
    Effect = "Skill/DisneyMVP_mozhi_buff"
  },
  [174900] = {
    id = 174900,
    EP = 0,
    Effect = "Skill/DecreaseAGI"
  },
  [174902] = {
    id = 174902,
    EP = 2,
    Effect = "Skill/sfx_cw_bf_buff_prf"
  },
  [174904] = {
    id = 174904,
    EP = 2,
    Effect = "Skill/Eff_08Toys_blast"
  },
  [174930] = {
    id = 174930,
    EP = 0,
    Effect = "Skill/sfx_MVPmini_swine_buff,none",
    EffectScale = 2.5
  },
  [174940] = {
    id = 174940,
    EP = 2,
    Effect = "Skill/sfx_MVPmini_eagle_hit,none"
  },
  [174942] = {
    id = 174942,
    EP = 2,
    Effect = "Skill/sfx_MVPmini_butterfly_buff,none"
  },
  [174954] = {
    id = 174954,
    EP = 2,
    Effect = "Skill/sf_Lady_kl_buff_prf,none"
  },
  [174980] = {
    id = 174980,
    EP = 2,
    Effect = "Skill/sf_Yoyo_yj_buff_prf,none"
  },
  [175000] = {
    id = 175000,
    EP = 2,
    Effect = "Skill/Eff_MVP2_wange_buff,none"
  },
  [175001] = {
    id = 175001,
    EP = 2,
    Effect = "Skill/Eff_MVP2_wange_buff,none",
    EffectScale = 0.57
  },
  [175030] = {
    id = 175030,
    EP = 2,
    Effect = "Skill/Eff_MVP2_Soul_buff,none"
  },
  [175040] = {
    id = 175040,
    EP = 1,
    Effect = "Skill/Eff_MVP2_sharen_buff01,none"
  },
  [175041] = {
    id = 175041,
    EP = 1,
    Effect = "Skill/Eff_MVP2_sharen_buff02,none"
  },
  [175042] = {
    id = 175042,
    EP = 1,
    Effect = "Skill/Eff_MVP2_sharen_buff03,none"
  },
  [175043] = {
    id = 175043,
    EP = 1,
    Effect = "Skill/Eff_MVP2_sharen_buff04,none"
  },
  [175044] = {
    id = 175044,
    EP = 1,
    Effect = "Skill/Eff_MVP2_sharen_buff05,none"
  },
  [175045] = {
    id = 175045,
    EP = 1,
    Effect = "Skill/Eff_MVP2_sharen_buff06,none"
  },
  [175046] = {
    id = 175046,
    EP = 1,
    Effect = "Skill/Eff_MVP2_sharen_buff07,none"
  },
  [175047] = {
    id = 175047,
    EP = 1,
    Effect = "Skill/Eff_MVP2_sharen_buff08,none"
  },
  [175048] = {
    id = 175048,
    EP = 1,
    Effect = "Skill/Eff_MVP2_sharen_buff09,none"
  },
  [175049] = {
    id = 175049,
    EP = 1,
    Effect = "Skill/Eff_MVP2_sharen_buff10,none"
  },
  [175071] = {
    id = 175071,
    EP = 3,
    Effect = "Skill/Eff_MVP2_shujing_buff,none"
  },
  [175080] = {
    id = 175080,
    EP = 2,
    Effect = "Skill/Eff_MVP2_kouxue_buff,none"
  },
  [175090] = {
    id = 175090,
    EP = 3,
    Effect = "Skill/Eff_MVP2_zhongzi_buff,none"
  },
  [175100] = {
    id = 175100,
    EP = 2,
    Effect = "Skill/Eff_MVP2_shujieshu_buff01,none"
  },
  [175110] = {
    id = 175110,
    EP = 2,
    Effect = "Skill/Eff_MVP2_shujieshu_buff02,none"
  },
  [175130] = {
    id = 175130,
    EP = 2,
    Effect = "Skill/Eff_MVP2_zhong_buff02,none"
  },
  [175140] = {
    id = 175140,
    EP = 3,
    Effect = "Skill/Eff_MVP2_green_buff,none"
  },
  [175150] = {
    id = 175150,
    EP = 3,
    Effect = "Skill/Eff_MVP2_blue_buff,none"
  },
  [175160] = {
    id = 175160,
    EP = 3,
    Effect = "Skill/Eff_MVP2_red_buff,none"
  },
  [175170] = {
    id = 175170,
    EP = 2,
    Effect = "Skill/Eff_Boss2_yanlingyu_buff,none"
  },
  [175180] = {
    id = 175180,
    EP = 2,
    Effect = "Skill/Eff_Boss2_huoyan_buff,none"
  },
  [175181] = {
    id = 175181,
    EP = 2,
    Effect = "Skill/Eff_Boss2_hanleng_buff,none"
  },
  [175191] = {
    id = 175191,
    EP = 3,
    Effect = "Skill/Eff_Thame_heihuo,none"
  },
  [175210] = {
    id = 175210,
    EP = 2,
    Effect = "Skill/StormGust,none"
  },
  [175220] = {
    id = 175220,
    EP = 2,
    Effect = "Skill/Eff_Boss2_binglao_buff,none"
  },
  [175270] = {
    id = 175270,
    EP = 3,
    Effect = "Skill/Eff_MVP2_suolian_buff,none"
  },
  [175431] = {
    id = 175431,
    EP = 1,
    Effect = "Skill/Kafra6up_buff",
    EffectScale = 2
  },
  [175451] = {
    id = 175451,
    EP = 2,
    Effect = "Skill/OldWolf_buff"
  },
  [175480] = {
    id = 175480,
    EP = 3,
    Effect = "Skill/Dragon_Harden",
    EffectScale = 4
  },
  [175501] = {
    id = 175501,
    EP = 0,
    Effect = "Skill/Eff_beiaiguanghuan_buff01"
  },
  [175508] = {
    id = 175508,
    EP = 5,
    Effect = "Skill/WolfAssault_attack_02"
  },
  [175509] = {
    id = 175509,
    EP = 0,
    Effect = "Skill/Goddess_buff02"
  },
  [175520] = {
    id = 175520,
    EP = 1,
    Effect = "Skill/SunconterATK_buff"
  },
  [175700] = {
    id = 175700,
    EP = 0,
    Effect = "Skill/Chepet_FlameCircleTrailer2_red"
  },
  [175702] = {
    id = 175702,
    EP = 0,
    Effect = "Skill/Chepet_FlameCircleTrailer2_red",
    EffectScale = 2
  },
  [175730] = {
    id = 175730,
    EP = 0,
    Effect = "Common/eff_game_jiasu"
  },
  [175731] = {
    id = 175731,
    EP = 0,
    Effect = "Common/eff_game_jiansu"
  },
  [175740] = {
    id = 175740,
    EP = 0,
    Effect = "Skill/Vacuum_atk",
    EffectScale = 0.5
  },
  [177200] = {
    id = 177200,
    EP = 2,
    Effect = "Skill/Eff_Fossil_charge_fire_floor,none"
  },
  [177230] = {
    id = 177230,
    EP = 2,
    Effect = "Skill/SoldierCat3_attack,none"
  },
  [177270] = {
    id = 177270,
    EP = 2,
    Effect = "Skill/FirePillar_Simplify,none"
  },
  [177300] = {
    id = 177300,
    EP = 2,
    Effect = "Skill/Galaxymusic_atk,none"
  },
  [177310] = {
    id = 177310,
    EP = 2,
    Effect = "Skill/MudFlatDeep,none",
    EffectScale = 1.2
  },
  [177325] = {
    id = 177325,
    EP = 2,
    Effect = "Common/StrongLight"
  },
  [177401] = {
    id = 177401,
    EP = 0,
    Effect = "Skill/sfx_mmmy_hudie_floor_prf,none"
  },
  [177410] = {
    id = 177410,
    EP = 0,
    Effect_start = "Skill/sfx_mmmy_hudie_atk_prf,none"
  },
  [177411] = {
    id = 177411,
    Logic = Table_BuffState_bk_t.Logic[5],
    EP = 3,
    Effect = "Common/Around,none",
    Effect_around = "Skill/sfx_mmmy_hudie_buff01_prf,none"
  },
  [177421] = {
    id = 177421,
    EP = 2,
    Effect = "Skill/sfx_45Monster_MagicCircle_prf"
  },
  [177476] = {
    id = 177476,
    EP = 2,
    Effect = "Skill/sfx_45Monster_MagicCircle_prf"
  },
  [177480] = {
    id = 177480,
    EP = 2,
    Effect = "Skill/Photosynthesis"
  },
  [177550] = {
    id = 177550,
    EP = 2,
    Effect_start = "Skill/Heal",
    SE_start = "Skill/Heal"
  },
  [177551] = {
    id = 177551,
    EP = 1,
    Effect = "Skill/Eff_08Toys_TurnAgainst",
    EffectScale = 1.3
  },
  [177552] = {
    id = 177552,
    EP = 2,
    Effect = "Skill/Cardroom_Meteorite_yujing_loop"
  },
  [177553] = {
    id = 177553,
    EP = 1,
    Effect = "Skill/Eff_08Toys_TurnAgainst"
  },
  [177554] = {
    id = 177554,
    EP = 3,
    Effect = "Skill/PoisonTub_hit"
  },
  [177561] = {
    id = 177561,
    EP = 2,
    Effect = "Skill/sfx_mvp2_sharen_buff05_prf",
    SE_start = "Skill/skill_magic_foreverchaos_attack"
  },
  [177562] = {
    id = 177562,
    EP = 2,
    Effect = "Skill/sfx_mvp2_sharen_buff04_prf",
    SE_start = "Skill/skill_magic_foreverchaos_attack"
  },
  [177563] = {
    id = 177563,
    EP = 2,
    Effect = "Skill/sfx_mvp2_sharen_buff03_prf",
    SE_start = "Skill/skill_magic_foreverchaos_attack"
  },
  [177564] = {
    id = 177564,
    EP = 2,
    Effect = "Skill/sfx_mvp2_sharen_buff02_prf",
    SE_start = "Skill/skill_magic_foreverchaos_attack"
  },
  [177565] = {
    id = 177565,
    EP = 2,
    Effect = "Skill/sfx_mvp2_sharen_buff01_prf",
    SE_start = "Skill/skill_magic_foreverchaos_attack"
  },
  [177566] = {
    id = 177566,
    EP = 2,
    Effect = "Skill/sfx_driller_atk_prf"
  },
  [177571] = {
    id = 177571,
    EP = 0,
    Effect = "Skill/Eff_SpaceQuiet_buff02,none",
    SE_start = "Skill/skill_weapon_soundneedle_attack"
  },
  [177572] = {
    id = 177572,
    EP = 0,
    Effect_start = "Skill/sfx_spacequiet_buff_start_prf",
    SE_start = "Skill/skill_weapon_soundneedle_attack"
  },
  [177590] = {
    id = 177590,
    EP = 2,
    Effect = "Skill/Evilsoul_Atk"
  },
  [177591] = {
    id = 177591,
    EP = 6,
    Effect = "Skill/StoneHammer_hit",
    EffectScale = 2,
    SE_hit = "Skill/Chronomancer_niuquzhadan"
  },
  [177592] = {
    id = 177592,
    EP = 0,
    Effect = "Skill/sfx_yuanli_buff_02_prf,none"
  },
  [177593] = {
    id = 177593,
    EP = 0,
    Effect = "Common/TeamFlag7,none",
    EffectScale = 2
  },
  [177598] = {
    id = 177598,
    EP = 2,
    Effect = "Skill/sfx_msk_buff_01_prf"
  },
  [177599] = {
    id = 177599,
    EP = 3,
    Effect = "Skill/sfx_hudun_buff_01_prf"
  },
  [177600] = {
    id = 177600,
    EP = 3,
    Effect = "Skill/sfx_hudun_buff_02_prf"
  },
  [177601] = {
    id = 177601,
    EP = 3,
    Effect = "Skill/sfx_hudun_buff_03_prf"
  },
  [177602] = {
    id = 177602,
    EP = 3,
    Effect = "Skill/sfx_hudun_die_01_prf"
  },
  [177603] = {
    id = 177603,
    EP = 3,
    Effect = "Skill/Pogonip_buff2,none"
  },
  [177620] = {
    id = 177620,
    EP = 0,
    Effect = "Skill/sfx_msj_buff_01_prf"
  },
  [177630] = {
    id = 177630,
    EP = 0,
    Effect = "Skill/sfx_msj_floor_01_prf"
  },
  [177640] = {
    id = 177640,
    EP = 2,
    Effect = "Skill/sfx_msj_floor_02_prf",
    SE_end = "Skill/sfx_skill_moshe_lightning_attack_01"
  },
  [177682] = {
    id = 177682,
    EP = 3,
    Effect = "Skill/sfx_msj_wuyun_atk_01_prf",
    SE_end = "Skill/sfx_skill_moshe_lightningcloud_loop_01"
  },
  [177690] = {
    id = 177690,
    EP = 0,
    Effect = "Skill/sfx_msj_wuyun_white_prf"
  },
  [177691] = {
    id = 177691,
    EP = 0,
    Effect = "Skill/sfx_msj_wuyun_atk_02_prf",
    SE_end = "Skill/sfx_skill_moshe_rainycloud_loop_01"
  },
  [177700] = {
    id = 177700,
    EP = 1,
    Effect = "Skill/sfx_msj_buff_02_prf"
  },
  [177720] = {
    id = 177720,
    EP = 1,
    Effect = "Skill/sfx_msj_wuyun_prf"
  },
  [177721] = {
    id = 177721,
    EP = 1,
    Effect = "Skill/sfx_gczc_boss_red_prf",
    EffectScale = 1.2,
    Offset = Table_BuffState_bk_t.Offset[3]
  },
  [177722] = {
    id = 177722,
    EP = 3,
    Effect = "Skill/sfx_gczc_boss_red_prf",
    Effect_end = "Skill/Eff_ShadowSlaughter_floor"
  },
  [177723] = {
    id = 177723,
    EP = 0,
    Effect_startScale = 0.3,
    Effect = "Skill/sfx_gczc_boss_red_prf",
    EffectScale = 0.3,
    Effect_end = "Skill/treatment_cast"
  },
  [177725] = {
    id = 177725,
    EP = 1,
    Effect = "Skill/sfx_gczc_boss_red_prf",
    EffectScale = 0.5,
    Offset = Table_BuffState_bk_t.Offset[3]
  },
  [177730] = {
    id = 177730,
    EP = 2,
    Effect = "Skill/Fearless_buff",
    EffectScale = 0.7
  },
  [177744] = {
    id = 177744,
    EP = 2,
    Effect = "Skill/Eff_CryogenicCyclone_buff",
    EffectScale = 1.7
  },
  [177746] = {
    id = 177746,
    EP = 2,
    Effect = "Skill/SafetyWall"
  },
  [177754] = {
    id = 177754,
    EP = 2,
    Effect = "Skill/AngleOffer_buff,none",
    EffectScale = 1.6
  },
  [177761] = {
    id = 177761,
    EP = 2,
    Effect = "Skill/Eff_green3_buff_Secret",
    EffectScale = 1.5
  },
  [177773] = {
    id = 177773,
    EP = 21,
    Effect = "Skill/Eff_HolyShield_floor"
  },
  [177782] = {
    id = 177782,
    EP = 3,
    Effect = "Skill/Sacrifice_buff,none",
    EffectScale = 1.5
  },
  [177786] = {
    id = 177786,
    EP = 2,
    Effect = "Skill/DestoryMyself_ring"
  },
  [177790] = {
    id = 177790,
    EP = 2,
    Effect = "Skill/DisneyMVP_maishi_Singing"
  },
  [177794] = {
    id = 177794,
    EP = 2,
    Effect = "Skill/DecelerationZone_buff",
    EffectScale = 1.1
  },
  [177802] = {
    id = 177802,
    EP = 2,
    Effect = "Skill/Eff_HolyShield_floor"
  },
  [177817] = {
    id = 177817,
    EP = 2,
    Effect = "Skill/PoisonFog_buff",
    EffectScale = 2
  },
  [177820] = {
    id = 177820,
    EP = 3,
    Effect = "Skill/sfx_gczc_boss_red_prf"
  },
  [177822] = {
    id = 177822,
    EP = 2,
    Effect_start = "Skill/sfx_schmidtknight_buff_prf",
    Effect_startScale = 2
  },
  [177830] = {
    id = 177830,
    EP = 3,
    Effect = "Skill/sfx_thunderlidenrad_cyzb_buff_prf"
  },
  [177845] = {
    id = 177845,
    EP = 3,
    Effect = "Skill/sfx_lioncrownfisher_lmy_buff_prf,none",
    SE_start_Loop = "Skill/sfx_skill_thunderjade_loop"
  },
  [177861] = {
    id = 177861,
    EP = 2,
    Effect = "Skill/sfx_wx_kwly_floor_prf",
    Offset = Table_BuffState_bk_t.Offset[5]
  },
  [177862] = {
    id = 177862,
    EP = 2,
    Effect = "Skill/sfx_wx_sjly_floor_prf",
    Offset = Table_BuffState_bk_t.Offset[5]
  },
  [177863] = {
    id = 177863,
    EP = 3,
    Effect = "Skill/Eff_MVP2_zhongzi_buff,none"
  },
  [177869] = {
    id = 177869,
    EP = 3,
    Effect_start = "Skill/Dark_Illusion_an_atk"
  },
  [177931] = {
    id = 177931,
    EP = 3,
    Effect = "Skill/sfx_schmidtknight_buff_01_prf"
  },
  [177932] = {
    id = 177932,
    EP = 3,
    Effect = "Skill/sfx_schmidtknight_buff_02_prf"
  },
  [177933] = {
    id = 177933,
    EP = 3,
    Effect = "Skill/sfx_schmidtknight_buff_03_prf"
  },
  [177934] = {
    id = 177934,
    EP = 2,
    Effect = "Skill/sfx_schmidtknight_floor_prf"
  },
  [177954] = {
    id = 177954,
    EP = 1,
    Effect = "Skill/sfx_corruptvines_buff_01_prf"
  },
  [177955] = {
    id = 177955,
    EP = 2,
    Effect = "Skill/sfx_corruptvines_bullet2_prf",
    Offset = Table_BuffState_bk_t.Offset[2]
  },
  [177956] = {
    id = 177956,
    EP = 3,
    Effect_hit = "Skill/sfx_corruptvines_hit_01_prf"
  },
  [177960] = {
    id = 177960,
    EP = 2,
    Effect = "Skill/OrruneCorrupt_buff",
    EffectScale = 0.2
  },
  [177970] = {
    id = 177970,
    EP = 2,
    Effect = "Skill/EverForce_buff"
  },
  [177974] = {
    id = 177974,
    EP = 2,
    Effect = "Skill/sfx_wx_sjly_floor_star_prf"
  },
  [177975] = {
    id = 177975,
    EP = 2,
    Effect = "Skill/sfx_wx_sjly_guodu01_floor_prf"
  },
  [177976] = {
    id = 177976,
    EP = 2,
    Effect = "Skill/sfx_wx_sjly_guodu02_floor_prf"
  },
  [177977] = {
    id = 177977,
    EP = 1,
    Effect = "Skill/sfx_pve3_bomb_buff_prf",
    Offset = Table_BuffState_bk_t.Offset[9]
  },
  [177981] = {
    id = 177981,
    EP = 0,
    Effect = "Skill/sfx_schmidtknight_floor_prf"
  },
  [177988] = {
    id = 177988,
    EP = 3,
    Effect_start = "Skill/sfx_Knight_hit_prf",
    SE_start = "Skill/sfx_skill_eleccutting_attack"
  },
  [177990] = {
    id = 177990,
    EP = 0,
    Effect = "Skill/sfx_schmidtknight_floor_01_prf"
  },
  [177991] = {
    id = 177991,
    EP = 5,
    Effect = "Skill/sfx_gczc_boss_red_prf"
  },
  [177992] = {
    id = 177992,
    EP = 3,
    Effect = "Skill/sfx_xgc_buff_01_prf",
    EffectScale = 1.2
  },
  [177993] = {
    id = 177993,
    EP = 0,
    Effect = "Skill/sfx_taqk_03_prf,none",
    EffectScale = 1.1
  },
  [177994] = {
    id = 177994,
    EP = 0,
    Effect_start = "Skill/Resurrection",
    SE_start = "Skill/Resurrection"
  },
  [177995] = {
    id = 177995,
    EP = 5,
    Effect = "Skill/sfx_gczc_boss_red_prf",
    EffectScale = 0.5
  },
  [178003] = {
    id = 178003,
    EP = 7,
    Effect = "Skill/sfx_gczc_boss_red_prf",
    EffectScale = 0.3
  },
  [178100] = {
    id = 178100,
    EP = 0,
    Effect = "Skill/sfx_ancientpecopeco_di_floor_prf",
    EffectScale = 1.1
  },
  [178101] = {
    id = 178101,
    EP = 0,
    Effect = "Skill/sfx_ancientpecopeco_di_floor02_prf,none",
    EffectScale = 1.1
  },
  [178102] = {
    id = 178102,
    EP = 2,
    Effect = "Skill/sfx_ancientpecopeco_di_floor_prf,none",
    EffectScale = 1.1
  },
  [178103] = {
    id = 178103,
    EP = 2,
    Effect = "Skill/sfx_ancientpecopeco_di_floor04_prf,none",
    EffectScale = 1.1
  },
  [178104] = {
    id = 178104,
    EP = 4,
    Effect = "Skill/AnniHilate_Buff,none",
    EffectScale = 2
  },
  [178291] = {
    id = 178291,
    EP = 2,
    Effect = "Skill/Lunar_MagicPuppet_buff,none",
    EffectScale = 2.5,
    Offset = Table_BuffState_bk_t.Offset[1]
  },
  [178292] = {
    id = 178292,
    EP = 2,
    Effect = "Skill/Sun_MagicPuppet,none",
    EffectScale = 2.5,
    Offset = Table_BuffState_bk_t.Offset[1]
  },
  [178313] = {
    id = 178313,
    EP = 2,
    Effect = "Skill/CrimsonRock_DM",
    EffectScale = 1.2
  },
  [178314] = {
    id = 178314,
    EP = 3,
    Effect_start = "Skill/Solarglory_hit"
  },
  [178315] = {
    id = 178315,
    EP = 11,
    Effect_startScale = 0.9,
    Effect = "Skill/sfx_n_alinia_back_wait_prf",
    Offset = Table_BuffState_bk_t.Offset[8]
  },
  [178317] = {
    id = 178317,
    EP = 2,
    Effect = "Skill/Dragon_ButterflyStorm_buff2"
  },
  [178319] = {
    id = 178319,
    EP = 2,
    Effect_start = "Skill/MagicBlame"
  },
  [178320] = {
    id = 178320,
    EP = 3,
    Effect = "Skill/sfx_n_alinia_xs_buff_01_prf",
    Offset = Table_BuffState_bk_t.Offset[4]
  },
  [178321] = {
    id = 178321,
    EP = 3,
    Effect = "Skill/sfx_n_alinia_xs_buff_02_prf",
    Offset = Table_BuffState_bk_t.Offset[4]
  },
  [178322] = {
    id = 178322,
    EP = 3,
    Effect = "Skill/sfx_n_alinia_xs_buff_03_prf",
    Offset = Table_BuffState_bk_t.Offset[4]
  },
  [178323] = {
    id = 178323,
    EP = 3,
    Effect = "Skill/sfx_alinia_chzd_Buff_01_prf,none"
  },
  [178324] = {
    id = 178324,
    EP = 2,
    Effect = "Skill/Rune_05_12pvp,none"
  },
  [178326] = {
    id = 178326,
    EP = 2,
    Effect_start = "Skill/sfx_starstone_state01_buff_prf"
  },
  [178327] = {
    id = 178327,
    EP = 3,
    Effect = "Skill/sfx_starstone_state02_buff_prf"
  },
  [178328] = {
    id = 178328,
    EP = 3,
    Effect = "Skill/DarkFantasy,none"
  },
  [178329] = {
    id = 178329,
    EP = 2,
    Effect_start = "Skill/sfx_herodnts_yujing_lod3_prf"
  },
  [178337] = {
    id = 178337,
    EP = 2,
    Effect = "Skill/sfx_fallingbishop_skill01_sing_prf"
  },
  [178339] = {
    id = 178339,
    EP = 2,
    Effect = "Skill/CrimsonRock_DM"
  },
  [178340] = {
    id = 178340,
    EP = 2,
    Effect = "Skill/CrimsonRock_DM",
    EffectScale = 1.33
  },
  [178341] = {
    id = 178341,
    EP = 2,
    Effect = "Skill/CrimsonRock_DM",
    EffectScale = 1.67
  },
  [178342] = {
    id = 178342,
    EP = 2,
    Effect = "Skill/CrimsonRock_DM",
    EffectScale = 2
  },
  [178343] = {
    id = 178343,
    EP = 2,
    Effect = "Skill/CrimsonRock_DM",
    EffectScale = 2.33
  },
  [178344] = {
    id = 178344,
    EP = 2,
    Effect = "Skill/CrimsonRock_DM",
    EffectScale = 2.67
  },
  [178345] = {
    id = 178345,
    EP = 2,
    Effect = "Skill/CrimsonRock_DM",
    EffectScale = 3
  },
  [178348] = {
    id = 178348,
    EP = 2,
    Effect = "Skill/sfx_lavagolem_yszl_floor_02_prf"
  },
  [178380] = {
    id = 178380,
    EP = 3,
    Effect_hit = "Skill/Flame_Double_hit"
  },
  [178390] = {
    id = 178390,
    EP = 3,
    Effect_hit = "Skill/Eff_DragonBones_hit"
  },
  [183190] = {
    id = 183190,
    EP = 2,
    Effect = "Skill/Flame_ShiningGuang_buff,none"
  },
  [183340] = {
    id = 183340,
    EP = 3,
    Effect = "Skill/Flame_FireAttribute_buff,none"
  },
  [183341] = {
    id = 183341,
    EP = 3,
    Effect = "Skill/Flame_lightAttribute_buff,none"
  },
  [183480] = {
    id = 183480,
    GroupID = 2,
    EffectGroup = "Common/Around,none",
    EffectGroup_around = "Skill/Flame_WCZD_buff01",
    EP = 1,
    Effect = "Common/Around,none"
  },
  [183481] = {
    id = 183481,
    GroupID = 2,
    EffectGroup = "Common/Around,none",
    EffectGroup_around = "Skill/Flame_WCZD_buff02",
    EP = 1,
    Effect = "Common/Around,none"
  },
  [183482] = {
    id = 183482,
    GroupID = 2,
    EffectGroup = "Common/Around,none",
    EffectGroup_around = "Skill/Flame_WCZD_buff03",
    EP = 1,
    Effect = "Common/Around,none"
  },
  [183483] = {
    id = 183483,
    GroupID = 2,
    EffectGroup = "Common/Around,none",
    EffectGroup_around = "Skill/Flame_WCZD_buff04",
    EP = 1,
    Effect = "Common/Around,none"
  },
  [183484] = {
    id = 183484,
    GroupID = 2,
    EffectGroup = "Common/Around,none",
    EffectGroup_around = "Skill/Flame_WCZD_buff05",
    EP = 1,
    Effect = "Common/Around,none"
  },
  [184040] = {
    id = 184040,
    EP = 2,
    Effect = "Skill/Eff_Ryujinmaru_feilong_atk,none"
  },
  [184042] = {
    id = 184042,
    EP = 2,
    Effect = "Skill/Eff_Ryujinmaru_feilong_hit,none"
  },
  [184060] = {
    id = 184060,
    EP = 2,
    Effect_start = "Skill/Eff_Ryujinmaru_control_buff,none"
  },
  [184061] = {
    id = 184061,
    EP = 2,
    Effect_start = "Skill/Eff_Ryujinmaru_longwang_buff,none"
  },
  [184150] = {
    id = 184150,
    EP = 2,
    Effect = "Skill/Eff_Ryujinmaru_fenghuang_buff,none"
  },
  [184161] = {
    id = 184161,
    EP = 3,
    Effect = "Skill/Eff_Ryujinmaru_dun_buff02,none"
  },
  [186001] = {
    id = 186001,
    EP = 2,
    Effect = "Skill/Eff_Lina_mowang_buff,none"
  },
  [186140] = {
    id = 186140,
    EP = 1,
    Effect = "Skill/Eff_Lina_FireHunt_buff,none"
  },
  [200010] = {
    id = 200010,
    EP = 3,
    Effect = "Quicken_buff,none"
  },
  [200020] = {
    id = 200020,
    EP = 0,
    Effect = "Skill/AShield_buff,none"
  },
  [200021] = {
    id = 200021,
    EP = 0,
    Effect = "Skill/AShield_buff_huge,none"
  },
  [200022] = {
    id = 200022,
    EP = 0,
    Effect_start = "Skill/AShield_hit,none"
  },
  [200023] = {
    id = 200023,
    EP = 0,
    Effect_start = "Skill/AShield_hit_huge,none"
  },
  [200050] = {
    id = 200050,
    EP = 3,
    Effect = "Skill/Stealth_buff1,none"
  },
  [200051] = {
    id = 200051,
    EP = 3,
    Effect = "Skill/Stealth_buff2,none"
  },
  [200052] = {
    id = 200052,
    EP = 0,
    Effect = "Thebest_buff,none"
  },
  [200060] = {
    id = 200060,
    EP = 3,
    Effect = "Skill/Cram_buff,none"
  },
  [200070] = {
    id = 200070,
    EP = 0,
    Effect = "Skill/Huge_buff,none"
  },
  [200360] = {
    id = 200360,
    EP = 3,
    Effect = "Skill/Carom_hit"
  },
  [200400] = {
    id = 200400,
    EP = 1,
    Effect = "Skill/sfx_pilien_zhua01_buff_prf"
  },
  [200401] = {
    id = 200401,
    EP = 1,
    Effect = "Skill/sfx_pilien_zhua02_buff_prf"
  },
  [200402] = {
    id = 200402,
    EP = 1,
    Effect = "Skill/sfx_pilien_zhua03_buff_prf"
  },
  [200410] = {
    id = 200410,
    EP = 0,
    Effect = "Skill/sfx_WaterProtect_buff_prf",
    EffectScale = 6
  },
  [200411] = {
    id = 200411,
    EP = 3,
    Effect = "Skill/poisoning,none"
  },
  [200413] = {
    id = 200413,
    EP = 3,
    Effect_start = "Skill/PoisonAttributeHit"
  },
  [200417] = {
    id = 200417,
    EP = 0,
    Effect = "Skill/sfx_kaitelina_floor_prf"
  },
  [200418] = {
    id = 200418,
    EP = 3,
    Effect = "Skill/Assumptio_buff,none",
    EffectScale = 2,
    SE_start = "Common/sfx_skill_pilien_shield_attack_01"
  },
  [200419] = {
    id = 200419,
    EP = 3,
    Effect = "Skill/sfx_kaitelina_buff_prf",
    EffectScale = 3
  },
  [200421] = {
    id = 200421,
    EP = 2,
    Effect = "Skill/WindWard_buff,none"
  },
  [200423] = {
    id = 200423,
    EP = 3,
    Effect = "Common/90YmirsHeart_continued2,none"
  },
  [200424] = {
    id = 200424,
    EP = 3,
    Effect_start = "Skill/TrolleysCannon_hit"
  },
  [200433] = {
    id = 200433,
    EP = 0,
    Effect_start = "Skill/sfx_kaitelina_sing_prf"
  },
  [200434] = {
    id = 200434,
    EP = 0,
    Effect_start = "Skill/sfx_kaitelina_atk_prf"
  },
  [200435] = {
    id = 200435,
    EP = 0,
    Effect_start = "Skill/sfx_kaitelina_hit_prf",
    SE_start = "Common/sfx_scene_nanmen_pilien_thunder_hit"
  },
  [210120] = {
    id = 210120,
    EP = 1,
    Effect = "Common/MagicBall_water"
  },
  [210121] = {
    id = 210121,
    EP = 1,
    Effect = "Common/MagicBall_fire"
  },
  [210122] = {
    id = 210122,
    EP = 1,
    Effect = "Common/MagicBall_land"
  },
  [210123] = {
    id = 210123,
    EP = 1,
    Effect = "Common/MagicBall_wind"
  },
  [210130] = {
    id = 210130,
    EP = 2,
    Effect = "Skill/FireWaller,none"
  },
  [210131] = {
    id = 210131,
    EP = 2,
    Effect = "Skill/FireWaller,none"
  },
  [210140] = {
    id = 210140,
    EP = 2,
    Effect = "Skill/LavaRoad,none"
  },
  [210160] = {
    id = 210160,
    EP = 3,
    Effect = "Skill/FireWater,none"
  },
  [210170] = {
    id = 210170,
    EP = 2,
    Effect = "Skill/MagicLoseWa,none"
  },
  [210171] = {
    id = 210171,
    EP = 2,
    Effect = "Skill/MagicLoseL,none"
  },
  [210172] = {
    id = 210172,
    EP = 2,
    Effect = "Skill/MagicLoseWi,none"
  },
  [210173] = {
    id = 210173,
    EP = 2,
    Effect = "Skill/MagicLoseF,none"
  },
  [210174] = {
    id = 210174,
    EP = 2,
    Effect = "Skill/MagicLose,none"
  },
  [210175] = {
    id = 210175,
    EP = 3,
    Effect = "Skill/Berserker,none"
  },
  [210176] = {
    id = 210176,
    EP = 2,
    Effect = "Skill/HoldBody_buff"
  },
  [504030] = {
    id = 504030,
    EP = 2,
    Effect = "Skill/Eff_jfzc_mlk_atk05",
    EffectScale = 0.78
  },
  [9999999] = {
    id = 9999999,
    EP = 0,
    Effect = "Skill/Eff_Monster_patrol"
  },
  [20310031] = {
    id = 20310031,
    EP = 3,
    Effect = "Skill/AssassinateHeart_buff,none"
  },
  [20410051] = {
    id = 20410051,
    EP = 2,
    Effect = "Skill/PlayerLock,none"
  },
  [20510031] = {
    id = 20510031,
    EP = 3,
    Effect = "Skill/Atonement_buff,none"
  },
  [20610040] = {
    id = 20610040,
    EP = 2,
    Effect_start = "Skill/Gear_Lvup",
    Effect_hit = "Skill/Gear_Lvup"
  },
  [30020006] = {
    id = 30020006,
    EP = 3,
    Effect = "Skill/sfx_schmidtknight_buff_02_prf"
  },
  [30020023] = {
    id = 30020023,
    EP = 0,
    Effect = "Skill/sfx_schmidtknight_floor_prf"
  },
  [30020028] = {
    id = 30020028,
    EP = 0,
    Effect = "Skill/Eff_ShadowSeparation01",
    EffectScale = 2
  },
  [30020029] = {
    id = 30020029,
    EP = 0,
    Effect = "Common/Cherry_blossom",
    EffectScale = 4
  },
  [30020030] = {
    id = 30020030,
    EP = 0,
    Effect = "Skill/Eff_ShadowSeparation01",
    EffectScale = 0.6,
    Offset = Table_BuffState_bk_t.Offset[7]
  },
  [30020031] = {
    id = 30020031,
    EP = 0,
    Effect = "Skill/BlessingFaith_buff2",
    EffectScale = 0.8,
    Offset = Table_BuffState_bk_t.Offset[6]
  },
  [30020032] = {
    id = 30020032,
    EP = 3,
    Effect = "Skill/BossVampire"
  },
  [30020033] = {
    id = 30020033,
    EP = 3,
    Effect = "Skill/BloodthirstyDesire_buff2"
  },
  [30020034] = {
    id = 30020034,
    EP = 2,
    Effect = "Common/Collection_EmirHeart"
  },
  [30020103] = {
    id = 30020103,
    EP = 3,
    Effect = "Skill/sfx_KinsProtect_buff_prf,none",
    EffectScale = 2.5
  },
  [30020115] = {
    id = 30020115,
    EP = 0,
    Effect = "Skill/sfx_gczc_ground_purple_prf",
    EffectScale = 1.4
  },
  [30020134] = {
    id = 30020134,
    EP = 0,
    Effect = "Common/cfx_smoke_trail_prf",
    EffectScale = 1
  },
  [30020144] = {
    id = 30020144,
    EP = 0,
    Effect = "Skill/sfx_gczc_ground_blue_prf",
    EffectScale = 0.45
  },
  [30020160] = {
    id = 30020160,
    EP = 3,
    Effect = "Skill/sfx_KinsProtect_buff_prf,none",
    EffectScale = 1
  },
  [30020166] = {
    id = 30020166,
    EP = 2,
    Effect = "Skill/SafetyWall",
    EffectScale = 1.5
  },
  [30020167] = {
    id = 30020167,
    EP = 2,
    Effect = "Skill/Eff_MVP2_kouxue_buff",
    EffectScale = 2
  },
  [30020168] = {
    id = 30020168,
    EP = 2,
    Effect = "Skill/BlastStep_buff",
    EffectScale = 2
  },
  [30020169] = {
    id = 30020169,
    EP = 3,
    Effect = "Skill/Eff_bianjuelongshi_buff",
    EffectScale = 3
  },
  [30020170] = {
    id = 30020170,
    EP = 3,
    Effect = "Skill/MeteorAssault",
    EffectScale = 1.5
  },
  [30020171] = {
    id = 30020171,
    EP = 2,
    Effect = "Skill/Dark_Illusion_an_atk,none",
    EffectScale = 1
  },
  [30020206] = {
    id = 30020206,
    EP = 2,
    Effect = "Skill/sfx_tswf_jinggu_buff04_prf",
    EffectScale = 0.65
  },
  [30020207] = {
    id = 30020207,
    EP = 2,
    Effect = "Skill/sfx_tswf_jinggu_buff03_prf",
    EffectScale = 0.65
  },
  [30020208] = {
    id = 30020208,
    EP = 2,
    Effect = "Skill/sfx_tswf_jinggu_buff02_prf",
    EffectScale = 0.65
  },
  [30020209] = {
    id = 30020209,
    EP = 2,
    Effect = "Skill/sfx_tswf_jinggu_buff01_prf",
    EffectScale = 0.65
  },
  [30020210] = {
    id = 30020210,
    EP = 2,
    SE_start = "Common/christmas_carriage_move_bg",
    SE_end = "Common/christmas_carriage_move_ed"
  },
  [30020212] = {
    id = 30020212,
    EP = 2,
    SE_start = "Common/christmas_carriage_gift_drop"
  },
  [30020316] = {
    id = 30020316,
    EP = 2,
    Effect = "Skill/sfx_n_callisgesimplify_ljf_prf",
    EffectScale = 0.8,
    SE_start_Loop = "Skill/sfx_skill_kalisige_succubuswaltz_summon_tornado_lp_01"
  },
  [30020334] = {
    id = 30020334,
    EP = 2,
    Effect = "Skill/sfx_n_callisgesimplify_trap_buff_prf",
    EffectScale = 1
  },
  [30020335] = {
    id = 30020335,
    EP = 2,
    Effect = "Skill/sfx_n_callisgesimplify_skill1_atk_prf",
    EffectScale = 1
  },
  [30020336] = {
    id = 30020336,
    EP = 1,
    Effect = "Skill/sfx_Mechanic_Charge_buff_prf",
    EffectScale = 1
  },
  [30020343] = {
    id = 30020343,
    EP = 2,
    Effect = "Skill/Eff_8Thread_xiaoshan",
    EffectScale = 1,
    SE_start = "Skill/skill_magic_gianticefall_hit"
  },
  [30020359] = {
    id = 30020359,
    EP = 2,
    Effect = "Skill/HeadAtk_attack",
    EffectScale = 1
  },
  [30020360] = {
    id = 30020360,
    EP = 0,
    SE_start = "Skill/Heal"
  },
  [30020361] = {
    id = 30020361,
    EP = 2,
    Effect = "Skill/sfx_n_callisgesimplify_skill1_atk_prf",
    EffectScale = 1,
    SE_start = "Skill/Heal"
  },
  [30020366] = {
    id = 30020366,
    EP = 1,
    Effect = "Skill/sfx_tengman_twining_prf",
    EffectScale = 1.5
  },
  [30020372] = {
    id = 30020372,
    EP = 1,
    Effect = "Skill/sfx_ysfb_feng_01_prf",
    EffectScale = 1.5
  },
  [30020373] = {
    id = 30020373,
    EP = 1,
    Effect = "Skill/sfx_ysfb_di_01_prf",
    EffectScale = 1.5
  },
  [30020374] = {
    id = 30020374,
    EP = 1,
    Effect = "Skill/sfx_ysfb_shui_01_prf",
    EffectScale = 1.5
  },
  [30020375] = {
    id = 30020375,
    EP = 1,
    Effect = "Skill/sfx_ysfb_huo_01_prf",
    EffectScale = 1.5
  },
  [30020376] = {
    id = 30020376,
    EP = 1,
    Effect = "Skill/sfx_ysfb_wu_01_prf",
    EffectScale = 1.5
  },
  [30020377] = {
    id = 30020377,
    EP = 1,
    Effect = "Skill/sfx_ysfb_ai_01_prf",
    EffectScale = 1.5
  },
  [30020378] = {
    id = 30020378,
    EP = 1,
    Effect = "Skill/sfx_ysfb_an_01_prf",
    EffectScale = 1.5
  },
  [30020379] = {
    id = 30020379,
    EP = 1,
    Effect = "Skill/sfx_ysfb_nian_01_prf",
    EffectScale = 1.5
  },
  [30020380] = {
    id = 30020380,
    EP = 1,
    Effect = "Skill/sfx_ysfb_zenge_01_prf",
    EffectScale = 1.5
  },
  [30020381] = {
    id = 30020381,
    EP = 1,
    Effect = "Skill/sfx_ysfb_du_01_prf",
    EffectScale = 1.5
  },
  [30020382] = {
    id = 30020382,
    EP = 1,
    Effect = "Common/DivineHand_2_5",
    EffectScale = 2
  },
  [30020384] = {
    id = 30020384,
    EP = 2,
    Effect = "Skill/BossDefense,none",
    EffectScale = 4.5
  },
  [30020385] = {
    id = 30020385,
    EP = 2,
    Effect = "Skill/eff_FrozenZone_mijing",
    EffectScale = 0.75
  },
  [30020393] = {
    id = 30020393,
    EP = 2,
    Effect = "Skill/sfx_InfiniteSing_buff_prf",
    EffectScale = 1
  },
  [30020394] = {
    id = 30020394,
    EP = 2,
    Effect = "Skill/sfx_violet_refresh_prf",
    EffectScale = 1
  },
  [30020409] = {
    id = 30020409,
    EP = 2,
    Effect = "Skill/Garm_Ice",
    EffectScale = 0.5
  },
  [30020412] = {
    id = 30020412,
    EP = 0,
    Effect = "Skill/sfx_sc_jfzc_kc_01_prf",
    EffectScale = 1
  },
  [30020414] = {
    id = 30020414,
    EP = 2,
    Effect = "Skill/sfx_violet_refresh_prf",
    EffectScale = 6
  },
  [30020430] = {
    id = 30020430,
    EP = 2,
    Effect = "Skill/sfx_fate_buff_01_prf",
    EffectScale = 1
  },
  [30020431] = {
    id = 30020431,
    EP = 2,
    Effect = "Skill/sfx_fate_buff_02_prf",
    EffectScale = 1
  },
  [30020432] = {
    id = 30020432,
    EP = 2,
    Effect = "Skill/sfx_fate_buff_03_prf",
    EffectScale = 1
  },
  [30020433] = {
    id = 30020433,
    EP = 2,
    Effect = "Skill/sfx_fate_buff_04_prf",
    EffectScale = 1
  },
  [30020439] = {
    id = 30020439,
    EP = 2,
    Effect = "Skill/Eff_MagneticField",
    EffectScale = 1.5
  },
  [30020444] = {
    id = 30020444,
    EP = 2,
    Effect = "Skill/sfx_violet_refresh_prf",
    EffectScale = 2
  },
  [30020448] = {
    id = 30020448,
    EP = 2,
    Effect = "Skill/sfx_jfzc_bossyinchang"
  },
  [30020454] = {
    id = 30020454,
    EP = 2,
    Effect_hit = "Skill/sfx_human_sszn_atk_01_prf"
  },
  [30020456] = {
    id = 30020456,
    EP = 2,
    Effect_hit = "Skill/sfx_vampire_bflj_atk_prf"
  },
  [30020459] = {
    id = 30020459,
    EP = 2,
    Effect = "Skill/sfx_jfzc_BossDefense,none",
    EffectScale = 1
  },
  [30020461] = {
    id = 30020461,
    EP = 2,
    Effect = "Skill/sfx_jfzc_DarkStrike_cast"
  },
  [30020467] = {
    id = 30020467,
    EP = 2,
    Effect = "Skill/sfx_human_ssjj_baoqi_prf",
    EffectScale = 1
  },
  [30020469] = {
    id = 30020469,
    EP = 2,
    Effect = "Skill/Eff_TherapeuticBarrier_buff",
    EffectScale = 1
  },
  [30020470] = {
    id = 30020470,
    EP = 2,
    Effect = "Skill/EleImprinting_buff",
    EffectScale = 1
  },
  [30020511] = {
    id = 30020511,
    EP = 2,
    Effect = "Skill/sfx_human_jg_prf",
    EffectScale = 1
  },
  [30020512] = {
    id = 30020512,
    EP = 2,
    Effect = "Skill/sfx_vampire_hg_prf",
    EffectScale = 1
  },
  [30020520] = {
    id = 30020520,
    EP = 2,
    Effect = "Skill/sfx_jfzc_Humming_mijing",
    EffectScale = 1
  },
  [30020521] = {
    id = 30020521,
    EP = 2,
    Effect = "Skill/sfx_jfzc_gongji",
    EffectScale = 1
  },
  [30020530] = {
    id = 30020530,
    EP = 2,
    Effect = "Skill/sfx_jfzc_DeathAwakening_buff",
    EffectScale = 1
  },
  [30020531] = {
    id = 30020531,
    EP = 2,
    Effect = "Skill/sfx_jfzc_fangyu",
    EffectScale = 1
  },
  [30020540] = {
    id = 30020540,
    EP = 2,
    Effect = "Skill/sfx_jfzc_IdunApple_buff2",
    EffectScale = 1
  },
  [30020541] = {
    id = 30020541,
    EP = 2,
    Effect = "Skill/sfx_jfzc_huixue",
    EffectScale = 1
  },
  [30032100] = {
    id = 30032100,
    EP = 4,
    Effect_start = "Skill/sfx_dragonblackflame_buff_start01_prf",
    Effect = "Skill/sfx_dragonblackflame_buff_loop01_prf"
  },
  [30032101] = {
    id = 30032101,
    EP = 5,
    Effect_start = "Skill/sfx_dragonblackflame_buff_start_prf",
    Effect = "Skill/sfx_dragonblackflame_buff_loop_prf"
  },
  [41000170] = {
    id = 41000170,
    EP = 2,
    Effect = "Skill/Relax_buff,none"
  },
  [42000110] = {
    id = 42000110,
    EP = 2,
    Effect = "Skill/IgnoreSpace,none"
  },
  [42000150] = {
    id = 42000150,
    EP = 3,
    Effect = "Skill/LightningRod_buff,none"
  },
  [42000229] = {
    id = 42000229,
    EP = 2,
    Effect = "Skill/GravitationalField_buff,none"
  },
  [45000120] = {
    id = 45000120,
    EP = 2,
    Effect = "Skill/Confession_buff,none"
  },
  [45000139] = {
    id = 45000139,
    EP = 2,
    Effect = "Skill/DoubleHeal_buff,none"
  },
  [45000180] = {
    id = 45000180,
    EP = 2,
    Effect = "Skill/BlessingFaith_buff2,none"
  },
  [45000184] = {
    id = 45000184,
    EP = 2,
    Effect = "Skill/BlessingFaith_buff1,none"
  },
  [70000020] = {
    id = 70000020,
    EP = 3,
    Effect = "Common/109LuminousBlue,none"
  },
  [70027010] = {
    id = 70027010,
    EP = 1,
    Effect = "Skill/ImmunePhysical_buff"
  },
  [70027020] = {
    id = 70027020,
    EP = 1,
    Effect = "Skill/ImmuneMagic_buff"
  },
  [70047001] = {
    id = 70047001,
    EP = 2,
    Effect = "Skill/Monkcat_skill_hitbuff,none"
  },
  [70047010] = {
    id = 70047010,
    EP = 3,
    Effect_hit = "Skill/SoldierCat4_use_kill_maohit,none"
  },
  [70047011] = {
    id = 70047011,
    EP = 3,
    Effect_start = "Skill/SoldierCat4_use_kill_renhit,none"
  },
  [70048000] = {
    id = 70048000,
    EP = 3,
    Effect = "Common/103Dark_buff,none"
  },
  [70048001] = {
    id = 70048001,
    EP = 2,
    Effect = "Common/MonsterSmog,none"
  },
  [70048002] = {
    id = 70048002,
    EP = 0,
    Effect = "Common/Chicken_induction,none"
  },
  [70049004] = {
    id = 70049004,
    EP = 3,
    Effect = "Skill/Abyssknight_buff,none"
  },
  [100003600] = {
    id = 100003600,
    EP = 3,
    Effect_start = "Skill/Dispersion,none"
  },
  [100017800] = {
    id = 100017800,
    EP = 0,
    Effect = "Skill/SlothBreath_buff,none"
  },
  [100023201] = {
    id = 100023201,
    EP = 2,
    Effect = "Skill/WhirlingDeath_buff,none"
  },
  [100032900] = {
    id = 100032900,
    EP = 2,
    Effect = "Skill/Eff_Stonelion_skill"
  },
  [100035501] = {
    id = 100035501,
    EP = 2,
    Effect = "Skill/Eff_45936_buff,none"
  },
  [100035701] = {
    id = 100035701,
    EP = 2,
    Effect = "Skill/Eff_eddga_waiyan_buff,none"
  },
  [100037951] = {
    id = 100037951,
    EP = 2,
    Effect = "Skill/Eff_BokiView_poet_HP,none"
  },
  [100037961] = {
    id = 100037961,
    EP = 2,
    Effect = "Skill/Eff_BokiView_poet_SP,none"
  },
  [110000082] = {
    id = 110000082,
    EP = 3,
    Effect = "Skill/sfx_gczc_boss_red_prf",
    EffectScale = 1.4
  },
  [200000000] = {id = 200000000}
}
local cell_mt = {
  __index = {
    Effect = "",
    EffectGroup = "",
    EffectGroup_around = "",
    Effect_around = "",
    Effect_end = "",
    Effect_hit = "",
    Effect_start = "",
    Effect_startAt = "",
    Logic = _EmptyTable,
    Myself = _EmptyTable,
    Offset = _EmptyTable,
    SE_end = "",
    SE_hit = "",
    SE_start = "",
    SE_start_Loop = "",
    id = 1
  }
}
for _, d in pairs(Table_BuffState_bk) do
  setmetatable(d, cell_mt)
end
