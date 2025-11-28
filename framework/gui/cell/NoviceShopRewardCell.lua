autoImport("BaseCell")
NoviceShopRewardCell = class("NoviceShopRewardCell", BaseCell)
local RewardState = {
  Lock = 0,
  Unlock = 1,
  Finish = 2
}
local scale = 0.4

function NoviceShopRewardCell:Init()
  NoviceShopRewardCell.super.Init(self)
  self:AddCellClickEvent()
  self.mark = self:FindGO("mark")
  self.titleLabel = self:FindGO("Title"):GetComponent(UILabel)
  self.itemIcon = self:FindGO("Icon"):GetComponent(UISprite)
  self.countLabel = self:FindGO("Count"):GetComponent(UILabel)
  self.mask = self:FindGO("mask")
  self.recvBtn = self:FindGO("RecvBtn")
  self.gotoBtn = self:FindGO("GotoBtn")
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
      ServiceSceneUser3Proxy.Instance:CallFirstDepositReward(self.index == 1, self.data.price)
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

function NoviceShopRewardCell:CheckValidTime()
  if not NoviceShopProxy.Instance:CheckValidTime() then
    MsgManager.ShowMsgByID(40973)
    return false
  end
  return true
end

function NoviceShopRewardCell:SetData(data)
  if data then
    self.index = data
    self.data = NoviceShopProxy.Instance:GetRewardDataByID(data)
    if self.data then
      local state = self.data.state or RewardState.Lock
      self.gotoBtn:SetActive(state == RewardState.Lock)
      self.recvBtn:SetActive(state == RewardState.Unlock)
      self.mask:SetActive(state == RewardState.Finish)
      self.mark:SetActive(state == RewardState.Finish)
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
      if self.data.price == -1 then
        self.titleLabel.text = ZhString.NoviceShop_FirstDeposit
      elseif self.data.price == 0 then
        self.titleLabel.text = ZhString.AccumulativeShop_FreeDeposit
      else
        self.titleLabel.text = string.format(ZhString.NoviceShop_Accumulated, NoviceShopProxy.Instance:GetCurrencyType(), self.data.price)
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
