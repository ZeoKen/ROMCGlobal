LevelUpPanel = class("LevelUpPanel", ContainerView)
LevelUpPanel.ViewType = UIViewType.LevelUpLayer
local TypeConfig = {
  SceneUserEvent_BaseLevelUp = {
    toSprite = "new-main_icon_arrowblue",
    bgTex = "levelup_bg_02",
    lvUPEffect = EffectMap.UI.LevelUp_Base,
    lineBGEffect = EffectMap.UI.LevelUp_LineEff_Base,
    fromText = ZhString.LevelUp_Base,
    funcText = ZhString.LevelUp_BaseTip,
    gradientTop = LuaColor.New(0.5372549019607843, 0.8862745098039215, 1),
    gradientBottom = LuaColor.New(1, 1, 1),
    outlineColor = LuaColor.New(0.25098039215686274, 0.43137254901960786, 0.7647058823529411)
  },
  SceneUserEvent_JobLevelUp = {
    toSprite = "new-main_icon_arrow",
    bgTex = "levelup_bg_01",
    spriteScale = 0.4,
    spriteRotate = 90,
    lvUPEffect = EffectMap.UI.LevelUp_Job,
    lineBGEffect = EffectMap.UI.LevelUp_LineEff_Job,
    fromText = ZhString.LevelUp_Job,
    funcText = ZhString.LevelUp_JobTip,
    gradientTop = LuaColor.New(1, 0.9411764705882353, 0.5529411764705883),
    gradientBottom = LuaColor.New(1, 0.996078431372549, 0.9450980392156862),
    outlineColor = LuaColor.New(0.5019607843137255, 0.34509803921568627, 0.1607843137254902)
  }
}
local tempV3 = LuaVector3()
local tempRot = LuaQuaternion()
local _MyselfProxy
local EffectAnimationTime = 1500
local IsNull = Slua.IsNull

function LevelUpPanel:Init()
  _MyselfProxy = MyselfProxy.Instance
  self:DisableAnimatorDuringInit()
  self:FindObjs()
  self:AddEvents()
  local lvType = self.viewdata and self.viewdata.viewdata and self.viewdata.viewdata.lvType
  self:UpdateView(lvType)
end

function LevelUpPanel:DisableAnimatorDuringInit()
  local animator = self.gameObject:GetComponent(Animator)
  if animator then
    animator.enabled = false
    if self.animatorEnableTick then
      self.animatorEnableTick:Destroy()
      self.animatorEnableTick = nil
    end
    self.animatorEnableTick = TimeTickManager.Me():CreateOnceDelayTick(0, function()
      if animator and animator.gameObject and animator.gameObject.activeInHierarchy then
        animator.enabled = true
      end
    end, self)
  end
end

function LevelUpPanel:FindObjs()
  self.mask = self:FindGO("mask")
  self.topEffect = self:FindGO("TopEffect")
  self.lineEffect1 = self:FindGO("LineEffect1")
  self.lineEffect2 = self:FindGO("LineEffect2")
  self.levelTex = self:FindComponent("LevelTexture", UITexture)
  self.levelLabel = self:FindComponent("LevelLabel", UILabel)
  self.fromLabel = self:FindComponent("FromLabel", UILabel)
  self.toLabel = self:FindComponent("ToLabel", UILabel)
  self.funcLabel = self:FindComponent("FuncLabel", UILabel)
  self.levelLabel_1 = self:FindComponent("LevelLabel_1", UILabel)
  self.toSprite = self:FindGO("ToSprite"):GetComponent(UISprite)
  self.info2 = self:FindGO("info2")
  self:Lock()
  self:AddClickEvent(self.mask, function(g)
    if self.isLocked then
      return
    end
    if not self:UpdateView() then
      self:CloseSelf()
    end
  end)
end

function LevelUpPanel:Lock()
  self.isLocked = true
  if self.lockTimer then
    self.lockTimer:Destroy()
    self.lockTimer = nil
  end
  self.lockTimer = TimeTickManager.Me():CreateOnceDelayTick(EffectAnimationTime, function()
    self:Unlock()
  end, self)
end

function LevelUpPanel:Unlock()
  self.isLocked = false
  if self.lockTimer then
    self.lockTimer:Destroy()
    self.lockTimer = nil
  end
end

function LevelUpPanel:AddEvents()
  self:AddListenEvt(SceneUserEvent.Me_LevelUp, self.TryUpdateView)
end

function LevelUpPanel:TryUpdateView(note)
  local lvType = note.body.lvType
  local from = note.body.from
  local to = note.body.to
  if lvType == self.lvType then
    _MyselfProxy:PopLevelUPData(lvType)
    self:ShowUIEffects(from, to, lvType)
  end
end

function LevelUpPanel:UpdateView(lvType)
  local lvType = lvType
  local hasData = _MyselfProxy:PeekLevelUPData(lvType)
  if not hasData then
    return
  end
  local from
  if not lvType then
    from, lvType = _MyselfProxy:PopLevelUPData(lvType)
  else
    from = _MyselfProxy:PopLevelUPData(lvType)
  end
  local myUserdata = Game.Myself.data.userdata
  local to
  if lvType == SceneUserEvent.BaseLevelUp then
    to = myUserdata:Get(UDEnum.ROLELEVEL)
  else
    to = myUserdata:Get(UDEnum.JOBLEVEL)
    if not MyselfProxy.Instance:IsHero() then
      local config = Table_JobLevel[to]
      local t = config.MasterLv and config.MasterLv > 0 and to - 160 or config.ShowLevel
      to = t
    end
  end
  self.to = to
  if not lvType then
    return
  end
  self:ShowUIEffects(from, to, lvType)
  self.lvType = lvType
  return true
end

function LevelUpPanel:ShowStaticUIEffects(from, to, lvType)
  local myUserdata = Game.Myself.data.userdata
  local config = TypeConfig[lvType]
  if config then
    self.fromLabel.text = string.format(config.fromText, from)
    local delta = lvType == SceneUserEvent.BaseLevelUp and _MyselfProxy:GetTotalAddBasePoint(from, to) or to - from
    if lvType == SceneUserEvent.JobLevelUp then
      local skillpoint = myUserdata:Get(UDEnum.SKILL_POINT)
      if skillpoint == 0 then
        self.funcLabel.text = ""
        self.info2:SetActive(false)
      else
        self.funcLabel.text = string.format(config.funcText, delta)
        self.info2:SetActive(true)
      end
    else
      self.funcLabel.text = string.format(config.funcText, delta)
      self.info2:SetActive(true)
    end
    if self.levelLabel and not IsNull(self.levelLabel) then
      self.levelLabel.text = to
    end
    if self.levelLabel_1 and not IsNull(self.levelLabel_1) then
      self.levelLabel_1.text = to
    end
    if self.toLabel and not IsNull(self.toLabel) then
      self.toLabel.text = to
    end
  end
end

function LevelUpPanel:ShowUIEffects(from, to, lvType)
  self:Lock()
  self.lvType = lvType
  self:ShowStaticUIEffects(from, to, lvType)
  local config = TypeConfig[lvType]
  if not config then
    return
  end
  self.to = to
  if self.tick then
    self.tick:Destroy()
    self.tick = nil
  end
  self.tick = TimeTickManager.Me():CreateOnceDelayTick(410, function()
    self.levelLabel.text = self.to
  end, self)
  self.textName = config.bgTex
  PictureManager.Instance:SetUI(config.bgTex, self.levelTex)
  if self.effect then
    self.effect:Destroy()
    self.effect = nil
  end
  self.effect = self:PlayUIEffect(config.lvUPEffect, self.topEffect)
  self.tick1 = TimeTickManager.Me():CreateOnceDelayTick(300, function()
    self:PlayUIEffect(config.lineBGEffect, self.lineEffect1, true)
  end, self)
  self.tick2 = TimeTickManager.Me():CreateOnceDelayTick(500, function()
    self:PlayUIEffect(config.lineBGEffect, self.lineEffect2, true)
  end, self)
  self.levelLabel.effectColor = config.outlineColor
  self.levelLabel.gradientTop = config.gradientTop
  self.levelLabel.gradientBottom = config.gradientBottom
  self.levelLabel_1.effectColor = config.outlineColor
  self.levelLabel_1.gradientTop = config.gradientTop
  self.levelLabel_1.gradientBottom = config.gradientBottom
  self.toSprite.spriteName = config.toSprite
  self.toSprite:MakePixelPerfect()
  if config.spriteScale then
    self.toSprite.gameObject.transform.localScale = LuaGeometry.GetTempVector3(config.spriteScale, config.spriteScale, 1)
  end
  if config.spriteRotate then
    tempV3[3] = config.spriteRotate
    LuaQuaternion.Better_SetEulerAngles(tempRot, tempV3)
    self.toSprite.gameObject.transform.localRotation = tempRot
  else
    self.toSprite.gameObject.transform.localRotation = LuaGeometry.Const_Qua_identity
  end
  self:PlayUISound(AudioMap.UI.sfx_UI_common_levelup)
end

function LevelUpPanel:OnExit()
  if self.textName then
    PictureManager.Instance:UnLoadUI(self.textName, self.levelTex)
  end
  if self.tick then
    self.tick:Destroy()
    self.tick = nil
  end
  if self.tick1 then
    self.tick1:Destroy()
    self.tick1 = nil
  end
  if self.tick2 then
    self.tick2:Destroy()
    self.tick2 = nil
  end
  if self.lockTimer then
    self.lockTimer:Destroy()
    self.lockTimer = nil
  end
  if self.animatorEnableTick then
    self.animatorEnableTick:Destroy()
    self.animatorEnableTick = nil
  end
  self.topEffect = nil
end
