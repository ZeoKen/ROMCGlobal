MaxSceneGuildFlag = 8
LobbyFlagID = 9
GOManager_SceneGuildFlag = class("GOManager_SceneGuildFlag")
local tempVector2 = LuaVector2.Zero()
local guid = 0
local GenerateGuid = function()
  guid = guid + 1
  return guid
end
local CheckFlagInvalid = function()
  if GameConfig.SystemForbid.GVG or Table_FuncState[4] and not FunctionUnLockFunc.checkFuncStateValid(4) then
    return true
  end
  return false
end

function GOManager_SceneGuildFlag:ctor()
  self.objects = {}
  self.renderers = {}
  self.objGuildIDMap = {}
  self.refAtlases = {}
  self.lobbyFlagId = LobbyFlagID
  self.objectMap = {}
  self.gvgPointIdMap = {}
end

function GOManager_SceneGuildFlag:Clear()
  for obj, guildId in pairs(self.objGuildIDMap) do
    GuildPictureManager.Instance():RemoveGuildPicRelative(guildId)
  end
  for _, atlas in pairs(self.refAtlases) do
    atlas:RemoveRef()
  end
  TableUtility.TableClear(self.objects)
  TableUtility.TableClear(self.objectMap)
  TableUtility.TableClear(self.renderers)
  TableUtility.TableClear(self.objGuildIDMap)
  TableUtility.TableClear(self.refAtlases)
end

local GetStrongHoldId_ = function(obj, flagid)
  local strongHoldId = tonumber(obj:GetProperty(0))
  if nil ~= strongHoldId then
    return strongHoldId
  end
  return flagid
end

function GOManager_SceneGuildFlag:SetIconWithAtlas(strongHoldId, atlas, spriteData, guildId, color)
  if atlas == nil or spriteData == nil then
    return
  end
  local flagObjects = self.objects
  for flagId, obj in pairs(flagObjects) do
    local shID = GetStrongHoldId_(obj, flagId)
    if shID == strongHoldId and obj then
      local offset_x, offset_y, scale_x, scale_y, texture
      atlas:AddRef()
      texture = atlas.texture
      if not texture then
        atlas:RemoveRef()
        return
      end
      offset_x = spriteData.x / texture.width
      offset_y = (texture.height - spriteData.y - spriteData.height) / texture.height
      scale_x = spriteData.width / texture.width
      scale_y = spriteData.height / texture.height
      self:SetFlagIcon(flagId, texture, offset_x, offset_y, scale_x, scale_y, guildId, color)
      self.refAtlases[flagId] = atlas
    end
  end
end

function GOManager_SceneGuildFlag:SetIcon(strongHoldId, icon, offsetX, offsetY, scaleX, scaleY, guildId)
  local flagObjects = self.objects
  for flagId, obj in pairs(flagObjects) do
    local shID = GetStrongHoldId_(obj, flagId)
    if shID == strongHoldId then
      self:SetFlagIcon(flagId, icon, offsetX, offsetY, scaleX, scaleY, guildId)
    end
  end
end

function GOManager_SceneGuildFlag:ResetNewGvgFlag(flagid, portrait, guildid)
  local obj = self.objects[flagid]
  if not obj then
    return
  end
  local flagGo = obj.gameObject
  if flagGo.activeInHierarchy ~= true then
    flagGo:SetActive(true)
  end
  FunctionGuild.Me():SetGuildLandIcon(flagid, portrait, guildid)
end

function GOManager_SceneGuildFlag:HideNewGvgFlag(flagid)
  local obj = self.objects[flagid]
  if not obj then
    return
  end
  local flagGo = obj.gameObject
  if flagGo.activeInHierarchy ~= false then
    flagGo:SetActive(false)
  end
end

function GOManager_SceneGuildFlag:SetFlagIcon(flagID, icon, offsetX, offsetY, scaleX, scaleY, guildId, color)
  local obj = self.objects[flagID]
  if nil == obj then
    return
  end
  local renderer = self.renderers[flagID]
  local renderer2 = obj:GetComponentProperty(1)
  if nil == renderer then
    if nil == icon then
      return
    end
    renderer = obj:GetComponentProperty(0)
    self.renderers[flagID] = renderer
  elseif nil == icon then
    renderer.material = nil
    renderer.materials = _EmptyTable
    if renderer2 then
      renderer2.material = nil
      renderer2.materials = _EmptyTable
    end
    if self.refAtlases[flagID] then
      self.refAtlases[flagID]:RemoveRef()
      self.refAtlases[flagID] = nil
    end
    self.renderers[flagID] = nil
    if self.objGuildIDMap[obj] then
      GuildPictureManager.Instance():RemoveGuildPicRelative(self.objGuildIDMap[obj])
      self.objGuildIDMap[obj] = nil
    end
    return
  end
  if Slua.IsNull(renderer) then
    return
  end
  renderer.material = Game.Prefab_SceneGuildIcon.sharedMaterial
  if color then
    local _, c = ColorUtil.TryParseHexString(color)
    if _ then
      renderer.material.color = c
    end
  end
  renderer.material.mainTexture = icon
  if renderer2 then
    renderer2.material = Game.Prefab_SceneGuildIcon.sharedMaterial
    renderer2.material.mainTexture = icon
  end
  if self.refAtlases[flagID] then
    self.refAtlases[flagID]:RemoveRef()
    self.refAtlases[flagID] = nil
  end
  local lastCustomIconGuildID = self.objGuildIDMap[obj]
  self.objGuildIDMap[obj] = guildId
  if lastCustomIconGuildID ~= guildId then
    if lastCustomIconGuildID then
      GuildPictureManager.Instance():RemoveGuildPicRelative(lastCustomIconGuildID)
    end
    if guildId then
      GuildPictureManager.Instance():AddGuildPicRelative(guildId)
    end
  end
  if nil ~= offsetX and nil ~= offsetY then
    LuaVector2.Better_Set(tempVector2, offsetX, offsetY)
    renderer.material.mainTextureOffset = tempVector2
    if renderer2 then
      renderer2.material.mainTextureOffset = tempVector2
    end
  end
  if nil ~= scaleX and nil ~= scaleY then
    LuaVector2.Better_Set(tempVector2, scaleX, scaleY)
    renderer.material.mainTextureScale = tempVector2
    if renderer2 then
      renderer2.material.mainTextureScale = tempVector2
    end
  end
end

function GOManager_SceneGuildFlag:SetFlag(obj, guid, city_id)
  self.objects[guid] = obj
  if nil ~= obj then
    self.objectMap[obj] = guid
    local renderer = obj:GetComponentProperty(0)
    renderer.material = nil
    renderer.materials = _EmptyTable
    local renderer2 = obj:GetComponentProperty(1)
    if renderer2 then
      renderer2.material = nil
      renderer2.materials = _EmptyTable
    end
    if self.refAtlases[guid] then
      self.refAtlases[guid]:RemoveRef()
      self.refAtlases[guid] = nil
    end
    if self.objGuildIDMap[obj] then
      GuildPictureManager.Instance():RemoveGuildPicRelative(self.objGuildIDMap[obj])
      self.objGuildIDMap[obj] = nil
    end
  else
    self.renderers[guid] = nil
  end
  if not obj then
    return
  end
  if guid == LobbyFlagID then
    GvgProxy.Instance:TryResetLobbyFlag()
    return
  end
  local strongHoldId = tonumber(obj:GetProperty(0))
  if strongHoldId then
    if GvgProxy.GetStrongHoldStaticData(strongHoldId) then
      FunctionGuild.Me():SetStrongHoldFlag(strongHoldId)
    end
    return
  end
  if not Game.MapManager:IsPVPMode_GVGDetailed() and city_id then
    FunctionGuild.Me():SetGuildFlagIcon(guid, city_id)
  else
  end
end

function GOManager_SceneGuildFlag:OnClick(obj)
  if Table_FuncState[4] and not FunctionUnLockFunc.checkFuncStateValid(4) then
    MsgManager.ShowMsgByID(40003)
    return
  end
  if Game.MapManager:IsInGVGRaid() then
    return
  end
  local strongHoldId = GetStrongHoldId_(obj, obj.ID)
  FunctionVisitNpc.AccessGuildFlag(strongHoldId, obj.transform)
end

function GOManager_SceneGuildFlag:ClearFlag(obj)
  local guid = self.objectMap[obj]
  local testObj = self.objects[guid]
  if nil ~= testObj and testObj == obj then
    self:SetFlag(nil, guid)
    return true
  end
  return false
end

function GOManager_SceneGuildFlag:RegisterGameObject(obj)
  if CheckFlagInvalid() then
    GameObject.Destroy(obj.gameObject)
    return true
  end
  local objID = obj.ID
  Debug_AssertFormat(0 < objID, "RegisterSceneGuildFlag({0}) invalid id: {1}", obj, objID)
  local isCity = nil ~= GvgProxy.GetStrongHoldStaticData(objID)
  if isCity then
    local guid = objID * 10000 + GenerateGuid()
    self:SetFlag(obj, guid, objID)
  else
    self:TryCacheBaseModePointID(objID)
    self:SetFlag(obj, objID)
  end
  return true
end

function GOManager_SceneGuildFlag:TryCacheBaseModePointID(config_point_id)
  if not config_point_id then
    return
  end
  if 10 <= config_point_id and config_point_id <= 89 then
    local point_id = config_point_id // 10
    local map = self.gvgPointIdMap[point_id]
    if not map then
      map = {}
      self.gvgPointIdMap[point_id] = map
    end
    map[config_point_id] = 1
  end
end

function GOManager_SceneGuildFlag:ClearPointMap()
  TableUtility.TableClear(self.gvgPointIdMap)
end

function GOManager_SceneGuildFlag:GetPointMap(point_id)
  return self.gvgPointIdMap[point_id]
end

function GOManager_SceneGuildFlag:GetLobbyFlagId()
  return self.lobbyFlagId
end

function GOManager_SceneGuildFlag:UnregisterGameObject(obj)
  if CheckFlagInvalid() then
    return true
  end
  local guid = self.objectMap[obj]
  self.objects[guid] = nil
  self.objectMap[obj] = nil
  if self.refAtlases[guid] then
    self.refAtlases[guid]:RemoveRef()
    self.refAtlases[guid] = nil
  end
  if self.objGuildIDMap[obj] then
    GuildPictureManager.Instance():RemoveGuildPicRelative(self.objGuildIDMap[obj])
    self.objGuildIDMap[obj] = nil
  end
  self.renderers[guid] = nil
  return true
end
