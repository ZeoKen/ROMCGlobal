autoImport("SkillTip")
PetSkillTip = class("PetSkillTip", SkillTip)

function PetSkillTip:Init()
  PetSkillTip.super.Init(self)
  self.calPropAffect = false
end

function PetSkillTip:FindObjs()
  PetSkillTip.super.FindObjs(self)
  self:HideUnnecessary()
end

function PetSkillTip:HideUnnecessary()
  self:Hide(self.nextInfo)
  self:Hide(self.nextCD)
  self:Hide(self.sperator)
  self:Hide(self.useCount)
end

function PetSkillTip:GetCreature()
  local petSkillData = self.data and self.data.petSkillData
  if type(petSkillData) ~= "table" then
    return nil
  end
  local petGuid = petSkillData.guid
  if not petGuid or petGuid == 0 or petGuid == "" then
    return nil
  end
  local scenePetProxy = NScenePetProxy and NScenePetProxy.Instance
  local creature = scenePetProxy and scenePetProxy:Find(petGuid)
  if not creature or not creature.data then
    return nil
  end
  local myselfID = Game.Myself and Game.Myself.data and Game.Myself.data.id
  if not myselfID or creature.data.ownerID ~= myselfID then
    return nil
  end
  local staticID = creature.data.staticData and creature.data.staticData.id
  if petSkillData.petid and staticID and staticID ~= petSkillData.petid then
    return nil
  end
  local props = creature.data.props
  local cdChangePer = props and props:GetPropByName("CDChangePer")
  local cdChange = props and props:GetPropByName("CDChange")
  local cdChangePerWithBound = props and props:GetPropByName("CDChangePerWithBound")
  return creature
end

function PetSkillTip:SetData(data)
  self.data = data.data
  local skillData = self.data
  self:UpdateCurrentInfo(skillData.staticData)
  local layoutHeight = self:Layout()
  local height = math.max(math.min(layoutHeight + 190, SkillTip.MaxHeight), SkillTip.MinHeight)
  self.bg.height = height
  self:UpdateAnchors()
  self.scroll:ResetPosition()
  self:ShowHideFunc()
  self:SetConditionLabel()
end

function PetSkillTip:SetConditionLabel()
  self.skillConf = self.data
  local petSkillData = self.data and self.data.petSkillData
  if type(petSkillData) == "table" and petSkillData.isContract then
    if petSkillData.maxLevel and petSkillData.maxLevel > 0 and petSkillData.level and petSkillData.level >= petSkillData.maxLevel then
      self.condition.text = ZhString.PetSkillTip_MaxLevel
      return
    end
    local nextSkillData = Table_Skill[petSkillData.skillId + 1]
    if nextSkillData then
      self.condition.text = string.format([[
%s

%s]], ZhString.SkillTip_NextLevelSperator, self:GetDesc(nextSkillData))
      return
    end
  end
  self.condition.text = ZhString.PetSkillTip_NoUpgrade
end

function PetSkillTip:UpdateCurrentInfo(skillData)
  skillData = skillData or self.data.staticData
  IconManager:SetSkillIcon(skillData.Icon, self.icon)
  self.skillName.text = skillData.NameZh
  self.currentInfo.text = self:GetDesc(skillData)
  self.currentCD.text = self:GetCD(skillData)
  self.skillLevel.text = "Lv." .. skillData.Level
  self.skillLevel:UpdateAnchors()
  self:Hide(self.useCount.gameObject)
  self.skillType.text = GameConfig.SkillType[skillData.SkillType].name
end

local GetPropValue = function(props, propName)
  local prop = props and props:GetPropByName(propName)
  return prop and prop:GetValue() or nil
end

function PetSkillTip:GetCDDesc(skillData)
  local creature = self:GetCreature()
  local realcd = SkillInfo.GetSkillCD(creature, true, skillData)
  if realcd then
    local oldCalPropAffect = self.calPropAffect
    self.calPropAffect = true
    local result = self:_GetSkillParam(skillData.CD, function()
      return realcd
    end, ZhString.SkillTip_CDTime, 2)
    self.calPropAffect = oldCalPropAffect
    return result
  end
  local result = self:GetSkillParam(skillData, "CD", nil, nil, ZhString.SkillTip_CDTime)
  return result
end

function PetSkillTip:GetCD(skillData)
  self.skillInfo = Game.LogicManager_Skill:GetSkillInfo(skillData.id)
  local strArr = {}
  local str = ""
  local range = self:GetSkillParam(skillData, "Launch_Range", nil, nil, ZhString.SkillTip_LaunchRange)
  if range then
    strArr[#strArr + 1] = range
  end
  strArr[#strArr + 1] = self:GetCastTime(skillData)
  strArr[#strArr + 1] = self:GetCDDesc(skillData)
  strArr[#strArr + 1] = self:GetSkillParam(skillData, "DelayCD", nil, nil, ZhString.SkillTip_DelayCDTime, nil)
  local cost = self:GetCost(skillData)
  if cost ~= "" then
    strArr[#strArr + 1] = cost
  end
  for i = 1, #strArr do
    str = str .. strArr[i] .. (i ~= #strArr and "\n" or "")
  end
  return str
end
