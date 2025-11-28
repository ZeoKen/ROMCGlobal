ActivityPuzzleView = class("ActivityPuzzleView", ContainerView)
ActivityPuzzleView.ViewType = UIViewType.NormalLayer
autoImport("ActivityGoalListCell")
autoImport("ActivityPuzzleCell")
autoImport("ActivityPuzzleGiftCell")
autoImport("ActivityPuzzleBlockCell")
autoImport("ItemCell")
autoImport("ColliderItemCell")
ActivityPuzzleView.ColorTheme = {
  [1] = {
    color = LuaColor.New(1, 1, 1, 1)
  },
  [2] = {
    color = LuaColor.New(0.6588235294117647, 0.6588235294117647, 0.6588235294117647, 1)
  },
  [3] = {
    color = LuaColor.New(0, 0, 0, 1)
  },
  [4] = {
    color = LuaColor.New(0.12156862745098039, 0.4549019607843137, 0.7490196078431373, 1)
  },
  [5] = {
    color = LuaColor.New(0.2549019607843137, 0.34901960784313724, 0.6666666666666666, 1)
  }
}
local GetActivityPuzzleList = function(activityId, excludeID)
  local activityPuzzleList = {}
  for i, v in pairs(Table_ActivityPuzzle) do
    if v.ActivityID == activityId and v.UnlockType ~= 100 and v.PuzzleID ~= excludeID then
      table.insert(activityPuzzleList, v)
    end
  end
  return activityPuzzleList
end
local GetActivityPuzzleGiftList = function(activityId)
  local activityPuzzleList = {}
  for i, v in pairs(Table_ActivityPuzzle) do
    if v.ActivityID == activityId and v.UnlockType == 100 then
      table.insert(activityPuzzleList, v)
    end
  end
  return activityPuzzleList
end

function ActivityPuzzleView:Init()
  self:GetGameObjects()
  self:addListEventListener()
  self:InitData()
  if self.defaultActivity then
    self:TabChangeHandler(self.defaultActivity)
  end
end

function ActivityPuzzleView:InitData()
  local activityPuzzleDataList = ActivityPuzzleProxy.Instance:GetActivityPuzzleDataList()
  self.listControllerOfVersions:ResetDatas(activityPuzzleDataList)
  local cells = self.listControllerOfVersions:GetCells()
  for i = 1, #cells do
    local singleCell = cells[i]
    if i == 1 then
      self.defaultActivity = singleCell
    end
    self:AddTabChangeEvent(singleCell.gameObject, nil, singleCell)
  end
end

function ActivityPuzzleView:GetGameObjects()
  self.activityGrid = self:FindGO("activityGrid", self.gameObject)
  self.uiGridOfVersions = self.activityGrid:GetComponent(UIGrid)
  if self.listControllerOfVersions == nil then
    self.listControllerOfVersions = UIGridListCtrl.new(self.uiGridOfVersions, ActivityPuzzleCell, "ActivityPuzzleCell")
  end
  self.activityName = self:FindComponent("ActivityName", UILabel)
  self.puzzleBlockGrid = self:FindGO("puzzleBlockGrid")
  self.uiGridOfPuzzleBlocks = self.puzzleBlockGrid:GetComponent(UIGrid)
  if self.listControllerOfPuzzleBlocks == nil then
    self.listControllerOfPuzzleBlocks = UIGridListCtrl.new(self.uiGridOfPuzzleBlocks, ActivityPuzzleBlockCell, "PuzzleBlockCell")
  end
  self.goalScollview = self:FindGO("GoalListScrollView"):GetComponent(UIScrollView)
  self.table = self:FindGO("Table"):GetComponent(UITable)
  self.currentGoalGrid = self:FindGO("currentGoalListGrid"):GetComponent(UIGrid)
  if self.currentGoalCtrl == nil then
    self.currentGoalCtrl = UIGridListCtrl.new(self.currentGoalGrid, ActivityGoalListCell, "ActivityGoalListCell")
    self.currentGoalCtrl:AddEventListener(MouseEvent.MouseClick, self.ShowQuestDesc, self)
    self.currentGoalCtrl:AddEventListener(ActivityPuzzleGoEvent.MouseClick, self.ClickGoal, self)
    self.currentGoalCtrl:AddEventListener(ActivityPuzzleGoEvent.ClickIconTip, self.ClickItem, self)
  end
  
  function self.currentGoalGrid.onReposition()
    self.table:Reposition()
  end
  
  local togA = true
  self.currentGoalGrid.gameObject:SetActive(true)
  local curExp = self:FindGO("curExp"):GetComponent(UISprite)
  curExp.flip = 0
  self:AddClickEvent(self:FindGO("Current"), function(go)
    self.currentGoalGrid.gameObject:SetActive(not togA)
    self.table:Reposition()
    togA = not togA
    curExp.flip = togA and 0 or 2
  end)
  self.futureGoalGrid = self:FindGO("futureGoalListGrid"):GetComponent(UIGrid)
  if self.futureGoalCtrl == nil then
    self.futureGoalCtrl = UIGridListCtrl.new(self.futureGoalGrid, ActivityGoalListCell, "ActivityGoalListCell")
    self.futureGoalCtrl:AddEventListener(MouseEvent.MouseClick, self.ShowQuestDesc, self)
    self.futureGoalCtrl:AddEventListener(ActivityPuzzleGoEvent.MouseClick, self.ClickGoal, self)
    self.futureGoalCtrl:AddEventListener(ActivityPuzzleGoEvent.ClickIconTip, self.ClickItem, self)
  end
  
  function self.futureGoalGrid.onReposition()
    self.table:Reposition()
  end
  
  local togB = true
  local futureExp = self:FindGO("futureExp"):GetComponent(UISprite)
  futureExp.flip = 0
  self.futureGoalGrid.gameObject:SetActive(true)
  self:AddClickEvent(self:FindGO("Future"), function(go)
    self.futureGoalGrid.gameObject:SetActive(not togB)
    self.table:Reposition()
    togB = not togB
    futureExp.flip = togB and 0 or 2
  end)
  self.pastGoalGrid = self:FindGO("pastGoalListGrid"):GetComponent(UIGrid)
  if self.pastGoalCtrl == nil then
    self.pastGoalCtrl = UIGridListCtrl.new(self.pastGoalGrid, ActivityGoalListCell, "ActivityGoalListCell")
    self.pastGoalCtrl:AddEventListener(MouseEvent.MouseClick, self.ShowQuestDesc, self)
    self.pastGoalCtrl:AddEventListener(ActivityPuzzleGoEvent.MouseClick, self.ClickGoal, self)
    self.pastGoalCtrl:AddEventListener(ActivityPuzzleGoEvent.ClickIconTip, self.ClickItem, self)
  end
  
  function self.pastGoalGrid.onReposition()
    self.table:Reposition()
  end
  
  local togC = true
  local pastExp = self:FindGO("pastExp"):GetComponent(UISprite)
  pastExp.flip = 0
  self.pastGoalGrid.gameObject:SetActive(true)
  self:AddClickEvent(self:FindGO("Past"), function(go)
    self.pastGoalGrid.gameObject:SetActive(not togC)
    self.table:Reposition()
    togC = not togC
    pastExp.flip = togC and 0 or 2
  end)
  self.giftGrid = self:FindComponent("giftGrid", UIGrid)
  self.giftListCtl = UIGridListCtrl.new(self.giftGrid, ActivityPuzzleGiftCell, "ActivityPuzzleGiftCell")
  self.giftListCtl:AddEventListener(MouseEvent.MouseClick, self.ShowReward, self)
  self.puzzleRewardProgressBack = self:FindComponent("PuzzleRewardProgressBack", UISprite)
  self.puzzleRewardProgress = self:FindComponent("PuzzleRewardProgress", UISprite)
  self.activityPuzzleTitle = self:FindComponent("ActivityName", UILabel)
  self:AddButtonEvent("CloseButton", function()
    if self.activitytimeTick then
      self.activitytimeTick:ClearTick(self)
      self.activitytimeTick = nil
    end
    self:CloseSelf()
  end)
  self.rewardListPanel = self:FindGO("PanelRewardList", self.gameObject)
  self.rewardScrollView = self:FindComponent("RewardScrollView", UIScrollView)
  self.rewardGrid = self:FindComponent("RewardListGrid", UIGrid)
  if self.listControllerOfReward == nil then
    self.listControllerOfReward = UIGridListCtrl.new(self.rewardGrid, ColliderItemCell, "ColliderItemCell")
    self.listControllerOfReward:AddEventListener(MouseEvent.MouseClick, self.ClickItem, self)
  end
  self:AddButtonEvent("RewardListButtonClose", function()
    self.rewardListPanel:SetActive(false)
  end)
  self:AddButtonEvent("RewardListMaskClose", function()
    self.rewardListPanel:SetActive(false)
  end)
  self.puzzleHelpButton = self:FindGO("puzzleHelpButton")
  self:AddClickEvent(self.puzzleHelpButton, function(go)
    if self.currentActivityCell then
      local linkInfos = ActivityEventProxy.Instance:GetTapTapLinkInfo()
      local helpId = self.currentActivityCell.staticData.HelpID
      local url
      if helpId ~= nil and linkInfos ~= nil then
        local types = GameConfig.TapTapLink[helpId]
        if types ~= nil then
          for _, info in pairs(linkInfos) do
            for _, v in pairs(types) do
              if info.activitytype == v then
                url = info.url
              end
            end
          end
        end
      end
      if not StringUtil.IsEmpty(url) then
        Application.OpenURL(url)
      else
        local helpData = Table_Help[helpId]
        if helpData then
          TipsView.Me():ShowGeneralHelp(helpData.Desc, helpData.Title)
        end
      end
    end
  end)
  self.bg = self:FindGO("PuzzleTexture"):GetComponent(UITexture)
  self.tipstick = self:FindGO("BackTypeGoal"):GetComponent(UISprite)
  self.OpencalendarBtn = self:FindGO("OpencalendarBtn")
  self:AddClickEvent(self.OpencalendarBtn, function()
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.CalendarView
    })
  end)
end

function ActivityPuzzleView:addListEventListener()
  self:AddListenEvt(ServiceEvent.PuzzleCmdPuzzleItemNtf, self.RefreshAllData)
  self:AddListenEvt(ServiceEvent.PuzzleCmdActUpdatePuzzleCmd, self.InitData)
  self:AddListenEvt(ServiceEvent.PuzzleCmdActivePuzzleCmd, self.PlayEffect, self)
  self:AddListenEvt(RedTipProxy.UpdateParamEvent, self.UpdateRedTip)
  self:AddListenEvt(RedTipProxy.UpdateRedTipEvent, self.UpdateRedTip)
end

function ActivityPuzzleView:ClickItem(cell)
  local data = cell.data
  if data == nil then
    self:ShowItemTip()
    return
  end
  local sdata = {
    itemdata = data,
    funcConfig = {},
    ignoreBounds = ignoreBounds,
    hideGetPath = true
  }
  self:ShowItemTip(sdata, self.tipstick, NGUIUtil.AnchorSide.Left, {-212, 0})
end

function ActivityPuzzleView:TabChangeHandler(cell)
  if self.currentActivityCell ~= cell then
    ActivityPuzzleView.super.TabChangeHandler(self, cell)
    self.currentActivityCell = cell
    self:handleCategoryClick(cell)
  end
end

function ActivityPuzzleView:handleCategoryClick(cell)
  self:handleCategorySelect(cell.data)
  local cells = self.listControllerOfVersions:GetCells()
  for i = 1, #cells do
    local single = cells[i]
    if single == cell then
      single:setIsSelected(true)
    else
      single:setIsSelected(false)
    end
  end
  local currentPic = Table_ActivityInfo[cell.data.actid].PuzzlePic
  if currentPic and currentPic ~= "" then
    PictureManager.Instance:SetPuzzleBG(currentPic, self.bg)
  end
end

function ActivityPuzzleView:handleCategorySelect(data)
  self.activityPuzzleTitle.text = self.currentActivityCell.staticData.ActivityTitle
  self:ClearTick()
  self:RefreshAllData()
  self.goalScollview:ResetPosition()
end

function ActivityPuzzleView:RefreshAllData()
  self:UpdateGoalList()
  self:UpdateGiftProgress()
  self:UpdatePuzzleBoard()
end

function ActivityPuzzleView:UpdatePuzzleBoard()
  local puzzleActiveList = GetActivityPuzzleList(self.currentActivityCell.staticData.id, 0)
  if puzzleActiveList and 0 < #puzzleActiveList then
    table.sort(puzzleActiveList, function(x, y)
      return x.PuzzleID < y.PuzzleID
    end)
    local lineCount = math.sqrt(self.currentActivityCell.staticData.Size)
    self.uiGridOfPuzzleBlocks.maxPerLine = lineCount
    self.uiGridOfPuzzleBlocks.cellWidth = 428 / lineCount
    self.uiGridOfPuzzleBlocks.cellHeight = 560 / lineCount
    self.listControllerOfPuzzleBlocks:ResetDatas(puzzleActiveList)
  end
end

local tempcur = {}
local temppast = {}
local tempfut = {}

function ActivityPuzzleView:UpdateGoalList()
  local totalGoals = GetActivityPuzzleList(self.currentActivityCell.staticData.id)
  if tempcur then
    TableUtility.ArrayClear(tempcur)
  end
  if temppast then
    TableUtility.ArrayClear(temppast)
  end
  if tempfut then
    TableUtility.ArrayClear(tempfut)
  end
  if totalGoals then
    local len = #totalGoals
    local curTime = ServerTime.CurServerTime() / 1000
    local puzzleData, goStarttime, goEndtime
    for i = 1, len do
      puzzleData = ActivityPuzzleProxy.Instance:GetActivityPuzzleItemData(totalGoals[i].ActivityID, totalGoals[i].PuzzleID)
      if puzzleData.PuzzleState == PuzzleCmd_pb.EPUZZLESTATE_CANACTIVE then
        totalGoals[i].order = 0
      elseif puzzleData.PuzzleState == PuzzleCmd_pb.EPUZZLESTATE_ACTIVE then
        totalGoals[i].order = 1
      elseif puzzleData.PuzzleState == PuzzleCmd_pb.EPUZZLESTATE_UNACTIVE then
        totalGoals[i].order = 2
      else
        totalGoals[i].order = 3
      end
      goStarttime, goEndtime = ActivityPuzzleProxy.Instance:GetPuzzleItemDate(totalGoals[i])
      if curTime < goStarttime then
        totalGoals[i].locked = 1
        table.insert(tempfut, totalGoals[i])
      elseif curTime > goEndtime then
        totalGoals[i].locked = 2
        table.insert(temppast, totalGoals[i])
      else
        totalGoals[i].locked = 3
        table.insert(tempcur, totalGoals[i])
      end
    end
    self:SortList(tempcur)
    self.currentGoalCtrl:ResetDatas(tempcur)
    self:SortList(tempfut)
    self.futureGoalCtrl:ResetDatas(tempfut)
    self:SortList(temppast)
    self.pastGoalCtrl:ResetDatas(temppast)
    self.table:Reposition()
  end
end

function ActivityPuzzleView:SortList(list)
  table.sort(list, function(x, y)
    if x.id == y.id then
      return x.order < y.order
    else
      return x.id < y.id
    end
  end)
end

function ActivityPuzzleView:HandleGiftLongPress(param)
  local state, cellCtl = param[1], param[2]
  if state then
    self.currentPressCell = cellCtl
    self.startPressTime = ServerTime.CurServerTime()
    if self.tickMg then
      self.tickMg:ClearTick(self)
    else
      self.tickMg = TimeTickManager.Me()
    end
    self.tickMg:CreateTick(0, 100, self.updatePressItemCount, self)
  elseif self.tickMg then
    self.tickMg:ClearTick(self)
    self.tickMg = nil
  end
end

function ActivityPuzzleView:updatePressItemCount()
  local holdTime = ServerTime.CurServerTime() - self.startPressTime
  local changeCount = 1
  if 200 < holdTime then
    local cellData = {
      rewardid = self.currentPressCell.data.RewardID
    }
    TipManager.Instance:ShowRewardListTip(cellData, self.currentPressCell.stick, NGUIUtil.AnchorSide.DownRight, {35, 35})
  end
end

function ActivityPuzzleView:UpdateGiftProgress()
  local totalGrowthValue = self.currentActivityCell.staticData.Size
  local currentProgress = ActivityPuzzleProxy.Instance:GetActivityPuzzleProgress(self.currentActivityCell.staticData.id)
  local unitWidth = 494 / totalGrowthValue
  self.puzzleRewardProgress.width = currentProgress * unitWidth
  self.puzzleRewardProgress.gameObject:SetActive(currentProgress ~= 0)
  self.giftListCtl:ResetDatas(GetActivityPuzzleGiftList(self.currentActivityCell.staticData.id))
  local cells = self.giftListCtl:GetCells()
  for i = 1, #cells do
    cells[i]:UpdateGiftState(currentProgress, unitWidth)
  end
  self.giftListCtl:Layout()
end

function ActivityPuzzleView:ShowReward(cell)
  self.rewardListPanel:SetActive(true)
  local itemList = ItemUtil.GetRewardItemIdsByTeamId(cell.data.RewardID)
  local itemDataList = {}
  if itemList and 0 < #itemList then
    for i = 1, #itemList do
      local itemInfo = itemList[i]
      local tempItem = ItemData.new("", itemInfo.id)
      tempItem.num = itemInfo.num
      if itemInfo.refinelv and tempItem:IsEquip() then
        tempItem.equipInfo:SetRefine(itemInfo.refinelv)
      end
      itemDataList[#itemDataList + 1] = tempItem
    end
    self.listControllerOfReward:ResetDatas(itemDataList)
  end
  self.rewardScrollView:ResetPosition()
end

function ActivityPuzzleView:ClickGoal(cell)
  self:CloseSelf()
  FuncShortCutFunc.Me():CallByID(cell.data.GotoMode)
end

function ActivityPuzzleView:PlayEffect(msg)
  local pCells = self.listControllerOfPuzzleBlocks:GetCells()
  for k, v in pairs(pCells) do
    if v.data and v.data.PuzzleID == msg.body.puzzleid then
      v:PlayEffect()
      break
    end
  end
end

function ActivityPuzzleView:OnDestroy()
  PictureManager.Instance:UnLoadPuzzleBG()
end

function ActivityPuzzleView:OnExit()
  if self.activitytimeTick then
    self.activitytimeTick:ClearTick(self)
    self.activitytimeTick = nil
  end
  self:ClearTick()
end

function ActivityPuzzleView:ClearTick()
  if self.currentGoalCtrl then
    local cells = self.currentGoalCtrl:GetCells()
    for i = 1, #cells do
      cells[i]:ClearTick()
    end
  end
  if self.futureGoalCtrl then
    local cells = self.futureGoalCtrl:GetCells()
    for i = 1, #cells do
      cells[i]:ClearTick()
    end
  end
  if self.pastGoalCtrl then
    local cells = self.pastGoalCtrl:GetCells()
    for i = 1, #cells do
      cells[i]:ClearTick()
    end
  end
end

function ActivityPuzzleView:ShowQuestDesc(cell)
  local Desc = cell.data.QuestDesc
  if not Desc then
    return
  end
  TipsView.Me():ShowGeneralHelp(Desc, ZhString.ActivityPuzzle_QuestDesc)
end

function ActivityPuzzleView:UpdateRedTip()
  local activityPuzzleDataList = ActivityPuzzleProxy.Instance:GetActivityPuzzleDataList()
  self.listControllerOfVersions:ResetDatas(activityPuzzleDataList)
end
