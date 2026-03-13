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
  local urls = StringUtil.Json2Lua(HttpOperationJson.Instance.rawString).urls
  NetConfig.NewAccessTokenAuthHost = urls
end
