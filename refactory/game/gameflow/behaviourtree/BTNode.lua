BTNode = class("BTNode")
local ArrayClear = TableUtility.ArrayClear
local TypeDefine = BTDefine.TypeDefine
local CreateNode = function(config)
  local baseType = config.basetype
  local type = config.type
  local baseTypeRef = TypeDefine[baseType]
  if not baseTypeRef then
    redlog("[bt] basetype not found", baseTypeRef)
    return
  end
  local typeRef = baseTypeRef[type]
  if not typeRef then
    redlog("[bt] type not found", baseType, type)
    return
  end
  local node = typeRef.new(config)
  node.nid = config.nid or 0
  return node
end
BTNode.CreateNode = CreateNode

function BTNode:ctor(config)
  self.enabled = true
  self.service = nil
  self.preCondition = nil
  self.children = {}
  self:Init(config)
end

function BTNode:Init(config)
  if config.service then
    self.service = CreateNode(config.service)
    if not self.service then
      redlog("[bt] service create failed", config.type, config.service.type)
    end
  end
  if config.preCondition then
    self.preCondition = CreateNode(config.preCondition)
    if not self.preCondition then
      redlog("[bt] precondition create failed", config.type, config.precondition.type)
    end
  end
  if config.children then
    for _, v in ipairs(config.children) do
      local node = CreateNode(v)
      if not node then
        redlog("[bt] create node failed", v and v.basetype, v and v.type)
      end
      table.insert(self.children, node)
    end
  end
end

function BTNode:Dispose()
  for _, v in ipairs(self.children) do
    if v then
      v:Dispose()
    end
  end
  ArrayClear(self.children)
end

function BTNode:AddChild(child)
  table.insert(self.children, child)
end

function BTNode:RemoveChild(i)
  local child = self.children[i]
  table.remove(self.children, i)
  return child
end
