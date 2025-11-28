local BaseCell = autoImport("BaseCell")
GiftItemCell = class("GiftItemCell", BaseCell)

function GiftItemCell:Init()
  self.sprite = self:FindGO("Icon_Sprite"):GetComponent(UISprite)
  self.label = self:FindGO("NumLabel"):GetComponent(UILabel)
  self.chooseSymbol = self:FindGO("ChooseSymbol")
  self:AddCellClickEvent()
  local longPress = self.gameObject:GetComponent(UILongPress)
  if longPress then
    function longPress.pressEvent(obj, state)
      if self.dType == "hairColor" then
        return
      end
      local data = {
        itemdata = ItemData.new("GiftItem", self.data.itemid),
        funcConfig = {},
        noSelfClose = false,
        hideGetPath = false
      }
      TipManager.Instance:ShowItemFloatTip(data, self.sprite, NGUIUtil.AnchorSide.TopRight, {200, 100})
    end
  end
end

function GiftItemCell:SetData(data)
  self.data = data
  if self.data and self.sprite then
    if IconManager:SetItemIcon(self.data.icon, self.sprite) then
      self.sprite:MakePixelPerfect()
    end
    self.label.text = self.data.count
  end
end

function GiftItemCell:SetChoose(isSelect)
  self.chooseSymbol:SetActive(isSelect)
end
