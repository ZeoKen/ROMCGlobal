LevelListPopUp = class("LevelListPopUp", SubView)
autoImport("TechTreeLevelCell")

function LevelListPopUp:Init()
  xdlog("LevelListPopUp")
  self:ReLoadPerferb("view/LevelListPopUp")
  self.trans:SetParent(self.container.levelContainer.transform, false)
  self:FindObjs()
  self:AddEvts()
  self:AddMapEvts()
  self:InitData()
  self:InitShow()
end

function LevelListPopUp:FindObjs()
  self.scrollView = self:FindComponent("LevelScrollView", UIScrollView)
  self.levelTable = self:FindGO("LevelTable"):GetComponent(UITable)
  self.levelGridCtrl = UIGridListCtrl.new(self.levelTable, TechTreeLevelCell, "TechTreeLevelCell")
  self.panel = self.scrollView.panel
  self.closecomp = self.gameObject:GetComponent(CloseWhenClickOtherPlace)
end

function LevelListPopUp:InitData()
  local config = Table_TechTreeLevel
  if not config then
    redlog("无科技树配置")
    return
  end
  self.treeId = self.container.treeId
  local result = {}
  self.levelList = {}
  local menuUnlockConfig = GameConfig.TechTree.ShowLevelMenuList
  for k, v in pairs(Table_TechTreeLevel) do
    if not self.levelList[v.Level] and not v.Hide and v.Tree == self.treeId then
      self.levelList[v.Level] = {
        level = v.Level,
        child = {}
      }
    end
    if not v.Hide and v.Tree == self.treeId then
      local forceUnlock = menuUnlockConfig and menuUnlockConfig[k] and FunctionUnLockFunc.Me():CheckCanOpen(menuUnlockConfig[k]) or false
      self.levelList[v.Level].child[k] = {
        level = v.Level,
        awarded = forceUnlock,
        achieved = false,
        sortOrder = TechTreeLevelCell.SortOrder.NotActieved
      }
    end
  end
  self:RefreshPage()
end

function LevelListPopUp:InitShow()
end

function LevelListPopUp:RefreshPage()
  local nodeInfos = self.container:RefreshTechTreeLevelInfos()
  if nodeInfos then
    for id, info in pairs(nodeInfos) do
      local level = Table_TechTreeLevel[id] and Table_TechTreeLevel[id].Level
      if self.levelList[level] and self.levelList[level].child[id] then
        self.levelList[level].child[id].awarded = info.awarded
        self.levelList[level].child[id].queststate = info.queststate
        self.levelList[level].child[id].achieved = true
      else
        redlog("无配置 或 未初始化节点", level, id)
      end
    end
  end
  local result = {}
  for k, v in pairs(self.levelList) do
    table.insert(result, v)
  end
  table.sort(result, function(l, r)
    return l.level < r.level
  end)
  self.levelGridCtrl:ResetDatas(result)
  self:AdjustScrollView()
end

function LevelListPopUp:AddEvts()
end

function LevelListPopUp:AddMapEvts()
end

function LevelListPopUp:UpdatePage()
end

function LevelListPopUp:ReUnitData(datas)
end

function LevelListPopUp:OnActivate()
  self:UpdatePage()
end

function LevelListPopUp:SetActive(bool)
  if bool then
    self:Show()
  else
    self:Hide()
  end
end

function LevelListPopUp:OnMouseClick(data)
end

function LevelListPopUp:AdjustScrollView()
  self.scrollView:ResetPosition()
  local cells = self.levelGridCtrl:GetCells()
  local targetCell
  for i = 1, #cells do
    local cell = cells[i]
    if not cell:CheckIsFinish() then
      if not targetCell then
        targetCell = cell
      elseif targetCell.sortOrder > cell.sortOrder then
        targetCell = cell
      end
    end
  end
  if not targetCell then
    return
  end
  local bound = NGUIMath.CalculateRelativeWidgetBounds(self.panel.cachedTransform, targetCell.gameObject.transform)
  local offset = self.panel:CalculateConstrainOffset(bound.min, bound.max)
  offset = Vector3(0, offset.y, 0)
  self.scrollView:MoveRelative(offset)
end
