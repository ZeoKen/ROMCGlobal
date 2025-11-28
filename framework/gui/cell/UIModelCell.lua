local BaseCell = autoImport("BaseCell")
UIModelCell = class("UIModelCell", BaseCell)
UIModelCell.ModelType = {
  Role = "Role",
  RolePart = "RolePart",
  ModelPrefab = "ModelPrefab",
  Furniture = "Furniture"
}
local tempV3 = LuaVector3()
local tempV3_1 = LuaVector3()
local IsNull = Slua.IsNull
UIModelCell.RTCount = 0

function UIModelCell:ctor(go, index)
  UIModelCell.super.ctor(self, go)
  self.index = index
  self:SetRenderTexPath(index)
  self:Init()
end

function UIModelCell:SetRenderTexPath(index)
  self.renderTexRId = "GUI/pic/Model/UIModelTexture" .. index
end

function UIModelCell:Init()
  self.camera = self:FindGO("Camera", self.gameObject):GetComponent(Camera)
  if LayerMask.NameToLayer("UIModelOutline") < 0 then
    local cullingMask = self.camera.cullingMask
    cullingMask = cullingMask | 1 << LayerMask.NameToLayer("Outline")
    self.camera.cullingMask = cullingMask
  end
  self.container = self:FindGO("ModelContainer", go)
  self.modelBack = self:FindGO("back", go)
  if self.modelBack then
    self.modelBackDefaultPos = self.modelBack.transform.localPosition
    self.modelBackDefaultScale = self.modelBack.transform.localScale
    local renderer = self.modelBack:GetComponent(MeshRenderer)
    if renderer and renderer.materials and next(renderer.materials) then
      self.modelBackMat = renderer.materials[1]
    end
  end
  self.isTransparent = false
end

local disabledHighFog = false

function UIModelCell:SetRT(forceReset)
  if not IsNull(self.renderTex) then
    if forceReset then
      self:ClearRT()
    else
      return
    end
  end
  if IsNull(self.camera) then
    return
  end
  if not IsNull(self.gameObject) then
    self.gameObject:SetActive(true)
  end
  if not IsNull(self.uiTexture) then
    local width, height = self.uiTexture.width, self.uiTexture.height
    if width < 800 or height < 600 then
      self.renderTex = RenderTexture.GetTemporary(width * 2, height * 2, 16)
    else
      self.renderTex = RenderTexture.GetTemporary(width, height, 16)
    end
    self.renderTex.autoGenerateMips = false
    UIModelCell.RTCount = UIModelCell.RTCount + 1
    self.camera.targetTexture = self.renderTex
    self.uiTexture.mainTexture = self.renderTex
  end
  if UIModelCell.RTCount == 1 and Shader.IsKeywordEnabled("LOCAL_HEIGHT_FOG") then
    Shader.DisableKeyword("LOCAL_HEIGHT_FOG")
    disabledHighFog = true
  end
end

function UIModelCell:ForceSetRT(forceReset, width, height)
  if not IsNull(self.renderTex) then
    if forceReset then
      self:ClearRT()
    else
      return
    end
  end
  if IsNull(self.camera) then
    return
  end
  if not IsNull(self.gameObject) then
    self.gameObject:SetActive(true)
  end
  if not IsNull(self.uiTexture) then
    self.renderTex = RenderTexture.GetTemporary(width, height, 16)
    self.renderTex.autoGenerateMips = false
    UIModelCell.RTCount = UIModelCell.RTCount + 1
    self.camera.targetTexture = self.renderTex
    self.uiTexture.mainTexture = self.renderTex
  end
  if UIModelCell.RTCount == 1 and Shader.IsKeywordEnabled("LOCAL_HEIGHT_FOG") then
    Shader.DisableKeyword("LOCAL_HEIGHT_FOG")
    disabledHighFog = true
  end
end

function UIModelCell:EnablePostProcessing(b)
  if not self.camera then
    return
  end
  local setUrp = function(comp, enableb)
    comp.renderPostProcessing = enableb
  end
  if not self.tryGetUrpData then
    self.tryGetUrpData = true
    self.urpData = self.camera.gameObject:GetComponent("UniversalAdditionalCameraData")
  end
  xpcall(setUrp, debug.traceback, self.urpData, b)
end

function UIModelCell:ClearRT()
  if not IsNull(self.renderTex) then
    RenderTexture.ReleaseTemporary(self.renderTex)
    UIModelCell.RTCount = UIModelCell.RTCount - 1
  end
  self.renderTex = nil
  if not IsNull(self.camera) then
    self.camera.targetTexture = nil
  end
  if not IsNull(self.gameObject) then
    self.gameObject:SetActive(false)
  end
  if UIModelCell.RTCount == 0 and disabledHighFog then
    disabledHighFog = false
    Shader.EnableKeyword("LOCAL_HEIGHT_FOG")
  end
end

function UIModelCell:SetTexture(uiTexture)
  if IsNull(uiTexture) then
    self:Clear()
    LogUtility.Error("UIModelCell.SetTexture: uiTexture is nil.")
    return
  end
  self.camera.enabled = true
  if self.comNonPrimaryCamera then
    self.comNonPrimaryCamera.enabled = true
  end
  TimeTickManager.Me():ClearTick(self, 2)
  local renderTexMatch = false
  if not IsNull(self.renderTex) and uiTexture.mainTexture == self.renderTex then
    if uiTexture.width < 800 or uiTexture.height < 600 then
      renderTexMatch = self.renderTex.width == uiTexture.width * 2 and self.renderTex.height == uiTexture.height * 2
    else
      renderTexMatch = self.renderTex.width == uiTexture.width and self.renderTex.height == uiTexture.height
    end
  end
  if self.uiTexture == uiTexture and renderTexMatch then
    return
  end
  self.uiTexture = uiTexture
  local uiTextureGO = uiTexture.gameObject
  local luaMono = Game.GameObjectUtil:GetOrAddComponent(uiTextureGO, GameObjectForLua)
  local texName = uiTextureGO.name
  
  function luaMono.onEnable()
    self:SetRT(true)
  end
  
  function luaMono.onDisable()
    self:ClearRT()
  end
  
  function luaMono.onDestroy()
    local success, errorMsg = xpcall(UIModelCell.Clear, debug.traceback, self)
    if not success then
      LogUtility.Error(string.format("UIModel Clear失败(textureGO:%s): ", texName) .. tostring(errorMsg))
    end
  end
  
  if not uiTextureGO.activeSelf then
    uiTextureGO:SetActive(true)
  else
    self:SetRT(true)
  end
end

local tempRot = LuaQuaternion()

function UIModelCell:UpdateCameraRot()
  local cameraController = CameraController.singletonInstance
  if cameraController == nil then
    return
  end
  local main_cr = cameraController.cameraRotation
  LuaVector3.Better_Set(tempV3, LuaGameObject.GetLocalEulerAngles(self.camera.transform))
  LuaVector3.Better_Sub(main_cr.eulerAngles, tempV3, tempV3_1)
  LuaQuaternion.Better_SetEulerAngles(tempRot, tempV3_1)
  self.gameObject.transform.rotation = tempRot
end

function UIModelCell:GetContainerObj()
  return self.container
end

function UIModelCell:_SetCameraConfig(cameraConfig)
  if not self:ObjIsNil(self.camera) then
    self.camera.transform.localPosition = cameraConfig.position
    self.camera.transform.localRotation = cameraConfig.rotation
    if cameraConfig.orthographic then
      self.camera.orthographic = true
      if cameraConfig.orthographicSize then
        self.camera.orthographicSize = cameraConfig.orthographicSize
      end
    else
      self.camera.orthographic = false
      if cameraConfig.fieldOfView then
        self.camera.fieldOfView = cameraConfig.fieldOfView
      end
    end
    if cameraConfig.nearClipPlane then
      self.camera.nearClipPlane = cameraConfig.nearClipPlane
    else
      self.camera.nearClipPlane = 0.3
    end
    if cameraConfig.farClipPlane then
      self.camera.farClipPlane = cameraConfig.farClipPlane
    else
      self.camera.farClipPlane = 20
    end
    self.camera.clearFlags = CameraClearFlags.SolidColor
    if self.isTransparent then
      self.camera.backgroundColor = LuaGeometry.GetTempColor(0, 0, 0, 0)
      self:EnablePostProcessing(false)
    else
      self.camera.backgroundColor = LuaGeometry.GetTempColor(0.19215686274509805, 0.30196078431372547, 0.4745098039215686, 1)
      self:EnablePostProcessing(true)
    end
    self.camera.rect = cameraConfig.rect or Rect(0, 0, 1, 1)
    if self.modelBack and not self.isTransparent then
      self.modelBack:SetActive(true)
      self.modelBack.transform.localPosition = cameraConfig.backPosition or self.modelBackDefaultPos
      self.modelBack.transform.localScale = cameraConfig.backScale or self.modelBackDefaultScale
    end
    self:UpdateCameraRot()
    self.camera.enabled = true
  end
end

function UIModelCell:SetRolePartModelTexture(uiTexture, partIndex, id, cameraConfig, scale, callback, callbackArg, failCallback, failCallbackArg)
  scale = scale or 1
  local mountBody = GameConfig.Mount2Body[id]
  if mountBody then
    local parts = Asset_Role.CreatePartArray()
    local userdata = Game.Myself.data.userdata
    parts[Asset_Role.PartIndex.Body] = mountBody[userdata:Get(UDEnum.SEX) or 1]
    parts[Asset_Role.PartIndex.Hair] = userdata:Get(UDEnum.HAIR) or 0
    parts[Asset_Role.PartIndexEx.HairColorIndex] = userdata:Get(UDEnum.HAIRCOLOR) or 0
    parts[Asset_Role.PartIndex.Eye] = userdata:Get(UDEnum.EYE) or 0
    parts[Asset_Role.PartIndexEx.EyeColorIndex] = userdata:Get(UDEnum.EYECOLOR) or 0
    parts[Asset_Role.PartIndexEx.Layer] = self.container ~= nil and self.container.layer or 0
    parts[Asset_Role.PartIndexEx.SkinQuality] = Asset_RolePart.SkinQuality.Bone4
    parts[Asset_Role.PartIndexEx.BodyColorIndex] = userdata:Get(UDEnum.CLOTHCOLOR) or 0
    local roleModel = self:SetRoleModelTexture(uiTexture, parts, cameraConfig, scale, true, nil, nil, callback, callbackArg)
    Asset_Role.DestroyPartArray(parts)
    return roleModel
  end
  self:_SetCameraConfig(cameraConfig or UIModelCameraTrans.Item)
  self:SetTexture(uiTexture)
  self:ClearModel()
  self.gameObject:SetActive(true)
  self.modelType = UIModelCell.ModelType.RolePart
  self.modelId = id
  local subparts, partColors
  if partIndex == Asset_Role.PartIndex.Mount then
    subparts, partColors = {}, {}
    MountFashionProxy.Instance:SetMountSubParts(subparts, id)
    MountFashionProxy.Instance:SetMountPartColors(partColors, id)
  end
  self.model = Asset_RolePart.Create(partIndex, id, function(rolePart, arg, assetRolePart)
    if self.modelId ~= id then
      if assetRolePart then
        assetRolePart:Destroy()
      end
      return
    end
    if assetRolePart then
      assetRolePart:SetEpNodesDisplay(true)
    end
    self.model = assetRolePart
    if self.model then
      self.model:ResetParent(self.container.transform)
      self.model:ResetLocalPositionXYZ(0, 0, 0)
      self.model:ResetLocalScaleXYZ(scale, scale, scale)
      LuaVector3.Better_Set(tempV3, 0, 0, 0)
      self.model:ResetLocalEulerAngles(tempV3)
    end
    if callback then
      callback(rolePart, arg, assetRolePart)
    end
    self.model:SetLayer(self.container.layer)
    local roleParts = rolePart.gameObject:GetComponentsInChildren(RolePart)
    if roleParts then
      local parentlayer = self.container.layer
      for _, v in pairs(roleParts) do
        v.layer = parentlayer
      end
    end
  end, callbackArg, Asset_RolePart.SkinQuality.Bone4, subparts, partColors, failCallback, failCallbackArg)
  self.model:RegisterWeakObserver(self)
  return self.model
end

function UIModelCell:SetModelPrefabTexture(uiTexture, bodyID, callBack)
  self:SetTexture(uiTexture)
  self.gameObject:SetActive(true)
  self.modelType = UIModelCell.ModelType.ModelPrefab
  self.modelId = bodyID
  local resID = ResourcePathHelper.RoleBody(bodyID)
  ResourceManager.Instance:SAsyncLoad(resID, function(asset)
    if self.modelId ~= bodyID then
      if asset then
        GameObject.Destroy(asset)
      end
      return
    end
    self:ClearModel()
    self.model = GameObject.Instantiate(asset)
    if self.model then
      self.model.transform:SetParent(self.container.transform)
      UIUtil.ChangeLayer(self.model, self.container.layer)
    end
    if callBack then
      callBack(self.model)
    end
  end, "", 0)
end

local _IdleAction = Asset_Role.ActionName.Idle

function UIModelCell:SetRoleModelTexture(uiTexture, parts, cameraConfig, scale, isPreviewMount, isStatic, suffixMap, callback, callbackArg, autoAdjust, disablePostProcessing)
  self:_SetCameraConfig(cameraConfig or UIModelCameraTrans.Role)
  self:SetTexture(uiTexture)
  if isStatic then
    self.camera.enabled = false
    if self.comNonPrimaryCamera then
      self.comNonPrimaryCamera.enabled = false
    end
  end
  self.gameObject:SetActive(true)
  parts[Asset_Role.PartIndexEx.Layer] = self.container ~= nil and self.container.layer or 0
  parts[Asset_Role.PartIndexEx.SkinQuality] = Asset_RolePart.SkinQuality.Bone4
  parts[Asset_Role.PartIndexEx.Download] = true
  if self.model and self.modelType == UIModelCell.ModelType.Role then
    self.model:Redress(parts, true)
  else
    self:ClearModel()
    self.model = Asset_Role.Create(parts)
    self.model:RegisterWeakObserver(self)
    self.model:SetParent(self.container.transform, false)
    self.model:SetEpNodesDisplay(true)
    self.model:SetLayer(self.container.layer)
  end
  self.modelType = UIModelCell.ModelType.Role
  self.model:SetPosition(LuaGeometry.Const_V3_zero)
  self.model:SetRotation(LuaGeometry.Const_Qua_identity)
  self.model:SetScale(scale or 1)
  if isPreviewMount ~= nil then
    self.model:SetMountDisplay(isPreviewMount)
  end
  if suffixMap then
    self.model:SetSuffixReplaceMap(suffixMap)
  end
  if autoAdjust then
    self.model:SetInvisible(true)
  end
  local onCreatedCallback = function(assetRole, arg)
    local params = Asset_Role.GetPlayActionParams(_IdleAction)
    params[4] = 0.2
    params[6] = true
    self.model:PlayAction(params)
    if callback then
      callback(assetRole, arg)
    end
    if isStatic then
      if self.model then
        self.model:AlphaTo(1, 0)
      end
      TimeTickManager.Me():CreateOnceDelayTick(50 + (self.index or 0) * 10, function()
        if self.camera then
          self.camera:Render()
        end
      end, self, 2)
    end
    self.model:IgnoreTerrainLightColor(true)
    self.model:ActiveMulColor(LuaGeometry.GetTempColor(0.975, 0.975, 0.975, 1))
    self.model:RefreshLightMapColor()
    if autoAdjust then
      self.model:SetInvisible(false)
      self:AutoAdjust()
    end
  end
  if self.model:_IsLoading() then
    self.model:SetExOnCreatedCallback(onCreatedCallback, callbackArg)
  else
    onCreatedCallback(self.model, callbackArg)
  end
  if disablePostProcessing then
    self:EnablePostProcessing(false)
  end
  return self.model
end

function UIModelCell:AutoAdjust()
  local body = self.model:GetPartObject(Asset_Role.PartIndex.Body)
  if body ~= nil then
    local smrs = body.smrs
    local bounds, smrbounds
    local planes = GeometryUtility.CalculateFrustumPlanes(self.camera)
    for i = 1, #smrs do
      smrbounds = smrs[i].bounds
      if GeometryUtility.TestPlanesAABB(planes, smrbounds) then
        if bounds == nil then
          bounds = smrbounds
        else
          bounds:Encapsulate(smrbounds)
        end
      end
    end
    bounds = bounds or body.bodyBounds
    if bounds == nil then
      return
    end
    local extents = bounds.extents
    local completeTransform = self.model.completeTransform
    if extents.z > (self.modelBack.transform.localScale.x - 3) / 2 then
      LuaVector3.Better_Set(tempV3, 0.3, 0.3, 0.3)
      completeTransform.localScale = tempV3
      completeTransform.localPosition = LuaVector3.Zero()
      return
    end
    local radius = math.max(extents.x, extents.y)
    if 0 < radius then
      local targetdistance = radius / math.tan(math.rad(self.camera.fieldOfView * 0.5))
      local transform = self.camera.transform
      tempV3:Set(LuaGameObject.GetPosition(transform))
      tempV3_1:Set(self.model:GetPositionXYZ())
      local distance = LuaVector3.Distance(tempV3, tempV3_1)
      if 0 < targetdistance - distance then
        local vec = transform.forward * targetdistance - completeTransform.up * extents.y * 0.75
        tempV3_1:Set(vec.x, vec.y, vec.z)
        completeTransform.position = tempV3 + tempV3_1
      else
        local mainSMR = body.mainSMR
        if mainSMR ~= nil then
          local pos = mainSMR.transform.localPosition
          if 1 < pos.y then
            tempV3:Set(0, -pos.y / 2, 0)
            completeTransform.localPosition = tempV3
          end
        end
      end
    end
  end
end

function UIModelCell:SetFurnitureModelTexture(uiTexture, furnitureSID, cameraConfig, callback)
  self:SetTexture(uiTexture)
  self.gameObject:SetActive(true)
  self.modelType = UIModelCell.ModelType.Furniture
  local furnitureSData = Table_HomeFurniture[furnitureSID]
  self.modelId = furnitureSID
  Asset_Furniture.new(furnitureSID, self.container.transform, function(model)
    if self.modelId ~= furnitureSID then
      if model then
        model:Destroy()
      end
      return
    end
    self:ClearModel()
    self.model = model
    if self.model and self.model.gameObject then
      self.model:SetLayer(self.container.layer)
      self.model:ShowShadow(false)
      self.model:ShowSideShadow(false)
      local posConfig = furnitureSData and furnitureSData.LoadShowPosition
      if posConfig and 2 < #posConfig then
        self.model:SetLocalPositionXYZ(posConfig[1], posConfig[2], posConfig[3])
      else
        self.model:SetLocalPositionXYZ(0, 0, 0)
      end
      self.model:SetScale(furnitureSData and furnitureSData.LoadShowSize or 1)
      self.model:SetLocalEulerAnglesXYZ(0, 0, 0)
    end
    self:_SetCameraConfig(cameraConfig or UIModelCameraTrans.Furniture)
    if callback then
      callback(self.model)
    end
  end)
end

function UIModelCell:SetHomeMaterialModelTexture(uiTexture, materialSID, cameraConfig, callback)
  self:SetTexture(uiTexture)
  self.gameObject:SetActive(true)
  self.modelType = UIModelCell.ModelType.ModelPrefab
  self.modelId = materialSID
  Game.AssetManager_Furniture:CreateHomeMaterialModel(materialSID, self.container.transform, function(obj)
    if self.modelId ~= materialSID then
      if obj then
        GameObject.Destroy(obj)
      end
      return
    end
    self:ClearModel()
    if obj then
      self.model = obj
      UIUtil.ChangeLayer(self.model, self.container.layer)
      local matStaticData = Table_HomeFurnitureMaterial[materialSID]
      local config = GameConfig.Home.RenovationModelShowConfig[matStaticData and matStaticData.Type]
      local transform = self.model.transform
      local single = config and config.Position
      if single then
        LuaVector3.Better_Set(tempV3, single[1], single[2], single[3])
      else
        LuaVector3.Better_Set(tempV3, 0, 0, 0)
      end
      transform.localPosition = tempV3
      local single = config and config.Euler
      if single then
        LuaVector3.Better_Set(tempV3, single[1], single[2], single[3])
      else
        LuaVector3.Better_Set(tempV3, -90, 0, 0)
      end
      transform.localEulerAngles = tempV3
      local single = config and config.Scale
      if single then
        LuaVector3.Better_Set(tempV3, single[1], single[2], single[3])
      else
        LuaVector3.Better_Set(tempV3, 0.5, 0.5, 0.5)
      end
      transform.localScale = tempV3
    end
    self:_SetCameraConfig(cameraConfig or UIModelCameraTrans.Furniture)
    if callback then
      callback(obj)
    end
  end)
end

function UIModelCell:SetModelTextureByPath(uiTexture, path, resType, callback)
  self:SetTexture(uiTexture)
  self:ClearModel()
  self.gameObject:SetActive(true)
  self.modelType = UIModelCell.ModelType.ModelPrefab
  if resType then
    ResourceManager.Instance:SAsyncLoad(path, resType, function(asset)
      if not asset then
        redlog("UIModelCell:SetModelTextureByPath ===1=== load by type asset is nil = " .. path, tostring(resType))
        return
      end
      self:LoadAsyncComplete(asset, callback)
    end, "", 0)
  else
    ResourceManager.Instance:SAsyncLoad(path, function(asset)
      if not asset then
        redlog("UIModelCell:SetModelTextureByPath ===2=== asset is nil = " .. path)
        return
      end
      self:LoadAsyncComplete(asset, callback)
    end, "", 0)
  end
end

function UIModelCell:LoadAsyncComplete(asset, callback)
  self.model = GameObject.Instantiate(asset).gameObject
  if self.model then
    self.model.transform:SetParent(self.container.transform)
    UIUtil.ChangeLayer(self.model, self.container.layer)
  end
  if callback then
    callback(self.model)
  end
end

local vec_zero = LuaVector3.Zero()

function UIModelCell:SetBricksTexture(uiTexture, bricksID, ratation, callBack)
  self:SetTexture(uiTexture)
  self.gameObject:SetActive(true)
  self:_SetCameraConfig(UIModelCameraTrans.Bricks)
  self.modelType = UIModelCell.ModelType.ModelPrefab
  self.modelId = bricksID
  local resID = ResourcePathHelper.BrickObj(bricksID)
  self:ClearModel()
  local asset = Game.AssetManager:Load(resID)
  self.model = GameObject.Instantiate(asset)
  Game.AssetManager:UnloadAsset(resID)
  if self.model then
    local trans = self.model.transform
    trans:SetParent(self.container.transform)
    UIUtil.ChangeLayer(self.model, self.container.layer)
    trans.localPosition = vec_zero
    if callBack then
      callBack(self.model)
      self:_ResetBrickUICamera(ratation)
    end
  end
end

local _cameraDistance = 3

function UIModelCell:_ResetBrickUICamera(ratation)
  if not ratation then
    return
  end
  local cameraRotation
  local cameraCtl = CameraController.Instance or CameraController.singletonInstance
  if nil ~= cameraCtl and nil ~= cameraCtl.activeCamera then
    cameraRotation = cameraCtl.activeCamera.transform.rotation
  end
  if not cameraRotation then
    if nil == Camera.main then
      return
    end
    cameraRotation = Camera.main.transform.rotation
  end
  self.container.transform.rotation = ratation
  self.camera.transform.rotation = cameraRotation
  self.camera.transform.position = self.container.transform.position + cameraRotation * LuaGeometry.GetTempVector3(0, 0, -_cameraDistance)
end

function UIModelCell:ClearModel()
  if self.model then
    if self.modelType == UIModelCell.ModelType.Role then
      self.model:IgnoreTerrainLightColor(false)
      self.model:DeactiveMulColor()
    end
    if type(self.model) == "table" then
      self.model:SetLayer(Game.ELayer.Default)
      self.model:Destroy()
    else
      GameObject.Destroy(self.model)
    end
  end
  self.model = nil
end

function UIModelCell:ObserverDestroyed(obj)
  self.model = nil
end

function UIModelCell:Clear()
  TimeTickManager.Me():ClearTick(self)
  self:ClearRT()
  self:ClearModel()
  self:_SetCameraConfig(UIModelCameraTrans.Default)
  self:ResetContainer()
  if not IsNull(self.uiTexture) then
    local luaMono = self.uiTexture.gameObject:GetComponent(GameObjectForLua)
    if luaMono then
      luaMono.onEnable = nil
      luaMono.onDisable = nil
      luaMono.onDestroy = nil
    end
  end
  self.uiTexture = nil
  self:ChangeBGMeshRenderer("Bg_beijing")
  if not self:ObjIsNil(self.gameObject) then
    self.gameObject:SetActive(false)
  end
  self.isTransparent = false
  self.autoAdjust = nil
  self.autoAdjustFrame = nil
end

local getmetatable = getmetatable

function UIModelCell:ResetContainer()
  if not IsNull(self.container) then
    self.container.transform.localPosition = LuaGeometry.GetTempVector3(0, 0.1, 0)
    self.container.transform.localEulerAngles = LuaGeometry.GetTempVector3(0, 170, 0)
    self.container.transform.localScale = LuaGeometry.Const_V3_one
    local cps, cp = self.container.gameObject:GetComponents(Component)
    for i = 1, #cps do
      cp = cps[i]
      if getmetatable(cp).__typename ~= "Transform" then
        GameObject.Destroy(cp)
      end
    end
  end
end

function UIModelCell:GetCacheUITexture()
  if self:ObjIsNil(self.uiTexture) then
    self.uiTexture = nil
  end
  return self.uiTexture
end

function UIModelCell:SetModelTransparent(col)
  self:SetCameraBgColor(col)
  self.modelBack:SetActive(false)
  self.isTransparent = true
  self:EnablePostProcessing(false)
end

function UIModelCell:ChangeBGMeshRenderer(name)
  if not IsNull(self.modelBackMat) and Game.State ~= Game.EState.Finished then
    if Game.AssetManager:IsResManagerDestroyed() then
      return
    end
    PictureManager.Instance:SetPetRenderTexture(name, self.modelBackMat)
  end
end

function UIModelCell:SetCameraBgColor(col)
  self.camera.clearFlags = CameraClearFlags.SolidColor
  self.camera.backgroundColor = col or LuaGeometry.GetTempColor(0, 0, 0, 0)
end

function UIModelCell:Reset()
  self:Clear()
end

function UIModelCell:SetCameraCulling(layers)
  if self.camera then
    local layers = layers or {}
    local _cullingMask = 0
    for i = 1, #layers do
      _cullingMask = _cullingMask | 1 << layers[i]
    end
    self.camera.cullingMask = _cullingMask
  end
end

function UIModelCell:ResetCameraCulling()
  if self.camera then
    local cullingMask = 0
    cullingMask = cullingMask | 1 << LayerMask.NameToLayer("UIModel")
    cullingMask = cullingMask | 1 << LayerMask.NameToLayer("UIModelOutline")
    self.camera.cullingMask = cullingMask
  end
end
