local EnvChannel = EnvChannel
EnvChannel.ChannelConfig.Develop = {
  Name = "Develop",
  ServerList = "Table_ServerList",
  ip = {
    "kr-gateway.vvv.io"
  },
  port = 8888
}
EnvChannel.ChannelConfig.Release = {
  Name = "Release",
  ServerList = "Table_ServerList",
  ip = {
    "kr-prod-gateway.ro.com"
  },
  port = 8888
}
EnvChannel.ChannelConfig.Alpha = {
  Name = "Alpha",
  ServerList = "Table_ServerList",
  ip = {
    "gstar-gateway.kr.mmo.ro.com"
  },
  port = 8888
}
EnvChannel.ChannelConfig.Studio = {
  Name = "Studio",
  ServerList = "Table_ServerList",
  ip = {
    "104.199.150.66"
  },
  port = 8888
}
EnvChannel.ChannelConfig.Oversea = {
  Name = "Oversea",
  ServerList = "Table_ServerList_Oversea",
  ip = {"ww.vvv.io"},
  port = 8888
}
EnvChannel.BranchBitValue[EnvChannel.ChannelConfig.Oversea.Name] = 8
EnvChannel.Channel = EnvChannel.ChannelConfig.Oversea
