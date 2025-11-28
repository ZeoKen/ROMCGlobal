autoImport("BattlePassBuyLevelCell")
NoviceBattlePassBuyLevelCell = class("NoviceBattlePassBuyLevelCell", BattlePassBuyLevelCell)

function NoviceBattlePassBuyLevelCell:SetBPType(bPType)
  self.bPType = bPType
end

function NoviceBattlePassBuyLevelCell:GetCurBPLevel()
  if self.bPType == 2 then
    return NoviceBattlePassProxy.Instance:GetCurReturnBPLevel()
  end
  return NoviceBattlePassProxy.Instance:GetCurBPLevel()
end

function NoviceBattlePassBuyLevelCell:GetMaxBPLevel()
  if self.bPType == 2 then
    return NoviceBattlePassProxy.Instance.returnMaxBPLevel
  end
  return NoviceBattlePassProxy.Instance.maxBPLevel
end

function NoviceBattlePassBuyLevelCell:GetRewardItemByLevelRange(startLevel, endLevel, rewardList)
  if self.bPType == 2 then
    return NoviceBattlePassProxy.Instance:GetReturnRewardItemByLevelRange(startLevel, endLevel, rewardList)
  end
  return NoviceBattlePassProxy.Instance:GetRewardItemByLevelRange(startLevel, endLevel, rewardList)
end

function NoviceBattlePassBuyLevelCell:GetBuyPriceByLevelRange(startLevel, endLevel)
  if self.bPType == 2 then
    return NoviceBattlePassProxy.Instance:GetReturnBuyPriceByLevelRange(startLevel, endLevel)
  end
  return NoviceBattlePassProxy.Instance:GetBuyPriceByLevelRange(startLevel, endLevel)
end

function NoviceBattlePassBuyLevelCell:CallBpBuyLevelCmd(buyLv)
  if self.bPType == 2 then
    ServiceNoviceBattlePassProxy.Instance:CallReturnBpBuyLevelCmd(buyLv)
    return
  end
  ServiceNoviceBattlePassProxy.Instance:CallNoviceBpBuyLevelCmd(buyLv)
end

function NoviceBattlePassBuyLevelCell:SetData(data)
  self.titleLabel.text = ZhString.BattlePassBuyLevelCell_title
  self.countTitleLabel.text = ZhString.BattlePassBuyLevelCell_CountTitle
  self.currentLevel = self:GetCurBPLevel()
  self.maxcount = self:GetMaxBPLevel() - self.currentLevel
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

function NoviceBattlePassBuyLevelCell:UpdateTotalPrice(count)
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

function NoviceBattlePassBuyLevelCell:AddConfirmClickEvent()
  self:AddClickEvent(self.confirmButton.gameObject, function()
    OverseaHostHelper:GachaUseComfirm(tonumber(self.totalPrice.text), function()
      self:Confirm()
      local buyLv = tonumber(self.countInput.value)
      local moneyID = GameConfig.BattlePass.BuyLevelMoneyType or 151
      local own = HappyShopProxy.Instance:GetItemNum(moneyID)
      if own < tonumber(self.totalPrice.text) then
        OverSeaFunc.SpecialItemNotEnoughMsg(moneyID)
      else
        self:CallBpBuyLevelCmd(buyLv)
      end
    end)
  end)
end

local tipData = {}
tipData.funcConfig = {}

function NoviceBattlePassBuyLevelCell:ClickRewardItemHandler(cellctl)
  if cellctl.data then
    tipData.itemdata = cellctl.data
    self:ShowItemTip(tipData, nil, NGUIUtil.AnchorSide.Up)
  end
end
