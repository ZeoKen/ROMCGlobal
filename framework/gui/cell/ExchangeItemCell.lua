ExchangeItemCell = class("ExchangeItemCell", ItemCell)
local str_format = "%s/%s"
local tempColor = LuaColor.White()
local greenColor = "[11a84c]x%s[-]"
local redColor = "[cf1c0f]x%s[-]"
ExchangeItemCellEvent = {
  Minus = "ExchangeItemCellEvent_Minus",
  LongPress = "ExchangeItemCellEvent_LongPress",
  LongPressSubtract = "ExchangeItemCellEvent_LongPressSubtract"
}

function ExchangeItemCell:Init()
  self:FindObj()
  self:AddEvts()
end

function ExchangeItemCell:FindObj()
  local itemCell = self:FindGO("Common_ItemCell")
  if not itemCell then
    self.itemgo = self:LoadPreferb("cell/ItemCell", self.gameObject)
    self.itemgo.name = "Common_ItemCell"
  end
  ExchangeItemCell.super.Init(self)
  self.pos = self:FindGO("pos")
  self.minus = self:FindGO("MinusImg")
  self.choosenLab = self:FindComponent("ChoosenNumLab", UILabel)
  self.ownLab = self:FindComponent("OwnLab", UILabel)
  self.chooseSymbol = self:FindGO("ChooseImg")
  self:AddCellClickEvent()
end

function ExchangeItemCell:AddEvts()
  self:AddPressEvent(self.gameObject, function(g, b)
    self:PlusPressCount(b)
  end)
  self:AddPressEvent(self.minus, function(g, b)
    self:SubtractPressCount(b)
  end)
end

function ExchangeItemCell:PlusPressCount(isPressed)
  if isPressed then
    TimeTickManager.Me():CreateTick(0, 150, function(owner, deltaTime)
      self:PassEvent(ExchangeItemCellEvent.LongPress, self)
    end, self, 1001)
  else
    TimeTickManager.Me():ClearTick(self, 1001)
  end
end

function ExchangeItemCell:SubtractPressCount(isPressed)
  if isPressed then
    TimeTickManager.Me():CreateTick(0, 150, function(owner, deltaTime)
      self:PassEvent(ExchangeItemCellEvent.LongPressSubtract, self)
    end, self, 1002)
  else
    TimeTickManager.Me():ClearTick(self, 1002)
  end
end

function ExchangeItemCell:SetData(data)
  if not data then
    self:Hide(self.itemgo)
    self:Hide(self.pos)
    self.gameObject:SetActive(false)
    return
  end
  self.gameObject:SetActive(true)
  self:Show(self.itemgo)
  self:Show(self.pos)
  ExchangeItemCell.super.SetData(self, data)
  if data.id == "FeedPet" then
    self:SetFeedData()
    self:UpdateChoose()
    return
  end
  self:UpdateOwn()
end

function ExchangeItemCell:SetChoosen(id)
  self.chooseId = id
  self:UpdateChoose()
end

function ExchangeItemCell:UpdateChoose()
  if self.data and self.chooseId and self.data.staticData.id == self.chooseId then
    self.chooseSymbol:SetActive(true)
  else
    self.chooseSymbol:SetActive(false)
  end
end

function ExchangeItemCell:SetFeedData()
  if not self.data then
    self:Hide(self.pos)
    return
  end
  self:Hide(self.minus)
  self:Hide(self.ownLab)
  local staticId = self.data.staticData.id
  local own = ExchangeShopProxy.GetOwnCount(staticId)
  if 0 == own then
    tempColor:Set(0.00392156862745098, 0.00784313725490196, 0.011764705882352941, 0.6274509803921569)
    self.icon.color = tempColor
    self:Hide(self.choosenLab)
  else
    ColorUtil.WhiteUIWidget(self.icon)
    self:Show(self.choosenLab)
    self.choosenLab.text = string.format(greenColor, own)
  end
end

function ExchangeItemCell:UpdateOwn()
  if self:ObjIsNil(self.gameObject) then
    return
  end
  if not self.data then
    self:Hide(self.pos)
    return
  end
  local staticId = self.data.staticData.id
  local own = ExchangeShopProxy.GetOwnCount(staticId)
  local previewNum = ExchangeShopProxy.Instance.chooseMap[staticId] or 0
  self.minus:SetActive(0 < previewNum)
  if previewNum <= 0 and self.subtractTick then
    self.subtractTick:Destroy()
    self.subtractTick = nil
  end
  self.pos:SetActive(true)
  if 0 == own then
    if previewNum == 0 then
      self.choosenLab.text = ""
      self.ownLab.text = ""
    else
      self.choosenLab.text = string.format(redColor, previewNum)
      self.ownLab.text = 0
    end
  else
    if previewNum == 0 then
      self.choosenLab.text = ""
    else
      self.choosenLab.text = own < previewNum and string.format(redColor, previewNum) or string.format(greenColor, previewNum)
    end
    self.ownLab.text = own
  end
end

function ExchangeItemCell:OnCellDestroy()
  TimeTickManager.Me():ClearTick(self)
end
