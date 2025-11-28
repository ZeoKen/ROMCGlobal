autoImport("QueueBaseCell")
RollRewardCell = class("RollRewardCell", QueueBaseCell)
RollRewardCell.resID = ResourcePathHelper.UICell("RollRewardCell")

function RollRewardCell:ctor(parent, data)
  self.parent = parent
  self.data = data
  self.cfg = GameConfig.RollRaid
end

function RollRewardCell:Enter()
  if self.gameObject then
    return
  end
  self.gameObject = self:CreateObj(RollRewardCell.resID, self.parent)
  self.titleLabel = self:FindComponent("Title", UILabel)
  self.countLeftLabel = self:FindComponent("CountLeft", UILabel)
  self.timeSlider = self:FindComponent("TimeSlider", UISlider)
  self.cost = SpriteLabel.new(self:FindGO("Cost"), nil, nil, nil, true)
  self.foldedCountGO = self:FindGO("FoldedCount")
  self.foldedCountLabel = self:FindComponent("Label", UILabel, self.foldedCountGO)
  local rewardIcon = self:FindComponent("RewardIcon", UISprite)
  IconManager:SetItemIcon("item_3838", rewardIcon)
  self.rollBtn = self:FindGO("RollBtn")
  local rollSprite = self:FindComponent("Sprite", UISprite, self.rollBtn)
  local atlas = RO.AtlasMap.GetAtlas("NewCom")
  if atlas then
    rollSprite.atlas = atlas
    rollSprite.spriteName = "com_icon_check"
    rollSprite:MakePixelPerfect()
  end
  self:AddClickEvent(self.rollBtn, function()
    if not self.data then
      return
    end
    if DungeonProxy.GetRestRollTimes(self.data) <= 0 then
      MsgManager.FloatMsg(nil, ZhString.RollReward_LackingRollTimes)
      return
    end
    local myCount, needCount = DungeonProxy.GetMyRollCoinCount(), self.data.coinCost
    local deltaCount = needCount - myCount
    if 0 < deltaCount then
      DungeonProxy.SetMyRollNeedCatB(deltaCount)
    else
      DungeonProxy.SetMyRollNeedCatB(nil)
    end
    ServiceFuBenCmdProxy.Instance:CallPreReplyRollRewardFubenCmd(Game.Myself.data.id, self.data.type, self.data.param)
    self:TryNext()
  end)
  self:AddButtonEvent("CancelBtn", function()
    self:GiveUp()
  end)
  self:SetData(self.data)
end

function RollRewardCell:SetData(data)
  if not data then
    return
  end
  self.data = data
  self.titleLabel.text = DungeonProxy.GetRollRaidDesc(data)
  self:UpdateRestRollTimes()
  self:UpdateRollCoin()
  self:UpdateFolded()
  self:UpdateTime(self.cfg.roll_duringtime)
end

function RollRewardCell:UpdateRestRollTimes()
  self.countLeftLabel.text = string.format(ZhString.RollReward_CountLeftFormat, DungeonProxy.GetRestRollTimes(self.data), DungeonProxy.GetTotalRollTimes(self.data))
end

function RollRewardCell:UpdateRollCoin()
  self.cost:Reset()
  local myCount, needCount = DungeonProxy.GetMyRollCoinCount(), self.data and self.data.coinCost or math.huge
  TimeTickManager.Me():CreateOnceDelayTick(40, function()
    if not self.cost then
      return
    end
    local content
    if myCount >= needCount then
      self.rollBtn:SetActive(true)
      content = string.format(ZhString.RollReward_CostFormat, needCount, self.cfg.roll_coin_itemid, myCount)
    elseif BranchMgr.IsJapan() or MyselfProxy.Instance:GetLottery() < needCount - myCount then
      self.rollBtn:SetActive(false)
      content = string.format(ZhString.RollReward_CatBCost_Japan, self.cfg.roll_coin_itemid)
    else
      self.rollBtn:SetActive(true)
      content = string.format(ZhString.RollReward_CatBCost, self.cfg.roll_coin_itemid, 151, needCount - myCount)
    end
    self.cost:SetText(content)
  end, self)
end

function RollRewardCell:UpdateFolded()
  local restInvCount = DungeonProxy.Instance:GetRestRewardInvitationCount()
  self.foldedCountGO:SetActive(1 < restInvCount)
  self.foldedCountLabel.text = restInvCount
end

function RollRewardCell:UpdateTime(totalTime)
  LeanTween.cancel(self.timeSlider.gameObject)
  if not totalTime then
    self.timeSlider.gameObject:SetActive(false)
    return
  end
  self.timeSlider.gameObject:SetActive(true)
  LeanTween.sliderNGUI(self.timeSlider, 1, 0, totalTime):setOnComplete(function()
    self:PassEvent(InviteConfirmEvent.RollInviteTimeOver, self)
    self:GiveUp()
  end)
end

function RollRewardCell:TryNext()
  local ins = DungeonProxy.Instance
  ins:PopRollRewardInvitation()
  if ins:GetRestRewardInvitationCount() <= 0 then
    self:Exit()
    return
  end
  self:SetData(ins:PeekRollRewardInvitation())
end

function RollRewardCell:GiveUp()
  if self.data then
    ServiceFuBenCmdProxy.Instance:CallReplyRollRewardFubenCmd(false, self.data.type, self.data.param)
  end
  self:TryNext()
end

function RollRewardCell:Exit()
  LeanTween.cancel(self.timeSlider.gameObject)
  Game.GOLuaPoolManager:AddToUIPool(RollRewardCell.resID, self.gameObject)
  self.gameObject = nil
  TimeTickManager.Me():ClearTick(self)
  RollRewardCell.super.Exit(self)
end
