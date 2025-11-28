EnvChannel = {}
EnvChannel.ServerListTableName = nil
EnvChannel.ChannelConfig = {
  Develop = {
    Name = "Develop",
    ServerList = "Table_ServerList",
    ip = {
      "gw-m-ro-gf.xd.com"
    },
    port = 5005,
    NeedGM = true,
    initReporter = true
  },
  Alpha = {
    Name = "Alpha",
    ServerList = "Table_ServerList_Alpha",
    ip = {
      "gw-m-ro-gf.xd.com",
      "gw-m-ro.xd.com"
    },
    port = 5001
  },
  Studio = {
    Name = "Studio",
    ServerList = "Table_ServerList_Studio",
    ip = {
      "gw-m-ro-gf.xd.com",
      "gw-m-ro.xd.com"
    },
    port = 5001,
    initReporter = true
  },
  Gravity = {
    Name = "Gravity",
    ServerList = "Table_ServerList_Gravity",
    ip = {
      "223.202.22.30"
    },
    port = 5003
  },
  UWA = {
    Name = "UWA",
    ServerList = "Table_ServerList_UWA",
    ip = {
      "gw-m-ro-gf.xd.com",
      "gw-m-ro.xd.com"
    },
    port = 5001,
    NeedGM = true
  },
  Release = {
    Name = "Release",
    ServerList = "Table_ServerList_Alpha",
    ip = {
      "gw-m-ro-gf.xd.com",
      "gw-m-ro.xd.com"
    },
    port = 5000
  },
  Oversea = {
    Name = "Oversea",
    ServerList = "Table_ServerList_Oversea",
    ip = {"jp.vvv.io"},
    port = 5223
  }
}
EnvChannel.BranchBitValue = {
  [EnvChannel.ChannelConfig.Develop.Name] = 1,
  [EnvChannel.ChannelConfig.Studio.Name] = 2,
  [EnvChannel.ChannelConfig.Alpha.Name] = 4,
  [EnvChannel.ChannelConfig.Release.Name] = 8
}
if BranchMgr.IsJapan() then
  autoImport("EnvChannel_Japan")
elseif BranchMgr.IsTW() then
  autoImport("EnvChannel_Taiwan")
elseif BranchMgr.IsKorea() then
  autoImport("EnvChannel_Korea")
elseif BranchMgr.IsSEA() then
  autoImport("EnvChannel_SEA")
elseif BranchMgr.IsNA() then
  autoImport("EnvChannel_NA")
elseif BranchMgr.IsEU() then
  autoImport("EnvChannel_EU")
end
EnvChannel.Channel = EnvChannel.ChannelConfig.Develop
if AppEnvConfig.Instance then
  EnvChannel.Channel = EnvChannel.ChannelConfig[AppEnvConfig.Instance.channelEnv]
  if EnvChannel.Channel == nil then
    EnvChannel.Channel = EnvChannel.ChannelConfig.Develop
    if not BranchMgr.IsChina() then
      local auth = NetConfig.OverseasAuth
      auth = string.gsub(auth, "https?://", "")
      auth = string.gsub(auth, ":%d+", "")
      auth = string.gsub(auth, "prod%-", "")
      auth = string.gsub(auth, "devel%-", "")
      auth = string.gsub(auth, "auth", "gateway")
      EnvChannel.Channel.ip = {auth}
    end
  end
  EnvChannel.ServerListTableName = EnvChannel.Channel.ServerList
  if ResourceID.CheckFileIsRecorded(EnvChannel.ServerListTableName) then
    autoImport(EnvChannel.ServerListTableName)
    Table_ServerList = _G[EnvChannel.ServerListTableName]
  else
    autoImport("Table_ServerList")
  end
else
  autoImport("Table_ServerList")
end

function EnvChannel.GetPublicIP()
  local ipConfig = EnvChannel.Channel
  return ipConfig ~= nil and ipConfig.ip or {
    NetConfig.PUBLIC_GAME_SERVER_IP
  }
end

function EnvChannel.GetPublicPort()
  local ipConfig = EnvChannel.Channel
  return ipConfig ~= nil and ipConfig.port or NetConfig.PUBLIC_GAME_SERVER_PORT
end

function EnvChannel.GMButtonEnable()
  return EnvChannel.Channel.NeedGM == true
end

function EnvChannel.SDKEnable()
  if AppEnvConfig.Instance then
    return AppEnvConfig.Instance.NeedSDK
  end
  return false
end

function EnvChannel.IsReleaseBranch()
  return EnvChannel.Channel.Name == EnvChannel.ChannelConfig.Release.Name
end

function EnvChannel.IsTFBranch()
  return EnvChannel.Channel.Name == EnvChannel.ChannelConfig.Alpha.Name
end

function EnvChannel.IsStudioBranch()
  return EnvChannel.Channel.Name == EnvChannel.ChannelConfig.Studio.Name
end

function EnvChannel.IsTrunkBranch()
  return EnvChannel.Channel.Name == EnvChannel.ChannelConfig.Develop.Name
end

function EnvChannel.GetHttpOperationJson()
  local httpJson = HttpOperationJson.Instance
  if httpJson then
    local str = httpJson.rawString
    helplog(str)
    if str then
      EnvChannel.httpOptJson = StringUtil.Json2Lua(str)
    end
  end
  return EnvChannel.httpOptJson
end
