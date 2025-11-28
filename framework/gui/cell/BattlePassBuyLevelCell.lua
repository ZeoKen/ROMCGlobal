BattlePassBuyLevelCell = class("BattlePassBuyLevelCell", ShopItemInfoCell)

function BattlePassBuyLevelCell:Init()
  BattlePassBuyLevelCell.super.Init(self)
end

function BattlePassBuyLevelCell:FindObjs()
  self.closecomp = 123
  BattlePassBuyLevelCell.super.FindObjs(self)
  self.titleLabel = self:FindComponent("title", UILabel)
  self.countTitleLabel = self:FindComponent("CountTitle", UILabel)
  self.promptLab = self:FindComponent("prompt", UILabel)
  self.noitemLab = self:FindComponent("noitem", UILabel)
  self.buylevelsv = self:FindComponent("BuyLevelScrollview", UIScrollView)
  local itemContainer = self:FindGO("bag_itemContainer", self.buylevelsv.gameObject)
  self.buylevelwrap = WrapListCtrl.new(itemContainer, BagItemCell, "BagItemCell", WrapListCtrl_Dir.Vertical, 8, 98, true)
  self.buylevelwrap:AddEventListener(MouseEvent.MouseClick, self.ClickRewardItemHandler, self)
  UIUtil.LimitInputCharacter(self.countInput, 3)
end

function BattlePassBuyLevelCell:SetData(data)
  self.titleLabel.text = ZhString.BattlePassBuyLevelCell_title
  self.countTitleLabel.text = ZhString.BattlePassBuyLevelCell_CountTitle
  self.currentLevel = BattlePassProxy.BPLevel()
  self.maxcount = BattlePassProxy.Instance.maxBpLevel - self.currentLevel
  local moneyID = GameConfig.BattlePass.BuyLevelMoneyType or 151
  local moneyData = Table_Item[moneyID]
  if moneyData ~= nil then
    local icon = moneyData.Icon
    if icon ~= nil then
      IconManager:SetItemIcon(icon, self.priceIcon)
    end
  end
  self.promptLab.gameObject:SetActive(self.maxcount ~= 0)
  self.countInput.value = 1
  self:InputOnChange()
end

function BattlePassBuyLevelCell:UpdateTotalPrice(count)
  self.count = count
  if self.countInput.value ~= tostring(count) then
    self.countInput.value = count
  end
  local endLevel = self.currentLevel + count
  local unlockType = BitUtil.setbit(0, 1)
  if 0 < BattlePassProxy.Instance:AdvLevel() then
    unlockType = BitUtil.setbit(unlockType, 2)
  end
  if 0 < BattlePassProxy.Instance:SuLevel() then
    unlockType = BitUtil.setbit(unlockType, 3)
  end
  local rewardList = BattlePassProxy.Instance:GetRewardInfoByLevelRange(unlockType, self.currentLevel + 1, endLevel, true)
  local price = BattlePassProxy.Instance:GetBuyPriceByLevelRange(self.currentLevel + 1, endLevel)
  self.promptLab.text = string.format(ZhString.BattlePassBuyLevelCell_RewardDesc, endLevel, #rewardList)
  if rewardList and next(rewardList) then
    self.buylevelsv.gameObject:SetActive(true)
    self.buylevelwrap:ResetDatas(rewardList)
    self.noitemLab.gameObject:SetActive(false)
  else
    self.buylevelsv.gameObject:SetActive(false)
    self.noitemLab.gameObject:SetActive(true)
  end
  self.totalPrice.text = price or 0
end

function BattlePassBuyLevelCell:AddConfirmClickEvent()
  self:AddClickEvent(self.confirmButton.gameObject, function()
    OverseaHostHelper:GachaUseComfirm(tonumber(self.totalPrice.text), function()
      self:Confirm()
      local buyLv = tonumber(self.countInput.value)
      local moneyID = GameConfig.BattlePass.BuyLevelMoneyType or 151
      local own = HappyShopProxy.Instance:GetItemNum(moneyID)
      if own < tonumber(self.totalPrice.text) then
        OverSeaFunc.SpecialItemNotEnoughMsg(moneyID)
      else
        ServiceBattlePassProxy.Instance:CallBuyLevelBattlePassCmd(buyLv)
      end
    end)
  end)
end

local tipData = {}
tipData.funcConfig = {}

function BattlePassBuyLevelCell:ClickRewardItemHandler(cellctl)
  if cellctl.data then
    tipData.itemdata = cellctl.data
    self:ShowItemTip(tipData, nil, NGUIUtil.AnchorSide.Up)
  end
end
