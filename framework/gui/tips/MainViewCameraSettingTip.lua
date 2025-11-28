MainViewCameraSettingTip = class("MainViewCameraSettingTip", BaseTip)

function MainViewCameraSettingTip:Init()
  MainViewCameraSettingTip.super.Init(self)
  self:FindObjs()
  self:AddEvts()
end

function MainViewCameraSettingTip:FindObjs()
  self.commonLock = self:FindGO("CommonLock")
  self.half3D = self:FindGO("2.5D")
  self.full3D = self:FindGO("3D")
  self.cameraToggle = {}
  self.cameraToggle[1] = self:FindGO("CommonToggle"):GetComponent(UIToggle)
  self.cameraToggle[2] = self:FindGO("2.5Dtoggle"):GetComponent(UIToggle)
  self.cameraToggle[3] = self:FindGO("3Dtoggle"):GetComponent(UIToggle)
  self.commonTgLabel = self.commonLock:GetComponent(UILabel)
  self.commonTgLabel.text = ZhString.LockCameraCtl
  self.half3DTgLabel = self.half3D:GetComponent(UILabel)
  self.half3DTgLabel.text = ZhString.Half3DCtl
  self.full3DTgLabel = self.full3D:GetComponent(UILabel)
  self.closecomp = self.gameObject:GetComponent(CloseWhenClickOtherPlace)
  
  function self.closecomp.callBack(go)
    self:CloseSelf()
  end
  
  self.confirmBtn = self:FindGO("ConfirmBtn")
end

function MainViewCameraSettingTip:AddEvts()
  self:AddClickEvent(self.confirmBtn, function()
    self:SaveSetting()
    self:RefreshCamera()
    GameFacade.Instance:sendNotification(MainViewEvent.RefreshCameraStatus)
  end)
end

function MainViewCameraSettingTip:SetPos(pos)
  if self.gameObject ~= nil then
    local p = self.gameObject.transform.position
    pos.z = p.z
    self.gameObject.transform.position = pos
  else
    self.pos = pos
  end
end

function MainViewCameraSettingTip:SetData()
  local setting = FunctionPerformanceSetting.Me()
  if setting:GetSetting().disableFreeCamera then
    self.cameraToggle[1].value = true
    self.cameraSetting = 1
  elseif setting:GetSetting().disableFreeCameraVert then
    self.cameraToggle[2].value = true
    self.cameraSetting = 2
  else
    self.cameraToggle[3].value = true
    self.cameraSetting = 3
  end
end

function MainViewCameraSettingTip:RefreshCamera()
  FunctionCameraEffect.Me():InitFreeCameraParam()
  Game.MapManager:UpdateCameraState(CameraController.singletonInstance)
end

function MainViewCameraSettingTip:SaveSetting()
  FunctionPerformanceSetting.Me():SetLockCamera(self.cameraToggle[1].value)
  FunctionPerformanceSetting.Me():SetLockFreeCameraVert(self.cameraToggle[2].value)
end

function MainViewCameraSettingTip:CloseSelf()
  self:SaveSetting()
  FunctionPerformanceSetting.Me():Save()
  if self.callback then
    self.callback(self.callbackParam)
  end
  TipsView.Me():HideCurrent()
  self.closecomp = nil
end

function MainViewCameraSettingTip:DestroySelf()
  if not Slua.IsNull(self.gameObject) then
    GameObject.Destroy(self.gameObject)
  end
end
