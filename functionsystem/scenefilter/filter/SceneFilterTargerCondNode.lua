autoImport("LConditionNode")
SceneFilterTargerCondNode = class("SceneFilterTargerCondNode", LConditionNode)

function SceneFilterTargerCondNode:ctor(behaviorTree, checkFunc, owner)
  SceneFilterTargerCondNode.super.ctor(self, behaviorTree)
  self.checkFunc = checkFunc
  self.owner = owner
end

function SceneFilterTargerCondNode:Check()
  if self.owner then
    return self.checkFunc(owner, self.behaviorTree.blackBoard.ftarget)
  else
    return self.checkFunc(self.behaviorTree.blackBoard.ftarget)
  end
end

SceneFilterTargetParamCondNode = class("SceneFilterTargetParamCondNode", LConditionNode)

function SceneFilterTargetParamCondNode:ctor(behaviorTree, checkFunc, fullParam, owner)
  SceneFilterTargetParamCondNode.super.ctor(self, behaviorTree)
  self.checkFunc = checkFunc
  self.checkFuncParam = {
    select(2, unpack(fullParam))
  }
  self.owner = owner
end

function SceneFilterTargetParamCondNode:SetParam(checkFuncParam)
  self.checkFuncParam = checkFuncParam
end

function SceneFilterTargetParamCondNode:Check()
  if self.owner then
    return self.checkFunc(self.owner, self.behaviorTree.blackBoard.ftarget, self.checkFuncParam)
  else
    return self.checkFunc(self.behaviorTree.blackBoard.ftarget, self.checkFuncParam)
  end
end
