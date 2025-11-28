autoImport("BaseItemCell")
RoleEquipItemCell = class("RoleEquipItemCell", BaseItemCell)
RoleEquipItemCell.FakeID = "Fake"

function RoleEquipItemCell:ctor(obj, index, isfashion)
  if index then
    self.index = index
  end
  RoleEquipItemCell.super.ctor(self, obj)
  if isfashion == nil then
    self.isfashion = false
  else
    self.isfashion = isfashion
  end
  if self.index then
    self.symbol = self:FindComponent("Symbol", UISprite)
    if index == 5 or index == 6 then
      self.symbol.spriteName = "bag_equip_6"
    else
      self.symbol.spriteName = "bag_equip_" .. self.index
    end
    self.symbol:MakePixelPerfect()
  end
  self.noEffect = self:FindGO("NoEffect")
  self.offForbid = self:FindGO("OffForbid")
  self.forbidColdDown = self:FindComponent("ForbidColdDown", UISprite)
  self.redMark = self:FindGO("RedMark")
  self.redMark.gameObject:SetActive(false)
  self:AddCellClickEvent()
  self:AddCellDoubleClickEvt()
end

function RoleEquipItemCell:SetData(data)
  RoleEquipItemCell.super.SetData(self, data)
  if data and data.staticData then
    self.noEffect:SetActive(false)
    self:SetIconGrey(data.id == RoleEquipItemCell.FakeID)
    self:SetMark(data.id == RoleEquipItemCell.FakeID)
    self:Hide(self.symbol)
  else
    self:Show(self.symbol)
  end
end

function RoleEquipItemCell:IsEffective()
  if self.data then
    local roleEquipBag = BagProxy.Instance:GetRoleEquipBag()
    local equip = roleEquipBag:GetEquipBySite(self.index)
    if equip then
      return equip.equipInfo.equipData.Type == self.data.equipInfo.equipData.Type
    end
  end
  return true
end

function RoleEquipItemCell:SetMark(b)
  self.redMark.gameObject:SetActive(b)
end
