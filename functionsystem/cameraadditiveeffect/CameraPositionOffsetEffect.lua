CameraPositionOffsetEffect = class("CameraPositionOffsetEffect", CameraAdditiveEffect)

function CameraPositionOffsetEffect:Apply(offset)
  if not Game.GameObjectUtil:ObjectIsNULL(self.cameraController) then
    self.cameraController.positionOffset = offset
  end
end

function CameraPositionOffsetEffect:OnCameraControllerChanged(oldCameraController, newCameraController)
  if nil ~= oldCameraController and not Game.GameObjectUtil:ObjectIsNULL(oldCameraController) then
    oldCameraController.positionOffset = self.originOffset
  end
  if nil ~= newCameraController and not Game.GameObjectUtil:ObjectIsNULL(newCameraController) then
    self.originOffset = newCameraController.positionOffset
  end
end
