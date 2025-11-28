autoImport("Props")
EquipProps = class("EquipProps", Props)

function EquipProps:ctor()
  EquipProps.super.ctor(self)
  self.cacheEffect = nil
  self.wholeEffectCount = 0
  self.configs = UserProxy.Instance.creatureProps
end

function EquipProps:CreateByConfig(effects, factor)
  self:ResetCount()
  factor = factor or 1
  self.cacheEffect = effects
  for k, v in pairs(self.cacheEffect) do
    self:SetValueByName(k, v * factor)
  end
end

function EquipProps:Multiply(factor)
  local p
  for k, v in pairs(self.cacheEffect) do
    p = self:GetPropByName(k)
    if p then
      p.value = p.value * factor
    end
  end
end

function EquipProps:Add(equipProps, justSame)
  local selfP, otherP
  if justSame then
    self:ResetCount()
  end
  for k, v in pairs(equipProps.cacheEffect) do
    otherP = equipProps:GetPropByName(k)
    selfP = self:GetPropByName(k)
    if otherP then
      if selfP then
        self:CountProp(k)
        selfP.value = selfP.value + otherP.value
      elseif not justSame then
        self:SetValueByName(k, otherP.value)
      end
    end
  end
end

function EquipProps:ResetCount()
  self.cacheWholeEffectName = {}
  self.wholeEffectCount = 0
end

function EquipProps:CountProp(name)
  if not self.cacheWholeEffectName[name] then
    self.cacheWholeEffectName[name] = name
    self.wholeEffectCount = self.wholeEffectCount + 1
  end
end

function EquipProps:SetValueByName(name, value)
  self:CountProp(name)
  EquipProps.super.SetValueByName(self, name, value)
end

function EquipProps:ToString(seperator, newLineChar, valueColorStr)
  local count, i, prop = self.wholeEffectCount, 0
  local sb = LuaStringBuilder.CreateAsTable()
  for k, v in pairs(self.cacheWholeEffectName) do
    i = i + 1
    prop = self[v]
    if prop then
      sb:Append(EquipProps.MakeStr(prop.propVO.displayName, seperator, prop:ValueToString(), valueColorStr))
      if count > i then
        sb:Append(newLineChar or "\n")
      end
    end
  end
  local s = sb:ToString()
  sb:Destroy()
  return s
end

function EquipProps.MakeStr(displayName, separator, value, valueColorStr)
  local sb = LuaStringBuilder.CreateAsTable()
  sb:Append(displayName)
  if valueColorStr then
    sb:Append(string.format("[c][%s]", valueColorStr))
  end
  sb:Append(separator or ":")
  sb:Append(value)
  if valueColorStr then
    sb:Append("[-][/c]")
  end
  local s = sb:ToString()
  sb:Destroy()
  return s
end
