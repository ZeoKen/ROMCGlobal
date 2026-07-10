local BaseCell = autoImport("BaseCell")
PetComposeMaterialChooseCell = class("PetComposeMaterialChooseCell", BaseCell)
local COUNT_ENOUGH = Color(0.15294117647058825, 0.15294117647058825, 0.15294117647058825, 1)
local COUNT_SHORT = Color(0.9294117647058824, 0.047058823529411764, 0.047058823529411764, 1)

function PetComposeMaterialChooseCell:Init()
  self:FindObjs()
  self:AddCellClickEvent()
end

function PetComposeMaterialChooseCell:FindObjs()
  self.content = self:FindGO("Content")
  self.icon = self:FindComponent("icon", UISprite)
  self.itemName = self:FindComponent("itemName", UILabel)
  self.countLab = self:FindComponent("countLab", UILabel)
end

function PetComposeMaterialChooseCell:SetData(data)
  self.data = data
  local item = data and data.item
  local static = item and item.staticData
  if not static then
    self.content:SetActive(false)
    return
  end
  self.content:SetActive(true)
  self.itemName.text = static.NameZh or ""
  local succ = IconManager:SetItemIcon(static.Icon, self.icon)
  if not succ then
    IconManager:SetItemIcon("item_45001", self.icon)
  end
  local have = item.num or 0
  local need = data.needCount and 0 < data.needCount and data.needCount or 1
  self.countLab.text = string.format("%d/%d", have, need)
  self.countLab.color = have >= need and COUNT_ENOUGH or COUNT_SHORT
end
