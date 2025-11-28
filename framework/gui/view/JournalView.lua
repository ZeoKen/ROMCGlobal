JournalView = class("JournalView", ContainerView)
JournalView.ViewType = UIViewType.NormalLayer
local selectTabSpriteName = "Handaccount_bth_activation"
local normalTabSpriteName = "Handaccount_btn_normal"
local lockedTabSpriteName = "Handaccount_btn_lock"
local selectTabLabelCol = ColorUtil.NGUIWhite
local normalTabLabelCol = Color(0.8549019607843137, 0.7764705882352941, 0.6549019607843137, 1)
local rewardBg1 = "activity_bg"
local rewardBg2 = "calendar_Advanced-version_bg"
local lockIconBg = "Handaccount_bg_lock"
local pageContentPicName = "calendar_bg1_picture2"
local progressAnimatorState = "state2001"
local completeAnimatorState = "state3001"

function JournalView:Init()
  if not Table_ActivityJournal then
    redlog("Table_ActivityJournal not exist!!!")
    self:CloseSelf()
    return
  end
  self:AddEventListener()
  self:InitData()
  self:InitView()
  if self.journalId then
    ServiceNoviceNotebookProxy.Instance:CallNoviceNotebookCmd(self.journalId)
  end
end

function JournalView:InitView()
  self.panel = self.gameObject:GetComponent(UIPanel)
  self.journalPanel = self:FindGO("journal")
  self.lockedNode = self:FindGO("locked")
  self.unlockedNode = self:FindGO("unlocked")
  self.bookmarkLockPivot = self:FindGO("bookmark_lock_pivot")
  self.bookmarkUnlockPivot = self:FindGO("bookmark_unlock_pivot")
  local leftNode = self:FindGO("left", self.unlockedNode)
  local rightNode = self:FindGO("right", self.unlockedNode)
  self.titleLabel = self:FindGO("title", leftNode)
  self.picNode = self:FindGO("bg_pic", leftNode)
  self.endTextLabel = self:FindGO("endText", leftNode)
  self.pageTitleLabel = self:FindGO("page_title", self.picNode)
  self.pageIdLabel = self:FindGO("pageId", self.pageTitleLabel)
  self.pageTexture = self:FindGO("pic", self.picNode):GetComponent(UITexture)
  self.pageLockedNode = self:FindGO("locked", self.picNode)
  self.pageContentNode = self:FindGO("content", rightNode)
  self.pageContainer = self:FindGO("Container", self.pageContentNode):GetComponent(UIWidget)
  self.pageContentLabel = self:FindGO("text", self.pageContentNode):GetComponent(UILabel)
  self.pageContentPic = self:FindGO("bg_pic", self.pageContentNode):GetComponent(UITexture)
  self.pageProgress = self:FindGO("progress", self.pageContentNode)
  self.pageTargetLabel = self:FindGO("questLabel", self.pageProgress):GetComponent(UILabel)
  self.pageProgressNum = self:FindGO("pageProgressNum", self.pageProgress):GetComponent(UILabel)
  self.autoUnlock = self:FindGO("autoUnlock", self.pageContentNode)
  self.autoUnlockLabel = self:FindGO("Label", self.autoUnlock):GetComponent(UILabel)
  self.rewardNode = self:FindGO("reward", rightNode)
  self.rewardIcon = self:FindGO("icon", self.rewardNode):GetComponent(UISprite)
  self.rewardCheck = self:FindGO("check", self.rewardIcon.gameObject):GetComponent(UISprite)
  self.rewardNumLabel = self:FindGO("num", self.rewardIcon.gameObject):GetComponent(UILabel)
  self.rewardBgTexture1 = self:FindGO("bg1", self.rewardNode):GetComponent(UITexture)
  self.rewardBgTexture2 = self:FindGO("bg2", self.rewardNode):GetComponent(UITexture)
  self.rewardBtn = self:FindGO("button_enable", self.rewardNode)
  self.rewardBtnReceived = self:FindGO("button_received", self.rewardNode)
  self.rewardBtnGray = self:FindGO("button_disable", self.rewardNode)
  self.newIcon = self:FindGO("new_icon", self.pageContentNode)
  self.leftArrow = self:FindGO("left_arrow", leftNode)
  self.rightArrow = self:FindGO("right_arrow", rightNode)
  self.chaptermark = self:FindGO("chaptermark", self.unlockedNode)
  self.unlockTipNode = self:FindGO("unlock_tip", self.lockedNode)
  self.unlockTipLabel = self:FindGO("tip", self.unlockTipNode):GetComponent(UILabel)
  self.progressTipLabel = self:FindGO("goal", self.lockedNode)
  self.lockedIconNode = self:FindGO("lockIcon", self.lockedNode)
  self.lockedIconTex = self.lockedIconNode:GetComponent(UITexture)
  self.loveWidget = self:FindGO("love3", self.lockedIconNode):GetComponent(UIWidget)
  self.progressLabel = self:FindGO("progress", self.lockedIconNode):GetComponent(UILabel)
  self.effectContainer = self:FindGO("effectContainer", self.lockedNode)
  self.helpBtn = self:FindGO("helpBtn", self.lockedNode)
  local gotoBtn = self:FindGO("gotoBtn", self.unlockTipNode)
  self:AddClickEvent(gotoBtn, function()
    self:OnGotoBtnClick()
  end)
  self:AddButtonEvent("closeButton", function()
    self:CloseSelf()
  end)
  self:AddClickEvent(self.leftArrow, function()
    self:OnLeftArrowClick()
  end)
  self:AddClickEvent(self.rightArrow, function()
    self:OnRightArrowClick()
  end)
  self:AddClickEvent(self.rewardBtn, function()
    self:OnRewardBtnClick()
  end)
  local helpid = GameConfig.Journal and self.journalId and GameConfig.Journal[self.journalId] and GameConfig.Journal[self.journalId].help_id or nil
  self:RegistShowGeneralHelpByHelpID(helpid, self.helpBtn)
  local tipData = {}
  local rewardId
  if GameConfig.Journal then
    local journal = GameConfig.Journal[self.journalId]
    if journal then
      rewardId = journal.reward_item_id
    end
  end
  tipData.itemdata = ItemData.new(nil, rewardId)
  local tipOffset = {200, 0}
  self:AddClickEvent(self.rewardIcon.gameObject, function()
    TipManager.Instance:ShowItemFloatTip(tipData, self.rewardIcon, NGUIUtil.AnchorSide.Right, tipOffset)
  end)
  for i = 1, self.chaptermark.transform.childCount do
    local child = self.chaptermark.transform:GetChild(i - 1)
    self:AddClickEvent(child.gameObject, function()
      self:OnChapterTabClick(i)
    end)
  end
  self.journalPanel:SetActive(false)
end

function JournalView:InitData()
  if self.viewdata then
    self.journalId = self.viewdata.viewdata and self.viewdata.viewdata.journalId
  end
  if not self.journalId then
    self.journalId = JournalProxy.Instance.currentJournalId
  end
  self.lastReadPageIndexes = {
    1,
    1,
    1,
    1
  }
end

function JournalView:AddEventListener()
  self:AddListenEvt(ServiceEvent.NoviceNotebookNoviceNotebookCmd, self.ShowPanel)
  self:AddListenEvt(ServiceEvent.NoviceNotebookNoviceNotebookReceiveAwardCmd, self.RefreshRewardPage)
  self:AddListenEvt(ServiceEvent.NoviceNotebookNoviceNotebookCoverOpenCmd, self.ShowPanel)
end

function JournalView:OnEnter()
end

function JournalView:OnExit()
  if self.lastTexture then
    PictureManager.Instance:UnloadJournalTexture(self.lastTexture, self.pageTexture)
  end
  PictureManager.Instance:UnloadJournalTexture(lockIconBg, self.lockedIconTex)
  PictureManager.Instance:UnloadActivityTexture(rewardBg1, self.rewardBgTexture1)
  PictureManager.Instance:UnloadPetTexture(rewardBg2, self.rewardBgTexture2)
  PictureManager.Instance:UnLoadUI(pageContentPicName, self.pageContentPic)
  ServiceNoviceNotebookProxy.Instance:CallNoviceNotebookLastPosCmd(self.journalId, {
    chapter_id = self.currentChapterIndex,
    page_id = self.currentPageIndex
  })
end

function JournalView:ShowPanel()
  self.journalPanel:SetActive(true)
  if not JournalProxy.Instance:IsJournalUnlock(self.journalId) then
    self.lockedNode:SetActive(true)
    self.unlockedNode:SetActive(false)
    self:ShowBookmarkEffect(self.bookmarkLockPivot)
    self:ShowLockedView()
  else
    self.currentChapterIndex, self.currentPageIndex = JournalProxy.Instance:GetDefaultChapterAndPageId(self.journalId)
    self.lockedNode:SetActive(false)
    self.unlockedNode:SetActive(true)
    self:ShowBookmarkEffect(self.bookmarkUnlockPivot)
    self:RefreshChapter()
  end
end

function JournalView:ShowLockedView()
  PictureManager.Instance:SetJournalTexture(lockIconBg, self.lockedIconTex)
  if GameConfig.Journal then
    local journal = GameConfig.Journal[self.journalId]
    if journal then
      self.unlockTipLabel.text = journal.unlock_tip
      self.progressTipLabel:GetComponent(UILabel).text = journal.progress_tip
      local itemNum = BagProxy.Instance:GetItemNumByStaticID(journal.item_id, BagProxy.BagType.Wallet)
      self.unlockTipNode:SetActive(itemNum == 0)
      self.helpBtn:SetActive(0 < itemNum)
      local activityData = FunctionActivity.Me():GetActivityData(journal.activity_id)
      local isProgressing = false
      if 0 < itemNum then
        if activityData then
          local unlockProgress = activityData:GetProgress()
          isProgressing = unlockProgress < 1
          if isProgressing then
            self.progressLabel.text = unlockProgress * 100 .. "%"
            self:ShowProgressingEffect(unlockProgress, progressAnimatorState)
          else
            self:ReadyToUnlock()
          end
        else
          self:ReadyToUnlock()
        end
      end
      self.progressTipLabel:SetActive(isProgressing)
    end
  end
end

function JournalView:ReadyToUnlock()
  self:AddClickEvent(self.lockedIconNode, function()
    self:OnUnlockBtnClick()
  end)
  self:ShowUnlockGuideEffect()
end

function JournalView:ShowProgressingEffect(progress, state)
  if self.progressEffect then
    self.progressEffect:SetActive(true)
  else
    self:PlayUIEffect(EffectMap.UI.Eff_Journal_ProgressFilling, self.effectContainer, false, function(obj, args, assetEffect)
      self.progressEffect = assetEffect
      self.progressEffect:ResetAction(state, 0)
      local panel = obj.transform:GetComponentInChildren(UIPanel)
      panel.depth = self.panel.depth + 1
      local heartFilling = obj.transform:Find("lovemask/HeartFillingUp")
      if heartFilling then
        local y = 158 * progress
        heartFilling.localPosition = LuaGeometry.GetTempVector3(heartFilling.localPosition.x, y, heartFilling.localPosition.z)
      end
    end)
  end
end

function JournalView:ShowUnlockGuideEffect()
  self:ShowProgressingEffect(1, completeAnimatorState)
end

function JournalView:ShowBookmarkEffect(pivot)
  if not self.bookmark then
    self:PlayUIEffect(EffectMap.UI.Eff_Journal_bookmark, pivot, false, function(obj, args, assetEffect)
      self.bookmark = assetEffect
    end)
  else
    self.bookmark:ResetParent(pivot.transform)
  end
end

function JournalView:RefreshChapter()
  self:RefreshChapterTab()
  self:RefreshPage()
end

function JournalView:RefreshChapterTab()
  local childCount = self.chaptermark.transform.childCount
  local chapterCount = JournalProxy.Instance:GetChapterCount(self.journalId)
  for i = childCount, 1, -1 do
    local child = self.chaptermark.transform:GetChild(i - 1)
    if i > chapterCount then
      child.gameObject:SetActive(false)
    else
      local state = JournalProxy.Instance:GetChapterState(self.journalId, i)
      local spriteName = normalTabSpriteName
      local spriteColor = normalTabLabelCol
      local sprite = child:GetComponent(UISprite)
      local numSprite = child:Find("num"):GetComponent(UISprite)
      local lockSprite = child:Find("lock"):GetComponent(UISprite)
      local tag = child:Find("tag")
      tag.gameObject:SetActive(state == NoviceNotebook_pb.NOVICE_NOTEBOOK_CHAPTER_TAG_STATE_OPEN)
      numSprite.enabled = state ~= NoviceNotebook_pb.NOVICE_NOTEBOOK_CHAPTER_TAG_STATE_DISABLE
      lockSprite.enabled = state == NoviceNotebook_pb.NOVICE_NOTEBOOK_CHAPTER_TAG_STATE_DISABLE
      child:GetComponent(BoxCollider).enabled = state ~= NoviceNotebook_pb.NOVICE_NOTEBOOK_CHAPTER_TAG_STATE_DISABLE
      if state == NoviceNotebook_pb.NOVICE_NOTEBOOK_CHAPTER_TAG_STATE_DISABLE then
        spriteName = lockedTabSpriteName
      else
        if i == self.currentChapterIndex then
          spriteName = selectTabSpriteName
          spriteColor = selectTabLabelCol
        end
        if state == NoviceNotebook_pb.NOVICE_NOTEBOOK_CHAPTER_TAG_STATE_OPEN then
          local startTimeStr, endTimeStr = JournalProxy.Instance:GetChapterTimeStr(self.journalId, i)
          local tagLabel = tag:Find("time"):GetComponent(UILabel)
          tagLabel.text = startTimeStr .. "~" .. endTimeStr
        end
      end
      sprite.spriteName = spriteName
      numSprite.color = spriteColor
      self:RefreshChapterTabRedTip(i, JournalProxy.Instance:GetFirstNewPageByChapterId(self.journalId, i) ~= nil)
    end
  end
end

function JournalView:RefreshChapterTabRedTip(chapterIndex, enabled)
  local tab = self.chaptermark.transform:GetChild(chapterIndex - 1)
  local redTip = tab:Find("redTip"):GetComponent(UISprite)
  redTip.enabled = enabled
end

function JournalView:RefreshPage()
  local page = JournalProxy.Instance:GetPageByChapterIdAndPageId(self.journalId, self.currentChapterIndex, self.currentPageIndex)
  local chapterState = JournalProxy.Instance:GetChapterState(self.journalId, self.currentChapterIndex)
  if page then
    self.picNode:SetActive(not page.isLastPage)
    self.endTextLabel:SetActive(page.isLastPage)
    self.pageContentNode:SetActive(not page.isLastPage)
    self.rewardNode:SetActive(page.isLastPage)
    local data = Table_ActivityJournal[page.index]
    if data then
      self.titleLabel:GetComponent(UILabel).text = data.ChapterName
      if page.isLastPage then
        PictureManager.Instance:SetActivityTexture(rewardBg1, self.rewardBgTexture1)
        PictureManager.Instance:SetPetRenderTexture(rewardBg2, self.rewardBgTexture2)
        PictureManager.Instance:UnLoadUI(pageContentPicName, self.pageContentPic)
        self.isPageContentPicLoaded = false
        self.endTextLabel:GetComponent(UILabel).text = data.PageText
        if GameConfig.Journal then
          local journal = GameConfig.Journal[self.journalId]
          if journal then
            local rewardId = journal.reward_item_id
            local rewardNum = journal.reward_item_num
            local item = Table_Item[rewardId]
            if item then
              IconManager:SetItemIcon(item.Icon, self.rewardIcon)
            end
            self.rewardNumLabel.text = 1 < rewardNum and rewardNum or ""
          end
        end
        self:RefreshRewardPage()
      else
        PictureManager.Instance:UnloadActivityTexture(rewardBg1, self.rewardBgTexture1)
        PictureManager.Instance:UnloadPetTexture(rewardBg2, self.rewardBgTexture2)
        if not self.isPageContentPicLoaded then
          PictureManager.Instance:SetUI(pageContentPicName, self.pageContentPic)
          self.isPageContentPicLoaded = true
        end
        self.pageIdLabel:GetComponent(UILabel).text = self.currentChapterIndex .. "-" .. self.currentPageIndex
        self.pageLockedNode:SetActive(not page.isComplete)
        self.pageTexture.gameObject:SetActive(page.isComplete)
        self.newIcon:GetComponent(UISprite).enabled = page.isComplete and page.isNew
        self.pageProgress:SetActive(not page.isComplete)
        if not page.isComplete and chapterState == NoviceNotebook_pb.NOVICE_NOTEBOOK_CHAPTER_TAG_STATE_CLOSE then
          self.pageContainer.alpha = 0.5
          self.autoUnlock:SetActive(true)
          self.autoUnlockLabel.text = JournalProxy.Instance:GetAutoUnlockTimeStr(self.journalId, self.currentChapterIndex)
        else
          self.pageContainer.alpha = 1
          self.autoUnlock:SetActive(false)
        end
        local pageTitle = page.isComplete and data.PageName or "??????"
        local pageContent = page.isComplete and data.PageText or data.PagePreviewText
        self.pageTitleLabel:GetComponent(UILabel).text = pageTitle
        self.pageContentLabel.text = pageContent
        self.pageTargetLabel.text = data.PageTarget
        self.pageProgressNum.text = page.progress .. "/" .. data.UnlockTime
        if data.PageTexture ~= self.lastTexture then
          if self.lastTexture then
            PictureManager.Instance:UnloadJournalTexture(self.lastTexture, self.pageTexture)
          end
          PictureManager.Instance:SetJournalTexture(data.PageTexture, self.pageTexture)
          self.lastTexture = data.PageTexture
        end
        if page.isNew then
          ServiceNoviceNotebookProxy.Instance:CallNoviceNotebookReadPageCmd(self.journalId, self.currentChapterIndex, self.currentPageIndex)
          page.isNew = false
          if not JournalProxy.Instance:GetFirstNewPageByChapterId(self.journalId, self.currentChapterIndex) then
            self:RefreshChapterTabRedTip(self.currentChapterIndex, false)
          end
        end
      end
    end
  end
  self:RefreshArrow()
end

function JournalView:RefreshRewardPage()
  local rewardState = JournalProxy.Instance:GetJournalRewardState(self.journalId)
  self.rewardCheck.enabled = rewardState == NoviceNotebook_pb.NOVICE_NOTEBOOK_CHAPTER_REWARD_STATE_RECEIVED
  self.rewardBtn:SetActive(rewardState == NoviceNotebook_pb.NOVICE_NOTEBOOK_CHAPTER_REWARD_STATE_AVAILABLE)
  self.rewardBtnReceived:SetActive(rewardState == NoviceNotebook_pb.NOVICE_NOTEBOOK_CHAPTER_REWARD_STATE_RECEIVED)
  self.rewardBtnGray:SetActive(rewardState == NoviceNotebook_pb.NOVICE_NOTEBOOK_CHAPTER_REWARD_STATE_NOT_AVAILABLE)
end

function JournalView:RefreshArrow()
  local pageCount = JournalProxy.Instance:GetPageCountByChapterId(self.journalId, self.currentChapterIndex)
  self.leftArrow:SetActive(self.currentPageIndex > 1)
  self.rightArrow:SetActive(pageCount > self.currentPageIndex)
end

function JournalView:OnChapterTabClick(index)
  self.lastReadPageIndexes[self.currentChapterIndex] = self.currentPageIndex
  self.currentChapterIndex = index
  local newPageIndex = JournalProxy.Instance:GetFirstNewPageByChapterId(self.journalId, index)
  self.currentPageIndex = newPageIndex or self.lastReadPageIndexes[index]
  self:RefreshChapter()
end

function JournalView:OnLeftArrowClick()
  self.currentPageIndex = self.currentPageIndex - 1
  self:RefreshPage()
end

function JournalView:OnRightArrowClick()
  self.currentPageIndex = self.currentPageIndex + 1
  self:RefreshPage()
end

function JournalView:OnRewardBtnClick()
  ServiceNoviceNotebookProxy.Instance:CallNoviceNotebookReceiveAwardCmd(self.journalId)
end

function JournalView:OnGotoBtnClick()
  if GameConfig.Journal then
    local journal = GameConfig.Journal[self.journalId]
    FuncShortCutFunc.Me():CallByID(journal.shortcut_id)
    self:CloseSelf()
  end
end

function JournalView:OnUnlockBtnClick()
  ServiceNoviceNotebookProxy.Instance:CallNoviceNotebookCoverOpenCmd(self.journalId)
end
