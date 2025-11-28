autoImport("AssetManager_Effect")
autoImport("AssetManager_Enviroment")
autoImport("AssetManager_Role")
autoImport("AssetManager_UI")
autoImport("AssetManager_SceneItem")
autoImport("AssetManager_StageManager")
autoImport("AssetManager_Furniture")
AssetManagerRefactory = class("AssetManagerRefactory")

function AssetManagerRefactory.OnAssetLoaded(asset, args)
  args[2](args[3], asset, args[1], args[4])
  args[1] = nil
  args[2] = nil
  args[3] = nil
  args[4] = nil
  ReusableTable.DestroyArray(args)
end

function AssetManagerRefactory:ctor()
  self.resManager = ResourceManager.Instance
  self.amEffect = AssetManager_Effect.new(self)
  self.amEnviroment = AssetManager_Enviroment.new(self)
  self.amRole = AssetManager_Role.new(self)
  self.amUI = AssetManager_UI.new(self)
  self.amSceneItem = AssetManager_SceneItem.new(self)
  self.amStage = AssetManager_StageManager.new(self)
  self.amFurniture = AssetManager_Furniture.new(self)
  Game.AssetManager_Effect = self.amEffect
  Game.AssetManager_Enviroment = self.amEnviroment
  Game.AssetManager_Role = self.amRole
  Game.AssetManager_UI = self.amUI
  Game.AssetManager_SceneItem = self.amSceneItem
  Game.AssetManager_StageManager = self.amStage
  Game.AssetManager_Furniture = self.amFurniture
end

function AssetManagerRefactory:IsResManagerDestroyed()
  return Slua.IsNull(self.resManager)
end

function AssetManagerRefactory:PreLoad()
  self.amSceneItem:PreLoadSceneItem()
end

function AssetManagerRefactory:LoadAsset(path, type, callback, owner, custom)
  local asset = self.resManager:SLoadByType(path, type)
  callback(owner, asset, path, custom)
end

function AssetManagerRefactory:LoadAssetAsync(path, type, callback, owner, custom, assetName)
  self.resManager:SAsyncLoad(path, type, function(asset)
    if callback then
      callback(owner, asset, path, custom)
    end
  end, assetName ~= nil and assetName or "", 0)
end

function AssetManagerRefactory:LimitLoadAsset(sType, path, resType, callback, owner, custom, assetName, priority)
  LoadAssetManager.Ins:LimitLoadAsset(sType, path, resType, function(asset)
    if callback then
      callback(owner, asset, path, custom)
    end
  end, priority or 0)
end

function AssetManagerRefactory:PreLoadAsset(path, prefix, callback, assetName, priority)
  LoadAssetManager.Ins:PreLoadAsset(path, prefix, function(asset)
    if callback then
      callback(asset)
    end
  end, assetName or "", priority or 0)
end

function AssetManagerRefactory:CancelLoadAsset(sType, path)
  LoadAssetManager.Ins:CancelLoad(sType, path or "")
end

function AssetManagerRefactory:Load(path)
  return self.resManager:SLoad(path)
end

function AssetManagerRefactory:LoadAsync(path, callback, assetName, callbackParam)
  self.resManager:SAsyncLoad(path, function(asset)
    if callback then
      callback(asset, callbackParam)
    end
  end, assetName ~= nil and assetName or "", 0)
end

local audioClipCache = {}

function AssetManagerRefactory:ClearAudioClips()
  for path, audioClip in pairs(audioClipCache) do
    self.resManager:SUnLoad(path, false)
  end
  audioClipCache = {}
end

function AssetManagerRefactory:LoadByType(path, type)
  if type == AudioClip then
    local asset = audioClipCache[path]
    if asset == nil then
      asset = self.resManager:SLoadByType(path, type)
      audioClipCache[path] = asset
    end
    return asset
  end
  return self.resManager:SLoadByType(path, type)
end

function AssetManagerRefactory:LoadBgm(path)
  local asset = self.resManager:SLoadByType(path, AudioClip)
  return asset
end

function AssetManagerRefactory:UnloadBgm(path)
  self.resManager:SUnLoad(path, true)
end

function AssetManagerRefactory:LoadByTypeAsync(path, type, callback, assetName)
  if type == AudioClip then
    local asset = audioClipCache[path]
    if asset == nil then
      self.resManager:SAsyncLoad(path, type, function(asset)
        audioClipCache[path] = asset
        if callback then
          callback(asset)
        end
      end, assetName ~= nil and assetName or "", 0)
    end
  else
    self.resManager:SAsyncLoad(path, type, function(asset)
      if callback then
        callback(asset)
      end
    end, assetName ~= nil and assetName or "", 0)
  end
end

function AssetManagerRefactory:PreloadAsset(path, type)
  return self.resManager:SLoadByType(path, type)
end

function AssetManagerRefactory:PreloadAssetAsync(path, type, callback, assetName)
  self:LoadByTypeAsync(path, type, callback, assetName)
end

function AssetManagerRefactory:UnloadAsset(path)
  self.resManager:SUnLoad(path, false)
end

function AssetManagerRefactory:Update(time, deltaTime)
  self.amEffect:Update(time, deltaTime)
  self.amEnviroment:Update(time, deltaTime)
  self.amRole:Update(time, deltaTime)
  self.amStage:Update(time, deltaTime)
  self.amSceneItem:Update(time, deltaTime)
end
