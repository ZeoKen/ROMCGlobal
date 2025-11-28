RememberLoginProxy = class("RememberLoginProxy", pm.Proxy)
autoImport("RememberLoginUtil")

function RememberLoginProxy:ctor(proxyName, data)
  self.proxyName = proxyName or "RememberLoginProxy"
  if RememberLoginProxy.Instance == nil then
    RememberLoginProxy.Instance = self
  end
  if not data then
    self:setData(data)
  end
end

function RememberLoginProxy:Init()
  self.isOpen = false
  self.startTime = 0
  self.endTime = 0
  self.loginDayNum = 0
  self.awardedDays = {}
  self.specialawarded = false
  self.onlineawarded = false
  self.specialawardactive = false
  self.ontimeRewardLevel = 1
  self.isInitOntimeTime = false
  self.startTime_Ontime = 0
  self.endTime_Ontime = 0
  self:InitConfig()
  self.isInited = true
end

function RememberLoginProxy:GetOntimeRewardLevel(loginDayNum)
  if not self.isInited then
    LogUtility.Error(string.format("[%s] GetOntimeRewardLevel() Error : self.isInited == false!", self.__cname))
    return nil
  end
  local count = #self.ontimeRewardLevels
  if loginDayNum >= self.ontimeRewardLevels[count] then
    return self.ontimeRewardLevels[count]
  end
  for i = 1, count do
    if loginDayNum < self.ontimeRewardLevels[i] then
      local index = i - 1
      index = math.max(index, 1)
      return self.ontimeRewardLevels[index]
    end
  end
  return self.ontimeRewardLevels[1]
end

function RememberLoginProxy:InitConfig()
  local configData = GameConfig.FestivalSignin[RememberLoginUtil.ConfigID]
  if not configData then
    LogUtility.Error(string.format("[%s] InitConfig() Error : GameConfig.FestivalSignin[%d] == nil!", self.__cname, RememberLoginUtil.ConfigID))
    return nil
  end
  self.configData = configData
  local list = {}
  for key, value in pairs(self.configData.OntimeReward) do
    list[#list + 1] = key
  end
  table.sort(list, function(a, b)
    return a < b
  end)
  self.ontimeRewardLevels = list
end

function RememberLoginProxy:GetSignInRewardDatas()
  if not self.configData then
    LogUtility.Error(string.format("[%s] GetSignInRewardDatas() Error : self.configData == nil!", self.__cname))
    return nil
  end
  return self.configData.SigninReward
end

function RememberLoginProxy:GetSpecialRewardData()
  if not self.configData then
    LogUtility.Error(string.format("[%s] GetSpecialRewardData() Error : self.configData == nil!", self.__cname))
    return nil
  end
  return self.configData.SpecialReward[1]
end

function RememberLoginProxy:GetOntimeRewardData(loginDayNum)
  if not self.configData then
    LogUtility.Error(string.format("[%s] GetOntimeRewardData() Error : self.configData == nil!", self.__cname))
    return nil
  end
  local level = loginDayNum and self:GetOntimeRewardLevel(loginDayNum) or self.ontimeRewardLevel
  return self.configData.OntimeReward[level]
end

function RememberLoginProxy:SetOpenData(data)
  self.isOpen = data.open
  self.startTime = data.starttime
  self.endTime = data.endtime
  if not self.isInitOntimeTime then
    self.startTime_Ontime = RememberLoginUtil:GetTimestampByStrHMS(self.configData.Ontime.BeginTime)
    self.endTime_Ontime = RememberLoginUtil:GetTimestampByStrHMS(self.configData.Ontime.EndTime)
    self.isInitOntimeTime = true
  end
end

function RememberLoginProxy:UpdateData(data)
  self.data = data
  self.loginDayNum = data.logindaynum or 0
  self.awardedDays = data.awardeddays and {}
  self.specialawarded = data.specialawarded or false
  self.onlineawarded = data.onlineawarded or false
  self.specialawardactive = data.specialawardactive or false
  self.ontimeRewardLevel = self:GetOntimeRewardLevel(self.loginDayNum)
  self.loginDayNum = 5
  self.awardedDays = {
    1,
    3,
    5
  }
  self.specialawardactive = false
  LogUtility.Info(string.format("[%s] UpdateData() self.loginDayNum = %d, self.ontimeRewardLevel == %d!", self.__cname, self.loginDayNum, self.ontimeRewardLevel))
  EventManager.Me():PassEvent(ServiceEvent.ActivityCmdFestivalSigninInfo)
end

function RememberLoginProxy:CheckoutIsOpen()
  local curTime = RememberLoginUtil:GetServerTime()
  if not self.startTime or not self.endTime then
    return false
  end
  return curTime >= self.startTime and curTime <= self.endTime or false
end

function RememberLoginProxy:CheckoutOntimeRewardIsOpen()
  local curTime = RememberLoginUtil:GetServerTime()
  return curTime >= self.startTime_Ontime and curTime <= self.endTime_Ontime or false
end

function RememberLoginProxy:CheckoutOntimeRewardState()
  local curTime = RememberLoginUtil:GetServerTime()
  if curTime < self.startTime_Ontime then
    return 1
  elseif curTime > self.endTime_Ontime then
    return 3
  else
    return 2
  end
end

function RememberLoginProxy:SetActivityState(openData)
  self:SetOpenData(openData)
  if openData.open then
    self:ReqFestivalSigninInfo()
  end
end

function RememberLoginProxy:ReqFestivalSigninInfo()
  ServiceActivityCmdProxy.Instance:CallFestivalSigninInfo()
end

function RememberLoginProxy:ReqFestivalSigninLoginAward()
  ServiceActivityCmdProxy.Instance:CallFestivalSigninLoginAward()
end

function RememberLoginProxy:RecvFestivalSigninInfo(data)
  self:UpdateData(data)
end

function RememberLoginProxy:RecvFestivalSigninLoginAward(data)
  print("")
end
