ShortCutQuestItemCell = class("ShortCutQuestItemCell", ShortCutItemCell)

function ShortCutQuestItemCell:SetData(data)
  if not data then
    return
  end
  self.id = data.id
  self.questName = data.staticData.QuestName
  self.map = data.staticData.Map
  helplog("任务ID是", self.id, "任务名", self.questName, "地图名", self.map)
  if self.questName then
    self.npcName.text = self.questName
  end
  if self.map then
    self.mapName.text = self.map
  end
end
