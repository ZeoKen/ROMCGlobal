NewbieCollegeProxy = class("NewbieCollegeProxy", pm.Proxy)
NewbieCollegeProxy.Instance = nil
NewbieCollegeProxy.NAME = "NewbieCollegeProxy"

function NewbieCollegeProxy:ctor(proxyName, data)
  self.proxyName = proxyName or NewbieCollegeProxy.NAME
  if NewbieCollegeProxy.Instance == nil then
    NewbieCollegeProxy.Instance = self
    self:AddEventListeners()
  end
end

function NewbieCollegeProxy:AddEventListeners()
  EventManager.Me():AddEventListener(ServiceEvent.PlayerMapChange, self.ProcessLeaveNewbieCollegeRaid, self)
end

NewbieCollegeProxy.fakeNpcName = nil
NewbieCollegeProxy.fakeTeamName = nil
NewbieCollegeProxy.fakeLeaderNpcId = nil
NewbieCollegeProxy.fakeTeamId = nil
NewbieCollegeProxy.IsInFakeTeam = false
NewbieCollegeProxy.EMEMBERDATA_FAKE_NPC = 998

function NewbieCollegeProxy:InviteFakeTeam(oriQuestData)
  if not oriQuestData then
    return
  end
  self.fakeNpcName = oriQuestData.params.invite_name
  self.fakeTeamName = oriQuestData.params.team_name
end

function NewbieCollegeProxy:EnterFakeTeam(oriQuestData)
  if not oriQuestData then
    return
  end
  self.fakeLeaderNpcId = oriQuestData.params.member[1]
  self:SimulateEnterTeam()
  if oriQuestData and oriQuestData.scope and oriQuestData.id and oriQuestData.staticData and oriQuestData.staticData.FinishJump then
    QuestProxy.Instance:notifyQuestState(oriQuestData.scope, oriQuestData.id, oriQuestData.staticData.FinishJump)
  else
    redlog("quest config contains error")
  end
end

function NewbieCollegeProxy:SimulateEnterTeam()
  local randCharid = 111000111
  self.fakeTeamId = 999111
  local fakeTeamItems = {}
  table.insert(fakeTeamItems, {type = 1, value = 10010})
  table.insert(fakeTeamItems, {type = 2, value = 1})
  table.insert(fakeTeamItems, {type = 3, value = 170})
  table.insert(fakeTeamItems, {type = 5, value = 2})
  table.insert(fakeTeamItems, {type = 6, value = 2})
  table.insert(fakeTeamItems, {type = 7, value = 1})
  table.insert(fakeTeamItems, {type = 10, value = 1})
  table.insert(fakeTeamItems, {type = 11, value = 0})
  table.insert(fakeTeamItems, {type = 12, strvalue = ""})
  table.insert(fakeTeamItems, {type = 15, value = 0})
  table.insert(fakeTeamItems, {
    type = SessionTeam_pb.ETEAMDATA_GROUP_ID,
    value = 0
  })
  table.insert(fakeTeamItems, {type = 17, value = 0})
  table.insert(fakeTeamItems, {type = 18, value = 0})
  local fakeMembers = {}
  local memberMyself = {}
  memberMyself.accid = FunctionLogin.Me():getLoginData().accid
  memberMyself.guid = Game.Myself.data.id
  memberMyself.name = Game.Myself.data.name
  memberMyself.zoneid = Game.Myself.data.userdata:Get(UDEnum.ZONEID)
  memberMyself.datas = {}
  table.insert(memberMyself.datas, {
    type = SessionTeam_pb.EMEMBERDATA_BASELEVEL,
    value = Game.Myself.data.userdata:Get(UDEnum.ROLELEVEL)
  })
  local memberfakenpc = {}
  memberfakenpc.accid = memberMyself.accid
  memberfakenpc.guid = randCharid
  memberfakenpc.name = self.fakeNpcName
  memberfakenpc.zoneid = memberMyself.zoneid
  memberfakenpc.serverid = MyselfProxy.Instance:GetServerId()
  memberfakenpc.datas = {}
  table.insert(memberfakenpc.datas, {
    type = NewbieCollegeProxy.EMEMBERDATA_FAKE_NPC,
    value = self.fakeLeaderNpcId
  })
  table.insert(memberfakenpc.datas, {
    type = SessionTeam_pb.EMEMBERDATA_PROFESSION,
    value = 55
  })
  table.insert(memberfakenpc.datas, {
    type = SessionTeam_pb.EMEMBERDATA_BASELEVEL,
    value = 160
  })
  table.insert(memberfakenpc.datas, {
    type = SessionTeam_pb.EMEMBERDATA_JOB,
    value = SessionTeam_pb.ETEAMJOB_LEADER
  })
  table.insert(fakeMembers, memberMyself)
  table.insert(fakeMembers, memberfakenpc)
  local fakeEnterTeamData = SessionTeam_pb.EnterTeam()
  fakeEnterTeamData.guid = self.fakeTeamId
  fakeEnterTeamData.items = fakeTeamItems
  fakeEnterTeamData.members = fakeMembers
  fakeEnterTeamData.name = self.fakeTeamName
  fakeEnterTeamData.hireMemberList_dirty = false
  ServiceSessionTeamProxy.Instance:RecvEnterTeam({data = fakeEnterTeamData})
  self.IsInFakeTeam = true
end

function NewbieCollegeProxy:LeaveFakeTeam()
  if not self.IsInFakeTeam then
    return
  end
  local fakeExitTeamData = SessionTeam_pb.ExitTeam()
  fakeExitTeamData.team = self.fakeTeamId
  ServiceSessionTeamProxy.Instance:RecvExitTeam({data = fakeExitTeamData})
  self.IsInFakeTeam = false
end

function NewbieCollegeProxy:ProcessLeaveNewbieCollegeRaid()
  GameFacade.Instance:sendNotification(NewbieCollegeEvent.RaidNpcFakeTeamClearInvite)
  self:LeaveFakeTeam()
end

NewbieCollegeProxy.waitUseFakeSkill = nil

function NewbieCollegeProxy:SetWaitUseFakeSkill(skillId)
end
