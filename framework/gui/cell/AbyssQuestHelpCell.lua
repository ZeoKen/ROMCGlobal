AbyssQuestHelpCell = class("AbyssQuestHelpCell", BaseCell)

function AbyssQuestHelpCell:Init()
  self.icon = self.gameObject:GetComponent(UIMultiSprite)
end

function AbyssQuestHelpCell:SetData(data)
  if data then
    self.icon.CurrentState = data
  end
end
