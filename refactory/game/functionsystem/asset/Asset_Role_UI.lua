Asset_Role_UI = class("Asset_Role_UI", Asset_Role)
Asset_Role_UI_Event = {
  PartCreated = "Asset_Role_UI_Event_PartCreated",
  PartDestroyed = "Asset_Role_UI_Event_PartDestroyed"
}
local hackAssetManager

function Asset_Role_UI.Create(parts, assetManager, onCreatedCallback, onCreatedCallbackArgs, mountForm)
  hackAssetManager = assetManager
  local args = ReusableTable.CreateArray()
  args[1] = parts
  args[2] = onCreatedCallback
  args[3] = onCreatedCallbackArgs
  args[4] = mountForm
  local obj = ReusableObject.Create(Asset_Role_UI, true, args)
  hackAssetManager = nil
  ReusableTable.DestroyAndClearArray(args)
  return obj
end

function Asset_Role_UI:OnPartCreated(tag, obj, part, ID, oldID)
  Asset_Role_UI.super.OnPartCreated(self, tag, obj, part, ID, oldID)
  if obj then
    self:NotifyObserver({
      Asset_Role_UI_Event.PartCreated,
      obj.gameObject,
      part
    })
  end
end

function Asset_Role_UI:_DestroyPartObject(part, oldID, undress)
  local oldPartObj = self.partObjs[part]
  if oldPartObj then
    self:NotifyObserver({
      Asset_Role_UI_Event.PartDestroyed,
      oldPartObj.gameObject,
      part
    })
  end
  Asset_Role_UI.super._DestroyPartObject(self, part, oldID, undress)
end

function Asset_Role_UI:Redress(parts, isLoadFirst)
  parts[Asset_Role.PartIndexEx.Download] = true
  Asset_Role_UI.super.Redress(self, parts, isLoadFirst)
end
