BatteryCannonShortCutSkill = class("BatteryCannonShortCutSkill", ShortCutSkill)

function BatteryCannonShortCutSkill:Init()
  self.super.Init(self)
  self.cdMask.width = 90
  self.cdMask.height = 90
  self.leadMask.width = 90
  self.leadMask.height = 90
  local exinfo = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell("BatteryCannonShortCutSkillCell"))
  exinfo.transform:SetParent(self.gameObject.transform, false)
  local scale = BatteryCannonView.SkillBtnScale
  exinfo.transform.localScale = LuaGeometry.GetTempVector3(1 / scale, 1 / scale, 1 / scale)
  self.cntLabel = self:FindChild("cnt"):GetComponent(UILabel)
  self.cntInf = self:FindChild("cnt_inf")
  self.lock_mark = self:FindChild("lock_mark")
  self.new_mark = self:FindChild("new_mark")
  local press = function(obj, state)
    if state then
      if self.data ~= nil and self.data.staticData ~= nil then
        TipsView.Me():ShowStickTip(ShotCutSkillTip, self.data, NGUIUtil.AnchorSide.Left, self.bgSp, {-205, -100})
      else
        TipsView.Me():HideTip(ShotCutSkillTip)
      end
    end
  end
  self.longPress = self.clickObj:GetComponent(UILongPress)
  self.longPress.pressEvent = press
  autoImport("BatteryCannonView")
  self.gameObject.transform.localScale = LuaGeometry.GetTempVector3(scale, scale, scale)
end

function BatteryCannonShortCutSkill:SetData(obj)
  self.super.SetData(self, obj)
  if self.data == nil or self.data.staticData ~= nil then
  end
  self.iconCover:SetActive(false)
  self:UpdateExInfo()
end

function BatteryCannonShortCutSkill:UpdateExInfo()
  local bulletCnt = self:GetBulletCnt()
  if bulletCnt then
    self.cntInf:SetActive(false)
    self.cntLabel.text = bulletCnt
  else
    self.cntInf:SetActive(true)
    self.cntLabel.text = ""
  end
  local is_locked = self:GetSkillLocked() == true
  local is_new = not is_locked and self:GetSkillIsNew() == true
  if not is_locked and self.lock_mark.activeSelf then
    self:PassEvent(BatteryCannonViewEvent.SkillUnlock, self.data:GetID())
  end
  self.lock_mark:SetActive(is_locked)
  self.new_mark:SetActive(is_new)
end

function BatteryCannonShortCutSkill:ClickSkill(auto)
  if self:ExtraCheckHasFitSpecialCost() then
    BatteryCannonShortCutSkill.super.ClickSkill(self, auto)
    Game.Myself:Client_LockTarget(nil)
  end
end

function BatteryCannonShortCutSkill:UpdatePreCondition()
  local data = self.data
  if data then
    local instance = SkillProxy.Instance
    if instance:IsFitPreCondition(data) then
      self.notFitCheck:RemoveReason(ShortCutSkill.FitPreCondReason)
    else
      self.notFitCheck:SetReason(ShortCutSkill.FitPreCondReason)
    end
    if instance:HasFitSpecialCost(data) and self:ExtraCheckHasFitSpecialCost() then
      self.notFitCheck:RemoveReason(ShortCutSkill.FitSpecialCost)
    else
      self.notFitCheck:SetReason(ShortCutSkill.FitSpecialCost)
    end
    if data.staticData ~= nil and instance:IsSubSkillFitPreCondition(data) then
      self.notFitCheck:RemoveReason(ShortCutSkill.FitSubSkill)
    else
      self.notFitCheck:SetReason(ShortCutSkill.FitSubSkill)
    end
  end
  self:SetPreCondition(self:GetPreCondition(data))
end

function BatteryCannonShortCutSkill:ExtraCheckHasFitSpecialCost()
  if self:GetSkillLocked() == true then
    return false
  end
  local inRaid = Game.MapManager:IsRaidMode()
  if inRaid then
    local leftTime = self:GetBulletCnt()
    if not leftTime or 0 < leftTime then
      return true
    else
      return false
    end
  else
    return true
  end
end

function BatteryCannonShortCutSkill:GetBulletCnt()
  if not self.data.cannon_skill_config then
    return 0
  end
  local inRaid = Game.MapManager:IsRaidMode()
  if inRaid then
    if not self.data.cannon_skill_config.useTime or self.data.cannon_skill_config.useTime == 0 then
      return
    end
    if not self.data.cannon_skill_config.leftTime then
      self.data.cannon_skill_config.leftTime = self.data.cannon_skill_config.useTime
    end
    return self.data.cannon_skill_config.leftTime
  else
    if not self.data.cannon_skill_config.costItem or self.data.cannon_skill_config.costItem == 0 then
      return
    end
    local id = SkillProxy.Instance:GetItemNumBySkillCostCfg(self.data.cannon_skill_config.costItem, nil)
    return id
  end
end

function BatteryCannonShortCutSkill:GetSkillLocked()
  if not self.data.cannon_skill_config then
    return true
  end
  return self.data.cannon_skill_config.locked == true
end

function BatteryCannonShortCutSkill:GetSkillIsNew()
  if not self.data.cannon_skill_config then
    return false
  end
  local usedTime = self.data.cannon_skill_config.usedTime or 0
  return usedTime == 0
end
