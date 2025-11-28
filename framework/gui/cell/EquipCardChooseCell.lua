local BaseCell = autoImport("BaseCell")
EquipCardChooseCell = class("EquipCardChooseCell", BaseCell)
EquipCardChooseCell.Status = {
  Empty = 0,
  Normal = 1,
  Lock = 2
}

function EquipCardChooseCell:Init()
  self.itemName = self:FindGO("ItemName"):GetComponent(UILabel)
  self.chooseBtn = self:FindGO("ChooseBtn")
  self.removeBtn = self:FindGO("RemoveBtn")
  self.descLabel = self:FindGO("Label"):GetComponent(UILabel)
  self:SetEvent(self.chooseBtn, function()
    self:PassEvent(UICellEvent.OnMidBtnClicked, self)
  end)
  self:SetEvent(self.removeBtn, function()
    self:PassEvent(UICellEvent.OnRightBtnClicked, self)
  end)
  local cardContainer = self:FindGO("CardContainer")
  local obj = self:LoadPreferb("cell/ItemCardCell", cardContainer)
  obj.transform.localPosition = LuaGeometry.GetTempVector3()
  self.cardCell = ItemCardCell.new(obj)
end

function EquipCardChooseCell:SetData(data)
  self.data = data
  if data and data.cardInfo then
    local cardInfo = data.cardInfo
    self.itemName.text = data:GetName()
    self:SetUse(data.used == true)
    local descStr = ""
    local bufferIds = data.cardInfo.BuffEffect.buff
    if bufferIds then
      for i = 1, #bufferIds do
        local str = ItemUtil.getBufferDescById(bufferIds[i])
        if 1 < i then
          descStr = descStr .. "; "
        end
        descStr = descStr .. str
      end
    end
    self.descLabel.text = descStr
    UIUtil.WrapLabel(self.descLabel)
    self.cardCell:SetData(data)
  end
end

function EquipCardChooseCell:SetUse(b)
  self.chooseBtn:SetActive(not b)
  self.removeBtn:SetActive(b)
end
