AssetManager_Furniture = class("AssetManager_Furniture")
local IsNull = Slua.IsNull
AssetManager_Furniture.OutlineShaderName = "RO/Furniture/Color"
AssetManager_Furniture.TransparentShaderName = "RO/Furniture/ColorAlpha"
AssetManager_Furniture.SceneObjShader = "RO/SceneObject/Lit"
AssetManager_Furniture.RoleShaderName = "RO/Role/PartOutline"
AssetManager_Furniture.RenderQueueOpaque = 2110
AssetManager_Furniture.RenderQueueTransparent = 3195

function AssetManager_Furniture.IsFurnitureBody(renderer)
  local material = renderer.material
  local shader = material and material.shader
  local shaderName = shader and shader.name
  return AssetManager_Furniture.IsFurnitureBodyShader(shaderName)
end

function AssetManager_Furniture.IsFurnitureBodyShader(shaderName)
  return shaderName == AssetManager_Furniture.OutlineShaderName or shaderName == AssetManager_Furniture.TransparentShaderName or shaderName == AssetManager_Furniture.RoleShaderName
end

function AssetManager_Furniture.IsSceneObj(renderer)
  if renderer.name == "shadow" or renderer.name == "shadow_side" then
    return false
  end
  local material = renderer.material
  local shader = material and material.shader
  local shaderName = shader and shader.name
  return shaderName == AssetManager_Furniture.SceneObjShader or AssetManager_Furniture.IsFurnitureBodyShader(shaderName)
end

function AssetManager_Furniture:ctor(assetManager)
  self.assetManager = assetManager
  self.tabMaterialMap = {}
  self.tabShaderMap = {}
  self.isRunOnEditor = ApplicationInfo.IsRunOnEditor()
end

function AssetManager_Furniture:CreateFurniture(id, parent, callback)
  self:CreateAssetAsync(ResourcePathHelper.Furniture(id), parent, function(obj)
    if callback then
      callback(obj)
    end
  end)
end

function AssetManager_Furniture:CreateBuildSign(parent, callback)
  local obj = self:CreateAsset("Public/Home/Prefabs/HomeBuildSign", parent, function(obj)
    if not obj then
      return
    end
    local renderers = obj:GetComponentsInChildren(Renderer)
    local material
    for i = 1, #renderers do
      material = renderers[i].material
      material.renderQueue = material.renderQueue + 2
    end
    if callback then
      callback(obj)
    end
  end)
  return obj
end

function AssetManager_Furniture:CreateWorldGrid(mapName, floorIndex, parent, callback)
  return self:CreateAsset(ResourcePathHelper.HomeWorldGrid(mapName, floorIndex), parent, callback)
end

function AssetManager_Furniture:CreateBuildGridMask(parent, callback)
  local obj = self:CreateAssetAsync("Public/Home/Prefabs/HomeBuildGridMask", parent, function(obj)
    if not obj then
      return
    end
    local renderers = obj:GetComponentsInChildren(Renderer)
    local material
    for i = 1, #renderers do
      material = renderers[i].material
      material.renderQueue = material.renderQueue + 1
    end
    if callback then
      callback(obj)
    end
  end)
  return obj
end

function AssetManager_Furniture:CreatePetHouse(parent, callback)
  self:CreateAssetAsync("Public/Home/PetHouse/Normal_01_Pethouse/Normal_01_Pethouse", parent, function(obj)
    if callback then
      callback(obj)
    end
  end)
end

function AssetManager_Furniture:CreatPetbowl(parent, callback)
  self:CreateAssetAsync("Public/Home/PetHouse/Petbowl/Petbowl", parent, function(obj)
    if callback then
      callback(obj)
    end
  end)
end

function AssetManager_Furniture:CreateHomeMaterialModel(matID, parent, callback)
  local matStaticData = Table_HomeFurnitureMaterial[matID]
  if matStaticData then
    self:CreateAssetAsync("Public/Home/Prefabs/" .. matStaticData.Type, parent, function(obj)
      if not obj then
        return
      end
      local folderConfig = GameConfig.Home.MaterialModelType
      self:LoadHomeMaterial(matID, folderConfig[matStaticData.Type] or folderConfig.default, function(mat)
        if not mat then
          LuaGameObject.DestroyObject(obj)
          return
        end
        self:GetFurnitureShader(false, function(shader)
          local renderers = obj:GetComponentsInChildren(Renderer)
          for i = 1, #renderers do
            renderers[i].material = mat
            renderers[i].material.shader = shader
          end
          if callback then
            callback(obj)
          end
        end)
      end)
    end)
  end
end

function AssetManager_Furniture:CreateGardenHouse(houseID, parent, callback)
  self:CreateAssetAsync(ResourcePathHelper.GardenHouse(houseID), parent, function(obj)
    if not obj then
      return
    end
    if callback then
      callback(obj)
    end
  end)
end

function AssetManager_Furniture:CreateAssetAsync(path, parent, callBack)
  self.assetManager:LoadAsync(path, function(asset)
    if not asset then
      LogUtility.Error("加载资源失败: " .. path)
      return nil
    end
    local obj = GameObject.Instantiate(asset)
    if parent then
      obj.transform:SetParent(parent, false)
    end
    if callBack then
      callBack(obj)
    end
  end)
end

function AssetManager_Furniture:CreateAsset(path, parent, callBack)
  local asset = self.assetManager:Load(path)
  if not asset then
    LogUtility.Error("加载资源失败: " .. path)
    return nil
  end
  local obj = GameObject.Instantiate(asset)
  if parent then
    obj.transform:SetParent(parent, false)
  end
  if callBack then
    callBack(obj)
  end
  return obj
end

function AssetManager_Furniture:LoadHomeMaterial(id, folderName, callBack, callBackParam)
  if not id or not folderName then
    LogUtility.Error(string.format("加载材质失败! ID: %s, 文件夹: %s", tostring(id), tostring(folderName)))
    return
  end
  local key = id .. folderName
  if self.tabMaterialMap[key] then
    if callBack then
      callBack(self.tabMaterialMap[key], callBackParam)
    end
    return
  end
  local path = ResourcePathHelper.HomeMaterial(id, folderName)
  if path then
    self.assetManager:LoadAsync(path, function(asset)
      if not asset then
        LogUtility.Error(string.format("加载材质失败! ID: %s, 文件夹: %s, 路径: %s", tostring(id), tostring(folderName), tostring(path)))
      end
      self.tabMaterialMap[key] = asset
      if callBack then
        callBack(asset, callBackParam)
      end
    end)
  end
end

function AssetManager_Furniture:GetFurnitureShader(containsAlpha, callBack, callBackArgs)
  if containsAlpha then
    return self:FindShader(AssetManager_Furniture.TransparentShaderName, "Public/Shader/Furniture", "FurnitureAlpha", callBack, callBackArgs)
  else
    return self:FindShader(AssetManager_Furniture.OutlineShaderName, "Public/Shader/Furniture", "Furniture", callBack, callBackArgs)
  end
end

function AssetManager_Furniture:FindShader(shaderName, path, shaderAssetName, callBack, callBackArgs)
  local shader = self.tabShaderMap[shaderName]
  if shader == nil then
    self.assetManager:LoadByTypeAsync(path, Shader, function(obj)
      self.tabShaderMap[shaderName] = obj
      if callBack then
        callBack(obj, callBackArgs)
      end
    end, shaderAssetName)
  elseif callBack then
    callBack(shader, callBackArgs)
  end
end

function AssetManager_Furniture:ClearCache()
  TableUtility.TableClear(self.tabMaterialMap)
end

function AssetManager_Furniture:DestroyFurniture(gameobject)
  if nil == gameobject or IsNull(gameobject) then
    return
  end
  LuaGameObject.DestroyObject(gameobject)
end
