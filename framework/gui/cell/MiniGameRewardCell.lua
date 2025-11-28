local BaseCell = autoImport("BaseCell")
MiniGameRewardCell = class("MiniGameRewardCell", BaseCell)

function MiniGameRewardCell:Init()
  self.icon = self:FindGO("Icon_Sprite"):GetComponent(UISprite)
  self.num = self:FindGO("numLabel"):GetComponent(UILabel)
  self:AddCellClickEvent()
end

function MiniGameRewardCell:SetData(data)
  if not data or not data.itemid then
    return
  end
  self.data = data
  self.itemid = data.itemid
  self.num.text = data.num
  local icon = Table_Item[self.itemid] and Table_Item[self.itemid].Icon
  IconManager:SetItemIcon(icon, self.icon)
end
