HappyShopProxy = class("HappyShopProxy", pm.Proxy)
HappyShopProxy.Instance = nil
HappyShopProxy.NAME = "HappyShopProxy"
HappyShopProxy.Config = {PicId = 50, ChipId = 110}
HappyShopProxy.LimitType = {
  OneDay = SessionShop_pb.ESHOPLIMITTYPE_USER,
  OneTime = SessionShop_pb.ESHOPLIMITTYPE_ONE_ONLY,
  AccUser = SessionShop_pb.ESHOPLIMITTYPE_ACC_USER,
  AccUserAlways = SessionShop_pb.ESHOPLIMITTYPE_ACC_USER_ALWAYS,
  UserWeek = SessionShop_pb.ESHOPLIMITTYPE_USER_WEEK,
  AccWeek = SessionShop_pb.ESHOPLIMITTYPE_ACC_WEEK,
  AccMonth = SessionShop_pb.ESHOPLIMITTYPE_ACC_MONTH,
  GuildMaterialWeek = SessionShop_pb.ESHOPLIMITTYPE_GUILD_MATERIAL_MAXCOUNT,
  UserAlways = SessionShop_pb.ESHOPLIMITTYPE_USER_ALWAYS,
  GVGSeasonLimit = SessionShop_pb.ESHOPLIMITTYPE_GVG_SEASON
}
HappyShopProxy.SourceType = {
  User = SessionShop_pb.ESHOPSOURCE_USER,
  Guild = SessionShop_pb.ESHOPSOURCE_GUILD,
  UserGuild = SessionShop_pb.ESHOPSOURCE_USER_GUILD
}
local totalCostList = {}
local packageCheck = GameConfig.PackageMaterialCheck and GameConfig.PackageMaterialCheck.shop
local _SourceShop = ProtoCommon_pb.ESOURCE_SHOP
local GUILD_MATERIAL_TYPE = 988

function HappyShopProxy:ctor(proxyName, data)
  self.proxyName = proxyName or HappyShopProxy.NAME
  if HappyShopProxy.Instance == nil then
    HappyShopProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:Init()
  self:PreProcessServant()
end

function HappyShopProxy:Init()
  self.shopItems = {}
  self.myProfessionItems = {}
  self.limitCountMap = {}
  self.tabItems = {}
  self.qualityItems = {}
end

function HappyShopProxy:InitShop(npcdata, params, shopType, force)
  self.npc = npcdata
  self.params = params
  self.shopType = shopType
  self.npcStaticid = npcdata and npcdata.data and npcdata.data.staticData and npcdata.data.staticData.id or 0
  self:InitMoneyType()
  self:InitAnimationConfig()
  self:InitShopData(shopType)
  self:CallQueryShopConfig(force)
end

function HappyShopProxy:RecvQueryShopConfig(data)
  if self.shopType == data.type then
    self:InitShopData(data.type)
  end
end

function HappyShopProxy:RecvUpdateShopConfigCmd(data)
  if self.shopType == data.type then
    self:InitShopData(data.type)
  end
end

function HappyShopProxy:InitMoneyType()
  self.defaultDesc = ZhString.HappyShop_defaultDesc
  local desc
  local is_rent = false
  if self.shopType then
    local nfcfg = Table_NpcFunction[self.shopType]
    self.moneyTypes = nfcfg and nfcfg.Parama.ItemID or nil
    desc = nfcfg and nfcfg.Parama.Desc
    is_rent = nfcfg and nfcfg.Parama.IsRent == 1 or nil
  end
  self.desc = desc or self.defaultDesc
  self.is_rent = is_rent
end

function HappyShopProxy:InitAnimationConfig()
  self.aniConfig = {}
  if self.shopType then
    local nfcfg = Table_NpcFunction[self.shopType]
    if nfcfg and nfcfg.Parama then
      self.aniConfig[1] = nfcfg.Parama.ShowSkip
      self.aniConfig[2] = nfcfg.Parama.AnimationName
      self.aniConfig[3] = nfcfg.Parama.SkipType
      self.aniConfig[4] = nfcfg.Parama.Effect
      self.aniConfig[5] = nfcfg.Parama.Audio
    end
  end
end

function HappyShopProxy:InitShopData(shopType)
  TableUtility.ArrayClear(self.shopItems)
  local shopData = ShopProxy.Instance:GetShopDataByTypeId(shopType, self.params)
  local checkQuality = false
  if shopData then
    local config = shopData:GetGoods()
    for k, v in pairs(config) do
      if not v.menuHide then
        TableUtility.ArrayPushBack(self.shopItems, k)
      end
    end
    table.sort(self.shopItems, HappyShopProxy._SortItem)
    if shopData:CheckScreen() then
      self:SetMyProfessionItems(self.shopItems)
    end
    if shopData:CheckTab() then
      self:DivideByTab(self.shopItems)
    end
    if shopData:CheckQuality() then
      self:DivideByQuality(self.shopItems)
    end
  end
end

function HappyShopProxy._SortItem(l, r)
  local _HappyShopProxy = HappyShopProxy.Instance
  local ldata = _HappyShopProxy:GetShopItemDataByTypeId(l)
  local rdata = _HappyShopProxy:GetShopItemDataByTypeId(r)
  if ldata.CanOpen ~= rdata.CanOpen then
    return not ldata:GetLock()
  elseif ldata.ShopOrder == rdata.ShopOrder then
    return ldata.id < rdata.id
  else
    return ldata.ShopOrder < rdata.ShopOrder
  end
end

function HappyShopProxy:UpdateQueryShopGotItem(data)
  self.cachedHaveBoughtItemCount = nil
  local items = data.items
  if items then
    for i = 1, #items do
      self:CachedHaveBoughtItemCount(items[i].id, items[i].count)
    end
  end
  if self.discountItemMap == nil then
    self.discountItemMap = {}
  else
    TableUtility.TableClear(self.discountItemMap)
  end
  for i = 1, #data.discountitems do
    local item = data.discountitems[i]
    self.discountItemMap[item.id] = item.count
  end
  if self.limitItemMap == nil then
    self.limitItemMap = {}
  else
    TableUtility.TableClear(self.limitItemMap)
  end
  for i = 1, #data.limititems do
    local item = data.limititems[i]
    self.limitItemMap[item.id] = item.count
  end
  if self.maxLimitItemMap == nil then
    self.maxLimitItemMap = {}
  else
    TableUtility.TableClear(self.maxLimitItemMap)
  end
  for i = 1, #data.addlimits do
    local item = data.addlimits[i]
    self.maxLimitItemMap[item.id] = item.count
  end
end

function HappyShopProxy:UpdateShopGotItem(data)
  local item = data.item
  if item then
    self:CachedHaveBoughtItemCount(item.id, item.count)
  end
  local discountitem = data.discountitem
  if discountitem then
    self.discountItemMap[discountitem.id] = discountitem.count
  end
  local limititem = data.limititem
  if limititem then
    self.limitItemMap[limititem.id] = limititem.count
  end
  local addlimit = data.addlimit
  if addlimit then
    self.maxLimitItemMap[addlimit.id] = addlimit.count
  end
end

function HappyShopProxy:JudgeCanBuy(data)
  local canBuy = false
  local temp
  if data.goodsID then
    temp = Table_Equip[data.goodsID]
  else
    errorLog("HappyShopProxy JudgeCanBuy : data.goodsID = nil")
  end
  if temp then
    if #temp.CanEquip == 1 and temp.CanEquip[1] == 0 then
      canBuy = true
      return canBuy
    end
    for i = 1, #temp.CanEquip do
      if temp.CanEquip[i] == MyselfProxy.Instance:GetMyProfession() then
        canBuy = true
        return canBuy
      end
    end
  else
    canBuy = true
  end
  return canBuy
end

function HappyShopProxy:CachedHaveBoughtItemCount(id, count)
  if self.cachedHaveBoughtItemCount == nil then
    self.cachedHaveBoughtItemCount = {}
  end
  self.cachedHaveBoughtItemCount[id] = count
end

function HappyShopProxy:GetCachedHaveBoughtItemCount(id)
  if id then
    return self.cachedHaveBoughtItemCount and self.cachedHaveBoughtItemCount[id]
  end
  return self.cachedHaveBoughtItemCount
end

function HappyShopProxy:GetNPC()
  return self.npc
end

function HappyShopProxy:GetShopItems()
  return self.shopItems
end

function HappyShopProxy:SetMyProfessionItems(datas)
  TableUtility.ArrayClear(self.myProfessionItems)
  for i = 1, #datas do
    local data = self:GetShopItemDataByTypeId(datas[i])
    if self:JudgeCanBuy(data) then
      TableUtility.ArrayPushBack(self.myProfessionItems, datas[i])
    end
  end
end

function HappyShopProxy:GetMyProfessionItems()
  return self.myProfessionItems
end

function HappyShopProxy:SetSelectId(id)
  self.selectId = id
end

function HappyShopProxy:GetSelectId()
  return self.selectId
end

function HappyShopProxy:GetMoneyType()
  return self.moneyTypes
end

function HappyShopProxy:GetScreen()
  local shopData = ShopProxy.Instance:GetShopDataByTypeId(self.shopType, self.params)
  if shopData then
    return shopData:CheckScreen()
  end
  return false
end

function HappyShopProxy:BuyShopItem(id, count)
  if self.buyItemList == nil then
    self.buyItemList = {}
  end
  if self.buyItemList[id] == nil then
    self.buyItemList[id] = count
  else
    self.buyItemList[id] = self.buyItemList[id] + count
  end
  if self.buyItemList[id] then
    self:BuyItem(id, self.buyItemList[id])
    self.buyItemList[id] = nil
  end
end

function HappyShopProxy:BuyItem(id, count, hideNetDelayPrompt)
  local item = self:GetShopItemDataByTypeId(id)
  if item == nil then
    return false
  end
  return self:BuyItemByShopItemData(item, count, nil, hideNetDelayPrompt)
end

function HappyShopProxy:BuyItemByShopItemData(item, count, skipCheckMoney, hideNetDelayPrompt)
  if item:CheckCanRemove() then
    MsgManager.ShowMsgByID(990)
    self:CallQueryShopConfig()
    return false
  end
  if item.curProduceNum == 0 then
    MsgManager.ShowMsgByID(13000)
    return false
  end
  if count == 0 then
    MsgManager.ShowMsgByID(42038)
    return
  end
  local goodsID = item.goodsID
  local foreverLimitConfig = GameConfig.Shop.forever_limit_item[goodsID]
  if foreverLimitConfig and foreverLimitConfig.num and foreverLimitConfig.msgid then
    local own = foreverLimitConfig.packageCheck and BagProxy.Instance:GetItemNumByStaticID(goodsID, foreverLimitConfig.packageCheck) or 0
    local curNum = goodsID == 5550 and CommonFun.calcValidDFSPNum(MyselfProxy.Instance:AllProfessionMaxJobLv(), foreverLimitConfig.num, own) or self:GetLimitItemCount(goodsID)
    if curNum <= 0 then
      MsgManager.ShowMsgByID(foreverLimitConfig.msgid)
      return
    end
  end
  if item.BaseLv == nil or MyselfProxy.Instance:RoleLevel() >= item.BaseLv then
    local canBuyCount, limitType = self:GetCanBuyCount(item)
    if canBuyCount ~= nil and (count > canBuyCount or canBuyCount == 0) then
      if limitType == self.LimitType.OneDay then
        MsgManager.ShowMsgByID(76)
      else
        MsgManager.ShowMsgByID(78)
      end
      return false
    end
    local goodsStaticData = Table_Item[goodsID]
    local limitCfg = goodsStaticData.GetLimit
    if self:CheckLimitCount(limitCfg) then
      local limitCount = ItemData.Get_GetLimitCount(goodsID)
      local haveCount = self.limitCountMap[goodsID] or 0
      limitCount = math.max(0, limitCount - haveCount)
      if count > limitCount then
        local msgId
        if limitCfg.type == 1 then
          msgId = 64
        elseif limitCfg.type == 7 then
          msgId = 63
        end
        MsgManager.ShowMsgByID(msgId, goodsStaticData.NameZh)
        return false
      end
    end
    TableUtility.ArrayClear(totalCostList)
    for i = 1, 5 do
      local temp = i
      if temp == 1 then
        temp = ""
      end
      local ItemID = item["ItemID" .. temp]
      if ItemID then
        totalCostList[i] = item:GetBuyFinalPrice(item["ItemCount" .. temp], count)
        local itemName = ""
        if Table_Item[ItemID] then
          itemName = Table_Item[ItemID].NameZh or ""
        end
        local moneyCount = self:GetItemNum(ItemID, item.source)
        if moneyCount < totalCostList[i] and not skipCheckMoney then
          OverSeaFunc.SpecialItemNotEnoughMsg(ItemID)
          return
        end
      end
    end
    if item.IfMsg ~= nil then
      local itemName = ""
      if Table_Item[item.ItemID] then
        itemName = Table_Item[item.ItemID].NameZh or ""
      end
      MsgManager.ConfirmMsgByID(item.IfMsg, function()
        ServiceSessionShopProxy.Instance:CallBuyShopItem(item.id, count, totalCostList[1], totalCostList[2], nil, hideNetDelayPrompt)
      end, nil, nil, item.ItemCount, itemName, goodsStaticData.NameZh or "")
    elseif item.presentMsgid ~= nil and item:CheckPresentMenu() then
      MsgManager.ConfirmMsgByID(item.presentMsgid, function()
        ServiceSessionShopProxy.Instance:CallBuyShopItem(item.id, count, totalCostList[1], totalCostList[2], nil, hideNetDelayPrompt)
      end)
    else
      ServiceSessionShopProxy.Instance:CallBuyShopItem(item.id, count, totalCostList[1], totalCostList[2], nil, hideNetDelayPrompt)
      return true
    end
  else
    MsgManager.FloatMsgTableParam(nil, ZhString.HappyShop_levelNotEnough)
  end
  return false
end

function HappyShopProxy:CallQueryShopConfig(force)
  ShopProxy.Instance:CallQueryShopConfig(self.shopType, self.params, force)
end

function HappyShopProxy:GetShopItemDataByTypeId(id)
  return ShopProxy.Instance:GetShopItemDataByTypeId(self.shopType, self.params, id)
end

function HappyShopProxy:GetItemNum(itemid, source)
  local moneyCount = 0
  if source == self.SourceType.Guild then
    moneyCount = GuildProxy.Instance:GetGuildPackItemNumByItemid(itemid)
  else
    local moneyId = GameConfig.MoneyId
    local config = Table_Item[itemid]
    if itemid == moneyId.Zeny then
      moneyCount = MyselfProxy.Instance:GetROB()
    elseif itemid == moneyId.PvpCoin then
      moneyCount = MyselfProxy.Instance:GetPvpCoin()
    elseif itemid == moneyId.Lottery then
      moneyCount = MyselfProxy.Instance:GetLottery()
    elseif itemid == moneyId.GuildHonor then
      moneyCount = MyselfProxy.Instance:GetGuildHonor()
    elseif itemid == moneyId.Contribute then
      moneyCount = Game.Myself and Game.Myself.data.userdata:Get(UDEnum.CONTRIBUTE) or 0
    elseif itemid == moneyId.Gods then
      moneyCount = GuildProxy.Instance:GetGuildPackItemNumByItemid(itemid)
    elseif itemid == moneyId.Quota then
      moneyCount = Game.Myself and Game.Myself.data.userdata:Get(UDEnum.QUOTA) or 0
    elseif itemid == moneyId.BattlePassCoin then
      moneyCount = Game.Myself and Game.Myself.data.userdata:Get(UDEnum.BATTLEPASS_COIN) or 0
    elseif itemid == moneyId.FourthSkillSand then
      moneyCount = Game.Myself and Game.Myself.data.userdata:Get(UDEnum.SAND) or 0
    elseif itemid == moneyId.Bind_Contribute then
      moneyCount = Game.Myself and Game.Myself.data.userdata:Get(UDEnum.BIND_CONTRIBUTE) or 0
    elseif itemid == moneyId.HappyValue then
      moneyCount = MyselfProxy.Instance:GetAccVarValueByType(Var_pb.EACCVARTYPE_HAPPYVALUE) or 0
    elseif config and (config.Type == 104 or config.Type == 105) then
      moneyCount = Game.Myself and Game.Myself.data.userdata:GetNoEnterPackItemNum(itemid)
    else
      moneyCount = self:GetItemNumByStaticID(itemid)
    end
  end
  return moneyCount
end

function HappyShopProxy:GetItemNumByStaticID(itemid)
  local _BagProxy = BagProxy.Instance
  local count = 0
  if GemProxy.CheckIsGemStaticData(Table_Item[itemid]) then
    return _BagProxy:GetItemNumByStaticID(itemid, GemProxy.PackageCheck)
  end
  for i = 1, #packageCheck do
    count = count + _BagProxy:GetItemNumByStaticID(itemid, packageCheck[i])
  end
  return count
end

function HappyShopProxy:GetTodayCanBuyCountStr(data)
  local canBuyCount, limitType = self:GetCanBuyCount(data)
  if canBuyCount ~= nil then
    local repStr
    if limitType == HappyShopProxy.LimitType.OneDay then
      repStr = ZhString.HappyShop_todayCanBuy
    elseif limitType == HappyShopProxy.LimitType.AccUser then
      repStr = ZhString.HappyShop_AccUserCanBuy
    elseif limitType == HappyShopProxy.LimitType.AccUserAlways then
      repStr = ZhString.HappyShop_AlwaysCanBuy
    elseif limitType == HappyShopProxy.LimitType.UserAlways then
      if self:IsNewGVGShop() then
        repStr = ZhString.HappyShop_SeasonCanBuy
      else
        repStr = ZhString.HappyShop_AlwaysCanBuy
      end
    elseif limitType == HappyShopProxy.LimitType.AccWeek then
      repStr = ZhString.HappyShop_AccWeekCanBuy
    elseif limitType == HappyShopProxy.LimitType.AccMonth then
      repStr = ZhString.HappyShop_AccMonthCanBuy
    elseif limitType == HappyShopProxy.LimitType.UserWeek then
      repStr = ZhString.HappyShop_AccUserWeekCanBuy
    elseif limitType == HappyShopProxy.LimitType.GVGSeasonLimit then
      repStr = ZhString.HappyShop_SeasonCanBuy
    end
    if repStr then
      local maxLimitStr = ""
      if data.maxlimitnum ~= nil and data.maxlimitnum > 0 then
        maxLimitStr = string.format(ZhString.HappyShop_MaxLimitCount, data.maxlimitnum)
      end
      return string.format(repStr, maxLimitStr, canBuyCount)
    end
  end
  return ""
end

function HappyShopProxy:GetCanBuyCount(data)
  local isOneDay = data:CheckLimitType(self.LimitType.OneDay)
  local isAccUser = data:CheckLimitType(self.LimitType.AccUser)
  local isAccUserAlways = data:CheckLimitType(self.LimitType.AccUserAlways)
  local isUserWeek = data:CheckLimitType(self.LimitType.UserWeek)
  local isAccWeek = data:CheckLimitType(self.LimitType.AccWeek)
  local isAccMonth = data:CheckLimitType(self.LimitType.AccMonth)
  local isGuildMaterial = data:CheckLimitType(self.LimitType.GuildMaterialWeek)
  local isUserAlways = data:CheckLimitType(self.LimitType.UserAlways)
  local isGVGSeason = data:CheckLimitType(self.LimitType.GVGSeasonLimit)
  local myGuildData = GuildProxy.Instance.myGuildData
  if myGuildData and isGuildMaterial then
    local limitCount = GuildBuildingProxy.Instance:GetGuildMaterialLimitCount()
    if limitCount and limitCount ~= 0 then
      return limitCount - myGuildData.material_machine_count, self.LimitType.GuildMaterialWeek
    end
  end
  if data.LimitNum ~= 0 and (isOneDay or isAccUser or isAccUserAlways or isUserWeek or isAccWeek or isAccMonth or isUserAlways or isGVGSeason) then
    local boughtCount = 0
    local haveBoughtItemCount = self:GetCachedHaveBoughtItemCount()
    if haveBoughtItemCount ~= nil then
      boughtCount = haveBoughtItemCount[data.id] or 0
    end
    local count = data.LimitNum - boughtCount + self:GetMaxLimitItemCount(data.id)
    if data.maxlimitnum ~= nil and data.maxlimitnum ~= 0 and count > data.maxlimitnum then
      count = data.maxlimitnum
    end
    if isOneDay then
      return count, self.LimitType.OneDay
    elseif isAccUser then
      return count, self.LimitType.AccUser
    elseif isAccUserAlways then
      return count, self.LimitType.AccUserAlways
    elseif isAccWeek then
      return count, self.LimitType.AccWeek
    elseif isAccMonth then
      return count, self.LimitType.AccMonth
    elseif isUserWeek then
      return count, self.LimitType.UserWeek
    elseif isUserAlways then
      return count, self.LimitType.UserAlways
    elseif isGVGSeason then
      return count, self.LimitType.GVGSeasonLimit
    end
  end
  return nil
end

function HappyShopProxy:IsShowSkip()
  return self.aniConfig and self.aniConfig[1] or false
end

local ActionConfig = {
  ActionId = 506,
  IdleActionId = 505,
  LeanTime = 1.5
}
local defaultEff, defaultAni = "Common/Lottery", "functional_action"

function HappyShopProxy:PlayAnimationEff()
  local isSkip = LocalSaveProxy.Instance:GetSkipAnimation(self.aniConfig[3])
  if isSkip then
    return
  end
  local npcID = self.npc.data:GetGuid()
  local npcRole = SceneCreatureProxy.FindCreature(npcID)
  if npcRole then
    local ani = self.aniConfig[2] or defaultAni
    self:PlayAction(npcRole, ActionConfig.ActionId)
    if self.effect then
      self.effect:Destroy()
      self.effect = nil
    end
    local effect = self.aniConfig[4] or defaultEff
    self.effect = npcRole:PlayEffect(nil, effect, 0, nil, nil, true)
    self.effect:RegisterWeakObserver(self)
    local audio = self.aniConfig[5]
    if audio then
      npcRole:PlayAudio(audio)
    end
  end
  self:RemoveLeanTween()
  self.lean = TimeTickManager.Me():CreateOnceDelayTick(ActionConfig.LeanTime * 1000, function(owner, deltaTime)
    self:PlayAction(npcRole, ActionConfig.IdleActionId)
  end, self)
end

function HappyShopProxy:PlayAction(npc, actionId)
  if npc ~= nil and actionId ~= nil then
    local actionName
    local config = Table_ActionAnime[actionId]
    if config ~= nil then
      actionName = config.Name
    end
    if actionName ~= nil then
      npc:Client_PlayAction(actionName, nil, false)
    end
  end
end

local strengthenAnimName = "functional_action"
local waitAnimName = "wait"

function HappyShopProxy:PlayFunctionalAction()
  local npcID = self.npc.data:GetGuid()
  local npcRole = SceneCreatureProxy.FindCreature(npcID)
  local animParams = Asset_Role.GetPlayActionParams(strengthenAnimName, nil, 1)
  animParams[7] = function()
    animParams = Asset_Role.GetPlayActionParams(waitAnimName, nil, 1)
    npcRole.assetRole:PlayActionRaw(animParams)
  end
  npcRole.assetRole:PlayActionRaw(animParams)
end

function HappyShopProxy:RemoveLeanTween()
  if self.lean then
    local npcID = self.npc.data:GetGuid()
    local npcRole = SceneCreatureProxy.FindCreature(npcID)
    self:PlayAction(npcRole, ActionConfig.IdleActionId)
    self.lean:Destroy()
    self.lean = nil
  end
end

function HappyShopProxy:ObserverDestroyed(obj)
  if obj == self.effect then
    self.effect = nil
  end
end

function HappyShopProxy:SetLimitCount(itemid, count)
  if itemid ~= nil then
    self.limitCountMap[itemid] = count or 0
  end
end

function HappyShopProxy:CheckLimitCount(limitCfg)
  if limitCfg == nil then
    return false
  end
  if limitCfg.type == nil then
    return false
  end
  if limitCfg.source == nil then
    return true
  else
    for i = 1, #limitCfg.source do
      if limitCfg.source[i] == _SourceShop then
        return true
      end
    end
  end
  return false
end

function HappyShopProxy:GetDiscountItemCount(shopid)
  return self.discountItemMap and self.discountItemMap[shopid] or 0
end

function HappyShopProxy:GetLimitItemCount(itemid)
  return self.limitItemMap and self.limitItemMap[itemid] or 0
end

function HappyShopProxy:GetMaxLimitItemCount(shopid)
  return self.maxLimitItemMap and self.maxLimitItemMap[shopid] or 0
end

function HappyShopProxy:GetShopType()
  return self.shopType
end

function HappyShopProxy:IsRent()
  return self.is_rent == true
end

function HappyShopProxy:IsNewGVGShop()
  if not self.shopType then
    return false
  end
  local config = GameConfig.GvgNewConfig.season_equip_shoptypes
  if config then
    return TableUtility.ArrayFindIndex(config, self.shopType) > 0
  end
  return false
end

function HappyShopProxy:isGuildMaterialType()
  return GUILD_MATERIAL_TYPE == self:GetShopType()
end

function HappyShopProxy:GetShopId()
  return self.params
end

function HappyShopProxy:DivideByTab(datas)
  TableUtility.ArrayClear(self.tabItems)
  local len = #datas
  for i = 1, len do
    local data = self:GetShopItemDataByTypeId(datas[i])
    if not self.tabItems[data.tabid] and data.tabid then
      self.tabItems[data.tabid] = {}
    end
    if data.tabid then
      TableUtility.ArrayPushBack(self.tabItems[data.tabid], datas[i])
    end
  end
end

function HappyShopProxy:GetTabItem(tabid)
  if self.tabItems and tabid then
    return self.tabItems[tabid] or {}
  end
  return {}
end

function HappyShopProxy:GetTab()
  local shopData = ShopProxy.Instance:GetShopDataByTypeId(self.shopType, self.params)
  if shopData then
    return shopData:CheckTab()
  end
  return false
end

function HappyShopProxy:PreProcessServant()
  if not self.servantShopMap then
    self.servantShopMap = {}
  else
    TableUtility.TableClear(self.servantShopMap)
  end
  local cfg = GameConfig.Servant.description
  for k, v in pairs(cfg) do
    local single = {}
    single.k = k
    single.npcid = v.id
    single.param = v.param
    single.type = v.type
    local npcdata = Table_Npc[v.id]
    if npcdata then
      single.icon = npcdata.Icon
      single.menuid = v.menuid or 0
      single.menuid2 = v.menuid2 or 0
      single.npcFavoriteItemid = v.npcFavoriteItemid
      self.servantShopMap[v.id] = single
    else
      redlog("Table_Npc Missing id :" .. tostring(v.id))
    end
  end
end

function HappyShopProxy:GetServantShopMap()
  return self.servantShopMap
end

function HappyShopProxy:GetNPCStaticid()
  return self.npcStaticid
end

function HappyShopProxy:UpdateMenu()
  local shopData = ShopProxy.Instance:GetShopDataByTypeId(self.shopType, self.params)
  if shopData then
    shopData:UpdateMenu()
  end
end

function HappyShopProxy:GetShopData()
  local shopData = ShopProxy.Instance:GetShopDataByTypeId(self.shopType, self.params)
  return shopData
end

local shopDatasArray = {}

function HappyShopProxy:GetShopDataByName(name, tabid)
  TableUtility.ArrayClear(shopDatasArray)
  local shopitems = {}
  if tabid and self:GetTab() then
    shopDatas = self:GetTabItem(tabid)
  else
    shopDatas = self.shopItems
  end
  if not shopDatas then
    return
  end
  for i = 1, #shopDatas do
    local sdata = self:GetShopItemDataByTypeId(shopDatas[i])
    if not name or string.find(sdata.nameZh, name) then
      shopDatasArray[#shopDatasArray + 1] = shopDatas[i]
    end
  end
  return shopDatasArray
end

function HappyShopProxy:RecvBuyShopItem(data)
  if BranchMgr.IsChina() and not ApplicationInfo.IsRunOnEditor() then
    local success = data.success
    local id = data.id
    if success and id and GameConfig.ToAppReviewShop and self.shopType == GameConfig.ToAppReviewShop.Type and TableUtility.ArrayFindIndex(GameConfig.ToAppReviewShop.Item, id) > 0 then
      local BundleID = AppBundleConfig.BundleID
      if GameConfig.BundleIDs and 0 < TableUtility.ArrayFindIndex(GameConfig.BundleIDs, BundleID) then
        MsgManager.ConfirmMsgByID(40576, function()
          AppBundleConfig.JumpToAppReview()
        end, nil, nil)
      end
    end
  end
end

function HappyShopProxy:NeedQueryAutoQuestComplete()
  return not self.isAutoQuestCompleteStateUpdated
end

function HappyShopProxy:NeedConfirmAutoQuestComplete()
  return self.autoQuestCompleteState == SceneQuest_pb.EQUESTCOMPLETESTATUS_QUEST_NOREWARD
end

function HappyShopProxy:IsNotNeedAutoQuestComplete()
  return self.autoQuestCompleteState == SceneQuest_pb.EQUESTCOMPLETESTATUS_NOQUEST
end

function HappyShopProxy:UpdateAutoQuestCompleteState(status)
  self.autoQuestCompleteState = status
  self.isAutoQuestCompleteStateUpdated = true
end

local filter = {}

function HappyShopProxy:GetFilter(filterData)
  TableUtility.ArrayClear(filter)
  for k, v in pairs(filterData) do
    table.insert(filter, k)
  end
  table.sort(filter, function(l, r)
    return l < r
  end)
  return filter
end

function HappyShopProxy:DivideByQuality(datas)
  TableUtility.TableClear(self.qualityItems)
  local len = #datas
  for i = 1, len do
    local data = self:GetShopItemDataByTypeId(datas[i])
    if not self.qualityItems[0] then
      self.qualityItems[0] = {}
    end
    if data.quality and not self.qualityItems[data.quality] then
      self.qualityItems[data.quality] = {}
    end
    if data.quality then
      TableUtility.ArrayPushBack(self.qualityItems[data.quality], datas[i])
      TableUtility.ArrayPushBack(self.qualityItems[0], datas[i])
    end
  end
end

function HappyShopProxy:GetQualityItem(quality)
  if self.qualityItems and quality then
    return self.qualityItems[quality] or {}
  end
  return {}
end

function HappyShopProxy:CheckQuality()
  local shopData = ShopProxy.Instance:GetShopDataByTypeId(self.shopType, self.params)
  if shopData then
    return shopData:CheckQuality()
  end
  return false
end

function HappyShopProxy:GetTotalCost(shopType, shopId)
  local costList = {}
  local goods = ShopProxy.Instance:GetConfigByTypeId(shopType, shopId)
  for id, shopItemData in pairs(goods) do
    local canBuyCount = self:GetCanBuyCount(shopItemData)
    if canBuyCount then
      local _moneyId = shopItemData.ItemID
      local _singleCost = shopItemData.ItemCount
      if _moneyId and _singleCost then
        if not costList[_moneyId] then
          costList[_moneyId] = _singleCost * canBuyCount
        else
          costList[_moneyId] = costList[_moneyId] + _singleCost * canBuyCount
        end
      end
    end
  end
  return costList
end
