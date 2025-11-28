autoImport("EquipRecommendNewCell")
ViceEquipRecommendNewCell = class("ViceEquipRecommendNewCell", EquipRecommendNewCell)

function ViceEquipRecommendNewCell:FindObjs()
  ViceEquipRecommendNewCell.super.FindObjs(self)
  self.cardEmpty = self:FindGO("empty")
  self.cardEmpty:SetActive(true)
end

function ViceEquipRecommendNewCell:SetData(data)
  self.data = data
  if data then
    local pos = data.pos
    local name = GameConfig.EquipPosName[pos]
    name = string.gsub(name, "(%d+)", "")
    self.nameLabel.text = name
    local index = pos == 5 and 6 or pos
    local iconName = "bag_equip_" .. index
    IconManager:SetUIIcon(iconName, self.icon)
    local itemDatas = {}
    local equips = data:GetEquips()
    for i = 1, 3 do
      local equip = equips[i] or BagItemEmptyType.Empty
      itemDatas[i] = equip
    end
    self.equipListCtrl:ResetDatas(itemDatas)
  end
end
