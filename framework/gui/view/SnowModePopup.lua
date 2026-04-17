SnowModePopup = class("SnowModePopup", BaseView)
SnowModePopup.ViewType = UIViewType.PopUpLayer

function SnowModePopup:Init()
  self.selectedModeType = nil
  self.initialModeType = nil
  self:InitView()
  self:InitData()
  self:RefreshShow()
end

function SnowModePopup:InitView()
  self.mask = self:FindGO("Mask")
  if self.mask then
    self:AddClickEvent(self.mask, function()
      self:CloseSelf()
    end)
  end
  self.titleLabel = self:FindComponent("Title", UILabel)
  local grid = self:FindGO("Grid")
  if grid then
    self.atkMode = self:FindGO("AtkMode", grid)
    if self.atkMode then
      self.atkModeToggle = self.atkMode:GetComponent(UIToggle)
      self.atkModeEffectContainer = self:FindGO("EffectContainer", self.atkMode)
      self.atkModeIcon = self:FindGO("Icon", self.atkMode)
      local atkInEffectLabel = self:FindComponent("InEffectLabel", UILabel, self.atkMode)
      if atkInEffectLabel then
        atkInEffectLabel.text = ZhString.CrownCustomPage_AtkMode or "物理模式"
      end
      if self.atkModeIcon then
        self:PlayUIEffect(EffectMap.UI.SnowGem_ModeBG_Atk, self.atkModeIcon, false)
      end
      self:AddClickEvent(self.atkMode, function()
        self:OnModeToggleClick(SnowCrownProxy.ModeEnum.Atk)
      end)
      self:AddOrRemoveGuideId(self.atkMode, 567)
    end
    self.defMode = self:FindGO("DefMode", grid)
    if self.defMode then
      self.defModeToggle = self.defMode:GetComponent(UIToggle)
      self.defModeEffectContainer = self:FindGO("EffectContainer", self.defMode)
      self.defModeIcon = self:FindGO("Icon", self.defMode)
      local defInEffectLabel = self:FindComponent("InEffectLabel", UILabel, self.defMode)
      if defInEffectLabel then
        defInEffectLabel.text = ZhString.CrownCustomPage_DefMode or "防御模式"
      end
      if self.defModeIcon then
        self:PlayUIEffect(EffectMap.UI.SnowGem_ModeBG_Def, self.defModeIcon, false)
      end
      self:AddClickEvent(self.defMode, function()
        self:OnModeToggleClick(SnowCrownProxy.ModeEnum.Def)
      end)
    end
    self.elementMode = self:FindGO("ElementMode", grid)
    if self.elementMode then
      self.elementModeToggle = self.elementMode:GetComponent(UIToggle)
      self.elementModeEffectContainer = self:FindGO("EffectContainer", self.elementMode)
      self.elementModeIcon = self:FindGO("Icon", self.elementMode)
      local elementInEffectLabel = self:FindComponent("InEffectLabel", UILabel, self.elementMode)
      if elementInEffectLabel then
        elementInEffectLabel.text = ZhString.CrownCustomPage_ElementMode or "魔法模式"
      end
      if self.elementModeIcon then
        self:PlayUIEffect(EffectMap.UI.SnowGem_ModeBG_Element, self.elementModeIcon, false)
      end
      self:AddClickEvent(self.elementMode, function()
        self:OnModeToggleClick(SnowCrownProxy.ModeEnum.Ele)
      end)
    end
  end
  self.confirmBtn = self:FindGO("ConfirmBtn")
  if self.confirmBtn then
    self:AddClickEvent(self.confirmBtn, function()
      self:OnConfirmBtnClick()
    end)
    self:AddOrRemoveGuideId(self.confirmBtn, 568)
  end
end

function SnowModePopup:InitData()
  if SnowCrownProxy and SnowCrownProxy.Instance then
    self.initialModeType = SnowCrownProxy.Instance:GetCurrentUseMode()
  else
    self.initialModeType = SnowCrownProxy.ModeEnum.Atk
  end
  self.selectedModeType = self.initialModeType
end

function SnowModePopup:RefreshShow()
  self:UpdateToggleDisplay(self.selectedModeType)
end

function SnowModePopup:UpdateToggleDisplay(modeEnum)
  if modeEnum == SnowCrownProxy.ModeEnum.Atk then
    if self.atkModeToggle then
      self.atkModeToggle.value = true
    end
    if self.defModeToggle then
      self.defModeToggle.value = false
    end
    if self.elementModeToggle then
      self.elementModeToggle.value = false
    end
  elseif modeEnum == SnowCrownProxy.ModeEnum.Def then
    if self.atkModeToggle then
      self.atkModeToggle.value = false
    end
    if self.defModeToggle then
      self.defModeToggle.value = true
    end
    if self.elementModeToggle then
      self.elementModeToggle.value = false
    end
  elseif modeEnum == SnowCrownProxy.ModeEnum.Ele then
    if self.atkModeToggle then
      self.atkModeToggle.value = false
    end
    if self.defModeToggle then
      self.defModeToggle.value = false
    end
    if self.elementModeToggle then
      self.elementModeToggle.value = true
    end
  end
  self:UpdateSelectedEffect(modeEnum)
end

function SnowModePopup:UpdateSelectedEffect(modeEnum)
  local targetGO
  if modeEnum == SnowCrownProxy.ModeEnum.Atk then
    targetGO = self.atkModeEffectContainer
  elseif modeEnum == SnowCrownProxy.ModeEnum.Def then
    targetGO = self.defModeEffectContainer
  elseif modeEnum == SnowCrownProxy.ModeEnum.Ele then
    targetGO = self.elementModeEffectContainer
  end
  self:DestroySelectedEffect()
  if targetGO then
    self:PlayUIEffect(EffectMap.UI.SnowGem_ModeSwitch, targetGO, false, function(obj, args, assetEffect)
      self.selectedEffect = assetEffect
    end)
  end
end

function SnowModePopup:DestroySelectedEffect()
  if self.selectedEffect then
    if self.selectedEffect.Alive and self.selectedEffect:Alive() then
      self.selectedEffect:Destroy()
    end
    self.selectedEffect = nil
  end
end

function SnowModePopup:OnModeToggleClick(modeEnum)
  self.selectedModeType = modeEnum
  self:UpdateToggleDisplay(modeEnum)
end

function SnowModePopup:OnConfirmBtnClick()
  if self.selectedModeType and self.selectedModeType ~= self.initialModeType and SnowCrownProxy and SnowCrownProxy.Instance then
    SnowCrownProxy.Instance:RequestModeChange(self.selectedModeType)
  end
  self:CloseSelf()
end

function SnowModePopup:OnExit()
  self:DestroySelectedEffect()
  SnowModePopup.super.OnExit(self)
end
