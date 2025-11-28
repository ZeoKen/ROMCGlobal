autoImport("WarbandMemberData")
WarbandTeamData = class("WarbandTeamData")
local _sortMemFunc = function(l, r)
  if nil == l or nil == b then
    return false
  end
  if l.id == Game.Myself.data.id then
    return true
  end
  if l.level ~= r.level then
    return l.level < r.level
  end
  if l.id ~= r.id then
    return l.id < r.id
  end
  return false
end

function WarbandTeamData:ctor(data, proxy)
  self.proxy = proxy or WarbandProxy.Instance
  if data then
    self.id = data.guid
    self.rank = data.rank
    self.name = data.bandname
    self.score = data.score
    self.membersMap = {}
    self.memberArray = {}
    local portrait = data.portrait
    if portrait then
      self.portrait = portrait.portrait
      self.bodyID = portrait.body
      self.hairID = portrait.hair
      self.haircolor = portrait.haircolor
      self.gender = portrait.gender
      self.headID = portrait.head
      self.faceID = portrait.face
      self.mouthID = portrait.mouth
      self.eyeID = portrait.eye
      self.portrait_frame = portrait.portrait_frame
      self.profession = data.profession
    end
  end
end

function WarbandTeamData:IsMyWarband()
  return self.id == self.proxy:GetMyWarbandID()
end

function WarbandTeamData:UpdateMembers(datas)
  self:_clearMember()
  for i = 1, #datas do
    self:UpdateMember(datas[i])
  end
end

function WarbandTeamData:UpdateMember(data)
  data.proxy = self.proxy
  local member = self:GetMemberByGuid(data.charid)
  if not member then
    self:AddMember(data)
  else
    member:SetData(data)
  end
end

function WarbandTeamData:AddMember(data)
  if data and data.charid then
    self._dirty = true
    local new = WarbandMemberData.new(data)
    self.membersMap[data.charid] = new
    if not self.memberNum then
      self.memberNum = 1
    else
      self.memberNum = self.memberNum + 1
    end
    redlog("添加一个队员：charid memberNum:  ", data.charid, self.memberNum)
    return new
  end
end

function WarbandTeamData:RemoveMembers(dels)
  if dels then
    for i = 1, #dels do
      self:RemoveMember(dels[i])
    end
  end
end

function WarbandTeamData:RemoveMember(guid)
  local member = self:GetMemberByGuid(guid)
  if member then
    self._dirty = true
    self.membersMap[guid] = nil
    redlog("删除了队员 guid: ", guid)
    self.memberNum = self.memberNum - 1
  end
  return member
end

function WarbandTeamData:GetMemberByGuid(guid)
  return self.membersMap[guid]
end

function WarbandTeamData:_clearMember()
  for k, member in pairs(self.membersMap) do
    member:Exit()
    self.membersMap[k] = nil
  end
  TableUtility.ArrayClear(self.memberArray)
end

function WarbandTeamData:GetMembers()
  if self._dirty then
    self._dirty = false
    TableUtility.ArrayClear(self.memberArray)
    for _, v in pairs(self.membersMap) do
      self.memberArray[#self.memberArray + 1] = v
    end
    table.sort(self.memberArray, _sortMemFunc)
  end
  return self.memberArray
end

function WarbandTeamData:GetLeader()
  for _, v in pairs(self.membersMap) do
    if v.isCaptial then
      return v
    end
  end
end

function WarbandTeamData:GetName()
  return self.name or ""
end

function WarbandTeamData:Exit()
  self:_clearMember()
  self.memberNum = nil
end

function WarbandTeamData:GetTeamScore()
  return self.score or 0
end
