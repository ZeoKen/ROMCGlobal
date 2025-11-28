GvgStatueInfo = class("GvgStatueInfo")

function GvgStatueInfo:ctor(data)
  self:Update(data)
end

function GvgStatueInfo:Update(data)
  self:UpdateAvatar(data)
  if not StringUtil.IsEmpty(data.guildname) then
    self.guildname = data.guildname
  end
  if not StringUtil.IsEmpty(data.leadername) then
    self.leadername = data.leadername
  end
  if data.leaderid then
    self.leaderid = data.leaderid
  end
  local pose = data.pose
  if pose then
    self:UpdatePose(pose)
  end
end

function GvgStatueInfo:UpdateAvatar(data)
  if data.body then
    self.body = data.body
  end
  if data.hair then
    self.hair = data.hair
  end
  if data.head then
    self.head = data.head
  end
  if data.face then
    self.face = data.face
  end
  if data.eye then
    self.eye = data.eye
  end
  if data.mouth then
    self.mouth = data.mouth
  end
  if data.back then
    self.back = data.back
  end
  if data.tail then
    self.tail = data.tail
  end
end

function GvgStatueInfo:IsEmpty()
  return not self.leaderid or self.leaderid == 0
end

function GvgStatueInfo:GetPose()
  return self.pose
end

function GvgStatueInfo:UpdatePose(ser_pos)
  self.pose = ser_pos
end

function GvgStatueInfo:GetGuildName()
  return self.guildname
end

function GvgStatueInfo:GetLeaderId()
  return self.leaderid
end

function GvgStatueInfo:GetLeaderName()
  return self.leadername
end
