autoImport("BagItemDataFunctionCD")
autoImport("CDCtrlRefresher")
autoImport("TimerCDCtrlRefresher")
FunctionCDCommand = class("FunctionCDCommand")
local RemoveSkillCheck = function(cdData)
  if cdData:GetCdCount() > 0 then
    return false
  end
  return 0 >= cdData:GetCd()
end
local RemoveSkillDelay = function(cdData)
  if CDProxy.Instance:IsInCD(SceneUser2_pb.CD_TYPE_SKILL, CDProxy.CommunalSkillCDSortID) then
    return false
  end
  return cdData:GetCd() <= 0
end
local RemoveCheck = {
  [SceneUser2_pb.CD_TYPE_SKILL] = RemoveSkillCheck,
  [SceneUser2_pb.CD_TYPE_SKILLDEALY] = RemoveSkillDelay
}

function FunctionCDCommand.Me()
  if nil == FunctionCDCommand.me then
    FunctionCDCommand.me = FunctionCDCommand.new()
  end
  return FunctionCDCommand.me
end

function FunctionCDCommand:ctor()
  self:Reset()
end

function FunctionCDCommand:Reset()
  self.cmdMap = {}
end

function FunctionCDCommand:GetCDProxy(cmdClass, owner)
  owner = owner or cmdClass
  return self.cmdMap[owner]
end

function FunctionCDCommand:GetBagItemDataCDProxy(owner)
  return self:GetCDProxy(BagItemDataFunctionCD, owner)
end

function FunctionCDCommand:StopAllCD()
  for k, v in pairs(self.cmdMap) do
    v:SetEnable(false)
  end
end

function FunctionCDCommand:StopCD(cmdClass)
  local cmd = self.cmdMap[cmdClass]
  if cmd ~= nil then
    cmd:SetEnable(false)
  end
end

function FunctionCDCommand:StartCDProxy(cmdClass, interval, owner)
  owner = owner or cmdClass
  local cmd = self.cmdMap[owner]
  interval = interval or 33
  if cmd == nil then
    cmd = cmdClass.new(interval)
    self.cmdMap[owner] = cmd
  end
  return cmd
end

function FunctionCDCommand:StartAllCD()
  for k, v in pairs(self.cmdMap) do
    if v:IsRunning() == false then
      v:SetEnable(true)
    end
  end
end

function FunctionCDCommand:StartCD(cmdClass)
  local cmd = self.cmdMap[cmdClass]
  if cmd ~= nil then
    cmd:SetEnable(true)
  end
end

function FunctionCDCommand:Refresh()
  self:Update(0, 0)
  for k, v in pairs(self.cmdMap) do
    v:Update(0, 0)
  end
end

function FunctionCDCommand:TryDestroy(cmdClass)
  local cmd = self.cmdMap[cmdClass]
  if cmd ~= nil and cmd:IsEmpty() then
    cmd:Destroy()
    self.cmdMap[cmdClass] = nil
    return true
  end
  return false
end

function FunctionCDCommand:CanRemove(cdType, cdData)
  local removeCheck = RemoveCheck[cdType]
  if removeCheck ~= nil then
    return removeCheck(cdData)
  end
  return cdData:GetCd() <= 0
end

function FunctionCDCommand:Update(time, deltaTime)
  local _CDProxy = CDProxy.Instance
  for cdType, maps in pairs(_CDProxy.cdMap) do
    for id, cdData in pairs(maps) do
      cdData:CalCd(-deltaTime)
      if self:CanRemove(cdType, cdData) then
        _CDProxy:RemoveCD(cdType, id)
      end
    end
  end
end
