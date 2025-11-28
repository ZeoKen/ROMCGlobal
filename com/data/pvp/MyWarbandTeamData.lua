autoImport("WarbandTeamData")
MyWarbandTeamData = class("MyWarbandTeamData", WarbandTeamData)
MyWarbandTeamData.EMPTY = "EMPTY"
local MAX_MEMBER_NUM = 12

function MyWarbandTeamData:ctor(data, proxy)
  self.proxy = proxy
  self.membersMap = {}
  self.memberArray = {}
  self.viewMembers = {}
  MAX_MEMBER_NUM = proxy and proxy:GetMinSignupMemberCount() or 12
  self:Update(data)
end

function MyWarbandTeamData:Update(data)
  self.id = data.guid
  self.name = data.warbandname
  self.signup = data.signup
  self.score = data.score
  self:UpdateMembers(data.memberinfo)
  self:RemoveMembers(data.delmembers)
end

function MyWarbandTeamData:IsSignUp()
  return self.signup
end

function MyWarbandTeamData:UpdateMembers(datas)
  if datas then
    for i = 1, #datas do
      datas[i].proxy = self.proxy
      self:UpdateMember(datas[i])
    end
  end
end

function MyWarbandTeamData:UpdateMember(data)
  data.proxy = self.proxy
  local member = self:GetMemberByGuid(data.charid)
  if not member then
    self:AddMember(data)
  else
    member:SetData(data)
  end
end

local mem

function MyWarbandTeamData:CheckMatchValid(enterLv)
  mem = self:GetMembers()
  for i = 1, #mem do
    if enterLv > mem[i].level then
      MsgManager.ShowMsgByID(7305, enterLv)
      return
    end
  end
  return true
end

function MyWarbandTeamData:CheckAllPrepared()
  mem = self:GetMembers()
  for i = 1, #mem do
    if not mem[i].prepare then
      return false
    end
  end
  return true
end

function MyWarbandTeamData:CheckAllReady()
  if not self:CheckAllPrepared() then
    return false
  end
  return true
end

function MyWarbandTeamData:IsFull()
  return self.memberNum and MAX_MEMBER_NUM <= self.memberNum
end

function MyWarbandTeamData:GetViewMembers()
  local data = self:GetMembers()
  TableUtility.ArrayClear(self.viewMembers)
  for i = 1, #data do
    self.viewMembers[#self.viewMembers + 1] = data[i]
  end
  local emptyCount = MAX_MEMBER_NUM - #data
  if 0 < emptyCount then
    for i = 1, emptyCount do
      self.viewMembers[#self.viewMembers + 1] = MyWarbandTeamData.EMPTY
    end
  end
  return self.viewMembers
end

function MyWarbandTeamData:GetTeamName()
  return self.name
end

function MyWarbandTeamData:GetLeaderName()
  local leader = self:GetLeader()
  return leader and leader.name or ""
end

function MyWarbandTeamData:CanSignUp()
end
