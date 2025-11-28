autoImport("BaseCell")
RaidItemCell = class("RaidItemCell", BaseCell)

function RaidItemCell:Init()
  self.itemnum = self:FindComponent("itemnum", UILabel)
  self.itemicon = self:FindComponent("itemicon", UISprite)
  self:AddCellClickEvent()
  local longPress = self.gameObject:GetComponent(UILongPress)
  if longPress then
    function longPress.pressEvent(obj, state)
      local data = {
        itemdata = self.data,
        
        funcConfig = {},
        hideGetPath = true
      }
      TipManager.Instance:ShowItemFloatTip(data, self.itemicon, NGUIUtil.AnchorSide.Right, {250, 0})
    end
  else
    redlog("no longpress")
  end
end

function RaidItemCell:SetData(data)
  if data then
    self.data = data
    self.gameObject:SetActive(true)
    self.itemData = self.data.staticData
    IconManager:SetItemIcon(self.itemData.Icon, self.itemicon)
    self.itemnum.text = data.num
  else
    self.gameObject:SetActive(false)
  end
end
