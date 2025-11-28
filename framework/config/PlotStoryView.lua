autoImport("BaseView")
autoImport("PlotStoryNarratorTextLineCell")
PlotStoryView = class("PlotStoryView", BaseView)
PlotStoryView.ViewType = UIViewType.InterstitialLayer
autoImport("NormalButtonCell")
local tempPos = LuaVector3()
local style_Subtitle = 2
local style_Narrator = 2
local handlerBgName = "fb_bg_Joystick"
local handlerCenterName = "fb_bg_Joystick2"
local handlerGuideEffect = "ufx_pattern_001_prf"
local centerV3 = LuaVector3.Zero()

function PlotStoryView:Init()
  self.collider = self:FindGO("Collider")
  self:FindObj_Subtitle()
  self:FindObj_Narrator()
  self.roleController = self:FindGO("handler")
  self.controllerTex = self.roleController:GetComponent(UITexture)
  self.controllerCenter = self:FindGO("center", self.roleController)
  self.controllerCenterTex = self.controllerCenter:GetComponent(UITexture)
  self.controllerGuideEffect = self:FindGO("effectContainer", self.roleController)
  local x, y, z = LuaGameObject.GetLocalPosition(self.controllerCenter.transform)
  LuaVector3.Better_Set(centerV3, x, y, z)
  self.maxDis = self.controllerTex.width * 0.5
  self.isRunOnEditor = ApplicationInfo.IsRunOnEditor()
  self.isRunOnWindows = ApplicationInfo.IsRunOnWindowns()
  self.touchSupported = Input.touchSupported
  local layer = LayerMask.NameToLayer("UI")
  self.uiCamera = NGUITools.FindCameraForLayer(layer)
  TweenAlpha.Begin(self.roleController, 0, 0)
  self.bgmBtn = self:FindGO("bgmBtn")
  self.bgmIcon = self:FindComponent("icon", UIMultiSprite, self.bgmBtn)
  self:AddClickEvent(self.bgmBtn, function()
    self:OnBgmBtnClick()
  end)
  self.bgmBtn:SetActive(false)
  self.plotTex = self:FindComponent("PlotTex", UITexture)
  self.effectTrans = self.gameObject.transform
  self.buttonMap = {}
  self:MapEvent()
end

function PlotStoryView:OnEnter()
  PlotStoryView.super.OnEnter(self)
  PlotStoryView.Instance = self
  Game.DisableJoyStick = true
  PictureManager.Instance:SetPlotEDTexture(handlerBgName, self.controllerTex)
  PictureManager.Instance:SetPlotEDTexture(handlerCenterName, self.controllerCenterTex)
  GameFacade.Instance:sendNotification(UIEvent.CloseUI, UIViewType.DialogLayer)
  GameFacade.Instance:sendNotification(UIEvent.CloseUI, UIViewType.PopUpLayer)
  GameFacade.Instance:sendNotification(InviteConfirmEvent.TempHide)
  self:CreateBWLoadingMask()
end

function PlotStoryView:OnExit()
  Game.DisableJoyStick = false
  PlotStoryView.Instance = nil
  TimeTickManager.Me():ClearTick(self)
  PictureManager.Instance:UnloadPlotEDTexture(handlerBgName, self.controllerTex)
  PictureManager.Instance:UnloadPlotEDTexture(handlerCenterName, self.controllerCenterTex)
  GameFacade.Instance:sendNotification(InviteConfirmEvent.RecoverFromTempHide)
  self:DestroyBWLoadingMask()
  PlotStoryView.super.OnExit(self)
end

function PlotStoryView:AddButton(buttonData)
  if not buttonData or not buttonData.clickEvent then
    return
  end
  local cellData = {}
  cellData.id = buttonData.id
  
  function cellData.event()
    if buttonData.clickEventParam then
      buttonData.clickEvent(buttonData.clickEventParam, buttonData)
    end
    if buttonData.removeWhenClick then
      self:RemoveButton(cellData.id)
    end
    if buttonData.questData then
      local questData = buttonData.questData
      QuestProxy.Instance:notifyQuestState(questData.scope, questData.id, questData.staticData.FinishJump)
    end
  end
  
  cellData.text = buttonData.text
  cellData.isInvisible = buttonData.isInvisible
  cellData.buttonSize = buttonData.buttonSize
  local buttonCell = self.buttonMap[buttonData.id]
  if not buttonCell then
    buttonCell = NormalButtonCell.new(NormalButtonCell.CreateButton(self.gameObject))
    self.buttonMap[buttonData.id] = buttonCell
  end
  buttonCell:SetData(cellData)
  local go = buttonCell.gameObject
  if buttonData.pos then
    LuaVector3.Better_Set(tempPos, buttonData.pos[1], buttonData.pos[2], buttonData.pos[3])
  else
    LuaVector3.Better_Set(tempPos, 450, -250, 0)
  end
  go.transform.localPosition = tempPos
end

function PlotStoryView:RemoveButton(buttonId)
  if not buttonId then
    return
  end
  local cell = self.buttonMap[buttonId]
  if cell and not Slua.IsNull(cell.gameObject) then
    GameObject.Destroy(cell.gameObject)
  end
  self.buttonMap[buttonId] = nil
end

function PlotStoryView:MapEvent()
  self:AddListenEvt(PlotStoryViewEvent.AddButton, self.HandleAddButton)
  self:AddListenEvt(PlotStoryViewEvent.PlaySubTitle, self.HandlePlaySubTitle)
  self:AddListenEvt(PlotStoryViewEvent.HideSubTitle, self.HandleHideSubTitle)
  self:AddListenEvt(PlotStoryViewEvent.PlayNarrator, self.HandlePlayNarrator)
  self:AddListenEvt(PlotStoryViewEvent.ShowRoleController, self.ShowRoleController)
  self:AddListenEvt(PlotStoryViewEvent.HideRoleController, self.HideRoleController)
  self:AddListenEvt(PlotStoryViewEvent.ShowBgmButton, self.HandleShowBgmButton)
  self:AddListenEvt(PlotStoryViewEvent.AddPicture, self.HandleAddPicture)
  self:AddListenEvt(PlotStoryViewEvent.RemovePicture, self.HandleRemovePicture)
  self:AddListenEvt(PlotStoryViewEvent.StartBWLoadingMask, self.StartBWLoadingMask)
  self:AddListenEvt(PlotStoryViewEvent.StopBWLoadingMask, self.StopBWLoadingMask)
end

function PlotStoryView:HandleAddButton(note)
  self:AddButton(note.body)
end

function PlotStoryView:HandlePlaySubTitle(note)
  local text, time, fade = note.body.text, note.body.time, note.body.fade
  self:ShowSubtitle(text, time, fade)
end

function PlotStoryView:HandleHideSubTitle(note)
  local fade = note.body.fade
  self:HideSubtitle(fade)
end

function PlotStoryView:HandlePlayNarrator(note)
  local text, time, fontSize, lineHeight, timeInterval, fadeInTime = note.body.text, note.body.time, note.body.fontSize, note.body.lineHeight, note.body.timeInterval, note.body.fadeInTime
  if style_Narrator == 1 then
    self:ShowNarrator_Style1(text, time)
  else
    self:ShowNarrator_Style2(text, time, timeInterval, fadeInTime, fontSize, lineHeight)
  end
end

function PlotStoryView:HandleShowBgmButton(note)
  self:ShowBgmButton()
end

function PlotStoryView:HandleAddPicture(note)
  local params = note.body
  local name = params.name
  PictureManager.Instance:SetPlotViewTexture(name, self.plotTex)
  self.plotTex:MakePixelPerfect()
  PictureManager.ReFitManualHeight(self.plotTex)
end

function PlotStoryView:HandleRemovePicture(note)
  local params = note.body
  local name = params.name
  PictureManager.Instance:UnloadPlotViewTexture(name, self.plotTex)
end

local fadeDuration = 0.8

function PlotStoryView:FindObj_Subtitle()
  local subtitle_s1 = self:FindGO("Subtitle(Style1)")
  local subtitle_s2 = self:FindGO("Subtitle(Style2)")
  if style_Subtitle == 1 then
    subtitle_s1:SetActive(true)
    subtitle_s2:SetActive(false)
    self.subtitle = subtitle_s1
  else
    subtitle_s1:SetActive(false)
    subtitle_s2:SetActive(true)
    self.subtitle = subtitle_s2
    self.subtitleBg = self:FindComponent("bg", UISprite, self.subtitle)
  end
  self.subtitle_text = self:FindComponent("text", UILabel, self.subtitle)
  self.subtitle_tpos = self.subtitle:GetComponent(TweenPosition)
  self.subtitle_talpha = self.subtitle:GetComponent(TweenAlpha)
end

function PlotStoryView:ShowSubtitle(text, time, fade)
  if time and time < 2 then
    fade = false
  end
  text = self:ParseText(text)
  self.subtitle_text.text = text
  UIUtil.FitLabelHeight(self.subtitle_text, 1200)
  if self.subtitleBg then
    self.subtitleBg:UpdateAnchors()
  end
  if fade then
    self.subtitle_tpos.enabled = true
    self.subtitle_tpos:PlayForward()
    self.subtitle_talpha.enabled = true
    self.subtitle_talpha:PlayForward()
  else
    self.subtitle_tpos:Sample(1, true)
    self.subtitle_tpos.enabled = false
    self.subtitle_talpha:Sample(1, true)
    self.subtitle_talpha.enabled = false
  end
  if time then
    if fade then
      time = time - fadeDuration
      if time < 0 then
        time = 0
      end
    end
    self.delayedFadeOutTween = TimeTickManager.Me():CreateOnceDelayTick(time * 1000, function(owner, deltaTime)
      self:HideSubtitle(fade)
      self.delayedFadeOutTween = nil
    end, self)
  end
end

function PlotStoryView:HideSubtitle(fade)
  if fade then
    self.subtitle_tpos.enabled = true
    self.subtitle_tpos:PlayReverse()
    self.subtitle_talpha.enabled = true
    self.subtitle_talpha:PlayReverse()
  else
    self.subtitle_tpos:Sample(0, true)
    self.subtitle_tpos.enabled = false
    self.subtitle_talpha:Sample(0, true)
    self.subtitle_talpha.enabled = false
  end
end

function PlotStoryView:FindObj_Narrator()
  if style_Narrator == 1 then
    self.narrator = self:FindGO("Narrator(Style1)")
    self.narrator_text = self:FindComponent("text", UILabel, self.narrator)
    self.narrator_rollmask = self:FindGO("mask", self.narrator)
  else
    self.narrator = self:FindGO("Narrator(Style2)")
    local lineGrid = self:FindComponent("table", UIGrid, self.narrator)
    self.narratorTextLineList = UIGridListCtrl.new(lineGrid, PlotStoryNarratorTextLineCell, "PlotStoryNarratorTextLineCell")
  end
end

function PlotStoryView:ShowNarrator_Style1(text, time)
  text = self:ParseText(text)
  self.narrator:SetActive(true)
  LuaVector3.Better_Set(tempPos, LuaGameObject.GetLocalPosition(self.narrator_rollmask.transform))
  tempPos[2] = 400
  self.narrator_rollmask.transform.localPosition = tempPos
  self.narrator_text.text = text
  local ylen = self.narrator_text.printedSize.y
  tempPos[2] = ylen / 2
  self.narrator_rollmask.transform.localPosition = tempPos
  tempPos[2] = -ylen / 2
  TweenPosition.Begin(self.narrator_rollmask, time, tempPos, false):SetOnFinished(function()
    self:HideNarrator()
  end)
end

local fadeInTimePct = 0.2

function PlotStoryView:ShowNarrator_Style2(text, time, timeInterval, fadeInTime, fontSize, lineHeight)
  text = self:ParseText(text)
  local textLines = string.split(text, "\n")
  local totalLine = #textLines
  timeInterval = timeInterval or 0
  fadeInTime = fadeInTime or 0
  self.narrator:SetActive(true)
  self.narratorTextLineList:ResetDatas(textLines)
  local textLineCells = self.narratorTextLineList:GetCells()
  for i = 1, totalLine do
    if fontSize then
      textLineCells[i]:SetLabelStyle(fontSize)
    end
    textLineCells[i]:ResetAlphaPlay(fadeInTime, (i - 1) * timeInterval)
  end
  if lineHeight then
    self.narratorTextLineList.layoutCtrl.cellHeight = lineHeight
  end
  TimeTickManager.Me():CreateOnceDelayTick(time * 1000, function(owner, deltaTime)
    self:HideNarrator()
  end, self)
end

function PlotStoryView:HideNarrator()
  self.narrator:SetActive(false)
end

function PlotStoryView:SkipPlot(isDoEndCall)
  Game.PlotStoryManager:DoSkip()
end

function PlotStoryView:ParseText(text)
  local dialogId = tonumber(text)
  if dialogId then
    local data = DialogUtil.GetDialogData(dialogId)
    if data then
      text = MsgParserProxy.Instance:TryParse(data.Text)
    end
  end
  return text
end

function PlotStoryView:ShowBgmButton()
  self.bgmBtn:SetActive(true)
  self.bgmMute = true
  self.bgmIcon.CurrentState = 0
end

function PlotStoryView:OnBgmBtnClick()
  local currentBgm = FunctionBGMCmd.Me().currentNewBgm
  local mute = currentBgm.mute
  local volume = currentBgm:GetVolume()
  if self.bgmMute then
    if volume == 0 then
      volume = FunctionBGMCmd.MaxVolume
      currentBgm:SetMaxVolume(volume)
      currentBgm:SetVolume(volume)
    end
    if mute then
      currentBgm:SetMute(false)
    end
    self.bgmMute = false
    self.bgmIcon.CurrentState = 1
  else
    currentBgm:SetMute(true)
    self.bgmMute = true
    self.bgmIcon.CurrentState = 0
  end
end

function PlotStoryView:ShowRoleController(note)
  local showGuide = note.body
  if self.roleController then
    TweenAlpha.Begin(self.roleController, 1, 1)
    self:AddMonoUpdateFunction(self.UpdateRoleController)
    if showGuide then
      TimeTickManager.Me():CreateOnceDelayTick(1000, function()
        self:ShowGuide()
      end, self)
    end
  end
end

function PlotStoryView:HideRoleController()
  if self.roleController then
    TweenAlpha.Begin(self.roleController, 1, 0)
    self:RemoveMonoUpdateFunction()
    self.controllerCenter.transform.localPosition = centerV3
    self:HideGuide()
  end
end

function PlotStoryView:ShowGuide()
  self:PlayUIEffect(EffectMap.UI[handlerGuideEffect], self.controllerGuideEffect)
  self.isGuideShown = true
end

function PlotStoryView:HideGuide()
  if self.isGuideShown then
    self:DestroyUIEffects()
    self.isGuideShown = nil
  end
end

function PlotStoryView:IsTouchOnController(localPos)
  local halfW = self.controllerTex.width * 0.5
  local halfH = self.controllerTex.height * 0.5
  if localPos[1] >= centerV3[1] - halfW and localPos[2] >= centerV3[2] - halfH and localPos[1] <= centerV3[1] + halfW and localPos[2] <= centerV3[2] + halfH then
    return true
  end
  return false
end

function PlotStoryView:GetTouchLocalPos(x, y, z)
  local touchPos = LuaGeometry.GetTempVector3(x, y, z)
  x, y, z = LuaGameObject.ScreenToWorldPointByVector3(self.uiCamera, touchPos)
  local worldPos = LuaGeometry.GetTempVector3(x, y, z)
  x, y, z = LuaGameObject.InverseTransformPointByVector3(self.roleController.transform, worldPos)
  local localPos = LuaGeometry.GetTempVector3(x, y, z)
  return localPos
end

local tempV3 = LuaVector3.Zero()

function PlotStoryView:UpdateRoleController(time, deltaTime)
  local x, y, z, localPos
  LuaVector3.Better_Set(tempV3, 0, 0, 0)
  if self.isRunOnEditor or self.isRunOnWindows then
    if Input.GetMouseButtonDown(0) then
      x, y, z = LuaGameObject.GetMousePosition()
      localPos = self:GetTouchLocalPos(x, y, z)
      if self:IsTouchOnController(localPos) then
        self.isTouching = true
      end
    elseif Input.GetMouseButtonUp(0) then
      self.isTouching = false
      self.controllerCenter.transform.localPosition = centerV3
    elseif Input.GetMouseButton(0) and self.isTouching then
      x, y, z = LuaGameObject.GetMousePosition()
      localPos = self:GetTouchLocalPos(x, y, z)
    end
  elseif self.touchSupported and 0 < Input.touchCount then
    local touch = Input.GetTouch(0)
    if touch.phase == TouchPhase.Began then
      x, y = LuaGameObject.GetTouchPosition(0, false)
      localPos = self:GetTouchLocalPos(x, y, centerV3[3])
      if self:IsTouchOnController(localPos) then
        self.isTouching = true
      end
    elseif touch.phase == TouchPhase.Ended then
      self.isTouching = false
      self.controllerCenter.transform.localPosition = centerV3
    elseif (touch.phase == TouchPhase.Moved or touch.phase == TouchPhase.Stationary) and self.isTouching then
      x, y = LuaGameObject.GetTouchPosition(0, false)
      localPos = self:GetTouchLocalPos(x, y, centerV3[3])
    end
  end
  if self.isTouching and localPos then
    LuaVector3.Better_Sub(localPos, centerV3, tempV3)
    if LuaVector3.Distance_Square(localPos, centerV3) > self.maxDis * self.maxDis then
      LuaVector3.Better_Mul(LuaVector3.Normalize(tempV3), self.maxDis, tempV3)
      LuaVector3.Better_Add(tempV3, centerV3, localPos)
    end
    self.controllerCenter.transform.localPosition = localPos
    if 0 < tempV3[2] then
      Game.PlotStoryManager:ManualMove()
      self:HideGuide()
    else
      Game.PlotStoryManager:ManualMoveStop()
    end
  else
    Game.PlotStoryManager:ManualMoveStop()
  end
end

local loadingMaskTimeoutTick = 9992

function PlotStoryView:CreateBWLoadingMask()
  local effect = self.loadingeffect
  if effect ~= nil then
    return
  end
  effect = self:PlayUIEffect(EffectMap.UI.MapTransfer, self.effectTrans)
  effect:SetActive(false)
  self.loadingeffect = effect
end

function PlotStoryView:StartBWLoadingMask()
  local effect = self.loadingeffect
  if effect ~= nil then
    effect:SetActive(true)
    effect:ResetAction("state1001", 0)
  end
  self.loadingtime = UnityTime
  TimeTickManager.Me():ClearTick(self, loadingMaskTimeoutTick)
  TimeTickManager.Me():CreateOnceDelayTick(30000, self.StopBWLoadingMask, self, loadingMaskTimeoutTick)
end

function PlotStoryView:StopBWLoadingMask()
  if self.loadingtime == nil then
    return
  end
  TimeTickManager.Me():ClearTick(self, loadingMaskTimeoutTick)
  self.loadingtime = nil
  local effect = self.loadingeffect
  if effect ~= nil then
    effect:ResetAction("state2001", 0)
  end
end

function PlotStoryView:DestroyBWLoadingMask()
  if self.loadingeffect then
    self.loadingeffect:Destroy()
    self.loadingeffect = nil
  end
end

function PlotStoryView:SetPlotStoryClearDelayClose(sec)
  self.plotStoryClearDelayClose = sec
end

function PlotStoryView:PlotStoryClearCloseSelf()
  if self.plotStoryClearDelayClose and self.plotStoryClearDelayClose > 0 then
    TimeTickManager.Me():CreateOnceDelayTick(self.plotStoryClearDelayClose, function(owner, deltaTime)
      self.plotStoryClearDelayClose = 0
      Game.PlotStoryManager:CloseUIView(PanelConfig.PlotStoryView.id, true)
    end, Game.PlotStoryManager)
    return true
  end
end
