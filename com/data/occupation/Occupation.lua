Occupation = reusableClass("Occupation")

function Occupation:DoConstruct(asArray, data)
  local level = data[1]
  local exp = data[2]
  local profession = data[3]
  self:ResetData(level, exp, profession)
end

function Occupation:ResetData(level, exp, profession)
  if not profession then
    return
  end
  self.exp = exp
  self.profession = profession
  self.professionData = Table_Class[self.profession]
  self:SetLevel(level)
  local curP = Game.Myself.data.userdata:Get(UDEnum.PROFESSION)
  self.isCurrent = profession == curP and true or false
end

function Occupation:GetLevelText()
  return self.levelText
end

function Occupation:GetLevel()
  return self.level
end

function Occupation.GetFixedJobLevel(lv, profession)
  local professionid = profession
  if type(professionid) == "table" then
    professionid = professionid.id
  end
  return Occupation.GetMyFixedJobLevelWithMax_Refactory(lv, 0, professionid)
end

function Occupation.GetMyFixedJobLevelWithMax_Refactory(curlv, cur_max, professionid)
  if professionid == 1 or ProfessionProxy.IsHero(professionid) then
  elseif professionid % 10 == 1 then
    cur_max = cur_max - 10
    curlv = curlv - 10
  elseif professionid % 10 == 2 then
    cur_max = cur_max - 50
    curlv = curlv - 50
  elseif professionid % 10 == 3 then
    cur_max = cur_max - 90
    curlv = curlv - 90
  elseif professionid % 10 == 4 then
    cur_max = cur_max - 160
    curlv = curlv - 160
  elseif professionid % 10 == 5 then
    cur_max = cur_max - 220
    curlv = curlv - 220
  else
    helplog("服务器发了错误的东西！！")
  end
  return curlv, cur_max
end

function Occupation.GetMyFixedJobLevelWithMax(lv, profession)
  local hasJobBreak = MyselfProxy.Instance:HasJobBreak()
  return Occupation.GetFixedJobLevelWithMax(lv, profession, hasJobBreak)
end

function Occupation.GetFixedJobLevelWithMax(lv, profession, hasJobBreak)
  local professionData = Table_Class[profession]
  lv = Occupation.GetFixedJobLevel(lv, professionData)
  local maxJobLv = professionData.MaxJobLevel
  if professionData.MaxPeak then
    maxJobLv = professionData.MaxPeak
  end
  local previousClasses = professionData.previousClasses
  local preMaxJobLv = 0
  if previousClasses then
    preMaxJobLv = previousClasses.MaxPeak or previousClasses.MaxJobLevel
  end
  lv = math.max(0, math.min(lv, maxJobLv - preMaxJobLv or 0))
  return lv
end

function Occupation:SetLevel(lv)
  if self.level ~= lv then
    self.level = lv
    self.levelText = Occupation.GetFixedJobLevel(lv, self.professionData)
  end
end

function Occupation:GetExp()
  return self.exp
end

function Occupation:SetExp(exp)
  self.exp = exp
end
