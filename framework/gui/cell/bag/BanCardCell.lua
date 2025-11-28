autoImport("BagCardCell")
BanCardCell = class("BanCardCell", BagCardCell)

function BanCardCell:Init()
  BanCardCell.super.Init(self)
  self.plusSymbol = self:FindGO("PlusSymbol")
  self.banSymbol = self:FindGO("BanSymbol")
end

function BanCardCell:SetData(data)
  BanCardCell.super.SetData(self, data)
  self:SetPlusSymbol()
  self:SetBanSymbol()
end

function BanCardCell:SetPlusSymbol()
  if not self.data then
    self.plusSymbol:SetActive(true)
  else
    self.plusSymbol:SetActive(false)
  end
end

function BanCardCell:SetCardAlpha()
  self.widget.alpha = 1
end

function BanCardCell:SetBanSymbol()
  if not self.data then
    self.banSymbol:SetActive(false)
  else
    local isBan = self.data.isBan or false
    self.banSymbol:SetActive(isBan)
  end
end
