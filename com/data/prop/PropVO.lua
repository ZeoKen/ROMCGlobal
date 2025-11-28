PropVO = class("PropVO")
PropValueType = {
  Int = 1,
  Float = 2,
  Bool = 3
}

function PropVO:ctor()
end

function PropVO:Init(id, typeID, name, displayName, isPercent, priority, valueType, defaultValue, IsClientPercent, isSyncFloat)
  self.id = id
  self.typeID = typeID
  self.name = name
  self.displayName = displayName
  self.isPercent = isPercent
  self.priority = priority
  self.valueType = valueType
  self.defaultValue = defaultValue
  self.IsClientPercent = IsClientPercent
  self.isSyncFloat = isSyncFloat
end

function PropVO.Create(id, typeID, name, displayName, isPercent, priority, valueType, defaultValue, IsClientPercent, isSyncFloat)
  local data = PropVO.new()
  data:Init(id, typeID, name, displayName, isPercent, priority, valueType, defaultValue, IsClientPercent, isSyncFloat)
  return data
end
