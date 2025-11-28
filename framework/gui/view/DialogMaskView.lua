DialogMaskView = class("WeakDialogView", BaseView)
DialogMaskView.ViewType = UIViewType.DialogMaskLayer

function DialogMaskView:Init()
  self.mask = self:FindGO("mask"):GetComponent(UISprite)
  self:AddListenEvt(ServiceEvent.SceneGoToUserCmd, self.HandleClose)
  self:AddListenEvt(ServiceEvent.PlayerMapChange, self.HandleClose)
end

function DialogMaskView:OnEnter()
  self.mask.height = Screen.height * 2
  self.mask.width = Screen.width * 2
end

function DialogMaskView:OnExit()
end

function DialogMaskView:HandleClose(note)
  self:CloseSelf()
end
