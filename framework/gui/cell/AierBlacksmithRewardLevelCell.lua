autoImport("TechTreeLevelCell")
AierBlacksmithRewardLevelCell = class("AierBlacksmithRewardLevelCell", TechTreeLevelCell)
autoImport("AierBlacksmithRewardLevelContentCell")
local tempVector3 = LuaVector3.Zero()
AierBlacksmithRewardLevelCell.SortOrder = {
  RewardReady = 1,
  QuestInProcess = 2,
  NotActieved = 3
}

function AierBlacksmithRewardLevelCell:FindObjs()
  self.contentGrid = self:FindGO("ContentGrid"):GetComponent(UIGrid)
  self.contentGridCtrl = UIGridListCtrl.new(self.contentGrid, AierBlacksmithRewardLevelContentCell, "TechTreeLevelContentCell")
  self.levelLabel = self:FindGO("LevelLabel"):GetComponent(UILabel)
  self.finishSymbol = self:FindGO("FinishSymbol")
  self.processDot = self:FindGO("ProcessDot")
  self.processFinish = self:FindGO("ProcessFinish")
  self.greenLine = self:FindGO("GreenLine"):GetComponent(UISprite)
  self.emptyLine = self:FindGO("EmptyLine"):GetComponent(UISprite)
end

function AierBlacksmithRewardLevelCell:SetData(data)
  local level = data.Level
  local achieved = level <= AierBlacksmithProxy.Instance.proxyData.level
  local reward = data.Reward
  if type(reward) == "table" then
    reward = reward[1]
  end
  reward = ItemUtil.GetRewardItemIdsByTeamId(reward)
  reward = reward.item
  local ccc = {}
  for i = 1, #reward do
    table.insert(ccc, {
      cfg = reward[i],
      achieved = achieved
    })
  end
  self.contentGridCtrl:ResetDatas(ccc)
  self.sortOrder = 0
  local count = #ccc
  self.greenLine.height = 85 + (count - 1) * 100
  self.emptyLine.height = 78 + (count - 1) * 100
  local processPos = self.processDot.transform.localPosition
  LuaVector3.Better_Set(tempVector3, processPos[1], -54 - (count - 1) * 100, processPos[3])
  self.processDot.transform.localPosition = tempVector3
  self.levelLabel.text = level
  self.finishSymbol:SetActive(achieved)
  self.greenLine.gameObject:SetActive(achieved)
  self.processFinish:SetActive(achieved)
  self.levelLabel.alpha = achieved and 0.33 or 1
end
