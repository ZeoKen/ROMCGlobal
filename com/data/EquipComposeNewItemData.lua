autoImport("EquipComposeCellItemData")
EquipComposeNewItemData = class("EquipComposeNewItemData")
local PACKAGECHECK = GameConfig.PackageMaterialCheck.equipcompose
local _PushArray = TableUtility.ArrayPushBack
local typeConfig = GameConfig.EquipComposeType

function EquipComposeNewItemData:ctor(cfg_data)
  self:SetData(cfg_data)
end

function EquipComposeNewItemData:SetData(cfg_data)
  if not Table_EquipCompose then
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
  local mainMaterial = self.staticData.Material
  self.mainMatID = mainMaterial[1].id
  self.mainMatLv = mainMaterial[1].lv
  for i = 2, #mainMaterial do
    local single = mainMaterial[i]
    local lv = single.lv
    if lv ~= 0 then
      redlog("有副装备的配置需求等级不为0  请策划检查", self.composeID, single.id)
    end
    if not self.material[single.id] then
      self.material[single.id] = 1
    end
  end
  local materialCost = self.staticData.MaterialCost
  if materialCost and 0 < #materialCost then
    for i = 1, #materialCost do
      local single = materialCost[i]
      if not self.material[single.id] then
        self.material[single.id] = single.num
      else
        self.material[single.id] = self.material[single.id] + single.num
      end
    end
  end
  self.cost = self.staticData.Cost
  self.itemdata = ItemData.new("composeItem", self.composeID)
  self.equipVID = Table_Equip[self.composeID] and Table_Equip[self.composeID].VID
  self.VIDType = math.floor(self.equipVID / 10000)
  self.VID = self.equipVID % 1000
  self:ResetChooseMat()
end

function EquipComposeNewItemData:GetMatLimitedLv(id)
  for i = 1, #self.MatArray do
    if self.MatArray[i].staticData.id == id then
      return self.MatArray[i].equipLvLimited
    end
  end
  if self.mainMat.staticData.id == id then
    return self.mainMat.equipLvLimited
  end
end

function EquipComposeNewItemData:GetItemType()
  return Table_Item[self.staticData.id].Type
end

function EquipComposeNewItemData:SetChooseMat(equipID, itemData)
  if not equipID or not self.material[equipID] then
    redlog("没有装备StaticID或者不是目标装备", equipID)
    return
  end
  local curEquipList = self.chooseMat[equipID] or {}
  curEquipList[itemData.id] = itemData.num
  self.chooseMat[equipID] = curEquipList
end

function EquipComposeNewItemData:GetChooseMat(equipID)
  if not self.chooseMat[equipID] then
    return
  end
  return self.chooseMat[equipID]
end

function EquipComposeNewItemData:GetChooseMatCount(equipID)
  local equipList = self:GetChooseMat(equipID)
  if not equipList then
    return 0
  end
  local count = 0
  for k, v in pairs(equipList) do
    count = count + v
  end
  return count
end

function EquipComposeNewItemData:CheckChooseMatCount(equipID)
  local targetCount = self.material[equipID]
  if not targetCount then
    redlog("指定材料非当前灌注需求", equipID)
    return false
  end
  local chosenMat = self:GetChooseMat(equipID)
  local curCount = 0
  for k, v in pairs(chosenMat) do
    curCount = curCount + v
  end
  if curCount == targetCount then
    return true
  elseif targetCount <= curCount then
    redlog("需求数量超出  需要拦截")
    return true
  else
    return false
  end
end

function EquipComposeNewItemData:GetMatCountInfo(equipID)
  local targetCount = self.material[equipID]
  if not targetCount then
    redlog("指定材料非当前灌注需求", equipID)
    return
  end
  local chosenMat = self:GetChooseMat(equipID)
  local curCount = 0
  for k, v in pairs(chosenMat) do
    curCount = curCount + v
  end
  return curCount, targetCount
end

function EquipComposeNewItemData:IsMatLimited()
  for id, num in pairs(self.material) do
    if ItemData.CheckIsEquip(id) then
      local chosenCount = self:GetChooseMatCount(id)
      if num > chosenCount then
        redlog("装备数量不足", id)
        return true
      end
    end
  end
  return false
end

function EquipComposeNewItemData:GetChooseMatArray()
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

function EquipComposeNewItemData:SetMainChooseMat(main_guid)
  if main_guid ~= self.chooseMainMat then
    self.chooseMainMat = main_guid
  end
end

function EquipComposeNewItemData:GetMainChooseMat()
  return self.chooseMainMat
end

function EquipComposeNewItemData:CheckProfessionValid()
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

function EquipComposeNewItemData:ResetChooseMat()
  self.chooseMainMat = nil
  self.chooseMat = {}
end

function EquipComposeNewItemData:IsCostLimited()
  return MyselfProxy.Instance:GetROB() < self.cost
end
