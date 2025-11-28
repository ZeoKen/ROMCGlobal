ColorFillingProxy = class("ColorFillingProxy", pm.Proxy)
ColorFillingProxy.Instance = nil
ColorFillingProxy.NAME = "ColorFillingProxy"

function ColorFillingProxy:ctor(proxyName, data)
  self.proxyName = proxyName or ColorFillingProxy.NAME
  if not ColorFillingProxy.Instance then
    ColorFillingProxy.Instance = self
  end
  if data then
    self:setData(data)
  end
  self.widgetColorMap = {}
  self.dialogDataMap = {}
end

function ColorFillingProxy:SetColorFillingData(data)
  if data.pics then
    for i = 1, #data.pics do
      local info = data.pics[i]
      local color = LuaColor(info.rgb.r / 255, info.rgb.g / 255, info.rgb.b / 255, 1)
      self.widgetColorMap[info.picid] = color
    end
  end
  if data.texts then
    for i = 1, #data.texts do
      local info = data.texts[i]
      self.dialogDataMap[info.textid] = info.content
    end
  end
end

function ColorFillingProxy:GetWidgetColor(id)
  return self.widgetColorMap[id]
end

function ColorFillingProxy:GetDialogContent(id)
  return self.dialogDataMap[id]
end
