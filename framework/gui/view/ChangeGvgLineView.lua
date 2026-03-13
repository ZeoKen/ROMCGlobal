autoImport("ChangeGuildZoneView")
ChangeGvgLineView = class("ChangeGvgLineView", ChangeGuildZoneView)

function ChangeGvgLineView:InitShow()
  self:RegistShowGeneralHelpByHelpID(32647, self.helpBtn)
  local guildData = GuildProxy.Instance.myGuildData
  self.name.text = ZhString.ChangeGvgLine_Title
  self.InputLab.text = string.format(ZhString.ChangeGvgLine_InputTip, GvgProxy.Instance:GetGroupCnt())
  self.currentZone.text = string.format(ZhString.ChangeGvgLine_Current, GuildProxy.ParseServerGroupID(guildData.battle_group))
  xdlog("当前战线", guildData.battle_group)
  if guildData.change_group_time ~= 0 then
    self.changeBtnLabel.text = ZhString.ChangeGvgLine_CancelChange
    self.contentInput.enabled = false
    self.contentInput.value = GuildProxy.ParseServerGroupID(guildData.next_battle_group)
  else
    self.changeBtnLabel.text = ZhString.ChangeGvgLine_ConfirmChange
    self.contentInput.enabled = true
    self.contentInput.defaultText = ZhString.ChangeGvgLine_Default
    self.contentInput.value = ""
  end
end

function ChangeGvgLineView:InitCost()
  self.costID = GameConfig.GvgNewConfig.change_group_cost[1][1]
  self.costNum = GameConfig.GvgNewConfig.change_group_cost[1][2]
  self.costHour = GameConfig.GvgNewConfig.change_group_time // 3600
  local itemData = Table_Item[self.costID]
  IconManager:SetItemIcon(itemData.Icon, self.costIcon)
end

function ChangeGvgLineView:ClickChangeBtn()
  if GuildProxy.Instance:IsMyGuildChangingGroup() then
    MsgManager.ConfirmMsgByID(3090, function()
      ServiceGuildCmdProxy.Instance:CallExchangeGvgGroupGuildCmd(GuildProxy.Instance.myGuildData.next_battle_group, true)
      self:CloseSelf()
    end)
    return
  end
  local value = self.contentInput.value
  local num = tonumber(value)
  if StringUtil.IsEmpty(value) then
    MsgManager.ShowMsgByID(3096)
    return
  end
  if num == GuildProxy.Instance:GetMyGuildClientGvgGroup() then
    MsgManager.ShowMsgByID(3084)
    return
  end
  local targetBattleLine = GvgProxy.Instance:GetServerGroupIdByBattleline(num)
  xdlog("当前输入线", targetBattleLine)
  if 0 == targetBattleLine then
    MsgManager.ShowMsgByID(3097)
    return
  end
  if self.ownCount < self.costNum then
    MsgManager.ShowMsgByID(3083)
    return
  end
  MsgManager.ConfirmMsgByID(2260, function()
    self:CallExchangeGvgGroupGuildCmd(num)
  end, nil, nil, tostring(num), string.format(ZhString.PeddlerShop_timeHour, self.costHour))
end

function ChangeGvgLineView:CallExchangeGvgGroupGuildCmd(num, cancel)
  if not num then
    return
  end
  local targetBattleLine = GvgProxy.Instance:GetServerGroupIdByBattleline(num)
  xdlog("CallExchangeGvgGroupGuildCmd", targetBattleLine, cancel)
  ServiceGuildCmdProxy.Instance:CallExchangeGvgGroupGuildCmd(targetBattleLine, cancel)
  self:CloseSelf()
end
