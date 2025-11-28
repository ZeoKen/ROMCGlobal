MiniMapWorldQuestButton = class("MiniMapWorldQuestButton", BaseCell)

function MiniMapWorldQuestButton:Init()
  self.sprIcon = self.gameObject:GetComponent(UISprite)
  self:AddCellClickEvent()
end

function MiniMapWorldQuestButton:SetData(data)
  self.questId = data
end
