local baseCell = autoImport("BaseCell")
AnnounceClassmateShowCell = class("AnnounceClassmateShowCell", baseCell)
autoImport("AnnounceQuestPanelTeamMemberPortrail")
local tempVector3 = LuaVector3.Zero()

function AnnounceClassmateShowCell:Init()
  self:initView()
  self:addViewEventListener()
end

function AnnounceClassmateShowCell:initView()
  self.questPublisherHead = self:FindGO("questPublisherHead")
  self.simpleIcon = self:FindComponent("simpleIcon", UISprite)
  self.questName = self:FindGO("questName"):GetComponent(UILabel)
  self.questTargetCt = self:FindGO("questTargetCt")
  self.questTarget = self:FindGO("questTarget"):GetComponent(UILabel)
  self.publishNameCt = self:FindGO("publishNameCt")
  self.teamQuestPortrait = self:FindGO("teamQuestPortrait")
  self.teamQuestPortraitGrid = self:FindComponent("portraitListClass", UIGrid)
  self.teamQuestPortraitGrid = UIGridListCtrl.new(self.teamQuestPortraitGrid, AnnounceQuestPanelTeamMemberPortrail, "AnnounceQuestPanelTeamMemberPortrail")
  self.actionBtn = self:FindComponent("leaderAceeptBtn", UISprite)
  self.actionBtnLabel = self:FindGO("leaderAceeptBtn"):GetComponent(UILabel)
  self.actionBtnCollider = self:FindComponent("leaderAceeptBtn", BoxCollider)
  self.teamQuestHelpReward = self:FindGO("teamQuestHelpReward")
  self.teamQuestHelpRewardLabel = self:FindGO("teamQuestHelpRewardLabel")
  self.teamQuestHelpRewardLabel = SpriteLabel.new(self.teamQuestHelpRewardLabel, nil, 40, 40, true)
  local upPanel = Game.GameObjectUtil:FindCompInParents(self.gameObject, UIPanel)
  local panels = self:FindComponents(UIPanel)
  for i = 1, #panels do
    panels[i].depth = upPanel.depth + panels[i].depth
  end
end

function AnnounceClassmateShowCell:addViewEventListener()
  self:AddButtonEvent("leaderAceeptBtn", function(obj)
    if self.data.notMine then
      self.actionBtn.color = Color(0.00392156862745098, 0.00784313725490196, 0.011764705882352941, 1)
      self.actionBtnCollider.enabled = false
      if self.DisenableAnnounceQuestTwId then
        self.DisenableAnnounceQuestTwId:Destroy()
        self.DisenableAnnounceQuestTwId = nil
      end
      self.DisenableAnnounceQuestTwId = TimeTickManager.Me():CreateOnceDelayTick(5000, function(owner, deltaTime)
        self.DisenableAnnounceQuestTwId = nil
        self.actionBtn.color = Color(1, 1, 1, 1)
        self.actionBtnCollider.enabled = true
      end, self)
    end
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
end

function AnnounceClassmateShowCell:SetData(data)
  self.data = data
  if self.data.notMine then
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
      if self.questTarget then
        self.questTarget.text = targetText
      else
        helplog("self.questTarget  == nil!!!")
        return
      end
    else
      self:Hide(self.questTargetCt)
    end
    self.questName.text = wantedData.Name
    local ret
    if wantedData.Type == 2 and wantedData.Icon ~= "" then
      ret = self:SetSimpleIcon(wantedData.Icon)
    end
    if not ret then
      self:SetNpcData(wantedData.NpcId)
    end
    self:adjustButtonSt()
    self:setEnableAccept()
    if data.notMine then
      self:Show(self.teamQuestHelpReward)
    end
    self:initHelpTeamReward()
  end
end

function AnnounceQuestPanelCellNew:setEnableAccept()
  local state = QuestProxy.Instance:hasGoingWantedQuest()
  if state and self.data:getQuestListType() == SceneQuest_pb.EQUESTLIST_CANACCEPT then
    self.actionBtn.color = Color(0.00392156862745098, 0.00784313725490196, 0.011764705882352941, 1)
    self.actionBtnCollider.enabled = false
    self.actionBtnLabel.effectStyle = UILabel.Effect.None
  end
end

function AnnounceClassmateShowCell:GetCardBackRepresentType()
  if self.cardBackType == nil then
    helplog("\tif self.cardBackType == nil then 没赋值！")
  end
  return self.cardBackType or NewLookBoardProxy.ShowCardType.Type_CardBack
end

function AnnounceQuestPanelCellNew.effectLoaded(effectObj)
end

function AnnounceQuestPanelCellNew:adjustButtonSt(data)
  self.actionBtn.color = Color(1, 1, 1, 1)
  self.actionBtnCollider.enabled = true
  self:Show(self.actionBtn.gameObject)
  if data.notMine then
    self:Hide(self.questState)
    self.actionBtn.spriteName = "com_btn_3"
    self.actionBtnLabel.text = ZhString.AnnounceQuestPanel_HelpQuest
    self.actionBtnLabel.effectColor = AnnounceQuestPanelCellLabelColor[2]
    self.actionBtnLabel.effectStyle = UILabel.Effect.Outline
    self:checkQuest()
    self:changeToNormalView()
  end
end

function AnnounceClassmateShowCell:changeToNormalView()
  self:Hide(self.leaderAceeptBtn)
  LuaVector3.Better_Set(tempVector3, 88, 12, 0)
  self.actionBtn.transform.localPosition = tempVector3
  self.actionBtn.width = 155
end

function AnnounceClassmateShowCell:SetSimpleIcon(Icon)
  local ret = IconManager:SetUIIcon(Icon, simpleIcon)
  if ret then
    self:Show(self.simpleIcon.gameObject)
    self:Hide(self.publishNameCt)
  end
  return ret
end

function AnnounceClassmateShowCell:initHelpTeamReward()
  local itemId = 147
  local itemData = Table_Item[itemId]
  if itemData then
    local text = string.format(ZhString.AnnounceQuestPanel_HelpTeammemberReward, itemId, itemData.NameZh)
    self.teamQuestHelpRewardLabel:SetText(text)
    return
  end
end

function AnnounceClassmateShowCell:SetNpcData(npcId)
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
  else
    printRed("can't find npcData at id:" .. npcId)
  end
end

function AnnounceClassmateShowCell:checkQuest()
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
    else
      self:Hide(self.teamQuestPortrait)
    end
  else
    self:Hide(self.teamQuestPortrait)
  end
end

function AnnounceClassmateShowCell:setTeamMembers(teamMembersData)
  self.teamQuestPortraitGrid:ResetDatas(teamMembersData)
end

function AnnounceClassmateShowCell:OnExit()
  self.super.OnExit(self)
  TimeTickManager.Me():ClearTick(self)
end
