local BaseCell = autoImport("BaseCell")
PlayerTipHomeCell = class("PlayerTipHomeCell", BaseCell)

function PlayerTipHomeCell:Init()
  self.bg = self.gameObject:GetComponent(UISprite)
  self.label = self:FindComponent("Label", UILabel)
  self.passEvent = true
  self:SetEvent(self.gameObject, function()
    if self.passEvent then
      self:PassEvent(MouseEvent.MouseClick, self)
    end
  end)
end

function PlayerTipHomeCell:SetData(data)
  self.data = data
  if not data then
    self.gameObject:SetActive(false)
    return
  end
  self.label.text = data.name or ""
  self.gameObject:SetActive(true)
end
