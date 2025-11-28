autoImport("BaseView")
UniqueConfirmView_Hotfix = class("UniqueConfirmView_Hotfix", BaseView)
UniqueConfirmView_Hotfix.ViewType = UIViewType.ConfirmLayer
local _serverDeltaSecondTime, _formatTimeBySec

function UniqueConfirmView_Hotfix:Init()
  _serverDeltaSecondTime = ServerTime.ServerDeltaSecondTime
  _formatTimeBySec = ClientTimeUtil.FormatTimeBySec
  self.contentLabel = self:FindComponent("ContentLabel", UILabel)
  self.confirmLabel = self:FindComponent("ConfirmLabel", UILabel)
  self.confirmBtn = self:FindGO("ConfirmBtn")
  self:AddButtonEvent("ConfirmBtn", function(go)
    Game.Me():BackToLogo()
    self:CloseSelf()
  end)
  UIManagerProxy.Instance:NeedEnableAndroidKey(false)
end

function UniqueConfirmView_Hotfix:DoConfirm()
end

function UniqueConfirmView_Hotfix:DoCancel()
end

function UniqueConfirmView_Hotfix:FillContent(text)
  self.contentLabel.text = text
end

function UniqueConfirmView_Hotfix:FillButton()
  if not self.msgData then
    return
  end
  self.confirmLabel.text = self.msgData.button or ""
end

function UniqueConfirmView_Hotfix:OnEnter()
  UniqueConfirmView_Hotfix.super.OnEnter(self)
  local viewdata = self.viewdata.viewdata
  local msgId = viewdata.msgId
  local msgData = Table_Sysmsg[msgId]
  self.msgData = msgData
  self.patchDeadline = viewdata.patchDeadline + 1
  self:UpdateLeftTime()
  self:FillButton()
end

function UniqueConfirmView_Hotfix:UpdateLeftTime()
  self.curServerTime = ServerTime.CurServerTime()
  if _serverDeltaSecondTime(self.patchDeadline * 1000 + self.curServerTime) > 0 then
    self.timetick = TimeTickManager.Me():CreateTick(0, 500, self._updateLeftTime, self, 1)
  else
    self:RemoveTimeTick()
    Game.Me():BackToLogo()
  end
end

function UniqueConfirmView_Hotfix:_updateLeftTime()
  local leftTime = _serverDeltaSecondTime(self.patchDeadline * 1000 + self.curServerTime)
  if 0 < leftTime then
    self:FillContent(string.format(self.msgData.Text, leftTime))
  else
    self:RemoveTimeTick()
    Game.Me():BackToLogo()
  end
end

function UniqueConfirmView_Hotfix:RemoveTimeTick()
  if self.timetick then
    TimeTickManager.Me():ClearTick(self, 1)
    self.timetick = nil
  end
end

function UniqueConfirmView_Hotfix:OnExit()
  self:RemoveTimeTick()
  UniqueConfirmView_Hotfix.super.OnExit(self)
end
