SecretLandGemBuffTip = class("SecretLandGemBuffTip", BaseCell)

function SecretLandGemBuffTip:Init()
  SecretLandGemBuffTip.super.Init(self)
  self:FindObj()
end

function SecretLandGemBuffTip:FindObj()
  self.lab = self:FindComponent("Label", UILabel)
end

function SecretLandGemBuffTip:SetData(id)
  self.data = id
  local desc = Table_Buffer[id] and Table_Buffer[id].Dsc or ""
  self.lab.text = desc
end
