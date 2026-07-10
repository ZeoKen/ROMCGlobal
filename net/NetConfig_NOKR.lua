local NetConfig = NetConfig
NetConfig.PrivateGameServerUrl = "47.102.102.204"
NetConfig.PrivateGameServerUrlPort = 6006
NetConfig.AnnounceAddress = "storage.googleapis.com/ro-nokr-notice"
if HttpOperationJson.Instance then
  local urls = StringUtil.Json2Lua(HttpOperationJson.Instance.rawString).urls
  NetConfig.NewAccessTokenAuthHost = urls
end
