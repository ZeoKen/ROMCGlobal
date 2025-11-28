BWEventData = class("BWEventData")
BWEventData.Type = {Quest = 1, MapStep = 2}

function BWEventData:ctor(type, id)
  self.type = type
  self.id = id
  if self.type == BWEventData.Type.Quest then
    local questData = QuestProxy.Instance:GetQuestDataBySameQuestID(id)
    if questData then
      if questData.staticData then
        self.name = questData.staticData.Name
      end
      if questData.pos then
        self.pos = questData.pos:Clone()
      end
      local symbolType = QuestSymbolCheck.GetQuestSymbolByQuest(questData)
      if symbolType then
        self.symbol = QuestSymbolConfig[symbolType] and QuestSymbolConfig[symbolType].UISymbol
      end
    end
    self.isComplete = QuestProxy.Instance:isQuestComplete(id)
  elseif self.type == BWEventData.Type.MapStep then
    local sData = Table_MapStep[self.id]
    if sData then
      self.name = ZhString.BWEventData_MapStepEvent
      self.symbol = ""
      self.group_id = sData.Params.group_id
      local pos = sData.Params.pos
      if pos then
        self.pos = LuaVector3.New(pos[1], pos[2], pos[3])
      end
    end
    self.isComplete = WorldMapProxy.Instance:GetMapStepForeverRewardInfo(id)
  end
end

function BWEventData:GetName()
  if self.name then
    return self.name
  end
  local keyStr = "Empty"
  for key, id in pairs(BWEventData.Type) do
    if self.type == id then
      keyStr = key
    end
  end
  return string.format("未找到事件:%s %s", tostring(keyStr), tostring(self.id))
end

function BWEventData:GetSymbol()
  return self.symbol or ""
end

function BWEventData:GetPos()
  return self.pos
end

function BWEventData:IsCompleted()
  return self.isComplete
end

function BWEventData:RefreshData()
  if self.type == BWEventData.Type.Quest then
    self.isComplete = QuestProxy.Instance:isQuestComplete(self.id)
  elseif self.type == BWEventData.Type.MapStep then
    self.isComplete = WorldMapProxy.Instance:GetMapStepForeverRewardInfo(self.id)
  end
end

function BWEventData:GetDebugPrintProgressInfo()
  local typeStr = self.type == BWEventData.Type.Quest and "Quest" or "MapStep"
  return string.format("%s %s : %s", typeStr, tostring(self.id), tostring(self.isComplete))
end
