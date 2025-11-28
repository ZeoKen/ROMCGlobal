autoImport("TeamData")
RecruitTeamData = class("RecruitTeamData", TeamData)
local autoDestroyTime = 300

function RecruitTeamData:ctor(recruitTeamData, chat)
  RecruitTeamData.super.ctor(self, recruitTeamData)
  self.createTime = ServerTime.CurServerTime()
  self.publisher = ChatMessageData.CreateAsArray(chat)
end

function RecruitTeamData:SetData(recruitTeamData)
  RecruitTeamData.super.SetData(self, recruitTeamData.data)
  self.version_time = recruitTeamData.version_time
end

function RecruitTeamData:GetCellType()
  local publisherId = self:GetId()
  if publisherId == Game.Myself.data.id then
    return ChatTypeEnum.MyselfRecruit
  end
  return ChatTypeEnum.SomeoneRecruit
end

function RecruitTeamData:CanDestroy()
  if self.createTime then
    local duration = (ServerTime.CurServerTime() - self.createTime) / 1000
    return duration > autoDestroyTime
  end
  return false
end

function RecruitTeamData:GetId()
  return self.publisher:GetId()
end

function RecruitTeamData:GetName()
  return self.publisher:GetName()
end

function RecruitTeamData:GetAppellation()
  return self.publisher:GetAppellation()
end

function RecruitTeamData:GetPortrait()
  return self.publisher:GetPortrait()
end

function RecruitTeamData:GetPortraitFrame()
  return self.publisher:GetPortraitFrame()
end

function RecruitTeamData:GetHair()
  return self.publisher:GetHair()
end

function RecruitTeamData:GetHaircolor()
  return self.publisher:GetHaircolor()
end

function RecruitTeamData:GetBody()
  return self.publisher:GetBody()
end

function RecruitTeamData:GetHead()
  return self.publisher:GetHead()
end

function RecruitTeamData:GetFace()
  return self.publisher:GetFace()
end

function RecruitTeamData:GetMouth()
  return self.publisher:GetMouth()
end

function RecruitTeamData:GetEye()
  return self.publisher:GetEye()
end

function RecruitTeamData:GetGender()
  return self.publisher:GetGender()
end

function RecruitTeamData:GetBlink()
  return self.publisher:GetBlink()
end

function RecruitTeamData:GetLevel()
  return self.publisher:GetLevel()
end

function RecruitTeamData:GetGuildname()
  return self.publisher:GetGuildname()
end

function RecruitTeamData:GetZoneId()
  return self.publisher:GetZoneId()
end

function RecruitTeamData:GetServerId()
  return self.publisher:GetServerId()
end

function RecruitTeamData:GetHomeId()
  return self.publisher:GetHomeId()
end

function RecruitTeamData:GetAccId()
  return self.publisher:GetAccId()
end

function RecruitTeamData:GetProfession()
  return self.publisher:GetProfession()
end

function RecruitTeamData:GetStr(isStripSymbols)
  return self.publisher:GetStr(isStripSymbols)
end
