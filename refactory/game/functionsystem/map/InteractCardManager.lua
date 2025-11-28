autoImport("InteractCard")
InteractCardManager = class("InteractCardManager")
local GameFacade = GameFacade.Instance
local ArrayPushBack = TableUtility.ArrayPushBack
local ArrayRemove = TableUtility.ArrayRemove
local ArrayClear = TableUtility.ArrayClear
local PartIndex = Asset_Role.PartIndex
local PartIndexEx = Asset_Role.PartIndexEx

function InteractCardManager:ctor()
  self.interactCardMap = {}
  self.assetRoleMap = {}
  self.interactCardCount = 0
end

function InteractCardManager:Update(time, deltaTime)
  if not self.running then
    return
  end
  if self.interactCardCount == 0 then
    return
  end
  self:Spin()
end

function InteractCardManager:Launch()
  if self.running then
    return
  end
  self.running = true
end

function InteractCardManager:Shutdown()
  if not self.running then
    return
  end
  self.running = false
  self:Clear()
end

function InteractCardManager:Clear()
end

function InteractCardManager:Spin()
end

function InteractCardManager:RegisterInteractCard(staticid, id)
end

function InteractCardManager:UnregisterInteractCard(id)
end

function InteractCardManager:AddInteractObject(id)
  self:RegisterInteractCard(id, id)
end

function InteractCardManager:RemoveInteractObject(id)
  self:UnregisterInteractCard(id)
end
