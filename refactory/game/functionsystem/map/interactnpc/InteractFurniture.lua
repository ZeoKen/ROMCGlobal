InteractFurniture = class("InteractFurniture", InteractBase)

function InteractFurniture.Create(data, id)
  local args = InteractBase.GetArgs(data, id)
  return ReusableObject.Create(InteractFurniture, false, args)
end

function InteractFurniture:GetOn(cpid, charid)
  InteractFurniture.super.GetOn(self, cpid, charid)
  if self.staticData.DoramOffset then
    local creature = self:GetCreature(charid)
    if creature and creature.data:IsDoram() then
      local offset = self.staticData.DoramOffset and self.staticData.DoramOffset[cpid]
      if offset then
        creature.assetRole:SetPosition(LuaGeometry.GetTempVector3(offset.x or 0, offset.y or 0, offset.z or 0))
      end
    end
  end
  if self.cpCount == 1 and not self:PlayAction(self.onActionid) then
    self:PlayAction(self.staticData.OnAction)
  end
  local myself = Game.Myself
  if charid == myself.data.id then
    myself:Client_SyncRotationY(0)
    FunctionSystem.InterruptMyselfAll()
  end
end

function InteractFurniture:GetOff(charid)
  InteractFurniture.super.GetOff(self, charid)
  if self.cpCount == 0 and not self:PlayAction(self.offActionid) then
    self:PlayAction(self.staticData.OffAction)
  end
end

function InteractFurniture:TryNotifyGetOn(param)
  if param ~= nil then
    self.onActionid = param.OnAction
    self.offActionid = param.OffAction
  end
  if self:IsFull() then
    if not self:IsMyselfOn() then
      MsgManager.ShowMsgByID(28000)
    end
    return false
  end
  ServiceHomeCmdProxy.Instance:CallFurnitureOperHomeCmd(HomeProxy.Oper.Interact, self.id)
  return true
end

function InteractFurniture:TryNotifyGetOff()
  ServiceHomeCmdProxy.Instance:CallFurnitureOperHomeCmd(HomeProxy.Oper.Stop, self.id)
  return true, true
end

function InteractFurniture:GetNpc()
  return HomeManager.Me():FindFurniture(self.id)
end

function InteractFurniture:GetCP(npc, cpid)
  return npc:GetCP(cpid)
end

function InteractFurniture:DoDeconstruct(asArray)
  InteractFurniture.super.DoDeconstruct(self, asArray)
  self.onActionid = nil
  self.offActionid = nil
end

function InteractFurniture:PlayOnAction(creature, name)
  creature:Logic_PlayAction_Simple(name)
end

function InteractFurniture:PlayAction(actionid)
  local npc = self:GetNpc()
  if npc == nil then
    return false
  end
  return npc:PlayActionByID(actionid)
end

function InteractFurniture:PlayOnAction(creature, name)
  local param = Asset_Role.GetPlayActionParams(name)
  param[6] = true
  creature.assetRole:PlayAction(param)
end

function InteractFurniture:IsMyselfOn()
  local charid = Game.Myself.data.id
  for k, v in pairs(self.cpMap) do
    if v == charid then
      return true
    end
  end
  return false
end
