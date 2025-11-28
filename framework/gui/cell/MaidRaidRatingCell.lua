autoImport("BaseCell")
autoImport("ColliderItemCell")
MaidRaidRatingCell = class("MaidRaidRatingCell", BaseCell)
local RewardStatus = {CanGet = 0, Get = 1}
local raidConfig = GameConfig.JanuaryRaid
local ratinglist = raidConfig.kill_rank_desc

function MaidRaidRatingCell:Init()
  self.medal = self:FindGO("medal"):GetComponent(UIMultiSprite)
  self.title = self:FindGO("title"):GetComponent(UILabel)
  self.rewardItem = self:FindGO("rewardItem"):GetComponent(UIButton)
  self.receiveLabel = self:FindGO("receiveLabel"):GetComponent(UILabel)
  self.score = self:FindGO("completeTime"):GetComponent(UILabel)
  self.rewardsp = self:FindGO("buttonsp"):GetComponent(UISprite)
  self:AddEvent()
end

function MaidRaidRatingCell:AddEvent()
  self:AddButtonEvent("rewardItem", function(obj)
    if self.status and self.status == RewardStatus.CanGet then
      ServiceFuBenCmdProxy.Instance:CallKumamotoOperFubenCmd(FuBenCmd_pb.EKUMAMOTOOPER_REWARD, self.id)
      return
    end
    self:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.RatingRewardPreview,
      viewdata = ratinglist[self.id]
    })
  end)
end

function MaidRaidRatingCell:SetData(data)
  if data then
    self.id = data.id
    self.medal.CurrentState = data.id - 1
    self.rewardid = data.reward
    local myreward = MyselfProxy.Instance:GetAccVarValueByType(Var_pb.EACCVARTYPE_JANUARY_SCORE) or 0
    self.status = DungeonProxy.Instance:GetJanuaryFubenRate(self.id)
    helplog("MaidRaidRatingCell", rewardStatus)
    self.title.text = data.title
    self.score.text = string.format(ZhString.IPRaidBord_CellScore, data.score)
    if self:GetMyRate() ~= 0 and self:GetMyRate() <= self.id then
      if self.status == 0 then
        self.status = RewardStatus.CanGet
      else
        self.status = RewardStatus.Get
      end
    else
      self.status = nil
    end
    IconManager:SetItemIcon(data.rewardicon, self.rewardsp)
    if not self.status then
      self.rewardItem.enabled = true
      self.rewardItem.gameObject:SetActive(true)
      self.receiveLabel.gameObject:SetActive(false)
      self.rewardsp.color = Color(0.00392156862745098, 0.00784313725490196, 0.011764705882352941)
    elseif self.status == RewardStatus.Get then
      self.rewardItem.gameObject:SetActive(false)
      self.receiveLabel.text = ZhString.EVA_ReceivedReward
      self.receiveLabel.gameObject:SetActive(true)
      self.rewardsp.color = Color(1, 1, 1)
    elseif self.status == RewardStatus.CanGet then
      self.rewardItem.enabled = true
      self.rewardItem.gameObject:SetActive(true)
      self.receiveLabel.gameObject:SetActive(false)
      self.rewardsp.color = Color(1, 1, 1)
    elseif self.status == RewardStatus.None then
      self.rewardItem.enabled = true
      self.rewardItem.gameObject:SetActive(true)
      self.receiveLabel.gameObject:SetActive(false)
      self.rewardsp.color = Color(1, 1, 1)
    end
  end
end

function MaidRaidRatingCell:ClickItem(cell)
  local data = cell.data
  if data == nil then
    self:ShowItemTip()
    return
  end
  local sdata = {
    itemdata = data,
    funcConfig = {},
    ignoreBounds = ignoreBounds,
    hideGetPath = true
  }
  self:ShowItemTip(sdata, self.tipstick, NGUIUtil.AnchorSide.Left, {-212, 0})
end

function MaidRaidRatingCell:GetMyRate()
  local myscore = MyselfProxy.Instance:GetAccVarValueByType(Var_pb.EACCVARTYPE_JANUARY_SCORE) or 0
  for i = 1, #ratinglist do
    local single = ratinglist[i]
    if myscore >= single.score then
      return single.id
    end
  end
  return 0
end
