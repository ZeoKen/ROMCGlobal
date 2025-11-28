TeamFindPopUp = class("TeamFindPopUp", ContainerView)
TeamFindPopUp.ViewType = UIViewType.NormalLayer
autoImport("TeamCell")
autoImport("TeamGoalCombineCell")
autoImport("TeamGoalGroupCell")
local COLOR_GRAY = ColorUtil.TitleGray
local COLOR_BLUE = ColorUtil.TitleBlue
local RED_FORMAT = "[c][FF0000]%s[-][/c]"
local Blue_FORMAT = "[c][8FC0E7]%s[-][/c]"
local PublishGoal = GameConfig.Team.publish_goal
local _TeamProxy

function TeamFindPopUp:Init()
  _TeamProxy = TeamProxy.Instance
  _TeamProxy:InitTeamGoals()
  self:InitUI()
  self:AddEvts()
  self:AddViewInerest()
end

function TeamFindPopUp:InitUI()
  self.filter = self:FindComponent("LevelPopUpFilter", UIPopupList)
  self.createTeamBtn = self:FindGO("CreateTeamButton")
  self.createTeamBtn:SetActive(not _TeamProxy:IHaveTeam())
  self.applyCtLab = self:FindComponent("ApplyCount", UILabel)
  self.goalScrollView = self:FindComponent("GoalsScrollView", UIScrollView)
  local minlvOption = {0}
  local filterlvConfig = GameConfig.Team.filtratelevel
  local mylv = Game.Myself.data.userdata:Get(UDEnum.ROLELEVEL)
  for i = 1, #filterlvConfig do
    if mylv >= filterlvConfig[i] then
      table.insert(minlvOption, filterlvConfig[i])
    end
  end
  for i = 1, #minlvOption do
    local minlv = minlvOption[i]
    if minlv == 0 then
      self.filter:AddItem(ZhString.TeamFindPopUp_NoneFilterLevel, 0)
    else
      self.filter:AddItem(string.format(ZhString.TeamFindPopUp_StartLevel, minlv), minlv)
    end
  end
  self.filterlevel = 0
  self.filterzone = 0
  EventDelegate.Add(self.filter.onChange, function()
    if self.filterlevel ~= self.filter.data then
      self.filterlevel = self.filter.data
      self:CallTeamList(1, true)
    end
  end)
  self.currentGroupCell = self:FindGO("CurrentGroupCell")
  self.currentGroupCellCtrl = TeamGoalGroupCell.new(self.currentGroupCell)
  self:AddClickEvent(self.currentGroupCell, function()
    self:SetGroupView()
  end)
  self.goalsView = self:FindGO("GoalsScrollView")
  self.goalsScrollView = self.goalsView:GetComponent(UIScrollView)
  local goalslist = self:FindGO("GoalsTabel", self.goalsView):GetComponent(UITable)
  self.goalListCtl = UIGridListCtrl.new(goalslist, TeamGoalCombineCell, "TeamGoalCombineCell")
  self.goalListCtl:AddEventListener(MouseEvent.MouseClick, self.ClickGoal, self)
  self.groupsView = self:FindGO("GroupScrollView")
  self.groupScrollView = self.groupsView:GetComponent(UIScrollView)
  local groupslist = self:FindGO("GroupsTabel", self.groupsView):GetComponent(UITable)
  self.groupCtl = UIGridListCtrl.new(groupslist, TeamGoalGroupCell, "TeamGoalGroupCell")
  self.groupCtl:AddEventListener(MouseEvent.MouseClick, self.ClickGroup, self)
  self.teamTable = self:FindComponent("TeamList", UITable)
  self.teamListCtl = UIGridListCtrl.new(self.teamTable, TeamCell, "TeamCell")
  self.noteamtip = self:FindGO("NoTeamTip")
  self.scrollView = self:FindComponent("TeamsScroll", UIScrollView)
  self.scrollView.momentumAmount = 100
  NGUIUtil.HelpChangePageByDrag(self.scrollView, function()
    if self.nowPage then
      local page = math.max(self.nowPage - 1, 1)
      self:CallTeamList(page)
    end
  end, function()
    if self.nowPage then
      local page = self.nowPage + 1
      if self.maxPage then
        page = math.min(self.maxPage, page)
      end
      self:CallTeamList(page)
    end
  end, 120)
  self.createTeamBtn = self:FindGO("CreateTeamButton")
  self.normalPos = self:FindGO("NormalPos")
end

function TeamFindPopUp:AddEvts()
  self:AddClickEvent(self.createTeamBtn, function(go)
    self:CreateTeam()
  end)
  local refreshButton = self:FindGO("RefreshButton")
  self:AddClickEvent(refreshButton, function(go)
    local now = UnityUnscaledTime
    if self._refreshTime == nil or now - self._refreshTime >= 3 then
      self._refreshTime = now
      self:ResetTeamMembers()
      self:CallTeamList(1, true)
    else
      MsgManager.ShowMsgByID(3210)
    end
  end)
  local inviteMemberButton = self:FindGO("InviteMemberButton")
  self:AddClickEvent(inviteMemberButton, function(go)
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.TeamInvitePopUp
    })
  end)
  self.publishBtn = self:FindGO("PublishBtn")
  self.noServerMergeTip = self:FindGO("NoServerMergeTip")
  self:RegistShowGeneralHelpByHelpID(100, self.noServerMergeTip)
  self.publishSprite = self:FindComponent("Bg", UISprite, self.publishBtn)
  self.publishLab = self:FindComponent("Label", UILabel, self.publishBtn)
  self:AddClickEvent(self.publishBtn, function(go)
    if self.noServerMerge then
      return
    end
    if not self.goal then
      MsgManager.ShowMsgByID(360)
      return
    end
    local nextGoal = self.goal + 1
    local nextGoalCfg = Table_TeamGoals[nextGoal]
    nextGoalType = nextGoalCfg and nextGoalCfg.type
    local goalCfg = Table_TeamGoals[self.goal]
    local goalType = goalCfg and goalCfg.type
    if not goalCfg then
      MsgManager.ShowMsgByID(28106)
      return
    end
    if goalType and nextGoalType and goalType == self.goal and nextGoalType == goalType then
      MsgManager.ShowMsgByID(360)
      return
    end
    local lvLimited = goalCfg.Level or 1
    local myLv = MyselfProxy.Instance:RoleLevel()
    if lvLimited > myLv then
      MsgManager.ShowMsgByID(28105, lvLimited)
      return
    end
    if _TeamProxy:IHaveTeam() then
      local md = _TeamProxy.myTeam:GetMembersListExceptMe()
      for i = 1, #md do
        if lvLimited > md[i].baselv then
          MsgManager.ShowMsgByID(28105, lvLimited)
          return
        end
      end
    end
    if _TeamProxy:IHaveGroup() then
      local uniteteam = _TeamProxy:GetGroupUniteTeamData()
      if uniteteam then
        local list = uniteteam:GetMembersList()
        for k, v in pairs(list) do
          if lvLimited > v.baselv then
            MsgManager.ShowMsgByID(28105, lvLimited)
            return
          end
        end
      end
    end
    FunctionTeam.Me():OnClickPublish(self.goal)
  end)
end

function TeamFindPopUp:AddToggleChange(toggle, handler, param)
  EventDelegate.Add(toggle.onChange, function()
    local label = toggle.gameObject:GetComponent(UILabel)
    if toggle.value then
      label.color = COLOR_BLUE
      if handler ~= nil then
        handler(self, param)
      end
    else
      label.color = COLOR_GRAY
    end
  end)
end

function TeamFindPopUp:CallTeamList(page, init)
  if init then
    self.prePage = nil
    self.nowPage = 1
  else
    self.prePage = self.nowPage
    self.nowPage = page
  end
  ServiceSessionTeamProxy:CallTeamList(self.goal, self.nowPage, self.filterlevel, self.filterzone, self.currentGroup or 0)
end

function TeamFindPopUp:OnEnter()
  TeamFindPopUp.super.OnEnter(self)
  self.publishBtn:SetActive(_TeamProxy:IHaveTeam())
  self:SetGroupView()
  local cells = self.groupCtl:GetCells()
  if cells then
    cells[1]:SetChoose(true)
  end
end

function TeamFindPopUp:HandleApplyCt()
  local leftCt = GameConfig.Team.maxapplycount - _TeamProxy:GetUserApplyCt()
  self.applyCtLab.text = string.format(ZhString.TeamFindPopUp_ApplyFormat, leftCt, GameConfig.Team.maxapplycount)
  local cells = self.teamListCtl:GetCells()
  for i = 1, #cells do
    if cells[i].data then
      local ctDate = _TeamProxy:GetUserApply(cells[i].data.id)
      ctDate = ctDate and ctDate.createtime
      cells[i]:CountDown(ctDate)
    end
  end
end

function TeamFindPopUp:GetTeamCell(id)
  local cells = self.teamListCtl:GetCells()
  local uniteTeamid = _TeamProxy:GetUniteTeamid(id)
  for i = 1, #cells do
    if cells[i].data.id == id or uniteTeamid and uniteTeamid == cells[i].data.id then
      return cells[i]
    end
  end
end

local defaulTeamDesc = GameConfig.Team.defaulTeamDesc or "%s副本开组"

function TeamFindPopUp:CreateTeam(state)
  local teamState = state or SessionTeam_pb.ETEAMSTATE_FREE
  local teamDesc = ""
  local defaultname = Game.Myself.data.name .. GameConfig.Team.teamname
  local filterType = GameConfig.MaskWord.TeamName
  local accept = self.accept or GameConfig.Team.defaultauto
  if FunctionMaskWord.Me():CheckMaskWord(defaultname, filterType) then
    defaultname = Game.Myself.data.name .. "_" .. GameConfig.Team.teamname
  end
  local filtratelevel = GameConfig.Team.filtratelevel
  local defaultMinlv, defaultMaxlv = filtratelevel[1], filtratelevel[#filtratelevel]
  local goal = state == nil and GameConfig.Team.defaulttype or self.goal
  local typeName = Table_TeamGoals[goal].NameZh
  typeName = OverSea.LangManager.Instance():GetLangByKey(typeName)
  teamDesc = goal == GameConfig.Team.defaulttype and typeName or string.format(defaulTeamDesc, typeName)
  if goal then
    local goalData = Table_TeamGoals[goal]
    if goalData and goalData.SetShow == 0 then
      if goalData.Filter == 10 then
        goal = 10010
      elseif goalData.SetShow == 0 then
        goal = goalData.type
      end
    end
  end
  if BranchMgr.IsSEA() or BranchMgr.IsNA() or BranchMgr.IsEU() then
    defaultname = defaultname:gsub(" ", ""):gsub("%(", ""):gsub("%)", "")
    teamDesc = teamDesc:gsub(" ", ""):gsub("%(", ""):gsub("%)", "")
  end
  ServiceSessionTeamProxy:CallCreateTeam(defaultMinlv, defaultMaxlv, goal, accept, defaultname, teamState, teamDesc)
end

function TeamFindPopUp:_resetCurCombine()
  if self.combineGoal then
    self.combineGoal:SetChoose(false)
    self.combineGoal:SetFolderState(false)
    self.combineGoal = nil
  end
end

function TeamFindPopUp:ResetTeamMembers()
  local cells = self.teamListCtl:GetCells()
end

function TeamFindPopUp:ClickGoal(parama)
  self:ResetTeamMembers()
  if "Father" == parama.type then
    local combine = parama.combine
    if combine == self.combineGoal then
      combine:PlayReverseAnimation()
      self.fatherGoalId = combine.data.fatherGoal.id
      self.goal = self.fatherGoalId
      self:_resetRootRaid()
      return
    end
    self:_resetCurCombine()
    self.combineGoal = combine
    self.combineGoal:PlayReverseAnimation()
    self.fatherGoalId = combine.data.fatherGoal.id
    self.goal = self.fatherGoalId
  elseif parama.child and parama.child.data then
    self.goal = parama.child.data.id
  else
    self.goal = self.fatherGoalId
  end
  self.currentGroup = 0
  self:CallTeamList(1, true)
  self.publishBtn:SetActive(_TeamProxy:IHaveTeam())
  self:ResetPublishStatus()
end

function TeamFindPopUp:ClickGroup(cell)
  if not cell then
    return
  end
  self.currentGroup = cell and cell.groupid or 0
  self.goal = 0
  if cell.groupid == 0 then
    self:CallTeamList(1, true)
    return
  end
  self:CallTeamList(1, true)
  self:SetGoal()
end

function TeamFindPopUp:SetGoal()
  if not self.currentGroup then
    return
  end
  if self.viewdata and self.viewdata.viewdata then
    self.startGoal = self.viewdata.viewdata.goalid
  else
    self.startGoal = GameConfig.Team.defaultQueryType
  end
  self.currentGroupCell:SetActive(true)
  self.currentGroupCellCtrl:SetData({
    groupid = self.currentGroup,
    NameZh = PublishGoal[self.currentGroup]
  })
  self.goalsView:SetActive(true)
  self.groupsView:SetActive(false)
  self.goalScrollView:ResetPosition()
  self:_resetCurCombine()
  local goals = _TeamProxy:GetTeamGoals(self.currentGroup)
  table.sort(goals, function(a, b)
    return a.fatherGoal.id < b.fatherGoal.id
  end)
  self.goalListCtl:ResetDatas(goals)
  local goalCells = self.goalListCtl:GetCells()
  if goalCells and 0 < #goalCells then
    for i = 1, #goalCells do
      local goalData = goalCells[i].data
      if goalData and goalData.fatherGoal.id == self.startGoal then
        goalCells[i]:ClickFather()
        break
      end
    end
  end
end

function TeamFindPopUp:SetGroupView()
  self.currentGroupCell:SetActive(false)
  self.goalsView:SetActive(false)
  self.groupsView:SetActive(true)
  local groups = _TeamProxy:GetGroupGoals()
  self.groupCtl:ResetDatas(groups)
  self:ClickGroup({groupid = 0})
end

local _publishCFG = {
  Color(0.11372549019607843, 0.17647058823529413, 0.4627450980392157, 1),
  Color(0.5, 0.5, 0.5, 1),
  "com_btn_1",
  "com_btn_13"
}

function TeamFindPopUp:ResetPublishStatus()
  local goal_StaticData = self.goal and Table_TeamGoals[self.goal]
  if not goal_StaticData or not goal_StaticData.RaidID then
    self.noServerMergeTip:SetActive(false)
  else
    local raidServerMerge = _TeamProxy:CheckRaidIdSupportDiffServer(goal_StaticData.RaidID) and goal_StaticData.NoServerMerge ~= 1
    local curIsMergeServer = ChangeZoneProxy.Instance:CheckCurIsMergeServer()
    local noServerMerge = not curIsMergeServer or not raidServerMerge
    self.noServerMerge = noServerMerge and _TeamProxy:CheckHasDiffServerMember(true)
    self.noServerMergeTip:SetActive(self.noServerMerge)
    self.publishSprite.spriteName = self.noServerMerge and _publishCFG[4] or _publishCFG[3]
    self.publishLab.effectColor = self.noServerMerge and _publishCFG[2] or _publishCFG[1]
  end
end

function TeamFindPopUp:_resetRootRaid()
  if TeamProxy.AllTeamType == self.goal then
    return
  end
end

function TeamFindPopUp:AddViewInerest()
  self:AddListenEvt(ServiceEvent.SessionTeamTeamList, self.HandleUpdateTeamList)
  self:AddListenEvt(ServiceEvent.SessionTeamEnterTeam, self.HandleEnterTeam)
  self:AddListenEvt(ServiceEvent.SessionTeamUserApplyUpdateTeamCmd, self.HandleApplyCt)
  self:AddListenEvt(ServiceEvent.SessionTeamMyGroupApplyUpdateTeamCmd, self.HandleApplyCt)
  self:AddListenEvt(ServiceEvent.SessionTeamExitTeam, self.HandleExitTeam)
  self:AddListenEvt(ServiceEvent.SessionTeamTeamDataUpdate, self.UpdateTeamData)
end

function TeamFindPopUp:HandleExitTeam()
  self:CloseSelf()
end

function TeamFindPopUp:HandleEnterTeam(note)
  self:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.TeamMemberListPopUp
  })
end

function TeamFindPopUp:HandleUpdateTeamList()
  local datas = _TeamProxy:GetAroundTeamList() or {}
  if self.prePage then
    if 0 < #datas then
      if self.nowPage < self.prePage then
        for i = #datas, 1, -1 do
          self.teamListCtl:AddCell(datas[i], 1)
        end
      elseif self.prePage < self.nowPage then
        for i = 1, #datas do
          self.teamListCtl:AddCell(datas[i])
        end
      end
      self.teamListCtl:Layout()
    else
      self.nowPage = self.prePage
      self.maxPage = self.nowPage
    end
  elseif self.nowPage then
    self.teamListCtl:ResetDatas(datas)
    self.teamListCtl:Layout()
    self.scrollView:ResetPosition()
  end
  self.noteamtip:SetActive(#self.teamListCtl:GetCells() == 0)
  self:HandleApplyCt()
end

function TeamFindPopUp:CheckShowEnterBtn()
  if TeamProxy.IsExpRaid(self.goal) then
    return true
  end
  return false
end

function TeamFindPopUp:UpdateTeamData()
  local myTeam = TeamProxy.Instance.myTeam
  if myTeam and (myTeam.state == SessionTeam_pb.ETEAMSTATE_PUBLISH or myTeam.state == SessionTeam_pb.ETEAMSTATE_PUBLISH_GROUP) then
    self:ResetTeamMembers()
    self:CallTeamList(1, true)
  end
end

function TeamFindPopUp:OnExit()
  TeamFindPopUp.super.OnExit(self)
  if self.teamListCtl then
    self.teamListCtl:RemoveAll()
  end
  _TeamProxy:ClearTeamMembers()
end
