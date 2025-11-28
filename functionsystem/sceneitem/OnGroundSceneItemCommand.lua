OnGroundSceneItemCommand = class("OnGroundSceneItemCommand")

function OnGroundSceneItemCommand.Me()
  if nil == OnGroundSceneItemCommand.me then
    OnGroundSceneItemCommand.me = OnGroundSceneItemCommand.new()
  end
  return OnGroundSceneItemCommand.me
end

function OnGroundSceneItemCommand:ctor()
  self.itemMap = {}
  if not self.timeTick then
    self.timeTick = TimeTickManager.Me():CreateTick(0, 33, self.Tick, self, 11)
  end
end

function OnGroundSceneItemCommand:Tick(deltaTime)
  for id, item in pairs(self.itemMap) do
    local creatureId = FunctionSceneItemCommand.Me():GetCreatureIdByItemId(id)
    if creatureId then
      self:Pick(id, creatureId)
      FunctionSceneItemCommand.Me():SetToListPickUp(id, nil)
    elseif item:CanBeDestroyed() then
      self:Remove(id)
    end
  end
end

function OnGroundSceneItemCommand:Add(item)
  self.itemMap[item.id] = item
end

function OnGroundSceneItemCommand:Remove(id)
  local item = self.itemMap[id]
  if item then
    item:Destroy()
    self.itemMap[id] = nil
  end
  SceneItemProxy.Instance:Remove(id)
end

function OnGroundSceneItemCommand:Clear()
  for id, v in pairs(self.itemMap) do
    self:Remove(id)
  end
end

function OnGroundSceneItemCommand:SetRemoveFlag(id)
  local item = self.itemMap[id]
  if item and not item:GetNeedPickedUp() then
    self.itemMap[id] = nil
    item:Destroy()
  end
end

function OnGroundSceneItemCommand:Pick(id, creatureID)
  local item = self.itemMap[id]
  if not item then
    return false
  end
  item:SetNeedPickedUp(true)
  item:Pick(self.PickSuccess, self, creatureID)
  return true
end

local tmpPos = LuaVector3.Zero()

function OnGroundSceneItemCommand.PickSuccess(item, self, creatureID)
  if creatureID then
    local creature = SceneCreatureProxy.FindCreature(creatureID)
    if creature then
      local path = GameConfig.SceneDropItem.ItemPickBall[item.staticData.Quality]
      local pos = tmpPos
      if item.pointSub then
        pos[1], pos[2], pos[3] = LuaGameObject.GetPosition(item.pointSub:GetEffectPoint(RoleDefines_EP.Top).transform)
      else
        pos = item.pos
      end
      creature:PlayPickUpTrackEffect(path, pos, GameConfig.SceneDropItem.ItemPickBallSpeed, item.config.pickedAudio)
    end
  end
  self:Remove(item.id)
end
