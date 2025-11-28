TwelvePVPDetailData = class("TwelvePVPDetailData")

function TwelvePVPDetailData:ctor(camp, serverdata)
  if not serverdata then
    return
  end
  self.guid = serverdata.charid
  self.campid = camp or 1
  self.profession = serverdata.profession
  self.name = serverdata.name or ""
  self.kill = serverdata.killnum or 0
  self.death = serverdata.dienum or 0
  self.heal = serverdata.heal or 0
  self.gold = serverdata.gold or 0
  self.exp = serverdata.crystal_exp or 0
  self.push = serverdata.push_time or 0
  self.mvp = serverdata.kill_mvp or 0
  self.hideName = serverdata.hidename
end

function TwelvePVPDetailData:Update(data)
  if nil ~= data.name then
    self.name = data.name
  end
  if nil ~= data.killnum then
    self.kill = data.killnum
  end
  if nil ~= data.dienum then
    self.death = data.dienum
  end
  if nil ~= data.heal then
    self.heal = data.heal
  end
  if nil ~= data.gold then
    self.gold = data.gold
  end
  if nil ~= data.crystal_exp then
    self.exp = data.crystal_exp
  end
  if nil ~= data.push_time then
    self.push = data.push_time
  end
  if nil ~= data.kill_mvp then
    self.mvp = data.kill_mvp
  end
  self.hideName = data.hidename
end

function TwelvePVPDetailData:GetName()
  if self.hideName then
    return FunctionAnonymous.Me():GetAnonymousName(self.profession)
  end
  return self.name
end
