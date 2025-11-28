local baseCell = autoImport("BaseCell")
AnnounceQuestPanelCell = class("AnnounceQuestPanelCell", baseCell)
autoImport("AnnounceQuestPanelTeamMemberPortrail")
local tempVector3 = LuaVector3.Zero()
AnnounceQuestPanelCellLabelColor = {
  [1] = LuaColor.New(0.6274509803921569, 0.38823529411764707, 0.13725490196078433, 1),
  [2] = LuaColor.New(0.45098039215686275, 0.09019607843137255, 0.058823529411764705, 1),
  [3] = LuaColor.New(0.5137254901960784, 0.027450980392156862, 0.047058823529411764, 1)
}
AnnounceQuestPanelCell.PassEvent_FastCompleteBtn = "AnnounceQuestPanelCell_PassEvent_FastCompleteBtn"

function AnnounceQuestPanelCell:Init()
  self:initView()
  self:addViewEventListener()
end

function AnnounceQuestPanelCell:initView()
  self.questPublisherHead = self:FindGO("questPublisherHead")
  self.publishName = self:FindGO("publishName"):GetComponent(UILabel)
  self.questName = self:FindGO("questName"):GetComponent(UILabel)
  self.questDetailLabel = self:FindGO("questDetailLabel"):GetComponent(UILabel)
  self.questTarget = self:FindGO("questTarget"):GetComponent(UILabel)
  self.questTargetCt = self:FindGO("questTargetCt")
  self.questReward = self:FindGO("questReward")
  self.publishNameCt = self:FindGO("publishNameCt")
  self.simpleIcon = self:FindComponent("simpleIcon", UISprite)
  self.acceptActionBtn = self:FindGO("acceptActionBtn")
  self.abandonActionBtn = self:FindGO("abandonActionBtn")
  self.cannotActionBtn = self:FindGO("cannotActionBtn")
  self.commitActionBtn = self:FindGO("commitActionBtn")
  self.leaderAceeptBtn = self:FindGO("leaderAceeptBtn")
  local leaderAceeptBtnText = self:FindComponent("actionBtnLabel1", UILabel, self.leaderAceeptBtn)
  leaderAceeptBtnText.text = ZhString.AnnounceQuestPanel_LeaderAceeptBtn
  self.actionBtn = self:FindComponent("actionBtn", UISprite)
  self.actionBtnLabel = self:FindComponent("actionBtnLabel1", UILabel)
  self.actionBtnCollider = self:FindComponent("actionBtn", BoxCollider)
  self.questState = self:FindGO("questState")
  IconManager:SetArtFontIcon("Rewardtask_txt_1", self.questState:GetComponent(UISprite))
  self.questStateScale = self.questState:GetComponent(UIPlayTween)
  self.completeHolder = self:FindGO("completeHolder")
  self.questBaseReward = self:FindGO("questBaseReward")
  self.baseExp = self:FindGO("baseExp"):GetComponent(UILabel)
  self.jobExp = self:FindGO("jobExp"):GetComponent(UILabel)
  self.robCount = self:FindGO("robCount"):GetComponent(UILabel)
  local coinIcon = self:FindGO("coinCt"):GetComponent(UISprite)
  IconManager:SetItemIcon(Table_Item[100].Icon, coinIcon)
  self.itemCount = self:FindGO("itemCount"):GetComponent(UILabel)
  self.itemIcon = self:FindGO("itemCt"):GetComponent(UISprite)
  self.item2Count = self:FindGO("item2Count"):GetComponent(UILabel)
  self.item2Icon = self:FindGO("item2Ct"):GetComponent(UISprite)
  self.item3Count = self:FindGO("item3Count"):GetComponent(UILabel)
  self.item3Icon = self:FindGO("item3Ct"):GetComponent(UISprite)
  self.fastAcceptBtn = self:FindGO("fastAcceptBtn")
  self.fastAcceptBtnSprite = self.fastAcceptBtn:GetComponent(UISprite)
  self.fastAcceptBtnLabel = self:FindComponent("actionBtnLabel1", UILabel, self.fastAcceptBtn)
  self.fastAcceptBtnCollider = self.fastAcceptBtn:GetComponent(BoxCollider)
  self.teamQuestPortrait = self:FindGO("teamQuestPortrait")
  self.teamQuestPortraitGrid = self:FindComponent("portraitList", UIGrid)
  self.teamQuestPortraitGrid = UIGridListCtrl.new(self.teamQuestPortraitGrid, AnnounceQuestPanelTeamMemberPortrail, "AnnounceQuestPanelTeamMemberPortrail")
  self.teamQuestHelpReward = self:FindGO("teamQuestHelpReward")
  self.teamQuestHelpRewardLabel = self:FindGO("teamQuestHelpRewardLabel")
  self.teamQuestHelpRewardLabel = SpriteLabel.new(self.teamQuestHelpRewardLabel, nil, 40, 40, true)
  self.helpQuestIcon = self:FindGO("helpQuestIcon")
  self.radioCt = self:FindGO("ratioCt")
  self.activityRelCt = self:FindGO("activityRelCt")
  self.acBgCt = self:FindGO("acBgCt")
  self.act_bg = self:FindGO("act_bg")
  local ratioTip = self:FindComponent("ratioTip", UILabel)
  if BranchMgr.IsSEA() or BranchMgr.IsNA() or BranchMgr.IsEU() then
    if AppBundleConfig.GetSDKLang() ~= "cn" then
      ratioTip.text = ZhString.OverSea_Reward
    else
      ratioTip.text = ZhString.Cn_Reward
    end
  else
    ratioTip.text = ZhString.Cn_Reward
  end
  self.ratioLabel = self:FindComponent("ratioLabel", UILabel)
  local teamOngingLabel = self:FindComponent("teamOngingLabel", UILabel)
  teamOngingLabel.text = ZhString.AnnounceQuestPanel_TeamOngingLabel
  self.extraRewardWidget = self:FindGO("extraReward"):GetComponent(UIWidget)
  self.extraRewardGrid = self:FindGO("extraGrid"):GetComponent(UIGrid)
  self.extraRewardCtrl = UIGridListCtrl.new(self.extraRewardGrid, BagItemCell, "BagItemCell")
  self.extraRewardCtrl:AddEventListener(MouseEvent.MouseClick, self.handleClickExtraReward, self)
  self.extraRewardGain = self:FindGO("extraRewardGain")
  self:Hide(self.extraRewardWidget.gameObject)
  self:Hide(self.extraRewardGain)
  self:Hide(teamOngingLabel.gameObject)
  self:Hide(self.activityRelCt)
  self:Hide(self.acBgCt)
  self:Hide(self.act_bg)
  local upPanel = Game.GameObjectUtil:FindCompInParents(self.gameObject, UIPanel)
  local panels = self:FindComponents(UIPanel)
  for i = 1, #panels do
    panels[i].depth = upPanel.depth + panels[i].depth
  end
end

function AnnounceQuestPanelCell:initHelpTeamReward()
  local itemId = 147
  local itemData = Table_Item[itemId]
  if itemData then
    local text = string.format(ZhString.AnnounceQuestPanel_HelpTeammemberReward, itemId, itemData.NameZh)
    self.teamQuestHelpRewardLabel:SetText(text)
    return
  end
end

function AnnounceQuestPanelCell:addViewEventListener()
  self:AddButtonEvent("actionBtn", function(obj)
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
  self:AddClickEvent(self.leaderAceeptBtn, function(obj)
    self:checkWantedTick(self.data)
  end)
  self:AddClickEvent(self.fastAcceptBtn, function(obj)
    self:PassEvent(AnnounceQuestPanelCell.PassEvent_FastCompleteBtn, self)
  end)
end

function AnnounceQuestPanelCell:checkWantedTick(data)
  if not (data and data.wantedData) or data.wantedData.IsActivity == 1 then
    return
  end
  local itemId = 5503
  local itemData = BagProxy.Instance:GetItemByStaticID(itemId, 17)
  local own = BagProxy.Instance:GetItemNumByStaticID(itemId, GameConfig.PackageMaterialCheck.default)
  local cost = 5
  if own < cost then
    MsgManager.ShowMsgByID(38199)
    return
  end
  if not itemData then
    ServiceQuestProxy.Instance:CallInviteHelpAcceptQuestCmd(nil, self.data.id)
    return
  end
  local dont = LocalSaveProxy.Instance:GetDontShowAgain(55)
  if dont == nil then
    MsgManager.DontAgainConfirmMsgByID(55, function()
      if BranchMgr.IsJapan() then
        AudioUtil.Play2DRandomSound(AudioMap.Maps.AnnounceQuestPanel_Accept)
      end
      ServiceQuestProxy.Instance:CallQuestAction(SceneQuest_pb.EQUESTACTION_QUICK_SUBMIT_BOARD_TEAM, self.data.id)
    end, function()
      if BranchMgr.IsJapan() then
        AudioUtil.Play2DRandomSound(AudioMap.Maps.AnnounceQuestPanel_Accept)
      end
      ServiceQuestProxy.Instance:CallInviteHelpAcceptQuestCmd(nil, self.data.id)
    end, nil, itemData:GetName(true, true))
  else
    if BranchMgr.IsJapan() then
      AudioUtil.Play2DRandomSound(AudioMap.Maps.AnnounceQuestPanel_Accept)
    end
    ServiceQuestProxy.Instance:CallQuestAction(SceneQuest_pb.EQUESTACTION_QUICK_SUBMIT_BOARD_TEAM, self.data.id)
  end
end

function AnnounceQuestPanelCell:checkLevelCross(qMinLv, qMaxLv, rMinLv, rMaxLv)
  if rMinLv <= qMaxLv and qMinLv <= rMaxLv then
    return true
  end
end

function AnnounceQuestPanelCell:setIsSelected(isSelect)
  if self.isSelect ~= isSelect then
    self.isSelect = isSelect
    if self.isSelect then
      self:Show(self.selector.gameObject)
    else
      self:Hide(self.selector.gameObject)
    end
  end
end

function AnnounceQuestPanelCell:OnRemove()
  TimeTickManager.Me():ClearTick(self)
end

function AnnounceQuestPanelCell:SetDisableAccept()
  self.actionBtn.color = Color(0.00392156862745098, 0.00784313725490196, 0.011764705882352941, 1)
  self.actionBtnCollider.enabled = false
  self.actionBtnLabel.effectStyle = UILabel.Effect.None
  self.fastAcceptBtnSprite.color = Color(0.00392156862745098, 0.00784313725490196, 0.011764705882352941, 1)
  self.fastAcceptBtnCollider.enabled = false
  self.fastAcceptBtnLabel.effectStyle = UILabel.Effect.None
end

function AnnounceQuestPanelCell:playAnim()
  self:PlayUIEffect(EffectMap.UI.stamp, self.completeHolder, true, AnnounceQuestPanelCell.AnimEffectHandle, self)
end

function AnnounceQuestPanelCell.AnimEffectHandle(effectHandle, owner, assetEffect)
end

function AnnounceQuestPanelCell:checkQuest()
  local charIds = ShareAnnounceQuestProxy.Instance:getOnGoTeamMembersByQuestIdAndAction(self.data.id)
  if TeamProxy.Instance:IHaveTeam() then
    local questData = QuestProxy.Instance:getWantedQuestDataByIdAndType(self.data.id, SceneQuest_pb.EQUESTLIST_ACCEPT)
    questData = questData and QuestData or QuestProxy.Instance:getWantedQuestDataByIdAndType(self.data.id, SceneQuest_pb.EQUESTLIST_COMPLETE)
    if questData then
      table.insert(charIds, Game.Myself.data.id)
    end
  end
  if charIds and 0 < #charIds then
    local teamMembersData = {}
    if not TeamProxy.Instance:IHaveTeam() then
      return
    end
    local myTeam = TeamProxy.Instance.myTeam
    for i = 1, #charIds do
      local single = charIds[i]
      local memberData = myTeam:GetMemberByGuid(single)
      if memberData then
        table.insert(teamMembersData, memberData)
      end
    end
    if 0 < #teamMembersData then
      self:Show(self.teamQuestPortrait)
      self:setTeamMembers(teamMembersData)
      self:Hide(self.extraRewardWidget.gameObject)
      self:Hide(self.extraRewardGain)
    else
      self:Hide(self.teamQuestPortrait)
    end
  else
    self:Hide(self.teamQuestPortrait)
  end
end

function AnnounceQuestPanelCell:setTeamMembers(teamMembersData)
  self.teamQuestPortraitGrid:ResetDatas(teamMembersData)
end

function AnnounceQuestPanelCell:adjustButtonSt(data)
  self.actionBtn.color = Color(1, 1, 1, 1)
  self.actionBtnCollider.enabled = true
  self.actionBtnLabel.effectStyle = UILabel.Effect.Outline
  self.fastAcceptBtnSprite.color = Color(1, 1, 1, 1)
  self.fastAcceptBtnCollider.enabled = true
  self.fastAcceptBtnLabel.effectStyle = UILabel.Effect.Outline
  self:Show(self.actionBtn.gameObject)
  if data:getQuestListType() == SceneQuest_pb.EQUESTLIST_ACCEPT then
    if data.staticData and data.staticData.Params and data.staticData.Params.ifAccessFc then
      helplog("Visit类型特殊处理")
      self:Hide(self.questState)
      self:checkQuest()
      self.actionBtn.spriteName = "com_btn_2"
      self.actionBtnLabel.text = ZhString.AnnounceQuestPanel_CommitQuest
      self.actionBtnLabel.effectColor = AnnounceQuestPanelCellLabelColor[1]
      self:changeToNormalView(data:getQuestListType())
    else
      self:Hide(self.questState)
      self:checkQuest()
      self.actionBtn.spriteName = "com_btn_0"
      self.actionBtnLabel.text = ZhString.AnnounceQuestPanel_AbadonQuest
      self:changeToNormalView(data:getQuestListType())
      self.actionBtnLabel.effectColor = AnnounceQuestPanelCellLabelColor[2]
    end
  elseif data:getQuestListType() == SceneQuest_pb.EQUESTLIST_COMPLETE then
    self:Hide(self.questState)
    self:checkQuest()
    self.actionBtn.spriteName = "com_btn_2"
    self.actionBtnLabel.text = ZhString.AnnounceQuestPanel_CommitQuest
    self.actionBtnLabel.effectColor = AnnounceQuestPanelCellLabelColor[1]
    self:changeToNormalView(data:getQuestListType())
  elseif data:getQuestListType() == SceneQuest_pb.EQUESTLIST_SUBMIT then
    self:Show(self.questState)
    self:Hide(self.actionBtn.gameObject)
    self:Hide(self.teamQuestPortrait)
    self:changeToNormalView(data:getQuestListType())
  elseif data:getQuestListType() == SceneQuest_pb.EQUESTLIST_CANACCEPT then
    self:Hide(self.questState)
    self:checkQuest()
    self.actionBtn.spriteName = "com_btn_2"
    self.actionBtnLabel.text = ZhString.AnnounceQuestPanel_AcceptQuest
    self.actionBtnLabel.effectColor = AnnounceQuestPanelCellLabelColor[1]
    local condition = TeamProxy.Instance:IHaveTeam() and TeamProxy.Instance:CheckIHaveLeaderAuthority() or false
    condition = condition and not QuestProxy.Instance:hasGoingWantedQuest() or false
    condition = condition and SkillProxy.Instance:HasLearnedSkill(AnnounceQuestPanel.skillid)
    if condition and data.wantedData.IsActivity ~= 1 then
      self:changeToTeamLeaderView(data:getQuestListType())
    else
      self:changeToNormalView(data:getQuestListType())
    end
  end
end

function AnnounceQuestPanelCell:changeToTeamLeaderView(questListType)
  self:Show(self.leaderAceeptBtn)
  self:Show(self.fastAcceptBtn)
  self:Hide(self.actionBtn.gameObject)
end

function AnnounceQuestPanelCell:changeToNormalView(questListType)
  self:Hide(self.leaderAceeptBtn)
  if questListType == SceneQuest_pb.EQUESTLIST_SUBMIT then
    self:Hide(self.fastAcceptBtn)
    return
  end
  self:Show(self.actionBtn.gameObject)
  if questListType == SceneQuest_pb.EQUESTLIST_CANACCEPT then
    self:Show(self.fastAcceptBtn)
    tempVector3[1] = 88
    self.actionBtn.transform.localPosition = tempVector3
    self.actionBtn.width = 161
  else
    self:Hide(self.fastAcceptBtn)
    tempVector3[1] = 0
    self.actionBtn.transform.localPosition = tempVector3
    self.actionBtn.width = 226
  end
end

function AnnounceQuestPanelCell:SetData(data)
  self.data = data
  if self.data then
    self:Show()
  else
    if not self:ObjIsNil(self.gameObject) then
      self:Hide()
    end
    return
  end
  local wantedData = data.wantedData
  if wantedData then
    local targetText = ""
    if data.notMine or data:getQuestListType() == SceneQuest_pb.EQUESTLIST_CANACCEPT then
      targetText = QuestDataUtil.parseWantedQuestTranceInfo(data, wantedData)
    else
      targetText = data:parseTranceInfo()
    end
    if targetText ~= "" then
      self:Show(self.questTargetCt)
      self.questTarget.text = targetText
    else
      self:Hide(self.questTargetCt)
    end
    self.questDetailLabel.text = wantedData.Describe
    self.questName.text = wantedData.Name
    local ret
    if wantedData.Type == 2 and wantedData.Icon ~= "" then
      ret = self:SetSimpleIcon(wantedData.Icon)
    end
    if not ret then
      self:SetNpcData(wantedData.NpcId)
    end
    self:adjustButtonSt(data)
    if data.notMine then
      self:Show(self.teamQuestHelpReward)
      self:Hide(self.questBaseReward)
      self:Show(self.helpQuestIcon)
    else
      self:Hide(self.helpQuestIcon)
      self:Show(self.questBaseReward)
      self:Hide(self.teamQuestHelpReward)
      self:setQuestRewardData()
    end
    self:initHelpTeamReward()
  end
end

function AnnounceQuestPanelCell:setQuestRewardData()
  local data = self.data
  local wantedData = self.data.wantedData
  local BaseLv = data.acceptlv
  local expData = Table_ExpPool[BaseLv]
  if expData then
    self.baseExp.text = math.floor(expData.WantedBaseExp)
    self.jobExp.text = math.floor(expData.WantedJobExp)
  end
  if data.wantedData.Rob then
    self.robCount.text = math.floor(data.wantedData.Rob)
  else
    self.robCount.text = "0"
  end
  self.itemIcon.gameObject:SetActive(false)
  self.item2Icon.gameObject:SetActive(false)
  self.item3Icon.gameObject:SetActive(false)
  if data.rewards then
    if data.rewards[1] then
      self.itemIcon.gameObject:SetActive(true)
      local rewarData = data.rewards[1]
      local itemData = Table_Item[rewarData.id]
      if itemData then
        self.itemCount.text = rewarData.count
        IconManager:SetItemIcon(itemData.Icon, self.itemIcon)
      end
    end
    if data.rewards[2] then
      self.item2Icon.gameObject:SetActive(true)
      local rewarData = data.rewards[2]
      local itemData = Table_Item[rewarData.id]
      if itemData then
        self.item2Count.text = rewarData.count
        IconManager:SetItemIcon(itemData.Icon, self.item2Icon)
      end
    end
    if data.rewards[3] then
      self.item3Icon.gameObject:SetActive(true)
      local rewarData = data.rewards[3]
      local itemData = Table_Item[rewarData.id]
      if itemData then
        self.item3Count.text = rewarData.count
        IconManager:SetItemIcon(itemData.Icon, self.item3Icon)
      end
    end
  end
  local showCt = false
  local actData = ActivityEventProxy.Instance:GetRewardByType(AERewardType.WantedQuest)
  local multiply = actData and actData.multiple or 0
  if actData and actData:IsInActivity() and 1 < multiply and wantedData.IsActivity ~= 1 then
    self:Show(self.activityRelCt)
    self:Show(self.radioCt)
    self.ratioLabel.text = "x" .. multiply
    showCt = true
  else
    self:Hide(self.radioCt)
  end
  local extraRewards = actData and actData:GetExtraRewards()
  if extraRewards and 0 < #extraRewards then
    self.extraRewardWidget.gameObject:SetActive(true)
    local extraRewardItems = {}
    for i = 1, #extraRewards do
      local single = extraRewards[i]
      local itemData = ItemData.new("Reward", single.id)
      itemData:SetItemNum(single.count)
      table.insert(extraRewardItems, itemData)
    end
    self.extraRewardCtrl:ResetDatas(extraRewardItems)
    local extraRewardValid = actData and actData:CheckExtraRewardValid()
    if self.data:getQuestListType() == SceneQuest_pb.EQUESTLIST_SUBMIT then
      self.extraRewardGain:SetActive(false)
      self.extraRewardWidget.alpha = 0.3
    else
      self.extraRewardGain:SetActive(not extraRewardValid)
      self.extraRewardWidget.alpha = extraRewardValid and 1 or 0.3
    end
  else
    self.extraRewardGain:SetActive(false)
    self.extraRewardWidget.gameObject:SetActive(false)
  end
  if not showCt then
    self:Hide(self.activityRelCt)
  else
    self:Show(self.activityRelCt)
  end
  if wantedData.IsActivity ~= 1 then
    self:Hide(self.acBgCt)
    self:Hide(self.act_bg)
  else
    self:Show(self.acBgCt)
    self:Show(self.act_bg)
  end
end

function AnnounceQuestPanelCell:playRatioUpAnm()
  if not self.data then
    return
  end
  if self.data:getQuestListType() == SceneQuest_pb.EQUESTLIST_ACCEPT or self.data:getQuestListType() == SceneQuest_pb.EQUESTLIST_CANACCEPT then
    self:Hide(self.baseExp.gameObject)
    self:Hide(self.robCount.gameObject)
    self:Hide(self.jobExp.gameObject)
    local holder = self:FindGO("EffectContainer", self.baseExp.transform.parent.gameObject)
    self:PlayUIEffect(EffectMap.UI.Refresh, holder, true)
    holder = self:FindGO("EffectContainer", self.jobExp.transform.parent.gameObject)
    self:PlayUIEffect(EffectMap.UI.Refresh, holder, true)
    holder = self:FindGO("EffectContainer", self.robCount.transform.parent.gameObject)
    self:PlayUIEffect(EffectMap.UI.Refresh, holder, true)
    self:showReward()
  end
end

function AnnounceQuestPanelCell:showReward()
  TimeTickManager.Me():CreateOnceDelayTick(500, function(owner, deltaTime)
    self:Show(self.baseExp.gameObject)
    self:Show(self.robCount.gameObject)
    self:Show(self.jobExp.gameObject)
  end, self)
end

function AnnounceQuestPanelCell.effectLoaded(effectObj)
end

function AnnounceQuestPanelCell:initBg()
end

function AnnounceQuestPanelCell:SetSimpleIcon(Icon)
  local ret = IconManager:SetUIIcon(Icon, simpleIcon)
  if ret then
    self:Show(self.simpleIcon.gameObject)
    self:Hide(self.publishNameCt)
  end
  return ret
end

function AnnounceQuestPanelCell:SetNpcData(npcId)
  local npcdata = Table_Npc[npcId]
  self:Hide(self.simpleIcon.gameObject)
  self:Show(self.publishNameCt)
  if npcdata then
    if not self.targetCell then
      self.targetCell = HeadIconCell.new()
      self.targetCell:CreateSelf(self.questPublisherHead)
      self.targetCell:SetScale(1)
      self.targetCell:SetMinDepth(3)
    end
    self.publishName.text = npcdata.NameZh
    local data = ReusableTable.CreateTable()
    local hasSimpleIcon = npcdata.Icon and npcdata.Icon ~= ""
    local showDetailedIcon = npcdata.Body and npcdata.Hair and npcdata.HeadDefaultColor and npcdata.Gender and npcdata.Eye and npcdata.Head
    if showDetailedIcon or not hasSimpleIcon then
      data.bodyID = npcdata.Body or 0
      data.hairID = npcdata.Hair or 0
      data.haircolor = npcdata.HeadDefaultColor or 0
      data.gender = npcdata.Gender or -1
      data.eyeID = npcdata.Eye or 0
      data.headID = npcdata.Head or 0
      self.targetCell:SetData(data)
    else
      self.targetCell:SetSimpleIcon(npcdata.Icon)
    end
    ReusableTable.DestroyTable(data)
  end
end

function AnnounceQuestPanelCell:handleClickExtraReward(cell)
  local d = cell.data
  if not d then
    self:ShowItemTip()
  else
    local sdata = {
      itemdata = d,
      ignoreBounds = {
        cell.gameObject
      }
    }
    self:ShowItemTip(sdata, cell:GetBgSprite(), NGUIUtil.AnchorSide.Left, {-280, 0})
  end
end

function AnnounceQuestPanelCell:OnExit()
  self.super.OnExit(self)
  TimeTickManager.Me():ClearTick(self)
end
