EquipMakeData = class("EquipMakeData")

function EquipMakeData:ctor(composeId)
  self:Init()
  self:SetData(composeId)
end

function EquipMakeData:Init()
  self.isChoose = false
end

function EquipMakeData:SetData(composeId)
  self.composeId = composeId
  local table_compose = EquipMakeProxy.Instance:GetComposeTable()
  local composeData = table_compose[composeId]
  if composeData then
    local id = composeData.Product.id
    self.itemData = ItemData.new(id, id)
    self.itemData:SetItemNum(composeData.Product.num or 1)
    self.itemData.composeId = composeId
    self.composeStaticData = composeData
  end
  self:_SetSortId()
end

function EquipMakeData:_SetSortId()
  if not self:IsLock() then
    if self.itemData:CanEquip() then
      self.sortId = 1
    else
      self.sortId = 2
    end
  else
    self.sortId = 3
  end
end

function EquipMakeData:SetChoose(isChoose)
  self.isChoose = isChoose
end

function EquipMakeData:IsLock()
  local composeData = self.composeStaticData
  if composeData.MenuID and not FunctionUnLockFunc.Me():CheckCanOpen(composeData.MenuID) then
    return true
  end
  return false
end

function EquipMakeData:GetMenuSysId()
  local menuId = self.composeStaticData and self.composeStaticData.MenuID or nil
  if menuId and Table_Menu[menuId] then
    return menuData and menuData.sysMsg and menuData.sysMsg.id
  end
  return nil
end

function EquipMakeData:IsChoose()
  return self.isChoose
end
