TransferProfListCell = class("TransferProfListCell", CoreView)

function TransferProfListCell:ctor(obj)
  TransferProfListCell.super.ctor(self, obj)
  self:Init()
end

function TransferProfListCell:Init()
  self.checkmark = self:FindGO("Checkmark")
  self.sp = self:FindComponent("Sprite", UISprite)
  self.newSp = self:FindComponent("NewSprite", GradientUISprite)
  self.effectContainer = self:FindGO("EffectContainer")
  self:AddClickEvent(self.gameObject, function()
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
end

function TransferProfListCell:SetData(data)
  self.data = data
  self.gameObject:SetActive(data ~= nil)
  if not data then
    return
  end
  IconManager:SetProfessionIcon(data.icon, self.sp)
  IconManager:SetProfessionIcon(data.icon, self.newSp)
  self.effectContainer:SetActive(data.recommended == true)
  if data.recommended and not self.effect then
    self.effect = self:PlayUIEffect(EffectMap.UI.TransferProf_RecommendedProf, self.effectContainer)
  end
  self:UpdateChoose()
end

function TransferProfListCell:SetChoose(icon)
  self.selectIcon = icon
  self:UpdateChoose()
end

function TransferProfListCell:UpdateChoose()
  self.checkmark:SetActive(self.data ~= nil and self.selectIcon == self.data.icon)
end
