autoImport("BaseCell")
AccumulativeShopRewardCell = class("AccumulativeShopRewardCell", BaseCell)
local RewardState = {
  Lock = 0,
  Unlock = 1,
  Finish = 2
}
local scale = 0.4

function AccumulativeShopRewardCell:Init()
  AccumulativeShopRewardCell.super.Init(self)
  self:AddCellClickEvent()
  self.mark = self:FindGO("mark")
  self.titleLabel = self:FindGO("Title"):GetComponent(UILabel)
  self.itemIcon = self:FindGO("Icon"):GetComponent(UISprite)
  self.countLabel = self:FindGO("Count"):GetComponent(UILabel)
  self.mask = self:FindGO("mask")
  self.recvBtn = self:FindGO("RecvBtn")
  self.gotoBtn = self:FindGO("GotoBtn")
  self.unLock = self:FindGO("unLock")
  self.unlockLabel = self:FindGO("unlockLabel"):GetComponent(UILabel)
  self.unlockText = self:FindGO("unlockText"):GetComponent(UILabel)
  self.unlockLabel.text = ZhString.ExtraBonusCell_Unlock
  self.cardobj = self:FindGO("cardCell")
  self.cardItem = ItemCardCell.new(self.cardobj)
  self:AddClickEvent(self.gotoBtn, function()
    FunctionNewRecharge.Instance():OpenUI(PanelConfig.NewRecharge_TDeposit, FunctionNewRecharge.InnerTab.Deposit_ROB)
  end)
  self:AddClickEvent(self.recvBtn, function()
    if not self:CheckValidTime() then
      return
    end
    if self.index and self.data then
      ServiceSceneUser3Proxy.Instance:CallAccumDepositReward(self.data.idx)
    end
  end)
  self:AddClickEvent(self.itemIcon.gameObject, function()
    if self.data then
      local sdata = {
        itemdata = ItemData.new("noviceshopreward", self.data.itemid),
        funcConfig = {},
        callback = callback
      }
      TipManager.Instance:ShowItemFloatTip(sdata, stick, NGUIUtil.AnchorSide.Left, {-220, 0})
    end
  end)
end

function AccumulativeShopRewardCell:CheckValidTime()
  if not AccumulativeShopProxy.Instance:CheckValidTime() then
    MsgManager.ShowMsgByID(40973)
    return false
  end
  return true
end

function AccumulativeShopRewardCell:SetData(data)
  if data then
    self.index = data
    self.data = AccumulativeShopProxy.Instance:GetRewardDataByID(data)
    if self.data then
      local state = self.data.state or RewardState.Lock
      self.gotoBtn:SetActive(state == RewardState.Lock)
      self.recvBtn:SetActive(state == RewardState.Unlock)
      self.mask:SetActive(state == RewardState.Finish)
      self.mark:SetActive(state == RewardState.Finish)
      if self.data.extraTip and self.data.extraTip ~= "" then
        self.unlockText.text = self.data.extraTip
        self.unLock:SetActive(true)
      else
        self.unLock:SetActive(false)
      end
      local item = Table_Item[self.data.itemid or ""]
      local cardinfo = Table_Card[self.data.itemid]
      if item then
        if not cardinfo then
          self.cardobj:SetActive(false)
          IconManager:SetItemIcon(item.Icon, self.itemIcon)
        else
          self.itemIcon.spriteName = ""
          self.cardobj:SetActive(true)
          local itemdata = ItemData.new("noviceshopreward", self.data.itemid)
          self.cardItem:SetData(itemdata)
        end
      end
      if self.data.price < 0 then
        self.titleLabel.text = ZhString.AccumulativeShop_AnyDeposit
      elseif self.data.price == 0 then
        self.titleLabel.text = ZhString.AccumulativeShop_FreeDeposit
      else
        self.titleLabel.text = string.format(ZhString.NoviceShop_Accumulated, AccumulativeShopProxy.Instance:GetCurrencyType(), self.data.price)
      end
      local count = self.data.count or 1
      self.countLabel.text = "x " .. tostring(count)
    else
      redlog("rewardData nil")
    end
  else
    redlog("data nil")
  end
end
