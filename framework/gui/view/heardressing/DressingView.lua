autoImport("ShopDressingView")
autoImport("Asset_Role_UI")
DressingView = class("DressingView", ShopDressingView)
DressingView.ViewType = UIViewType.NormalLayer
autoImport("HairPage")
autoImport("EyePage")
local _shopType, _shopID, _hairCost, _eyeCost, _ShopDressProxy, _PackageCheck
local _bHasTicket = function(id)
  if id then
    local ticketNum = BagProxy.Instance:GetAllItemNumByStaticID(id)
    return 0 < ticketNum
  else
    return false
  end
end
local _EDressType = {
  Hair = SceneUser2_pb.EDRESSTYPE_HAIR,
  HairColor = SceneUser2_pb.EDRESSTYPE_HAIRCOLOR,
  Eye = SceneUser2_pb.EDRESSTYPE_EYE
}
DressingView.TabName = {
  [1] = ZhString.HairDressingView_HairPageTitle,
  [2] = ZhString.HairDressingView_EyePageTitle
}
local _DressType = {
  ShopDressingProxy.DressingType.HAIR,
  ShopDressingProxy.DressingType.HAIRCOLOR,
  ShopDressingProxy.DressingType.EYE,
  ShopDressingProxy.DressingType.ClothColor
}
local _EnviromentMgr

function DressingView:FindObjs()
  DressingView.super.FindObjs(self)
  self.hairPage = self:FindGO("HairPage")
  self.eyePage = self:FindGO("EyePage")
  self.headgearToggle = self:FindGO("HeadgearToggle"):GetComponent(UIToggle)
  self.facegearToggle = self:FindGO("FacegearToggle"):GetComponent(UIToggle)
  self.HideHeadgearLabel = self:FindGO("HideHeadgearLabel"):GetComponent(UILabel)
  self.HideFacegearLabel = self:FindGO("HideFacegearLabel"):GetComponent(UILabel)
  self.hairToggle = self:FindGO("HairToggle")
  self.eyeToggle = self:FindGO("EyeToggle")
  self.hairCutLabel = self:FindGO("NameLabel", self.hairToggle):GetComponent(UILabel)
  self.hairDyeLabel = self:FindGO("NameLabel", self.eyeToggle):GetComponent(UILabel)
  self.hairCutTabIconSp = self:FindGO("Icon", self.hairToggle):GetComponent(UISprite)
  self.hairDyeTabIconSp = self:FindGO("Icon", self.eyeToggle):GetComponent(UISprite)
  self:Hide(self.eyePage)
end

function DressingView:InitUIView()
  _ShopDressProxy = ShopDressingProxy.Instance
  _EnviromentMgr = Game.EnviromentManager
  self.super.InitUIView(self)
  self:InitSceneModel()
  self.bgTex = self:FindComponent("BgTexture", UITexture)
  self.HairPage = self:AddSubView("HairPage", HairPage)
  self.hairCutLabel.text = DressingView.TabName[1]
  self.hairDyeLabel.text = DressingView.TabName[2]
  self.HideHeadgearLabel.text = ZhString.HairDressingView_HideHeadgear
  self.HideFacegearLabel.text = ZhString.EyeLensesView_hideFacegear
  self.pageType = 1
  TabNameTip.SwitchShowTabIconOrLabel(self.hairCutTabIconSp.gameObject, self.hairCutLabel.gameObject)
  TabNameTip.SwitchShowTabIconOrLabel(self.hairDyeTabIconSp.gameObject, self.hairDyeLabel.gameObject)
  self:SetCurrentTabIconColor(self.hairToggle)
  _shopType = _ShopDressProxy.shopType
  _shopID = _ShopDressProxy.shopID
  _PackageCheck = GameConfig.PackageMaterialCheck.unlock_hair_eye
  local costConfig = GameConfig.HairEye or {HairCost = 2000, EyeCost = 3000}
  _hairCost = costConfig.HairCost
  _eyeCost = costConfig.EyeCost
  self.useSceneModel = true
  local featherEffectContainer = self:FindGO("featherEffectContainer")
  self:PlayUIEffect(EffectMap.UI.DressingModelFeather, featherEffectContainer)
  self:PlayUIEffect(EffectMap.UI.Eff_BokiView_ui, featherEffectContainer)
  self.recvCall = {}
  self.recvCall[_EDressType.Hair] = self.HandleRecvHair
  self.recvCall[_EDressType.HairColor] = self.HandleRecvHairColor
  self.recvCall[_EDressType.Eye] = self.HandleRecvEye
end

function DressingView:InitSceneModel()
  if self.sceneObj then
    return
  end
  self.vecCameraPosRecord = LuaVector3()
  self.quaCameraRotRecord = LuaQuaternion()
  self.sceneObj = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UIModel("ShopDressingScene"))
  self.sceneObj.transform.position = LuaGeometry.GetTempVector3(0, 1000, 0)
  self.rolePos = self:FindGO("RolePos", self.sceneObj)
  self.cameraPos = self:FindGO("CameraPos", self.sceneObj).transform
  UIManagerProxy.Instance:RefitSceneModel(self.cameraPos)
  self.eyeYAxisOffset = Game.Myself.data:IsDoram() and 47.064 or 46.826
end

function DressingView:AddEvts()
  self.super.AddEvts(self)
  self:AddDragEvent(self.touchZone, function(obj, delta)
    if self.role then
      self.role:RotateDelta(-delta.x)
    end
  end)
  self:AddClickEvent(self.headgearToggle.gameObject, function(g)
    self:ClickGearToggle()
  end)
  self:AddClickEvent(self.facegearToggle.gameObject, function(g)
    self:ClickGearToggle()
  end)
  self:AddTabChangeEvent(self.hairToggle, self.hairPage, PanelConfig.HairPage)
  self:AddTabChangeEvent(self.eyeToggle, self.eyePage, PanelConfig.EyePage)
  local toggleList = {
    self.hairToggle,
    self.eyeToggle
  }
  for i, v in ipairs(toggleList) do
    local longPress = v:GetComponent(UILongPress)
    
    function longPress.pressEvent(obj, state)
      self:PassEvent(TipLongPressEvent.DressingView, {state, i})
    end
  end
  self:AddEventListener(TipLongPressEvent.DressingView, self.HandleLongPress, self)
  self:AddListenEvt(ServiceEvent.PlayerMapChange, self.CloseSelf)
end

function DressingView:HandleRecvHair()
  self.HairPage:ResetEquiped()
end

function DressingView:HandleRecvHairColor()
  self.HairPage:ResetDyeEquiped()
end

function DressingView:HandleRecvEye()
  self.EyePage:ResetEquiped()
  self.EyePage:ResetDyeEquiped()
end

function DressingView:TabChangeHandler(key)
  DressingView.super.TabChangeHandler(self, key)
  if self.pageType == key then
    return
  end
  self.pageType = key
  _ShopDressProxy:ResetQueryData()
  if key == 1 then
    self.HairPage:ResetChoose()
    self.EyePage:ResetChoose()
    self.EyePage:Hide(self.EyePage.desc)
    self.EyePage:Hide(self.EyePage.menuDes)
    self.HairPage:InitPageView()
    _shopType = _ShopDressProxy.shopType
    _shopID = _ShopDressProxy.shopID
    self.rolePos.transform.localPosition = LuaGeometry.GetTempVector3(-0.673, 47.222, -406.165)
  else
    if nil == self.EyePage then
      self.EyePage = self:AddSubView("EyePage", EyePage)
    end
    self.HairPage:ResetChoose()
    self.EyePage:ResetChoose()
    self.HairPage:Hide(self.HairPage.desc)
    self.HairPage:Hide(self.HairPage.menuDes)
    self.EyePage:InitPageView()
    _shopType = _ShopDressProxy.shopType2
    _shopID = _ShopDressProxy.shopID2
    self.rolePos.transform.localPosition = LuaGeometry.GetTempVector3(-0.38, self.eyeYAxisOffset, -408.67)
  end
  self:DisableState()
  self:RefreshModel()
  self:SetCurrentTabIconColor(self.coreTabMap[key].go)
end

function DressingView:ClickGearToggle()
  self:RefreshModel()
end

function DressingView:ClickReplaceBtn()
  if self.pageType == 1 then
    self:ClickReplaceHair()
  elseif self.pageType == 2 then
    self:ClickReplaceEye()
  end
end

function DressingView:ClickUnlockBtn()
  if self.pageType == 1 then
    self:_clickUnlockHair()
  elseif self.pageType == 2 then
    self:_clickUnlockEye()
  end
end

function DressingView:_clickUnlockHair()
  if self.hairUnlockEnough == false then
    local id = self.costId == GameConfig.MoneyId.Zeny and 1 or 8
    MsgManager.ShowMsgByID(id)
    return
  end
  local queryArgs = _ShopDressProxy:GetQueryArgs()
  local hairStyleID = queryArgs[1]
  if not hairStyleID then
    return
  end
  local costid = self.costId ~= GameConfig.MoneyId.Zeny and self.costId or 0
  ServiceSceneUser3Proxy.Instance:CallUnlockDress(_EDressType.Hair, hairStyleID, costid)
end

function DressingView:_clickUnlockEye()
  if self.eyeUnlockEnough == false then
    local id = self.costId == GameConfig.MoneyId.Zeny and 1 or 8
    MsgManager.ShowMsgByID(id)
    return
  end
  local queryArgs = _ShopDressProxy:GetQueryArgs()
  local eyeID = queryArgs[6]
  if not eyeID then
    return
  end
  local costid = self.costId ~= GameConfig.MoneyId.Zeny and self.costId or 0
  ServiceSceneUser3Proxy.Instance:CallUnlockDress(_EDressType.Eye, eyeID, costid)
end

function DressingView:RecvNewDressing()
  DressingView.super.RecvNewDressing(self)
  local page = self.pageType == 1 and self.HairPage or self.EyePage
  if page and page.UpdateUnlock then
    page:UpdateUnlock()
  end
end

function DressingView:ClickReplaceEye()
  local queryArgs = _ShopDressProxy:GetQueryArgs()
  local eyeID = queryArgs[6]
  if not eyeID then
    return
  end
  local eyeShopID = queryArgs[7]
  if _ShopDressProxy:IsSame(_DressType[3]) then
    MsgManager.FloatMsgTableParam(nil, ZhString.EyeLensesView_sameEyeLenses)
    return
  end
  local tempcsv = ShopProxy.Instance:GetShopItemDataByTypeId(_shopType, _shopID, eyeShopID)
  if tempcsv:CheckCanRemove() then
    MsgManager.FloatMsgTableParam(nil, ZhString.HappyShop_overtime)
    return
  end
  if not _ShopDressProxy:bActived(eyeID, _DressType[3]) then
    local lockmsg = tempcsv:GetMenuDes()
    if lockmsg then
      MsgManager.FloatMsgTableParam(nil, lockmsg)
    end
    return
  end
  local curMoney = MyselfProxy.Instance:GetROB()
  if curMoney < _eyeCost then
    MsgManager.ShowMsgByIDTable(1)
    return
  end
  ServiceNUserProxy.Instance:CallChangeEyeUserCmd(eyeID)
end

function DressingView:ClickReplaceHair()
  local queryArgs = _ShopDressProxy:GetQueryArgs()
  local hairStyleID, hairColorID = queryArgs[1], queryArgs[4]
  if not hairStyleID and not hairColorID then
    return
  end
  local hairItemID, hairShopID = queryArgs[2], queryArgs[3]
  local hairColorShopID = queryArgs[5]
  local hasTicket = false
  if _ShopDressProxy:IsSame(_DressType[1]) and _ShopDressProxy:IsSame(_DressType[2]) then
    MsgManager.FloatMsgTableParam(nil, ZhString.HairDressingView_bSameHair)
    return
  end
  local curMoney = MyselfProxy.Instance:GetROB()
  if _ShopDressProxy:IsSame(_DressType[1]) then
    if not hairColorID then
      MsgManager.FloatMsgTableParam(nil, ZhString.HairDressingView_bSameHair)
      return
    else
      hairItemID = nil
    end
  end
  if hairItemID then
    local tempcsv = ShopProxy.Instance:GetShopItemDataByTypeId(_shopType, _shopID, hairShopID)
    if tempcsv:CheckCanRemove() then
      MsgManager.FloatMsgTableParam(nil, ZhString.HappyShop_overtime)
      return
    end
    if not _ShopDressProxy:bActived(hairStyleID, _DressType[1]) then
      local lockmsg = tempcsv:GetMenuDes()
      if lockmsg then
        MsgManager.FloatMsgTableParam(nil, lockmsg)
      end
      return
    end
    local preCost = tempcsv.PreCost
    hasTicket = _bHasTicket(preCost)
    if not hasTicket and curMoney < _hairCost then
      MsgManager.ShowMsgByIDTable(1)
      return
    end
  end
  if _ShopDressProxy:IsSame(_DressType[2]) then
    if not hairStyleID then
      MsgManager.FloatMsgTableParam(nil, ZhString.HairDressingView_bSameColor)
      return
    else
      hairColorID = nil
    end
  end
  if hairColorID then
    if curMoney < _hairCost then
      MsgManager.ShowMsgByIDTable(1)
      return
    end
    local curHair = hairItemID or _ShopDressProxy.originalHair
    if GameConfig.HairColor and GameConfig.HairColor[curHair] then
      MsgManager.ShowMsgByID(41402)
      return
    end
    local tempcsv = ShopProxy.Instance:GetShopItemDataByTypeId(_shopType, _shopID, hairColorShopID)
    if tempcsv:CheckCanRemove() then
      MsgManager.FloatMsgTableParam(nil, ZhString.HappyShop_overtime)
      return
    end
  end
  ServiceNUserProxy.Instance:CallChangeHairUserCmd(hairItemID, hairColorID)
end

function DressingView.GetUnlockCost(id, is_hair)
  local _shopDressProxy = ShopDressingProxy.Instance
  local unlockCost = is_hair and _shopDressProxy:GetHairUnlockItems(id) or _shopDressProxy:GetEyeUnlockItems(id)
  if not unlockCost then
    redlog("--------------------------策划未配置发型美瞳解锁，配置GameConfig.HairEyeUnlock, error id: ", id)
    return
  end
  local cost_id, cost_num = unlockCost[1], unlockCost[2]
  return cost_id, cost_num, cost_num < BagProxy.Instance:GetItemNumByStaticID(cost_id, _PackageCheck)
end

function DressingView:RefreshSelectedROB(type, precost, hairID, eyeID)
  self:Show(self.chargeNum)
  self:Show(self.itemIcon)
  self:Show(self.chargeTitle)
  self:RefreshMoney()
  local needCost = _hairCost
  local myZeny = MyselfProxy.Instance:GetROB()
  IconManager:SetItemIcon(Table_Item[100].Icon, self.itemIcon)
  local enoughZeny, isActive
  self.hairUnlockEnough, self.eyeUnlockEnough, self.costId = nil, nil, nil
  if type == 1 then
    isActive = _ShopDressProxy:bActived(hairID, _DressType[1])
    local updateReplaceBtnState = function()
      local isSame
      local enoughZeny = myZeny >= _hairCost
      local hasTicket = _bHasTicket(precost)
      if hairID then
        isSame = _ShopDressProxy:IsSame(_DressType[1])
      else
        isSame = _ShopDressProxy:IsSame(_DressType[2])
      end
      self:SetReplaceBtnState(not isSame and (hasTicket or enoughZeny))
    end
    if nil ~= hairID and not isActive then
      self:Hide(self.chargeRoot)
      self:Show(self.unlockRoot)
      local cost_id, cost_num, cost_enough = DressingView.GetUnlockCost(hairID, true)
      self.unlockCostLab.text = StringUtil.NumThousandFormat(cost_num)
      self.unlockCostLab.color = cost_enough and ColorUtil.ButtonLabelBlue or ColorUtil.Red
      local costIconName = Table_Item[cost_id].Icon
      IconManager:SetItemIcon(costIconName, self.unlockCostIcon)
      self.hairUnlockEnough = cost_enough
      self.costId = cost_id
      updateReplaceBtnState()
    else
      self:Show(self.chargeRoot)
      self:Hide(self.unlockRoot)
      self.chargeNum.text = StringUtil.NumThousandFormat(_hairCost)
      enoughZeny = myZeny >= _hairCost
      if enoughZeny then
        self.chargeNum.color = ColorUtil.ButtonLabelBlue
      else
        ColorUtil.RedLabel(self.chargeWidget)
      end
      updateReplaceBtnState()
    end
  elseif type == 2 then
    isActive = _ShopDressProxy:bActived(eyeID, _DressType[3])
    local updateReplaceBtnState = function()
      local enoughZeny = myZeny >= _eyeCost
      local isSame = _ShopDressProxy:IsSame(_DressType[3])
      self:SetReplaceBtnState(not isSame and enoughZeny)
    end
    if nil ~= eyeID and not isActive then
      self:Hide(self.chargeRoot)
      self:Show(self.unlockRoot)
      local styleid = Table_Eye[eyeID].StyleID
      local cost_id, cost_num, cost_enough = DressingView.GetUnlockCost(styleid, false)
      self.unlockCostLab.text = StringUtil.NumThousandFormat(cost_num)
      self.unlockCostLab.color = cost_enough and ColorUtil.ButtonLabelBlue or ColorUtil.Red
      local costIconName = Table_Item[cost_id].Icon
      IconManager:SetItemIcon(costIconName, self.unlockCostIcon)
      self.eyeUnlockEnough = cost_enough
      self.costId = cost_id
      updateReplaceBtnState()
    else
      self:Hide(self.unlockRoot)
      self:Show(self.chargeRoot)
      self.chargeNum.text = StringUtil.NumThousandFormat(_eyeCost)
      enoughZeny = myZeny >= _eyeCost
      if enoughZeny then
        self.chargeNum.color = ColorUtil.ButtonLabelBlue
      else
        ColorUtil.RedLabel(self.chargeWidget)
      end
      updateReplaceBtnState()
    end
  end
end

function DressingView:RecvUseDressing(note)
  DressingView.super.RecvUseDressing(self, note)
  local t = note.body.type
  local call = self.recvCall[t]
  if call then
    call(self)
  end
end

local partIndex = Asset_Role.PartIndex
local partIndexEx = Asset_Role.PartIndexEx

function DressingView:RefreshModel()
  local userdata = Game.Myself.data.userdata
  if not userdata then
    return
  end
  local parts = Asset_Role.CreatePartArray()
  if not self.role then
    parts[Asset_Role.PartIndexEx.SkinQuality] = Asset_RolePart.SkinQuality.Bone4
    self.role = Asset_Role_UI.Create(parts)
    self.role:SetParent(self.rolePos.transform, false)
    self.role:SetLayer(Game.ELayer.Outline)
    self.role:SetPosition(LuaGeometry.Const_V3_zero)
    self.role:SetEulerAngleY(180)
    self.role:SetScale(1)
    self.role:SetShadowEnable(false)
    self.role:ActiveMulColor(LuaColor.New(1, 1, 1, 1))
    self.role:RegisterWeakObserver(self)
  end
  local args = ReusableTable.CreateArray()
  local queryArgs = ShopDressingProxy.Instance:GetQueryArgs()
  if nil ~= next(queryArgs) then
    args[1] = queryArgs[1] or _ShopDressProxy.originalHair
    args[2] = queryArgs[4] or _ShopDressProxy.originalHairColor
    args[3] = queryArgs[6] or _ShopDressProxy.originalEye
    args[6] = queryArgs[8] or _ShopDressProxy.originalBodyColor
    args[7] = nil ~= queryArgs[8] and _ShopDressProxy:getBodyID() or _ShopDressProxy.originalBody
  else
    args[1] = _ShopDressProxy.originalHair
    args[2] = _ShopDressProxy.originalHairColor
    args[3] = _ShopDressProxy.originalEye
    args[6] = _ShopDressProxy.originalBodyColor
    args[7] = _ShopDressProxy.originalBody
  end
  args[8] = self.headgearToggle.value and 0 or ShopDressingProxy.Instance.originalHead
  args[9] = self.facegearToggle.value and 0 or ShopDressingProxy.Instance.originalFace
  parts[partIndex.Body] = args[7]
  parts[partIndex.Hair] = args[1]
  parts[partIndexEx.HairColorIndex] = args[2]
  parts[partIndex.Eye] = args[3]
  local config, bodyType
  local part = parts[partIndex.Body]
  if 0 < part then
    config = Table_Body[part]
    bodyType = config ~= nil and config.BodyType
  end
  if bodyType ~= nil then
    local eyeIndex = parts[partIndex.Eye]
    local t = type(bodyType)
    if t == "number" then
    elseif t == "string" and string.find(bodyType, "hf_") then
      local tempGender = 0
      local bodyData = Table_Body[part]
      local realGender = Table_Eye[eyeIndex].Sex
      if bodyType == "hf_doram_002" then
        bodyType = 1
        tempGender = 2
      elseif bodyType == "hf_doram_001" then
        bodyType = 2
        tempGender = 1
      elseif bodyType == "hf_human_002" then
        bodyType = 3
        tempGender = 2
      elseif bodyType == "hf_human_001" then
        bodyType = 4
        tempGender = 1
      else
        bodyType = 0
      end
      if eyeIndex and 4 < eyeIndex and tempGender ~= realGender then
        parts[partIndex.Eye] = Table_Eye[eyeIndex].PairItemID
      end
    end
  end
  parts[partIndexEx.BodyColorIndex] = args[6]
  parts[partIndexEx.Gender] = Game.Myself.data.userdata:Get(UDEnum.SEX)
  parts[partIndex.Head] = args[8]
  parts[partIndex.Face] = args[9]
  self.role:Redress(parts, true)
  Asset_Role.DestroyPartArray(parts)
  self.role:SetEpNodesDisplay(true)
end

function DressingView:ObserverDestroyed(obj)
  if obj == self.role then
    self.role:UnregisterWeakObserver(self)
    self.role = nil
  end
end

function DressingView:OnEnter()
  DressingView.super.OnEnter(self)
  self:FocusCameraToScene()
  self:DisableState()
  Game.EnviromentManager:SetSpecialBloomEffect(EnviromentManager.UIRoleBloom)
end

function DressingView:FocusCameraToScene()
  if self.isCameraOnModel then
    return
  end
  if self.ltInitCamera then
    return
  end
  if not self.cameraWorld or LuaGameObject.ObjectIsNull(self.cameraWorld) then
    self.cameraWorld = NGUITools.FindCameraForLayer(Game.ELayer.Default)
    if not self.cameraWorld then
      self.initRetryCount = self.initRetryCount + 1
      if self.initRetryCount > 9 then
        return
      end
      self.ltInitCamera = TimeTickManager.Me():CreateOnceDelayTick(self.initRetryCount * 100, function(owner, deltaTime)
        self.ltInitCamera = nil
        self:FocusCameraToScene()
      end, self, 3)
      return
    end
  end
  ServiceWeatherProxy.Instance:SetWeatherEnable(false)
  FunctionSystem.InterruptMyself()
  self.cameraController = self.cameraWorld.gameObject:GetComponent(CameraController)
  if not self.cameraController then
    local curMapID = Game.MapManager:GetMapID()
    LogUtility.Error("没有在主摄像机上找到CameraController. Map ID：  ", curMapID)
    return
  end
  self.tsfCameraWorld = self.cameraWorld.transform
  self.fovRecord = self.cameraWorld.fieldOfView
  self.cameraController.applyCurrentInfoPause = true
  self.cameraController.enabled = false
  LuaVector3.Better_Set(self.vecCameraPosRecord, LuaGameObject.GetPosition(self.tsfCameraWorld))
  LuaQuaternion.Better_Set(self.quaCameraRotRecord, LuaGameObject.GetRotation(self.tsfCameraWorld))
  self.tsfCameraWorld.position = LuaGeometry.GetTempVector3(LuaGameObject.GetPosition(self.cameraPos))
  self.tsfCameraWorld.rotation = LuaGeometry.GetTempQuaternion(LuaGameObject.GetRotation(self.cameraPos))
  self.cameraWorld.fieldOfView = 20
  self.isCameraOnModel = true
end

function DressingView:ResetCameraToDefault()
  if not self.isCameraOnModel then
    return
  end
  if self.ltInitCamera then
    self.ltInitCamera:Destroy()
    self.ltInitCamera = nil
  end
  ServiceWeatherProxy.Instance:SetWeatherEnable(true)
  if self.cameraWorld and not LuaGameObject.ObjectIsNull(self.cameraWorld) then
    self.tsfCameraWorld.position = self.vecCameraPosRecord
    self.tsfCameraWorld.rotation = self.quaCameraRotRecord
    if self.fovRecord then
      self.cameraWorld.fieldOfView = self.fovRecord
    end
    if self.cameraController then
      self.cameraController.applyCurrentInfoPause = false
      self.cameraController:InterruptSmoothTo()
      self.cameraController.enabled = true
      self:UpdateCameraViewPort(0)
    end
  end
  self.fovRecord = nil
  self.isCameraOnModel = false
end

function DressingView:UpdateCameraViewPort(duration)
  local mount = BagProxy.Instance:GetRoleEquipBag():GetMount()
  self:CameraRotateToMe(false, mount and CameraConfig.UI_WithMount_ViewPort or CameraConfig.UI_ViewPort, nil, nil, duration)
end

function DressingView:OnExit()
  DressingView.super.OnExit(self)
  self:ResetCameraToDefault()
  self:DestroySceneObj()
  self:CameraReset()
  if self.role then
    self.role:DeactiveMulColor()
  end
  _EnviromentMgr:UnSetSpecialBloomEffect()
end

function DressingView:DestroySceneObj()
  if self.sceneObj then
    LuaGameObject.DestroyObject(self.sceneObj)
    self.sceneObj = nil
    self.rolePos = nil
    self.cameraPos = nil
  end
end

function DressingView:HandleLongPress(param)
  local isPressing, index = param[1], param[2]
  local name = string.gsub(DressingView.TabName[index], "\n", "")
  TabNameTip.OnLongPress(isPressing, name, false, Game.GameObjectUtil:DeepFindChild(self.coreTabMap[index].go, "Background"):GetComponent(UISprite))
end

local choosenColor = Color(0.7215686274509804, 0.7411764705882353, 0.8627450980392157, 1)

function DressingView:SetCurrentTabIconColor(currentTabGo)
  self.hairCutTabIconSp.color = choosenColor
  self.hairDyeTabIconSp.color = choosenColor
  if not currentTabGo then
    return
  end
  local icon = Game.GameObjectUtil:DeepFindChild(currentTabGo, "Icon")
  if icon then
    local iconSp = icon:GetComponent(UISprite)
    if iconSp then
      iconSp.color = ColorUtil.TabColor_White
    end
  end
end
