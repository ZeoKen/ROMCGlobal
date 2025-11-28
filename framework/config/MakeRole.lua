CharacterGender = {
  Male = {
    hairList = {
      [7] = {
        93,
        94,
        95,
        97
      },
      default = {
        2,
        3,
        6,
        8
      }
    }
  },
  Female = {
    hairList = {
      [7] = {
        83,
        84,
        85,
        86
      },
      default = {
        15,
        11,
        12,
        14
      }
    }
  }
}
CharacterPreview = {
  hairColorList = {
    1,
    2,
    3,
    4
  },
  accessories = {
    45004,
    45045,
    45072
  }
}
CharacterSelectList = {
  [1] = {
    gender = CharacterGender.Female,
    maleID = 1172,
    femaleID = 1166,
    petID = 1181,
    classID = 42,
    name = "猎人",
    ename = "Hunter",
    str = 3,
    int = 5,
    vit = 4,
    agi = 8,
    dex = 9,
    luk = 5
  },
  [2] = {
    gender = CharacterGender.Female,
    maleID = 1173,
    femaleID = 1167,
    petID = 1263,
    classID = 52,
    name = "牧师",
    ename = "Priest",
    str = 2,
    int = 8,
    vit = 6,
    agi = 4,
    dex = 4,
    luk = 6
  },
  [3] = {
    gender = CharacterGender.Male,
    maleID = 1168,
    femaleID = 1174,
    classID = 62,
    name = "铁匠",
    ename = "Blacksmith",
    str = 9,
    int = 3,
    vit = 6,
    agi = 4,
    dex = 7,
    luk = 5
  },
  [4] = {
    gender = CharacterGender.Female,
    maleID = 1175,
    femaleID = 1169,
    classID = 22,
    name = "巫师",
    ename = "Wizard",
    str = 1,
    int = 9,
    vit = 3,
    agi = 3,
    dex = 8,
    luk = 4
  },
  [5] = {
    gender = CharacterGender.Male,
    maleID = 1170,
    femaleID = 1176,
    classID = 12,
    name = "骑士",
    ename = "Knight",
    str = 9,
    int = 1,
    vit = 8,
    agi = 3,
    dex = 5,
    luk = 2
  },
  [6] = {
    gender = CharacterGender.Male,
    maleID = 1171,
    femaleID = 1177,
    petID = 1264,
    classID = 32,
    name = "刺客",
    ename = "Assassin",
    str = 4,
    int = 4,
    vit = 5,
    agi = 9,
    dex = 6,
    luk = 8
  },
  [7] = {
    gender = CharacterGender.Female,
    maleID = 806658,
    femaleID = 806659,
    classID = 152,
    name = "灵术师",
    ename = "Doram",
    str = 0,
    int = 40,
    vit = 30,
    agi = 10,
    dex = 40,
    luk = 0
  }
}
if BranchMgr.IsJapan() then
  CharacterSelectList[7].ename = "Summoner"
end
PreloadUI_Static = {
  MainView = 1,
  PackageView = 1,
  AdventurePanel = 1,
  Charactor = 1,
  SkillView = 1
}
