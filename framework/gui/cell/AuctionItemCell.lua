AuctionItemCell = class("AuctionItemCell", ItemCell)

function AuctionItemCell:Init()
  local obj = self:LoadPreferb("cell/ItemCell", self.gameObject)
  obj.transform.localPosition = LuaGeometry.GetTempVector3()
  AuctionItemCell.super.Init(self)
  self:FindObjs()
  self:InitCell()
  self:AddCellClickEvent()
  self:SetIgnoreClickEventInterval(true)
end

function AuctionItemCell:FindObjs()
  self.tweenScale = self.gameObject:GetComponent(TweenScale)
  self.widget = self.gameObject:GetComponent(UIWidget)
  self.redDot = self:FindGO("RedDot")
  self.result = self:FindGO("Result"):GetComponent(UISprite)
  self.spOrder = self:FindGO("spOrder")
end

function AuctionItemCell:InitCell()
end

function AuctionItemCell:SetData(data)
  self.gameObject:SetActive(data ~= nil)
  if data then
    AuctionItemCell.super.SetData(self, data:GetItemData())
    self:ActiveNewTag(false)
    self:ShowRedDot(false)
    if data.result == AuctionItemState.Sucess then
      self.result.gameObject:SetActive(true)
      IconManager:SetArtFontIcon("auction_icon_seal2", self.result)
    elseif data.result == AuctionItemState.Fail then
      self.result.gameObject:SetActive(true)
      IconManager:SetArtFontIcon("auction_icon_seal3", self.result)
    else
      self.result.gameObject:SetActive(false)
    end
    self.spOrder:SetActive(data.originOrder == 0)
  end
  self.data = data
end

function AuctionItemCell:SetScale(isScale)
  if isScale then
    self.tweenScale:PlayForward()
    self.widget.alpha = 1
  else
    self.tweenScale:PlayReverse()
    self.widget.alpha = 0.5
  end
end

function AuctionItemCell:ShowRedDot(isShow)
  self.redDot:SetActive(isShow)
end
