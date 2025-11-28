local BaseCell = autoImport("BaseCell")
RewardSelectCell = class("RewardSelectCell", BaseCell)

function RewardSelectCell:Init()
  self.itemName = self:FindGO("itemName"):GetComponent(UILabel)
  self.itemType = self:FindGO("itemType"):GetComponent(UILabel)
  self.itemicon = self:FindGO("itemicon"):GetComponent(UISprite)
  self:AddListener()
end

function RewardSelectCell:AddListener()
  self:AddCellClickEvent()
  local GetBtn = self:FindGO("GetBtn")
  self:AddClickEvent(GetBtn, function()
    local itemdata = ItemData.new(self.guid, self.itemid)
    ServiceItemProxy.Instance:CallItemUse(itemdata, nil, 1, self.itemid)
    self:sendNotification(RewardSelectViewEvent.CloseUI)
  end)
  self:AddClickEvent(self.itemicon.gameObject, function()
    self:ClickItem()
  end)
end

function RewardSelectCell:SetData(data)
  if data then
    self.gameObject:SetActive(true)
    self.data = data
    self.guid = data.itemguid
    self.itemid = data.itemid
    local itemdata = Table_Item[self.itemid]
    local itemType = itemdata and itemdata.Type
    if itemType then
      local itemtypeName = Table_ItemType[itemType] and Table_ItemType[itemType].Name or ""
      self.itemType.text = string.format(ZhString.RrewardSelect_ItemType, itemtypeName)
      self.itemName.text = itemdata.NameZh or ""
      IconManager:SetItemIcon(itemdata.Icon or "", self.itemicon)
    end
  else
    self.gameObject:SetActive(false)
  end
end

local tipData = {}
local tipOffset = {0, -160}

function RewardSelectCell:ClickItem()
  local itemID = self.itemid
  if not itemID or not self.itemicon then
    redlog("itemID", itemID)
    self:ShowItemTip()
    return
  end
  tipData.itemdata = ItemData.new("RewardSelectView", itemID)
  local equipInfo = tipData.itemdata.equipInfo
  if equipInfo and equipInfo:IsNextGen() then
    equipInfo.isRandomPreview = true
  end
  self:ShowItemTip(tipData, stick, NGUIUtil.AnchorSide.Left or NGUIUtil.AnchorSide.Right, tipOffset)
end
