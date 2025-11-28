local str = ZhString.RoundReward_RoundTitle
autoImport("BaseRoundRewardView")
autoImport("ServantRoundRewardCell")
ServantRoundRewardView = class("ServantRoundRewardView", BaseRoundRewardView)

function ServantRoundRewardView:InitWrap()
  local container = self:FindGO("ItemContainer")
  local wrapConfig = {
    wrapObj = container,
    pfbNum = 6,
    cellName = "MiniROItemCell",
    control = ServantRoundRewardCell,
    dir = 1
  }
  self.listItem = WrapCellHelper.new(wrapConfig)
end

function ServantRoundRewardView:UpdateView()
  local data = ServantRecommendProxy.Instance:GetDailyKillTasks()
  if not data or not next(data) then
    return
  end
  local viewData = {}
  TableUtil.ArrayCopy(viewData, data)
  table.sort(viewData, function(l, r)
    return l.staticData.Sort < r.staticData.Sort
  end)
  local max = BattleTimeDataProxy.Instance:GetMaxRewardRound()
  local result = {}
  for i = 1, #viewData do
    if i <= max then
      local reward_data = {}
      reward_data[1] = i
      reward_data[2] = string.format(str, i)
      reward_data[3] = viewData[i]:GetRewards()
      reward_data[4] = self.tipStick
      table.insert(result, reward_data)
    end
  end
  self.listItem:UpdateInfo(result)
end
