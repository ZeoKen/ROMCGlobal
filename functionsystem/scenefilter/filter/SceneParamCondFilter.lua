SceneParamCondFilter = class("SceneParamCondFilter")

function SceneParamCondFilter.Me()
  if nil == SceneParamCondFilter.me then
    SceneParamCondFilter.me = SceneParamCondFilter.new()
  end
  return SceneParamCondFilter.me
end

function SceneParamCondFilter:ctor()
end

function SceneParamCondFilter.CheckParam_GUID(creature, paramCond)
  return false
end

function SceneParamCondFilter.CheckParam_LuaGameObjectType(luago, paramCond)
  local comp = luago and luago.transform and luago.transform:GetComponent(LuaGameObject)
  if not comp then
    return
  end
  return comp.type and TableUtility.ArrayFindIndex(paramCond, comp.type) > 0
end

function SceneParamCondFilter.CheckParam_LuaGameObjectID(luago, paramCond)
  local comp = luago and luago.transform and luago.transform:GetComponent(LuaGameObject)
  if not comp then
    return
  end
  return comp.ID and TableUtility.ArrayFindIndex(paramCond, comp.ID) > 0
end
