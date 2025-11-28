autoImport("BaseCombineCell")
TechTreePageCombineCell = class("TechTreePageCombineCell", BaseCombineCell)

function TechTreePageCombineCell:Init()
  self.header = self:FindGO("Header")
  self.headerLabel = self:FindComponent("Label", UILabel, self.header)
  self.arrowSp = self:FindComponent("Arrow", UISprite, self.header)
  self.grid = self:FindComponent("Grid", UIGrid)
  self:AddClickEvent(self.arrowSp.gameObject, function()
    self:PassEvent(MouseEvent.MouseClick, self.headerLabel.text)
  end)
end

function TechTreePageCombineCell:SetData(data)
  if not data then
    self.grid.gameObject:SetActive(false)
    self.header:SetActive(false)
  elseif #data == 0 then
    self.grid.gameObject:SetActive(false)
    self.headerLabel.text = data.header
    self.arrowSp.flip = data.hide and 2 or 0
    self.header:SetActive(true)
  else
    self.header:SetActive(false)
    self.grid.gameObject:SetActive(true)
    TechTreePageCombineCell.super.SetData(self, data)
    self.grid.repositionNow = true
  end
end

function TechTreePageCombineCell:AddEventListener(eventType, handler, handlerOwner)
  TechTreePageCombineCell.super.AddEventListener(self, eventType, handler, handlerOwner)
  TechTreePageCombineCell.super.super.AddEventListener(self, eventType, handler, handlerOwner)
end
