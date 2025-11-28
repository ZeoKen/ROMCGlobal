autoImport("QuestTraceBaseTogCell")
QuestTraceTogCell = class("QuestTraceTogCell", QuestTraceBaseTogCell)

function QuestTraceTogCell:FindObjs()
  QuestTraceTogCell.super.FindObjs(self)
  self.mapIcon = self:FindGO("MapIcon"):GetComponent(UISprite)
  self.mapLabel = self:FindGO("MapLabel"):GetComponent(UILabel)
end

function QuestTraceTogCell:SetChooseStatus(bool)
  if self.chooseSymbol then
    self.chooseSymbol:SetActive(bool)
  else
    redlog("no chooseSymbol")
  end
end

function QuestTraceTogCell:SwitchTracedQuestInCombinedGroup()
  for i = 1, #self.questList do
    if self.curChoose.id == self.questList[i].id then
      for j = i, #self.questList do
        if self.questList[j + 1] and not self.questList[j + 1].isFinish then
          self.curChoose = self.questList[j + 1]
          self.data = self.curChoose
          self.title.text = self.curChoose.traceTitle
          return
        end
      end
      for k = 1, #self.questList do
        if not self.questList[k].isFinish and self.questList[k].id ~= self.curChoose.id then
          self.curChoose = self.questList[k]
          break
        end
      end
      self.data = self.curChoose
      self.title.text = self.curChoose.traceTitle
      break
    end
  end
end
