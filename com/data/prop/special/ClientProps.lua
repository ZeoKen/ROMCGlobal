autoImport("Props")
ClientProps = class("ClientProps", Props)

function ClientProps:InitProp(propVO)
  local p = Prop.new(propVO)
  self.mProps[propVO.name] = p
  p.value = 0
  return p
end
