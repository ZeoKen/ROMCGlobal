TeamOptionPopUp = class("TeamOptionPopUp", ContainerView)
TeamOptionPopUp.ViewType = UIViewType.PopUpLayer
autoImport("Team_RoleCell")
local teamProxy
local defaulTeamDesc = GameConfig.Team.defaulTeamDesc or "%s副本开组"
local InputLimitMaxCount = GameConfig.System.team_desc_size or 20
local maxTeamNameLength = GameConfig.Team.maxteamnamelength or 10
local _allJoinGroup = {
  allow = SessionTeam_pb.ETEAMGROUPTYPE_ALLOW,
  refuse = SessionTeam_pb.ETEAMGROUPTYPE_REFUSE
}
local RoleBGHeight = {50, 90}

function TeamOptionPopUp:Init()
  teamProxy = TeamProxy.Instance
  if self.viewdata then
    self.goal = self.viewdata.viewdata.goal
    self.isPublish = self.viewdata.viewdata.ispublish
  end
  self:InitUI()
  self:_resetOptionChangeFlag()
  self:AddViewInterests()
end

function TeamOptionPopUp.ServerProxy()
  return ServiceSessionTeamProxy.Instance
end

function TeamOptionPopUp:InitUI()
  self.panel = self.gameObject:GetComponent(UIPanel)
  self.optionPage = self:FindGO("OptionPage")
  self.nameInput = self:FindComponent("TeamNameInput", UIInput)
  local nameObj = self:FindGO("TeamNameInput")
  self:AddSelectEvent(self.nameInput, function(go, state)
    if state and FunctionUnLockFunc.Me():ForbidInput(FunctionUnLockFunc.ClientInputForbiddenType.TeamOption_Name) then
      self.nameInput.isSelected = false
    end
  end)
  self.descInput = self:FindComponent("TeamDescInput", UIInput)
  self:AddSelectEvent(self.descInput, function(go, state)
    if state and FunctionUnLockFunc.Me():ForbidInput(FunctionUnLockFunc.ClientInputForbiddenType.TeamOption_Desc) then
      self.descInput.isSelected = false
    end
  end)
  if FunctionPerformanceSetting.CheckInputForbidden() then
    local descBoxColider = self.descInput.gameObject:GetComponent(BoxCollider)
    descBoxColider.enabled = false
    local nameBoxColider = self.nameInput.gameObject:GetComponent(BoxCollider)
    nameBoxColider.enabled = false
  end
  self.curTeamTypeLab = self:FindComponent("CurTeamTypeLab", UILabel)
  self.filterType = GameConfig.MaskWord.TeamName
  UIUtil.LimitInputCharacter(self.nameInput, maxTeamNameLength, function(str)
    local resultStr = string.gsub(str, " ", "")
    if StringUtil.ChLength(resultStr) < 2 then
      resultStr = teamProxy:IHaveTeam() and teamProxy.myTeam.name or string.format(OverSea.LangManager.Instance():GetLangByKey(ZhString.Pvp_DesertWolfJoinName), Game.Myself.data:GetName())
      MsgManager.ShowMsgByIDTable(883)
    end
    return resultStr
  end)
  UIUtil.LimitInputCharacter(self.descInput, InputLimitMaxCount, function(str)
    local resultStr = string.gsub(str, " ", "")
    if StringUtil.ChLength(resultStr) < 1 then
      resultStr = teamProxy:IHaveTeam() and teamProxy.myTeam.desc or string.format(OverSea.LangManager.Instance():GetLangByKey(ZhString.Pvp_DesertWolfJoinName), Game.Myself.data:GetName())
    end
    return resultStr
  end)
  SkipTranslatingInput(self.nameInput)
  SkipTranslatingInput(self.descInput)
  self:AddButtonEvent("ConfirmButton", function(go)
    self:ConfirmButton()
  end)
  self.minlvPopUp = self:FindComponent("MinLvPopUp", UIPopupList)
  local filtratelevel = GameConfig.Team.filtratelevel
  for i = 1, #filtratelevel do
    self.minlvPopUp:AddItem(filtratelevel[i])
  end
  self.minLvTog = self.minlvPopUp:GetComponentInChildren(UIToggle)
  self:AddClickEvent(self.minlvPopUp.gameObject, function(go)
    self:ControlTogEvt(self.minLvTog)
  end)
  EventDelegate.Add(self.minlvPopUp.onChange, function()
    if self.minlvPopUp.isOpen then
      self:ControlTogEvt(self.minLvTog)
    end
  end)
  local minLvSymbol = self:FindComponent("Symbol", TweenRotation, self.minlvPopUp.gameObject)
  EventDelegate.Set(self.minLvTog.onChange, function()
    local value = self.minLvTog.value
    if value then
      minLvSymbol:PlayForward()
    else
      minLvSymbol:PlayReverse()
    end
  end)
  local picUpMode = self:FindGO("PickUpMode")
  picUpMode:SetActive(GameConfig.SystemForbid.TeamPickUpMode == nil)
  self.pickUpModeTog_1 = self:FindComponent("PickUpMode_1", UIToggle)
  self.pickUpModeTog_2 = self:FindComponent("PickUpMode_2", UIToggle)
  self:AddClickEvent(self.pickUpModeTog_1.gameObject, function()
    self.pickUpMode = 0
  end)
  self:AddClickEvent(self.pickUpModeTog_2.gameObject, function()
    self.pickUpMode = 1
  end)
  local allowJoin = self:FindGO("AllowJoin")
  self.allowJoinTog_1 = self:FindComponent("AllowJoin", UIToggle, allowJoin)
  self.allowJoinTog_2 = self:FindComponent("ForbidJoin", UIToggle, allowJoin)
  self:AddClickEvent(self.allowJoinTog_1.gameObject, function()
    self.allowJoin = _allJoinGroup.allow
  end)
  self:AddClickEvent(self.allowJoinTog_2.gameObject, function()
    self.allowJoin = _allJoinGroup.refuse
  end)
  self.autoApplyTip = {
    [0] = ZhString.TeamOptionPopUp_AutoApplyTip1,
    [1] = ZhString.TeamOptionPopUp_AutoApplyTip2,
    [2] = ZhString.TeamOptionPopUp_AutoApplyTip3
  }
  self.autoApplyTip = self:FindComponent("AutoApplyTip", UILabel)
  self.autoApplyTip.text = ZhString.TeamOptionPopUp_AutoApply
  self.autoApplyTog_Close = self:FindComponent("Close", UIToggle, self.autoApplyTip.gameObject)
  self.autoApplyTog_All = self:FindComponent("All", UIToggle, self.autoApplyTip.gameObject)
  self.autoApplyTog_OnlyGuildFriend = self:FindComponent("OnlyGuildFriend", UIToggle, self.autoApplyTip.gameObject)
  self:AddClickEvent(self.autoApplyTog_Close.gameObject, function()
    self.autoApply = 0
  end)
  self:AddClickEvent(self.autoApplyTog_All.gameObject, function()
    self.autoApply = 1
  end)
  self:AddClickEvent(self.autoApplyTog_OnlyGuildFriend.gameObject, function()
    self.autoApply = 2
  end)
  self.autoApplyTogs = {
    [0] = self.autoApplyTog_Close,
    [1] = self.autoApplyTog_All,
    [2] = self.autoApplyTog_OnlyGuildFriend
  }
  EventDelegate.Add(self.descInput.onChange, function()
    local str = self.descInput.value
    local length = StringUtil.Utf8len(str)
    if length > InputLimitMaxCount then
      self.descInput.value = StringUtil.getTextByIndex(str, 1, InputLimitMaxCount)
      MsgManager.ShowMsgByID(28010)
    end
  end)
  self.teamRole = self:FindGO("TeamRole"):GetComponent(UILabel)
  self.teamRole.text = ZhString.TeamOptionPopUp_TeamRole
  self.roleGrid = self:FindGO("roleGrid"):GetComponent(UIGrid)
  self.roleCtrl = UIGridListCtrl.new(self.roleGrid, Team_RoleCell, "Team_RoleCell")
  local myTeam = TeamProxy.Instance.myTeam
  self:AddButtonEvent("editRoleBtn", function()
    local myTeam = TeamProxy.Instance.myTeam
    if myTeam:IsGroupTeam() then
      if myTeam:IsGroupTeamFull() then
        MsgManager.ShowMsgByID(28103)
        return
      end
    elseif myTeam:IsTeamFull() then
      MsgManager.ShowMsgByID(28103)
      return
    end
    self:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.TeamOption_SetRolePopup
    })
  end)
  self.rolebg = self:FindGO("roleBG"):GetComponent(UISprite)
end

function TeamOptionPopUp:ConfirmButton()
  local myTeam = TeamProxy.Instance.myTeam
  local name
  if self.nameInput and (not myTeam or myTeam.name ~= self.nameInput.value) then
    self:_setOptionChangeFlag()
    name = self.nameInput.value
  end
  if self.descInput then
    desc = tostring(self.descInput.value)
  end
  local changeOption = {}
  local optionStateChanged, optionChanged = false, false
  local minlv = tonumber(self.minlvPopUp.value) or 0
  if not myTeam or myTeam.minlv ~= minlv then
    self:_setOptionChangeFlag()
    self:_setStatusOptionChangeFlag()
    local minlvOption = {
      type = SessionTeam_pb.ETEAMDATA_MINLV,
      value = minlv
    }
    table.insert(changeOption, minlvOption)
  end
  if not myTeam or self.pickUpMode ~= myTeam.pickupmode then
    self:_setOptionChangeFlag()
    local pickUpOption = {
      type = SessionTeam_pb.ETEAMDATA_PICKUP_MODE,
      value = self.pickUpMode
    }
    table.insert(changeOption, pickUpOption)
  end
  if self.autoApply and self.autoApply ~= self.autoAccept then
    self:_setOptionChangeFlag()
    local autoacceptOption = {
      type = SessionTeam_pb.ETEAMDATA_AUTOACCEPT,
      value = self.autoApply
    }
    table.insert(changeOption, autoacceptOption)
  end
  if not myTeam or myTeam.desc ~= self.descInput.value then
    self:_setOptionChangeFlag()
    if self.descInput then
      local descOption = {
        type = SessionTeam_pb.ETEAMDATA_DESC,
        strvalue = self.descInput.value
      }
      table.insert(changeOption, descOption)
    end
  end
  if not myTeam or self.allowJoin ~= myTeam.allowjoin then
    self:_setOptionChangeFlag()
    local allowJoin = {
      type = SessionTeam_pb.ETEAMDATA_ALLOW_JOIN_GROUP,
      value = self.allowJoin
    }
    table.insert(changeOption, allowJoin)
  end
  local teamGoal = self.goal
  if not myTeam or myTeam.type ~= teamGoal then
    self:_setOptionChangeFlag()
    local teamGoalOption = {
      type = SessionTeam_pb.ETEAMDATA_TYPE,
      value = teamGoal
    }
    table.insert(changeOption, teamGoalOption)
  end
  if self.isPublish then
    local curState = TeamProxy.IsGroupTeamGoal(teamGoal) and SessionTeam_pb.ETEAMSTATE_PUBLISH_GROUP or SessionTeam_pb.ETEAMSTATE_PUBLISH
    if not myTeam or myTeam.state ~= curState then
      self:_setStatusOptionChangeFlag()
      local teamStateOption = {
        type = SessionTeam_pb.ETEAMDATA_STATE,
        value = curState
      }
      table.insert(changeOption, teamStateOption)
    end
  elseif self.statusOptionChange then
    local teamStateOption = {
      type = SessionTeam_pb.ETEAMDATA_STATE,
      value = SessionTeam_pb.ETEAMSTATE_FREE
    }
    table.insert(changeOption, teamStateOption)
  end
  local localDesc = desc
  if localDesc then
    localDesc = string.gsub(localDesc, " ", "")
    localDesc = string.gsub(localDesc, "·", "")
  end
  local localName = name
  if localName then
    localName = string.gsub(localName, " ", "")
    localName = string.gsub(localName, "·", "")
  end
  if localName and FunctionMaskWord.Me():CheckMaskWord(localName, self.filterType) then
    MsgManager.ShowMsgByIDTable(2604)
    return
  end
  local descMaskType = self.filterType
  if BranchMgr.IsKorea() then
    descMaskType = GameConfig.MaskWord.Chat
  end
  if FunctionMaskWord.Me():CheckMaskWord(localDesc, self.filterType) then
    MsgManager.ShowMsgByIDTable(2604)
    return
  end
  if TeamProxy.Instance:IHaveTeam() then
    if self.optionChange or self.statusOptionChange then
      MsgManager.ConfirmMsgByID(371, function()
        self.ServerProxy():CallSetTeamOption(name, changeOption)
        self:CloseUI()
      end)
    else
      self:CloseSelf()
    end
  else
    local teamState
    if self.isPublish then
      teamState = Table_TeamGoals[teamGoal].Filter == 42 and SessionTeam_pb.ETEAMSTATE_PUBLISH_GROUP or SessionTeam_pb.ETEAMSTATE_PUBLISH
    else
      teamState = SessionTeam_pb.ETEAMSTATE_FREE
    end
    local autoAccept = self.autoApply or self.autoAccept
    local allowJoinGroup = self.allowJoinTog_1.value == true and _allJoinGroup.allow or _allJoinGroup.refuse
    ServiceSessionTeamProxy.Instance:CallCreateTeam(minlv, maxlv, self.goal, autoAccept, name, teamState, localDesc, allowJoinGroup)
    self:CloseUI()
  end
end

function TeamOptionPopUp:CloseUI()
  self:CloseSelf()
  if self.isPublish then
    self:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.TeamMemberListPopUp
    })
  end
end

function TeamOptionPopUp:_resetOptionChangeFlag()
  self.optionChange, self.optionStateChanged = false, false
end

function TeamOptionPopUp:_setOptionChangeFlag(value)
  value = value or true
  local myTeam = TeamProxy.Instance.myTeam
  if nil ~= myTeam and self.optionChange ~= value then
    self.optionChange = value
  end
end

function TeamOptionPopUp:_setStatusOptionChangeFlag(value)
  if nil == value then
    value = true
  end
  local myTeam = TeamProxy.Instance.myTeam
  if nil ~= myTeam and self.statusOptionChange ~= value then
    self.statusOptionChange = value
  end
end

function TeamOptionPopUp:ControlTogEvt(tog)
  self.needCheckBounds = true
  if not tog.value then
    if self.nowCtlTog then
      self.nowCtlTog.value = false
    end
    self.nowCtlTog = tog
    tog.value = true
  else
    tog.value = false
    self.nowCtlTog = nil
  end
  return tog.value
end

function TeamOptionPopUp:ClickTarget(cellCtl)
  cellCtl:SetChoose(true)
  self.nowTarget = cellCtl.data
end

function TeamOptionPopUp:UpdateOption()
  if not teamProxy:IHaveTeam() then
    self.curTeamTypeLab.text = Table_TeamGoals[self.goal].NameZh
    self.nameInput.value = Game.Myself.data:GetName() .. GameConfig.Team.teamname
    local filterLvCfg = GameConfig.Team.filtratelevel
    self.minlvPopUp.value = filterLvCfg[1]
    self.pickUpModeTog_1.value = true
    self.pickUpModeTog_2.value = false
    self.allowJoinTog_1.value = true
    self.allowJoinTog_2.value = false
    self.autoAccept = GameConfig.Team.defaultauto
    self.curAutoApplyTog = self.autoApplyTogs[self.autoAccept]
    self.curAutoApplyTog:Set(true)
    self.descInput.value = string.format(defaulTeamDesc, Table_TeamGoals[self.goal].NameZh)
    self.pickUpMode = GameConfig.Team.pickupmode
    return
  end
  local myTeam = teamProxy.myTeam
  self.nameInput.value = myTeam.name
  self.minlvPopUp.value = tostring(myTeam.minlv)
  self.pickUpMode = myTeam.pickupmode
  self.pickUpModeTog_1.value = myTeam.pickupmode == 0
  self.pickUpModeTog_2.value = myTeam.pickupmode == 1
  self.allowJoin = myTeam.allowjoin
  if not self.allowJoin then
    self.allowJoinTog_1.value = true
    self.allowJoinTog_2.value = false
  else
    self.allowJoinTog_1.value = myTeam.allowjoin == _allJoinGroup.allow
    self.allowJoinTog_2.value = myTeam.allowjoin == _allJoinGroup.refuse
  end
  self:UpdateRoles()
  self.autoAccept = myTeam.autoaccept or GameConfig.Team.defaultauto
  self.curAutoApplyTog = self.autoApplyTogs[self.autoAccept]
  self.curAutoApplyTog:Set(true)
  self.curTeamTypeLab.text = Table_TeamGoals[self.goal].NameZh
  local teamDesc = self.isPublish and string.format(defaulTeamDesc, Table_TeamGoals[self.goal].NameZh) or myTeam.desc
  if not StringUtil.IsEmpty(teamDesc) then
    if string.sub(teamDesc, 1, 2) == "##" then
      self.descInput.value = OverSea.LangManager.Instance():GetLangByKey(teamDesc)
    else
      self.descInput.value = teamDesc
    end
  else
    self.descInput.value = OverSea.LangManager.Instance():GetLangByKey(ZhString.TeamMemberListPopUp_Free)
  end
end

function TeamOptionPopUp:AddViewInterests()
  self:AddDispatcherEvt(ServiceEvent.SessionTeamMemberDataUpdate, self.UpdateRoles)
  self:AddListenEvt(ServiceEvent.SessionTeamQueryMemberTeamCmd, self.UpdateRoles)
end

function TeamOptionPopUp:UpdateRoles()
  redlog("UpdateRoles")
  local myTeam = teamProxy.myTeam
  local role = myTeam:GetRoles()
  if teamProxy:IHaveGroup() then
    local uniteGroupTeam = teamProxy.uniteGroupTeam
    local role2 = uniteGroupTeam:GetRoles()
    for i = 1, #role2 do
      table.insert(role, role2[i])
    end
    self.rolebg.height = RoleBGHeight[2]
  else
    self.rolebg.height = RoleBGHeight[1]
  end
  self.roleCtrl:ResetDatas(role)
  local cells = self.roleCtrl:GetCells()
  if cells then
    for i = 1, #cells do
      cells[i]:SetScale(0.45, 0.5)
    end
  end
end

function TeamOptionPopUp:OnEnter()
  TeamOptionPopUp.super.OnEnter(self)
  TimeTickManager.Me():CreateTick(0, 500, self.checkSelect, self)
  self:UpdateOption()
end

function TeamOptionPopUp:checkSelect()
  if not self.needCheckBounds then
    return
  end
  if self.minlvPopUp.isOpen then
    local obj = self:FindGO("Drop-down List")
    local success = self.panel:ConstrainTargetToBounds(obj.transform, true)
    if success then
      self.needCheckBounds = false
    end
  end
end

function TeamOptionPopUp:OnExit()
  self.minlvPopUp = nil
  self.minLvTog = nil
  self.descInput = nil
  TeamOptionPopUp.super.OnExit(self)
end
