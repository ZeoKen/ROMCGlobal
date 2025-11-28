QuestionnaireProxy = class("QuestionnaireProxy", pm.Proxy)

function QuestionnaireProxy:ctor(proxyName, data)
  self.proxyName = proxyName or "QuestionnaireProxy"
  if QuestionnaireProxy.Instance == nil then
    QuestionnaireProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:Init()
end

function QuestionnaireProxy:Init()
  EventManager.Me():AddEventListener(VisitNpcEvent.AccessNpc, self.OnAccessNpc, self)
  self.resultMap = {}
  self:InitStaticData()
end

function QuestionnaireProxy:InitStaticData()
  self.staticData = {}
  self.groupCloseViewStaticDataMap = {}
  local groupData
  for _, data in pairs(Table_SchoolPaper) do
    if data.Type == 1 then
      groupData = self.staticData[data.Group] or {}
      groupData[data.Number] = data
      self.staticData[data.Group] = groupData
    elseif data.Type == 2 then
      self.groupCloseViewStaticDataMap[data.Group] = data
    end
  end
  for _, map in pairs(self.staticData) do
    if next(map) then
      local minNum = math.huge
      for num, _ in pairs(map) do
        if num < minNum then
          minNum = num
        end
      end
      map.min = minNum
    end
  end
end

function QuestionnaireProxy:OnAccessNpc(note)
  local npc = note and note.data
  self.lastVisitedNpcId = npc and npc:GetCreatureType() == Creature_Type.Npc and npc.data.id
end

function QuestionnaireProxy:GetLastVisitedNpc()
  return self.lastVisitedNpcId and SceneCreatureProxy.FindCreature(self.lastVisitedNpcId)
end

function QuestionnaireProxy:ClearLastVisitedNpc()
  self.lastVisitedNpcId = nil
end

function QuestionnaireProxy:GetQuestionDataMapByGroup(group)
  return self.staticData[group]
end

function QuestionnaireProxy:GetCloseViewQuestionDataByGroup(group)
  return self.groupCloseViewStaticDataMap[group]
end

function QuestionnaireProxy:GetMyResultByGroup(group)
  return self.resultMap[group]
end

function QuestionnaireProxy:RecvQueryPaperResult(datas)
  TableUtility.TableClear(self.resultMap)
  for i = 1, #datas do
    self.resultMap[datas[i].id] = datas[i].result
  end
end

function QuestionnaireProxy:RecvPaperQuestionInter(group)
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.QuestionnaireView,
    viewdata = {group = group}
  })
end

function QuestionnaireProxy.CallPaperResultInter(group, number)
  local data = NetConfig.PBC and {} or SceneInterlocution_pb.PaperData()
  data.id = group
  data.result = number
  ServiceSceneInterlocutionProxy.Instance:CallPaperResultInterCmd(data)
end
