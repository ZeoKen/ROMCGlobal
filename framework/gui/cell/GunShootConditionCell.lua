local BaseCell = autoImport("BaseCell")
GunShootConditionCell = class("GunShootConditionCell", BaseCell)

function GunShootConditionCell:Init()
  self:FindObjs()
end

function GunShootConditionCell:FindObjs()
  self.headIcon = self:FindComponent("SimpleHeadIcon", UISprite)
  self.number = self:FindComponent("cond", UILabel)
  self.result = self:FindComponent("result", UIMultiSprite)
end

function GunShootConditionCell:SetData(data)
  self.data = data
  if data then
    local setSuc = IconManager:SetFaceIcon(Table_Monster[data.mid].Icon, self.headIcon)
    if not setSuc then
      IconManager:SetFaceIcon(Table_Monster[10001].Icon, self.headIcon)
    end
    local checkOK = data.shootOn >= data.count
    self.number.text = (checkOK and data.count or data.shootOn) .. "/" .. data.count
    self.result.gameObject:SetActive(checkOK)
  end
end
