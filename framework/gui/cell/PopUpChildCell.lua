local BaseCell = autoImport("BaseCell")
PopUpChildCell = class("PopUpChildCell", BaseCell)

function PopUpChildCell:Init()
  self.info = self:FindGO("info"):GetComponent(UIRichLabel)
  self.infoSL = SpriteLabel.new(self.info, nil, 36, 36, false)
  self:AddCellClickEvent()
  self.choose = false
end

function PopUpChildCell:SetData(data)
  self.data = data
  self.infoSL:SetText(data.Name, true)
  self.infoSL:SetLabelColor(self.choose and PopupCombineCell.ChooseColorConfig.ChooseColor or PopupCombineCell.ChooseColorConfig.NormalColor)
end

function PopUpChildCell:IsChoose()
  return self.choose
end

function PopUpChildCell:SetChoose(choose)
  self.choose = choose
  self.infoSL:SetLabelColor(self.choose and PopupCombineCell.ChooseColorConfig.ChooseColor or PopupCombineCell.ChooseColorConfig.NormalColor)
end
