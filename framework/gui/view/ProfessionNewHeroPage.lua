autoImport("ProfessionNewHeroIntroCell")
autoImport("ProfessionNewHeroTaskCell")
autoImport("ProfessionNewHeroStoryCell")
ProfessionNewHeroPage = class("ProfessionNewHeroPage", SubView)
ProfessionNewHeroPage.ViewType = UIViewType.NormalLayer
local inoutAnimDelay = 0.1
local normalProgressColor = Color(1, 1, 1, 1)
local completeProgressColor = Color(0.7490196078431373, 1, 0.7294117647058823, 1)

function ProfessionNewHeroPage:LoadView()
  local viewPath = ResourcePathHelper.UIView("ProfessionNewHeroPage")
  local obj = self:LoadPreferb_ByFullPath(viewPath, self.container, true)
  obj.name = "ProfessionNewHeroPage"
  self.gameObject = obj
end

function ProfessionNewHeroPage:Init()
  self:LoadView()
  self:FindObjs()
  self:AddEvts()
  self:AddMapEvts()
  self:SwitchToTab(1)
end

function ProfessionNewHeroPage:FindObjs()
  local anchorRight = self:FindGO("Anchor_Right")
  self.inoutTween = anchorRight:GetComponent(TweenAlpha)
  EventDelegate.Set(self.inoutTween.onFinished, function()
    self:OnInoutAnimFinished()
  end)
  local anchorBottom = self:FindGO("Anchor_Bottom")
  self.inoutTweenBottom = anchorBottom:GetComponent(TweenAlpha)
  self.heroIntroGO = self:FindGO("HeroIntro", anchorBottom)
  self.heroIntroCell = ProfessionNewHeroIntroCell.new(self.heroIntroGO)
  self.helpBtnGO = self:FindGO("HelpBtn")
  self:TryOpenHelpViewById(PanelConfig.ProfessionNewHeroPage.id, nil, self.helpBtnGO)
  self.tabs = {
    {
      go = self:FindGO("TaskTab")
    }
  }
  for i, tab in ipairs(self.tabs) do
    tab.selectedGO = self:FindGO("Selected", tab.go)
    self:AddClickEvent(tab.go, function()
      self:SwitchToTab(i)
    end)
    tab.widget = tab.go:GetComponent(UIWidget)
  end
  local tabPanelGO = self:FindGO("TabPanels")
  self.taskPanel = self:FindGO("TaskPanel", tabPanelGO)
  self.storyPanel = self:FindGO("StoryPanel", tabPanelGO)
  self.tabPanels = {
    self.taskPanel
  }
  local taskTable = self:FindComponent("Container", UITable, self.taskPanel)
  self.taskListCtrl = ListCtrl.new(taskTable, ProfessionNewHeroTaskCell, "Profession/ProfessionNewHeroTaskCell")
  local storyScrollGO = self:FindGO("StoryScroll", self.storyPanel)
  local storyTable = self:FindComponent("Container", UITable, storyScrollGO)
  self.storyListCtrl = ListCtrl.new(storyTable, ProfessionNewHeroStoryCell, "Profession/ProfessionNewHeroStoryCell")
  self.listCtrls = {
    self.taskListCtrl
  }
  self.tabPanelUpdateFuncs = {
    self.UpdateTaskPanel
  }
  self.extraStoryQuestGO = self:FindGO("ExtraStoryReward")
  self:AddClickEvent(self.extraStoryQuestGO, function()
    self:OnExtraStoryQuestClicked()
  end)
  local longPress = self.extraStoryQuestGO:GetComponent(UILongPress)
  
  function longPress.pressEvent()
    self:OnExtraStoryQuestLongPressed()
  end
  
  self.extraStoryQuestEffectGO = self:FindGO("Effect", self.extraStoryQuestGO)
  self.extraStoryQuestProgress = self:FindComponent("Progress", UILabel, self.extraStoryQuestGO)
  self.extraStoryQuestRewardIcon = self:FindComponent("ItemIcon", UISprite, self.extraStoryQuestGO)
  self.extraStoryQuestRewardNum = self:FindComponent("ItemNum", UILabel, self.extraStoryQuestGO)
  self.extraStoryQuestTakenGO = self:FindGO("Taken", self.extraStoryQuestGO)
end

function ProfessionNewHeroPage:AddEvts()
end

function ProfessionNewHeroPage:AddMapEvts()
  self:AddListenEvt(ServiceEvent.SceneUser3HeroGrowthQuestInfo, self.UpdateView)
  self:AddListenEvt(ServiceEvent.SceneUser3HeroStoryQusetInfo, self.UpdateView)
  self:AddListenEvt(ServiceEvent.SceneUser3HeroStoryQuestAccept, self.UpdateView)
  self:AddListenEvt(ServiceEvent.SceneUser3HeroQuestReward, self.UpdateView)
end

function ProfessionNewHeroPage:UpdateView()
  local lastSelectedTab = self.selectedTabIndex or 1
  self.selectedTabIndex = nil
  self:SwitchToTab(lastSelectedTab)
  self.heroIntroCell:SetData(HeroProfessionProxy.Instance:GetHeroIntro(self.selectedProfession))
end

function ProfessionNewHeroPage:SeenRedTip(tabIndex)
  local redtipProxy = RedTipProxy.Instance
  if tabIndex == 1 and redtipProxy:IsNew(SceneTip_pb.EREDSYS_HERO_GROWTH_QUEST, self.selectedProfession) then
    redtipProxy:SeenNew(SceneTip_pb.EREDSYS_HERO_GROWTH_QUEST, self.selectedProfession)
  end
end

function ProfessionNewHeroPage:SetProfession(newProfession)
  local typeBranch = ProfessionProxy.GetTypeBranchFromProf(newProfession)
  local isBranchValid = HeroProfessionProxy.Instance:isCommonBranchTaskValid(typeBranch)
  xdlog("SetProfession", newProfession, typeBranch, isBranchValid)
  if not ProfessionProxy.IsHero(newProfession) and not isBranchValid then
    redlog("职业不合法")
    return
  end
  newProfession = isBranchValid and typeBranch or newProfession
  if self.selectedProfession == newProfession then
    return
  end
  self.selectedProfession = newProfession
  self.selectedTabIndex = nil
  self:SwitchToTab(1)
  HeroProfessionProxy.Instance:QueryHeroQuests(newProfession)
end

function ProfessionNewHeroPage:SwitchToTab(tabIndex)
  if self.selectedTabIndex == tabIndex then
    return
  end
  if self.selectedTabIndex ~= nil then
    self:StopInoutAnim(true)
  end
  self.selectedTabIndex = tabIndex
  for i, panel in ipairs(self.tabPanels) do
    panel:SetActive(i == tabIndex)
  end
  for i, func in ipairs(self.tabPanelUpdateFuncs) do
    if i == self.selectedTabIndex then
      func(self)
    end
  end
end

function ProfessionNewHeroPage:UpdateTaskPanel()
  local questDatas = HeroProfessionProxy.Instance:GetHeroQuestsByProfession(self.selectedProfession)
  self.taskListCtrl:ResetDatas(questDatas)
  local cells = self.taskListCtrl:GetCells()
  for i, cell in ipairs(cells) do
    cell:SetInoutAnimDelay((i - 1) * inoutAnimDelay)
  end
  self.extraStoryQuestGO:SetActive(true)
  self:UpdateExtraStoryQuest()
end

function ProfessionNewHeroPage:UpdateStoryPanel()
  local storyDatas = HeroProfessionProxy.Instance:GetHeroStories(self.selectedProfession)
  self.storyListCtrl:ResetDatas(storyDatas)
  local cells = self.storyListCtrl:GetCells()
  for i, cell in ipairs(cells) do
    cell:SetInoutAnimDelay((i - 1) * inoutAnimDelay)
  end
  self.extraStoryQuestGO:SetActive(true)
  self:UpdateExtraStoryQuest()
end

function ProfessionNewHeroPage:OnInoutAnimFinished()
  if self.inoutFinishCallback then
    self.inoutFinishCallback()
  end
end

function ProfessionNewHeroPage:StartInoutAnim(inOrOut, callback)
  local forward = inOrOut == 2 and true or false
  if not forward then
    self:UpdateView()
    self:SeenRedTip(self.selectedTabIndex or 1)
  end
  self.inoutFinishCallback = callback
  local ctl = self.listCtrls[self.selectedTabIndex]
  if ctl then
    local cells = ctl:GetCells()
    self.inoutAnimCount = #cells
    if self.inoutAnimCount == 0 then
      self:OnInoutAnimFinished()
    else
      for i, cell in ipairs(cells) do
        cell:PlayInoutAnim(inOrOut)
      end
      self.inoutTween:Play(forward)
      self.inoutTweenBottom:Play(forward)
    end
  end
end

function ProfessionNewHeroPage:StopInoutAnim(jumpToFinish)
  local ctl = self.listCtrls[self.selectedTabIndex]
  if ctl then
    local cells = ctl:GetCells()
    for i, cell in ipairs(cells) do
      cell:StopInoutAnim(jumpToFinish)
    end
  end
  if jumpToFinish then
    if self.inoutTween.enabled then
      self.inoutTween:Toggle()
      self.inoutTween:ResetToBeginning()
    end
    if self.inoutTweenBottom.enabled then
      self.inoutTweenBottom:Toggle()
      self.inoutTweenBottom:ResetToBeginning()
    end
  end
  self.inoutTween.enabled = false
  self.inoutTweenBottom.enabled = false
  self.inoutAnimCount = nil
  self.inoutFinishCallback = nil
end

function ProfessionNewHeroPage:UpdateExtraStoryQuest()
  local questData = HeroProfessionProxy.Instance:GetHeroExtraTask(self.selectedProfession)
  if questData then
    if questData:IsRewarded() then
      self.extraStoryQuestEffectGO:SetActive(false)
      self.extraStoryQuestTakenGO:SetActive(true)
      self.extraStoryQuestRewardIcon.alpha = 0.5
      self.extraStoryQuestProgress.text = ZhString.HeroProfessionExtraRewarded
      self.extraStoryQuestProgress.color = completeProgressColor
    else
      self.extraStoryQuestTakenGO:SetActive(false)
      if questData:IsCompleted() then
        self.extraStoryQuestEffectGO:SetActive(true)
      else
        self.extraStoryQuestEffectGO:SetActive(false)
      end
      self.extraStoryQuestRewardIcon.alpha = 1
      self.extraStoryQuestProgress.text = string.format(ZhString.HeroProfessionExtraProgress, questData:GetProgressStr())
      self.extraStoryQuestProgress.color = normalProgressColor
    end
    local rewardIcon = questData:GetRewardItemIcon()
    if rewardIcon then
      IconManager:SetItemIcon(rewardIcon, self.extraStoryQuestRewardIcon)
    end
    local rewardNum = questData:GetRewardItemNum()
    if rewardNum and 1 < rewardNum then
      self.extraStoryQuestRewardNum.text = rewardNum
    else
      self.extraStoryQuestRewardNum.text = ""
    end
  end
end

function ProfessionNewHeroPage:OnExtraStoryQuestClicked()
  local questData = HeroProfessionProxy.Instance:GetHeroExtraTask(self.selectedProfession)
  if questData:IsCompleted() and not questData:IsRewarded() then
    HeroProfessionProxy.Instance:TakeHeroQuestReward(nil, self.selectedProfession, questData.completeNum, SceneUser3_pb.HEROQUESTREWARDTYPE_GROWTH_EXTRA)
  else
    local rewardItemId = questData:GetRewardItemId()
    if rewardItemId then
      self:ShowRewardItemTip(rewardItemId, self.extraStoryQuestRewardIcon)
    end
  end
end

function ProfessionNewHeroPage:OnExtraStoryQuestLongPressed()
  local questData = HeroProfessionProxy.Instance:GetHeroExtraStoryQuest(self.selectedProfession)
  if questData then
    local rewardItemId = questData:GetRewardItemId()
    if rewardItemId then
      self:ShowRewardItemTip(rewardItemId, self.extraStoryQuestRewardIcon)
    end
  end
end

local tipOffset = {280, -228}

function ProfessionNewHeroPage:ShowRewardItemTip(itemId, stick)
  if itemId then
    if self.tipItemData then
      self.tipItemData:ResetData(nil, itemId)
    else
      self.tipItemData = ItemData.new(nil, itemId)
    end
    local tab = ReusableTable.CreateTable()
    tab.itemdata = self.tipItemData
    self:ShowItemTip(tab, stick, NGUIUtil.AnchorSide.TopLeft, tipOffset)
    ReusableTable.DestroyAndClearTable(tab)
  end
end
