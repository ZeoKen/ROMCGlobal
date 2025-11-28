PackageMailData = class("PackageMailData")
local _config_expiretime = GameConfig.PackMail and GameConfig.PackMail.expire_time or 86400

function PackageMailData:ctor(PackMailData)
  self:SetData(PackMailData)
end

local _StatusTrans = {
  [SceneItem_pb.EPACKMAILSTATUS_NEW] = SessionMail_pb.EMAILSTATUS_NEW,
  [SceneItem_pb.EPACKMAILSTATUS_READ] = SessionMail_pb.EMAILSTATUS_READ
}

function PackageMailData:SetData(data)
  if data then
    self.id = data.id
    self.emailPackageType = data.type
    self.status = _StatusTrans[data.status]
    self.title = data.title
    self.sendername = data.sender
    self.msg = data.msg
    self.time = data.sendtime
    self.sendtime = data.sendtime
    self.expiretime = data.sendtime + _config_expiretime
    self:SetAttach(data.items)
    self.unread = data.status == PostProxy.PACKAGE_STATUS.NEW
    self.isPackageMail = true
    self:SetFilterData()
    self:SetSortID()
  end
end

function PackageMailData:SetFilterData()
  self.FilterIndex = self.unread and SessionMail_pb.EMAILSTATUS_MIN or SessionMail_pb.EMAILSTATUS_READ
end

function PackageMailData:IsMultiChoosenPost()
  local posts = PostProxy.Instance:GetMultiChoosePost()
  return TableUtility.ArrayFindIndex(posts, self.id) ~= 0
end

function PackageMailData:HasPostItems()
  return #self.postItems > 0
end

function PackageMailData:CheckAttachValid()
  return self:HasPostItems()
end

function PackageMailData:IsAttachStatus()
  return false
end

function PackageMailData:IsRealAttach()
  return false
end

function PackageMailData:IsVirtualAttach()
  return false
end

function PackageMailData:SetSortID()
  if self.unread and self:HasPostItems() then
    self.sortID = 1
  elseif self:CheckAttachValid() then
    self.sortID = 3
  else
    self.sortID = 4
  end
end

function PackageMailData:SetAttach(items)
  self.postItems = {}
  for i = 1, #items do
    local tempItem = ItemData.new()
    tempItem:ParseFromServerData(items[i])
    tempItem.attach = false
    table.insert(self.postItems, tempItem)
  end
end
