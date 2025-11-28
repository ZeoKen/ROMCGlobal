PvpCustomRoomMemberData = class("PvpCustomRoomMemberData")

function PvpCustomRoomMemberData:ctor(data, teamtype)
  self:SetData(data)
  self.teamtype = teamtype
end

function PvpCustomRoomMemberData:SetData(data)
  if not data then
    return
  end
  self.id = data.charid
  self.charid = data.charid
  self.level = data.level
  self.name = data.name
  self.guildname = data.guildname
  self.guildportrait = data.guildportrait
  self.iscaptial = data.iscaptial
  self.index = data.index
  self.prepare = data.prepare
  if not self.portrait then
    self.portrait = HeadImageData.new()
  end
  self.portrait:TransByPortraitData(data.portrait)
end

function PvpCustomRoomMemberData:Clear()
  self.id = nil
  self.charid = nil
  self.level = nil
  self.name = nil
  self.guildname = nil
  self.guildportrait = nil
  self.iscaptial = nil
  self.index = nil
  self.portrait = nil
end
