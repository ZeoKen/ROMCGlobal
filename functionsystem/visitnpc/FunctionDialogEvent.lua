FunctionDialogEvent = class("FunctionDialogEvent")
autoImport("ItemUtil")
autoImport("ItemTipComCell")
autoImport("DialogEventConfig")
autoImport("EquipStrengthen")
FunctionDialogEvent.ReplaceAction = "functional_action"
FunctionDialogEvent.EventResult_Type = {
  Result_Succes = "Result1",
  Result_Fail_1 = "Result2",
  Result_Fail_2 = "Result3",
  Result_Wait = "Wait",
  Result_Close = "Close"
}
local tempV3 = LuaVector3()

function FunctionDialogEvent.Me()
  if nil == FunctionDialogEvent.me then
    FunctionDialogEvent.me = FunctionDialogEvent.new()
  end
  return FunctionDialogEvent.me
end

local DEFAULT_MATERIAL_SEARCH_BAGTYPES, UPGRADE_MATERIAL_SEARCH_BAGTYPES, REPLACE_MATERIAL_SEARCH_BAGTYPES, _BagProxy, _BlackSmithProxy, Func_Type_Map

function FunctionDialogEvent:ctor()
  Func_Type_Map = {
    EquipUpgrade = FunctionDialogEvent.SetEquipUpgrade,
    EquipReplace = FunctionDialogEvent.SetEquipReplace,
    UpJobLevel = FunctionDialogEvent.UpJobLevel,
    DialogGoddessOfferDead = FunctionDialogEvent.SetDialogGoddessOfferDead,
    FastClassChange = FunctionDialogEvent.FastClassChange,
    FastChangeClassGetGem = FunctionDialogEvent.FastChangeClassGetGem,
    Func_GetNewBFSecret = FunctionDialogEvent.Func_GetNewBFSecret,
    Func_GetBFSecretHistory = FunctionDialogEvent.Func_GetBFSecretHistory,
    Func_NightmareDialogStart = FunctionDialogEvent.Func_NightmareDialogStart,
    Func_GetNightmareAttrDialog = FunctionDialogEvent.Func_GetNightmareAttrDialog,
    Func_GetMonsterBatch = FunctionDialogEvent.Func_GetMonsterBatch,
    Func_TransMultiExp = FunctionDialogEvent.Func_TransMultiExp,
    Func_GetNightmareExchangeDialog = FunctionDialogEvent.Func_GetNightmareExchangeDialog,
    Func_QuestRepair = FunctionDialogEvent.Func_QuestRepair,
    Func_ReturnActivityReward = FunctionDialogEvent.Func_ReturnActivityReward,
    Func_ExchangeSand = FunctionDialogEvent.Func_ExchangeSand,
    Func_CatLitterBox = FunctionDialogEvent.Func_CatLitterBox,
    Func_RetrieveAllArtifacts = FunctionDialogEvent.Func_RetrieveAllArtifacts
  }
  local pacakgeCheck = GameConfig.PackageMaterialCheck
  DEFAULT_MATERIAL_SEARCH_BAGTYPES = pacakgeCheck and pacakgeCheck.default or {1, 9}
  UPGRADE_MATERIAL_SEARCH_BAGTYPES = pacakgeCheck and pacakgeCheck.upgrade or DEFAULT_MATERIAL_SEARCH_BAGTYPES
  REPLACE_MATERIAL_SEARCH_BAGTYPES = pacakgeCheck and pacakgeCheck.upgrade or DEFAULT_MATERIAL_SEARCH_BAGTYPES
  _BagProxy = BagProxy.Instance
  _BlackSmithProxy = BlackSmithProxy.Instance
  self:MapEventConfig()
end

function FunctionDialogEvent:MapEventConfig()
  self.paramaMap = {}
  self.paramaMap["%[EquipSite%]"] = FunctionDialogEvent.GetEquipSite
  self.paramaMap["%[EquipName%]"] = FunctionDialogEvent.GetEquipName
  self.paramaMap["%[ReplaceProduceName%]"] = FunctionDialogEvent.GetReplaceProduceName
  self.paramaMap["%[ReplaceMaterials%]"] = FunctionDialogEvent.GetReplaceMaterials
  self.paramaMap["%[UpgradeMaterials%]"] = FunctionDialogEvent.GetUpgradeMaterials
  self.paramaMap["%[UpgradeProduceName%]"] = FunctionDialogEvent.GetUpgradeProduceName
  self.paramaMap["%[UpJobLvMaterialsData%]"] = FunctionDialogEvent.UpJobLvMaterialsData
  self.paramaMap["%[CatLitterBoxLv%]"] = FunctionDialogEvent.CatLitterBoxLv
  self.paramaMap["%[CatLitterBoxExtraReward%]"] = FunctionDialogEvent.CatLitterBoxExtraReward
  self.paramaMap["%[NextLvCatLitterBoxExtraReward%]"] = FunctionDialogEvent.NextLvCatLitterBoxExtraReward
  self.paramaMap["%[UpJobLvNumber%]"] = FunctionDialogEvent.UpJobLvNumber
  self.paramaMap["%[CurrentDeadCoin%]"] = FunctionDialogEvent.CurrentDeadCoin
  self.paramaMap["%[LackOfDeadCoin%]"] = FunctionDialogEvent.LackOfDeadCoin
  self.paramaMap["%[DeadCoin%]"] = FunctionDialogEvent.DeadCoin
  self.paramaMap["%[DeadLv%]"] = FunctionDialogEvent.DeadLv
  self.paramaMap["%[CurJobName%]"] = FunctionDialogEvent.CurJobName
  self.paramaMap["%[NextJobName%]"] = FunctionDialogEvent.NextJobName
  self.paramaMap["%[BFSecretCurrentCost%]"] = FunctionDialogEvent.Param_BFSecretCurrentCost
  self.paramaMap["%[BFSecretNewResult%]"] = FunctionDialogEvent.Param_BFSecretNewResult
  self.paramaMap["%[NightmareValue%]"] = FunctionDialogEvent.Param_NightmareValue
  self.paramaMap["%[NightmareExchangePrice%]"] = FunctionDialogEvent.Param_NightmareExchangePrice
  self.paramaMap["%[NightmareExchangeGetItem%]"] = FunctionDialogEvent.Param_NightmareExchangeGetItem
  self.paramaMap["%[NightmareAttrResult%]"] = FunctionDialogEvent.Param_NightmareAttrResult
  self.paramaMap["%[NightmareExchangeAttrPrice%]"] = FunctionDialogEvent.Param_NightmareExchangeAttrPrice
  self.paramaMap["%[NightmareExchangeAttr%]"] = FunctionDialogEvent.Param_NightmareExchangeAttr
  self.paramaMap["%[CurMonsterBatch%]"] = FunctionDialogEvent.Param_CurMonsterBatch
  self.paramaMap["%[NextMonsterBatch%]"] = FunctionDialogEvent.Param_NextMonsterBatch
  self.paramaMap["%[CurMultiExpTime%]"] = FunctionDialogEvent.Param_CurMultiExpTime
  self.paramaMap["%[MultiExpTime%]"] = FunctionDialogEvent.Param_MultiExpTime
  self.paramaMap["%[CurSand%]"] = FunctionDialogEvent.Param_CurSand
  self.paramaMap["%[SandExchangeItem%]"] = FunctionDialogEvent.Param_SandExchangeItem
  self.eventMap = {}
  self.eventMap.Replace_MaterialEnough = FunctionDialogEvent.Replace_MaterialEnough
  self.eventMap.Upgrade_MaterialEnough = FunctionDialogEvent.Upgrade_MaterialEnough
  self.eventMap.CanUpJobLv = FunctionDialogEvent.CanUpJobLv
  self.eventMap.DoReplace = FunctionDialogEvent.DoReplace
  self.eventMap.DoUpgrade = FunctionDialogEvent.DoUpgrade
  self.eventMap.DoUpJobLv = FunctionDialogEvent.DoUpJobLv
  self.eventMap.ConsumeDeadCoin = FunctionDialogEvent.ConsumeDeadCoin
  self.eventMap.ChangeClassGetGem = FunctionDialogEvent.ChangeClassGetGem
  self.eventMap.ChangeClass = FunctionDialogEvent.ChangeClass
  self.eventMap.ReturnPlayerRaidReward = FunctionDialogEvent.ReturnPlayerRaidReward
  self.eventMap.Event_GetNewBFSecret = FunctionDialogEvent.Event_GetNewBFSecret
  self.eventMap.Event_GetBFSecretHistory = FunctionDialogEvent.Event_GetBFSecretHistory
  self.eventMap.Event_CheckNightmareAttrLimit = FunctionDialogEvent.Event_CheckNightmareAttrLimit
  self.eventMap.Event_CheckAndExchangeNightmareAttr = FunctionDialogEvent.Event_CheckAndExchangeNightmareAttr
  self.eventMap.Event_CheckNightmareGetResult = FunctionDialogEvent.Event_CheckNightmareGetResult
  self.eventMap.Event_CheckNightmareValue = FunctionDialogEvent.Event_CheckNightmareValue
  self.eventMap.Event_ExchangeNightmareOnce = FunctionDialogEvent.Event_ExchangeNightmareOnce
  self.eventMap.Event_ExchangeNightmareAll = FunctionDialogEvent.Event_ExchangeNightmareAll
  self.eventMap.Event_CallCurMonsterBatch = FunctionDialogEvent.Event_CallCurMonsterBatch
  self.eventMap.Event_CallNextMonsterBatch = FunctionDialogEvent.Event_CallNextMonsterBatch
  self.eventMap.Event_CallTransMultiExp = FunctionDialogEvent.Event_CallTransMultiExp
  self.eventMap.Event_CallQuestRepair = FunctionDialogEvent.Event_CallQuestRepair
  self.eventMap.Event_CallExchangeSand = FunctionDialogEvent.Event_CallExchangeSand
  self.eventMap.Event_BuildingSubmitMaterial = FunctionDialogEvent.Event_BuildingSubmitMaterial
  self.eventMap.Event_RetrieveAllArtifacts = FunctionDialogEvent.Event_RetrieveAllArtifacts
  self.checkEventMap = {}
  self.checkEventMap.Event_BuildingSubmitMaterial = FunctionDialogEvent.Check_Event_BuildingSubmitMaterial
  self.showEventMap = {}
  self.showEventMap.ShowUpgradeItem = FunctionDialogEvent.ShowUpgradeItemEvent
  self.dialogEventType = {}
  self.dialogEventType.EquipUpgrade = {}
end

function FunctionDialogEvent.GetEquipSite(parama, npc)
  local site = parama.site
  if site then
    site = site[1]
    for _, cfg in pairs(GameConfig.EquipType) do
      for _, sitecfg in pairs(cfg.site) do
        if sitecfg == site then
          return cfg.name
        end
      end
    end
  end
  return "NULL"
end

function FunctionDialogEvent.GetEquipName(parama, npc)
  local itemData = parama.itemData
  if itemData then
    return itemData:GetName(true, true)
  end
  return "NULL"
end

function FunctionDialogEvent.GetReplaceProduceName(parama, npc)
  local itemData = parama.itemData
  local composeId = itemData.equipInfo.equipData.SubstituteID
  local composeData = composeId and Table_Compose[composeId]
  local product = composeData.Product
  if product.id and Table_Item[product.id] then
    return Table_Item[product.id].NameZh
  end
  return "NULL"
end

function FunctionDialogEvent.GetUpgradeProduceName(parama, npc)
  local itemData = parama.itemData
  local equipInfo = itemData.equipInfo
  local upgradeData = equipInfo.upgradeData
  local equiplv = equipInfo.equiplv
  if equiplv < equipInfo.upgrade_MaxLv then
    return itemData.staticData.NameZh .. StringUtil.IntToRoman(equiplv + 1)
  else
    local productid = upgradeData.Product
    if productid then
      return Table_Item[productid].NameZh
    end
  end
end

function FunctionDialogEvent.UpJobLvMaterialsData(parama, npc)
  local itemConfig = GameConfig.Peak.itemaddlevel
  local itemid, num = itemConfig[1].item, itemConfig[1].num
  return string.format("%s x %s", Table_Item[itemid].NameZh, num)
end

function FunctionDialogEvent.CatLitterBoxLv(parama, npc)
  local type = GuildBuildingProxy.Type.EGUILDBUILDING_CAT_LITTER_BOX
  return GuildBuildingProxy.Instance:GetBuildingLevelByType(type)
end

function FunctionDialogEvent.CatLitterBoxExtraReward(parama, npc)
  local type = GuildBuildingProxy.Type.EGUILDBUILDING_CAT_LITTER_BOX
  local lv = GuildBuildingProxy.Instance:GetBuildingLevelByType(type)
  local id = GuildBuildingProxy.GetGuildBuildingID(type, lv)
  local rate = Table_GuildBuilding[id].UnlockParam.ChallengeRewardRatio or 10
  return math.floor((rate - 1) * 100)
end

function FunctionDialogEvent.NextLvCatLitterBoxExtraReward(parama, npc)
  local type = GuildBuildingProxy.Type.EGUILDBUILDING_CAT_LITTER_BOX
  local lv = GuildBuildingProxy.Instance:GetBuildingLevelByType(type) + 1
  local id = GuildBuildingProxy.GetGuildBuildingID(type, lv)
  local rate = Table_GuildBuilding[id].UnlockParam.ChallengeRewardRatio or 10
  return math.floor((rate - 1) * 100)
end

function FunctionDialogEvent.UpJobLvNumber(parama, npc)
  local itemConfig = GameConfig.Peak.itemaddlevel
  return itemConfig[1].level
end

function FunctionDialogEvent.CurrentDeadCoin(parama, npc)
  return Game.Myself.data.userdata:Get(UDEnum.DEADCOIN)
end

function FunctionDialogEvent.LackOfDeadCoin(parama, npc)
  local curOfferedNum = Game.Myself.data.userdata:Get(UDEnum.DEADEXP) or 0
  local deadLvData = Table_DeadLevel[Game.Myself.data.userdata:Get(UDEnum.DEADLV) + 1]
  return math.max((deadLvData and deadLvData.exp or 0) - curOfferedNum, 0)
end

function FunctionDialogEvent.DeadCoin(parama, npc)
  return Table_Item[GameConfig.Dead.deadcoinID].NameZh
end

function FunctionDialogEvent.DeadLv(parama, npc)
  return Game.Myself.data.userdata:Get(UDEnum.DEADLV)
end

function FunctionDialogEvent.CurJobName(param, npc)
  return MyselfProxy.Instance:GetMyProfessionName()
end

function FunctionDialogEvent.NextJobName(param, npc)
  local professionid = Game.Myself.data.userdata:Get(UDEnum.PROFESSION)
  local advanceJob = Table_Class[professionid].AdvanceClass[1]
  return ProfessionProxy.GetProfessionName(advanceJob, MyselfProxy.Instance:GetMySex())
end

function FunctionDialogEvent.Param_BFSecretCurrentCost(param, npc)
  local todayGet = BFBuildingProxy.Instance:SecretGetTodayCount()
  local cost = GameConfig.BuildingCooperate.MapSecretCost[todayGet + 1]
  if cost and 1 < #cost then
    local name = Table_Item[cost[1]] and Table_Item[cost[1]].NameZh
    return string.format("%sX%d", name, cost[2])
  end
  return "..."
end

function FunctionDialogEvent.Param_BFSecretNewResult(param, npc)
  local newGet = BFBuildingProxy.Instance:SecretGetNew()
  if newGet and Table_ExploreSecret[newGet] then
    return Table_ExploreSecret[newGet].Desc
  else
    return "......" .. (newGet or "nil")
  end
end

function FunctionDialogEvent.Param_NightmareValue(param, npc)
  return tostring(Game.Myself.data.userdata:Get(UDEnum.NIGHTMARE) or 0)
end

function FunctionDialogEvent.Param_NightmareExchangePrice(param, npc)
  return tostring(GameConfig.Nightmare.ExchangeItemCost)
end

function FunctionDialogEvent.Param_NightmareExchangeGetItem(param, npc)
  local str = ""
  for i = 1, #GameConfig.Nightmare.ExchangeItem do
    local cfg = GameConfig.Nightmare.ExchangeItem[i]
    local item = cfg[1]
    local count = cfg[2]
    local name = Table_Item[item] and Table_Item[item].NameZh
    if i == #GameConfig.Nightmare.ExchangeItem then
      str = str .. string.format("%sx%d", name, count)
    else
      str = str .. string.format("%sx%d,", name, count)
    end
  end
  return str
end

local attrStrFunc = function(s1, s2)
  s1 = ItemUtil.GetAttributeNameFromAbbreviation(s1)
  if string.find(s1, "%%") then
    return string.gsub(s1, "%%", "+" .. tostring(s2 * 100) .. "%%%%,")
  else
    return string.format("%s+%s,", s1, tostring(s2))
  end
end

function FunctionDialogEvent.Param_NightmareAttrResult(param, npc)
  local exchangeCount = BFBuildingProxy.Instance:NightmareExchangeCount()
  local attr = GameConfig.Nightmare.ExchangeAttr[exchangeCount]
  local str = ""
  for _, v in pairs(attr.attr) do
    str = str .. attrStrFunc(v[1], v[2])
  end
  return str
end

function FunctionDialogEvent.Param_NightmareExchangeAttrPrice(param, npc)
  local nextExchange = BFBuildingProxy.Instance:NightmareExchangeCount() + 1
  local attr = GameConfig.Nightmare.ExchangeAttr[nextExchange]
  return attr and attr.cost or ""
end

function FunctionDialogEvent.Param_NightmareExchangeAttr(param, npc)
  local nextExchange = BFBuildingProxy.Instance:NightmareExchangeCount() + 1
  local attr = GameConfig.Nightmare.ExchangeAttr[nextExchange]
  local str = ""
  if attr and attr.attr then
    for _, v in pairs(attr.attr) do
      str = str .. attrStrFunc(v[1], v[2])
    end
  end
  return str
end

function FunctionDialogEvent.Param_CurMonsterBatch(param, npc)
  local monsterInfo = MonsterInfoProxy.Instance:GetCurMonsterBatchInfo()
  local str = ""
  if monsterInfo and #monsterInfo then
    for i = 1, #monsterInfo do
      local staticData = Table_Monster[monsterInfo[i]]
      str = str .. "[c][ffff00]" .. OverSea.LangManager.Instance():GetLangByKey(staticData.NameZh) .. "[-][/c]"
      if i ~= #monsterInfo then
        str = str .. ", "
      end
    end
  end
  return str
end

function FunctionDialogEvent.Param_NextMonsterBatch(param, npc)
  local monsterInfo = MonsterInfoProxy.Instance:GetNextMonsterBatchInfo()
  local str = ""
  if monsterInfo and #monsterInfo then
    for i = 1, #monsterInfo do
      local staticData = Table_Monster[monsterInfo[i]]
      str = str .. "[c][ffff00]" .. OverSea.LangManager.Instance():GetLangByKey(staticData.NameZh) .. "[-][/c]"
      if i ~= #monsterInfo then
        str = str .. ", "
      end
    end
  end
  return str
end

function FunctionDialogEvent.Param_CurMultiExpTime(param, npc)
  local doubleExpBuff = FunctionBuff.Me():GetBuffByID(8002)
  local str = ""
  if doubleExpBuff then
    local layer = doubleExpBuff.layer
    local leftTime = math.ceil(layer / 60)
    str = str .. "[c][ffff00]" .. string.format(ZhString.MinutesFormat, leftTime) .. "[-][/c]"
  end
  return str
end

function FunctionDialogEvent.Param_MultiExpTime(param, npc)
  local doubleExpBuff = FunctionBuff.Me():GetBuffByID(8002)
  local str = ""
  if doubleExpBuff then
    local layer = doubleExpBuff.layer
    local leftTime = math.ceil(layer / 60 / 2)
    str = str .. "[c][ffff00]" .. string.format(ZhString.MinutesFormat, leftTime) .. "[-][/c]"
  end
  return str
end

function FunctionDialogEvent.Param_CurSand(param, npc)
  return tostring(param)
end

function FunctionDialogEvent.Param_SandExchangeItem(param, npc)
  local _, newItemNum = ItemFun.oldItemExchange(GameConfig.MoneyId.FourthSkillSand, param)
  return tostring(newItemNum)
end

local Func_GetMaterial_SearchNum = function(itemid, search_bagTypes, filterDamage)
  if itemid == 100 then
    return Game.Myself.data.userdata:Get(UDEnum.SILVER)
  else
    search_bagTypes = search_bagTypes or DEFAULT_MATERIAL_SEARCH_BAGTYPES
    local items
    if ItemData.CheckIsEquip(itemid) then
      items = _BlackSmithProxy:GetMaterialEquips_ByEquipId(itemid, nil, filterDamage, nil, search_bagTypes)
    else
      items = _BagProxy:GetMaterialItems_ByItemId(itemid, search_bagTypes)
    end
    local searchNum = 0
    if items then
      for i = 1, #items do
        if _BagProxy:CheckIfFavoriteCanBeMaterial(items[i]) ~= false then
          searchNum = searchNum + items[i].num
        end
      end
    end
    return searchNum, items
  end
end

function FunctionDialogEvent.GetReplaceMaterials(parama, npc)
  local itemData = parama.itemData
  local composeId = itemData.equipInfo.equipData.SubstituteID
  local composeData = composeId and Table_Compose[composeId]
  local cost = composeData.BeCostItem
  local resultStr, materialStr = ""
  for i = 1, #cost do
    local id = cost[i].id
    materialStr = string.format(ZhString.FunctionDialogEvent_MaterialFormat, Table_Item[id].NameZh, Func_GetMaterial_SearchNum(id, UPGRADE_MATERIAL_SEARCH_BAGTYPES, true), cost[i].num)
    if i < #cost then
      materialStr = materialStr .. ZhString.FunctionDialogEvent_And
    end
    resultStr = resultStr .. materialStr
  end
  if composeData.ROB > 0 then
    resultStr = resultStr .. string.format(ZhString.FunctionDialogEvent_ZenyCost, composeData.ROB)
  end
  return resultStr
end

function FunctionDialogEvent.GetUpgradeMaterials(parama, npc)
  local itemData = parama.itemData
  local upgradeData = itemData.equipInfo.upgradeData
  local resultStr = ""
  local equiplv = itemData.equipInfo.equiplv
  local materialsKey = "Material_" .. equiplv + 1
  local cost = upgradeData[materialsKey]
  if cost then
    local materialStr = ""
    for i = 1, #cost do
      local id = cost[i].id
      materialStr = string.format(ZhString.FunctionDialogEvent_MaterialFormat, Table_Item[id].NameZh, Func_GetMaterial_SearchNum(id, nil, true), cost[i].num)
      if i < #cost then
        materialStr = materialStr .. ZhString.FunctionDialogEvent_And
      end
      resultStr = resultStr .. materialStr
    end
  end
  return resultStr
end

function FunctionDialogEvent.Replace_MaterialEnough(parama, npc)
  local itemData = parama.itemData
  local composeId = itemData.equipInfo.equipData.SubstituteID
  local composeData = composeId and Table_Compose[composeId]
  if MyselfProxy.Instance:GetROB() < composeData.ROB then
    return FunctionDialogEvent.EventResult_Type.Result_Fail_1
  end
  local composeCost = composeData.BeCostItem
  local equipItems, lackMats
  for i = 1, #composeCost do
    local itemCfg = composeCost[i]
    local itemid, neednum = itemCfg.id, itemCfg.num or 1
    local searchNum = 0
    if ItemData.CheckIsEquip(itemid) then
      equipItems = _BlackSmithProxy:GetMaterialEquips_ByEquipId(itemid, neednum, true, nil, REPLACE_MATERIAL_SEARCH_BAGTYPES)
      for j = 1, #equipItems do
        searchNum = searchNum + equipItems[j].num
      end
    else
      searchNum = Func_GetMaterial_SearchNum(itemid)
    end
    if itemid ~= 100 and neednum > searchNum then
      if lackMats == nil then
        lackMats = {}
      end
      table.insert(lackMats, {
        id = itemid,
        count = neednum - searchNum
      })
    end
  end
  if lackMats and QuickBuyProxy.Instance:TryOpenView(lackMats, QuickBuyProxy.QueryType.NoDamage) then
    return FunctionDialogEvent.EventResult_Type.Result_Close
  end
  local hasRecover, tipEquips = FunctionItemFunc.RecoverEquips(equipItems)
  if hasRecover then
    return FunctionDialogEvent.EventResult_Type.Result_Wait
  end
  if 0 < #tipEquips then
    local confirmMsgParam = {}
    confirmMsgParam.id = 247
    confirmMsgParam.param = {
      tipEquips[1].equipInfo.refinelv
    }
    return FunctionDialogEvent.EventResult_Type.Result_Wait, confirmMsgParam
  end
  return FunctionDialogEvent.EventResult_Type.Result_Succes
end

function FunctionDialogEvent.Upgrade_MaterialEnough(parama, npc)
  local itemData = parama.itemData
  local upgradeData = itemData.equipInfo.upgradeData
  local equiplv = itemData.equipInfo.equiplv
  local materialsKey = "Material_" .. equiplv + 1
  local cost = upgradeData[materialsKey]
  local costEquips, lackMats
  local matEnough = true
  for i = 1, #cost do
    local sc = cost[i]
    local searchNum = 0
    if sc.id == 100 then
      searchNum = Game.Myself.data.userdata:Get(UDEnum.SILVER) or 0
      if searchNum < sc.num then
        return FunctionDialogEvent.EventResult_Type.Result_Fail_1
      end
    elseif ItemData.CheckIsEquip(sc.id) then
      costEquips = _BlackSmithProxy:GetMaterialEquips_ByEquipId(sc.id, sc.num, true, nil, UPGRADE_MATERIAL_SEARCH_BAGTYPES)
      for j = 1, #costEquips do
        searchNum = searchNum + costEquips[j].num
      end
    else
      searchNum = Func_GetMaterial_SearchNum(sc.id)
    end
    if searchNum < sc.num then
      matEnough = false
    end
    if sc.id ~= 100 and searchNum < sc.num then
      if lackMats == nil then
        lackMats = {}
      end
      table.insert(lackMats, {
        id = sc.id,
        count = sc.num - searchNum
      })
    end
  end
  if lackMats and QuickBuyProxy.Instance:TryOpenView(lackMats, QuickBuyProxy.QueryType.NoDamage) then
    return FunctionDialogEvent.EventResult_Type.Result_Close
  end
  if not matEnough then
    return FunctionDialogEvent.EventResult_Type.Result_Fail_1
  end
  local hasRecover, tipEquips = FunctionItemFunc.RecoverEquips(costEquips)
  if hasRecover then
    return FunctionDialogEvent.EventResult_Type.Result_Wait
  end
  if 0 < #tipEquips then
    local confirmMsgParam = {}
    confirmMsgParam.id = 247
    confirmMsgParam.param = {
      tipEquips[1].equipInfo.refinelv
    }
    return FunctionDialogEvent.EventResult_Type.Result_Wait, confirmMsgParam
  end
  local nowEquiplv = itemData.equipInfo.equiplv
  if equiplv >= itemData.equipInfo.upgrade_MaxLv then
    local productid = upgradeData.Product
    local confirmMsgParam = {}
    confirmMsgParam.id = 25402
    confirmMsgParam.param = {
      Table_Item[productid].NameZh
    }
    return FunctionDialogEvent.EventResult_Type.Result_Wait, confirmMsgParam
  end
  local myClass = Game.Myself.data.userdata:Get(UDEnum.PROFESSION)
  local classDepth = ProfessionProxy.Instance:GetDepthByClassId(myClass)
  if not itemData.equipInfo:CanUpgrade_ByClassDepth(classDepth, nowEquiplv + 1) then
    return FunctionDialogEvent.EventResult_Type.Result_Fail_2
  end
  return FunctionDialogEvent.EventResult_Type.Result_Succes
end

function FunctionDialogEvent.CanUpJobLv(param, npc)
  if MyselfProxy.Instance:HasMaxJobBreak() then
    return FunctionDialogEvent.EventResult_Type.Result_Fail_2
  end
  local itemConfig = GameConfig.Peak.itemaddlevel
  local itemid, num = itemConfig[1].item, itemConfig[1].num
  local searchNum = BagProxy.Instance:GetItemNumByStaticID(itemid)
  if num > searchNum then
    return FunctionDialogEvent.EventResult_Type.Result_Fail_1
  end
  return FunctionDialogEvent.EventResult_Type.Result_Succes
end

function FunctionDialogEvent.DoReplace(parama, npc)
  local itemData = parama.itemData
  if npc then
    npc:Client_PlayAction(FunctionDialogEvent.ReplaceAction, nil, false)
  end
  ServiceItemProxy.Instance:CallEquipExchangeItemCmd(itemData.id, SceneItem_pb.EEXCHANGETYPE_EXCHANGE)
end

function FunctionDialogEvent.DoUpgrade(parama, npc)
  local itemData = parama.itemData
  ServiceItemProxy.Instance:CallEquipExchangeItemCmd(itemData.id, SceneItem_pb.EEXCHANGETYPE_LEVELUP)
end

function FunctionDialogEvent.DoUpJobLv(param, npc)
  local itemConfig = GameConfig.Peak.itemaddlevel
  local itemid, num = itemConfig[1].item, itemConfig[1].num
  helplog("Call-->AddJobLevelItemCmd", itemid, num)
  ServiceItemProxy.Instance:CallAddJobLevelItemCmd(itemid, num)
end

function FunctionDialogEvent.ConsumeDeadCoin(param, npc)
  if Game.Myself.data.userdata:Get(UDEnum.DEADCOIN) < 1 then
    return FunctionDialogEvent.EventResult_Type.Result_Fail_1
  end
  ServiceUserEventProxy.Instance:CallLevelupDeadUserEvent()
  local animParams = Asset_Role.GetPlayActionParams("use_skill2")
  animParams[7] = function()
    npc.assetRole:PlayAction_Simple(Asset_Role.ActionName.Idle)
  end
  npc.assetRole:PlayAction(animParams)
  return FunctionDialogEvent.EventResult_Type.Result_Succes
end

function FunctionDialogEvent:ChangeClassGetGem(param, npc)
  if ProfessionProxy.Instance:IsFastTransGemGet() then
    return FunctionDialogEvent.EventResult_Type.Result_Fail_1
  else
    GameFacade.Instance:sendNotification(UIEvent.ShowUI, {
      viewname = "FastClassChangeGetGemPopUp"
    })
    return FunctionDialogEvent.EventResult_Type.Result_Close
  end
end

function FunctionDialogEvent.ChangeClass(param, npc)
  local professionid = Game.Myself.data.userdata:Get(UDEnum.PROFESSION)
  if professionid % 10 == 5 then
    return FunctionDialogEvent.EventResult_Type.Result_Fail_1
  end
  ServiceNUserProxy.Instance:CallFastTransClassUserCmd()
  return FunctionDialogEvent.EventResult_Type.Result_Succes
end

function FunctionDialogEvent.Event_GetNewBFSecret(param, npc)
  local todayGet = BFBuildingProxy.Instance:SecretGetTodayCount()
  local result = FunctionDialogEvent.EventResult_Type.Result_Succes
  if todayGet >= GameConfig.BuildingCooperate.MapSecretDaily then
    result = FunctionDialogEvent.EventResult_Type.Result_Fail_2
  else
    repeat
      local cost = GameConfig.BuildingCooperate.MapSecretCost[todayGet + 1]
      if not cost or #cost < 2 then
      else
        do
          local selfNum = HappyShopProxy.Instance:GetItemNum(cost[1])
          if selfNum < cost[2] then
            result = FunctionDialogEvent.EventResult_Type.Result_Fail_1
            break -- pseudo-goto
          end
        end
      end
    until true
  end
  if result == FunctionDialogEvent.EventResult_Type.Result_Succes then
    ServiceMapProxy.Instance:CallUserSecretGetMapCmd()
  end
  return result
end

function FunctionDialogEvent.Event_GetBFSecretHistory(param, npc)
  FunctionNpcFunc.JumpPanel(PanelConfig.BFSecretHistoryPopup)
  return FunctionDialogEvent.EventResult_Type.Result_Close
end

function FunctionDialogEvent.Event_CheckNightmareAttrLimit()
  local exchangeCount = BFBuildingProxy.Instance:NightmareExchangeCount()
  local reachAttrLimit = #GameConfig.Nightmare.ExchangeAttr
  if exchangeCount < reachAttrLimit then
    return FunctionDialogEvent.EventResult_Type.Result_Succes
  else
    return FunctionDialogEvent.EventResult_Type.Result_Fail_1
  end
end

function FunctionDialogEvent.Event_CheckAndExchangeNightmareAttr()
  local nextExchange = BFBuildingProxy.Instance:NightmareExchangeCount() + 1
  local nightmareValue = Game.Myself.data.userdata:Get(UDEnum.NIGHTMARE) or 0
  local reachAttrLimit = GameConfig.Nightmare.ExchangeAttr[nextExchange]
  if reachAttrLimit and reachAttrLimit.cost and nightmareValue >= reachAttrLimit.cost then
    ServiceNUserProxy.Instance:CallNightmareAttrGetUserCmd(1)
    return FunctionDialogEvent.EventResult_Type.Result_Succes
  end
  return FunctionDialogEvent.EventResult_Type.Result_Fail_1
end

function FunctionDialogEvent.Event_CheckNightmareGetResult()
  if BFBuildingProxy.Instance.nightmareGetPending then
    return FunctionDialogEvent.EventResult_Type.Result_Fail_2
  elseif BFBuildingProxy.Instance.nightmareGetResult then
    return FunctionDialogEvent.EventResult_Type.Result_Succes
  end
  return FunctionDialogEvent.EventResult_Type.Result_Fail_1
end

function FunctionDialogEvent.Event_CheckNightmareValue()
  local exchangeMinCost = GameConfig.Nightmare.ExchangeItemCost
  local nightmareValue = Game.Myself.data.userdata:Get(UDEnum.NIGHTMARE) or 0
  if exchangeMinCost <= nightmareValue then
    return FunctionDialogEvent.EventResult_Type.Result_Succes
  else
    return FunctionDialogEvent.EventResult_Type.Result_Fail_1
  end
end

function FunctionDialogEvent.Event_ExchangeNightmareOnce()
  ServiceNUserProxy.Instance:CallNightmareAttrGetUserCmd(1)
  return FunctionDialogEvent.EventResult_Type.Result_Succes
end

function FunctionDialogEvent.Event_ExchangeNightmareAll()
  local exchangeMinCost = GameConfig.Nightmare.ExchangeItemCost
  local nightmareValue = Game.Myself.data.userdata:Get(UDEnum.NIGHTMARE) or 0
  local canExchangeMax = math.floor(nightmareValue / exchangeMinCost)
  ServiceNUserProxy.Instance:CallNightmareAttrGetUserCmd(canExchangeMax)
  return FunctionDialogEvent.EventResult_Type.Result_Succes
end

function FunctionDialogEvent.Event_CallCurMonsterBatch()
  local curMonsterBatch = MonsterInfoProxy.Instance:GetCurMonsterBatchInfo()
  if curMonsterBatch then
    helplog("本周怪物信息数据已存在")
    return FunctionDialogEvent.EventResult_Type.Result_Fail_1
  else
    ServiceNUserProxy.Instance:CallQueryMapMonsterRefreshInfo()
    redlog("本周怪物信息不存在")
    return FunctionDialogEvent.EventResult_Type.Result_Succes
  end
end

function FunctionDialogEvent.Event_CallNextMonsterBatch()
  local nextMonsterBatch = MonsterInfoProxy.Instance:GetNextMonsterBatchInfo()
  if nextMonsterBatch then
    helplog("下周怪物信息数据已存在")
    return FunctionDialogEvent.EventResult_Type.Result_Fail_1
  else
    ServiceNUserProxy.Instance:CallQueryMapMonsterRefreshInfo()
    return FunctionDialogEvent.EventResult_Type.Result_Succes
  end
end

function FunctionDialogEvent.Event_CallTransMultiExp()
  local checkSuccess = FunctionBuff.Me():GetBuffByID(8002)
  if checkSuccess then
    ServiceNUserProxy.Instance:CallChainExchangeUserCmd()
    return FunctionDialogEvent.EventResult_Type.Result_Succes
  else
    return FunctionDialogEvent.EventResult_Type.Result_Fail_1
  end
end

function FunctionDialogEvent.Event_CallQuestRepair()
  MyselfProxy.Instance:SetQuestRepairMode(true)
  return FunctionDialogEvent.EventResult_Type.Result_Close
end

function FunctionDialogEvent.ReturnPlayerRaidReward()
  ServiceActivityCmdProxy.Instance:CallUserReturnRaidAwardCmd()
  return FunctionDialogEvent.EventResult_Type.Result_Succes
end

function FunctionDialogEvent.Event_CallExchangeSand()
  ServiceItemProxy.Instance:CallOldItemExchangeItemCmd(GameConfig.MoneyId.FourthSkillSand)
  return FunctionDialogEvent.EventResult_Type.Result_Succes
end

function FunctionDialogEvent:GetFuncByConfig(key, npc)
  return self.eventMap[key]
end

function FunctionDialogEvent.Event_BuildingSubmitMaterial(param, nnpc)
  local data = GuildBuildingProxy.Instance:GetCurBuilding()
  if data and data.type == param then
    GuildBuildingProxy.Instance:InitBuilding(nnpc, param)
    FunctionNpcFunc.JumpPanel(PanelConfig.GuildBuildingMatSubmitView, {npcdata = nnpc})
  end
  return FunctionDialogEvent.EventResult_Type.Result_Close
end

function FunctionDialogEvent.Check_Event_BuildingSubmitMaterial(param, nnpc)
  return FunctionNpcFunc.CheckOpenBuildingSubmitMat(nnpc, param) == NpcFuncState.Active
end

function FunctionDialogEvent.Event_RetrieveAllArtifacts(param, nnpc)
  xdlog("Event_RetrieveAllArtifacts")
  ServiceGuildCmdProxy:CallArtifactOptGuildCmd(ArtifactProxy.OptionType.RetrieveAll)
  return FunctionDialogEvent.EventResult_Type.Result_Succes
end

function FunctionDialogEvent.ShowUpgradeItemEvent(viewPreferb, param)
  local itemData = param.itemData
  if not itemData then
    return
  end
  local equipInfo = itemData.equipInfo
  local upgradeData = equipInfo and equipInfo.upgradeData
  if not upgradeData then
    return
  end
  local upgradeItem
  if equipInfo.equiplv < equipInfo.upgrade_MaxLv then
    upgradeItem = ItemData.new("Upgrade", itemData.staticData.id)
    upgradeItem.equipInfo.equiplv = equipInfo.equiplv + 1
  else
    local productid = upgradeData.Product
    if not productid then
      return
    end
    upgradeItem = ItemData.new("Upgrade", productid)
  end
  local mid = Game.GameObjectUtil:DeepFind(viewPreferb, "Anchor_Middle")
  local tipRid = ResourcePathHelper.UICell("ItemTipComCell")
  local tipObj = Game.AssetManager_UI:CreateAsset(tipRid, mid)
  LuaVector3.Better_Set(tempV3, -350, 30, 0)
  tipObj.transform.localPosition = tempV3
  local nowTipCell = ItemTipComCell.new(tipObj)
  nowTipCell:UpdateTipButtons({})
  nowTipCell:SetData(itemData)
  nowTipCell:HideGetPath()
  nowTipCell:HidePreviewButton()
  local upRid = ResourcePathHelper.UICell("ItemTipUpgradeCell")
  local upObj = Game.AssetManager_UI:CreateAsset(upRid, mid)
  LuaVector3.Better_Set(tempV3, 120, 30, 0)
  upObj.transform.localPosition = tempV3
  local upTipCell = ItemTipComCell.new(upObj)
  upTipCell:UpdateTipButtons({})
  upTipCell:SetData(upgradeItem)
  upTipCell:HideGetPath()
  upTipCell:HidePreviewButton()
  IconManager:SetArtFontIcon("tips_bg_tex", upTipCell:FindComponent("UpgradeTip", UISprite))
  local hideFunc = function()
    GameObject.Destroy(tipObj)
    GameObject.Destroy(upObj)
    upTipCell:Exit()
    nowTipCell:Exit()
  end
  return hideFunc
end

function FunctionDialogEvent._SetEventDialogEvent(npcInfo, eventParam, ignoreConfirm)
  local optCfg, param = eventParam[1], eventParam[2]
  local result, func
  if optCfg.FuncType then
    func = FunctionDialogEvent.Me():GetFuncByConfig(optCfg.FuncType)
    if func then
      local eventResult, confirmMsgParam = func(param, npcInfo)
      if not ignoreConfirm then
        if confirmMsgParam then
          local confirm_confirmFunc = function()
            FunctionDialogEvent._SetEventDialogEvent(npcInfo, eventParam, true)
          end
          MsgManager.ConfirmMsgByID(confirmMsgParam.id, confirm_confirmFunc, nil, nil, unpack(confirmMsgParam.param))
          return true
        end
        if eventResult == FunctionDialogEvent.EventResult_Type.Result_Wait then
          return true
        elseif eventResult == FunctionDialogEvent.EventResult_Type.Result_Close then
          return false
        end
      end
      result = optCfg[eventResult] or optCfg.Result1
    end
  else
    result = optCfg.Result1
  end
  if result then
    if result.NextDialog then
      FunctionDialogEvent.Me():SetEventDialog(result.NextDialog, param, npcInfo)
    elseif result.DialogEventType then
      FunctionDialogEvent.SetDialogEventEnter(result.DialogEventType, npcInfo)
      return true
    end
  end
  if not func and not result then
    return false
  end
end

function FunctionDialogEvent:SetEventDialog(dialogId, param, npcInfo)
  local viewdata = {viewname = "DialogView"}
  local dcfg = EventDialog[dialogId]
  if not dcfg then
    return
  end
  local text = dcfg.DialogText
  for key, func in pairs(self.paramaMap) do
    if string.find(text, key) then
      local replaceStr = func(param, npcInfo)
      text = string.gsub(text, key, replaceStr)
    end
  end
  viewdata.dialoglist = {text}
  local optionIds = dcfg.Option
  if optionIds then
    local addfunc = {}
    for i = 1, #optionIds do
      local optId = optionIds[i]
      local optCfg = EventDialogOption[optId]
      if optCfg then
        local checkFunc = optCfg.FuncType and self.checkEventMap[optCfg.FuncType]
        if not checkFunc or checkFunc(param, npcInfo) == true then
          local func = {}
          func.NameZh = optCfg.Name
          func.event = FunctionDialogEvent._SetEventDialogEvent
          func.eventParam = {optCfg, param}
          table.insert(addfunc, func)
        end
      end
    end
    viewdata.addfunc = addfunc
  end
  if dcfg.ClickDialog then
    local optCfg
    if dcfg.ClickDialog == "next" then
      optCfg = {
        Result1 = {
          NextDialog = dialogId + 1
        }
      }
    else
      optCfg = EventDialogOption[dcfg.ClickDialog]
    end
    if optCfg then
      local func = {}
      func.NameZh = optCfg.Name
      func.event = FunctionDialogEvent._SetEventDialogEvent
      func.eventParam = {optCfg, param}
      viewdata.clickDialogFunc = func
    end
  end
  viewdata.npcinfo = npcInfo
  if dcfg.ShowEvent then
    viewdata.midShowFunc = self.showEventMap[dcfg.ShowEvent]
    viewdata.midShowFuncParam = param
  end
  if npcInfo.data.staticData.id == GameConfig.PurifyStake.NpcId then
    viewdata.cameraVP = GameConfig.PurifyStake.ViewPort
    viewdata.cameraRot = GameConfig.PurifyStake.Rotation
  end
  GameFacade.Instance:sendNotification(UIEvent.ShowUI, viewdata)
end

function FunctionDialogEvent.SetDialogEventEnter(type, npcInfo)
  FunctionDialogEvent.Me().npcguid = npcInfo.data.id
  if type and Func_Type_Map[type] then
    Func_Type_Map[type](npcInfo)
  end
end

function FunctionDialogEvent._DoReplaceOptEvent(npcInfo, eventParam)
  local siteEquip = _BagProxy.roleEquip:GetEquipBySite(eventParam[1])
  if eventParam[2] and (not siteEquip or not siteEquip.equipInfo.equipData.SubstituteID) then
    siteEquip = _BagProxy.roleEquip:GetEquipBySite(eventParam[2])
  end
  local param = {itemData = siteEquip}
  if siteEquip then
    local equipInfo = siteEquip.equipInfo
    if not equipInfo:IsNextGen() and equipInfo.equipData.SubstituteID then
      FunctionDialogEvent.Me():SetEventDialog(51, param, npcInfo)
    else
      FunctionDialogEvent.Me():SetEventDialog(52, param, npcInfo)
    end
  else
    FunctionDialogEvent.Me():SetEventDialog(2, param, npcInfo)
  end
end

function FunctionDialogEvent.SetEquipReplace(npcInfo)
  local npcfunction = npcInfo.data.staticData.NpcFunction
  local replaceFunc = npcfunction and npcfunction[1]
  if not replaceFunc then
    return
  end
  local parts, partsStr = replaceFunc.param, ""
  if not parts then
    return
  end
  local addfunc = {}
  for i = 1, #parts do
    local part = parts[i]
    local partConfig = GameConfig.EquipParts[part]
    local event = {}
    if BranchMgr.IsSEA() or BranchMgr.IsNA() or BranchMgr.IsEU() then
      event.NameZh = OverseasConfig.EquipParts[part].name .. NoTransString.FunctionDialogEvent_Replace
    else
      event.NameZh = partConfig.name .. ZhString.FunctionDialogEvent_Replace
    end
    event.event = FunctionDialogEvent._DoReplaceOptEvent
    event.eventParam = partConfig.site
    table.insert(addfunc, event)
    partsStr = partsStr .. partConfig.name
    if i < #parts then
      partsStr = partsStr .. "、"
    end
  end
  local viewdata = {viewname = "DialogView", npcinfo = npcInfo}
  local dialogText = ""
  if 0 < #addfunc then
    dialogText = EventDialog[1].DialogText
  else
    dialogText = EventDialog[2].DialogText
  end
  dialogText = string.format(dialogText, partsStr)
  viewdata.dialoglist = {dialogText}
  viewdata.addfunc = addfunc
  GameFacade.Instance:sendNotification(UIEvent.ShowUI, viewdata)
end

function FunctionDialogEvent.HelpCheckCanUpGradeEquip(npcInfo, item)
  if not item or not npcInfo then
    return false
  end
  local equipInfo = item.equipInfo
  if not equipInfo.upgradeData then
    return false
  end
  if equipInfo.equiplv > equipInfo.upgrade_MaxLv then
    return false
  end
  if equipInfo.equiplv == equipInfo.upgrade_MaxLv and equipInfo.upgradeData.Product == nil then
    return false
  end
  return equipInfo.upgradeData.NpcId == npcInfo.data.staticData.id
end

function FunctionDialogEvent._DoEquipUpgradeOpt(npcInfo, eventParam)
  local npcData = npcInfo.data.staticData
  local haveUpgradeEquip = false
  local siteEquip = _BagProxy.roleEquip:GetEquipBySite(eventParam[1])
  if not FunctionDialogEvent.HelpCheckCanUpGradeEquip(npcInfo, siteEquip) and eventParam[2] then
    siteEquip = _BagProxy.roleEquip:GetEquipBySite(eventParam[2])
  end
  if siteEquip then
    local param = {itemData = siteEquip}
    if FunctionDialogEvent.HelpCheckCanUpGradeEquip(npcInfo, siteEquip) then
      FunctionDialogEvent.Me():SetEventDialog(61, param, npcInfo)
    else
      FunctionDialogEvent.Me():SetEventDialog(62, param, npcInfo)
    end
  else
    FunctionDialogEvent.Me():SetEventDialog(60, nil, npcInfo)
  end
end

function FunctionDialogEvent.SetEquipUpgrade(npcInfo)
  local npcfunction = npcInfo.data.staticData.NpcFunction
  local upgradeFunc = npcfunction and npcfunction[1]
  local parts = upgradeFunc.param
  if not parts then
    return
  end
  local addfunc = {}
  for i = 1, #parts do
    local part = parts[i]
    local partConfig = GameConfig.EquipParts[part]
    local event = {}
    event.NameZh = partConfig.name .. ZhString.FunctionDialogEvent_Upgrade
    event.event = FunctionDialogEvent._DoEquipUpgradeOpt
    event.eventParam = partConfig.site
    table.insert(addfunc, event)
  end
  local viewdata = {
    viewname = "DialogView",
    dialoglist = {
      EventDialog[3].DialogText
    },
    npcinfo = npcInfo,
    addfunc = addfunc
  }
  GameFacade.Instance:sendNotification(UIEvent.ShowUI, viewdata)
end

function FunctionDialogEvent.UpJobLevel(npcInfo)
  local dialogId
  helplog("UpJobLevel", MyselfProxy.Instance:HasJobBreak())
  if MyselfProxy.Instance:HasJobBreak() then
    dialogId = 81
  else
    dialogId = 80
  end
  FunctionDialogEvent.Me():SetEventDialog(dialogId, nil, npcInfo)
end

function FunctionDialogEvent.SetDialogGoddessOfferDead(npcInfo)
  local curDeadLv = Game.Myself.data.userdata:Get(UDEnum.DEADLV) or 0
  local dialogId = curDeadLv < GameConfig.Dead.max_deadlv and 90 or 95
  FunctionDialogEvent.Me():SetEventDialog(dialogId, nil, npcInfo)
end

function FunctionDialogEvent.FastClassChange(npcInfo)
  local professionid = Game.Myself.data.userdata:Get(UDEnum.PROFESSION)
  local dialogId
  if professionid % 10 == 5 then
    dialogId = 105
  elseif GameConfig.Profession and GameConfig.Profession.ForbidFastTrans then
    local config = GameConfig.Profession.ForbidFastTrans
    for i = 1, #config do
      if professionid == config[i] then
        dialogId = 107
        break
      end
    end
  else
    dialogId = 100
  end
  dialogId = dialogId or 100
  FunctionDialogEvent.Me():SetEventDialog(dialogId, nil, npcInfo)
end

function FunctionDialogEvent.FastChangeClassGetGem(npcInfo)
  local dialogId
  if ProfessionProxy.Instance:IsFastTransGemGet() then
    dialogId = 106
  else
    dialogId = 103
  end
  FunctionDialogEvent.Me():SetEventDialog(dialogId, nil, npcInfo)
end

function FunctionDialogEvent.Func_GetNewBFSecret(npcInfo)
  local dialogId
  local todayGet = BFBuildingProxy.Instance:SecretGetTodayCount()
  local allHistory = BFBuildingProxy.Instance:SecretGetHistory() or {}
  if #allHistory >= GameConfig.BuildingCooperate.MapSecretList then
    dialogId = 200
  elseif todayGet >= GameConfig.BuildingCooperate.MapSecretDaily then
    dialogId = 210
  elseif todayGet == 0 then
    dialogId = 201
  else
    dialogId = 202
  end
  FunctionDialogEvent.Me():SetEventDialog(dialogId, nil, npcInfo)
end

function FunctionDialogEvent.Func_GetBFSecretHistory(npcInfo)
  FunctionDialogEvent.Me():SetEventDialog(208, nil, npcInfo)
end

function FunctionDialogEvent.Func_NightmareDialogStart(npcInfo)
  ServiceNUserProxy.Instance:CallNightmareAttrQueryUserCmd()
  FunctionDialogEvent.Me():SetEventDialog(300, nil, npcInfo)
end

function FunctionDialogEvent.Func_GetNightmareAttrDialog(npcInfo)
  local dialogId = math.random(391, 396)
  FunctionDialogEvent.Me():SetEventDialog(dialogId, nil, npcInfo)
end

function FunctionDialogEvent.Func_GetNightmareExchangeDialog(npcInfo)
  local exchangeMinCost = GameConfig.Nightmare.ExchangeItemCost
  local nightmareValue = Game.Myself.data.userdata:Get(UDEnum.NIGHTMARE) or 0
  local dialogId = exchangeMinCost <= nightmareValue and 325 or 324
  FunctionDialogEvent.Me():SetEventDialog(dialogId, nil, npcInfo)
end

function FunctionDialogEvent.Func_GetMonsterBatch(npcInfo)
  FunctionDialogEvent.Me():SetEventDialog(400, nil, npcInfo)
end

function FunctionDialogEvent.Func_TransMultiExp(npcInfo)
  local doubleExpBuff = FunctionBuff.Me():GetBuffByID(8002)
  if not doubleExpBuff then
    FunctionDialogEvent.Me():SetEventDialog(503, nil, npcInfo)
    return
  end
  FunctionDialogEvent.Me():SetEventDialog(500, nil, npcInfo)
end

function FunctionDialogEvent.Func_QuestRepair(npcInfo)
  FunctionDialogEvent.Me():SetEventDialog(600, nil, npcInfo)
end

function FunctionDialogEvent.Func_ReturnActivityReward(npcInfo)
  local flag = MyselfProxy.Instance:GetAccVarValueByType(Var_pb.EACCVARTYPE_USERRETURN_FLAG) or 0
  if 0 < flag then
    FunctionDialogEvent.Me():SetEventDialog(1001, nil, npcInfo)
  else
    FunctionDialogEvent.Me():SetEventDialog(1000, nil, npcInfo)
  end
end

function FunctionDialogEvent.Func_ExchangeSand(npcInfo)
  local sand = Game.Myself.data.userdata:Get(UDEnum.SAND)
  if 0 < sand then
    FunctionDialogEvent.Me():SetEventDialog(1101, sand, npcInfo)
  else
    FunctionDialogEvent.Me():SetEventDialog(1104, nil, npcInfo)
  end
end

function FunctionDialogEvent.Func_CatLitterBox(npcInfo)
  local type = GuildBuildingProxy.Type.EGUILDBUILDING_CAT_LITTER_BOX
  local lv = GuildBuildingProxy.Instance:GetBuildingLevelByType(type)
  local maxlv = GuildBuildingProxy.Instance:GetMaxLv(type)
  if lv == maxlv then
    FunctionDialogEvent.Me():SetEventDialog(86, nil, npcInfo)
  else
    FunctionDialogEvent.Me():SetEventDialog(87, GuildBuildingProxy.Type.EGUILDBUILDING_CAT_LITTER_BOX, npcInfo)
  end
end

function FunctionDialogEvent.Func_RetrieveAllArtifacts(npcInfo)
  FunctionDialogEvent.Me():SetEventDialog(1201, nil, npcInfo)
end
