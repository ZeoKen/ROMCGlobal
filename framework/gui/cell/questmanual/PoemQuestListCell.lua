local baseCell = autoImport("BaseCell")
PoemQuestListCell = class("PoemQuestListCell", baseCell)

function PoemQuestListCell:Init()
  self:initView()
end

function PoemQuestListCell:initView()
  self.questName = self:FindComponent("questName", UILabel)
  self.chooseSymbol = self:FindGO("ChooseSymbol")
  self.audioIcon = self:FindGO("audioIcon")
  self.pauseIcon = self:FindGO("pauseIcon")
  self:AddButtonEvent("ActiveBtn", function()
    self:PassEvent(QuestManualEvent.PoemClick, self)
  end)
  self.chooseSymbol:SetActive(false)
end

function PoemQuestListCell:setIsSelected(isSelected)
  self.chooseSymbol:SetActive(false)
  if self.isSelected ~= isSelected then
    self.isSelected = isSelected
    if isSelected then
      self.chooseSymbol:SetActive(true)
      self.questName.color = QuestManualView.ColorTheme[6].color
    elseif self.data.complete then
      self.questName.color = QuestManualView.ColorTheme[9].color
    else
      self.questName.color = QuestManualView.ColorTheme[8].color
    end
  end
end

function PoemQuestListCell:SetData(data)
  self.data = data
  if data.complete then
    self.questName.color = QuestManualView.ColorTheme[9].color
  else
    self.questName.color = QuestManualView.ColorTheme[8].color
  end
  self.questName.text = data.name
  self.isSelected = false
  self:UpdateStatus()
end

function PoemQuestListCell:UpdateStatus()
  local sdata = PlotAudioProxy.Instance:GetCurrentStoryAudio()
  if sdata then
    local playStatus = sdata:GetPlayStatus()
    if playStatus == PlotAudioData.AudioStatus.Playing then
      self.pauseIcon:SetActive(false)
      self.audioIcon:SetActive(sdata:GetAudioIndex() == self.data.questid)
      self.audioIcon.transform.localPosition = LuaGeometry.GetTempVector3(self.questName.width / 2 + 6, self.questName.gameObject.transform.localPosition.y)
    elseif playStatus == PlotAudioData.AudioStatus.Paused then
      self.audioIcon:SetActive(false)
      self.pauseIcon:SetActive(sdata:GetAudioIndex() == self.data.questid)
      self.pauseIcon.transform.localPosition = LuaGeometry.GetTempVector3(self.questName.width / 2 + 6, self.questName.gameObject.transform.localPosition.y)
    end
  else
    self.audioIcon:SetActive(false)
    self.pauseIcon:SetActive(false)
  end
end
