ColliderView = class("ColliderView", BaseView)
ColliderView.ViewType = UIViewType.VideoLayer

function ColliderView:Init()
  self:AddListenEvt(UIEvent.CloseUI, self.CloseUI)
  self:InitView()
end

function ColliderView:InitView()
  self.sprite = self:FindComponent("Sprite", UISprite)
  self.color = self.viewdata.viewdata or Color(0, 0, 0, 0.00392156862745098)
  self.sprite.color = self.color
end

function ColliderView:CloseUI(note)
  if note and note.body then
    local viewConfig = note.body.view
    if viewConfig == PanelConfig.ColliderView then
      self:CloseSelf()
    end
  end
end
