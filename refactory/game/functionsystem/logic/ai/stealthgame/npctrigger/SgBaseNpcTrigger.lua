SgBaseNpcTrigger = class("SgBaseNpcTrigger", ReusableObject)
SgNpcTriggerType = {eBox = 0, eVisit = 1}
SgNpcTriggerEnableType = {
  eStore = 0,
  ePDBSuccessed = 1,
  eChildCompleted = 2
}

function SgBaseNpcTrigger:DoConstruct(asArray)
end

function SgBaseNpcTrigger:DoDeconstruct()
  self.m_objClass = nil
  if self.m_creature ~= nil then
    FunctionVisitNpc.Me():UnRegisterVisitShow(self.m_uid)
    NSceneNpcProxy.Instance:Remove(self.m_uid)
    self.m_creature = nil
  end
end

function SgBaseNpcTrigger:initData(sgClass, uid, tid, historyData)
  self.m_uid = uid
  self.m_tid = tid
  self.m_objClass = sgClass
  self.m_type = sgClass.MyType
  self.m_objId = sgClass.ObjID
  self.m_objType = sgClass.ObjType
  self.m_enableType = sgClass.EnableType
  self.m_enableStore = sgClass.Score
  self.m_plotID = sgClass.PlotID
  self.m_birthPlotID = sgClass.BirthPlotID
  self.m_birthEffect = sgClass.BirthEffect
  if self.m_birthPlotID ~= nil then
    Game.PlotStoryManager:Start_PQTLP(self.m_birthPlotID, nil, nil, nil, false, nil, {
      obj = {
        id = self.m_objId,
        type = self.m_objType
      }
    }, false)
  end
  if self.m_birthEffect ~= nil then
    self.m_birthEffect:ShowEffect()
  end
  self.m_dorpItems = {}
  local tmp = sgClass.DropItems
  for i = 1, #tmp do
    table.insert(self.m_dorpItems, tmp[i])
  end
  self.m_isRepeat = sgClass.IsRepeat
  self.m_isCanDelete = sgClass.IsCanDelete
  self.m_memoryDialog = {}
  tmp = sgClass.MemoryDialogs
  for i = 1, #tmp do
    table.insert(self.m_memoryDialog, tmp[i])
  end
  tmp = sgClass.ChildTriggers
  for i = 1, #tmp do
    SgAIManager.Me():visitedTrigger(tonumber(tmp[i]))
  end
  tmp = sgClass.UseItems
  self.m_usedItems = {}
  for i = 1, #tmp do
    table.insert(self.m_usedItems, tmp[i])
  end
  self:createNpc()
  self:addEvent()
end

function SgBaseNpcTrigger:createNpc()
  local x, y, z = LuaGameObject.GetPosition(self.m_objClass.transform)
  local data = {}
  data.npcID = self.m_tid
  data.id = self.m_uid
  data.pos = {
    x = x * 1000,
    y = y * 1000,
    z = z * 1000
  }
  data.datas = {}
  data.attrs = {}
  data.mounts = {}
  local staticData = Table_Npc[data.npcID]
  data.staticData = staticData
  if staticData.NameZh ~= nil then
    data.name = staticData.NameZh
  end
  data.searchrange = 0
  self.m_creature = NSceneNpcProxy.Instance:Add(data, NNpc)
  if staticData then
    if staticData.ShowName then
      self.m_creature.data.userdata:Set(UDEnum.SHOWNAME, staticData.ShowName)
    end
    if staticData.Scale then
      self.m_creature:Server_SetScaleCmd(staticData.Scale, true)
    end
  end
  self.m_creature.assetRole:SetColliderEnable(true)
  self.m_creature.assetRole:SetPosition(self.m_objClass.transform.position)
end

function SgBaseNpcTrigger:addEvent()
  local isCanVisited = true
  if SgAIManager.Me():npcTriggerIsVisited(self.m_uid) then
    isCanVisited = false
    if self.m_isRepeat then
      isCanVisited = true
    end
  end
  if isCanVisited then
    FunctionVisitNpc.Me():RegisterVisitShow(self.m_uid, nil, function()
      self:onExecute()
      SgAIManager.Me():visitedNpcTrigger(self.m_uid)
      local dialog = self.m_memoryDialog
      if dialog and 0 < #dialog then
        SgAIManager.Me():AddMemory(dialog)
        RedTipProxy.Instance:UpdateRedTip(711)
        EventManager.Me():PassEvent(StealthGameEvent.Update_MemoryInfo)
      end
    end, nil)
  end
end

function SgBaseNpcTrigger:getUid()
  return self.m_uid
end
