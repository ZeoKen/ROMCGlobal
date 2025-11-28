autoImport("TripleTeamMemberCell")
MobaPvpCompetiveView = class("MobaPvpCompetiveView", SubView)
local Prefab_Path = ResourcePathHelper.UIView("MobaPvpCompetiveView")

function MobaPvpCompetiveView:Init()
  self:LoadPreferb()
  self:FindObjs()
  self:AddListenEvts()
  ServiceMatchCCmdProxy.Instance:CallQueryTriplePwsTeamInfoMatchCCmd()
end

function MobaPvpCompetiveView:LoadPreferb()
  local parent = self:FindGO("MobaPvpCompetiveView")
  local obj = self:LoadPreferb_ByFullPath(Prefab_Path, parent, true)
  obj.name = "MobaPvpCompetiveSubView"
  self.gameObject = obj
end

function MobaPvpCompetiveView:FindObjs()
  self.myScoreLabel = self:FindComponent("labMyScore", UILabel)
  self.teamScoreLabel = self:FindComponent("labTeamScore", UILabel)
  self.seasonBeginLabel = self:FindComponent("SeasonBeginLabel", UILabel)
  self.seasonEndLabel = self:FindComponent("SeasonEndLabel", UILabel)
  local levelCellContainer = self:FindGO("LevelCellContainer")
  self.mySeasonLevelCell = TripleTeamSeasonLevelCell.new(levelCellContainer)
  self.matchBtn = self:FindGO("MatchBtn")
  self:AddClickEvent(self.matchBtn, function()
    self:OnMatchBtnClick()
  end)
  local rankBtn = self:FindGO("RankBtn")
  self:AddClickEvent(rankBtn, function()
    self:OnRankBtnClick()
  end)
  local rewardBtn = self:FindGO("RewardBtn")
  self:AddClickEvent(rewardBtn, function()
    self:OnRewardBtnClick()
  end)
  local memberGrid = self:FindComponent("memberGrid", UIGrid)
  self.memberListCtrl = UIGridListCtrl.new(memberGrid, TripleTeamMemberCell, "TripleTeamMemberCell")
  self.memberListCtrl:AddEventListener(MouseEvent.MouseClick, self.OnTeamMemberClick, self)
  self.emptyTeamGO = self:FindGO("EmptyTeam")
end

function MobaPvpCompetiveView:AddListenEvts()
  self:AddListenEvt(ServiceEvent.MatchCCmdQueryTriplePwsTeamInfoMatchCCmd, self.HandleTriplePwsTeamInfoCmd)
  self:AddListenEvt(ServiceEvent.SessionTeamEnterTeam, self.UpdateMemberList)
  self:AddListenEvt(ServiceEvent.SessionTeamMemberDataUpdate, self.UpdateMemberList)
  self:AddListenEvt(ServiceEvent.SessionTeamTeamMemberUpdate, self.UpdateMemberList)
  self:AddListenEvt(ServiceEvent.SessionTeamExitTeam, self.UpdateMemberList)
end

function MobaPvpCompetiveView:HandleTriplePwsTeamInfoCmd()
  self:UpdateView()
end

local effectColor = Color(0, 0.33725490196078434, 0.08627450980392157)

function MobaPvpCompetiveView:UpdateView()
  self:UpdateMemberList()
  local isOpen = PvpProxy.Instance:IsTripleTeamPwsMatchOpen()
  self:SetButtonEnable(self.matchBtn, isOpen or false, effectColor)
  local myInfo = PvpProxy.Instance:GetTriplePwsTeamUserInfo(Game.Myself.data.id)
  if myInfo then
    self.mySeasonLevelCell:SetData(myInfo)
    self.myScoreLabel.text = string.format(ZhString.TeamPws_MyScore, myInfo.score)
  end
  local dayTime = GameConfig.Triple and GameConfig.Triple.DayTime
  if dayTime and 0 < #dayTime then
    local t = ReusableTable.CreateArray()
    t[#t + 1] = ZhString.WeekDay[dayTime[1].wday]
    t[#t + 1] = string.gsub(dayTime[1].begintime, ":(%d+)", "", 1)
    t[#t + 1] = string.gsub(dayTime[1].endtime, ":(%d+)", "", 1)
    self.seasonBeginLabel.text = string.format(ZhString.Triple_SeasonStartTime, unpack(t))
    ReusableTable.DestroyArray(t)
    local openTimeInfo = PvpProxy.Instance:GetTripleTeamPwsOpenTimeInfo()
    if openTimeInfo then
      local curTime = ServerTime.CurServerTime() / 1000
      local beginTime = openTimeInfo.seasonBegin
      local breakBeginTime = openTimeInfo.seasonBreakBegin
      local breakEndTime = openTimeInfo.seasonBreakEnd
      local openedCount = openTimeInfo.count
      local totalOpenCount = GameConfig.Triple and GameConfig.Triple.MatchCount or 4
      if beginTime == 0 or curTime < beginTime then
        self.seasonEndLabel.text = ZhString.Triple_SeasonStartSoon
      elseif breakBeginTime == 0 or curTime < breakBeginTime or 0 < breakEndTime and curTime > breakEndTime then
        if openedCount < totalOpenCount then
          local curTimeDate = os.date("*t", curTime)
          local remainCount = totalOpenCount - openedCount
          local curWday = (curTimeDate.wday - 1) % 7
          curWday = 0 < curWday and curWday or 7
          if 1 < remainCount or curWday > dayTime[1].wday then
            self.seasonEndLabel.text = string.format(ZhString.Triple_SeasonEndRemainWeek, remainCount)
          else
            self.seasonEndLabel.text = ZhString.Triple_LastWeek
          end
        elseif isOpen then
          self.seasonEndLabel.text = ZhString.Triple_LastWeek
        else
          self.seasonEndLabel.text = ZhString.Triple_SeasonStartSoon
        end
      else
        self.seasonEndLabel.text = ZhString.Triple_SeasonBreak
      end
    else
      self.seasonEndLabel.text = ZhString.Triple_SeasonStartSoon
    end
  end
end

function MobaPvpCompetiveView:UpdateMemberList()
  local myTeamMemberList = TeamProxy.Instance:GetMyTeamMemberList()
  if myTeamMemberList then
    self.memberListCtrl:ResetDatas(myTeamMemberList)
    local memberCount = #myTeamMemberList
    for i = memberCount + 1, 3 do
      self.memberListCtrl:AddCell(MyselfTeamData.EMPTY_STATE, i)
    end
    self.memberListCtrl:Layout()
    local teamScore = 0
    for i = 1, memberCount do
      local info = PvpProxy.Instance:GetTriplePwsTeamUserInfo(myTeamMemberList[i].id)
      if info then
        teamScore = teamScore + info.score
      end
    end
    self.teamScoreLabel.text = string.format(ZhString.TeamPws_TeamScore, math.floor(teamScore / memberCount))
  else
    self.memberListCtrl:RemoveAll()
  end
  self.teamScoreLabel.gameObject:SetActive(myTeamMemberList ~= nil)
  self.emptyTeamGO:SetActive(not myTeamMemberList)
end

function MobaPvpCompetiveView:OnMatchBtnClick()
  local matchid = GameConfig.Triple and GameConfig.Triple.SeasonMatchid
  local valid = PvpProxy.Instance:CheckMatchValid(PvpProxy.Type.Triple)
  if valid then
    valid = TeamProxy.Instance:CheckMatchValid(Table_MatchRaid[matchid])
    if valid then
      self:CallMatch()
    end
  end
end

function MobaPvpCompetiveView:CallMatch()
  local matchid = GameConfig.Triple and GameConfig.Triple.SeasonMatchid
  local matchRaid = Table_MatchRaid[matchid]
  if not matchRaid then
    redlog(string.format("matchid:%s不存在！", matchid))
    return
  end
  local pvpType = matchRaid.Type
  local raidId = matchRaid.RaidConfigID
  if not TeamProxy.Instance:CheckDiffServerValidByPvpType(pvpType) then
    MsgManager.ShowMsgByID(42041)
    return
  end
  ServiceMatchCCmdProxy.Instance:CallJoinRoomCCmd(pvpType, raidId)
  self.container:CloseSelf()
end

function MobaPvpCompetiveView:OnRankBtnClick()
  self:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.TripleTeamRankPopUp
  })
end

function MobaPvpCompetiveView:OnRewardBtnClick()
  self:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.TripleTeamPwsRewardPopUp
  })
end

function MobaPvpCompetiveView:OnTeamMemberClick(cell)
  local memberData = cell.data
  if cell == self.curCell or cell.charID == Game.Myself.data.id or memberData.cat and memberData.cat ~= 0 then
    FunctionPlayerTip.Me():CloseTip()
    self.curCell = nil
    return
  end
  self.curCell = cell
  local playerTip = FunctionPlayerTip.Me():GetPlayerTip(cell.headIcon.frameSp, NGUIUtil.AnchorSide.TopRight, {-70, 14})
  local playerData = PlayerTipData.new()
  playerData:SetByTeamMemberData(memberData)
  local funckeys = FunctionPlayerTip.Me():GetPlayerFunckey(memberData.id)
  playerTip:SetData({playerData = playerData, funckeys = funckeys})
  playerTip:AddIgnoreBound(cell.headIcon.gameObject)
  
  function playerTip.closecallback()
    self.curCell = nil
  end
end
