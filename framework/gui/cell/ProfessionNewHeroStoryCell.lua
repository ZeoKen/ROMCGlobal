autoImport("UIAutoScrollCtrl")
local BaseCell = autoImport("BaseCell")
ProfessionNewHeroStoryCell = class("ProfessionNewHeroStoryCell", BaseCell)
local bgHeightDelta = 40
local storyMinLineCount = 3
local lockAlpha = 0.5
local normalColor = Color(0.12156862745098039, 0.4549019607843137, 0.7490196078431373, 1)
local completeColor = Color(0.3686274509803922, 0.7176470588235294, 0.1450980392156863, 1)

function ProfessionNewHeroStoryCell:ctor(obj)
  ProfessionNewHeroStoryCell.super.ctor(self, obj)
  self:FindObjs()
  self:AddGameObjectComp()
end

function ProfessionNewHeroStoryCell:OnDestroy()
  ProfessionNewHeroStoryCell.super.OnDestroy(self)
  if self.autoTitleScrollCtrl then
    self.autoTitleScrollCtrl:Destroy()
  end
end

function ProfessionNewHeroStoryCell:OnDisable()
  ProfessionNewHeroStoryCell.super.OnDisable(self)
  if self.autoTitleScrollCtrl then
    self.autoTitleScrollCtrl:Stop(true)
  end
end

function ProfessionNewHeroStoryCell:FindObjs()
  self.expandTween = self.gameObject:GetComponent(UIPlayTween)
  EventDelegate.Set(self.expandTween.onFinished, function()
    self:OnExpandFinished()
  end)
  local container = self:FindGO("Container")
  self.inoutTween = container:GetComponent(TweenPosition)
  local headerGO = self:FindGO("Header")
  self.arrowGO = self:FindGO("Arrow", headerGO)
  self:AddClickEvent(self.arrowGO, function()
    self:OnArrowClicked()
  end)
  self.initArrowLocalRotation = self.arrowGO.transform.localRotation
  self.titleScroll = self:FindComponent("TitlePanel", UIScrollView, headerGO)
  self:SetPanelDepthByParent(self.titleScroll.gameObject, 1)
  self.titleDecoGO = self:FindGO("DecoContainer", self.titleScroll.gameObject)
  self.titleTable = self:FindComponent("Table", UITable, self.titleScroll.gameObject)
  self.titlePrefixLab = self:FindComponent("TitlePrefix", UILabel, self.titleScroll.gameObject)
  self.titleLab = self:FindComponent("Title", UILabel, self.titleScroll.gameObject)
  self.autoTitleScrollCtrl = UIAutoScrollCtrl.new(self.titleScroll, self.titleLab, 3, 10)
  self.lockedGO = self:FindGO("Locked")
  self.lockedWidget = self.lockedGO:GetComponent(UIWidget)
  self.unlockBtnGO = self:FindGO("UnlockBtn", self.lockedGO)
  self:AddClickEvent(self.unlockBtnGO, function()
    self:OnUnlockClicked()
  end)
  self.unlockDesc = self:FindComponent("UnlockDesc", UIRichLabel, self.lockedGO)
  self.unlockSpriteDesc = SpriteLabel.new(self.unlockDesc, nil, 20, 20)
  self.completeBgGO = self:FindGO("CompleteBg", self.lockedGO)
  self.unlockedGO = self:FindGO("Unlocked")
  self.unlockedWidget = self.unlockedGO:GetComponent(UIWidget)
  self.goBtnGO = self:FindGO("GoBtn", self.unlockedGO)
  self:AddClickEvent(self.goBtnGO, function()
    self:OnGotoClicked()
  end)
  self.storyBG = self:FindComponent("BG", UISprite, self.unlockedGO)
  self.minStoryBGHeight = self.storyBG.height
  self.storyBGTween = self.storyBG:GetComponent(TweenHeight)
  self.storyBGTween.from = self.minStoryBGHeight
  self.storyDesc = self:FindComponent("StoryDesc", UIRichLabel, self.unlockedGO)
  self.storySpriteDesc = SpriteLabel.new(self.storyDesc, nil, 20, 20)
  self.taskDesc = self:FindComponent("TaskDesc", UIRichLabel, self.unlockedGO)
  self.taskSpriteDesc = SpriteLabel.new(self.taskDesc, nil, 20, 20)
  self.rewardBtnGO = self:FindGO("RewardBtn", self.unlockedGO)
  self:AddClickEvent(self.rewardBtnGO, function()
    self:OnRewardClicked()
  end)
  self.itemGO = self:FindGO("Item", container)
  self:AddClickEvent(self.itemGO, function()
    self:OnItemClicked()
  end)
  self.item = self.itemGO:GetComponent(UIWidget)
  self.itemCount = self:FindComponent("ItemCount", UILabel, self.itemGO)
  self.itemIcon = self:FindComponent("ItemIcon", UISprite, self.itemGO)
  self.selectedGO = self:FindGO("Selected", self.itemGO)
  self.selectedGO:SetActive(false)
end

function ProfessionNewHeroStoryCell:SetData(data)
  self.data = data
  local bgHeight = self.minStoryBGHeight
  self.titleLab.text = data:GetTitle()
  self.titlePrefixLab.text = data:GetTitlePrefix()
  self.titleTable:Reposition()
  self.expandTween.enabled = false
  local exUseLua = SpriteLabel.useLuaVersion
  SpriteLabel.useLuaVersion = true
  if data:IsRewarded() then
    self.itemGO:SetActive(false)
    self.rewardBtnGO:SetActive(false)
    self.goBtnGO:SetActive(false)
    local storyDesc = data:GetDesc()
    if storyDesc and storyDesc ~= "" then
      self.arrowGO:SetActive(true)
      self.lockedGO:SetActive(false)
      self.unlockedGO:SetActive(true)
      self.taskDesc.gameObject:SetActive(false)
      self.storyDesc.gameObject:SetActive(true)
      self.storySpriteDesc:SetText(storyDesc)
      self.storyDesc.maxLineCount = 0
      self.storyDesc:ProcessText()
      bgHeight = math.max(self.storyDesc.height + bgHeightDelta, bgHeight)
      self.storyDesc.maxLineCount = storyMinLineCount
    else
      self.arrowGO:SetActive(false)
      self.storyDesc.gameObject:SetActive(false)
      self.lockedGO:SetActive(true)
      self.completeBgGO:SetActive(true)
      self.unlockedGO:SetActive(false)
      self.unlockBtnGO:SetActive(false)
      self.unlockSpriteDesc:SetText(string.format("[b]%s[/b]", ZhString.HeroProfessionQuestCompleted))
    end
  else
    self.arrowGO:SetActive(false)
    self.storyDesc.gameObject:SetActive(false)
    self.taskDesc.gameObject:SetActive(true)
    self.completeBgGO:SetActive(false)
    self.itemGO:SetActive(true)
    local iconName = data:GetRewardItemIcon()
    if iconName then
      IconManager:SetItemIcon(iconName, self.itemIcon)
    end
    local itemCount = data:GetRewardItemNum()
    self.itemCount.text = itemCount or ""
    self.itemCount.gameObject:SetActive(itemCount and 1 < itemCount or false)
    if data:IsCompleted() then
      self.unlockedGO:SetActive(true)
      self.lockedGO:SetActive(false)
      self.rewardBtnGO:SetActive(true)
      self.goBtnGO:SetActive(false)
      self.taskSpriteDesc:SetText(ZhString.HeroProfessionQuestCompleted)
      self.taskDesc.color = completeColor
      self.item.alpha = 1
    elseif data:IsInProgress() then
      self.unlockedGO:SetActive(true)
      self.lockedGO:SetActive(false)
      self.rewardBtnGO:SetActive(false)
      self.goBtnGO:SetActive(true)
      self.taskSpriteDesc:SetText(data:GetTaskDesc())
      self.taskDesc.color = normalColor
      self.item.alpha = 1
    elseif data:IsWaitUnlock() then
      self.unlockedGO:SetActive(false)
      self.lockedGO:SetActive(true)
      self.unlockBtnGO:SetActive(true)
      self.unlockSpriteDesc:SetText(data:GetUnlockDesc())
      self.item.alpha = lockAlpha
    else
      self.unlockedGO:SetActive(false)
      self.lockedGO:SetActive(true)
      self.unlockBtnGO:SetActive(false)
      self.unlockSpriteDesc:SetText(data:GetUnlockDesc())
      self.item.alpha = lockAlpha
    end
  end
  if self.autoTitleScrollCtrl then
    self.autoTitleScrollCtrl:Start(true)
  end
  self.storyBGTween.to = bgHeight
  self.isExpanded = nil
  self.storyBG.height = self.minStoryBGHeight
  self.arrowGO.transform.localRotation = self.initArrowLocalRotation
  SpriteLabel.useLuaVersion = exUseLua
end

function ProfessionNewHeroStoryCell:Expand(b)
  if self.isExpanded == b then
    return
  end
  self.isExpanded = b
  self.expandTween:Play(self.isExpanded)
  if not b then
    self.storyDesc.maxLineCount = storyMinLineCount
  end
end

function ProfessionNewHeroStoryCell:OnExpandFinished()
  if self.isExpanded then
    self.storyDesc.maxLineCount = 0
  end
end

function ProfessionNewHeroStoryCell:OnArrowClicked()
  self:Expand(not self.isExpanded)
end

function ProfessionNewHeroStoryCell:OnUnlockClicked()
  if self.data and self.data:IsWaitUnlock() then
    HeroProfessionProxy.Instance:UnlockStory(self.data.id)
  end
end

function ProfessionNewHeroStoryCell:OnGotoClicked()
  local questData = self.data:GetQuestData()
  if questData then
    GameFacade.Instance:sendNotification(UIEvent.CloseUI, MultiProfessionNewView.ViewType)
    FunctionQuest.Me():executeManualQuest(questData)
  end
end

local tipOffset = {-220, -188}

function ProfessionNewHeroStoryCell:OnItemClicked()
  local itemId = self.data and self.data:GetRewardItemId()
  if itemId then
    local itemData = ItemData.new(nil, itemId)
    local tab = ReusableTable.CreateTable()
    tab.itemdata = itemData
    self:ShowItemTip(tab, self.item, NGUIUtil.AnchorSide.TopLeft, tipOffset)
    ReusableTable.DestroyAndClearTable(tab)
  end
end

function ProfessionNewHeroStoryCell:OnRewardClicked()
  if self.data and self.data:IsCompleted() then
    HeroProfessionProxy.Instance:TakeHeroQuestReward(self.data.id, nil, nil, SceneUser3_pb.HEROQUESTREWARDTYPE_STORY)
  end
end

function ProfessionNewHeroStoryCell:PlayInoutAnim(inOrOut)
  ProfessionNewHeroStoryCell.super.PlayInoutAnim(self, inOrOut)
  if self.autoTitleScrollCtrl then
    self.autoTitleScrollCtrl:Stop(true)
  end
end

function ProfessionNewHeroStoryCell:OnInoutFinished()
  ProfessionNewHeroStoryCell.super.OnInoutFinished(self)
  if self.autoTitleScrollCtrl and self.inOrOut == 1 then
    self.autoTitleScrollCtrl:InvalidateClipping()
    self.autoTitleScrollCtrl:Start(true)
  end
end

function ProfessionNewHeroStoryCell:StopInoutAnim(jumpToFinish)
  ProfessionNewHeroStoryCell.super.StopInoutAnim(self, jumpToFinish)
  if self.autoTitleScrollCtrl and self.inOrOut == 1 then
    self.autoTitleScrollCtrl:InvalidateClipping()
    self.autoTitleScrollCtrl:Start(true)
  end
end
