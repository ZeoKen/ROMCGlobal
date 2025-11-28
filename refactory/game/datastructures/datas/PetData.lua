autoImport("Table_PetAvatar")
PetData = reusableClass("PetData", NpcData)
PetData.PoolSize = 50

function PetData:ctor()
  PetData.super.ctor(self)
  self.ownerID = nil
end

function PetData:GetHoldScale()
  if self.petStaticData and self.petStaticData.BeHoldScale then
    return self.petStaticData.BeHoldScale
  end
  return 1
end

function PetData:GetHoldDir()
  if self.petStaticData and self.petStaticData.BeHoldDir then
    return self.petStaticData.BeHoldDir
  end
  return 0
end

function PetData:GetHoldOffset()
  if self.petStaticData and self.petStaticData.BeHoldOffset then
    return self.petStaticData.BeHoldOffset
  end
  return PetData.super.GetHoldOffset(self)
end

function PetData:GetCamp()
  if self.ownerID then
    local owner = SceneCreatureProxy.FindCreature(self.ownerID)
    if owner then
      return owner.data:GetCamp()
    else
      return PetData.super.GetCamp(self)
    end
  end
  return RoleDefines_Camp.NEUTRAL
end

function PetData:GetTeamID()
  return PetData.super.GetTeamID(self)
end

function PetData:GetGroupTeamID()
  return PetData.super.GetGroupTeamID(self)
end

function PetData:SetOwnerID(ownerID)
  self.ownerID = ownerID
end

function PetData:GetDynamicSkillInfo(skillID)
  return CreatureSkillProxy.Instance:GetDynamicSkillInfoByID(self.staticData.id, skillID)
end

local PART_INDEX = {
  [5] = "Head",
  [6] = "Wing",
  [7] = "Face",
  [8] = "Tail",
  [10] = "Mouth"
}
local GetEquipId = function(id, cfg)
  if cfg then
    for k, v in pairs(cfg) do
      local cfgId = v.id or v.FakeID / 1000
      if id == cfgId then
        return v.FakeID or v.id
      end
    end
  end
  return 0
end

function PetData:GetDressParts()
  local parts = PetData.super.GetDressParts(self)
  if self.petStaticData == nil then
    return parts
  end
  local hasPreviewData = FunctionPet.Me():ExistPreviewData()
  if self.useServerDressData or hasPreviewData then
    local userData = self.userdata
    if userData ~= nil then
      local staticParts = NSceneNpcProxy.Instance:GetOrCreatePartsFromStaticData(self.staticData)
      local cloned = NpcData.super.GetDressParts(self, staticParts)
      local bodyID = self:GetBodyId()
      if 0 == cloned[Asset_Role.PartIndex.Body] then
        cloned[Asset_Role.PartIndex.Body] = bodyID
      end
      if not bodyID then
        return
      end
      local petAvatar = Table_PetAvatar[bodyID]
      local previewData = FunctionPet.Me():GetPreviewData()
      for k, v in pairs(cloned) do
        local cfg_key = PART_INDEX[k]
        if v == 0 then
          cloned[k] = previewData and previewData[k] and petAvatar and GetEquipId(previewData[k], petAvatar[cfg_key]) or parts[k]
        elseif petAvatar and cfg_key and petAvatar[cfg_key] then
          cloned[k] = previewData and previewData[k] and GetEquipId(previewData[k], petAvatar[cfg_key]) or GetEquipId(v, petAvatar[cfg_key])
        end
      end
      return cloned
    end
  end
  return parts
end

function PetData:IsSkillNpc()
  if self:IsPioneerNpc_Detail() then
    return true
  end
  if self:IsSkillNpc_Detail() then
    return not self:NoAccessable()
  end
  if self:IsShadowNpc_Detail() then
    return true
  end
  if self:IsGhostNpc_Detail() then
    return true
  end
  return false
end

function PetData:IsCopyNpc()
  if self:IsCopyNpc_Detail() then
    return true
  end
  return false
end

function PetData:IsFollowMaster()
  if self:IsFollowMaster_Detail() then
    return true
  end
  return false
end

function PetData:GetGuildData()
  if self.ownerID and (self:IsCopyNpc() or self:IsFollowMaster() or self:IsPhantom()) then
    local owner = SceneCreatureProxy.FindCreature(self.ownerID)
    if owner then
      return owner.data:GetGuildData()
    else
      return PetData.super.GetGuildData(self)
    end
  end
  return PetData.super.GetGuildData(self)
end

function PetData:DoConstruct(asArray, serverData)
  PetData.super.DoConstruct(self, asArray, serverData)
  if NpcMonsterUtility.IsPetByData(self.staticData) then
    self.type = NpcData.NpcType.Pet
  end
  self.petStaticData = Table_Pet[serverData.npcID]
end

function PetData:GetBodyId()
  local parts = NSceneNpcProxy.Instance:GetOrCreatePartsFromStaticData(self.staticData)
  local DressParts = NpcData.super.GetDressParts(self, parts)
  if 0 ~= DressParts[RoleDefines_EquipBodyIndex.Body] then
    return DressParts[RoleDefines_EquipBodyIndex.Body]
  elseif self.petStaticData and Table_Monster[self.petStaticData.id] then
    return Table_Monster[self.petStaticData.id].Body
  end
end

function PetData:DoDeconstruct(asArray)
  PetData.super.DoDeconstruct(self, asArray)
  self.petStaticData = nil
end
