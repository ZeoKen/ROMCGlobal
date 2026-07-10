local baseCell = autoImport("BaseCell")
autoImport("FunctionPet")
PetSkillCell = class("PetSkillCell", baseCell)
local _ContractBg = "pet_bg_skillqiyue_bg02"

function PetSkillCell:Init()
  self.icon = self:FindComponent("Icon", UISprite)
  self.lockIcon = self:FindGO("LockIcon")
  self.level = self:FindComponent("SkillLevel", UILabel)
  self.contractBgTexture = self:FindComponent("ContractBg", UITexture)
  if self.contractBgTexture then
    PictureManager.Instance:SetUI(_ContractBg, self.contractBgTexture)
  end
  self.effectContainer = self:FindGO("EffectContainer")
  self.upgradeBtn = self:FindGO("UpgradeBtn")
  if self.upgradeBtn then
    self:AddClickEvent(self.upgradeBtn, function()
      if type(self.data) == "table" and self.data.canUpgradeContract and self.data.petid then
        FunctionPet.Me():TryContractSkillLevelUp(self.data.petid)
      end
    end)
  end
  self:SetEvent(self.icon.gameObject, function()
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
end

function PetSkillCell:SetData(data)
  self.data = data
  local sid, skill_sdata
  if type(data) == "number" then
    sid = data
    skill_sdata = Table_Skill[sid]
  elseif type(data) == "table" then
    if data.skillId then
      sid = data.skillId
      skill_sdata = Table_Skill[sid]
    elseif data.staticData then
      IconManager:SetSkillIcon(data.staticData.Icon, self.icon)
      self.level.text = data.Level
      if self.upgradeBtn then
        self.upgradeBtn:SetActive(false)
      end
      if self.icon then
        self.icon.color = ColorUtil.NGUIWhite
      end
      return
    end
  end
  if skill_sdata then
    IconManager:SetSkillIcon(skill_sdata.Icon, self.icon)
    if type(data) == "table" and data.level then
      self.level.text = data.level
    else
      self.level.text = skill_sdata.Level
    end
  end
  if type(data) == "table" and data.skillId then
    if data.inactive and self.icon then
      self.icon.color = ColorUtil.NGUIShaderGray
    elseif self.icon then
      self.icon.color = ColorUtil.NGUIWhite
    end
    if self.lockIcon then
      self.lockIcon:SetActive(data.inactive == true)
    end
    if self.upgradeBtn then
      self.upgradeBtn:SetActive(data.canUpgradeContract == true)
    end
  elseif self.upgradeBtn then
    self.upgradeBtn:SetActive(false)
    if self.icon then
      self.icon.color = ColorUtil.NGUIWhite
    end
  end
  if self.contractBgTexture then
    if type(data) == "table" and data.isContract then
      self:Show(self.contractBgTexture)
    else
      self:Hide(self.contractBgTexture)
    end
  end
end

function PetSkillCell:PlayResetEffect()
  self:PlayUIEffect(EffectMap.UI.Pet_SkillUp, self.effectContainer, true)
end

local scale = LuaVector3.One()

function PetSkillCell:SetScale(size)
  if self.gameObject then
    LuaVector3.Better_Set(scale, 1, 1, 1)
    LuaVector3.Mul(scale, size)
    self.gameObject.transform.localScale = scale
  end
end

function PetSkillCell:OnCellDestroy()
  if self.contractBgTexture then
    PictureManager.Instance:UnLoadUI(_ContractBg, self.contractBgTexture)
  end
end
