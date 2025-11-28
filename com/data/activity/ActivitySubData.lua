ActivitySubData = class("ActivitySubData")

function ActivitySubData:ctor(serverData)
  self:updateData(serverData)
end

function ActivitySubData:updateData(serverData)
  self.id = serverData.id
  self.begintime = serverData.begintime
  self.endtime = serverData.endtime
  self.pathtype = serverData.pathtype
  self.pathevent = serverData.pathevent
  self.monthcard = serverData.data and serverData.data.monthcard
  self.name = self:getMultLanContent(serverData, "name")
  self.url = self:getMultLanContent(serverData, "url")
  self.pic_url = self:getMultLanContent(serverData, "pic_url")
  if BranchMgr.IsJapan() then
    self.pic_url = string.gsub(self.pic_url, "https", "http")
    self.url = string.gsub(self.url, "https", "http")
  end
  self.groupid = serverData.groupid
end

function ActivitySubData:getMultLanContent(serverData, key)
  if serverData[key] and serverData[key] ~= "" then
    return serverData[key]
  end
  local lanData = serverData.data.lang
  if not lanData then
    return ""
  end
  local language = ApplicationInfo.GetSystemLanguage()
  helplog("ActivitySubData:getMultLanContent", key, language)
  local englishVal = ""
  local val
  for i = 1, #lanData do
    local single = lanData[i]
    if single.language == language then
      val = single[key]
      break
    end
    if single.language == 10 then
      englishVal = single[key]
    end
  end
  if val ~= nil then
    helplog("return", key, val)
    return val
  end
  return englishVal
end
