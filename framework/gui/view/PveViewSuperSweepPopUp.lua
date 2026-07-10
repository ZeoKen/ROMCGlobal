local _BattleTimeData
local _GrayUIWidget = ColorUtil.GrayUIWidget
local _WhiteUIWidget = ColorUtil.WhiteUIWidget
PveViewSuperSweepPopUp = class("PveViewSuperSweepPopUp", ContainerView)
PveViewSuperSweepPopUp.ViewType = UIViewType.PopUpLayer

function PveViewSuperSweepPopUp:Init()
  _BattleTimeData = BattleTimeDataProxy.Instance
  self.viewData = self.viewdata and self.viewdata.viewdata
  self.pveData = self.viewData and self.viewData.pveData
  self.costTime = self.viewData and self.viewData.costTime or 0
  self.confirmCallback = self.viewData and self.viewData.confirmCallback
  self.viewGroupLeftTime = self.viewData and self.viewData.groupLeftTime
  self.useBattleTimeGroupPlayTime = self.viewData and self.viewData.useBattleTimeGroupPlayTime or false
  self.count = 1
  self:FindObjs()
  self:AddUIEvts()
  self:AddEvt()
  self:RefreshTimeInfo()
  self:SetCount(1)
end

function PveViewSuperSweepPopUp:FindObjs()
  self.tipLab = self:FindComponent("Tip", UILabel)
  self.conditionLab = self:FindComponent("Condition", UILabel)
  self.cancelBtn = self:FindGO("CancelBtn")
  self.confirmBtn = self:FindGO("ConfirmBtn")
  self.plusBtn = self:FindComponent("Plus", UISprite)
  self.plusBtnSp = self:FindComponent("Sprite", UISprite, self.plusBtn.gameObject)
  self.minusBtn = self:FindComponent("Minus", UISprite)
  self.minusBtnSp = self:FindComponent("Sprite", UISprite, self.minusBtn.gameObject)
  self.countLab = self:FindComponent("CountLab", UILabel)
  self.countInput = self:FindComponent("CountLab", UIInput)
  self.costLab = self:FindComponent("CostLab", UILabel)
end

function PveViewSuperSweepPopUp:AddUIEvts()
  self:AddClickEvent(self.cancelBtn, function()
    self:CloseSelf()
  end)
  self:AddClickEvent(self.confirmBtn, function()
    self:CommitCountInput()
    if self.confirmCallback then
      self.confirmCallback(self.count)
    end
    self:CloseSelf()
  end)
  self:AddClickEvent(self.plusBtn.gameObject, function()
    self:CommitCountInput()
    self:SetCount(self.count + 1)
  end)
  self:AddClickEvent(self.minusBtn.gameObject, function()
    self:CommitCountInput()
    self:SetCount(self.count - 1)
  end)
  if self.countInput then
    EventDelegate.Set(self.countInput.onChange, function()
      self:OnCountInputChange()
    end)
    local onSubmit = function()
      self:CommitCountInput()
    end
    EventDelegate.Set(self.countInput.onSubmit, onSubmit)
    self:AddSelectEvent(self.countInput, function(go, state)
      if not state then
        onSubmit()
      end
    end)
  end
end

function PveViewSuperSweepPopUp:AddEvt()
  self:AddListenEvt(ServiceEvent.NUserBattleTimelenUserCmd, self.HandlePlayTimeUpdate)
  self:AddListenEvt(ServiceEvent.SceneUser3GroupPlayTimeUpdateUserCmd, self.HandlePlayTimeUpdate)
end

function PveViewSuperSweepPopUp:HandlePlayTimeUpdate()
  self.useBattleTimeGroupPlayTime = true
  self.viewGroupLeftTime = nil
  self:RefreshTimeInfo()
  self:SetCount(self.count)
end

function PveViewSuperSweepPopUp:GetGroupPlayTime(groupid)
  if nil ~= self.viewGroupLeftTime then
    return self.viewGroupLeftTime
  end
  if not self.useBattleTimeGroupPlayTime and self.pveData and self.pveData.GetExclusiveLeftTime then
    local lefttime = self.pveData:GetExclusiveLeftTime()
    if nil ~= lefttime then
      return lefttime
    end
  end
  return _BattleTimeData:GetGroupPlayTime(groupid) or 0
end

function PveViewSuperSweepPopUp:RefreshTimeInfo()
  local groupid = self.pveData and self.pveData.staticEntranceData and self.pveData.staticEntranceData.groupid
  self.groupLeftTime = self:GetGroupPlayTime(groupid)
  self.normalLeftTime = (_BattleTimeData:GetLeftTime(BattleTimeDataProxy.ETime.PLAY) or 0) // 60
  self.totalLeftTime = self.groupLeftTime + self.normalLeftTime
  if 0 < self.costTime then
    self.maxCount = math.max(1, math.floor(self.totalLeftTime * 60 / self.costTime))
  else
    self.maxCount = 1
  end
end

function PveViewSuperSweepPopUp:SetCount(count)
  count = math.floor(tonumber(count) or 1)
  count = math.max(1, math.min(count, self.maxCount))
  self.count = count
  self:UpdateCount()
end

function PveViewSuperSweepPopUp:OnCountInputChange()
  if not self.countInput then
    return
  end
  local count = tonumber(self.countInput.value)
  if nil ~= count then
    self:SetCount(count)
  end
end

function PveViewSuperSweepPopUp:CommitCountInput()
  if not self.countInput then
    return
  end
  local count = tonumber(self.countInput.value)
  if nil == count then
    self.countInput.value = self.count
    return
  end
  self:SetCount(count)
end

function PveViewSuperSweepPopUp:UpdateCount()
  self.countLab.text = tostring(self.count)
  if self.countInput and self.countInput.value ~= tostring(self.count) then
    self.countInput.value = self.count
  end
  self.tipLab.text = string.format(ZhString.Pve_SuperSweep_Tip, self.count)
  local costTime = self.count * self.costTime // 60
  self.costLab.text = string.format("%d/%d", costTime, self.totalLeftTime)
  local extraTime = costTime - self.groupLeftTime
  if 0 < extraTime then
    self.conditionLab.text = string.format(ZhString.Pve_SuperSweep_Condition, extraTime)
    self:Show(self.conditionLab.gameObject)
  else
    self:Hide(self.conditionLab.gameObject)
  end
  self:UpdateCountBtnState()
end

function PveViewSuperSweepPopUp:UpdateCountBtnState()
  if self.count >= self.maxCount then
    _GrayUIWidget(self.plusBtn)
    _GrayUIWidget(self.plusBtnSp)
  else
    _WhiteUIWidget(self.plusBtn)
    _WhiteUIWidget(self.plusBtnSp)
  end
  if self.count <= 1 then
    _GrayUIWidget(self.minusBtn)
    _GrayUIWidget(self.minusBtnSp)
  else
    _WhiteUIWidget(self.minusBtn)
    _WhiteUIWidget(self.minusBtnSp)
  end
end
