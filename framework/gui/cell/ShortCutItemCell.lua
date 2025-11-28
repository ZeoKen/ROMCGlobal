local BaseCell = autoImport("BaseCell")
ShortCutItemCell = class("ShortCutItemCell", BaseCell)
local tempV3 = LuaVector3()

function ShortCutItemCell:Init()
  self.npcName = self:FindComponent("NpcName", UILabel)
  self.mapName = self:FindComponent("MapName", UILabel)
  self.questName = self:FindComponent("QuestName", UILabel)
  self.questTraceInfo = self:FindComponent("QuestTraceInfo", UILabel)
  self.traceButton = self:FindGO("TraceButton")
  self:AddClickEvent(self.traceButton, function()
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
end

function ShortCutItemCell:SetData(data)
  if not data then
    return
  end
  local event = data.Event
  if event then
    self.npcName.gameObject:SetActive(true)
    self.mapName.gameObject:SetActive(true)
    self.questName.gameObject:SetActive(false)
    self.questTraceInfo.gameObject:SetActive(false)
    self.traceId = data.id
    self.questId = data.questId
    if event.npcid then
      local npcData = Table_Npc[event.npcid]
      if npcData then
        if npcData.Guild and npcData.Guild ~= "" then
          self.npcName.text = string.format("%s<%s>", npcData.NameZh, npcData.Guild)
        else
          self.npcName.text = npcData.NameZh
        end
      else
        self.npcName.text = ""
      end
    elseif event.name then
      self.npcName.text = event.name
    else
      self.npcName.text = ""
    end
    if event.mapid then
      local mapData = Table_Map[event.mapid]
      if mapData then
        if event.npcid then
          self.mapName.text = mapData.NameZh
        else
          self.npcName.text = mapData.NameZh
          self.mapName.text = ""
        end
      else
        self.mapName.text = ""
      end
    elseif event.tip then
      self.mapName.text = event.tip
    else
      self.mapName.text = ""
    end
    if self.mapName.text == "" then
      LuaVector3.Better_Set(tempV3, -200, 0, 0)
    else
      LuaVector3.Better_Set(tempV3, -200, 16, 0)
    end
    self.npcName.transform.localPosition = tempV3
    return
  end
  self.npcName.gameObject:SetActive(false)
  self.mapName.gameObject:SetActive(false)
  self.questName.gameObject:SetActive(true)
  self.questTraceInfo.gameObject:SetActive(true)
  self.questData = data
  self.id = data.id
  local questName = data.staticData.Name
  local traceInfo = data.staticData.TraceInfo or Table_Map[data.staticData.Map].NameZh
  if self.questName then
    self.questName.text = string.format("%s%s", questName, ZhString.ServantImproveCellState_InQuest)
    UIUtil.WrapLabel(self.questName)
  end
  if self.traceInfo then
    self.questTraceInfo.text = traceInfo
  end
end
