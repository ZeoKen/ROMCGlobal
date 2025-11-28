RaidPuzzleProxy = class("RaidPuzzleProxy", pm.Proxy)
RaidPuzzleProxy.Instance = nil
RaidPuzzleProxy.NAME = "RaidPuzzleProxy"
local normalBoxId = 817508
local luxuryBoxId = 817507

function RaidPuzzleProxy:ctor(proxyName, data)
  self.proxyName = proxyName or RaidPuzzleProxy.NAME
  if RaidPuzzleProxy.Instance == nil then
    RaidPuzzleProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:Init()
end

function RaidPuzzleProxy:Init()
  self.raidPuzzleRewards = {}
  self.raidInfo = {}
  self:InitRewards()
end

function RaidPuzzleProxy:RecvQueryRaidPuzzleListRaidCmd(data)
  local raidData = data.data
  local raidid = raidData.raidid
  if not self.raidInfo[raidData.raidid] then
    self.raidInfo[raidData.raidid] = {}
  end
  local curGetBoxes = raidData.rewardboxs
  if self.raidPuzzleRewards[raidData.raidid] then
    local raidRewardIds = self.raidPuzzleRewards[raidData.raidid]
    local boxes = {}
    if curGetBoxes and 0 < #curGetBoxes then
      for i = 1, #raidRewardIds do
        if TableUtility.ArrayFindIndex(curGetBoxes, raidRewardIds[i]) == 0 then
          table.insert(boxes, raidRewardIds[i])
        end
      end
    else
      for i = 1, #raidRewardIds do
        table.insert(boxes, raidRewardIds[i])
      end
    end
    self.raidInfo[raidid].leftBoxes = boxes
    if curGetBoxes and 0 < #curGetBoxes then
      local curBoxes = {}
      for i = 1, #curGetBoxes do
        table.insert(curBoxes, curGetBoxes[i])
      end
      self.raidInfo[raidid].curBoxes = curBoxes
    end
    local luxuryBoxNum = 0
    local normalBoxNum = 0
    for i = 1, #raidRewardIds do
      if Table_RaidPushAreaObj[raidid][raidRewardIds[i]].NpcID == luxuryBoxId then
        luxuryBoxNum = luxuryBoxNum + 1
      elseif Table_RaidPushAreaObj[raidid][raidRewardIds[i]].NpcID == normalBoxId then
        normalBoxNum = normalBoxNum + 1
      end
    end
    self.raidInfo[raidid].luxuryBoxMax = luxuryBoxNum
    self.raidInfo[raidid].normalBoxMax = normalBoxNum
    if #curGetBoxes >= luxuryBoxNum + normalBoxNum then
      self.raidInfo[raidid].allClear = true
    else
      self.raidInfo[raidid].allClear = false
    end
    self.raidInfo[raidid].status = raidData.status
  else
    redlog("当前副本总奖励列表缺失", raidData.raidid)
  end
end

function RaidPuzzleProxy:ClearRaidPuzzleListRaidInfo()
end

function RaidPuzzleProxy:SetRaidPuzzleTarget(data)
  if data.data then
    self.puzzleRaidTarget = data.data
    helplog("当前进度目标：", self.puzzleRaidTarget)
  else
    redlog("副本目标数据中不含有字符串数据data")
  end
end

function RaidPuzzleProxy:SetRaidBox(data)
  if data.values then
    local str = ""
    for i = 1, #data.values do
      str = str .. data.values[i] .. ","
    end
    helplog("设置副本已领取宝箱ID", str)
    local boxes = data.values
    local rewardList = {}
    local boxList = {}
    if boxes and #boxes then
      for i = 1, #boxes do
        table.insert(boxList, boxes[i])
      end
    end
    self.puzzleRaidBoxes = boxList
    self.puzzleRaidRewards = rewardList
  else
    redlog("副本宝箱数据中不含有数组数据values")
  end
end

function RaidPuzzleProxy:SetRaidDesc(data)
  if data.datas then
    local str = ""
    for i = 1, #data.datas do
      str = str .. data.datas[i] .. ","
    end
    helplog("设置副本已解锁信息", str)
    local descs = {}
    for i = 1, #data.datas do
      table.insert(descs, data.datas[i])
    end
    self.puzzleRaidDescs = descs
  else
    redlog("副本信息数据中不含有字符串数组datas")
  end
end

function RaidPuzzleProxy:SetRaidBuffs(data)
  if data.values then
    local str = ""
    for i = 1, #data.values do
      str = str .. data.values[i] .. ","
    end
    helplog("设置副本已获取buff", str)
    local buffs = {}
    for i = 1, #data.values do
      table.insert(buffs, data.values[i])
    end
    self.puzzleRaidBuffs = buffs
  else
    redlog("副本buff信息数据中不含有数组values")
  end
end

function RaidPuzzleProxy:SetRaidTorchPuzzle(data)
  if data.values then
    local str = ""
    for i = 1, #data.values do
      str = str .. data.values[i] .. ","
    end
    helplog("设置副本点火顺序答案", str)
    local torchTarget = {}
    for i = 1, #data.values do
      table.insert(torchTarget, data.values[i])
    end
    self.puzzleRaidTorches = torchTarget
  else
    redlog("副本点火顺序信息数据中不含有数组values")
  end
end

function RaidPuzzleProxy:InitRewards()
  for k, v in pairs(Table_RaidPushAreaObj) do
    if not self.raidPuzzleRewards[k] then
      self.raidPuzzleRewards[k] = {}
      for m, n in pairs(v) do
        local single = n
        if single.RewardId and single.RewardId ~= 0 then
          table.insert(self.raidPuzzleRewards[k], single.id)
        end
      end
    end
  end
end
