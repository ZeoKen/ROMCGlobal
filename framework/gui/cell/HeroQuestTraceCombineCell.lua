autoImport("QuestTraceBaseCombineCell")
autoImport("MainQuestTraceCell")
autoImport("HeroQuestTraceCell")
autoImport("QuestTraceBaseTogCell")
HeroQuestTraceCombineCell = class("HeroQuestTraceCombineCell", QuestTraceBaseCombineCell)
HeroQuestTraceCombineCell.rewardCellPath = ResourcePathHelper.UICell("QuestTraceRewardCell")

function HeroQuestTraceCombineCell:Init()
  HeroQuestTraceCombineCell.super.Init(self)
  self.father_TweenPos = self.fatherObj:GetComponent(TweenPosition)
  self.father_TweenAlpha = self.fatherObj:GetComponent(TweenAlpha)
  self.childCtl = UIGridListCtrl.new(self.ChildGoals_UIGrid, HeroQuestTraceCell, "HeroQuestTraceCell")
  self.childCtl:AddEventListener(MouseEvent.MouseClick, self.ClickChild, self)
  self.childCtl:AddEventListener(QuestEvent.QuestTraceChange, self.HandleTraceUpdate, self)
  self.tweenScale:SetOnFinished(function()
    self:OnTweenScaleOnFinished()
  end)
  self.levelRangeLabel = self:FindGO("LevelRangeLabel"):GetComponent(UILabel)
  self.keyRewardGO = self:FindGO("KeyReward")
  self.versionBGTexture = self:FindGO("FatherGoal"):GetComponent(UITexture)
  self.folderState = true
end

function HeroQuestTraceCombineCell:SetData(data)
  HeroQuestTraceCombineCell.super.SetData(self, data)
  self.data = data
  if data.fatherGoal then
    local isHero = data.fatherGoal.isHero
    self.childContainer.transform.localPosition = LuaGeometry.GetTempVector3(0, -50, 0)
    self.fatherObj:SetActive(true)
    self.profId = data.fatherGoal.profId
    local bannerConfig = GameConfig.HeroStory and GameConfig.HeroStory.Banner
    self.heroBG = "Missiontracking_bottom_menghuan"
    if bannerConfig and bannerConfig[self.profId] then
      self.heroBG = bannerConfig[self.profId]
    end
    if self.heroBG then
      PictureManager.Instance:SetMissionTrackTexture(self.heroBG, self.versionBGTexture)
    end
    if self.profId then
      local className = Table_Class[self.profId].NameZh
      local extraData = HeroProfessionProxy.Instance:GetHeroExtraStoryQuest(self.profId)
      self.groupLabel.text = OverSea.LangManager.Instance():GetLangByKey(className) .. string.format(ZhString.HeroProfessionExtraProgress, extraData:GetProgressStr())
      self.keyRewardGO:SetActive(false)
    end
    local starttime = data.fatherGoal.starttime
    local endtime = data.fatherGoal.endtime
    if starttime and endtime then
      local str = ""
      local p = "(%d+)-(%d+)-(%d+) (%d+):(%d+):(%d+)"
      local year, month, day, hour, min, sec = starttime:match(p)
      str = str .. tonumber(month) .. "." .. tonumber(day) .. "~"
      year, month, day, hour, min, sec = endtime:match(p)
      str = str .. tonumber(month) .. "." .. tonumber(day)
      self.levelRangeLabel.text = str
    elseif data.fatherGoal.isCollabor then
      self.levelRangeLabel.text = ZhString.HeroStory_Collabor
    else
      self.levelRangeLabel.text = ZhString.HeroStory_Permanent
    end
    self.ChildGoals_UIGrid.cellHeight = 76.6
    self.childCtl:ResetDatas(data.childGoals)
    local isReward = data.fatherGoal.isReward or false
    self.folderState = not isReward
  else
    self.folderState = true
  end
  if self.folderState then
    self.tweenScale.duration = 0
    self.tweenScale:PlayForward()
    self.tweenScale.enabled = false
    self:PlayChildTween()
  else
    self.tweenScale.duration = 0
    self:PlayChildTweenReverse()
    self.tweenScale:ResetToBeginning()
    self.tweenScale.enabled = false
  end
  self:RefreshArrow()
end

function HeroQuestTraceCombineCell:SwitchToTargetQuest(id)
  local cells = self.childCtl:GetCells()
  for i = 1, #cells do
    if cells[i].id and cells[i].id == id then
      self:ClickChild(cells[i])
      return cells[i]
    end
  end
  return false
end

function HeroQuestTraceCombineCell:SetDefaultChoose()
  local cells = self.childCtl:GetCells()
  if cells and 0 < #cells then
    self:ClickChild(cells[1])
    return
  end
end

function HeroQuestTraceCombineCell:ClickChild(cellCtrl)
  if cellCtrl ~= self.nowChild then
    cellCtrl:SetChooseStatus(true)
    self.nowChild = cellCtrl
  end
  self:PassEvent(MouseEvent.MouseClick, {
    type = "Child",
    combine = self,
    child = self.nowChild
  })
end

function HeroQuestTraceCombineCell:PlayChildTween()
  local cells = self.childCtl:GetCells()
  if cells and 0 < #cells then
    for i = 1, #cells do
      cells[i]:PlayTween()
    end
  end
end

function HeroQuestTraceCombineCell:handleClickKeyReward(cellCtrl)
  if self.isCompleted and not self.isRewarded then
    local questData = HeroProfessionProxy.Instance:GetHeroExtraStoryQuest(self.profId)
    if questData:IsCompleted() and not questData:IsRewarded() then
      xdlog("尝试领奖", questData.completeNum, self.profId, SceneUser3_pb.HEROQUESTREWARDTYPE_STORY_EXTRA)
      HeroProfessionProxy.Instance:TakeHeroQuestReward(questData.completeNum, self.profId, SceneUser3_pb.HEROQUESTREWARDTYPE_STORY_EXTRA)
    end
  else
    local sdata = {
      itemdata = cellCtrl.data,
      ignoreBounds = {
        cellCtrl.gameObject
      }
    }
    self:ShowItemTip(sdata, cellCtrl.icon, NGUIUtil.AnchorSide.TopRight, {300, -200})
  end
end

function HeroQuestTraceCombineCell:HandleTraceUpdate(cellCtrl)
  self:PassEvent(QuestEvent.QuestTraceChange, cellCtrl)
end

function HeroQuestTraceCombineCell:RefillContainer()
  local cells = self.childCtl:GetCells()
  local height = self.ChildGoals_UIGrid.cellHeight * #cells
  self.sizeContainer.height = height
end

function HeroQuestTraceCombineCell:OnCellDestroy()
  if self.versionBG then
    PictureManager.Instance:UnloadMissionTrackTexture(self.versionBG, self.versionBGTexture)
    self.versionBG = nil
  end
end
