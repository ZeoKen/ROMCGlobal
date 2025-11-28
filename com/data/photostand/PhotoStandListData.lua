autoImport("PhotoStandBriefData")
PhotoStandPageAuxData = class("PhotoStandPageAuxData")

function PhotoStandPageAuxData:ctor(pageId, s_idx, e_idx)
  self.pageId = pageId
  self.fetched = nil
  self.s_idx = s_idx
  self.e_idx = e_idx
end

PhotoStandListData = class("PhotoStandListData")

function PhotoStandListData:ctor()
  self.briefList = {}
  self.pageAuxList = {}
  self.sum = nil
  self.pageCount = 0
end

local DL_WIN_CFG = {
  def = {-5, 5},
  scene = {0, 10},
  slide = {-5, 5},
  mypost = {-5, 10},
  theme = {0, 10},
  theme_slide = {-5, 5}
}

function PhotoStandListData:SetUsageTag(usageTag)
  self.usageTag = usageTag
  local dlWin = DL_WIN_CFG[usageTag] or DL_WIN_CFG.def
  if self.activeOnShow and self.dlWin and (self.dlWin[1] ~= dlWin[1] or self.dlWin[2] ~= dlWin[2]) then
    self:Raise_RequestDL()
  end
  self.dlWin = dlWin
end

function PhotoStandListData:SetActiveOnShow(isTrue)
  self.activeOnShow = isTrue
  if not isTrue then
    self:Cancel_RequestDL()
  else
    self:Raise_RequestDL()
  end
end

function PhotoStandListData:Raise_RequestDL()
  local lb_index = self:_getRightIndex(self.curSpotPicIndex + self.dlWin[1], self.sum)
  local rb_index = self:_getRightIndex(self.curSpotPicIndex + self.dlWin[2], self.sum)
  local lb_page = math.ceil(lb_index / PhotoStandProxy.ServerPageSize)
  local rb_page = math.ceil(rb_index / PhotoStandProxy.ServerPageSize)
  local dlWinSize = self.dlWin[2] - self.dlWin[1] + 1
  if dlWinSize >= self.sum then
    lb_page = 1
    rb_page = self.pageCount
  elseif dlWinSize >= PhotoStandProxy.ServerPageSize and lb_page == rb_page then
    lb_page = 1
    rb_page = self.pageCount
  end
  self.req_pages = {}
  if lb_page <= rb_page then
    for i = lb_page, rb_page do
      if not self.pageAuxList[i].fetched then
        self.req_pages[#self.req_pages + 1] = i
      end
    end
  else
    for i = lb_page, self.pageCount do
      if not self.pageAuxList[i].fetched then
        self.req_pages[#self.req_pages + 1] = i
      end
    end
    for i = 1, rb_page do
      if not self.pageAuxList[i].fetched then
        self.req_pages[#self.req_pages + 1] = i
      end
    end
  end
  if #self.req_pages == 0 then
    self:RefreshDownloadQueue()
  else
    self:TryFetchReqPages()
  end
end

function PhotoStandListData:Cancel_RequestDL()
  self.req_pages = {}
  self:ClearDownloadQueue()
end

function PhotoStandListData:SetCurSpotPicIndex(index)
  if self.sum == 0 or self.sum == nil then
    self.curSpotPicIndex = 0
    return
  end
  index = self:_getRightIndex(index, self.sum)
  if self.curSpotPicIndex ~= index then
    self.curSpotPicIndex = index
    if self.activeOnShow then
      self:Raise_RequestDL()
    end
  end
end

function PhotoStandListData:_getRightIndex(idx, len)
  if len <= 0 then
    return idx
  end
  idx = idx % len
  if idx == 0 then
    idx = len
  end
  return idx
end

function PhotoStandListData:_getthepage_getthepage(p)
  if self.usageTag == "scene" or self.usageTag == "slide" then
    PhotoStandProxy.Instance:ServerCall_BoardRotateListPhotoCmd(p, self.npc)
  elseif self.usageTag == "mypost" then
    PhotoStandProxy.Instance:ServerCall_BoardMyListPhotoCmd(p)
  elseif self.usageTag == "theme" or self.usageTag == "theme_slide" then
    PhotoStandProxy.Instance:ServerCall_BoardListPhotoCmd(self.topic, p)
  end
end

function PhotoStandListData:TryFetchReqPages()
  for i = 1, #self.req_pages do
    local p = self.req_pages[i]
    if not self.pageAuxList[p].fetched then
      self:_getthepage_getthepage(p)
    end
  end
end

function PhotoStandListData:IsInited()
  return self.sum ~= nil
end

function PhotoStandListData:GetTheFxxkin_totalcount()
  if self:IsInited() then
    return
  end
  self:_getthepage_getthepage(0)
end

function PhotoStandListData:InitWithEmpty(sum)
  self.sum = sum
  self.pageCount = math.ceil(sum / PhotoStandProxy.ServerPageSize)
  self.briefList = {}
  self.pageAuxList = {}
  for i = 1, sum do
    table.insert(self.briefList, PhotoStandBriefData.new(i))
  end
  for i = 1, self.pageCount do
    table.insert(self.pageAuxList, PhotoStandPageAuxData.new(i, (i - 1) * PhotoStandProxy.ServerPageSize + 1, math.min(i * PhotoStandProxy.ServerPageSize, sum)))
  end
  if not self.curSpotPicIndex then
    self.curSpotPicIndex = 1
  end
end

function PhotoStandListData:UpdateListData(pageData)
  if self.sum ~= pageData.totalcount then
    local isConflict = self.sum ~= nil
    if isConflict then
      GameFacade.Instance:sendNotification(PhotoStandProxy.TEMP_Server.Alert_ServerConsoleChangedData)
      PhotoStandProxy.Instance:OnAlert_ServerConsoleChangedData()
    else
      self:InitWithEmpty(pageData.totalcount)
    end
    return
  end
  if self.sum <= 0 or self.sum == nil then
    return
  end
  local aux = self.pageAuxList[pageData.page]
  if not aux then
    redlog(string.format("PHOTOSTAND %s SERVER DATA ERROR: pageData.page = %s, self.pageCount = %s, pageData.totalcount = %s", self.usageTag, pageData.page, self.pageCount, pageData.totalcount))
    return
  end
  if pageData.lists and #pageData.lists == aux.e_idx - aux.s_idx + 1 then
    aux.fetched = true
    for i = 1, #pageData.lists do
      self.briefList[aux.s_idx - 1 + i]:Server_SetBaseData(pageData.lists[i])
    end
    if self.req_pages and next(self.req_pages) then
      for i = 1, #self.req_pages do
        if self.req_pages[i] == pageData.page then
          table.remove(self.req_pages, i)
          break
        end
      end
      if #self.req_pages == 0 then
        self:RefreshDownloadQueue()
      end
    end
  end
end

function PhotoStandListData:TryGetCurSpotPicData()
  return self.briefList and self.briefList[self.curSpotPicIndex] and self.briefList[self.curSpotPicIndex]:TryGetPicData()
end

function PhotoStandListData:RefreshDownloadQueue()
  self:ClearDownloadQueue()
  self:GenerateDownloadQueue()
end

function PhotoStandListData:ClearDownloadQueue()
  PhotoStandTestMe.Me():ClearRequest()
end

function PhotoStandListData:GenerateDownloadQueue()
  if self.dlWin[1] * self.dlWin[2] >= 0 then
    if self.dlWin[1] < 0 then
      for i = self.dlWin[2], self.dlWin[1], -1 do
        local s = self:_getRightIndex(self.curSpotPicIndex + i, self.sum)
        local s_pic = self.briefList[s]:TryGetPicData()
        if s_pic then
          s_pic:DownloadTex()
        else
          redlog("GenerateDownloadQueue Error", "Index " .. s .. " not found.")
        end
      end
    elseif self.dlWin[2] > 0 then
      for i = self.dlWin[1], self.dlWin[2] do
        local s = self:_getRightIndex(self.curSpotPicIndex + i, self.sum)
        local s_pic = self.briefList[s]:TryGetPicData()
        if s_pic then
          s_pic:DownloadTex()
        else
          redlog("GenerateDownloadQueue Error", "Index " .. s .. " not found.")
        end
      end
    else
      local s = self:_getRightIndex(self.curSpotPicIndex, self.sum)
      local s_pic = self.briefList[s]:TryGetPicData()
      if s_pic then
        s_pic:DownloadTex()
      else
        redlog("GenerateDownloadQueue Error", "Index " .. s .. " not found.")
      end
    end
  else
    local ll = math.abs(self.dlWin[1])
    local rl = self.dlWin[2]
    local maxh = math.max(ll, rl)
    for i = 0, maxh do
      if i <= rl then
        local r = self:_getRightIndex(self.curSpotPicIndex + i, self.sum)
        local r_pic = self.briefList[r]:TryGetPicData()
        if r_pic then
          r_pic:DownloadTex()
        else
          redlog("GenerateDownloadQueue Error", "Index " .. r .. " not found.")
        end
      end
      if i <= ll then
        local l = self:_getRightIndex(self.curSpotPicIndex - i, self.sum)
        local l_pic = self.briefList[l]:TryGetPicData()
        if l_pic then
          l_pic:DownloadTex()
        else
          redlog("GenerateDownloadQueue Error", "Index " .. l .. " not found.")
        end
      end
    end
  end
end
