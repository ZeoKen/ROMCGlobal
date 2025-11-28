LotteryRecoverCell = class("LotteryRecoverCell", ItemCell)

function LotteryRecoverCell:Init()
  self.itemContainer = self:FindGO("ItemContainer")
  local obj = self:LoadPreferb("cell/ItemCell", self.itemContainer)
  obj.transform.localPosition = LuaGeometry.Const_V3_zero
  LotteryRecoverCell.super.Init(self)
  self:FindObjs()
  self:AddEvts()
  self:HideNum()
end

function LotteryRecoverCell:FindObjs()
  self.money = self:FindGO("Money"):GetComponent(UILabel)
  self.moneyIcon = self:FindGO("MoneyIcon"):GetComponent(UISprite)
  self.sub = self:FindGO("Sub")
  if self.sub then
    self.sub:SetActive(false)
  end
  self.count = self:FindGO("Count"):GetComponent(UILabel)
  self.selected = self:FindGO("Selected")
end

function LotteryRecoverCell:AddLongPressEvt()
  self.tipData = {}
  self.tipData.funcConfig = {}
  local pressFunc = function(_, state)
    if state and self.data and self.data.itemData then
      self.tipData.itemdata = self.data.itemData
      TipManager.Instance:ShowItemFloatTip(self.tipData, self.icon, NGUIUtil.AnchorSide.Right, {210, -50})
    end
  end
  self.longPress = self.itemContainer:GetComponent(UILongPress)
  self.longPress.pressEvent = pressFunc
end

function LotteryRecoverCell:AddEvts()
  self:AddClickEvent(self.itemContainer, function()
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
  self:AddLongPressEvt()
end

function LotteryRecoverCell:SetData(data)
  if not data then
    return
  end
  LotteryRecoverCell.super.SetData(self, data.itemData)
  self.data = data
  self:ActiveNewTag(false)
  local money = Table_Item[data.costItem]
  if money and money.Icon then
    IconManager:SetItemIcon(money.Icon, self.moneyIcon)
  end
  self:UpdateSub(data)
  self:UpdateCount(data)
  self:UpdateMoney(data)
  self:HideBgSp()
end

function LotteryRecoverCell:UpdateSub(data)
  data = data or self.data
  self.selected:SetActive(data.selectCount == data.itemData.num)
end

function LotteryRecoverCell:UpdateCount(data)
  data = data or self.data
  local delta = data.itemData.num - data.selectCount
  if 0 < delta then
    self.count.text = tostring(delta)
  else
    self.count.text = ""
  end
end

function LotteryRecoverCell:UpdateMoney(data)
  data = data or self.data
  self.money.text = data:GetLeftCost()
end

function LotteryRecoverCell:UpdateInfo()
  self:UpdateSub()
  self:UpdateCount()
  self:UpdateMoney()
end

function LotteryRecoverCell:SelectCount(offset)
  if self.data:SelectCount(offset) then
    self:UpdateSub()
    self:UpdateCount()
    self:UpdateMoney()
  end
end
