local BaseCell = autoImport("BaseCell")
CreateRoleRewardCell = class("CreateRoleRewardCell", BaseCell)

function CreateRoleRewardCell:Init()
  self:FindObjs()
end

function CreateRoleRewardCell:FindObjs()
  self.icon = self:FindGO("Icon"):GetComponent(UISprite)
  self.count = self:FindGO("Num"):GetComponent(UILabel)
  self.chooseSymbol = self:FindGO("ChooseSymbol")
  self.finishSymbol = self:FindGO("FinishSymbol")
end

function CreateRoleRewardCell:SetData(data)
  self.data = data
  local itemID = data.id
  local staticData = Table_Item[itemID]
  if staticData then
    IconManager:SetItemIcon(staticData.Icon, self.icon)
  end
  self.count.text = data.num or ""
end
