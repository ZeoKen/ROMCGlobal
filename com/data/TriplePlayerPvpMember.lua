TriplePlayerPvpMember = class("TriplePlayerPvpMember")

function TriplePlayerPvpMember:ctor(data, index, camp)
  local user = data.user
  self.index = index
  self.camp = camp
  self.name = user.name
  self.charid = user.charid
  self.isMyself = self.charid == Game.Myself.data.id
  self.userData = UserData.CreateAsTable()
  self:ResetData(user, data.offline, data.choose_profession)
end

function TriplePlayerPvpMember:ResetData(user, offline, choose_profession)
  self.offline = offline
  self.choose_profession = choose_profession
  if user.datas then
    for i = 1, #user.datas do
      local sdata = user.datas[i]
      if sdata then
        self.userData:SetByID(sdata.type, sdata.value, sdata.data)
      end
    end
  end
  if self:IsChoosen() and self.isMyself then
    TriplePlayerPvpProxy.Instance:SetMyselfChooseFlag(true)
  end
end

function TriplePlayerPvpMember:IsChoosen()
  return nil ~= self.choose_profession and self.choose_profession > 0
end

function TriplePlayerPvpMember:GetName()
  local anonymous = self.userData:Get(UDEnum.ANONYMOUS) or 0
  if anonymous ~= 0 then
    local pro = self.userData:Get(UDEnum.PROFESSION)
    return FunctionAnonymous.Me():GetAnonymousName(pro)
  end
  return self.name
end

function TriplePlayerPvpMember:GetUserData()
  return self.userData
end

function TriplePlayerPvpMember:GetLv()
  return self.userData:Get(UDEnum.ROLELEVEL) or 0
end

function TriplePlayerPvpMember:GetChoosenPro()
  if self:IsChoosen() then
    return self.choose_profession
  end
  return nil
end

function TriplePlayerPvpMember:GetPro()
  return self.userData:Get(UDEnum.PROFESSION) or 0
end

function TriplePlayerPvpMember:IsOffline()
  return self.offline == true
end

function TriplePlayerPvpMember:OnRemove()
  if self.userData and self.userData:Alive() then
    self.userData:Destroy()
  end
end

function TriplePlayerPvpMember:SetViewIndex(i)
  self.view_index = i
end

function TriplePlayerPvpMember:GetIndex()
  return self.view_index or self.index
end
