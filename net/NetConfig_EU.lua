local NetConfig = NetConfig
NetConfig.PUBLIC_GAME_SERVER_IP = ""
NetConfig.PUBLIC_GAME_SERVER_PORT = 0
NetConfig.PrivateAuthServerUrl = ""
NetConfig.PrivateAuthServerUrlPort = 0
NetConfig.PrivateGameServerUrl = "47.102.102.204"
NetConfig.PrivateGameServerUrlPort = 6006
NetConfig.AnnounceAddress = "storage.googleapis.com/ro-eu-notice"
if HttpOperationJson.Instance then
  NetConfig.OverseasAuth = StringUtil.Json2Lua(HttpOperationJson.Instance.rawString).urls[1]
end
NetConfig.AccessTokenAuthHost = {
  CN = {
    NetConfig.OverseasAuth,
    NetConfig.OverseasAuth
  },
  EN = {
    NetConfig.OverseasAuth
  }
}
NetConfig.NewAccessTokenAuthHost = {
  NetConfig.OverseasAuth,
  NetConfig.OverseasAuth,
  NetConfig.OverseasAuth
}
NetConfig.GateHost = {
  CN = {
    "kr-devel-gateway.ro.com",
    "kr-devel-gateway.ro.com"
  },
  EN = {
    "kr-devel-gateway.ro.com"
  }
}
NetConfig.NewGateHost = {
  "kr-devel-gateway.ro.com",
  "kr-devel-gateway.ro.com",
  "kr-devel-gateway.ro.com"
}
NetConfig.NewGateHost_NOTEST = {
  "kr-devel-gateway.ro.com"
}
NetConfig.AliyunSecurityIPSdkServerGroup = {
  CN = {
    {
      "rogame01.8mt9y3kc02.aliyungf.com",
      "rogame02.d0esx39ki3.aliyungf.com"
    },
    {
      "rogame03.2vm2y89vy8.aliyungf.com",
      "rogame04.flgz057w55.aliyungf.com"
    },
    {
      "rogame05.3cisrammt8.aliyungf.com",
      "rogame06.9o3hda7mt7.aliyungf.com"
    },
    {
      "rogame07.avlpndshxq.aliyungf.com",
      "rogame08.0qd1h196ed.aliyungf.com"
    }
  },
  EN = {}
}
