local baseView = autoImport("BaseView")
GuideMaskView = class("GuideMaskView", BaseView)
GuideMaskView.ViewType = UIViewType.GuideLayer
local maskBg = "com_mask"
local defaultHollowX, defaultHollowY, defaultHollowW, defaultHollowH = 1, 1, 0, 0

function GuideMaskView.getInstance()
  if GuideMaskView.Instance == nil then
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.GuideMaskView
    })
  end
  return GuideMaskView.Instance
end

function GuideMaskView:Init()
  if GuideMaskView.Instance == nil then
    GuideMaskView.Instance = self
  end
  self:initView()
  self:initData()
  self:registListener()
end

function GuideMaskView:initData()
  self.currentTriggerId = nil
  self.forbid = false
  self.objPos = nil
end

function GuideMaskView:resetData()
  self.currentTriggerId = nil
  self.lastOption = nil
end

function GuideMaskView:initView()
  self.mask = self:FindGO("mask")
  self.maskTex = self.mask:GetComponent(UITexture)
  self.maskCollider = self.mask:GetComponent(BoxCollider)
  self.resPath = ResourcePathHelper.EffectUI(EffectMap.UI.HlightBoxType2)
  self.hlightGo = Game.AssetManager_UI:CreateAsset(self.resPath, self.gameObject)
  self.hlightGo.transform.localScale = LuaGeometry.GetTempVector3(1, 1, 1)
  self.resPath2 = ResourcePathHelper.EffectUI(EffectMap.UI.HlightArrow)
  self.hlightGo2 = Game.AssetManager_UI:CreateAsset(self.resPath2, self.gameObject)
  self.hlightGo2.transform.localScale = LuaGeometry.GetTempVector3(1, 1, 1)
  self.hlight2Texture = self:FindGO("pic_skill_uv_add2", self.hlight2Go)
  self.hlight2Texture = self.hlight2Texture:GetComponent(UIWidget)
  self.hlight2Texture.depth = 3000
  self.panel = self.gameObject:GetComponent(UIPanel)
  self:SetGirlHintCtPanel(false)
  self.currentGuideId = nil
  self:Hide(self.hlightGo)
  self:Hide(self.hlightGo2)
  self:HideMask()
  self:SetMaskAlpha(0.00392156862745098)
end

function GuideMaskView:SetGirlHintCtPanel(isTrue)
  if self.hintCt then
    self.hintCt:SetActive(false)
    self.hintCt = nil
  end
  if isTrue then
    self.hintCt = self:FindGO("girlHintTextCt")
    self.hintText = self:FindGO("girlHintText"):GetComponent(UILabel)
    self.hintCtPanel = self:FindComponent("girlHintTextCt", UIPanel)
    self.hintTextPos = self.hintText.gameObject.transform.localPosition
    self.hintTextBg = self:FindGO("girlHintTextBg"):GetComponent(UIWidget)
  else
    self.hintCt = self:FindGO("hintTextCt")
    self.hintText = self:FindGO("hintText"):GetComponent(UILabel)
    self.hintCtPanel = self:FindComponent("hintTextCt", UIPanel)
    self.hintTextPos = self.hintText.gameObject.transform.localPosition
    self.hintTextBg = self:FindGO("hintTextBg"):GetComponent(UIWidget)
  end
  self.useGirlHint = isTrue
end

function GuideMaskView:ResetGirlHintCt()
  if not Game.GameObjectUtil:ObjectIsNULL(self.hintCt) then
    self.hintCt.transform:SetParent(self.gameObject.transform)
    self.hintCtPanel.depth = self.panel.depth + 1
    self:Hide(self.hintCt)
  end
end

function GuideMaskView:SetMaskAlpha(alpha)
  self.maskTex.alpha = alpha
end

function GuideMaskView:restoreParent(closeSelf)
  if Slua.IsNull(self.hlightGo) then
    self.hlightGo = Game.AssetManager_UI:CreateAsset(self.resPath, self.gameObject)
  else
    local hlightGoPanel = self.hlightGo:GetComponent(UIPanel)
    if hlightGoPanel and hlightGoPanel.depth < 10000 then
      hlightGoPanel.depth = 10000
    end
  end
  self:Hide(self.hlightGo)
  self:ResetGirlHintCt()
  if self.obj and self.tagParent and not Game.GameObjectUtil:ObjectIsNULL(self.obj) then
    self.obj.transform:SetParent(self.tagParent, true)
    if self.objPos then
      self.obj.transform.position = self.objPos
      self.obj.transform.localScale = self.objScale
    end
    self:Hide(self.obj)
    self:Show(self.obj)
    self.obj = nil
    self.objPos = nil
    self.tagParent = nil
    self:Hide(self.hlightGo2)
  end
  if self.m_moveTween ~= nil then
    EventManager.Me():RemoveEventListener(DragDropEvent.SwapObj, self.onMoveFinished, self)
    EventManager.Me():RemoveEventListener(DragDropEvent.DropEmpty, self.onMoveFinished, self)
    self.m_moveTween.style = 0
    LuaGameObject.RemoveComponentsFromObj(self.hlightGo, UITweener)
    self.m_moveTween = nil
  end
  if self.m_moveEndObj and not Game.GameObjectUtil:ObjectIsNULL(self.m_moveEndObj) then
    self.obj = nil
    self.objPos = nil
    self.tagParent = nil
    self:Hide(self.hlightGo2)
  end
  self:HideMask()
  self:clearWaitTick()
  if closeSelf then
    self:CloseSelf()
  end
end

function GuideMaskView:restoreMask()
  self:ResetGirlHintCt()
  self:RecoverMask()
  self:HideMask()
  self:AddClickEvent(self.mask)
end

function GuideMaskView:playHightAnim(pos)
  TweenPosition.Begin(self.hlightGo, 0.2, pos)
end

function GuideMaskView:setGuideUIActive(active)
  if self.hlightGo and not Game.GameObjectUtil:ObjectIsNULL(self.hlightGo) and not self:showGirl() then
    self.hlightGo:SetActive(active)
  end
  if self.hintCt and not Game.GameObjectUtil:ObjectIsNULL(self.hintCt) then
    local text = self.guideData and self.guideData.staticData.text
    if text and text ~= "" and active then
      self.hintCt:SetActive(active)
    else
      self.hintCt:SetActive(false)
    end
  end
end

function GuideMaskView:OnEnter()
  PictureManager.Instance:SetUI(maskBg, self.maskTex)
  self:sendNotification(GuideEvent.OnGuideStart)
  GuideMaskView.super.OnEnter(self)
end

function GuideMaskView:OnExit()
  QuestProxy.Instance:SelfDebug("  function GuideMaskView:OnExit() ")
  PictureManager.Instance:UnLoadUI(maskBg, self.maskTex)
  self:restoreParent()
  if not Game.GameObjectUtil:ObjectIsNULL(self.hlightGo) then
    Game.GOLuaPoolManager:AddToUIPool(self.resPath, self.hlightGo)
  end
  if not Game.GameObjectUtil:ObjectIsNULL(self.hlightGo2) then
    Game.GOLuaPoolManager:AddToUIPool(self.resPath2, self.hlightGo2)
  end
  self.resPath = nil
  GuideMaskView.Instance = nil
  self:SetGuideData(nil)
  self.obj = nil
  self.tagParent = nil
  self.currentTriggerId = nil
  self.clientWaitData = nil
  self:sendNotification(GuideEvent.OnGuideEnd)
  self:restoreMask()
  self:clearWaitTick()
  if self.needRestoreHotKey then
    self.needRestoreHotKey = nil
    if Game.HotKeyManager.SetEnable then
      Game.HotKeyManager:SetEnable(true)
    else
      Game.HotKeyManager.Running = true
    end
  end
  GuideMaskView.super.OnExit(self)
end

function GuideMaskView:setTalkText(origin)
  local sGuideData = self.guideData and self.guideData.staticData
  if not sGuideData then
    return
  end
  local guideType = self.guideData and self.guideData.guideType
  local text = sGuideData.text
  if text and text ~= "" then
    self:Show(self.hintCt)
    self.hintText.text = text
    UIUtil.FitLableMaxHeight(self.hintText, self.hintTextBg.height)
    local rotation = sGuideData.rotation
    if rotation and rotation.x then
      self.hintTextBg.gameObject.transform.localRotation = Quaternion.Euler(rotation.x, rotation.y, rotation.z)
    end
    local pos = sGuideData.position
    self.hintTextBg.width = self.hintText.width + 50
    if rotation.x == 180 and rotation.z ~= 180 or rotation.z == 180 and rotation.x ~= 180 then
      self.hintText.gameObject.transform.localPosition = LuaGeometry.GetTempVector3(self.hintTextPos.x, -3, 0)
    else
      self.hintText.gameObject.transform.localPosition = self.hintTextPos
    end
    if guideType == QuestDataGuideType.QuestDataGuideType_unforce then
      if self:showGirl() then
        self.hintCt.transform:SetParent(self.hlightGo2.transform.parent, false)
      else
        self.hintCt.transform:SetParent(self.hlightGo.transform.parent)
      end
      if self.hlightTexture and self.hlightTexture.panel then
        self.hintCtPanel.depth = self.hlightTexture.panel.depth + 20
      end
    else
      local offset = sGuideData.offset
      if offset and next(offset) and origin then
        pos = {}
        pos.x = origin.x + offset.x
        pos.y = origin.y + offset.y
      end
    end
    if pos and pos.x then
      self.hintCt.transform.localPosition = LuaGeometry.GetTempVector3(pos.x, pos.y, 1)
    end
  else
    self:Hide(self.hintCt)
  end
end

function GuideMaskView:showGuideByQuestData(questData)
  self:SetQuestData(questData)
  self:showGuide()
end

function GuideMaskView:showGuide()
  local sGuideData = self.guideData and self.guideData.staticData
  if not sGuideData then
    return false
  end
  redlog("触发引导", self.guideData.guideID)
  if self:isAutoComplete() then
    self:restoreParent()
  end
  self.currentGuideId = self.guideData.guideID
  self:SetMaskAlpha(0.00392156862745098)
  self:SetGirlHintCtPanel(false)
  local targetGO
  local tag = sGuideData.ButtonID
  local collider, bound, center, lPos
  if tag then
    targetGO = GuideTagCollection.getGuideItemById(tag)
    self.obj = targetGO
    if self.obj == nil then
      self:HideMask()
      self:ResetGirlHintCt()
      return false
    end
    collider = self.obj:GetComponent(BoxCollider)
    bound = NGUIMath.CalculateRelativeWidgetBounds(self.obj.transform, false)
    center = bound.center
    if collider and (tag == 101 or tag == 5) then
      center = collider.center
    end
    if sGuideData.EffectAnchor then
      if sGuideData.EffectAnchor == 0 then
        center.x = bound.min.x
        center.y = bound.max.y
      elseif sGuideData.EffectAnchor == 1 then
        center.y = bound.max.y
      elseif sGuideData.EffectAnchor == 2 then
        center = bound.max
      elseif sGuideData.EffectAnchor == 3 then
        center.x = bound.min.x
      elseif sGuideData.EffectAnchor == 5 then
        center.x = bound.max.x
      elseif sGuideData.EffectAnchor == 6 then
        center = bound.min
      elseif sGuideData.EffectAnchor == 7 then
        center.y = bound.min.y
      elseif sGuideData.EffectAnchor == 8 then
        center.x = bound.max.x
        center.y = bound.min.y
      end
    end
  end
  if self.guideData.targetQuestID then
    self:sendNotification(GuideEvent.AdjustQuestList, self.guideData.targetQuestID)
  end
  local guideType = self.guideData.guideType
  local showGirl = self.guideData.showGirl
  local isShowHollowMask = sGuideData.hollows and 0 < #sGuideData.hollows
  if guideType == QuestDataGuideType.QuestDataGuideType_unforce then
    local tempV3 = LuaVector3()
    local position = sGuideData.EffectPos or {}
    LuaVector3.Better_Set(tempV3, position.x or 0, position.y or 0, 0)
    tempV3[1] = tempV3[1] + center.x
    tempV3[2] = tempV3[2] + center.y
    self.tagParent = self.gameObject.transform
    if showGirl then
      self:SetGirlHintCtPanel(true)
      if self.obj then
        self.hlightGo2.transform:SetParent(self.obj.transform)
        self:SetPanelDepthByParent(self.hlightGo2, 9)
        self.hlightGo2.transform.localPosition = tempV3
        self.hlightGo2.transform.localScale = LuaGeometry.GetTempVector3(1, 1, 1)
        self.obj = self.hlightGo2.gameObject
      end
    else
      self.tagParent = self.gameObject.transform
      if self.obj then
        self.hlightGo.transform:SetParent(self.obj.transform)
        self:SetPanelDepthByParent(self.hlightGo, 9)
        self.hlightGo.transform.localScale = LuaGeometry.GetTempVector3(1, 1, 1)
        self.hlightGo.transform.localPosition = tempV3
        lPos = self.obj.transform.localPosition
        self.obj = self.hlightGo.gameObject
      end
    end
  elseif guideType == QuestDataGuideType.QuestDataGuideType_slide then
    local btnId = sGuideData.ButtonID2
    if btnId ~= nil then
      self.m_moveEndObj = GuideTagCollection.getGuideItemById(btnId)
    else
      self.m_moveEndObj = nil
    end
    if self.obj ~= nil and self.m_moveEndObj ~= nil then
      lPos = self.obj.transform.localPosition
      self.hlightGo.transform.position = self.obj.transform.position
      self.m_delayTween = TimeTickManager.Me():CreateTick(500, 0, self.delayShowSlideGuide, self, 999)
      if showGirl then
        self:SetGirlHintCtPanel(true)
      end
    else
      redlog("guideid = " .. self.currentGuideId .. "配置中未找到buttonid 或者未找到 buttonid2")
      local questData = self.guideData.questData
      if questData then
        QuestProxy.Instance:notifyQuestState(questData.scope, questData.id, questData.staticData.FailJump)
      end
      return false
    end
  elseif guideType == QuestDataGuideType.QuestDataGuideType_force then
    if self.obj then
      self.tagParent = self.obj.transform.parent
      self.objPos = self.obj.transform.position
      self.objScale = self.obj.transform.localScale
      lPos = LuaGeometry.GetTempVector3(NGUIUtil.GetUIPositionXYZ(self.obj))
      self.obj.transform:SetParent(self.gameObject.transform)
      self.obj.transform.localPosition = lPos
      local tempV3 = LuaVector3()
      local position = sGuideData.EffectPos or {}
      LuaVector3.Better_Set(tempV3, position.x or 0, position.y or 0, 0)
      local pos = Vector3(lPos.x + center.x + tempV3[1], lPos.y + center.y + tempV3[2], lPos.z)
      self.hlightGo.transform.localPosition = pos
    end
  elseif guideType == QuestDataGuideType.QuestDataGuideType_force_with_arrow then
    if isShowHollowMask then
      self:AddClickEvent(self.mask, function()
        FunctionGuide.Me():triggerWithoutTag()
      end, {hideClickSound = true, hideClickEffect = true})
      local panelName = sGuideData.uiID
      local panelCtrl = UIManagerProxy.Instance:GetNodeByViewName(panelName)
      local hollowData = sGuideData.hollows[1]
      if panelCtrl and hollowData then
        local attachGo = self:GetHollowAttachGo(panelCtrl, hollowData)
        local _bound = NGUIMath.CalculateRelativeWidgetBounds(attachGo.transform)
        if _bound then
          local worldCenter = attachGo.transform:TransformPoint(_bound.center)
          lPos = self.mask.transform.parent:InverseTransformPoint(worldCenter)
          center = LuaVector3.Zero()
        end
      end
    elseif self.obj then
      self.tagParent = self.obj.transform.parent
      self.objPos = self.obj.transform.position
      self.objScale = self.obj.transform.localScale
      self.obj.transform:SetParent(self.gameObject.transform)
      lPos = self.obj.transform.localPosition
      local tempV3 = LuaVector3()
      local position = sGuideData.position
      LuaVector3.Better_Set(tempV3, position.x or 0, position.y or 0, 0)
      local pos = Vector3(lPos.x + center.x + tempV3[1], lPos.y + center.y + tempV3[2], lPos.z)
      self.hlightGo.transform.localPosition = pos
      self.hlightGo.transform.localPosition = LuaGeometry.GetTempVector3()
      self.hlightGo2.transform.localPosition = pos
      self.hlightGo2.transform.localScale = LuaGeometry.GetTempVector3(1, 1, 1)
      local rotation = sGuideData.rotation
      LuaVector3.Better_Set(tempV3, rotation.x or 0, rotation.y or 0, rotation.z or 0)
      self.hlightGo2.transform.localEulerAngles = tempV3
    end
    self:SetGirlHintCtPanel(true)
  end
  local width = 0
  local height = 0
  if collider and (tag == 101 or tag == 5) then
    width = collider.size.x
    height = collider.size.y
  elseif bound then
    width = bound.size.x + 20
    height = bound.size.y + 20
  end
  if self.hlightTexture then
    self.hlightTexture.width = width
    self.hlightTexture.height = height
  end
  if self.obj then
    self:Hide(self.obj.gameObject)
    self:Show(self.obj.gameObject)
  end
  local origin
  if lPos and center then
    origin = lPos + center
  end
  self:setTalkText(origin)
  self:Show(self.hlightGo)
  local needForbidHotKey = false
  if guideType == QuestDataGuideType.QuestDataGuideType_unforce then
    self:HideMask()
    if showGirl then
      self:Show(self.hlightGo2)
      self:SetPanelDepthByParent(self.hlightGo2, 9)
      self:Hide(self.hlightGo)
    end
  elseif guideType == QuestDataGuideType.QuestDataGuideType_force then
    self:ShowMask()
    Game.AutoBattleManager:AutoBattleOff()
    needForbidHotKey = true
  elseif guideType == QuestDataGuideType.QuestDataGuideType_force_with_arrow then
    self:ShowMask()
    self:SetMaskAlpha(0.4)
    if isShowHollowMask then
      self:Hide(self.hlightGo2)
      self:SetMaskHollow()
    else
      self:Show(self.hlightGo2)
      self:SetPanelDepthByParent(self.hlightGo2, 9)
    end
    self:Hide(self.hlightGo)
  elseif guideType == QuestDataGuideType.QuestDataGuideType_showDialog then
  end
  self:sendNotification(GuideEvent.TargetGuideSuccess, {
    targetGO,
    self.currentGuideId
  })
  redlog("引导任务", guideType, showGirl, self.obj)
  if Game.HotKeyManager.Running and needForbidHotKey then
    self.needRestoreHotKey = true
    if Game.HotKeyManager.SetEnable then
      Game.HotKeyManager:SetEnable(false)
    else
      Game.HotKeyManager.Running = false
    end
  end
  return true
end

function GuideMaskView:showGuideByQuestDataRepeat()
  if not self.guideData then
    return
  end
  local tag = self.guideData.staticData.ButtonID
  if tag ~= 201 then
    return
  end
  self:restoreParent()
  self.obj = GuideTagCollection.getGuideItemById(tag)
  if self.obj then
    local bound = NGUIMath.CalculateRelativeWidgetBounds(self.obj.transform, false)
    local guideType = self.guideData and self.guideData.guideType
    local lPos
    if guideType == QuestDataGuideType.QuestDataGuideType_unforce then
      self.tagParent = self.gameObject.transform
      self.hlightGo.transform:SetParent(self.obj.transform)
      self.hlightGo.transform.localScale = Vector3.one
      self.hlightGo.transform.localPosition = bound.center
      lPos = self.obj.transform.localPosition
      self.obj = self.hlightGo.gameObject
    elseif guideType == QuestDataGuideType.QuestDataGuideType_force then
      self.tagParent = self.obj.transform.parent
      self.objPos = self.obj.transform.position
      self.objScale = self.obj.transform.localScale
      self.obj.transform:SetParent(self.gameObject.transform)
      lPos = self.obj.transform.localPosition
      local pos = Vector3(lPos.x + bound.center.x, lPos.y + bound.center.y, lPos.z)
      self.hlightGo.transform.localPosition = pos
      self.hlightGo.transform.localScale = Vector3(5, 5, 1)
    end
    if self.hlightTexture then
      self.hlightTexture.width = bound.size.x + 20
      self.hlightTexture.height = bound.size.y + 20
    end
    self:Hide(self.obj.gameObject)
    self:Show(self.obj.gameObject)
    local origin
    if lPos then
      origin = lPos + bound.center
    end
    self:setTalkText(origin)
    self:Show(self.hlightGo)
    if guideType == QuestDataGuideType.QuestDataGuideType_unforce then
      self:HideMask()
    elseif guideType == QuestDataGuideType.QuestDataGuideType_force then
      self:ShowMask()
    elseif guideType == QuestDataGuideType.QuestDataGuideType_showDialog then
    end
  elseif tag == 201 then
    helplog("失败跳转")
    local questData = self.guideData and self.guideData.questData
    if questData then
      QuestProxy.Instance:notifyQuestState(self.questData.scope, self.questData.id, self.questData.staticData.FailJump)
    end
  end
end

function GuideMaskView:IsCurrentGuideItemsInBag()
  local tag = self.guideData and self.guideData.staticData.ButtonID
  if tag ~= 201 then
    return false
  else
    return true
  end
end

function GuideMaskView:clientWaitGuide(waitData)
  self.clientWaitData = waitData
end

function GuideMaskView:waitServerEvent(serverEvent, questData)
  self.waitEvent = serverEvent
  self.delayQuestData = questData
end

function GuideMaskView:waitButtonEnable()
  if not self.waitObjTick then
    local tag = self.guideData and self.guideData.staticData.ButtonID
    self.waitObjTick = TimeTickManager.Me():CreateTick(0, 33, function()
      self.obj = GuideTagCollection.getGuideItemById(tag)
      if not Slua.IsNull(self.obj) then
        self:clearWaitTick()
        self:restoreParent()
        self:showGuide()
      end
    end, self, 112)
  end
end

function GuideMaskView:clearWaitTick()
  TimeTickManager.Me():ClearTick(self, 112)
  self.waitObjTick = nil
end

function GuideMaskView:registListener()
  local list = GuideProxy.Instance:getGuideListeners()
  for i = 1, #list do
    self:AddListenEvt(list[i], self.excuteGuide)
  end
end

function GuideMaskView:excuteGuide()
  if self.delayQuestData then
    FunctionGuide.Me():showGuideByQuestData(self.delayQuestData)
    self.delayQuestData = nil
  end
  if self.clientWaitData and self.clientWaitData == self.guideData then
    self.clientWaitData = nil
    self:showGuide()
  end
end

function GuideMaskView:isAutoComplete()
  return self.guideData and self.guideData.autoComplete
end

function GuideMaskView:showGirl()
  return self.guideData and self.guideData.showGirl
end

function GuideMaskView:SetQuestData(newData)
  if newData then
    local guideData = GuideData.new()
    guideData:SetByQuestData(newData)
    self:SetGuideData(guideData)
  else
    self:SetGuideData(nil)
  end
end

function GuideMaskView:SetClientGuideData(newData, guideKey)
  if newData then
    local guideData = GuideData.new()
    guideData:SetByClientData(newData, guideKey)
    self:SetGuideData(guideData)
  else
    self:SetGuideData(nil)
  end
end

function GuideMaskView:SetGuideData(data)
  self.guideData = data
end

function GuideMaskView:ShowMask()
  self:Show(self.mask)
  PictureManager.ReFitFullScreen(self.maskTex)
  self:sendNotification(GuideEvent.OnForceGuideStart)
end

function GuideMaskView:HideMask()
  self:Hide(self.mask)
  self:sendNotification(GuideEvent.OnForceGuideEnd)
end

function GuideMaskView:SetMaskHollow()
  local sGuideData = self.guideData and self.guideData.staticData
  if not sGuideData then
    return
  end
  local hollows = sGuideData.hollows
  if not hollows then
    return
  end
  local panelName = sGuideData.uiID
  local panelCtrl = UIManagerProxy.Instance:GetNodeByViewName(panelName)
  if not panelCtrl then
    if panelName == "MainView" then
      local layer = UIManagerProxy.Instance:GetLayerByType(UIViewType.MainLayer)
      if layer then
        panelCtrl = layer:FindNodeByName(panelName)
      end
    else
      return
    end
  end
  local maskMat = self.maskTex.material
  if not maskMat then
    Game.AssetManager_UI:LoadAsset(ResourcePathHelper.PublicMaterial("HollowMask"), Material, function(_, asset)
      maskMat = asset
    end)
  end
  for i = 1, 4 do
    local x = defaultHollowX
    local y = defaultHollowY
    local w = defaultHollowW
    local h = defaultHollowH
    local hollowData = hollows[i]
    if hollowData then
      local attachGo = self:GetHollowAttachGo(panelCtrl, hollowData)
      local bound = NGUIMath.CalculateRelativeWidgetBounds(attachGo.transform)
      if bound then
        w = bound.size.x * 0.5
        h = bound.size.y * 0.5
        local worldCenter = attachGo.transform:TransformPoint(bound.center)
        local localPos = self.mask.transform.parent:InverseTransformPoint(worldCenter)
        x = -localPos.x / w
        y = -localPos.y / h
        w = 1 / w
        h = 1 / h
      end
    end
    local clipRange = "_ClipRange" .. i - 1
    maskMat:SetVector(clipRange, Vector4(x, y, w, h))
  end
  self.maskTex.material = maskMat
end

function GuideMaskView:RecoverMask()
  self:SetMaskAlpha(0.00392156862745098)
  local maskMat = self.maskTex.material
  if maskMat then
    for i = 1, 4 do
      local clipRange = "_ClipRange" .. i - 1
      maskMat:SetVector(clipRange, Vector4(defaultHollowX, defaultHollowY, defaultHollowW, defaultHollowH))
    end
    self.maskTex.material = nil
    Game.AssetManager_UI:UnLoadAsset(ResourcePathHelper.PublicMaterial("HollowMask"))
  end
end

function GuideMaskView:GetHollowAttachGo(panelCtrl, hollowData)
  local attachGo
  if type(hollowData) == "table" then
    local parentName = hollowData[1]
    local index = hollowData[2]
    local parent = self:FindGO(parentName, panelCtrl.gameObject)
    attachGo = parent.transform:GetChild(index).gameObject
  else
    local attachGoName = hollowData
    attachGo = self:FindGO(attachGoName, panelCtrl.gameObject)
  end
  return attachGo
end

function GuideMaskView:CloseOnClick()
  return self.guideData and self.guideData.closeOnClick
end

function GuideMaskView:HideOnClick()
  return self.guideData and self.guideData.hideOnClick
end

function GuideMaskView:finishedSlideGuide()
  local questData = self.guideData and self.guideData.questData
  if questData and questData.params.type == QuestDataGuideType.QuestDataGuideType_slide then
    QuestProxy.Instance:notifyQuestState(questData.scope, questData.id, questData.staticData.FinishJump)
  end
end

function GuideMaskView:delayShowSlideGuide()
  local sGuideData = self.guideData and self.guideData.staticData
  if not sGuideData then
    return
  end
  local time = sGuideData.moveTime == nil and 1.5 or sGuideData.moveTime
  self.m_moveTween = TweenPosition.Begin(self.hlightGo, time, self.m_moveEndObj.transform.position, true)
  if sGuideData.isLoop ~= nil and sGuideData.isLoop == 0 then
    self.m_moveTween.style = 1
  else
    self.m_moveTween.style = 0
  end
  if self.m_delayTween ~= nil then
    TimeTickManager.Me():ClearTick(self, 999)
    self.m_delayTween = nil
  end
end
