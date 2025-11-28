PCSetView = class("PCSetView", ContainerView)
PCSetView.ViewType = UIViewType.NormalLayer

function PCSetView:Init()
  self:AddViewEvt()
  self:InitData()
  self:FindObj()
  self:AddButtonEvt()
end

function PCSetView:AddViewEvt()
end

function PCSetView:InitData()
end

function PCSetView:FindObj()
end

function PCSetView:AddButtonEvt()
  self:AddButtonEvent("SetViewBtn", function()
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.SetView
    })
  end)
  self:AddButtonEvent("HotKeyViewBtn", function()
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.PCHotKeySetView
    })
  end)
end
