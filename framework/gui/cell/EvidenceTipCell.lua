local BaseCell = autoImport("BaseCell")
EvidenceTipCell = class("EvidenceTipCell", BaseCell)

function EvidenceTipCell:Init()
  EvidenceTipCell.super.Init(self)
  self:FindObjs()
end

function EvidenceTipCell:FindObjs()
  self.bg = self.gameObject:GetComponent(UISprite)
  self.label = self:FindGO("Label"):GetComponent(UILabel)
  self.noneLabel = self:FindGO("NoneLabel")
  self.effectContainer = self:FindGO("EffectContainer")
end

function EvidenceTipCell:SetData(data)
  self.data = data
  self.id = data
  local staticData = Table_EvidenceMessage[self.id]
  self.label.text = staticData.Description or "?"
  local height = self.label.printedSize.y + 28
  if height < 82 then
    height = 82
  end
  self.bg.height = height
  self.noneLabel:SetActive(false)
end

function EvidenceTipCell:Enlight()
  local effect = self:PlayUIEffect(EffectMap.UI.SevenRoyalFamilies_EvidenceBook_UI02, self.effectContainer, true)
  local scale = self.bg.height / 82
  effect:ResetLocalScaleXYZ(1, scale, 1)
end
