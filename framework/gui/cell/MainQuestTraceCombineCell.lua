autoImport("QuestTraceBaseCombineCell")
autoImport("MainQuestTraceCell")
autoImport("QuestTraceBaseTogCell")
MainQuestTraceCombineCell = class("MainQuestTraceCombineCell", QuestTraceBaseCombineCell)
MainQuestTraceCombineCell.rewardCellPath = ResourcePathHelper.UICell("QuestTraceRewardCell")

function MainQuestTraceCombineCell:Init()
  MainQuestTraceCombineCell.super.Init(self)
  self.father_TweenPos = self.fatherObj:GetComponent(TweenPosition)
  self.father_TweenAlpha = self.fatherObj:GetComponent(TweenAlpha)
  self.childCtl = UIGridListCtrl.new(self.ChildGoals_UIGrid, MainQuestTraceCell, "MainQuestTraceCell")
  self.childCtl:AddEventListener(MouseEvent.MouseClick, self.ClickChild, self)
  self.childCtl:AddEventListener(QuestEvent.QuestTraceChange, self.HandleTraceUpdate, self)
  self.largeChildCtl = UIGridListCtrl.new(self.ChildGoals_UIGrid, QuestTraceTogCell, "QuestTraceTogCell")
  self.largeChildCtl:AddEventListener(MouseEvent.MouseClick, self.ClickLargeChild, self)
  self.largeChildCtl:AddEventListener(QuestEvent.QuestTraceChange, self.HandleTraceUpdate, self)
  self.tweenScale:SetOnFinished(function()
    self:OnTweenScaleOnFinished()
  end)
  self.levelRangeLabel = self:FindGO("LevelRangeLabel"):GetComponent(UILabel)
  self.keyRewardGO = self:FindGO("KeyReward")
  self.versionBGTexture = self:FindGO("FatherGoal"):GetComponent(UITexture)
  self.puzzleBtn = self:FindGO("PuzzleBtn")
  self:AddClickEvent(self.puzzleBtn, function()
    if self.data and self.data.fatherGoal and self.data.fatherGoal.allFinish then
      self:PassEvent(QuestEvent.QuestTraceShowPuzzleImage, {
        version = self.data.fatherGoal.version
      })
    else
      MsgManager.ShowMsgByID(834)
    end
  end)
  self.shortcutBtn = self:FindGO("ShortCutBtn")
  self:AddClickEvent(self.shortcutBtn, function()
    if self.shortcutId then
      FuncShortCutFunc.Me():CallByID(self.shortcutId)
    end
  end)
  self.folderState = true
end

function MainQuestTraceCombineCell:SetData(data)
  MainQuestTraceCombineCell.super.SetData(self, data)
  self.data = data
  if data.fatherGoal then
    local isMain = data.fatherGoal.isMain
    self.childContainer.transform.localPosition = isMain and LuaGeometry.GetTempVector3(0, -50, 0) or LuaGeometry.Const_V3_zero
    if isMain then
      self.fatherObj:SetActive(true)
      local version = data.fatherGoal.version
      self.versionBG = data.fatherGoal.versionBG
      if self.versionBG then
        PictureManager.Instance:SetMissionTrackTexture(self.versionBG, self.versionBGTexture)
      end
      local storyConfig = QuestManualProxy.Instance:GetStoryConfigByVersion(data.fatherGoal.version)
      if storyConfig then
        local minLevel = storyConfig.minLevel or 1
        local maxLevel = storyConfig.maxLevel or 170
        if minLevel and maxLevel then
          self.levelRangeLabel.text = "Lv." .. minLevel .. "~" .. "Lv." .. maxLevel
        else
          self.levelRangeLabel.text = ""
        end
      end
      local curFinishCount, maxIndex = QuestManualProxy.Instance:GetVersionIndexProcess(data.fatherGoal.version)
      if data.fatherGoal.title then
        local formatStr = "(%s/%s)"
        self.groupLabel.text = OverSea.LangManager.Instance():GetLangByKey(data.fatherGoal.title) .. string.format(formatStr, curFinishCount, maxIndex)
      end
      self.groupLabel_BG.width = self.groupLabel.printedSize.x + 30
      local allFinish = data.fatherGoal.allFinish
      local inProcess = data.fatherGoal.inProcess
      local keyReward = data.fatherGoal.keyReward
      if keyReward then
        self.keyRewardGO:SetActive(true)
        local parent = self:FindGO("keyCellHandler", self.keyRewardGO)
        local obj = Game.AssetManager_UI:CreateAsset(MainQuestTraceCombineCell.rewardCellPath, parent)
        obj.transform.localPosition = Vector3.zero
        self.keyRewardCell = QuestTraceRewardCell.new(obj)
        local itemData = ItemData.new("KeyReward", keyReward.itemid)
        itemData:SetItemNum(keyReward.num)
        self.keyRewardCell:SetData(itemData)
        self.keyRewardCell:AddEventListener(MouseEvent.MouseClick, self.handleClickKeyReward, self)
        if self.keyRewardCell then
          self.keyRewardCell:SetFinish(allFinish)
        end
      else
        self.keyRewardGO:SetActive(false)
      end
      local versionPic
      for _, ven in pairs(Table_QuestVersion) do
        if ven.version == version then
          local _versionPic = ven.VersionPic
          versionPic = _versionPic
          self.shortcutId = ven.ShortCutId
          break
        end
      end
      if versionPic and versionPic ~= "" then
        self.puzzleBtn:SetActive(true)
        if allFinish then
          self:SetTextureWhite(self.puzzleBtn)
        else
          self:SetTextureGrey(self.puzzleBtn)
        end
      else
        self.puzzleBtn:SetActive(false)
      end
      self.shortcutBtn:SetActive(self.shortcutId ~= nil)
      self.ChildGoals_UIGrid.cellHeight = 76.6
      self.largeChildCtl:RemoveAll()
      self.childCtl:ResetDatas(data.childGoals)
      self.folderState = inProcess or false
    else
      self.fatherObj:SetActive(false)
      self.folderState = true
      self.ChildGoals_UIGrid.cellHeight = 120
      self.childCtl:RemoveAll()
      self.largeChildCtl:ResetDatas(data.childGoals)
    end
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

function MainQuestTraceCombineCell:SwitchToTargetQuest(id, prestigeversion)
  local cells = self.childCtl:GetCells()
  for i = 1, #cells do
    if cells[i].indexID and cells[i].indexID == id then
      self:ClickChild(cells[i])
      return cells[i]
    end
    if prestigeversion and cells[i].prestigeVersion and cells[i].prestigeVersion == prestigeversion then
      self:ClickChild(cells[i])
      return cells[i]
    end
  end
  cells = self.largeChildCtl:GetCells()
  if cells and 0 < #cells then
    for i = 1, #cells do
      if cells[i].data and cells[i].data.id == id then
        self:ClickLargeChild(cells[i])
        return cells[i]
      end
    end
  end
  return false
end

function MainQuestTraceCombineCell:SetDefaultChoose()
  local cells = self.childCtl:GetCells()
  if cells and 0 < #cells then
    self:ClickChild(cells[1])
    return
  end
  cells = self.largeChildCtl:GetCells()
  if cells and 0 < #cells then
    self:ClickLargeChild(cells[1])
    return
  end
end

function MainQuestTraceCombineCell:ClickChild(cellCtrl)
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

function MainQuestTraceCombineCell:PlayChildTween()
  local cells = self.childCtl:GetCells()
  if cells and 0 < #cells then
    for i = 1, #cells do
      cells[i]:PlayTween()
    end
  end
  cells = self.largeChildCtl:GetCells()
  if cells and 0 < #cells then
    for i = 1, #cells do
      cells[i]:PlayTween()
    end
  end
end

function MainQuestTraceCombineCell:ClickLargeChild(cellCtrl)
  if cellCtrl ~= self.nowChild then
    cellCtrl:SetChooseStatus(true)
    self.nowChild = cellCtrl
  end
  self:PassEvent(MouseEvent.MouseClick, {
    type = "CommonChild",
    combine = self,
    child = self.nowChild
  })
end

function MainQuestTraceCombineCell:handleClickKeyReward(cellCtrl)
  xdlog("点击奖励")
  local sdata = {
    itemdata = cellCtrl.data,
    ignoreBounds = {
      cellCtrl.gameObject
    }
  }
  self:ShowItemTip(sdata, cellCtrl.icon, NGUIUtil.AnchorSide.TopRight, {300, -200})
end

function MainQuestTraceCombineCell:HandleTraceUpdate(cellCtrl)
  self:PassEvent(QuestEvent.QuestTraceChange, cellCtrl)
end

function MainQuestTraceCombineCell:RefillContainer()
  local height = 0
  local cells = self.childCtl:GetCells()
  if cells and 0 < #cells then
    height = self.ChildGoals_UIGrid.cellHeight * #cells
  end
  cells = self.largeChildCtl:GetCells()
  if cells and 0 < #cells then
    height = self.ChildGoals_UIGrid.cellHeight * #cells
  end
  self.sizeContainer.height = height
end

function MainQuestTraceCombineCell:GetChildCells()
  local cells = self.childCtl:GetCells()
  if cells then
    return cells
  end
  cells = self.largeChildCtl:GetCells()
  if cells then
    return cells
  end
end

function MainQuestTraceCombineCell:OnCellDestroy()
  if self.versionBG then
    PictureManager.Instance:UnloadMissionTrackTexture(self.versionBG, self.versionBGTexture)
    self.versionBG = nil
  end
end
