local _TableClear = TableUtility.TableClear
local _ArrayClear = TableUtility.ArrayClear
TriplePlayerPvpProxy = class("TriplePlayerPvpProxy", pm.Proxy)
TriplePlayerPvpProxy.Instance = nil
TriplePlayerPvpProxy.NAME = "TriplePlayerPvpProxy"
TriplePlayerPvpProxy.ETripleCamp = {
  RED = 1,
  YELLOW = 2,
  BLUE = 3,
  GREEN = 4
}
TriplePlayerPvpProxy.EState = {
  None = 0,
  Waitting = 1,
  ChooseProfession = 2,
  End = 3
}
TriplePlayerPvpProxy.MaxPlayer = 9
TriplePlayerPvpProxy.EmptyHead = "Empty"
autoImport("TriplePlayerPvpData")
TriplePlayerPvpProxy.Debug_Mode = false

function TriplePlayerPvpProxy.Debug(...)
  if TriplePlayerPvpProxy.Debug_Mode then
    redlog(...)
  end
end

function TriplePlayerPvpProxy:ctor(proxyName, data)
  self.proxyName = proxyName or TriplePlayerPvpProxy.NAME
  if TriplePlayerPvpProxy.Instance == nil then
    TriplePlayerPvpProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:InitProxy()
end

function TriplePlayerPvpProxy:InitProxy()
  self:InitStateFunc()
  self.phase = 0
  self.myselfIndex = 2
  self.enterNum = 0
  self.phase_end_time = 0
  self.fire_begin_time = 0
  self.enemyTeams = {}
  self.triplePvpHeadImages = {}
  self:ResetWaittingHead()
  self.campMap = {}
end

function TriplePlayerPvpProxy:ResetWaittingHead()
  if not self.triplePvpHeadImages or nil == next(self.triplePvpHeadImages) then
    return
  end
  for i = 1, TriplePlayerPvpProxy.MaxPlayer do
    self.triplePvpHeadImages[i] = TriplePlayerPvpProxy.EmptyHead
  end
end

function TriplePlayerPvpProxy:InitStateFunc()
  self.state = TriplePlayerPvpProxy.EState.None
  self.stateFunc = {}
  self.stateFunc[TriplePlayerPvpProxy.EState.Waitting] = self._DoWaittingState
  self.stateFunc[TriplePlayerPvpProxy.EState.ChooseProfession] = self._DoChoosingState
  self.stateFunc[TriplePlayerPvpProxy.EState.End] = self._DoEndState
end

function TriplePlayerPvpProxy:_DoWaittingState(data)
  if data.profession_begin_time and data.profession_begin_time > 0 then
    self.prepare_end_time = data.profession_begin_time
  end
  FunctionSystem.InterruptMyselfAI()
  self:RaidNoMove(true)
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.TriplePlayerPvpWaittingView
  })
end

function TriplePlayerPvpProxy:RaidNoMove(noMove)
  if self.noMove ~= noMove then
    self.noMove = noMove
    Game.Myself:Client_NoMove(noMove)
  end
end

function TriplePlayerPvpProxy:_DoChoosingState(data)
  self.phase_end_time = data.phase_end_time or 0
  if self.phase_end_time > 0 then
    if self.phase == 0 then
      GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.TriplePlayerPvpChooseProView
      })
    end
    self.phase = self.phase + 1
  else
    self.fire_begin_time = data.fire_begin_time or 0
  end
end

function TriplePlayerPvpProxy:_DoEndState(_)
  self:Reset()
end

function TriplePlayerPvpProxy:Reset()
  if self:IsNoneState() then
    return
  end
  self:RaidNoMove(false)
  if self.myTeam then
    self.myTeam:OnRemove()
    self.myTeam = nil
  end
  if self.enemyTeams and nil ~= next(self.enemyTeams) then
    for k, v in pairs(self.enemyTeams) do
      v:OnRemove()
    end
    _TableClear(self.enemyTeams)
  end
  self.enterNum = 0
  self.phase = 0
  self.phase_end_time = 0
  self.fire_begin_time = 0
  self.prepare_end_time = nil
  self.myselfChoosen = nil
  self:ResetWaittingHead()
  _TableClear(self.campMap)
  self.state = TriplePlayerPvpProxy.EState.None
  self.isRelax = nil
end

function TriplePlayerPvpProxy:HandleSyncTripleEnterCount(data)
  if ISNoviceServerType then
    return
  end
  local datas = data and data.datas
  if not datas then
    return
  end
  for i = 1, #datas do
    if nil ~= next(datas[i]) then
      self.enterNum = self.enterNum + 1
      local portrait = HeadImageData.new()
      portrait:TransByPortraitData(datas[i])
      if self.enterNum <= TriplePlayerPvpProxy.MaxPlayer then
        self.triplePvpHeadImages[self.enterNum] = portrait
      else
      end
    end
  end
end

function TriplePlayerPvpProxy:HandleSyncTriplePlayerModel(data)
  if ISNoviceServerType then
    return
  end
  TriplePlayerPvpProxy.Debug("--------------------[DebugTriplePlayer] HandleSyncTriplePlayerModel")
  local myteam = data.myteam
  if myteam then
    if self.myTeam then
      self.myTeam:UpdateMember(myteam)
    else
      self.myTeam = TriplePlayerPvpData.new(myteam, true)
    end
    self.campMap[3] = self.myTeam.camp
  end
  local otherteams = data.otherteams
  if otherteams then
    for i = 1, #otherteams do
      local camp = otherteams[i].ecamp
      self.campMap[i] = camp
      local otherTeamData = self.enemyTeams[camp]
      if not otherTeamData then
        otherTeamData = TriplePlayerPvpData.new(otherteams[i])
        self.enemyTeams[otherteams[i].ecamp] = otherTeamData
      else
        otherTeamData:UpdateMember(otherteams[i])
      end
    end
  end
end

function TriplePlayerPvpProxy:HandleSyncTime(data)
  if ISNoviceServerType then
    return
  end
  TriplePlayerPvpProxy.Debug("--------------------[DebugTriplePlayer] SyncTripleProfessionTimeFuBenCmd phase_end_time| profession_begin_time | close", data.phase_end_time, data.profession_begin_time, data.close)
  if data.close then
    self.state = TriplePlayerPvpProxy.EState.End
  elseif self:IsNoneState() and data.profession_begin_time and data.profession_begin_time > 0 then
    self.state = TriplePlayerPvpProxy.EState.Waitting
  else
    self.state = TriplePlayerPvpProxy.EState.ChooseProfession
  end
  local call = self.stateFunc[self.state]
  if call then
    call(self, data)
  end
end

function TriplePlayerPvpProxy:SetMyselfChooseFlag(var)
  if var ~= self.myselfChoosen then
    self.myselfChoosen = var
  end
end

function TriplePlayerPvpProxy:CheckIChoosen()
  return self.myselfChoosen == true
end

function TriplePlayerPvpProxy:CheckNeedConfirmChangePro()
  return not self:CheckIChoosen() and self:InPreparation()
end

function TriplePlayerPvpProxy:GetWaittingPlayerHeadImages()
  return self.triplePvpHeadImages
end

function TriplePlayerPvpProxy:GetEnterPlayerNum()
  return math.min(self.enterNum, TriplePlayerPvpProxy.MaxPlayer)
end

function TriplePlayerPvpProxy:IsNoneState()
  return self.state == TriplePlayerPvpProxy.EState.None
end

function TriplePlayerPvpProxy:IsFighting()
  return self.state == TriplePlayerPvpProxy.EState.End
end

function TriplePlayerPvpProxy:IsWaitting()
  return self.state == TriplePlayerPvpProxy.EState.Waitting
end

function TriplePlayerPvpProxy:InPreparation()
  return self.state > TriplePlayerPvpProxy.EState.None and self.state < TriplePlayerPvpProxy.EState.End
end

function TriplePlayerPvpProxy:IsChoosing()
  return self.state == TriplePlayerPvpProxy.EState.ChooseProfession
end

function TriplePlayerPvpProxy:GetState()
  return self.state
end

function TriplePlayerPvpProxy:GetEnemyTeam()
  return self.enemyTeams
end

function TriplePlayerPvpProxy:GetMembersByCamp(index)
  local camp = self.campMap[index]
  local data = camp and self.enemyTeams[camp]
  if data then
    return data:GetMembers()
  end
  return _EmptyTable
end

function TriplePlayerPvpProxy:GetMyTeam()
  return self.myTeam
end

function TriplePlayerPvpProxy:CheckMyTeamRepetitiveProfession(pro)
  if self:IsRelax() then
    return false
  end
  local memberMap = self.myTeam and self.myTeam.memberMap
  if memberMap then
    for index, triplePlayerPvpMember in pairs(memberMap) do
      if triplePlayerPvpMember:IsChoosen() and triplePlayerPvpMember:GetPro() == pro then
        return true
      end
    end
  end
  return false
end

function TriplePlayerPvpProxy:InitializeRelaxFlag(var)
  self.isRelax = var
end

function TriplePlayerPvpProxy:IsRelax()
  return self.isRelax == true
end

function TriplePlayerPvpProxy:GetPhase()
  return self.phase
end

function TriplePlayerPvpProxy:GetPhaseEndTime()
  return self.phase_end_time
end

function TriplePlayerPvpProxy:GetWaitEndTime()
  return self.prepare_end_time
end

function TriplePlayerPvpProxy:GetFireBeginTime()
  return self.fire_begin_time
end

function TriplePlayerPvpProxy:GetCamp(index)
  return self.campMap[index]
end
