LoadingThanatosView = class("LoadingThanatosView", SubView)

function LoadingThanatosView:Init()
  self.gameObject = self:FindGO("LoadingViewThanatos")
  self.data = self.viewdata.viewdata and self.viewdata.viewdata or 1
  self.effectContainer = self:FindGO("effectContainer", self.gameObject)
  self:PlayUIEffect(EffectMap.UI.Eff_tuanben3_loading, self.effectContainer)
end

function LoadingThanatosView:OnEnter()
  Game.AssetManager_Role:SetForceLoadAll(true)
  LoadingThanatosView.super.OnEnter(self)
end

function LoadingThanatosView:OnExit()
  Game.AssetManager_Role:SetForceLoadAll(false)
  LoadingThanatosView.super.OnExit(self)
end

function LoadingThanatosView:ServerReceiveLoadedHandler(note)
end

function LoadingThanatosView:SceneFadeOut(note)
  self.effectContainer:SetActive(true)
  self.container:DoFadeOut(0.5)
end

function LoadingThanatosView:SceneFadeInFinish()
  self.container:CloseSelf()
end

function LoadingThanatosView:LoadFinish()
  self.effectContainer:SetActive(false)
  self.container:FireLoadFinishEvent()
  self.container:DoFadeIn(0.5)
end

function LoadingThanatosView:SceneFadeOutFinish()
end

function LoadingThanatosView:StartLoadScene(note)
end

function LoadingThanatosView:Update(delta)
end
