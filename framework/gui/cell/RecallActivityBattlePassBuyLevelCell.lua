autoImport("ActivityBattlePassBuyLevelCell")
RecallActivityBattlePassBuyLevelCell = class("RecallActivityBattlePassBuyLevelCell", ActivityBattlePassBuyLevelCell)

function RecallActivityBattlePassBuyLevelCell:GetCurBPLevel()
  return RecallActivityBattlePassProxy.Instance:GetCurBPLevel()
end

function RecallActivityBattlePassBuyLevelCell:GetMaxBPLevel()
  return RecallActivityBattlePassProxy.Instance:GetMaxBPLevel()
end

function RecallActivityBattlePassBuyLevelCell:GetRewardItemByLevelRange(startLevel, endLevel, rewardList)
  return RecallActivityBattlePassProxy.Instance:GetRewardItemByLevelRange(startLevel, endLevel, rewardList)
end

function RecallActivityBattlePassBuyLevelCell:GetBuyPriceByLevelRange(startLevel, endLevel)
  return RecallActivityBattlePassProxy.Instance:GetBuyPriceByLevelRange(startLevel, endLevel)
end

function RecallActivityBattlePassBuyLevelCell:CallBpBuyLevelCmd(buyLv)
  ServiceRecallCCmdProxy.Instance:CallBattlePassQuickLvUpRecallCmd(buyLv)
end

function RecallActivityBattlePassBuyLevelCell:SetData()
  self.titleLabel.text = ""
  self.currentLevel = self:GetCurBPLevel()
  self.maxcount = self:GetMaxBPLevel() - self.currentLevel
  self.promptLab.gameObject:SetActive(self.maxcount ~= 0)
  self.countInput.value = 1
  self:InputOnChange()
end

function RecallActivityBattlePassBuyLevelCell:UpdateTotalPrice(count)
  self.count = count
  if self.countInput.value ~= tostring(count) then
    self.countInput.value = count
  end
  local endLevel = self.currentLevel + count
  local rewardList = ReusableTable.CreateArray()
  rewardList = self:GetRewardItemByLevelRange(self.currentLevel + 1, endLevel, rewardList)
  local costItem, price = self:GetBuyPriceByLevelRange(self.currentLevel + 1, endLevel)
  if costItem then
    IconManager:SetItemIconById(costItem, self.priceIcon)
  end
  self.costItem = costItem
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

function RecallActivityBattlePassBuyLevelCell:AddConfirmClickEvent()
  self:AddClickEvent(self.confirmButton.gameObject, function()
    local totalPrice = tonumber(self.totalPrice.text)
    local buyLv = tonumber(self.countInput.value)
    local own = HappyShopProxy.Instance:GetItemNum(self.costItem)
    if totalPrice > own then
      MsgManager.ShowMsgByID(1)
    else
      MsgManager.DontAgainConfirmMsgByID(3000007, function()
        self:CallBpBuyLevelCmd(buyLv)
        self:Confirm()
      end, nil, nil, totalPrice)
    end
  end)
end
