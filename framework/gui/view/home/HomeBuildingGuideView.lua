HomeBuildingGuideView = class("HomeBuildingGuideView", SubView)
HomeBuildingGuideView.Step = {
  CameraMove = 1,
  CameraRotateHori = 2,
  CameraRotateVert = 3,
  CameraZoom = 4,
  SwitchToRenovation = 5,
  SwitchToFurniture = 6,
  ClickSetting = 7,
  DragFurniture = 8,
  Max = 9
}
local m_MaskLightSize = {small = 1.5, big = 0.9}
local m_cellSize = 0.5
local m_congratulationsTime = 1.7
local m_operateMinNum = 3
local m_finishGuideDelay = 2
local m_targetFurnitureStaticID = 30005
local m_furnitureDragTargetConfig = {
  floor = 1,
  row = 8,
  col = 20
}
local m_blackMaskAlpha = 0.6666666666666666
local m_strGuideNpcTexName = "home_guide_dialogue_hero"
local m_animName_guideGirl = "homeguide"
local m_animName_zoomHand = "homehand"
local m_tmpVector3 = LuaVector3(0, 0, 0)
local GetTempVector3 = function(x, y, z, tarVector)
  tarVector = tarVector or m_tmpVector3
  LuaVector3.Better_Set(tarVector, x, y, z)
  return tarVector
end

function HomeBuildingGuideView:Init()
  self:FindObjs()
  self:AddEvts()
  self:AddViewEvts()
  self:InitView()
end

function HomeBuildingGuideView:FindObjs()
  self.gameObject = self:FindGO("GuideRoot")
  self.tabGuideObjs = {}
  self.tabGuideStepOperateNum = {}
  local contentConfig = GameConfig.Home.GuideContentText
  local objGuide
  for key, id in pairs(HomeBuildingGuideView.Step) do
    if key ~= HomeBuildingGuideView.Step.Max then
      objGuide = self:FindGO(string.format("Guide_%d", id))
      if objGuide and contentConfig then
        self:FindComponent("labContent", UILabel, objGuide).text = contentConfig[id]
      end
      self.tabGuideObjs[id] = objGuide
    end
  end
  self.objCongratulations = self:FindGO("Congratulations")
  local l_objGuideDragFurniture = self.tabGuideObjs[HomeBuildingGuideView.Step.DragFurniture]
  self.objDragStartSign = self:FindGO("StartSign", l_objGuideDragFurniture)
  self.tsfDragStartSign = self.objDragStartSign.transform
  self.objDragHandParent = self:FindGO("HandParent", l_objGuideDragFurniture)
  self.tsfDragHandParent = self.objDragHandParent.transform
  self.widgetDragHandParent = self.objDragHandParent:GetComponent(UIWidget)
  self.objGuideBGMsg = self:FindGO("GuideBGMsg")
  self.texGuideNpc = self:FindComponent("texGuideNpc", UITexture, self.objGuideBGMsg)
  self.objBlackMask = self:FindGO("texGuideMask")
  self.texBlackMask = self.objBlackMask:GetComponent(UITexture)
  self.objGuideGirlRoot = self:FindGO("GuideGirlRoot")
  self.tsfGuideGirlRoot = self.objGuideGirlRoot.transform
end

function HomeBuildingGuideView:AddEvts()
  self:AddClickEvent(self.objCongratulations, function()
    self:ShowNextGuideStep()
  end)
  self:AddClickEvent(self:FindGO("BtnDoNotGuide", self.objGuideBGMsg), function()
    self.objGuideBGMsg:SetActive(false)
    self.includeDragFurniture = false
    self:CompleteFirstGuide()
  end)
  self:AddClickEvent(self:FindGO("BtnNeedGuide", self.objGuideBGMsg), function()
    self.objGuideBGMsg:SetActive(false)
    self:BeginGuide()
  end)
end

function HomeBuildingGuideView:AddViewEvts()
end

function HomeBuildingGuideView:InitView()
  self.objGuideBGMsg:SetActive(false)
  self.screenWidth = Screen.width
  self.screenHeight = Screen.height
  self.rectMaskTex = Rect(0, 0, 1, 1)
  self.aspectRatio = self.screenWidth / self.screenHeight
  self:LoadSpineAnim("homeguide", "homegirl", 1, self.objGuideGirlRoot).transform.localPosition = GetTempVector3(0, 65, 0)
  self.objGuideGirlRoot:SetActive(false)
  self:LoadSpineAnim("homehand", "mouse2", 0.5, self:FindGO("HandRoot", self.tabGuideObjs[HomeBuildingGuideView.Step.CameraZoom]))
  local furnitureSData = Table_HomeFurniture[m_targetFurnitureStaticID]
  local vecScale = GetTempVector3(furnitureSData.Col * m_cellSize, furnitureSData.Row * m_cellSize, 1)
  self.tsfDragStartSign.localScale = vecScale
  local l_tsfEndDragSign = self:FindGO("EndSign", l_objDragWorldGuideRoot).transform
  l_tsfEndDragSign.localScale = vecScale
  local l_objDragWorldGuideRoot = self:FindGO("DragWorldGuideRoot", self.tabGuideObjs[HomeBuildingGuideView.Step.DragFurniture])
  local vecEuler = GetTempVector3(LuaGameObject.GetEulerAngles(HomeManager.Me():GetFurnitureRootTransform()))
  vecEuler.x = -90
  l_objDragWorldGuideRoot.transform.eulerAngles = vecEuler
  local config = m_furnitureDragTargetConfig
  local posX, posZ = HomeManager.Me():ConvertRowAndColToWorldPosition(config.floor, config.row, config.col)
  local result, right, wrong, placeRow, placeCol = HomeManager.Me():TryPlaceFurniture(0, m_targetFurnitureStaticID, config.floor, posX, posZ, 0)
  self.targetFurniturePos = HomeManager.Me():GetBuildPosByCells(config.floor, right, wrong):Clone()
  l_tsfEndDragSign.position = self.targetFurniturePos
  l_tsfEndDragSign.localEulerAngles = GetTempVector3(0, 0, 0)
  self.needPlaceRow = placeRow
  self.needPlaceCol = placeCol
end

function HomeBuildingGuideView:OnEnter()
  HomeBuildingGuideView.super.OnEnter(self)
  PictureManager.Instance:SetHome(m_strGuideNpcTexName, self.texGuideNpc)
  local curHouseData = HomeProxy.Instance:GetCurHouseData()
  if curHouseData and not curHouseData:IsFinishedGuide() then
    self:CheckNeedShowGuide(true)
  end
end

function HomeBuildingGuideView:OnExit()
  PictureManager.Instance:UnLoadHome(m_strGuideNpcTexName, self.texGuideNpc)
  self:ExitGuide()
  HomeBuildingGuideView.super.OnExit(self)
end

function HomeBuildingGuideView:IsInAnyGuide()
  return self.curStepIndex and self.curStepIndex > 0
end

function HomeBuildingGuideView:CheckOperateForbid(guideStep)
  if self.isCongratulationsShow then
    return true
  end
  if self:IsInAnyGuide() then
    return self.curStepIndex ~= guideStep
  end
  return false
end

function HomeBuildingGuideView:CanSelectFurniture(nFurniture)
  if self.curStepIndex ~= HomeBuildingGuideView.Step.DragFurniture or not self.targetDragFurnitureID then
    return true
  end
  return nFurniture.data.id == self.targetDragFurnitureID
end

function HomeBuildingGuideView:CheckNeedShowGuide(includeDragFurniture)
  self.objGuideBGMsg:SetActive(true)
  self.includeDragFurniture = includeDragFurniture
end

function HomeBuildingGuideView:CompleteFirstGuide()
  local curHouseData = HomeProxy.Instance:GetCurHouseData()
  if curHouseData and not curHouseData:IsFinishedGuide() then
    ServiceHomeCmdProxy.Instance:CallHouseActionHomeCmd(HomeCmd_pb.EHOUSEACTION_GUIDE_SET)
    curHouseData:GuideFinished()
  end
end

function HomeBuildingGuideView:BeginGuide(includeDragFurniture)
  if self:IsInAnyGuide() or not HomeManager.Me():IsAtHome() then
    return
  end
  self.container.bpControl:ExitBPMode()
  self.container:SetEditRecovery(false)
  self.container:OnClickBtnConfirm()
  self.container:RemoveCurOperateItem()
  self.container:OnClickBtnEditFurniture()
  if includeDragFurniture ~= nil then
    self.includeDragFurniture = includeDragFurniture
  end
  if self.includeDragFurniture then
    local furnitures = HomeManager.Me():GetFurnituresMap()
    for id, nFurniture in pairs(furnitures) do
      if nFurniture.data.staticID == m_targetFurnitureStaticID then
        self.targetDragFurniture = nFurniture
        self.targetDragFurnitureID = self.targetDragFurniture.data.id
        break
      end
    end
    if not self.targetDragFurniture then
      LogUtility.Error("Cannot Find Guide Target Furniture")
    end
  end
  self.includeDragFurniture = self.includeDragFurniture and self.targetDragFurniture ~= nil
  self.curStepIndex = HomeBuildingGuideView.Step.Max
  self.container.cameraControl:ResetCameraToEditStartPos(function()
    self.curStepIndex = 0
    self.objBlackMask:SetActive(true)
    self:ShowNextGuideStep()
  end)
end

function HomeBuildingGuideView:FinishGuideStep(step)
  if self.curStepIndex ~= step then
    return
  end
  self.curGuideObj:SetActive(false)
  self.objCongratulations:SetActive(true)
  if self.effectCongratulations == nil then
    Asset_Effect.PlayOn(ResourcePathHelper.UIEffect("home_guide"), self.objCongratulations.transform, function(obj, owner, assetEffect)
      if not owner then
        return
      end
      owner.effectCongratulations = assetEffect
      if owner.effectCongratulations and owner.effectCongratulations.args[6] and not LuaGameObject.ObjectIsNull(owner.effectCongratulations.args[6]) then
        owner.effectCongratulations.args[6].gameObject:SetActive(true)
      end
    end, self)
  elseif self.effectCongratulations and self.effectCongratulations.args[6] and not LuaGameObject.ObjectIsNull(self.effectCongratulations.args[6]) then
    self.effectCongratulations.args[6].gameObject:SetActive(true)
  end
  self:ShowBlackMask(false, true)
  self.isCongratulationsShow = true
  if not self.ltNextGuide then
    self.ltNextGuide = TimeTickManager.Me():CreateOnceDelayTick(m_congratulationsTime * 1000, function(owner, deltaTime)
      self:ShowNextGuideStep()
      self.ltNextGuide = nil
    end, self)
  end
end

function HomeBuildingGuideView:ShowNextGuideStep()
  self.objCongratulations:SetActive(false)
  if self.effectCongratulations and self.effectCongratulations:Alive() then
    self.effectCongratulations:Destroy()
  end
  self.effectCongratulations = nil
  self.curStepIndex = self.curStepIndex + 1
  self:ClearNextGuideLt()
  self:ClearFinishGuideLt()
  self.curOperateStep = nil
  self.curGuideTimeOver = nil
  self.isCongratulationsShow = false
  self.tabGuideStepOperateNum[self.curStepIndex] = 0
  self.container:CloseMenus()
  local maxGuideNum = self.includeDragFurniture and HomeBuildingGuideView.Step.Max or HomeBuildingGuideView.Step.DragFurniture
  if maxGuideNum > self.curStepIndex then
    self.curGuideObj = self.tabGuideObjs[self.curStepIndex]
    if self.curStepIndex == HomeBuildingGuideView.Step.DragFurniture then
      self.container.cameraControl:ResetCameraToEditStartPos(function()
        self:ResetDragFurnitureStartSign()
        self:ShowDragHand(true, true)
        local screenPos = self.container.cameraControl:WorldToScreenPoint(self.targetFurniturePos)
        self:ResetBlackMask(screenPos.x, screenPos.y, m_MaskLightSize.small)
        self:InitDragFurnitureTargetArrow()
        local objCharaBG = self:FindGO("CharaBG", self.curGuideObj)
        self.objGuideGirlRoot:SetActive(objCharaBG ~= nil)
        if objCharaBG then
          self.tsfGuideGirlRoot:SetParent(objCharaBG.transform, false)
        end
        self:ShowBlackMask(true, true)
        self.curGuideObj:SetActive(true)
      end)
    else
      local maskHeight, maskWidth = m_MaskLightSize.small
      if self.curStepIndex == HomeBuildingGuideView.Step.CameraRotateHori or self.curStepIndex == HomeBuildingGuideView.Step.CameraRotateVert then
        maskHeight = m_MaskLightSize.big
        maskWidth = maskHeight
      end
      local screenPos = self.container.cameraUI:WorldToScreenPoint(GetTempVector3(LuaGameObject.GetPosition(self:FindGO("LightPoint", self.curGuideObj).transform)))
      self:ResetBlackMask(screenPos.x, screenPos.y, maskHeight, maskWidth)
      local objCharaBG = self:FindGO("CharaBG", self.curGuideObj)
      self.objGuideGirlRoot:SetActive(objCharaBG ~= nil)
      if objCharaBG then
        self.tsfGuideGirlRoot:SetParent(objCharaBG.transform, false)
      end
      self:ShowBlackMask(true, true)
      self.curGuideObj:SetActive(true)
    end
  else
    self:GuideFinish()
    self:CompleteFirstGuide()
  end
end

function HomeBuildingGuideView:InitDragFurnitureTargetArrow(screenPos)
  local l_tsfArrow = self:FindGO("Arrow", self.tabGuideObjs[HomeBuildingGuideView.Step.DragFurniture]).transform
  local screenPos = self.container.cameraControl:WorldToScreenPoint(self.targetFurniturePos)
  local uiPos = l_tsfArrow.parent:InverseTransformPoint(self.container.cameraUI:ScreenToWorldPoint(screenPos))
  uiPos.z = 0
  uiPos.x = uiPos.x - 100
  uiPos.y = uiPos.y - 140
  l_tsfArrow.localPosition = uiPos
end

function HomeBuildingGuideView:ExitGuide()
  if self.curGuideObj then
    self.curGuideObj:SetActive(false)
  end
  self:GuideFinish()
end

function HomeBuildingGuideView:GuideFinish()
  TableUtility.TableClear(self.tabGuideStepOperateNum)
  if self.effectCongratulations and self.effectCongratulations:Alive() then
    self.effectCongratulations:Destroy()
    self.effectCongratulations = nil
  end
  self:ClearNextGuideLt()
  self:ClearFinishGuideLt()
  self.curStepIndex = nil
  self.curGuideObj = nil
  self.curOperateStep = nil
  self.curGuideTimeOver = nil
  self.targetDragFurniture = nil
  self.targetDragFurnitureID = nil
  self.includeDragFurniture = false
  self.isCongratulationsShow = false
  self.objBlackMask:SetActive(false)
end

function HomeBuildingGuideView:StartGuideStep(step, nFurniture)
  if self.curStepIndex ~= step then
    return
  end
  if nFurniture then
    if nFurniture.data.id == self.targetDragFurnitureID then
      self.objDragStartSign:SetActive(true)
    else
      return
    end
  end
  self.tabGuideStepOperateNum[step] = not self.tabGuideStepOperateNum[step] and 1 or self.tabGuideStepOperateNum[step] + 1
  self.curOperateStep = step
  self:ShowBlackMask(false)
  if self.curStepIndex == HomeBuildingGuideView.Step.DragFurniture then
    self:ShowDragHand(false)
  elseif not self.ltFinishGuide then
    self.ltFinishGuide = TimeTickManager.Me():CreateOnceDelayTick(m_finishGuideDelay * 1000, function(owner, deltaTime)
      self:OnPressUp(true)
      self.ltFinishGuide = nil
    end, self)
  end
end

function HomeBuildingGuideView:OnPressUp(isFake)
  if not self:IsInAnyGuide() or self.curStepIndex == HomeBuildingGuideView.Step.DragFurniture then
    return
  end
  local isFinish = self.tabGuideStepOperateNum[self.curStepIndex] and self.tabGuideStepOperateNum[self.curStepIndex] > m_operateMinNum and (self.curStepIndex == HomeBuildingGuideView.Step.CameraMove or self.curStepIndex == HomeBuildingGuideView.Step.CameraRotateHori or self.curStepIndex == HomeBuildingGuideView.Step.CameraRotateVert or self.curStepIndex == HomeBuildingGuideView.Step.CameraZoom)
  if not isFake and self.curOperateStep then
    self.tabGuideStepOperateNum[self.curOperateStep] = 0
  end
  self:ClearFinishGuideLt()
  if isFinish then
    self:FinishGuideStep(self.curOperateStep)
  elseif not isFake or self.curStepIndex == HomeBuildingGuideView.Step.CameraZoom then
    self:ShowBlackMask(true)
  end
  self.curOperateStep = nil
end

function HomeBuildingGuideView:OnZoomOver()
  if self.curStepIndex ~= HomeBuildingGuideView.Step.CameraZoom or not self.tabGuideStepOperateNum[self.curStepIndex] then
    return
  end
  self:FinishGuideStep(self.curStepIndex)
end

function HomeBuildingGuideView:OnFurniturePlaced(nFurniture)
  if not self.curStepIndex == HomeBuildingGuideView.Step.DragFurniture or not self.targetDragFurniture then
    return
  end
  if nFurniture.data.id ~= self.targetDragFurnitureID then
    return
  end
  local config = m_furnitureDragTargetConfig
  if nFurniture.placeFloor == config.floor and nFurniture.placeRow == self.needPlaceRow and nFurniture.placeCol == self.needPlaceCol then
    self:FinishGuideStep(self.curStepIndex)
  else
    self:ResetDragFurnitureStartSign()
    local screenPos = self.container.cameraControl:WorldToScreenPoint(self.targetFurniturePos)
    self:ResetBlackMask(screenPos.x, screenPos.y, m_MaskLightSize.small)
    self:ShowBlackMask(true)
    self:ShowDragHand(true)
  end
end

function HomeBuildingGuideView:ResetDragFurnitureStartSign()
  local screenPoint = self.container.cameraControl:WorldToScreenPoint(self.targetDragFurniture:GetPosition())
  screenPoint.x = math.clamp(screenPoint.x, 0, self.screenWidth)
  screenPoint.y = math.clamp(screenPoint.y, 0, self.screenHeight)
  screenPoint.z = 0
  local furnitureScreenPos = self.container.cameraUI:ScreenToWorldPoint(screenPoint)
  furnitureScreenPos.z = 0
  self.tsfDragHandParent.position = furnitureScreenPos
  self.tsfDragStartSign.position = self.targetDragFurniture:GetPosition()
  self.tsfDragStartSign.localEulerAngles = GetTempVector3(0, self.targetDragFurniture:GetRotationAngle(), 0)
  self.objDragStartSign:SetActive(true)
end

function HomeBuildingGuideView:ShowDragHand(isShow, immediate)
  if self.isDragHandShow == isShow then
    return
  end
  self.isDragHandShow = isShow
  if immediate then
    self.widgetDragHandParent.alpha = isShow and 1 or 0
    return
  end
  TweenAlpha.Begin(self.objDragHandParent, 0.1, isShow and 1 or 0)
end

function HomeBuildingGuideView:ClearNextGuideLt()
  if self.ltNextGuide then
    self.ltNextGuide:Destroy()
    self.ltNextGuide = nil
  end
end

function HomeBuildingGuideView:ClearFinishGuideLt()
  if self.ltFinishGuide then
    self.ltFinishGuide:Destroy()
    self.ltFinishGuide = nil
  end
end

function HomeBuildingGuideView:LoadSpineAnim(name, animName, timeScale, objParent)
  local obj = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.Emoji(name), objParent)
  UIUtil.ChangeLayer(obj, objParent.layer)
  obj:SetActive(true)
  obj.name = name
  local anim = obj:GetComponent(SkeletonAnimation)
  anim.AnimationName = animName
  anim:Reset()
  anim.loop = true
  anim.timeScale = timeScale
  SpineLuaHelper.PlayAnim(anim, animName, nil)
  obj:GetComponent(UISpine).depth = 10
  return obj
end

function HomeBuildingGuideView:ShowBlackMask(isShow, immediate)
  if self.isBlackMaskShow == isShow then
    return
  end
  self.isBlackMaskShow = isShow
  if immediate then
    self.texBlackMask.alpha = isShow and m_blackMaskAlpha or 0
    return
  end
  TweenAlpha.Begin(self.objBlackMask, 0.1, isShow and m_blackMaskAlpha or 0)
end

function HomeBuildingGuideView:ResetBlackMask(posx, posy, height, width)
  local width = width or self.aspectRatio * height
  local x = 0.5 - posx / self.screenWidth * width
  local y = 0.5 - posy / self.screenHeight * height
  self:SetBlackMaskRect(x, y, width, height)
end

function HomeBuildingGuideView:SetBlackMaskRect(x, y, width, height)
  self.rectMaskTex.x = x
  self.rectMaskTex.y = y
  self.rectMaskTex.width = width
  self.rectMaskTex.height = height
  self.texBlackMask.uvRect = self.rectMaskTex
end
