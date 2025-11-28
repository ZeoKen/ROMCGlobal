local BaseCell = autoImport("BaseCell")
TechTreeLevelCell = class("TechTreeLevelCell", BaseCell)
autoImport("TechTreeLevelContentCell")
local tempVector3 = LuaVector3.Zero()
TechTreeLevelCell.SortOrder = {
  RewardReady = 1,
  QuestInProcess = 2,
  NotActieved = 3
}

function TechTreeLevelCell:Init()
  TechTreeLevelCell.super.Init(self)
  self:FindObjs()
end

function TechTreeLevelCell:FindObjs()
  self.contentGrid = self:FindGO("ContentGrid"):GetComponent(UIGrid)
  self.contentGridCtrl = UIGridListCtrl.new(self.contentGrid, TechTreeLevelContentCell, "TechTreeLevelContentCell")
  self.levelLabel = self:FindGO("LevelLabel"):GetComponent(UILabel)
  self.finishSymbol = self:FindGO("FinishSymbol")
  self.processDot = self:FindGO("ProcessDot")
  self.processFinish = self:FindGO("ProcessFinish")
  self.greenLine = self:FindGO("GreenLine"):GetComponent(UISprite)
  self.emptyLine = self:FindGO("EmptyLine"):GetComponent(UISprite)
end

function TechTreeLevelCell:SetData(data)
  self.data = data.child
  local result = {}
  local count = 0
  local level = 0
  local isFinish = true
  local achieved = false
  for id, info in pairs(self.data) do
    local data = {}
    TableUtility.TableShallowCopy(data, info)
    data.id = id
    table.insert(result, data)
    count = count + 1
    level = info.level
    if not info.awarded then
      isFinish = false
    end
    if info.achieved then
      achieved = true
    end
    if not self.sortOrder then
      self.sortOrder = info.sortOrder
    end
    if not info.awarded then
      if info.queststate == 0 then
        self.sortOrder = TechTreeLevelCell.SortOrder.RewardReady
      else
        self.sortOrder = TechTreeLevelCell.SortOrder.QuestInProcess
      end
    end
  end
  self.contentGridCtrl:ResetDatas(result)
  self.greenLine.height = 85 + (count - 1) * 100
  self.emptyLine.height = 78 + (count - 1) * 100
  local processPos = self.processDot.transform.localPosition
  LuaVector3.Better_Set(tempVector3, processPos[1], -54 - (count - 1) * 100, processPos[3])
  self.processDot.transform.localPosition = tempVector3
  self.levelLabel.text = "Lv." .. level
  self.finishSymbol:SetActive(isFinish)
  self.greenLine.gameObject:SetActive(achieved)
  self.processFinish:SetActive(achieved)
  self.levelLabel.alpha = isFinish and 0.33 or 1
end

function TechTreeLevelCell:RefreshStatus(data)
end

function TechTreeLevelCell:HandleClickReward(cellCtrl)
end

function TechTreeLevelCell:CheckIsFinish()
  return self.finishSymbol.activeSelf
end
