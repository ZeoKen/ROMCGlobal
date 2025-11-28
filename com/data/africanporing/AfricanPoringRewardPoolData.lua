autoImport("AfricanPoringRewardData")
AfricanPoringRewardPoolData = class("AfricanPoringRewardPoolData")

function AfricanPoringRewardPoolData:ctor(serverData)
  self:SetStaticData(serverData.groupid, serverData.pos)
  self:SetServerData(serverData)
end

function AfricanPoringRewardPoolData:SetStaticData(groupId, pos)
  local groupConfig = Game.AfricanPoringPosConfig[groupId]
  if not groupConfig then
    return
  end
  local staticData = groupConfig[pos]
  self.staticData = staticData
  if staticData then
    self.extraRewardItem = AfricanPoringRewardData.new({
      id = 0,
      GroupId = groupId,
      Pos = pos,
      ItemID = staticData.ReplaceItemID,
      ItemNum = staticData.ReplaceItemNum
    })
  else
    self.extraRewardItem = nil
  end
end

function AfricanPoringRewardPoolData:SetServerData(serverData)
  if not serverData then
    return
  end
  self.rewardItemRefs = {}
  self.pos = serverData.pos
  self.status = serverData.status
  self.curRewardId = serverData.curreward
end

function AfricanPoringRewardPoolData:GetWeight()
  return self.staticData and self.staticData.Weight or 0
end

function AfricanPoringRewardPoolData:UpdateServerData(serverData)
  if self.pos == serverData.pos then
    self.status = serverData.status
    self.curRewardId = serverData.curreward
  end
end

function AfricanPoringRewardPoolData:RevealSelectedReward(b)
  if b then
    if self.curRewardId and self.curRewardId > 0 then
      self.selectedReward = self:GetRewardItemById(self.curRewardId)
    else
      self.selectedReward = self.extraRewardItem
    end
  else
    self.selectedReward = nil
  end
end

function AfricanPoringRewardPoolData:GetSelectedRewardId()
  return self.selectedReward and self.selectedReward.itemId
end

function AfricanPoringRewardPoolData:IsPoolHit()
  return self.status == SceneItem_pb.EAFRICANPORINGPOSSTATUS_DRAW
end

function AfricanPoringRewardPoolData:HasAllRewardOwned()
  local allOwned = true
  if self.rewardItemRefs then
    for _, item in ipairs(self.rewardItemRefs) do
      if not item.owned then
        allOwned = false
        break
      end
    end
  else
    allOwned = false
  end
  return allOwned
end

function AfricanPoringRewardPoolData:AddRewardItem(item)
  if not self:GetRewardItemById(item.id) then
    table.insert(self.rewardItemRefs, item)
  end
end

function AfricanPoringRewardPoolData:ClearRewardItems()
  self.rewardItemRefs = {}
end

function AfricanPoringRewardPoolData:GetRewardItems()
  return self.rewardItemRefs or {}
end

function AfricanPoringRewardPoolData:GetRewardItemById(id)
  if self.rewardItemRefs then
    for _, item in ipairs(self.rewardItemRefs) do
      if item.id == id then
        return item
      end
    end
  end
end

function AfricanPoringRewardPoolData:SetProbability(probability)
  self.probability = probability
  if self.rewardItemRefs then
    for _, item in ipairs(self.rewardItemRefs) do
      item.probability = probability
    end
  end
end
