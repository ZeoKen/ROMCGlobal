autoImport("BaseRoundRewardView")
autoImport("MiniROItemCell")
MiniRORewardView = class("MiniRORewardView", BaseRoundRewardView)

function MiniRORewardView:InitWrap()
  local activityData = MiniROProxy.Instance:GetActivityData()
  if activityData == nil then
    return
  end
  local turnCount = #activityData.featureData.circleRewards
  local container = self:FindGO("ItemContainer")
  local wrapConfig = {
    wrapObj = container,
    pfbNum = turnCount,
    cellName = "MiniROItemCell",
    control = MiniROItemCell,
    dir = 1
  }
  self.listItem = WrapCellHelper.new(wrapConfig)
end

function MiniRORewardView:UpdateView()
  local activityData = MiniROProxy.Instance:GetActivityData()
  if activityData == nil then
    return
  end
  if self.listData == nil then
    self.listData = {}
  else
    TableUtility.TableClear(self.listData)
  end
  local turnCount = #activityData.featureData.circleRewards
  for i = 1, turnCount do
    local listRewardId = activityData.featureData.circleRewards[i]
    local data = {}
    data[1] = i
    data[2] = string.format(ZhString.MiniRORewardCellTitle, i)
    data[3] = listRewardId
    data[4] = self.tipStick
    table.insert(self.listData, data)
  end
  self.listItem:UpdateInfo(self.listData)
  if self.listItemCell == nil then
    self.listItemCell = self.listItem:GetCellCtls()
  end
  for i = 1, #self.listItemCell do
    self.listItemCell[i]:SetView(self)
  end
  local startIndex = turnCount > MiniROProxy.Instance:GetCurCompleteTurns() and MiniROProxy.Instance:GetCurCompleteTurns() + 1 or turnCount
  self.listItem:SetStartPositionByIndex(startIndex)
end
