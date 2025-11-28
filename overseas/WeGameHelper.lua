WeGameHelper = {}

function WeGameHelper:trackCreatRole(serverId, level)
  local SDKEnable = EnvChannel.SDKEnable()
  if SDKEnable then
    Debug.Log("WeGameHelper:trackCreatRole")
    local overseasManager = OverSeas_TW.OverSeasManager.GetInstance()
    local passportInfoStr
    if FunctionLogin.Me():getSdkType() == FunctionSDK.E_SDKType.TDSG then
      if BranchMgr.IsTW() or BranchMgr.IsKorea() then
        overseasManager:TrackEvent("charater create")
      else
        overseasManager:TrackCreateRole()
      end
      local roleInfo = ServiceUserProxy.Instance:GetNewRoleInfo()
      roleInfo = roleInfo ~= nil and roleInfo or ServiceUserProxy.Instance:GetRoleInfo()
      local roleId = roleInfo.id
      local roleName = roleInfo.name
      overseasManager:TrackAccount(tostring(roleId), tostring(roleName), serverId, level)
    end
  end
end

function WeGameHelper:urlEncode(str)
  if str then
    str = string.gsub(str, "\n", "\r\n")
    str = string.gsub(str, "([^%w ])", function(c)
      return string.format("%%%02X", string.byte(c))
    end)
    str = string.gsub(str, " ", "+")
  end
  return str
end

function WeGameHelper:caculateSign(data, lastKey)
  local secret = "d1b0e8aa437119d95602403c0c8f1472"
  local orginStr = ""
  local key_table = {}
  for key, _ in pairs(data) do
    table.insert(key_table, key)
  end
  table.sort(key_table)
  for _, key in pairs(key_table) do
    orginStr = orginStr .. key .. "=" .. data[key]
    if key ~= lastKey then
      orginStr = orginStr .. "&"
    end
  end
  orginStr = orginStr .. secret
  local md5Str = MyMD5.HashString(orginStr)
  return md5Str
end

function WeGameHelper:WeGameHelperRequest(data, sign, test)
  local baseUrl = test ~= nil and "https://test-api.wegames.com.tw/api/" or "https://api.wegames.com.tw/api/"
  Debug.Log(baseUrl)
  local requests = HttpWWWSeveralRequests()
  local form = WWWForm()
  local key_table = {}
  for key, _ in pairs(data) do
    table.insert(key_table, key)
  end
  table.sort(key_table)
  for _, key in pairs(key_table) do
    form:AddField(key, tostring(data[key]))
  end
  form:AddField("wg_sign", sign)
  local timeoutSec = 30
  local order = HttpWWWRequestOrder(baseUrl, timeoutSec, form, false, true)
  requests:AddOrder(order)
  requests:SetCallBacks(function(response)
    Debug.LogFormat("WeGameRequest Message:{0}", response.resString)
  end, function(order)
    Debug.LogFormat("WeGameRequest Error:{0}", order)
  end)
  requests:StartRequest()
end
