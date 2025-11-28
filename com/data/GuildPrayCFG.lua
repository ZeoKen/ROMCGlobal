GuildPrayCFG = class("GuildPrayCFG")

function GuildPrayCFG:ctor(data)
  self.id = serviceData.prayid
  self.staticData = Table_Guild_Faith[self.id]
  self.lv = serviceData.praylv
  self.type = serviceData.type
  local serviceAttr = serviceData.attrs
  if serviceAttr and 0 < #serviceAttr then
    local attrId = serviceAttr[1].type
    self.attrStaticData = Table_RoleData[attrId]
    self.attrValue = serviceAttr[1].value
  else
    self.attrValue = 0
  end
  local itemInfo = serviceData.costs
  if itemInfo and 0 < #itemInfo then
    local item = ItemData.new(itemInfo[1].guid, itemInfo[1].id)
    item.num = itemInfo[1].count
    self.itemCost = item
  end
end
