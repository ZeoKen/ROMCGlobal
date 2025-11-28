autoImport("PlayerFaceCell")
local BaseCell = autoImport("BaseCell")
MemberSelectCell = class("MemberSelectCell", BaseCell)

function MemberSelectCell:Init()
  MemberSelectCell.super.Init(self)
  self.teamHead = PlayerFaceCell.new(self:FindGO("PlayerHead"))
  self.teamHead:AddIconEvent()
  self.teamHead:SetMinDepth(40)
  self.teamHead:SetHeadIconPos(false)
  self.headData = HeadImageData.new()
  self:AddCellClickEvent()
end

function MemberSelectCell:SetData(data)
  self.data = data
  local haveData = data ~= nil
  if self.isActive ~= haveData then
    self.gameObject:SetActive(haveData)
    self.isActive = haveData
  end
  if not haveData then
    return
  end
  if self.id == data.id then
    local curHp = 1
    if data.hp and data.hpmax then
      curHp = data.hp / data.hpmax
    end
    if self.hp ~= curHp then
      self.teamHead:UpdateHp(curHp)
      self.hp = curHp
    end
    local curMp = 1
    if data.sp and data.spmax then
      curMp = data.sp / data.spmax
    end
    if self.mp ~= curMp then
      self.teamHead:UpdateMp(curMp)
      self.mp = curMp
    end
    if self.lv ~= data.baselv then
      self.teamHead.level.text = data.baselv
      self.lv = data.baselv
    end
    if self.job ~= data.job or self.groupTeamIndex ~= data.groupTeamIndex then
      self.job = data.job
      self.groupTeamIndex = data.groupTeamIndex
      self.teamHead:SetTeamLeaderSymbol(self.job, self.groupTeamIndex == 1)
    end
    if self.offline ~= data:IsOffline() then
      self.offline = data:IsOffline()
      if self.teamHead.data then
        self.teamHead.data.offline = self.offline
      end
      if AfkProxy.ParseIsAfk(self.teamHead.data and self.teamHead.data.afk) then
        self.teamHead:SetGoNormalMP()
      elseif self.offline == true then
        self.teamHead:SetGoGreyMP()
      elseif (data.expiretime and data.expiretime ~= 0) ~= true then
        self.teamHead:SetGoNormalMP()
      end
      self.teamHead:SetTeamLeaderSymbol(self.job, self.groupTeamIndex == 1)
    end
  else
    self.id = data.id
    self.headData:Reset()
    self.headData:TransByTeamMemberData(data)
    self.hp = self.headData.hp
    self.mp = self.headData.mp
    self.job = self.headData.job
    self.groupTeamIndex = self.headData.groupTeamIndex
    self.lv = self.headData.level
    self.offline = self.headData.offline
    self.teamHead:SetData(self.headData)
    self.teamHead.level.text = self.lv
  end
end

function MemberSelectCell:OnRemove()
  self.teamHead:RemoveIconEvent()
end
