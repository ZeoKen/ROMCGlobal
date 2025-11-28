PlotVoicePage = class("PlotVoicePage", SubView)
autoImport("PlotAudioData")
autoImport("AudioPreviewCell")
autoImport("MapPlotCell")
local minOffsetIndex = 5

function PlotVoicePage:Init()
end

function PlotVoicePage:TryInit()
  if not self.loaded then
    self:ReLoadPerferb("view/PlotVoicePage", false)
    self.loaded = true
    self:initView()
    self:AddListenerEvts()
    self:initData()
  end
end

function PlotVoicePage:initView()
  self.bgtexture = self:FindGO("BGTexture"):GetComponent(UITexture)
  self.plotScrollview = self:FindGO("PlotScrollview"):GetComponent(UIScrollView)
  self.plotGrid = self:FindGO("plotGrid"):GetComponent(UIGrid)
  self.plotGridCtrl = UIGridListCtrl.new(self.plotGrid, MapPlotCell, "MapPlotCell")
  self.audioScrollview = self:FindGO("AudioScrollview"):GetComponent(UIScrollView)
  self.audioGrid = self:FindGO("AudioGrid"):GetComponent(UIGrid)
  self.centeron = self.audioGrid:GetComponent(MyUICenterOnChild)
  self.audioGridCtrl = UIGridListCtrl.new(self.audioGrid, AudioPreviewCell, "AudioPreviewCell")
  self.textContainer = self:FindGO("TextContainer"):GetComponent(UIRichLabel)
  self.contentContainer = self:FindGO("ContentContainer")
  self.noData = self:FindGO("NoData")
  self.noDataTip = self:FindGO("NoDataTip")
  self.noDataTipLabel = self.noDataTip:GetComponent(UILabel)
  self.textScrollview = self:FindGO("Scroll View", self.contentContainer):GetComponent(UIScrollView)
end

function PlotVoicePage:AddListenerEvts()
  self.plotGridCtrl:AddEventListener(QuestManualEvent.PlotVoiceClick, self.UpdateQuestList, self)
  self.audioGridCtrl:AddEventListener(QuestManualEvent.PlotQuestClick, self.UpdateDialog, self)
  self:AddListenEvt(StoryAudioEvent.StoryAudioPause, self.StoryAudioPause)
  self:AddListenEvt(StoryAudioEvent.StoryAudioResume, self.StoryAudioResume)
  self:AddListenEvt(StoryAudioEvent.StoryAudioEnd, self.HandleStoryAudioEnd)
  self:AddListenEvt(StoryAudioEvent.StoryAudioStart, self.HandleStoryAudioStart)
end

function PlotVoicePage:initData()
  self.audioToggle = false
  self.first = true
end

function PlotVoicePage:Show(target)
  self.first = true
  self:TryInit()
  PlotVoicePage.super.Show(self, target)
  PictureManager.Instance:SetPuzzleBG("taskmanual_bg_bottom4_new", self.bgtexture)
end

function PlotVoicePage:Hide(target)
  self:TryInit()
  helplog("====PlotVoicePage:Hide==>>>")
  PlotVoicePage.super.Hide(self, target)
end

local plotQuestList, plotVoicetList

function PlotVoicePage:SetData(version)
  self:TryInit()
  self.currentVersion = version
  self.currentSelectedCell = nil
  plotVoicetList = QuestManualProxy.Instance:GetPlotVoiceData(version)
  self.contentContainer:SetActive(plotVoicetList ~= nil)
  self.noData:SetActive(not plotVoicetList)
  self.plotGrid.gameObject:SetActive(plotVoicetList ~= nil)
  if plotVoicetList then
    self.plotGridCtrl:ResetDatas(plotVoicetList:GetMapList())
  end
  local cells = self.plotGridCtrl:GetCells()
  local mapIndex = PlotAudioProxy.Instance.mapIndex
  local check = PlotAudioProxy.Instance.lastVersion
  if cells and #cells ~= 0 then
    if mapIndex and self.first then
      for i = 1, #cells do
        if cells[i].data.mapID == mapIndex then
          self:UpdateQuestList(cells[i])
          self.first = false
        end
      end
      if self.first then
        self:UpdateQuestList(cells[1])
      end
    else
      self:UpdateQuestList(cells[1])
    end
  end
end

function PlotVoicePage:UpdateQuestList(cell)
  local plotdata = QuestManualProxy.Instance:GetPlotVoiceData(self.currentVersion)
  self.audioGrid.gameObject:SetActive(plotdata ~= nil)
  self.textContainer.text = ""
  if plotdata then
    plotQuestList = plotdata:GetMapQuestList(cell.data.mapID)
    self.audioGridCtrl:ResetDatas(plotQuestList)
    local cells = self.audioGridCtrl:GetCells()
    if self:CenterOnChild() and cells and #cells ~= 0 then
      self:UpdateDialog(cells[1])
    end
    local sdata = PlotAudioProxy.Instance:GetCurrentStoryAudio()
    local audioindex = sdata and sdata:GetAudioIndex() or 0
    for i = 1, #cells do
      cells[i]:UpdateAudioStatus(audioindex)
    end
  end
  if self.currentSelectedCell then
    if self.currentSelectedCell == cell then
      return
    else
      self.currentSelectedCell:setIsSelected(false)
    end
  end
  self.currentSelectedCell = cell
  self.currentSelectedCell:setIsSelected(true)
end

function PlotVoicePage:UpdateDialog(cell)
  local index = cell.index
  if index then
    if cell.complete then
      self.textContainer.text = Table_PlotVoice[index].Dialog
      self.noDataTip:SetActive(false)
    else
      self.textContainer.text = ""
      self.noDataTipLabel.text = string.format(ZhString.PlotVoicePage_UnLockQuest, cell.questName)
      self.noDataTip:SetActive(true)
    end
  end
  local cells = self.audioGridCtrl:GetCells()
  if cells then
    for i = 1, #cells do
      cells[i]:SetChoose(cells[i].index == index)
    end
  end
  self.textScrollview:ResetPosition()
end

function PlotVoicePage:UpdateAudioStatus()
  local sdata = PlotAudioProxy.Instance:GetCurrentStoryAudio()
  if sdata then
    audioindex = sdata:GetAudioIndex() or 0
  end
  local cells = self.audioGridCtrl:GetCells()
  for i = 1, #cells do
    cells[i]:UpdateAudioStatus(audioindex)
  end
end

function PlotVoicePage:StoryAudioPause()
  self:UpdateAudioStatus()
end

function PlotVoicePage:StoryAudioResume()
  self:UpdateAudioStatus()
end

function PlotVoicePage:HandleStoryAudioEnd()
  self:UpdateAudioStatus()
end

function PlotVoicePage:HandleStoryAudioStart()
  self:UpdateAudioStatus()
end

function PlotVoicePage:CenterOnChild()
  if not self.first then
    return true
  end
  local centerIndex = PlotAudioProxy.Instance.audioIndex
  if not centerIndex then
    return true
  end
  local sCells = self.audioGridCtrl:GetCells()
  local cellIndex
  for i = 1, #sCells do
    if sCells[i] and sCells[i].audioIndex == centerIndex then
      self.curCell = sCells[i]
      cellIndex = i
    end
  end
  if not cellIndex then
    redlog("true")
    return true
  end
  redlog("cellIndex", cellIndex)
  if self.curCell then
    if cellIndex >= minOffsetIndex then
      self.centeron:CenterOn(self.curCell.gameObject.transform)
    end
    self:UpdateDialog(self.curCell)
  end
end
