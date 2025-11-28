autoImport("EquipComposeCellItemData")
EquipComposeItemData = class("EquipComposeItemData")
local PACKAGECHECK = GameConfig.PackageMaterialCheck.equipcompose
local _PushArray = TableUtility.ArrayPushBack
local typeConfig = GameConfig.EquipComposeType

function EquipComposeItemData:ctor(cfg_data)
  self:SetData(cfg_data)
end

function EquipComposeItemData:SetData(cfg_data)
  if not Table_EquipCompose then
    redlog("策划未生成Table_EquipCompose")
    return
  end
  self.composeID = cfg_data.id
  self.itemStaticData = Table_Item[cfg_data.id]
  if nil == self.itemStaticData then
    helplog("cfg_data.id: ", cfg_data.id)
  end
  self.staticData = cfg_data
  self.material = {}
  local _bagproxy = BagProxy.Instance
  for i = 1, #self.staticData.MaterialCost do
    local cellMatCost = self.staticData.MaterialCost[i]
    local data = ItemData.new("cost", cellMatCost.id)
    data:SetItemNum(cellMatCost.num)
    _PushArray(self.material, data)
  end
  self.cost = self.staticData.Cost
  self:ResetMatData()
  self.itemdata = ItemData.new("composeItem", self.composeID)
  self.equipVID = Table_Equip[self.composeID] and Table_Equip[self.composeID].VID
  if self.equipVID then
    self.VIDType = math.floor(self.equipVID / 10000)
    self.VID = self.equipVID % 1000
  else
    redlog("Equip表VID配置错误", self.composeID)
    self.composeID = nil
    return
  end
  self:ResetChooseMat()
end

function EquipComposeItemData:ResetMatData()
  self.MatArray = {}
  for i = 2, #self.staticData.Material do
    local matData = EquipComposeCellItemData.new("mat", self.staticData.Material[i].id)
    matData:SetEquipLv(self.staticData.Material[i].lv)
    self.MatArray[#self.MatArray + 1] = matData
  end
  self.mainMat = EquipComposeCellItemData.new("mainMat", self.staticData.Material[1].id)
  self.mainMat:SetEquipLv(self.staticData.Material[1].lv)
end

function EquipComposeItemData:GetMatLimitedLv(id)
  for i = 1, #self.MatArray do
    if self.MatArray[i].staticData.id == id then
      return self.MatArray[i].equipLvLimited
    end
  end
  if self.mainMat.staticData.id == id then
    return self.mainMat.equipLvLimited
  end
end

function EquipComposeItemData:GetItemType()
  return Table_Item[self.staticData.id].Type
end

function EquipComposeItemData:SetChooseMat(index, itemData)
  if not index or not self.chooseMat[index] then
    return
  end
  self.chooseMat[index] = itemData.id
  local _subMatIndex = self:GetMatIndex(itemData.staticData.id)
  if self.MatArray[_subMatIndex] then
    local matData = EquipComposeCellItemData.new("mat", itemData.staticData.id)
    matData:Copy(itemData)
    matData:SetEquipLv(self.MatArray[_subMatIndex].equipLvLimited)
    self.MatArray[_subMatIndex] = matData
  else
    self.mainMat = EquipComposeCellItemData.new("mainMat", itemData.staticData.id)
    self.mainMat:Copy(itemData)
    self.mainMat:SetEquipLv(self.staticData.Material[1].lv)
  end
end

function EquipComposeItemData:GetChooseMat(index)
  if not index then
    return nil
  end
  return self.chooseMat[index]
end

function EquipComposeItemData:IsMatLimited()
  local mat, mainMat = self:GetChooseMatArray()
  local lackCostMat = self:GetLackCostMat()
  if not (mat and not (#mat <= 0) and mainMat) or 0 < #lackCostMat then
    return true
  end
  return false
end

function EquipComposeItemData:GetChooseMatArray()
  local chooseMatArray = {}
  for k, v in pairs(self.chooseMat) do
    if 0 == v then
      return nil
    else
      chooseMatArray[#chooseMatArray + 1] = v
    end
  end
  return chooseMatArray, self.chooseMat[self.staticData.Material[1].id]
end

function EquipComposeItemData:SetMainChooseMat(main_guid)
  if main_guid ~= self.chooseMainMat then
    self.chooseMainMat = main_guid
  end
end

function EquipComposeItemData:GetMainChooseMat()
  return self.chooseMainMat
end

function EquipComposeItemData:CheckProfessionValid()
  local pro = Game.Myself.data.userdata:Get(UDEnum.PROFESSION)
  local array = Table_Equip[self.staticData.id] and Table_Equip[self.staticData.id].CanEquip
  if array then
    for i = 1, #array do
      if 0 == array[i] or array[i] == pro then
        return true
      end
    end
  end
end

function EquipComposeItemData:ResetChooseMat()
  self.chooseMainMat = nil
  self.chooseMat = {}
  for i = 1, #self.staticData.Material do
    self.chooseMat[self.staticData.Material[i].id] = 0
  end
  self:ResetMatData()
end

function EquipComposeItemData:IsCostLimited()
  return MyselfProxy.Instance:GetROB() < self.cost
end

function EquipComposeItemData:GetLackCostMat()
  local lackItems = {}
  for i = 1, #self.material do
    local costStaticID = self.material[i].staticData.id
    local costNum = self.material[i].num
    local ownNum = BagProxy.Instance:GetItemNumByStaticID(costStaticID, PACKAGECHECK)
    if costNum > ownNum then
      local lackItem = {
        id = costStaticID,
        count = costNum - ownNum
      }
      TableUtility.ArrayPushBack(lackItems, lackItem)
    end
  end
  return lackItems
end

function EquipComposeItemData:GetMatIndex(staticId)
  for i = 1, #self.MatArray do
    if self.MatArray[i] and self.MatArray[i].staticData.id == staticId then
      return i
    end
  end
end

EquipComposeData = class("EquipComposeData")

function EquipComposeData:ctor(tab, equips)
  self.tab = tab
  if tab then
    self.tabName = typeConfig[tab] and typeConfig[tab].name
  end
  self.isTab = equips == nil
  self.equipList = equips or {}
end
