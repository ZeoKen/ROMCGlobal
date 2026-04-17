local BaseCell = autoImport("BaseCell")
ActivityIntegrationTabCell = class("ActivityIntegrationTabCell", BaseCell)

function ActivityIntegrationTabCell:Init()
  self:FindObjs()
  self:AddUIEvents()
end

function ActivityIntegrationTabCell:FindObjs()
  self.timeLabel = self:FindGO("TimeLabel"):GetComponent(UILabel)
  self.titleLabel = self:FindGO("Title"):GetComponent(UILabel)
  self.titleBG = self:FindGO("TitleBg"):GetComponent(UISprite)
  self.descLabel = self:FindGO("DescLabel"):GetComponent(UILabel)
  self.point = self:FindGO("Point"):GetComponent(UISprite)
end

function ActivityIntegrationTabCell:AddUIEvents()
  self:AddClickEvent(self.gameObject, function(go)
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
end

function ActivityIntegrationTabCell:SetData(data)
  self.data = data
  self.id = data.id
  local id = self.data.id
  local startTime, endTime = data.startTime, data.endTime
  if startTime and endTime then
    local p = "(%d+)-(%d+)-(%d+) (%d+):(%d+):(%d+)"
    local startYear, startMonth, startDay, startHour, startMin, startSec = startTime:match(p)
    local endYear, endMonth, endDay, endHour, endMin, endSec = endTime:match(p)
    if startYear and endYear then
      local startTimestamp = ServerTime.Ori_OsTime({
        year = tonumber(startYear),
        month = tonumber(startMonth),
        day = tonumber(startDay),
        hour = tonumber(startHour),
        min = tonumber(startMin),
        sec = tonumber(startSec)
      })
      local endTimestamp = ServerTime.Ori_OsTime({
        year = tonumber(endYear),
        month = tonumber(endMonth),
        day = tonumber(endDay),
        hour = tonumber(endHour),
        min = tonumber(endMin),
        sec = tonumber(endSec)
      })
      local curServerTime = ServerTime.CurServerTime() / 1000
      if startTimestamp and endTimestamp and startTimestamp <= curServerTime and endTimestamp >= curServerTime then
        local str = tonumber(startMonth) .. "." .. tonumber(startDay) .. "~" .. tonumber(endMonth) .. "." .. tonumber(endDay)
        self.timeLabel.text = str
      else
        self.timeLabel.text = ""
      end
    else
      self.timeLabel.text = ""
    end
  else
    self.timeLabel.text = ""
  end
  self.staticData = data.staticData
  if self.staticData then
    self.titleLabel.text = self.staticData.TitleName
    self.descLabel.text = self.staticData.TabDesc or ""
  else
    self.titleLabel.text = data.TitleName
    self.descLabel.text = data.TabDesc or ""
  end
end

function ActivityIntegrationTabCell:SetSelect(isTrue)
  self.titleLabel.color = isTrue and LuaGeometry.GetTempColor(1, 0.8745098039215686, 0.36470588235294116, 1) or LuaGeometry.GetTempColor(0.9921568627450981, 0.9490196078431372, 0.8196078431372549, 1)
  self.titleBG.color = isTrue and LuaGeometry.GetTempColor(0.8980392156862745, 0.5058823529411764, 0.12156862745098039, 0.5) or LuaGeometry.GetTempColor(0.9019607843137255, 0.8235294117647058, 0.6039215686274509, 0.35)
  self.timeLabel.color = isTrue and LuaGeometry.GetTempColor(0.8980392156862745, 0.7058823529411765, 0.12156862745098039, 1) or LuaGeometry.GetTempColor(0.7568627450980392, 0.7333333333333333, 0.6666666666666666, 1)
  self.descLabel.color = isTrue and LuaGeometry.GetTempColor(0.8980392156862745, 0.7058823529411765, 0.12156862745098039, 1) or LuaGeometry.GetTempColor(0.7568627450980392, 0.7333333333333333, 0.6666666666666666, 1)
  self.point.color = isTrue and LuaGeometry.GetTempColor(1, 0.8745098039215686, 0.36470588235294116, 1) or LuaGeometry.GetTempColor(0.6, 0.5647058823529412, 0.4196078431372549, 1)
end
