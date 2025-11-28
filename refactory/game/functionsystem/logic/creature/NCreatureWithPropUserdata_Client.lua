function NCreatureWithPropUserdata:Client_NoMove(v)
  local p = self.data:AddClientProp("NoMove", v and 1 or -1)
  
  self.data.noMove = self.data:PlusClientProp(p)
  redlog("Client_NoMove", v, p, self.data.noMove)
end

function NCreatureWithPropUserdata:Client_NoAttack(v)
  local p = self.data:AddClientProp("NoAttack", v and 1 or -1)
  self.data.noAttack = self.data:PlusClientProp(p)
end

function NCreatureWithPropUserdata:Client_NoAttacked(v)
  local p = self.data:AddClientProp("NoAttacked", v and 1 or -1)
  self.data.noAttacked = self.data:PlusClientProp(p)
end

function NCreatureWithPropUserdata:Client_NoRelive(noRelive)
  self.data.noRelive = self.data.noRelive + noRelive
end

function NCreatureWithPropUserdata:Client_NoAction(v)
  self.data.noAction = self.data.noAction + (v and 1 or -1)
  if self.data:NoAction() then
    self.assetRole:MoveActionStopped()
  end
end

function NCreatureWithPropUserdata:Client_NoMoveAction(v)
  self.data.noMoveAction = self.data.noMoveAction + (v and 1 or -1)
  if self.data:NoMoveAction() then
    self.assetRole:MoveActionStopped()
  end
end

function NCreatureWithPropUserdata:Client_NoRotate(v)
  self.data.noRotate = (self.data.noRotate or 0) + (v and 1 or -1)
end
