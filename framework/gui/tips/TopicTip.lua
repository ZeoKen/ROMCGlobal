local _raidId = GameConfig.Topic.mapraidid
local _unlockColor = Color(0.7843137254901961, 0.5607843137254902, 0.1411764705882353, 1)
autoImport("BaseTip")
autoImport("ItemNewCell")
TopicTip = class("TopicTip", BaseTip)

function TopicTip:Init()
  self.closecomp = self.gameObject:GetComponent(CloseWhenClickOtherPlace)
  local grid = self:FindComponent("Grid", UIGrid)
  self.rewardCtl = UIGridListCtrl.new(grid, ItemNewCell, "MaterialItemNewCell")
  self.challengeBtn = self:FindComponent("ChallengeBtn", UIMultiSprite)
  self:AddClickEvent(self.challengeBtn.gameObject, function()
    self:DoChallenge()
  end)
  self.challengeLab = self:FindComponent("Label", UILabel, self.challengeBtn.gameObject)
  self.challengeLab.text = ZhString.Topic_Tip_Btn
  local _FixedLab = self:FindComponent("FixedLab", UILabel)
  _FixedLab.text = ZhString.Topic_Tip_Fixed
  _FixedLab = self:FindComponent("FixedLab2", UILabel)
  _FixedLab.text = ZhString.Topic_Tip_Fixed_Reward
  self.unlockTipLabel = self:FindComponent("UnlockTipLab", UILabel)
  self.headIcon = self:FindComponent("HeadIcon", UISprite)
  
  function self.closecomp.callBack(go)
    self:CloseSelf()
  end
end

function TopicTip:SetData(data)
  self.data = data
  if data.layerFinished then
    self:Hide(self.challengeBtn)
    self:Hide(self.unlockTipLabel)
  else
    self:Show(self.challengeBtn)
    self.canChallenge = not data.locked and data.isNext
    self.unlockTipLabel.gameObject:SetActive(not self.canChallenge)
    if not self.canChallenge then
      self.unlockTipLabel.text = data.index == 1 and ZhString.Topic_Tip_UnlockDesc_First or ZhString.Topic_Tip_UnlockDesc
    end
    self.challengeBtn.CurrentState = self.canChallenge and 0 or 1
    self.challengeLab.effectColor = self.canChallenge and _unlockColor or ColorUtil.NGUIGray
  end
  IconManager:SetNpcMonsterIconByID(data.staticData.Monster, self.headIcon)
  self:UpdateReward(data.staticData.Reward)
end

function TopicTip:UpdateReward(reward)
  local rewards = {}
  for i = 1, #reward do
    local item = ItemData.new("TopicReward", reward[i][1])
    item.num = reward[i][2]
    rewards[#rewards + 1] = item
  end
  self.rewardCtl:ResetDatas(rewards)
end

function TopicTip:DoChallenge()
  if not self.canChallenge then
    return
  end
  if TeamProxy.Instance:IHaveTeam() then
    MsgManager.ShowMsgByID(43160)
    return
  end
  ServiceFuBenCmdProxy.Instance:CallReqEnterTowerPrivate(_raidId)
  self:CloseSelf()
end

function TopicTip:CloseSelf()
  TipsView.Me():HideCurrent()
end

function TopicTip:DestroySelf()
  if not Slua.IsNull(self.gameObject) then
    GameObject.Destroy(self.gameObject)
  end
end

function TopicTip:OnExit()
  self.rewardCtl:RemoveAll()
  return TopicTip.super.OnExit(self)
end
