RolePart_PlayShow = class("RolePart_PlayShow", ReusableObject)
RolePart_PlayShow.PoolSize = 100
local waitForActionCmdArray = {}
local PlayShowIntervalRange = {8, 15}
local PlayShowNameHash = ActionUtility.GetNameHash("flash")
local IdleNameHash = ActionUtility.GetNameHash(Asset_Role.ActionName.Idle)
local InstanceFindPredicate = function(instance, instanceID)
  return instance.instanceID == instanceID
end
local OnActionFinished = function(args)
  local instance, i = TableUtility.ArrayFindByPredicate(waitForActionCmdArray, InstanceFindPredicate, args)
  if instance ~= nil then
    args = instance.args
    args[1]:SetPartHaveOwnAction(args[2], false)
    local rolePart = args[1]:GetPartObject(args[2])
    if rolePart ~= nil then
      rolePart:PlayAction(IdleNameHash, IdleNameHash)
    end
  end
end

function RolePart_PlayShow.Create()
  return ReusableObject.Create(RolePart_PlayShow, true, nil)
end

function RolePart_PlayShow:ctor()
  self.args = {
    [1] = nil,
    [2] = 0
  }
  self.playShowStartTime = 0
end

function RolePart_PlayShow:SetParams(assetRole, partIndex)
  self.args[1] = assetRole
  self.args[2] = partIndex
end

function RolePart_PlayShow:LateUpdate(time, deltaTime)
  local args = self.args
  local assetRole = args[1]
  if assetRole:NoLogic() then
    return
  end
  local rolePart = assetRole:GetPartObject(args[2])
  if nil == rolePart then
    return
  end
  if self.playShowStartTime > 0 and time >= self.playShowStartTime then
    assetRole:SetPartHaveOwnAction(args[2], true)
    rolePart:PlayAction(PlayShowNameHash, IdleNameHash, 1, 0, OnActionFinished, self.instanceID)
    TableUtility.ArrayPushBack(waitForActionCmdArray, self)
    self.playShowStartTime = 0
  end
  if self.playShowStartTime == 0 then
    self.playShowStartTime = time + RandomUtil.Range(PlayShowIntervalRange[1], PlayShowIntervalRange[2])
  end
end

function RolePart_PlayShow:DoConstruct(asArray, args)
end

function RolePart_PlayShow:DoDeconstruct(asArray)
  self.args[1] = nil
  self.args[2] = 0
  self.playShowStartTime = 0
  TableUtility.ArrayRemove(waitForActionCmdArray, self)
end
