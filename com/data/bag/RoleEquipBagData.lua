autoImport("ItemData")
autoImport("BagTabData")
autoImport("BagMainTab")
autoImport("BagData")
RoleEquipBagData = class("RoleEquipBagData", BagData)
local _EquipStrengthType = SceneItem_pb.ESTRENGTHTYPE_NORMAL

function RoleEquipBagData:ctor(tabs, tabClass, type)
  RoleEquipBagData.super.ctor(self, tabs, tabClass, type)
  self.siteMap = {}
  self.staticIdMap = {}
  self.itemTypeMap = {}
end

local MirrorIndexMap = {
  [5] = 6,
  [6] = 5
}

function RoleEquipBagData:SetSiteMapItem(index, item)
  if item then
    local mirrorIndex = MirrorIndexMap[index]
    if mirrorIndex then
      local mirrorItem = self.siteMap[mirrorIndex]
      if mirrorItem and mirrorItem.id == item.id then
        self.siteMap[mirrorIndex] = nil
      end
    end
  end
  self.siteMap[index] = item
  if item then
    local site = StrengthProxy.Instance:GetStrengthenData(_EquipStrengthType, index)
    if site then
      self:UpdateStrengthLv(_EquipStrengthType, index, site.lv)
    end
  end
end

function RoleEquipBagData:GetSite(id)
  for k, v in pairs(self.siteMap) do
    if v and v.id == id then
      return k
    end
  end
  return nil
end

function RoleEquipBagData:IsMagicSuitPosEmpty()
  local pos = GameConfig.System.equipSuitPos
  for i = 1, #pos do
    if nil ~= self.siteMap[pos[i]] then
      return false
    end
  end
  return true
end

function RoleEquipBagData:UpdateStrengthLv(type, index, lv)
  if type == SceneItem_pb.ESTRENGTHTYPE_NORMAL then
    if nil ~= self.siteMap[index] then
      self.siteMap[index]:SetStrengthLv(lv)
    end
    GameFacade.Instance:sendNotification(ItemEvent.StrengthLvUpdate, {index, lv})
  elseif type == SceneItem_pb.ESTRENGTHTYPE_GUILD then
    if nil ~= self.siteMap[index] then
      self.siteMap[index]:SetGuildStrengthLv(lv)
    end
    GameFacade.Instance:sendNotification(ItemEvent.GuildStrengthLvUpdate)
  end
end

function RoleEquipBagData:Reinit()
  for _, item in pairs(self.siteMap) do
    item:SetStrengthLv(0)
    item:SetGuildStrengthLv(0)
  end
end

function RoleEquipBagData:UpdateItem(item, serverItem)
  RoleEquipBagData.super.UpdateItem(self, item, serverItem)
  self:SetSiteMapItem(item.index, item)
end

function RoleEquipBagData:AddItem(item)
  RoleEquipBagData.super.AddItem(self, item)
  self:SetSiteMapItem(item.index, item)
  if item.staticData then
    if self.staticIdMap then
      self.staticIdMap[item.staticData.id] = 1
    end
    if self.itemTypeMap then
      local num = self.itemTypeMap[item.staticData.Type]
      if num == nil then
        num = 0
      end
      num = num + 1
      self.itemTypeMap[item.staticData.Type] = num
    end
  end
  EventManager.Me():PassEvent(RoleEquipEvent.TakeOn, item)
end

function RoleEquipBagData:RemoveItemByGuid(itemId)
  local item = self:GetItemByGuid(itemId)
  RoleEquipBagData.super.RemoveItemByGuid(self, itemId)
  if item then
    self:SetSiteMapItem(item.index, nil)
    if item.staticData then
      if self.staticIdMap then
        self.staticIdMap[item.staticData.id] = nil
      end
      if self.itemTypeMap then
        local num = self.itemTypeMap[item.staticData.Type]
        if num == nil then
          num = 0
        end
        num = math.max(0, num - 1)
        self.itemTypeMap[item.staticData.Type] = num
      end
    end
    EventManager.Me():PassEvent(RoleEquipEvent.TakeOff, item)
  end
end

function RoleEquipBagData:GetStaticIdMap()
  return self.staticIdMap
end

function RoleEquipBagData:GetEquipBySite(site)
  if type(site) == "number" then
    return self.siteMap[site]
  end
end

function RoleEquipBagData:GetEquipCardNumBySiteAndCardID(site, cardID)
  local equip = self:GetEquipBySite(site)
  if equip and equip.equipedCardInfo then
    if cardID == nil or cardID == 0 then
      return equip:GetEquipedCardNum()
    end
    local count = 0
    if type(equip.cardSlotNum) == "number" then
      local card
      for i = 1, equip.cardSlotNum do
        card = equip.equipedCardInfo[i]
        if card and card.staticData and card.staticData.id == cardID then
          count = count + 1
        end
      end
    end
    return count
  end
  return 0
end

function RoleEquipBagData:GetTypeMap()
  return self.itemTypeMap
end

function RoleEquipBagData:GetNumByItemType(t)
  return self.itemTypeMap and self.itemTypeMap[t]
end

function RoleEquipBagData:GetEquipedItemNum(itemId)
  local count = 0
  if Table_Equip[itemId] then
    for _, item in pairs(self.siteMap) do
      if item.staticData and item.staticData.id == itemId then
        count = count + 1
      end
    end
  elseif Table_Card[itemId] then
    for _, item in pairs(self.siteMap) do
      if item.equipedCardInfo then
        for kk, card in pairs(item.equipedCardInfo) do
          if card.id == itemId then
            count = count + 1
          end
        end
      end
    end
  end
  return count
end

function RoleEquipBagData:GetEqiupedSuitCardIds()
  local equipCards = {}
  for k, item in pairs(self.siteMap) do
    if item.equipedCardInfo then
      for kk, card in pairs(item.equipedCardInfo) do
        if card and card.suitInfo then
          equipCards[card.staticData.id] = 1
        end
      end
    end
  end
  return equipCards
end

function RoleEquipBagData.GetEquipSiteByItemid(itemid)
  local equipData = Table_Equip[itemid]
  if equipData == nil then
    return nil
  end
  local equipType = equipData.EquipType
  local equipConfig = GameConfig.EquipType[equipType]
  return equipConfig and equipConfig.site[1]
end

local siteName_init, siteNameZhMap = false, {}

function RoleEquipBagData.GetSiteNameZh(site)
  if siteName_init == false then
    siteName_init = true
    siteNameZhMap[1] = ZhString.RoleEquipBagData_Shield
    local euqipConfig = GameConfig.EquipType
    for k, v in pairs(euqipConfig) do
      for m, n in pairs(v.site) do
        if n ~= 1 then
          siteNameZhMap[n] = v.name
        end
      end
    end
  end
  return siteNameZhMap[site] or ""
end

function RoleEquipBagData:GetBreakEquipSiteInfo()
  local curServerTime = math.floor(ServerTime.CurServerTime() / 1000)
  local items = self:GetItems()
  local result = {}
  for i = 1, #items do
    local item = items[i]
    local equipInfo = items[i].equipInfo
    if equipInfo.breakendtime and curServerTime < equipInfo.breakendtime then
      local siteInfo = {}
      siteInfo.index = item.index
      siteInfo.breakstarttime = equipInfo.breakstarttime
      siteInfo.breakendtime = equipInfo.breakendtime
      table.insert(result, siteInfo)
    end
  end
  return result
end

function RoleEquipBagData:GetMount()
  local item = self.siteMap[GameConfig.EquipType[12].site[1]]
  if item and (item:IsMount() or item:IsMountPet()) then
    return item
  end
  return nil
end

function RoleEquipBagData:GetWeapon()
  return self.siteMap[GameConfig.EquipType[1].site[1]]
end

function RoleEquipBagData:GetBarrow()
  return self.siteMap[GameConfig.EquipType[14].site[1]]
end

function RoleEquipBagData:GetNumByEquipFeature(feature)
  local count = 0
  for k, v in pairs(self.siteMap) do
    if v.equipInfo ~= nil and v.equipInfo:HasFeature(feature) then
      count = count + 1
    end
  end
  return count
end

function RoleEquipBagData:Reset()
  RoleEquipBagData.super.Reset(self)
  TableUtility.TableClear(self.siteMap)
  if self.staticIdMap then
    TableUtility.TableClear(self.staticIdMap)
  end
  if self.itemTypeMap then
    TableUtility.TableClear(self.itemTypeMap)
  end
end

function RoleEquipBagData:GetShield()
  return self.siteMap[GameConfig.EquipType[3].site[1]]
end
