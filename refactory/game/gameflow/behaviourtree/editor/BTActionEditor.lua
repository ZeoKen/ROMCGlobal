BTAnimatorAction.Schema = {
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
  },
  {
    ParamType = "boolean",
    ParamName = "allAnimators",
    Required = true
  }
}
BTPlayAnimation.Schema = {
  {
    ParamType = "string",
    ParamName = "stateName",
    Required = true
  },
  {
    ParamType = "boolean",
    ParamName = "forceReplay",
    Required = false
  },
  {
    ParamType = "number",
    ParamName = "normalizesdTime",
    Required = false,
    DefaultValue = 0
  },
  {
    ParamType = "integer",
    ParamName = "layer",
    Required = false,
    DefaultValue = -1
  }
}
BTDefine.InheritSchema(BTPlayAnimation.Schema, BTAnimatorAction.Schema)
BTPlayAnimation.Comments = "播放 Animator 动画\nstateName 动画名\nforceReplay 是否强制重新播放，如果不勾选，那么当前已经在播放 stateName 动画时，会继续播放。\n"
BTSetAnimatorParam.Schema = {
  {
    ParamType = "string",
    ParamName = "paramName",
    Required = true
  },
  {
    ParamType = "custom",
    ParamName = "paramVal",
    Required = true
  },
  {
    ParamType = "integer",
    ParamName = "paramType",
    Required = false,
    ValueOptionsByTable = BTDefine.ParamTypes
  }
}
BTDefine.InheritSchema(BTSetAnimatorParam.Schema, BTAnimatorAction.Schema)
BTSetAnimatorParam.Comments = "设置 Animator parameter的值\nparamName Animator中定义的变量名\n"
BTSetAnimatorEnabled.Schema = {
  {
    ParamType = "boolean",
    ParamName = "enabled",
    Required = true
  }
}
BTDefine.InheritSchema(BTSetAnimatorEnabled.Schema, BTAnimatorAction.Schema)
BTSetAnimatorEnabled.Comments = "设置 Animator 开关\n"
BTTogglePlayerSpEffect.Schema = {
  {
    ParamType = "integer",
    ParamName = "effectId",
    Required = true
  },
  {
    ParamType = "number",
    ParamName = "duration",
    Required = true
  },
  {
    ParamType = "string",
    ParamName = "serviceKey",
    Required = true,
    ValueOptionsByTableKey = BTDefine.BBOptions
  },
  {
    ParamType = "integer",
    ParamName = "onBBKey",
    Required = true,
    ValueOptionsByParam = {DepParamName = "serviceKey"}
  },
  {
    ParamType = "integer",
    ParamName = "offBBKey",
    Required = true,
    ValueOptionsByParam = {DepParamName = "serviceKey"}
  }
}
BTTogglePlayerSpEffect.Comments = "添加/删除玩家SpEffect，例如拖尾特效\neffectId Table_SpEffect表中的id\nduration 持续时间\nserviceKey 必须定义的前置收集guid列表Service的名字\nonBBKey 添加的guid列表key\noffBBKey 删除的guid列表的key\n"
BTUserActionNtf.Schema = {
  {
    ParamType = "integer",
    ParamName = "actionId",
    Required = true
  },
  {
    ParamType = "boolean",
    ParamName = "loop",
    Required = true
  }
}
BTUserActionNtf.Comments = "播放HolyAction动作并同步给其他玩家\nactionId ActionAnime中定义的的id\n"
BTUseSkill.Schema = {
  {
    ParamType = "integer",
    ParamName = "skillId",
    Required = true
  }
}
BTTargetAction.Schema = {
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
BTTargetMoveTo.Schema = {
  {
    ParamType = "position",
    ParamName = "targetPosition",
    Required = true
  },
  {
    ParamType = "number",
    ParamName = "speed",
    Required = true
  }
}
BTDefine.InheritSchema(BTTargetMoveTo.Schema, BTTargetAction.Schema)
BTTargetMoveTo.Comments = "对象移动\nspeed 移动速度\n对象由tag和id决定，如果是GlobalTarget则必须配置前置的ChangeTarget Service指定对象\n"
BTTargetMoveToPlayer.Schema = {
  {
    ParamType = "number",
    ParamName = "speed",
    Required = true
  },
  {
    ParamType = "vector",
    ParamName = "offset",
    Required = false
  }
}
BTDefine.InheritSchema(BTTargetMoveToPlayer.Schema, BTTargetAction.Schema)
BTTargetMoveToPlayer.Comments = "对象向玩家移动\nspeed 移动速度，等于0时瞬移\noffset 目标点的偏移量\n"
BTTargetRotateTo.Schema = {
  {
    ParamType = "rotation",
    ParamName = "targetRotation",
    Required = true
  },
  {
    ParamType = "number",
    ParamName = "rotateSpeed",
    Required = true
  }
}
BTDefine.InheritSchema(BTTargetRotateTo.Schema, BTTargetAction.Schema)
BTTargetRotateTo.Comments = "对象旋转\nrotateSpeed 旋转速度，单位角度/秒，等于0时瞬间旋转\n对象由tag和id决定，如果是GlobalTarget则必须配置前置的ChangeTarget Service指定对象\n"
BTTargetLookAt.Schema = {
  {
    ParamType = "position",
    ParamName = "targetPosition",
    Required = true
  },
  {
    ParamType = "number",
    ParamName = "rotateSpeed",
    Required = true
  }
}
BTDefine.InheritSchema(BTTargetLookAt.Schema, BTTargetAction.Schema)
BTTargetLookAt.Comments = "对象看向某处\nrotateSpeed 旋转速度，单位角度/秒，等于0时瞬间旋转\n对象由tag和id决定，如果是GlobalTarget则必须配置前置的ChangeTarget Service指定对象\n"
BTTargetSetActive.Schema = {
  {
    ParamType = "boolean",
    ParamName = "active",
    Required = true,
    DefaultValue = true
  }
}
BTDefine.InheritSchema(BTTargetSetActive.Schema, BTTargetAction.Schema)
BTTargetSetActive.Comments = "对象Active状态\n"
BTAbort.Comments = "结束行为树\n"
BTPlayTimeline.Schema = {
  {
    ParamType = "string",
    ParamName = "assetId",
    Required = true
  },
  {
    ParamType = "blackboard",
    ParamName = "bbOnComplete",
    Required = true
  }
}
BTPlayTimeline.Comments = "播放剧情编辑器\nassetId 剧情配置的id\nbbOnComplete 剧情播完时设置黑板参数\n"
BTStopTimeline.Schema = {
  {
    ParamType = "string",
    ParamName = "assetId",
    Required = true
  }
}
BTStopTimeline.Comments = "停止播放剧情\n"
BTDisplayZoneInfo.Schema = {
  {
    ParamType = "integer",
    ParamName = "zoneId",
    Required = true
  },
  {
    ParamType = "number",
    ParamName = "duration",
    Required = false
  }
}
BTDisplayZoneInfo.Comments = "显示区域信息UI\nzoneId Table_MapZone表中的ID\nduration 显示持续时间\n"
BTDisplayZoneCD.Schema = {
  {
    ParamType = "integer",
    ParamName = "zoneid",
    Required = true
  },
  {
    ParamType = "integer",
    ParamName = "msgtype",
    Required = true,
    ValueOptionsByTable = BTDisplayZoneCD.MsgTypes
  },
  {
    ParamType = "integer",
    ParamName = "msgid",
    Required = true
  },
  {
    ParamType = "boolean",
    ParamName = "visible",
    Required = true
  }
}
BTDisplayZoneCD.Comments = "显示区域CD\nzoneid 对应区域的id\nvisible 显示/隐藏\n"
BTBoidDetectTarget.Schema = {
  {
    ParamType = "string",
    ParamName = "goalService",
    Required = true,
    ValueOptionsByTableKey = BTDefine.BBOptions
  },
  {
    ParamType = "integer",
    ParamName = "goalBBKey",
    Required = true,
    ValueOptionsByParam = {
      DepParamName = "goalService"
    }
  },
  {
    ParamType = "string",
    ParamName = "obstacleService",
    Required = true,
    ValueOptionsByTableKey = BTDefine.BBOptions
  },
  {
    ParamType = "integer",
    ParamName = "obstacleBBKey",
    Required = true,
    ValueOptionsByParam = {
      DepParamName = "obstacleService"
    }
  }
}
BTDefine.InheritSchema(BTBoidDetectTarget.Schema, BTTargetAction.Schema)
BTBoidDetectTarget.Comments = "goalService goal数据的收集器\ngoalBBKey goal数据的key\nobstacleService obstacle数据的收集器\nobstacleBBKey obstacle数据的key\n"
