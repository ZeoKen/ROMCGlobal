QuestTracePanel = class("QuestTracePanel", BaseView)
autoImport("PopupGridList")
autoImport("QuestTypeTabCell")
autoImport("QuestTraceTogCell")
autoImport("QuestTableRewardCell")
autoImport("QuestTraceCombineCell")
autoImport("QuestTraceRewardCell")
autoImport("QuestTraceSubCell")
autoImport("MainQuestTraceCombineCell")
autoImport("HeroQuestTraceCombineCell")
autoImport("KnightPrestigeLevelCell")
autoImport("KnightPrestigeLabelCell")
QuestTracePanel.ViewType = UIViewType.NormalLayer
local questTypeTog = GameConfig.Quest.QuestTraceGroup
local PageEnum = {
  Common = 1,
  Main = 2,
  Hero = 3
}
local picIns = PictureManager.Instance
local decorateTextureNameMap = {
  BGTexture = "calendar_bg1_picture2",
  Heart_1 = "Missiontracking_heart_1",
  Heart_2 = "Missiontracking_heart_2",
  Heart_3 = "Missiontracking_heart_3",
  Heart_4 = "Missiontracking_heart_4",
  Heart_5 = "Missiontracking_heart_5",
  Heart_6 = "Missiontracking_heart_6",
  Heart_7 = "Missiontracking_heart_7"
}
local sliderGradientColor = {
  [1] = {
    109,
    38,
    255
  },
  [2] = {
    243,
    108,
    255
  }
}

function QuestTracePanel:Init()
  self:FindObjs()
  self:InitDatas()
  self:AddEvts()
  self:AddMapEvts()
  self:InitShow()
  self:AddCloseButtonEvent()
end

function QuestTracePanel:FindObjs()
  QuestTracePanel.instance = self
  local questTypeTog = self:FindGO("QuestTypeTog")
  self.questTypeScrollView = self:FindGO("QuestTypeScrollView", questTypeTog):GetComponent(UIScrollView)
  self.questTypeGrid = self:FindGO("QuestTypeGrid", questTypeTog):GetComponent(UITable)
  self.questTypeTogCtrl = UIGridListCtrl.new(self.questTypeGrid, QuestTypeTabCell, "QuestTypeTabCell")
  self.questTypeTogCtrl:AddEventListener(QuestEvent.QuestTraceSwitchPage, self.ClickTypeTog, self)
  local questList = self:FindGO("QuestList")
  self.questScrollView = self:FindGO("QuestScrollView"):GetComponent(UIScrollView)
  self.questSVPanel = self:FindGO("QuestScrollView"):GetComponent(UIPanel)
  self.questTable = self:FindGO("QuestTable", questList):GetComponent(UITable)
  self.mainQuestTable = self:FindGO("MainQuestTable", questList):GetComponent(UITable)
  self.questListCtrl = UIGridListCtrl.new(self.questTable, QuestTraceCombineCell, "QuestTraceCombineCell")
  self.questListCtrl:AddEventListener(MouseEvent.MouseClick, self.ClickGoal, self)
  self.questListCtrl:AddEventListener(QuestEvent.QuestTraceChange, self.HandleTraceStatusUpdate, self)
  self.mainQuestCtrl = UIGridListCtrl.new(self.mainQuestTable, MainQuestTraceCombineCell, "MainQuestTraceCombineCell")
  self.mainQuestCtrl:AddEventListener(MouseEvent.MouseClick, self.ClickMainGoal, self)
  self.mainQuestCtrl:AddEventListener(QuestEvent.QuestTraceChange, self.HandleTraceStatusUpdate, self)
  self.mainQuestCtrl:AddEventListener(QuestEvent.QuestTraceShowPuzzleImage, self.HandleShowPuzzleImage, self)
  self.heroQuestTable = self:FindGO("HeroQuestTable"):GetComponent(UITable)
  self.heroQuestCtrl = UIGridListCtrl.new(self.heroQuestTable, HeroQuestTraceCombineCell, "MainQuestTraceCombineCell")
  self.heroQuestCtrl:AddEventListener(MouseEvent.MouseClick, self.ClickHeroGoal, self)
  self.heroQuestCtrl:AddEventListener(QuestEvent.QuestTraceChange, self.HandleTraceStatusUpdate, self)
  self.hideToggle = self:FindGO("HideToggle"):GetComponent(UIToggle)
  self.hideToggleGO = self.hideToggle.gameObject
  self.noneTip = self:FindGO("NoneTip")
  self.questInfoPart = self:FindGO("QuestInfo")
  self.questInfoDetail = self:FindGO("QuestInfoDetail", self.questInfoPart)
  self.questDetail = self:FindGO("QuestDetail", self.questInfoPart)
  self.noQuestTip = self:FindGO("NoQuestInfoTip", self.questInfoPart)
  self.lockStatus = self:FindGO("LockStatus", self.questInfoPart)
  self.lockLabel = self:FindGO("LockLabel", self.lockStatus):GetComponent(UIRichLabel)
  self.lockLabel = SpriteLabel.new(self.lockLabel, nil, 40, 40, true)
  self.lockBg = self:FindGO("LockBg", self.lockStatus):GetComponent(UISprite)
  self.lockIcon = self:FindGO("LockIcon", self.lockStatus)
  self.tipLabel = self:FindGO("TipLabel", self.questInfoPart):GetComponent(UILabel)
  self.questTitle = self:FindGO("QuestTitle"):GetComponent(UILabel)
  self.traceInfoGO = self:FindGO("TraceInfo")
  self.traceInfo = self:FindComponent("TraceInfo", UIRichLabel)
  self.traceInfo = SpriteLabel.new(self.traceInfo, nil, 20, 20)
  self.mapIcon = self:FindGO("MapIcon"):GetComponent(UISprite)
  self.mapLabel = self:FindGO("MapLabel"):GetComponent(UILabel)
  self.traceBtn = self:FindGO("TraceBtn")
  self.traceBtn_BoxCollider = self.traceBtn:GetComponent(BoxCollider)
  self.repairBtn = self:FindGO("RepairBtn")
  self.rewardPart = self:FindGO("RewardPart")
  self.rewardTip = self:FindGO("RewardTip", self.rewardPart):GetComponent(UILabel)
  self.rewardScrollView = self:FindGO("RewardScrollView"):GetComponent(UIScrollView)
  self.rewardGrid = self:FindGO("RewardGrid"):GetComponent(UIGrid)
  self.rewardListCtrl = UIGridListCtrl.new(self.rewardGrid, QuestTraceRewardCell, "QuestTraceRewardCell")
  self.rewardListCtrl:AddEventListener(MouseEvent.MouseClick, self.ClickRewardCell, self)
  self.scenicSpotCell = self:FindGO("ScenicSpotCell")
  self.sceneSpotList = self:FindGO("ScenicSpotList")
  local sceneSpotTipLabel = self:FindGO("SceneSpotTip", self.sceneSpotList):GetComponent(UILabel)
  sceneSpotTipLabel.text = ZhString.QuestDetailTip_UnlockInfo
  self.sceneSpotScrollView = self:FindGO("ScenicSpotScrollView"):GetComponent(UIScrollView)
  self.sceneSpotGrid = self:FindGO("ScenicSpotGrid"):GetComponent(UITable)
  self.sceneSpotGridCtrl = UIGridListCtrl.new(self.sceneSpotGrid, QuestTableRewardCell, "QuestTableRewardCellType2")
  self.traceCount = self:FindGO("TraceCount"):GetComponent(UILabel)
  self.stick = self:FindGO("Stick"):GetComponent(UISprite)
  self.mainStoryPart = self:FindGO("MainStory")
  self.finishDecorate = self:FindGO("FinishDecorate", self.mainStoryPart)
  self.lineGO = self:FindGO("Line", self.mainStoryPart)
  self.storyGainSymbol = self:FindGO("StoryGain", self.mainStoryPart)
  self.storyTitle = self:FindGO("StoryTitle", self.mainStoryPart):GetComponent(UILabel)
  self.storyScrollView = self:FindGO("StoryScrollView", self.mainStoryPart):GetComponent(UIScrollView)
  self.storyLabel = self:FindGO("StoryLabel", self.mainStoryPart):GetComponent(UILabel)
  self.lineCell = {}
  self.prequestScrollView = self:FindGO("PreQuestScrollView", self.questInfoDetail):GetComponent(UIScrollView)
  self.prequestPanel = self:FindGO("PreQuestScrollView", self.questInfoDetail):GetComponent(UIPanel)
  self.prequestGrid = self:FindGO("PrequestGrid"):GetComponent(UIGrid)
  self.prequestCtrl = UIGridListCtrl.new(self.prequestGrid, QuestTraceSubCell, "QuestTraceSubCell")
  self.prequestCtrl:AddEventListener(MouseEvent.MouseClick, self.handleClickPrequestCell, self)
  self.heroQuestKey = self:FindGO("HeroQuestKey")
  self.heroQuestKeyCount = self:FindGO("HeroQuestKeyCount", self.heroQuestKey):GetComponent(UILabel)
  self.heroQuestKeyTipLabel = self:FindGO("KeyTipLabel", self.heroQuestKey):GetComponent(UILabel)
  self.heroQuestKey_Icon = self:FindGO("KeyIcon", self.heroQuestKey):GetComponent(UISprite)
  self.heroQuestKeyTipLabel.text = ZhString.HeroStory_KeyCount
  local iconName = "n_topazkey"
  IconManager:SetItemIcon(iconName, self.heroQuestKey_Icon)
  self.heroQuestKey:SetActive(false)
  self.unlockBtn = self:FindGO("UnlockBtn")
  self.unlockBtn_KeyIcon = self:FindGO("KeyIcon", self.unlockBtn):GetComponent(UISprite)
  self.unlockBtn_BoxCollider = self.unlockBtn:GetComponent(BoxCollider)
  IconManager:SetItemIcon(iconName, self.unlockBtn_KeyIcon)
  self.questManualBtn = self:FindGO("QuestManual")
  self.puzzlePart = self:FindGO("Puzzle")
  self.puzzleTexture = self:FindGO("PuzzleTexture", self.puzzlePart):GetComponent(UITexture)
  self.closePuzzle = self:FindGO("ClosePuzzle", self.puzzlePart)
  self:AddClickEvent(self.closePuzzle, function()
    self.puzzlePart:SetActive(false)
  end)
  self:InitKnightPrestige()
  self.questManualBtn:SetActive(false)
  for objName, _ in pairs(decorateTextureNameMap) do
    self[objName] = self:FindComponent(objName, UITexture, self.gameObject)
  end
end

function QuestTracePanel:InitKnightPrestige()
  self.knightPrestigePanel = self:FindGO("KnightPrestigePanel")
  self.knightPrestigeValue = self:FindGO("PrestigeValue", self.knightPrestigePanel):GetComponent(UILabel)
  self.knightPrestigeDailyLimitLabel = self:FindGO("DailyLimit", self.knightPrestigePanel):GetComponent(UILabel)
  self.sliderScrollView = self:FindGO("SliderScrollView"):GetComponent(UIScrollView)
  self.sliderGrid = self:FindGO("SliderGrid"):GetComponent(UIGrid)
  self.sliderCtrl = UIGridListCtrl.new(self.sliderGrid, KnightPrestigeLevelCell, "KnightPrestigeLevelCell")
  self.sliderCtrl:AddEventListener(MouseEvent.MouseClick, self.handleClickPrestigeLevel, self)
  self.sliderBG = self:FindGO("SliderBg"):GetComponent(UISprite)
  self.sliderFore = self:FindGO("SliderFore"):GetComponent(UISprite)
  self.lvInfoScrollView = self:FindGO("LvInfoScrollView", self.knightPrestigePanel):GetComponent(UIScrollView)
  self.lvInfoTable = self:FindGO("LvInfoTable", self.knightPrestigePanel):GetComponent(UITable)
  self.ruleInfoLabel = self:FindGO("RuleInfoLabel", self.lvInfoTable.gameObject):GetComponent(UILabel)
  self.ruleGoToBtn = self:FindGO("GoToBtn", self.ruleInfoLabel.gameObject)
  self.ruleLabel = self:FindGO("RuleLabel", self.ruleInfoLabel.gameObject):GetComponent(UILabel)
  self:AddClickEvent(self.ruleGoToBtn, function()
    if not self.prestigeGoToModeID then
      return
    end
    FuncShortCutFunc.Me():CallByID(self.prestigeGoToModeID)
    self:CloseSelf()
  end)
  self.upgradeLabel = self:FindGO("UpgradeLabel", self.lvInfoTable.gameObject):GetComponent(UILabel)
  self.upgradeGrid = self:FindGO("Grid", self.upgradeLabel.gameObject):GetComponent(UIGrid)
  self.upgradeCtrl = UIGridListCtrl.new(self.upgradeGrid, KnightPrestigeLabelCell, "KnightPrestigeLabelCell")
  self.unlockTipLabel = self:FindGO("UnlockTipLabel", self.lvInfoTable.gameObject):GetComponent(UILabel)
  self.unlockTipGrid = self:FindGO("Grid", self.unlockTipLabel.gameObject):GetComponent(UIGrid)
  self.unlockTipCtrl = UIGridListCtrl.new(self.unlockTipGrid, KnightPrestigeUnlockCell, "KnightPrestigeLabelCell")
  self.upgradeRewardTipLabel = self:FindGO("UpgradeRewardTipLabel", self.knightPrestigePanel):GetComponent(UILabel)
  self.upgradeRewardGrid = self:FindGO("RewardGrid", self.upgradeRewardTipLabel.gameObject):GetComponent(UIGrid)
  self.upgradeRewardCtrl = UIGridListCtrl.new(self.upgradeRewardGrid, BagItemCell, "BagItemCell")
  self.upgradeRewardCtrl:AddEventListener(MouseEvent.MouseClick, self.ClickRewardCell, self)
  self.upgradeRewardBg = self:FindGO("RewardBg", self.upgradeRewardTipLabel.gameObject):GetComponent(UISprite)
  self.upgradeRewardRecvBtn = self:FindGO("RecvBtn", self.upgradeRewardTipLabel.gameObject)
  self.upgradeRewardRecvBtn_Icon = self.upgradeRewardRecvBtn:GetComponent(UIMultiSprite)
  self.upgradeRewardRecvBtn_Label = self:FindGO("Label", self.upgradeRewardRecvBtn):GetComponent(UILabel)
  self.upgradeRewardRecvBtn_BoxCollider = self.upgradeRewardRecvBtn:GetComponent(BoxCollider)
  self:AddClickEvent(self.upgradeRewardRecvBtn, function()
    xdlog("申请领奖", self.prestigeVersion, self.curShowPrestigeLevel)
    ServiceSceneUser3Proxy.Instance:CallPrestigeRewardCmd(self.prestigeVersion, self.curShowPrestigeLevel)
  end)
  self.prestigeTextureBG = self:FindGO("TextureBg", self.knightPrestigePanel):GetComponent(UITexture)
  self.prestigeHelp = self:FindGO("HelpBtn", self.knightPrestigePanel)
  self:AddClickEvent(self.prestigeHelp, function()
    if not self.prestigeVersion then
      return
    end
    local helpID = GameConfig.Prestige and GameConfig.Prestige.HelpID and GameConfig.Prestige.HelpID[self.prestigeVersion] or 35289
    local helpConfig = Table_Help[helpID]
    if helpConfig then
      self:OpenHelpView(helpConfig)
    end
  end)
  self.curTip = self:FindGO("CurTip", self.knightPrestigePanel)
  self.curLvLabel = self:FindGO("CurLv", self.curTip):GetComponent(UILabel)
  self.nextLvLabel = self:FindGO("NextLv", self.curTip):GetComponent(UILabel)
  self.maxTip = self:FindGO("MaxTip", self.knightPrestigePanel)
  self.prestigeGainWayBtn = self:FindGO("PrestigeGainWayBtn", self.knightPrestigePanel)
  self:AddClickEvent(self.prestigeGainWayBtn, function()
    local guideGroup = GameConfig.Prestige and GameConfig.Prestige.GuideUI and GameConfig.Prestige.GuideUI[self.prestigeVersion] or 2
    local showLv = self.curPrestigeLevel + 1
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.NoviceExpGuideView,
      viewdata = {level = showLv, groupid = guideGroup}
    })
  end)
  self.skillBtn = self:FindGO("SkillBtn", self.knightPrestigePanel)
  self:AddClickEvent(self.skillBtn, function()
    local professionSkill = SkillProxy.Instance:FindProfessSkill(ProfessionProxy.CommonClass)
    local skillData = professionSkill:FindSkillById(4620001)
    if skillData then
      self:SetPushToStack(true)
      FunctionNpcFunc.JumpPanel(PanelConfig.SpecialSkillUpgradeView, skillData)
    end
  end)
end

function QuestTracePanel:InitDatas()
  QuestProxy.Instance:RefreshWorldQuestNewSymbol()
  self.levelHide = false
  self.hideToggle.value = self.levelHide
  self.validAcceptQuestList = QuestProxy.Instance:getValidAcceptQuestList(nil)
  self.questList = {}
  self.previewList = {}
  self.myLevel = Game.Myself.data.userdata:Get(UDEnum.ROLELEVEL)
  local viewdata = self.viewdata and self.viewdata.viewdata
  self.tabID = viewdata and viewdata.tabID or 1
  self.initPrestigeVersion = viewdata and viewdata.PrestigeVersion
  self.initWorldQuestGroup = viewdata and viewdata.group
  self:InitChapterFilter()
  self:SetTraceCount()
  self:InitQuestList()
  self:RefreshKeyCount()
end

function QuestTracePanel:InitQuestList()
  local groupConfig = {}
  for k, v in pairs(questTypeTog) do
    local areaRange = v.area
    if areaRange and 0 < #areaRange then
      for i = 1, #areaRange do
        groupConfig[areaRange[i]] = k
      end
    elseif v.other then
      groupConfig.other = k
    end
  end
  for i = 1, #self.validAcceptQuestList do
    local single = self.validAcceptQuestList[i]
    local colorFromServer = single.staticData.ColorFromServer
    if groupConfig[colorFromServer] then
      if not self.questList[groupConfig[colorFromServer]] then
        self.questList[groupConfig[colorFromServer]] = {}
      end
      table.insert(self.questList[groupConfig[colorFromServer]], single)
    else
      if not self.questList[groupConfig.other] then
        self.questList[groupConfig.other] = {}
      end
      table.insert(self.questList[groupConfig.other], single)
    end
  end
end

function QuestTracePanel:RefreshKeyCount()
  local maxCount = GameConfig.HeroStory and GameConfig.HeroStory.DailyKeyNum or 5
  local keyUsed = MyselfProxy.Instance:GetAccVarValueByType(Var_pb.EACCVARTYPE_HERO_STORY_KEY_USED) or 0
  xdlog("钥匙数量", keyUsed)
  self.heroQuestKeyCount.text = maxCount - keyUsed .. "/" .. maxCount
end

function QuestTracePanel:InitShow()
  self:InitQuestTypeTog()
  local typeTogs = self.questTypeTogCtrl:GetCells()
  if typeTogs and typeTogs[self.tabID] then
    self:ClickTypeTog(typeTogs and typeTogs[self.tabID])
    typeTogs[self.tabID].toggle.value = true
  else
    self:ClickTypeTog(typeTogs and typeTogs[1])
    typeTogs[1].toggle.value = true
  end
  self:RefreshNewTag()
  self:RefreshTraceCount()
end

function QuestTracePanel:RefreshNewTag()
  local typeTogs = self.questTypeTogCtrl:GetCells()
  for i = 1, #typeTogs do
    local index = typeTogs[i].index
    if index == 1 then
      local inRedTip = RedTipProxy.Instance:InRedTip(SceneTip_pb.EREDSYS_PRESTIGE_SYSTEM_REWARD)
      typeTogs[i]:SetNewSymbol(inRedTip)
    elseif typeTogs[i].indexInList == #typeTogs then
      local inRedTip = RedTipProxy.Instance:InRedTip(SceneTip_pb.EREDSYS_HERO_STORY_QUEST)
      local showRedTip = inRedTip
      typeTogs[i]:SetNewSymbol(inRedTip)
      local heroStories = HeroProfessionProxy.Instance.heroStories
      if heroStories and next(heroStories) then
        typeTogs[i].gameObject:SetActive(true)
      else
        typeTogs[i].gameObject:SetActive(false)
      end
    else
      local areaQuest = self.questList[index]
      if areaQuest and 0 < #areaQuest then
        for j = 1, #areaQuest do
          local single = areaQuest[j]
          if single.newstatus == 1 then
            typeTogs[i]:SetNewSymbol(true)
            break
          end
          typeTogs[i]:SetNewSymbol(false)
        end
      end
    end
  end
  self.questTypeGrid:Reposition()
end

function QuestTracePanel:SwitchTag()
  if self.pageType == PageEnum.Hero then
    xdlog("英雄界面离开")
    local typeTogs = self.questTypeTogCtrl:GetCells()
    if typeTogs and 0 < #typeTogs then
      typeTogs[#typeTogs]:SetNewSymbol(false)
    end
    local inRedTip = RedTipProxy.Instance:InRedTip(SceneTip_pb.EREDSYS_HERO_STORY_QUEST)
    if inRedTip then
      RedTipProxy.Instance:SeenNew(SceneTip_pb.EREDSYS_HERO_STORY_QUEST)
      RedTipProxy.Instance:RemoveRedTip(SceneTip_pb.EREDSYS_HERO_STORY_QUEST)
    end
  elseif self.pageType == PageEnum.Common then
    local cells = self.questListCtrl:GetCells()
    helplog("通常页签", #cells)
    for i = 1, #cells do
      cells[i]:CancelNewTag()
    end
  end
  self:RefreshNewTag()
end

function QuestTracePanel:InitQuestClickShow()
  xdlog("InitQuestClickShow")
  local cells
  if self.pageType == PageEnum.Main then
    cells = self.mainQuestCtrl:GetCells()
  elseif self.pageType == PageEnum.Common then
    cells = self.questListCtrl:GetCells()
  elseif self.pageType == PageEnum.Hero then
    cells = self.heroQuestCtrl:GetCells()
  end
  local isShow = false
  local curTraceID = self.previewList[self.curType]
  curTraceID = curTraceID or LocalSaveProxy.Instance:getLastTraceQuestId()
  local firstValidCell
  local switched = false
  for i = 1, #cells do
    if #cells[i].data.childGoals > 0 then
      firstValidCell = cells[i]
      isShow = true
      break
    end
  end
  if isShow then
    self.questInfoDetail:SetActive(true)
    self.noQuestTip:SetActive(false)
    self.knightPrestigePanel:SetActive(false)
    local targetCell
    if self.initWorldQuestGroup and self.curType == 2 then
      for i = 1, #cells do
        if cells[i].data and cells[i].data.fatherGoal and cells[i].data.fatherGoal.version == self.initWorldQuestGroup then
          targetCell = cells[i]:SetDefaultChoose()
          if not cells[i].folderState then
            cells[i]:ClickFather()
          end
          switched = true
          self.initWorldQuestGroup = nil
          break
        end
      end
      if not switched then
        firstValidCell:SetDefaultChoose()
      end
    elseif curTraceID then
      for i = 1, #cells do
        targetCell = cells[i]:SwitchToTargetQuest(curTraceID)
        if targetCell then
          if not cells[i].folderState then
            cells[i]:ClickFather()
          end
          switched = true
          break
        end
      end
      if not switched then
        firstValidCell:SetDefaultChoose()
      end
    end
    self.questScrollView:ResetPosition()
    if targetCell then
      TimeTickManager.Me():CreateOnceDelayTick(100, function(owner, deltaTime)
        local panel = self.questScrollView.panel
        local bound = NGUIMath.CalculateRelativeWidgetBounds(panel.cachedTransform, targetCell.gameObject.transform)
        local offset = panel:CalculateConstrainOffset(bound.min, bound.max)
        offset = Vector3(0, offset.y, 0)
        self.questScrollView:MoveRelative(offset)
      end, self, 4)
    end
  else
    self.questInfoDetail:SetActive(false)
    self.noQuestTip:SetActive(true)
    self.knightPrestigePanel:SetActive(false)
    self.mainStoryPart:SetActive(false)
  end
end

function QuestTracePanel:InitMainQuestClick()
  local cells = self.mainQuestCtrl:GetCells()
  local areaPriorVersion = Game.MapManager:GetCurMapQuestVersion()
  self.questInfoDetail:SetActive(true)
  self.noQuestTip:SetActive(false)
  self.knightPrestigePanel:SetActive(false)
  local firstValidCell
  local switched = false
  for i = 1, #cells do
    if #cells[i].data.childGoals > 0 then
      firstValidCell = cells[i]
      isShow = true
      break
    end
  end
  local targetCell
  if self.initPrestigeVersion then
    for i = 1, #cells do
      targetCell = cells[i]:SwitchToTargetQuest(nil, self.initPrestigeVersion)
      if targetCell then
        switched = true
        self.initPrestigeVersion = nil
        break
      end
    end
    if not switched then
      firstValidCell:SetDefaultChoose()
    end
  elseif areaPriorVersion then
    for i = 1, #cells do
      if cells[i].data and cells[i].data.fatherGoal and cells[i].data.fatherGoal.version and cells[i].data.fatherGoal.version == areaPriorVersion and not cells[i].data.fatherGoal.allFinish then
        targetCell = cells[i]
        targetCell:SetDefaultChoose()
        switched = true
        break
      end
    end
    if not switched and firstValidCell then
      firstValidCell:SetDefaultChoose()
    end
  elseif firstValidCell then
    firstValidCell:SetDefaultChoose()
  end
  self.questScrollView:ResetPosition()
  if targetCell then
    TimeTickManager.Me():CreateOnceDelayTick(100, function(owner, deltaTime)
      local panel = self.questScrollView.panel
      local bound = NGUIMath.CalculateRelativeWidgetBounds(panel.cachedTransform, targetCell.gameObject.transform)
      local offset = panel:CalculateConstrainOffset(bound.min, bound.max)
      offset = Vector3(0, offset.y, 0)
      self.questScrollView:MoveRelative(offset)
    end, self, 4)
  end
end

function QuestTracePanel:AddEvts()
  self:AddClickEvent(self.scenicSpotCell, function()
    self:ShowScenicSpotList()
  end)
  self:AddClickEvent(self.hideToggleGO, function()
    self:InitShow()
  end)
  self:AddClickEvent(self.traceBtn, function()
    xdlog("追踪任务", self.curChooseQuestCell.id)
    if self.curChooseQuestCell.toggle.value == false then
      self.curChooseQuestCell.toggle.value = true
      self:HandleTraceStatusUpdate(self.curChooseQuestCell)
    end
    GameFacade.Instance:sendNotification(QuestEvent.QuestTraceSwitch, self.curChooseQuestCell.data)
    self:CloseSelf()
  end)
  self:AddClickEvent(self.repairBtn, function()
    local questData = self.curChooseQuestCell.data
    if questData then
      TipManager.Instance:ShowQuestRepairTip(questData, self.stick, nil, {0, 0})
    end
  end)
  self:AddClickEvent(self.questManualBtn, function()
    self:SetPushToStack(true)
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.QuestManualView
    })
  end)
  self:AddClickEvent(self.unlockBtn, function()
    local id = self.curChooseQuestCell.id
    xdlog("解锁", id)
    if id then
      local maxCount = GameConfig.HeroStory and GameConfig.HeroStory.DailyKeyNum or 5
      local keyUsed = MyselfProxy.Instance:GetAccVarValueByType(Var_pb.EACCVARTYPE_HERO_STORY_KEY_USED) or 0
      if 0 < maxCount - keyUsed then
        HeroProfessionProxy.Instance:UnlockStory(id)
      else
        redlog("MSG:没钥匙了")
      end
    end
  end)
end

function QuestTracePanel:AddMapEvts()
  self:AddListenEvt(QuestEvent.QuestTraceChange, self.HandleTraceStatusUpdate, self)
  self:AddListenEvt(ServiceEvent.QuestQuestUpdate, self.SetTraceCount, self)
  self:AddListenEvt(ServiceEvent.SceneUser3HeroGrowthQuestInfo, self.HandleHeroStoryUpate)
  self:AddListenEvt(ServiceEvent.SceneUser3HeroStoryQuestInfo, self.HandleHeroStoryUpate)
  self:AddListenEvt(ServiceEvent.SceneUser3HeroStoryQuestAccept, self.HandleHeroStoryAccept)
  self:AddListenEvt(ServiceEvent.SceneUser3HeroQuestReward, self.HandleHeroStoryUpate)
  self:AddListenEvt(ServiceEvent.NUserVarUpdate, self.RefreshKeyCount)
  self:AddListenEvt(ServiceEvent.SceneUser3QueryPrestigeCmd, self.HandlePrestigeUpdate)
  self:AddListenEvt(ServiceEvent.SceneUser3PrestigeRewardCmd, self.HandleRecvPrestigeReward)
  self:AddListenEvt(RedTipProxy.UpdateRedTipEvent, self.HandleRedTipUpdate)
  self:AddListenEvt(RedTipProxy.UpdateParamEvent, self.HandleRedTipUpdate)
  self:AddListenEvt(RedTipProxy.RemoveRedTipEvent, self.HandleRedTipUpdate)
  self:AddListenEvt(ShortCut.MoveToPos, self.CloseSelf)
end

function QuestTracePanel:InitQuestTypeTog()
  local result = {}
  local lastIndex
  for k, v in pairs(questTypeTog) do
    v.index = k
    table.insert(result, v)
    if not lastIndex or k > lastIndex then
      lastIndex = k
    end
  end
  table.sort(result, function(l, r)
    local l_index = l.index
    local r_index = r.index
    if l_index and r_index then
      return l_index < r_index
    end
  end)
  local tracing = {
    name = ZhString.AnnounceQuestPanel_Ongoing,
    isTracing = true,
    index = lastIndex + 1
  }
  table.insert(result, tracing)
  local heroQuest = {
    name = ZhString.HeroStory_Title,
    isHero = true,
    redtip = SceneTip_pb.EREDSYS_HERO_STORY_QUEST,
    index = lastIndex + 2
  }
  table.insert(result, heroQuest)
  self.questTypeTogCtrl:ResetDatas(result)
end

local listPopUpItems = {}

function QuestTracePanel:InitChapterFilter()
  TableUtility.ArrayClear(listPopUpItems)
  local data = {
    name = ZhString.Card_All,
    version = 0,
    tab = 1
  }
  table.insert(listPopUpItems, data)
  for k, v in pairs(Table_QuestVersion) do
    local hasQuest = false
    for i = 1, #self.validAcceptQuestList do
      local single = self.validAcceptQuestList[i]
      if single.staticData.Version and single.staticData.Version == v.version then
        hasQuest = true
        break
      end
    end
    if hasQuest then
      local data = {}
      data.name = v.StoryName
      data.version = v.version
      data.tab = v.Tab or 1
      table.insert(listPopUpItems, data)
    end
  end
end

function QuestTracePanel:tabClick(selectTabData)
  local targetVersion = selectTabData.version or 0
  local result = {}
  if not self.validAcceptQuestList then
    return
  end
  local areaRange = questTypeTog[2].area
  if areaRange and 0 < #areaRange then
    local result = {}
    for i = 1, #areaRange do
      local areaData = {}
      areaData.fatherGoal = {
        area = areaRange[i],
        isHide = true
      }
      areaData.childGoals = {}
      for j = 1, #self.validAcceptQuestList do
        local single = self.validAcceptQuestList[j]
        local colorFromServer = single.staticData.ColorFromServer
        local version = single.staticData.Version
        if areaRange[i] == colorFromServer and (targetVersion == 0 or version and version == targetVersion) then
          if self.levelHide then
            if QuestProxy.Instance:CheckQuestShow(single, self.myLevel) then
              table.insert(areaData.childGoals, single)
            end
          else
            table.insert(areaData.childGoals, single)
          end
        end
      end
      local tempData = self:questReunit(areaData.childGoals)
      areaData.childGoals = tempData
      table.insert(result, areaData)
    end
    self.questListCtrl:ResetDatas(result)
    self.questScrollView:ResetPosition()
    local cells = self.questListCtrl:GetCells()
    local isShow = false
    for i = 1, #cells do
      if 0 < #cells[i].data.childGoals then
        isShow = true
        break
      end
    end
    self.noneTip:SetActive(not isShow)
  end
end

function QuestTracePanel:ClickTypeTog(cellCtrl)
  self.curChooseQuestCell = nil
  if self.curType and self.curType ~= cellCtrl.index then
    self:SwitchTag()
  end
  self.curType = cellCtrl.index
  local questProxyIns = QuestProxy.Instance
  local questManualProxyIns = QuestManualProxy.Instance
  local result = {}
  self.pageType = PageEnum.Common
  if cellCtrl.index == 2 then
    local worldQuest = {}
    local worldQuestMap = GameConfig.Quest.worldquestmap
    for k, v in pairs(worldQuestMap) do
      worldQuest[k] = {}
    end
    local areaQuest = self.questList[2]
    if areaQuest and 0 < #areaQuest then
      for i = 1, #areaQuest do
        local single = areaQuest[i]
        if Table_WorldQuest[single.id] then
          local version = Table_WorldQuest[single.id].Version
          if not worldQuest[version] then
            worldQuest[version] = {}
          end
          table.insert(worldQuest[version], single)
        else
          if not worldQuest[0] then
            worldQuest[0] = {}
          end
          table.insert(worldQuest[0], single)
        end
      end
      for k, v in pairs(worldQuest) do
        local areaData = {}
        local isHide = true
        if GameConfig.Quest.worldquestmap[k] and (0 < #v or 0 < QuestProxy.Instance:GetWorldCount(k)) then
          isHide = false
        end
        if not isHide then
          areaData.fatherGoal = {
            isWorldQuest = true,
            version = k,
            isHide = isHide
          }
          areaData.childGoals = v
          local tempData = self:questReunit(areaData.childGoals)
          areaData.childGoals = tempData
          table.insert(result, areaData)
          xdlog("冒险任务version", version, isHide)
        end
      end
      local curTraceID = self.previewList[2]
      if self.initWorldQuestGroup then
        for i = 1, #result do
          result[i].fatherGoal.folderState = self.initWorldQuestGroup == result[i].fatherGoal.version
        end
      else
        local curWorldQuestMapGroup = Game.MapManager:GetWorldQuestGroupByMapID() or 0
        for i = 1, #result do
          local allFinish = Game.MapManager:GetWorldQuestProcessAllFinish(result[i].fatherGoal.version)
          if allFinish then
            result[i].fatherGoal.folderState = false
          else
            local curProcess = QuestProxy.Instance:GetWorldCount(result[i].fatherGoal.version)
            if curProcess < 4 then
              result[i].fatherGoal.folderState = true
            end
          end
        end
      end
      for i = 1, #result do
        local version = result[i].fatherGoal.version
        if not worldQuestMap[version] then
          result[i].fatherGoal.folderState = true
        end
      end
      table.sort(result, function(l, r)
        local lFolderState = l.fatherGoal.folderState or false
        local rFolderState = r.fatherGoal.folderState or false
        if lFolderState ~= rFolderState then
          return lFolderState == true
        end
        local l_order = l.fatherGoal.version or 0
        local r_order = r.fatherGoal.version or 0
        if l_order ~= r_order then
          return l_order < r_order
        end
      end)
    end
  elseif cellCtrl.data and cellCtrl.data.isTracing then
    local curWorldQuestGroup = Game.MapManager:getCurWorldQuestGroup()
    local isCurWorldGroupAllFinish = Game.MapManager:GetWorldQuestProcessAllFinish(curWorldQuestGroup)
    local tracingQuest = {}
    local areaData = {}
    for k, v in pairs(self.questList) do
      for i = 1, #v do
        local single = v[i]
        local status = QuestProxy.Instance:CheckQuestIsTrace(single.id)
        local isTrace = false
        if curWorldQuestGroup and not isCurWorldGroupAllFinish then
          if status and status == 3 then
            local version = Table_WorldQuest[single.id] and Table_WorldQuest[single.id].Version
            if version == curWorldQuestGroup then
              isTrace = true
            end
          elseif status and status == 1 then
            isTrace = true
          end
        elseif status and status == 1 then
          isTrace = true
        end
        if isTrace then
          table.insert(tracingQuest, single)
        end
      end
    end
    if tracingQuest and 0 < #tracingQuest then
      local areaData = {}
      areaData.fatherGoal = {
        isWorldQuest = false,
        title = "追踪中",
        isHide = true,
        folderState = true
      }
      areaData.childGoals = {}
      TableUtility.ArrayShallowCopy(areaData.childGoals, tracingQuest)
      local tempData = self:questReunit(areaData.childGoals)
      areaData.childGoals = tempData
      table.insert(result, areaData)
    end
    table.sort(result, function(l, r)
      local lHide = l.fatherGoal.isHide
      local rHide = r.fatherGoal.isHide
      if lHide ~= rHide then
        return lHide == false
      end
    end)
  elseif cellCtrl.index == 1 then
    self.pageType = PageEnum.Main
    self:ResizeQuestListScrollView()
    self:UpdateMainQuestList()
  elseif cellCtrl.data and cellCtrl.data.isHero then
    xdlog("英雄赞歌")
    self.pageType = PageEnum.Hero
    self:ResizeQuestListScrollView()
    self:UpdateHeroQuestList()
  else
    local areaQuest = self.questList[cellCtrl.index]
    local areaData = {}
    areaData.fatherGoal = {isHide = true, folderState = true}
    areaData.childGoals = {}
    if areaQuest and 0 < #areaQuest then
      for i = 1, #areaQuest do
        local single = areaQuest[i]
        if self.levelHide then
          if QuestProxy.Instance:CheckQuestShow(single, self.myLevel) then
            table.insert(areaData.childGoals, single)
          end
        else
          table.insert(areaData.childGoals, single)
        end
      end
    end
    local tempData = self:questReunit(areaData.childGoals)
    areaData.childGoals = tempData
    table.insert(result, areaData)
    table.sort(result, function(l, r)
      local lHide = l.fatherGoal.isHide
      local rHide = r.fatherGoal.isHide
      if lHide ~= rHide then
        return lHide == false
      end
    end)
  end
  if self.pageType == PageEnum.Common then
    self.questTable.gameObject:SetActive(true)
    self.mainQuestTable.gameObject:SetActive(false)
    self.heroQuestTable.gameObject:SetActive(false)
    self.questListCtrl:ResetDatas(result)
    local cells = self.questListCtrl:GetCells()
    if cells and 0 < #cells then
      cells[#cells]:RefillContainer()
    end
    self:ResizeQuestListScrollView()
    local cells = self.questListCtrl:GetCells()
    local isShow = false
    for i = 1, #cells do
      if #cells[i].data.childGoals > 0 then
        isShow = true
        break
      end
    end
    self.noneTip:SetActive(not isShow)
    self:InitQuestClickShow()
    self.questScrollView:ResetPosition()
  end
  self.heroQuestKey:SetActive(self.pageType == PageEnum.Hero)
end

function QuestTracePanel:UpdateMainQuestList()
  local result = {}
  local areaData = {}
  areaData.fatherGoal = {isMain = false}
  areaData.childGoals = {}
  local profQuestExist = false
  for i = 1, #self.validAcceptQuestList do
    local single = self.validAcceptQuestList[i]
    local colorFromServer = single.staticData.ColorFromServer
    if colorFromServer and colorFromServer == 6 then
      profQuestExist = true
      table.insert(areaData.childGoals, single)
    end
  end
  if profQuestExist then
    table.insert(result, areaData)
  end
  local myLevel = MyselfProxy.Instance:RoleLevel()
  local myPro = Game.Myself.data.userdata:Get(UDEnum.PROFESSION)
  local myRace = Table_Class[myPro].Race
  local hasDoram = ProfessionProxy.Instance:HasDoramProf()
  local questProxyIns = QuestProxy.Instance
  local questManualProxyIns = QuestManualProxy.Instance
  local areaPriorVersion = Game.MapManager:GetCurMapQuestVersion()
  local latestVersionSort = questManualProxyIns.latestVersionSort
  for _, v in pairs(Table_QuestVersion) do
    local version = v.version
    local raceValid = not v.Race or v.Race == myRace
    local staticVersionConfig = questManualProxyIns:GetStoryConfigByVersion(version)
    local isVersionInProcess = questManualProxyIns:IsVersionInProcess(version)
    local minLevel = staticVersionConfig and staticVersionConfig.minLevel
    if (isVersionInProcess or minLevel and minLevel <= myLevel + 10 or latestVersionSort >= v.sortid) and (not v.Race or v.Race == myRace or hasDoram) then
      local indexInfo = questManualProxyIns:GetStoryVersionInfo(version)
      if indexInfo then
        local areaData = {}
        areaData.fatherGoal = {
          isMain = true,
          title = v.StoryName,
          version = version,
          sort = v.id,
          versionBG = v.VersionBG
        }
        if v.KeyReward then
          local mySex = MyselfProxy.Instance:GetMySex()
          if v.KeyReward.female and mySex == 2 then
            local targetReward = v.KeyReward.female[1]
            local reward = {
              itemid = targetReward[1],
              num = targetReward[2]
            }
            areaData.fatherGoal.keyReward = reward
          else
            local targetReward = v.KeyReward.male and v.KeyReward.male[1]
            targetReward = targetReward or v.KeyReward[1]
            if targetReward then
              local reward = {
                itemid = targetReward[1],
                num = targetReward[2]
              }
              areaData.fatherGoal.keyReward = reward
            end
          end
        end
        areaData.childGoals = {}
        local allFinish = true
        local inProcess = false
        local questTraceVersion = GameConfig.Prestige and GameConfig.Prestige.QuestTraceVersion
        local prestigeVersions = questTraceVersion and questTraceVersion[version]
        if prestigeVersions then
          if type(prestigeVersions) == "number" then
            local menuid = GameConfig.Prestige and GameConfig.Prestige.PrestigeUnlockMenu and GameConfig.Prestige.PrestigeUnlockMenu[prestigeVersions]
            if not menuid or FunctionUnLockFunc.Me():CheckCanOpen(menuid) then
              local prestigeFinish = VersionPrestigeProxy:GetVersionAllFinish(prestigeVersions)
              if not prestigeFinish then
                inProcess = true
              end
              local cellData = {isKnight = true, prestigeVersion = prestigeVersions}
              table.insert(areaData.childGoals, cellData)
            end
          elseif type(prestigeVersions) == "table" then
            for i = 1, #prestigeVersions do
              local menuid = GameConfig.Prestige and GameConfig.Prestige.PrestigeUnlockMenu and GameConfig.Prestige.PrestigeUnlockMenu[prestigeVersions[i]]
              if not menuid or FunctionUnLockFunc.Me():CheckCanOpen(menuid) then
                local prestigeFinish = VersionPrestigeProxy:GetVersionAllFinish(prestigeVersions[i])
                if not prestigeFinish then
                  inProcess = true
                end
                local cellData = {
                  isKnight = true,
                  prestigeVersion = prestigeVersions[i]
                }
                table.insert(areaData.childGoals, cellData)
              end
            end
          end
        end
        for index, config in pairs(indexInfo) do
          if not config.hideInList then
            local cellData = {
              index = index,
              version = version,
              status = config.status,
              raceValid = raceValid
            }
            local isUnlock = config.status == 3 or false
            if not isUnlock then
              allFinish = false
            end
            cellData.isUnlock = isUnlock
            if config.status == 2 then
              local curQuestData = config.curQuestData
              if curQuestData and 0 < #curQuestData then
                for i = 1, #curQuestData do
                  local singleCellData = {}
                  TableUtility.TableShallowCopy(singleCellData, cellData)
                  singleCellData.questData = curQuestData[i].questData
                  singleCellData.questType = curQuestData[i].questType
                  table.insert(areaData.childGoals, singleCellData)
                  local isTrace = QuestProxy.Instance:CheckQuestIsTrace(singleCellData.questData.id)
                  if isTrace == 1 or isTrace == 0 then
                    inProcess = true
                  end
                end
              else
                inProcess = true
                table.insert(areaData.childGoals, cellData)
              end
            else
              table.insert(areaData.childGoals, cellData)
            end
          end
        end
        if areaPriorVersion == version and not allFinish then
          inProcess = true
        end
        if #areaData.childGoals > 1 then
          table.sort(areaData.childGoals, function(l, r)
            local l_isKnight = l.isKnight and 1 or 0
            local r_isKnight = r.isKnight and 1 or 0
            if l_isKnight ~= r_isKnight then
              return l_isKnight > r_isKnight
            end
            local l_isUnlock = l.isUnlock
            local r_isUnlock = r.isUnlock
            if l_isUnlock ~= r_isUnlock then
              return l_isUnlock == false
            end
            local l_index = l.index
            local r_index = r.index
            if l_index ~= r_index then
              return l_index < r_index
            end
          end)
        end
        areaData.fatherGoal.allFinish = allFinish
        areaData.fatherGoal.inProcess = inProcess
        table.insert(result, areaData)
      end
    end
  end
  table.sort(result, function(l, r)
    local l_isMain = l.fatherGoal.isMain
    local r_isMain = r.fatherGoal.isMain
    if l_isMain ~= r_isMain then
      return not l_isMain
    end
    local l_isAllFinish = l.fatherGoal.allFinish
    local r_isAllFinish = r.fatherGoal.allFinish
    if l_isAllFinish ~= r_isAllFinish then
      return l_isAllFinish == false
    end
    local l_sort = l.fatherGoal.sort
    local r_sort = r.fatherGoal.sort
    return l_sort < r_sort
  end)
  self.questTable.gameObject:SetActive(false)
  self.mainQuestTable.gameObject:SetActive(true)
  self.heroQuestTable.gameObject:SetActive(false)
  self.mainQuestCtrl:ResetDatas(result)
  local cells = self.mainQuestCtrl:GetCells()
  if cells and 0 < #cells then
    cells[#cells]:RefillContainer()
  end
  self.noneTip:SetActive(false)
  self:InitMainQuestClick()
end

function QuestTracePanel:UpdateHeroQuestList(noResetPos)
  local result = {}
  local shopConfig = GameConfig.HeroShop and GameConfig.HeroShop.Items
  local isTF = EnvChannel.IsTFBranch()
  local heroStories = HeroProfessionProxy.Instance.heroStories
  for profId, stories in pairs(heroStories) do
    local areaData = {}
    local extraData = HeroProfessionProxy.Instance:GetHeroExtraStoryQuest(profId)
    local isComplete = extraData:IsCompleted()
    local isReward = extraData:IsAllComplete()
    areaData.fatherGoal = {
      isHero = true,
      profId = profId,
      isReward = isReward
    }
    local typeBranch = ProfessionProxy.GetTypeBranchFromProf(profId)
    local onSaleConfig = shopConfig and shopConfig[typeBranch]
    local getdate = isTF and onSaleConfig and onSaleConfig.tfgetdate or onSaleConfig and onSaleConfig.getdate
    local timeValid = true
    if getdate then
      areaData.fatherGoal.isCollabor = true
      local t = ServerTime.CurServerTime() / 1000
      local t1 = StringUtil.FormatTime2TimeStamp2(getdate[1])
      local t2 = StringUtil.FormatTime2TimeStamp2(getdate[2])
      if t < t1 or t > t2 then
        timeValid = false
      else
        areaData.fatherGoal.starttime = getdate[1]
        areaData.fatherGoal.endtime = getdate[2]
      end
    end
    local hasClass = ProfessionProxy.Instance:IsThisIdYiGouMai(profId)
    areaData.childGoals = {}
    local inProcess = false
    local isAllFinish = true
    for i = 1, #stories do
      local state = stories[i].serverData and stories[i].serverData.state
      if state == SceneUser3_pb.HEROSTORY_QUEST_STATE_INPROCESS or state == SceneUser3_pb.HEROSTORY_QUEST_STATE_COMPLETE or state == SceneUser3_pb.HEROSTORY_QUEST_STATE_REWARD or state == SceneUser3_pb.HEROSTORY_QUEST_STATE_UNACCEPT then
        inProcess = true
      end
      if not stories[i]:IsRewarded() then
        isAllFinish = false
      end
      local cellData = {
        id = stories[i].id,
        state = stories[i].serverData and stories[i].serverData.state
      }
      table.insert(areaData.childGoals, cellData)
    end
    if timeValid and not hasClass then
      local cellData = {profId = profId, shopIndex = true}
      table.insert(areaData.childGoals, cellData)
    end
    if timeValid or inProcess then
      table.insert(result, areaData)
    end
  end
  table.sort(result, function(l, r)
    local l_isReward = l.fatherGoal.isReward and 1 or 0
    local r_isReward = r.fatherGoal.isReward and 1 or 0
    if l_isReward ~= r_isReward then
      return l_isReward < r_isReward
    end
    return l.fatherGoal.profId > r.fatherGoal.profId
  end)
  self.questTable.gameObject:SetActive(false)
  self.mainQuestTable.gameObject:SetActive(false)
  self.heroQuestTable.gameObject:SetActive(true)
  self.heroQuestCtrl:ResetDatas(result)
  local cells = self.heroQuestCtrl:GetCells()
  if cells and 0 < #cells then
    cells[#cells]:RefillContainer()
  end
  self.noneTip:SetActive(#result == 0)
  if not noResetPos then
    self:InitQuestClickShow()
    self.questScrollView:ResetPosition()
  end
  local inRedTip = RedTipProxy.Instance:InRedTip(SceneTip_pb.EREDSYS_HERO_STORY_QUEST)
  if inRedTip then
    RedTipProxy.Instance:SeenNew(SceneTip_pb.EREDSYS_HERO_STORY_QUEST)
    RedTipProxy.Instance:RemoveRedTip(SceneTip_pb.EREDSYS_HERO_STORY_QUEST)
  end
end

local tipData = {}
tipData.funcConfig = {}

function QuestTracePanel:ClickRewardCell(cellCtrl)
  if cellCtrl.data and cellCtrl.data.staticData then
    tipData.itemdata = cellCtrl.data
    self:ShowItemTip(tipData, cellCtrl.icon, NGUIUtil.AnchorSide.Center, {-250, -37})
  end
end

function QuestTracePanel:ClickQuestCell(cellCtrl, noSwitch)
  if cellCtrl.questList and #cellCtrl.questList > 0 and self.curChooseQuestCell and cellCtrl.curChoose.id == self.curChooseQuestCell.id and not noSwitch then
    cellCtrl:SwitchTracedQuestInCombinedGroup()
  end
  if self.curChooseQuestCell ~= cellCtrl then
    if self.curChooseQuestCell then
      self.curChooseQuestCell:SetChooseStatus(false)
    end
    self.curChooseQuestCell = cellCtrl
    self.curChooseQuestCell:SetChooseStatus(true)
  else
    self.curChooseQuestCell = cellCtrl
  end
  self:UpdateQuestInfo()
  local version = cellCtrl.version
  local index = cellCtrl.index
  local showAllReward = false
  if version and index then
    local indexID = QuestManualProxy.Instance:GetStoryConfigByIndex(version, index)
    local config = indexID and Table_MainQuestStory[indexID]
    showAllReward = config and config.ShowReward and true or false
  end
  if not showAllReward then
    local questData = cellCtrl.data
    local iconFromServer = questData and questData.staticData and questData.staticData.IconFromServer
    if iconFromServer and iconFromServer == 28 then
      showAllReward = true
    end
  end
  self:UpdateRewardPart(cellCtrl.data, showAllReward)
  self:UpdateRepairBtn()
  if self:RemoveNewSymbol(cellCtrl) then
    self:RefreshNewTag()
  end
  self:ShowRelatedQuest(cellCtrl)
  if self.curChooseQuestCell.indexID then
    self.previewList[self.curType] = self.curChooseQuestCell.indexID
  elseif self.curChooseQuestCell.data and self.curChooseQuestCell.data.id then
    self.previewList[self.curType] = self.curChooseQuestCell.data.id
  end
end

local panelParam = {
  [1] = {
    posY = 0,
    offsetY = 116,
    height = 138
  },
  [2] = {
    posY = 0,
    offsetY = 0,
    height = 386
  }
}

function QuestTracePanel:ShowRelatedQuest(cellCtrl)
  local version = cellCtrl.version
  local index = cellCtrl.index
  local subQuestList = {}
  local indexInfo = QuestManualProxy.Instance:GetStoryIndexInfo(version, index)
  local subQuest = indexInfo and indexInfo.subQuestData
  if subQuest and 0 < #subQuest then
    for i = 1, #subQuest do
      local questid = subQuest[i].questid
      xdlog("SubQuestID", questid)
      local submitQuest = QuestProxy.Instance:getQuestDataByIdAndType(questid, SceneQuest_pb.EQUESTLIST_SUBMIT)
      if submitQuest then
        local data = {
          questData = subQuest[i].questData,
          questType = 2
        }
        table.insert(subQuestList, data)
      else
        local questData = QuestProxy.Instance:getQuestDataByIdAndType(questid, SceneQuest_pb.EQUESTLIST_ACCEPT)
        if questData then
          local data = {questData = questData, questType = 1}
          table.insert(subQuestList, data)
        else
          local data = {
            questData = subQuest[i].questData,
            questType = subQuest[i].questType
          }
          table.insert(subQuestList, data)
        end
      end
    end
  end
  self.prequestCtrl:ResetDatas(subQuestList)
  self:ResizePrequestScrollView()
end

function QuestTracePanel:ResizePrequestScrollView()
  local param = self.rewardPart.activeSelf and panelParam[1] or panelParam[2]
  local clip = self.prequestPanel.baseClipRegion
  local pos = self.prequestPanel.gameObject.transform.localPosition
  self.prequestPanel.gameObject.transform.localPosition = LuaGeometry.GetTempVector3(pos.x, param.posY, pos.z)
  self.prequestPanel.clipOffset = LuaGeometry.GetTempVector2(self.prequestPanel.clipOffset.x, param.offsetY)
  self.prequestPanel.baseClipRegion = LuaGeometry.GetTempVector4(clip.x, clip.y, clip.z, param.height)
  self.prequestScrollView:ResetPosition()
  local cells = self.prequestCtrl:GetCells()
  if cells and 0 < #cells then
    self.lockStatus.transform.localPosition = LuaGeometry.GetTempVector3(0, 213, 0)
  else
    self.lockStatus.transform.localPosition = LuaGeometry.GetTempVector3(0, 145, 0)
  end
end

local questSVParam = {
  [1] = {
    posY = -73,
    offsetY = -78.6,
    height = 578
  },
  [2] = {
    posY = -73,
    offsetY = -105,
    height = 530
  }
}

function QuestTracePanel:ResizeQuestListScrollView()
  local param = self.pageType == PageEnum.Hero and questSVParam[2] or questSVParam[1]
  local clip = self.questSVPanel.baseClipRegion
  local pos = self.questSVPanel.gameObject.transform.localPosition
  self.questSVPanel.gameObject.transform.localPosition = LuaGeometry.GetTempVector3(pos.x, param.posY, pos.z)
  self.questSVPanel.clipOffset = LuaGeometry.GetTempVector2(self.questSVPanel.clipOffset.x, param.offsetY)
  self.questSVPanel.baseClipRegion = LuaGeometry.GetTempVector4(clip.x, clip.y, clip.z, param.height)
  self.questScrollView:ResetPosition()
end

function QuestTracePanel:ClickLockedIndex(cellCtrl)
  xdlog("更新封锁状态")
  local version = cellCtrl.version
  local index = cellCtrl.index
  local indexID = cellCtrl.indexID
  local raceValid = cellCtrl.raceValid
  local storyConfig = Table_MainQuestStory[indexID]
  if not storyConfig then
    redlog("MainQuestStory缺少ID配置", indexID)
    return
  end
  self.questTitle.text = storyConfig.QuestName
  self.tipLabel.text = ""
  self.previewList[self.curType] = indexID
  if storyConfig.ToBeContinued then
    self.rewardPart:SetActive(false)
    self.scenicSpotCell:SetActive(false)
    self.lockLabel.richLabel.alignment = 2
    self.lockLabel:SetText(ZhString.QuestManual_ToBeContinue2)
    return
  end
  local indexInfo = QuestManualProxy.Instance:GetStoryIndexInfo(version, index)
  local indexStatus = indexInfo and indexInfo.status
  xdlog("状态", indexStatus)
  if indexStatus == 1 then
    local rewards = indexInfo.rewards
    local result = {}
    local itemList = {}
    if rewards and 0 < #rewards then
      for i = 1, #rewards do
        local rewardId = rewards[i]
        local items = ItemUtil.GetRewardItemIdsByTeamId(rewardId)
        if items and 0 < #items then
          for j = 1, #items do
            local item = items[j]
            if item.type == 2 then
              isRandom = true
            end
            if not itemList[item.id] then
              itemList[item.id] = item.num
            else
              itemList[item.id] = itemList[item.id] + item.num
            end
          end
        end
      end
    end
    for k, v in pairs(itemList) do
      local itemData = ItemData.new("reward", k)
      itemData:SetItemNum(v)
      table.insert(result, itemData)
    end
    table.sort(result, function(l, r)
      local l_StaticID = l.staticData and l.staticData.id or 0
      local r_StaticID = r.staticData and r.staticData.id or 0
      if l_StaticID ~= r_StaticID then
        return l_StaticID < r_StaticID
      end
    end)
    self.rewardListCtrl:ResetDatas(result)
    if result and #result == 0 then
      self.rewardPart:SetActive(false)
    else
      self.rewardPart:SetActive(true)
    end
    self.scenicSpotCell:SetActive(false)
    self.rewardGrid:Reposition()
    self.rewardScrollView:ResetPosition()
  else
    self.rewardPart:SetActive(false)
    self.scenicSpotCell:SetActive(false)
  end
  self.rewardTip.text = ZhString.QuestDetailTip_CommonReward
  local questData = cellCtrl.questData
  local cells = self.rewardListCtrl:GetCells()
  if cells and 0 < #cells then
    for i = 1, #cells do
      cells[i]:SetFontSize(24)
    end
  end
  self.traceInfo:SetText("")
  local menuPreQuest = {}
  local targetPreQuest = {}
  local lockStr = ""
  local curQuestData = indexInfo.curQuestData
  if curQuestData and 0 < #curQuestData then
    local questData = curQuestData[1] and curQuestData[1].questData
    if indexStatus ~= 1 then
      self:UpdateRewardPart(questData)
    end
    self.questTitle.text = questData.traceTitle
    local levelLimit = curQuestData[1].level
    local maxLevel = GameConfig.System.maxbaselevel or 170
    if levelLimit and levelLimit <= maxLevel then
      xdlog("等级限制", levelLimit)
      if levelLimit > MyselfProxy.Instance:RoleLevel() then
        lockStr = lockStr .. string.format(ZhString.QuestManual_Level, levelLimit)
      end
    end
    local preMenu = curQuestData[1].preMenu
    if preMenu and 0 < #preMenu then
      for i = 1, #preMenu do
        local singleMenu = preMenu[i]
        if not FunctionUnLockFunc.Me():CheckCanOpen(singleMenu) then
          local menuList = {}
          FunctionUnLockFunc.Me():GetRelatedMenuIDByMenuID(menuList, singleMenu)
          for j = 1, #menuList do
            local menuid = menuList[j]
            local menuConfig = Table_Menu[menuid]
            if menuConfig and menuConfig.Condition and menuConfig.Condition.quest then
              local menuQuestList = menuConfig.Condition.quest
              for k = 1, #menuQuestList do
                table.insert(menuPreQuest, menuQuestList[k])
              end
            end
            local menuText = Table_Menu[menuid] and Table_Menu[menuid].text
            if menuText and menuText ~= "" then
              if lockStr ~= "" then
                lockStr = lockStr .. "\n"
              end
              lockStr = lockStr .. menuText
            end
            lockStr = lockStr .. menuText
          end
        end
      end
    end
    local menuPreMenu = curQuestData[1].mustPreMenu
    if menuPreMenu and 0 < #menuPreMenu then
      for i = 1, #menuPreMenu do
        local singleMenu = menuPreMenu[i]
        if not FunctionUnLockFunc.Me():CheckCanOpen(singleMenu) then
          local menuList = {}
          FunctionUnLockFunc.Me():GetRelatedMenuIDByMenuID(menuList, singleMenu)
          for j = 1, #menuList do
            local menuid = menuList[j]
            local menuConfig = Table_Menu[menuid]
            if menuConfig and menuConfig.Condition and menuConfig.Condition.quest then
              local menuQuestList = menuConfig.Condition.quest
              for k = 1, #menuQuestList do
                table.insert(menuPreQuest, menuQuestList[k])
              end
            end
            local menuText = Table_Menu[menuid] and Table_Menu[menuid].text
            if menuText and menuText ~= "" then
              if lockStr ~= "" then
                lockStr = lockStr .. "\n"
              end
              lockStr = lockStr .. menuText
            end
          end
        end
      end
    end
  end
  if not raceValid then
    local sysmsg = Table_Sysmsg[43314]
    local msgStr = sysmsg and sysmsg.Text
    if lockStr ~= "" then
      lockStr = lockStr .. "\n"
    end
    lockStr = lockStr .. msgStr
  end
  local preQuestData = indexInfo.preQuestData
  if preQuestData and 0 < #preQuestData then
    for i = 1, #preQuestData do
      if preQuestData[i].questType == 4 then
        local questName = preQuestData[i].questName
        if lockStr ~= "" then
          lockStr = lockStr .. "\n"
        end
        lockStr = lockStr .. ZhString.QuestManual_FormerQuest .. questName
      else
        table.insert(targetPreQuest, preQuestData[i])
      end
    end
  end
  local prequestList = {}
  for i = 1, #menuPreQuest do
    local single = menuPreQuest[i]
    local questData = QuestProxy.Instance:getQuestDataByIdAndType(single)
    if questData then
      local data = {questData = questData, questType = 1}
      table.insert(prequestList, data)
    end
  end
  for i = 1, #targetPreQuest do
    local single = targetPreQuest[i]
    table.insert(prequestList, single)
  end
  self.prequestCtrl:ResetDatas(prequestList)
  self:ResizePrequestScrollView()
  if lockStr == "" then
    lockStr = 0 < #prequestList and ZhString.QuestManual_PreQuestTip2 or ZhString.QuestManual_PreQuestTip
  end
  self.lockLabel.richLabel.alignment = 2
  self.lockLabel:SetText(lockStr)
  self.tipLabel.text = ZhString.QuestManual_PreQuestTip3
  local height = self.lockLabel.richLabel.printedSize.y
  self.lockBg.height = height + 13
  self.lockIcon.transform.localPosition = LuaGeometry.GetTempVector3(0, height / 2, 0)
end

function QuestTracePanel:ClickLockedHeroQuest(cellCtrl)
  local id = cellCtrl.id
  if not id then
    redlog("无id")
    return
  end
  local config = Table_HeroStoryQuest[id]
  if not config then
    redlog("无配置", id)
    return
  end
  self.previewList[self.curType] = id
  self.tipLabel.text = ""
  self.lockStatus.transform.localPosition = LuaGeometry.GetTempVector3(0, 120, 0)
  self.questTitle.text = config.StoryName
  self.lockLabel:SetText(config.UnlockDesc or "")
  local height = self.lockLabel.richLabel.printedSize.y
  self.lockBg.height = height + 13
  self.lockIcon.transform.localPosition = LuaGeometry.GetTempVector3(0, height / 2, 0)
  self.lockLabel.richLabel.alignment = 28 < height and 1 or 2
  local heroStoryData = HeroProfessionProxy.Instance:GetHeroStoryByID(id)
  xdlog("检测解锁状态", id)
  if heroStoryData then
    if heroStoryData:IsWaitUnlock() then
      self.unlockBtn:SetActive(true)
      self.traceBtn:SetActive(false)
      local maxCount = GameConfig.HeroStory and GameConfig.HeroStory.DailyKeyNum or 5
      local keyUsed = MyselfProxy.Instance:GetAccVarValueByType(Var_pb.EACCVARTYPE_HERO_STORY_KEY_USED) or 0
      if 0 < maxCount - keyUsed then
        self:SetTextureWhite(self.unlockBtn, LuaGeometry.GetTempVector4(0.6666666666666666, 0.3764705882352941, 0.00784313725490196, 1))
      else
        self:SetTextureGrey(self.unlockBtn)
      end
      self.unlockBtn_BoxCollider.enabled = true
    elseif heroStoryData:IsLocked() then
      self.unlockBtn:SetActive(true)
      self.traceBtn:SetActive(false)
      self:SetTextureGrey(self.unlockBtn)
      self.unlockBtn_BoxCollider.enabled = false
    else
      self.unlockBtn:SetActive(false)
      self.traceBtn:SetActive(true)
    end
  else
    redlog("无服务器数据")
    self.unlockBtn:SetActive(false)
    self.traceBtn:SetActive(true)
  end
  self.prequestCtrl:RemoveAll()
  local extraList = {}
  local extraReward = config.ExtraReward
  if extraReward and 0 < #extraReward then
    for i = 1, #extraReward do
      local rewardInfo = extraReward[i].Reward and extraReward[i].Reward[1]
      if not extraList[rewardInfo[1]] then
        extraList[rewardInfo[1]] = rewardInfo[2]
      else
        extraList[rewardInfo[1]] = extraList[rewardInfo[1]] + rewardInfo[2]
      end
    end
  end
  local itemList = {}
  local reward = heroStoryData:GetReplacedRewards()
  if reward and 0 < #reward then
    for i = 1, #reward do
      local rewardId = reward[i]
      local items = ItemUtil.GetRewardItemIdsByTeamId(rewardId)
      if items and 0 < #items then
        for j = 1, #items do
          local item = items[j]
          if item.type == 2 then
            isRandom = true
          end
          if not itemList[item.id] then
            itemList[item.id] = item.num
          else
            itemList[item.id] = itemList[item.id] + item.num
          end
        end
      end
    end
  end
  local result = {}
  for k, v in pairs(extraList) do
    local itemData = ItemData.new("reward", k)
    itemData:SetItemNum(v)
    itemData.isExtra = true
    table.insert(result, itemData)
  end
  for k, v in pairs(itemList) do
    local itemData = ItemData.new("reward", k)
    itemData:SetItemNum(v)
    TableUtility.ArrayPushBack(result, itemData)
  end
  table.sort(result, function(l, r)
    local l_StaticID = l.staticData and l.staticData.id or 0
    local r_StaticID = r.staticData and r.staticData.id or 0
    if l_StaticID ~= r_StaticID then
      return l_StaticID < r_StaticID
    end
  end)
  self.rewardListCtrl:ResetDatas(result)
  local cells = self.rewardListCtrl:GetCells()
  if cells and 0 < #cells then
    for i = 1, #cells do
      cells[i]:SetFontSize(24)
      if cells[i].data.isExtra then
        cells[i]:SetTipLabel(ZhString.HeroStory_AllFinishReward)
      else
        cells[i]:SetTipLabel()
      end
    end
  end
  if result and #result == 0 then
    self.rewardPart:SetActive(false)
  else
    self.rewardPart:SetActive(true)
  end
  self.rewardTip.text = ZhString.QuestDetailTip_CommonReward
  self.scenicSpotCell:SetActive(false)
  self.rewardGrid:Reposition()
  self.rewardScrollView:ResetPosition()
end

function QuestTracePanel:handleClickPrequestCell(cellCtrl)
  local data = cellCtrl.data
  GameFacade.Instance:sendNotification(QuestEvent.QuestTraceSwitch, data)
  self:CloseSelf()
end

function QuestTracePanel:RemoveNewSymbol(cellCtrl)
  if cellCtrl.newSymbol.activeSelf then
    cellCtrl:SetNewSymbol(false)
    QuestProxy.Instance:RemoveClientNewQuest(cellCtrl.data.id)
    return true
  end
end

function QuestTracePanel:ClickGoal(params)
  if params.type == "Father" then
    local cells = self.questListCtrl:GetCells()
    local index = params.index
  elseif params.child and params.child.data then
    self:ClickQuestCell(params.child)
    self:SetChapterLockStatus(false)
    self:SetStory(false)
  end
end

function QuestTracePanel:ClickMainGoal(params)
  xdlog("ClickMainGoal")
  if params.type == "Child" then
    self.questInfoDetail:SetActive(true)
    self.noQuestTip:SetActive(false)
    local cell = params.child
    local data = cell and cell.cellData
    local isUnlock = data and data.isUnlock or false
    xdlog("点击主线", data.version, data.index, isUnlock, data.raceValid)
    if self.curChooseQuestCell ~= cell then
      if self.curChooseQuestCell then
        self.curChooseQuestCell:SetChooseStatus(false)
      end
      self.curChooseQuestCell = cell
      self.curChooseQuestCell:SetChooseStatus(true)
    else
      self.curChooseQuestCell = cell
    end
    if data.isKnight then
      redlog("骑士界面")
      self:UpdateKnightPrestige(data.prestigeVersion)
      return
    else
      self.knightPrestigePanel:SetActive(false)
    end
    if isUnlock then
      xdlog("打开故事界面")
      local indexID = cell and cell.indexID
      local storyConfig = Table_MainQuestStory[indexID]
      if indexID then
        self:SetStory(true, indexID)
      else
        self:SetStory(false)
        redlog("未找到Table_MainQuestStory故事ID", indexID)
      end
    else
      redlog("打开通常界面")
      self:SetStory(false)
      local questData = cell.questData
      if questData and data.questType == 1 and data.raceValid then
        self:SetChapterLockStatus(false)
        self:ClickQuestCell(cell)
      else
        redlog("封锁界面")
        self:SetChapterLockStatus(true)
        self:ClickLockedIndex(cell)
      end
    end
  elseif params.type == "CommonChild" then
    self.questInfoDetail:SetActive(true)
    self.knightPrestigePanel:SetActive(false)
    if params.child and params.child.data then
      self:ClickQuestCell(params.child)
      self:SetChapterLockStatus(false)
      self:SetStory(false)
    end
  elseif params.type == "Father" then
    local cell = params.father
    local fatherGoal = cell.data.fatherGoal
    local version = fatherGoal and fatherGoal.version
    xdlog("clickFather", version)
  end
end

function QuestTracePanel:ClickHeroGoal(params)
  if params.type == "Child" then
    self.questInfoDetail:SetActive(true)
    self.noQuestTip:SetActive(false)
    self.knightPrestigePanel:SetActive(false)
    local cell = params.child
    local state = cell and cell.state
    local questData = cell and cell.data
    if self.curChooseQuestCell ~= cell then
      if self.curChooseQuestCell then
        self.curChooseQuestCell:SetChooseStatus(false)
      end
      self.curChooseQuestCell = cell
      self.curChooseQuestCell:SetChooseStatus(true)
    else
      self.curChooseQuestCell = cell
      self.curChooseQuestCell:SetChooseStatus(true)
    end
    self:SetHeroStory(false)
    if state == SceneUser3_pb.HEROSTORY_QUEST_STATE_INPROCESS then
      if questData then
        self:ClickQuestCell(cell)
        self:SetChapterLockStatus(false)
      else
      end
    elseif state == SceneUser3_pb.HEROSTORY_QUEST_STATE_UNLOCK or state == SceneUser3_pb.HEROSTORY_QUEST_STATE_UNACCEPT then
      self:SetChapterLockStatus(true)
      self:ClickLockedHeroQuest(cell)
    elseif state == SceneUser3_pb.HEROSTORY_QUEST_STATE_REWARD or state == SceneUser3_pb.HEROSTORY_QUEST_STATE_COMPLETE then
      self:SetHeroStory(true, cell.id)
    end
  elseif params.type == "Father" then
  end
end

function QuestTracePanel:UpdateQuestInfo()
  if not self.curChooseQuestCell then
    return
  end
  local desStr = ""
  if self.curChooseQuestCell.isCombined then
    local questList = self.curChooseQuestCell.questList
    for i = 1, #questList do
      local single = questList[i]
      local traceInfo = single:parseTranceInfo()
      if not single.isFinish then
        desStr = desStr .. "{taskuiicon=tips_icon_01}" .. traceInfo
      else
        local finishTraceInfo = OverSea.LangManager.Instance():GetLangByKey(Table_FinishTraceInfo[single.id].FinishTraceInfo)
        desStr = desStr .. "{taskuiicon=pet_icon_finish}" .. "[c][A2A2A2]" .. finishTraceInfo .. "[-][/c]"
      end
      if i < #questList then
        desStr = desStr .. "\n"
      end
    end
    desStr = desStr or ""
    desStr = string.gsub(desStr, "ffff00", "FF7D13")
    self.traceInfo:SetText(desStr)
    local questData = self.curChooseQuestCell.curChoose
    self.questTitle.text = questData.traceTitle or ""
    local map = self.curChooseQuestCell.curChoose.map
    if not map then
      self.mapIcon.gameObject:SetActive(false)
      self.traceInfoGO.transform.localPosition = LuaGeometry.GetTempVector3(-274, 229, 0)
    else
      self.mapIcon.gameObject:SetActive(true)
      local mapData = Table_Map[map]
      self.mapLabel.text = mapData.CallZh
      self.traceInfoGO.transform.localPosition = LuaGeometry.GetTempVector3(-274, 186, 0)
    end
  else
    local questData = self.curChooseQuestCell.data
    self.questTitle.text = questData.traceTitle or ""
    xdlog("正常任务", questData.id)
    local map = questData.map
    if not map then
      self.mapIcon.gameObject:SetActive(false)
      self.traceInfoGO.transform.localPosition = LuaGeometry.GetTempVector3(-274, 229, 0)
    else
      self.mapIcon.gameObject:SetActive(true)
      local mapData = Table_Map[map]
      if not mapData then
        self.mapLabel.text = "???"
      else
        self.mapLabel.text = mapData.CallZh
      end
      self.traceInfoGO.transform.localPosition = LuaGeometry.GetTempVector3(-274, 186, 0)
    end
    local desStr = questData:parseTranceInfo() or ""
    if desStr == "" and map then
      local mapData = Table_Map[map]
      desStr = string.format(ZhString.QuestTraceCell_TargetMap, mapData.CallZh)
    end
    desStr = string.gsub(desStr, "ffff00", "FF7D13")
    self.traceInfo:SetText(desStr)
  end
  self.unlockBtn:SetActive(false)
  self.traceBtn:SetActive(true)
end

local RewardType = {
  Common = 1,
  RewardChooseType = 2,
  RewardGroupType = 3,
  None = 4
}

function QuestTracePanel:UpdateRewardPart(data, showAllReward)
  if not data then
    return
  end
  local itemList = {}
  local rewardList = {}
  local rewards = QuestProxy.Instance:GetReplacedRewardByQuestData(data)
  local rewardType = 0
  local rewardConfig = GameConfig.SpecialShowReward
  if rewardConfig and rewardConfig[data.id] then
    xdlog("通用奖励展示")
    local tempRewardList = {}
    local commonReward = rewardConfig[data.id].Reward
    if commonReward and 0 < #commonReward then
      for i = 1, #commonReward do
        table.insert(tempRewardList, commonReward[i])
      end
    end
    local myGender = MyselfProxy.Instance:GetMySex()
    local sexSeperateReward = myGender == 1 and rewardConfig[data.id].Male or rewardConfig[data.id].Female
    if sexSeperateReward and 0 < #sexSeperateReward then
      for i = 1, #sexSeperateReward do
        table.insert(tempRewardList, sexSeperateReward[i])
      end
    end
    for i = 1, #tempRewardList do
      local rewardId = tempRewardList[i]
      if rewardId then
        local items = ItemUtil.GetRewardItemIdsByTeamId(rewardId)
        if items and 0 < #items then
          for j = 1, #items do
            local item = items[j]
            if not itemList[item.id] then
              itemList[item.id] = item.num
            else
              itemList[item.id] = itemList[item.id] + item.num
            end
          end
        end
      end
    end
    self.rewardTip.text = ZhString.QuestDetailTip_CommonReward
    rewardType = RewardType.Common
  elseif data.rewards then
    for i = 1, #data.rewards do
      local single = data.rewards[i]
      if single and Table_Item[single.id] then
        if not itemList[single.id] then
          itemList[single.id] = single.count
        else
          itemList[single.id] = itemList[single.id] + single.count
        end
      end
    end
    self.rewardTip.text = ZhString.QuestDetailTip_CommonReward
    rewardType = RewardType.Common
  elseif rewards and 1 < #rewards then
    if showAllReward then
      for i = 1, #rewards do
        local rewardId = rewards[i]
        if rewardId then
          local items = ItemUtil.GetRewardItemIdsByTeamId(rewardId)
          if items and 0 < #items then
            for j = 1, #items do
              local item = items[j]
              if not itemList[item.id] then
                itemList[item.id] = item.num
              else
                itemList[item.id] = itemList[item.id] + item.num
              end
            end
          end
        end
      end
      self.rewardTip.text = ZhString.QuestDetailTip_CommonReward
      rewardType = RewardType.RewardGroupType
    else
      self.rewardTip.text = ZhString.QuestDetailTip_MultReward
      rewardType = RewardType.RewardChooseType
    end
  elseif rewards and 0 < #rewards then
    local rewardId = rewards[1]
    local isRandom = false
    if rewardId then
      local items = ItemUtil.GetRewardItemIdsByTeamId(rewardId)
      if items and 0 < #items then
        for j = 1, #items do
          local item = items[j]
          if item.type == 2 then
            isRandom = true
          end
          if not itemList[item.id] then
            itemList[item.id] = item.num
          else
            itemList[item.id] = itemList[item.id] + item.num
          end
        end
      end
    end
    self.rewardTip.text = isRandom and ZhString.QuestDetailTip_RandomReward or ZhString.QuestDetailTip_CommonReward
    rewardType = RewardType.RewardGroupType
  else
    self.rewardTip.text = ZhString.QuestDetailTip_CommonReward
  end
  local menuRewards = QuestProxy.Instance:getValidReward(data)
  self.scenicSpotCell:SetActive(menuRewards ~= nil)
  if menuRewards then
    self.menuRewards = {}
    TableUtility.TableShallowCopy(self.menuRewards, menuRewards)
  end
  for k, v in pairs(itemList) do
    local itemData = ItemData.new("reward", k)
    itemData:SetItemNum(v)
    table.insert(rewardList, itemData)
  end
  local stepActions = data.staticData.stepactions
  if stepActions and 0 < #stepActions then
    for i = 1, #stepActions do
      local single = stepActions[i]
      local params = single.params
      if params then
        local type = params.type
        if type == "achieve" then
          local id = tonumber(params.id)
          local achievementConfig = Table_Achievement[id]
          if achievementConfig then
            local rewardAttr = achievementConfig.RewardAttr
            for name, value in pairs(rewardAttr) do
              local iconConfig = GameConfig.AchievementAttrReward and GameConfig.AchievementAttrReward[name]
              local showData = {
                icon = iconConfig and iconConfig.icon or "tab_icon_BaseHp",
                scale = iconConfig and iconConfig.scale or 1,
                value = value,
                type = type
              }
              table.insert(rewardList, showData)
            end
          end
        end
      end
    end
  end
  table.sort(rewardList, function(l, r)
    local l_StaticID = l.staticData and l.staticData.id or 0
    local r_StaticID = r.staticData and r.staticData.id or 0
    if l_StaticID ~= r_StaticID then
      return l_StaticID < r_StaticID
    end
  end)
  self.rewardListCtrl:ResetDatas(rewardList)
  local cells = self.rewardListCtrl:GetCells()
  if cells and 0 < #cells then
    for i = 1, #cells do
      cells[i]:SetFontSize(24)
    end
  end
  if rewardList and #rewardList == 0 then
    if rewardType == RewardType.RewardChooseType then
      self.rewardPart:SetActive(true)
    elseif not self.scenicSpotCell.activeSelf then
      self.rewardPart:SetActive(false)
    end
  else
    self.rewardTip.text = ZhString.QuestDetailTip_CommonReward
    self.rewardPart:SetActive(true)
  end
  self.rewardGrid:Reposition()
  self.rewardScrollView:ResetPosition()
end

function QuestTracePanel:ShowScenicSpotList()
  if self.menuRewards then
    self.sceneSpotList:SetActive(true)
    self.sceneSpotGridCtrl:ResetDatas(self.menuRewards)
    self.sceneSpotGrid:Reposition()
  end
end

function QuestTracePanel:SetTraceCount()
  if not self.validAcceptQuestList then
    return
  end
  local count = 0
  for i = 1, #self.validAcceptQuestList do
    local single = self.validAcceptQuestList[i]
    if single.trace then
      count = count + 1
    end
  end
  local maxTraceCount = 3
  local str = count .. "/" .. maxTraceCount
  self.traceCount.text = string.format(ZhString.QuestTraceCell_TraceCount, str)
end

function QuestTracePanel:questReunit(list)
  local tempResult = ReusableTable.CreateTable()
  local Result = ReusableTable.CreateTable()
  if 0 < #list then
    for i = 1, #list do
      local single = list[i]
      local questid = single.id
      if tempResult and tempResult[questid] then
        redlog("重复ID", questid)
      end
      if Table_FinishTraceInfo and Table_FinishTraceInfo[questid] then
        local traceGroupID = Table_FinishTraceInfo[questid].QuestKey
        if not tempResult[traceGroupID] then
          tempResult[traceGroupID] = {
            isCombined = true,
            groupid = traceGroupID,
            type = single.type,
            orderId = questid,
            id = questid
          }
          tempResult[traceGroupID].questList = {}
        end
        single.isFinish = false
        table.insert(tempResult[traceGroupID].questList, single)
      else
        tempResult[questid] = single
        tempResult[questid].isCombined = false
      end
    end
  end
  local finishList = QuestProxy.Instance:getQuestListInOrder(SceneQuest_pb.EQUESTLIST_SUBMIT)
  for i = 1, #finishList do
    local single = finishList[i]
    if Table_FinishTraceInfo and Table_FinishTraceInfo[single.id] then
      local traceGroupID = Table_FinishTraceInfo[single.id].QuestKey
      if tempResult[traceGroupID] then
        single.isFinish = true
        table.insert(tempResult[traceGroupID].questList, single)
      end
    end
  end
  for _, temp in pairs(tempResult) do
    table.insert(Result, temp)
  end
  table.sort(Result, function(l, r)
    if l.isCombined ~= r.isCombined then
      return l.isCombined == true
    end
    if l.newstatus ~= r.newstatus then
      return l.newstatus < r.newstatus
    end
    local lTrace = QuestProxy.Instance:CheckQuestIsTrace(l.id)
    local rTrace = QuestProxy.Instance:CheckQuestIsTrace(r.id)
    if lTrace and rTrace then
      return lTrace < rTrace
    else
      return lTrace ~= nil
    end
  end)
  return Result
end

function QuestTracePanel:HandleTraceStatusUpdate(cellCtrl)
  xdlog("HandleTraceStatusUpdate -- todo")
  if cellCtrl then
    if cellCtrl.questList then
      local questids = {}
      for i = 1, #cellCtrl.questList do
        local single = cellCtrl.questList[i]
        table.insert(questids, single.id)
      end
      if questids and 0 < #questids then
        if cellCtrl.toggle.value then
          QuestProxy.Instance:AddQuestsToTraceList(questids)
        else
          QuestProxy.Instance:RemoveTraceListByIDs(questids)
        end
      end
    else
      if cellCtrl.data and cellCtrl.data.id then
        if cellCtrl.toggle.value then
          QuestProxy.Instance:AddTraceList(cellCtrl.data.id)
        else
          QuestProxy.Instance:RemoveTraceList(cellCtrl.data.id)
        end
      end
      local questData = cellCtrl.data
      if questData and questData.type == "worldboss" then
        LocalSaveProxy.Instance:AddWorldBossQuestTrace(questData.id, cellCtrl.toggle.value and 1 or 2)
      end
    end
    QuestProxy.Instance:callQuestStatus()
  end
  self:RefreshTraceCount()
end

function QuestTracePanel:HandleShowPuzzleImage(note)
  local version = note.version
  xdlog("version", version)
  self.puzzlePart:SetActive(true)
  for i = 1, #Table_QuestVersion do
    local ven = Table_QuestVersion[i]
    if ven.version == version then
      local versionPic = ven.VersionPic
      if versionPic and versionPic ~= "" then
        PictureManager.Instance:SetPuzzleBG(versionPic, self.puzzleTexture)
        break
      end
    end
  end
end

function QuestTracePanel:RefreshTraceCount()
  local maxCount = GameConfig.Quest.max_trace_count or 4
  local traceList = QuestProxy.Instance.clientTraceList
  local curCount = traceList and #traceList or 0
  if traceList and 0 < #traceList then
    local str = ""
    for i = 1, #traceList do
      str = str .. traceList[i] .. ","
    end
    xdlog("追踪中", str)
  end
  self.questTypeScrollView:ResetPosition()
end

function QuestTracePanel:UpdateRepairBtn()
  if MyselfProxy.Instance.questRepairModeOn then
    self.repairBtn:SetActive(true)
  else
    self.repairBtn:SetActive(false)
  end
end

function QuestTracePanel:RefreshQuestManualRedtip()
  self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_QUESTPUZZLE_CANLOCK, self.questManualBtn, 42)
end

function QuestTracePanel:CheckPuzzleRedtipValid()
  local redTip = RedTipProxy.Instance:GetRedTip(SceneTip_pb.EREDSYS_QUESTPUZZLE_CANLOCK)
  if not redTip then
    return true
  end
  local redTipParams = redTip.params
  local count = 0
  for k, v in pairs(redTipParams) do
    count = count + 1
  end
  if count == 1 then
    local myPro = Game.Myself.data.userdata:Get(UDEnum.PROFESSION)
    local myRace = Table_Class[myPro].Race
    if not myRace or myRace == 1 then
      if RedTipProxy.Instance:IsNew(SceneTip_pb.EREDSYS_QUESTPUZZLE_CANLOCK, 20) then
        return false
      else
        return true
      end
    elseif RedTipProxy.Instance:IsNew(SceneTip_pb.EREDSYS_QUESTPUZZLE_CANLOCK, 10) then
      return false
    else
      return true
    end
  else
    return true
  end
end

function QuestTracePanel:SetChapterLockStatus(bool)
  self.mainStoryPart:SetActive(false)
  self.lockStatus:SetActive(bool)
  self.questDetail:SetActive(not bool)
  self.tipLabel.gameObject:SetActive(bool)
  self.traceBtn:SetActive(true)
  self.knightPrestigePanel:SetActive(false)
  if bool then
    self:SetTextureGrey(self.traceBtn)
    self.traceBtn_BoxCollider.enabled = false
  else
    self:SetTextureWhite(self.traceBtn, LuaGeometry.GetTempVector4(0.6666666666666666, 0.3764705882352941, 0.00784313725490196, 1))
    self.traceBtn_BoxCollider.enabled = true
  end
end

function QuestTracePanel:SetStory(bool, indexID)
  self.questInfoPart:SetActive(not bool)
  self.mainStoryPart:SetActive(bool)
  self.unlockBtn:SetActive(false)
  self.traceBtn:SetActive(not bool)
  self.knightPrestigePanel:SetActive(false)
  xdlog("SetStory", bool, indexID)
  local storyConfig = Table_MainQuestStory[indexID]
  if not storyConfig then
    redlog("无故事ID Table_MainQuestStory", indexID)
    return
  end
  self.storyTitle.text = storyConfig and storyConfig.QuestName or "???"
  local storyIDs = storyConfig and storyConfig.Mstory
  if bool and storyIDs and 0 < #storyIDs then
    local storyStr = ""
    for i = 1, #storyIDs do
      local storyID = storyIDs[i]
      if storyID and storyID ~= 0 then
        if 1 < i then
          storyStr = storyStr .. "\n"
        end
        local dialogData = DialogUtil.GetDialogData(storyID)
        local str = OverSea.LangManager.Instance():GetLangByKey(dialogData.Text)
        str = string.gsub(str, "\n", "\n" .. UIUtil.GetIndentString())
        local indent = UIUtil.GetIndentString()
        storyStr = storyStr .. indent .. str
      end
    end
    if storyStr ~= "" then
      self.storyLabel.text = storyStr
    end
    local printedY = self.storyLabel.printedSize.y
    local lineCount = printedY / 36
    local x, y, z = LuaGameObject.GetLocalPosition(self.lineGO.transform)
    for i = 1, lineCount do
      if not self.lineCell[i] then
        local obj = self:CopyGameObject(self.lineGO)
        obj:SetActive(true)
        obj.transform.localPosition = LuaGeometry.GetTempVector3(x, y - 36 * i, z)
        self.lineCell[i] = obj
      else
        self.lineCell[i]:SetActive(true)
      end
    end
    for i = #self.lineCell, lineCount + 1, -1 do
      GameObject.DestroyImmediate(self.lineCell[i])
      table.remove(self.lineCell, i)
    end
    x, y, z = LuaGameObject.GetLocalPosition(self.storyGainSymbol.transform)
    self.storyGainSymbol.transform.localPosition = LuaGeometry.GetTempVector3(x, 200 - printedY, z)
  end
  self.storyScrollView:ResetPosition()
end

function QuestTracePanel:SetHeroStory(bool, storyID)
  self.questInfoPart:SetActive(not bool)
  self.mainStoryPart:SetActive(bool)
  self.unlockBtn:SetActive(false)
  self.knightPrestigePanel:SetActive(false)
  if bool and storyID ~= nil then
    local config = Table_HeroStoryQuest[storyID]
    if not config then
      redlog("无配置")
      return
    end
    self.previewList[self.curType] = storyID
    self.storyTitle.text = config.StoryName
    local storyContent = config.StoryContent
    self.storyLabel.text = ZhString.QuestManual_TwoSpace .. OverSea.LangManager.Instance():GetLangByKey(storyContent)
    local printedY = self.storyLabel.printedSize.y
    local lineCount = printedY / 36
    local x, y, z = LuaGameObject.GetLocalPosition(self.lineGO.transform)
    for i = 1, lineCount do
      if not self.lineCell[i] then
        local obj = self:CopyGameObject(self.lineGO)
        obj:SetActive(true)
        obj.transform.localPosition = LuaGeometry.GetTempVector3(x, y - 36 * i, z)
        self.lineCell[i] = obj
      else
        self.lineCell[i]:SetActive(true)
      end
    end
    for i = #self.lineCell, lineCount + 1, -1 do
      GameObject.DestroyImmediate(self.lineCell[i])
      table.remove(self.lineCell, i)
    end
    x, y, z = LuaGameObject.GetLocalPosition(self.storyGainSymbol.transform)
    self.storyGainSymbol.transform.localPosition = LuaGeometry.GetTempVector3(x, 200 - printedY, z)
  end
  self.storyScrollView:ResetPosition()
end

function QuestTracePanel:HandleHeroStoryUpate()
  local heroStories = HeroProfessionProxy.Instance.heroStories
  local typeTogs = self.questTypeTogCtrl:GetCells()
  if heroStories and next(heroStories) then
    typeTogs[#typeTogs].gameObject:SetActive(true)
  else
    typeTogs[#typeTogs].gameObject:SetActive(false)
  end
  self.questTypeGrid:Reposition()
  if self.pageType == PageEnum.Hero then
    self:UpdateHeroQuestList(true)
  else
    redlog("当前不在英雄页签下，不执行操作")
  end
end

function QuestTracePanel:HandleHeroStoryAccept(note)
  local data = note.body
  local unlockid = data and data.id
  if self.pageType ~= PageEnum.Hero then
    redlog("不在赞歌页签下")
    return
  end
  local cells = self.heroQuestCtrl:GetCells()
  for i = 1, #cells do
    local childCells = cells[i].childCtl:GetCells()
    for j = 1, #childCells do
      local singleCell = childCells[j]
      if singleCell.id == unlockid then
        local heroStoryData = HeroProfessionProxy.Instance:GetHeroStoryByID(unlockid)
        local cellData = singleCell.cellData
        cellData.state = heroStoryData.serverData.state
        self:HeroCellDelayUpdate(singleCell, 500, 5)
        return
      end
    end
  end
end

function QuestTracePanel:HeroCellDelayUpdate(cell, delay, count)
  if not cell then
    return
  end
  local id = cell.id
  local storyConfig = Table_HeroStoryQuest[id]
  local targetQuestID = storyConfig and storyConfig.FirstQuestID
  local tempQuestData = targetQuestID and QuestProxy.Instance:GetValidQuestBySameQuestID(targetQuestID)
  if not tempQuestData then
    if 0 < count then
      TimeTickManager.Me():CreateOnceDelayTick(delay, function(owner, deltaTime)
        self:HeroCellDelayUpdate(cell, delay, count - 1)
      end, 2)
    end
  else
    TimeTickManager.Me():CreateOnceDelayTick(delay, function(owner, deltaTime)
      cell:ResetData()
      cell:PlayTween()
      cell:HandleClickSelf()
    end, 2)
  end
end

function QuestTracePanel:UpdateKnightPrestige(prestigeVersion)
  self.questInfoPart:SetActive(false)
  self.mainStoryPart:SetActive(false)
  self.unlockBtn:SetActive(false)
  self.knightPrestigePanel:SetActive(true)
  if prestigeVersion then
    if self.prestigeVersion and self.prestigeVersion ~= prestigeVersion then
      self.curShowPrestigeLevel = nil
    end
    self.prestigeVersion = prestigeVersion
  end
  local prestigeVersionInfo = VersionPrestigeProxy.Instance:GetPrestigeInfo(self.prestigeVersion)
  if not prestigeVersionInfo then
    redlog("没有数据", self.prestigeVersion)
    return
  end
  VersionPrestigeProxy.Instance:BrowseLevelUpNotify(self.prestigeVersion)
  local maxValue = GameConfig.Prestige and GameConfig.Prestige.MaxPrestige and GameConfig.Prestige.MaxPrestige[self.prestigeVersion] or "--r"
  local curValue = prestigeVersionInfo.value or 0
  local titleConfig = GameConfig.Prestige and GameConfig.Prestige.PrestigeTitle
  local prestigeName = titleConfig and titleConfig[self.prestigeVersion] and titleConfig[self.prestigeVersion].prestige_name or "???"
  self.knightPrestigeValue.text = string.format("%s:%s", prestigeName, curValue)
  local dailyLimitConfig = GameConfig.Prestige and GameConfig.Prestige.PrestigeDailyLimit
  local curVersionConfig = dailyLimitConfig and dailyLimitConfig[self.prestigeVersion]
  if curVersionConfig then
    self.knightPrestigeDailyLimitLabel.gameObject:SetActive(true)
    local curDailyProcess = prestigeVersionInfo.dailyLimit or 0
    local maxLimit = curVersionConfig.limit
    if curDailyProcess >= maxLimit then
      curDailyProcess = string.format("[c][FF5F11]%s[-][/c]", curDailyProcess)
    end
    self.knightPrestigeDailyLimitLabel.text = string.format(ZhString.KnightPrestige_DailyLimit, curDailyProcess, maxLimit)
  else
    self.knightPrestigeDailyLimitLabel.gameObject:SetActive(false)
  end
  local staticPrestigeInfo = VersionPrestigeProxy.Instance:GetStaticPrestigeInfo(self.prestigeVersion)
  local curLv = prestigeVersionInfo.level or 0
  self.curPrestigeLevel = curLv
  local maxLevel = staticPrestigeInfo and staticPrestigeInfo.MaxLevel
  local rewardedLevels = prestigeVersionInfo and prestigeVersionInfo.rewarded_levels or {}
  if curLv < maxLevel then
    self.curTip:SetActive(true)
    self.maxTip:SetActive(false)
    self.curLvLabel.text = "Lv." .. curLv
    self.nextLvLabel.text = "Lv." .. curLv + 1
    self.prestigeGainWayBtn:SetActive(true)
  else
    self.curTip:SetActive(false)
    self.maxTip:SetActive(true)
    self.prestigeGainWayBtn:SetActive(false)
  end
  if not self.curShowPrestigeLevel then
    self.curShowPrestigeLevel = curLv + 1
    if maxLevel < self.curShowPrestigeLevel then
      self.curShowPrestigeLevel = maxLevel
    end
  end
  local prestigeValue = staticPrestigeInfo and staticPrestigeInfo.PrestigeValue
  local targetCell
  self.sliderCtrl:SetEmptyDatas(maxLevel)
  self.sliderGrid:Reposition()
  local cells = self.sliderCtrl:GetCells()
  for i = 1, #cells do
    local index = VersionPrestigeProxy.Instance:ParseLevelToIndex(self.prestigeVersion, i)
    local targetPrestige = prestigeValue and prestigeValue[index]
    local startPrestige = prestigeValue and prestigeValue[index - 1] or 0
    cells[i]:SetVersion(self.prestigeVersion)
    cells[i]:SetLevelText(i, targetPrestige)
    cells[i]:SetChooseStatus(i == self.curShowPrestigeLevel)
    if i == self.curShowPrestigeLevel then
      targetCell = cells[i]
    end
    if i < curLv then
      cells[i]:SetStatus(1)
      local rewarded = 0 < TableUtility.ArrayFindIndex(rewardedLevels, i)
      cells[i]:SetRedTip(not rewarded)
    elseif i == curLv then
      cells[i]:SetStatus(2)
      local rewarded = 0 < TableUtility.ArrayFindIndex(rewardedLevels, i)
      cells[i]:SetRedTip(not rewarded)
    else
      cells[i]:SetStatus(3)
    end
    cells[i]:SetTargetSymbol(i == curLv + 1)
  end
  self.sliderBG.width = 73 + (maxLevel - 1) * 105.8
  local curLv_StartPrestige = prestigeValue
  if curLv == 0 then
    local curLv_index = VersionPrestigeProxy.Instance:ParseLevelToIndex(self.prestigeVersion, 1)
    local targetPrestige = prestigeValue and prestigeValue[curLv_index]
    if curValue > targetPrestige then
      curValue = targetPrestige
    end
    local percent = curValue / targetPrestige
    self.sliderFore.width = 73 * percent
    if curValue == 0 then
      self.sliderFore.gameObject:SetActive(false)
    else
      self.sliderFore.gameObject:SetActive(true)
    end
  elseif curLv == maxLevel then
    self.sliderFore.gameObject:SetActive(true)
    self.sliderFore.width = 73 + (curLv - 1) * 105.8
  else
    self.sliderFore.gameObject:SetActive(true)
    local curLv_index = VersionPrestigeProxy.Instance:ParseLevelToIndex(self.prestigeVersion, curLv)
    local targetPrestige = prestigeValue and prestigeValue[curLv_index + 1]
    local startPrestige = prestigeValue and prestigeValue[curLv_index] or 0
    if targetPrestige and curValue > targetPrestige then
      curValue = targetPrestige
    end
    local percent = (curValue - startPrestige) / (targetPrestige - startPrestige)
    self.sliderFore.width = 73 + (curLv - 1) * 105.8 + percent * 105.8
  end
  TimeTickManager.Me():CreateOnceDelayTick(100, function(owner, deltaTime)
    local panel = self.sliderScrollView.panel
    local bound = NGUIMath.CalculateRelativeWidgetBounds(panel.cachedTransform, targetCell.gameObject.transform)
    local offset = panel:CalculateConstrainOffset(bound.min, bound.max)
    offset = Vector3(offset.x, 0, 0)
    self.sliderScrollView:MoveRelative(offset)
  end, self, 3)
  local ruleConfig = GameConfig.Prestige and GameConfig.Prestige.Rule
  local versionRuleConfig = ruleConfig and ruleConfig[self.prestigeVersion]
  if versionRuleConfig then
    self.ruleInfoLabel.gameObject:SetActive(true)
    if versionRuleConfig.shortcutpower then
      self.ruleGoToBtn:SetActive(true)
      self.prestigeGoToModeID = versionRuleConfig.shortcutpower
    else
      self.ruleGoToBtn:SetActive(false)
    end
    local helpid = versionRuleConfig.helpid
    local helpConfig = helpid and Table_Help[helpid]
    if helpConfig then
      self.ruleLabel.text = helpConfig.Desc
    end
  else
    self.ruleInfoLabel.gameObject:SetActive(false)
  end
  self.upgradeLabel.text = string.format(ZhString.KnightPrestige_LevelUpCondition, self.curShowPrestigeLevel)
  local conds = VersionPrestigeProxy.Instance:GetPrestigeLevelConditions(self.prestigeVersion, self.curShowPrestigeLevel)
  self.upgradeCtrl:ResetDatas(conds)
  self.unlockTipLabel.text = string.format(ZhString.KnightPrestige_NextLevelUnlock, self.curShowPrestigeLevel)
  local prestigeID = VersionPrestigeProxy.Instance:ParseLevelToIndex(self.prestigeVersion, self.curShowPrestigeLevel)
  local prestigeConfig = Table_PrestigeLevel[prestigeID]
  if prestigeConfig then
    local effect = prestigeConfig.Effect or {}
    self.unlockTipCtrl:ResetDatas(effect)
    self.unlockTipLabel.gameObject:SetActive(0 < #effect)
  end
  local unlockCells = self.unlockTipCtrl:GetCells()
  for i = 1, #unlockCells do
    unlockCells[i]:SetFinish(curLv >= self.curShowPrestigeLevel)
  end
  self.upgradeRewardTipLabel.text = string.format(ZhString.KnightPrestige_NextLevelReward, self.curShowPrestigeLevel)
  local itemList = {}
  local rewardId = prestigeConfig and prestigeConfig.Reward
  local items = ItemUtil.GetRewardItemIdsByTeamId(rewardId)
  if items and 0 < #items then
    for j = 1, #items do
      local item = items[j]
      if item.type == 2 then
        isRandom = true
      end
      if not itemList[item.id] then
        itemList[item.id] = item.num
      else
        itemList[item.id] = itemList[item.id] + item.num
      end
    end
  end
  local result = {}
  for k, v in pairs(itemList) do
    local itemData = ItemData.new("reward", k)
    itemData:SetItemNum(v)
    table.insert(result, itemData)
  end
  self.upgradeRewardCtrl:ResetDatas(result)
  local rewardCells = self.upgradeRewardCtrl:GetCells()
  local rewarded = TableUtility.ArrayFindIndex(rewardedLevels, self.curShowPrestigeLevel) > 0
  for i = 1, #rewardCells do
    rewardCells[i]:SetGetSymbol(rewarded)
  end
  if rewarded then
    self.upgradeRewardRecvBtn:SetActive(false)
  else
    self.upgradeRewardRecvBtn:SetActive(true)
    if curLv < self.curShowPrestigeLevel then
      self.upgradeRewardRecvBtn_Icon.CurrentState = 1
      self.upgradeRewardRecvBtn_BoxCollider.enabled = false
      self.upgradeRewardRecvBtn_Label.effectColor = ColorUtil.NGUIGray
    else
      self.upgradeRewardRecvBtn_Icon.CurrentState = 0
      self.upgradeRewardRecvBtn_BoxCollider.enabled = true
      self.upgradeRewardRecvBtn_Label.effectColor = ColorUtil.ButtonLabelOrange
    end
  end
  self.upgradeRewardTipLabel.gameObject:SetActive(0 < #result)
  self.lvInfoTable:Reposition()
  if self.prestigeVersion and self.prestigeVersion == 1 then
    local professionSkill = SkillProxy.Instance:FindProfessSkill(ProfessionProxy.CommonClass)
    local skillData = professionSkill:FindSkillById(4620001)
    if skillData then
      self.skillBtn:SetActive(true)
    else
      self.skillBtn:SetActive(false)
    end
  else
    self.skillBtn:SetActive(false)
  end
end

function QuestTracePanel:HandlePrestigeUpdate()
  self:UpdateCellPrestigeProcess()
  if self.knightPrestigePanel.activeSelf then
    self:UpdateKnightPrestige()
  end
  QuestProxy.Instance:RefreshWorldQuestNewSymbol()
  self:RefreshNewTag()
end

function QuestTracePanel:UpdateCellPrestigeProcess()
  local cells = self.mainQuestCtrl:GetCells() or {}
  for i = 1, #cells do
    local childCells = cells[i]:GetChildCells() or {}
    for j = 1, #childCells do
      if childCells[j].cellData and childCells[j].cellData.isKnight then
        local prestigeVersion = childCells[j].cellData.prestigeVersion
        local prestigeInfo = VersionPrestigeProxy.Instance:GetPrestigeInfo(prestigeVersion)
        local staticPrestigeInfo = VersionPrestigeProxy.Instance:GetStaticPrestigeInfo(prestigeVersion)
        if prestigeInfo then
          local maxLevel = staticPrestigeInfo and staticPrestigeInfo.MaxLevel
          local curLv = prestigeInfo.level or 0
          childCells[j]:ResetData()
        end
      end
    end
  end
end

function QuestTracePanel:HandleRecvPrestigeReward()
  if self.knightPrestigePanel.activeSelf then
    self:UpdateKnightPrestige()
  end
  xdlog("领奖反馈")
end

function QuestTracePanel:HandleRedTipUpdate(note)
  local data = note.body
  local redtipid = data.id
  if redtipid and redtipid == SceneTip_pb.EREDSYS_PRESTIGE_SYSTEM_REWARD then
    xdlog("刷新new")
    self:RefreshNewTag()
  end
end

function QuestTracePanel:handleClickPrestigeLevel(cellCtrl)
  local level = cellCtrl and cellCtrl.level
  xdlog("切换等级显示", level)
  if level and level ~= self.curShowPrestigeLevel then
    self.curShowPrestigeLevel = level
    self:UpdateKnightPrestige()
  end
end

function QuestTracePanel:CallPrestigeInfo()
  local prestigeConfig = GameConfig.Prestige
  if not prestigeConfig then
    return
  end
  local maxPrestige = prestigeConfig.MaxPrestige
  local unlockMenu = prestigeConfig.PrestigeUnlockMenu
  for prestigeID, _ in pairs(maxPrestige) do
    local menuID = unlockMenu and unlockMenu[prestigeID]
    if menuID and FunctionUnLockFunc.Me():CheckCanOpen(menuID) then
      xdlog("申请数据")
      ServiceSceneUser3Proxy.Instance:CallQueryPrestigeCmd(prestigeID)
    end
  end
end

function QuestTracePanel:OnEnter()
  local hasMpInfo = ProfessionProxy.Instance:HasMPInfo()
  if not hasMpInfo then
    ServiceNUserProxy.Instance:CallProfessionQueryUserCmd(nil)
  end
  self:CallPrestigeInfo()
  ServiceSceneUser3Proxy.Instance:CallHeroStoryQuestInfo()
  QuestTracePanel.super.OnEnter(self)
  for objName, texName in pairs(decorateTextureNameMap) do
    picIns:SetUI(texName, self[objName])
  end
  picIns:SetMissionTrackTexture("Missiontracking_bottom_13", self.prestigeTextureBG)
end

function QuestTracePanel:OnExit()
  GameFacade.Instance:sendNotification(QuestEvent.QuestTracePanelOff)
  QuestTracePanel.super.OnExit(self)
  TimeTickManager.Me():ClearTick(self)
  for objName, texName in pairs(decorateTextureNameMap) do
    picIns:UnLoadUI(texName, self[objName])
  end
  picIns:UnloadMissionTrackTexture("Missiontracking_bottom_13", self.prestigeTextureBG)
end
