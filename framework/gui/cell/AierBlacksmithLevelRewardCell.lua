local baseCell = autoImport("BaseCell")
AierBlacksmithLevelRewardCell = class("AierBlacksmithLevelRewardCell", baseCell)
local tempVector3 = LuaVector3.Zero()

function AierBlacksmithLevelRewardCell:Init()
  self:FindObjs()
  self:AddCellClickEvent()
end

function AierBlacksmithLevelRewardCell:FindObjs()
  self.iconSp = self:FindComponent("icon", UISprite)
  self.countLb = self:FindComponent("count", UILabel)
  self.levelLb = self:FindComponent("level", UILabel)
  self.getMark = self:FindGO("getMark")
  self.lockMark = self:FindGO("lockMark")
  self.effectContainer = self:FindGO("effectContainer")
end

function AierBlacksmithLevelRewardCell:SetData(data)
  self.data = data
  if data == nil then
    self:Hide()
    return
  end
  self:Show()
  local level = data.Level
  local achieved = level <= AierBlacksmithProxy.Instance.proxyData.reward_level
  local reward = data.Reward
  if type(reward) == "table" then
    reward = reward[1]
  end
  reward = ItemUtil.GetRewardItemIdsByTeamId(reward) or ItemUtil.GetRewardItemIdsByTeamId(6122)
  reward = reward[1]
  self.itemid = reward.id
  local cfg = Table_Item[reward.id]
  local str = cfg.Icon
  local setSuc = IconManager:SetItemIcon(str, self.iconSp)
  setSuc = setSuc or IconManager:SetItemIcon("item_45001", self.iconSp)
  self.countLb.text = reward.num
  self.lockMark:SetActive(not achieved)
  self.getMark:SetActive(achieved)
  self.levelLb.text = level
  self.achieved = achieved
  self.sortOrder = 0
  local important = data.important == 1
end

function AierBlacksmithLevelRewardCell:CheckIsFinish()
  return self.achieved
end
