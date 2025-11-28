autoImport("Creature_SceneTopUI")
autoImport("Creature_SceneBottomUI")
Creature_SceneUI = reusableClass("Creature_SceneUI")
Creature_SceneUI.PoolSize = 50
local TableClear = TableUtility.TableClear

function Creature_SceneUI:ctor()
  Creature_SceneUI.super.ctor(self)
  self.roleTopUI = nil
  self.roleBottomUI = nil
  self.maskMap = {}
end

function Creature_SceneUI:MaskByType(uiType)
  local typeReasons = self.maskMap[uiType]
  if typeReasons then
    return typeReasons.count and typeReasons.count > 0 or false
  end
  return false
end

function Creature_SceneUI:CopyMaskFromOther(otherSceneui)
  if otherSceneui then
    TableClear(self.maskMap)
    for uiType, trs in pairs(otherSceneui.maskMap) do
      for reason, v in pairs(trs) do
        if reason ~= "count" then
          self:MaskUI(reason, uiType)
        end
      end
    end
  end
end

function Creature_SceneUI:MaskUI(reason, uiType, creature)
  local typeReasons = self.maskMap[uiType]
  if not typeReasons then
    typeReasons = {}
    self.maskMap[uiType] = typeReasons
  end
  if not typeReasons[reason] then
    typeReasons[reason] = reason
    typeReasons.count = typeReasons.count ~= nil and typeReasons.count + 1 or 1
    if typeReasons.count >= 1 then
      self:MaskSceneUI(uiType, creature)
    end
  end
end

function Creature_SceneUI:UnMaskUI(reason, uiType, creature)
  local typeReasons = self.maskMap[uiType]
  if typeReasons then
    if typeReasons[reason] ~= nil then
      typeReasons[reason] = nil
      typeReasons.count = typeReasons.count - 1
    end
    if typeReasons.count and typeReasons.count <= 0 then
      self:UnMaskSceneUI(uiType, creature)
    end
  end
end

function Creature_SceneUI:MaskSceneUI(maskPlayerUIType, creature)
  if self.roleTopUI then
    self.roleTopUI:ActiveSceneUI(maskPlayerUIType, false)
  end
  if self.roleBottomUI then
    self.roleBottomUI:ActiveSceneUI(maskPlayerUIType, false, creature)
  end
end

function Creature_SceneUI:UnMaskSceneUI(maskPlayerUIType, creature)
  if self.roleTopUI then
    self.roleTopUI:ActiveSceneUI(maskPlayerUIType, true)
  end
  if self.roleBottomUI then
    self.roleBottomUI:ActiveSceneUI(maskPlayerUIType, true, creature)
  end
end

function Creature_SceneUI:SetCreature(creature)
  self.creature = creature
  self.creatureId = creature.data.id
  if self.roleTopUI then
    self.roleTopUI:SetCreature(creature)
  end
  if self.roleBottomUI then
    self.roleBottomUI:SetCreature(creature)
  end
end

function Creature_SceneUI:DoConstruct(asArray, creature)
  creature.sceneui = self
  self.roleTopUI = Creature_SceneTopUI.CreateAsTable(creature)
  self.roleBottomUI = Creature_SceneBottomUI.CreateAsTable(creature)
end

function Creature_SceneUI:DoDeconstruct(asArray)
  self.roleTopUI:Destroy()
  self.roleBottomUI:Destroy()
  self.roleTopUI = nil
  self.roleBottomUI = nil
  for k, v in pairs(self.maskMap) do
    TableUtility.TableClear(v)
  end
end
