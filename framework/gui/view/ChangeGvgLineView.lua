autoImport("ChangeGuildZoneView")
ChangeGvgLineView = class("ChangeGvgLineView", ChangeGuildZoneView)

function ChangeGvgLineView:InitShow()
  local guildData = GuildProxy.Instance.myGuildData
  self.name.text = string.format(ZhString.ChangeGuildZone_Name, guildData.name)
  self.currentZone.text = string.format(ZhString.ChangeGvgLine_Current, GvgProxy.ClientGroupId(guildData.battle_group))
  xdlog("当前战线", guildData.battle_group)
  if guildData.change_group_time ~= 0 then
    self.changeBtnLabel.text = ZhString.ChangeGvgLine_CancelChange
    self.contentInput.enabled = false
    self.contentInput.value = GvgProxy.ClientGroupId(guildData.next_battle_group)
  else
    self.changeBtnLabel.text = ZhString.ChangeGvgLine_ConfirmChange
    self.contentInput.enabled = true
    self.contentInput.value = ""
  end
  self.tip.text = ZhString.ChangeGvgLine_ChangeTip
end

function ChangeGvgLineView:ClickChangeBtn()
  local value = self.contentInput.value
  local num = tonumber(value)
  if GuildProxy.Instance.myGuildData.change_group_time == 0 then
    if value == "" then
      MsgManager.ShowMsgByID(3096)
      return
    end
    if num == GvgProxy.ClientGroupId(GuildProxy.Instance.myGuildData.battle_group) then
      MsgManager.ShowMsgByID(3084)
      return
    end
    local targetBattleLine = GvgProxy.Instance:GetServerGroupId(num)
    xdlog("当前输入线", targetBattleLine)
    if not GvgProxy.Instance:CheckGroupValid(num) then
      MsgManager.ShowMsgByID(3097)
      return
    end
    local cost = GameConfig.GvgNewConfig and GameConfig.GvgNewConfig.change_group_cost
    for i = 1, #cost do
      local itemid = cost[i][1]
      local num = cost[i][2]
      local count = GuildProxy.Instance:GetGuildPackItemNumByItemid(itemid)
      if num > count then
        MsgManager.ShowMsgByID(3083)
        return
      end
    end
    self:CallExchangeGvgGroupGuildCmd(num)
  else
    MsgManager.ConfirmMsgByID(3090, function()
      self:CallExchangeGvgGroupGuildCmd(num, true)
    end)
  end
end

function ChangeGvgLineView:CallExchangeGvgGroupGuildCmd(num, cancel)
  if not num then
    return
  end
  local targetBattleLine = GvgProxy.Instance:GetServerGroupId(num)
  xdlog("CallExchangeGvgGroupGuildCmd", targetBattleLine, cancel)
  ServiceGuildCmdProxy.Instance:CallExchangeGvgGroupGuildCmd(targetBattleLine, cancel)
  self.container:CloseSelf()
end
