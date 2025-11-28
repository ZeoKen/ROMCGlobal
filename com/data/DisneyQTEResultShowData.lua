DisneyQTEResultShowData = class("DisneyQTEResultShowData")

function DisneyQTEResultShowData:ctor(type, data, rank)
  if type == 0 then
    self:CreateByServerData(data.showdata, data.point, data.combo, rank)
  elseif type == 1 then
    self:CreateBySelf(data.point, data.combo, rank)
  end
end

function DisneyQTEResultShowData:CreateByServerData(modelData, score, combo, rank)
  if not modelData then
    return
  end
  self.rank = rank
  self.score = score or 0
  self.combo = combo or 0
  self.guid = modelData.charid
  self.name = modelData.name
  self.guildid = modelData.guildid
  self.guildname = modelData.guildname
  self.gender = modelData.gender
  self.profession = modelData.profession
  self.level = modelData.level
  self.hairID = modelData.hair
  self.haircolor = modelData.haircolor
  self.bodyID = modelData.body
  self.eyeID = modelData.eye
  self.clothcolor = modelData.clothcolor
  self.headID = modelData.head
  self.back = modelData.back
  self.faceID = modelData.face
  self.tail = modelData.tail
  self.mount = modelData.mount
  self.mouthID = modelData.mouth
  self.lefthand = modelData.lefthand
  self.righthand = modelData.righthand
  self.headIconData = nil
  self.fullBodyData = nil
end

function DisneyQTEResultShowData:CreateBySelf(score, combo, rank)
  self.rank = rank
  self.score = score or DisneyProxy.Instance.myselfScore
  self.combo = combo or DisneyProxy.Instance.myselfCombo
  self.guid = Game.Myself.data.id
  self.name = Game.Myself.data.name
  local userdata = Game.Myself.data.userdata
  self.level = userdata:Get(UDEnum.ROLELEVEL)
  self.bodyID = userdata:Get(UDEnum.BODY)
  self.hairID = userdata:Get(UDEnum.HAIR)
  self.eyeID = userdata:Get(UDEnum.EYE)
  self.mouthID = userdata:Get(UDEnum.MOUTH)
  self.profession = userdata:Get(UDEnum.PROFESSION)
  self.lefthand = userdata:Get(UDEnum.LEFTHAND)
  self.righthand = userdata:Get(UDEnum.RIGHTHAND)
  self.gender = userdata:Get(UDEnum.SEX)
  self.haircolor = userdata:Get(UDEnum.HAIRCOLOR)
  self.eyecolor = userdata:Get(UDEnum.EYECOLOR)
  self.clothcolor = userdata:Get(UDEnum.CLOTHCOLOR)
  self.headID = userdata:Get(UDEnum.HEAD)
  self.faceID = userdata:Get(UDEnum.FACE)
  self.back = userdata:Get(UDEnum.BACK)
  self.tail = userdata:Get(UDEnum.TAIL)
  local guildData = GuildProxy.Instance.myGuildData
  self.guildname = guildData and guildData.name
  self.guildportrait = guildData and guildData.portrait
end
