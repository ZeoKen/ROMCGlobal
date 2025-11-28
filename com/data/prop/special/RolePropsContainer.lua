autoImport("EquipProps")
autoImport("Props")
RolePropsContainer = reusableClass("RolePropsContainer", Props)
RolePropsContainer.PoolSize = 250

function RolePropsContainer:ctor()
  RolePropsContainer.super.ctor(self, RolePropsContainer.config)
end

function RolePropsContainer:SetValueById(id, value)
  local p
  local conf = self.configs[id]
  if conf ~= nil then
    local name = conf.name
    p = self.mProps[name]
    if p == nil or p.propVO == nil then
      local config = self.configs[name]
      if config ~= nil then
        p = Prop.new(config)
        self.mProps[config.name] = p
      end
    end
    if p == nil then
      p = Prop.new(conf)
      self.mProps[name] = p
    end
  end
  if p == nil then
    return
  end
  local old = p.value
  p.value = value
  return old, p
end

function RolePropsContainer:DoConstruct(asArray, parts)
  self:Reset()
end

function RolePropsContainer:DoDeconstruct(asArray)
end
