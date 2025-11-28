local BaseCell = autoImport("BaseCell")
RecallIntegrationTabCell = class("RecallIntegrationTabCell", BaseCell)

function RecallIntegrationTabCell:Init()
  self:FindObjs()
  self:AddUIEvents()
end

function RecallIntegrationTabCell:FindObjs()
  self.timeLabel = self:FindGO("TimeLabel"):GetComponent(UILabel)
  self.titleLabel = self:FindGO("Title"):GetComponent(UILabel)
  self.titleBG = self:FindGO("TitleBg"):GetComponent(UISprite)
  self.descLabel = self:FindGO("DescLabel"):GetComponent(UILabel)
  self.point = self:FindGO("Point"):GetComponent(UISprite)
end

function RecallIntegrationTabCell:AddUIEvents()
  self:AddClickEvent(self.gameObject, function(go)
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
end

function RecallIntegrationTabCell:SetData(data)
  self.data = data
  self.id = data.id
  local startTime, endTime = data.startTime, data.endTime
  if startTime and endTime and 0 < startTime and 0 < endTime then
    local str = ""
    local startDate = os.date("*t", startTime)
    local endDate = os.date("*t", endTime)
    if startDate and endDate then
      str = str .. startDate.month .. "." .. startDate.day .. "~"
      str = str .. endDate.month .. "." .. endDate.day
    end
    self.timeLabel.text = str
  else
    self.timeLabel.text = ""
  end
  if data.name then
    self.titleLabel.text = data.name
  else
    self.titleLabel.text = ""
  end
  if data.desc then
    self.descLabel.text = data.desc
  else
    self.descLabel.text = ""
  end
end

function RecallIntegrationTabCell:SetSelect(isTrue)
  self.titleLabel.color = isTrue and LuaGeometry.GetTempColor(1, 0.8745098039215686, 0.36470588235294116, 1) or LuaGeometry.GetTempColor(0.9921568627450981, 0.9490196078431372, 0.8196078431372549, 1)
  self.titleBG.color = isTrue and LuaGeometry.GetTempColor(0.8980392156862745, 0.5058823529411764, 0.12156862745098039, 0.5) or LuaGeometry.GetTempColor(0.9019607843137255, 0.8235294117647058, 0.6039215686274509, 0.35)
  self.timeLabel.color = isTrue and LuaGeometry.GetTempColor(0.8980392156862745, 0.7058823529411765, 0.12156862745098039, 1) or LuaGeometry.GetTempColor(0.7568627450980392, 0.7333333333333333, 0.6666666666666666, 1)
  self.descLabel.color = isTrue and LuaGeometry.GetTempColor(0.8980392156862745, 0.7058823529411765, 0.12156862745098039, 1) or LuaGeometry.GetTempColor(0.7568627450980392, 0.7333333333333333, 0.6666666666666666, 1)
  self.point.color = isTrue and LuaGeometry.GetTempColor(1, 0.8745098039215686, 0.36470588235294116, 1) or LuaGeometry.GetTempColor(0.6, 0.5647058823529412, 0.4196078431372549, 1)
end
