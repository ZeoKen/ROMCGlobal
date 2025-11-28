autoImport("ShortCutSkill")
autoImport("UIGridListCtrl")
MainViewSkillPage = class("MainViewSkillPage", SubView)

function MainViewSkillPage:OnShow()
  if not Game.MapManager:IsPVEMode_HeartLockRaid() then
    self.active = true
    if self.dirtyupdate then
      self.dirtyupdate = nil
      self:UpdateSkills()
    end
  else
    self:UpdateHeartLockSkills()
  end
  self:CheckSkillForbid()
end

function MainViewSkillPage:OnHide()
  self.active = nil
end

function MainViewSkillPage:Init()
  FunctionCDCommand.Me():StartCDProxy(ShotCutSkillCDRefresher, 16)
  self.touchBoard = self:FindChild("TouchCollider"):GetComponent(UIWidget)
  self.skillGrid = self:FindChild("SkillBord")
  self.skillGrid = self:FindChild("SkillGrid", self.skillGrid):GetComponent(UIGridActiveSelf)
  self.currentSelectPhaseSkillID = 0
  self.phaseSkillEffect = self:FindChild("PhaseSkillSelectEffect")
  self.skillShotCutList = UIGridListCtrl.new(self.skillGrid, ShortCutSkill, "ShortCutSkill")
  self.skillShotCutList:SetAddCellHandler(self.AddShortCutCellHandler, self)
  local rSize = UIManagerProxy.Instance:GetUIRootSize()
  self.tempSkillGrid = self:FindGO("TempSkillGrid"):GetComponent(UIGridEx)
  self.tempSkillGrid.transform.localPosition = LuaGeometry.GetTempVector3(-400, rSize[2] / 2, 0)
  self.tempSkillShotCutList = UIGridListCtrl.new(self.tempSkillGrid, ShortCutSkill, "ShortCutSkill")
  self.tempSkillShotCutList:AddEventListener(MouseEvent.MouseClick, self.OnClickTempSkill, self)
  self.extraFuncSkillGrid = self:FindGO("extraFuncSkillGrid"):GetComponent(UIGrid)
  self.cancelTransformBtn = self:FindChild("cancelTransformBtn")
  local cancelTransferBtnIcon = self:FindGO("Icon", self.cancelTransformBtn):GetComponent(UISprite)
  self.returnSkillBtn = self:FindGO("returnSkillBtn")
  local returnSkillBtnIcon = self:FindGO("Icon", self.returnSkillBtn):GetComponent(UISprite)
  self.returnSkillBG = self:FindGO("returnSkillBG")
  self.returnSkillTip_TweenAlpha = self.returnSkillBG:GetComponent(TweenAlpha)
  self.returnSkillTipLabel = self:FindGO("returnSkillLabel", self.returnSkillBtn):GetComponent(UILabel)
  self.itemSkillPanel = self:FindGO("ItemSkillPanel")
  IconManager:SetSkillIconByProfess("skill_10130001", cancelTransferBtnIcon, MyselfProxy.Instance:GetMyProfessionType(), true)
  cancelTransferBtnIcon:SetMaskPath(UIMaskConfig.SkillMask)
  cancelTransferBtnIcon.OpenMask = true
  cancelTransferBtnIcon.OpenCompress = true
  if GameConfig.Return then
    local skillInfo = Game.LogicManager_Skill:GetSkillInfo(GameConfig.Return.Common.SkillID or 1558001)
    IconManager:SetSkillIconByProfess(skillInfo.staticData.Icon, returnSkillBtnIcon, MyselfProxy.Instance:GetMyProfessionType(), true)
    returnSkillBtnIcon:SetMaskPath(UIMaskConfig.SkillMask)
    returnSkillBtnIcon.OpenMask = true
    returnSkillBtnIcon.OpenCompress = true
    local skillTip = GameConfig.Return.Common and GameConfig.Return.Common.SkillTip or ""
    self.returnSkillTipLabel.text = skillTip
  end
  self.skillShotCutList:AddEventListener(MouseEvent.MouseClick, self.ClickSkillHandler, self)
  self:InitSwitchShortCut()
  self.shortcutSwitchIndex = 1
  self:SwitchShortCutTo(ShortCutProxy.SwitchList[self.shortcutSwitchIndex])
  self:AddViewEvts()
  self:InitHeartLockGrid()
end

function MainViewSkillPage:InitHeartLockGrid()
  self.heartLockItemSkillPanel = self:FindGO("HeartLockItemSkillPanel")
  self.hlSkillGrid = self:FindGO("HeartLockSkillGrid", self.heartLockItemSkillPanel):GetComponent(UIGridActiveSelf)
  self.hlSkillGridShotCutList = UIGridListCtrl.new(self.hlSkillGrid, ShortCutSkill, "ShortCutSkill")
  self.hlSkillGridShotCutList:SetAddCellHandler(self.AddHeartLockCellHandler, self)
  self.hlSkillGridShotCutList:AddEventListener(MouseEvent.MouseClick, self.ClickHeartLockSkillHandler, self)
  self.cancelAttachBtn = self:FindGO("cancelAttachBtn", self.heartLockItemSkillPanel)
  self:AddClickEvent(self.cancelAttachBtn, function()
    SgAIManager.Me():CancelAttachNPC()
    self.cancelAttachBtn:SetActive(false)
  end)
  self.cancelAttachBtn:SetActive(false)
  local cancelAttachBtnIcon = self:FindGO("Icon", self.cancelAttachBtn):GetComponent(UISprite)
  cancelAttachBtnIcon:SetMaskPath(UIMaskConfig.SkillMask)
  cancelAttachBtnIcon.OpenMask = true
  cancelAttachBtnIcon.OpenCompress = true
  self.cancelHideBtn = self:FindGO("CancelHideBtn", self.heartLockItemSkillPanel)
  self:AddClickEvent(self.cancelHideBtn, function()
    SgAIManager.Me():Handle_Hiding(false)
    self:UpdateHideBtn(false)
  end)
  self.cancelHideBtn:SetActive(false)
  self.dropBtn = self:FindGO("DropBtn", self.heartLockItemSkillPanel)
  self:AddClickEvent(self.dropBtn, function()
    SgAIManager.Me():CancelPush()
  end)
  self.dropBtn:SetActive(false)
end

function MainViewSkillPage:AddHeartLockCellHandler(cell)
  cell.container = self.hlSkillGrid
end

function MainViewSkillPage:ClickHeartLockSkillHandler(obj)
  local id = obj.data.data:GetID()
  if id ~= 0 then
    if self.currentSelectPhaseSkillID == id then
      self:sendNotification(MyselfEvent.CancelAskUseSkill, id)
    else
      self:sendNotification(MyselfEvent.AskUseSkill, id)
    end
  elseif Game.MapManager:IsMapForbid() then
    MsgManager.ShowMsgByID(27011)
  end
end

function MainViewSkillPage:UpdateHeartLockSkills()
  local equipDatas = SgAIManager.Me():GetEquippedSkills()
  if equipDatas then
    self.hlSkillGridShotCutList:ResetDatas(equipDatas)
    self.hlSkillGridShotCutList:Layout()
  end
end

function MainViewSkillPage:ClearHeartLockSkills()
  if self.hlSkillGridShotCutList then
    self.hlSkillGridShotCutList:RemoveAll()
  end
  self.heartLockItemSkillPanel:SetActive(false)
end

function MainViewSkillPage:HandleHeartLockRaidLaunch()
  self.itemSkillPanel:SetActive(false)
  self.heartLockItemSkillPanel:SetActive(true)
  self:UpdateHeartLockSkills()
end

function MainViewSkillPage:HandleHeartLockRaidShutdown()
  self.itemSkillPanel:SetActive(true)
  self:HideAttackNPC()
  self:ClearHeartLockSkills()
end

function MainViewSkillPage:StartHeartLockCD()
  local cells = self.hlSkillGridShotCutList:GetCells()
  for _, o in pairs(cells) do
    o:TryStartCd()
  end
end

function MainViewSkillPage:UpdateHideBtn(invisible)
  if self.cancelHideBtn then
    self.cancelHideBtn:SetActive(invisible == true)
  end
end

function MainViewSkillPage:ShowAttachNPC()
  self.cancelAttachBtn:SetActive(true)
end

function MainViewSkillPage:HideAttackNPC()
  self.cancelAttachBtn:SetActive(false)
end

function MainViewSkillPage:UpdateDropBtn(invisible)
  if self.dropBtn then
    self.dropBtn:SetActive(invisible == true)
  end
end

function MainViewSkillPage:InitSwitchShortCut()
  self.skillShortCutSwitchIcon = self:FindChild("SwitchIcon"):GetComponent(UIMultiSprite)
  self.skillShortCutSwtichBtn = self:FindChild("SkillShortCutSwitch")
  Game.HotKeyTipManager:RegisterHotKeyTip(16, self.skillShortCutSwtichBtn:GetComponent(UISprite), NGUIUtil.AnchorSide.TopLeft, {12, -14})
  self:AddButtonEvent("SkillShortCutSwitch", function()
    self:TryGetNextSwitchID()
    self:SwitchShortCutTo(self.shortcutSwitchID)
  end)
  self:AddButtonEvent("cancelTransformBtn", function()
    MsgManager.ConfirmMsgByID(924, function()
      self:callCancelTransformState()
    end, nil, nil)
  end)
  self:AddButtonEvent("returnSkillBtn", function()
    self:callUseReturnPlayerSkill()
  end)
end

function MainViewSkillPage:TryGetNextSwitchID(gap)
  gap = gap or 1
  local max_index = #ShortCutProxy.SwitchList
  self.shortcutSwitchIndex = self.shortcutSwitchIndex + gap
  if max_index < self.shortcutSwitchIndex then
    self.shortcutSwitchIndex = self.shortcutSwitchIndex % max_index
  end
  local id = ShortCutProxy.SwitchList[self.shortcutSwitchIndex]
  local funcEnable = ShortCutProxy.Instance:ShortCutListIsEnable(id)
  local isEmpty = SkillProxy.Instance:IsEquipedSkillEmpty(id)
  if funcEnable and not isEmpty then
    self.shortcutSwitchID = id
  else
    self:TryGetNextSwitchID(gap)
  end
end

function MainViewSkillPage:callCancelTransformState()
  ServiceUserEventProxy.Instance:CallDelTransformUserEvent()
end

function MainViewSkillPage:callUseReturnPlayerSkill()
  local id = GameConfig.Return.Common.SkillID
  if id and id ~= 0 then
    local valid = SkillProxy.Instance:SkillCanBeUsedByID(id)
    if valid then
      self:sendNotification(MyselfEvent.AskUseSkill, id)
    end
  end
end

function MainViewSkillPage:SwitchShortCutTo(id)
  if id ~= nil then
    self.shortcutSwitchID = id
    self.skillShortCutSwitchIcon.CurrentState = self.shortcutSwitchIndex - 1
    self.skillShortCutSwitchIcon.width = 78
    self.skillShortCutSwitchIcon.height = 78
    self:UpdateSkills()
    local skillID = Game.SkillClickUseManager:GetNextUseSkillID()
    local cell = self:GetCell(skillID)
    if cell then
      self:_ShowWaitNextUseEffect(cell)
    else
      self:CancelWaitNextUseHandler()
    end
  end
end

function MainViewSkillPage:HandleShortCutSwitchActive(note)
  local funcEnable = false
  local isEmpty = true
  local _ShortCutEnum = ShortCutProxy.ShortCutEnum
  local _ShortCutProxy = ShortCutProxy.Instance
  local _SkillProxy = SkillProxy.Instance
  local ID1 = _ShortCutEnum.ID1
  for k, v in pairs(_ShortCutEnum) do
    if v ~= ID1 then
      if _ShortCutProxy:ShortCutListIsEnable(v) then
        funcEnable = true
      end
      if not _SkillProxy:IsEquipedSkillEmpty(v) then
        isEmpty = false
      end
      if not (not funcEnable or isEmpty) then
        break
      end
    end
  end
  if (not funcEnable or isEmpty) and self.shortcutSwitchID ~= ID1 then
    self.shortcutSwitchIndex = 1
    self:SwitchShortCutTo(ID1)
  end
  local transformed = Game.Myself.data:IsTransformed()
  if not funcEnable or isEmpty or transformed and _SkillProxy:GetTransformedSkills() ~= nil then
    self:SetActive(self.skillShortCutSwtichBtn, false)
  else
    self:SetActive(self.skillShortCutSwtichBtn, true)
  end
end

function MainViewSkillPage:AddShortCutCellHandler(cell)
  cell.container = self.skillGrid
end

function MainViewSkillPage:ClickSkillHandler(obj)
  local id = obj.data.data:GetID()
  if id ~= 0 then
    if self.currentSelectPhaseSkillID == id then
      self:sendNotification(MyselfEvent.CancelAskUseSkill, id)
    else
      self:sendNotification(MyselfEvent.AskUseSkill, id)
    end
  elseif Game.MapManager:IsMapForbid() then
    MsgManager.ShowMsgByID(27011)
  elseif not ApplicationInfo.IsRunOnWindowns() then
    self:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.CharactorProfessSkill
    })
  end
end

function MainViewSkillPage:KeyBoardUseSkillHandler(key)
  local index = key
  local cells = self.skillShotCutList:GetCells()
  if 0 < index and index <= #cells then
    local cell = cells[index]
    if cell and cell:CanUseSkill() then
      local _SkillProxy = SkillProxy.Instance
      if _SkillProxy:IsFitPreCondition(cell.data) and _SkillProxy:HasEnoughHp(cell.data:GetID()) then
        self:ClickSkillHandler({data = cell})
      else
        FunctionSkillEnableCheck.Me():MsgNotFit(cell.data)
      end
    end
  end
end

function MainViewSkillPage:ShowPhaseSkillEffect(skillID)
  if SkillProxy.Instance:GetRandomSkillID() ~= nil then
    return
  end
  local cell = self:GetCell(skillID)
  if not cell then
    return
  end
  if self.phaseEffectCtrl == nil then
    self.phaseEffectCtrl = self:PlayUIEffect(EffectMap.UI.SkillsPlay, self.phaseSkillEffect.transform, false, function(obj, args, effect)
      self.phaseEffectCtrl = effect
      local x, y, z = LuaGameObject.InverseTransformPointByTransform(self.phaseSkillEffect.transform, cell.gameObject.transform, Space.World)
      self.phaseEffectCtrl:ResetLocalPositionXYZ(x, y, z)
    end)
  end
  GameFacade.Instance:sendNotification(SkillEvent.ShowTargetPointTip)
end

function MainViewSkillPage:HidePhaseSkillEffect(skillID)
  if self.phaseEffectCtrl then
    self.phaseEffectCtrl:Destroy()
    self.phaseEffectCtrl = nil
  end
  GameFacade.Instance:sendNotification(SkillEvent.HideTargetPointTip)
end

function MainViewSkillPage:GetCell(skillID)
  if skillID then
    local cells = self.skillShotCutList:GetCells()
    for index, cell in pairs(cells) do
      if cell.data:GetID() == skillID then
        return cell
      end
    end
  end
  return nil
end

function MainViewSkillPage:AddViewEvts()
  self:AddListenEvt(SkillEvent.SkillUpdate, self.UpdateSkills)
  self:AddListenEvt(ServiceEvent.SkillUpdateMasterSkill, self.UpdateSkills)
  self:AddListenEvt(ServiceEvent.SkillUpdateMasterSkillEquip, self.UpdateSkills)
  self:AddListenEvt(ServiceEvent.SkillUpdateInheritSkillCmd, self.UpdateSkills)
  self:AddListenEvt(MyselfEvent.MyProfessionChange, self.UpdateSkills)
  self:AddListenEvt(ItemEvent.ItemUpdate, self.ItemUpdateHandler)
  self:AddListenEvt(MyselfEvent.ZenyChange, self.ItemUpdateHandler)
  self:AddListenEvt(MyselfEvent.SyncBuffs, self.BuffUpdateHandler)
  self:AddListenEvt(MyselfEvent.SelectTargetChange, self.SelectTargetChangeHandler)
  self:AddListenEvt(SkillEvent.SkillUnlockPos, self.UnlockPosHandler)
  self:AddListenEvt(SkillEvent.SkillStartEvent, self.StartSkillCD)
  self:AddListenEvt(SkillEvent.SkillWaitNextUse, self.WaitNextUseHandler)
  self:AddListenEvt(SkillEvent.SkillCancelWaitNextUse, self.CancelWaitNextUseHandler)
  self:AddListenEvt(SkillEvent.SkillSelectPhaseStateChange, self.HandlePhaseSkillEffect)
  self:AddListenEvt(MyselfEvent.TransformChange, self.UpdateSkills)
  self:AddListenEvt(ServiceEvent.SkillDynamicSkillCmd, self.UpdateSkills)
  self:AddListenEvt(ServiceEvent.SkillUpdateDynamicSkillCmd, self.UpdateSkills)
  self:AddListenEvt(MyselfEvent.MyPropChange, self.UpdateCancelTransformBtn)
  self:AddListenEvt(ServiceEvent.PlayerMapChange, self.HandlePlayerMapChange)
  self:AddListenEvt(SkillEvent.BreakSkillEffect, self.ShowBreakSkillEffect)
  self:AddListenEvt(TeamEvent.MemberEnterTeam, self.TeamMemberUpdateHandler)
  self:AddListenEvt(TeamEvent.MemberExitTeam, self.TeamMemberUpdateHandler)
  self:AddDispatcherEvt(SkillEvent.SkillFitPreCondtion, self.UpdateSkillPreCondtion)
  self:AddDispatcherEvt(MyselfEvent.SkillGuideBegin, self.SkillGuideBeginHandler)
  self:AddDispatcherEvt(MyselfEvent.SkillGuideEnd, self.SkillGuideEndHandler)
  self:AddDispatcherEvt(MyselfEvent.SelectTargetClassChange, self.SelectTargetClassChangeHandler)
  self:AddDispatcherEvt(DungeonManager.Event.Launched, self.CheckSkillForbid)
  self:AddDispatcherEvt(MyselfEvent.ForgetSkill_Start, self.UsedSkillCheck)
  self:AddDispatcherEvt("CJKeyBoardUseSkillEvent", self.KeyBoardUseSkillHandler)
  self:AddListenEvt(HotKeyEvent.UseShortCutSkill, self.HandleUseShortCutIndex)
  self:AddListenEvt(HotKeyEvent.SwitchShortCutSkillIndex, self.HandleSwitchShortCutIndex)
  self:AddListenEvt(SkillEvent.ChangeIcon, self.HandleChangeIcon)
  self:AddListenEvt(ServiceEvent.SkillMaskSkillRandomOneSkillCmd, self.UpdateSkills)
  self:AddListenEvt(SkillEvent.BreakCastBegin, self.HandleBreakCastBegin)
  self:AddListenEvt(SkillEvent.BreakCastEnd, self.HandleBreakCastEnd)
  self:AddListenEvt(PlayerEvent.DeathStatusChange, self.HandleBreakCastByBokiState)
  self:AddListenEvt(MainViewEvent.NewPlayerHide, self.HandleHideUIUserCmd)
  self:AddListenEvt(MyselfEvent.EnterSniperMode, self.HandleEnterSniperMode)
  self:AddListenEvt(MyselfEvent.ExitSniperMode, self.HandleExitSniperMode)
  self:AddListenEvt(MyselfEvent.ObservationModeStart, self.OnObservationModeStart)
  self:AddListenEvt(MyselfEvent.ObservationModeEnd, self.OnObservationModeEnd)
  EventManager.Me():AddEventListener(SkillEvent.UpdateSubSkill, self.UpdateSubSkillPreCondtion, self)
  self:AddListenEvt(PVEEvent.HeartLockRaid_Launch, self.HandleHeartLockRaidLaunch)
  self:AddListenEvt(PVEEvent.HeartLockRaid_Shutdown, self.HandleHeartLockRaidShutdown)
  self:AddDispatcherEvt(StealthGameEvent.Skill_AttachNPC, self.ShowAttachNPC)
  self:AddDispatcherEvt(StealthGameEvent.Skill_CancelAttachNPC, self.HideAttackNPC)
  self:AddDispatcherEvt(StealthGameEvent.Skill_Update, self.UpdateHeartLockSkills, self)
  self:AddDispatcherEvt(StealthGameEvent.HideIn, self.UpdateHideBtn, self)
  self:AddDispatcherEvt(StealthGameEvent.CarryBox, self.UpdateDropBtn, self)
  self:AddListenEvt(PVEEvent.DemoRaid_Launch, self.OnDemoRaidLaunch)
  self:AddListenEvt(PVEEvent.DemoRaidRaid_Shutdown, self.OnDemoRaidShutdown)
  self:AddListenEvt(SkillEvent.SkillWaitNextCombo, self.WaitNextCombo)
  self:AddListenEvt(SkillEvent.SkillCancelWaitNextCombo, self.CancelWaitNextCombo)
  self:AddListenEvt(SkillEvent.UpdateQuestSkill, self.UpdateTempQuestSkills)
  self:AddListenEvt(SkillEvent.UpdateCDTimes, self.UpdateCDTimes)
  self:AddListenEvt(MyselfEvent.CheckInvalidSkill, self.UpdateSkills)
  self:AddListenEvt(SkillEvent.CheckSkillForbid, self.CheckSkillForbid)
  self:AddListenEvt(SkillEvent.BellCharge, self.HandleBellCharge)
  self:AddListenEvt(ServiceEvent.SkillUpSkillInfoSkillCmd, self.UpdateSkills)
end

function MainViewSkillPage:OnObservationModeStart()
  self.itemSkillPanel:SetActive(false)
end

function MainViewSkillPage:OnObservationModeEnd()
  self.itemSkillPanel:SetActive(true)
end

function MainViewSkillPage:TeamMemberUpdateHandler(note)
  local member = note.body
  if member then
    local memberGUID = member.id
    local target = Game.Myself:GetLockTarget()
    if target and target.data.id == memberGUID then
      self:_HandleSelectTargetChange(target)
    end
  end
end

function MainViewSkillPage:_HandleSelectTargetChange(creature)
  local cells = self.skillShotCutList:GetCells()
  for i = 1, #cells do
    cells[i]:CheckTargetValid(creature)
  end
end

function MainViewSkillPage:SelectTargetClassChangeHandler(creature)
  self:_HandleSelectTargetChange(creature)
end

function MainViewSkillPage:SelectTargetChangeHandler(note)
  self:_HandleSelectTargetChange(note.body)
end

function MainViewSkillPage:UpdateSkillPreCondtion(skill)
  local cells = self.skillShotCutList:GetCells()
  local cell, data
  for i = 1, #cells do
    cell = cells[i]
    data = cell.data
    if data.id == skill.id or data.staticData ~= nil and data:HasSubSkill() then
      cell:UpdatePreCondition()
    end
  end
end

function MainViewSkillPage:UpdateSubSkillPreCondtion(dirtySkills)
  local cells = self.skillShotCutList:GetCells()
  local cell, data
  for i = 1, #cells do
    cell = cells[i]
    data = cell.data
    if data.staticData ~= nil and data:HasSubSkill() then
      cell:UpdatePreCondition()
    end
  end
end

function MainViewSkillPage:WaitNextUseHandler(note)
  local skillID = note.body
  if skillID then
    local cell = self:GetCell(skillID)
    if cell then
      self:_ShowWaitNextUseEffect(cell)
    end
  end
end

function MainViewSkillPage:_ShowWaitNextUseEffect(cell)
  if self.nextEffectCtrl == nil then
    self.nextEffectCtrl = self:PlayUIEffect(EffectMap.UI.SkillWait, self.phaseSkillEffect.transform, false, function(obj, args, effect)
      self.nextEffectCtrl = effect
      local x, y, z = LuaGameObject.InverseTransformPointByTransform(self.phaseSkillEffect.transform, cell.gameObject.transform, Space.World)
      self.nextEffectCtrl:ResetLocalPositionXYZ(x, y, z)
    end)
  end
end

function MainViewSkillPage:CancelWaitNextUseHandler(note)
  if self.nextEffectCtrl then
    self.nextEffectCtrl:Destroy()
    self.nextEffectCtrl = nil
  end
end

function MainViewSkillPage:HandlePhaseSkillEffect(note)
  local skillID = Game.SkillClickUseManager.currentSelectPhaseSkillID
  if skillID == 0 then
    self:HidePhaseSkillEffect(skillID)
  else
    self:ShowPhaseSkillEffect(skillID)
  end
end

function MainViewSkillPage:UnlockPosHandler(note)
  ShortCutProxy.Instance:SetCacheListToRealList()
  self:UpdateSkills(note)
end

function MainViewSkillPage:_IsShowCancelTransBtn()
  local myselfData = Game.Myself.data
  if self.isInDemoRaid == true then
    return false
  end
  if not myselfData:IsTransformed() then
    return false
  end
  if myselfData:IsHideCancelTransformBtn() then
    return false
  end
  local _MapManager = Game.MapManager
  if _MapManager:IsPVPMode_PoringFight() or _MapManager:IsPveMode_AltMan() then
    return false
  end
  return true
end

function MainViewSkillPage:ShowCancelTransBtn()
  if self:_IsShowCancelTransBtn() then
    self:Show(self.cancelTransformBtn)
  else
    self:Hide(self.cancelTransformBtn)
  end
end

function MainViewSkillPage:RefreshReturnSkillBtn()
  local flag = MyselfProxy.Instance:GetAccVarValueByType(Var_pb.EACCVARTYPE_USERRETURN_FLAG) or 0
  if flag == 0 then
    return
  end
  local id = GameConfig.Return.Common.SkillID
  local skillValid = id and SkillProxy.Instance:SkillCanBeUsedByID(id) or false
  if skillValid then
    self:Show(self.returnSkillBtn)
    self.returnSkillTip_TweenAlpha.duration = 8
    self.returnSkillTip_TweenAlpha:ResetToBeginning()
    self.returnSkillTip_TweenAlpha:PlayForward()
  else
    self:Hide(self.returnSkillBtn)
  end
  self.extraFuncSkillGrid:Reposition()
end

function MainViewSkillPage:UpdateSkills(note)
  if not self.active then
    self.dirtyupdate = true
    return
  end
  self:ShowCancelTransBtn()
  self:RefreshReturnSkillBtn()
  local equipDatas
  self:HandleShortCutSwitchActive()
  local _SkillProxy = SkillProxy.Instance
  local transformed = Game.Myself.data:IsTransformed()
  if _SkillProxy:GetRandomSkillID() ~= nil then
    equipDatas = _SkillProxy:GetRandomSkills()
  elseif transformed then
    equipDatas = _SkillProxy:GetTransformedSkills()
  else
    equipDatas = _SkillProxy:GetCurrentEquipedSkillData(true, self.shortcutSwitchID)
  end
  if equipDatas ~= nil then
    self.skillShotCutList:ResetDatas(equipDatas)
    self:Tutorial()
    local cells = self.skillShotCutList:GetCells()
    if cells and not transformed then
      local data, locked
      for i = 1, #cells do
        data = cells[i].data
        if data then
          locked = ShortCutProxy.Instance:SkillIsLocked(i, self.shortcutSwitchID)
          if self.shortcutSwitchID == ShortCutProxy.ShortCutEnum.ID1 then
            cells[i]:NeedHide(locked)
          elseif locked then
            if i > ShortCutProxy.Instance:GetUnLockSkillMaxIndex(ShortCutProxy.ShortCutEnum.ID1) then
              cells[i]:NeedHide(true)
            else
              cells[i]:ExtendsEmptyShow()
            end
          else
            cells[i]:NeedHide(false)
          end
        end
      end
      self.skillShotCutList:Layout()
    end
  end
  self:UpdateAnchor(self.skillShotCutList)
  self:UpdateTempQuestSkills()
  local cells = self.skillShotCutList:GetCells()
  for i = 1, #cells do
    local id = 16 + i
    local parent = cells[i].hotKeyTipContainer
    if cells[i].data and cells[i].data.staticData then
      Game.HotKeyTipManager:RegisterHotKeyTip(id, parent, NGUIUtil.AnchorSide.TopLeft, {12, -14})
    else
      Game.HotKeyTipManager:RemoveHotKeyTip(id, parent)
    end
  end
end

function MainViewSkillPage:UpdateTempQuestSkills()
  local tempSkills = SkillProxy.Instance:GetQuestSkills()
  if not tempSkills or #tempSkills == 0 then
    self.tempSkillShotCutList:RemoveAll()
  else
    self.tempSkillShotCutList:ResetDatas(tempSkills)
    local cells = self.tempSkillShotCutList:GetCells()
    if cells and 0 < #cells then
      self:AddOrRemoveGuideId(cells[1].gameObject, 527)
    end
  end
end

function MainViewSkillPage:UpdateAnchor(list)
  local cellnum = 0
  for k, v in pairs(list:GetCells()) do
    if v.gameObject.activeSelf then
      cellnum = cellnum + 1
    end
  end
  self.touchBoard.width = cellnum * self.skillGrid.cellWidth
  NGUITools.UpdateWidgetCollider(self.touchBoard.gameObject)
  if self.skillShortCutSwtichBtn.activeSelf then
    self.skillGrid.gameObject.transform.localPosition = LuaGeometry.GetTempVector3(-133, 56, 0)
  else
    self.skillGrid.gameObject.transform.localPosition = LuaGeometry.GetTempVector3(-47, 56, 0)
  end
end

function MainViewSkillPage:StartSkillCD(note)
  local cells = self.skillShotCutList:GetCells()
  local skill = note.body
  for _, o in pairs(cells) do
    o:TryStartCd()
  end
  if Game.MapManager:IsPVEMode_HeartLockRaid() then
    self:StartHeartLockCD()
  end
end

function MainViewSkillPage:UsedSkillCheck()
  local cells = self.skillShotCutList:GetCells()
  for _, o in pairs(cells) do
    o:UpdateForgetState()
  end
end

function MainViewSkillPage:ItemUpdateHandler(note)
  local cells = self.skillShotCutList:GetCells()
  for i = 1, #cells do
    cells[i]:UpdatePreCondition()
  end
end

function MainViewSkillPage:BuffUpdateHandler(note)
  self:ItemUpdateHandler(note)
end

function MainViewSkillPage:SkillGuideBeginHandler(skillInfo)
  if skillInfo then
    local cell = self:GetCell(skillInfo:GetSkillID())
    if cell then
      cell:GuideBegin(skillInfo)
    end
  end
end

function MainViewSkillPage:SkillGuideEndHandler(skillInfo)
  if skillInfo then
    local cells = self.skillShotCutList:GetCells()
    for index, cell in pairs(cells) do
      if cell.data.sortID == math.floor(skillInfo:GetSkillID() / 1000) then
        cell:GuideEnd()
        break
      end
    end
  end
end

function MainViewSkillPage:CheckSkillForbid()
  local cells = self.skillShotCutList:GetCells()
  for i = 1, #cells do
    cells[i]:CheckEnableUseSkill()
  end
end

function MainViewSkillPage:HandleUseShortCutIndex(note)
  local param = note.body
  if param.index then
    local cells = self.skillShotCutList:GetCells()
    local cell = cells[param.index]
    if cell == nil then
      return
    end
    local d = cell.data
    if d == nil then
      return
    end
    if d:GetID() == 0 then
      self:ClickSkillHandler({data = cell})
    else
      Game.SkillClickUseManager:ClickSkill(cell)
    end
  end
end

function MainViewSkillPage:HandleSwitchShortCutIndex(note)
  local param = note.body
  if param.add_index then
    self:TryGetNextSwitchID(param.add_index)
    self:SwitchShortCutTo(self.shortcutSwitchID)
    return
  end
  if param.index then
    local id = ShortCutProxy.SwitchList[param.index]
    local funcEnable = ShortCutProxy.Instance:ShortCutListIsEnable(id)
    if funcEnable then
      self.shortcutSwitchIndex = param.index
      local max_index = #ShortCutProxy.SwitchList
      if max_index < self.shortcutSwitchIndex then
        self.shortcutSwitchIndex = self.shortcutSwitchIndex % max_index
      end
      self:SwitchShortCutTo(id)
    end
  end
end

function MainViewSkillPage:HandleChangeIcon(note)
  local data = note.body
  if data ~= nil then
    local map = ReusableTable.CreateTable()
    for i = 1, #data do
      map[data[i]] = 1
    end
    local cell, sortID
    local cells = self.skillShotCutList:GetCells()
    for i = 1, #cells do
      cell = cells[i]
      if cell.data ~= nil then
        sortID = cell.data.sortID
        if sortID ~= nil and map[sortID] ~= nil then
          cell:UpdateIcon(true)
        end
      end
    end
    ReusableTable.DestroyAndClearTable(map)
    map = nil
  end
end

function MainViewSkillPage:UpdateCancelTransformBtn(note)
  local transformed = Game.Myself.data:IsTransformed()
  if not transformed then
    return
  end
  local data = note.body
  if data and 0 < #data then
    local attrEffectB = ProtoCommon_pb.EATTRTYPE_ATTREFFECT2
    for i = 1, #data do
      if data[i].type == attrEffectB then
        self:ShowCancelTransBtn()
        return
      end
    end
  end
end

local skillGuildIds = {
  131,
  132,
  133,
  134,
  135,
  136
}

function MainViewSkillPage:Tutorial()
  local cells = self.skillShotCutList:GetCells()
  local cell, data
  for i = 1, #cells do
    cell = cells[i]
    self:AddOrRemoveGuideId(cell.clickObj)
    self:AddOrRemoveGuideId(cell.clickObj, skillGuildIds[i])
  end
end

function MainViewSkillPage:InitBreakSkill()
  local btn = self.breakSkill
  if btn ~= nil then
    return
  end
  btn = self:FindGO("BreakSkillBtn")
  self.breakSkill = btn
  self:AddClickEvent(btn, function()
    local id = self.breakSkillCreatureID
    if id ~= nil then
      local npc = NSceneNpcProxy.Instance:Find(id)
      if npc ~= nil then
        ServiceSkillProxy.Instance:CallStopBossSkillUsageSkillCmd(id, npc.skill:GetSkillID())
      end
    end
  end)
end

function MainViewSkillPage:ShowBreakSkill(show)
  local btn = self.breakSkill
  if btn == nil then
    return
  end
  btn:SetActive(show)
end

function MainViewSkillPage:HandleBreakCastBegin(note)
  local guid = note.body
  if guid ~= nil then
    self.breakSkillCreatureID = guid
    self:InitBreakSkill()
    self:ShowBreakSkill(true)
  end
end

function MainViewSkillPage:HandleBreakCastEnd()
  self.breakSkillCreatureID = nil
  self:ShowBreakSkill(false)
end

function MainViewSkillPage:HandleHideUIUserCmd(note)
  local data = note.body
  local ui = data.ui
  local on = data.open
  if on and on == 1 then
    if TableUtility.ArrayFindIndex(data.id, 3) > 0 then
      self.itemSkillPanel:SetActive(false)
    end
  else
    self.itemSkillPanel:SetActive(true)
  end
end

function MainViewSkillPage:HandleBreakCastByBokiState(note)
  local myself = Game.Myself
  if nil == myself then
    return
  end
  local creature = note.body and note.body.data
  if nil == creature then
    return
  end
  if nil == self.breakSkillCreatureID then
    return
  end
  local isBoki = creature.staticData and creature.staticData.Type == NpcData.NpcDetailedType.Boki
  if isBoki or myself == note.body then
    local status = creature.userdata:Get(UDEnum.STATUS)
    if ProtoCommon_pb.ECREATURESTATUS_DEAD == status then
      self:HandleBreakCastEnd()
    elseif ProtoCommon_pb.ECREATURESTATUS_LIVE == status then
      self:InitBreakSkill()
      self:ShowBreakSkill(true)
    end
  end
end

function MainViewSkillPage:HandleEnterSniperMode()
  TimeTickManager.Me():CreateTick(0, 50, self.UpdateSkillRange, self, 2)
  self:UpdateMaxAttackRange()
  self.updateRangeIndex = 0
end

function MainViewSkillPage:HandleExitSniperMode()
  TimeTickManager.Me():ClearTick(self, 2)
  self:ClearShowSkillRange()
  self.updateRangeIndex = nil
end

function MainViewSkillPage:UpdateSkillRange(deltaTime)
  if self.updateRangeIndex < 1 then
    self:UpdateMaxAttackRange()
    self.updateRangeIndex = 1
    return
  end
  local cells = self.skillShotCutList:GetCells()
  local cellCnt = #cells
  if cellCnt >= self.updateRangeIndex then
    cells[self.updateRangeIndex]:UpdateCastRangeStatus()
  end
  self.updateRangeIndex = self.updateRangeIndex + 1
  if cellCnt < self.updateRangeIndex then
    self.updateRangeIndex = 0
  end
end

function MainViewSkillPage:UpdateMaxAttackRange()
  local maxRange = 0
  local _LogicManager_Skill = Game.LogicManager_Skill
  local _myself = Game.Myself
  if MyselfProxy.Instance.selectAutoNormalAtk then
    local skillID = _myself.data:GetAttackSkillIDAndLevel()
    local skillInfo = _LogicManager_Skill:GetSkillInfo(skillID)
    if skillInfo and not _myself.data:GetLimitNotElement(skillID) then
      maxRange = skillInfo:GetIndicatorRange(_myself)
    end
  end
  local cells = self.skillShotCutList:GetCells()
  if not cells then
    FunctionSniperMode.Me():SetCurMaxAttackRange(maxRange)
    return
  end
  local cell, castRange
  for i = 1, #cells do
    cell = cells[i]
    if cell:IsAvailable() then
      skillInfo = _LogicManager_Skill:GetSkillInfo(cell.data:GetID())
      castRange = skillInfo and skillInfo:GetIndicatorRange(_myself) or 0
      if castRange and maxRange < castRange then
        maxRange = castRange
      end
    end
  end
  FunctionSniperMode.Me():SetCurMaxAttackRange(maxRange)
end

function MainViewSkillPage:ClearShowSkillRange()
  local cells = self.skillShotCutList:GetCells()
  for i = 1, #cells do
    cells[i]:ClearCastRangeStatus()
  end
end

function MainViewSkillPage:OnDemoRaidLaunch()
  self.isInDemoRaid = true
end

function MainViewSkillPage:OnDemoRaidShutdown()
  self.isInDemoRaid = false
end

local SpeicalComboMap = {
  [2523] = 2503
}

function MainViewSkillPage:GetRootCell(skillID)
  if skillID then
    local replaceSkillID = SpeicalComboMap[skillID] or skillID
    local cells = self.skillShotCutList:GetCells()
    for index, cell in pairs(cells) do
      if cell.data:GetRootID() == skillID or replaceSkillID == cell.data:GetRootID() then
        return cell
      end
    end
  end
  return nil
end

function MainViewSkillPage:WaitNextCombo(note)
  local skillID = note.body.parentID
  local skillItemData = note.body.skillItemData
  if skillID then
    local cell = self:GetRootCell(skillID)
    if cell then
      cell:SetData(skillItemData)
      self:_ShowWaitNextUseEffect(cell)
    end
  end
end

function MainViewSkillPage:_ShowWaitNextUseEffect(cell)
  if self.nextEffectCtrl == nil then
    self.nextEffectCtrl = self:PlayUIEffect(EffectMap.UI.SkillWait, self.phaseSkillEffect.transform, false, function(obj, args, effect)
      self.nextEffectCtrl = effect
      local x, y, z = LuaGameObject.InverseTransformPointByTransform(self.phaseSkillEffect.transform, cell.gameObject.transform, Space.World)
      self.nextEffectCtrl:ResetLocalPositionXYZ(x, y, z)
    end)
  end
end

function MainViewSkillPage:CancelWaitNextCombo(note)
  local skillID = note.body.parentID
  local skillItemData = note.body.skillItemData
  if skillItemData and skillID then
    local cell = self:GetRootCell(skillID)
    if cell then
      cell:SetData(skillItemData)
    end
  end
  if self.nextEffectCtrl then
    self.nextEffectCtrl:Destroy()
    self.nextEffectCtrl = nil
  end
end

function MainViewSkillPage:OnClickTempSkill(obj)
  local id = obj.data.data:GetID()
  xdlog("使用临时技能", id)
  if id and id ~= 0 then
    FunctionSkill.Me():TryUseSkill(id, Game.Myself:GetLockTarget())
  end
end

function MainViewSkillPage:HandlePlayerMapChange()
  xdlog("切图移除技能")
  SkillProxy.Instance:ClearQuestSkills()
  self:UpdateTempQuestSkills()
end

function MainViewSkillPage:ShowBreakSkillEffect(note)
  local cells = self.skillShotCutList:GetCells()
  local skillSortID = note.body
  for _, o in pairs(cells) do
    if o.data ~= nil and o.data:GetSortID() == skillSortID then
      o:ShowBreakSkillEffect()
    end
  end
end

function MainViewSkillPage:UpdateCDTimes(note)
  local cells = self.skillShotCutList:GetCells()
  local skillSortID = note.body
  for _, o in pairs(cells) do
    if o.data ~= nil and o.data:GetSortID() == skillSortID then
      o:UpdateCDTimes()
    end
  end
end

function MainViewSkillPage:HandleBellCharge(note)
  local skillSortID = note.body
  local cells = self.skillShotCutList:GetCells()
  for _, o in pairs(cells) do
    if o.data ~= nil and o.data:GetSortID() == skillSortID then
      o:UpdateChargeBuff()
    end
  end
end
