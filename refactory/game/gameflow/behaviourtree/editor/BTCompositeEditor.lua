BTSelector.Comments = "顺序执行Children，当某个子节点返回成功时结束并返回成功。所有子节点返回失败时返回失败。\n如果设置了preCondition，当preCondition返回失败时，直接返回失败。\n"
BTConditionalSelector.Schema = {
  {
    ParamType = "boolean",
    ParamName = "alwaysExec",
    Required = true
  }
}
BTConditionalSelector.Comments = "根据preCondition返回的序号选择执行的子节点\n必须配置preCondition，且通过Condition的passRet和failRet返回给Selector作为执行子节点的序号。\n"
BTSequence.Comments = "顺序执行Children，当某个子节点返回失败时结束并返回失败。所有子节点都返回成功时返回成功。\n如果设置了preCondition，当preCondition返回失败时，直接返回失败。\n"
BTParallel.Comments = "顺序执行所有Children，并返回成功。\n如果设置了preCondition，当preCondition返回失败时，直接返回失败。\n"
BTCooldown.Schema = {
  {
    ParamType = "number",
    ParamName = "cd",
    Required = true
  }
}
BTCooldown.Comments = "提供cooldown功能\n一般挂一个子Composite，机制类似parallel，顺序执行所有子节点，当有1个子节点返回成功时，开始cd\n"
