CameraEffect = class("CameraEffect")

function CameraEffect:ctor()
  self:Reset()
end

function CameraEffect:Reset()
  self:ResetCameraController(nil)
end

function CameraEffect:ResetCameraController(newCameraController)
  local oldCameraController = self.cameraController
  if oldCameraController == newCameraController then
    return
  end
  self.cameraController = newCameraController
  if nil ~= oldCameraController and not Game.GameObjectUtil:ObjectIsNULL(oldCameraController) then
    self:DoEnd(oldCameraController)
    oldCameraController.beSingleton = true
    oldCameraController:SetResumeLockTarget()
  end
  if nil ~= newCameraController then
    self:DoStart(newCameraController)
    newCameraController.beSingleton = false
    newCameraController:SetPauseLockTarget(self.duration or 0, false)
  end
end

function CameraEffect:Bussy()
  return nil ~= self.cameraController and not Game.GameObjectUtil:ObjectIsNULL(self.cameraController)
end

function CameraEffect:Start(cameraController)
  self:ResetCameraController(cameraController)
end

function CameraEffect:End(cameraController)
  self:Reset()
end

function CameraEffect:DoStart(cameraController)
end

function CameraEffect:DoEnd(cameraController)
end
