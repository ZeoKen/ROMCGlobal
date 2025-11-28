AssetLoadEventDispatcher = class("AssetLoadEventDispatcher")
local arg = {}

function AssetLoadEventDispatcher:ctor()
  self.assetDownload = AssetDownload.Instance
  self.eventDispatcher = EventDispatcher.new()
  self.fileStatus = {}
  self.tags = {}
  self:Init()
end

function AssetLoadEventDispatcher:Init()
  local assetDownload = self.assetDownload
  if assetDownload ~= nil then
    assetDownload:SetCompleteHandler(AssetLoadEventDispatcher.OnAssetDownloadComplete)
    assetDownload:SetFailedHandler(AssetLoadEventDispatcher.OnAssetDownloadFailed)
  end
end

function AssetLoadEventDispatcher.OnAssetDownloadComplete(tag)
  if tag ~= nil then
    helplog("lua OnAssetDownloadComplete:" .. tag)
    arg.success = true
    arg.assetName = tag
    arg.errMsg = nil
    local _assetLoad = Game.AssetLoadEventDispatcher
    _assetLoad:PassEvent(tag, arg)
    _assetLoad:RefreshFileStatus(tag, 2)
  end
end

function AssetLoadEventDispatcher.OnAssetDownloadFailed(tag, errMsg)
  if tag ~= nil then
    helplog("lua OnAssetDownloadFailed:" .. tag .. ", errMsg:" .. errMsg)
    arg.success = false
    arg.assetName = tag
    arg.errMsg = errMsg
    local _assetLoad = Game.AssetLoadEventDispatcher
    _assetLoad:PassEvent(tag, arg)
    _assetLoad:RefreshFileStatus(tag, 0)
  end
end

function AssetLoadEventDispatcher:Destroy()
  self.eventDispatcher:ClearEvent()
  local assetDownload = self.assetDownload
  if assetDownload ~= nil then
    assetDownload:SetCompleteHandler(nil)
    assetDownload:SetFailedHandler(nil)
  end
  self.assetDownload = nil
end

function AssetLoadEventDispatcher:AddRequestUrl(assetName, pushBack)
  if pushBack == nil then
    pushBack = true
  end
  local assetDownload = self.assetDownload
  local tag = assetDownload ~= nil and assetDownload:AddRequestUrl(assetName, pushBack) or nil
  if tag then
    self.tags[tag] = assetName
  end
  return tag
end

function AssetLoadEventDispatcher:AddSceneRequestUrl(assetName)
  local assetDownload = self.assetDownload
  local tag = assetDownload ~= nil and assetDownload:AddSceneRequestUrl(assetName)
  if tag then
    self.tags[tag] = assetName
  end
  return tag
end

function AssetLoadEventDispatcher:AddGroupRequestUrl(list)
  local assetDownload = self.assetDownload
  local tag = assetDownload ~= nil and assetDownload:AddGroupRequestUrl(list)
  if tag then
    local taginfo = self.tags[tag]
    if taginfo == nil then
      taginfo = ReusableTable.CreateTable()
      self.tags[tag] = taginfo
    end
    for i = 0, list.Count - 1 do
      taginfo[list:getItem(i)] = 1
    end
  end
  return tag
end

function AssetLoadEventDispatcher:CancelRequest(assetName)
  local assetDownload = self.assetDownload
  if assetDownload ~= nil then
    assetDownload:CancelRequest(assetName)
  end
end

function AssetLoadEventDispatcher:AddEventListener(assetName, handler, handlerOwner)
  self.eventDispatcher:AddEventListener(assetName, handler, handlerOwner)
end

function AssetLoadEventDispatcher:RemoveEventListener(assetName, handler, handlerOwner)
  self.eventDispatcher:RemoveEventListener(assetName, handler, handlerOwner)
end

function AssetLoadEventDispatcher:PassEvent(assetName, args)
  self.eventDispatcher:PassEvent(assetName, args)
end

function AssetLoadEventDispatcher:RefreshFileStatus(tag, status)
  local assetName = self.tags[tag]
  if assetName then
    if type(assetName) == "table" then
      for k, v in pairs(assetName) do
        self.fileStatus[k] = status
        assetName[k] = nil
      end
      ReusableTable.DestroyTable(assetName)
    else
      self.fileStatus[assetName] = status
    end
    self.tags[tag] = nil
  end
end

function AssetLoadEventDispatcher:IsFileExist(assetName)
  local status = self.fileStatus[assetName]
  if status ~= nil then
    return status
  end
  local _PatchFileManager = PatchFileManager.Instance
  if _PatchFileManager == nil then
    return 2
  end
  status = _PatchFileManager:IsFileExist(assetName)
  self.fileStatus[assetName] = status
  return status
end
