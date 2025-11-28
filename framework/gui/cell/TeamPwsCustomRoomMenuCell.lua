local BaseCell = autoImport("BaseCell")
TeamPwsCustomRoomMenuCell = class("TeamPwsCustomRoomMenuCell", BaseCell)

function TeamPwsCustomRoomMenuCell:Init()
  self.menuBtnGO = self:FindGO("FatherGoal")
  self.menuSprite = self.menuBtnGO:GetComponent(UIMultiSprite)
  self.menuLabel = self:FindComponent("Label", UILabel, self.menuBtnGO)
  self:AddClickEvent(self.menuBtnGO, function()
    if self.data then
      self:PassEvent(UICellEvent.OnCellClicked, self)
    end
  end)
end

function TeamPwsCustomRoomMenuCell:SetData(data)
  self.data = data
  self.menuLabel.text = data.name
end

function TeamPwsCustomRoomMenuCell:SetSelected(b)
  self.selected = b
  if b then
    self.menuLabel.effectColor = ColorUtil.ButtonLabelOrange
    self.menuSprite.CurrentState = 1
  else
    self.menuLabel.effectColor = ColorUtil.ButtonLabelBlue
    self.menuSprite.CurrentState = 0
  end
end
