autoImport("ChangeGvgLineView")
ChangeGvgLineView_MultyZone = class("ChangeGvgLineView_MultyZone", ChangeGvgLineView)

function ChangeGvgLineView_MultyZone:InitShow()
  self:RegistShowGeneralHelpByHelpID(32648, self.helpBtn)
  self.InputLab.text = string.format(ZhString.ChangeGvgLine_InputTip, GvgProxy.Instance:GetGroupCnt())
  self.groupRoot = self:FindGO("GroupInfoRoot")
  self.battleGroup = self:FindComponent("BattleGroup", UILabel, self.groupRoot)
  self.gvgTime = self:FindComponent("GvGTime", UILabel, self.groupRoot)
  EventDelegate.Set(self.contentInput.onChange, function()
    self:OnInputChanged()
  end)
  local guildData = GuildProxy.Instance.myGuildData
  self.name.text = ZhString.ChangeGvgLine_Title
  local battlelineStr, timeZoneId, server_id, battleLineId, timeZoneLetter = GuildProxy.ParseServerGroupID(guildData.battle_group, true)
  self.currentZone.text = string.format(ZhString.ChangeGvgLine_Current, battlelineStr)
  self.isChangingGvGLine = guildData.change_group_time ~= 0
  if self.isChangingGvGLine then
    self:Show(self.groupRoot)
    self.battleGroup.text = string.format(ZhString.ChangeGvgLine_Group, timeZoneLetter)
    self.gvgTime.text = GvgProxy.Instance:GetGvgStartTimeStrByTimeZoneID(timeZoneId)
    self.changeBtnLabel.text = ZhString.ChangeGvgLine_CancelChange
    self.contentInput.enabled = false
    local nextBattlelineStr, nextTimeZoneId, nextServer_id, nextBattleLineId, nextTimeZoneLetter = GuildProxy.ParseServerGroupID(guildData.next_battle_group)
    self.contentInput.value = tostring(nextBattleLineId)
  else
    self:Hide(self.groupRoot)
    self.changeBtnLabel.text = ZhString.ChangeGvgLine_ConfirmChange
    self.contentInput.enabled = true
    self.contentInput.defaultText = ZhString.ChangeGvgLine_Default
    self.contentInput.value = ""
  end
end

function ChangeGvgLineView_MultyZone:OnInputChanged()
  if self.isChangingGvGLine then
    return
  end
  local value = self.contentInput.value
  if StringUtil.IsEmpty(value) then
    self:Hide(self.groupRoot)
    return
  end
  local num = tonumber(value)
  local targetBattleLine = GvgProxy.Instance:GetServerGroupIdByBattleline(num)
  if 0 == targetBattleLine then
    self:Hide(self.groupRoot)
    return
  end
  self:Show(self.groupRoot)
  local battlelineStr, timeZoneId, server_id, battleLineId, timeZoneLetter = GuildProxy.ParseServerGroupID(targetBattleLine)
  self.battleGroup.text = string.format(ZhString.ChangeGvgLine_Group, timeZoneLetter)
  self.gvgTime.text = GvgProxy.Instance:GetGvgStartTimeStrByTimeZoneID(timeZoneId)
end
