autoImport("RoleEquipBagData")
FashionEquipBagData = class("FashionEquipBagData", RoleEquipBagData)

function FashionEquipBagData:ctor(type)
  FashionEquipBagData.super.super.ctor(self, nil, nil, type)
  self.siteMap = {}
end

function FashionEquipBagData:SetSiteMapItem(index, item)
  self.siteMap[index] = item
end

local staticDataFilter = function(item)
  if item and item.staticData then
    return item
  end
end

function FashionEquipBagData:StaticDataFilterForOverride(methodName, ...)
  if not FashionEquipBagData.super[methodName] then
    return
  end
  return staticDataFilter(FashionEquipBagData.super[methodName](self, ...))
end

function FashionEquipBagData:GetEquipBySite(site)
  return self:StaticDataFilterForOverride("GetEquipBySite", site)
end

function FashionEquipBagData:GetWeapon()
  return self:StaticDataFilterForOverride("GetWeapon")
end

function FashionEquipBagData:GetItemByGuid(guid)
  return self:StaticDataFilterForOverride("GetItemByGuid", guid)
end

function FashionEquipBagData:GetItems(tabType)
  local items = FashionEquipBagData.super.GetItems(self, tabType)
  for i = #items, 1, -1 do
    if not items[i].staticData then
      table.remove(items, i)
    end
  end
  return items
end

function FashionEquipBagData:GetShield()
  return self:StaticDataFilterForOverride("GetShield")
end
