BTDefine = {}

function BTDefine.InheritSchema(childSchema, baseSchema)
  if not baseSchema then
    return
  end
  for i, v in ipairs(baseSchema) do
    table.insert(childSchema, i, v)
  end
end

BTDefine.Result = {Success = 0, Failed = 1}
BTDefine.ParamTypes = {
  integer = 1,
  number = 2,
  boolean = 3,
  trigger = 4
}
BTDefine.TypeDefine = {
  Composite = {},
  Decorator = {},
  Service = {},
  Action = {}
}

function BTDefine.RegisterComposite(typename, cls)
  if BTDefine.TypeDefine.Composite[typename] then
    redlog("[bt] composite already registered", typename)
  end
  BTDefine.TypeDefine.Composite[typename] = cls
end

function BTDefine.UnregisterComposite(typename)
  BTDefine.TypeDefine.Composite[typename] = nil
end

function BTDefine.RegisterDecorator(typename, cls)
  if BTDefine.TypeDefine.Decorator[typename] then
    redlog("[bt] decorator already registered", typename)
  end
  BTDefine.TypeDefine.Decorator[typename] = cls
end

function BTDefine.UnregisterDecorator(typename)
  BTDefine.TypeDefine.Decorator[typename] = nil
end

function BTDefine.RegisterService(typename, cls)
  if BTDefine.TypeDefine.Service[typename] then
    redlog("[bt] Service already registered", typename)
  end
  BTDefine.TypeDefine.Service[typename] = cls
end

function BTDefine.UnregisterService(typename)
  BTDefine.TypeDefine.Service[typename] = nil
end

function BTDefine.RegisterAction(typename, cls)
  if BTDefine.TypeDefine.Action[typename] then
    redlog("[bt] Action already registered", typename)
  end
  BTDefine.TypeDefine.Action[typename] = cls
end

function BTDefine.UnregisterAction(typename)
  BTDefine.TypeDefine.Action[typename] = nil
end

function BTDefine.RegisterBlackBoard(typename, cls)
  BTDefine.TypeDefine.BlackBoard[typename] = cls
end

function BTDefine.UnregisterBlackBoard(typename)
  BTDefine.TypeDefine.BlackBoard[typename] = nil
end

local LogicOp = {
  Equal = 0,
  NotEqual = 1,
  Greater = 2,
  GreaterEqual = 3,
  Less = 4,
  LessEqual = 5,
  Contains = 6
}
BTDefine.LogicOp = LogicOp

function LogicCompare(a, b, op)
  if op == LogicOp.Equal then
    return a == b
  elseif op == LogicOp.NotEqual then
    return a ~= b
  elseif op == LogicOp.Greater then
    return b < a
  elseif op == LogicOp.GreaterEqual then
    return b <= a
  elseif op == LogicOp.Less then
    return a < b
  elseif op == LogicOp.LessEqual then
    return a <= b
  elseif op == LogicOp.Contains then
    if type(a) == "table" and b then
      return not not a[b]
    end
    return false
  else
    return false
  end
end

BTDefine.LogicCompare = LogicCompare
local Finders = {GlobalTarget = 1, ObjectFinder = 2}
BTDefine.Finders = Finders

function BTDefine.GetFinder(tag, context)
  local func, target
  if tag == Finders.GlobalTarget then
    target = context and context.blackboard
    func = target and target.GetTarget
  elseif tag == Finders.ObjectFinder then
    target = Game.GameObjectManagers[Game.GameObjectType.ObjectFinder]
    func = target.FindObject
  end
  return func, target
end

function BTDefine.GetTarget(tag, id, context)
  local func, target = BTDefine.GetFinder(tag, context)
  if func then
    return func(target, id)
  end
  return nil
end

local BlackboardOptions = {}
BTDefine.BBOptions = BlackboardOptions

function BTDefine.RegisterBlackBoardOption(serviceName, optionTable)
  if serviceName and optionTable then
    BlackboardOptions[serviceName] = optionTable
    BTDefine.RegisterReservedBBKey(serviceName)
  end
end

function BTDefine.UnregisterBlackBoardOption(serviceName)
  if serviceName then
    BlackboardOptions[serviceName] = nil
    BTDefine.UnregisterReservedBBKey(serviceName)
  end
end

local BBReservedKeys = {}
BTDefine.BBReservedKeys = BBReservedKeys

function BTDefine.RegisterReservedBBKey(key)
  if key then
    BBReservedKeys[key] = 1
  end
end

function BTDefine.UnregisterReservedBBKey(key)
  if key then
    BBReservedKeys[key] = nil
  end
end
