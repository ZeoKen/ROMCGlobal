LoveChallengeConfirmCell = class("LoveChallengeConfirmCell", InviteConfirmCell)
LoveChallengeConfirmCell.resID = ResourcePathHelper.UICell("LoveChallengeConfirmCell")

function LoveChallengeConfirmCell:Enter()
  if not self.gameObject then
    self.gameObject = self:CreateObj(LoveChallengeConfirmCell.resID, self.parent)
    self.nobtn = self:FindGO("NoBtn")
    self.noTip = self:FindGO("Label", self.nobtn):GetComponent(UILabel)
    self.yesbtn = self:FindGO("YesBtn")
    self.yestip = self:FindGO("Label", self.yesbtn):GetComponent(UILabel)
    self.lab1 = self:FindGO("Context"):GetComponent(UILabel)
    self.lab2 = self:FindGO("Context2"):GetComponent(UILabel)
    self.effectHandler = self:FindGO("EffectHandler")
    self:SetEvent(self.yesbtn, function()
      self:ExcuteYesEvent()
    end)
    self:SetEvent(self.nobtn, function()
      self:ExcuteNoEvent()
    end)
  end
end

function LoveChallengeConfirmCell:SetData(data)
  if data then
    self.data = data
  else
    data = self.data
  end
  if self.data then
    self.playerid = data.playerid
    self.yestip.text = data.button
    self.noTip.text = ZhString.TeamOptionPopUp_AutoApplyTip1
    if data.tip then
      self.tipLabel.text = data.tip
    end
    self.yesevt = data.yesevt
    self.noevt = data.noevt
    self.endevt = data.endevt
    self.name = data.name or "?"
    self.lab1.text = string.format(ZhString.LoveChallenge_BeInvited, self.name)
    self.endTimeStamp = MiniGameProxy.Instance:GetInviteEndStamp()
    if self.endTimeStamp then
      TimeTickManager.Me():ClearTick(self, 1)
      TimeTickManager.Me():CreateTick(0, 500, self.handleCountdown, self, 1)
    end
    if not self.inviteEffect then
      self.inviteEffect = self:PlayUIEffect(EffectMap.UI.LoveChallenge_InviteHeart, self.effectHandler)
      xdlog("play inviteEffect")
    end
  end
end

function LoveChallengeConfirmCell:ExcuteYesEvent()
  if self.yesevt then
    self.yesevt(self.playerid, self.name)
  end
  self:PassEvent(InviteConfirmEvent.Agree, self)
  local noClose = self.data and self.data.agreeNoClose
  if not noClose then
    self:Exit()
  end
end

function LoveChallengeConfirmCell:ExcuteNoEvent()
  if self.noevt then
    self.noevt(self.playerid, self.name)
  end
  if self.data.CanNOTrefuse then
  else
    self:PassEvent(InviteConfirmEvent.Refuse, self)
    self:Exit()
  end
end

function LoveChallengeConfirmCell:handleCountdown()
  local timeLeft = self.endTimeStamp - ServerTime.CurServerTime() / 1000
  if timeLeft < 0 then
    self:PassEvent(InviteConfirmEvent.TimeOver, self)
    self:Exit()
  else
    self.lab2.text = string.format(ZhString.LoveChallenge_InviteCountdown, math.floor(timeLeft))
  end
end

function LoveChallengeConfirmCell:Exit()
  self.inviteEffect:Destroy()
  self.inviteEffect = nil
  TimeTickManager.Me():ClearTick(self)
  Game.GOLuaPoolManager:AddToUIPool(LoveChallengeConfirmCell.resID, self.gameObject)
  self.gameObject = nil
  LoveChallengeConfirmCell.super.Exit(self)
end
