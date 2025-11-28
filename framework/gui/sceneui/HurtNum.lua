HurtNum = class("HurtNum", ReusableObject)
HurtNum.HideLogic = true
HurtNumType = {
  HealNum = "HealNum",
  DamageNum = "DamageNum",
  DamageNum_U = "DamageNum_U",
  DamageNum_L = "DamageNum_L",
  DamageNum_R = "DamageNum_R",
  Miss = "Miss"
}
HurtNumColorType = {
  Combo = 1,
  Normal = 2,
  Player = 3,
  Treatment = 4,
  Normal_Sp = 5,
  Treatment_Sp = 6
}
HurtNumAliveTime = {
  Normal = 1,
  Static = 3,
  Hide = 5
}
HurtNumColorMap = {
  [1] = LuaColor.New(0.99, 0.99, 0.004, 1),
  [2] = LuaColor.New(1, 1, 1, 1),
  [3] = LuaColor.New(0.82, 0.14, 0.04, 1),
  [4] = LuaColor.New(0.078, 0.94, 0.027, 1),
  [5] = LuaColor.New(0.6352941176470588, 0.4, 0.9607843137254902, 1),
  [6] = LuaColor.New(0.42745098039215684, 0.5647058823529412, 1, 1)
}
HurtNum_CritType = {
  None = 0,
  PAtk = 1,
  MAtk = 2
}
HurtNumLimit = {
  [1] = 20,
  [2] = 30,
  [3] = 10,
  [4] = 10,
  [5] = 20,
  [6] = 10
}

function HurtNum:PlayAni(aniName)
  local animator = self.animator
  if animator == nil then
    return
  end
  animator:Play(aniName, -1, 0)
end

local oneK = 1000
local oneM = 1000000
local tenM = 10000000
local oneB = 1000000000

function HurtNum:ProcessNum(numstr)
  if not FunctionPerformanceSetting.Me():GetHurtNumStyleDetail() then
    local orinum = tonumber(numstr)
    if orinum then
      if orinum >= oneM and orinum < tenM then
        numstr = string.format("%dK", orinum / oneK)
      elseif orinum >= tenM and orinum < oneB then
        numstr = string.format("%.1fM", orinum / oneM)
      elseif orinum >= oneB then
        numstr = string.format("%.1fB", orinum / oneB)
      end
    end
  end
  return numstr
end

function HurtNum:Update(deltaTime)
  if not self.__leftLifeTime then
    return
  end
  if self.__leftLifeTime <= 0 then
    return
  end
  self.__leftLifeTime = self.__leftLifeTime - deltaTime
  if self.__leftLifeTime <= 0 then
    self.__leftLifeTime = 0
  end
end

function HurtNum:SetLifeEndTime(val)
  self.__leftLifeTime = val
end

function HurtNum:IsLifeEnd()
  if not self.__leftLifeTime then
    return false
  end
  return self.__leftLifeTime <= 0
end

function HurtNum:InitArgs(args)
end

function HurtNum:DoConstruct(asArray, args)
end

function HurtNum:DoDeconstruct(asArray)
end

function HurtNum:DoDeconstruct(asArray)
end
