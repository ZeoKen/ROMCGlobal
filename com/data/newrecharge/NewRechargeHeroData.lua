NewRechargeHeroData = class("NewRechargeHeroData")
local _Table_Class = Table_Class
local _Table_Item
local _GameConfigHeroShop = GameConfig.HeroShop and GameConfig.HeroShop.Items
local hero_ticket_id = GameConfig.Profession.hero_ticket_id
local hero_ticket_price = GameConfig.Profession.hero_ticket_price

function NewRechargeHeroData:ctor(branchId)
  self.branchId = branchId
  if _Table_Item == nil then
    _Table_Item = Table_Item
  end
  self:UpdateSData()
end

function NewRechargeHeroData:UpdateSData()
  local gameConfig = _GameConfigHeroShop[self.branchId]
  self.classid = gameConfig.profession
  local classData = _Table_Class[self.classid]
  if not classData then
    return
  end
  self.classname = classData.NameZh
  self.classicon = classData.icon
  self.classdesc = classData.Desc
  self.teamfunction = classData.TeamFunction and classData.TeamFunction.default or nil
  self.newdate = EnvChannel.IsTFBranch() and gameConfig.tfnewdate or gameConfig.newdate
  self.getdate = EnvChannel.IsTFBranch() and gameConfig.tfgetdate or gameConfig.getdate
  self.bgm = gameConfig.bgm
  self.addway = gameConfig.addway
  self.helpid = gameConfig.helpid
  self.costid = hero_ticket_id
  self.costicon = _Table_Item[hero_ticket_id].Icon
  self.costprice = hero_ticket_price
  self.heropic = gameConfig.heropic
  self.video = gameConfig.video
  self.reward = gameConfig.reward
  self.price = "x1"
  self.preview = gameConfig.preview == 1
  self.sort = gameConfig.sort or 0
end

function NewRechargeHeroData:UpdateServerInfo(heroProfessionInfo)
  self.canbuy = heroProfessionInfo.canbuy == true
  self.isbuy = heroProfessionInfo.isbuy == true
end

function NewRechargeHeroData:IsNew()
  if not self.newdate then
    return false
  end
  local t = ServerTime.CurServerTime() / 1000
  local t1 = StringUtil.FormatTime2TimeStamp2(self.newdate[1])
  local t2 = StringUtil.FormatTime2TimeStamp2(self.newdate[2])
  if t >= t1 and t <= t2 then
    return not ProfessionProxy.Instance:IsSeeRechargeHero(self.branchId)
  end
  return false
end

function NewRechargeHeroData:IsDateNew()
  if not self.newdate then
    return false
  end
  local t = ServerTime.CurServerTime() / 1000
  local t1 = StringUtil.FormatTime2TimeStamp2(self.newdate[1])
  local t2 = StringUtil.FormatTime2TimeStamp2(self.newdate[2])
  if t >= t1 and t <= t2 then
    return true
  end
  return false
end

function NewRechargeHeroData:GetLeftTime()
  if not self.getdate then
    return -1
  end
  local t = ServerTime.CurServerTime() / 1000
  local t1 = StringUtil.FormatTime2TimeStamp2(self.getdate[1])
  if t < t1 then
    return
  end
  local t2 = StringUtil.FormatTime2TimeStamp2(self.getdate[2])
  local leftTime = t2 - t
  if leftTime < 0 then
    return
  end
  return leftTime, ClientTimeUtil.FormatTimeBySec(leftTime)
end
