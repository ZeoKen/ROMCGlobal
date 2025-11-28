PeddlerExtraBonusCell = class("PeddlerExtraBonusCell", BaseCell)

function PeddlerExtraBonusCell:Init()
  self:FindObjs()
  self:AddEvts()
end

function PeddlerExtraBonusCell:FindObjs()
  self.progressSlider = self:FindComponent("Slider", UISlider)
  self.progressLabel = self:FindComponent("ProgressLabel", UILabel)
  self.rewardIcon = self:FindComponent("Icon", UISprite)
  self.rewardCountLabel = self:FindComponent("Count", UILabel)
  self.finishSymbol = self:FindGO("FinishSymbol")
  self.effectContainer = self:FindGO("EffectContainer")
  self:AddCellClickEvent()
end

function PeddlerExtraBonusCell:AddEvts()
end

function PeddlerExtraBonusCell:SetData(data)
  self.data = data
  if not data then
    self.gameObject:SetActive(false)
    return
  end
  self.gameObject:SetActive(true)
  self:SetProgress(data.currentAmount or 0, data.targetAmount or 0)
  self:SetRewardInfo(data.rewardId or 0, data.rewardCount or 0)
  self:SetStatus(data.status or "pending")
end

function PeddlerExtraBonusCell:SetProgress(current, target)
  local progress = 0
  if 0 < target then
    progress = math.min(current / target, 1.0)
  end
  if self.progressSlider then
    if self.data and self.data.progressCurrent and self.data.progressTarget then
      local relativeProgress = 0
      if 0 < self.data.progressTarget then
        relativeProgress = math.min(self.data.progressCurrent / self.data.progressTarget, 1.0)
      end
      self.progressSlider.value = relativeProgress
    else
      self.progressSlider.value = progress
    end
  end
  if self.progressLabel then
    local displayCurrent = math.min(current, target)
    self.progressLabel.text = string.format("(%s/%s)", StringUtil.NumThousandFormat(displayCurrent), StringUtil.NumThousandFormat(target))
  end
end

function PeddlerExtraBonusCell:SetRewardInfo(itemId, count)
  if itemId <= 0 then
    if self.rewardContainer then
      self.rewardContainer:SetActive(false)
    end
    return
  end
  if self.rewardContainer then
    self.rewardContainer:SetActive(true)
  end
  local staticData = Table_Item[itemId]
  if staticData and self.rewardIcon then
    IconManager:SetItemIcon(staticData.Icon, self.rewardIcon)
    self.rewardIcon:MakePixelPerfect()
  end
  if self.rewardCountLabel then
    if 1 < count then
      self.rewardCountLabel.gameObject:SetActive(true)
      self.rewardCountLabel.text = tostring(count)
    else
      self.rewardCountLabel.gameObject:SetActive(false)
    end
  end
  self.rewardItemId = itemId
  self.rewardItemCount = count
end

function PeddlerExtraBonusCell:SetStatus(status)
  self.status = status
  if self.finishSymbol then
    self.finishSymbol:SetActive(false)
  end
  local btnActive = false
  local btnText = ""
  if status == "pending" then
    btnActive = false
    btnText = ZhString.PeddlerExtraBonus_NotReached or "未达成"
    if self.backgroundSprite then
      self.backgroundSprite.color = Color.gray
    end
    self:DestroyReceiveEffect()
  elseif status == "complete" then
    btnActive = true
    btnText = ZhString.PeddlerExtraBonus_CanReceive or "领取"
    if self.finishSymbol then
      self.finishSymbol:SetActive(false)
    end
    if self.backgroundSprite then
      self.backgroundSprite.color = Color.white
    end
    self:PlayReceiveEffect()
  elseif status == "received" then
    btnActive = false
    btnText = ZhString.PeddlerExtraBonus_Received or "已领取"
    if self.finishSymbol then
      self.finishSymbol:SetActive(true)
    end
    if self.backgroundSprite then
      self.backgroundSprite.color = Color.gray
    end
    self:DestroyReceiveEffect()
  end
  if self.receiveBtn then
    self.receiveBtn:SetActive(btnActive)
  end
  if self.receiveBtnLabel then
    self.receiveBtnLabel.text = btnText
  end
end

function PeddlerExtraBonusCell:OnReceiveClicked()
  if self.status ~= "complete" then
    return
  end
  xdlog("PeddlerExtraBonusCell:OnReceiveClicked", "领取奖励", self.data and self.data.targetAmount)
  if self.data and self.data.targetAmount then
    PeddlerShopProxy.Instance:RequestReceiveExtraBonus(self.data.targetAmount)
  end
  self:PassEvent(MouseEvent.MouseClick, self)
end

function PeddlerExtraBonusCell:ShowItemTip()
  if not self.rewardItemId or self.rewardItemId <= 0 then
    return
  end
  self:PassEvent(ItemTipEvent.ShowItemTip, self.rewardItemId)
end

function PeddlerExtraBonusCell:PlayReceiveEffect()
  if not self.effectContainer then
    return
  end
  self:DestroyReceiveEffect()
  if not self.receiveEffect then
    self.receiveEffect = self:PlayUIEffect(EffectMap.UI.FlipCard_LinkReward, self.effectContainer)
  end
end

function PeddlerExtraBonusCell:DestroyReceiveEffect()
  if self.receiveEffect then
    self.receiveEffect:Destroy()
    self.receiveEffect = nil
  end
end

function PeddlerExtraBonusCell:OnDestroy()
  self:DestroyReceiveEffect()
  self.data = nil
  self.rewardItemId = nil
  self.rewardItemCount = nil
  self.status = nil
  PeddlerExtraBonusCell.super.OnDestroy(self)
end
