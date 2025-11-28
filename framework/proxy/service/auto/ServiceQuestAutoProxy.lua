ServiceQuestAutoProxy = class("ServiceQuestAutoProxy", ServiceProxy)
ServiceQuestAutoProxy.Instance = nil
ServiceQuestAutoProxy.NAME = "ServiceQuestAutoProxy"

function ServiceQuestAutoProxy:ctor(proxyName)
  if ServiceQuestAutoProxy.Instance == nil then
    self.proxyName = proxyName or ServiceQuestAutoProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceQuestAutoProxy.Instance = self
  end
end

function ServiceQuestAutoProxy:Init()
end

function ServiceQuestAutoProxy:onRegister()
  self:Listen(8, 1, function(data)
    self:RecvQuestList(data)
  end)
  self:Listen(8, 2, function(data)
    self:RecvQuestUpdate(data)
  end)
  self:Listen(8, 5, function(data)
    self:RecvQuestStepUpdate(data)
  end)
  self:Listen(8, 3, function(data)
    self:RecvQuestAction(data)
  end)
  self:Listen(8, 4, function(data)
    self:RecvRunQuestStep(data)
  end)
  self:Listen(8, 6, function(data)
    self:RecvQuestTrace(data)
  end)
  self:Listen(8, 7, function(data)
    self:RecvQuestDetailList(data)
  end)
  self:Listen(8, 8, function(data)
    self:RecvQuestDetailUpdate(data)
  end)
  self:Listen(8, 9, function(data)
    self:RecvQuestRaidCmd(data)
  end)
  self:Listen(8, 10, function(data)
    self:RecvQuestCanAcceptListChange(data)
  end)
  self:Listen(8, 11, function(data)
    self:RecvVisitNpcUserCmd(data)
  end)
  self:Listen(8, 12, function(data)
    self:RecvQueryOtherData(data)
  end)
  self:Listen(8, 13, function(data)
    self:RecvQueryWantedInfoQuestCmd(data)
  end)
  self:Listen(8, 14, function(data)
    self:RecvInviteHelpAcceptQuestCmd(data)
  end)
  self:Listen(8, 16, function(data)
    self:RecvInviteAcceptQuestCmd(data)
  end)
  self:Listen(8, 15, function(data)
    self:RecvReplyHelpAccelpQuestCmd(data)
  end)
  self:Listen(8, 17, function(data)
    self:RecvQueryWorldQuestCmd(data)
  end)
  self:Listen(8, 18, function(data)
    self:RecvQuestGroupTraceQuestCmd(data)
  end)
  self:Listen(8, 19, function(data)
    self:RecvHelpQuickFinishBoardQuestCmd(data)
  end)
  self:Listen(8, 21, function(data)
    self:RecvQueryManualQuestCmd(data)
  end)
  self:Listen(8, 22, function(data)
    self:RecvOpenPuzzleQuestCmd(data)
  end)
  self:Listen(8, 23, function(data)
    self:RecvManualFunctionQuestCmd(data)
  end)
  self:Listen(8, 24, function(data)
    self:RecvQueryQuestListQuestCmd(data)
  end)
  self:Listen(8, 25, function(data)
    self:RecvMapStepSyncCmd(data)
  end)
  self:Listen(8, 26, function(data)
    self:RecvMapStepUpdateCmd(data)
  end)
  self:Listen(8, 27, function(data)
    self:RecvMapStepFinishCmd(data)
  end)
  self:Listen(8, 29, function(data)
    self:RecvPlotStatusNtf(data)
  end)
  self:Listen(8, 28, function(data)
    self:RecvQuestAreaAction(data)
  end)
  self:Listen(8, 30, function(data)
    self:RecvQueryBottleInfoQuestCmd(data)
  end)
  self:Listen(8, 31, function(data)
    self:RecvBottleActionQuestCmd(data)
  end)
  self:Listen(8, 32, function(data)
    self:RecvBottleUpdateQuestCmd(data)
  end)
  self:Listen(8, 33, function(data)
    self:RecvEvidenceQueryCmd(data)
  end)
  self:Listen(8, 34, function(data)
    self:RecvUnlockEvidenceMessageCmd(data)
  end)
  self:Listen(8, 35, function(data)
    self:RecvQueryCharacterInfoCmd(data)
  end)
  self:Listen(8, 37, function(data)
    self:RecvEvidenceHintCmd(data)
  end)
  self:Listen(8, 38, function(data)
    self:RecvEnlightSecretCmd(data)
  end)
  self:Listen(8, 39, function(data)
    self:RecvCloseUICmd(data)
  end)
  self:Listen(8, 40, function(data)
    self:RecvNewEvidenceUpdateCmd(data)
  end)
  self:Listen(8, 41, function(data)
    self:RecvLeaveVisitNpcQuestCmd(data)
  end)
  self:Listen(8, 42, function(data)
    self:RecvCompleteAvailableQueryQuestCmd(data)
  end)
  self:Listen(8, 43, function(data)
    self:RecvWorldCountListQuestCmd(data)
  end)
  self:Listen(8, 48, function(data)
    self:RecvQueryQuestHeroQuestCmd(data)
  end)
  self:Listen(8, 50, function(data)
    self:RecvSetQuestStatusQuestCmd(data)
  end)
  self:Listen(8, 49, function(data)
    self:RecvUpdateQuestHeroQuestCmd(data)
  end)
  self:Listen(8, 51, function(data)
    self:RecvUpdateQuestStoryIndexQuestCmd(data)
  end)
  self:Listen(8, 52, function(data)
    self:RecvUpdateOnceRewardQuestCmd(data)
  end)
  self:Listen(8, 53, function(data)
    self:RecvSyncTreasureBoxNumCmd(data)
  end)
  self:Listen(8, 54, function(data)
    self:RecvQueryAbyssQuestListQuestCmd(data)
  end)
  self:Listen(8, 55, function(data)
    self:RecvUpdateAbyssHelpCountQuestCmd(data)
  end)
  self:Listen(8, 56, function(data)
    self:RecvAbyssDragonInfoNtfQuestCmd(data)
  end)
  self:Listen(8, 57, function(data)
    self:RecvAbyssDragonHpUpdateQuestCmd(data)
  end)
  self:Listen(8, 58, function(data)
    self:RecvAbyssDragonOnOffQuestCmd(data)
  end)
end

function ServiceQuestAutoProxy:CallQuestList(type, id, list, clear, over)
  if not NetConfig.PBC then
    local msg = SceneQuest_pb.QuestList()
    if type ~= nil then
      msg.type = type
    end
    if id ~= nil then
      msg.id = id
    end
    if list ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.list == nil then
        msg.list = {}
      end
      for i = 1, #list do
        table.insert(msg.list, list[i])
      end
    end
    if clear ~= nil then
      msg.clear = clear
    end
    if over ~= nil then
      msg.over = over
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QuestList.id
    local msgParam = {}
    if type ~= nil then
      msgParam.type = type
    end
    if id ~= nil then
      msgParam.id = id
    end
    if list ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.list == nil then
        msgParam.list = {}
      end
      for i = 1, #list do
        table.insert(msgParam.list, list[i])
      end
    end
    if clear ~= nil then
      msgParam.clear = clear
    end
    if over ~= nil then
      msgParam.over = over
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceQuestAutoProxy:CallQuestUpdate(items)
  if not NetConfig.PBC then
    local msg = SceneQuest_pb.QuestUpdate()
    if items ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.items == nil then
        msg.items = {}
      end
      for i = 1, #items do
        table.insert(msg.items, items[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QuestUpdate.id
    local msgParam = {}
    if items ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.items == nil then
        msgParam.items = {}
      end
      for i = 1, #items do
        table.insert(msgParam.items, items[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceQuestAutoProxy:CallQuestStepUpdate(id, step, data)
  if not NetConfig.PBC then
    local msg = SceneQuest_pb.QuestStepUpdate()
    if id ~= nil then
      msg.id = id
    end
    if step ~= nil then
      msg.step = step
    end
    if data ~= nil and data.process ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.process = data.process
    end
    if data ~= nil and data.params ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.params == nil then
        msg.data.params = {}
      end
      for i = 1, #data.params do
        table.insert(msg.data.params, data.params[i])
      end
    end
    if data ~= nil and data.names ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.names == nil then
        msg.data.names = {}
      end
      for i = 1, #data.names do
        table.insert(msg.data.names, data.names[i])
      end
    end
    if data.config ~= nil and data.config.QuestID ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.config == nil then
        msg.data.config = {}
      end
      msg.data.config.QuestID = data.config.QuestID
    end
    if data.config ~= nil and data.config.GroupID ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.config == nil then
        msg.data.config = {}
      end
      msg.data.config.GroupID = data.config.GroupID
    end
    if data.config ~= nil and data.config.RewardGroup ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.config == nil then
        msg.data.config = {}
      end
      msg.data.config.RewardGroup = data.config.RewardGroup
    end
    if data.config ~= nil and data.config.SubGroup ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.config == nil then
        msg.data.config = {}
      end
      msg.data.config.SubGroup = data.config.SubGroup
    end
    if data.config ~= nil and data.config.FinishJump ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.config == nil then
        msg.data.config = {}
      end
      msg.data.config.FinishJump = data.config.FinishJump
    end
    if data.config ~= nil and data.config.FailJump ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.config == nil then
        msg.data.config = {}
      end
      msg.data.config.FailJump = data.config.FailJump
    end
    if data.config ~= nil and data.config.Map ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.config == nil then
        msg.data.config = {}
      end
      msg.data.config.Map = data.config.Map
    end
    if data.config ~= nil and data.config.WhetherTrace ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.config == nil then
        msg.data.config = {}
      end
      msg.data.config.WhetherTrace = data.config.WhetherTrace
    end
    if data.config ~= nil and data.config.Auto ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.config == nil then
        msg.data.config = {}
      end
      msg.data.config.Auto = data.config.Auto
    end
    if data.config ~= nil and data.config.FirstClass ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.config == nil then
        msg.data.config = {}
      end
      msg.data.config.FirstClass = data.config.FirstClass
    end
    if data.config ~= nil and data.config.Class ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.config == nil then
        msg.data.config = {}
      end
      msg.data.config.Class = data.config.Class
    end
    if data.config ~= nil and data.config.Level ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.config == nil then
        msg.data.config = {}
      end
      msg.data.config.Level = data.config.Level
    end
    if data.config ~= nil and data.config.PreNoShow ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.config == nil then
        msg.data.config = {}
      end
      msg.data.config.PreNoShow = data.config.PreNoShow
    end
    if data.config ~= nil and data.config.Risklevel ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.config == nil then
        msg.data.config = {}
      end
      msg.data.config.Risklevel = data.config.Risklevel
    end
    if data.config ~= nil and data.config.Joblevel ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.config == nil then
        msg.data.config = {}
      end
      msg.data.config.Joblevel = data.config.Joblevel
    end
    if data.config ~= nil and data.config.CookerLv ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.config == nil then
        msg.data.config = {}
      end
      msg.data.config.CookerLv = data.config.CookerLv
    end
    if data.config ~= nil and data.config.TasterLv ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.config == nil then
        msg.data.config = {}
      end
      msg.data.config.TasterLv = data.config.TasterLv
    end
    if data.config ~= nil and data.config.StartTime ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.config == nil then
        msg.data.config = {}
      end
      msg.data.config.StartTime = data.config.StartTime
    end
    if data.config ~= nil and data.config.EndTime ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.config == nil then
        msg.data.config = {}
      end
      msg.data.config.EndTime = data.config.EndTime
    end
    if data.config ~= nil and data.config.Icon ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.config == nil then
        msg.data.config = {}
      end
      msg.data.config.Icon = data.config.Icon
    end
    if data.config ~= nil and data.config.Color ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.config == nil then
        msg.data.config = {}
      end
      msg.data.config.Color = data.config.Color
    end
    if data.config ~= nil and data.config.QuestName ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.config == nil then
        msg.data.config = {}
      end
      msg.data.config.QuestName = data.config.QuestName
    end
    if data.config ~= nil and data.config.Name ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.config == nil then
        msg.data.config = {}
      end
      msg.data.config.Name = data.config.Name
    end
    if data.config ~= nil and data.config.Type ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.config == nil then
        msg.data.config = {}
      end
      msg.data.config.Type = data.config.Type
    end
    if data.config ~= nil and data.config.Content ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.config == nil then
        msg.data.config = {}
      end
      msg.data.config.Content = data.config.Content
    end
    if data.config ~= nil and data.config.TraceInfo ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.config == nil then
        msg.data.config = {}
      end
      msg.data.config.TraceInfo = data.config.TraceInfo
    end
    if data.config ~= nil and data.config.Prefixion ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.config == nil then
        msg.data.config = {}
      end
      msg.data.config.Prefixion = data.config.Prefixion
    end
    if data.config ~= nil and data.config.version ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.config == nil then
        msg.data.config = {}
      end
      msg.data.config.version = data.config.version
    end
    if data ~= nil and data.config.params.params ~= nil then
      if msg.data.config.params == nil then
        msg.data.config.params = {}
      end
      if msg.data.config.params.params == nil then
        msg.data.config.params.params = {}
      end
      for i = 1, #data.config.params.params do
        table.insert(msg.data.config.params.params, data.config.params.params[i])
      end
    end
    if data ~= nil and data.config.ExtraJump.params ~= nil then
      if msg.data.config.ExtraJump == nil then
        msg.data.config.ExtraJump = {}
      end
      if msg.data.config.ExtraJump.params == nil then
        msg.data.config.ExtraJump.params = {}
      end
      for i = 1, #data.config.ExtraJump.params do
        table.insert(msg.data.config.ExtraJump.params, data.config.ExtraJump.params[i])
      end
    end
    if data ~= nil and data.config.stepactions ~= nil then
      if msg.data.config == nil then
        msg.data.config = {}
      end
      if msg.data.config.stepactions == nil then
        msg.data.config.stepactions = {}
      end
      for i = 1, #data.config.stepactions do
        table.insert(msg.data.config.stepactions, data.config.stepactions[i])
      end
    end
    if data ~= nil and data.config.allreward ~= nil then
      if msg.data.config == nil then
        msg.data.config = {}
      end
      if msg.data.config.allreward == nil then
        msg.data.config.allreward = {}
      end
      for i = 1, #data.config.allreward do
        table.insert(msg.data.config.allreward, data.config.allreward[i])
      end
    end
    if data ~= nil and data.config.PreQuest ~= nil then
      if msg.data.config == nil then
        msg.data.config = {}
      end
      if msg.data.config.PreQuest == nil then
        msg.data.config.PreQuest = {}
      end
      for i = 1, #data.config.PreQuest do
        table.insert(msg.data.config.PreQuest, data.config.PreQuest[i])
      end
    end
    if data ~= nil and data.config.MustPreQuest ~= nil then
      if msg.data.config == nil then
        msg.data.config = {}
      end
      if msg.data.config.MustPreQuest == nil then
        msg.data.config.MustPreQuest = {}
      end
      for i = 1, #data.config.MustPreQuest do
        table.insert(msg.data.config.MustPreQuest, data.config.MustPreQuest[i])
      end
    end
    if data ~= nil and data.config.PreMenu ~= nil then
      if msg.data.config == nil then
        msg.data.config = {}
      end
      if msg.data.config.PreMenu == nil then
        msg.data.config.PreMenu = {}
      end
      for i = 1, #data.config.PreMenu do
        table.insert(msg.data.config.PreMenu, data.config.PreMenu[i])
      end
    end
    if data ~= nil and data.config.MustPreMenu ~= nil then
      if msg.data.config == nil then
        msg.data.config = {}
      end
      if msg.data.config.MustPreMenu == nil then
        msg.data.config.MustPreMenu = {}
      end
      for i = 1, #data.config.MustPreMenu do
        table.insert(msg.data.config.MustPreMenu, data.config.MustPreMenu[i])
      end
    end
    if data.config ~= nil and data.config.Headicon ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.config == nil then
        msg.data.config = {}
      end
      msg.data.config.Headicon = data.config.Headicon
    end
    if data.config ~= nil and data.config.Hide ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.config == nil then
        msg.data.config = {}
      end
      msg.data.config.Hide = data.config.Hide
    end
    if data.config ~= nil and data.config.CreateTime ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.config == nil then
        msg.data.config = {}
      end
      msg.data.config.CreateTime = data.config.CreateTime
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QuestStepUpdate.id
    local msgParam = {}
    if id ~= nil then
      msgParam.id = id
    end
    if step ~= nil then
      msgParam.step = step
    end
    if data ~= nil and data.process ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.process = data.process
    end
    if data ~= nil and data.params ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.params == nil then
        msgParam.data.params = {}
      end
      for i = 1, #data.params do
        table.insert(msgParam.data.params, data.params[i])
      end
    end
    if data ~= nil and data.names ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.names == nil then
        msgParam.data.names = {}
      end
      for i = 1, #data.names do
        table.insert(msgParam.data.names, data.names[i])
      end
    end
    if data.config ~= nil and data.config.QuestID ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.config == nil then
        msgParam.data.config = {}
      end
      msgParam.data.config.QuestID = data.config.QuestID
    end
    if data.config ~= nil and data.config.GroupID ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.config == nil then
        msgParam.data.config = {}
      end
      msgParam.data.config.GroupID = data.config.GroupID
    end
    if data.config ~= nil and data.config.RewardGroup ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.config == nil then
        msgParam.data.config = {}
      end
      msgParam.data.config.RewardGroup = data.config.RewardGroup
    end
    if data.config ~= nil and data.config.SubGroup ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.config == nil then
        msgParam.data.config = {}
      end
      msgParam.data.config.SubGroup = data.config.SubGroup
    end
    if data.config ~= nil and data.config.FinishJump ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.config == nil then
        msgParam.data.config = {}
      end
      msgParam.data.config.FinishJump = data.config.FinishJump
    end
    if data.config ~= nil and data.config.FailJump ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.config == nil then
        msgParam.data.config = {}
      end
      msgParam.data.config.FailJump = data.config.FailJump
    end
    if data.config ~= nil and data.config.Map ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.config == nil then
        msgParam.data.config = {}
      end
      msgParam.data.config.Map = data.config.Map
    end
    if data.config ~= nil and data.config.WhetherTrace ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.config == nil then
        msgParam.data.config = {}
      end
      msgParam.data.config.WhetherTrace = data.config.WhetherTrace
    end
    if data.config ~= nil and data.config.Auto ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.config == nil then
        msgParam.data.config = {}
      end
      msgParam.data.config.Auto = data.config.Auto
    end
    if data.config ~= nil and data.config.FirstClass ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.config == nil then
        msgParam.data.config = {}
      end
      msgParam.data.config.FirstClass = data.config.FirstClass
    end
    if data.config ~= nil and data.config.Class ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.config == nil then
        msgParam.data.config = {}
      end
      msgParam.data.config.Class = data.config.Class
    end
    if data.config ~= nil and data.config.Level ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.config == nil then
        msgParam.data.config = {}
      end
      msgParam.data.config.Level = data.config.Level
    end
    if data.config ~= nil and data.config.PreNoShow ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.config == nil then
        msgParam.data.config = {}
      end
      msgParam.data.config.PreNoShow = data.config.PreNoShow
    end
    if data.config ~= nil and data.config.Risklevel ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.config == nil then
        msgParam.data.config = {}
      end
      msgParam.data.config.Risklevel = data.config.Risklevel
    end
    if data.config ~= nil and data.config.Joblevel ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.config == nil then
        msgParam.data.config = {}
      end
      msgParam.data.config.Joblevel = data.config.Joblevel
    end
    if data.config ~= nil and data.config.CookerLv ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.config == nil then
        msgParam.data.config = {}
      end
      msgParam.data.config.CookerLv = data.config.CookerLv
    end
    if data.config ~= nil and data.config.TasterLv ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.config == nil then
        msgParam.data.config = {}
      end
      msgParam.data.config.TasterLv = data.config.TasterLv
    end
    if data.config ~= nil and data.config.StartTime ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.config == nil then
        msgParam.data.config = {}
      end
      msgParam.data.config.StartTime = data.config.StartTime
    end
    if data.config ~= nil and data.config.EndTime ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.config == nil then
        msgParam.data.config = {}
      end
      msgParam.data.config.EndTime = data.config.EndTime
    end
    if data.config ~= nil and data.config.Icon ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.config == nil then
        msgParam.data.config = {}
      end
      msgParam.data.config.Icon = data.config.Icon
    end
    if data.config ~= nil and data.config.Color ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.config == nil then
        msgParam.data.config = {}
      end
      msgParam.data.config.Color = data.config.Color
    end
    if data.config ~= nil and data.config.QuestName ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.config == nil then
        msgParam.data.config = {}
      end
      msgParam.data.config.QuestName = data.config.QuestName
    end
    if data.config ~= nil and data.config.Name ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.config == nil then
        msgParam.data.config = {}
      end
      msgParam.data.config.Name = data.config.Name
    end
    if data.config ~= nil and data.config.Type ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.config == nil then
        msgParam.data.config = {}
      end
      msgParam.data.config.Type = data.config.Type
    end
    if data.config ~= nil and data.config.Content ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.config == nil then
        msgParam.data.config = {}
      end
      msgParam.data.config.Content = data.config.Content
    end
    if data.config ~= nil and data.config.TraceInfo ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.config == nil then
        msgParam.data.config = {}
      end
      msgParam.data.config.TraceInfo = data.config.TraceInfo
    end
    if data.config ~= nil and data.config.Prefixion ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.config == nil then
        msgParam.data.config = {}
      end
      msgParam.data.config.Prefixion = data.config.Prefixion
    end
    if data.config ~= nil and data.config.version ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.config == nil then
        msgParam.data.config = {}
      end
      msgParam.data.config.version = data.config.version
    end
    if data ~= nil and data.config.params.params ~= nil then
      if msgParam.data.config.params == nil then
        msgParam.data.config.params = {}
      end
      if msgParam.data.config.params.params == nil then
        msgParam.data.config.params.params = {}
      end
      for i = 1, #data.config.params.params do
        table.insert(msgParam.data.config.params.params, data.config.params.params[i])
      end
    end
    if data ~= nil and data.config.ExtraJump.params ~= nil then
      if msgParam.data.config.ExtraJump == nil then
        msgParam.data.config.ExtraJump = {}
      end
      if msgParam.data.config.ExtraJump.params == nil then
        msgParam.data.config.ExtraJump.params = {}
      end
      for i = 1, #data.config.ExtraJump.params do
        table.insert(msgParam.data.config.ExtraJump.params, data.config.ExtraJump.params[i])
      end
    end
    if data ~= nil and data.config.stepactions ~= nil then
      if msgParam.data.config == nil then
        msgParam.data.config = {}
      end
      if msgParam.data.config.stepactions == nil then
        msgParam.data.config.stepactions = {}
      end
      for i = 1, #data.config.stepactions do
        table.insert(msgParam.data.config.stepactions, data.config.stepactions[i])
      end
    end
    if data ~= nil and data.config.allreward ~= nil then
      if msgParam.data.config == nil then
        msgParam.data.config = {}
      end
      if msgParam.data.config.allreward == nil then
        msgParam.data.config.allreward = {}
      end
      for i = 1, #data.config.allreward do
        table.insert(msgParam.data.config.allreward, data.config.allreward[i])
      end
    end
    if data ~= nil and data.config.PreQuest ~= nil then
      if msgParam.data.config == nil then
        msgParam.data.config = {}
      end
      if msgParam.data.config.PreQuest == nil then
        msgParam.data.config.PreQuest = {}
      end
      for i = 1, #data.config.PreQuest do
        table.insert(msgParam.data.config.PreQuest, data.config.PreQuest[i])
      end
    end
    if data ~= nil and data.config.MustPreQuest ~= nil then
      if msgParam.data.config == nil then
        msgParam.data.config = {}
      end
      if msgParam.data.config.MustPreQuest == nil then
        msgParam.data.config.MustPreQuest = {}
      end
      for i = 1, #data.config.MustPreQuest do
        table.insert(msgParam.data.config.MustPreQuest, data.config.MustPreQuest[i])
      end
    end
    if data ~= nil and data.config.PreMenu ~= nil then
      if msgParam.data.config == nil then
        msgParam.data.config = {}
      end
      if msgParam.data.config.PreMenu == nil then
        msgParam.data.config.PreMenu = {}
      end
      for i = 1, #data.config.PreMenu do
        table.insert(msgParam.data.config.PreMenu, data.config.PreMenu[i])
      end
    end
    if data ~= nil and data.config.MustPreMenu ~= nil then
      if msgParam.data.config == nil then
        msgParam.data.config = {}
      end
      if msgParam.data.config.MustPreMenu == nil then
        msgParam.data.config.MustPreMenu = {}
      end
      for i = 1, #data.config.MustPreMenu do
        table.insert(msgParam.data.config.MustPreMenu, data.config.MustPreMenu[i])
      end
    end
    if data.config ~= nil and data.config.Headicon ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.config == nil then
        msgParam.data.config = {}
      end
      msgParam.data.config.Headicon = data.config.Headicon
    end
    if data.config ~= nil and data.config.Hide ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.config == nil then
        msgParam.data.config = {}
      end
      msgParam.data.config.Hide = data.config.Hide
    end
    if data.config ~= nil and data.config.CreateTime ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.config == nil then
        msgParam.data.config = {}
      end
      msgParam.data.config.CreateTime = data.config.CreateTime
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceQuestAutoProxy:CallQuestAction(action, questid)
  if not NetConfig.PBC then
    local msg = SceneQuest_pb.QuestAction()
    if action ~= nil then
      msg.action = action
    end
    if questid ~= nil then
      msg.questid = questid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QuestAction.id
    local msgParam = {}
    if action ~= nil then
      msgParam.action = action
    end
    if questid ~= nil then
      msgParam.questid = questid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceQuestAutoProxy:CallRunQuestStep(questid, starid, subgroup, step)
  if not NetConfig.PBC then
    local msg = SceneQuest_pb.RunQuestStep()
    if questid ~= nil then
      msg.questid = questid
    end
    if starid ~= nil then
      msg.starid = starid
    end
    if subgroup ~= nil then
      msg.subgroup = subgroup
    end
    if step ~= nil then
      msg.step = step
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.RunQuestStep.id
    local msgParam = {}
    if questid ~= nil then
      msgParam.questid = questid
    end
    if starid ~= nil then
      msgParam.starid = starid
    end
    if subgroup ~= nil then
      msgParam.subgroup = subgroup
    end
    if step ~= nil then
      msgParam.step = step
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceQuestAutoProxy:CallQuestTrace(questid, trace)
  if not NetConfig.PBC then
    local msg = SceneQuest_pb.QuestTrace()
    if questid ~= nil then
      msg.questid = questid
    end
    if trace ~= nil then
      msg.trace = trace
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QuestTrace.id
    local msgParam = {}
    if questid ~= nil then
      msgParam.questid = questid
    end
    if trace ~= nil then
      msgParam.trace = trace
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceQuestAutoProxy:CallQuestDetailList(details)
  if not NetConfig.PBC then
    local msg = SceneQuest_pb.QuestDetailList()
    if details ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.details == nil then
        msg.details = {}
      end
      for i = 1, #details do
        table.insert(msg.details, details[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QuestDetailList.id
    local msgParam = {}
    if details ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.details == nil then
        msgParam.details = {}
      end
      for i = 1, #details do
        table.insert(msgParam.details, details[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceQuestAutoProxy:CallQuestDetailUpdate(detail, del)
  if not NetConfig.PBC then
    local msg = SceneQuest_pb.QuestDetailUpdate()
    if detail ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.detail == nil then
        msg.detail = {}
      end
      for i = 1, #detail do
        table.insert(msg.detail, detail[i])
      end
    end
    if del ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.del == nil then
        msg.del = {}
      end
      for i = 1, #del do
        table.insert(msg.del, del[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QuestDetailUpdate.id
    local msgParam = {}
    if detail ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.detail == nil then
        msgParam.detail = {}
      end
      for i = 1, #detail do
        table.insert(msgParam.detail, detail[i])
      end
    end
    if del ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.del == nil then
        msgParam.del = {}
      end
      for i = 1, #del do
        table.insert(msgParam.del, del[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceQuestAutoProxy:CallQuestRaidCmd(questid)
  if not NetConfig.PBC then
    local msg = SceneQuest_pb.QuestRaidCmd()
    if questid ~= nil then
      msg.questid = questid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QuestRaidCmd.id
    local msgParam = {}
    if questid ~= nil then
      msgParam.questid = questid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceQuestAutoProxy:CallQuestCanAcceptListChange()
  if not NetConfig.PBC then
    local msg = SceneQuest_pb.QuestCanAcceptListChange()
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QuestCanAcceptListChange.id
    local msgParam = {}
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceQuestAutoProxy:CallVisitNpcUserCmd(npctempid, sync_scene)
  if not NetConfig.PBC then
    local msg = SceneQuest_pb.VisitNpcUserCmd()
    if npctempid ~= nil then
      msg.npctempid = npctempid
    end
    if sync_scene ~= nil then
      msg.sync_scene = sync_scene
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.VisitNpcUserCmd.id
    local msgParam = {}
    if npctempid ~= nil then
      msgParam.npctempid = npctempid
    end
    if sync_scene ~= nil then
      msgParam.sync_scene = sync_scene
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceQuestAutoProxy:CallQueryOtherData(type, data)
  if not NetConfig.PBC then
    local msg = SceneQuest_pb.QueryOtherData()
    if type ~= nil then
      msg.type = type
    end
    if data ~= nil and data.data ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.data = data.data
    end
    if data ~= nil and data.param1 ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.param1 = data.param1
    end
    if data ~= nil and data.param2 ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.param2 = data.param2
    end
    if data ~= nil and data.param3 ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.param3 = data.param3
    end
    if data ~= nil and data.param4 ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.param4 = data.param4
    end
    if data ~= nil and data.treasures ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.treasures == nil then
        msg.data.treasures = {}
      end
      for i = 1, #data.treasures do
        table.insert(msg.data.treasures, data.treasures[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QueryOtherData.id
    local msgParam = {}
    if type ~= nil then
      msgParam.type = type
    end
    if data ~= nil and data.data ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.data = data.data
    end
    if data ~= nil and data.param1 ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.param1 = data.param1
    end
    if data ~= nil and data.param2 ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.param2 = data.param2
    end
    if data ~= nil and data.param3 ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.param3 = data.param3
    end
    if data ~= nil and data.param4 ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.param4 = data.param4
    end
    if data ~= nil and data.treasures ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.treasures == nil then
        msgParam.data.treasures = {}
      end
      for i = 1, #data.treasures do
        table.insert(msgParam.data.treasures, data.treasures[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceQuestAutoProxy:CallQueryWantedInfoQuestCmd(maxcount)
  if not NetConfig.PBC then
    local msg = SceneQuest_pb.QueryWantedInfoQuestCmd()
    if maxcount ~= nil then
      msg.maxcount = maxcount
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QueryWantedInfoQuestCmd.id
    local msgParam = {}
    if maxcount ~= nil then
      msgParam.maxcount = maxcount
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceQuestAutoProxy:CallInviteHelpAcceptQuestCmd(leaderid, questid, time, sign, leadername, issubmit)
  if not NetConfig.PBC then
    local msg = SceneQuest_pb.InviteHelpAcceptQuestCmd()
    if leaderid ~= nil then
      msg.leaderid = leaderid
    end
    if questid ~= nil then
      msg.questid = questid
    end
    if time ~= nil then
      msg.time = time
    end
    if sign ~= nil then
      msg.sign = sign
    end
    if leadername ~= nil then
      msg.leadername = leadername
    end
    if issubmit ~= nil then
      msg.issubmit = issubmit
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.InviteHelpAcceptQuestCmd.id
    local msgParam = {}
    if leaderid ~= nil then
      msgParam.leaderid = leaderid
    end
    if questid ~= nil then
      msgParam.questid = questid
    end
    if time ~= nil then
      msgParam.time = time
    end
    if sign ~= nil then
      msgParam.sign = sign
    end
    if leadername ~= nil then
      msgParam.leadername = leadername
    end
    if issubmit ~= nil then
      msgParam.issubmit = issubmit
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceQuestAutoProxy:CallInviteAcceptQuestCmd(leaderid, questid, time, sign, leadername, issubmit, isquickfinish)
  if not NetConfig.PBC then
    local msg = SceneQuest_pb.InviteAcceptQuestCmd()
    if leaderid ~= nil then
      msg.leaderid = leaderid
    end
    if questid ~= nil then
      msg.questid = questid
    end
    if time ~= nil then
      msg.time = time
    end
    if sign ~= nil then
      msg.sign = sign
    end
    if leadername ~= nil then
      msg.leadername = leadername
    end
    if issubmit ~= nil then
      msg.issubmit = issubmit
    end
    if isquickfinish ~= nil then
      msg.isquickfinish = isquickfinish
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.InviteAcceptQuestCmd.id
    local msgParam = {}
    if leaderid ~= nil then
      msgParam.leaderid = leaderid
    end
    if questid ~= nil then
      msgParam.questid = questid
    end
    if time ~= nil then
      msgParam.time = time
    end
    if sign ~= nil then
      msgParam.sign = sign
    end
    if leadername ~= nil then
      msgParam.leadername = leadername
    end
    if issubmit ~= nil then
      msgParam.issubmit = issubmit
    end
    if isquickfinish ~= nil then
      msgParam.isquickfinish = isquickfinish
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceQuestAutoProxy:CallReplyHelpAccelpQuestCmd(leaderid, questid, time, sign, agree, issubmit)
  if not NetConfig.PBC then
    local msg = SceneQuest_pb.ReplyHelpAccelpQuestCmd()
    if leaderid ~= nil then
      msg.leaderid = leaderid
    end
    if questid ~= nil then
      msg.questid = questid
    end
    if time ~= nil then
      msg.time = time
    end
    if sign ~= nil then
      msg.sign = sign
    end
    if agree ~= nil then
      msg.agree = agree
    end
    if issubmit ~= nil then
      msg.issubmit = issubmit
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ReplyHelpAccelpQuestCmd.id
    local msgParam = {}
    if leaderid ~= nil then
      msgParam.leaderid = leaderid
    end
    if questid ~= nil then
      msgParam.questid = questid
    end
    if time ~= nil then
      msgParam.time = time
    end
    if sign ~= nil then
      msgParam.sign = sign
    end
    if agree ~= nil then
      msgParam.agree = agree
    end
    if issubmit ~= nil then
      msgParam.issubmit = issubmit
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceQuestAutoProxy:CallQueryWorldQuestCmd(quests)
  if not NetConfig.PBC then
    local msg = SceneQuest_pb.QueryWorldQuestCmd()
    if quests ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.quests == nil then
        msg.quests = {}
      end
      for i = 1, #quests do
        table.insert(msg.quests, quests[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QueryWorldQuestCmd.id
    local msgParam = {}
    if quests ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.quests == nil then
        msgParam.quests = {}
      end
      for i = 1, #quests do
        table.insert(msgParam.quests, quests[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceQuestAutoProxy:CallQuestGroupTraceQuestCmd(traces)
  if not NetConfig.PBC then
    local msg = SceneQuest_pb.QuestGroupTraceQuestCmd()
    if traces ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.traces == nil then
        msg.traces = {}
      end
      for i = 1, #traces do
        table.insert(msg.traces, traces[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QuestGroupTraceQuestCmd.id
    local msgParam = {}
    if traces ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.traces == nil then
        msgParam.traces = {}
      end
      for i = 1, #traces do
        table.insert(msgParam.traces, traces[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceQuestAutoProxy:CallHelpQuickFinishBoardQuestCmd(questid, leadername)
  if not NetConfig.PBC then
    local msg = SceneQuest_pb.HelpQuickFinishBoardQuestCmd()
    if questid ~= nil then
      msg.questid = questid
    end
    if leadername ~= nil then
      msg.leadername = leadername
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.HelpQuickFinishBoardQuestCmd.id
    local msgParam = {}
    if questid ~= nil then
      msgParam.questid = questid
    end
    if leadername ~= nil then
      msgParam.leadername = leadername
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceQuestAutoProxy:CallQueryManualQuestCmd(version, manual)
  if not NetConfig.PBC then
    local msg = SceneQuest_pb.QueryManualQuestCmd()
    if version ~= nil then
      msg.version = version
    end
    if manual ~= nil and manual.version ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.manual == nil then
        msg.manual = {}
      end
      msg.manual.version = manual.version
    end
    if manual ~= nil and manual.main.items ~= nil then
      if msg.manual.main == nil then
        msg.manual.main = {}
      end
      if msg.manual.main.items == nil then
        msg.manual.main.items = {}
      end
      for i = 1, #manual.main.items do
        table.insert(msg.manual.main.items, manual.main.items[i])
      end
    end
    if manual.main.puzzle ~= nil and manual.main.puzzle.version ~= nil then
      if msg.manual.main == nil then
        msg.manual.main = {}
      end
      if msg.manual.main.puzzle == nil then
        msg.manual.main.puzzle = {}
      end
      msg.manual.main.puzzle.version = manual.main.puzzle.version
    end
    if manual ~= nil and manual.main.puzzle.open_puzzles ~= nil then
      if msg.manual.main.puzzle == nil then
        msg.manual.main.puzzle = {}
      end
      if msg.manual.main.puzzle.open_puzzles == nil then
        msg.manual.main.puzzle.open_puzzles = {}
      end
      for i = 1, #manual.main.puzzle.open_puzzles do
        table.insert(msg.manual.main.puzzle.open_puzzles, manual.main.puzzle.open_puzzles[i])
      end
    end
    if manual ~= nil and manual.main.puzzle.unlock_puzzles ~= nil then
      if msg.manual.main.puzzle == nil then
        msg.manual.main.puzzle = {}
      end
      if msg.manual.main.puzzle.unlock_puzzles == nil then
        msg.manual.main.puzzle.unlock_puzzles = {}
      end
      for i = 1, #manual.main.puzzle.unlock_puzzles do
        table.insert(msg.manual.main.puzzle.unlock_puzzles, manual.main.puzzle.unlock_puzzles[i])
      end
    end
    if manual ~= nil and manual.main.puzzle.canopen_puzzles ~= nil then
      if msg.manual.main.puzzle == nil then
        msg.manual.main.puzzle = {}
      end
      if msg.manual.main.puzzle.canopen_puzzles == nil then
        msg.manual.main.puzzle.canopen_puzzles = {}
      end
      for i = 1, #manual.main.puzzle.canopen_puzzles do
        table.insert(msg.manual.main.puzzle.canopen_puzzles, manual.main.puzzle.canopen_puzzles[i])
      end
    end
    if manual ~= nil and manual.main.mainstoryid ~= nil then
      if msg.manual.main == nil then
        msg.manual.main = {}
      end
      if msg.manual.main.mainstoryid == nil then
        msg.manual.main.mainstoryid = {}
      end
      for i = 1, #manual.main.mainstoryid do
        table.insert(msg.manual.main.mainstoryid, manual.main.mainstoryid[i])
      end
    end
    if manual ~= nil and manual.main.previews ~= nil then
      if msg.manual.main == nil then
        msg.manual.main = {}
      end
      if msg.manual.main.previews == nil then
        msg.manual.main.previews = {}
      end
      for i = 1, #manual.main.previews do
        table.insert(msg.manual.main.previews, manual.main.previews[i])
      end
    end
    if manual ~= nil and manual.branch.shops ~= nil then
      if msg.manual.branch == nil then
        msg.manual.branch = {}
      end
      if msg.manual.branch.shops == nil then
        msg.manual.branch.shops = {}
      end
      for i = 1, #manual.branch.shops do
        table.insert(msg.manual.branch.shops, manual.branch.shops[i])
      end
    end
    if manual ~= nil and manual.story.previews ~= nil then
      if msg.manual.story == nil then
        msg.manual.story = {}
      end
      if msg.manual.story.previews == nil then
        msg.manual.story.previews = {}
      end
      for i = 1, #manual.story.previews do
        table.insert(msg.manual.story.previews, manual.story.previews[i])
      end
    end
    if manual ~= nil and manual.story.submit_ids ~= nil then
      if msg.manual.story == nil then
        msg.manual.story = {}
      end
      if msg.manual.story.submit_ids == nil then
        msg.manual.story.submit_ids = {}
      end
      for i = 1, #manual.story.submit_ids do
        table.insert(msg.manual.story.submit_ids, manual.story.submit_ids[i])
      end
    end
    if manual ~= nil and manual.prequest ~= nil then
      if msg.manual == nil then
        msg.manual = {}
      end
      if msg.manual.prequest == nil then
        msg.manual.prequest = {}
      end
      for i = 1, #manual.prequest do
        table.insert(msg.manual.prequest, manual.prequest[i])
      end
    end
    if manual ~= nil and manual.plotvoice ~= nil then
      if msg.manual == nil then
        msg.manual = {}
      end
      if msg.manual.plotvoice == nil then
        msg.manual.plotvoice = {}
      end
      for i = 1, #manual.plotvoice do
        table.insert(msg.manual.plotvoice, manual.plotvoice[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QueryManualQuestCmd.id
    local msgParam = {}
    if version ~= nil then
      msgParam.version = version
    end
    if manual ~= nil and manual.version ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.manual == nil then
        msgParam.manual = {}
      end
      msgParam.manual.version = manual.version
    end
    if manual ~= nil and manual.main.items ~= nil then
      if msgParam.manual.main == nil then
        msgParam.manual.main = {}
      end
      if msgParam.manual.main.items == nil then
        msgParam.manual.main.items = {}
      end
      for i = 1, #manual.main.items do
        table.insert(msgParam.manual.main.items, manual.main.items[i])
      end
    end
    if manual.main.puzzle ~= nil and manual.main.puzzle.version ~= nil then
      if msgParam.manual.main == nil then
        msgParam.manual.main = {}
      end
      if msgParam.manual.main.puzzle == nil then
        msgParam.manual.main.puzzle = {}
      end
      msgParam.manual.main.puzzle.version = manual.main.puzzle.version
    end
    if manual ~= nil and manual.main.puzzle.open_puzzles ~= nil then
      if msgParam.manual.main.puzzle == nil then
        msgParam.manual.main.puzzle = {}
      end
      if msgParam.manual.main.puzzle.open_puzzles == nil then
        msgParam.manual.main.puzzle.open_puzzles = {}
      end
      for i = 1, #manual.main.puzzle.open_puzzles do
        table.insert(msgParam.manual.main.puzzle.open_puzzles, manual.main.puzzle.open_puzzles[i])
      end
    end
    if manual ~= nil and manual.main.puzzle.unlock_puzzles ~= nil then
      if msgParam.manual.main.puzzle == nil then
        msgParam.manual.main.puzzle = {}
      end
      if msgParam.manual.main.puzzle.unlock_puzzles == nil then
        msgParam.manual.main.puzzle.unlock_puzzles = {}
      end
      for i = 1, #manual.main.puzzle.unlock_puzzles do
        table.insert(msgParam.manual.main.puzzle.unlock_puzzles, manual.main.puzzle.unlock_puzzles[i])
      end
    end
    if manual ~= nil and manual.main.puzzle.canopen_puzzles ~= nil then
      if msgParam.manual.main.puzzle == nil then
        msgParam.manual.main.puzzle = {}
      end
      if msgParam.manual.main.puzzle.canopen_puzzles == nil then
        msgParam.manual.main.puzzle.canopen_puzzles = {}
      end
      for i = 1, #manual.main.puzzle.canopen_puzzles do
        table.insert(msgParam.manual.main.puzzle.canopen_puzzles, manual.main.puzzle.canopen_puzzles[i])
      end
    end
    if manual ~= nil and manual.main.mainstoryid ~= nil then
      if msgParam.manual.main == nil then
        msgParam.manual.main = {}
      end
      if msgParam.manual.main.mainstoryid == nil then
        msgParam.manual.main.mainstoryid = {}
      end
      for i = 1, #manual.main.mainstoryid do
        table.insert(msgParam.manual.main.mainstoryid, manual.main.mainstoryid[i])
      end
    end
    if manual ~= nil and manual.main.previews ~= nil then
      if msgParam.manual.main == nil then
        msgParam.manual.main = {}
      end
      if msgParam.manual.main.previews == nil then
        msgParam.manual.main.previews = {}
      end
      for i = 1, #manual.main.previews do
        table.insert(msgParam.manual.main.previews, manual.main.previews[i])
      end
    end
    if manual ~= nil and manual.branch.shops ~= nil then
      if msgParam.manual.branch == nil then
        msgParam.manual.branch = {}
      end
      if msgParam.manual.branch.shops == nil then
        msgParam.manual.branch.shops = {}
      end
      for i = 1, #manual.branch.shops do
        table.insert(msgParam.manual.branch.shops, manual.branch.shops[i])
      end
    end
    if manual ~= nil and manual.story.previews ~= nil then
      if msgParam.manual.story == nil then
        msgParam.manual.story = {}
      end
      if msgParam.manual.story.previews == nil then
        msgParam.manual.story.previews = {}
      end
      for i = 1, #manual.story.previews do
        table.insert(msgParam.manual.story.previews, manual.story.previews[i])
      end
    end
    if manual ~= nil and manual.story.submit_ids ~= nil then
      if msgParam.manual.story == nil then
        msgParam.manual.story = {}
      end
      if msgParam.manual.story.submit_ids == nil then
        msgParam.manual.story.submit_ids = {}
      end
      for i = 1, #manual.story.submit_ids do
        table.insert(msgParam.manual.story.submit_ids, manual.story.submit_ids[i])
      end
    end
    if manual ~= nil and manual.prequest ~= nil then
      if msgParam.manual == nil then
        msgParam.manual = {}
      end
      if msgParam.manual.prequest == nil then
        msgParam.manual.prequest = {}
      end
      for i = 1, #manual.prequest do
        table.insert(msgParam.manual.prequest, manual.prequest[i])
      end
    end
    if manual ~= nil and manual.plotvoice ~= nil then
      if msgParam.manual == nil then
        msgParam.manual = {}
      end
      if msgParam.manual.plotvoice == nil then
        msgParam.manual.plotvoice = {}
      end
      for i = 1, #manual.plotvoice do
        table.insert(msgParam.manual.plotvoice, manual.plotvoice[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceQuestAutoProxy:CallOpenPuzzleQuestCmd(version, id)
  if not NetConfig.PBC then
    local msg = SceneQuest_pb.OpenPuzzleQuestCmd()
    if version ~= nil then
      msg.version = version
    end
    if id ~= nil then
      msg.id = id
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.OpenPuzzleQuestCmd.id
    local msgParam = {}
    if version ~= nil then
      msgParam.version = version
    end
    if id ~= nil then
      msgParam.id = id
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceQuestAutoProxy:CallManualFunctionQuestCmd(items)
  if not NetConfig.PBC then
    local msg = SceneQuest_pb.ManualFunctionQuestCmd()
    if items ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.items == nil then
        msg.items = {}
      end
      for i = 1, #items do
        table.insert(msg.items, items[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ManualFunctionQuestCmd.id
    local msgParam = {}
    if items ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.items == nil then
        msgParam.items = {}
      end
      for i = 1, #items do
        table.insert(msgParam.items, items[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceQuestAutoProxy:CallQueryQuestListQuestCmd(mapid, datas)
  if not NetConfig.PBC then
    local msg = SceneQuest_pb.QueryQuestListQuestCmd()
    if mapid ~= nil then
      msg.mapid = mapid
    end
    if datas ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.datas == nil then
        msg.datas = {}
      end
      for i = 1, #datas do
        table.insert(msg.datas, datas[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QueryQuestListQuestCmd.id
    local msgParam = {}
    if mapid ~= nil then
      msgParam.mapid = mapid
    end
    if datas ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.datas == nil then
        msgParam.datas = {}
      end
      for i = 1, #datas do
        table.insert(msgParam.datas, datas[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceQuestAutoProxy:CallMapStepSyncCmd(stepid)
  if not NetConfig.PBC then
    local msg = SceneQuest_pb.MapStepSyncCmd()
    if stepid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.stepid == nil then
        msg.stepid = {}
      end
      for i = 1, #stepid do
        table.insert(msg.stepid, stepid[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.MapStepSyncCmd.id
    local msgParam = {}
    if stepid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.stepid == nil then
        msgParam.stepid = {}
      end
      for i = 1, #stepid do
        table.insert(msgParam.stepid, stepid[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceQuestAutoProxy:CallMapStepUpdateCmd(del_stepid, add_stepid)
  if not NetConfig.PBC then
    local msg = SceneQuest_pb.MapStepUpdateCmd()
    if del_stepid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.del_stepid == nil then
        msg.del_stepid = {}
      end
      for i = 1, #del_stepid do
        table.insert(msg.del_stepid, del_stepid[i])
      end
    end
    if add_stepid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.add_stepid == nil then
        msg.add_stepid = {}
      end
      for i = 1, #add_stepid do
        table.insert(msg.add_stepid, add_stepid[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.MapStepUpdateCmd.id
    local msgParam = {}
    if del_stepid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.del_stepid == nil then
        msgParam.del_stepid = {}
      end
      for i = 1, #del_stepid do
        table.insert(msgParam.del_stepid, del_stepid[i])
      end
    end
    if add_stepid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.add_stepid == nil then
        msgParam.add_stepid = {}
      end
      for i = 1, #add_stepid do
        table.insert(msgParam.add_stepid, add_stepid[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceQuestAutoProxy:CallMapStepFinishCmd(stepid, option_jump)
  if not NetConfig.PBC then
    local msg = SceneQuest_pb.MapStepFinishCmd()
    if stepid ~= nil then
      msg.stepid = stepid
    end
    if option_jump ~= nil then
      msg.option_jump = option_jump
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.MapStepFinishCmd.id
    local msgParam = {}
    if stepid ~= nil then
      msgParam.stepid = stepid
    end
    if option_jump ~= nil then
      msgParam.option_jump = option_jump
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceQuestAutoProxy:CallPlotStatusNtf(isstart, id)
  if not NetConfig.PBC then
    local msg = SceneQuest_pb.PlotStatusNtf()
    if isstart ~= nil then
      msg.isstart = isstart
    end
    if id ~= nil then
      msg.id = id
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.PlotStatusNtf.id
    local msgParam = {}
    if isstart ~= nil then
      msgParam.isstart = isstart
    end
    if id ~= nil then
      msgParam.id = id
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceQuestAutoProxy:CallQuestAreaAction(configid)
  if not NetConfig.PBC then
    local msg = SceneQuest_pb.QuestAreaAction()
    if configid ~= nil then
      msg.configid = configid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QuestAreaAction.id
    local msgParam = {}
    if configid ~= nil then
      msgParam.configid = configid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceQuestAutoProxy:CallQueryBottleInfoQuestCmd(accepts, finishs)
  if not NetConfig.PBC then
    local msg = SceneQuest_pb.QueryBottleInfoQuestCmd()
    if accepts ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.accepts == nil then
        msg.accepts = {}
      end
      for i = 1, #accepts do
        table.insert(msg.accepts, accepts[i])
      end
    end
    if finishs ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.finishs == nil then
        msg.finishs = {}
      end
      for i = 1, #finishs do
        table.insert(msg.finishs, finishs[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QueryBottleInfoQuestCmd.id
    local msgParam = {}
    if accepts ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.accepts == nil then
        msgParam.accepts = {}
      end
      for i = 1, #accepts do
        table.insert(msgParam.accepts, accepts[i])
      end
    end
    if finishs ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.finishs == nil then
        msgParam.finishs = {}
      end
      for i = 1, #finishs do
        table.insert(msgParam.finishs, finishs[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceQuestAutoProxy:CallBottleActionQuestCmd(action, id)
  if not NetConfig.PBC then
    local msg = SceneQuest_pb.BottleActionQuestCmd()
    if action ~= nil then
      msg.action = action
    end
    if id ~= nil then
      msg.id = id
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.BottleActionQuestCmd.id
    local msgParam = {}
    if action ~= nil then
      msgParam.action = action
    end
    if id ~= nil then
      msgParam.id = id
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceQuestAutoProxy:CallBottleUpdateQuestCmd(status, updates, delids)
  if not NetConfig.PBC then
    local msg = SceneQuest_pb.BottleUpdateQuestCmd()
    if status ~= nil then
      msg.status = status
    end
    if updates ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.updates == nil then
        msg.updates = {}
      end
      for i = 1, #updates do
        table.insert(msg.updates, updates[i])
      end
    end
    if delids ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.delids == nil then
        msg.delids = {}
      end
      for i = 1, #delids do
        table.insert(msg.delids, delids[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.BottleUpdateQuestCmd.id
    local msgParam = {}
    if status ~= nil then
      msgParam.status = status
    end
    if updates ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.updates == nil then
        msgParam.updates = {}
      end
      for i = 1, #updates do
        table.insert(msgParam.updates, updates[i])
      end
    end
    if delids ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.delids == nil then
        msgParam.delids = {}
      end
      for i = 1, #delids do
        table.insert(msgParam.delids, delids[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceQuestAutoProxy:CallEvidenceQueryCmd(evidences, next_hint, last_hint_cd)
  if not NetConfig.PBC then
    local msg = SceneQuest_pb.EvidenceQueryCmd()
    if evidences ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.evidences == nil then
        msg.evidences = {}
      end
      for i = 1, #evidences do
        table.insert(msg.evidences, evidences[i])
      end
    end
    if next_hint ~= nil then
      msg.next_hint = next_hint
    end
    if last_hint_cd ~= nil then
      msg.last_hint_cd = last_hint_cd
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.EvidenceQueryCmd.id
    local msgParam = {}
    if evidences ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.evidences == nil then
        msgParam.evidences = {}
      end
      for i = 1, #evidences do
        table.insert(msgParam.evidences, evidences[i])
      end
    end
    if next_hint ~= nil then
      msgParam.next_hint = next_hint
    end
    if last_hint_cd ~= nil then
      msgParam.last_hint_cd = last_hint_cd
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceQuestAutoProxy:CallUnlockEvidenceMessageCmd(evidence_id, message_id)
  if not NetConfig.PBC then
    local msg = SceneQuest_pb.UnlockEvidenceMessageCmd()
    if evidence_id ~= nil then
      msg.evidence_id = evidence_id
    end
    if message_id ~= nil then
      msg.message_id = message_id
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.UnlockEvidenceMessageCmd.id
    local msgParam = {}
    if evidence_id ~= nil then
      msgParam.evidence_id = evidence_id
    end
    if message_id ~= nil then
      msgParam.message_id = message_id
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceQuestAutoProxy:CallQueryCharacterInfoCmd(characters, relations)
  if not NetConfig.PBC then
    local msg = SceneQuest_pb.QueryCharacterInfoCmd()
    if characters ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.characters == nil then
        msg.characters = {}
      end
      for i = 1, #characters do
        table.insert(msg.characters, characters[i])
      end
    end
    if relations ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.relations == nil then
        msg.relations = {}
      end
      for i = 1, #relations do
        table.insert(msg.relations, relations[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QueryCharacterInfoCmd.id
    local msgParam = {}
    if characters ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.characters == nil then
        msgParam.characters = {}
      end
      for i = 1, #characters do
        table.insert(msgParam.characters, characters[i])
      end
    end
    if relations ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.relations == nil then
        msgParam.relations = {}
      end
      for i = 1, #relations do
        table.insert(msgParam.relations, relations[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceQuestAutoProxy:CallEvidenceHintCmd(success, next_hint, hint_cd)
  if not NetConfig.PBC then
    local msg = SceneQuest_pb.EvidenceHintCmd()
    if success ~= nil then
      msg.success = success
    end
    if next_hint ~= nil then
      msg.next_hint = next_hint
    end
    if hint_cd ~= nil then
      msg.hint_cd = hint_cd
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.EvidenceHintCmd.id
    local msgParam = {}
    if success ~= nil then
      msgParam.success = success
    end
    if next_hint ~= nil then
      msgParam.next_hint = next_hint
    end
    if hint_cd ~= nil then
      msgParam.hint_cd = hint_cd
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceQuestAutoProxy:CallEnlightSecretCmd(character_id, secret_id, success)
  if not NetConfig.PBC then
    local msg = SceneQuest_pb.EnlightSecretCmd()
    if character_id ~= nil then
      msg.character_id = character_id
    end
    if secret_id ~= nil then
      msg.secret_id = secret_id
    end
    if success ~= nil then
      msg.success = success
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.EnlightSecretCmd.id
    local msgParam = {}
    if character_id ~= nil then
      msgParam.character_id = character_id
    end
    if secret_id ~= nil then
      msgParam.secret_id = secret_id
    end
    if success ~= nil then
      msgParam.success = success
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceQuestAutoProxy:CallCloseUICmd(questid, raid_starid)
  if not NetConfig.PBC then
    local msg = SceneQuest_pb.CloseUICmd()
    if questid ~= nil then
      msg.questid = questid
    end
    if raid_starid ~= nil then
      msg.raid_starid = raid_starid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.CloseUICmd.id
    local msgParam = {}
    if questid ~= nil then
      msgParam.questid = questid
    end
    if raid_starid ~= nil then
      msgParam.raid_starid = raid_starid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceQuestAutoProxy:CallNewEvidenceUpdateCmd(evidence_ids)
  if not NetConfig.PBC then
    local msg = SceneQuest_pb.NewEvidenceUpdateCmd()
    if evidence_ids ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.evidence_ids == nil then
        msg.evidence_ids = {}
      end
      for i = 1, #evidence_ids do
        table.insert(msg.evidence_ids, evidence_ids[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.NewEvidenceUpdateCmd.id
    local msgParam = {}
    if evidence_ids ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.evidence_ids == nil then
        msgParam.evidence_ids = {}
      end
      for i = 1, #evidence_ids do
        table.insert(msgParam.evidence_ids, evidence_ids[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceQuestAutoProxy:CallLeaveVisitNpcQuestCmd(sync_scene)
  if not NetConfig.PBC then
    local msg = SceneQuest_pb.LeaveVisitNpcQuestCmd()
    if sync_scene ~= nil then
      msg.sync_scene = sync_scene
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.LeaveVisitNpcQuestCmd.id
    local msgParam = {}
    if sync_scene ~= nil then
      msgParam.sync_scene = sync_scene
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceQuestAutoProxy:CallCompleteAvailableQueryQuestCmd(itemid, status)
  if not NetConfig.PBC then
    local msg = SceneQuest_pb.CompleteAvailableQueryQuestCmd()
    if itemid ~= nil then
      msg.itemid = itemid
    end
    if status ~= nil then
      msg.status = status
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.CompleteAvailableQueryQuestCmd.id
    local msgParam = {}
    if itemid ~= nil then
      msgParam.itemid = itemid
    end
    if status ~= nil then
      msgParam.status = status
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceQuestAutoProxy:CallWorldCountListQuestCmd(list)
  if not NetConfig.PBC then
    local msg = SceneQuest_pb.WorldCountListQuestCmd()
    if list ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.list == nil then
        msg.list = {}
      end
      for i = 1, #list do
        table.insert(msg.list, list[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.WorldCountListQuestCmd.id
    local msgParam = {}
    if list ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.list == nil then
        msgParam.list = {}
      end
      for i = 1, #list do
        table.insert(msgParam.list, list[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceQuestAutoProxy:CallQueryQuestHeroQuestCmd(items)
  if not NetConfig.PBC then
    local msg = SceneQuest_pb.QueryQuestHeroQuestCmd()
    if items ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.items == nil then
        msg.items = {}
      end
      for i = 1, #items do
        table.insert(msg.items, items[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QueryQuestHeroQuestCmd.id
    local msgParam = {}
    if items ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.items == nil then
        msgParam.items = {}
      end
      for i = 1, #items do
        table.insert(msgParam.items, items[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceQuestAutoProxy:CallSetQuestStatusQuestCmd(traces, news)
  if not NetConfig.PBC then
    local msg = SceneQuest_pb.SetQuestStatusQuestCmd()
    if traces ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.traces == nil then
        msg.traces = {}
      end
      for i = 1, #traces do
        table.insert(msg.traces, traces[i])
      end
    end
    if news ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.news == nil then
        msg.news = {}
      end
      for i = 1, #news do
        table.insert(msg.news, news[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.SetQuestStatusQuestCmd.id
    local msgParam = {}
    if traces ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.traces == nil then
        msgParam.traces = {}
      end
      for i = 1, #traces do
        table.insert(msgParam.traces, traces[i])
      end
    end
    if news ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.news == nil then
        msgParam.news = {}
      end
      for i = 1, #news do
        table.insert(msgParam.news, news[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceQuestAutoProxy:CallUpdateQuestHeroQuestCmd(items)
  if not NetConfig.PBC then
    local msg = SceneQuest_pb.UpdateQuestHeroQuestCmd()
    if items ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.items == nil then
        msg.items = {}
      end
      for i = 1, #items do
        table.insert(msg.items, items[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.UpdateQuestHeroQuestCmd.id
    local msgParam = {}
    if items ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.items == nil then
        msgParam.items = {}
      end
      for i = 1, #items do
        table.insert(msgParam.items, items[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceQuestAutoProxy:CallUpdateQuestStoryIndexQuestCmd(version, indexs)
  if not NetConfig.PBC then
    local msg = SceneQuest_pb.UpdateQuestStoryIndexQuestCmd()
    if version ~= nil then
      msg.version = version
    end
    if indexs ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.indexs == nil then
        msg.indexs = {}
      end
      for i = 1, #indexs do
        table.insert(msg.indexs, indexs[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.UpdateQuestStoryIndexQuestCmd.id
    local msgParam = {}
    if version ~= nil then
      msgParam.version = version
    end
    if indexs ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.indexs == nil then
        msgParam.indexs = {}
      end
      for i = 1, #indexs do
        table.insert(msgParam.indexs, indexs[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceQuestAutoProxy:CallUpdateOnceRewardQuestCmd(item)
  if not NetConfig.PBC then
    local msg = SceneQuest_pb.UpdateOnceRewardQuestCmd()
    if item ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.item == nil then
        msg.item = {}
      end
      for i = 1, #item do
        table.insert(msg.item, item[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.UpdateOnceRewardQuestCmd.id
    local msgParam = {}
    if item ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.item == nil then
        msgParam.item = {}
      end
      for i = 1, #item do
        table.insert(msgParam.item, item[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceQuestAutoProxy:CallSyncTreasureBoxNumCmd(mapid, gotten_num, total_num)
  if not NetConfig.PBC then
    local msg = SceneQuest_pb.SyncTreasureBoxNumCmd()
    if mapid ~= nil then
      msg.mapid = mapid
    end
    if gotten_num ~= nil then
      msg.gotten_num = gotten_num
    end
    if total_num ~= nil then
      msg.total_num = total_num
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.SyncTreasureBoxNumCmd.id
    local msgParam = {}
    if mapid ~= nil then
      msgParam.mapid = mapid
    end
    if gotten_num ~= nil then
      msgParam.gotten_num = gotten_num
    end
    if total_num ~= nil then
      msgParam.total_num = total_num
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceQuestAutoProxy:CallQueryAbyssQuestListQuestCmd(cur_area, cur_prestige_lv, cur_help_count, cur_help_totalcount, list)
  if not NetConfig.PBC then
    local msg = SceneQuest_pb.QueryAbyssQuestListQuestCmd()
    if cur_area ~= nil then
      msg.cur_area = cur_area
    end
    if cur_prestige_lv ~= nil then
      msg.cur_prestige_lv = cur_prestige_lv
    end
    if cur_help_count ~= nil then
      msg.cur_help_count = cur_help_count
    end
    if cur_help_totalcount ~= nil then
      msg.cur_help_totalcount = cur_help_totalcount
    end
    if list ~= nil and list.cmd ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.list == nil then
        msg.list = {}
      end
      msg.list.cmd = list.cmd
    end
    if list ~= nil and list.param ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.list == nil then
        msg.list = {}
      end
      msg.list.param = list.param
    end
    if list ~= nil and list.type ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.list == nil then
        msg.list = {}
      end
      msg.list.type = list.type
    end
    if list ~= nil and list.id ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.list == nil then
        msg.list = {}
      end
      msg.list.id = list.id
    end
    if list ~= nil and list.list ~= nil then
      if msg.list == nil then
        msg.list = {}
      end
      if msg.list.list == nil then
        msg.list.list = {}
      end
      for i = 1, #list.list do
        table.insert(msg.list.list, list.list[i])
      end
    end
    if list ~= nil and list.clear ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.list == nil then
        msg.list = {}
      end
      msg.list.clear = list.clear
    end
    if list ~= nil and list.over ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.list == nil then
        msg.list = {}
      end
      msg.list.over = list.over
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QueryAbyssQuestListQuestCmd.id
    local msgParam = {}
    if cur_area ~= nil then
      msgParam.cur_area = cur_area
    end
    if cur_prestige_lv ~= nil then
      msgParam.cur_prestige_lv = cur_prestige_lv
    end
    if cur_help_count ~= nil then
      msgParam.cur_help_count = cur_help_count
    end
    if cur_help_totalcount ~= nil then
      msgParam.cur_help_totalcount = cur_help_totalcount
    end
    if list ~= nil and list.cmd ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.list == nil then
        msgParam.list = {}
      end
      msgParam.list.cmd = list.cmd
    end
    if list ~= nil and list.param ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.list == nil then
        msgParam.list = {}
      end
      msgParam.list.param = list.param
    end
    if list ~= nil and list.type ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.list == nil then
        msgParam.list = {}
      end
      msgParam.list.type = list.type
    end
    if list ~= nil and list.id ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.list == nil then
        msgParam.list = {}
      end
      msgParam.list.id = list.id
    end
    if list ~= nil and list.list ~= nil then
      if msgParam.list == nil then
        msgParam.list = {}
      end
      if msgParam.list.list == nil then
        msgParam.list.list = {}
      end
      for i = 1, #list.list do
        table.insert(msgParam.list.list, list.list[i])
      end
    end
    if list ~= nil and list.clear ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.list == nil then
        msgParam.list = {}
      end
      msgParam.list.clear = list.clear
    end
    if list ~= nil and list.over ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.list == nil then
        msgParam.list = {}
      end
      msgParam.list.over = list.over
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceQuestAutoProxy:CallUpdateAbyssHelpCountQuestCmd(area, count)
  if not NetConfig.PBC then
    local msg = SceneQuest_pb.UpdateAbyssHelpCountQuestCmd()
    if area ~= nil then
      msg.area = area
    end
    if count ~= nil then
      msg.count = count
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.UpdateAbyssHelpCountQuestCmd.id
    local msgParam = {}
    if area ~= nil then
      msgParam.area = area
    end
    if count ~= nil then
      msgParam.count = count
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceQuestAutoProxy:CallAbyssDragonInfoNtfQuestCmd(dragon_from_bp, dragon_to_bp, dragon_hp, dragon_stage, anim_start_time, activity_start_time)
  if not NetConfig.PBC then
    local msg = SceneQuest_pb.AbyssDragonInfoNtfQuestCmd()
    if dragon_from_bp ~= nil then
      msg.dragon_from_bp = dragon_from_bp
    end
    if dragon_to_bp ~= nil then
      msg.dragon_to_bp = dragon_to_bp
    end
    if dragon_hp ~= nil then
      msg.dragon_hp = dragon_hp
    end
    if dragon_stage ~= nil then
      msg.dragon_stage = dragon_stage
    end
    if anim_start_time ~= nil then
      msg.anim_start_time = anim_start_time
    end
    if activity_start_time ~= nil then
      msg.activity_start_time = activity_start_time
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.AbyssDragonInfoNtfQuestCmd.id
    local msgParam = {}
    if dragon_from_bp ~= nil then
      msgParam.dragon_from_bp = dragon_from_bp
    end
    if dragon_to_bp ~= nil then
      msgParam.dragon_to_bp = dragon_to_bp
    end
    if dragon_hp ~= nil then
      msgParam.dragon_hp = dragon_hp
    end
    if dragon_stage ~= nil then
      msgParam.dragon_stage = dragon_stage
    end
    if anim_start_time ~= nil then
      msgParam.anim_start_time = anim_start_time
    end
    if activity_start_time ~= nil then
      msgParam.activity_start_time = activity_start_time
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceQuestAutoProxy:CallAbyssDragonHpUpdateQuestCmd(dragon_hp, dragon_maxhp)
  if not NetConfig.PBC then
    local msg = SceneQuest_pb.AbyssDragonHpUpdateQuestCmd()
    if dragon_hp ~= nil then
      msg.dragon_hp = dragon_hp
    end
    if dragon_maxhp ~= nil then
      msg.dragon_maxhp = dragon_maxhp
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.AbyssDragonHpUpdateQuestCmd.id
    local msgParam = {}
    if dragon_hp ~= nil then
      msgParam.dragon_hp = dragon_hp
    end
    if dragon_maxhp ~= nil then
      msgParam.dragon_maxhp = dragon_maxhp
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceQuestAutoProxy:CallAbyssDragonOnOffQuestCmd(onoff)
  if not NetConfig.PBC then
    local msg = SceneQuest_pb.AbyssDragonOnOffQuestCmd()
    if onoff ~= nil then
      msg.onoff = onoff
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.AbyssDragonOnOffQuestCmd.id
    local msgParam = {}
    if onoff ~= nil then
      msgParam.onoff = onoff
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceQuestAutoProxy:RecvQuestList(data)
  self:Notify(ServiceEvent.QuestQuestList, data)
end

function ServiceQuestAutoProxy:RecvQuestUpdate(data)
  self:Notify(ServiceEvent.QuestQuestUpdate, data)
end

function ServiceQuestAutoProxy:RecvQuestStepUpdate(data)
  self:Notify(ServiceEvent.QuestQuestStepUpdate, data)
end

function ServiceQuestAutoProxy:RecvQuestAction(data)
  self:Notify(ServiceEvent.QuestQuestAction, data)
end

function ServiceQuestAutoProxy:RecvRunQuestStep(data)
  self:Notify(ServiceEvent.QuestRunQuestStep, data)
end

function ServiceQuestAutoProxy:RecvQuestTrace(data)
  self:Notify(ServiceEvent.QuestQuestTrace, data)
end

function ServiceQuestAutoProxy:RecvQuestDetailList(data)
  self:Notify(ServiceEvent.QuestQuestDetailList, data)
end

function ServiceQuestAutoProxy:RecvQuestDetailUpdate(data)
  self:Notify(ServiceEvent.QuestQuestDetailUpdate, data)
end

function ServiceQuestAutoProxy:RecvQuestRaidCmd(data)
  self:Notify(ServiceEvent.QuestQuestRaidCmd, data)
end

function ServiceQuestAutoProxy:RecvQuestCanAcceptListChange(data)
  self:Notify(ServiceEvent.QuestQuestCanAcceptListChange, data)
end

function ServiceQuestAutoProxy:RecvVisitNpcUserCmd(data)
  self:Notify(ServiceEvent.QuestVisitNpcUserCmd, data)
end

function ServiceQuestAutoProxy:RecvQueryOtherData(data)
  self:Notify(ServiceEvent.QuestQueryOtherData, data)
end

function ServiceQuestAutoProxy:RecvQueryWantedInfoQuestCmd(data)
  self:Notify(ServiceEvent.QuestQueryWantedInfoQuestCmd, data)
end

function ServiceQuestAutoProxy:RecvInviteHelpAcceptQuestCmd(data)
  self:Notify(ServiceEvent.QuestInviteHelpAcceptQuestCmd, data)
end

function ServiceQuestAutoProxy:RecvInviteAcceptQuestCmd(data)
  self:Notify(ServiceEvent.QuestInviteAcceptQuestCmd, data)
end

function ServiceQuestAutoProxy:RecvReplyHelpAccelpQuestCmd(data)
  self:Notify(ServiceEvent.QuestReplyHelpAccelpQuestCmd, data)
end

function ServiceQuestAutoProxy:RecvQueryWorldQuestCmd(data)
  self:Notify(ServiceEvent.QuestQueryWorldQuestCmd, data)
end

function ServiceQuestAutoProxy:RecvQuestGroupTraceQuestCmd(data)
  self:Notify(ServiceEvent.QuestQuestGroupTraceQuestCmd, data)
end

function ServiceQuestAutoProxy:RecvHelpQuickFinishBoardQuestCmd(data)
  self:Notify(ServiceEvent.QuestHelpQuickFinishBoardQuestCmd, data)
end

function ServiceQuestAutoProxy:RecvQueryManualQuestCmd(data)
  self:Notify(ServiceEvent.QuestQueryManualQuestCmd, data)
end

function ServiceQuestAutoProxy:RecvOpenPuzzleQuestCmd(data)
  self:Notify(ServiceEvent.QuestOpenPuzzleQuestCmd, data)
end

function ServiceQuestAutoProxy:RecvManualFunctionQuestCmd(data)
  self:Notify(ServiceEvent.QuestManualFunctionQuestCmd, data)
end

function ServiceQuestAutoProxy:RecvQueryQuestListQuestCmd(data)
  self:Notify(ServiceEvent.QuestQueryQuestListQuestCmd, data)
end

function ServiceQuestAutoProxy:RecvMapStepSyncCmd(data)
  self:Notify(ServiceEvent.QuestMapStepSyncCmd, data)
end

function ServiceQuestAutoProxy:RecvMapStepUpdateCmd(data)
  self:Notify(ServiceEvent.QuestMapStepUpdateCmd, data)
end

function ServiceQuestAutoProxy:RecvMapStepFinishCmd(data)
  self:Notify(ServiceEvent.QuestMapStepFinishCmd, data)
end

function ServiceQuestAutoProxy:RecvPlotStatusNtf(data)
  self:Notify(ServiceEvent.QuestPlotStatusNtf, data)
end

function ServiceQuestAutoProxy:RecvQuestAreaAction(data)
  self:Notify(ServiceEvent.QuestQuestAreaAction, data)
end

function ServiceQuestAutoProxy:RecvQueryBottleInfoQuestCmd(data)
  self:Notify(ServiceEvent.QuestQueryBottleInfoQuestCmd, data)
end

function ServiceQuestAutoProxy:RecvBottleActionQuestCmd(data)
  self:Notify(ServiceEvent.QuestBottleActionQuestCmd, data)
end

function ServiceQuestAutoProxy:RecvBottleUpdateQuestCmd(data)
  self:Notify(ServiceEvent.QuestBottleUpdateQuestCmd, data)
end

function ServiceQuestAutoProxy:RecvEvidenceQueryCmd(data)
  self:Notify(ServiceEvent.QuestEvidenceQueryCmd, data)
end

function ServiceQuestAutoProxy:RecvUnlockEvidenceMessageCmd(data)
  self:Notify(ServiceEvent.QuestUnlockEvidenceMessageCmd, data)
end

function ServiceQuestAutoProxy:RecvQueryCharacterInfoCmd(data)
  self:Notify(ServiceEvent.QuestQueryCharacterInfoCmd, data)
end

function ServiceQuestAutoProxy:RecvEvidenceHintCmd(data)
  self:Notify(ServiceEvent.QuestEvidenceHintCmd, data)
end

function ServiceQuestAutoProxy:RecvEnlightSecretCmd(data)
  self:Notify(ServiceEvent.QuestEnlightSecretCmd, data)
end

function ServiceQuestAutoProxy:RecvCloseUICmd(data)
  self:Notify(ServiceEvent.QuestCloseUICmd, data)
end

function ServiceQuestAutoProxy:RecvNewEvidenceUpdateCmd(data)
  self:Notify(ServiceEvent.QuestNewEvidenceUpdateCmd, data)
end

function ServiceQuestAutoProxy:RecvLeaveVisitNpcQuestCmd(data)
  self:Notify(ServiceEvent.QuestLeaveVisitNpcQuestCmd, data)
end

function ServiceQuestAutoProxy:RecvCompleteAvailableQueryQuestCmd(data)
  self:Notify(ServiceEvent.QuestCompleteAvailableQueryQuestCmd, data)
end

function ServiceQuestAutoProxy:RecvWorldCountListQuestCmd(data)
  self:Notify(ServiceEvent.QuestWorldCountListQuestCmd, data)
end

function ServiceQuestAutoProxy:RecvQueryQuestHeroQuestCmd(data)
  self:Notify(ServiceEvent.QuestQueryQuestHeroQuestCmd, data)
end

function ServiceQuestAutoProxy:RecvSetQuestStatusQuestCmd(data)
  self:Notify(ServiceEvent.QuestSetQuestStatusQuestCmd, data)
end

function ServiceQuestAutoProxy:RecvUpdateQuestHeroQuestCmd(data)
  self:Notify(ServiceEvent.QuestUpdateQuestHeroQuestCmd, data)
end

function ServiceQuestAutoProxy:RecvUpdateQuestStoryIndexQuestCmd(data)
  self:Notify(ServiceEvent.QuestUpdateQuestStoryIndexQuestCmd, data)
end

function ServiceQuestAutoProxy:RecvUpdateOnceRewardQuestCmd(data)
  self:Notify(ServiceEvent.QuestUpdateOnceRewardQuestCmd, data)
end

function ServiceQuestAutoProxy:RecvSyncTreasureBoxNumCmd(data)
  self:Notify(ServiceEvent.QuestSyncTreasureBoxNumCmd, data)
end

function ServiceQuestAutoProxy:RecvQueryAbyssQuestListQuestCmd(data)
  self:Notify(ServiceEvent.QuestQueryAbyssQuestListQuestCmd, data)
end

function ServiceQuestAutoProxy:RecvUpdateAbyssHelpCountQuestCmd(data)
  self:Notify(ServiceEvent.QuestUpdateAbyssHelpCountQuestCmd, data)
end

function ServiceQuestAutoProxy:RecvAbyssDragonInfoNtfQuestCmd(data)
  self:Notify(ServiceEvent.QuestAbyssDragonInfoNtfQuestCmd, data)
end

function ServiceQuestAutoProxy:RecvAbyssDragonHpUpdateQuestCmd(data)
  self:Notify(ServiceEvent.QuestAbyssDragonHpUpdateQuestCmd, data)
end

function ServiceQuestAutoProxy:RecvAbyssDragonOnOffQuestCmd(data)
  self:Notify(ServiceEvent.QuestAbyssDragonOnOffQuestCmd, data)
end

ServiceEvent = _G.ServiceEvent or {}
ServiceEvent.QuestQuestList = "ServiceEvent_QuestQuestList"
ServiceEvent.QuestQuestUpdate = "ServiceEvent_QuestQuestUpdate"
ServiceEvent.QuestQuestStepUpdate = "ServiceEvent_QuestQuestStepUpdate"
ServiceEvent.QuestQuestAction = "ServiceEvent_QuestQuestAction"
ServiceEvent.QuestRunQuestStep = "ServiceEvent_QuestRunQuestStep"
ServiceEvent.QuestQuestTrace = "ServiceEvent_QuestQuestTrace"
ServiceEvent.QuestQuestDetailList = "ServiceEvent_QuestQuestDetailList"
ServiceEvent.QuestQuestDetailUpdate = "ServiceEvent_QuestQuestDetailUpdate"
ServiceEvent.QuestQuestRaidCmd = "ServiceEvent_QuestQuestRaidCmd"
ServiceEvent.QuestQuestCanAcceptListChange = "ServiceEvent_QuestQuestCanAcceptListChange"
ServiceEvent.QuestVisitNpcUserCmd = "ServiceEvent_QuestVisitNpcUserCmd"
ServiceEvent.QuestQueryOtherData = "ServiceEvent_QuestQueryOtherData"
ServiceEvent.QuestQueryWantedInfoQuestCmd = "ServiceEvent_QuestQueryWantedInfoQuestCmd"
ServiceEvent.QuestInviteHelpAcceptQuestCmd = "ServiceEvent_QuestInviteHelpAcceptQuestCmd"
ServiceEvent.QuestInviteAcceptQuestCmd = "ServiceEvent_QuestInviteAcceptQuestCmd"
ServiceEvent.QuestReplyHelpAccelpQuestCmd = "ServiceEvent_QuestReplyHelpAccelpQuestCmd"
ServiceEvent.QuestQueryWorldQuestCmd = "ServiceEvent_QuestQueryWorldQuestCmd"
ServiceEvent.QuestQuestGroupTraceQuestCmd = "ServiceEvent_QuestQuestGroupTraceQuestCmd"
ServiceEvent.QuestHelpQuickFinishBoardQuestCmd = "ServiceEvent_QuestHelpQuickFinishBoardQuestCmd"
ServiceEvent.QuestQueryManualQuestCmd = "ServiceEvent_QuestQueryManualQuestCmd"
ServiceEvent.QuestOpenPuzzleQuestCmd = "ServiceEvent_QuestOpenPuzzleQuestCmd"
ServiceEvent.QuestManualFunctionQuestCmd = "ServiceEvent_QuestManualFunctionQuestCmd"
ServiceEvent.QuestQueryQuestListQuestCmd = "ServiceEvent_QuestQueryQuestListQuestCmd"
ServiceEvent.QuestMapStepSyncCmd = "ServiceEvent_QuestMapStepSyncCmd"
ServiceEvent.QuestMapStepUpdateCmd = "ServiceEvent_QuestMapStepUpdateCmd"
ServiceEvent.QuestMapStepFinishCmd = "ServiceEvent_QuestMapStepFinishCmd"
ServiceEvent.QuestPlotStatusNtf = "ServiceEvent_QuestPlotStatusNtf"
ServiceEvent.QuestQuestAreaAction = "ServiceEvent_QuestQuestAreaAction"
ServiceEvent.QuestQueryBottleInfoQuestCmd = "ServiceEvent_QuestQueryBottleInfoQuestCmd"
ServiceEvent.QuestBottleActionQuestCmd = "ServiceEvent_QuestBottleActionQuestCmd"
ServiceEvent.QuestBottleUpdateQuestCmd = "ServiceEvent_QuestBottleUpdateQuestCmd"
ServiceEvent.QuestEvidenceQueryCmd = "ServiceEvent_QuestEvidenceQueryCmd"
ServiceEvent.QuestUnlockEvidenceMessageCmd = "ServiceEvent_QuestUnlockEvidenceMessageCmd"
ServiceEvent.QuestQueryCharacterInfoCmd = "ServiceEvent_QuestQueryCharacterInfoCmd"
ServiceEvent.QuestEvidenceHintCmd = "ServiceEvent_QuestEvidenceHintCmd"
ServiceEvent.QuestEnlightSecretCmd = "ServiceEvent_QuestEnlightSecretCmd"
ServiceEvent.QuestCloseUICmd = "ServiceEvent_QuestCloseUICmd"
ServiceEvent.QuestNewEvidenceUpdateCmd = "ServiceEvent_QuestNewEvidenceUpdateCmd"
ServiceEvent.QuestLeaveVisitNpcQuestCmd = "ServiceEvent_QuestLeaveVisitNpcQuestCmd"
ServiceEvent.QuestCompleteAvailableQueryQuestCmd = "ServiceEvent_QuestCompleteAvailableQueryQuestCmd"
ServiceEvent.QuestWorldCountListQuestCmd = "ServiceEvent_QuestWorldCountListQuestCmd"
ServiceEvent.QuestQueryQuestHeroQuestCmd = "ServiceEvent_QuestQueryQuestHeroQuestCmd"
ServiceEvent.QuestSetQuestStatusQuestCmd = "ServiceEvent_QuestSetQuestStatusQuestCmd"
ServiceEvent.QuestUpdateQuestHeroQuestCmd = "ServiceEvent_QuestUpdateQuestHeroQuestCmd"
ServiceEvent.QuestUpdateQuestStoryIndexQuestCmd = "ServiceEvent_QuestUpdateQuestStoryIndexQuestCmd"
ServiceEvent.QuestUpdateOnceRewardQuestCmd = "ServiceEvent_QuestUpdateOnceRewardQuestCmd"
ServiceEvent.QuestSyncTreasureBoxNumCmd = "ServiceEvent_QuestSyncTreasureBoxNumCmd"
ServiceEvent.QuestQueryAbyssQuestListQuestCmd = "ServiceEvent_QuestQueryAbyssQuestListQuestCmd"
ServiceEvent.QuestUpdateAbyssHelpCountQuestCmd = "ServiceEvent_QuestUpdateAbyssHelpCountQuestCmd"
ServiceEvent.QuestAbyssDragonInfoNtfQuestCmd = "ServiceEvent_QuestAbyssDragonInfoNtfQuestCmd"
ServiceEvent.QuestAbyssDragonHpUpdateQuestCmd = "ServiceEvent_QuestAbyssDragonHpUpdateQuestCmd"
ServiceEvent.QuestAbyssDragonOnOffQuestCmd = "ServiceEvent_QuestAbyssDragonOnOffQuestCmd"
