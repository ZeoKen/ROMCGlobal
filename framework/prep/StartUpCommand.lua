StartUpCommand = class("StartUpCommand", pm.MacroCommand)
autoImport("PrepDataProxyCommand")
autoImport("PrepServiceProxyCommand")
autoImport("PrepCMDCommand")
autoImport("PrepUICommand")
autoImport("SpeechRecognizer")

function StartUpCommand:initializeMacroCommand()
  self:addSubCommand(PrepDataProxyCommand)
  self:addSubCommand(PrepServiceProxyCommand)
  self:addSubCommand(PrepCMDCommand)
  self:addSubCommand(PrepUICommand)
  FunctionAppStateMonitor.Me():Launch()
  if BranchMgr.IsChina() then
    local envChannel = EnvChannel.Channel.Name
    local channelConfig = EnvChannel.ChannelConfig
    if ApplicationInfo.IsRunOnEditor() then
      LogUtility.Info("编辑器模式 无法使用jpush")
    else
      ROPush.Init("JPushBinding")
      ROPush.SetDebug(envChannel == channelConfig.Develop.Name or envChannel == channelConfig.Studio.Name)
      ROPush.ResetBadge()
      ROPush.SetApplicationIconBadgeNumber(0)
    end
  end
  NetMonitor.Me():InitCallBack()
  NetMonitor.Me():ListenSkillUseSendCallBack()
  LuaGC.StartLuaGC()
end
