ActivityFlipCardGridRewardCell = class("ActivityFlipCardGridRewardCell", BaseCell)

function ActivityFlipCardGridRewardCell:Init()
  self:FindObjs()
  self.tipData = {}
  self.tipData.funcConfig = {}
end

function ActivityFlipCardGridRewardCell:FindObjs()
  self.check = self:FindGO("check")
  self.bg = self:FindComponent("bg", UISprite)
  self:AddClickEvent(self.bg.gameObject, function()
    self:OnCellClick()
  end)
  self.icon = self:FindComponent("icon", UISprite)
  self.num = self:FindComponent("num", UILabel)
  self.effectContainer = self:FindGO("effectContainer")
end

function ActivityFlipCardGridRewardCell:SetData(data)
  self.id = data.id
  self.data = data
  local staticData = Table_FlipCard[self.id]
  if staticData then
    local itemId = staticData.Reward and staticData.Reward[1]
    local itemNum = staticData.Reward and staticData.Reward[2]
    self.itemData = ItemData.new("Reward", itemId)
    self.itemData.num = itemNum
    IconManager:SetItemIconById(itemId, self.icon)
    self.num.text = 1 < itemNum and itemNum or ""
    self:SetState(data.state)
    self.tipData.itemdata = self.itemData
    if data.row then
      self.isCanReceive = ActivityFlipCardProxy.Instance:CheckIfLinkRowLine(data.act_id, data.row)
    elseif data.column then
      self.isCanReceive = ActivityFlipCardProxy.Instance:CheckIfLinkColumnLine(data.act_id, data.column)
    elseif data.isDiagonal then
      self.isCanReceive = ActivityFlipCardProxy.Instance:CheckIfLinkDiagonal(data.act_id)
    end
    if not data.state and self.isCanReceive then
      if not self.rewardEffect then
        self.rewardEffect = self:PlayUIEffect(EffectMap.UI.FlipCard_LinkReward, self.effectContainer)
      end
    else
      self:DestroyRewardEffect()
    end
  end
end

function ActivityFlipCardGridRewardCell:SetState(state)
  self.check:SetActive(state)
  local alpha = state and 0.5 or 1
  self.bg.alpha = alpha
end

function ActivityFlipCardGridRewardCell:OnCellClick()
  if not self.data.state then
    if self.isCanReceive then
      if not ActivityFlipCardProxy.Instance:IsActivityAvailable(self.data.act_id) then
        MsgManager.ShowMsgByID(41346)
        self:PassEvent(ActivityFlipCardEvent_TimeOut)
        return
      end
      self:DestroyRewardEffect()
      ServiceActivityCmdProxy.Instance:CallFlipCardGetRewardCmd(self.data.act_id, nil, self.id)
      self:PlayUIEffect(EffectMap.UI.Activation, self.effectContainer, true)
    else
      self:ShowItemTip(self.tipData, self.icon, NGUIUtil.AnchorSide.Right, {200, 0})
    end
  end
end

function ActivityFlipCardGridRewardCell:DestroyRewardEffect()
  if self.rewardEffect then
    self.rewardEffect:Destroy()
    self.rewardEffect = nil
  end
end

function ActivityFlipCardGridRewardCell:OnCellDestroy()
  self:DestroyRewardEffect()
end
