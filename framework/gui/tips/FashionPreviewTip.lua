autoImport("BaseTip")
FashionPreviewTip = class("FashionPreviewTip", BaseTip)
FashionPreviewEvent = {
  Close = "FashionPreviewEvent_Close"
}
local fovMin, fovMax = 35, 65
local cameraConfig = {
  position = LuaVector3.New(1.28, 1.18, -2.34),
  rotation = LuaQuaternion.Euler(7.12, -28.5, 0),
  fieldOfView = 45,
  backScale = Vector3(16, 9, 1)
}

function FashionPreviewTip:ctor(parent)
  FashionPreviewTip.super.ctor(self, "FashionPreviewTip", parent)
  self.closecomp = self.gameObject:GetComponent(CloseWhenClickOtherPlace)
  
  function self.closecomp.callBack()
    self:OnExit()
  end
  
  self.roleTex = self:FindComponent("RoleTex", UITexture)
  self.closeButton = self:FindGO("CloseButton")
  self:AddClickEvent(self.closeButton, function(go)
    self:OnExit()
  end)
  self.objHideToggle = self:FindGO("HideToggle")
  self.hideToggle = self.objHideToggle:GetComponent(UIToggle)
  self:AddTabEvent(self.objHideToggle, function(go, value)
    self:RefreshShow(nil, false)
  end)
  self.panel = self.gameObject:GetComponent(UIPanel)
  local temp = self.gameObject.transform.parent:GetComponentInParent(UIPanel)
  if temp then
    self.panel.depth = temp.depth + 1
  end
  self.fovScrollBar = self:FindGO("FovScrollBar")
  self.fovScrollBarCtrl = self:FindComponent("BackGround", UICustomScrollBar, self.fovScrollBar)
  EventDelegate.Add(self.fovScrollBarCtrl.onChange, function()
    if not self.fovScrollBarCtrl.isDragging or not self.uiModelCell then
      return
    end
    local value = 1 - self.fovScrollBarCtrl.value
    cameraConfig.fieldOfView = (fovMax - fovMin) * value + fovMin
    self.uiModelCell:_SetCameraConfig(cameraConfig)
  end)
  self:AddDragEvent(self.roleTex.gameObject, function(go, delta)
    self:RotateRoleEvt(go, delta)
  end)
  EventManager.Me():AddEventListener(ServiceEvent.NUserTransformPreDataCmd, self.HandleTransformed, self)
end

function FashionPreviewTip:HandleTransformed(data)
  local datas = data and data.datas
  if datas then
    local userdata = UserData.CreateAsTable()
    for i = 1, #datas do
      userdata:SetByID(datas[i].type, datas[i].value, datas[i].bytes)
    end
    self:RefreshByUserData(userdata)
    userdata:Destroy()
  end
end

function FashionPreviewTip:RotateRoleEvt(go, delta)
  if self.model then
    local deltaAngle = -delta.x * 360 / 400
    self.model:RotateDelta(deltaAngle)
  end
end

function FashionPreviewTip:SetData(id, customUserData)
  self.id = id
  self:RefreshShow(customUserData)
end

function FashionPreviewTip:RefreshShow(customUserData, camReset)
  if Table_HomeFurniture[self.id] ~= nil then
    self:ShowFurniturePreview()
    return
  end
  local composeInfo = Table_Compose[self.id]
  if composeInfo then
    local productId = composeInfo.Product.id
    if Table_HomeFurniture[productId] then
      self.id = productId
      self:ShowFurniturePreview()
      return
    end
  end
  if customUserData then
    self:RefreshByCustomData(customUserData)
  elseif Game.Myself.data:IsTransformed() then
    ServiceNUserProxy.Instance:CallTransformPreDataCmd()
  else
    self:RefreshByUserData(Game.Myself.data.userdata, camReset)
  end
end

function FashionPreviewTip:ShowFurniturePreview()
  self:Hide(self.objHideToggle)
  self:Hide(self.fovScrollBar)
  UIModelUtil.Instance:SetFurnitureModelTexture(self.roleTex, self.id, nil, function(obj)
    if not obj then
      return
    end
    self.model = obj
    self.model:RegisterWeakObserver(self)
  end)
end

function FashionPreviewTip:RefreshByCustomData(customUserData)
  self:Hide(self.objHideToggle)
  local sex = customUserData.sex
  local class = customUserData.class
  local parts = customUserData.parts
  local partIndex = Asset_Role.PartIndex
  local partIndexEx = Asset_Role.PartIndexEx
  parts[partIndex.Body] = parts[partIndex.Body] or sex == 1 and Table_Class[class].MaleBody or Table_Class[class].FemaleBody
  parts[partIndex.Hair] = parts[partIndex.Hair] or 0
  parts[partIndexEx.HairColorIndex] = parts[partIndexEx.HairColorIndex] or 0
  parts[partIndex.Eye] = ProfessionProxy.GetOriginalEye(parts[partIndex.Eye] or 0, parts[partIndex.Body])
  parts[partIndexEx.EyeColorIndex] = parts[partIndexEx.EyeColorIndex] or 0
  parts[partIndex.Face] = parts[partIndex.Face] or 0
  self:RefreshByData(parts, class, sex, true, cameraConfig)
end

function FashionPreviewTip:RefreshByUserData(userdata, camReset)
  self:Show(self.objHideToggle)
  local parts = Asset_Role.CreatePartArray()
  local partIndex = Asset_Role.PartIndex
  local partIndexEx = Asset_Role.PartIndexEx
  local class = Game.Myself.data.userdata:Get(UDEnum.PROFESSION)
  local mySex = Game.Myself.data.userdata:Get(UDEnum.SEX)
  local hideOther = self.hideToggle.value
  if hideOther then
    parts[partIndex.Body] = mySex == 1 and Table_Class[class].MaleBody or Table_Class[class].FemaleBody
    parts[partIndex.Hair] = userdata:Get(UDEnum.HAIR) or 0
    parts[partIndexEx.HairColorIndex] = userdata:Get(UDEnum.HAIRCOLOR) or 0
    parts[partIndex.Eye] = ProfessionProxy.GetOriginalEye(userdata:Get(UDEnum.EYE) or 0, parts[partIndex.Body])
    parts[partIndexEx.EyeColorIndex] = userdata:Get(UDEnum.EYECOLOR) or 0
  else
    Asset_RoleUtility.SetUserRoleParts(userdata, parts)
    parts[partIndex.Mount] = 0
  end
  self:RefreshByData(parts, class, mySex, hideOther, cameraConfig, camReset)
end

function FashionPreviewTip:RefreshByData(parts, class, sex, hideOther, camConfig, camReset)
  Asset_RoleUtility.SetFashionPreviewParts(self.id, class, sex, hideOther, parts)
  local isPreviewMount = ItemUtil.getItemRolePartIndex(self.id) == Asset_Role.PartIndex.Mount
  if camConfig and camReset ~= false then
    camConfig.fieldOfView = 45
    local cameraPosY = isPreviewMount and 1.18 or 1.45
    if Table_Class[class].Race == ECHARRACE.ECHARRACE_CAT then
      cameraPosY = cameraPosY * 0.8
    end
    camConfig.position[2] = cameraPosY
    self.fovScrollBarCtrl.value = 1 - (camConfig.fieldOfView - fovMin) / (fovMax - fovMin)
  end
  local mountScale = isPreviewMount and GameConfig.UIMountScale.scale or 1
  local suffixMap = Asset_RoleUtility.GetSuffixReplaceMap(class, parts[Asset_Role.PartIndex.Body], sex)
  if isPreviewMount then
    MountFashionProxy.Instance:SetMountSubParts(parts, self.id)
    MountFashionProxy.Instance:SetMountPartColors(parts, self.id)
  end
  self.model = UIModelUtil.Instance:SetRoleModelTexture(self.roleTex, parts, camConfig, mountScale, isPreviewMount, false, suffixMap, function(obj)
    self.model = obj
    self.uiModelCell = UIModelUtil.Instance:GetUIModelCell(self.roleTex)
    local equipData = Table_Equip[self.id]
    if equipData and (equipData.EquipType == 1 or equipData.Type == "Shield") then
      self.model:PlayAction_AttackIdle()
    elseif isPreviewMount then
      self.model:PlayAction_Idle()
    end
    self:RefreshBuffState()
  end)
  self.model:RegisterWeakObserver(self)
  Asset_Role.DestroyPartArray(parts)
end

function FashionPreviewTip:RefreshBuffState()
  if not self.id then
    return
  end
  if self.buffEffect and self.buffEffect[self.id] then
    return
  end
  if not self.buffEffect then
    self.buffEffect = {}
  end
  xdlog("RefreshBuffState", self.id)
  local equipData = Table_Equip[self.id]
  local fashionBuff = equipData and equipData.FashionBuff
  if fashionBuff and 0 < #fashionBuff then
    for i = 1, #fashionBuff do
      local buffData = Table_Buffer[fashionBuff[i]]
      local buffStateID = buffData and buffData.BuffStateID
      if buffStateID then
        local buffStateData = Table_BuffState[buffStateID]
        local path = buffStateData.Effect
        self.model:PlayEffectOn(path, buffStateData.EP)
        self.uiModelCell:SetCameraCulling({
          LayerMask.NameToLayer("UIModel"),
          LayerMask.NameToLayer("UIModelOutline"),
          LayerMask.NameToLayer("Outline"),
          LayerMask.NameToLayer("Default")
        })
      end
    end
    self.buffEffect[self.id] = 1
  else
    self.uiModelCell:ResetCameraCulling()
  end
end

function FashionPreviewTip:ObserverDestroyed(obj)
  if obj == self.model then
    self.model = nil
  end
end

local tempV3 = LuaVector3()

function FashionPreviewTip:SetAnchorPos(isright)
  if isright then
    tempV3[1] = 0
  else
    tempV3[1] = -390
  end
  self.gameObject.transform.localPosition = tempV3
end

function FashionPreviewTip:AddIgnoreBounds(obj)
  if self.gameObject and self.closecomp then
    self.closecomp:AddTarget(obj.transform)
  end
end

function FashionPreviewTip:OnExit()
  EventManager.Me():RemoveEventListener(ServiceEvent.NUserTransformPreDataCmd, self.HandleTransformed, self)
  if self.model and self.model.SetForceDestroy then
    self.model:SetForceDestroy(true)
  end
  GameObject.Destroy(self.gameObject)
  self:PassEvent(FashionPreviewEvent.Close)
  return true
end
