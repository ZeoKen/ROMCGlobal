autoImport("TechTreeLevelCell")
ServantProjectLevelCell = class("ServantProjectLevelCell", TechTreeLevelCell)
autoImport("ServantProjectLevelContentCell")
local tempVector3 = LuaVector3.Zero()
ServantProjectLevelCell.SortOrder = {
  RewardReady = 1,
  QuestInProcess = 2,
  NotActieved = 3
}

function ServantProjectLevelCell:Init()
  ServantProjectLevelCell.super.Init(self)
  self:FindObjs()
end

function ServantProjectLevelCell:FindObjs()
  self.contentGrid = self:FindGO("ContentGrid"):GetComponent(UIGrid)
  self.contentGridCtrl = UIGridListCtrl.new(self.contentGrid, ServantProjectLevelContentCell, "TechTreeLevelContentCell")
  self.levelLabel = self:FindGO("LevelLabel"):GetComponent(UILabel)
  self.finishSymbol = self:FindGO("FinishSymbol")
  self.processDot = self:FindGO("ProcessDot")
  self.processFinish = self:FindGO("ProcessFinish")
  self.greenLine = self:FindGO("GreenLine"):GetComponent(UISprite)
  self.emptyLine = self:FindGO("EmptyLine"):GetComponent(UISprite)
  local shandian = self:FindGO("shandian"):GetComponent(UISprite)
  IconManager:SetItemIcon("item_181", shandian)
end

function ServantProjectLevelCell:SetData(data)
  local count = #data.child
  local point = data.score
  local achieved = data.achieved
  local ccc = {}
  for i = 1, #data.child do
    table.insert(ccc, {
      cfg = data.child[i],
      achieved = achieved
    })
  end
  self.contentGridCtrl:ResetDatas(ccc)
  self.sortOrder = 0
  self.greenLine.height = 85 + (count - 1) * 100
  self.emptyLine.height = 78 + (count - 1) * 100
  local processPos = self.processDot.transform.localPosition
  LuaVector3.Better_Set(tempVector3, processPos[1], -54 - (count - 1) * 100, processPos[3])
  self.processDot.transform.localPosition = tempVector3
  self.levelLabel.text = point
  self.finishSymbol:SetActive(achieved)
  self.greenLine.gameObject:SetActive(achieved)
  self.processFinish:SetActive(achieved)
  self.levelLabel.alpha = achieved and 0.33 or 1
end

function ServantProjectLevelCell:RefreshStatus(data)
end

function ServantProjectLevelCell:HandleClickReward(cellCtrl)
end

function ServantProjectLevelCell:CheckIsFinish()
  return self.finishSymbol.activeSelf
end
