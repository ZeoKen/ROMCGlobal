autoImport("QuestTraceBaseTogCell")
HeroQuestTraceCell = class("HeroQuestTraceCell", QuestTraceBaseTogCell)

function HeroQuestTraceCell:Init()
  self:FindObjs()
end

function HeroQuestTraceCell:FindObjs()
  HeroQuestTraceCell.super.FindObjs(self)
  self.questRoot = self:FindGO("Root")
  self.buyRoot = self:FindGO("BuyRoot")
  self.lv = self:FindGO("Lv"):GetComponent(UILabel)
  self.lockSymbol = self:FindGO("LockSymbol")
  self.finishSymbol = self:FindGO("FinishSymbol")
  self.funcBtn = self:FindGO("FuncBtn")
  self.funcBtn_Label = self:FindGO("Label", self.funcBtn):GetComponent(UILabel)
  self.funcBtn_Label.text = ZhString.FunctionNpcFunc_Unlock
  self:AddClickEvent(self.funcBtn, function()
    xdlog("申请解锁", self.id)
    local maxCount = GameConfig.HeroStory and GameConfig.HeroStory.DailyKeyNum or 5
    local keyUsed = MyselfProxy.Instance:GetAccVarValueByType(Var_pb.EACCVARTYPE_HERO_STORY_KEY_USED) or 0
    if 0 < maxCount - keyUsed then
      HeroProfessionProxy.Instance:UnlockStory(self.id)
    else
      redlog("MSG:没钥匙了")
    end
  end)
  self.unlockTip = self:FindGO("UnlockTip", self.buyRoot):GetComponent(UILabel)
  self.buyBtn = self:FindGO("BuyBtn", self.buyRoot)
  self.giftTip = self:FindGO("GiftTip"):GetComponent(UISprite)
  self.waitUnlockSymbol = self:FindGO("WaitUnlockSymbol")
  self:AddClickEvent(self.questRoot, function()
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
  self:AddClickEvent(self.buyRoot, function()
    xdlog("尝试购买", self.cellData.profId)
    FunctionNewRecharge.Instance():OpenUI(PanelConfig.NewRecharge_THero, nil, {
      profId = self.cellData.profId
    })
  end)
  self:AddClickEvent(self.toggleGO, function()
    local limit = QuestProxy.Instance:CheckTraceLimit(self.toggle.value)
    if limit then
      MsgManager.ShowMsgByID(298)
      self.toggle.value = false
      return
    end
    self:PassEvent(QuestEvent.QuestTraceChange, self)
  end)
  self:AddClickEvent(self.giftTip.gameObject, function()
    if self.rewardid then
      local tipData = {}
      tipData.itemdata = ItemData.new("Reward", self.rewardid)
      tipData.itemdata:SetItemNum(self.rewardNum)
      self:ShowItemTip(tipData, self.giftTip, NGUIUtil.AnchorSide.Right, {280, 0})
    end
  end)
end

function HeroQuestTraceCell:SetData(data)
  self.cellData = data
  if data.shopIndex then
    self.questRoot:SetActive(false)
    self.buyRoot:SetActive(true)
    local profId = data.profId
    local classConfig = Table_Class[profId]
    local className = classConfig and classConfig.NameZh or "???"
    self.unlockTip.text = string.format(ZhString.HeroStory_UnlockHero, className)
    return
  end
  self.toggleGO:SetActive(false)
  self.lockSymbol:SetActive(false)
  self.finishSymbol:SetActive(false)
  self.funcBtn:SetActive(false)
  self.waitUnlockSymbol:SetActive(false)
  self.id = data.id
  local config = Table_HeroStoryQuest[self.id]
  if not config then
    redlog("故事ID不存在")
    return
  end
  self.state = data.state
  self.title.text = config.StoryName
  local width = self.title.printedSize.x
  self.giftTip.gameObject.transform.localPosition = LuaGeometry.GetTempVector3(width + 33, 2, 0)
  local targetID = config.FirstQuestID
  local questData = targetID and QuestProxy.Instance:GetValidQuestBySameQuestID(targetID)
  if questData then
    self.data = questData
  end
  local status = self.data and QuestProxy.Instance:CheckQuestIsTrace(self.data.id) or 0
  local isTrace = status == 1 and true or false
  self.toggle.value = isTrace
  self.lv.text = ""
  local heroStoryData = HeroProfessionProxy.Instance:GetHeroStoryByProfessionAndID(config.Class, self.id)
  if not heroStoryData then
  elseif heroStoryData:IsRewarded() then
    self.finishSymbol:SetActive(true)
  elseif heroStoryData:IsCompleted() then
    self.finishSymbol:SetActive(true)
    self:SetLockedStatus(false)
  elseif heroStoryData:IsInProgress() then
    self.toggleGO:SetActive(true)
    self:SetLockedStatus(false)
  elseif heroStoryData:IsWaitUnlock() then
    self.lockSymbol:SetActive(true)
    self:SetLockedStatus(false)
    self.waitUnlockSymbol:SetActive(true)
  else
    self.lockSymbol:SetActive(true)
    self:SetLockedStatus(true)
  end
  if self.data then
    self:SetQuestIcon()
  end
  self:SetChooseStatus(false)
  local extraReward = config.ExtraReward
  if extraReward and 0 < #extraReward then
    self.rewardid = extraReward[1].Reward[1][1]
    self.rewardNum = extraReward[1].Reward[1][2]
    self.giftTip.gameObject:SetActive(true)
    local extraData = HeroProfessionProxy.Instance:GetHeroExtraStoryQuest(config.Class)
    self.giftTip.spriteName = extraData:IsRewarded() and "growup2" or "growup1"
  else
    self.giftTip.gameObject:SetActive(false)
  end
  TimeTickManager.Me():ClearTick(self, 1)
  self.tweenPos:ResetToBeginning()
  self.tweenPos.enabled = false
  self.tweenAlpha:ResetToBeginning()
  self.tweenAlpha.enabled = false
end

function HeroQuestTraceCell:ResetData()
  if not self.cellData then
    return
  end
  self:SetData(self.cellData)
end

function HeroQuestTraceCell:SetLockedStatus(bool)
  if bool then
    self.title.color = LuaGeometry.GetTempVector4(0.49411764705882355, 0.49411764705882355, 0.49411764705882355, 1)
    self.titleIcon.alpha = 0.7
  else
    self.title.color = LuaColor.Black()
    self.titleIcon.alpha = 1
  end
end

function HeroQuestTraceCell:HandleClickSelf()
  self:PassEvent(MouseEvent.MouseClick, self)
end

function HeroQuestTraceCell:SetNewSymbol(bool)
  self.newSymbol:SetActive(bool)
end

function HeroQuestTraceCell:SetChooseStatus(bool)
  if self.chooseSymbol then
    self.chooseSymbol:SetActive(bool)
  else
    redlog("no chooseSymbol")
  end
end

function HeroQuestTraceCell:PlayTween()
  if self.indexInList > 6 then
    self.tweenPos.enabled = false
    self.tweenAlpha.enabled = false
    self.tweenPos:PlayForward()
    self.tweenAlpha:PlayForward()
    return
  end
  self.tweenPos.delay = 0.1 * self.indexInList
  self.tweenPos.enabled = false
  self.tweenPos:ResetToBeginning()
  self.tweenPos:PlayForward()
  self.tweenAlpha.delay = 0.1 * self.indexInList
  self.tweenAlpha.enabled = false
  self.tweenAlpha:ResetToBeginning()
  self.tweenAlpha:PlayForward()
end

function HeroQuestTraceCell:PlayReverse()
  self.tweenPos:ResetToBeginning()
  self.tweenAlpha:ResetToBeginning()
end

function HeroQuestTraceCell:OnCellDestroy()
  HeroQuestTraceCell.super.OnCellDestroy(self)
  TimeTickManager.Me():ClearTick(self)
end
