local BaseCell = autoImport("BaseCell")
BFSecretContentCell = class("BFSecretContentCell", BaseCell)

function BFSecretContentCell:Init()
  self:FindObjs()
end

function BFSecretContentCell:FindObjs()
  self.num = self:FindComponent("Num", UILabel)
  self.content = self:FindComponent("Content", UILabel)
end

function BFSecretContentCell:SetData(data)
  self.num.text = data.id
  self.content.text = data.content
end
