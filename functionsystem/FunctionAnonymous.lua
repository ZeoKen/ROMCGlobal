FunctionAnonymous = class("FunctionAnonymous")

function FunctionAnonymous.Me()
  if nil == FunctionAnonymous.me then
    FunctionAnonymous.me = FunctionAnonymous.new()
  end
  return FunctionAnonymous.me
end

local _PartIndex = Asset_Role.PartIndex
local _PartIndexEx = Asset_Role.PartIndexEx

function FunctionAnonymous:ctor()
end

function FunctionAnonymous:GetAnonymousName(classId)
  local config = Table_Class[classId]
  local proName = config and config.NameZh or ""
  return string.format(ZhString.Anonymous_UserName, proName)
end

function FunctionAnonymous:GetAnonymousModelParts(classId, gender, parts)
  local config = Table_Class[classId]
  if config then
    local classBody = gender == ProtoCommon_pb.EGENDER_MALE and config.MaleBody or config.FemaleBody
    parts[_PartIndex.Body] = classBody
    local classRace = ProfessionProxy.GetRaceByProfession(classId)
    local hair, eye = ProfessionProxy.Instance:GetProfessionRaceFaceInfo(classRace)
    parts[_PartIndex.Hair] = hair
    parts[_PartIndex.Eye] = eye
    local weapon = config.DefaultWeapon
    parts[_PartIndex.RightWeapon] = weapon or 0
    if ProfessionProxy.IsHero(classId) then
      if config.Head then
        parts[_PartIndex.Head] = config.Head
      end
      if config.Eye then
        parts[_PartIndex.Eye] = config.Eye
      end
    end
    parts[_PartIndexEx.Gender] = gender
  end
end

function FunctionAnonymous:GetAnonymousHeadIconData(classId, gender, iconData)
  local config = Table_Class[classId]
  if config then
    local classBody = gender == ProtoCommon_pb.EGENDER_MALE and config.MaleBody or config.FemaleBody
    iconData.bodyID = classBody
    local classRace = ProfessionProxy.GetRaceByProfession(classId)
    local hair, eye = ProfessionProxy.Instance:GetProfessionRaceFaceInfo(classRace)
    iconData.hairID = hair
    iconData.eyeID = eye
    if ProfessionProxy.IsHero(classId) then
      if config.Head then
        iconData.headID = config.Head
      end
      if config.Eye then
        iconData.eyeID = config.Eye
      end
    end
    iconData.gender = gender
  end
end
