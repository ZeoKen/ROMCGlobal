autoImport("OnGroundSceneItemCommand")
FunctionSceneItemCommand = class("FunctionSceneItemCommand")
local ConfigPrivateOwnTime = GameConfig.SceneDropItem.privateOwnTime

function FunctionSceneItemCommand.Me()
  if nil == FunctionSceneItemCommand.me then
    FunctionSceneItemCommand.me = FunctionSceneItemCommand.new()
  end
  return FunctionSceneItemCommand.me
end

function FunctionSceneItemCommand:ctor()
  self.onGroundCmd = OnGroundSceneItemCommand.Me()
  self.waiting = {}
  self.appearing = {}
  if not self.timeTick then
    self.timeTick = TimeTickManager.Me():CreateTick(0, 33, function(self, deltaTime)
      for id, item in pairs(self.waiting) do
        if item:CanShow() then
          self:AppearFromWait(item)
        end
      end
    end, self, 1225)
  end
end

function FunctionSceneItemCommand:Clear()
  self.listPickUp = {}
  for _, item in pairs(self.waiting) do
    item:Destroy()
  end
  for _, item in pairs(self.appearing) do
    item:Destroy()
  end
  self.waiting = {}
  self.appearing = {}
  self.onGroundCmd:Clear()
end

function FunctionSceneItemCommand:DropItems(items)
  self:AddItems(items)
end

function FunctionSceneItemCommand:AddItems(items)
  for i = 1, #items do
    self:Appear(items[i])
  end
end

function FunctionSceneItemCommand:ItemDropEnd(item)
  self.appearing[item.id] = nil
  self.onGroundCmd:Add(item)
  local creatureId = self:GetCreatureIdByItemId(item.id)
  if creatureId then
    self.onGroundCmd:Pick(item.id, creatureId)
    self:SetToListPickUp(item.id, nil)
  end
end

function FunctionSceneItemCommand:Appear(item)
  if item:CanShow() then
    if self.appearing[item.id] then
      self.appearing[item.id]:Destroy()
      self.appearing[item.id] = nil
    end
    self.appearing[item.id] = item
    item:PlayAppear(self.ItemDropEnd, self)
  else
    self.waiting[item.id] = item
  end
end

function FunctionSceneItemCommand:AppearFromWait(item)
  self.waiting[item.id] = nil
  self.appearing[item.id] = item
  item:Appear(self.ItemDropEnd, self)
end

function FunctionSceneItemCommand:PickUpItem(creature, itemGuid)
  self:SetToListPickUp(itemGuid, creature.data.id)
  if self.waiting[itemGuid] then
    self.waiting[itemGuid]:SetNeedPickedUp(true)
    self:AppearFromWait(self.waiting[itemGuid])
  elseif self.appearing[itemGuid] then
    self.appearing[itemGuid]:SetNeedPickedUp(true)
  else
    self.onGroundCmd:Pick(itemGuid, creature.data.id)
  end
end

function FunctionSceneItemCommand:SetRemoveFlag(itemGuid)
  if self.waiting[itemGuid] and not self.waiting[itemGuid]:GetNeedPickedUp() then
    self.waiting[itemGuid]:Destroy()
    self.waiting[itemGuid] = nil
    SceneItemProxy.Instance:Remove(itemGuid)
  end
  if self.appearing[itemGuid] and not self.appearing[itemGuid]:GetNeedPickedUp() then
    self.appearing[itemGuid]:Destroy()
    self.appearing[itemGuid] = nil
    SceneItemProxy.Instance:Remove(itemGuid)
  end
  self.onGroundCmd:SetRemoveFlag(itemGuid)
end

function FunctionSceneItemCommand:SetToListPickUp(id, creatureId)
  if id == nil then
    return
  end
  self.listPickUp[id] = creatureId
end

function FunctionSceneItemCommand:GetCreatureIdByItemId(id)
  return self.listPickUp[id] or nil
end
