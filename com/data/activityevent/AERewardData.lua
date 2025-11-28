autoImport("AERewardInfoData")
AERewardData = class("AERewardData")
AERewardData.DebugString = {
  "研究所",
  "看板",
  "裂隙",
  "工会捐赠",
  "无限塔",
  "公会副本",
  "公会道场",
  "pve卡牌",
  "经验副本",
  "团本",
  "12PVP",
  "克魔岛副本",
  "七王室6人副本",
  "新GVG个人奖励",
  "新GVG公会奖励",
  "装备升级副本"
}

function AERewardData:ctor()
  self.rewardMap = {}
end

function AERewardData:SetReward(data)
  if data ~= nil then
    local rewardData = data.reward
    for i = 1, #rewardData do
      local mode = rewardData[i].mode
      local logStr = ""
      logStr = "AERewardData  --> "
      local dateFormat = "%m月%d日%H点%M分%S秒"
      local modeStr = AERewardData.DebugString[mode]
      logStr = logStr .. string.format(" | 功能:%s | 开始时间:%s | 结束时间:%s | 当前时间:%s | 奖励倍数：%s", tostring(modeStr), os.date(dateFormat, data.begintime), os.date(dateFormat, data.endtime), os.date(dateFormat, ServerTime.CurServerTime() / 1000), tostring(rewardData[i].multiplereward.multiple))
      helplog(logStr)
      if not self.rewardMap[mode] then
        self.rewardMap[mode] = {}
      end
      local single = AERewardInfoData.new(rewardData[i], data.begintime, data.endtime)
      table.insert(self.rewardMap[mode], single)
    end
  end
end

function AERewardData:GetRewardByType(type)
  if self.rewardMap[type] then
    for k, v in pairs(self.rewardMap[type]) do
      if v:IsInActivity() then
        return v
      end
    end
  end
  return nil
end
