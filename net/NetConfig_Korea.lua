local NetConfig = NetConfig
NetConfig.PUBLIC_GAME_SERVER_IP = ""
NetConfig.PUBLIC_GAME_SERVER_PORT = 0
NetConfig.PrivateAuthServerUrl = ""
NetConfig.PrivateAuthServerUrlPort = 0
NetConfig.PrivateGameServerUrl = "47.102.102.204"
NetConfig.PrivateGameServerUrlPort = 6003
NetConfig.AnnounceAddress = "storage.googleapis.com/ro-kr-notice"
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
