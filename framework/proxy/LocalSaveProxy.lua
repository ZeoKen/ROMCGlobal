LocalSaveProxy = class("LocalSaveProxy", pm.Proxy)
LocalSaveProxy.Instance = nil
LocalSaveProxy.NAME = "LocalSaveProxy"
LocalSaveProxy.SAVE_KEY = {
  DontShowAgain = "DontShowAgain",
  ExchangeSearchHistory = "ExchangeSearchHistory",
  PhotoFilterSetting = "PhotographPanelFilters_%d",
  LastTraceQuestId = "LastTraceQuestId",
  Setting = "Setting",
  MainViewChatTweenLevel = "MainViewChatTweenLevel",
  MainViewAutoAimMonster = "MainViewAutoAimMonster",
  MainViewBooth = "MainViewBooth",
  BossView_ShowMini = "BossView_ShowMini",
  SkipAnimation = "SkipAnimation",
  FashionPreviewTip_ShowOtherPart = "FashionPreviewTip_ShowOtherPart",
  FoodBuffOverrideNoticeShow = "FoodBuffOverrideNoticeShow",
  WindowsResolution = "WindowsResolution",
  AstrolabeView_EvoFliter = "AstrolabeView_EvoFliter",
  AstrolabeView_PathFliter = "AstrolabeView_PathFliter",
  SkipStartGameCG = "SkipStartGameCG",
  LockCamera = "LockCamera",
  HideCameraCtl = "HideCameraCtl",
  FreeCameraRotationX = "FreeCameraRotationX",
  FreeCameraRotationY = "FreeCameraRotationY",
  CameraZoom = "CameraZoom",
  ChangedAppIcon = "ChangedAppIcon",
  PeddlerDailyDot = "PeddlerDailyDot",
  CheckFrameRateTime = "CheckFrameRateTime",
  CheckFrameRateClose = "CheckFrameRateClose",
  MainViewCameraSettingHide = "MainViewCameraSettingHide",
  MainViewVoiceSettingHide = "MainViewVoiceSettingHide",
  ExpRaidRewardChoose = "ExpRaidRewardChoose",
  MainViewCameraSettingHide = "MainViewCameraSettingHide",
  MainViewVoiceSettingHide = "MainViewVoiceSettingHide",
  RoguelikeWeekMode = "RoguelikeWeekMode",
  ShowLotteryDollSkip = "ShowLotteryDollSkip",
  RaidPuzzleEntranceFloor = "RaidPuzzleEntranceFloor",
  MiniROCastDice = "MiniROCastDice",
  WorldQuestTraceTimeStamp = "WorldQuestTraceTimeStamp",
  WorldBossQuestTrace = "WorldBossQuestTrace",
  ActivityQuestTraceNewTag = "ActivityQuestTraceNewTag",
  GVG_FrameChecked = "GVG_FrameChecked",
  QueryPriceHistory = "QueryPriceHistory",
  AnnouncementEndTime = "AnnouncementEndTime",
  NoviceShopOpened = "NoviceShopOpened",
  BannerDontShowAgain = "BannerDontShowAgain",
  AssistantInvite_RefuseCount = "AssistantInvite_RefuseCount",
  AssistantInvite_RefuseTime = "AssistantInvite_RefuseTime",
  RechargeHero_New = "RechargeHero_New",
  MountFashion = "MountFashion",
  GLandChallenge_LastExcellentNum = "LastExcellentNum"
}

function LocalSaveProxy:ctor(proxyName, data)
  self.proxyName = proxyName or LocalSaveProxy.NAME
  if LocalSaveProxy.Instance == nil then
    LocalSaveProxy.Instance = self
  end
end

function LocalSaveProxy:InitDontShowAgain()
  local serverTime = ServerTime.CurServerTime()
  if self.dontShowAgains == nil and FunctionPlayerPrefs.Me():IsInited() and serverTime ~= nil then
    self.dontShowAgains = {}
    self.dontShowAgainsOpt = {}
    local dirty
    local str = FunctionPlayerPrefs.Me():GetString(LocalSaveProxy.SAVE_KEY.DontShowAgain, "")
    local t = loadstring("return {" .. str .. "}")()
    local id, timeStamp
    local ids = ""
    for i = 1, #t do
      id = t[i]
      if id ~= nil and id ~= "" then
        str = FunctionPlayerPrefs.Me():GetString(LocalSaveProxy.SAVE_KEY.DontShowAgain .. "_" .. id, "")
        local rets = string.split(str, "_")
        timeStamp = tonumber(rets[1])
        local opt = rets[2]
        if timeStamp and serverTime and (timeStamp == 0 or serverTime < timeStamp) then
          self.dontShowAgains[id] = timeStamp
          self.dontShowAgainsOpt[id] = opt and tonumber(opt)
          ids = ids ~= "" and ids .. "," .. id or id
        else
          dirty = true
          helplog("删除", id, timeStamp)
          FunctionPlayerPrefs.Me():DeleteKey(LocalSaveProxy.SAVE_KEY.DontShowAgain .. "_" .. id)
        end
      end
    end
    self.dontShowAgains.ids = ids
    if dirty then
      FunctionPlayerPrefs.Me():SetString(LocalSaveProxy.SAVE_KEY.DontShowAgain, self.dontShowAgains.ids)
      FunctionPlayerPrefs.Me():Save()
    end
  end
end

function LocalSaveProxy:AddDontShowAgain(id, days, opt)
  local find = self:GetDontShowAgain(id)
  if find == nil then
    local timeStamp = days ~= 0 and ServerTime.CurServerTime() + 86400000 * days or 0
    local value = timeStamp
    if opt then
      value = value .. "_" .. opt
    end
    FunctionPlayerPrefs.Me():AppendString(LocalSaveProxy.SAVE_KEY.DontShowAgain, id, ",")
    FunctionPlayerPrefs.Me():SetString(LocalSaveProxy.SAVE_KEY.DontShowAgain .. "_" .. id, value)
    FunctionPlayerPrefs.Me():Save()
    self.dontShowAgains[id] = timeStamp
    self.dontShowAgainsOpt[id] = opt
  end
end

function LocalSaveProxy:RemoveDontShowAgain(id)
  local find = self:GetDontShowAgain(id)
  if find then
    FunctionPlayerPrefs.Me():DeleteKey(LocalSaveProxy.SAVE_KEY.DontShowAgain .. "_" .. id)
    self.dontShowAgains[id] = nil
    self.dontShowAgainsOpt[id] = nil
  end
end

function LocalSaveProxy:GetDontShowAgain(id)
  return self.dontShowAgains and self.dontShowAgains[id] or nil
end

function LocalSaveProxy:GetDontShowAgainOpt(id)
  return self.dontShowAgainsOpt[id]
end

function LocalSaveProxy:InitExchangeSearchHistory()
  if FunctionPlayerPrefs.Me():IsInited() then
    self.exchangeSearchHistory = {}
    local str = FunctionPlayerPrefs.Me():GetString(LocalSaveProxy.SAVE_KEY.ExchangeSearchHistory, "")
    local history = string.split(str, "_")
    for i = 1, #history do
      if history[i] ~= "" then
        table.insert(self.exchangeSearchHistory, tonumber(history[i]))
      end
    end
  end
end

function LocalSaveProxy:AddExchangeSearchHistory(itemId)
  if not self:IsInExchangeSearchHistory(itemId) then
    if #self.exchangeSearchHistory >= GameConfig.Exchange.MaxSearchLog then
      local offset = #self.exchangeSearchHistory - GameConfig.Exchange.MaxSearchLog + 1
      for i = offset, 1, -1 do
        table.remove(self.exchangeSearchHistory, i)
      end
    end
    table.insert(self.exchangeSearchHistory, itemId)
    local str = tostring(self.exchangeSearchHistory[1])
    for i = 2, #self.exchangeSearchHistory do
      str = str .. "_" .. tostring(self.exchangeSearchHistory[i])
    end
    FunctionPlayerPrefs.Me():SetString(LocalSaveProxy.SAVE_KEY.ExchangeSearchHistory, str)
    FunctionPlayerPrefs.Me():Save()
  end
end

function LocalSaveProxy:IsInExchangeSearchHistory(itemId)
  for i = 1, #self.exchangeSearchHistory do
    if self.exchangeSearchHistory[i] == itemId then
      return true
    end
  end
  return false
end

function LocalSaveProxy:GetExchangeSearchHistory()
  if self.exchangeSearchHistory == nil then
    self:InitExchangeSearchHistory()
  end
  return self.exchangeSearchHistory
end

function LocalSaveProxy:savePhotoFilterSetting(list)
  local key = LocalSaveProxy.SAVE_KEY.PhotoFilterSetting
  for j = 1, #list do
    local single = list[j]
    if single.id ~= GameConfig.PhotographPanel.HideUI_ID then
      FunctionPlayerPrefs.Me():SetBool(string.format(key, single.id), single.isSelect)
    end
  end
  FunctionPlayerPrefs.Me():Save()
end

function LocalSaveProxy:getPhotoFilterSetting(cells)
  local key = LocalSaveProxy.SAVE_KEY.PhotoFilterSetting
  local list = {}
  for j = 1, #cells do
    local id = cells[j].data.id
    local bFilter = false
    if id ~= GameConfig.PhotographPanel.HideUI_ID then
      bFilter = FunctionPlayerPrefs.Me():GetBool(string.format(key, id), true)
    end
    list[id] = bFilter
  end
  return list
end

function LocalSaveProxy:getLastTraceQuestId()
  local key = LocalSaveProxy.SAVE_KEY.LastTraceQuestId
  return FunctionPlayerPrefs.Me():GetInt(key, -1)
end

function LocalSaveProxy:setLastTraceQuestId(value)
  if value then
    local key = LocalSaveProxy.SAVE_KEY.LastTraceQuestId
    FunctionPlayerPrefs.Me():SetInt(key, value)
  end
end

function LocalSaveProxy:SaveSetting(setting)
  FunctionPlayerPrefs.Me():DeleteKey(LocalSaveProxy.SAVE_KEY.Setting, false)
  for k, v in pairs(setting) do
    local str
    if type(v) == "table" then
      str = k .. "={"
      if #v == 0 then
        str = str .. "}"
      end
      for i = 1, #v do
        if i ~= #v then
          str = str .. v[i] .. ","
        else
          str = str .. v[i] .. "}"
        end
      end
    else
      str = k .. "=" .. tostring(v)
    end
    FunctionPlayerPrefs.Me():AppendString(LocalSaveProxy.SAVE_KEY.Setting, str, ",", false)
  end
  FunctionPlayerPrefs.Me():Save()
end

function LocalSaveProxy:LoadSetting()
  local str = FunctionPlayerPrefs.Me():GetString(LocalSaveProxy.SAVE_KEY.Setting, "", false)
  local t = loadstring("return {" .. str .. "}")()
  return t
end

function LocalSaveProxy:ClearSetting()
  FunctionPlayerPrefs.Me():DeleteKey(LocalSaveProxy.SAVE_KEY.Setting, false)
  FunctionPlayerPrefs.Me():Save()
end

function LocalSaveProxy:GetMainViewChatTweenLevel()
  local key = LocalSaveProxy.SAVE_KEY.MainViewChatTweenLevel
  return FunctionPlayerPrefs.Me():GetInt(key, 3)
end

function LocalSaveProxy:SetMainViewChatTweenLevel(value)
  if value then
    local key = LocalSaveProxy.SAVE_KEY.MainViewChatTweenLevel
    FunctionPlayerPrefs.Me():SetInt(key, value)
    FunctionPlayerPrefs.Me():Save()
  end
end

function LocalSaveProxy:GetMainViewAutoAimMonster()
  local key = LocalSaveProxy.SAVE_KEY.MainViewAutoAimMonster
  return FunctionPlayerPrefs.Me():GetString(key, "")
end

function LocalSaveProxy:SetMainViewAutoAimMonster(value)
  if value then
    local key = LocalSaveProxy.SAVE_KEY.MainViewAutoAimMonster
    FunctionPlayerPrefs.Me():SetString(key, value)
    FunctionPlayerPrefs.Me():Save()
  end
end

function LocalSaveProxy:GetMainViewBooth()
  local key = LocalSaveProxy.SAVE_KEY.MainViewBooth
  return FunctionPlayerPrefs.Me():GetString(key, "")
end

function LocalSaveProxy:SetMainViewBooth(value)
  if value then
    local sb = LuaStringBuilder.CreateAsTable()
    sb:Append(value)
    sb:Append("_")
    sb:Append(ServerTime.CurServerTime())
    FunctionPlayerPrefs.Me():SetString(LocalSaveProxy.SAVE_KEY.MainViewBooth, sb:ToString())
    FunctionPlayerPrefs.Me():Save()
    sb:Destroy()
  end
end

function LocalSaveProxy:GetMiniRODiceAnim()
  local key = LocalSaveProxy.SAVE_KEY.MiniROCastDice
  return FunctionPlayerPrefs.Me():GetString(key, "")
end

function LocalSaveProxy:SetMiniRODiceAnim(value)
  if value then
    local sb = LuaStringBuilder.CreateAsTable()
    sb:Append(value)
    sb:Append("_")
    sb:Append(ServerTime.CurServerTime())
    FunctionPlayerPrefs.Me():SetString(LocalSaveProxy.SAVE_KEY.MiniROCastDice, sb:ToString())
    FunctionPlayerPrefs.Me():Save()
    sb:Destroy()
  end
end

function LocalSaveProxy:SetBossView_ShowMini(value)
  FunctionPlayerPrefs.Me():SetBool(LocalSaveProxy.SAVE_KEY.BossView_ShowMini, value == true)
  FunctionPlayerPrefs.Me():Save()
end

function LocalSaveProxy:GetBossView_ShowMini()
  return FunctionPlayerPrefs.Me():GetBool(LocalSaveProxy.SAVE_KEY.BossView_ShowMini, true)
end

function LocalSaveProxy:SetSkipAnimation(type, value)
  if type then
    local key = LocalSaveProxy.SAVE_KEY.SkipAnimation .. "_" .. type
    FunctionPlayerPrefs.Me():SetBool(key, value)
    FunctionPlayerPrefs.Me():Save()
  end
end

function LocalSaveProxy:GetSkipAnimation(type)
  return FunctionPlayerPrefs.Me():GetBool(LocalSaveProxy.SAVE_KEY.SkipAnimation .. "_" .. type, false)
end

function LocalSaveProxy:SetFashionPreviewTip_ShowOtherPart(value)
  FunctionPlayerPrefs.Me():SetBool(LocalSaveProxy.SAVE_KEY.FashionPreviewTip_ShowOtherPart, value == true)
  FunctionPlayerPrefs.Me():Save()
end

function LocalSaveProxy:GetFashionPreviewTip_ShowOtherPart(value)
  return FunctionPlayerPrefs.Me():GetBool(LocalSaveProxy.SAVE_KEY.FashionPreviewTip_ShowOtherPart, true)
end

function LocalSaveProxy:SetFoodBuffOverrideNoticeShow(value)
  FunctionPlayerPrefs.Me():SetBool(LocalSaveProxy.SAVE_KEY.FoodBuffOverrideNoticeShow, value == true)
  FunctionPlayerPrefs.Me():Save()
end

function LocalSaveProxy:GetFoodBuffOverrideNoticeShow(value)
  return FunctionPlayerPrefs.Me():GetBool(LocalSaveProxy.SAVE_KEY.FoodBuffOverrideNoticeShow, true)
end

function LocalSaveProxy:SetWindowsResolution(index)
  PlayerPrefs.SetInt(LocalSaveProxy.SAVE_KEY.WindowsResolution, index)
end

function LocalSaveProxy:GetWindowsResolution()
  return PlayerPrefs.GetInt(LocalSaveProxy.SAVE_KEY.WindowsResolution, 1) or 1
end

function LocalSaveProxy:GetAstrolabeView_EvoFliter()
  return FunctionPlayerPrefs.Me():GetInt(LocalSaveProxy.SAVE_KEY.AstrolabeView_EvoFliter, 2)
end

function LocalSaveProxy:SetAstrolabeView_EvoFliter(value)
  FunctionPlayerPrefs.Me():SetInt(LocalSaveProxy.SAVE_KEY.AstrolabeView_EvoFliter, value)
end

function LocalSaveProxy:GetAstrolabeView_PathFliter()
  return FunctionPlayerPrefs.Me():GetInt(LocalSaveProxy.SAVE_KEY.AstrolabeView_PathFliter, 1)
end

function LocalSaveProxy:SetAstrolabeView_PathFliter(value)
  FunctionPlayerPrefs.Me():SetInt(LocalSaveProxy.SAVE_KEY.AstrolabeView_PathFliter, value)
end

function LocalSaveProxy:SetFreeCameraRotation(x, y)
  if not FunctionPlayerPrefs.Me():IsInited() then
    return
  end
  FunctionPlayerPrefs.Me():SetFloat(LocalSaveProxy.SAVE_KEY.FreeCameraRotationX, x)
  FunctionPlayerPrefs.Me():SetFloat(LocalSaveProxy.SAVE_KEY.FreeCameraRotationY, y)
end

function LocalSaveProxy:GetFreeCameraRotation()
  return FunctionPlayerPrefs.Me():GetFloat(LocalSaveProxy.SAVE_KEY.FreeCameraRotationX, 0), FunctionPlayerPrefs.Me():GetFloat(LocalSaveProxy.SAVE_KEY.FreeCameraRotationY, 0)
end

function LocalSaveProxy:SetCameraZoom(value)
  if not value then
    return
  end
  if not FunctionPlayerPrefs.Me():IsInited() then
    return
  end
  local curCameraMode = FunctionCameraEffect.Me():GetCurCameraMode()
  FunctionPlayerPrefs.Me():SetFloat(LocalSaveProxy.SAVE_KEY.CameraZoom .. curCameraMode, value)
  FunctionPlayerPrefs.Me():SetFloat(LocalSaveProxy.SAVE_KEY.CameraZoom, value)
end

function LocalSaveProxy:GetCameraZoom()
  local curCameraMode = FunctionCameraEffect.Me():GetCurCameraMode()
  local value = FunctionPlayerPrefs.Me():GetFloat(LocalSaveProxy.SAVE_KEY.CameraZoom .. curCameraMode, 0)
  if value == 0 then
    FunctionPlayerPrefs.Me():GetFloat(LocalSaveProxy.SAVE_KEY.CameraZoom, 0)
  end
  if value ~= 0 then
    return value
  end
end

function LocalSaveProxy:GetPeddlerDailyDot()
  local str = FunctionPlayerPrefs.Me():GetString(LocalSaveProxy.SAVE_KEY.PeddlerDailyDot, "")
  return str
end

function LocalSaveProxy:SetPeddlerDailyDot()
  local curTime = ServerTime.CurServerTime() / 1000
  local nowTimeString = os.date("%Y-%m-%d %H:%M:%S", curTime)
  local p = "(%d+)-(%d+)-(%d+) (%d+):(%d+):(%d+)"
  local year, month, day, hour, min, sec = nowTimeString:match(p)
  local checkDate = os.time({
    day = day,
    month = month,
    year = year,
    hour = 5,
    min = 0,
    sec = 0
  })
  if curTime < checkDate then
    checkDate = checkDate - 86400
  end
  FunctionPlayerPrefs.Me():SetString(LocalSaveProxy.SAVE_KEY.PeddlerDailyDot, tostring(checkDate))
end

function LocalSaveProxy:CheckPeddlerDailyDot()
  local str = self:GetPeddlerDailyDot()
  if str and string.len(str) > 0 then
    local checkDate = tonumber(str)
    local delta = ServerTime.CurServerTime() / 1000 - checkDate
    return 0 <= delta and delta < 86400
  end
end

function LocalSaveProxy:IsCheckFrameRateOpen()
  return FunctionPlayerPrefs.Me():GetInt(LocalSaveProxy.SAVE_KEY.CheckFrameRateClose, 0) == 0
end

function LocalSaveProxy:SetCheckFrameRateOpenClose()
  FunctionPlayerPrefs.Me():SetInt(LocalSaveProxy.SAVE_KEY.CheckFrameRateClose, 1)
end

function LocalSaveProxy:GetCheckFrameRateTime()
  return FunctionPlayerPrefs.Me():GetInt(LocalSaveProxy.SAVE_KEY.CheckFrameRateTime, 0)
end

function LocalSaveProxy:SetCheckFrameRateTime(value)
  FunctionPlayerPrefs.Me():SetInt(LocalSaveProxy.SAVE_KEY.CheckFrameRateTime, value)
end

function LocalSaveProxy:GetShowLotteryDollSkip()
  local val = FunctionPlayerPrefs.Me():GetInt(LocalSaveProxy.SAVE_KEY.ShowLotteryDollSkip, 0)
  return 0 < val
end

function LocalSaveProxy:SetShowLotteryDollSkip(value)
  FunctionPlayerPrefs.Me():SetInt(LocalSaveProxy.SAVE_KEY.ShowLotteryDollSkip, value)
end

function LocalSaveProxy:InitWorldBossSaveList()
  if not FunctionPlayerPrefs.Me():IsInited() then
    return
  end
  local serverTime = ServerTime.CurServerTime() and ServerTime.CurServerTime() / 1000 or nil
  if not serverTime then
    return
  end
  self.worldBossQuestList = {}
  local str = FunctionPlayerPrefs.Me():GetString(LocalSaveProxy.SAVE_KEY.WorldBossQuestTrace, "")
  local ids = loadstring("return {" .. str .. "}")()
  for i = 1, #ids do
    local questId = ids[i]
    if questId and questId ~= "" then
      local traceStatus = FunctionPlayerPrefs.Me():GetInt(LocalSaveProxy.SAVE_KEY.WorldBossQuestTrace .. "_" .. questId, 0)
      if traceStatus ~= 0 then
        self.worldBossQuestList[questId] = traceStatus
      else
        FunctionPlayerPrefs.Me():DeleteKey(LocalSaveProxy.SAVE_KEY.WorldBossQuestTrace .. "_" .. questId)
      end
    end
  end
end

function LocalSaveProxy:AddWorldBossQuestTrace(questid, status)
  local savedStatus = self:GetWorldBossQuestTrace(questid)
  if savedStatus == nil then
    FunctionPlayerPrefs.Me():AppendString(LocalSaveProxy.SAVE_KEY.WorldBossQuestTrace, questid, ",")
  end
  FunctionPlayerPrefs.Me():SetInt(LocalSaveProxy.SAVE_KEY.WorldBossQuestTrace .. "_" .. questid, status)
  FunctionPlayerPrefs.Me():Save()
  if not self.worldBossQuestList then
    self.worldBossQuestList = {}
  end
  self.worldBossQuestList[questid] = status
end

function LocalSaveProxy:RemoveWorldBossQuestTrace(questid)
  local find = self:GetWorldQuestTrace(questid)
  if find ~= nil then
    FunctionPlayerPrefs.Me():DeleteKey(LocalSaveProxy.SAVE_KEY.WorldBossQuestTrace .. "_" .. questId)
    self.worldBossQuestList[questid] = nil
  end
end

function LocalSaveProxy:GetWorldBossQuestTrace(id)
  return self.worldBossQuestList and self.worldBossQuestList[id]
end

function LocalSaveProxy:SetGVGFrameChecked()
  FunctionPlayerPrefs.Me():SetInt(LocalSaveProxy.SAVE_KEY.GVG_FrameChecked, 1)
end

function LocalSaveProxy:ResetGVGFrameChecked()
  FunctionPlayerPrefs.Me():SetInt(LocalSaveProxy.SAVE_KEY.GVG_FrameChecked, 0)
end

function LocalSaveProxy:AddQueryPriceHistory(itemId)
  if not self:IsInQueryPriceHistory(itemId) then
    if #self.queryPriceHistory >= GameConfig.Exchange.MaxSearchLog then
      local offset = #self.queryPriceHistory - GameConfig.Exchange.MaxSearchLog + 1
      for i = offset, 1, -1 do
        table.remove(self.queryPriceHistory, i)
      end
    end
    table.insert(self.queryPriceHistory, itemId)
    local str = tostring(self.queryPriceHistory[1])
    for i = 2, #self.queryPriceHistory do
      str = str .. "_" .. tostring(self.queryPriceHistory[i])
    end
    FunctionPlayerPrefs.Me():SetString(LocalSaveProxy.SAVE_KEY.QueryPriceHistory, str)
    FunctionPlayerPrefs.Me():Save()
  end
end

function LocalSaveProxy:IsInQueryPriceHistory(itemId)
  for i = 1, #self.queryPriceHistory do
    if self.queryPriceHistory[i] == itemId then
      return true
    end
  end
  return false
end

function LocalSaveProxy:GetQueryPriceHistory()
  if self.queryPriceHistory == nil then
    self:InitQueryPriceHistory()
  end
  return self.queryPriceHistory
end

function LocalSaveProxy:InitQueryPriceHistory()
  if FunctionPlayerPrefs.Me():IsInited() then
    self.queryPriceHistory = {}
    local str = FunctionPlayerPrefs.Me():GetString(LocalSaveProxy.SAVE_KEY.QueryPriceHistory, "")
    local history = string.split(str, "_")
    for i = 1, #history do
      if history[i] ~= "" then
        table.insert(self.queryPriceHistory, tonumber(history[i]))
      end
    end
  end
end

function LocalSaveProxy:GetLastAnnouncementEndTime()
  return FunctionPlayerPrefs.Me():GetInt(LocalSaveProxy.SAVE_KEY.AnnouncementEndTime, 0)
end

function LocalSaveProxy:SetLastAnnouncementEndTime(value)
  FunctionPlayerPrefs.Me():SetInt(LocalSaveProxy.SAVE_KEY.AnnouncementEndTime, value)
end

function LocalSaveProxy:GetNoviceShopOpened()
  return FunctionPlayerPrefs.Me():GetInt(LocalSaveProxy.SAVE_KEY.NoviceShopOpened, 0)
end

function LocalSaveProxy:SetNoviceShopOpened(value)
  FunctionPlayerPrefs.Me():SetInt(LocalSaveProxy.SAVE_KEY.NoviceShopOpened, value)
end

function LocalSaveProxy:InitBannerDontShowAgain()
  if not ServerTime.CurServerTime() then
    return
  end
  local serverTime = ServerTime.CurServerTime() / 1000
  if self.bannerdontShowAgains == nil and FunctionPlayerPrefs.Me():IsInited() and serverTime ~= nil then
    self.bannerdontShowAgains = {}
    local dirty
    local str = FunctionPlayerPrefs.Me():GetString(LocalSaveProxy.SAVE_KEY.BannerDontShowAgain, "")
    local t = loadstring("return {" .. str .. "}")()
    local id, timeStamp
    local ids = ""
    for i = 1, #t do
      id = t[i]
      if id ~= nil and id ~= "" then
        str = FunctionPlayerPrefs.Me():GetString(LocalSaveProxy.SAVE_KEY.BannerDontShowAgain .. "_" .. id, "")
        timeStamp = tonumber(str)
        if timeStamp and serverTime and (timeStamp == 0 or serverTime < timeStamp) then
          self.bannerdontShowAgains[id] = timeStamp
          ids = ids ~= "" and ids .. "," .. id or id
        else
          dirty = true
          helplog("删除", id, timeStamp)
          FunctionPlayerPrefs.Me():DeleteKey(LocalSaveProxy.SAVE_KEY.BannerDontShowAgain .. "_" .. id)
        end
      end
    end
    self.bannerdontShowAgains.ids = ids
    if dirty then
      FunctionPlayerPrefs.Me():SetString(LocalSaveProxy.SAVE_KEY.BannerDontShowAgain, self.bannerdontShowAgains.ids)
      FunctionPlayerPrefs.Me():Save()
    end
  end
end

function LocalSaveProxy:AddBannerDontShowAgain(id, timeStamp)
  local find = self:GetBannerDontShowAgain(id)
  if find == nil then
    local timeStamp = ClientTimeUtil.GetNextDailyRefreshTime()
    FunctionPlayerPrefs.Me():AppendString(LocalSaveProxy.SAVE_KEY.BannerDontShowAgain, id, ",")
    FunctionPlayerPrefs.Me():SetString(LocalSaveProxy.SAVE_KEY.BannerDontShowAgain .. "_" .. id, timeStamp)
    FunctionPlayerPrefs.Me():Save()
    self.bannerdontShowAgains[id] = timeStamp
  end
end

function LocalSaveProxy:GetBannerDontShowAgain(id)
  return self.bannerdontShowAgains and self.bannerdontShowAgains[id] or nil
end

function LocalSaveProxy:GetNoviceShopOpened()
  return FunctionPlayerPrefs.Me():GetInt(LocalSaveProxy.SAVE_KEY.NoviceShopOpened, 0)
end

local RefuseInterval = GameConfig.Team.RefuseInterval

function LocalSaveProxy:GetCanRefuseTime()
  local curTime = ServerTime.CurServerTime() / 1000
  local lastcount = FunctionPlayerPrefs.Me():GetInt(LocalSaveProxy.SAVE_KEY.AssistantInvite_RefuseCount, -1)
  local lasttime = FunctionPlayerPrefs.Me():GetInt(LocalSaveProxy.SAVE_KEY.AssistantInvite_RefuseTime, 0)
  if lasttime <= 0 then
    return true
  end
  if not ClientTimeUtil.IsSameDay(curTime, lasttime) then
    FunctionPlayerPrefs.Me():SetInt(LocalSaveProxy.SAVE_KEY.AssistantInvite_RefuseTime, 0)
    FunctionPlayerPrefs.Me():SetInt(LocalSaveProxy.SAVE_KEY.AssistantInvite_RefuseCount, -1)
    return true
  end
  local interval = RefuseInterval[lastcount]
  local nexttime = lasttime + interval
  if 0 < interval then
    return curTime > nexttime
  else
    return false
  end
end

function LocalSaveProxy:SetLastRefuseTime()
  local timeStamp = ServerTime.CurServerTime() / 1000
  local lastcount = FunctionPlayerPrefs.Me():GetInt(LocalSaveProxy.SAVE_KEY.AssistantInvite_RefuseCount, -1)
  FunctionPlayerPrefs.Me():SetInt(LocalSaveProxy.SAVE_KEY.AssistantInvite_RefuseCount, lastcount + 1)
  FunctionPlayerPrefs.Me():SetInt(LocalSaveProxy.SAVE_KEY.AssistantInvite_RefuseTime, timeStamp)
  FunctionPlayerPrefs.Me():Save()
end

function LocalSaveProxy:GetRechargeHero_New()
  local lasttime = FunctionPlayerPrefs.Me():GetInt(LocalSaveProxy.SAVE_KEY.RechargeHero_New, 0)
  return lasttime
end

function LocalSaveProxy:SetRechargeHero_New()
  local curTime = ServerTime.CurServerTime() / 1000
  FunctionPlayerPrefs.Me():SetInt(LocalSaveProxy.SAVE_KEY.RechargeHero_New, curTime)
end

function LocalSaveProxy:CheckRechargeHero_New()
  local lasttime = self:GetRechargeHero_New()
  local lasttime = tonumber(str)
  local delta = ServerTime.CurServerTime() / 1000 - checkDate
  return 0 <= delta and delta < 86400
end

local KEY_PhotographPanel_HighQuality = "PhotographPanel_HighQuality"

function LocalSaveProxy:Set_PhotographPanel_HighQuality(val)
  FunctionPlayerPrefs.Me():SetInt(KEY_PhotographPanel_HighQuality, val)
  FunctionPlayerPrefs.Me():Save()
end

function LocalSaveProxy:Get_PhotographPanel_HighQuality()
  return FunctionPlayerPrefs.Me():GetInt(KEY_PhotographPanel_HighQuality, 1)
end

local KEY_PhotographPanel_MulityPeopleToggle = "PhotographPanel_MulityPeopleToggle"

function LocalSaveProxy:Set_PhotographPanel_MulityPeopleToggle(val)
  FunctionPlayerPrefs.Me():SetInt(KEY_PhotographPanel_MulityPeopleToggle, val)
  FunctionPlayerPrefs.Me():Save()
end

function LocalSaveProxy:Get_PhotographPanel_MulityPeopleToggle()
  return FunctionPlayerPrefs.Me():GetInt(KEY_PhotographPanel_MulityPeopleToggle, 1)
end

function LocalSaveProxy:SetMountFashion(roleId, mountId, bytes)
  FunctionPlayerPrefs.Me():SetString(LocalSaveProxy.SAVE_KEY.MountFashion .. "_" .. roleId .. "_" .. mountId, bytes, false)
  FunctionPlayerPrefs.Me():Save()
end

function LocalSaveProxy:GetMountFashion(roleId, mountId)
  if roleId and mountId then
    local key = LocalSaveProxy.SAVE_KEY.MountFashion .. "_" .. roleId .. "_" .. mountId
    return FunctionPlayerPrefs.Me():GetString(key, "", false)
  end
end
