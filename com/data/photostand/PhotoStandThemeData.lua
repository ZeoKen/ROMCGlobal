PhotoStandThemeData = class("PhotoStandThemeData", PhotoStandListData)

function PhotoStandThemeData:ctor(serverData)
  PhotoStandThemeData.super.ctor(self)
  self:Server_SetData(serverData)
end

local get_name = function(names)
  local language = ApplicationInfo.GetSystemLanguage()
  local englishVal = ""
  for i = 1, #names do
    local v = names[i]
    if v.language == language then
      return v.param
    elseif v.language == 10 then
      englishVal = v.param
    end
  end
  return englishVal
end

function PhotoStandThemeData:Server_SetData(serverData)
  self.topic = serverData.topic
  self.rotate = serverData.rotate
  self.name = get_name(serverData.names)
  self.npcids = table.deepcopy(serverData.npcids)
  self.uploadurl = serverData.uploadurl
  self.begintime = serverData.begintime
  self.endtime = serverData.endtime
end

function PhotoStandThemeData:SetTagAsSlide(isTrue)
  self:SetUsageTag(isTrue and "theme_slide" or "theme")
end
