InteractNpc2Furniture = class("InteractNpc2Furniture", InteractBase)

function InteractNpc2Furniture.Create(data, id)
  local args = InteractBase.GetArgs(data, id)
  return ReusableObject.Create(InteractNpc2Furniture, false, args)
end

function InteractNpc2Furniture:GetNpc()
  return HomeManager.Me():FindFurniture(self.id)
end

function InteractNpc2Furniture:GetCP(npc, cpid)
  return npc:GetCP(cpid)
end

function InteractNpc2Furniture:GetCreature(charid)
  local char = NSceneNpcProxy.Instance:Find(charid)
  if char == nil then
    local allPets = HomeProxy.Instance:GetCurFeedingPet()
    if allPets ~= nil then
      for _, pet in ipairs(allPets) do
        if charid == pet.data.id then
          return pet
        end
      end
    end
  end
  return char
end

function InteractNpc2Furniture:PlayOnAction(creature, name)
  creature:Logic_PlayAction_Simple(name)
end

function InteractNpc2Furniture:IsOff(charid)
  local isOff = true
  for k, v in pairs(self.cpMap) do
    if v == charid then
      isOff = false
      break
    end
  end
  return isOff
end
