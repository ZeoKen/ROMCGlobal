ActivityFlipCardGridCell = class("ActivityFlipCardGridCell", BaseCell)

function ActivityFlipCardGridCell:Init()
  self:FindObjs()
end

function ActivityFlipCardGridCell:FindObjs()
  self:AddButtonEvent("bg", function()
    self:OnGridCellClick()
  end)
  self.icon = self:FindComponent("icon", UISprite)
  self.effectContainer = self:FindGO("effectContainer")
  self.notFlipIcon = self:FindGO("notflipicon")
end

function ActivityFlipCardGridCell:SetData(data)
  self.data = data
  if data then
    IconManager:SetItemIconById(data.itemId, self.icon)
    local grey = data.state == 0
    self.notFlipIcon:SetActive(grey)
    self.icon.gameObject:SetActive(not grey)
    if grey and ActivityFlipCardProxy.Instance:IsHaveFlipChance(data.act_id) then
      if not self.flipEffect then
        self.flipEffect = self:PlayUIEffect(EffectMap.UI.FlipCard_CanFlip, self.effectContainer)
      end
    else
      self:DestroyFlipEffect()
    end
  end
end

function ActivityFlipCardGridCell:OnGridCellClick()
  if self.data and self.data.state == 0 then
    if not ActivityFlipCardProxy.Instance:IsActivityAvailable(self.data.act_id) then
      MsgManager.ShowMsgByID(41346)
      self:PassEvent(ActivityFlipCardEvent_TimeOut)
      return
    end
    if ActivityFlipCardProxy.Instance:IsHaveFlipChance(self.data.act_id) then
      local grid = {}
      grid.row = self.data.row
      grid.column = self.data.column
      ServiceActivityCmdProxy.Instance:CallFlipCardGetRewardCmd(self.data.act_id, grid)
      self:DestroyFlipEffect()
      self:PlayUIEffect(EffectMap.UI.Activation, self.effectContainer, true)
    else
      local config = Table_Item[self.data.itemId]
      local name = config and config.NameZh or ""
      MsgManager.ShowMsgByID(43446, name)
    end
  end
end

function ActivityFlipCardGridCell:DestroyFlipEffect()
  if self.flipEffect then
    self.flipEffect:Destroy()
    self.flipEffect = nil
  end
end

function ActivityFlipCardGridCell:OnCellDestroy()
  self:DestroyFlipEffect()
end
