DialogEventType = {
  EquipReplace = "EquipReplace",
  EquipUpgrade = "EquipUpgrade"
}
EventDialog = {
  [1] = {
    DialogText = "你好冒险者，我是%s部位打洞的专家，想试试吗？所谓的装备打洞就是让装备多出一个卡槽，可以让你变得更加强力！"
  },
  [2] = {
    DialogText = "可是你该部位没有穿戴装备，无法提供服务",
    Option = {7}
  },
  [3] = {
    DialogText = "冒险者，根据我所学的配方，我可以帮你升级一部分特定的装备，现在请你选择需要升级的装备吧！"
  },
  [4] = {
    DialogText = "我们乌加特家族在王国内可是数一数二的大家族呢！"
  },
  [51] = {
    DialogText = "将【[EquipName]】打洞成【[ReplaceProduceName]】时，需要消耗：[ReplaceMaterials]\n注意事项：精炼＋7及以上和已打过洞的装备或者破损装备无法成为材料",
    Option = {3, 7}
  },
  [52] = {
    DialogText = "该装备的卡槽数已达上限，无法进行打洞",
    Option = {7}
  },
  [53] = {
    DialogText = "打洞后卡片、附魔、强化、精炼、缝纫加固等级全部继承，继续吗？",
    Option = {4, 7}
  },
  [54] = {
    DialogText = "恭喜你获得【[ReplaceProduceName]】"
  },
  [55] = {
    DialogText = "材料不足\n注意事项：如果所需材料中，需要装备，那么精炼＋7及以上和已打过洞的装备或者破损装备无法成为材料",
    Option = {7}
  },
  [60] = {
    DialogText = "可是你该部位没有穿戴装备，无法提供服务",
    Option = {8}
  },
  [61] = {
    DialogText = "【[EquipName]】升级为【[UpgradeProduceName]】需要以下材料：[UpgradeMaterials]",
    Option = {5, 8},
    ShowEvent = "ShowUpgradeItem"
  },
  [62] = {
    DialogText = "你身上的【[EquipName]】不能升级，拿其他装备来我这里尝试下。",
    Option = {8}
  },
  [63] = {
    DialogText = "现在为你升级，请不用担心，升级后卡片、附魔、强化、缝纫加固都会继承哦~\n注意事项：当升级完最终回End档后，你的装备会升级成新的装备，所以精炼会下降2级，若新的装备没有卡槽，卡片会卸下并返还至包包中，请注意！",
    Option = {6, 8}
  },
  [64] = {
    DialogText = "我已为你打造成功，这是升级后的【[UpgradeProduceName]】，欢迎再次选择我们乌加特家族"
  },
  [65] = {
    DialogText = "材料不足\n注意事项：如果所需材料中，需要装备，那么精炼＋7及以上和已打过洞的装备无法成为材料",
    Option = {8}
  },
  [66] = {
    DialogText = "职业等级不符合",
    Option = {8}
  },
  [80] = {
    DialogText = "必须完成职业等级突破上限任务后才能提升Job上限等级。"
  },
  [81] = {
    DialogText = "收集[UpJobLvMaterialsData]给我，我可以为你提升[UpJobLvNumber]级职业等级上限。",
    Option = {10}
  },
  [82] = {
    DialogText = "材料不足，请收集[UpJobLvMaterialsData]后再来找我吧。"
  },
  [83] = {
    DialogText = "材料已经收集齐全了，现在请闭上眼睛吧。",
    Option = {11}
  },
  [84] = {
    DialogText = "你的职业等级上限已经提升了[UpJobLvNumber]级。"
  },
  [85] = {
    DialogText = "当前已经无法再提升你的职业等级上限了。"
  },
  [86] = {
    DialogText = "当前猫砂盆Lv.[CatLitterBoxLv]（已满级），公会挑战奖励将会额外获得[CatLitterBoxExtraReward]%"
  },
  [87] = {
    DialogText = "当前猫砂盆Lv.[CatLitterBoxLv]，公会挑战奖励将会额外获得[CatLitterBoxExtraReward]%，升到下一级将会额外获得[NextLvCatLitterBoxExtraReward]%",
    Option = {73}
  },
  [100] = {
    DialogText = "可以将当前职业【[CurJobName]】突破到下一阶段【[NextJobName]】，并且可以获得：技能重置棒*1，轮回之石*1",
    Option = {20, 21}
  },
  [101] = {
    DialogText = "你已经成功转职啦。"
  },
  [102] = {
    DialogText = "等你考虑好了再来。"
  },
  [103] = {
    DialogText = "可以领取一枚当前职业系的S级符文，每个职业系仅可领取一次",
    Option = {22, 21}
  },
  [104] = {
    DialogText = "所选S级符文已领取成功。"
  },
  [105] = {
    DialogText = "你当前已达到起源转职状态，不可再进行职业升阶。"
  },
  [106] = {
    DialogText = "你已成功领取过本职业系S级符文，同职业系不可重复领取。"
  },
  [107] = {
    DialogText = "你当前职业的起源转职阶段暂未开放，敬请期待。"
  },
  [200] = {
    DialogText = "该知道的你都已经知道了，我已经没有更多的消息了。"
  },
  [201] = {
    DialogText = "你好，冒险家，想听听今天都有什么有意思的消息吗？",
    Option = {31, 32}
  },
  [202] = {
    DialogText = "嗯？我可以告诉你一些消息......只不过呢，需要一点点报酬~不如你先给我[BFSecretCurrentCost])",
    Option = {33, 34}
  },
  [203] = {
    DialogText = "哈哈哈，你可真爽快！",
    Option = {35}
  },
  [204] = {
    DialogText = "啧啧，犹犹豫豫的家伙可不受欢迎。"
  },
  [205] = {
    DialogText = "你还真的是个直爽的人呢",
    Option = {36}
  },
  [206] = {
    DialogText = "咦，你身上带的可不太够哦~"
  },
  [207] = {
    DialogText = "[BFSecretNewResult]"
  },
  [208] = {
    DialogText = "想回忆一下以前从我这听到了什么？行啊……不过说真的，你的记性可不太好。",
    Option = {37}
  },
  [209] = {
    DialogText = "吝啬鬼休想从我这获得任何消息"
  },
  [210] = {
    DialogText = "今天我有些累了，明天你再来吧。"
  },
  [300] = {
    DialogText = "是谁来找我……已经很久没有感受到如此强大的能量波动了。",
    ClickDialog = "next"
  },
  [301] = {
    DialogText = "原来是穿梭于不同世界的冒险者啊。怎么？是有什么烦恼要向我倾诉么？",
    ClickDialog = 30000
  },
  [302] = {
    DialogText = "我可以同调你的精神，给予你一些安宁和祝福。",
    ClickDialog = "next"
  },
  [303] = {
    DialogText = "不过相对地，你要将你身上的混沌气息交给我。你当前有[NightmareValue]的混沌气息，当前需消耗[NightmareExchangeAttrPrice]个混沌气息，同时获得[NightmareExchangeAttr]的属性奖励。你愿意吗？",
    Option = {30001, 30002},
    ClickDialog = 30002
  },
  [304] = {
    DialogText = "好，那么就让我来看看你的精神世界到底发生了什么……",
    ClickDialog = 30003
  },
  [305] = {
    DialogText = "这点混沌气息是不足以给我的，你还是攒够了再来吧。"
  },
  [306] = {
    DialogText = "吝惜于这点东西的你看来也不过如此。"
  },
  [307] = {
    DialogText = "好了，你已经获得了心灵的安宁和祝福。还需要吗？你当前有[NightmareValue]的混沌气息，当前需消耗[NightmareExchangeAttrPrice]个混沌气息，同时获得[NightmareExchangeAttr]的属性奖励。",
    Option = {30004, 30005},
    ClickDialog = 30005
  },
  [308] = {
    DialogText = "好，那么我们继续。",
    ClickDialog = 30006
  },
  [309] = {
    DialogText = "永夜徘徊在此，混沌气息不会轻易消散。我已经无法再增强你的能力了，接下来的道路需要你自己来开拓，但是如果你仍需要净化自身的话，那就来找我吧，我可以用这梦境中的珍宝与你交换！"
  },
  [320] = {
    DialogText = "我可以将你身上的混沌气息清除，当然作为回报，我会给你相应的奖励，这可是这梦境中无上的珍宝！",
    Option = {30008},
    ClickDialog = 30008
  },
  [321] = {
    DialogText = "让我看看你的身上有多少混沌气息，啊，你身上有[NightmareValue]的混沌气息。每给我[NightmareExchangePrice]个混沌气息，我可以给你[NightmareExchangeGetItem]作为奖励！",
    Option = {30009, 30010},
    ClickDialog = 30010
  },
  [322] = {
    DialogText = "让我看看你的身上有多少混沌气息，啊，你身上有[NightmareValue]的混沌气息。每给我[NightmareExchangePrice]个混沌气息，我可以给你[NightmareExchangeGetItem]作为奖励！",
    Option = {30011, 30012}
  },
  [323] = {
    DialogText = "让我看看你的身上有多少混沌气息，啊，你身上有[NightmareValue]的混沌气息。每给我[NightmareExchangePrice]个混沌气息，我可以给你[NightmareExchangeGetItem]作为奖励！",
    ClickDialog = 30013
  },
  [324] = {
    DialogText = "好了，你已经获得了心灵的安宁和祝福。我已尽我最大力量的清除了你的混沌气息，冒险家，愿你在这梦境中平安。"
  },
  [325] = {
    DialogText = "好了，你已经获得了心灵的安宁和祝福。还需要吗？记得要用混沌气息交换。",
    Option = {30014, 30005},
    ClickDialog = 30005
  },
  [390] = {
    DialogText = "错误：服务器返回失败"
  },
  [391] = {
    DialogText = "嗯……你的精神世界中有一条深不见底的漆黑通道，落下一束微弱的光芒。我已经增强你的部分能力，[NightmareAttrResult] 放手一搏吧，冒险家！",
    ClickDialog = 30007
  },
  [392] = {
    DialogText = "你一跃而起，奋力伸出双手，去追寻那微弱的希望。我已经增强你的部分能力，[NightmareAttrResult] 放手一搏吧，冒险家！",
    ClickDialog = 30007
  },
  [393] = {
    DialogText = "滚滚的雷声，厚重的乌云，灰暗的天空下，一切色彩的踪影皆无……我已经增强你的部分能力，[NightmareAttrResult] 放手一搏吧，冒险家！",
    ClickDialog = 30007
  },
  [394] = {
    DialogText = "你的眼瞳中绽放出光芒，沐浴朝阳，向着地平线起飞，摆脱无尽的深渊。我已经增强你的部分能力，[NightmareAttrResult] 放手一搏吧，冒险家！",
    ClickDialog = 30007
  },
  [395] = {
    DialogText = "破碎的未来彼方，也许就是重生的希望。我已经增强你的部分能力，[NightmareAttrResult] 放手一搏吧，冒险家！",
    ClickDialog = 30007
  },
  [400] = {
    DialogText = "在这花开之地，就连魔物也很守规矩呢。毕竟惹怒了芙蕾雅大人可不是好玩的。",
    Option = {40, 41}
  },
  [401] = {
    DialogText = "让我看看本周都有哪些魔物驻守此地",
    Option = {42}
  },
  [402] = {
    DialogText = "让我查查看下周驻守此地的魔物都是谁",
    Option = {43}
  },
  [403] = {
    DialogText = "本周，花开之地的驻守者是[CurMonsterBatch]"
  },
  [404] = {
    DialogText = "在下周，降临花开之地的看守者将是[NextMonsterBatch]"
  },
  [500] = {
    DialogText = "是否将当前持有的[CurMultiExpTime]锁链雷锭buff转换为[MultiExpTime]坠星陨铁buff。",
    Option = {50, 51}
  },
  [501] = {
    DialogText = "下次再来。"
  },
  [502] = {
    DialogText = "已经成功兑换为[MultiExpTime]的坠星陨铁时长。"
  },
  [503] = {
    DialogText = "暂无可以兑换的锁链雷锭buff。"
  },
  [600] = {
    DialogText = "即将为您开启任务修复功能，请在[c][ffff00]主界面右侧任务列表[-][/c]中选取阻断的任务尝试修复。（修复操作只能在普隆德拉进行）",
    Option = {60}
  },
  [1000] = {
    DialogText = "我有一份礼物要送给那些[c][ffff00]回归[-][/c]米德加尔特的冒险者，可惜你不是呢——要不要去召集一些久别的伙伴呢？"
  },
  [1001] = {
    DialogText = "欢迎回到米德加尔特，冒险者！我有一份礼物送给你和你的队伍成员！",
    Option = {1001}
  },
  [1101] = {
    DialogText = "是否将当前持有的[c][ffff00][CurSand][-][/c]个时光流沙转换为[c][ffff00][SandExchangeItem][-][/c]个超大型JOB药水？",
    Option = {71, 72}
  },
  [1102] = {
    DialogText = "下次再来。"
  },
  [1103] = {
    DialogText = "已经成功兑换为[c][ffff00][SandExchangeItem][-][/c]个超大型JOB药水。"
  },
  [1104] = {
    DialogText = "暂无可以兑换的时光流沙。"
  },
  [1201] = {
    DialogText = "即将回收所有公会成员处的公会神器到公会仓库中，是否确认？",
    Option = {12011, 12012}
  },
  [1202] = {
    DialogText = "公会神器已经全部收回！请到公会仓库中查看。"
  }
}
EventDialogOption = {
  [3] = {
    Name = "继续",
    FuncType = "Replace_MaterialEnough",
    Result1 = {NextDialog = 53},
    Result2 = {NextDialog = 55}
  },
  [4] = {
    Name = "进行打洞",
    FuncType = "DoReplace",
    Result1 = {NextDialog = 54}
  },
  [5] = {
    Name = "下一步",
    FuncType = "Upgrade_MaterialEnough",
    Result1 = {NextDialog = 63},
    Result2 = {NextDialog = 65},
    Result3 = {NextDialog = 66}
  },
  [6] = {
    Name = "进行升级",
    FuncType = "DoUpgrade",
    Result1 = {NextDialog = 64}
  },
  [7] = {
    Name = "返回",
    Result1 = {
      DialogEventType = "EquipReplace"
    }
  },
  [8] = {
    Name = "返回",
    Result1 = {
      DialogEventType = "EquipUpgrade"
    }
  },
  [10] = {
    Name = "下一步",
    FuncType = "CanUpJobLv",
    Result1 = {NextDialog = 83},
    Result2 = {NextDialog = 82},
    Result3 = {NextDialog = 85}
  },
  [11] = {
    Name = "下一步",
    FuncType = "DoUpJobLv",
    Result1 = {NextDialog = 84}
  },
  [15] = {
    Name = "继续",
    Result1 = {NextDialog = 91}
  },
  [16] = {
    Name = "转化",
    FuncType = "ConsumeDeadCoin",
    Result1 = {NextDialog = 92},
    Result2 = {NextDialog = 93}
  },
  [17] = {
    Name = "返回",
    Result1 = {NextDialog = 96}
  },
  [18] = {
    Name = "继续",
    Result1 = {NextDialog = 96}
  },
  [20] = {
    Name = "确定",
    FuncType = "ChangeClass",
    Result1 = {NextDialog = 101},
    Result2 = {NextDialog = 104},
    Result3 = {NextDialog = 107}
  },
  [21] = {
    Name = "返回",
    Result1 = {NextDialog = 102}
  },
  [22] = {
    Name = "确定",
    FuncType = "ChangeClassGetGem",
    Result1 = {NextDialog = 104}
  },
  [31] = {
    Name = "好！",
    FuncType = "Event_GetNewBFSecret",
    Result1 = {NextDialog = 203},
    Result2 = {NextDialog = 206},
    Result3 = {NextDialog = 200}
  },
  [32] = {
    Name = "再想想",
    Result1 = {NextDialog = 204}
  },
  [33] = {
    Name = "好！",
    FuncType = "Event_GetNewBFSecret",
    Result1 = {NextDialog = 205},
    Result2 = {NextDialog = 206},
    Result3 = {NextDialog = 200}
  },
  [34] = {
    Name = "再想想",
    Result1 = {NextDialog = 209}
  },
  [35] = {
    Name = "快告诉我吧",
    Result1 = {NextDialog = 207}
  },
  [36] = {
    Name = "好的",
    Result1 = {NextDialog = 207}
  },
  [37] = {
    Name = "拜托了",
    FuncType = "Event_GetBFSecretHistory"
  },
  [40] = {
    Name = "本周刷新魔物",
    FuncType = "Event_CallCurMonsterBatch",
    Result1 = {NextDialog = 401},
    Result2 = {NextDialog = 403}
  },
  [41] = {
    Name = "下周刷新魔物",
    FuncType = "Event_CallNextMonsterBatch",
    Result1 = {NextDialog = 402},
    Result2 = {NextDialog = 404}
  },
  [42] = {
    Name = "...",
    Result1 = {NextDialog = 403}
  },
  [43] = {
    Name = "...",
    Result1 = {NextDialog = 404}
  },
  [50] = {
    Name = "兑换",
    FuncType = "Event_CallTransMultiExp",
    Result1 = {NextDialog = 502},
    Result2 = {NextDialog = 503}
  },
  [51] = {
    Name = "思考一下",
    Result1 = {NextDialog = 501}
  },
  [60] = {
    Name = "好的",
    FuncType = "Event_CallQuestRepair"
  },
  [71] = {
    Name = "兑换",
    FuncType = "Event_CallExchangeSand",
    Result1 = {NextDialog = 1103},
    Result2 = {NextDialog = 1104}
  },
  [72] = {
    Name = "思考一下",
    Result1 = {NextDialog = 1102}
  },
  [73] = {
    Name = "升级设施",
    FuncType = "Event_BuildingSubmitMaterial"
  },
  [30000] = {
    Name = "开始时，检测玩家是否达到兑换属性的上限",
    FuncType = "Event_CheckNightmareAttrLimit",
    Result1 = {NextDialog = 302},
    Result2 = {NextDialog = 320}
  },
  [30001] = {
    Name = "是",
    FuncType = "Event_CheckAndExchangeNightmareAttr",
    Result1 = {NextDialog = 304},
    Result2 = {NextDialog = 305}
  },
  [30002] = {
    Name = "否",
    Result1 = {NextDialog = 306}
  },
  [30003] = {
    Name = "等待结果，属性加成语句加粗dialog随机播放",
    FuncType = "Event_CheckNightmareGetResult",
    Result1 = {
      DialogEventType = "Func_GetNightmareAttrDialog"
    },
    Result2 = {NextDialog = 390},
    Result3 = {NextDialog = 304}
  },
  [30004] = {
    Name = "还要交换",
    FuncType = "Event_CheckAndExchangeNightmareAttr",
    Result1 = {NextDialog = 308},
    Result2 = {NextDialog = 305}
  },
  [30005] = {
    Name = "先这样吧"
  },
  [30006] = {
    Name = "等待结果，属性加成语句加粗dialog随机播放",
    FuncType = "Event_CheckNightmareGetResult",
    Result1 = {
      DialogEventType = "Func_GetNightmareAttrDialog"
    },
    Result2 = {NextDialog = 390},
    Result3 = {NextDialog = 308}
  },
  [30007] = {
    Name = "属性兑换完之后，检测玩家是否达到兑换属性的上限",
    FuncType = "Event_CheckNightmareAttrLimit",
    Result1 = {NextDialog = 307},
    Result2 = {NextDialog = 309}
  },
  [30008] = {
    Name = "我知道了",
    Result1 = {NextDialog = 321}
  },
  [30009] = {
    Name = "交换",
    FuncType = "Event_CheckNightmareValue",
    Result1 = {NextDialog = 322},
    Result2 = {NextDialog = 305}
  },
  [30010] = {
    Name = "暂不交换",
    Result1 = {NextDialog = 306}
  },
  [30011] = {
    Name = "清除1次",
    FuncType = "Event_ExchangeNightmareOnce",
    Result1 = {NextDialog = 323}
  },
  [30012] = {
    Name = "全部清除",
    FuncType = "Event_ExchangeNightmareAll",
    Result1 = {NextDialog = 323}
  },
  [30013] = {
    Name = "等待结果",
    FuncType = "Event_CheckNightmareGetResult",
    Result1 = {
      DialogEventType = "Func_GetNightmareExchangeDialog"
    },
    Result2 = {NextDialog = 390},
    Result3 = {NextDialog = 323}
  },
  [30014] = {
    Name = "还要交换",
    Result1 = {NextDialog = 322}
  },
  [1001] = {
    Name = "谢谢",
    FuncType = "ReturnPlayerRaidReward"
  },
  [12011] = {
    Name = "确认",
    FuncType = "Event_RetrieveAllArtifacts",
    Result1 = {NextDialog = 1202}
  },
  [12012] = {Name = "再想想"}
}
DialogParamType = {
  StoragePrice = "Dialog_ParamType_StoragePrice",
  GuildName = "Dialog_ParamType_GuildName",
  GuildLeaderName = "Dialog_ParamType_GuildLeaderName",
  GvgSeason = "Dialog_ParamType_GvgSeason",
  TrippleChampion = "Dialog_ParamType_TrippleChampion",
  TeampwsChampion = "Dialog_ParamType_TeampwsChampion",
  TwelveChampion = "Dialog_ParamType_Twelvechampion",
  TrippleChampionScore = "Dialog_ParamType_TrippleChampionScore",
  GvgStatueBattleLine = "Dialog_ParamType_GvgStatueBattleLine",
  GvgStatueCity = "Dialog_ParamType_GvgStatueCity",
  GvgStatueGuildName = "Dialog_ParamType_GvgStatueGuildName",
  GvgStatueLeaderName = "Dialog_ParamType_GvgStatueLeaderName"
}
Dialog_ReplaceParam = {
  [2015] = {
    DialogParamType.StoragePrice
  },
  [3849] = {
    DialogParamType.StoragePrice
  },
  [3957] = {
    DialogParamType.StoragePrice
  },
  [7046] = {
    DialogParamType.StoragePrice
  },
  [7047] = {
    DialogParamType.StoragePrice
  },
  [93004] = {
    DialogParamType.StoragePrice
  },
  [131487] = {
    DialogParamType.StoragePrice
  },
  [8819] = {
    DialogParamType.StoragePrice
  },
  [8820] = {
    DialogParamType.StoragePrice
  },
  [8821] = {
    DialogParamType.StoragePrice
  },
  [8824] = {
    DialogParamType.StoragePrice
  },
  [8825] = {
    DialogParamType.StoragePrice
  },
  [8827] = {
    DialogParamType.StoragePrice
  },
  [8828] = {
    DialogParamType.StoragePrice
  },
  [8830] = {
    DialogParamType.StoragePrice
  },
  [8831] = {
    DialogParamType.StoragePrice
  },
  [8833] = {
    DialogParamType.StoragePrice
  },
  [8834] = {
    DialogParamType.StoragePrice
  },
  [81733] = {
    DialogParamType.StoragePrice
  },
  [84227] = {
    DialogParamType.StoragePrice
  },
  [84229] = {
    DialogParamType.StoragePrice
  },
  [84232] = {
    DialogParamType.StoragePrice
  },
  [88775] = {
    DialogParamType.StoragePrice
  },
  [51252] = {
    DialogParamType.StoragePrice
  },
  [51253] = {
    DialogParamType.StoragePrice
  },
  [101872] = {
    DialogParamType.StoragePrice
  },
  [101873] = {
    DialogParamType.StoragePrice
  },
  [101875] = {
    DialogParamType.StoragePrice
  },
  [101876] = {
    DialogParamType.StoragePrice
  },
  [101878] = {
    DialogParamType.StoragePrice
  },
  [101879] = {
    DialogParamType.StoragePrice
  },
  [108026] = {
    DialogParamType.StoragePrice
  },
  [108979] = {
    DialogParamType.StoragePrice
  },
  [108980] = {
    DialogParamType.StoragePrice
  },
  [108977] = {
    DialogParamType.StoragePrice
  },
  [320832] = {
    DialogParamType.StoragePrice
  },
  [320834] = {
    DialogParamType.StoragePrice
  },
  [320835] = {
    DialogParamType.StoragePrice
  },
  [305333] = {
    DialogParamType.StoragePrice
  },
  [305342] = {
    DialogParamType.StoragePrice
  },
  [305361] = {
    DialogParamType.StoragePrice
  },
  [305363] = {
    DialogParamType.StoragePrice
  },
  [305364] = {
    DialogParamType.StoragePrice
  },
  [600258] = {
    DialogParamType.StoragePrice
  },
  [400887] = {
    DialogParamType.StoragePrice
  },
  [400889] = {
    DialogParamType.StoragePrice
  },
  [400890] = {
    DialogParamType.StoragePrice
  },
  [400895] = {
    DialogParamType.StoragePrice
  },
  [400897] = {
    DialogParamType.StoragePrice
  },
  [400898] = {
    DialogParamType.StoragePrice
  },
  [400620] = {
    DialogParamType.StoragePrice
  },
  [400621] = {
    DialogParamType.StoragePrice
  },
  [400622] = {
    DialogParamType.StoragePrice
  },
  [401253] = {
    DialogParamType.StoragePrice
  },
  [550411] = {
    DialogParamType.StoragePrice
  },
  [550412] = {
    DialogParamType.StoragePrice
  },
  [550413] = {
    DialogParamType.StoragePrice
  },
  [550420] = {
    DialogParamType.StoragePrice
  },
  [550421] = {
    DialogParamType.StoragePrice
  },
  [550422] = {
    DialogParamType.StoragePrice
  },
  [550417] = {
    DialogParamType.StoragePrice
  },
  [550418] = {
    DialogParamType.StoragePrice
  },
  [550419] = {
    DialogParamType.StoragePrice
  },
  [601731] = {
    DialogParamType.StoragePrice
  },
  [451738] = {
    DialogParamType.StoragePrice
  },
  [451740] = {
    DialogParamType.StoragePrice
  },
  [451741] = {
    DialogParamType.StoragePrice
  },
  [452290] = {
    DialogParamType.StoragePrice
  },
  [452291] = {
    DialogParamType.StoragePrice
  },
  [452292] = {
    DialogParamType.StoragePrice
  },
  [452294] = {
    DialogParamType.StoragePrice
  },
  [452295] = {
    DialogParamType.StoragePrice
  },
  [452297] = {
    DialogParamType.StoragePrice
  },
  [452298] = {
    DialogParamType.StoragePrice
  },
  [452300] = {
    DialogParamType.StoragePrice
  },
  [452301] = {
    DialogParamType.StoragePrice
  },
  [405022] = {
    DialogParamType.StoragePrice,
    DialogParamType.StoragePrice
  },
  [800274] = {
    DialogParamType.StoragePrice
  },
  [800276] = {
    DialogParamType.StoragePrice
  },
  [800277] = {
    DialogParamType.StoragePrice
  },
  [395002] = {
    DialogParamType.GuildName,
    DialogParamType.GuildLeaderName,
    DialogParamType.GvgSeason
  },
  [396847] = {
    DialogParamType.TrippleChampion
  },
  [396848] = {
    DialogParamType.TeampwsChampion
  },
  [396849] = {
    DialogParamType.TwelveChampion
  },
  [396859] = {
    DialogParamType.GvgStatueBattleLine,
    DialogParamType.GvgStatueGuildName,
    DialogParamType.GvgStatueLeaderName,
    DialogParamType.GvgStatueCity
  },
  [396860] = {
    DialogParamType.GvgStatueBattleLine,
    DialogParamType.GvgStatueCity
  }
}
