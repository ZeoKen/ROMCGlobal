SceneTargetFilter = class("SceneTargetFilter")

function SceneTargetFilter.Me()
  if nil == SceneTargetFilter.me then
    SceneTargetFilter.me = SceneTargetFilter.new()
  end
  return SceneTargetFilter.me
end

function SceneTargetFilter:ctor()
end

function SceneTargetFilter.CheckIsPlayer(creature)
  if not creature then
    return false
  end
  return creature:GetCreatureType() == Creature_Type.Player or creature:GetCreatureType() == Creature_Type.Me or TeamProxy.Instance:IsInMyTeam(creature.data.id)
end

function SceneTargetFilter.CheckIsNpc(creature)
  if not creature then
    return false
  end
  if creature:GetCreatureType() == Creature_Type.PlotFakeNPlayer then
    return true
  end
  if creature:GetCreatureType() == Creature_Type.Npc then
    return creature.data:IsNpc()
  end
  return false
end

function SceneTargetFilter.CheckIsMonster(creature)
  if not creature then
    return false
  end
  if creature:GetCreatureType() == Creature_Type.Npc then
    return creature.data:IsMonster()
  end
  return false
end

function SceneTargetFilter.CheckIsPet(creature)
  if not creature then
    return false
  end
  if TeamProxy.Instance:IsInMyTeam(creature.data.id) then
    return false
  end
  return creature:GetCreatureType() == Creature_Type.Pet
end

function SceneTargetFilter.CheckIsPetPartner(creature)
  if not creature then
    return false
  end
  return creature:GetCreatureType() == Creature_Type.Pet
end

function SceneTargetFilter.CheckIsLuaGO(luago)
  return luago and type(luago) == "userdata" and luago.transform and luago.transform:GetComponent(LuaGameObject) ~= nil
end

function SceneTargetFilter.CheckClassifyIsLuaGO(luago)
  return SceneTargetFilter.CheckIsLuaGO(luago)
end

function SceneTargetFilter.CheckClassifyIsCreature(creature)
  return creature and type(creature) == "table" and creature.data and creature.data.id
end
