autoImport("LParentNode")
LSelectorNode = class("LSelectorNode", LParentNode)

function LSelectorNode:ctor(behaviorTree, emptyChildState)
  LSelectorNode.super.ctor(self, behaviorTree)
  self.emptyChildState = emptyChildState
end

function LSelectorNode:Update()
  if #self.childrenNodes == 0 and self.emptyChildState then
    return self.emptyChildState
  end
  local node, state
  for i = 1, #self.childrenNodes do
    node = self.childrenNodes[i]
    state = node:Update()
    if state ~= TaskState.Failure then
      return state
    end
  end
  return TaskState.Failure
end
