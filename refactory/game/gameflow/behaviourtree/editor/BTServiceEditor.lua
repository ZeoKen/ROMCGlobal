BTPlayerTriggerCollector.Schema = {
  {
    ParamType = "number",
    ParamName = "groupRange",
    Required = true
  },
  {
    ParamType = "collider",
    ParamName = "collider",
    Required = true
  }
}
BTPlayerTriggerCollector.Comments = "触发器收集器\ngroupRange 靠近玩家的判定范围\n收集以下数据：\nUserCount 触发器中玩家的数量\nFoundMe 我在不在触发器内\nMeStayDuration 我在触发器中的持续时间，单位秒\nFoundMeInGroup 我附近有靠近的玩家，并且至少有一人在触发器内\nFoundGroup 是否有靠近玩家，并且至少有一人在触发器内\nGroupStayDuration 有靠近玩家在触发器内的持续时间，单位秒\nMeHandInHand 有与我牵手的玩家，且至少有一人在触发器内\nAnyHandInHand 有牵手玩家，且至少有一人在触发器内\nMeFirstIn 我是否第一次进入\nUserGuids 在触发器内的guid列表\n布尔值通过是否大于0来记录，所以Condition中要判定是否时，用Greater than 0的逻辑。\n"
BTPlayerTriggerInOutCollector.Schema = {
  {
    ParamType = "string",
    ParamName = "preServiceName",
    Required = true,
    ValueOptionsByTableKey = BTDefine.BBOptions
  },
  {
    ParamType = "integer",
    ParamName = "bbKey",
    Required = true,
    ValueOptionsByParam = {
      DepParamName = "preServiceName"
    }
  }
}
BTPlayerTriggerInOutCollector.Comments = "触发器收集器，依赖前置收集器返回的数据\n收集以下数据：\nLastInGuids 上一帧在触发器里的玩家guid列表\nFirstInGuids 首次进入触发器的玩家guid列表\nFirstOutGuids 首次离开触发器的玩家guid列表\n"
BTBBChangeTarget.Schema = {
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
BTBBChangeTarget.Comments = "切换全局唯一操作对象，记录在Blackboard上，给后续节点使用。\ntag 用于查询对象的标签，目前支持以下查询器：\n\t[2] ObjectFinder 挂了LuaGameObject脚本，并且指定Type=29的对象\nid 对象的id，tag对应对象查找器的参数\n"
BTBBSetValue.Schema = {
  {
    ParamType = "blackboard",
    ParamName = "bbParam",
    Required = true
  }
}
BTBBSetValue.Comments = "设置BlackBoard的变量值\nparamName 变量名\nparamvVal 变量值\n"
BTBBUnsetValue.Schema = {
  {
    ParamType = "blackboard",
    ParamName = "bbParam",
    Required = true
  }
}
BTBBUnsetValue.Comments = "清空BlackBoard上的值\nparamName 变量名\nparamvVal 不需要填\n"
