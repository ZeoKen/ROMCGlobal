CameraSelectView = class("CameraSelectView", ContainerView)
CameraSelectView.ViewType = UIViewType.PerformanceLayer

function CameraSelectView.CanShow()
  return FunctionPerformanceSetting.Me():GetSetting().isFirstTimeInstall
end

function CameraSelectView:Init()
  self:FindObjs()
  self:AddEvts()
end

function CameraSelectView:FindObjs()
  self.cameraTog_1 = self:FindComponent("Toggle1", UIToggle)
  self.cameraTog_2 = self:FindComponent("Toggle2", UIToggle)
  self.cameraTog_3 = self:FindComponent("Toggle3", UIToggle)
  self.texture1 = self:FindGO("Texture1"):GetComponent(UITexture)
  self.texture2 = self:FindGO("Texture2"):GetComponent(UITexture)
  self.texture3 = self:FindGO("Texture3"):GetComponent(UITexture)
  self.texturePath1 = "Lens_pic_3d"
  self.texturePath2 = "Lens_pic_2-5d"
  self.texturePath3 = "Lens_pic_suoding"
  PictureManager.Instance:SetUI(self.texturePath1, self.texture1)
  PictureManager.Instance:SetUI(self.texturePath2, self.texture2)
  PictureManager.Instance:SetUI(self.texturePath3, self.texture3)
  self.confirmBtn = self:FindGO("ConfirmButton")
  self.togSelect = 1
  self.cameraTog_1.value = true
end

function CameraSelectView:AddEvts()
  self:AddClickEvent(self.cameraTog_1.gameObject, function()
    self.togSelect = 1
    self.cameraTog_1.value = true
  end)
  self:AddClickEvent(self.cameraTog_2.gameObject, function()
    self.togSelect = 2
    self.cameraTog_2.value = true
  end)
  self:AddClickEvent(self.cameraTog_3.gameObject, function()
    self.togSelect = 3
    self.cameraTog_3.value = true
  end)
  self:AddClickEvent(self.confirmBtn, function()
    self:UpdateCameraSetting(self.togSelect)
    self:CloseSelf()
  end)
end

function CameraSelectView:UpdateCameraSetting()
  if self.togSelect == 1 then
    FunctionPerformanceSetting.Me():SetLockCamera(false)
    FunctionPerformanceSetting.Me():SetLockFreeCameraVert(false)
  elseif self.togSelect == 2 then
    FunctionPerformanceSetting.Me():SetLockCamera(false)
    FunctionPerformanceSetting.Me():SetLockFreeCameraVert(true)
  else
    FunctionPerformanceSetting.Me():SetLockCamera(true)
    FunctionPerformanceSetting.Me():SetLockFreeCameraVert(true)
  end
  FunctionCameraEffect.Me():InitFreeCameraParam()
  FunctionPerformanceSetting.Me():SetFirstTimeInstall(false)
  Game.MapManager:UpdateCameraState(CameraController.singletonInstance)
  FunctionPerformanceSetting.Me():Save()
  GameFacade.Instance:sendNotification(SetEvent.CameraCtrlChange)
end

function CameraSelectView:OnExit()
  CameraSelectView.super.OnExit(self)
  if self.texturePath1 then
    PictureManager.Instance:UnLoadUI(self.texturePath1, self.texture1)
  end
  if self.texturePath2 then
    PictureManager.Instance:UnLoadUI(self.texturePath2, self.texture2)
  end
  if self.texturePath3 then
    PictureManager.Instance:UnLoadUI(self.texturePath3, self.texture3)
  end
end
