GOManager_TextMesh = class("GOManager_TextMesh")

function GOManager_TextMesh:ctor()
end

function GOManager_TextMesh:RegisterGameObject(obj)
  return true
end

function GOManager_TextMesh:UnregisterGameObject(obj)
  self:Clear(obj.gameObject:GetInstanceID())
end

function GOManager_TextMesh:SpawnEffect(creature, path, text, epID, loop, stick)
  local effect = creature:PlayEffect(path, path, epID, nil, loop, stick, function(go, args, assetEffect)
    self:_SetTextMeshRT("_MaskTex", assetEffect.effectObj, args)
  end, text)
  if effect ~= nil then
    effect:RegisterWeakObserver(self)
  end
end

function GOManager_TextMesh:SpawnModel(obj, text)
  self:_SetTextMeshRT("_MaskTex", obj, text)
end

function GOManager_TextMesh:ObserverDestroyed(obj)
  self:_ClearRT(obj:GetGOInstanceID())
end

function GOManager_TextMesh:_SetTextMeshRT(shaderTex, obj, text)
  if self.textMeshObj == nil then
    self.textMeshObj = Game.AssetManager_UI:CreateAsset("GUI/v1/root/TextMesh")
    self.textMesh = self.textMeshObj:GetComponent(TextMesh)
    self.camera = self.textMeshObj:GetComponentInChildren(Camera)
  else
    self.textMeshObj:SetActive(true)
  end
  self:_SetText(self.textMesh, text)
  local renderer = self.textMesh:GetComponent(Renderer)
  if renderer then
    self.camera.orthographicSize = renderer.bounds.size.x * 0.3
  end
  if self.rtmap == nil then
    self.rtmap = {}
  end
  local data = self.rtmap[text]
  if data == nil then
    data = {}
    data.instanceids = {}
    data.instanceids.count = 0
    if SystemInfo.IsFormatSupported(5, 4) then
      data.rt = RenderTexture.GetTemporary(256, 128, 16, 5)
    else
      data.rt = RenderTexture.GetTemporary(256, 128, 16, 7)
    end
    self.rtmap[text] = data
  end
  data.instanceids[obj:GetInstanceID()] = 1
  data.instanceids.count = data.instanceids.count + 1
  self.camera.targetTexture = data.rt
  self.camera:Render()
  local target = Game.GameObjectUtil:DeepFind(obj, "TextMesh")
  if target ~= nil then
    renderer = target:GetComponent(Renderer)
    if renderer then
      renderer.material:SetTexture(shaderTex, data.rt)
    end
  else
    error("GOManager_TextMesh Can't Find TextMesh")
  end
  self.camera.targetTexture = nil
  self.textMeshObj:SetActive(false)
end

function GOManager_TextMesh:_SetText(textMesh, text)
  if BranchMgr.IsChina() then
    textMesh.text = text
  else
    local overseaFont = OverSea.LangManager.Instance().overseasUGUIFont
    if nil ~= textMesh.font and nil ~= overseaFont then
      textMesh.font = overseaFont
      local mr = textMesh.gameObject:GetComponent("MeshRenderer")
      mr.material = textMesh.font.material
    end
    textMesh.text = OverSea.LangManager.Instance():GetLangByKey(text)
  end
end

function GOManager_TextMesh:Clear(id)
  self:_ClearRT(id)
  self:_ClearTM(id)
end

function GOManager_TextMesh:_ClearRT(id)
  if self.rtmap == nil then
    return
  end
  local instanceids
  for k, v in pairs(self.rtmap) do
    instanceids = v.instanceids
    if instanceids[id] == 1 then
      instanceids[id] = nil
      instanceids.count = instanceids.count - 1
      if instanceids.count == 0 then
        RenderTexture.ReleaseTemporary(v.rt)
        self.rtmap[k] = nil
      end
      break
    end
  end
end

function GOManager_TextMesh:_ClearTM(id)
  if self.textMeshObj == nil then
    return
  end
  for k, v in pairs(self.rtmap) do
    return
  end
  Object.DestroyImmediate(self.textMeshObj)
  self.textMeshObj = nil
  self.textMesh = nil
  self.camera = nil
end
