Prop = class("Prop")
Prop.PercentFactor = 100
Prop.FixPercent = 1000

function Prop:ctor(propVO)
  self.value = propVO ~= nil and propVO.defaultValue or 0
  self.propVO = propVO
end

function Prop:GetValue()
  if self.propVO == nil then
    return 0
  end
  local v = self.value
  if self.propVO.isPercent or self.propVO.isSyncFloat then
    v = self.value / Prop.FixPercent
  end
  return v
end

function Prop:SetValue(v)
  local old = self.value
  self.value = v
  return old
end

function Prop:ValueToString(percent)
  percent = percent or "%"
  local value = self.value
  if self.propVO.isPercent then
    local p = Prop.FixPercent / Prop.PercentFactor
    value = value / p // 1 .. percent
  else
    return value // 1
  end
  return value
end

function Prop:ResetValue()
  self.value = self.propVO ~= nil and self.propVO.defaultValue or 0
end
