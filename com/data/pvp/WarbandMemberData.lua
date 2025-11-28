WarbandMemberData = class("WarbandMemberData")

function WarbandMemberData:ctor(data)
  self:SetData(data)
end

function WarbandMemberData:SetData(data)
  if data then
    self.data = data
    if data.charid then
      self.id = data.charid
    end
    if data.level then
      self.level = data.level
    end
    if data.name then
      self.name = data.name
    end
    if data.guildname then
      self.guildName = data.guildname
    end
    if data.profession then
      self.profession = data.profession
    end
    if nil ~= data.iscaptial then
      self.isCaptial = data.iscaptial
    end
    if self.isCaptial then
      self.prepare = true
    else
      self.prepare = data.prepare
    end
    if nil ~= data.isoffline then
      self.isoffline = data.isoffline
    end
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
    end
  end
end

function WarbandMemberData:IsMe()
  return self.id == Game.Myself.data.id
end

function WarbandMemberData:IsOffline()
  return self.isoffline and self.isoffline == true
end

function WarbandMemberData:Exit()
end
