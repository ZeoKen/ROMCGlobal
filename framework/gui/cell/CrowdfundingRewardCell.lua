CrowdfundingRewardCell = class("CrowdfundingRewardCell", CoreView)
local actIns

function CrowdfundingRewardCell:ctor(obj)
  if not actIns then
    actIns = CrowdfundingActProxy.Instance
  end
  CrowdfundingRewardCell.super.ctor(self, obj)
  self:Init()
end

function CrowdfundingRewardCell:Init()
  self.percent = self:FindComponent("Percent", UILabel)
  self.icon = self:FindComponent("ItemIcon", UISprite)
  self.numLabel = self:FindComponent("NumLabel", UILabel)
  self.activate = self:FindGO("Activate")
  self.cleared = self:FindGO("Cleared")
  self.awarded = self:FindGO("Awarded")
  self.effContainer = self:FindGO("EffContainer")
  local item = self:FindGO("Item")
  self:AddClickEvent(item, function()
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
end

function CrowdfundingRewardCell:SetData(data)
  self.data = data
  local flag = data ~= nil
  self.gameObject:SetActive(flag)
  if not flag then
    return
  end
  self.percent.text = string.format("%s%%", self.data.processpct)
  self:SetReward(self.data.RewardId)
  self:UpdateId()
  self:UpdateActivate()
  self:UpdateCleared()
  self:UpdateAwarded()
end

function CrowdfundingRewardCell:SetReward(rewardId)
  self.rewardItemId = nil
  local items, rewardIconName, num = ItemUtil.GetRewardItemIdsByTeamId(rewardId), "item_45001", ""
  if items and items[1] then
    local single = items[1]
    if Table_Item[single.id] then
      self.rewardItemId = single.id
      rewardIconName = Table_Item[self.rewardItemId].Icon
    end
    num = tostring(single.num)
  end
  IconManager:SetItemIcon(rewardIconName, self.icon)
  self.numLabel.text = num
end

function CrowdfundingRewardCell:UpdateId()
  self.id = nil
  local cfg = self:GetRewardConfig()
  for id, data in pairs(cfg) do
    if data.processpct == self.data.processpct then
      self.id = id
      break
    end
  end
  if not self.id then
    LogUtility.Warning("Cannot get id of globalreward. There must be sth wrong with config.")
  end
end

function CrowdfundingRewardCell:UpdateActivate()
  local map = actIns:GetNowAvailableRewardIdMap(true)
  local isShow = self.id ~= nil and map[self.id] == true
  self.activate:SetActive(isShow)
  if isShow and not self.activateEff then
    self:PlayUIEffect(EffectMap.UI.SignIn21Hint, self.effContainer, false, function(obj, args, assetEffect)
      self.activateEff = assetEffect
    end)
  elseif not isShow and self.activateEff then
    self.activateEff:Destroy()
    self.activateEff = nil
  end
end

function CrowdfundingRewardCell:UpdateCleared()
  self.cleared:SetActive(actIns:GetGlobalProgress() >= self.data.processpct)
end

function CrowdfundingRewardCell:UpdateAwarded()
  local map = actIns:GetInfo("globalAwardedIdMap")
  self.awarded:SetActive(map ~= nil and map[self.id] == true)
end

function CrowdfundingRewardCell:GetRewardConfig()
  return GameConfig.DonationActivity[actIns.showingActId].globalreward
end
