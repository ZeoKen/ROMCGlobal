local _MaxIndex = 3
autoImport("TriplePlayerPvpMember")
TriplePlayerPvpData = class("TriplePlayerPvpData")
TriplePlayerPvpData.EmptyMember = 0

function TriplePlayerPvpData:ctor(data, myTeam)
  self.camp = data.ecamp
  self.isMyteam = myTeam == true
  self:InitMember()
  self:UpdateMember(data)
end

function TriplePlayerPvpData:InitMember()
  self.memberMap = {}
  for i = 1, _MaxIndex do
    self.memberMap[i] = TriplePlayerPvpData.EmptyMember
  end
  self.myMemberMap = {}
end

function TriplePlayerPvpData:IsEmpty(index)
  return self.memberMap[index] == TriplePlayerPvpData.EmptyMember
end

function TriplePlayerPvpData:UpdateMember(data)
  if data.userinfos then
    for i = 1, #data.userinfos do
      local index = data.userinfos[i].index
      if self:IsEmpty(index) then
        self.memberMap[index] = TriplePlayerPvpMember.new(data.userinfos[i], index, self.camp, data.userinfos[i].offline)
      else
        self.memberMap[index]:ResetData(data.userinfos[i].user, data.userinfos[i].offline, data.userinfos[i].choose_profession)
      end
      if self.memberMap[index].isMyself then
        self.realIndex = index
      end
    end
  end
end

function TriplePlayerPvpData:GetMembers()
  if not (self.isMyteam and self.realIndex) or self.realIndex == TriplePlayerPvpProxy.Instance.myselfIndex then
    return self.memberMap
  else
    return self:getMyMembers()
  end
end

local swapIndexMap = {
  [1] = {
    [1] = 2,
    [2] = 1,
    [3] = 3
  },
  [3] = {
    [3] = 2,
    [2] = 3,
    [1] = 1
  }
}

function TriplePlayerPvpData:getMyMembers()
  local swapIndex = swapIndexMap[self.realIndex]
  if swapIndex then
    for k, swap_k in pairs(swapIndex) do
      self.myMemberMap[k] = self.memberMap[swap_k]
      self.memberMap[swap_k]:SetViewIndex(k)
    end
  end
  return self.myMemberMap
end

function TriplePlayerPvpData:OnRemove()
  for _, v in pairs(self.memberMap) do
    if v.__cname == "TriplePlayerPvpMember" then
      v:OnRemove()
    end
  end
  for _, v in pairs(self.myMemberMap) do
    if v.__cname == "TriplePlayerPvpMember" then
      v:OnRemove()
    end
  end
end
