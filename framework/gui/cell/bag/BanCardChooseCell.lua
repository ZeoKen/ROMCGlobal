autoImport("BagCardCell")
BanCardChooseCell = class("BanCardChooseCell", BagCardCell)

function BanCardChooseCell:Init()
  BanCardChooseCell.super.Init(self)
  self.banSymbol = self:FindGO("BanSymbol")
end

function BanCardChooseCell:SetData(data)
  if data == nil then
    self.gameObject:SetActive(false)
    return
  end
  self.gameObject:SetActive(true)
  BanCardChooseCell.super.SetData(self, data)
  self:SetBanSymbol()
end

function BanCardChooseCell:SetCardAlpha()
  if not self.data then
    self.widget.alpha = 0
  else
    self.widget.alpha = 1
  end
end

function BanCardChooseCell:SetBanSymbol()
  if not self.data then
    self.banSymbol:SetActive(false)
    self.cardSelect:SetActive(false)
  else
    local isBan = self.data.isBan or false
    self.banSymbol:SetActive(isBan)
    self.cardSelect:SetActive(isBan)
  end
end
