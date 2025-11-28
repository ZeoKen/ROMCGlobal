autoImport("SceneFilterTargerCondNode")
autoImport("SceneTargetFilter")
autoImport("SceneRangeFilter")
autoImport("SceneParamCondFilter")
autoImport("SceneFiltersActions")
SceneFilterNode = class("SceneFilterNode")
SceneFilterNode.NodePool = nil

function SceneFilterNode.InitNodePool()
  SceneFilterNode.NodePool = {}
  SceneFilterNode.NodePool.Classifys = {}
  SceneFilterNode.NodePool.ClassifyNodes = {}
  SceneFilterNode.NodePool.Classifys[SceneFilterDefine.Classify.Character] = SceneTargetFilter.CheckClassifyIsCreature
  SceneFilterNode.NodePool.Classifys[SceneFilterDefine.Classify.LuaGO] = SceneTargetFilter.CheckClassifyIsLuaGO
  SceneFilterNode.NodePool.Targets = {}
  SceneFilterNode.NodePool.TargetNodes = {}
  SceneFilterNode.NodePool.Targets[SceneFilterDefine.Target.Player] = SceneTargetFilter.CheckIsPlayer
  SceneFilterNode.NodePool.Targets[SceneFilterDefine.Target.Pet] = SceneTargetFilter.CheckIsPet
  SceneFilterNode.NodePool.Targets[SceneFilterDefine.Target.Npc] = SceneTargetFilter.CheckIsNpc
  SceneFilterNode.NodePool.Targets[SceneFilterDefine.Target.Monster] = SceneTargetFilter.CheckIsMonster
  SceneFilterNode.NodePool.Targets[SceneFilterDefine.Target.LuaGO] = SceneTargetFilter.CheckIsLuaGO
  SceneFilterNode.NodePool.Ranges = {}
  SceneFilterNode.NodePool.RangeNodes = {}
  SceneFilterNode.NodePool.Ranges[SceneFilterDefine.Range.NotGuildOther] = SceneRangeFilter.CheckNotGuildOther
  SceneFilterNode.NodePool.Ranges[SceneFilterDefine.Range.SameGuild] = SceneRangeFilter.CheckSameGuild
  SceneFilterNode.NodePool.Ranges[SceneFilterDefine.Range.NotTeamOther] = SceneRangeFilter.CheckNotTeamOther
  SceneFilterNode.NodePool.Ranges[SceneFilterDefine.Range.SameTeam] = SceneRangeFilter.CheckSameTeam
  SceneFilterNode.NodePool.Ranges[SceneFilterDefine.Range.AllOther] = SceneRangeFilter.CheckAllOther
  SceneFilterNode.NodePool.Ranges[SceneFilterDefine.Range.NotTeam] = SceneRangeFilter.CheckNotTeam
  SceneFilterNode.NodePool.Ranges[SceneFilterDefine.Range.All] = SceneRangeFilter.CheckAll
  SceneFilterNode.NodePool.Ranges[SceneFilterDefine.Range.Self] = SceneRangeFilter.CheckSelf
  SceneFilterNode.NodePool.Ranges[SceneFilterDefine.Range.BoothOther] = SceneRangeFilter.CheckBoothOther
  SceneFilterNode.NodePool.ParamConds = {}
  SceneFilterNode.NodePool.ParamCondNodes = {}
  SceneFilterNode.NodePool.ParamConds[SceneFilterDefine.ParamCond.GUID] = SceneParamCondFilter.CheckParam_GUID
  SceneFilterNode.NodePool.ParamConds[SceneFilterDefine.ParamCond.LuaGameObjectType] = SceneParamCondFilter.CheckParam_LuaGameObjectType
  SceneFilterNode.NodePool.ParamConds[SceneFilterDefine.ParamCond.LuaGameObjectID] = SceneParamCondFilter.CheckParam_LuaGameObjectID
end

function SceneFilterNode.GetClassifyConNode(classifyType, tree)
  local cond = SceneFilterNode.NodePool.ClassifyNodes[classifyType]
  if not cond then
    cond = SceneFilterTargerCondNode.new(tree, SceneFilterNode.NodePool.Classifys[classifyType])
    SceneFilterNode.NodePool.ClassifyNodes[classifyType] = cond
  end
  return cond
end

function SceneFilterNode.GetTargetConNode(targetType, tree)
  local cond = SceneFilterNode.NodePool.TargetNodes[targetType]
  if not cond then
    cond = SceneFilterTargerCondNode.new(tree, SceneFilterNode.NodePool.Targets[targetType])
    SceneFilterNode.NodePool.TargetNodes[targetType] = cond
  end
  return cond
end

function SceneFilterNode.GetRangeConNode(rangeType, tree)
  local cond = SceneFilterNode.NodePool.RangeNodes[rangeType]
  if not cond then
    cond = SceneFilterTargerCondNode.new(tree, SceneFilterNode.NodePool.Ranges[rangeType])
    SceneFilterNode.NodePool.RangeNodes[rangeType] = cond
  end
  return cond
end

function SceneFilterNode.GetParamCondConNode(paramCond, tree)
  local cond = SceneFilterNode.NodePool.ParamCondNodes[paramCond]
  if not cond then
    cond = SceneFilterTargetParamCondNode.new(tree, SceneFilterNode.NodePool.ParamConds[paramCond[1]], paramCond)
    SceneFilterNode.NodePool.ParamCondNodes[paramCond] = cond
  end
  return cond
end

function SceneFilterNode:ctor(behaviourTree, groupID, counterwise)
  self.enabled = false
  self.groupID = groupID
  self.tree = behaviourTree
  self.counterwise = counterwise
  self.selfRootSelector = LSequenceNode.new(self.tree)
  self.classifySelector = LSelectorNode.new(self.tree)
  self.selfRootSelector:AddCondNode(self.classifySelector)
  local mainLogicSelector = LSelectorNode.new(self.tree)
  self.selfRootSelector:AddNode(mainLogicSelector)
  local activeSequenceNode = LSequenceNode.new(self.tree)
  self.targetSelector = LSelectorNode.new(self.tree, TaskState.Success)
  self.rangeSelector = LSequenceNode.new(self.tree)
  self.paramCondSelector = LSequenceNode.new(self.tree)
  activeSequenceNode:AddCondNode(self.targetSelector)
  activeSequenceNode:AddCondNode(self.rangeSelector)
  activeSequenceNode:AddCondNode(self.paramCondSelector)
  activeSequenceNode:AddNode(SceneFilterActiveNode.new(self.tree))
  mainLogicSelector:AddNode(SceneFilterSetDataAction.new(self.tree, "groupNode", self))
  mainLogicSelector:AddNode(activeSequenceNode)
  mainLogicSelector:AddNode(SceneFilterInActiveNode.new(self.tree))
  self.data = SceneFilterNodeData.new()
  self.filterMap = {}
  self.filterCount = 0
  if not SceneFilterNode.NodePool then
    SceneFilterNode.InitNodePool()
  end
end

function SceneFilterNode:HasFilter()
  for k, v in pairs(self.filterMap) do
    return true
  end
  return false
end

function SceneFilterNode:SetEnable(value)
  if self.enabled ~= value then
    self.enabled = value
    if value then
      self.tree:GetRootNode().directeNode:AddNode(self.selfRootSelector)
    else
      self.tree:GetRootNode().directeNode:RemoveNode(self.selfRootSelector)
    end
  end
end

function SceneFilterNode:IsEnabled()
  return self.enabled
end

function SceneFilterNode:AddFilter(id)
  if not self.filterMap[id] then
    local conf = Table_ScreenFilter[id]
    self.filterMap[id] = conf
    if conf then
      self.filterCount = self.filterCount + 1
      self:_AddClassifys(#conf.Classifys > 0 and conf.Classifys or {
        SceneFilterDefine.Classify.Character
      })
      if conf.Targets then
        local target
        for i = 1, #conf.Targets do
          target = conf.Targets[i]
          if SceneFilterNode.NodePool.Targets[target] then
            if self.data:AddTarget(target) then
              self.targetSelector:AddNode(SceneFilterNode.GetTargetConNode(target, self.tree))
            end
          else
            errorLog("屏蔽ID %s 中配置的target %s程序未支持", id, target)
          end
        end
      end
      self:_AddRanges(conf.Range)
      self:_AddParamConds(conf.ParamCond)
    end
    return true
  end
  return false
end

function SceneFilterNode:_AddClassifys(_Classifys)
  local classify
  for i = 1, #_Classifys do
    classify = _Classifys[i]
    if SceneFilterNode.NodePool.Classifys[classify] then
      if self.data:AddClassify(classify) then
        self.classifySelector:AddNode(SceneFilterNode.GetClassifyConNode(classify, self.tree))
      end
    else
      errorLog("屏蔽ID %s 中配置的classify %s程序未支持", id, classify)
    end
  end
end

function SceneFilterNode:_AddRanges(_Ranges)
  local range
  for i = 1, #_Ranges do
    range = _Ranges[i]
    if SceneFilterNode.NodePool.Ranges[range] then
      if self.data:AddRange(range) then
        self.rangeSelector:AddCondNode(SceneFilterNode.GetRangeConNode(range, self.tree))
      end
    else
      errorLog("屏蔽ID %s 中配置的range %s程序未支持", id, range)
    end
  end
end

function SceneFilterNode:_AddParamConds(_ParamConds)
  if not _ParamConds then
    return
  end
  local paramCond
  for i = 1, #_ParamConds do
    paramCond = _ParamConds[i]
    if type(paramCond) == "table" and 0 < #paramCond then
      if SceneFilterNode.NodePool.ParamConds[paramCond[1]] then
        if self.data:AddParamCond(paramCond) then
          self.paramCondSelector:AddCondNode(SceneFilterNode.GetParamCondConNode(paramCond, self.tree))
        end
      else
        errorLog("屏蔽ID %s 中配置的param cond %s程序未支持", id, paramCond)
      end
    end
  end
end

function SceneFilterNode:RemoveFilter(id)
  if self.filterMap[id] then
    self.filterMap[id] = nil
    SceneFilterProxy.Instance:SceneFilterProcessCheckById(id, self.counterwise)
    local conf = Table_ScreenFilter[id]
    if conf then
      self.filterCount = self.filterCount - 1
      self:_RemoveClassifys(#conf.Classifys > 0 and conf.Classifys or {
        SceneFilterDefine.Classify.Character
      })
      if conf.Targets then
        local target
        for i = 1, #conf.Targets do
          target = conf.Targets[i]
          if self.data:RemoveTarget(target) then
            self.targetSelector:RemoveNode(SceneFilterNode.GetTargetConNode(target, self.tree))
          end
        end
      end
      self:_RemoveRanges(conf.Range)
      self:_RemoveParamConds(conf.ParamCond)
    end
  end
end

function SceneFilterNode:_RemoveClassifys(_Classifys)
  local classify
  for i = 1, #_Classifys do
    classify = _Classifys[i]
    if self.data:RemoveClassify(classify) then
      self.classifySelector:RemoveNode(SceneFilterNode.GetClassifyConNode(classify, self.tree))
    end
  end
end

function SceneFilterNode:_RemoveRanges(_Ranges)
  local range
  for i = 1, #_Ranges do
    range = _Ranges[i]
    if self.data:RemoveRange(range) then
      self.rangeSelector:RemoveCondNode(SceneFilterNode.GetRangeConNode(range, self.tree))
    end
  end
end

function SceneFilterNode:_RemoveParamConds(_ParamConds)
  if not _ParamConds then
    return
  end
  local paramCond
  for i = 1, #_ParamConds do
    paramCond = _ParamConds[i]
    if self.data:RemoveParamCond(paramCond) then
      self.paramCondSelector:RemoveCondNode(SceneFilterNode.GetParamCondConNode(paramCond, self.tree))
    end
  end
end

function SceneFilterNode:RemoveAll()
  for k, v in pairs(self.filterMap) do
    self:RemoveFilter(k)
  end
  self.filterCount = 0
end

function SceneFilterNode:GetFilter(id)
  return self.filterMap[id]
end

SceneFilterNodeData = class("SceneFilterNodeData")

function SceneFilterNodeData:ctor()
  self.classifyCount = {}
  self.targetCount = {}
  self.rangeCount = {}
  self.paramCondCount = {}
end

function SceneFilterNodeData:Remove(tab, checkType)
  local count = tab[checkType] or 0
  tab[checkType] = 0 < count and count - 1 or 0
  return count == 1
end

function SceneFilterNodeData:Add(tab, checkType)
  local count = tab[checkType] or 0
  tab[checkType] = count + 1
  return count == 0
end

function SceneFilterNodeData:AddClassify(classifyType)
  return self:Add(self.classifyCount, classifyType)
end

function SceneFilterNodeData:RemoveClassify(classifyType)
  return self:Remove(self.classifyCount, classifyType)
end

function SceneFilterNodeData:AddTarget(targetType)
  return self:Add(self.targetCount, targetType)
end

function SceneFilterNodeData:RemoveTarget(targetType)
  return self:Remove(self.targetCount, targetType)
end

function SceneFilterNodeData:AddRange(rangeType)
  return self:Add(self.rangeCount, rangeType)
end

function SceneFilterNodeData:RemoveRange(rangeType)
  return self:Remove(self.rangeCount, rangeType)
end

function SceneFilterNodeData:AddParamCond(paramCond)
  return self:Add(self.paramCondCount, paramCond)
end

function SceneFilterNodeData:RemoveParamCond(paramCond)
  return self:Remove(self.paramCondCount, paramCond)
end
