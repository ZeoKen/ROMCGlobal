PropUtil = {}
PropUtil.CachedProps = {}

function PropUtil.FormatEffect(effect, factor, separator, valueColorStr)
  return EquipProps.MakeStr(GameConfig.EquipEffect[effect.name], separator, factor * effect.value, valueColorStr)
end

function PropUtil.FormatEffects(effects, factor, separator, newLineChar, valueColorStr)
  separator = separator or ":"
  newLineChar = newLineChar or "\n"
  local sb = LuaStringBuilder.CreateAsTable()
  for i = 1, #effects do
    sb:Append(PropUtil.FormatEffect(effects[i], factor, separator, valueColorStr))
    if i < #effects then
      sb:Append(newLineChar)
    end
  end
  local s = sb:GetCount() == 0 and ZhString.PropEffect_NoGrow or sb:ToString()
  sb:Destroy()
  return s
end

function PropUtil.FormatEffectsByProp(effects, same, separator, newLineChar, valueColorStr)
  local effect, props, propsLast
  for i = 1, #effects do
    effect = effects[i]
    if effect.lv > 0 then
      props = PropUtil.GetProp(effect)
      if propsLast then
        propsLast:Add(props, same)
      else
        propsLast = props
      end
    end
  end
  return propsLast and propsLast:ToString(separator, newLineChar, valueColorStr)
end

function PropUtil.GetProp(effect)
  local res = PropUtil.CachedProps[effect.name]
  if not res then
    res = EquipProps.new()
    PropUtil.CachedProps[effect.name] = res
  end
  res:CreateByConfig(effect.effect, effect.lv)
  return res
end
