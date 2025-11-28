PoemStoryPage = class("PoemStoryPage", SubView)
autoImport("PoemQuestListCell")
autoImport("PoemAwardCell")
autoImport("PoemstoryLockCell")
autoImport("MapPlotCell")
local reusableArray = {}
local questInstance = QuestProxy.Instance
local Offset = 50
local tempVector3 = LuaVector3.Zero()
local minOffsetIndex = 13

function PoemStoryPage:Init()
end

function PoemStoryPage:TryInit()
  if not self.loaded then
    self:ReLoadPerferb("view/PoemStoryPage", false)
    self.loaded = true
    self:initView()
    self:addViewEventListener()
    self:AddListenerEvts()
    self:initData()
  end
end

function PoemStoryPage:initView()
  self.anecdoteTable = self:FindGO("AnecdoteTable"):GetComponent(UITable)
  self.poemTag = self:FindGO("poemTag")
  self.poemArrow = self:FindGO("Arrow", self.poemTag)
  self.poemArrowSp = self.poemArrow:GetComponent(UISprite)
  self.poemArrowFolderState = true
  self.plotTag = self:FindGO("plotTag")
  self.plotArrow = self:FindGO("Arrow", self.plotTag)
  self.plotArrowSp = self.plotArrow:GetComponent(UISprite)
  self.plotArrowFolderState = true
  self.poemPanel = self:FindGO("PoemPanel")
  self.poemStoryTagTable = self:FindGO("poemStoryTagTable"):GetComponent(UITable)
  self.questDescription = self:FindComponent("QuestDescription", UILabel)
  self.storyName = self:FindComponent("StoryName", UILabel)
  self.storyListGrid = self:FindGO("storyListGrid")
  self.storylistSV = self:FindGO("ScrollView_StoryList"):GetComponent(UIScrollView)
  self.storylistcenterOnChild = self.storylistSV.gameObject:GetComponent(MyUICenterOnChild)
  self.uiGridOfStoryList = self.storyListGrid:GetComponent(UIGrid)
  if self.listControllerOfStoryList == nil then
    self.listControllerOfStoryList = UIGridListCtrl.new(self.uiGridOfStoryList, PoemQuestListCell, "PoemQuestListCell")
    self.listCellsOfStoryList = self.listControllerOfStoryList:GetCells()
  end
  self.poemAward = self:FindGO("PoemAward")
  self.poemAwardGrid = self:FindGO("poemAwardGrid")
  self.uiGridOfPoemAward = self.poemAwardGrid:GetComponent(UIGrid)
  if self.listControllerOfPoemAward == nil then
    self.listControllerOfPoemAward = UIGridListCtrl.new(self.uiGridOfPoemAward, PoemAwardCell, "PoemAwardCell")
  end
  self.modeltexture = self:FindComponent("ModelTexture", UITexture)
  self.nPCName = self:FindComponent("NPCName", UILabel)
  self.progressScrollView = self:FindGO("ProgressScrollView")
  self.scrollview = self:FindComponent("ScrollView", UIScrollView)
  self.table = self:FindComponent("Table", UITable)
  self.poemAwardScrollView = self:FindComponent("PoemAwardScrollView", UIScrollView)
  self.panel = self:FindGO("panel")
  self.noData = self:FindGO("NoData")
  self.locklistGrid = self:FindGO("LockList"):GetComponent(UIGrid)
  self.locklistCtr = UIGridListCtrl.new(self.locklistGrid, PoemstoryLockCell, "PoemstoryLockCell")
  self.locktip = self:FindGO("LockTip")
  self.bgtexture = self:FindGO("BGTexture"):GetComponent(UITexture)
  self.plotPanel = self:FindGO("PlotPanel")
  self.plotStoryTagTable = self:FindGO("plotStoryTagTable"):GetComponent(UITable)
  self.bgtexture = self:FindGO("BGTexture"):GetComponent(UITexture)
  self.plotGrid = self:FindGO("plotGrid"):GetComponent(UIGrid)
  self.plotGridObj = self:FindGO("plotGrid")
  self.plotGridCtrl = UIGridListCtrl.new(self.plotGrid, MapPlotCell, "MapPlotCell")
  self.plotGridCells = self.plotGridCtrl:GetCells()
  self.audioScrollview = self:FindGO("AudioScrollview"):GetComponent(UIScrollView)
  self.audioGrid = self:FindGO("AudioGrid"):GetComponent(UIGrid)
  self.centeron = self.audioGrid:GetComponent(MyUICenterOnChild)
  self.audioGridCtrl = UIGridListCtrl.new(self.audioGrid, AudioPreviewCell, "AudioPreviewCell")
  self.textContainer = self:FindGO("TextContainer"):GetComponent(UIRichLabel)
  self.noData = self:FindGO("NoData")
  self.noDataLabel = self:FindGO("Label", self.noData):GetComponent(UILabel)
  self.noDataLabel.text = string.format(ZhString.QuestManual_NoneTip, ZhString.QuestManual_AnecdotePage)
  self.noDataTip = self:FindGO("NoDataTip")
  self.noDataTipLabel = self.noDataTip:GetComponent(UILabel)
  self.textScrollview = self:FindGO("Scroll View", self.plotPanel):GetComponent(UIScrollView)
end

function PoemStoryPage:Show(target)
  self:TryInit()
  helplog("====PoemStoryPage:show==>>>")
  PoemStoryPage.super.Show(self, target)
end

function PoemStoryPage:Hide(target)
  self:TryInit()
  helplog("====PoemStoryPage:Hide==>>>")
  if self.modeltexture then
    UIModelUtil.Instance:ResetTexture(self.modeltexture)
  end
  PoemStoryPage.super.Hide(self, target)
end

function PoemStoryPage:initData()
end

function PoemStoryPage:SetData(version)
  self:TryInit()
  self.panel:SetActive(true)
  self.currentVersion = version
  local manualQuestDatas = QuestManualProxy.Instance:GetManualQuestDatas(version)
  if not manualQuestDatas then
    self.poemPanel:SetActive(false)
    self.poemHasInfo = false
    self.poemTag:SetActive(false)
    self.storyListGrid:SetActive(false)
    return
  end
  poemStorys = manualQuestDatas.storyQuestList
  self.currentSelectedCell = nil
  if poemStorys and #poemStorys > 0 then
    self.poemPanel:SetActive(true)
    self.poemHasInfo = true
    self.poemTag:SetActive(true)
    self.storyListGrid:SetActive(self.poemArrowFolderState)
    self.listControllerOfStoryList:ResetDatas(poemStorys)
    self.uiGridOfStoryList:Reposition()
    self.storylistSV:ResetPosition()
    self.poemStoryTagTable:Reposition()
  else
    self.listControllerOfStoryList:ResetDatas()
    self.poemPanel:SetActive(false)
    self.poemHasInfo = false
    self.poemTag:SetActive(false)
    self.storyListGrid:SetActive(false)
  end
  plotVoicetList = QuestManualProxy.Instance:GetPlotVoiceData(version)
  self.plotPanel:SetActive(plotVoicetList ~= nil and not self.poemPanel.activeSelf)
  self.plotHasInfo = plotVoicetList ~= nil
  self.plotTag:SetActive(plotVoicetList ~= nil)
  self.plotGrid.gameObject:SetActive(self.plotArrowFolderState)
  if plotVoicetList then
    self.plotGridCtrl:ResetDatas(plotVoicetList:GetMapList())
    self.plotGrid:Reposition()
    self.plotStoryTagTable:Reposition()
  else
    self.plotGridCtrl:ResetDatas()
  end
  if not self.poemHasInfo and not self.plotHasInfo then
    self.noData:SetActive(true)
    self.panel:SetActive(false)
  else
    self.noData:SetActive(false)
    self.panel:SetActive(true)
  end
  self.anecdoteTable:Reposition()
  self.storylistSV:ResetPosition()
  local firstCell = self.listCellsOfStoryList[1]
  if firstCell then
    self:UpdatePoemDetails(firstCell)
    return
  end
  local cells = self.plotGridCells
  local mapIndex = PlotAudioProxy.Instance.mapIndex
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

function PoemStoryPage:OnEnter()
end

function PoemStoryPage:OnExit()
end

function PoemStoryPage:addViewEventListener()
  self:AddClickEvent(self.poemArrow, function()
    self.poemArrowFolderState = not self.poemArrowFolderState
    self.storyListGrid:SetActive(self.poemArrowFolderState)
    self.uiGridOfStoryList:Reposition()
    self.anecdoteTable:Reposition()
    if self.poemArrowFolderState then
      self.poemArrowSp.flip = 0
    else
      self.poemArrowSp.flip = 1
    end
  end)
  self:AddClickEvent(self.plotArrow, function()
    self.plotArrowFolderState = not self.plotArrowFolderState
    self.plotGridObj:SetActive(self.plotArrowFolderState)
    self.plotGrid:Reposition()
    self.anecdoteTable:Reposition()
    if self.plotArrowFolderState then
      self.plotArrowSp.flip = 0
    else
      self.plotArrowSp.flip = 1
    end
  end)
end

function PoemStoryPage:AddListenerEvts()
  self.listControllerOfStoryList:AddEventListener(QuestManualEvent.PoemClick, self.UpdatePoemDetails, self)
  self.plotGridCtrl:AddEventListener(QuestManualEvent.PlotVoiceClick, self.UpdateQuestList, self)
  self.audioGridCtrl:AddEventListener(QuestManualEvent.PlotQuestClick, self.UpdateDialog, self)
  self:AddListenEvt(StoryAudioEvent.StoryAudioPause, self.StoryAudioPause)
  self:AddListenEvt(StoryAudioEvent.StoryAudioResume, self.StoryAudioResume)
  self:AddListenEvt(StoryAudioEvent.StoryAudioEnd, self.HandleStoryAudioEnd)
  self:AddListenEvt(StoryAudioEvent.StoryAudioStart, self.HandleStoryAudioStart)
end

function PoemStoryPage:UpdatePoemDetails(cell)
  self.poemPanel:SetActive(true)
  self.plotPanel:SetActive(false)
  for _, c in pairs(self.listCellsOfStoryList) do
    c:setIsSelected(false)
  end
  for _, c in pairs(self.plotGridCells) do
    c:setIsSelected(false)
  end
  self.currentSelectedCell = cell
  self.currentSelectedCell:setIsSelected(true)
  local poemData = Table_PomeStory[self.currentSelectedCell.data.questid]
  if poemData then
    self.storyName.text = poemData.QuestName
    local indent = UIUtil.GetIndentString()
    self.questDescription.text = indent
    LuaVector3.Better_Set(tempVector3, 0, poemData.NpcSpace or 0, 0)
    self.modeltexture.gameObject.transform.localPosition = tempVector3
    local poemDialogList = {}
    local poemDialogLockList = {}
    local currentStep = 0
    local currentManual = QuestManualProxy.Instance:GetManualQuestDatas(self.currentVersion)
    local showlist = self:CheckList(poemData, currentManual)
    poemDialogLockList, poemDialogList = self:CheckStep(showlist, currentManual)
    local count = #poemDialogList
    for i = 1, count do
      local dialogData = DialogUtil.GetDialogData(poemDialogList[i])
      if dialogData then
        self.questDescription.text = self.questDescription.text .. dialogData.Text .. "\n　　"
      end
      if i == count then
        function self.questDescription.onChange()
          self.table:Reposition()
        end
      end
    end
    UIUtil.FitLableSpaceChangeLine(self.questDescription)
    self.progressScrollView:SetActive(#poemDialogList ~= 0)
    self.locktip:SetActive(#poemDialogLockList ~= 0 and #poemDialogList ~= 0)
    self.scrollview:ResetPosition()
    local datalist = {}
    for i = 1, #poemDialogLockList do
      local single = {}
      local ps = Table_PoemStep[poemDialogLockList[i]]
      single.name = ps.name
      single.QuestName = ps.TraceInfo
      datalist[#datalist + 1] = single
    end
    self.locklistCtr:ResetDatas(datalist)
    self:Show3DModel(poemData.Npcid)
    self.table:Reposition()
    self.scrollview:ResetPosition()
  end
  if cell.data.complete then
    self.poemAward:SetActive(false)
    self:ResizeScrollview(true)
  else
    self.poemAward:SetActive(true)
    self:ResizeScrollview(false)
    TableUtility.ArrayClear(reusableArray)
    local rewardIds = self.currentSelectedCell.data.allrewardid
    if rewardIds and 0 < #rewardIds then
      for i = 1, #rewardIds do
        local rewardId = rewardIds[i]
        local rewards = ItemUtil.GetRewardItemIdsByTeamId(rewardId)
        if rewards and 0 < #rewards then
          for i = 1, #rewards do
            table.insert(reusableArray, rewards[i])
          end
        end
      end
    end
    self.listControllerOfPoemAward:ResetDatas(reusableArray)
    self.poemAwardScrollView:ResetPosition()
  end
end

function PoemStoryPage:Show3DModel(npcid)
  local sdata = Table_Npc[npcid]
  if sdata then
    local otherScale = 1
    if sdata.Shape then
      otherScale = GameConfig.UIModelScale[sdata.Shape] or 1
    else
    end
    if sdata.Scale then
      otherScale = sdata.Scale
    end
    self.nPCName.text = sdata.NameZh
    self.nPCName.gameObject:SetActive(sdata.ShowName == 2)
    UIModelUtil.Instance:SetCellTransparent(self.modelTexture)
    self.model = UIModelUtil.Instance:SetNpcModelTexture(self.modeltexture, sdata.id)
    local showPos = sdata.LoadShowPose
    if showPos and #showPos == 3 then
      LuaVector3.Better_Set(tempVector3, showPos[1] or 0, showPos[2] or 0, showPos[3] or 0)
      self.model:SetPosition(tempVector3)
    end
    if sdata.LoadShowRotate then
      self.model:SetEulerAngleY(sdata.LoadShowRotate)
    end
    if sdata.LoadShowSize then
      otherScale = sdata.LoadShowSize
    end
    self.model:SetScale(otherScale)
  end
end

function PoemStoryPage:CheckList(poemData, currentManualdata)
  if #poemData.ShowList ~= 0 then
    return poemData.ShowList
  else
    return poemData.Option1
  end
  if poemData.NoMustQuestID and poemData.NoMustQuestID[2] then
    local op2 = poemData.NoMustQuestID[2]
    for k, v in pairs(op2) do
      if currentManualdata.poemCompleteList[v] then
        return poemData.Option2
      end
      if questInstance:getQuestDataByIdAndType(v) then
        return poemData.Option2
      end
    end
  end
end

function PoemStoryPage:CheckStep(checklist, currentManualdata)
  local locklist = {}
  local dialoglist = {}
  for i = 1, #checklist do
    local stepData = Table_PoemStep[checklist[i]]
    local flag = true
    if currentManualdata.poemCompleteList[stepData.Questid] then
      flag = false
    end
    local questdata = questInstance:getQuestDataByIdAndType(stepData.Questid)
    if questdata and questdata.step > stepData.step then
      flag = false
    end
    if stepData.SubQuestid and stepData.SubStep then
      flag = true
      if currentManualdata.poemCompleteList[stepData.SubQuestid] then
        flag = false
      end
      local subQuestdata = questInstance:getQuestDataByIdAndType(stepData.SubQuestid)
      if subQuestdata and subQuestdata.step > stepData.SubStep then
        flag = false
      end
    end
    if flag then
      locklist[#locklist + 1] = checklist[i]
    else
      for i = 1, #stepData.Descrip do
        dialoglist[#dialoglist + 1] = stepData.Descrip[i]
      end
    end
  end
  return locklist, dialoglist
end

function PoemStoryPage:ResizeScrollview(isExtended)
  if self.scrollview.panel then
    if isExtended then
      self.scrollview.panel.baseClipRegion = Vector4(0, -50, 414, 358 + Offset * 2)
    else
      self.scrollview.panel.baseClipRegion = Vector4(0, 0, 414, 358)
    end
  end
end

function PoemStoryPage:UpdateQuestList(cell)
  self.poemPanel:SetActive(false)
  self.plotPanel:SetActive(true)
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
  for _, c in pairs(self.listCellsOfStoryList) do
    c:setIsSelected(false)
  end
  for _, c in pairs(self.plotGridCells) do
    c:setIsSelected(false)
  end
  self.currentSelectedCell = cell
  self.currentSelectedCell:setIsSelected(true)
end

function PoemStoryPage:UpdateDialog(cell)
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

function PoemStoryPage:UpdateAudioStatus()
  local sdata = PlotAudioProxy.Instance:GetCurrentStoryAudio()
  if sdata then
    audioindex = sdata:GetAudioIndex() or 0
  end
  local cells = self.audioGridCtrl:GetCells()
  for i = 1, #cells do
    cells[i]:UpdateAudioStatus(audioindex)
  end
end

function PoemStoryPage:StoryAudioPause()
  self:UpdateAudioStatus()
end

function PoemStoryPage:StoryAudioResume()
  self:UpdateAudioStatus()
end

function PoemStoryPage:HandleStoryAudioEnd()
  self:UpdateAudioStatus()
end

function PoemStoryPage:HandleStoryAudioStart()
  self:UpdateAudioStatus()
end

function PoemStoryPage:CenterOnChild()
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
