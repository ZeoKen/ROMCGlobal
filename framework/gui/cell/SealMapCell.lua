local BaseCell = autoImport("BaseCell")
SealMapCell = class("SealMapCell", BaseCell)

function SealMapCell:Init()
  self:InitCell()
  self:AddCellClickEvent()
end

function SealMapCell:InitCell()
  self.multiSymbol = self:FindComponent("SealSymbol", UIMultiSprite)
end

function SealMapCell:SetData(data)
  self.data = data
  if data.sealData then
    self.multiSymbol.gameObject:SetActive(true)
    if data.acceptSeal then
      self.multiSymbol.CurrentState = 1
    elseif data.newGenSeal then
      if not data.Unlock then
        self.multiSymbol.CurrentState = 5
      elseif data.enableQuickFinish then
        self.multiSymbol.CurrentState = 3
      else
        self.multiSymbol.CurrentState = 4
      end
    elseif data.sealData.Type == 2 then
      self.multiSymbol.CurrentState = 2
    else
      self.multiSymbol.CurrentState = 0
    end
  else
    self.multiSymbol.gameObject:SetActive(false)
  end
end
