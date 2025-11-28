autoImport("ItemData")
EquipComposeCellItemData = class("EquipComposeCellItemData", ItemData)

function EquipComposeCellItemData:ctor(id, staticId)
  EquipComposeCellItemData.super.ctor(self, id, staticId)
end

function EquipComposeCellItemData:SetEquipLv(v)
  self.equipLvLimited = v
end

function EquipComposeCellItemData:IsChoosed()
  local curData = EquipComposeProxy.Instance:GetCurData()
  return 0 ~= curData:GetChooseMat(self.staticData.id)
end
