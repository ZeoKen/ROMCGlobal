YearMemoryProxy = class("YearMemoryProxy", pm.Proxy)
YearMemoryProxy.Instance = nil
YearMemoryProxy.NAME = "YearMemoryProxy"

function YearMemoryProxy:ctor(proxyName, data)
  self.proxyName = proxyName or YearMemoryProxy.NAME
  if YearMemoryProxy.Instance == nil then
    YearMemoryProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:Init()
end

function YearMemoryProxy:Init()
  self.memoryStaticData = {}
  self.memoryData = {}
  self.memoryUnlockData = {}
end

function YearMemoryProxy:InitStaticData()
  if not self.inited then
    self.inited = true
  else
    return
  end
  for k, v in pairs(Table_YearMemoryLine) do
    local versionData = self.memoryStaticData[v.Version] or {}
    local pages = versionData.pages or {}
    local pageInfo = pages[v.Page] or {}
    local indexes = pageInfo.indexes or {}
    table.insert(indexes, k)
    if v.Texture and v.Texture ~= "" then
      pageInfo.texture = v.Texture
    end
    if v.Quest then
      pageInfo.quest = v.Quest
    end
    pageInfo.indexes = indexes
    pages[v.Page] = pageInfo
    versionData.pages = pages
    self.memoryStaticData[v.Version] = versionData
  end
  for version, info in pairs(self.memoryStaticData) do
    local pages = info.pages
    for page, info in pairs(pages) do
      local indexes = info.indexes
      table.sort(indexes, function(l, r)
        return l < r
      end)
      local replaceIDs = {}
      for i = 1, #indexes do
        if Table_YearMemoryLine[indexes[i]] and Table_YearMemoryLine[indexes[i]].ReplaceID then
          table.insert(replaceIDs, Table_YearMemoryLine[indexes[i]].ReplaceID)
        end
      end
      for i = 1, #replaceIDs do
        redlog("移除替换用id", replaceIDs[i])
        TableUtility.ArrayRemove(indexes, replaceIDs[i])
      end
    end
  end
  for actid, info in pairs(Table_ActPersonalTimer) do
    if info.Type == "year_memory" then
      local misc = info.Misc
      local year = misc.year
      if self.memoryStaticData[year] then
        self.memoryStaticData[year].end_process = misc.end_process or 6
        local reward = misc.share_reward
        if reward and next(reward) then
          self.memoryStaticData[year].share_reward = {
            reward[1],
            reward[2]
          }
        end
        self.memoryStaticData[year].timestamp = misc.TimeStamp and KFCARCameraProxy.Instance:GetSelfCustomDate(misc.TimeStamp)
      end
    end
  end
end

function YearMemoryProxy:GetVersionData(version)
  return self.memoryStaticData[version]
end

function YearMemoryProxy:GetIndexsByVersionAndPage(version, page)
  if self.memoryStaticData[version] then
    local pages = self.memoryStaticData[version].pages
    if pages then
      return pages[page]
    end
  end
end

function YearMemoryProxy:GetValidIndexesByVersion(version)
  local staticData = self:GetVersionData(version)
  if not staticData then
    return
  end
  local result = {}
  local pages = staticData.pages
  for page, info in pairs(pages) do
    local indexes = info.indexes
    if indexes and 0 < #indexes then
      for i = 1, #indexes do
        local lineInfo = Table_YearMemoryLine[indexes[i]]
        if lineInfo then
          local descStr = OverSea.LangManager.Instance():GetLangByKey(lineInfo.Desc)
          if self:HasReplaceInfo(version, descStr) then
            table.insert(result, indexes[i])
          else
            local replaceID = lineInfo.ReplaceID
            if replaceID then
              descStr = OverSea.LangManager.Instance():GetLangByKey(Table_YearMemoryLine[replaceID].Desc)
              if self:HasReplaceInfo(version, descStr) then
                table.insert(result, replaceID)
              end
            end
          end
        end
      end
    end
  end
  return result
end

function YearMemoryProxy:RecvYearMemoryActInfoCmd(data)
  local actid = data.act_id
  if not actid or not Table_ActPersonalTimer[actid] then
    redlog("周年回忆分享状态配置错误Table_ActPersonalTimer", actid)
    return
  end
  local info = Table_ActPersonalTimer[actid].Misc
  local year = info and info.year
  local maxProcess = info and info.end_process
  if year and not self.memoryUnlockData[year] then
    self.memoryUnlockData[year] = {}
  end
  self.memoryUnlockData[year].actid = actid
  self.memoryUnlockData[year].gotten_share_reward = data.gotten_share_reward or false
  xdlog("1111 周年回忆是否领奖", year, data.gotten_share_reward)
  self:RefreshFakeRedTip(year)
end

function YearMemoryProxy:GetMemoryStatus(year)
  if self.memoryUnlockData[year] then
    return self.memoryUnlockData[year]
  else
    self.memoryUnlockData[year] = {}
    return
  end
end

function YearMemoryProxy:RecvQueryYearMemoryUserCmd(data)
  local year = data.year
  if not self.memoryData[year] then
    self.memoryData[year] = {}
  end
  local datas = data.datas
  if datas and 0 < #datas then
    for i = 1, #datas do
      local id = datas[i].id
      self.memoryData[year][id] = {
        value = datas[i].value,
        name = datas[i].name
      }
    end
  end
end

function YearMemoryProxy:GetYearMemoryData(year)
  if self.memoryData[year] then
    return self.memoryData[year]
  end
end

function YearMemoryProxy:GetYearMemoryDetail(year, replaceID)
  if not self.memoryData[year] then
    return
  end
  local curInfo = self.memoryData[year][replaceID]
  if curInfo then
    if curInfo.value and curInfo.value ~= 0 then
      return curInfo.value
    elseif curInfo.name and curInfo.name ~= "" then
      return curInfo.name
    else
      return
    end
  else
    return
  end
end

function YearMemoryProxy:RecvYearMemoryProcessUserCmd(data)
  self:InitStaticData()
  local datas = data.datas
  if datas and 0 < #datas then
    for i = 1, #datas do
      local process = datas[i].process or 0
      if not self.memoryUnlockData[datas[i].year] then
        self.memoryUnlockData[datas[i].year] = {}
      elseif self.memoryUnlockData[datas[i].year].process and process > self.memoryUnlockData[datas[i].year].process then
        xdlog("11111数据变动 视作解锁", process)
        GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
          view = PanelConfig.MemoryPopup,
          viewdata = {
            pages = {process},
            version = datas[i].year,
            firstShow = 1
          }
        })
      end
      self.memoryUnlockData[datas[i].year].process = process
      self.memoryUnlockData[datas[i].year].title = datas[i].title_id
      local keypoints = datas[i].keypoint_ids
      if keypoints and 0 < #keypoints then
        self.memoryUnlockData[datas[i].year].keypoints = {}
        TableUtility.ArrayShallowCopy(self.memoryUnlockData[datas[i].year].keypoints, keypoints)
      end
      xdlog("11111解锁的周年庆进度", datas[i].year, process, keypoints and keypoints[1] or "0")
      self:RefreshFakeRedTip(datas[i].year)
    end
  end
end

function YearMemoryProxy:RefreshFakeRedTip(year)
  if not year then
    return
  end
  local unlockData = self:GetMemoryStatus(year)
  local actid = unlockData and unlockData.actid
  if not actid then
    RedTipProxy.Instance:RemoveWholeTip(SceneTip_pb.EREDSYS_NEW_YEAR_MEMORY)
    return
  else
    local actValid = ActivityIntegrationProxy.Instance:CheckActPersinalActValid(actid)
    if not actValid then
      RedTipProxy.Instance:RemoveWholeTip(SceneTip_pb.EREDSYS_NEW_YEAR_MEMORY)
      return
    end
  end
  local staticData = self:GetVersionData(year)
  local process = unlockData and unlockData.process
  local endProcess = staticData and staticData.end_process
  local isNew = RedTipProxy.Instance:InRedTip(SceneTip_pb.EREDSYS_NEW_YEAR_MEMORY)
  if process == endProcess and unlockData and not unlockData.gotten_share_reward then
    if not isNew then
      RedTipProxy.Instance:UpdateRedTip(SceneTip_pb.EREDSYS_NEW_YEAR_MEMORY)
    end
  elseif isNew then
    RedTipProxy.Instance:RemoveWholeTip(SceneTip_pb.EREDSYS_NEW_YEAR_MEMORY)
  end
end

function YearMemoryProxy:CallQueryYearMemoryUserCmd(year)
  if not year then
    return
  end
  local yearData = self:GetYearMemoryData(year)
  if not yearData then
    xdlog("1111请求Query", year)
    ServiceSceneUser3Proxy.Instance:CallQueryYearMemoryUserCmd(year)
  end
end

function YearMemoryProxy:CallYearMemoryGetShareRewardCmd(year)
  local data = self:GetMemoryStatus(year)
  if data and data.gotten_share_reward then
  elseif not data then
  else
    local actid = data and data.actid
    if actid then
      xdlog("申请领奖", actid)
      ServiceActivityCmdProxy.Instance:CallYearMemoryGetShareRewardCmd(actid)
    end
  end
end

function YearMemoryProxy:HasReplaceInfo(version, str)
  if StringUtil.IsEmpty(str) then
    return
  end
  for id, func in string.gmatch(str, "%[#(.-)%]") do
    local split = string.split(id, ",")
    local replaceStr = self:GetYearMemoryDetail(version, tonumber(split[1]))
    if not replaceStr or replaceStr == "" then
      return false
    end
  end
  return true
end

function YearMemoryProxy:AdaptReplaceMark(version, str)
  if StringUtil.IsEmpty(str) then
    return
  end
  if not version then
    return
  end
  return string.gsub(str, "%[#(.-)%]", function(str)
    local split = string.split(str, ",")
    local sb = LuaStringBuilder.CreateAsTable()
    sb:Append("[c][B34604]")
    local replaceStr
    if #split == 1 then
      replaceStr = self:GetYearMemoryDetail(version, tonumber(split[1]))
    elseif #split == 2 then
      replaceStr = self:GetYearMemoryDetail(version, tonumber(split[1]))
      if split[2] == "distance" and type(replaceStr) == "number" then
        replaceStr = math.ceil(replaceStr / 284)
      elseif split[2] == "date" and type(replaceStr) == "number" then
        local time = os.date("*t", replaceStr)
        replaceStr = string.format(ZhString.Servant_Calendar_DATE_FORMAT, time.year, time.month, time.day)
      elseif split[2] == "totalday" and type(replaceStr) == "number" then
        local unlockData = self:GetMemoryStatus(version)
        local timestamp = ServerTime.CurServerTime() / 1000
        local deltaTime = timestamp - replaceStr
        if deltaTime < 0 then
          deltaTime = 0
        end
        replaceStr = string.format(ZhString.EndlessTower_refreshDay, math.floor(deltaTime / 86400))
      elseif split[2] == "day" and type(replaceStr) == "number" then
        replaceStr = math.ceil(replaceStr / 86400)
      elseif split[2] == "hour" and type(replaceStr) == "number" then
        replaceStr = math.ceil(replaceStr / 86400) * 24
      elseif split[2] == "minute" and type(replaceStr) == "number" then
        replaceStr = math.ceil(replaceStr / 86400) * 1440
      elseif split[2] == "second" and type(replaceStr) == "number" then
        replaceStr = math.ceil(replaceStr / 86400) * 86400
      elseif split[2] == "zeny" and type(replaceStr) == "number" then
        replaceStr = StringUtil.NumThousandFormat(replaceStr)
      end
    end
    sb:Append(replaceStr)
    sb:Append("[-][/c]")
    local s = sb:ToString()
    sb:Destroy()
    return s
  end)
end

function YearMemoryProxy:CallSetYearMemoryTitleUserCmd(version, title, keypoints)
  if not version then
    return
  end
  local data = self:GetMemoryStatus(version)
  local titleSend = title or data.title or nil
  local keyPointsSend = keypoints or data.keypoints or {}
  xdlog("请求数据变动", keyPointsSend and keyPointsSend[1] or "nil")
  data.title = titleSend
  data.keypoints = keyPointsSend
  ServiceSceneUser3Proxy.Instance:CallSetYearMemoryTitleUserCmd(version, titleSend, keyPointsSend)
end
