ActivityFlipCardLinkRewardCell = class("ActivityFlipCardLinkRewardCell", BaseCell)

function ActivityFlipCardLinkRewardCell:Init()
  self:FindObjs()
  self.tipData = {}
  self.tipData.funcConfig = {}
end

function ActivityFlipCardLinkRewardCell:FindObjs()
  self.bg = self:FindComponent("Bg", UISprite)
  self:AddButtonEvent("reward", function()
    if not self.data.state and self.data.curLink >= self.data.targetLink then
      if not ActivityFlipCardProxy.Instance:IsActivityAvailable(self.data.act_id) then
        MsgManager.ShowMsgByID(41346)
        self:PassEvent(ActivityFlipCardEvent_TimeOut)
        return
      end
      ServiceActivityCmdProxy.Instance:CallFlipCardGetRewardCmd(self.data.act_id, nil, self.id)
      self:DestroyRewardEffect()
    else
      self:ShowItemTip(self.tipData, self.icon, NGUIUtil.AnchorSide.Left, {-200, 0})
    end
  end)
  self.icon = self:FindComponent("icon", UISprite)
  self.num = self:FindComponent("num", UILabel)
  self.name = self:FindComponent("name", UILabel)
  self.progress = self:FindComponent("progress", UILabel)
  self.getBtn = self:FindGO("getBtn")
  self.getBtn:SetActive(false)
  self.check = self:FindGO("check")
  self:AddClickEvent(self.bg.gameObject, function()
    if not self.data.state and self.data.curLink >= self.data.targetLink then
      if not ActivityFlipCardProxy.Instance:IsActivityAvailable(self.data.act_id) then
        MsgManager.ShowMsgByID(41346)
        self:PassEvent(ActivityFlipCardEvent_TimeOut)
        return
      end
      ServiceActivityCmdProxy.Instance:CallFlipCardGetRewardCmd(self.data.act_id, nil, self.id)
      self:DestroyRewardEffect()
    end
  end)
  self.effectContainer = self:FindGO("effectContainer")
end

function ActivityFlipCardLinkRewardCell:SetData(data)
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
    local itemConfig = Table_Item[itemId]
    self.name.text = itemConfig.NameZh or ""
    local curLink = math.min(data.curLink, data.targetLink)
    self.progress.text = string.format(ZhString.FlipCard_CompleteLink, curLink, data.targetLink)
    self:SetState(data)
    self.tipData.itemdata = self.itemData
  end
end

function ActivityFlipCardLinkRewardCell:SetState(data)
  self.check:SetActive(data.state)
  local alpha = data.state and 0.5 or 1
  self.bg.alpha = alpha
  if not data.state and data.curLink >= data.targetLink then
    if not self.rewardEffect then
      self.rewardEffect = self:PlayUIEffect(EffectMap.UI.FlipCard_LinkReward, self.effectContainer)
    end
  else
    self:DestroyRewardEffect()
  end
end

function ActivityFlipCardLinkRewardCell:DestroyRewardEffect()
  if self.rewardEffect then
    self.rewardEffect:Destroy()
    self.rewardEffect = nil
  end
end
