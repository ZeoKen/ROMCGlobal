TeamRecruitData = class("TeamRecruitData")

function TeamRecruitData:ctor(recruitData)
  self:SetData(recruitData)
end

function TeamRecruitData:SetData(recruitData)
  if not recruitData then
    return
  end
  self.name = recruitData.launch_name
  self.raidname = recruitData.activity_name
  self.zoneid = recruitData.zoneid
  self.realzoneid = recruitData.realzoneid
  self.serverid = recruitData.serverid
  self.memberNum = recruitData.owner_count
  self.fullMemberNum = recruitData.max_count
  redlog("TeamRecruitData:SetData name=" .. tostring(self.name), "raidname=" .. tostring(self.raidname))
end

function TeamRecruitData:GetMemberNum()
  return self.memberNum
end

function TeamRecruitData:GetFullMemberNum()
  return self.fullMemberNum
end
