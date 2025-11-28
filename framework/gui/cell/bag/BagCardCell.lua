local BaseCell = autoImport("BaseCell")
BagCardCell = class("BagCardCell", BaseCell)
autoImport("ItemCardCell")

function BagCardCell:Init()
  self.emptyCard = self:FindGO("EmptyCard")
  self.widget = self.gameObject:GetComponent(UIWidget)
  self.numLabel = self:FindComponent("CardNum", UILabel)
  self.cardSelect = self:FindGO("CardSelect")
  self.source = self:FindComponent("Source", UISprite)
  self.longPress = self.gameObject:GetComponent(UILongPress)
  if self.longPress then
    function self.longPress.pressEvent(obj, isPress)
      if isPress then
        self:PassEvent(MouseEvent.LongPress, self)
      end
    end
  end
  self:AddCellClickEvent()
end

function BagCardCell:GetItemCardCell()
  if self.cardCell == nil then
    local cardGO = self:LoadPreferb("cell/ItemCardCell", self.gameObject)
    self.cardCell = ItemCardCell.new(cardGO)
  end
  return self.cardCell
end

function BagCardCell:SetData(data)
  self.data = data
  self.emptyCard:SetActive(data == nil or data == BagItemEmptyType.Empty)
  self:GetItemCardCell():SetData(data)
  self:SetCardNum()
  self:SetCardAlpha()
  self:SetCardSource()
end

function BagCardCell:SetCardAlpha()
  if not self.data or self.data == BagItemEmptyType.Empty then
    return
  end
  local num = math.max(self.data.num, 0)
  if num == 0 then
    self.widget.alpha = 0.4
  else
    self.widget.alpha = 1
  end
end

function BagCardCell:SetCardSelectState(state)
  self.cardSelect:SetActive(state)
end

function BagCardCell:SetCardNum()
  if not self.data or self.data == BagItemEmptyType.Empty then
    self.numLabel.text = ""
    return
  end
  local num = self.data.num > 1 and self.data.num or ""
  self.numLabel.text = num
end

function BagCardCell:SetCardSource()
  if not self.data or self.data == BagItemEmptyType.Empty then
    self.source.gameObject:SetActive(false)
    return
  end
  if self.data.bagtype == BagProxy.BagType.MainBag then
    self.source.gameObject:SetActive(false)
  elseif self.data.bagtype == BagProxy.BagType.PersonalStorage then
    self.source.gameObject:SetActive(true)
    self.source.spriteName = "com_icon_Corner_warehouse"
  elseif self.data.bagtype == BagProxy.BagType.Barrow then
    self.source.gameObject:SetActive(true)
    self.source.spriteName = "com_icon_Corner_wheelbarrow"
  else
    self.source.gameObject:SetActive(false)
  end
end
