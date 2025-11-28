FakeNPlayerData = reusableClass("FakeNPlayerData", PlayerData)

function FakeNPlayerData:NoPlayShow()
  if self.staticData then
    return 1 == selfData.staticData.DisablePlayshow
  end
end

function FakeNPlayerData:GetFeature(bit)
  if self.staticData and self.staticData.Features then
    return self.staticData.Features & bit > 0
  end
  return false
end

function FakeNPlayerData:GetFeature_BeHold()
  return self:GetFeature(4)
end

function FakeNPlayerData:NoPlayIdle()
  if self.staticData then
    return 1 == selfData.staticData.DisableWait
  end
end

function FakeNPlayerData:GetDefaultGear()
  if self.staticData then
    return self.staticData.DefaultGear
  end
end

function FakeNPlayerData:GetDefaultScale()
  if self.staticData then
    return self.staticData.Scale or 1
  end
  return 1
end

function FakeNPlayerData:NoPlayIdle()
  if self.staticData then
    return 1 == self.staticData.DisableWait
  end
end

function FakeNPlayerData:NoPlayShow()
  if self.staticData then
    return 1 == self.staticData.DisablePlayshow
  end
end

function FakeNPlayerData:NoAutoAttack()
  if self.staticData then
    return 1 == self.staticData.NoAutoAttack
  end
end

function FakeNPlayerData:GetGroupID()
  return self.groupid
end

function FakeNPlayerData:DoConstruct(asArray, fakeData)
  FakeNPlayerData.super.DoConstruct(self, asArray, fakeData)
  if fakeData.fullparam then
    self.staticData = fakeData.fullparam
  elseif fakeData.npcid then
    self.staticData = Table_Npc[fakeData.npcid]
  elseif fakeData.monsterid then
    self.staticData = Table_Monster[fakeData.monsterid]
  end
  self.id = fakeData.id
  self.groupid = fakeData.groupid
  if fakeData.name then
    self.name = fakeData.name
  end
end

function FakeNPlayerData:DoDeconstruct(asArray)
  FakeNPlayerData.super.DoDeconstruct(self, asArray)
  self.staticData = nil
  self.beHoldedDirX = nil
  self.beHoldedDirY = nil
  self.beHoldedOffset = nil
end

function FakeNPlayerData:GetDressParts()
  return FakeNPlayerData.super.super.GetDressParts(self)
end

function FakeNPlayerData:GetHoldScale()
  local scale = self.beHoldedScale or self.staticData and self.staticData.Scale or 1
  return scale
end

function FakeNPlayerData:SetBeHoldedInfo(dirX, dirY, offset, scale)
  self.beHoldedDirX = dirX
  self.beHoldedDirY = dirY
  if offset then
    self.beHoldedOffset = LuaGeometry.GetTempVector3(offset[1], offset[2], offset[3])
  end
  if scale then
    self.beHoldedScale = scale
  end
end

function FakeNPlayerData:GetHoldDir()
  xdlog("GetHoldDir", self.beHoldedDirY)
  return self.beHoldedDirY or 0
end

function FakeNPlayerData:GetHoldDirX()
  xdlog("GetHoldDirX", self.beHoldedDirX)
  return self.beHoldedDirX or 0
end

function FakeNPlayerData:GetHoldOffset()
  if self.beHoldedOffset then
    return self.beHoldedOffset
  end
  return FakeNPlayerData.super.GetHoldOffset(self)
end

FakeNPlayer = reusableClass("FakeNPlayer", NPlayer)

function FakeNPlayer.CreateNpc(guid, npcID, pos)
  local fakeServerData
  if Table_Npc[npcID] then
    fakeServerData = {}
    fakeServerData.id = guid
    fakeServerData.name = Table_Npc[npcID].NameZh
    fakeServerData.npcid = npcID
  elseif Table_Monster[npcID] then
    fakeServerData = {}
    fakeServerData.id = guid
    fakeServerData.name = Table_Monster[npcID].NameZh
    fakeServerData.monsterid = npcID
  end
  if fakeServerData then
    fakeServerData.pos = {
      x = pos[1] * 1000,
      y = pos[2] * 1000,
      z = pos[3] * 1000
    }
    fakeServerData.attrs = {}
    fakeServerData.datas = {}
    return FakeNPlayer.CreateAsTable(fakeServerData)
  end
  return nil
end

function FakeNPlayer:SetNpcDress()
  if self.data.staticData then
    local parts = NSceneNpcProxy.Instance:GetOrCreatePartsFromStaticData(self.data.staticData)
    local userData = self.data.userdata
    local partIndex = Asset_Role.PartIndex
    userData:Set(UDEnum.BODY, parts[partIndex.Body] or 0)
    userData:Set(UDEnum.HAIR, parts[partIndex.Hair] or 0)
    userData:Set(UDEnum.LEFTHAND, parts[partIndex.LeftWeapon] or 0)
    userData:Set(UDEnum.RIGHTHAND, parts[partIndex.RightWeapon] or 0)
    userData:Set(UDEnum.HEAD, parts[partIndex.Head] or 0)
    userData:Set(UDEnum.BACK, parts[partIndex.Wing] or 0)
    userData:Set(UDEnum.FACE, parts[partIndex.Face] or 0)
    userData:Set(UDEnum.TAIL, parts[partIndex.Tail] or 0)
    userData:Set(UDEnum.EYE, parts[partIndex.Eye] or 0)
    userData:Set(UDEnum.MOUNT, parts[partIndex.Mount] or 0)
    userData:Set(UDEnum.MOUTH, parts[partIndex.Mouth] or 0)
    local partIndexEx = Asset_Role.PartIndexEx
    userData:Set(UDEnum.SEX, parts[partIndexEx.Gender] or 0)
    userData:Set(UDEnum.HAIRCOLOR, parts[partIndexEx.HairColorIndex] or 0)
    userData:Set(UDEnum.CLOTHCOLOR, parts[partIndexEx.BodyColorIndex] or 0)
    self:ReDress()
  end
end

function FakeNPlayer:GetDressParts()
  local parts = FakeNPlayer.super.GetDressParts(self)
  local staticData = self.data.staticData
  if staticData then
    local id = staticData.DefaultRolePartID
    if id ~= nil then
      local config = Table_RoleParts[id]
      if config ~= nil then
        parts[Asset_Role.PartIndexEx.DefaultBody] = config.Body
        parts[Asset_Role.PartIndexEx.DefaultHair] = config.Hair
        parts[Asset_Role.PartIndexEx.DefaultEye] = config.Eye
      end
    end
  end
  return parts
end

function FakeNPlayer:GetCreatureType()
  return Creature_Type.PlotFakeNPlayer
end

function FakeNPlayer:_InitData(fakeData)
  if self.data == nil then
    return FakeNPlayerData.CreateAsTable(fakeData)
  end
  return nil
end

function FakeNPlayer:DoConstruct(asArray, fakeData)
  FakeNPlayer.super.DoConstruct(self, asArray, fakeData)
  self.data:SetDressEnable(true)
  self:SetNpcDress()
  self:SetUserdataData()
  self:SetShadowEnable()
  self.assetRole:SetNpcDefaultExpression(fakeData.DefaultExpression, fakeData.ReplaceActionExpresssion)
end

function FakeNPlayer:DoDeconstruct(asArray)
  FakeNPlayer.super.DoDeconstruct(self, asArray)
end

function FakeNPlayer:RegisterRoleDress()
end

function FakeNPlayer:UnregisterRoleDress()
end

function FakeNPlayer:SetShadowEnable()
  local staticData = self.data.staticData
  if staticData ~= nil then
    self.assetRole:SetShadowEnable(staticData.move ~= 1)
    self.assetRole:SetShadowCastMode(staticData.ShadowCastOff == nil)
  end
end

function FakeNPlayer:SetUserdataData()
  if self.data.staticData then
    self.data.userdata:Set(UDEnum.SHOWNAME, self.data.staticData.ShowName)
  end
end

function FakeNPlayer:SetBeHoldedInfo(dirX, dirY, offset, scale)
  self.data:SetBeHoldedInfo(dirX, dirY, offset, scale)
end

function FakeNPlayer:SetRidingMount(mountID)
  self.ridingMount = mountID
end

function FakeNPlayer:UpdateRegisterMultiMount(enable)
  if enable then
    Game.InteractNpcManager:UpdateRegisterInteractMount(self.data.id, self.ridingMount, self)
  else
    local isMyselfRide = Game.InteractNpcManager:IsMyselfRideInteractMount()
    Game.InteractNpcManager:UpdateRegisterInteractMount(self.data.id)
    local myselfID = Game.Myself and Game.Myself.data and Game.Myself.data.id
    if isMyselfRide and self.data.id == myselfID then
      ServiceNUserProxy.Instance:CallKickOffPassengerUserCmd(0, true, false)
    end
  end
end
