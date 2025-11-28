autoImport("BaseCDCell")
ProfessionSkillCDCell = class("ProfessionSkillCDCell", BaseCDCell)

function ProfessionSkillCDCell:Init()
  self:SetcdCtl(FunctionCDCommand.Me():GetCDProxy(ShotCutSkillCDRefresher))
  self.icon = self:FindGO("Icon"):GetComponent(UISprite)
  self.cdMask = Game.GameObjectUtil:DeepFindChild(self.gameObject, "CDMask"):GetComponent(UISprite)
  self:AddCellClickEvent()
end

function ProfessionSkillCDCell:SetData(obj)
  if obj then
    self:ResetCdEffect()
    local profession = obj[1]
    self.skillid = obj[2]
    local professionData = Table_Class[profession]
    local professionType = professionData and professionData.Type or MyselfProxy.Instance:GetMyProfessionType()
    local skillData = Table_Skill[self.skillid]
    if skillData then
      if profession then
        IconManager:SetSkillIconByProfess(skillData.Icon, self.icon, professionType, true)
      else
        IconManager:SetSkillIcon(skillData.Icon, self.icon)
      end
      self:Show(self.icon.gameObject)
    else
      self.icon.spriteName = nil
      errorLog("can't find skillData in table Skill,Skill id:", obj)
    end
    self.updateCdLb = obj[5]
    self.skillEnable = obj[4]
    if obj[3] and obj[4] then
      self.data = obj[3]
      self:TryStartCd()
      self:SetTextureWhite(self.gameObject)
    else
      self:RefreshCD(0)
      self:SetTextureGrey(self.gameObject)
    end
  end
end

function ProfessionSkillCDCell:RefreshCD(f)
  self.cdMask.fillAmount = f
  if self.updateCdLb then
    if self.data and self.skillEnable then
      local curCd = self:GetCD() or 0
      self.updateCdLb.text = curCd <= 0 and ZhString.AdventurePanel_UseEffectSkill_CanUse or string.format(ZhString.SkillTip_CDTime.normal, math.ceil(curCd))
    else
      self.updateCdLb.text = ""
    end
  end
end

function ProfessionSkillCDCell:TryStartCd()
  if self.data ~= nil and self.data.staticData ~= nil and not self.data.shadow then
    if self:GetCD() > 0 then
      self.cdCtrl:Add(self)
    else
      self:ResetCdEffect()
    end
  else
    self:ResetCdEffect()
  end
end

function ProfessionSkillCDCell:ResetCdEffect()
  self.cdCtrl:Remove(self)
  self:RefreshCD(0)
end

function ProfessionSkillCDCell:GetCD()
  return self.data and CDProxy.Instance:GetSkillItemDataCD(self.data)
end

function ProfessionSkillCDCell:GetMaxCD()
  if not self.data then
    return
  end
  local cdData = CDProxy.Instance:GetSkillInCD(self.data.sortID)
  local communalData = CDProxy.Instance:GetSkillInCD(CDProxy.CommunalSkillCDSortID)
  if self.data and self.data.staticData and self.data.staticData.id == Game.Myself.data:GetAttackSkillIDAndLevel() then
    return 1
  elseif cdData ~= nil and cdData.cdMax then
    if communalData == nil then
      return cdData:GetCdMax()
    end
    return math.max(cdData:GetCdMax(), communalData:GetCdMax())
  elseif communalData then
    return communalData:GetCdMax()
  end
  return 1
end

function ProfessionSkillCDCell:ClearCD(f)
  self:RefreshCD(0)
end

function ProfessionSkillCDCell:OnRemove()
  self:ResetCdEffect()
end
