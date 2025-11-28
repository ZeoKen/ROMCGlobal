autoImport("BaseCell")
autoImport("ColliderItemCell")
KumamotoRatingCell = class("KumamotoRatingCell", BaseCell)
local RewardStatus = {CanGet = 0, Get = 1}
local EvaConfig = GameConfig.KumamotoBear
local ratinglist = EvaConfig.kill_rank_desc

function KumamotoRatingCell:Init()
  self.medal = self:FindGO("medal"):GetComponent(UIMultiSprite)
  self.title = self:FindGO("title"):GetComponent(UILabel)
  self.rewardItem = self:FindGO("rewardItem"):GetComponent(UIButton)
  self.receiveLabel = self:FindGO("receiveLabel"):GetComponent(UILabel)
  self.score = self:FindGO("completeTime"):GetComponent(UILabel)
  self.rewardsp = self:FindGO("buttonsp"):GetComponent(UISprite)
  self.spriteTweenRot = self:FindGO("buttonsp"):GetComponent(TweenRotation)
  self.redtip = self:FindGO("RedTipCell")
  self:AddEvent()
end

function KumamotoRatingCell:AddEvent()
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

function KumamotoRatingCell:SetData(data)
  if data then
    self.id = data.id
    self.medal.CurrentState = data.id - 1
    self.rewardid = data.reward
    local myreward = MyselfProxy.Instance:GetAccVarValueByType(Var_pb.EACCVARTYPE_KUMAMOTO_REWARD) or 0
    self.status = BitUtil.band(myreward, self.id)
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
    if self.status == RewardStatus.CanGet then
      self.redtip:SetActive(true)
      self.spriteTweenRot.enabled = true
    else
      self.redtip:SetActive(false)
      self.spriteTweenRot.enabled = false
    end
  end
end

function KumamotoRatingCell:ClickItem(cell)
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

function KumamotoRatingCell:GetMyRate()
  local myscore = MyselfProxy.Instance:GetAccVarValueByType(Var_pb.EACCVARTYPE_KUMAMOTO_SCORE) or 0
  for i = 1, #ratinglist do
    local single = ratinglist[i]
    if myscore >= single.score then
      return single.id
    end
  end
  return 0
end
