GOManager_PhotoStand = class("GOManager_PhotoStand")
local FramePhotoWidth = 822
local FramePhotoHeight = 462
local FramePhotoAspect = FramePhotoWidth / FramePhotoHeight
local FramePhotoAspectReverse = FramePhotoHeight / FramePhotoWidth
local tempVector3 = LuaVector3.Zero()
local isNil = LuaGameObject.ObjectIsNull

function GOManager_PhotoStand:ctor()
  self.objects = {}
  self.renderers = {}
  self.transCount = {}
  self.lastPhoto = {}
end

function GOManager_PhotoStand:Launch()
  self:InitOriMat()
end

function GOManager_PhotoStand:Shutdown()
  self:Clear()
end

function GOManager_PhotoStand:Clear()
  self:PlaySlide()
  TableUtility.TableClear(self.objects)
  TableUtility.TableClear(self.renderers)
  TableUtility.TableClear(self.transCount)
  TableUtility.TableClear(self.lastPhoto)
  self.ori_mat = nil
end

local shaderABPath = "Public/Shader"
local shaderAssetName = "SceneObject-textrans"

function GOManager_PhotoStand:InitOriMat(finishCb)
  if self.ori_mat == nil then
    local seg_SetOriMat = function(shader)
      if shader then
        self.ori_mat = Material(shader)
        self.ori_mat:SetColor("_LightMapColor", LuaColor.New(0.9019607843137255, 0.9019607843137255, 0.9019607843137255, 0))
      else
        redlog("cant find shader [RO/SceneObject/TexTransition] at Public/Shader/SceneObject-textrans")
      end
    end
    local shader = Shader.Find("RO/SceneObject/TexTransition")
    if shader then
      seg_SetOriMat(shader)
    else
      Game.AssetManager:LoadByTypeAsync(shaderABPath, Shader, function(shader)
        seg_SetOriMat(shader)
        if finishCb then
          finishCb()
        end
      end, shaderAssetName)
      return
    end
  end
  if finishCb then
    finishCb()
  end
end

function GOManager_PhotoStand:HasPhotoFrame(checkIDList)
  local not_empty = self.objects ~= nil and next(self.objects) ~= nil
  if not not_empty or not checkIDList then
    return not_empty
  end
  for _, v in pairs(checkIDList) do
    if self.objects[v] then
      return true
    end
  end
  return false
end

function GOManager_PhotoStand:PlaySlide(frame, newPhoto)
  self:SetPhoto(frame, newPhoto)
end

function GOManager_PhotoStand:SetPhoto(frameID, photo, photoWidth, photoHeight, angleZ)
  local obj = self.objects[frameID]
  if nil == obj then
    return
  end
  local renderer = self.renderers[frameID]
  if nil == renderer then
    if nil == photo then
      return
    end
    renderer = obj:GetComponentProperty(0)
    self.renderers[frameID] = renderer
  elseif nil == photo then
    renderer.material = nil
    renderer.materials = _EmptyTable
    self.renderers[frameID] = nil
    return
  end
  self:InitOriMat(function()
    self:SetPhoto_Part2(renderer, frameID, photo, photoWidth, photoHeight, angleZ)
  end)
end

function GOManager_PhotoStand:SetPhoto_Part2(renderer, frameID, photo, photoWidth, photoHeight, angleZ)
  if not renderer then
    return
  end
  if not self.transCount[frameID] then
    self.transCount[frameID] = 0
  end
  self.transCount[frameID] = self.transCount[frameID] + 1
  if self.transCount[frameID] == 1 then
    renderer.material = self.ori_mat
  end
  local lastPhoto = self.lastPhoto[frameID]
  if isNil(lastPhoto) then
    lastPhoto = photo
  end
  renderer.material:SetTexture("_MainTex", lastPhoto)
  renderer.material:SetTextureScale("_MainTex", LuaVector2.New(1, FramePhotoAspect))
  renderer.material:SetTextureOffset("_MainTex", LuaVector2.New(0, (1 - FramePhotoAspect) / 2))
  renderer.material:SetTexture("_MainTex2", photo)
  renderer.material:SetTextureScale("_MainTex2", LuaVector2.New(1, FramePhotoAspect))
  renderer.material:SetTextureOffset("_MainTex2", LuaVector2.New(0, (1 - FramePhotoAspect) / 2))
  self.lastPhoto[frameID] = photo
  renderer.material:SetFloat("_transStart", Time.timeSinceLevelLoad)
end

function GOManager_PhotoStand:SetPhotoFrame(obj, ID)
  self.objects[ID] = obj
  if nil ~= obj then
    local bcs = obj.gameObject:GetComponentsInChildren(BoxCollider)
    for i = 1, #bcs do
      bcs[i].gameObject.layer = Game.ELayer.Accessable
    end
    local renderer = obj:GetComponentProperty(0)
    renderer.material = nil
    renderer.materials = _EmptyTable
  else
    local renderer = self.renderers[ID]
    if renderer then
      renderer.material = nil
      renderer.materials = _EmptyTable
    end
    self.renderers[ID] = nil
    self.transCount[ID] = nil
  end
end

function GOManager_PhotoStand:OnClick(obj)
end

function GOManager_PhotoStand:ClearPhotoFrame(obj)
  local objID = obj.ID
  local testObj = self.objects[objID]
  if nil ~= testObj and testObj == obj then
    self:SetPhotoFrame(nil, objID)
    return true
  end
  return false
end

function GOManager_PhotoStand:RegisterGameObject(obj)
  return true
end

function GOManager_PhotoStand:UnregisterGameObject(obj)
  return true
end

function GOManager_PhotoStand:RegisterGameObject4NNpc(obj, id)
  obj.ID = id
  local objID = obj.ID
  Debug_AssertFormat(0 < objID, "RegisterScenePhotoFrame({0}) invalid id: {1}", obj, objID)
  self:SetPhotoFrame(obj, objID)
  FunctionPhotoStand.Me():TrySetPhoto4Frame(obj)
  return true
end

function GOManager_PhotoStand:UnregisterGameObject4NNpc(obj)
  if not self:ClearPhotoFrame(obj) then
    Debug_AssertFormat(false, "UnregisterScenePhotoFrame({0}) failed: {1}", obj, obj.ID)
    return false
  end
  FunctionPhotoStand.Me():UnregisterLuaGO(obj.ID)
  return true
end
