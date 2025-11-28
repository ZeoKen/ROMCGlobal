local baseCell = autoImport("BaseCell")
AudioPreviewCell = class("AudioPreviewCell", baseCell)
local tempVector3 = LuaVector3(-178, 12, 0)

function AudioPreviewCell:Init()
  self:initView()
end

function AudioPreviewCell:initView()
  self.icon = self:FindGO("icon"):GetComponent(UISprite)
  self.name = self:FindGO("Name"):GetComponent(UILabel)
  self.preview = self:FindGO("preview"):GetComponent(UILabel)
  self.chooseSymbol = self:FindGO("chooseSymbol")
  local statusbtn = self:FindGO("Status")
  self:AddClickEvent(statusbtn, function(obj)
    if not self.complete then
      return
    end
    local sdata = PlotAudioProxy.Instance:GetCurrentStoryAudio()
    if sdata then
      self.audioToggle = sdata.index == self.audioIndex
    else
      self.audioToggle = false
    end
    self.audioToggle = not self.audioToggle
    if self.audioToggle then
      self:PlayStoryAudio()
      self.icon.spriteName = "taskmanual_icon_Pause-playback"
    else
      self:StopStoryAudio()
      self.icon.spriteName = "taskmanual_icon_Play2"
    end
    self:PassEvent(QuestManualEvent.PlotQuestClick, self)
  end)
  self:AddClickEvent(self:FindGO("bg"), function(obj)
    self:SetUIRecord()
    self:PassEvent(QuestManualEvent.PlotQuestClick, self)
  end)
end

function AudioPreviewCell:SetData(data)
  self.index = data
  if not data then
    return
  end
  config = Table_PlotVoice[self.index]
  self.name.text = config.QuestName
  self.questName = config.QuestName
  self.audioIndex = config.StoryVoice
  self.bgmkeep = config.BgmKeep == 1
  self.mapid = config.Map
  self.complete = QuestManualProxy.Instance:CheckPlotCompleteByQuestID(config.Version, config.QuestID)
  if not self.complete then
    tempVector3[2] = 0
    self.preview.text = ""
  else
    tempVector3[2] = 12
    self.preview.text = config.Dialog
  end
  self.name.gameObject.transform.localPosition = tempVector3
  UIUtil.WrapLabel(self.preview)
end

local IconMap = {
  [PlotAudioData.AudioStatus.Default] = "taskmanual_icon_Play2",
  [PlotAudioData.AudioStatus.Playing] = "taskmanual_icon_Pause-playback",
  [PlotAudioData.AudioStatus.Paused] = "taskmanual_icon_Play2"
}

function AudioPreviewCell:UpdateAudioStatus(audioIndex)
  if self.complete then
    local sdata = PlotAudioProxy.Instance:GetCurrentStoryAudio()
    local rightType = FunctionPlotCmd.Me():IsPlayTypeEqualTo(FunctionPlotCmd.AudioSort.PlotAudio)
    if sdata and rightType then
      if audioIndex == self.audioIndex then
        self.icon.spriteName = IconMap[sdata:GetPlayStatus()]
      else
        self.icon.spriteName = IconMap[0]
      end
    else
      self.icon.spriteName = IconMap[0]
    end
  else
    self.icon.spriteName = "taskmanual_icon_lock"
    return
  end
end

function AudioPreviewCell:PlayStoryAudio()
  PlotAudioProxy.Instance:PlayPoemStory(self.audioIndex, self.bgmkeep)
  self:SetUIRecord()
end

function AudioPreviewCell:SetUIRecord()
  PlotAudioProxy.Instance.audioVersion = QuestManualProxy.Instance.lastVersion
  PlotAudioProxy.Instance.audioTab = QuestManualProxy.Instance.lastTab
  PlotAudioProxy.Instance.audioIndex = self.audioIndex
  PlotAudioProxy.Instance.mapIndex = self.mapid
end

function AudioPreviewCell:StopStoryAudio()
  PlotAudioProxy.Instance:StopStoryAudio()
end

function AudioPreviewCell:SetChoose(b)
  self.chooseSymbol:SetActive(b)
end
