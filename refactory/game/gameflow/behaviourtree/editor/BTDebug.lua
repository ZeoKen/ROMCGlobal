redlog("[bt] Debug Mode")
local btSystemUpdateFunc = BTSystem.Update

function BTSystem:Update(time, deltaTime)
  RO.BTDebug.OnGraphExec(self.gid or 0)
  btSystemUpdateFunc(self, time, deltaTime)
end

local typeDefines = BTDefine.TypeDefine
for baseType, list in pairs(typeDefines) do
  for _, concreteType in pairs(list) do
    local originExecFunc = concreteType.Exec
    if originExecFunc then
      function concreteType:Exec(time, deltaTime, context)
        local execFunc = originExecFunc
        
        local ret, output = execFunc(self, time, deltaTime, context)
        RO.BTDebug.OnNodeExec(self.nid or 0, ret)
        return ret, output
      end
    end
  end
end
local bbExec = BTBlackBoard.Exec

function BTBlackBoard:Exec(time, deltaTime)
  RO.BTDebug.ClearBlackBoard()
  if self.globalDatas then
    for k, v in pairs(self.globalDatas) do
      local valueType = type(v)
      if valueType == "number" or valueType == "string" or valueType == "boolean" then
        RO.BTDebug.SetBlackBoard(k, v)
      end
    end
  end
  bbExec(self, time, deltaTime)
end

return true
