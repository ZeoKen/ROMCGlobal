autoImport("ItemData")
AfricanPoringRewardData = class("AfricanPoringRewardData")

function AfricanPoringRewardData:ctor(staticData, serverData)
  self:SetStaticData(staticData)
  self:SetServerData(serverData)
end

function AfricanPoringRewardData:SetStaticData(data)
  if not data then
    return
  end
  self.id = data.id
  self.groupId = data.GroupId
  self.weight = data.Weight or 0
  self.pos = data.Pos or 0
  self.itemId = data.ItemID
  self.itemNum = data.ItemNum
  self.probability = 0
  self.ssr = data.Ssr
  if self.itemData then
    if self.itemId then
      self.itemData:ResetData("AfricanPoringRewardItem", self.itemId)
    else
      self.itemData = nil
    end
  end
end

function AfricanPoringRewardData:SetServerData(serverData)
  if not serverData or self.id ~= serverData.id then
    return
  end
  self.owned = serverData.get
  self.selected = serverData.select
end

function AfricanPoringRewardData:GetItemData()
  if self.itemId and self.itemData == nil then
    self.itemData = ItemData.new("AfricanPoringRewardItem", self.itemId)
    self.itemData:SetItemNum(self.itemNum)
  end
  return self.itemData
end

function AfricanPoringRewardData:GetItemConfig()
  return Table_Item[self.itemId]
end

function AfricanPoringRewardData:IsSsr()
  return self.ssr == 1
end

function AfricanPoringRewardData:IsOwned()
  return self.owned
end
