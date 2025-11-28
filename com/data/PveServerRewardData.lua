autoImport("PveDropItemData")
PveServerRewardData = class("PveServerRewardData")

function PveServerRewardData:ctor(serverdata)
  self.rewards = {}
  self.showtype = serverdata.showtype
  self:SetData(serverdata)
end

function PveServerRewardData:SetData(serverdata)
  self:_setItemInfo(serverdata.item)
  self:_setRewards(serverdata.rewardids)
end

function PveServerRewardData:_setItemInfo(itemInfo)
  if itemInfo and itemInfo.id and itemInfo.id > 0 then
    local item = PveDropItemData.new("PveDropReward", itemInfo.id)
    item.num = itemInfo.count or 1
    item:SetType(self.showtype)
    self.rewards[#self.rewards + 1] = item
  end
end

local rewardTeamids, rate

function PveServerRewardData:_setRewards(rewardids)
  if rewardids and 0 < rewardids then
    rewardTeamids = ItemUtil.GetRewardItemIdsByTeamId(rewardids)
    if rewardTeamids then
      for _, data in pairs(rewardTeamids) do
        local item = PveDropItemData.new("PveDropReward", data.id)
        item.num = data.num
        item:SetType(self.showtype)
        if BranchMgr.IsJapan() then
          rate = data.jp_rate
        else
          rate = data.rate
        end
        if rate then
          item:SetRate(rate)
        end
        item:SetRange(data.minnum, data.maxnum)
        self.rewards[#self.rewards + 1] = item
      end
    end
  end
end

function PveServerRewardData:GetRewards()
  return self.rewards
end
