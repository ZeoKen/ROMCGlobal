BattlePassRankShowData = class("BattlePassRankShowData")

function BattlePassRankShowData:ctor(type, data, rank)
  if type == 0 then
    self:CreateByServerData(data.showdata, data.level, rank)
  elseif type == 1 then
    self:CreateBySelf(rank)
  elseif type == 2 then
    self:CreateBySocialData(data, rank)
  end
end

function BattlePassRankShowData:CreateByServerData(modelData, bplevel, rank)
  if not modelData then
    return
  end
  self.rank = rank
  self.bplevel = bplevel or 1
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
  self.portrait = modelData.portrait
  self.headIconData = nil
  self.fullBodyData = nil
end

function BattlePassRankShowData:CreateBySelf(rank)
  self.rank = rank
  self.bplevel = BattlePassProxy.BPLevel()
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
  self.portrait = userdata:Get(UDEnum.PORTRAIT)
  self.headID = userdata:Get(UDEnum.HEAD)
  self.faceID = userdata:Get(UDEnum.FACE)
  self.back = userdata:Get(UDEnum.BACK)
  self.tail = userdata:Get(UDEnum.TAIL)
  local guildData = GuildProxy.Instance.myGuildData
  self.guildname = guildData and guildData.name
  self.guildportrait = guildData and guildData.portrait
end

function BattlePassRankShowData:CreateBySocialData(socialData, rank)
  if not socialData then
    return
  end
  self.rank = rank
  self.guid = socialData.guid
  self.level = socialData.level
  self.frame = socialData.frame
  self.hairID = socialData.hairID or 0
  self.haircolor = socialData.haircolor or 0
  self.bodyID = socialData.bodyID or 0
  self.headID = socialData.headID or 0
  self.faceID = socialData.faceID or 0
  self.mouthID = socialData.mouthID or 0
  self.eyeID = socialData.eyeID or 0
  self.profession = socialData.profession
  self.eyecolor = socialData.eyecolor or 0
  self.clothcolor = socialData.clothcolor or 0
  self.gender = socialData.gender
  self.blink = socialData.blink
  self.name = socialData.name
  self.guildname = socialData.guildname
  self.guildportrait = socialData.guildportrait
  if socialData.battlepass_lv then
    local version = math.floor(socialData.battlepass_lv / 10000)
    local bplevel = socialData.battlepass_lv % 10000
    if version == BattlePassProxy.Instance.currentVersion then
      self.bplevel = bplevel
    else
      self.bplevel = 1
    end
  else
    self.bplevel = 1
  end
end
