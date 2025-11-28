autoImport("GvGPerfectTimeInfo")
GvgDefenseData = class("GvgDefenseData")

function GvgDefenseData:ctor(data)
  self.cityid = data.cityid
  local staticData = GvgProxy.GetStrongHoldStaticData(self.cityid)
  if staticData and not StringUtil.IsEmpty(staticData.Name) then
    self.cityName = OverSea.LangManager.Instance():GetLangByKey(staticData.Name)
  else
    self.cityName = ""
  end
  self:Reset(data)
end

function GvgDefenseData:Reset(data)
  if nil ~= data.perfect then
    self.perfect = data.perfect
  end
  local timeInfo = GvGPerfectTimeInfo.new(data.perfect_time)
  self.pause = timeInfo.pause
  self.time = timeInfo.time
  GvgProxy.Instance:Debug("[NewGVG 本场公会战积分信息完美防守信息] 是否暂停 是否达成完美防守 时间 ", self.pause, self.perfect, os.date("%Y-%m-%d-%H-%M-%S", self.time))
end
