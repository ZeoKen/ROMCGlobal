autoImport("BattlePassBuyLevelCell")
ActivityBattlePassBuyLevelCell = class("ActivityBattlePassBuyLevelCell", BattlePassBuyLevelCell)

function ActivityBattlePassBuyLevelCell:GetCurBPLevel()
  return ActivityBattlePassProxy.Instance:GetCurBPLevel(self.activityId)
end

function ActivityBattlePassBuyLevelCell:GetMaxBPLevel()
  return ActivityBattlePassProxy.Instance.maxBPLevel[self.activityId]
end

function ActivityBattlePassBuyLevelCell:GetRewardItemByLevelRange(startLevel, endLevel, rewardList)
  return ActivityBattlePassProxy.Instance:GetRewardItemByLevelRange(self.activityId, startLevel, endLevel, rewardList)
end

function ActivityBattlePassBuyLevelCell:GetBuyPriceByLevelRange(startLevel, endLevel)
  return ActivityBattlePassProxy.Instance:GetBuyPriceByLevelRange(self.activityId, startLevel, endLevel)
end

function ActivityBattlePassBuyLevelCell:CallBpBuyLevelCmd(buyLv)
  ServiceActivityCmdProxy.Instance:CallActBpBuyLevelCmd(self.activityId, buyLv)
end

function ActivityBattlePassBuyLevelCell:FindObjs()
  ActivityBattlePassBuyLevelCell.super.FindObjs(self)
  self:AddButtonEvent("mask", function()
    self:Cancel()
  end)
end

function ActivityBattlePassBuyLevelCell:SetData(data)
  self.activityId = data
  self.titleLabel.text = ""
  self.currentLevel = self:GetCurBPLevel()
  self.maxcount = self:GetMaxBPLevel() - self.currentLevel
  local moneyID = GameConfig.BattlePass.BuyLevelMoneyType or 151
  IconManager:SetItemIconById(moneyID, self.priceIcon)
  self.promptLab.gameObject:SetActive(self.maxcount ~= 0)
  self.countInput.value = 1
  self:InputOnChange()
end

function ActivityBattlePassBuyLevelCell:UpdatePrice()
  self.price.text = ""
end

function ActivityBattlePassBuyLevelCell:UpdateTotalPrice(count)
  self.count = count
  if self.countInput.value ~= tostring(count) then
    self.countInput.value = count
  end
  local endLevel = self.currentLevel + count
  local rewardList = ReusableTable.CreateArray()
  rewardList = self:GetRewardItemByLevelRange(self.currentLevel + 1, endLevel, rewardList)
  local price = self:GetBuyPriceByLevelRange(self.currentLevel + 1, endLevel)
  self.promptLab.text = string.format(ZhString.BattlePassBuyLevelCell_RewardDesc, endLevel, #rewardList)
  if 0 < #rewardList then
    self.buylevelsv.gameObject:SetActive(true)
    self.buylevelwrap:ResetDatas(rewardList)
    self.noitemLab.gameObject:SetActive(false)
  else
    self.buylevelsv.gameObject:SetActive(false)
    self.noitemLab.gameObject:SetActive(true)
  end
  ReusableTable.DestroyAndClearArray(rewardList)
  self.totalPrice.text = price or 0
end

function ActivityBattlePassBuyLevelCell:AddConfirmClickEvent()
  self:AddClickEvent(self.confirmButton.gameObject, function()
    OverseaHostHelper:GachaUseComfirm(tonumber(self.totalPrice.text), function()
      self:Confirm()
      local buyLv = tonumber(self.countInput.value)
      local moneyID = GameConfig.BattlePass.BuyLevelMoneyType or 151
      local own = HappyShopProxy.Instance:GetItemNum(moneyID)
      if own < tonumber(self.totalPrice.text) then
        MsgManager.ConfirmMsgByID(3551, function()
          FunctionNewRecharge.Instance():OpenUI(PanelConfig.NewRecharge_TDeposit)
        end)
      else
        MsgManager.DontAgainConfirmMsgByID(43344, function()
          self:CallBpBuyLevelCmd(buyLv)
        end, nil, nil, self.totalPrice.text)
      end
    end)
  end)
end

local tipData = {}
tipData.funcConfig = {}

function ActivityBattlePassBuyLevelCell:ClickRewardItemHandler(cellctl)
  if cellctl.data then
    tipData.itemdata = cellctl.data
    self:ShowItemTip(tipData, nil, NGUIUtil.AnchorSide.Up)
  end
end
