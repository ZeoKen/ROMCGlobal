ClickEffectView = class("ClickEffectView", BaseView)
ClickEffectView.ViewType = UIViewType.TouchLayer
local tempVector3 = LuaVector3.Zero()

function ClickEffectView:Init()
  self.gameObject.name = "ClickEffectView"
  self.collider = self:FindGO("Collider")
  ClickEffectView.Instance = self
end

ClickEffectView.disable = false

function ClickEffectView.ShowClickEffect()
  if ClickEffectView.disable then
    return
  end
  local instance = ClickEffectView.getInstance()
  local uiCamera = NGUIUtil:GetCameraByLayername("UI")
  if not uiCamera then
    return
  end
  if Input.touchCount > 1 then
    printRed(Input.touchCount)
    for i = 1, Input.touchCount do
      local single = Input.GetTouch(i - 1)
      if single.phase == TouchPhase.Ended then
        local x, y = LuaGameObject.GetTouchPosition(i - 1, false)
        LuaVector3.Better_Set(tempVector3, x, y, 0)
        break
      end
    end
  else
    local x, y, z = LuaGameObject.GetMousePosition()
    LuaVector3.Better_Set(tempVector3, x, y, z)
  end
  if not UIUtil.IsScreenPosValid(tempVector3[1], tempVector3[2]) then
    if not ApplicationInfo.IsRunOnEditor() then
      LogUtility.Error(string.format("ClickEffectView MousePosition is Invalid! x: %s, y: %s", tempVector3[1], tempVector3[3]))
    end
    return
  end
  local x, y, z = LuaGameObject.ScreenToWorldPointByVector3(uiCamera, tempVector3)
  LuaVector3.Better_Set(tempVector3, x, y, z)
  x, y, z = LuaGameObject.InverseTransformPointByVector3(instance.gameObject.transform, tempVector3)
  LuaVector3.Better_Set(tempVector3, x, y, z)
  instance.lPos = tempVector3
  instance:PlayUIEffect(EffectMap.UI.UIPoint, instance.gameObject, true, instance.resourceLoadSus, instance)
end

function ClickEffectView.resourceLoadSus(eObj, instance)
  eObj.transform.localPosition = instance.lPos
end

function ClickEffectView:OnExit()
  ClickEffectView.super.OnExit(self)
  ClickEffectView.Instance = nil
end

function ClickEffectView.getInstance()
  if ClickEffectView.Instance == nil then
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.ClickEffectView
    })
  end
  return ClickEffectView.Instance
end

function ClickEffectView.close()
  if ClickEffectView.Instance ~= nil then
    ClickEffectView.Instance:CloseSelf()
  end
end

function ClickEffectView:EnterHandUpMode()
  self.collider:SetActive(true)
end

function ClickEffectView:ExitHandUpMode()
  self.collider:SetActive(false)
end
