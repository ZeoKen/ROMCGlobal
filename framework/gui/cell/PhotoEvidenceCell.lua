local BaseCell = autoImport("BaseCell")
PhotoEvidenceCell = class("PhotoEvidenceCell", BaseCell)

function PhotoEvidenceCell:Init()
  PhotoEvidenceCell.super.Init(self)
  self:FindObjs()
end

function PhotoEvidenceCell:FindObjs()
  self.label = self:FindGO("Label"):GetComponent(UILabel)
  self.noneLabel = self:FindGO("NoneLabel")
  self.bg = self:FindGO("Bg"):GetComponent(UISprite)
  self.tweenColor = self.label.gameObject:GetComponent(TweenColor)
end

function PhotoEvidenceCell:SetData(data)
  self.data = data
  self.label.text = data or "?"
  self.noneLabel:SetActive(false)
  self.tweenColor:ResetToBeginning()
  self.tweenColor:PlayForward()
end
