local NetConfig = NetConfig
NetConfig.PrivateGameServerUrl = "47.102.102.204"
NetConfig.PrivateGameServerUrlPort = 6006
NetConfig.AnnounceAddress = "storage.googleapis.com/ro-noen-notice"
NetConfig.AuthHostNovice = "nona-prod-auth.ro.com"
if HttpOperationJson.Instance then
  NetConfig.OverseasAuth = StringUtil.Json2Lua(HttpOperationJson.Instance.rawString).urls[1]
end
NetConfig.NewAccessTokenAuthHost = {
  NetConfig.OverseasAuth,
  NetConfig.OverseasAuth,
  NetConfig.OverseasAuth
}
