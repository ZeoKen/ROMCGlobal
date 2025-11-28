local NetConfig = NetConfig
NetConfig.PUBLIC_GAME_SERVER_IP = ""
NetConfig.PUBLIC_GAME_SERVER_PORT = 0
NetConfig.PrivateAuthServerUrl = ""
NetConfig.PrivateAuthServerUrlPort = 0
NetConfig.PrivateGameServerUrl = "47.102.102.204"
NetConfig.PrivateGameServerUrlPort = 6006
NetConfig.AnnounceAddress = "storage.googleapis.com/ro-no-notice"
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
    "no-devel-gateway.ro.com",
    "no-devel-gateway.ro.com"
  },
  EN = {
    "no-devel-gateway.ro.com"
  }
}
NetConfig.NewGateHost = {
  "-devel-gateway.ro.com",
  "no-devel-gateway.ro.com",
  "no-devel-gateway.ro.com"
}
NetConfig.NewGateHost_NOTEST = {
  "no-devel-gateway.ro.com"
}
