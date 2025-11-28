BTCondition.Schema = {
  {
    ParamType = "boolean",
    ParamName = "invertResult",
    Required = false
  },
  {
    ParamType = "custom",
    ParamName = "passRet",
    Required = false
  },
  {
    ParamType = "custom",
    ParamName = "failRet",
    Required = false
  }
}
BTSelectCondition.Schema = {}
BTDefine.InheritSchema(BTSelectCondition.Schema, BTCondition.Schema)
BTSelectCondition.Comments = "规则类似BTSelector，同时会返回passRet和failRet。\n"
BTSequenceCondition.Schema = {}
BTDefine.InheritSchema(BTSequenceCondition.Schema, BTCondition.Schema)
BTSequenceCondition.Comments = "规则类似BTSequence，同时会返回passRet和failRet。\n"
BTCompareBB.Schema = {
  {
    ParamType = "string",
    ParamName = "serviceKey",
    Required = false,
    ValueOptionsByTableKey = BTDefine.BBOptions
  },
  {
    ParamType = "integer",
    ParamName = "bbKey",
    Required = true,
    ValueOptionsByParam = {DepParamName = "serviceKey"}
  },
  {
    ParamType = "custom",
    ParamName = "val",
    Required = true
  },
  {
    ParamType = "integer",
    ParamName = "op",
    Required = true,
    ValueOptionsByTable = BTDefine.LogicOp
  }
}
BTDefine.InheritSchema(BTCompareBB.Schema, BTCondition.Schema)
BTCompareBB.Comments = "继承Condition，比较Blackboard上的数值与指定数值\nserviceKey 收集器数据在Blackboard上的key，通常为收集器的名字\nbbKey 数据的key\nval 指定的数值\nop 操作符，比如大于、等于、小于...\n"
BTCompareBB2.Schema = {
  {
    ParamType = "string",
    ParamName = "serviceKey",
    Required = false,
    ValueOptionsByTableKey = BTDefine.BBOptions
  },
  {
    ParamType = "integer",
    ParamName = "bbKey",
    Required = true,
    ValueOptionsByParam = {DepParamName = "serviceKey"}
  },
  {
    ParamType = "integer",
    ParamName = "bbKey2",
    Required = true
  },
  {
    ParamType = "integer",
    ParamName = "op",
    Required = true,
    ValueOptionsByTable = BTDefine.LogicOp
  }
}
BTDefine.InheritSchema(BTCompareBB2.Schema, BTCondition.Schema)
BTCompareBB2 = "继承Condition，比较Blackboard上的2个数值\nserviceKey 收集器数据在Blackboard上的key，通常为收集器的名字\nbbKey 数据1的key\nbbKey 数据2的key\nop 操作符，比如大于、等于、小于...\n"
BTCompareBBCustom.Schema = {
  {
    ParamType = "blackboard",
    ParamName = "bbParam",
    Required = true
  },
  {
    ParamType = "integer",
    ParamName = "op",
    Required = true,
    ValueOptionsByTable = BTDefine.LogicOp
  }
}
BTDefine.InheritSchema(BTCompareBBCustom.Schema, BTCondition.Schema)
BTCompareBBCustom = "比较自定义的黑板参数\nbbParam 自定义黑板参数\nop 操作符，比如大于、等于、小于...\n"
BTTargetCondition.Schema = {
  {
    ParamType = "integer",
    ParamName = "tag",
    Required = true,
    ValueOptionsByTable = BTDefine.Finders
  },
  {
    ParamType = "custom",
    ParamName = "id",
    Required = true
  }
}
BTDefine.InheritSchema(BTTargetCondition.Schema, BTCondition.Schema)
BTHasArrived.Schema = {
  {
    ParamType = "position",
    ParamName = "targetPosition",
    Required = true
  },
  {
    ParamType = "number",
    ParamName = "tolerance",
    Required = true,
    DefaultValue = 0.01
  }
}
BTDefine.InheritSchema(BTHasArrived.Schema, BTTargetCondition.Schema)
BTHasArrived.Comments = "对象是否到达目的地\ntag 对象标签，如果是GlobalTarget，则前置节点必须指定ChangeTarget服务\ntolerance 判断是否到达的误差值\n"
BTHasRotatedTo.Schema = {
  {
    ParamType = "rotation",
    ParamName = "targetRotation",
    Required = true
  },
  {
    ParamType = "number",
    ParamName = "tolerance",
    Required = true,
    DefaultValue = 0.99
  }
}
BTDefine.InheritSchema(BTHasRotatedTo.Schema, BTTargetCondition.Schema)
BTHasRotatedTo.Comments = "对象是否旋转到指定角度\ntag 对象标签，如果是GlobalTarget，则前置节点必须指定ChangeTarget服务\ntolerance 判断是否到达的误差值，该值为 向量夹角的余弦值，通常不需要修改。\n"
BTIsLookingAt.Schema = {
  {
    ParamType = "position",
    ParamName = "targetPosition",
    Required = true
  },
  {
    ParamType = "number",
    ParamName = "tolerance",
    Required = true,
    DefaultValue = 0.99
  }
}
BTDefine.InheritSchema(BTIsLookingAt.Schema, BTTargetCondition.Schema)
BTIsLookingAt.Comments = "对象是否看向某处\ntag 对象标签，如果是GlobalTarget，则前置节点必须指定ChangeTarget服务\ntolerance 判断是否到达的误差值，该值为 向量夹角的余弦值，通常不需要修改。\n"
BTCheckAnimatorProgress.Schema = {
  {
    ParamType = "string",
    ParamName = "stateName",
    Required = false
  },
  {
    ParamType = "number",
    ParamName = "normalizedTime",
    Required = true
  },
  {
    ParamType = "integer",
    ParamName = "op",
    Required = true,
    ValueOptionsByTable = BTDefine.LogicOp
  }
}
BTDefine.InheritSchema(BTCheckAnimatorProgress.Schema, BTTargetCondition.Schema)
BTCheckAnimatorProgress.Comments = "检查Animator播放进度 InTransition时返回失败\nstateName 可选，检查stateName是否匹配\nnormalizedTime 当前进度\nop 比较符\n可以用来检查当前是否在播某个动作，或者是否已经播完\n"
BTCheckAnimatorIntParam.Schema = {
  {
    ParamType = "string",
    ParamName = "paramName",
    Required = true
  },
  {
    ParamType = "integer",
    ParamName = "paramVal",
    Required = true
  },
  {
    ParamType = "integer",
    ParamName = "op",
    Required = true,
    ValueOptionsByTable = BTDefine.LogicOp
  }
}
BTDefine.InheritSchema(BTCheckAnimatorIntParam.Schema, BTTargetCondition.Schema)
BTCheckAnimatorIntParam.Comments = "检查Animator Integer 参数\nparamName 参数名\nparamVal 参数值\nop 比较符\n可以用来检查当前是否在播某个动作，或者是否已经播完\n"
BTCheckWildMvpState.Schema = {
  {
    ParamType = "integer",
    ParamName = "monsterid",
    Required = true
  },
  {
    ParamType = "integer",
    ParamName = "state",
    Required = true,
    ValueOptionsByTable = BTCheckWildMvpState.MonsterStates
  },
  {
    ParamType = "integer",
    ParamName = "op",
    Required = true,
    ValueOptionsByTable = BTDefine.LogicOp
  }
}
BTDefine.InheritSchema(BTCheckWildMvpState.Schema, BTCondition.Schema)
BTCheckAnimatorIntParam.Comments = "检查 星 MVP 怪物状态\nmonsterid 怪物ID, 对应 MonsterList 表id\nstate 状态 Alive = 1 存活 | Dead = 2 死亡 | Unknown = 3 未招唤\nop 比较符\n"
