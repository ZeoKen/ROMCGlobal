autoImport("EquipInfo")
autoImport("SuitInfo")
autoImport("EnchantInfo")
autoImport("LoveLetterData")
autoImport("PetEggInfo")
autoImport("CodeData")
autoImport("WeddingData")
autoImport("GemSkillData")
autoImport("GemAttrData")
autoImport("GemSecretLandData")
autoImport("PersonalArtifactData")
autoImport("EquipMemoryData")
ItemData = class("ItemData")
ItemTarget_Type = {
  Player = 1,
  Npc = 2,
  Monster = 4
}
Item_CardType = {
  Get = 1,
  Born = 2,
  Raffle = 4,
  Decompose = 8,
  BossCompose = 16
}
local _MyItemStatusCheck = ItemsWithRoleStatusChange:Instance()

function ItemData:ctor(id, staticId)
  self.id = ""
  self.bagtype = nil
  self.staticData = nil
  self.equipInfo = nil
  self.cardInfo = nil
  self.enchantInfo = nil
  self.equipedCardInfo = nil
  self.cardSlotNum = 0
  self.index = 0
  self.num = 0
  self.bind = false
  self.expireTime = 0
  self.equiped = 0
  self.cdTime = 0
  self.configCdTime = 0
  self.battlepoint = 0
  self.isNew = false
  self.isFashion = false
  self.tempHint = true
  self.isactive = false
  self.couldUseWithRoleStatus = nil
  self.replaceCount = 0
  self.mapLimit = nil
  self.mapLimitTipid = 0
  self:ResetData(id, staticId)
  self.CodeData = nil
  self.cdGroup = nil
  self.isFavorite = false
  self.source = nil
  self.artifact = nil
  self.noPileSlot = false
  self.equipMemoryData = nil
end

function ItemData:ResetData(id, staticId)
  self.cdTime = 0
  self.id = id
  self.staticData = Table_Item[staticId]
  if self.staticData ~= nil then
    self.staticData.id = staticId
  elseif staticId ~= nil and staticId ~= 0 then
    LogUtility.InfoFormat("根本找不到id为{0}的道具", tostring(staticId))
  end
  local equipData = Table_Equip[staticId]
  if equipData ~= nil then
    self.equipInfo = EquipInfo.new(equipData)
    self.cardSlotNum = equipData.CardSlot
    self.replaceCount = 0
    if equipData.SubstituteID then
      local cData = Table_Compose[equipData.SubstituteID]
      local nextEquipId = cData.Product.id
      if nextEquipId then
        while nextEquipId ~= nil and self.replaceCount < 5 do
          self.replaceCount = self.replaceCount + 1
          local eData = Table_Equip[nextEquipId]
          if eData and eData.SubstituteID then
            cData = Table_Compose[eData.SubstituteID]
            if cData then
              nextEquipId = cData.Product.id
            else
              nextEquipId = nil
            end
          else
            nextEquipId = nil
          end
        end
      end
    end
  else
    self.equipInfo = nil
    self.cardSlotNum = 0
  end
  local useItemData = Table_UseItem[staticId]
  self.configCdTime = useItemData and useItemData.CDTime or 0
  self.cardInfo = Table_Card[staticId]
  if self.equipInfo then
    local suitIds = BagProxy.GetSuitIds(staticId)
    if 0 < #suitIds then
      self.suitInfo = SuitInfo.new(suitIds)
    else
      self.suitInfo = nil
    end
  else
    self.suitInfo = nil
  end
  local useData = Table_UseItem[staticId]
  self.cdGroup = useData and useData.CDGroup
  if useData and useData.MapLimit then
    if self.mapLimit then
      TableUtility.ArrayClear(self.mapLimit)
    end
    self.mapLimit = {}
    self.mapLimitTipid = useData.MapLimitTipID
    TableUtility.ArrayShallowCopy(self.mapLimit, useData.MapLimit)
  end
  self.noPileSlot = nil
  if self.staticData then
    local type = self.staticData.Type
    local id = self.staticData.id
    if GameConfig.Item and GameConfig.Item.NoPile then
      if GameConfig.Item.NoPile.Types and 0 < TableUtility.ArrayFindIndex(GameConfig.Item.NoPile.Types, type) then
        self.noPileSlot = true
      elseif GameConfig.Item.NoPile.IDs and 0 < TableUtility.ArrayFindIndex(GameConfig.Item.NoPile.IDs, id) then
        self.noPileSlot = true
      end
    end
  end
  self.memoryData = Table_ItemMemory and Table_ItemMemory[staticId]
end

function ItemData:GetMaxCardSlot()
  if self.isAdv then
    return 0
  end
  return self.equipInfo and self.equipInfo:GetMaxCardSlot() or 0
end

function ItemData:GetCdConfigTime()
  local useItemData = Table_UseItem[self.staticData.id]
  if useItemData == nil then
    return 0
  end
  if useItemData.PVPCDtime and Game.MapManager:IsPVPMode() then
    return useItemData.PVPCDtime or 0
  end
  if self.cdGroup then
    local map = CDProxy.Instance:GetCDMapByType(SceneUser2_pb.CD_TYPE_ITEM)
    local sUseData
    for itemid, cdData in pairs(map) do
      sUseData = Table_UseItem[itemid]
      if sUseData and sUseData.CDGroup == self.cdGroup and sUseData.CDTime then
        return sUseData.CDTime
      end
    end
  end
  return useItemData.CDTime or 0
end

function ItemData:SetEquipCards(cards)
  self.equipedCardInfo = {}
  if cards then
    for i = 1, #cards do
      local single = cards[i]
      local equipedCard = ItemData.new(single.guid, single.id)
      equipedCard:SetCardLevel(single.card_info and single.card_info.lv or 0)
      if single.pos and 0 < single.pos then
        equipedCard.index = single.pos
        self.equipedCardInfo[single.pos] = equipedCard
      else
        table.insert(self.equipedCardInfo, equipedCard)
      end
    end
  end
end

function ItemData:HasEquipedCard()
  if self.equipedCardInfo == nil then
    return false
  end
  return next(self.equipedCardInfo) ~= nil
end

function ItemData:GetEquipedCardNum()
  if self.equipedCardInfo == nil then
    return 0
  end
  local count = 0
  for k, v in pairs(self.equipedCardInfo) do
    count = count + 1
  end
  return count
end

function ItemData:SetEnchantInfo(enchantData)
  if not self.staticData then
    return
  end
  if not self.equipInfo then
    return
  end
  if self.enchantInfo == nil then
    local quench = self:GetQuenchPer()
    self.enchantInfo = EnchantInfo.new(self.staticData.id, quench and quench / 100)
  end
  self.enchantInfo:SetMyServerData(enchantData)
end

function ItemData:HasServerEnchant()
  if nil ~= self.enchantInfo and self.enchantInfo.enchantType ~= SceneItem_pb.EENCHANTTYPE_MIN then
    return true
  end
  return false
end

function ItemData:SetCacheEnchantInfo(server_preview_enchants)
  self.cacheEnchants = self.cacheEnchants or {}
  TableUtility.ArrayClear(self.cacheEnchants)
  if not server_preview_enchants or not next(server_preview_enchants) then
    return
  end
  local enchantInfo
  for i = 1, #server_preview_enchants do
    local quench = self:GetQuenchPer()
    enchantInfo = EnchantInfo.new(self.staticData.id, quench and quench / 100)
    enchantInfo:SetMyServerData(server_preview_enchants[i])
    enchantInfo:SetServerIndex(i - 1)
    self.cacheEnchants[#self.cacheEnchants + 1] = enchantInfo
  end
  table.sort(self.cacheEnchants, function(l, r)
    if l.combineSortValue == r.combineSortValue then
      return l.attrSortValue > r.attrSortValue
    else
      return l.combineSortValue > r.combineSortValue
    end
  end)
  if #self.cacheEnchants > 0 and not self:HasServerEnchant() then
    ServiceItemProxy.Instance:CallProcessEnchantItemCmd(true, self.id, self.cacheEnchants[1].serverIndex)
  end
end

function ItemData:HasUnSaveAttri()
  return self.cacheEnchants and #self.cacheEnchants > 0
end

function ItemData:GetCacheEnchants()
  return self.cacheEnchants
end

function ItemData:HasGoodCacheEnchantAttri()
  if not self:HasUnSaveAttri() then
    return false
  end
  for i = 1, #self.cacheEnchants do
    if self.cacheEnchants[i]:HasNewGoodAttri() then
      return true
    end
  end
  return false
end

function ItemData:HasGoodEnchantAttri()
  if self.enchantInfo and self.enchantInfo:HasNewGoodAttri() then
    return true
  end
  return self:HasGoodCacheEnchantAttri()
end

function ItemData:SetRefreshEnchantAttrs(preview_reset_attr)
  self.cacheEnchantRefreshAttr = self.cacheEnchantRefreshAttr or {}
  TableUtility.ArrayClear(self.cacheEnchantRefreshAttr)
  if not preview_reset_attr or not next(preview_reset_attr) then
    return
  end
  for i = 1, #preview_reset_attr do
    if nil ~= preview_reset_attr[i].type and preview_reset_attr[i].type ~= ProtoCommon_pb.EATTRTYPE_MIN then
      self.cacheEnchantRefreshAttr[#self.cacheEnchantRefreshAttr + 1] = EnchantInfo.SetServerAttri(EnchantType.Senior, preview_reset_attr[i], self.staticData.id, i - 1)
    end
  end
end

function ItemData:GetCacheEnchantRefreshAttr()
  return self.cacheEnchantRefreshAttr
end

function ItemData:HasCacheEnchantRefreshAttr()
  return nil ~= self.cacheEnchantRefreshAttr and nil ~= next(self.cacheEnchantRefreshAttr)
end

function ItemData:HasGoodEnchantRefreshAttr()
  for i = 1, #self.cacheEnchantRefreshAttr do
    if self.cacheEnchantRefreshAttr[i].Quality == EnchantAttriQuality.Good then
      return true
    end
  end
  return false
end

function ItemData:SetCdTime(cdTime)
  self.cdTime = cdTime
end

function ItemData:SetSpecialName(name)
  self.specialName = name
end

function ItemData:GetSpecialName()
  return self.specialName
end

function ItemData:GetName(hideRefinelv, hideDamageColor, refineBuffUpSource)
  if self.staticData then
    if self.site then
      return GameConfig.PosStrenght.name[self.site]
    end
    local name = self.staticData.NameZh
    if self.petEggInfo and self.petEggInfo.name ~= "" then
      return string.format(ZhString.ItemData_PetEggName, self.petEggInfo.name)
    end
    if self.equipInfo then
      local withLimitBuffUpLv, withoutLimitBuffUpLv, withExtraLimitBuffUpLv
      if self.GetRefineBuffUpLevel then
        withLimitBuffUpLv, withoutLimitBuffUpLv, withExtraLimitBuffUpLv = self:GetRefineBuffUpLevel(refineBuffUpSource)
      end
      local capLv = BlackSmithProxy.Instance:GetEquipCapLevel(self.index, playerId)
      local refinelv = BlackSmithProxy.CalculateBuffUpLevel(self.equipInfo.refinelv, BlackSmithProxy.Instance:MaxRefineLevelByData(self.staticData), withLimitBuffUpLv, withoutLimitBuffUpLv, capLv, withExtraLimitBuffUpLv)
      if 0 < refinelv and hideRefinelv ~= true then
        name = string.format("+%d%s", refinelv, tostring(name))
      end
      if 0 < self.equipInfo.equiplv then
        name = name .. StringUtil.IntToRoman(self.equipInfo.equiplv)
      end
      if self.equipInfo.damage and hideDamageColor ~= true then
        name = string.format("[c]%s%s[-][/c]", ItemData.GetDamageColorStr(), tostring(name))
      end
    end
    if GemProxy.CheckGemIsSculpted(self) then
      name = name .. ZhString.Gem_NameZhSculptedSuffix
    end
    if self.IsPersonalArtifactFragment and self:IsPersonalArtifactFragment() then
      name = name .. ZhString.Gem_NameZhPersonalArtifactSuffix
    end
    if self.cardLv and 0 < self.cardLv then
      name = string.format("+%s %s", self.cardLv, name)
    end
    return name
  end
  return ""
end

function ItemData:GetEquipedRefineLv(refineBuffUpSource)
  if self.equipInfo then
    local withLimitBuffUpLv, withoutLimitBuffUpLv, withExtraLimitBuffUpLv
    if self.GetRefineBuffUpLevel then
      withLimitBuffUpLv, withoutLimitBuffUpLv, withExtraLimitBuffUpLv = self:GetRefineBuffUpLevel(refineBuffUpSource)
    end
    local capLv = BlackSmithProxy.Instance:GetEquipCapLevel(self.index, playerId)
    local refinelv = BlackSmithProxy.CalculateBuffUpLevel(self.equipInfo.refinelv, BlackSmithProxy.Instance:MaxRefineLevelByData(self.staticData), withLimitBuffUpLv, withoutLimitBuffUpLv, capLv, withExtraLimitBuffUpLv)
    return refinelv
  end
  return 0
end

function ItemData.GetDamageColorStr()
  return "[ff6021]"
end

function ItemData.CheckIsEquip(itemid)
  return Table_Equip[itemid] ~= nil
end

function ItemData:IsEquip()
  return self.equipInfo ~= nil
end

function ItemData:GetPileString()
  if not self:IsEquip() then
    return nil
  end
  if self:HasEnchant() or self:HasEquipedCard() then
    return nil
  end
  return string.format("pile_%s_%s_%s", self.equipInfo.refinelv or 0, self.equipInfo.equiplv or 0, self.equipInfo.damage and 1 or 0)
end

function ItemData:IsPileStringMatch(str)
  if not str then
    return false
  end
  if not self:IsEquip() then
    return false
  end
  if self:HasEnchant() or self:HasEquipedCard() then
    return false
  end
  local infos = string.split(str, "_")
  if not infos or #infos ~= 4 then
    return false
  end
  if self.equipInfo.refinelv ~= tonumber(infos[2]) then
    return false
  end
  if self.equipInfo.equiplv ~= tonumber(infos[3]) then
    return false
  end
  local isDamage = self.equipInfo.damage and 1 or 0
  if isDamage ~= tonumber(infos[4]) then
    return false
  end
  return true
end

function ItemData:IsAdventureWeaponOrShield()
  local itemtype = self.staticData and self.staticData.Type
  local group = Table_ItemType[itemtype] and Table_ItemType[itemtype].AdventureLogGroup
  return group == 1025 or group == 1026
end

function ItemData.SIsFashion(id)
  if not id then
    return false
  end
  local sData = Table_Item[id]
  if sData and sData.Type and BagProxy.fashionType[sData.Type] then
    return true
  end
  local eData = Table_Equip[id]
  if eData and type(eData.Body) == "table" and next(eData.Body) then
    return true
  end
  return false
end

function ItemData:IsFashion()
  return ItemData.SIsFashion(self.staticData and self.staticData.id)
end

function ItemData:IsMount()
  return self.staticData ~= nil and self.staticData.Type == 90
end

function ItemData:IsPersonalArtifactDebris()
  return self.staticData ~= nil and self.staticData.Type == 549
end

function ItemData:IsPersonalArtifact()
  return self.staticData ~= nil and self.staticData.Type == 550
end

function ItemData:IsRarePersonalArtifact()
  return self:IsPersonalArtifact() and self.staticData.Quality > 2
end

function ItemData:IsClothFashion()
  return nil ~= self.staticData and self.staticData.Type == 501
end

function ItemData:IsNew()
  return self.isNew ~= nil and self.isNew or false
end

function ItemData:IsHint()
  return self.isHint ~= nil and self.isHint or false
end

function ItemData:IsLoveLetter()
  return self.loveLetter ~= nil and self.loveLetter:CheckValid()
end

function ItemData:CanEquip(isSkipSkillCheck)
  if self:IsPetEgg() then
    return self.petEggInfo and self.petEggInfo:PetMountCanEquip()
  end
  local myself = Game.Myself
  if not myself then
    return false
  end
  local sid = self.staticData.id
  local otherLimit = GameConfig.EquipedLimitBySkill
  if otherLimit and not isSkipSkillCheck then
    local skillConfig = otherLimit[sid]
    if skillConfig and myself.data:GetLernedSkillLevel(skillConfig[1]) < skillConfig[2] then
      return false
    end
  end
  if self.equipInfo then
    local sites = self.equipInfo:GetEquipSite()
    if not _MyItemStatusCheck:CanEquipWithCurrentStatus(BagProxy.BagType.RoleEquip, sites) or not _MyItemStatusCheck:CanEquipWithCurrentStatus(BagProxy.BagType.RoleFashionEquip, sites) then
      return false
    end
    if self.equipInfo:IsArtifact() then
      local rid = Game.MapManager:GetRaidID()
      local raidData = rid and Table_MapRaid[rid]
      if raidData and raidData.ForbidAritfact == 1 then
        return false
      end
    end
    if DesertWolfProxy.Instance:IsEquipForbidden(self.equipInfo) then
      return false
    end
    local myPro = myself.data.userdata:Get(UDEnum.PROFESSION)
    if self.equipInfo:CanUseByProfess(myPro) then
      local sexEquip = self.equipInfo.equipData.SexEquip or 0
      local mySex = myself.data.userdata:Get(UDEnum.SEX)
      return sexEquip == 0 or sexEquip == mySex
    end
  else
    return false
  end
end

function ItemData:CanIOffEquip()
  if self.staticData == nil then
    return false
  end
  if self.equipInfo == nil then
    return false
  end
  return _MyItemStatusCheck:CanOffEquipWithCurrentStatus(self.bagtype, self.equipInfo:GetEquipSite())
end

function ItemData:EyeCanEquip()
  if not Game.Myself then
    return false
  end
  local mySex = Game.Myself.data.userdata:Get(UDEnum.SEX)
  local id = self.staticData.id
  local staticData = Table_Eye[id]
  if staticData and (mySex == staticData.Sex or staticData.Sex == 3) and staticData.IsPro == 1 and staticData.OnSale == 1 then
    return true
  end
  return false
end

function ItemData:HairCanEquip(race)
  if self.staticData == nil then
    return false
  end
  if not Game.Myself then
    return false
  end
  local id = self.staticData.id
  local hairid = ShopDressingProxy.Instance:GetHairStyleIDByItemID(id)
  if hairid == nil then
    return false
  end
  local hairSData = Table_HairStyle[hairid]
  if hairSData.IsPro == 1 and hairSData.OnSale == 1 and hairSData.Race == race then
    local mySex = Game.Myself.data.userdata:Get(UDEnum.SEX)
    return hairSData.Sex == mySex
  end
  return false
end

function ItemData:IsCodeCanSell()
  if self.CodeData then
    return self.CodeData:IsCodeCanSell()
  end
  return true
end

function ItemData:Clone()
  local item = ItemData.new(self.id, self.staticData and self.staticData.id or 0)
  item.__isclone = true
  item.num = self.num
  item.isNew = self.isNew
  item.bagtype = self.bagtype
  item.isFavorite = self.isFavorite
  item.noTradeReason = self.noTradeReason
  item.equiped = self.equiped
  item.usedtimes = self.usedtimes
  item.usedtime = self.usedtime
  if item.equipInfo then
    item.equipInfo:Clone(self.equipInfo)
  end
  if self.petEggInfo then
    item.petEggInfo = self.petEggInfo:Clone()
  end
  if self.enchantInfo then
    item.enchantInfo = self.enchantInfo:Clone()
  end
  if self.equipedCardInfo then
    item.equipedCardInfo = {}
    for _pos, _cardInfo in pairs(self.equipedCardInfo) do
      item.equipedCardInfo[_pos] = _cardInfo
    end
  end
  if self.equipMemoryData then
    item.equipMemoryData = self.equipMemoryData:Clone()
  end
  item.cardLv = self.cardLv
  return item
end

function ItemData:Copy(item)
  self.num = item.num
  self.isNew = item.isNew
  self.bagtype = item.bagtype
  if self.equipInfo then
    self.equipInfo:Clone(item.equipInfo)
  end
  self.petEggInfo = item.petEggInfo and item.petEggInfo:Clone()
  self.enchantInfo = item.enchantInfo and item.enchantInfo:Clone()
  if item.equipedCardInfo then
    self.equipedCardInfo = {}
    for _pos, _cardInfo in pairs(self.equipedCardInfo) do
      self.equipedCardInfo[_pos] = _cardInfo
    end
  else
    self.equipedCardInfo = nil
  end
  self.equipMemoryData = item.equipMemoryData and item.equipMemoryData:Clone()
end

function ItemData:NewCompareTo(item)
  if not item then
    return true
  end
  if not item.equipInfo then
    return false
  end
  if item.equipInfo:IsHeadEquipType() then
    return false
  end
  if self:CheckIsEquipCompose() and item:CheckIsEquipCompose() then
    return false
  end
  if self.equipInfo.equipData.id == item.equipInfo.equipData.id then
    return false
  end
  local base_effects = self.equipInfo:GetBaseEffect()
  local self_base_effects = item.equipInfo:GetBaseEffect()
  if not base_effects then
    return false
  end
  if not self_base_effects then
    return true
  end
  for k, v in pairs(self_base_effects) do
    if not base_effects[k] or v >= base_effects[k] then
      return false
    end
  end
  return true
end

function ItemData:CompareTo(item)
  if item and item.equipInfo ~= nil and self.equipInfo ~= nil then
    if self.staticData.Quality >= item.staticData.Quality then
      if item.staticData.Quality == 1 and self.staticData.Quality > item.staticData.Quality then
        return true
      end
      local attrName, attrValue = item.equipInfo:GetEffect()
      local selfAttrName, selfAttrValue = self.equipInfo:GetEffect()
      if attrName ~= selfAttrName then
        return false
      end
      if attrValue ~= nil and selfAttrValue ~= nil then
        if attrValue < selfAttrValue then
          return true
        elseif selfAttrValue == attrValue then
          if item.equipInfo.equipData and self.equipInfo.equipData then
            local selfEquipCardSlot = self.equipInfo.equipData.CardSlot or 0
            local equipCardSlot = item.equipInfo.equipData.CardSlot or 0
            if selfEquipCardSlot > equipCardSlot then
              return true
            end
          end
          return self.equipInfo.refinelv > item.equipInfo.refinelv
        end
        return false
      end
    end
    return false
  end
  return true
end

function ItemData:CanUse()
  if not Game.Myself then
    return true
  end
  if self.equipInfo then
    local myPro = Game.Myself.data.userdata:Get(UDEnum.PROFESSION)
    local isValid = self.equipInfo:CanUseByProfess(myPro)
    if isValid then
      return self.num > 0 and 0 >= self.cdTime
    end
  end
  return self.num > 0 and 0 >= self.cdTime
end

function ItemData:IsJobLimit()
  if not Game.Myself then
    return true
  end
  local joblimit = self.staticData.JobLimit
  if joblimit and 0 < #joblimit then
    local myPro = Game.Myself.data.userdata:Get(UDEnum.PROFESSION)
    local canuse = false
    for i = 1, #joblimit do
      if myPro == joblimit[i] then
        canuse = true
        break
      end
    end
    if not canuse then
      return true
    end
  end
  return false
end

function ItemData:CheckIsEquipCompose()
  local sid = self.staticData and self.staticData.id
  return nil ~= sid and nil ~= Table_EquipCompose[sid]
end

function ItemData:IsLimitUse()
  local sid = self.staticData.id
  local sData = Table_UseItem[sid]
  if sData == nil then
    return false
  end
  local limitType = sData.LimitType
  if limitType == 1 and Game.MapManager:IsPvpMode_DesertWolf() and PvpProxy.Instance:IsFoodForbidden() then
    return true
  end
  local useLimitNew = sData.UseLimitNew
  if useLimitNew and 0 < useLimitNew and useLimitNew & 1 > 0 and HomeManager.Me():IsAtHome() then
    return false
  end
  local uselimit = sData.UseLimit
  if uselimit == nil then
    return false
  end
  if uselimit & 1 > 0 and Game.MapManager:IsPVPMode_GVGDetailed() then
    return true
  end
  if 0 < uselimit & 2 then
    local currentRaidID = Game.MapManager:GetRaidID()
    local raidData = currentRaidID and Table_MapRaid[currentRaidID]
    if raidData == nil or raidData.Type ~= 10 then
      return true
    end
  end
  if 0 < uselimit & 4 and not Game.MapManager:IsPVPMode() then
    return true
  end
  if 0 < uselimit & 16 and Game.MapManager:IsPVPMode_MvpFight() then
    return true
  end
  if 0 < uselimit & 64 and (Game.MapManager:IsPVPMode_TeamPws() or Game.MapManager:IsPVPMode_3Teams()) then
    return true
  end
  if 0 < uselimit & 256 and not Game.MapManager:IsPVEMode_ExpRaid() then
    return true
  end
  if 0 < uselimit & 512 and (Game.MapManager:IsPveMode_Thanatos() or Game.MapManager:IsPVEMode_ComodoRaid() or Game.MapManager:IsPVEMode_MultiBossRaid() or Game.MapManager:IsPVEMode_Element()) then
    return true
  end
  if 0 < uselimit & 1024 and Game.MapManager:IsPVEMode_HeadwearRaid() then
    return true
  end
  if 0 < uselimit & 2048 and Game.MapManager:IsPVEMode_Roguelike() then
    return true
  end
  if 0 < uselimit & 8192 and Game.MapManager:IsMapForbid() then
    return true
  end
  if 0 < uselimit & 16384 and Game.MapManager:IsPvPMode_TeamTwelve() then
    return true
  end
  if 0 < uselimit & 32768 and RaidPuzzleManager.Me():IsWorking() then
    return true
  end
  if 0 < uselimit & 65536 and not HomeManager.Me():IsAtHome() then
    return true
  end
  if 0 < uselimit & 131072 and Game.MapManager:IsPveMode_Arena() then
    return true
  end
  if 0 < uselimit & 524288 and Game.MapManager:IsPVEMode_CrackRaid() then
    return true
  end
  if 0 < uselimit & 2097152 then
    return not ProfessionProxy.CanChangeProfession()
  end
  if 0 < uselimit & 1048576 and Game.MapManager:IsPVEMode_BossScene() then
    return true
  end
  if 0 < uselimit & 4194304 and GameConfig.UseItemLimitMap[sid] then
    return 0 < TableUtility.ArrayFindIndex(GameConfig.UseItemLimitMap[sid], Game.MapManager:GetMapID())
  end
  return false
end

function ItemData:CanUseForTarget(targetType, targetID, detailtype)
  if self.staticData == nil then
    return false
  end
  local st = self.staticData.ItemTarget.type
  local id = self.staticData.ItemTarget.id
  local npctype = self.staticData.ItemTarget.npcType
  if st ~= nil then
    if st == 1 then
      return targetType == ItemTarget_Type.Player
    elseif st == 2 then
      return targetType == ItemTarget_Type.Monster
    elseif st == 3 then
      return targetType == ItemTarget_Type.Monster or targetType == ItemTarget_Type.Player
    elseif st == 4 then
      return targetType == ItemTarget_Type.NPC and id == targetID
    elseif st == 5 then
      return targetType == ItemTarget_Type.Monster or targetType == ItemTarget_Type.Player or targetType == ItemTarget_Type.Npc
    elseif st == 6 then
      return detailtype == npctype
    end
  end
  return false
end

function ItemData:ToString()
  return string.format("Guid:%s Sid:%d Equiped:%d Type:%d Quality:%d Index:%d Num:%d", self.id, self.staticData.id, self.equiped, self.staticData.Type, self.staticData.Quality, self.index, self.num)
end

function ItemData:ToTestString()
  return string.format("Guid:%s Sid:%d Equiped:%d Type:%d Quality:%d Index:%d Num:%d", self.id, self.sid, self.equiped, self.type, self.qua, self.index, self.num)
end

function ItemData:ParseFromServerData(serverItem)
  local sItemData = serverItem.base
  local sEquipData = serverItem.equip
  local sECardInfo = serverItem.card
  if serverItem.equiped then
    self.equiped = 1
  else
    self.equiped = 0
  end
  self:ResetData(sItemData.guid, sItemData.id)
  if self.staticData == nil then
    errorLog("server send item ,which has no staticData " .. sItemData.id)
    return
  end
  self.num = sItemData.count
  self.battlepoint = serverItem.battlepoint
  self.isNew = serverItem.base.isnew
  self.isHint = serverItem.base.ishint
  self.index = sItemData.index
  self.createtime = sItemData.createtime
  self.deltime = sItemData.overtime
  self.noTradeReason = sItemData.no_trade_reason
  self.usedtimes = sItemData.usedtimes
  self.usedtime = sItemData.usedtime
  self.isFavorite = sItemData.isfavorite
  self.isFashion = BagProxy.fashionType[self.staticData.Type] or false
  self.bind = sItemData.eBind == ProtoCommon_pb.EBINDTYPE_BIND
  if self.equipInfo and sEquipData then
    self.equipInfo:Set(sEquipData)
  end
  self:SetEquipCards(sECardInfo)
  if serverItem.enchant then
    self:SetEnchantInfo(serverItem.enchant)
    self:SetRefreshEnchantAttrs(serverItem.previewattr)
  end
  self:SetCacheEnchantInfo(serverItem.previewenchant)
  self:UpdateEnchantCombineEffect()
  self:UpdateSecretLand(serverItem.gem_secret_land)
  local sLoveLetter = serverItem.letter
  if sLoveLetter then
    if self.loveLetter == nil then
      self.loveLetter = LoveLetterData.new()
    end
    self.loveLetter:SetDataByItemServerData(sItemData.id, sLoveLetter)
  end
  if serverItem.egg and serverItem.egg.id ~= nil and serverItem.egg.id ~= 0 then
    self.petEggInfo = PetEggInfo.new(self.staticData)
    self.petEggInfo:Server_SetData(serverItem.egg)
  end
  if serverItem.code and serverItem.code.code ~= "" then
    self.CodeData = CodeData.new(sItemData.guid, self.staticData)
    self.CodeData:Server_SetData(serverItem.code)
  end
  if serverItem.wedding and serverItem.wedding.id ~= 0 then
    if not self.weddingData then
      self.weddingData = WeddingData.new(self.staticData)
    end
    self.weddingData:Server_Update(serverItem.wedding)
  end
  local s_sender = serverItem.sender
  if s_sender and s_sender.charid ~= nil and s_sender.charid ~= 0 then
    self.sender_charid = s_sender.charid
    self.sender_name = s_sender.name
  end
  GemProxy.TryParseGemAttrDataFromServerItemData(self, serverItem)
  GemProxy.TryParseGemSkillDataFromServerItemData(self, serverItem)
  if serverItem.home then
    local ownerId = serverItem.home.ownerid
    if ownerId and ownerId ~= 0 then
      self.homeOwnerId = ownerId
    end
  end
  PersonalArtifactProxy.TryParseDataFromServerItemData(self, serverItem)
  if serverItem.cupinfo then
    local cupname = serverItem.cupinfo.name
    if cupname ~= "" then
      self.cup_name = cupname
    end
  end
  if serverItem.red_packet then
    self.redPacketData = self.redPacketData or {}
    self.redPacketData.staticId = serverItem.red_packet.config_id
    self.redPacketData.minNumLimit = serverItem.red_packet.min_num
    self.redPacketData.maxNumLimit = serverItem.red_packet.max_num
    self.redPacketData.minMoneyLimit = serverItem.red_packet.min_money
    self.redPacketData.maxMoneyLimit = serverItem.red_packet.max_money
    if 0 < #serverItem.red_packet.multi_items then
      self.redPacketData.multiItems = self.redPacketData.multiItems or {}
      TableUtility.ArrayClear(self.redPacketData.multiItems)
      for i = 1, #serverItem.red_packet.multi_items do
        local item = {}
        item.itemid = serverItem.red_packet.multi_items[i].itemid
        item.group_count = serverItem.red_packet.multi_items[i].group_count
        table.insert(self.redPacketData.multiItems, item)
      end
    end
    self.redPacketData.gvg_cityid = serverItem.red_packet.gvg_cityid
    if serverItem.red_packet.gvg_charids then
      self.redPacketData.gvg_charids = self.redPacketData.gvg_charids or {}
      TableUtility.ArrayClear(self.redPacketData.gvg_charids)
      for i = 1, #serverItem.red_packet.gvg_charids do
        self.redPacketData.gvg_charids[i] = serverItem.red_packet.gvg_charids[i]
      end
    end
  end
  local memoryInfo = serverItem.memory
  if memoryInfo and memoryInfo.itemid and memoryInfo.itemid ~= 0 then
    self:SetMemoryInfo(memoryInfo)
  elseif self.equipMemoryData then
    self.equipMemoryData = nil
  end
  if self:IsCard() then
    self:SetCardLevel(sItemData.card_info and sItemData.card_info.lv or 0)
  end
end

function ItemData:CheckFragmentActive(id)
  if self.personalArtifactData then
    return self.personalArtifactData:CheckFragmentActive(id)
  end
  return false
end

function ItemData:CheckPersonalArtifactValid()
  if self.personalArtifactData then
    return self.personalArtifactData:CheckValid()
  end
  return false
end

function ItemData:CheckPersonalArtifactInActive()
  if self.personalArtifactData then
    return self.personalArtifactData:CheckInActive()
  end
  return true
end

function ItemData:GetFragmentCount()
  if self.personalArtifactData then
    return self.personalArtifactData:GetFragmentCount()
  end
  return 0
end

function ItemData:GetPersonalArtifactState()
  return self.personalArtifactData and self.personalArtifactData:GetState() or PersonalArtifactProxy.EArtifactState.InActivated
end

function ItemData:IsPersonalArtifactFragment()
  return self.personalArtifactData and self.personalArtifactData:GetState() == PersonalArtifactProxy.EArtifactState.Fragments
end

function ItemData:ExportServerItem()
  if not self.staticData then
    return
  end
  local serverItem = SceneItem_pb.ItemData()
  serverItem.base.id = self.staticData.id
  if self.equipInfo then
    serverItem.equip.refinelv = self.equipInfo.refinelv
    serverItem.equip.damage = self.equipInfo.damage
    serverItem.equip.lv = self.equipInfo.equiplv
  end
  if self.enchantInfo then
    local attrs = self.enchantInfo:GetEnchantAttrs()
    if 0 < #attrs then
      serverItem.enchant.type = self.enchantInfo.enchantType
      for i = 1, #attrs do
        local serverAttri = SceneItem_pb.EnchantAttr()
        serverAttri.type = attrs[i].type
        serverAttri.value = attrs[i].serverValue
        table.insert(serverItem.enchant.attrs, serverAttri)
      end
      local combineEffect = self.enchantInfo:GetCombineEffects()
      for i = 1, #combineEffect do
        local serverExtra = SceneItem_pb.EnchantExtra()
        serverExtra.configid = combineEffect[i].configid
        serverExtra.buffid = combineEffect[i].buffid
        table.insert(serverItem.enchant.extras, serverExtra)
      end
    end
  end
  table.insert(serverItem.artifact.attrs, SceneItem_pb.ArtifactAttr())
  table.insert(serverItem.artifact.preattrs, SceneItem_pb.ArtifactAttr())
  if self:IsCard() and self.cardLv then
    serverItem.base.card_info.lv = self.cardLv
  end
  return serverItem
end

function ItemData:ExportServerItemInfo()
  if not self.staticData then
    return
  end
  local serverItemInfo = NetConfig.PBC and {} or SceneItem_pb.ItemInfo()
  serverItemInfo.guid = self.id
  serverItemInfo.id = self.staticData.id
  serverItemInfo.count = self.num
  return serverItemInfo
end

function ItemData:UpdateEnchantCombineEffect()
  if self.enchantInfo and self.equipInfo then
    self.enchantInfo:UpdateCombineEffectWork(self.equipInfo.refinelv)
  end
end

function ItemData:UpdateSecretLand(data)
  if not (data and data.id) or data.id == 0 then
    return
  end
  local secretLandId = GemProxy.Instance:GetSecretLandID(data.id)
  if secretLandId and Table_SecretLandGem[secretLandId] then
    self.secretLandDatas = GemSecretLandData.new(secretLandId)
    self.secretLandDatas:SetServerData(self.id, data)
  else
    redlog("未在Table_SecretLandGem表中找到ItemID： ", data.id)
  end
end

function ItemData:CheckAttrUpWorkValid()
  return self.enchantInfo:CheckAttrUpWorkValid()
end

function ItemData:CheckThirdAttrResetValid()
  return self.enchantInfo:CheckThirdAttrResetValid()
end

function ItemData:SetDelWarningState(b)
  self.delWarning = b
end

function ItemData:GetDelWarningState()
  return self.delWarning
end

function ItemData:CheckItemCardType(item_CardType)
  if self.cardInfo and self.cardInfo.Type then
    return self.cardInfo.Type & item_CardType > 0
  end
  return false
end

function ItemData:GetFoodSData()
  local sid = self.staticData.id
  return Table_Food[sid]
end

function ItemData:GetFurnitureSData()
  local sid = self.staticData.id
  return Table_HomeFurniture[sid]
end

function ItemData:GetHomeMaterialSData()
  local sid = self.staticData.id
  return Table_HomeFurnitureMaterial[sid]
end

function ItemData:IsFood()
  return self:GetFoodSData() ~= nil
end

function ItemData:IsCard()
  return self.cardInfo ~= nil
end

function ItemData:IsPic()
  if self.staticData then
    return self.staticData.Type == 50
  end
  return false
end

function ItemData:IsEquipMaterial()
  if self.staticData then
    return self.staticData.Type == 70
  end
  return false
end

function ItemData:IsHomePic()
  if self.staticData then
    return self.staticData.Type == 55
  end
  return false
end

function ItemData:IsHomeMaterialPic()
  if self.staticData and self.staticData.Type == 55 then
    local composeInfo = Table_Compose[self.staticData.id]
    if composeInfo then
      local productId = composeInfo.Product.id
      if Table_HomeFurnitureMaterial[productId] then
        return true
      end
    end
  end
  return false
end

function ItemData:IsPetEgg()
  return self.staticData ~= nil and self.staticData.Type == 101
end

function ItemData:IsMountPet()
  if self:IsPetEgg() then
    local petStaticData = Game.Config_EggPet[self.staticData.id]
    return petStaticData ~= nil and petStaticData.CanEquip == 1
  end
  return false
end

function ItemData:IsFurniture()
  return self:GetFurnitureSData() ~= nil
end

function ItemData:IsHomeMatetial()
  return self:GetHomeMaterialSData() ~= nil
end

function ItemData:IsUseItem()
  if self.staticData == nil then
    return false
  end
  return Table_UseItem[self.staticData.id] ~= nil
end

function ItemData:IsMarryInviteLetter()
  if self.staticData and self.weddingData then
    return self.staticData.Type == 167
  end
  return false
end

function ItemData:IsMarriageCertificate()
  if self.staticData and self.weddingData then
    return self.staticData.Type == 166
  end
  return false
end

function ItemData:IsMarriageRing()
  if self.staticData and self.weddingData then
    return self.staticData.Type == 540
  end
  return false
end

function ItemData:IsTrolley()
  return self.staticData ~= nil and self.staticData.Type == 91
end

function ItemData:IsToy()
  return self.staticData ~= nil and self.staticData.Type == 77
end

function ItemData:IsMemory()
  return self.memoryData ~= nil
end

function ItemData:IsHideMemoryCorner()
  return self.hideMemoryCorner
end

function ItemData:GetFoodEffectDesc()
  if self.buffDesc == nil then
    self.buffDesc = ""
    local sid = self.staticData.id
    if sid == FoodProxy.FailFood_ItemID then
      self.buffDesc = "??????????"
    else
      local foodSData = self:GetFoodSData()
      if foodSData then
        local buffids = foodSData.BuffEffect
        local buff_SData
        for i = 1, #buffids do
          buff_SData = Table_Buffer[buffids[i]]
          self.buffDesc = self.buffDesc .. OverSea.LangManager.Instance():GetLangByKey(buff_SData.Dsc)
          if i < #buffids then
            self.buffDesc = self.buffDesc .. "\n"
          end
        end
      else
        self.buffDesc = ""
      end
    end
  end
  return self.buffDesc
end

function ItemData:CanTrade()
  if self.noTradeReason and self.noTradeReason > 0 then
    return false
  end
  if self.petEggInfo then
    return self.petEggInfo:CanExchange()
  end
  if BagProxy.Instance:CheckIsFavorite(self) then
    return false
  end
  if self.tradeForbidden == nil then
    local itemType = self.staticData and self.staticData.Type
    self.tradeForbidden = itemType and FunctionUnLockFunc.CheckForbiddenByFuncState("exchange_type_forbidden", itemType) or false
    if not self.tradeForbidden then
      local tryParse_FuncStateId = self.staticData.id and Game.Config_EquipComposeIDForbidMap[self.staticData.id]
      if tryParse_FuncStateId then
        self.tradeForbidden = not FunctionUnLockFunc.checkFuncStateValid(tryParse_FuncStateId)
      end
    end
  end
  if self.tradeForbidden then
    return false
  end
  return ItemData.CheckItemCanTrade(self.staticData.id)
end

function ItemData:CanCardDecompose()
  return not self.noTradeReason or self.noTradeReason <= 0
end

function ItemData.CheckItemCanTrade(itemid)
  return ItemData.CheckTradeTime(itemid) and ItemData.CheckUnTradeTime(itemid)
end

function ItemData.CheckTradeTime(itemid)
  local data = Table_Exchange[itemid]
  if data then
    if data.Trade ~= 1 then
      return false
    end
    local tradeTime
    if EnvChannel.IsTFBranch() then
      tradeTime = data.TFTradeTime
    else
      tradeTime = data.TradeTime
    end
    if tradeTime ~= nil and tradeTime ~= "" then
      local t = StringUtil.FormatTime2TimeStamp(tradeTime)
      return t <= ServerTime.CurServerTime() / 1000
    end
    return true
  end
  return false
end

function ItemData.CheckUnTradeTime(itemid)
  local data = Table_Exchange[itemid]
  if data then
    if data.Trade ~= 1 then
      return false
    end
    local unTradeTime
    if EnvChannel.IsTFBranch() then
      unTradeTime = data.TFUnTradeTime
    else
      unTradeTime = data.UnTradeTime
    end
    if unTradeTime ~= nil and unTradeTime ~= "" then
      local t = StringUtil.FormatTime2TimeStamp(unTradeTime)
      return t >= ServerTime.CurServerTime() / 1000
    end
    return true
  end
  return false
end

function ItemData.Get_GetLimitCount(itemid)
  if not Game.Myself then
    return
  end
  local limitCfg = Table_Item[itemid].GetLimit
  local limitCount
  if limitCfg.type == 3 or limitCfg.type == 8 then
    limitCount = limitCfg.limit_count
  else
    limitCount = ItemData.Help_GetLimitCount(limitCfg.limit, Game.Myself.data.userdata:Get(UDEnum.ROLELEVEL))
  end
  if type(limitCount) == "table" then
    local hasMonthVIP = ServiceUserEventProxy.Instance:AmIMonthlyVIP()
    if hasMonthVIP then
      limitCount = limitCount[1] + limitCount[2]
    else
      limitCount = limitCount[1]
    end
  end
  return limitCount
end

function ItemData.Help_GetLimitCount(map, mylv)
  local tempTable, limitCount = ReusableTable.CreateArray()
  TableUtility.TableClear(tempTable)
  for lv, count in pairs(map) do
    table.insert(tempTable, {lv, count})
  end
  table.sort(tempTable, function(a, b)
    return a[1] < b[1]
  end)
  for i = 1, #tempTable do
    if mylv <= tempTable[i][1] then
      limitCount = tempTable[i][2]
      break
    end
  end
  if limitCount == nil then
    limitCount = tempTable[1][2]
  end
  ReusableTable.DestroyAndClearArray(tempTable)
  return limitCount
end

local limitPrefixKeyMap = {
  [1] = "ItemTip_GetLimit_Day",
  [4] = "ItemTip_GetLimit_Day",
  [5] = "ItemTip_GetLimit_Week",
  [6] = "ItemTip_GetLimit_Month",
  [7] = "ItemTip_GetLimit_Week",
  [8] = "ItemTip_GetLimit_Acc"
}

function ItemData.GetLimitPrefixFromCfg(limitCfg)
  local type = limitCfg and limitCfg.type
  return type and limitPrefixKeyMap[type] and ZhString[limitPrefixKeyMap[type]] or ""
end

function ItemData:CanStack()
  if self.staticData == nil then
    return
  end
  return self.staticData.MaxNum > 1
end

function ItemData:IsWalletAccountItem()
  return self:CanStorage(BagProxy.BagType.Storage) or self:CanStorage(BagProxy.BagType.Home)
end

function ItemData:CanStorage(bagType)
  if self.staticData == nil then
    return false
  end
  local noStorage = self.staticData.NoStorage
  if noStorage == nil then
    return true
  end
  local Item_Nostorge_Type = {
    [BagProxy.BagType.Storage] = 1,
    [BagProxy.BagType.PersonalStorage] = 2,
    [BagProxy.BagType.Barrow] = 2,
    [BagProxy.BagType.Home] = 4
  }
  local forbidValue = Item_Nostorge_Type[bagType]
  if forbidValue == nil then
    return true
  end
  return noStorage & forbidValue <= 0
end

function ItemData:SetItemNum(num)
  self.num = num
end

function ItemData:CheckIsLimitedTime()
  if self.deltime and self.deltime > 0 then
    return true
  end
  return self:IsUseItem() and nil ~= Table_UseItem[self.staticData.id].UseInterval
end

function ItemData:CanIntervalUse()
  local sid = self.staticData.id
  if sid == nil then
    return false
  end
  local interval = Table_UseItem[sid] and Table_UseItem[sid].UseInterval
  if interval == nil then
    return false
  end
  local nextUseTime = self.usedtime or 0
  return 0 < ServerTime.CurServerTime() / 1000 - (nextUseTime + interval)
end

function ItemData:GetUseEffectTime()
  local sid = self.staticData.id
  if sid == nil then
    return 0
  end
  local useeffect = Table_UseItem[sid] and Table_UseItem[sid].UseEffect
  if useeffect == nil then
    return 0
  end
  return useeffect.time or 0
end

function ItemData:IsPortraitFrame()
  local useItemData = Table_UseItem[self.staticData.id]
  local useeffect = useItemData and useItemData.UseEffect
  if useeffect then
    return useeffect.type == "add_portrait_frame", useeffect.id
  else
    return false
  end
end

function ItemData:IsBackground()
  local useItemData = Table_UseItem[self.staticData.id]
  local useeffect = useItemData and useItemData.UseEffect
  if useeffect then
    return useeffect.type == "add_background", useeffect.id
  else
    return false
  end
end

function ItemData:IsChatframe()
  local useItemData = Table_UseItem[self.staticData.id]
  local useeffect = useItemData and useItemData.UseEffect
  if useeffect then
    return useeffect.type == "add_chat_frame", useeffect.id
  else
    return false
  end
end

function ItemData:IsSelectRewardPackage()
  local useItemData = Table_UseItem[self.staticData.id]
  local useEffect = useItemData and useItemData.UseEffect
  if useEffect then
    if useEffect.type == "headwear_box" then
      return true
    else
      return false
    end
  else
    return false
  end
end

function ItemData:CheckMapLimit(mapid)
  if self.staticData == nil then
    return false
  end
  if not self.mapLimit or #self.mapLimit == 0 then
    return true
  end
  return table.ContainsValue(self.mapLimit, mapid)
end

function ItemData:GetMapLimitTipID()
  return self.mapLimitTipid
end

function ItemData:HasEnchant()
  return self.enchantInfo ~= nil and #self.enchantInfo:GetEnchantAttrs() > 0
end

function ItemData:SetStrengthLv(lv)
  if self:IsEquip() then
    self.equipInfo:SetEquipStrengthLv(lv)
  end
end

function ItemData:SetGuildStrengthLv(lv)
  if self:IsEquip() then
    self.equipInfo:SetEquipGuildStrengthLv(lv)
  end
end

local equipBuffUpLevelLimits = {
  1,
  0,
  2
}

function ItemData:GetEquipBuffUpLevel(playerId, buffUpType)
  if ItemUtil.IsGVGSeasonEquip(self.staticData.id) or BlackSmithProxy.CheckCanEquipBuffUpLevel(self, playerId, buffUpType) then
    local curSite = BagProxy.Instance:GetRoleBagSite(self.id)
    local siteConfig
    if not curSite then
      siteConfig = GameConfig.EquipType[self.equipInfo.equipData.EquipType]
      siteConfig = siteConfig and siteConfig.site[1]
    else
      siteConfig = curSite
    end
    return BlackSmithProxy.GetEquipBuffUpLevel(siteConfig, playerId, buffUpType, equipBuffUpLevelLimits)
  end
  return 0, 0, 0
end

function ItemData:GetStrengthBuffUpLevel(playerId)
  return self:GetEquipBuffUpLevel(playerId, "Strength")
end

function ItemData:GetRefineBuffUpLevel(playerId)
  return self:GetEquipBuffUpLevel(playerId, "Refine")
end

function ItemData:IsServerShadowEquip()
  return self.bagtype == SceneItem_pb.EPACKTYPE_SHADOWEQUIP
end

function ItemData:IsShadowEquip()
  return self:IsServerShadowEquip() or nil ~= ItemUtil.manualQuenchValue or ItemUtil.QuenchOpen
end

function ItemData:CanShowQuenchLv()
  if not self:HasQuench() then
    return false
  end
  if ItemUtil.QuenchOpen then
    return true
  end
  if self.bagtype == SceneItem_pb.EPACKTYPE_SHADOWEQUIP or self.bagtype == SceneItem_pb.EPACKTYPE_MAIN then
    return true
  end
  return false
end

function ItemData:HasQuench(includeEqual)
  if self.equipInfo and "number" == type(self.equipInfo.quench_per) then
    if includeEqual then
      return self.equipInfo.quench_per >= 0
    else
      return self.equipInfo.quench_per > 0
    end
  end
  return false
end

function ItemData:GetQuenchPer()
  if self:HasQuench() then
    if PvpProxy.Instance:IsFreeFire() and not ISNoviceServerType then
      return self.equipInfo:MaxQunenchPer() or 50
    end
    return self.equipInfo.quench_per
  end
  return nil
end

function ItemData:GetAttrPercentByQuench(ignoreBagType)
  if nil ~= ItemUtil.manualQuenchValue then
    return ItemUtil.manualQuenchValue
  end
  if not ignoreBagType and not self:IsShadowEquip() then
    return 1
  end
  if PvpProxy.Instance:IsFreeFire() and not ISNoviceServerType then
    return 1
  end
  return self.equipInfo.quench_per / 100
end

function ItemData.IsRelics(itemId)
  local equipConf = Table_Equip[itemId]
  if equipConf then
    local typeConfig = GameConfig.EquipType and GameConfig.EquipType[equipConf.EquipType]
    if typeConfig and typeConfig.equipBodyIndex == "PersonalArtifact" then
      return true
    end
  end
  return false
end

function ItemData.IsArtifact(itemId)
  local equipConf = Table_Equip[itemId]
  if equipConf then
    local typeConfig = GameConfig.EquipType and GameConfig.EquipType[equipConf.EquipType]
    if typeConfig and typeConfig.equipBodyIndex == "Artifact" then
      return true
    end
  end
  return false
end

function ItemData:IsNoPileSlot()
  return self.noPileSlot
end

function ItemData:IsExtraction()
  return self.extractionInfo ~= nil
end

function ItemData:IsExtractionActive()
  return false
end

function ItemData:IsRedPacket()
  return self.staticData and self.staticData.Type == 4208 or false
end

function ItemData.GetHoldedCountLimit(itemid)
  local data = Table_Exchange[itemid]
  if data then
    local buyLimit = data.BuyLimit
    if buyLimit and buyLimit.type and buyLimit.type == "Count" then
      local count = buyLimit.Param and buyLimit.Param.count
      return count
    end
  end
end

function ItemData.GetSellCountLimit(itemid)
  local data = Table_Exchange[itemid]
  if data then
    local sellLimit = data.SellLimit
    if sellLimit and sellLimit.type and sellLimit.type == "Count" then
      local count = sellLimit.Param and sellLimit.Param.count
      return count
    end
  end
end

function ItemData:SetMemoryInfo(memoryData)
  if self.equipMemoryData == nil then
    self.equipMemoryData = EquipMemoryData.new(self.id)
  end
  self.equipMemoryData:SetMyServerData(memoryData)
end

function ItemData:HasMemoryInfo()
  return self.equipMemoryData ~= nil
end

function ItemData:IsAnonymousItem()
  return self.staticData and self.staticData.Type == 557 or false
end

function ItemData:GetComposeFashionTarget()
  if not self.composeFashionTarget then
    if not Table_AstralSeason then
      return
    end
    for _, _info in pairs(Table_AstralSeason) do
      local _fashionReward = _info.FashionReward
      if _fashionReward then
        for _diff, _reward in pairs(_fashionReward) do
          if _reward and _reward[1] == self.staticData.id then
            self.composeFashionTarget = _info.FashionEquip
            break
          end
        end
      end
    end
  end
  return self.composeFashionTarget
end

function ItemData:SetCardLevel(cardLv)
  self.cardLv = cardLv or 0
end

function ItemData:GetCardQuality()
  if self.cardLv and self.cardLv >= 5 then
    return 5
  end
  return self.staticData.Quality
end

function ItemData:HasCardLv()
  return self.cardLv and self.cardLv > 0
end

function ItemData:GetCardBufferIds()
  if self:IsCard() then
    local bufferIds = self.cardInfo.BuffEffect.buff
    if self.cardLv and self.cardLv > 0 then
      local cfg = Game.CardUpgradeMap and Game.CardUpgradeMap[self.staticData.id]
      if cfg then
        bufferIds = cfg[self.cardLv].BuffEffect
      end
    end
    return bufferIds
  end
end

function ItemData:GetCardAttrs(iconPrefix)
  local attrs = {}
  if self:IsCard() then
    local bufferIds = self:GetCardBufferIds()
    if bufferIds then
      for i = 1, #bufferIds do
        local str = ItemUtil.getBufferDescById(bufferIds[i])
        if not StringUtil.IsEmpty(str) then
          local bufferStrs = string.split(str, "\n")
          for j = 1, #bufferStrs do
            table.insert(attrs, (iconPrefix or "") .. bufferStrs[j])
          end
        end
      end
    end
  end
  return attrs
end
