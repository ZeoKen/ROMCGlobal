GOManager_Skybox = class("GOManager_Skybox")
GOManager_Skybox.SkyboxID = {Main = 1}
local cachedQuat = LuaQuaternion()
local cachedRotation = LuaVector3()
local TexHashId = Shader.PropertyToID("_Tex")
local TintHashId = Shader.PropertyToID("_Tint")
local ExposureHashId = Shader.PropertyToID("_Exposure")
local SunSizeHashId = Shader.PropertyToID("_SunSize")
local FiniteKeyword = "FINITE_SKYBOX"

function GOManager_Skybox:ctor()
  self.skyboxGO = nil
  self.skyboxMat = nil
  self.skyboxId = nil
end

function GOManager_Skybox:Clear()
  self.skyboxGO = nil
  self.skyboxMat = nil
  self.skyboxId = nil
end

function GOManager_Skybox:RegisterGameObject(obj)
  local objId = obj.ID
  self.skyboxGO = obj.gameObject
  self.skyboxId = objId
  local renderer = obj:GetComponent(MeshRenderer)
  self.skyboxMat = renderer.sharedMaterial
  local rotation = obj.gameObject.transform.localRotation.eulerAngles
  LuaVector3.Better_Set(cachedRotation, rotation.x, rotation.y, rotation.z)
  return true
end

function GOManager_Skybox:UnregisterGameObject(obj)
  if obj.ID == self.skyboxId then
    self:Clear()
    return true
  end
  return false
end

function GOManager_Skybox:SetEnabled(val)
  if self.skyboxGO then
    self.skyboxGO:SetActive(val)
  end
end

function GOManager_Skybox:SetTexture(tex)
  if self.skyboxMat then
    self.skyboxMat:SetTexture(TexHashId, tex)
  end
end

function GOManager_Skybox:SetTintColor(tint)
  if self.skyboxMat then
    self.skyboxMat:SetColor(TintHashId, tint)
  end
end

function GOManager_Skybox:SetExposure(val)
  if self.skyboxMat then
    self.skyboxMat:SetFloat(ExposureHashId, val)
  end
end

function GOManager_Skybox:SetFinite(val)
  if self.skyboxMat then
    if val then
      self.skyboxMat:EnableKeyword(FiniteKeyword)
    else
      self.skyboxMat:DisableKeyword(FiniteKeyword)
    end
  end
end

function GOManager_Skybox:SetRotation(ry)
  if self.skyboxGO then
    cachedRotation[2] = ry
    LuaQuaternion.Better_SetEulerAngles(cachedQuat, cachedRotation)
    self.skyboxGO.transform.localRotation = cachedQuat
  end
end

function GOManager_Skybox:SetLocalPosition(localPos)
  if self.skyboxGO then
    self.skyboxGO.transform.localPosition = localPos
  end
end

function GOManager_Skybox:SetSunSize(val)
  if self.skyboxMat then
    self.skyboxMat:SetFloat(SunSizeHashId, val or 0)
  end
end

function GOManager_Skybox:SetMatFloatProperty(key, val)
  if self.skyboxMat then
    self.skyboxMat:SetFloat(key, val)
  end
end

function GOManager_Skybox:HasCustomSkybox()
  return self.skyboxId ~= nil
end
