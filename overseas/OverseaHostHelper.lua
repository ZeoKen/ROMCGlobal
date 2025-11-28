OverseaHostHelper = {}
autoImport("GoogleStorageConfig")
OverseaHostHelper.curServerData = nil
OverseaHostHelper.hostList = nil
OverseaHostHelper.accId = 0
OverseaHostHelper.hasShowAge = false
OverseaHostHelper.regions = nil
OverseaHostHelper.langZone = ApplicationInfo.GetSystemLanguage()
OverseaHostHelper.KRfireBaseFirstAgreent = "KRfireBaseFirstAgreent"
OverseaHostHelper.accountUID = nil
OverseaHostHelper.firebaseNotify = nil
OverseaHostHelper.firebaseNotifyUpdated = nil
OverseaHostHelper.firebaseNotifyExpired = nil

function OverseaHostHelper:SetFireBaseNotify(_uid, _firebaseNotify, _firebaseNotifyUpdated, _firebaseNotifyExpired)
  redlog("===========OverseaHostHelper:SetFireBaseNotify===========")
  helplog("_uid == ", _uid)
  helplog("_firebaseNotify == ", _firebaseNotify)
  helplog("_firebaseNotify == ", _firebaseNotifyUpdated)
  helplog("_firebaseNotify == ", _firebaseNotifyExpired)
  OverseaHostHelper.accountUID = _uid
  OverseaHostHelper.firebaseNotify = _firebaseNotify
  OverseaHostHelper.firebaseNotifyUpdated = _firebaseNotifyUpdated
  OverseaHostHelper.firebaseNotifyExpired = tostring(_firebaseNotifyExpired)
  OverseaHostHelper:ShowFirstFireBaseAgreet()
  OverseaHostHelper:ShowfirebaseNotifyExpired()
end

function OverseaHostHelper:ShowfirebaseNotifyExpired()
  if OverseaHostHelper.firebaseNotifyExpired ~= nil and OverseaHostHelper.firebaseNotifyExpired == "true" then
    MsgManager.ConfirmMsgByID(1000013)
  end
end

function OverseaHostHelper:ShowFirstFireBaseAgreet()
  if OverseaHostHelper:GetIsFireBaseFirst() then
    local firebasestatus = OverSeas_TW.OverSeasManager.GetInstance():GetNotificationStatus()
    local y, m, d = OverseaHostHelper:GetFireBaseChangeTime()
    if firebasestatus then
      MsgManager.ShowMsgByIDTable(1000011, {
        y,
        m,
        d
      })
    else
      MsgManager.ShowMsgByIDTable(1000012, {
        y,
        m,
        d
      })
    end
  end
end

function OverseaHostHelper:CheckFirstFirebaseCallServer()
  if not BranchMgr.IsKorea() then
    return
  end
  local firebasestatus = OverSeas_TW.OverSeasManager.GetInstance():GetNotificationStatus()
  if OverseaHostHelper:GetIsFireBaseFirst() then
    ServiceOverseasTaiwanCmdProxy.Instance:CallFirebaseNotifyUpdateCmd(firebasestatus)
    PlayerPrefs.SetInt(OverseaHostHelper.KRfireBaseFirstAgreent .. OverseaHostHelper.accountUID, 1)
  elseif OverseaHostHelper.firebaseNotifyExpired == "true" then
    ServiceOverseasTaiwanCmdProxy.Instance:CallFirebaseNotifyUpdateCmd(true)
  end
end

function OverseaHostHelper:GetIsFireBaseFirst()
  if OverseaHostHelper.accountUID == nil then
    return false
  end
  local prefsKey = OverseaHostHelper.KRfireBaseFirstAgreent .. OverseaHostHelper.accountUID
  if not PlayerPrefs.HasKey(prefsKey) then
    return true
  end
  return false
end

function OverseaHostHelper:GetFireBaseChangeTime()
  local curServerTime = ServerTime.CurServerTime()
  if currentTime ~= nil then
    currentTime = currentTime / 1000
  else
    currentTime = os.time()
  end
  local year = os.date("%Y", curServerTime)
  local month = os.date("%m", curServerTime)
  local day = os.date("%d", curServerTime)
  return year, month, day
end

function OverseaHostHelper:RefreshHostInfo(hostList)
  OverseaHostHelper.hostList = hostList
end

function OverseaHostHelper:ResetSectors(sid)
  if not GameConfig.Zone or not sid then
    return
  end
  helplog("OverseaHostHelper:ResetSectors:" .. sid)
  if OverseaHostHelper.regions ~= nil then
    for _, v in pairs(OverseaHostHelper.regions) do
      helplog("in:" .. v.sid)
      if tostring(v.sid) == tostring(sid) then
        helplog("find sectors:" .. tostring(sid))
        GameConfig.Zone.zone_name = v.sectors
        break
      end
    end
  else
    helplog("OverseaHostHelper.regions is nil")
  end
end

function OverseaHostHelper:RefreshServerInfo(serverData)
end

function OverseaHostHelper:GetHosts()
  local sid, curServerInfo
  local server = FunctionLogin.Me():getCurServerData()
  if server and server.sid then
    sid = server.sid
  end
  if OverseaHostHelper.regions ~= nil then
    for k, v in pairs(OverseaHostHelper.regions) do
      if v.sid == sid then
        curServerInfo = v
        break
      end
    end
  end
  local hosts = {}
  if curServerInfo and curServerInfo.gateways ~= nil and #curServerInfo.gateways > 0 and curServerInfo.gateways[1] ~= "" then
    helplog("使用内层 gates")
    hosts = curServerInfo.gateways
  elseif OverseaHostHelper.hostList ~= nil then
    for k, v in pairs(OverseaHostHelper.hostList) do
      table.insert(hosts, v.host)
    end
  end
  helplog("OverseaHostHelper:GetHosts")
  for _, h in pairs(hosts) do
    helplog(sid, h)
  end
  return hosts
end

function OverseaHostHelper:SetUCloudConfig(uCloudConfig)
  if uCloudConfig ~= nil then
    local addrs = uCloudConfig.addrs
    local funcs = uCloudConfig.funcs
    self.ucloud_addrs = addrs
    self.ucloud_funcs = funcs
  end
end

function OverseaHostHelper:InitDomainMap()
  self.ucloud_domainMap = {}
end

function OverseaHostHelper:AddDomainWithIp(domain, ip)
  Debug.Log("OverseaHostHelper => AddDomainWithIp" .. " domain :" .. tostring(domain) .. " ip" .. tostring(ip))
  self.ucloud_domainMap[domain] = ip
end

function OverseaHostHelper:GetRoleIde()
  local roleInfo = ServiceUserProxy.Instance:GetNewRoleInfo()
  roleInfo = roleInfo ~= nil and roleInfo or ServiceUserProxy.Instance:GetRoleInfo()
  local roleId = roleInfo.id
  local timestamp = os.time()
  local ide = roleId .. tostring(timestamp)
  helplog(ide)
  return ide
end

function OverseaHostHelper:isJP()
  return OverSea.LangManager.Instance().CurSysLang == "Japanese"
end

function OverseaHostHelper:CheckStoreIap(open)
  if BranchMgr.IsTW() then
    return
  end
  if ServiceUserProxy.Instance:GetRoleInfo() ~= nil then
    local promotingIap = PlayerPrefs.GetString("PromotingIAP")
    local curProduct
    for _, v in pairs(Table_Deposit) do
      local tpro = v
      if promotingIap ~= "" and tpro.ProductID == promotingIap then
        curProduct = tpro
        break
      end
    end
    if curProduct ~= nil then
      helplog("OverseaHostHelper:CheckStoreIap:" .. promotingIap)
      if open then
        EventManager.Me():AddEventListener(ServiceEvent.UserEventQueryChargeCnt, self.OnReceiveQueryChargeCnt, self)
        ServiceUserEventProxy.Instance:CallQueryChargeCnt()
      else
        GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
          view = PanelConfig.StorePayPanel,
          viewdata = {}
        })
      end
    else
      helplog("不存在缓存的Store 预售,不触发")
    end
  else
    helplog("还未登录,不触发")
  end
end

function OverseaHostHelper:OnReceiveQueryChargeCnt(data)
  EventManager.Me():RemoveEventListener(ServiceEvent.UserEventQueryChargeCnt, self.OnReceiveQueryChargeCnt, self)
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.StorePayPanel,
    viewdata = {}
  })
end

function OverseaHostHelper:StoreIap(msg)
  redlog("UNEXPECTED CALL: 'OverseaHostHelper:StoreIap' is discarded.")
  PlayerPrefs.SetString("PromotingIAP", msg)
  OverseaHostHelper:CheckStoreIap(false)
end

function OverseaHostHelper:ZoneInfoToNum(name, zid)
  local info
  for _, v in pairs(GameConfig.Zone.zone_name) do
    if v.name_prefix == name then
      info = v
      break
    end
  end
  if info == nil then
    MsgManager.FloatMsg("", ZhString.ZoneStrError)
    return nil
  end
  local min = info.min
  local max = info.max
  local range = max - min + 1
  local numberZid = tonumber(zid)
  if numberZid == nil or numberZid == 0 or range < numberZid then
    MsgManager.FloatMsg("", string.format(ZhString.ChangeZoneError, tostring(range)))
    return nil
  end
  local rNum = min + numberZid - 1
  return rNum
end

OverseaHostHelper.isGuest = 0

function OverseaHostHelper:GuestExchangeForbid()
  if OverseaHostHelper.isGuest == 1 then
    MsgManager.FloatMsg("", ZhString.GuestExchangeForbid)
  end
  return OverseaHostHelper.isGuest
end

function OverseaHostHelper:guestSecurity(callback, callbackParam)
  if OverseaHostHelper.isGuest == 1 then
    UIUtil.PopUpConfirmYesNoView(ZhString.GuestSecurityTitle, ZhString.GuestSecurityContent, function()
      Game.Me():BackToLogo()
    end, function()
    end, nil, ZhString.GuestSecurityConfirm, ZhString.GuestSecurityCancel)
  elseif callback then
    callback(callbackParam)
  end
end

OverseaHostHelper.lastAuthUrl = ""

function OverseaHostHelper:TryResetCheckGuest()
  helplog("OverseaHostHelper:TryResetCheckGuest")
  if PlayerPrefs.GetInt("NeedCheckGuest", 0) == 1 then
    PlayerPrefs.DeleteKey("NeedCheckGuest")
    local order = HttpWWWRequestOrder(OverseaHostHelper.lastAuthUrl, NetConfig.HttpRequestTimeOut, nil, false, true)
    if order then
      order:SetCallBacks(function(response)
        local content = response.resString
        helplog(content)
        local result
        pcall(function(i)
          result = StringUtil.Json2Lua(content)
          if result == nil then
            result = json.decode(content)
          end
        end)
        if result and result.data then
          OverseaHostHelper.isGuest = tonumber(result.data.isGuest)
        end
      end, function(order)
      end, function(order)
      end)
      Game.HttpWWWRequest:RequestByOrder(order)
    end
  end
end

function OverseaHostHelper:getScriptPath()
  return ApplicationHelper.persistentDataPath .. "/" .. ApplicationHelper.platformFolder .. "/resources/script2/"
end

function OverseaHostHelper:GetClientV2Code()
  local scriptFolderList
  if BranchMgr.IsJapan() or BranchMgr.IsKorea() then
    scriptFolderList = {
      "login.unity3d"
    }
  elseif BranchMgr.IsTW() then
    scriptFolderList = {
      "login.unity3d",
      "overseas.unity3d"
    }
  elseif BranchMgr.IsSEA() or BranchMgr.IsNA() or BranchMgr.IsEU() then
    scriptFolderList = {
      "util.unity3d",
      "login.unity3d",
      "config_item_daoju.unity3d",
      "oversea.unity3d",
      "diskfilehandler.unity3d",
      "overseas.unity3d",
      "config_resource_ziyuan.unity3d",
      "envchannel.unity3d",
      "net.unity3d",
      "config_pay_zhifu.unity3d",
      "config_guild_gonghui.unity3d",
      "test.unity3d",
      "org.unity3d",
      "unionwallphoto.unity3d",
      "purchase.unity3d",
      "framework.unity3d",
      "mconfig.unity3d",
      "config_adventure_chengjiu_maoxian.unity3d",
      "config_hint_tishizhiyin.unity3d",
      "config_event_shijian.unity3d",
      "protocolstatistics.unity3d",
      "config.unity3d",
      "tablemathextension.unity3d",
      "config_npc_mowu.unity3d",
      "functionsystem.unity3d",
      "gmtool.unity3d",
      "itemswithrolestatuschange.unity3d",
      "personalphoto.unity3d",
      "config_text_wenben.unity3d",
      "config_pvp_jingjisai.unity3d",
      "config_skill_jineng.unity3d",
      "unionlogo.unity3d",
      "config_pet_suicong.unity3d",
      "main.unity3d",
      "config_marry_jiehun.unity3d",
      "config_map_fuben.unity3d",
      "config_property_zhiye_shuxing.unity3d",
      "refactory.unity3d",
      "marryphoto.unity3d",
      "com.unity3d",
      "gamephotoutil.unity3d",
      "scenicspotsphoto.unity3d",
      "config_equip_zhuangbei_kapian.unity3d"
    }
  else
    return 0
  end
  local size = 0
  local path = OverseaHostHelper:getScriptPath()
  for i = 1, #scriptFolderList do
    local filePath = path .. scriptFolderList[i]
    local file = io.open(filePath, "r")
    if file then
      size = size + file:seek("end")
      file:close()
    end
  end
  return size
end

function OverseaHostHelper:ExtractionSlotConfirm(data)
  local costid = data.costid
  local costnum = data.costnum
  local moneyCount = 0
  if costid == GameConfig.MoneyId.Zeny then
    moneyCount = MyselfProxy.Instance:GetROB()
  elseif costid == GameConfig.MoneyId.Lottery then
    moneyCount = MyselfProxy.Instance:GetLottery()
  end
  OverseaHostHelper:GachaUseComfirm(costnum, function()
    if moneyCount < costnum then
      MsgManager.ShowMsgByID(25419, Table_Item[costid].NameZh)
    else
      ServiceNUserProxy.Instance:CallExtractionGridBuyUserCmd()
    end
  end)
end

function OverseaHostHelper:SavePlotConfirm(data)
  local costid = data.costid
  local costnum = data.costnum
  local moneyCount = 0
  if costid == GameConfig.MoneyId.Zeny then
    moneyCount = MyselfProxy.Instance:GetROB()
  elseif costid == GameConfig.MoneyId.Lottery then
    moneyCount = MyselfProxy.Instance:GetLottery()
  end
  OverseaHostHelper:GachaUseComfirm(costnum, function()
    if moneyCount < costnum then
      MsgManager.ShowMsgByID(25419, Table_Item[costid].NameZh)
    else
      ServiceNUserProxy.Instance:CallBuyRecordSlotUserCmd(data.id)
    end
  end)
end

local Manual_UseConfirm_Branch = {JP = 1, KR = 1}

function OverseaHostHelper:UseOverseaConfirm()
  local config = GameConfig.Lottery and GameConfig.Lottery.UseConfirm_Branch or Manual_UseConfirm_Branch
  local branch_name = BranchMgr.GetBranchName()
  return nil ~= config and nil ~= config[branch_name]
end

function OverseaHostHelper:GachaUseComfirm(count, cb, z, ccb)
  local confirm = self:UseOverseaConfirm()
  if confirm then
    local msgData = Table_Sysmsg[43233]
    if not msgData then
      redlog("未配置SysMsg id:43233。 错误分支名：", branch_name)
      return
    end
    local view = {
      view = PanelConfig.NewShopConfirmPanel,
      viewdata = {
        data = {
          title = msgData.Title,
          desc = string.format(msgData.Text, count),
          callback = cb,
          cancelcallback = ccb,
          button = msgData.button,
          buttonF = msgData.buttonF
        }
      }
    }
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, view)
    if z then
      EventManager.Me():PassEvent("XDEChangeZ", {depth = z})
    end
  elseif cb then
    cb()
  end
end

function OverseaHostHelper:FeedXDConfirm(titleVal, descVal, productName, productPrice, callback, cancelcallback)
  local view
  if BranchMgr.IsJapan() then
    local msgData = Table_Sysmsg[43234]
    if msgData then
      view = {
        view = PanelConfig.NewShopConfirmPanel,
        viewdata = {
          data = {
            title = msgData.Title,
            desc = string.format(msgData.Text, productName, productPrice),
            callback = callback,
            cancelcallback = cancelcallback,
            button = msgData.button,
            buttonF = msgData.buttonF
          }
        }
      }
    end
  else
    view = {
      view = PanelConfig.ShopConfirmPanel,
      viewdata = {
        data = {
          title = titleVal,
          desc = descVal,
          callback = callback
        }
      }
    }
  end
  if view then
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, view)
  elseif callback then
    callback()
  end
end

function OverseaHostHelper:hasRole()
  local allRoles = ServiceUserProxy.Instance:GetAllRoleInfos()
  if not allRoles or #allRoles == 0 then
    return false
  end
  for i = 1, #allRoles do
    if allRoles[i].id ~= 0 then
      return true
    end
  end
  return false
end

function OverseaHostHelper:GenUpLoadSignObj(fields)
  helplog("OverseaHostHelper:GenUpLoadSignObj")
  local uaws = false
  local signDataObj = {}
  for i = 1, #fields do
    local d = fields[i]
    helplog(d.name, d.value)
    signDataObj[d.name] = d.value
  end
  if signDataObj["__using-aws"] and signDataObj["__using-aws"] == "true" then
    uaws = true
  end
  local signObj = uaws and OverSeas_TW.AWSSignObj.insObg(signDataObj.acl, signDataObj["Content-Type"], signDataObj.key, signDataObj.success_action_status, signDataObj["x-amz-algorithm"], signDataObj["x-amz-credential"], signDataObj["x-amz-date"], signDataObj.policy, signDataObj.signature) or OverSeas_TW.GoogleStorageSignObj.insObg(signDataObj["content-type"], signDataObj.bucket, signDataObj.acl, signDataObj.key, signDataObj.GoogleAccessId, signDataObj.policy, signDataObj.signature, signDataObj.success_action_status)
  local url
  if BranchMgr.IsJapan() then
    url = uaws and string.format("http://%s.s3.ap-northeast-1.amazonaws.com/", signDataObj.bucket) or GoogleStorageConfig.googleStorageUpLoad
  else
    url = GoogleStorageConfig.googleStorageUpLoad
  end
  helplog("uploadUrl", url)
  return {signObj = signObj, uploadUrl = url}
end

function OverseaHostHelper:GenUpLoadSignObj2(uaws, fields)
  helplog("OverseaHostHelper:GenUpLoadSignObj")
  local signDataObj = {}
  for i = 1, #fields do
    local d = fields[i]
    helplog(d.key, d.value)
    signDataObj[d.key] = d.value
  end
  local signObj = uaws and OverSeas_TW.AWSSignObj.insObg(signDataObj.acl, signDataObj["Content-Type"], signDataObj.key, signDataObj.success_action_status, signDataObj["x-amz-algorithm"], signDataObj["x-amz-credential"], signDataObj["x-amz-date"], signDataObj.policy, signDataObj.signature) or OverSeas_TW.GoogleStorageSignObj.insObg(signDataObj["content-type"], signDataObj.bucket, signDataObj.acl, signDataObj.key, signDataObj.GoogleAccessId, signDataObj.policy, signDataObj.signature, signDataObj.success_action_status)
  local url
  if BranchMgr.IsJapan() then
    url = uaws and string.format("http://%s.s3.ap-northeast-1.amazonaws.com/", signDataObj.bucket) or GoogleStorageConfig.googleStorageUpLoad
  else
    url = GoogleStorageConfig.googleStorageUpLoad
  end
  helplog("uploadUrl", url)
  return {signObj = signObj, uploadUrl = url}
end

function OverseaHostHelper:FixLabelOver(label, overflow, width, height)
  label.overflowMethod = overflow ~= nil and overflow or 0
  if width then
    label.width = width
  end
  if height then
    label.height = height
  end
end

function OverseaHostHelper:FixLabelOverV(label, overflow, width, height)
  label.overflowMethod = overflow
  label.width = width
  label.height = height
end

function OverseaHostHelper:FixLabelOverV1(label, overflow, width)
  label.overflowMethod = overflow
  label.width = width
end

function OverseaHostHelper:ShrinkFixLabelOver(label, width)
  label.overflowMethod = 0
  label.width = width
end

function OverseaHostHelper:FixAnchor(fromAnchor, target, relative, absolute)
  fromAnchor.target = target
  fromAnchor.relative = relative
  fromAnchor.absolute = absolute
end

function OverseaHostHelper:OpenWebView(url, needInternal)
  if needInternal then
    ApplicationInfo.OpenUrl(url)
  else
    Application.OpenURL(url)
  end
end

function OverseaHostHelper:AFTrack(evntName)
  if not BranchMgr.IsJapan() then
    return
  end
  helplog("OverseaHostHelper:AFTrack", evntName)
  OverSeas_TW.OverSeasManager.GetInstance():TXTrackEvnt(evntName)
end

function OverseaHostHelper:GetCurZoneInfo()
  local zoneid = MyselfProxy.Instance:GetZoneId()
  helplog("OverseaHostHelper:GetCurZoneInfo origin", zoneid)
  if 9999 < zoneid then
    local zoneStr = tostring(zoneid)
    zoneid = tonumber(string.sub(zoneStr, string.len(zoneStr) - 3, string.len(zoneStr)))
  end
  helplog("OverseaHostHelper:GetCurZoneInfo", zoneid)
  return self:GetZoneInfo(zoneid)
end

function OverseaHostHelper:GetZoneInfo(num)
  if num and 0 < num then
    if 9000 <= num then
      return {
        name = ZhString.ChangeZoneProxy_PvpLine,
        id = ""
      }
    end
    local curServerId = ChangeZoneProxy.Instance:GetMyselfServerId()
    local serverInfo = ChangeZoneProxy.Instance.serverInfos[curServerId]
    if serverInfo then
      return {
        name = serverInfo:GetDisplayZoneName(num),
        id = ""
      }
    end
  end
end

function OverseaHostHelper:RefreshPriceInfo()
  if not BranchMgr.IsSEA() and not BranchMgr.IsNA() and not BranchMgr.IsEU() and not BranchMgr.IsVN() and not BranchMgr.IsNO() and not BranchMgr.IsNOTW() and not BranchMgr.IsNOEN() then
    return
  end
  local pIds = {}
  for _, v in pairs(Table_Deposit) do
    local productConf = v
    if productConf.ProductID ~= "" then
      table.insert(pIds, productConf.ProductID)
    end
  end
  local pIdStr = ""
  for i = 1, #pIds do
    local pId = pIds[i]
    pIdStr = pIdStr .. pId
    if i < #pIds then
      pIdStr = pIdStr .. ","
    end
  end
  Debug.Log(pIdStr)
  OverSeas_TW.OverSeasManager.GetInstance():QueryProduct(pIdStr, function(msg)
    Debug.Log("QueryProduct result!")
    Debug.Log(msg)
    local infos = string.split(msg, "#")
    for _, v in pairs(infos) do
      local pInfo = string.split(v, "|")
      local pId = pInfo[2]
      local priceStr = pInfo[3]
      for _, v in pairs(Table_Deposit) do
        local productConf = v
        if productConf.ProductID == pId then
          productConf.priceStr = priceStr
          break
        end
      end
    end
  end)
end

function OverseaHostHelper:FilterLangStr(origin)
  if BranchMgr.IsChina() then
    return origin
  end
  if AppBundleConfig.GetSDKLang() == "th" then
    origin = string.gsub(origin, "×", "x")
    origin = string.gsub(origin, "{uiicon=tips_icon_01} \n", "")
    origin = string.gsub(origin, "{uiicon=tips_icon_01} \r\n", "")
  end
  if AppBundleConfig.GetSDKLang() == "en" or AppBundleConfig.GetSDKLang() == "th" or AppBundleConfig.GetSDKLang() == "pt" then
    origin = string.gsub(origin, "＋", "+")
    origin = origin:gsub("ได้รับความเสียหายจากธาตุทั้งหมด", "ได้รับความเสียหายจากธาตุทั้งหมด ")
    origin = origin:gsub("สร้างความเสียหายต่อมอนสเตอร์ทั้งหมด", "สร้างความเสียหายต่อมอนสเตอร์ทั้งหมด ")
    origin = origin:gsub("ทำให้เกิดความเสียหายต่อเป้าหมายและเป้", "ทำให้เกิดความเสียหายต่อเป้าหมายและเป้ ")
  end
  if AppBundleConfig.GetSDKLang() == "id" and origin:find("每个大类下不同道具抽取概率略有不同") == nil then
    origin = string.gsub(origin, "＋", "+")
    origin, tmp = string.gsub(origin, "%s\n", "\n")
  end
  return origin
end

function OverseaHostHelper:FullWidthToHalfWidth(str)
  local ret = OverSea.LangManager.Instance():GetLangByKey(str)
  ret = ret:gsub("＋", "+")
  ret = ret:gsub("，", ",")
  ret = ret:gsub("：", ":")
  return ret
end

function OverseaHostHelper:SpecialProcess(str)
  if AppBundleConfig.GetSDKLang() == "th" then
    str = str:gsub("Christmas Song 30%%  : Atk %+3%%", "Christmas Song 30%%: Atk +3%%")
  end
  if AppBundleConfig.GetSDKLang() == "vi" then
    str = OverseaHostHelper:FullWidthToHalfWidth(str)
    str = str:gsub("Phổ công có 30%% xác suất diễn tấu Ca khúc Noel:Atk%+3%%,Equip.ASPD%+3%%,liên tục 10s", "Phổ công có 30%% xác suất   diễn tấu Ca khúc Noel: Atk+3%%, Equip.ASPD+3%%, liên tục 10s")
  end
  if AppBundleConfig.GetSDKLang() == "id" then
    str = OverseaHostHelper:FullWidthToHalfWidth(str)
  end
  return str
end

function OverseaHostHelper:IsKorean()
  return OverSea.LangManager.Instance().CurSysLang == "Korean"
end

function OverseaHostHelper:IsChinese()
  return OverSea.LangManager.Instance().CurSysLang == "ChineseSimplified"
end

function OverseaHostHelper:IsPortuguese()
  return OverSea.LangManager.Instance().CurSysLang == "Portuguese"
end

function OverseaHostHelper:IsEng()
  return OverSea.LangManager.Instance().CurSysLang == "English"
end

function OverseaHostHelper:IsVietnamese()
  return OverSea.LangManager.Instance().CurSysLang == "Vietnamese"
end

function OverseaHostHelper:IsIndonesian()
  return OverSea.LangManager.Instance().CurSysLang == "Indonesian"
end

function OverseaHostHelper:AddClickAni(go)
  if not go or go:GetComponent(UIButtonScale) then
    return
  end
  local ubc = go:AddComponent(UIButtonScale)
  ubc.hover = LuaGeometry.GetTempVector3(1, 1, 1)
  ubc.pressed = LuaGeometry.GetTempVector3(0.95, 0.95, 0.95)
  ubc.duration = 0.15
end

function OverseaHostHelper:TXWYTrackEvent(evt)
  helplog("OverseaHostHelper:TXWYTrackEvent:" .. evt)
  pcall(function()
    OverSeas_TW.OverSeasManager.GetInstance():TXWYTrackEvent(evt)
  end)
end

if BranchMgr.IsSEA() or BranchMgr.IsNA() or BranchMgr.IsEU() then
  OverseaHostHelper.AFAchievementObj = {
    AFA1204008 = "pet1",
    AFA1204009 = "pet5",
    AFA1204010 = "pet10",
    AFA1301001 = "map1",
    AFA1301004 = "map2",
    AFA1301007 = "map3",
    AFA1301015 = "map4",
    AFA1301018 = "map5",
    AFA1603081 = "month4",
    AFA1603084 = "zeny6",
    AFA1603085 = "zeny50"
  }
else
  OverseaHostHelper.AFAchievementObj = {
    AFA1201001 = "フレンドを作った",
    AFA1202043 = "初回ギルド加入（作成も含む）",
    AFA1306001 = "冒険者ランクF",
    AFA1306002 = "冒険者ランクE",
    AFA1306003 = "冒険者ランクD",
    AFA1306004 = "冒険者ランクC",
    AFA1204008 = "最初のペットを入手した",
    AFA1205011 = "最初の料理を作成した",
    AFA1603084 = "課金"
  }
end

function OverseaHostHelper:AFAchievementTrack(achievementId)
  local evntName = OverseaHostHelper.AFAchievementObj["AFA" .. tostring(achievementId)]
  helplog("OverseaHostHelper:AFAchievementTrack", achievementId, evntName)
  if evntName ~= nil then
    helplog("exist begin track")
    OverseaHostHelper:TXWYTrackEvent(evntName)
  end
end

function OverseaHostHelper:AFRenewTrack()
  local key = "xde_packageVersion"
  local packageVersion = PlayerPrefs.GetInt(key)
  local currentVersion = CompatibilityVersion.version
  helplog("OverseaHostHelper:AFRenewTrack", packageVersion, currentVersion)
  if packageVersion < currentVersion then
    PlayerPrefs.SetInt(key, currentVersion)
    OverseaHostHelper:AFTrack("アップデート")
  else
    helplog("same not need renew")
  end
end

function OverseaHostHelper:ShowGiftProbability(itemId)
  local url = "https://jp-cdn.ro.com/item/manual.html#id=" .. itemId
  helplog("OverseaHostHelper:ShowGiftProbability", url)
  OverseaHostHelper:OpenWebView(url, false)
end

function OverseaHostHelper:TryShowQualitySelect()
end

function OverseaHostHelper:GetWrapLeftStringTextSharp(uiLabel, text)
  uiLabel.text = text
  local textlen = OverSeas_TW.OverSeasManager.GetInstance():GetStringLength(text)
  local bWarp, finalStr, leftStr
  bWarp, finalStr = uiLabel:Wrap(text, finalStr, uiLabel.height)
  finalStr = string.gsub(finalStr, "\n", "")
  if not bWarp then
    local finallen = OverSeas_TW.OverSeasManager.GetInstance():GetStringLength(finalStr)
    uiLabel.text = OverSeas_TW.OverSeasManager.GetInstance():SubString(text, 0, finallen)
    local nextlen = textlen - finallen
    if 0 < nextlen then
      leftStr = OverSeas_TW.OverSeasManager.GetInstance():SubString(text, finallen, nextlen)
    else
      leftStr = ""
    end
  else
    leftStr = nil
  end
  return bWarp, leftStr
end

function OverseaHostHelper:GetWrapLeftStringTextLua(uiLabel, text)
  uiLabel.text = text
  local bWarp, finalStr, leftStr
  bWarp, finalStr = uiLabel:Wrap(text, finalStr, uiLabel.height)
  finalStr = string.gsub(finalStr, "\n", "")
  if not bWarp then
    local finallen = StringUtil.getTextLen(finalStr)
    local lastSpaceIndex = StringUtil.LastIndexOf(finalStr, " ") or finallen
    uiLabel.text = StringUtil.getTextByIndex(text, 1, lastSpaceIndex)
    local textlen = StringUtil.getTextLen(text)
    if finallen < textlen then
      leftStr = StringUtil.getTextByIndex(text, lastSpaceIndex + 1, textlen)
    else
      leftStr = ""
    end
  else
    leftStr = nil
  end
  return bWarp, leftStr
end

function OverseaHostHelper:GetStringLength(str)
  return OverSeas_TW.OverSeasManager.GetInstance():GetStringLength(str)
end

function OverseaHostHelper.AppFlyOpenDeepLink()
  helplog("OverseaHostHelper:AppFlyOpenDeepLink")
end

OverseaHostHelper.Share_URL = "https://ragnarokm.gungho.jp/"
if BranchMgr.IsTW() then
  OverseaHostHelper.Share_URL = ""
end
OverseaHostHelper.TWITTER_MSG = "#ラグマス"
OverseaHostHelper.SAVE_FAILED = "許可されていないため、保存しませんでした"

function OverseaHostHelper.PorFormatMilComma(int_number)
  if OverseaHostHelper:IsPortuguese() then
    if int_number then
      local isMinus = int_number < 0
      if isMinus then
        int_number = int_number * -1
      end
      local str = tostring(int_number)
      local tab = {}
      local count = 0
      for i = #str, 1, -1 do
        local char = string.sub(str, i, i)
        table.insert(tab, char)
        count = count + 1
        if count == 3 and 1 < i then
          table.insert(tab, ".")
          count = 0
        end
      end
      local result = ""
      for j = #tab, 1, -1 do
        local char = tab[j]
        result = result .. char
      end
      if isMinus then
        result = "-" .. result
      end
      return result
    end
    return nil
  end
  return int_number
end

OverseaHostHelper.serverGMToffset = -21600

function OverseaHostHelper:diffGMT()
  local t = os.time()
  local ut = os.date("!*t", t)
  local lt = os.date("*t", t)
  local tzdt = (lt.hour - ut.hour) * 3600 + (lt.min - ut.min) * 60
  return tzdt - OverseaHostHelper.serverGMToffset
end

if BranchMgr.IsNA() or BranchMgr.IsEU() then
  OverseaHostHelper.isGuest = 0
end

function OverseaHostHelper:GuestExchangeForbid()
  if OverseaHostHelper.isGuest == 1 then
    MsgManager.FloatMsg("", ZhString.GuestExchangeForbid)
  end
  return OverseaHostHelper.isGuest
end

function OverseaHostHelper:guestSecurity(callback, callbackParam)
  if OverseaHostHelper.isGuest == 1 then
    UIUtil.PopUpConfirmYesNoView(ZhString.GuestSecurityTitle, ZhString.GuestSecurityContent, function()
      Game.Me():BackToLogo()
    end, function()
    end, nil, ZhString.GuestSecurityConfirm, ZhString.GuestSecurityCancel)
  elseif callback then
    callback(callbackParam)
  end
end

function OverseaHostHelper:getScriptPath()
  return ApplicationHelper.persistentDataPath .. "/" .. ApplicationHelper.platformFolder .. "/resources/script2/"
end

function OverseaHostHelper:IsEng()
  return OverSea.LangManager.Instance().CurSysLang == "English"
end

function OverseaHostHelper:DateValid(StartDate, FinishDate)
  if OverseaHostHelper:StringIsNullOrEmpty(StartDate) or OverseaHostHelper:StringIsNullOrEmpty(FinishDate) then
    return false
  end
  local serverTime = ServerTime.CurServerTime() / 1000
  helplog(serverTime)
  helplog(OverseaHostHelper:GetSelfCustomDate(StartDate))
  helplog(OverseaHostHelper:GetSelfCustomDate(FinishDate))
  if serverTime >= OverseaHostHelper:GetSelfCustomDate(StartDate) and serverTime <= OverseaHostHelper:GetSelfCustomDate(FinishDate) then
    return true
  end
  return false
end

function OverseaHostHelper:StringIsNullOrEmpty(text)
  if text == nil or text == "" then
    return true
  else
    return false
  end
end

function OverseaHostHelper:GetSelfCustomDate(validDate)
  local p = "(%d+)-(%d+)-(%d+) (%d+):(%d+):(%d+)"
  local year, month, day, hour, min, sec = validDate:match(p)
  if day == nil then
    helplog("策划瞎写")
    return
  end
  local startDate = os.time({
    day = day,
    month = month,
    year = year,
    hour = hour,
    min = min,
    sec = sec
  })
  return startDate
end

function OverseaHostHelper:JumpToAppleMusic()
  Application.OpenURL("https://music.apple.com/deeplink?app=music&p=subscribe-individual&at=1000lwDU")
end

TransformExtenstion = {}

function TransformExtenstion:AddLocalPositionX(transform, offsetX)
  local exPos = transform.localPosition
  local v = Vector3(exPos.x + offsetX, exPos.y, exPos.z)
  transform.localPosition = v
end

function TransformExtenstion:SetLocalPositionX(transform, x)
  local exPos = transform.localPosition
  local v = Vector3(x, exPos.y, exPos.z)
  transform.localPosition = v
end
