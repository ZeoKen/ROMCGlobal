PushConfig = {}
PushConfig.EventConfig = {}
PushConfig.ChannelConfig = {
  CN = "CN",
  KR = "KR",
  OR = "OR"
}
PushConfig.CommonEventCount = #PushConfig.EventConfig
if BranchMgr.IsKorea() then
  PushConfig.EventConfig[PushConfig.CommonEventCount + 1] = {
    key = {
      "daytime_push"
    },
    name = ZhString.PushConfig_Daytime
  }
  PushConfig.EventConfig[PushConfig.CommonEventCount + 2] = {
    key = {"night_push"},
    name = ZhString.PushConfig_Night
  }
  PushConfig.Channel = PushConfig.ChannelConfig.KR
elseif BranchMgr.IsChina() then
  PushConfig.Channel = PushConfig.ChannelConfig.CN
else
  PushConfig.Channel = PushConfig.ChannelConfig.OR
end
PushConfig.Temp_ForbidPushSet = 1
