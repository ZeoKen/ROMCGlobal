local _ItemPB = SceneItem_pb
local _ShadowEquipSite = {
  [_ItemPB.EEQUIPPOS_SHIELD] = 1,
  [_ItemPB.EEQUIPPOS_ARMOUR] = 1,
  [_ItemPB.EEQUIPPOS_ROBE] = 1,
  [_ItemPB.EEQUIPPOS_SHOES] = 1,
  [_ItemPB.EEQUIPPOS_ACCESSORY1] = 1,
  [_ItemPB.EEQUIPPOS_ACCESSORY2] = 1
}
local _MirrorIndexMap = {
  [5] = 6,
  [6] = 5
}
local _GetEquipCount = function(data)
  local count = 0
  local _Table_Equip = Table_Equip
  for _, item in pairs(data) do
    if _Table_Equip[id] then
      if item.staticData and item.staticData.id == id then
        count = count + 1
      end
    elseif item.equipedCardInfo then
      for _, card in pairs(item.equipedCardInfo) do
        if card.id == id then
          count = count + 1
        end
      end
    end
  end
  return count
end
autoImport("RoleEquipBagData")
ShadowBagData = class("ShadowBagData", RoleEquipBagData)
ShadowBagData.InvalidAttr = {}

function ShadowBagData:ctor(type)
  ShadowBagData.super.super.ctor(self, nil, nil, type)
  self.siteMap = {}
end

function ShadowBagData:SetSiteMapItem(site, item)
  if item and _ShadowEquipSite[site] then
    local mirrorIndex = _MirrorIndexMap[index]
    if mirrorIndex then
      local mirrorItem = self.siteMap[mirrorIndex]
      if mirrorItem and mirrorItem.id == item.id then
        self.siteMap[mirrorIndex] = nil
      end
    end
  end
  self.siteMap[site] = item
end

function ShadowBagData:GetEquipBySite(site)
  if type(site) ~= "number" then
    return
  end
  local item = self.siteMap[site]
  return item
end

function ShadowBagData:Reset()
  ShadowBagData.super.Reset(self)
  TableUtility.TableClear(self.siteMap)
end

function ShadowBagData:GetMount()
  return nil
end

function ShadowBagData:GetBarrow()
  return nil
end
