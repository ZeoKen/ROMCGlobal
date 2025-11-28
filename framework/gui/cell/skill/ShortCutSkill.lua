autoImport("BaseCDCell")
autoImport("ShotCutSkillTip")
autoImport("ConditionCheck")
ShortCutSkill = class("ShortCutSkill", BaseCDCell)
ShortCutSkill.FitPreCondReason = 1
ShortCutSkill.FitSpecialCost = 2
ShortCutSkill.FitHpCost = 3
ShortCutSkill.FitTargetFilter = 4
ShortCutSkill.FitSubSkill = 5
local RandomSkillIcon = "skill_2036001"
local SkillType_SpaceLeap = "SpaceLeap"
local CanDoubleClick = function(staticData)
  if staticData == nil then
    return
  end
  return staticData.SkillType == SkillType_SpaceLeap
end
local _EffectShow = function(effectHandle, owner, assetEffect)
  if not owner then
    return
  end
  owner.FindObjects(owner, effectHandle.gameObject)
  owner.SetAnimator(owner, effectHandle)
end

function ShortCutSkill:FindObjects(effectGO)
  if effectGO and self.effectGO ~= effectGO then
    self.effectGO = effectGO
    self.animator = effectGO:GetComponent(Animator)
  end
end

function ShortCutSkill:SetAnimator(effectHandle)
  if self.duration and self.duration > 0 then
    self.animator.speed = 1 / self.duration
    self.animator:Play("ufx_danmachibell_xuli_prf")
  end
end

function ShortCutSkill:Init()
  self.notFitCheck = ConditionCheckWithDirty.new()
  self:SetcdCtl(FunctionCDCommand.Me():GetCDProxy(ShotCutSkillCDRefresher))
  self.container = nil
  self.icon = Game.GameObjectUtil:DeepFindChild(self.gameObject, "Icon"):GetComponent(UISprite)
  self.iconCover = self:FindGO("IconCover")
  self.bg = self:FindGO("Bg")
  self.clickObj = self:FindGO("Click")
  self.clickObjBtn = self:FindGO("Click"):GetComponent(UIButton)
  self.clickTweenScale = self.clickObj:GetComponent(TweenScale)
  self.clickTweenScale:SetOnFinished(function()
    self.clickTweenScale:PlayReverse()
  end)
  self.bgSp = self.bg:GetComponent(UISprite)
  self.cdMask = Game.GameObjectUtil:DeepFindChild(self.gameObject, "CDMask"):GetComponent(UISprite)
  self.innercdMask = self:FindGO("InnerCDMask"):GetComponent(UISprite)
  self.leadMask = self:FindGO("LeadMask"):GetComponent(UISprite)
  self.preCondNotFitObj = Game.GameObjectUtil:DeepFindChild(self.gameObject, "PreConditionNotFit")
  self.preCondNotFit = self.preCondNotFitObj:GetComponent(UISprite)
  self.spNotEnough = self:FindGO("SpNotEnough")
  self.disableMask = self:FindGO("DisableMask")
  self.objOutOfRangeMask = self:FindGO("OutOfRangeMask")
  self.addSp = self:FindGO("Add")
  self.cannotUseSp = self:FindGO("CannotUse")
  self.expireTime = self:FindGO("ExpireTime"):GetComponent(UILabel)
  self.usedCount = self:FindGO("UsedCount"):GetComponent(UILabel)
  self.lefttime = self:FindGO("lefttime"):GetComponent(UILabel)
  self.forgetMask = self:FindGO("ForgetMask")
  self.replaceEff = self:FindGO("replaceEff")
  self.replaceEffMask = self:FindGO("replaceEffMask")
  self.replaceEffSp = self.replaceEff:GetComponent(UISprite)
  self.replaceEffMaskSp = self.replaceEffMask:GetComponent(UISprite)
  self.leadEffectContainer = self:FindGO("leadEffect")
  self.switchEffectContainer = self:FindGO("switchEffect")
  self:DestroySwitchEffect()
  self:ResetCdEffect()
  self:GuideEnd()
  local click = function(obj)
    self:ClickSkill()
  end
  local doubleClick = function()
    if self.data ~= nil and CanDoubleClick(self.data.staticData) then
      self:ClickSkill(true)
    end
  end
  local press = function(obj, state)
    if MonitorProxy.Instance.monitorTarget then
      return
    end
    if state then
      if self.data ~= nil and self.data.staticData ~= nil then
        if SkillProxy.Instance:GetRandomSkillID() ~= nil then
          return
        end
        if ShortCutProxy.Instance:GetUnLockSkillMaxIndex() - self.indexInList < 4 then
          TipsView.Me():ShowStickTip(ShotCutSkillTip, self.data, NGUIUtil.AnchorSide.TopRight, self.bgSp, {-203, -20})
        else
          TipsView.Me():ShowStickTip(ShotCutSkillTip, self.data, NGUIUtil.AnchorSide.TopLeft, self.bgSp, {205, -20})
        end
      else
        TipsView.Me():HideTip(ShotCutSkillTip)
      end
    end
  end
  local maskBg = self:FindGO("MaskBg")
  self:AddClickEvent(maskBg, function()
    local data = self.data
    if data == nil then
      return
    end
    local staticData = data.staticData
    if staticData == nil or staticData.Logic_Param == nil then
      return
    end
    local limitMap = staticData.Logic_Param.use_limit_map
    if limitMap ~= nil then
      local mapID = Game.MapManager:GetMapID()
      for i = 1, #limitMap do
        if mapID == limitMap[i] then
          return
        end
      end
      MsgManager.ShowMsgByID(40907)
    end
  end)
  self.longPress = self.clickObj:GetComponent(UILongPress)
  self.longPress.pressEvent = press
  self:SetEvent(self.clickObj, click)
  self:SetDoubleClick(self.clickObj, doubleClick)
  EventManager.Me():AddEventListener(MyselfEvent.SpChange, self.CheckSp, self)
  EventManager.Me():AddEventListener(MyselfEvent.HpChange, self.CheckHp, self)
  EventManager.Me():AddEventListener(MyselfEvent.EnableUseSkillStateChange, self.CheckEnableUseSkill, self)
  EventManager.Me():AddEventListener(MyselfEvent.CurBulletsChange, self.UpdateSpecialCost, self)
  EventManager.Me():AddEventListener(MyselfEvent.OnMountFormChange, self.UpdateIcon, self)
  self.breakEffectContainer = self:FindGO("breakEffect")
  self.hotKeyTipContainer = self:FindComponent("HotKeyTipContainer", UIWidget)
  self.chargeTimes = self:FindComponent("chargeTimes", UILabel)
end

function ShortCutSkill:ClickSkill(auto)
  if MonitorProxy.Instance.monitorTarget then
    return
  end
  local _TipsView = TipsView.Me()
  if _TipsView:IsCurrentTip(ShotCutSkillTip) then
    _TipsView:HideTip(ShotCutSkillTip)
    return
  end
  local id = self.data:GetID()
  local time = SkillProxy.Instance:SkillInForgetTime(id // 1000)
  if id == 0 then
    self:DispatchEvent(MouseEvent.MouseClick, self)
  elseif self.data.shadow then
    if SgAIManager.Me():IsHiding() then
      return
    end
    if self.data.CheckVertigoCount and self.data:CheckVertigoCount() then
      MsgManager.ShowMsgByID(42077)
    elseif self.data.CheckAttach and self.data:CheckAttach() then
      if SgAIManager.Me().isInsight then
        MsgManager.ShowMsgByID(42124)
      else
        MsgManager.ShowMsgByID(42083)
      end
    else
      local msgId = -1
      if GameConfig.HeartLock.UseSkillFail ~= nil then
        for k, v in pairs(GameConfig.HeartLock.UseSkillFail) do
          if k == id then
            msgId = v
            break
          end
        end
      end
      if msgId ~= -1 then
        MsgManager.ShowMsgByID(msgId)
      else
        MsgManager.ShowMsgByID(40901)
      end
    end
  elseif 0 < time then
    MsgManager.ShowMsgByID(43311)
  else
    if self:isClientSkill(id) then
      if self.m_cdTickTime ~= nil then
        redlog("客户端释放技能在CD中 | id = " .. id)
        return
      end
      self.m_clientMaxCD = Table_Skill[id].FixCD
      self.m_clientCurCD = self.m_clientMaxCD
      self.m_cdTickTime = TimeTickManager.Me():CreateTick(0, 33, self.updateClientSkillCD, self, id)
    end
    if FunctionSniperMode.Me():IsWorking() then
      self:UpdateCastRangeStatus()
      if self.outOfRange then
        MsgManager.ShowMsgByID(625)
        return
      end
    end
    if self.data.staticData.Logic_Param.heartlock_SKILLTYPE then
      GameFacade.Instance:sendNotification(MyselfEvent.AskUseSkill, {skill = id})
    else
      Game.SkillClickUseManager:ClickSkill(self, auto)
    end
    self.clickTweenScale:PlayForward()
  end
end

function ShortCutSkill:isClientSkill(value)
  return value == 4607001
end

function ShortCutSkill:updateClientSkillCD()
  if self.m_clientCurCD <= 0 then
    TimeTickManager.Me():ClearTick(self, self.data:GetID())
    self.m_cdTickTime = nil
    self.cdMask.fillAmount = 0
    self.innercdMask.fillAmount = 0
    self:SetLeftTime("")
  else
    self.m_clientCurCD = self.m_clientCurCD - 0.033
    local value = self.m_clientCurCD / self.m_clientMaxCD
    local left = self.m_clientMaxCD - self.m_clientCurCD
    if left < 0 then
      left = 0
    end
    self.cdMask.fillAmount = value
    self.innercdMask.fillAmount = value
    self:SetLeftTime(tostring(self.m_clientMaxCD - self.m_clientCurCD))
  end
end

function ShortCutSkill:GetClickObj()
  return self.clickObj
end

function ShortCutSkill:NeedHide(val)
  self.isHiding = val
  self.gameObject:SetActive(not val)
end

function ShortCutSkill:IsAvailable()
  return self.data ~= nil and self.data:GetID() ~= 0 and not self.isHiding and not self.disableMaskActive
end

function ShortCutSkill:ExtendsEmptyShow()
  self:Show(self.cannotUseSp)
  self:Hide(self.addSp)
  self:Hide(self.clickObj)
end

function ShortCutSkill:_FallBackExtendsEmptyShow()
  self:Hide(self.cannotUseSp)
  self:Show(self.addSp)
  self:Show(self.clickObj)
end

function ShortCutSkill:SetData(obj)
  self.data = obj
  self:NeedHide(false)
  self:_FallBackExtendsEmptyShow()
  if self.data == nil then
    self.iconCover:SetActive(false)
    self:ResetCdEffect()
    self:ClickBtnAlpha(1)
    self.replaceEff:SetActive(false)
    self:DestroySwitchEffect()
  else
    if self.data.staticData ~= nil then
      self.iconCover:SetActive(true)
      self:UpdateIcon()
      self:ClickBtnAlpha(0)
    else
      self.icon.spriteName = nil
      self.iconCover:SetActive(false)
      self:ClickBtnAlpha(1)
      self.replaceEff:SetActive(false)
      self:DestroySwitchEffect()
    end
    self:TryStartCd()
  end
  self:UpdateShadow()
  self:CheckEnableUseSkill()
  self:_CheckCost()
  self:UpdatePreCondition()
  self:CheckTargetValid(Game.Myself:GetLockTarget())
  self:UpdateExpireTime()
  self:UpdateUsedCount()
  self:UpdateLeftCDtimes()
  self:UpdateForgetState()
  self:UpdateLeadMask()
  self:UpdateChargeBuff()
end

function ShortCutSkill:ClickBtnAlpha(a)
  self.clickObjBtn.defaultColor = Color(1, 1, 1, a)
  self.bgSp.alpha = a
end

function ShortCutSkill:UpdateShadow()
  if self.data and self.data.shadow then
    ColorUtil.ShaderGrayUIWidget(self.icon)
    self:ResetCdEffect()
    local skillInfo = Game.LogicManager_Skill:GetSkillInfo(self.data:GetID())
    local showReplaceEff = skillInfo:ShowReplaceEffect()
    self.replaceEffMask:SetActive(showReplaceEff ~= nil)
  else
    ColorUtil.WhiteUIWidget(self.icon)
    self:TryStartCd()
  end
end

function ShortCutSkill:UpdatePreCondition()
  local data = self.data
  if data then
    local instance = SkillProxy.Instance
    if instance:IsFitPreCondition(data) then
      self.notFitCheck:RemoveReason(ShortCutSkill.FitPreCondReason)
    else
      self.notFitCheck:SetReason(ShortCutSkill.FitPreCondReason)
    end
    if instance:HasFitSpecialCost(data) then
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

function ShortCutSkill:GetPreCondition(data)
  if not data then
    return false
  end
  return data.staticData and self.notFitCheck:HasReason() or false
end

function ShortCutSkill:SetPreCondition(active)
  if self.preConditionActive == active then
    return
  end
  self.preCondNotFitObj:SetActive(active)
  self.preConditionActive = active
end

function ShortCutSkill:UpdateIcon(fromServer)
  if SkillProxy.Instance:GetRandomSkillID() ~= nil then
    self:SetSkillIcon(RandomSkillIcon, 10)
    return
  end
  if self.data == nil then
    return
  end
  local staticData = self.data.staticData
  if staticData == nil then
    return
  end
  local icon = Game.SkillDynamicManager:GetDynamicConfig(Game.Myself.data.id, staticData.id, SkillDynamicManager.Config.Icon)
  icon = icon or self.data:GetAltIcon(Game.Myself)
  icon = icon or staticData.Icon
  self:SetSkillIcon(icon, MyselfProxy.Instance:GetMyProfessionType())
  local skillInfo = Game.LogicManager_Skill:GetSkillInfo(self.data:GetID())
  local showReplaceEff = skillInfo:ShowReplaceEffect()
  if showReplaceEff ~= nil then
    IconManager:SetUIIcon(showReplaceEff, self.replaceEffSp)
    IconManager:SetUIIcon(showReplaceEff .. "grey", self.replaceEffMaskSp)
    self.replaceEff:SetActive(true)
    self.replaceEffMask:SetActive(false)
  else
    self.replaceEff:SetActive(false)
    self.replaceEffMask:SetActive(false)
  end
  self:SetSwitchEffect(fromServer and icon ~= staticData.Icon)
end

function ShortCutSkill:SetSkillIcon(icon, profess)
  IconManager:SetSkillIconByProfess(icon, self.icon, profess, true)
  self.icon:SetMaskPath(UIMaskConfig.SkillMask)
  self.icon.OpenMask = true
  self.icon.OpenCompress = true
end

function ShortCutSkill:CheckTargetValid(creature)
  local fitFilterTarget = false
  if self.data and self.data.staticData then
    local skillInfo = Game.LogicManager_Skill:GetSkillInfo(self.data:GetID())
    if skillInfo:NoPreCheckTarget() then
      return
    end
    if skillInfo and skillInfo:GetTargetType() == SkillTargetType.Creature then
      local staticData = self.data.staticData
      if staticData.TargetFilter and staticData.TargetFilter.classID then
        if creature then
          local classes = staticData.TargetFilter.classID
          local targetClassID = creature.data:GetClassID()
          for i = 1, #classes do
            if classes[i] == targetClassID then
              fitFilterTarget = true
              break
            end
          end
        else
          fitFilterTarget = true
        end
      end
      if skillInfo:TargetOnlyTeam() then
        if creature then
          if not creature:IsInMyGroup() and not creature.data:IsPippi() then
            fitFilterTarget = true
          end
        else
          fitFilterTarget = true
        end
      end
    end
  end
  if fitFilterTarget then
    self.notFitCheck:SetReason(ShortCutSkill.FitTargetFilter)
  else
    self.notFitCheck:RemoveReason(ShortCutSkill.FitTargetFilter)
  end
  self:SetPreCondition(self:GetPreCondition(self.data))
end

function ShortCutSkill:CheckHp(hp)
  if self.data and self.data.staticData then
    if SkillProxy.Instance:HasEnoughHp(self.data:GetID(), hp) then
      self.notFitCheck:RemoveReason(ShortCutSkill.FitHpCost)
    else
      self.notFitCheck:SetReason(ShortCutSkill.FitHpCost)
    end
    self:SetPreCondition(self:GetPreCondition(self.data))
  end
end

function ShortCutSkill:CheckSp(sp)
  if Game.Myself.data:IsTransformed() then
    self:SetSpNotEnough(false)
    return
  end
  if self.data and self.data.staticData and self.data.shadow == false and SkillProxy.Instance:HasEnoughSp(self.data:GetID(), sp) == false and self.disableMask.activeSelf == false then
    self:SetSpNotEnough(true)
  else
    self:SetSpNotEnough(false)
  end
end

function ShortCutSkill:SetSpNotEnough(active)
  if self.spNotEnoughActive == active then
    return
  end
  self.spNotEnoughActive = active
  self.spNotEnough:SetActive(active)
end

function ShortCutSkill:_CheckCost()
  self:CheckSp()
  self:CheckHp()
end

function ShortCutSkill:CheckEnableUseSkill(val)
  if self.data ~= nil and self.data.staticData ~= nil and self.data:GetID() == Game.Myself.data:GetAttackSkillIDAndLevel() then
    val = self:CheckAttackCanUse()
  end
  if val == nil or self.data and val == false and self.data:GetSuperUse() ~= nil then
    val = Game.Myself:Logic_CheckSkillCanUseByID(self.data:GetID() or 0)
  end
  if val == nil or val == true then
    val = not SkillProxy.Instance:ForbitUse(self.data)
  end
  if self.data and self.data.staticData then
    if (val == nil or val == true) and self.data.staticData.ForbidUse and 0 < self.data.staticData.ForbidUse & 16384 and GameConfig.UseSkillLimitMap then
      local sortId = self.data.GetSortID and self.data:GetSortID()
      local limitMap = sortId and GameConfig.UseSkillLimitMap[sortId]
      if limitMap then
        val = 0 >= TableUtility.ArrayFindIndex(limitMap, Game.MapManager:GetMapID())
      end
    end
    if self.data.shadow == false and val == false and self.data.staticData.Logic_Param.heartlock_SKILLTYPE == nil then
      self:SetDisableMask(true)
    else
      self:SetDisableMask(false)
    end
  else
    self:SetDisableMask(false)
  end
  self:_CheckCost()
end

function ShortCutSkill:CheckAttackCanUse()
  if Game.Myself.data:GetLimitNotElement(self.data:GetID()) then
    return false
  end
  return true
end

function ShortCutSkill:SetDisableMask(active)
  if self.disableMaskActive == active then
    return
  end
  self.disableMask:SetActive(active)
  self.disableMaskActive = active
  self:SetOutOfRangeMask(self.outOfRange)
end

function ShortCutSkill:TryStartCd()
  if self.data ~= nil and self.data.staticData ~= nil and not self.data.shadow then
    local cd, cdMax, cdCount = self:GetCD()
    local paused = self:GetPaused()
    if 0 < cd or 0 < cdCount then
      self.cdCtrl:Add(self)
      if paused then
        self:RefreshCD(cdMax ~= 0 and cd / cdMax or 0)
      end
    else
      self:ResetCdEffect()
    end
  else
    self:ResetCdEffect()
  end
  self:UpdateLeftCDtimes()
end

function ShortCutSkill:ResetCdEffect()
  self.cdCtrl:Remove(self)
  self.cdMask.fillAmount = 0
  self.innercdMask.fillAmount = 0
  self:SetLeftTime("")
end

function ShortCutSkill:CanUseSkill()
  if self.data ~= nil then
    return self:GetCD() == 0 and not self.data.shadow
  end
end

function ShortCutSkill:OnRemove()
  self:ResetCdEffect()
  self:ClearCountdown()
  self:ClearForget()
  EventManager.Me():RemoveEventListener(MyselfEvent.HpChange, self.CheckHp, self)
  EventManager.Me():RemoveEventListener(MyselfEvent.SpChange, self.CheckSp, self)
  EventManager.Me():RemoveEventListener(MyselfEvent.EnableUseSkillStateChange, self.CheckEnableUseSkill, self)
  EventManager.Me():RemoveEventListener(MyselfEvent.OnMountFormChange, self.UpdateIcon, self)
end

function ShortCutSkill:GetCD()
  return CDProxy.Instance:GetSkillItemDataCD(self.data)
end

function ShortCutSkill:GetMaxCD()
  local cd, cdMax = CDProxy.Instance:GetSkillItemDataCD(self.data)
  return cdMax
end

function ShortCutSkill:RefreshCD(f)
  self.cdMask.fillAmount = f
  self.innercdMask.fillAmount = f
end

function ShortCutSkill:ClearCD(f)
  self:RefreshCD(0)
end

function ShortCutSkill:GetPaused()
  return CDProxy.Instance:GetSkillPaused(self.data)
end

function ShortCutSkill:UpdateLeadMask()
  if FunctionSkill.Me().isCasting then
    local info = Game.Myself.skill.info
    if self.data and info and info:GetSkillID() // 1000 == self.data:GetID() // 1000 then
      self:GuideBegin(info)
    else
      self:GuideEnd()
    end
  end
end

function ShortCutSkill:GuideBegin(skillInfo)
  if skillInfo == nil then
    skillInfo = Game.LogicManager_Skill:GetSkillInfo(self.data:GetID())
  end
  self.duration = skillInfo:GetCastInfo(Game.Myself)
  if not skillInfo:UseLeadUIEffect() then
    LeanTween.fillAmountNGUI(self.leadMask, 1, 0, self.duration)
    return
  end
  if not self.leadEffect then
    self.leadEffect = self:PlayUIEffect(EffectMap.UI.LeadEffect, self.leadEffectContainer, true, _EffectShow, self)
  end
end

function ShortCutSkill:GuideEnd()
  self.leadMask.fillAmount = 0
  LeanTween.cancel(self.leadMask.gameObject)
  if self.leadEffect then
    self.leadEffect:Destroy()
    self.leadEffect = nil
  end
end

function ShortCutSkill:UpdateExpireTime()
  local data = self.data
  local _FunctionCDCommand = FunctionCDCommand.Me()
  local cdCtrl = _FunctionCDCommand:GetCDProxy(ShotCutSkillCountdownRefresher)
  if data ~= nil and data.expireTime ~= nil and data.expireTime > ServerTime.CurServerTime() / 1000 then
    self:Show(self.expireTime)
    if cdCtrl == nil then
      cdCtrl = _FunctionCDCommand:StartCDProxy(ShotCutSkillCountdownRefresher, 1000)
    end
    cdCtrl:Add(self)
  else
    self:Hide(self.expireTime)
    self:ClearCountdown()
  end
end

function ShortCutSkill:ClearCountdown()
  local _FunctionCDCommand = FunctionCDCommand.Me()
  local cdCtrl = _FunctionCDCommand:GetCDProxy(ShotCutSkillCountdownRefresher)
  if cdCtrl ~= nil then
    cdCtrl:Remove(self)
    _FunctionCDCommand:TryDestroy(ShotCutSkillCountdownRefresher)
  end
end

function ShortCutSkill:RefreshCountdown()
  return self:SetExpireTime()
end

function ShortCutSkill:SetExpireTime()
  local time = self.data.expireTime - ServerTime.CurServerTime() / 1000
  if 0 < time then
    self.expireTime.text = string.format("%02d:%02d", ClientTimeUtil.GetFormatSecTimeStr(time))
    return false
  else
    self:Hide(self.expireTime)
  end
  return true
end

function ShortCutSkill:UpdateUsedCount()
  local data = self.data
  if data ~= nil and data.allCount ~= nil and data.allCount > 0 then
    self:Show(self.usedCount)
    self.usedCount.text = string.format("%d/%d", data.usedCount, data.allCount)
  else
    self:Hide(self.usedCount)
  end
end

function ShortCutSkill:UpdateLeftCDtimes()
  if not self.data then
    return
  end
  local maxtime = self.data:GetMaxCDTimes(Game.Myself)
  if not maxtime or maxtime < 1 then
    self:Hide(self.lefttime)
    return
  else
    self:Show(self.lefttime)
  end
  self:SetLeftTime(self.data:GetLeftCDTimes())
end

function ShortCutSkill:SetLeftTime(time)
  if self.lefttimevalue == time then
    return
  end
  self.lefttimevalue = time
  self.lefttime.text = time
end

function ShortCutSkill:UpdateSpecialCost()
  local data = self.data
  if data then
    local instance = SkillProxy.Instance
    if instance:HasFitSpecialCost(data) then
      self.notFitCheck:RemoveReason(ShortCutSkill.FitSpecialCost)
    else
      self.notFitCheck:SetReason(ShortCutSkill.FitSpecialCost)
    end
    self:SetPreCondition(self:GetPreCondition(data))
  end
end

function ShortCutSkill:SetOutOfRangeMask(active)
  self.outOfRange = active == true
  local active = (active and not self.disableMaskActive) == true
  if active ~= self.outOfRangeMaskActive then
    self.objOutOfRangeMask:SetActive(active)
    self.outOfRangeMaskActive = active
  end
end

function ShortCutSkill:UpdateCastRangeStatus()
  if not self:CanUseSkill() then
    return
  end
  local _Game = Game
  local skillInfo = _Game.LogicManager_Skill:GetSkillInfo(self.data:GetID())
  if not skillInfo or skillInfo:GetTargetType() ~= SkillTargetType.Creature then
    self:SetOutOfRangeMask(false)
    return
  end
  local curTarget = _Game.Myself:GetLockTarget()
  local curSqrRange = curTarget and VectorUtility.DistanceXZ_Square(_Game.Myself:GetPosition(), curTarget:GetPosition()) or nil
  local castRange = skillInfo:GetLaunchRange(_Game.Myself)
  self:SetOutOfRangeMask(curSqrRange and curSqrRange > castRange * castRange)
end

function ShortCutSkill:ClearCastRangeStatus()
  self:SetOutOfRangeMask(false)
end

function ShortCutSkill:UpdateForgetState()
  if not self.data then
    return
  end
  local skillInfo = Game.LogicManager_Skill:GetSkillInfo(self.data:GetID())
  if not skillInfo then
    return
  end
  local time = SkillProxy.Instance:SkillInForgetTime(skillInfo:GetSkillID() // 1000)
  if 0 < time then
    local data = self.data
    local _FunctionCDCommand = FunctionCDCommand.Me()
    local cdCtrl = _FunctionCDCommand:GetCDProxy(ShotCutSkillForgetRefresher)
    self.forgetMask:SetActive(true)
    cdCtrl = cdCtrl or _FunctionCDCommand:StartCDProxy(ShotCutSkillForgetRefresher, 1000)
    cdCtrl:Add(self)
  else
    self.forgetMask:SetActive(false)
    self:ClearForget()
  end
end

function ShortCutSkill:ClearForget()
  local _FunctionCDCommand = FunctionCDCommand.Me()
  local cdCtrl = _FunctionCDCommand:GetCDProxy(ShotCutSkillForgetRefresher)
  if cdCtrl ~= nil then
    cdCtrl:Remove(self)
    _FunctionCDCommand:TryDestroy(ShotCutSkillForgetRefresher)
  end
end

function ShortCutSkill:RefreshForget()
  return self:UpdateForgetState()
end

function ShortCutSkill:SetSwitchEffect(showEffect)
  if showEffect then
    if not self.switchEffect then
      self.switchEffect = self:PlayUIEffect(EffectMap.UI.SwitchEffect, self.switchEffectContainer, false)
    end
    self.switchEffectContainer:SetActive(true)
  else
    self.switchEffectContainer:SetActive(false)
  end
end

function ShortCutSkill:DestroySwitchEffect()
  if self.switchEffect then
    self.switchEffect:Destroy()
    self.switchEffect = nil
  end
end

function ShortCutSkill:ShowBreakSkillEffect()
  self:PlayUIEffect(EffectMap.UI.BreakEffect, self.breakEffectContainer, true)
end

function ShortCutSkill:UpdateCDTimes()
  self:UpdateLeftCDtimes()
end

local chargebuffID = 0

function ShortCutSkill:UpdateChargeBuff()
  chargebuffID = self.data and self.data.staticData and self.data.staticData.Logic_Param and self.data.staticData.Logic_Param.charge_buffid
  if chargebuffID then
    local layer = Game.Myself:GetBuffLayer(chargebuffID)
    if 0 < layer then
      self.chargeTimes.text = layer
      self:Show(self.chargeTimes)
    else
      self:Hide(self.chargeTimes)
    end
  else
    self:Hide(self.chargeTimes)
  end
end
