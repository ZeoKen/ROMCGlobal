local _ArrayPushBack = TableUtility.ArrayPushBack
autoImport("NewGvgRank_GuildShowInfo")
GvgSettleCity = class("GvgSettleCity")
GvgSettleCity.SortID = {
  LastCity = 1,
  Wait = 2,
  TempOccupy = 3,
  Prepare = 4
}

function GvgSettleCity:ctor(id, sortid, lastGuild)
  self.cityId = id
  self.sortID = sortid
  self.cityConfig = GvgProxy.GetStrongHoldStaticData(id)
  if self.cityConfig then
    self.cityName = self.cityConfig.Name
  else
    self.cityName = "Check Config! Can not find Guild_StrongHold id : " .. tostring(id)
  end
  if lastGuild then
    self.isMyLastGuildCity = GuildProxy.Instance.guildId == lastGuild
  else
    self.isMyLastGuildCity = nil
  end
end

function GvgSettleCity:IsMyLastGuildCity()
  return self.isMyLastGuildCity == true
end

function GvgSettleCity:IsLastCity()
  return self.sortID == GvgSettleCity.SortID.LastCity
end

function GvgSettleCity:IsWait()
  return self.sortID == GvgSettleCity.SortID.Wait
end

function GvgSettleCity:IsTempOccupy()
  return self.sortID == GvgSettleCity.SortID.TempOccupy
end

function GvgSettleCity:IsPrepare()
  return self.sortID == GvgSettleCity.SortID.Prepare
end

GvgSettleInfo = class("GvgSettleInfo")

function GvgSettleInfo:ctor(data)
  self.settleFinish = data.finish
  GvgProxy.Instance:Debug("[NewGVG] settle finish: ", data.finish)
  if self.settleFinish then
    return
  end
  GvgProxy.Instance:Debug("[NewGVG] 打印settle信息")
  TableUtil.Print(data)
  self.settleCityList = {}
  local server_guildShowInfo = data.last_city_owner
  if data.last_city and data.last_city > 0 and server_guildShowInfo.guildid and 0 < server_guildShowInfo.guildid then
    self.lastCityId = data.last_city
    local staticCity = GvgProxy.GetStrongHoldStaticData(self.lastCityId)
    self.lastCityName = staticCity and staticCity.Name or ""
    self.lastCityGuildId = server_guildShowInfo.guildid
    self.lastCityShowInfo = NewGvgRank_GuildShowInfo.new(self.lastCityGuildId, server_guildShowInfo)
    local settle_Last_city = GvgSettleCity.new(self.lastCityId, GvgSettleCity.SortID.LastCity, self.lastCityGuildId)
    _ArrayPushBack(self.settleCityList, settle_Last_city)
  end
  if data.wait_option_city and 0 < data.wait_option_city then
    self.waitOptionalCity = data.wait_option_city
    local settle_Wait_city = GvgSettleCity.new(self.waitOptionalCity, GvgSettleCity.SortID.Wait)
    _ArrayPushBack(self.settleCityList, settle_Wait_city)
  end
  local waitSelectCitys = data.wait_select_citys
  if waitSelectCitys and 0 < #waitSelectCitys then
    for i = 1, #waitSelectCitys do
      if waitSelectCitys[i] ~= self.lastCityId then
        local settle_tempOccupy_city = GvgSettleCity.new(waitSelectCitys[i], GvgSettleCity.SortID.TempOccupy)
        _ArrayPushBack(self.settleCityList, settle_tempOccupy_city)
        self.hasSelectCitys = true
      end
    end
  end
  local prepCitys = data.prepare_citys
  if prepCitys and 0 < #prepCitys then
    for _, cityId in ipairs(prepCitys) do
      if cityId ~= self.lastCityId then
        local settle_tempOccupy_city = GvgSettleCity.new(cityId, GvgSettleCity.SortID.Prepare)
        _ArrayPushBack(self.settleCityList, settle_tempOccupy_city)
      end
    end
  end
end

function GvgSettleInfo:HasSelectCitys()
  return self.hasSelectCitys == true
end

function GvgSettleInfo:GetLastWeekGuildName()
  return self.lastCityShowInfo and self.lastCityShowInfo.guildName or ""
end

function GvgSettleInfo:GetLastWeekCityName()
  return self.lastCityName or ""
end

function GvgSettleInfo:HasWaitOption()
  return self.waitOptionalCity and self.waitOptionalCity > 0
end

function GvgSettleInfo:IsPlanConfirmed()
  if self:HasWaitOption() then
    return true
  end
  if not self:HasSelectCitys() and not self:HasWaitOption() and self.lastCityGuildId and self.lastCityGuildId ~= GuildProxy.Instance.guildId then
    return true
  end
  return false
end
