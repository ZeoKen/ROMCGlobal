NetConfig.PUBLIC_GAME_SERVER_IP = ""
NetConfig.PUBLIC_GAME_SERVER_PORT = 0
NetConfig.PrivateAuthServerUrl = ""
NetConfig.PrivateAuthServerUrlPort = 0
NetConfig.PrivateAuthServerUrl = ""
NetConfig.PrivateAuthServerUrlPort = 0
NetConfig.PrivateGameServerUrl = "47.102.102.204"
NetConfig.PrivateGameServerUrlPort = 6002
NetConfig.AnnounceAddress = "storage.googleapis.com/ro-tw-notice"
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
    "rom-prod-gateway.wegames.com.tw",
    "rom-prod-gateway.wegames.com.tw"
  },
  EN = {
    "rom-prod-gateway.wegames.com.tw"
  }
}
NetConfig.NewGateHost = {
  "rom-prod-gateway.wegames.com.tw",
  "rom-prod-gateway.wegames.com.tw",
  "rom-prod-gateway.wegames.com.tw"
}
NetConfig.NewGateHost_NOTEST = {
  "rom-prod-gateway.wegames.com.tw"
}
