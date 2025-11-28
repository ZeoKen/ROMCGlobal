local baseCell = autoImport("BaseCell")
GLandPersonalRankCell = class("GLandPersonalRankCell", BaseCell)
autoImport("RewardGridCell")

function GLandPersonalRankCell:Init()
  self:FindObjs()
  self:AddCellClickEvent()
end

function GLandPersonalRankCell:FindObjs()
  self.rankIcon = self:FindGO("RankIcon"):GetComponent(UISprite)
  self.rankScore = self:FindGO("RankScore"):GetComponent(UILabel)
  self.commonNode = self:FindGO("CommonNode"):GetComponent(UIMultiSprite)
  local rewardGO = self:FindGO("RewardGridCell")
  self.rewardCell = RewardGridCell.new(rewardGO)
  self.effectContainer = self:FindGO("EffectContainer")
end

function GLandPersonalRankCell:SetData(data)
  self.data = data
  local id = data.id
  local staticData = Table_GuildGvgProgressReward[id]
  local excellent = data.Excellent
  self.rankScore.text = excellent
  if self.indexInList == 1 then
    self.rankIcon.gameObject:SetActive(true)
    self.rankIcon.spriteName = "guildwar_icon_01"
  elseif staticData.Rank then
    self.rankIcon.gameObject:SetActive(true)
    self.rankIcon.spriteName = "guildwar_icon_0" .. staticData.Rank
  else
    self.rankIcon.gameObject:SetActive(false)
  end
  if staticData and staticData.Reward then
    local rewards = ItemUtil.GetRewardItemIdsByTeamId(staticData.Reward) or {}
    if rewards and 0 < #rewards then
      local itemData = ItemData.new("Reward", rewards[1].id)
      itemData:SetItemNum(rewards[1].num)
      local tempData = {
        itemData = itemData,
        num = rewards[1].num
      }
      self.rewardCell:SetData(tempData)
    else
      self.rewardCell:Hide()
    end
  else
    self.rewardCell:Hide()
  end
end

function GLandPersonalRankCell:SetRewarded(bool)
  self.rewarded = bool
  self.rewardCell:SetFinishStatus(bool)
end

function GLandPersonalRankCell:SetReachProcess(bool)
  self.commonNode.CurrentState = bool and 1 or 0
end

function GLandPersonalRankCell:SetCanRecv(bool)
  self.rewardCell:SetChooseStatus(bool)
end

function GLandPersonalRankCell:handleClickReward(cellCtrl)
  if cellCtrl then
    self:PassEvent(MouseEvent.DoubleClick, cellCtrl)
  end
end

function GLandPersonalRankCell:PlayAchieveEffect()
  if self.rankIcon.gameObject.activeSelf then
    self:PlayUIEffect(EffectMap.UI.GLandChallenge_ReachRank, self.effectContainer)
  end
end
