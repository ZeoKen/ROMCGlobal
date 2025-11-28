function NpcData:Push_InitData(config, configRow, configCol)
  self.pushStaticData = config
  
  self.push_configRow = configRow
  self.push_configCol = configCol
end

function NpcData:Push_GetConfigRowAndCol()
  return self.push_configRow, self.push_configCol
end

function NpcData:Push_GetStaticData(dataKey)
  return self.pushStaticData and self.pushStaticData[dataKey]
end

function NpcData:Push_GetFeature(bit)
  local feature = self.userdata:Get(UDEnum.BOX_FEATURE)
  return feature and 0 < feature & bit or false
end

function NpcData:Push_GetFeature_CanRotate()
  return self:Push_GetFeature(1)
end

function NpcData:Push_GetFeature_IsIceBox()
  return self:Push_GetFeature(16)
end

function NpcData:Push_GetFeature_ForbidPush()
  return self:Push_GetFeature(32)
end

function NpcData:Push_SetDirection(direction)
  self.push_direction = direction
end

function NpcData:Push_GetDirection()
  return self.push_direction or 1
end

function NpcData:Push_LockRotate(isLock)
  self.push_LockRotate = isLock
end

function NpcData:Push_IsLockRotate()
  return self.push_LockRotate
end

function NpcData:Push_LockPush(isLock)
  self.push_LockPush = isLock
end

function NpcData:Push_IsLockPush()
  return self.push_LockPush
end

function NpcData:Push_ClearData()
  self.pushStaticData = nil
  self.push_LockPush = nil
  self.push_LockRotate = nil
  self.push_direction = nil
  self.push_configRow = nil
  self.push_configCol = nil
end
