autoImport("TeamPwsMemberCell")
autoImport("TeamPwsRankPopUp")
autoImport("UILabelScrollCtrl")
autoImport("CupModeForbiddenPro")
TeamPwsView = class("TeamPwsView", SubView)
local teamPwsView_Path = ResourcePathHelper.UIView("TeamPwsView")
TeamPwsView.TexUp = "pvp_bg_06"
TeamPwsView.TexSeason = "pvp_icon_season_1"
local _cellName = "CupModeForbiddenPro"
local _cellSize = 0.4
local T_PVP_TYPE

function TeamPwsView:Init()
  local roomID, pwsConfig = next(GameConfig.PvpTeamRaid)
  self.pwsConfig = pwsConfig
  self.roomID = roomID
  T_PVP_TYPE = PvpProxy.Type.TeamPws
  self:FindObjs()
  self:AddBtnEvts()
  self:AddViewEvts()
  self:InitShow()
end

function TeamPwsView:FindObjs()
  self:LoadSubView()
  self.memberPanel = self:FindComponent("MemberScrollView", UIPanel, self.objRoot)
  self.memberScrollView = self:FindComponent("MemberScrollView", UIScrollView, self.objRoot)
  local gridMember = self:FindComponent("memberGrid", UIGrid, self.objRoot)
  self.listMember = UIGridListCtrl.new(gridMember, TeamPwsMemberCell, "TeamPwsMemberCell")
  self.labFightCount = self:FindComponent("labFightCount", UILabel, self.objRoot)
  self.labFightCountInfo = self:FindComponent("labFightCountInfo", UILabel, self.objRoot)
  self.labEventCountDown = self:FindComponent("labEventCountDown", UILabel, self.objRoot)
  self.fightCountPanel = self:FindComponent("fightCountPanel", UIPanel, self.objRoot)
  self.labelScrollCtl = UILabelScrollCtrl.new(self.fightCountPanel, self.labFightCountInfo, 10000, 5000)
  self.fightBg = self:FindComponent("FightBG", UISprite, self.objRoot)
  self.objMyLevel = self:FindGO("sprLabMyLevel", self.objRoot)
  self.labMyScore = self:FindComponent("labMyScore", UILabel, self.objRoot)
  self.labTeamScore = self:FindComponent("labTeamScore", UILabel, self.objRoot)
  self.sprPwsCoin = self:FindComponent("sprPwsCoin", UISprite)
  self.labPwsCoin = self:FindComponent("labPwsCoin", UILabel)
  self.objLowLevel = self:FindGO("labLowLevel", self.objRoot)
  self.objEmptyTeam = self:FindGO("EmptyTeam", self.objRoot)
  self.objBtnMatch = self:FindGO("MatchBtn", self.objRoot)
  self.colBtnMatch = self.objBtnMatch:GetComponent(BoxCollider)
  self.sprBtnMatch = self:FindComponent("BG", UISprite, self.objBtnMatch)
  self.objEnableMatchBtnLabel = self:FindGO("enableLabel", self.objBtnMatch)
  self.objDisableMatchBtnLabel = self:FindGO("disableLabel", self.objBtnMatch)
  if GameConfig.PvpTeamRaidPublic and GameConfig.PvpTeamRaidPublic.CoinItemID then
    self:FindGO("PwsCoin"):SetActive(true)
  else
    self:FindGO("PwsCoin"):SetActive(false)
  end
  local proPrefab = self:_loadForbiddenProPfb()
  self.forbiddenPro = CupModeForbiddenPro.new(proPrefab)
  self:_initDiffServerMatch()
end

function TeamPwsView:_loadForbiddenProPfb()
  local cellpfb = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell(_cellName))
  if nil == cellpfb then
    redlog("can not find cellpfb", _cellName)
    return
  end
  cellpfb.transform:SetParent(self.objRoot.transform, false)
  cellpfb.transform.localScale = LuaGeometry.GetTempVector3(_cellSize, _cellSize, _cellSize)
  return cellpfb
end

function TeamPwsView:_initDiffServerMatch()
  self.onlyMatchMyServerObj = self:FindGO("OnlyMatchMyServer", self.objRoot)
  self.onlyMatchMyServerTog = self:FindComponent("Tog", UIToggle, self.onlyMatchMyServerObj)
  self.onlyMatchMyServerLab = self:FindComponent("Label", UILabel, self.onlyMatchMyServerObj)
  self.onlyMatchMyServerLab.text = ZhString.TeamFindPopUp_OnlyMatchMyServer
  local defaultTogValue = TeamProxy.Instance:GetDiffServerChooseStatus(T_PVP_TYPE)
  self.onlyMatchMyServerTog.value = defaultTogValue
  self.onlyMatchMyServerTip = self:FindGO("Tip", self.onlyMatchMyServerObj)
  self:RegistShowGeneralHelpByHelpID(101, self.onlyMatchMyServerTip)
end

function TeamPwsView:SupportDiffServer()
  return not ISNoviceServerType
end

function TeamPwsView:LoadSubView()
  self.objRoot = self:FindGO("TeamPwsSubView")
  local obj = self:LoadPreferb_ByFullPath(teamPwsView_Path, self.objRoot, true)
  obj.name = "TeamPwsSubView"
end

function TeamPwsView:AddBtnEvts()
  self:AddClickEvent(self:FindGO("RankBtn", self.objRoot), function()
    self:ClickButtonRank()
  end)
  self:AddClickEvent(self:FindGO("RewardBtn", self.objRoot), function()
    self:ClickButtonReward()
  end)
  self:AddClickEvent(self.objBtnMatch, function()
    self:ClickButtonMatch()
  end)
end

function TeamPwsView:AddViewEvts()
  self:AddListenEvt(LoadSceneEvent.FinishLoad, self.UpdateMatchButton)
  self:AddListenEvt(ServiceEvent.MatchCCmdNtfMatchInfoCCmd, self.UpdateMatchButton)
  self:AddListenEvt(ServiceEvent.MatchCCmdQueryTeamPwsTeamInfoMatchCCmd, self.HandleQueryTeamPwsTeamInfo)
  self:AddListenEvt(ServiceEvent.SessionTeamEnterTeam, self.UpdateMemberInfosAndScore)
  self:AddListenEvt(TeamEvent.MemberEnterTeam, self.UpdateMemberInfosAndScore)
  self:AddListenEvt(ServiceEvent.SessionTeamMemberDataUpdate, self.UpdateMemberInfosOnly)
  self:AddListenEvt(TeamEvent.MemberExitTeam, self.UpdateMemberInfosOnly)
  self:AddListenEvt(ServiceEvent.SessionTeamExitTeam, self.UpdateMemberInfosOnly)
  self:AddListenEvt(ServiceEvent.ActivityCmdStartActCmd, self.UpdateView)
  self:AddListenEvt(ServiceEvent.ActivityCmdStopActCmd, self.UpdateView)
  self.listMember:AddEventListener(MouseEvent.MouseClick, self.ClickTeamMember, self)
end

function TeamPwsView:InitShow()
  self.texSeason = self:FindComponent("texSeason", UITexture, self.objRoot)
  self.texSeason:MakePixelPerfect()
  self.sprLabMyLevel = SpriteLabel.new(self.objMyLevel, nil, 42, 35, true)
end

function TeamPwsView:UpdateMatchButton()
  local btnMatchEnable = FunctionActivity.Me():IsActivityRunning(self.pwsConfig.ActivityID)
  if btnMatchEnable then
    local matchStatus = PvpProxy.Instance:GetMatchState(T_PVP_TYPE)
    local freeBattleMatchStatus = PvpProxy.Instance:GetMatchState(PvpProxy.Type.FreeBattle)
    if matchStatus and matchStatus.ismatch or freeBattleMatchStatus and freeBattleMatchStatus.ismatch or TeamPwsView.InOtherGameMode() or PvpProxy.Instance.inviteMap then
      btnMatchEnable = false
    end
  end
  self.colBtnMatch.enabled = btnMatchEnable
  if btnMatchEnable then
    self:SetTextureWhite(self.sprBtnMatch)
  else
    self:SetTextureGrey(self.sprBtnMatch)
  end
  self.objEnableMatchBtnLabel:SetActive(btnMatchEnable)
  self.objDisableMatchBtnLabel:SetActive(not btnMatchEnable)
  self.btnMatchEnable = btnMatchEnable
  TeamProxy.Instance:SetDiffServerJoinRoomStatus(self.onlyMatchMyServerObj, self.onlyMatchMyServerTog, self.onlyMatchMyServerTip, self:SupportDiffServer())
end

function TeamPwsView.InOtherGameMode()
  return Game.MapManager:IsPVPMode_TeamPws() or Game.MapManager:IsPVEMode_HeadwearRaid()
end

function TeamPwsView:UpdateMemberInfosAndScore()
  self:UpdateMemberInfos(true)
end

function TeamPwsView:UpdateMemberInfosOnly()
  self:UpdateMemberInfos(false)
end

function TeamPwsView:UpdateMemberInfos(refreshScore)
  if TeamProxy.Instance:IHaveTeam() then
    self.objEmptyTeam:SetActive(false)
    local isLowLevel = false
    local memberlst = TeamProxy.Instance.myTeam:GetPlayerMemberList(true, true)
    local member
    for i = 1, #memberlst do
      member = memberlst[i]
      if member.baselv < self.pwsConfig.RequireLv then
        isLowLevel = true
        break
      end
      self.labTeamScore.gameObject:SetActive(not isLowLevel)
      self.objLowLevel:SetActive(isLowLevel)
    end
    self.listMember:ResetDatas(memberlst)
    for i = #memberlst + 1, GameConfig.Team.maxmember do
      self.listMember:AddCell(MyselfTeamData.EMPTY_STATE, i)
    end
    self.listMember:Layout()
    self:UpdateTeamScoreInfo()
  else
    self.listMember:RemoveAll()
    self.objEmptyTeam:SetActive(true)
    self.labTeamScore.gameObject:SetActive(false)
    self.objLowLevel:SetActive(Game.Myself.data.userdata:Get(UDEnum.ROLELEVEL) < self.pwsConfig.RequireLv)
  end
  self.memberScrollView:ResetPosition()
  if refreshScore then
    ServiceMatchCCmdProxy.Instance:CallQueryTeamPwsTeamInfoMatchCCmd()
  end
end

function TeamPwsView:HandleQueryTeamPwsTeamInfo(note)
  local serverData = note.body
  self.myRank = serverData.myrank
  self.nextOpenTime = serverData.opentime
  self:ClearMemberScoreInfos()
  self.memberScoreInfos = ReusableTable.CreateArray()
  local serverUserInfos = serverData.userinfos
  local singleServerInfo, singleClientInfo
  for i = 1, #serverUserInfos do
    singleServerInfo = serverUserInfos[i]
    singleClientInfo = ReusableTable.CreateTable()
    singleClientInfo.charid = singleServerInfo.charid
    singleClientInfo.score = singleServerInfo.score
    singleClientInfo.erank = singleServerInfo.erank
    self.memberScoreInfos[#self.memberScoreInfos + 1] = singleClientInfo
  end
  self:UpdateTeamScoreInfo()
  self:UpdateLeftTime()
  self:UpdateMatchButton()
  local curSeason = serverData.season or 1
  if curSeason then
    PictureManager.Instance:SetPVP("pvp_icon_season_" .. curSeason, self.texSeason)
  end
  local invalidPro = PvpProxy.Instance.teamPwsSeasonForbiddenPro
  self.forbiddenPro:SetData(invalidPro)
  if invalidPro and 0 < #invalidPro then
    self:ResizeMemberScrollView(2)
  else
    self:ResizeMemberScrollView(1)
  end
end

local memberSVParam = {
  [1] = {offsetY = -19, height = 300},
  [2] = {offsetY = 0, height = 260}
}

function TeamPwsView:ResizeMemberScrollView(type)
  local param = memberSVParam[type]
  if not param then
    return
  end
  local clip = self.memberPanel.baseClipRegion
  local pos = self.memberPanel.gameObject.transform.localPosition
  local targetOffsetY = param.offsetY - pos.y
  self.memberPanel.clipOffset = LuaGeometry.GetTempVector2(self.memberPanel.clipOffset.x, targetOffsetY)
  self.memberPanel.baseClipRegion = LuaGeometry.GetTempVector4(clip.x, clip.y, clip.z, param.height)
end

function TeamPwsView:UpdateTeamScoreInfo()
  if not self.memberScoreInfos or not self.myRank then
    return
  end
  local allScore, memberNum, minScore = 0, 0, -1
  local myID = Game.Myself.data.id
  local cells = self.listMember:GetCells()
  local data, cell
  for i = 1, #self.memberScoreInfos do
    data = self.memberScoreInfos[i]
    if data.charid == myID then
      self.sprLabMyLevel:Reset()
      if data.erank ~= MatchCCmd_pb.ETEAMPWSRANK_NONE then
        local iconName = string.format("ui_teampvp_lv%s", data.erank)
        local myLevelInfo = string.format(ZhString.TeamPws_MyLevel, string.format("{uiicon=%s}", iconName))
        if self.myRank and 0 ~= self.myRank then
          myLevelInfo = string.format("%s  %s", myLevelInfo, self.myRank)
        end
        self.sprLabMyLevel:SetText(myLevelInfo, true)
      else
        self.sprLabMyLevel:SetText(string.format(ZhString.TeamPws_MyLevel, self.myRank and self.myRank ~= 0 and self.myRank or "-"), true)
      end
      self.labMyScore.text = string.format(ZhString.TeamPws_MyScore, data.score)
      if not TeamProxy.Instance:IHaveTeam() then
        return
      end
    end
    for j = 1, #cells do
      cell = cells[j]
      if data.charid == cell.charID then
        local tempScore = data.score
        if 3000 < tempScore then
          tempScore = 3000 + (tempScore - 3000) * 10
        end
        if minScore < 0 or minScore > tempScore then
          minScore = tempScore
        end
        allScore = allScore + math.pow(tempScore, 2)
        memberNum = memberNum + 1
        cell:SetScore(data)
        break
      end
    end
  end
  if 1 < memberNum then
    allScore = allScore - math.pow(minScore, 2)
    memberNum = memberNum - 1
  end
  allScore = math.sqrt(allScore / memberNum)
  if 3000 < allScore then
    allScore = 3000 + (allScore - 3000) / 10
  end
  allScore = math.floor(allScore)
  self.labTeamScore.text = string.format(ZhString.TeamPws_TeamScore, 0 < memberNum and allScore or 0)
end

function TeamPwsView:ClickButtonRule()
  local panelId = PanelConfig.TeamPwsView.id
  local Desc = Table_Help[panelId] and Table_Help[panelId].Desc or ZhString.Help_RuleDes
  TipsView.Me():ShowGeneralHelp(Desc)
end

function TeamPwsView:ClickButtonRank()
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.TeamPwsRankPopUp
  })
end

function TeamPwsView:ClickButtonReward()
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.TeamPwsRewardPopUp
  })
end

function TeamPwsView:ClickButtonMatch()
  if self.disableClick then
    return
  end
  local valid = TeamProxy.Instance:CheckMatchValid(Table_MatchRaid[self.pwsConfig.matchid]) and PvpProxy.Instance:CheckPwsMatchValid(false, self.roomID)
  if valid then
    if not TeamProxy.Instance:CheckTeamTwsProfValid() then
      return
    end
    if PvpProxy.Instance:CheckHasInvalidPro() then
      local param = PvpProxy.Instance:GetForbiddenProStr()
      MsgManager.ConfirmMsgByID(28088, nil, nil, nil, param)
      return
    end
    if TeamProxy.Instance:IHaveTeam() then
      local memberlst = TeamProxy.Instance.myTeam:GetPlayerMemberList(true, true)
      if #memberlst < GameConfig.Team.maxmember then
        MsgManager.ConfirmMsgByID(25904, function()
          self:CallMatch()
        end, nil)
        return
      end
    end
    self:CallMatch()
  end
end

function TeamPwsView:CallMatch()
  if self.disableClick then
    return
  end
  if not TeamProxy.Instance:CheckDiffServerValidByPvpType(T_PVP_TYPE) then
    MsgManager.ShowMsgByID(42041)
    return
  end
  ServiceMatchCCmdProxy.Instance:CallJoinRoomCCmd(T_PVP_TYPE, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, self.onlyMatchMyServerTog.value)
  self.disableClick = true
  self.ltDisableClick = TimeTickManager.Me():CreateOnceDelayTick(3000, function(owner, deltaTime)
    self.disableClick = false
    self.ltDisableClick = nil
  end, self)
  TeamProxy.Instance:SetDiffServerChooseStatus(T_PVP_TYPE, self.onlyMatchMyServerTog.value)
  self.container:CloseSelf()
end

function TeamPwsView:OnTabEnabled()
  self:UpdateView()
end

function TeamPwsView:OnTabDisabled()
  self:ClearTick()
end

function TeamPwsView:UpdateView()
  local teamPwsCount = MyselfProxy.Instance:getVarValueByType(Var_pb.EVARTYPE_TEAMPWS_COUNT) or 0
  self.labFightCount.text = GameConfig.teamPVP.Maxtime - teamPwsCount .. "/" .. GameConfig.teamPVP.Maxtime
  self.labFightCountInfo.text = ZhString.TeamPws_FightLabel
  self.labPwsCoin.text = string.format("%s/%s", Game.Myself.data.userdata:Get(UDEnum.TEAMPVP_COIN), GameConfig.PvpTeamRaidPublic.MaxSeasonCoinNum)
  self.haveChance = teamPwsCount < GameConfig.teamPVP.Maxtime
  self:UpdateMatchButton()
  self:UpdateMemberInfosAndScore()
  self:RefreshLeftTime()
  self.fightBg:UpdateAnchors()
end

function TeamPwsView:ClickTeamMember(cellCtl)
  local memberData = cellCtl.data
  if cellCtl == self.curCell or cellCtl.charID == Game.Myself.data.id or memberData.cat and memberData.cat ~= 0 then
    FunctionPlayerTip.Me():CloseTip()
    self.curCell = nil
    return
  end
  self.curCell = cellCtl
  local playerTip = FunctionPlayerTip.Me():GetPlayerTip(cellCtl.headIcon.frameSp, NGUIUtil.AnchorSide.TopRight, {-70, 14})
  local playerData = PlayerTipData.new()
  playerData:SetByTeamMemberData(memberData)
  local funckeys = FunctionPlayerTip.Me():GetPlayerFunckey(memberData.id)
  playerTip:SetData({playerData = playerData, funckeys = funckeys})
  playerTip:AddIgnoreBound(cellCtl.headIcon.gameObject)
  
  function playerTip.closecallback()
    self.curCell = nil
  end
end

function TeamPwsView:RefreshLeftTime()
  self:ClearTick()
  self.activityOpen = FunctionActivity.Me():IsActivityRunning(self.pwsConfig.ActivityID)
  self.timeTick = TimeTickManager.Me():CreateTick(0, self.activityOpen and 330 or 5000, self.UpdateLeftTime, self)
end

function TeamPwsView:UpdateLeftTime()
  local curTime = ServerTime.CurServerTime() / 1000
  local currentCDStatus = 0
  if self.activityOpen then
    local actData = FunctionActivity.Me():GetActivityData(self.pwsConfig.ActivityID)
    if actData then
      local totalSec = actData:GetEndTime() - ServerTime.CurServerTime() / 1000
      if 0 < totalSec then
        local day, hour, min, sec = ClientTimeUtil.FormatTimeBySec(totalSec)
        self.labEventCountDown.text = string.format(ZhString.TeamPws_LeftTime, day * 24 + hour, min, sec)
        self:OnCDStatusChanged(1)
        return
      end
    end
    self.labEventCountDown.text = string.format(ZhString.TeamPws_LeftTime, 0, 0, 0)
    self:OnCDStatusChanged(2)
    return
  end
  if not self.nextOpenTime or curTime > self.nextOpenTime then
    self.labEventCountDown.text = ZhString.TeamPws_EventWaitTime_NoTime
    self:OnCDStatusChanged(3)
    return
  end
  local day, hour, min, sec = ClientTimeUtil.FormatTimeBySec(self.nextOpenTime - curTime)
  if 0 < day then
    self.labEventCountDown.text = string.format(ZhString.TeamPws_EventWaitTime, day)
    self:OnCDStatusChanged(4)
  else
    self.labEventCountDown.text = string.format(ZhString.TeamPws_EventWaitTime_Detail, hour, 0 < sec and min + 1 or min)
    self:OnCDStatusChanged(5)
  end
end

function TeamPwsView:OnCDStatusChanged(curStatus)
  if not self.lastCDStatus or curStatus ~= self.lastCDStatus then
    self.lastCDStatus = curStatus
    self.fightBg:UpdateAnchors()
  end
end

function TeamPwsView:ClearTick()
  if self.timeTick then
    self.timeTick:Destroy()
    self.timeTick = nil
  end
end

function TeamPwsView:ClearMemberScoreInfos()
  if not self.memberScoreInfos then
    return
  end
  for i = 1, #self.memberScoreInfos do
    ReusableTable.DestroyAndClearTable(self.memberScoreInfos[i])
  end
  ReusableTable.DestroyAndClearArray(self.memberScoreInfos)
  self.memberScoreInfos = nil
end

function TeamPwsView:OnEnter()
  TeamPwsView.super.OnEnter(self)
  local itemSData = Table_Item[GameConfig.PvpTeamRaidPublic.CoinItemID]
  if itemSData then
    IconManager:SetItemIcon(itemSData.Icon, self.sprPwsCoin)
  end
  if self.labelScrollCtl then
    self.labelScrollCtl:Start()
  end
  local defaultTogValue = TeamProxy.Instance:GetDiffServerChooseStatus(T_PVP_TYPE)
  self.onlyMatchMyServerTog.value = defaultTogValue
end

function TeamPwsView:OnExit()
  if self.labelScrollCtl then
    self.labelScrollCtl:Stop()
  end
  PictureManager.Instance:UnLoadPVP(TeamPwsView.TexSeason, self.texSeason)
  if self.sprLabMyLevel then
    self.sprLabMyLevel:Destroy()
  end
  if self.ltDisableClick then
    self.ltDisableClick:Destroy()
    self.ltDisableClick = nil
  end
  self:ClearTick()
  self:ClearMemberScoreInfos()
  TeamPwsView.super.OnExit(self)
end
