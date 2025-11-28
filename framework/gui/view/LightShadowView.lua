autoImport("LightShadowModelCell")
LightShadowView = class("LightShadowView", ContainerView)
LightShadowView.ViewType = UIViewType.NormalLayer
local _CircleTexName = "qws_bg_circular"
local _LineTexName = "chapter_bg_line"
local _MiniSpStatusName = {
  "qws_icon_position",
  "qws_icon_position02",
  "qws_icon_Select"
}
local _MiniSpPreName = "pos"
local _DirectionPos = {
  "Top",
  "Down",
  "Left",
  "Right"
}
local _DirectionColor = {
  [1] = LuaColor.New(1, 1, 1, 1),
  [2] = LuaColor.New(0.2784313725490196, 0.2784313725490196, 0.2784313725490196, 1)
}
local _FunctionBrick, _PicMgr
local _guideStepSuccessEffect = ResourcePathHelper.UIEffect("home_guide")
local _guideGirlEmoji = ResourcePathHelper.Emoji("homeguide")
local _guideGirlEmojiAnimation = "homegirl"
local _homeGuide = "home_guide_good"
local _EmojiPos = LuaGeometry.GetTempVector3(0, 65, 0)
local _SliderEffect = GameConfig.Bricks.effect or "eff_21days_tips"
local _successStartProgress = 0.86
local _SetLocalPositionGo = LuaGameObject.SetLocalPositionGO
local _successBGMusic = GameConfig.Bricks.bgm
local _ratio = GameConfig.Bricks.rotateSpeedRatio or 1
local _pressRotateSpeed = GameConfig.Bricks.pressRotateSpeed or 1
local _getLocalPos = LuaGameObject.GetLocalPositionGO
local _beginTweenAnim = TweenPosition.Begin
local _beginTweenAlpha = TweenAlpha.Begin
local _EvtMrg
local _tmpPos = LuaVector3.Zero()
local _tweenOffset = 300
local _tweenDuration = 1

function LightShadowView:Init()
  _EvtMrg = EventManager.Me()
  _FunctionBrick = FunctionShadowBricks.Me()
  _PicMgr = PictureManager.Instance
  self:FindObj()
  self:AddUIEvt()
  self:AddEvent()
  self:InitViewGuide()
end

function LightShadowView:OnEnter()
  FunctionCameraEffect.Me():ResetFreeCameraLocked(true, nil, nil, 1)
  LightShadowView.super.OnEnter(self)
  _PicMgr:SetUI(_CircleTexName, self.circleTex)
  _PicMgr:SetUI(_LineTexName, self.lineTexture)
  self:InitFinalTex()
  self:UpdateLightShadowItem()
  self:ClearDelayTick()
  _FunctionBrick.enterViewMoving = true
  self.delayTick = TimeTickManager.Me():CreateOnceDelayTick(2000, function(owner, deltaTime)
    _FunctionBrick.enterViewMoving = false
    self:ClickValidModel()
    _FunctionBrick:GuideBegin()
    self.delayTick = nil
  end, self, 2)
end

function LightShadowView:UpdateLightShadowItem()
  local bricks = _FunctionBrick:GetBrickList()
  self.modelChooseItemCtl:ResetDatas(bricks)
end

function LightShadowView:FindObj()
  self.closeBtn = self:FindGO("CloseButton")
  self.touchZone = self:FindGO("TouchZone")
  self.positionOption = self:FindGO("PositionOption")
  self.modelTex = self:FindComponent("ModelTexture", UITexture)
  self.circleTex = self:FindComponent("CircleTex", UITexture, self.positionOption)
  self:InitDirMap()
  self.rightRoot = self:FindGO("RightRoot")
  self.lineTexture = self:FindComponent("LineTexture", UITexture, self.rightRoot)
  local modelChooseGrid = self:FindComponent("ModelChooseGrid", UIGrid, self.rightRoot)
  self.modelChooseItemCtl = UIGridListCtrl.new(modelChooseGrid, LightShadowModelCell, "LightShadowModelCell")
  self.modelChooseItemCtl:AddEventListener(MouseEvent.MouseClick, self.OnClickModelChooseCell, self)
  self.centerRoot = self:FindGO("CenterRoot")
  self.centerBtn = self:FindGO("Btn", self.centerRoot)
  self.centerBgObj = self:FindGO("Bg", self.centerRoot)
  self.finalTex = self:FindComponent("FinalTex", UITexture, self.centerRoot)
  self.effectContainer = self:FindGO("EffectContainer", self.centerRoot)
  self.centerRoot:SetActive(false)
  self.rightRoot:SetActive(true)
  self.positionOption:SetActive(true)
  self.centerBtn:SetActive(false)
  self.progressSlider = self:FindComponent("ProgressSlider", UISprite)
  self.progressThumb = self:FindGO("Thumb", self.progressSlider.gameObject)
  self.progressThumbInitX = self.progressThumb.transform.localPosition.x
  self.progressTotalWidth = self.progressSlider.width
  self.effContainer = self:FindGO("ThumbEffectContainer")
  self.lerpImage = self:FindComponent("LerpImage", UISprite, self.progressSlider.gameObject)
  self:_resetProgressSlider()
  self:_initPressRotate()
end

function LightShadowView:_initPressRotate()
  self.leftPressRotateBtn = self:FindGO("LeftRot", self.rightRoot)
  self.rightPressRotateBtn = self:FindGO("RightRot", self.rightRoot)
  self:AddPressEvent(self.leftPressRotateBtn, function(go, isPress)
    self.pressSpeed = _pressRotateSpeed
    self:OnPress(go, isPress)
  end)
  self:AddPressEvent(self.rightPressRotateBtn, function(go, isPress)
    self.pressSpeed = -_pressRotateSpeed
    self:OnPress(go, isPress)
  end)
end

function LightShadowView:OnPress(obj, isPress)
  if not self.curBrick then
    return
  end
  if _FunctionBrick:CheckOptionInValid() then
    return
  end
  local inUIRotateGuide = _FunctionBrick:InUIRotateGuide()
  local inProgressGuide = _FunctionBrick:InProgressGuide()
  if _FunctionBrick:InGuide() and not inUIRotateGuide and not inProgressGuide then
    return
  end
  self:_ClearPressTick()
  if isPress then
    self.curPressObj = obj
    self:_PressTickOn()
  else
    self.pressTime = nil
    _FunctionBrick:DoCheck()
  end
end

function LightShadowView:_PressTickOn()
  self.pressTick = TimeTickManager.Me():CreateTick(0, 30, function()
    self.pressTime = self.pressTime or 0
    self.pressTime = self.pressTime + UnityDeltaTime
    _FunctionBrick:DoRotateTargetAroundNormal(self.pressSpeed, self.uiModelTransform)
    if _FunctionBrick:InUIRotateGuide() and self.pressTime > _FunctionBrick.pressRotateTime then
      self.pressTime = nil
      self:OnGuideStepSuccess()
    end
  end, self, 5)
end

function LightShadowView:_ClearPressTick()
  if self.pressTick then
    self.pressTick:Destroy()
    self.pressTick = nil
  end
end

function LightShadowView:_resetProgressSlider()
  self:Show(self.progressSlider)
  self.progressSlider.fillAmount = 0
  self:Show(self.lerpImage)
  if self.successEffect and nil ~= self.successEffect.args[6] and not LuaGameObject.ObjectIsNull(self.successEffect.args[6]) then
    self.successEffect.effectObj:SetActive(false)
  end
  _SetLocalPositionGo(self.progressThumb, self.progressThumbInitX, 0, 0)
end

function LightShadowView:InitFinalTex()
  local texName, texOffset, texSize = _FunctionBrick:GetTextureInfo()
  if texName then
    _PicMgr:SetBrickTexture(texName, self.finalTex)
    if texOffset then
      self.finalTex.gameObject.transform.localPosition = LuaGeometry.GetTempVector3(texOffset[1], texOffset[2], texOffset[3])
    end
    if texSize then
      self.finalTex.width = texSize[1]
      self.finalTex.height = texSize[2]
    end
    self.texName = texName
  end
end

function LightShadowView:AddUIEvt()
  self:AddClickEvent(self.centerBtn, function(go)
    _FunctionBrick:TryNtfFinishQuest()
    self:CloseSelf()
  end)
  for dir = 1, 4 do
    self:AddClickEvent(self.posDirection[dir].gameObject, function(go)
      if _FunctionBrick:CheckOptionInValid() then
        return
      end
      if not self.curBrick then
        return
      end
      if _FunctionBrick:InGuide() then
        if _FunctionBrick:InMoveGuide() and _FunctionBrick.waitMoveDir == dir then
          self:OnGuideStepSuccess()
        else
          return
        end
      end
      _FunctionBrick:MoveBegin(dir)
    end)
  end
  self:AddDragEvent(self.touchZone, function(obj, delta)
    if _FunctionBrick:CheckOptionInValid() then
      return
    end
    if not self.curBrick then
      return
    end
    if not self.uiModel then
      return
    end
    if _FunctionBrick:InGuide() and not _FunctionBrick:InProgressGuide() and not _FunctionBrick:InModelRotateGuide() then
      return
    end
    _FunctionBrick:DoRotate(delta.x * _ratio, delta.y * _ratio, self.uiModel.transform)
    if _FunctionBrick:InModelRotateGuide() then
      self:OnGuideStepSuccess()
    end
  end)
end

function LightShadowView:AddEvent()
  _EvtMrg:AddEventListener(LightShadowEvent.PosChanged, self.OnPosChanged, self)
  _EvtMrg:AddEventListener(LightShadowEvent.BricksStepFinished, self.OnBricksStepFinished, self)
  _EvtMrg:AddEventListener(LightShadowEvent.BricksAllFinished, self.OnBricksFinished, self)
  _EvtMrg:AddEventListener(ServiceEvent.ConnReconnect, self.CloseSelf, self)
  _EvtMrg:AddEventListener(LightShadowEvent.GuideStepUpdate, self.OnGuideUpdate, self)
  _EvtMrg:AddEventListener(LightShadowEvent.FirstInPrpgress, self.OnFirstInProgress, self)
  _EvtMrg:AddEventListener(LightShadowEvent.DisplayProgress, self.OnProgressChanged, self)
  _EvtMrg:AddEventListener(LightShadowEvent.SingleBrickSuccess, self.HandleSingleBrickSuccess, self)
end

function LightShadowView:RemoveEvent()
  _EvtMrg:RemoveEventListener(LightShadowEvent.PosChanged, self.OnPosChanged, self)
  _EvtMrg:RemoveEventListener(LightShadowEvent.BricksStepFinished, self.OnBricksStepFinished, self)
  _EvtMrg:RemoveEventListener(LightShadowEvent.BricksAllFinished, self.OnBricksFinished, self)
  _EvtMrg:RemoveEventListener(ServiceEvent.ConnReconnect, self.CloseSelf, self)
  _EvtMrg:RemoveEventListener(LightShadowEvent.GuideStepUpdate, self.OnGuideUpdate, self)
  _EvtMrg:RemoveEventListener(LightShadowEvent.DisplayProgress, self.OnProgressChanged, self)
  _EvtMrg:RemoveEventListener(LightShadowEvent.FirstInPrpgress, self.OnFirstInProgress, self)
  _EvtMrg:RemoveEventListener(LightShadowEvent.SingleBrickSuccess, self.HandleSingleBrickSuccess, self)
end

function LightShadowView:OnProgressChanged(value)
  if value == self.curProgress then
    return
  end
  self:_SetProgress(value)
  if _FunctionBrick:InProgressGuide() then
    self:OnGuideStepSuccess()
  end
end

function LightShadowView:OnFirstInProgress()
  if _FunctionBrick:InProgressGuide() then
    self:OnGuideStepSuccess()
  end
end

function LightShadowView:_SetProgress(value)
  self.curProgress = math.clamp(value, 0, 100)
  self.curProgress = math.floor(self.curProgress)
  local progress = self.curProgress / 100 * _successStartProgress
  self.progressSlider.fillAmount = progress
  local x = self.progressThumbInitX + self.progressTotalWidth * progress
  _SetLocalPositionGo(self.progressThumb, x, 0, 0)
end

function LightShadowView:InitViewGuide()
  local guideConfig = _FunctionBrick:GetGuideConfig()
  if not guideConfig then
    return
  end
  local congratulationsPanel = self:FindGO("CongratulationsPanel")
  self.successTex = self:FindComponent("SuccessTex", UITexture, congratulationsPanel)
  PictureManager.Instance:SetUI(_homeGuide, self.successTex)
  self.guideEffClickableObj = self:FindGO("Congratulations", congratulationsPanel)
  self.guideSteps = {}
  for i = 1, #guideConfig do
    self.guideSteps[i] = self:FindGO("Guide_" .. tostring(i))
    self.guideSteps[i]:SetActive(false)
  end
end

function LightShadowView:MoveToNextGuide()
  if not _FunctionBrick:InGuide() then
    return
  end
  self.guideEffClickableObj:SetActive(false)
  self:Hide(self.successTex)
  _FunctionBrick:OnGuideStepSuccess()
  if not _FunctionBrick:InGuide() and self.curStepObj then
    self.curStepObj:SetActive(false)
  end
  self:_ClearAutoGuideTick()
end

function LightShadowView:OnGuideStepSuccess()
  if nil ~= self.autoMoveNextGuideTick then
    return
  end
  self:Show(self.successTex)
  self.successTex.transform.position = self.successPos.transform.position
  if _FunctionBrick:InGuide() then
    self:_ClearAutoGuideTick()
    if not _FunctionBrick:IsLastGuideStep() then
      self.guideEffClickableObj:SetActive(true)
      self.autoMoveNextGuideTick = TimeTickManager.Me():CreateOnceDelayTick(1000, self.MoveToNextGuide, self, 5)
    end
  end
end

function LightShadowView:OnGuideUpdate()
  local curStepObj = _FunctionBrick:GetGuideStep()
  if nil == self.guideSteps[curStepObj] then
    return
  end
  if self.curStepObj then
    self.curStepObj:SetActive(false)
  end
  self.curStepObj = self.guideSteps[curStepObj]
  self.curStepObj:SetActive(true)
  self.successPos = self:FindGO("SuccessTex", self.curStepObj)
  self.guideContent = self:FindComponent("labContent", UILabel, self.curStepObj)
  self.guideContent.text = _FunctionBrick.guideContent
  if _FunctionBrick:InChooseGuide() then
    self:SetGuideChooseBrickPos()
  end
  self:UpdateOptionSprite()
end

function LightShadowView:InitDirMap()
  self:_InitDirection()
  self:_InitMiniMap()
end

function LightShadowView:_InitDirection()
  self.posDirection = {}
  self.posDirectionColider = {}
  for i = 1, #_DirectionPos do
    self.posDirection[i] = self:FindComponent(_DirectionPos[i], UISprite, self.positionOption)
    self.posDirectionColider[i] = self:FindComponent(_DirectionPos[i], BoxCollider, self.positionOption)
  end
end

function LightShadowView:_InitMiniMap()
  self.miniPosIndexSp = {}
  self.miniPosGrid = self:FindComponent("MiniPosGrid", UIGrid, self.positionOption)
  for i = 1, 9 do
    local cellSp = self:FindComponent(_MiniSpPreName .. tostring(i), UISprite, self.miniPosGrid.gameObject)
    self.miniPosIndexSp[i] = cellSp
  end
end

function LightShadowView:UpdateOptionSprite()
  self:_updateMiniPosImg()
  self:_updateDirImage()
end

function LightShadowView:_updateMiniPosImg()
  for slot, sp in pairs(self.miniPosIndexSp) do
    if _FunctionBrick:IsBrickDone(slot) then
      sp.spriteName = _MiniSpStatusName[2]
    else
      sp.spriteName = slot == self.curSlot and _MiniSpStatusName[3] or _MiniSpStatusName[1]
    end
  end
end

function LightShadowView:_updateDirImage()
  local curSlot = self.curSlot
  for dir = 1, 4 do
    if FunctionShadowBricks.DirPosConfig[dir][curSlot] then
      self.posDirection[dir].color = _DirectionColor[2]
      self.posDirectionColider[dir].enabled = false
    elseif FunctionShadowBricks.DirPosConfig[dir][curSlot + FunctionShadowBricks.UnitMove[dir]] and _FunctionBrick:IsBrickDone(curSlot + FunctionShadowBricks.UnitMove[dir]) then
      self.posDirection[dir].color = _DirectionColor[2]
      self.posDirectionColider[dir].enabled = false
    elseif _FunctionBrick:IsBrickDone(curSlot + FunctionShadowBricks.UnitMove[dir]) and _FunctionBrick:IsBrickDone(curSlot + FunctionShadowBricks.UnitMove[dir] * 2) then
      self.posDirection[dir].color = _DirectionColor[2]
      self.posDirectionColider[dir].enabled = false
    else
      self.posDirection[dir].color = _DirectionColor[1]
      self.posDirectionColider[dir].enabled = not _FunctionBrick:InGuide() or _FunctionBrick.waitMoveDir == dir
    end
  end
end

function LightShadowView:ClickValidModel()
  local cells = self.modelChooseItemCtl:GetCells()
  if 0 < #cells then
    for i = 1, #cells do
      if not _FunctionBrick:IsBrickDone(cells[i].data.targetSlotIndex) then
        self:OnClickModelChooseCell(cells[i], true)
        break
      end
    end
  end
end

function LightShadowView:SetGuideChooseBrickPos()
  local cells = self.modelChooseItemCtl:GetCells()
  if 0 < #cells then
    for i = 1, #cells do
      if cells[i].data.ID == _FunctionBrick.waitChooseBrickId then
        self.curStepObj.transform.position = cells[i].gameObject.transform.position
        break
      end
    end
  end
end

function LightShadowView:HandleSingleBrickSuccess()
  self:_ClearPressTick()
  self:Hide(self.lerpImage)
  self:MoveToNextGuide()
  self:_CreatSliderLerp()
  self:_PlaySuccessAudio()
  self:_PlayDoneTweenAnim()
end

function LightShadowView:AddCloseButtonEvent()
  self:AddButtonEvent("CloseButton", function()
    if _FunctionBrick.isLerping then
      return
    end
    self:CloseSelf()
  end)
end

function LightShadowView:_PlaySuccessAudio()
  if not _successBGMusic then
    return
  end
  AudioUtility.PlayOneShot2D_Path(_successBGMusic)
end

function LightShadowView:_PlayDoneTweenAnim()
  if not _FunctionBrick:IsAllBrickDone() then
    return
  end
  UIManagerProxy.Instance:NeedEnableAndroidKey(false)
  _tmpPos[1], _tmpPos[2] = _getLocalPos(self.closeBtn)
  _tmpPos[1] = _tmpPos[1] - _tweenOffset
  _beginTweenAnim(self.closeBtn, _tweenDuration, _tmpPos, false)
  _tmpPos[1], _tmpPos[2] = _getLocalPos(self.positionOption)
  _tmpPos[1] = _tmpPos[1] - _tweenOffset
  _beginTweenAnim(self.positionOption, _tweenDuration, _tmpPos, false)
  _beginTweenAlpha(self.modelTex.gameObject, _tweenDuration, 0)
  self.touchZone:SetActive(false)
  _beginTweenAlpha(self.leftPressRotateBtn, _tweenDuration, 0)
  _beginTweenAlpha(self.rightPressRotateBtn, _tweenDuration, 0)
  _tmpPos[1], _tmpPos[2] = _getLocalPos(self.rightRoot)
  _tmpPos[1] = _tmpPos[1] + _tweenOffset
  _beginTweenAnim(self.rightRoot, _tweenDuration, _tmpPos, false)
end

function LightShadowView:_CreatSliderLerp()
  self:_ClearProgressTick()
  if self.successEffect and nil ~= self.successEffect.args[6] and not LuaGameObject.ObjectIsNull(self.successEffect.args[6]) then
    self.successEffect.effectObj:SetActive(true)
  else
    self:PlayUIEffect(_SliderEffect, self.effContainer, true, function(obj, args, assetEffect)
      self.successEffect = assetEffect
    end)
  end
  self.progressTick = TimeTickManager.Me():CreateTick(0, 33, self.LerpProgress, self, 4)
end

function LightShadowView:LerpProgress(deltaTime)
  local newValue = self.progressSlider.fillAmount + deltaTime / 10000
  self.progressSlider.fillAmount = newValue
  local x = self.progressThumbInitX + self.progressTotalWidth * newValue
  _SetLocalPositionGo(self.progressThumb, x, 0, 0)
  if self.progressSlider.fillAmount >= 1 then
    self:_ClearProgressTick()
  end
end

function LightShadowView:OnBricksStepFinished()
  self:ClearDelayTick()
  self:UpdateLightShadowItem()
  _beginTweenAlpha(self.modelTex.gameObject, 1, 0)
  self.delayTick = TimeTickManager.Me():CreateOnceDelayTick(1000, function(owner, deltaTime)
    self:ClickValidModel()
    _beginTweenAlpha(self.modelTex.gameObject, 1, 1)
    self.delayTick = nil
  end, self, 2)
end

function LightShadowView:OnBricksFinished()
  _FunctionBrick:NotifyQuestStep()
  self:ClearDelayTick()
  self:UpdateLightShadowItem()
  self:Hide(self.progressSlider)
  self.delayTick = TimeTickManager.Me():CreateOnceDelayTick(2500, function(owner, deltaTime)
    self.centerRoot:SetActive(true)
    _FunctionBrick:AllBrickFadeOut()
    _beginTweenAlpha(self.finalTex.gameObject, 3, 1)
    _beginTweenAlpha(self.centerBgObj, 3, 0.35)
    self.btnDelayTick = TimeTickManager.Me():CreateOnceDelayTick(1500, function(owner, deltaTime)
      self.centerBtn:SetActive(true)
      self:PlayUIEffect(EffectMap.UI.BrickSuccess, self.effectContainer)
      self.btnDelayTick = nil
    end, self, 3)
    self.delayTick = nil
  end, self, 2)
end

function LightShadowView:ClearDelayTick()
  if self.delayTick then
    self.delayTick:Destroy()
    self.delayTick = nil
  end
  if self.btnDelayTick then
    self.btnDelayTick:Destroy()
    self.btnDelayTick = nil
  end
end

function LightShadowView:_ClearProgressTick()
  if self.progressTick then
    self.progressTick:Destroy()
    self.progressTick = nil
  end
end

function LightShadowView:_ClearAutoGuideTick()
  if self.autoMoveNextGuideTick then
    self.autoMoveNextGuideTick:Destroy()
    self.autoMoveNextGuideTick = nil
  end
end

function LightShadowView:OnClickModelChooseCell(cell, isAuto)
  if _FunctionBrick:CheckOptionInValid() then
    return
  end
  local data = cell.data
  if data.done then
    return
  end
  local pickID = data.ID
  if _FunctionBrick:InGuide() then
    if _FunctionBrick:InChooseGuide() and pickID == _FunctionBrick.waitChooseBrickId then
      self:OnGuideStepSuccess()
    else
      return
    end
  end
  if self.curBrick and self.curBrick.ID == pickID then
    return
  end
  local itemCells = self.modelChooseItemCtl:GetCells()
  for i = 1, #itemCells do
    itemCells[i]:SetChooseId(pickID)
  end
  self.curBrick = data
  local initialSlot = _FunctionBrick:GetInitializedBrickSlot()
  if not initialSlot then
    redlog("LightShadowView 未找到初始位置")
    return
  end
  helplog("--------光影初始位置： ", initialSlot)
  self.curSlot = initialSlot
  _FunctionBrick:SetCurSlot(initialSlot)
  self:UpdateOptionSprite()
  self:_LoadUIModel(initialSlot, isAuto)
  self:_resetProgressSlider()
end

function LightShadowView:_LoadUIModel(initialSlot, isAuto)
  local brick = self.curBrick
  local sysRotation = FunctionShadowBricks.Me():GetSystemRotation()
  UIModelUtil.Instance:ResetTexture(self.modelTex)
  UIModelUtil.Instance:SetCellTransparent(self.modelTex)
  UIModelUtil.Instance:SetBricksTexture(self.modelTex, brick.ID, sysRotation, function(obj)
    self.uiModel = obj
    self.uiModelTransform = self.uiModel.transform
    local shadowObj = self.uiModel:GetComponent(ShadowPuzzleObject)
    if shadowObj then
      shadowObj:SetRotatePivot(brick.centerOffset)
      shadowObj:SetTargetRotation(brick.defaultRotation)
      shadowObj:SetLocalRotation(LuaVector3.Zero())
      shadowObj:SetTargetScale(brick.defaultScale)
      _FunctionBrick:SetUIModelShadowObj(shadowObj)
    end
    if self.modelTex then
      if isAuto then
        self.modelTex.alpha = 0
        _beginTweenAlpha(self.modelTex.gameObject, 2, 1)
      else
        self.modelTex.alpha = 1
      end
    end
    _FunctionBrick:DoPickBrick(brick.ID, initialSlot, isAuto)
  end)
end

function LightShadowView:OnPosChanged(pos)
  self.curSlot = pos
  self:UpdateOptionSprite()
  _FunctionBrick:DoMove(pos)
end

function LightShadowView:OnExit()
  FunctionCameraEffect.Me():ResetFreeCameraLocked()
  UIManagerProxy.Instance:NeedEnableAndroidKey(true, UIManagerProxy.GetDefaultNeedEnableAndroidKeyCallback())
  LightShadowView.super.OnExit(self)
  _PicMgr:UnLoadUI(_CircleTexName, self.circleTex)
  _PicMgr:UnLoadUI(_LineTexName, self.lineTexture)
  if self.texName then
    _PicMgr:UnloadBrickTexture(self.texName, self.finalTex)
  end
  self:RemoveEvent()
  self:ClearDelayTick()
  self:_ClearProgressTick()
  self:_ClearAutoGuideTick()
  self:_ClearPressTick()
  _PicMgr:UnLoadUI(_homeGuide, self.successTex)
  UIModelUtil.Instance:ResetTexture(self.modelTex)
  _FunctionBrick:Exit()
end
