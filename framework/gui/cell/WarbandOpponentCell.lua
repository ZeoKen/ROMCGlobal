local BaseCell = autoImport("BaseCell")
WarbandOpponentCell = class("WarbandOpponentCell", BaseCell)

function WarbandOpponentCell:Init()
  self:FindObj()
  self:AddCellClickEvent()
end

function WarbandOpponentCell:FindObj()
  self.bg = self.gameObject:GetComponent(UISprite)
  self.name = self:FindComponent("Name", UILabel)
  self.myWarbandFlag = self:FindGO("MyWarbandFlag")
  self.winner = self:FindGO("Winner")
  self.root = self:FindGO("Root")
  self.promotion = self:FindGO("Promotion")
end

function WarbandOpponentCell:SetData(data)
  self.data = data
  if data then
    self.root:SetActive(true)
    self.name.text = data:GetName()
    self.myWarbandFlag:SetActive(data:IsMyWarband())
    self.winner:SetActive(data:IsChampionship())
  else
    self.root:SetActive(false)
  end
end

function WarbandOpponentCell:SetPromotionSymbol(bool)
  if bool == true and not self.winner.activeSelf then
    self.promotion:SetActive(true)
  else
    self.promotion:SetActive(false)
  end
end

function WarbandOpponentCell:OnDestroy()
end
