BigMapQuestTip = class("BigMapQuestTip", CoreView)
autoImport("MapBoardQuestCombineCell")
autoImport("WrapScrollViewHelper")

function BigMapQuestTip:ctor(go)
  BigMapQuestTip.super.ctor(self, go)
  self:Init()
end

function BigMapQuestTip:Init()
  self:initView()
  self:InitData()
end

function BigMapQuestTip:initView()
  self.helpBtn = self:FindGO("HelpButton")
  self.questTable = self:FindComponent("QuestTable", UITable)
  self.questScrollView = self:FindComponent("QuestScrollView", UIScrollView)
  self.scrollViewPanel = self:FindComponent("QuestScrollView", UIPanel)
  self.scrollViewPanel.depth = 55
  self.noneTip = self:FindGO("NoneTip")
  self.questType = {}
  self.listCtrl = WrapScrollViewHelper.new(MapBoardQuestCombineCell, ResourcePathHelper.UICell("MapBoardQuestCombineCell"), self.questScrollView.gameObject, self.questTable, 7)
  self.listCtrl:AddEventListener("ClickBigMapBoardQuestCell", self.ClickQuestCell, self)
  self.listCtrl:AddEventListener("RefreshMapBoardList", self.RefreshTable, self)
  self.listCtrl:AddEventListener("MapBoardQuestCombineCell_ClickDescribeBtn", self.RefreshDescriptionShow, self)
  self:TryOpenHelpViewById(8000005, nil, self.helpBtn)
end

function BigMapQuestTip:InitData()
end

function BigMapQuestTip:RefreshDescriptionShow()
  self.questTable:Reposition()
end

function BigMapQuestTip:RefreshList()
  local resultTable = self:MakeQuestFatherTable()
  self.listCtrl:ResetPosition(resultTable)
  self.questScrollView:ResetPosition()
  local showNoTip = true
  for k, v in pairs(resultTable) do
    if #v.childQuests > 0 then
      showNoTip = false
      break
    end
  end
  if showNoTip then
    self.noneTip:SetActive(true)
  else
    self.noneTip:SetActive(false)
  end
end

function BigMapQuestTip:MakeQuestFatherTable()
  if self.questType then
    TableUtility.TableClear(self.questType)
  end
  local curMapId = Game.MapManager:GetMapID()
  local list = QuestProxy.Instance:getMiniMapQuestListByMap(curMapId)
  for i = 1, #list do
    local single = list[i]
    if not self.questType[single.staticData.ColorFromServer] and single.staticData.ColorFromServer ~= 0 and single.staticData.ColorFromServer ~= 6 and self:CheckQuestTypeShownInList(single.staticData.ColorFromServer) then
      fatherTagItem = ReusableTable.CreateTable()
      fatherTagItem.ColorFromServer = single.staticData.ColorFromServer
      self.questType[single.staticData.ColorFromServer] = fatherTagItem
    end
  end
  local resultTable = {}
  for k, v in pairs(self.questType) do
    local newGoal = ReusableTable.CreateTable()
    newGoal.fatherTag = v
    newGoal.childQuests = {}
    for i = 1, #list do
      local questData = list[i]
      if questData.staticData.ColorFromServer == 6 then
        questData.staticData.ColorFromServer = 1
      end
      if questData.staticData.ColorFromServer == v.ColorFromServer and questData.map ~= nil and questData.traceInfo ~= "" then
        table.insert(newGoal.childQuests, questData)
      end
    end
    table.insert(resultTable, newGoal)
  end
  if GameConfig.Quest and GameConfig.Quest.QuestSort then
    local QuestSort = GameConfig.Quest.QuestSort
    table.sort(resultTable, function(l, r)
      local leftSortOrder = QuestSort[l.fatherTag.ColorFromServer].sortorder or 99
      local rightSortOrder = QuestSort[r.fatherTag.ColorFromServer].sortorder or 99
      if leftSortOrder == 99 or rightSortOrder == 99 then
        redlog("tag颜色为" .. l.fatherTag.ColorFromServer .. "或者" .. r.fatherTag.ColorFromServer .. "未配置sort值")
      end
      if leftSortOrder ~= rightSortOrder then
        return leftSortOrder > rightSortOrder
      end
    end)
  end
  return resultTable
end

local checkColorList = {
  1,
  2,
  3,
  4,
  5,
  6,
  7,
  20
}

function BigMapQuestTip:CheckQuestTypeShownInList(ColorFromServer)
  for i = 1, #checkColorList do
    local validColor = checkColorList[i]
    if ColorFromServer == validColor then
      return true
    end
  end
  return false
end

function BigMapQuestTip:RefreshTable()
  self.questTable:Reposition()
  local size = NGUIMath.CalculateRelativeWidgetBounds(self.questTable.transform)
  local height = size.size.y
  if height < 450 then
    self.questScrollView:DisableSpring()
    self.questScrollView:ResetPosition()
  end
end

function BigMapQuestTip:ClickQuestCell(cellCtrl)
  if not cellCtrl or not cellCtrl.data then
    return
  end
  if self.isInFuben then
    local curID = Game.MapManager:GetRaidID() or 0
    if curID ~= cellCtrl.data.map then
      MsgManager.ShowMsgByIDTable(27002)
      return
    end
  end
end

function BigMapQuestTip:stopShowDirAndDis(id)
  if not id then
    return
  end
  FunctionQuest.Me():stopQuestMiniShow(id)
  local cells = self.questList:GetCells()
  for j = 1, #cells do
    local cell = cells[j]
    local data = cell.data
    if data and id == data.id then
      FunctionQuestDisChecker.RemoveQuestCheck(id)
      cell:setISShowDir(false)
      break
    end
  end
end

function BigMapQuestTip:OnShow()
  self:RefreshList()
  EventManager.Me():AddEventListener(ServiceEvent.QuestQuestUpdate, self.RefreshList, self)
  EventManager.Me():AddEventListener(ServiceEvent.QuestQuestList, self.RefreshList, self)
  EventManager.Me():AddEventListener(ServiceEvent.QuestQuestStepUpdate, self.RefreshList, self)
  EventManager.Me():AddEventListener(ServiceEvent.QuestQueryOtherData, self.RefreshList, self)
end

function BigMapQuestTip:OnHide()
  EventManager.Me():RemoveEventListener(ServiceEvent.QuestQuestUpdate, self.RefreshList, self)
  EventManager.Me():RemoveEventListener(ServiceEvent.QuestQuestList, self.RefreshList, self)
  EventManager.Me():RemoveEventListener(ServiceEvent.QuestQuestStepUpdate, self.RefreshList, self)
  EventManager.Me():RemoveEventListener(ServiceEvent.QuestQueryOtherData, self.RefreshList, self)
end

function BigMapQuestTip:RemoveCells()
  self.listCtrl:RemoveAll()
end
