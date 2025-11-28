GuildGVGRewardMsgView = class("GuildGVGRewardMsgView", BaseView)
GuildGVGRewardMsgView.ViewType = UIViewType.TipLayer

function GuildGVGRewardMsgView:Init()
  self.MsgLabel = self:FindComponent("MsgLabel", UILabel)
  self.MsgLabel.text = Table_Item[5543].Desc
  self.IconSprite = self:FindGO("IconSprite"):GetComponent(UISprite)
  IconManager:SetItemIcon("item_5543", self.IconSprite)
  local clickZone = self:FindGO("ClickZone")
  self:AddClickEvent(clickZone, function()
    self:CloseSelf()
  end)
end
