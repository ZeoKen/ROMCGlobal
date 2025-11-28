PostProxy = class("PostProxy", pm.Proxy)
PostProxy.Instance = nil
PostProxy.NAME = "PostProxy"
autoImport("PostData")
autoImport("PackageMailData")
PostProxy.STATUS = {
  NEW = SessionMail_pb.EMAILSTATUS_NEW,
  ATTACH = SessionMail_pb.EMAILSTATUS_ATTACH,
  READ = SessionMail_pb.EMAILSTATUS_READ
}
PostProxy.PACKAGE_STATUS = {
  NEW = SceneItem_pb.EPACKMAILSTATUS_NEW,
  READ = SceneItem_pb.EPACKMAILSTATUS_READ
}

function PostProxy:ctor(proxyName, data)
  self.proxyName = proxyName or PostProxy.NAME
  if PostProxy.Instance == nil then
    PostProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self.postDatas = {}
  self.multiChoosePost = {}
  self:InitLastDayMailSingleDepositMap()
  self.track_mail_ids = {}
  self:InitTrackMailIds(GameConfig.PostTrackMailIds or {})
end

function PostProxy.GetOvertime()
  if not PostProxy.overTime then
    PostProxy.overTime = GameConfig.System.sysmail_overtime * 24 * 60 * 60
  end
  return PostProxy.overTime
end

function PostProxy:IsExpire(mail_id)
  local data = self.postDatas[mail_id]
  if data then
    local defaultSeconds = PostProxy.GetOvertime()
    local leftTime = 0
    if data.expiretime == 0 then
      leftTime = data.time + defaultSeconds - ServerTime.CurServerTime() / 1000
    else
      leftTime = data.expiretime - ServerTime.CurServerTime() / 1000
    end
    return leftTime <= 0, leftTime
  end
  return true
end

function PostProxy:InitLastDayMailSingleDepositMap()
  self.lastDayMailSingleDepositMap = {}
  local id
  for _, data in pairs(Table_Deposit) do
    id = data.DailyMail.LastDailyId
    if id then
      self.lastDayMailSingleDepositMap[id] = data.id
    end
  end
  self.packageMailCount = 0
  self.mailCount = 0
end

function PostProxy:AddUpdatePostDatas(mailDatas, isPack)
  local updateNum = 0
  for i = 1, #mailDatas do
    local mailData = mailDatas[i]
    if mailData and mailData.id then
      local postData = self.postDatas[mailData.id]
      if not postData then
        if isPack then
          postData = PackageMailData.new(mailData)
          self.packageMailCount = self.packageMailCount + 1
        else
          postData = PostData.new(mailData)
          self.mailCount = self.mailCount + 1
        end
        self.postDatas[mailData.id] = postData
        GameFacade.Instance:sendNotification(PostEvent.PostAdd)
      else
        updateNum = updateNum + 1
        postData:SetData(mailData)
      end
    end
  end
  if 0 < updateNum then
    local sort = 1 < updateNum
    GameFacade.Instance:sendNotification(PostEvent.PostUpdate, sort)
  end
end

function PostProxy:RemovePostData(deletes)
  for i = 1, #deletes do
    local id = deletes[i]
    if self.postDatas[id] then
      if self.postDatas[id].isPackageMail then
        self.packageMailCount = self.packageMailCount - 1
      else
        self.mailCount = self.mailCount - 1
      end
      self.postDatas[id] = nil
    end
  end
  if 0 < #deletes then
    GameFacade.Instance:sendNotification(PostEvent.PostDelete)
  end
end

function PostProxy:GetMailCount()
  return self.mailCount, self.packageMailCount
end

function PostProxy:GetNewPost()
  local unreadPost = {}
  for k, v in pairs(self.postDatas) do
    if true == v.unread then
      unreadPost[#unreadPost + 1] = v
    end
  end
  return unreadPost
end

function PostProxy:ReadyChooseAllPost()
  self:ResetMultiChoosePosts()
  for k, v in pairs(self.postDatas) do
    self:SetMultiChoosePosts(k)
  end
end

function PostProxy:SetMultiChoosePosts(id)
  if 0 == TableUtility.ArrayRemove(self.multiChoosePost, id) then
    self.multiChoosePost[#self.multiChoosePost + 1] = id
  end
end

function PostProxy:GetMultiChoosePost()
  local unAttachNum = 0
  for i = 1, #self.multiChoosePost do
    local cellData = self.postDatas[self.multiChoosePost[i]]
    if cellData and cellData:HasPostItems() and cellData.status ~= PostProxy.STATUS.ATTACH then
      unAttachNum = unAttachNum + 1
    end
  end
  return self.multiChoosePost, unAttachNum
end

function PostProxy:ResetMultiChoosePosts()
  TableUtility.ArrayClear(self.multiChoosePost)
end

function PostProxy:RemovePosts()
  ServiceSessionMailProxy.Instance:CallMailRemove(self.multiChoosePost)
end

function PostProxy:CheckAllReceived()
  for k, v in pairs(self.postDatas) do
    if v:HasPostItems() then
      if v.status ~= PostProxy.STATUS.ATTACH then
        return false
      end
    else
      local realAttach = v.status == PostProxy.STATUS.ATTACH or v.status == PostProxy.STATUS.READ
      if not realAttach then
        return false
      end
    end
  end
  return true
end

local filterCFG = GameConfig.PostFilter
local postFilter = {}

function PostProxy:GetFilter()
  TableUtility.ArrayClear(postFilter)
  for k, v in pairs(filterCFG) do
    table.insert(postFilter, k)
  end
  return postFilter
end

function PostProxy:GetPostArray()
  local result = {}
  for k, v in pairs(self.postDatas) do
    result[#result + 1] = v
  end
  table.sort(result, function(l, r)
    return l.time > r.time
  end)
  return result
end

function PostProxy:HandlePostUpdate(updates, dels, packMail)
  self:AddUpdatePostDatas(updates, packMail)
  self:RemovePostData(dels)
  GameFacade.Instance:sendNotification(ServiceEvent.SessionMailMailUpdate)
end

function PostProxy:SetFilterData()
  local result = {}
  for k, v in pairs(GameConfig.PostFilter) do
    local data = {}
    for _, cell in pairs(self.postDatas) do
      if k == cell.FilterIndex then
        table.insert(data, cell)
      end
    end
    result[k] = data
  end
  return result
end

function PostProxy:GetAttachPost()
  local data = {}
  for _, cell in pairs(self.postDatas) do
    if cell:IsAttachStatus() then
      data[#data + 1] = cell
    end
  end
  return data
end

local priorityCFG = GameConfig.PostDelPriority or {
  3,
  4,
  0
}

function PostProxy:GetDelModelPriorityData()
  local data = self:SetFilterData()
  for i = 1, #priorityCFG do
    if data[priorityCFG[i]] and 0 < #data[priorityCFG[i]] then
      return data[priorityCFG[i]], priorityCFG[i]
    end
  end
  return self:GetPostArray(), 0
end

PostProxy.PostTrackEvent = {
  STAY_TIME = "",
  CLICK_URL_COUNT = "",
  UNREAD_RECEIVE_COUNT = ""
}

function PostProxy:InitTrackMailIds(serverData)
  TableUtility.ArrayClear(self.track_mail_ids)
  for _, v in pairs(serverData) do
    TableUtility.ArrayPushBack(self.track_mail_ids, v)
  end
end
