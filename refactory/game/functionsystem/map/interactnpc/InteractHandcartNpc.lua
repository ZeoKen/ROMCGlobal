autoImport("InteractNpc")
InteractHandcartNpc = class("InteractHandcartNpc", InteractNpc)

function InteractHandcartNpc:TryNotifyGetOn(handcartId)
  if self:IsFull() then
    return false
  end
  ServiceSceneUser3Proxy.Instance:CallAboardUserHandcartCmd(handcartId)
end

function InteractHandcartNpc:RequestGetOn(creature, cpid)
  self:GetOn(cpid, creature.data.id, nil, nil, creature)
  if creature and creature.assetRole then
    creature.assetRole:RestoreAction()
  end
end

function InteractNpc:RequestGetOff(charid)
  self:GetOff(charid)
end
