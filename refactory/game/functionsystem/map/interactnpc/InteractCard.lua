InteractCard = class("InteractCard", ReusableObject)
InteractCard.PoolSize = 13
local ParentNPC = 1689
local updateInterval = 1
local VectorDistanceXZ = VectorUtility.DistanceXZ
local TableClear = TableUtility.TableClear
local PartIndexBody = Asset_Role.PartIndex.Body
local LayerChangeReasonInteractNpc = LayerChangeReason.InteractNpc
local PUIVisibleReasonInteractNpc = PUIVisibleReason.InteractNpc

function InteractCard.GetArgs(staticData, npcGuid)
  tempArgs[1] = staticData
  tempArgs[2] = npcGuid
  return tempArgs
end

function InteractCard.Create(data)
  return ReusableObject.Create(InteractCard, true, data)
end

function InteractCard:ctor()
end

function InteractCard:Update(time, deltaTime)
  if self.npcid == nil then
    return false
  end
end

function InteractCard:GetCP(npc, cpid)
  return npc.assetRole:GetCP(cpid)
end

function InteractCard:DoConstruct(asArray, data)
  self.index = data[1]
  self.pivot = data[2]
  self.nextUpdateTime = 0
  self.cpCount = 0
end

function InteractCard:DoDeconstruct(asArray)
  self.staticData = nil
  self.npcid = nil
  self.nextUpdateTime = nil
end
