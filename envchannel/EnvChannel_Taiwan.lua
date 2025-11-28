local EnvChannel = EnvChannel
EnvChannel.ChannelConfig.Develop = {
  Name = "Develop",
  ServerList = "Table_ServerList",
  ip = {
    "rohub-tw.vvv.io"
  },
  port = 6002
}
EnvChannel.ChannelConfig.Release = {
  Name = "Release",
  ServerList = "Table_ServerList",
  ip = {
    "rom-prod-gateway.wegames.com.tw"
  },
  port = 8888
}
EnvChannel.ChannelConfig.Alpha = {
  Name = "Alpha",
  ServerList = "Table_ServerList",
  ip = {
    "rom-release-gateway.wegames.com.tw"
  },
  port = 8888
}
EnvChannel.ChannelConfig.Studio = {
  Name = "Studio",
  ServerList = "Table_ServerList",
  ip = {
    "rom-release-gateway.wegames.com.tw"
  },
  port = 8888
}
EnvChannel.ChannelConfig.Oversea = {
  Name = "Oversea",
  ServerList = "Table_ServerList",
  ip = {
    "rohub-tw.vvv.io"
  },
  port = 6002
}
EnvChannel.BranchBitValue[EnvChannel.ChannelConfig.Oversea.Name] = 8
