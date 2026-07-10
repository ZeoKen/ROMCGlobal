ActivityIntegrationLotteryRaidShopSubView = class("ActivityIntegrationLotteryRaidShopSubView", SubView)
autoImport("ActivityIntegrationLotteryRaidShopGoodsCell")
autoImport("NewHappyShopBuyItemCell")
autoImport("Asset_Role_UI")
local viewPath = ResourcePathHelper.UIView("ActivityIntegrationLotteryRaidShopSubView")
local scenePath = ResourcePathHelper.UIModel("LotteryRaidShopScene")
local rightBgTexName = "PayRaid_shop_bg"
local tempVector3 = LuaVector3.Zero()
local modelCameraFov = 20
local GetCameraPostProcessing = function(comp)
  return comp.renderPostProcessing
end
local SetCameraPostProcessing = function(comp, enable)
  comp.renderPostProcessing = enable
end

function ActivityIntegrationLotteryRaidShopSubView:Init(initParama)
  if self.inited then
    return
  end
  self.hideRaidEntry = initParama and initParama.hideRaidEntry
  self:FindObjs()
  self:SetRaidEntryVisible(self.hideRaidEntry or false)
  self:AddViewEvts()
  self:AddMapEvts()
  self:InitDatas()
  self.inited = true
end

function ActivityIntegrationLotteryRaidShopSubView:LoadSubView()
  local obj = self:LoadPreferb_ByFullPath(viewPath, self.container, true)
  obj.name = "ActivityIntegrationLotteryRaidShopSubView"
  self.gameObject = obj
end

function ActivityIntegrationLotteryRaidShopSubView:FindObjs()
  self:LoadSubView()
  self.rightBgTex = self:FindComponent("RightBgTex", UITexture, self.gameObject)
  self.titleLabel = self:FindComponent("TitleLabel", UILabel, self.gameObject)
  self.leftTimeBg = self:FindGO("LeftTimeBg", self.gameObject)
  self.timeLabel = self:FindComponent("TimeLabel", UILabel, self.gameObject)
  self.helpBtn = self:FindGO("HelpBtn", self.gameObject)
  self.modelTexture = self:FindGO("ModelTexture", self.gameObject)
  if self.modelTexture then
    self:AddDragEvent(self.modelTexture, function(go, delta)
      self:RotateModel(go, delta)
    end)
  end
  self.shopScrollView = self:FindGO("ShopScrollView", self.gameObject):GetComponent(UIScrollView)
  self.shopGrid = self:FindGO("Grid", self.gameObject):GetComponent(UIGrid)
  self.shopListCtrl = UIGridListCtrl.new(self.shopGrid, ActivityIntegrationLotteryRaidShopGoodsCell, "ActivityIntegrationLotteryRaidShopGoodsCell")
  self.shopListCtrl:AddEventListener(NewRechargeEvent.GoodsCell_ShowTip, self.ShowGoodsItemTip, self)
  self.shopListCtrl:AddEventListener(NewRechargeEvent.GoodsCell_ShowShopItemPurchaseDetail, self.ShowShopItemPurchaseDetail, self)
  self.goGachaCoinBalance = self:FindGO("GachaCoinBalance", self.gameObject)
  self.labGachaCoinBalance = self:FindComponent("Lab", UILabel, self.goGachaCoinBalance)
  self.spGachaCoin = self:FindComponent("Icon", UISprite, self.goGachaCoinBalance)
  self.addMoneyBtn = self:FindGO("AddMoney", self.goGachaCoinBalance)
  self.addMoneyBtn:SetActive(false)
  self.descLabel = self:FindComponent("DescLabel", UILabel, self.gameObject)
  self.goToBtn = self:FindGO("GotoBtn", self.gameObject)
  self.uiCamera = NGUIUtil:GetCameraByLayername("UI")
  self:InitBuyItemCell()
end

function ActivityIntegrationLotteryRaidShopSubView:AddViewEvts()
  if self.goToBtn then
    self:AddClickEvent(self.goToBtn, function()
      self:HandleClickGoToRaid()
    end)
  end
  if self.addMoneyBtn then
    self:AddClickEvent(self.addMoneyBtn, function()
      self:HandleClickAddMoney()
    end)
  end
end

function ActivityIntegrationLotteryRaidShopSubView:AddMapEvts()
  self:AddListenEvt(ServiceEvent.SessionShopBuyShopItem, self.RecvQueryShopConfig)
  self:AddListenEvt(ServiceEvent.SessionShopShopDataUpdateCmd, self.RecvQueryShopConfig)
  self:AddListenEvt(ServiceEvent.SessionShopUpdateShopConfigCmd, self.RecvQueryShopConfig)
  self:AddListenEvt(ServiceEvent.SessionShopQueryShopConfigCmd, self.RecvQueryShopConfig)
  self:AddListenEvt(ServiceEvent.UserEventQueryChargeCnt, self.RecvQueryShopConfig)
  self:AddListenEvt(MyselfEvent.MyDataChange, self.UpdateBalance)
  self:AddListenEvt(ItemEvent.ItemUpdate, self.UpdateBalance)
  self:AddListenEvt(ServiceEvent.NUserUpdateShopGotItem, self.UpdateBalance)
end

function ActivityIntegrationLotteryRaidShopSubView:InitDatas()
  self.vecCameraPosRecord = LuaVector3()
  self.quaCameraRotRecord = LuaQuaternion()
  self.initRetryCount = 0
  self.shopInfoInited = false
end

function ActivityIntegrationLotteryRaidShopSubView:SetActivityID(activityID)
  self.activityID = activityID
end

function ActivityIntegrationLotteryRaidShopSubView:InitShopConfig()
  local config = GameConfig.LotteryRaidShop
  self.shopConfig = config
  self.shopType = config and config.ShopType
  self.shopId = config and config.ShopId
  self.shopItemID = config and config.ShopItemID
  self.modelConfig = config and config.ModelItems
end

function ActivityIntegrationLotteryRaidShopSubView:LoadCellPfb(cName)
  local cellpfb = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell(cName))
  if cellpfb == nil then
    error("can not find cellpfb" .. cName)
  end
  cellpfb.transform:SetParent(self.gameObject.transform, false)
  return cellpfb
end

function ActivityIntegrationLotteryRaidShopSubView:InitBuyItemCell()
  local go = self:LoadCellPfb("NewHappyShopBuyItemCell")
  self.buyCell = NewHappyShopBuyItemCell.new(go)
  self.buyCell:AddEventListener(ItemTipEvent.ClickItemUrl, self.OnClickItemUrl, self)
  self.buyCell:AddCloseWhenClickOtherPlaceCallBack(self)
  self.CloseWhenClickOtherPlace = self.buyCell.closeWhenClickOtherPlace
  self.buyCell.gameObject:SetActive(false)
end

function ActivityIntegrationLotteryRaidShopSubView:RefreshPage(id)
  local staticData = self.staticData
  local titleName, helpID
  if self.hideRaidEntry then
    titleName = self.shopConfig and self.shopConfig.TitleName
    helpID = self.shopConfig and self.shopConfig.HelpID
  else
    titleName = staticData and staticData.TitleName
    helpID = staticData and staticData.HelpID
  end
  if self.titleLabel then
    self.titleLabel.text = titleName or ""
  end
  if self.helpBtn then
    if helpID then
      self:RegistShowGeneralHelpByHelpID(helpID, self.helpBtn)
    else
      self.helpBtn:SetActive(false)
    end
  end
  if staticData then
    self.startTime, self.endTime = LoopActIntegrationProxy.Instance:GetActivityTime(staticData)
  else
    self.startTime, self.endTime = nil, nil
  end
  TimeTickManager.Me():ClearTick(self, 1)
  if self.leftTimeBg then
    self.leftTimeBg:SetActive(staticData ~= nil)
  end
  if self.timeLabel and staticData then
    TimeTickManager.Me():CreateTick(0, 1000, self.UpdateLeftTime, self, 1)
  end
  if self.shopItemID then
    local itemData = Table_Item[self.shopItemID]
    if itemData and itemData.Icon then
      IconManager:SetItemIcon(itemData.Icon, self.spGachaCoin)
    end
  end
  self:RefreshRaidEntryDesc()
  self:RefreshRaidEntryVisible()
  self:UpdateBalance()
  self:UpdateShopInfo()
  self:RefreshModel()
end

function ActivityIntegrationLotteryRaidShopSubView:RefreshRaidEntryDesc()
  local paramsInte = self.staticData and self.staticData.Params_Inte
  local desc = paramsInte and paramsInte.Desc
  if self.descLabel then
    self.descLabel.text = desc and desc ~= "" and OverSea.LangManager.Instance():GetLangByKey(desc) or ""
  end
end

function ActivityIntegrationLotteryRaidShopSubView:SetRaidEntryVisible(isVisible)
  if self.descLabel then
    self.descLabel.gameObject:SetActive(isVisible)
  end
  if self.goToBtn then
    self.goToBtn:SetActive(isVisible)
  end
end

function ActivityIntegrationLotteryRaidShopSubView:RefreshRaidEntryVisible()
  self:SetRaidEntryVisible(not self.hideRaidEntry)
end

function ActivityIntegrationLotteryRaidShopSubView:HandleClickGoToRaid()
  local lotteryRaidData = PveEntranceProxy.Instance:GetCurLotteryRaidFirstPveData()
  if not lotteryRaidData then
    local datas = PveEntranceProxy.Instance:GetAllLotteryRaidData()
    lotteryRaidData = datas and datas[1]
  end
  if lotteryRaidData then
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.PveView,
      viewdata = {
        targetData = {lotteryRaidData}
      }
    })
  else
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.PveView
    })
  end
  if self.container then
    self.container:CloseSelf()
  end
end

function ActivityIntegrationLotteryRaidShopSubView:HandleClickAddMoney()
  FunctionNewRecharge.Instance():OpenUI(PanelConfig.NewRecharge_TDeposit)
end

function ActivityIntegrationLotteryRaidShopSubView:UpdateLeftTime()
  if not self.timeLabel then
    return
  end
  if not self.endTime then
    TimeTickManager.Me():ClearTick(self, 1)
    if self.leftTimeBg then
      self.leftTimeBg:SetActive(false)
    end
  else
    local leftTime = self.endTime - ServerTime.CurServerTime() / 1000
    if 0 < leftTime then
      local day, hour, min, sec = ClientTimeUtil.FormatTimeBySec(leftTime)
      local timeText
      if 0 < day then
        timeText = string.format(ZhString.PlayerTip_ExpireTime, day)
        self.timeLabel.text = timeText .. ZhString.PlayerTip_Day
      else
        timeText = string.format("%02d:%02d:%02d", hour, min, sec)
        self.timeLabel.text = string.format(ZhString.PlayerTip_ExpireTime, timeText)
      end
    else
      TimeTickManager.Me():ClearTick(self, 1)
      if self.leftTimeBg then
        self.leftTimeBg:SetActive(false)
      end
    end
  end
end

function ActivityIntegrationLotteryRaidShopSubView:RecvQueryShopConfig(note)
  self:UpdateShopInfo(self.shopInfoInited)
  self:UpdateBalance()
end

function ActivityIntegrationLotteryRaidShopSubView:UpdateShopInfo(isRefresh)
  if not self.shopItems then
    self.shopItems = {}
  else
    TableUtility.ArrayClear(self.shopItems)
  end
  if not self.shopType or not self.shopId then
    self.shopListCtrl:ResetDatas(self.shopItems)
    if not isRefresh then
      self.shopScrollView:ResetPosition()
    end
    return
  end
  local shopData = ShopProxy.Instance:GetShopDataByTypeId(self.shopType, self.shopId)
  if shopData then
    local config = shopData:GetGoods()
    for _, shopItemData in pairs(config) do
      TableUtility.ArrayPushBack(self.shopItems, self:CreateShopGoodsCellData(shopItemData))
    end
  end
  local _HappyShopProxy = HappyShopProxy.Instance
  table.sort(self.shopItems, function(l, r)
    local lCanBuyCount = _HappyShopProxy:GetCanBuyCount(l.shopItemData) or 999
    local rCanBuyCount = _HappyShopProxy:GetCanBuyCount(r.shopItemData) or 999
    if 0 < lCanBuyCount and 0 < rCanBuyCount then
      local lOrder = l.ShopOrder or 999999
      local rOrder = r.ShopOrder or 999999
      if lOrder == rOrder then
        return l.id < r.id
      end
      return lOrder < rOrder
    end
    return lCanBuyCount > rCanBuyCount
  end)
  self.shopListCtrl:ResetDatas(self.shopItems)
  if not isRefresh then
    self.shopScrollView:ResetPosition()
  end
  if shopData then
    self.shopInfoInited = true
  end
end

function ActivityIntegrationLotteryRaidShopSubView:CreateShopGoodsCellData(shopItemData)
  local data = {
    confType = NewRechargePrototypeGoodsCell.GoodsTypeEnum.Shop,
    ShopID = shopItemData.id,
    shopType = self.shopType,
    shopId = self.shopId,
    shopItemData = shopItemData,
    id = shopItemData.id,
    ShopOrder = shopItemData.ShopOrder
  }
  self:ApplyShopShowData(data, shopItemData.id)
  return data
end

function ActivityIntegrationLotteryRaidShopSubView:ApplyShopShowData(data, shopID)
  if not Table_ShopShow then
    return
  end
  for _, shopShowData in pairs(Table_ShopShow) do
    if shopShowData.ShopID == shopID then
      data.Picture = shopShowData.Picture
      data.IconScale = shopShowData.IconScale
      data.SuperValue = shopShowData.SuperValue
      data.IconTip = shopShowData.IconTip
      data.Order = shopShowData.Order
      data.KeyShow = shopShowData.KeyShow
      break
    end
  end
end

function ActivityIntegrationLotteryRaidShopSubView:ShowShopItemPurchaseDetail(data)
  local shopItemData = data and data.info
  self:HandleClickShopItem(shopItemData)
end

function ActivityIntegrationLotteryRaidShopSubView:HandleClickShopItem(shopItemData)
  local id = shopItemData and shopItemData.id
  local data = id and ShopProxy.Instance:GetShopItemDataByTypeId(self.shopType, self.shopId, id)
  if data then
    if data:GetLock() then
      FunctionUnLockFunc.Me():CheckCanOpen(data.MenuID, true)
      self.buyCell.gameObject:SetActive(false)
      return
    end
    local _HappyShopProxy = HappyShopProxy
    local config = Table_NpcFunction[_HappyShopProxy.Instance:GetShopType()]
    if config ~= nil and config.Parama.Source == _HappyShopProxy.SourceType.Guild and not GuildProxy.Instance:CanIDoAuthority(GuildAuthorityMap.Shop) then
      MsgManager.ShowMsgByID(3808)
      self.buyCell.gameObject:SetActive(false)
      return
    end
    if HappyShopProxy.Instance:isGuildMaterialType() then
      local npcdata = HappyShopProxy.Instance:GetNPC()
      if npcdata then
        self:CameraReset()
        self:CameraFocusAndRotateTo(npcdata.assetRole.completeTransform, CameraConfig.GuildMaterial_Choose_ViewPort, CameraConfig.GuildMaterial_Choose_Rotation)
      end
    end
    HappyShopProxy.Instance:SetSelectId(id)
    self.buyCell.gameObject:SetActive(true)
    self:UpdateBuyItemInfo(data)
  end
end

function ActivityIntegrationLotteryRaidShopSubView:GetScreenTouchedPos()
  local positionX, positionY, positionZ = LuaGameObject.GetMousePosition()
  LuaVector3.Better_Set(tempVector3, positionX, positionY, positionZ)
  if not UIUtil.IsScreenPosValid(positionX, positionY) then
    LogUtility.Error(string.format("ActivityIntegrationLotteryRaidShopSubView MousePosition is Invalid! x: %s, y: %s", positionX, positionY))
    return 0, 0
  end
  positionX, positionY, positionZ = LuaGameObject.ScreenToWorldPointByVector3(self.uiCamera, tempVector3)
  LuaVector3.Better_Set(tempVector3, positionX, positionY, positionZ)
  positionX, positionY, positionZ = LuaGameObject.InverseTransformPointByVector3(self.gameObject.transform, tempVector3)
  return positionX, positionY
end

function ActivityIntegrationLotteryRaidShopSubView:UpdateBuyItemInfo(data, funcBuy)
  if data then
    local positionX = self:GetScreenTouchedPos()
    if 0 < positionX then
      self.buyCell:updateLocalPostion(-217)
    else
      self.buyCell:updateLocalPostion(300)
    end
    self.buyCell:SetData(data, funcBuy)
    TipsView.Me():HideCurrent()
  else
    self.buyCell.gameObject:SetActive(false)
  end
end

local goodsTipData, goodsTipOffset = {}, {0, -90}

function ActivityIntegrationLotteryRaidShopSubView:ShowGoodsItemTip(itemConfID)
  if itemConfID ~= nil then
    goodsTipData.itemdata = ItemData.new(nil, itemConfID)
    TipManager.Instance:ShowItemFloatTip(goodsTipData, nil, NGUIUtil.AnchorSide.Center, goodsTipOffset)
  end
end

local itemClickUrlTipData = {}

function ActivityIntegrationLotteryRaidShopSubView:OnClickItemUrl(id)
  if not next(itemClickUrlTipData) then
    itemClickUrlTipData.itemdata = ItemData.new()
  end
  itemClickUrlTipData.itemdata:ResetData("itemClickUrl", id)
  
  function itemClickUrlTipData.clickItemUrlCallback(tip, itemid)
    TipManager.Instance:CloseTip()
    itemClickUrlTipData.itemdata:ResetData("itemClickUrl", itemid)
    self:ShowClickItemUrlTip(itemClickUrlTipData)
  end
  
  self:ShowClickItemUrlTip(itemClickUrlTipData)
end

local clickItemUrlTipOffset = {196, 0}

function ActivityIntegrationLotteryRaidShopSubView:ShowClickItemUrlTip(data)
  local tip = self:ShowItemTip(data, self.buyCell.bg, NGUIUtil.AnchorSide.Right, clickItemUrlTipOffset)
  if tip then
    tip:AddEventListener(ItemTipEvent.ShowFashionPreview, self.OnTipFashionPreviewShow, self)
    tip:AddEventListener(FashionPreviewEvent.Close, self.OnTipFashionPreviewClose, self)
  end
end

function ActivityIntegrationLotteryRaidShopSubView:OnTipFashionPreviewShow(preview)
  self.CloseWhenClickOtherPlace:AddTarget(preview.gameObject.transform)
end

function ActivityIntegrationLotteryRaidShopSubView:OnTipFashionPreviewClose()
  self.CloseWhenClickOtherPlace:ReCalculateBound()
end

function ActivityIntegrationLotteryRaidShopSubView:UpdateBalance()
  if not self.shopItemID then
    return
  end
  local coinNum = BagProxy.Instance:GetItemNumByStaticID(self.shopItemID)
  local milCommaBalance = FunctionNewRecharge.FormatMilComma(coinNum)
  if milCommaBalance then
    self.labGachaCoinBalance.text = milCommaBalance
  end
end

function ActivityIntegrationLotteryRaidShopSubView:GetActivityModelItems(sex)
  local modelConfig = self.modelConfig
  if not modelConfig then
    return
  end
  local modelItems = {}
  local fashionItems = modelConfig.Fashion
  local fashionItem
  if fashionItems then
    fashionItem = #fashionItems == 1 and fashionItems[1] or fashionItems[sex == 1 and 1 or 2]
  end
  if fashionItem then
    TableUtility.ArrayPushBack(modelItems, fashionItem)
  end
  local partItems = modelConfig.Parts
  if partItems then
    for i = 1, #partItems do
      TableUtility.ArrayPushBack(modelItems, partItems[i])
    end
  end
  return 0 < #modelItems and modelItems or nil, modelConfig.ModelScale
end

function ActivityIntegrationLotteryRaidShopSubView:IsValidModelItem(itemid)
  if not (itemid and Table_Item and Table_Item[itemid] and Table_Equip) or not Table_Equip[itemid] then
    return false
  end
  local equipData = Table_Equip[itemid]
  if equipData.Type == "Armour" and not equipData.Body then
    return false
  end
  local partIndex = ItemUtil.getItemRolePartIndex(itemid)
  return partIndex and partIndex ~= 0
end

function ActivityIntegrationLotteryRaidShopSubView:GetInvalidModelItemReason(itemid)
  if not itemid then
    return "itemid is nil"
  end
  if not Table_Item or not Table_Item[itemid] then
    return "Table_Item missing"
  end
  if not Table_Equip or not Table_Equip[itemid] then
    return "Table_Equip missing"
  end
  local equipData = Table_Equip[itemid]
  if equipData.Type == "Armour" and not equipData.Body then
    return "armour has no Body"
  end
  return "no role part"
end

function ActivityIntegrationLotteryRaidShopSubView:SetActivityModelTransform(model)
  local modelConfig = self.modelConfig
  if not model or not modelConfig then
    return
  end
  local pos = modelConfig.ModelPos
  if pos then
    model:SetPosition(LuaGeometry.GetTempVector3(pos[1], pos[2], pos[3]))
  end
  local rot = modelConfig.ModelRotation
  if rot then
    model:SetEulerAngles(LuaGeometry.GetTempVector3(rot[1], rot[2], rot[3]))
  end
end

function ActivityIntegrationLotteryRaidShopSubView:InitScene()
  if self.sceneObj then
    return
  end
  self.sceneObj = Game.AssetManager_UI:CreateAsset(scenePath)
  if not self.sceneObj then
    LogUtility.Error("ActivityIntegrationLotteryRaidShopSubView cannot load LotteryRaidShopScene")
    return
  end
  self.sceneObj.transform.position = LuaGeometry.GetTempVector3(0, 1000, 0)
  self.rolePos = self:FindGO("RolePos", self.sceneObj)
  local cameraPosGO = self:FindGO("CameraPos", self.sceneObj)
  local roleBgGO = self:FindGO("Reloading_BG", self.sceneObj)
  self.cameraPos = cameraPosGO and cameraPosGO.transform
  self.roleBg = roleBgGO and roleBgGO.transform
  if self.cameraPos then
    UIManagerProxy.Instance:RefitSceneModel(self.cameraPos, self.roleBg)
  end
end

function ActivityIntegrationLotteryRaidShopSubView:DestroyScene()
  if self.sceneObj then
    LuaGameObject.DestroyObject(self.sceneObj)
  end
  self.sceneObj = nil
  self.rolePos = nil
  self.cameraPos = nil
  self.roleBg = nil
end

function ActivityIntegrationLotteryRaidShopSubView:DestroyRoleModel()
  if self.model and self.model:Alive() then
    self.model:UnregisterWeakObserver(self)
    self.model:SetEpNodesDisplay(false)
    self.model:Destroy()
  end
  self.model = nil
  self.hasMount = nil
end

function ActivityIntegrationLotteryRaidShopSubView:DestroyCameraTick()
  if self.ltInitCamera then
    self.ltInitCamera:Destroy()
    self.ltInitCamera = nil
  end
end

function ActivityIntegrationLotteryRaidShopSubView:DisableCameraPostProcessing()
  if not self.cameraWorld or LuaGameObject.ObjectIsNull(self.cameraWorld) then
    return
  end
  self.cameraUrpData = self.cameraWorld.gameObject:GetComponent("UniversalAdditionalCameraData")
  if not self.cameraUrpData then
    return
  end
  local success, enabled = xpcall(GetCameraPostProcessing, debug.traceback, self.cameraUrpData)
  if success then
    self.cameraPostProcessingRecord = enabled
    xpcall(SetCameraPostProcessing, debug.traceback, self.cameraUrpData, false)
  end
end

function ActivityIntegrationLotteryRaidShopSubView:RestoreCameraPostProcessing()
  if self.cameraPostProcessingRecord ~= nil and self.cameraUrpData then
    xpcall(SetCameraPostProcessing, debug.traceback, self.cameraUrpData, self.cameraPostProcessingRecord)
  end
  self.cameraPostProcessingRecord = nil
  self.cameraUrpData = nil
end

function ActivityIntegrationLotteryRaidShopSubView:SwitchCameraToModel()
  if self.isCameraOnModel or self.ltInitCamera or not self.cameraPos then
    return
  end
  if not self.cameraWorld or LuaGameObject.ObjectIsNull(self.cameraWorld) then
    self.cameraWorld = NGUITools.FindCameraForLayer(Game.ELayer.Default)
    if not self.cameraWorld then
      self.initRetryCount = (self.initRetryCount or 0) + 1
      if self.initRetryCount > 9 then
        LogUtility.Error("ActivityIntegrationLotteryRaidShopSubView cannot find default camera")
        return
      end
      self.ltInitCamera = TimeTickManager.Me():CreateOnceDelayTick(self.initRetryCount * 100, function(owner, deltaTime)
        self.ltInitCamera = nil
        self:SwitchCameraToModel()
      end, self, 3)
      return
    end
  end
  self.initRetryCount = 0
  ServiceWeatherProxy.Instance:SetWeatherEnable(false)
  FunctionSystem.InterruptMyself()
  self.cameraController = self.cameraWorld.gameObject:GetComponent(CameraController)
  self.tsfCameraWorld = self.cameraWorld.transform
  self.fovRecord = self.cameraWorld.fieldOfView
  self:DisableCameraPostProcessing()
  if self.cameraController then
    self.cameraController.applyCurrentInfoPause = true
    self.cameraController.enabled = false
  else
    LogUtility.Error("ActivityIntegrationLotteryRaidShopSubView cannot find CameraController")
  end
  LuaVector3.Better_Set(self.vecCameraPosRecord, LuaGameObject.GetPosition(self.tsfCameraWorld))
  LuaQuaternion.Better_Set(self.quaCameraRotRecord, LuaGameObject.GetRotation(self.tsfCameraWorld))
  self.tsfCameraWorld.position = LuaGeometry.GetTempVector3(LuaGameObject.GetPosition(self.cameraPos))
  self.tsfCameraWorld.rotation = LuaGeometry.GetTempQuaternion(LuaGameObject.GetRotation(self.cameraPos))
  self.cameraWorld.fieldOfView = modelCameraFov
  self.isCameraOnModel = true
end

function ActivityIntegrationLotteryRaidShopSubView:ResetCameraToDefault()
  self:DestroyCameraTick()
  if not self.isCameraOnModel then
    return
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
      self:CameraReset()
    end
  end
  self:RestoreCameraPostProcessing()
  self.fovRecord = nil
  self.isCameraOnModel = false
end

function ActivityIntegrationLotteryRaidShopSubView:SetParentBgVisible(visible)
  local parent = self.parentView or self.container
  local bgTex = parent and (parent.u_bgTex or parent.bgTexture)
  if bgTex and bgTex.gameObject then
    bgTex.gameObject:SetActive(visible)
  end
end

function ActivityIntegrationLotteryRaidShopSubView:RefreshModel()
  self:InitScene()
  if not self.rolePos then
    self:DestroyRoleModel()
    return
  end
  local myself = Game.Myself and Game.Myself.data
  local userdata = myself and myself.userdata
  if not userdata then
    self:DestroyRoleModel()
    return
  end
  local sex = userdata:Get(UDEnum.SEX)
  local modelItems, modelScale = self:GetActivityModelItems(sex)
  if not modelItems or #modelItems == 0 then
    self:DestroyRoleModel()
    return
  end
  local parts = Asset_RoleUtility.CreateUserRoleParts(userdata)
  if not parts then
    self:DestroyRoleModel()
    return
  end
  local partIndex = Asset_Role.PartIndex
  local prof = userdata:Get(UDEnum.PROFESSION)
  local hasMount = false
  parts[partIndex.Mount] = 0
  parts[Asset_Role.PartIndexEx.LoadFirst] = true
  parts[Asset_Role.PartIndexEx.SkinQuality] = Asset_RolePart.SkinQuality.Bone4
  parts[Asset_Role.PartIndexEx.Download] = true
  for i = 1, #modelItems do
    local itemid = modelItems[i]
    if self:IsValidModelItem(itemid) then
      local itemPartIndex = ItemUtil.getItemRolePartIndex(itemid)
      Asset_RoleUtility.SetFashionPreviewParts(itemid, prof, sex, nil, parts, userdata)
      if itemPartIndex == partIndex.Mount then
        hasMount = true
        MountFashionProxy.Instance:SetMountSubParts(parts, itemid)
        MountFashionProxy.Instance:SetMountPartColors(parts, itemid)
      end
    else
      redlog("ActivityIntegrationLotteryRaidShopSubView invalid ModelItems itemid:", itemid, self:GetInvalidModelItemReason(itemid))
    end
  end
  local suffixMap = Asset_RoleUtility.GetSuffixReplaceMap(prof, parts[partIndex.Body], sex)
  local onCreated = function(assetRole)
    if not assetRole then
      return
    end
    local params = Asset_Role.GetPlayActionParams(Asset_Role.ActionName.Idle)
    params[4] = 0.2
    params[6] = true
    assetRole:PlayAction(params)
    assetRole:IgnoreTerrainLightColor(true)
    assetRole:RefreshLightMapColor()
  end
  if not self.model then
    self.model = Asset_Role_UI.Create(parts)
    self.model:SetParent(self.rolePos.transform, false)
    self.model:SetLayer(Game.ELayer.Outline)
    self.model:SetShadowEnable(false)
    self.model:ActiveMulColor(LuaColor.New(1, 1, 1, 1))
    self.model:RegisterWeakObserver(self)
    self.model:SetEpNodesDisplay(true)
  else
    self.model:Redress(parts, true)
  end
  self.model:SetSuffixReplaceMap(suffixMap)
  self.model:SetScale(modelScale or 0.8)
  self.model:SetForceShowMount(hasMount)
  self.model:SetMountDisplay(hasMount)
  self.model:SetMountEnable(hasMount)
  self:SetActivityModelTransform(self.model)
  if self.model:_IsLoading() then
    self.model:SetExOnCreatedCallback(onCreated)
  else
    onCreated(self.model)
  end
  self.hasMount = hasMount
  Asset_Role.DestroyPartArray(parts)
end

function ActivityIntegrationLotteryRaidShopSubView:RotateModel(go, delta)
  if self.model then
    local deltaAngle = -delta.x * 360 / 400
    self.model:RotateDelta(deltaAngle)
  end
end

function ActivityIntegrationLotteryRaidShopSubView:ObserverDestroyed(obj)
  if obj == self.model then
    self.model:UnregisterWeakObserver(self)
    self.model = nil
  end
end

function ActivityIntegrationLotteryRaidShopSubView:OnShow()
  self:SetParentBgVisible(false)
  self:SwitchCameraToModel()
end

function ActivityIntegrationLotteryRaidShopSubView:OnHide()
  self:ResetCameraToDefault()
  self:SetParentBgVisible(true)
end

function ActivityIntegrationLotteryRaidShopSubView:OnEnter(id)
  if self.rightBgTex then
    PictureManager.Instance:SetUI(rightBgTexName, self.rightBgTex)
  end
  id = id or self.activityID
  if not id and not self.hideRaidEntry then
    self:SetParentBgVisible(true)
    ActivityIntegrationLotteryRaidShopSubView.super.OnEnter(self)
    return
  end
  self.activityID = id
  self.staticData = id and Table_ActivityNew[id]
  if id and not self.staticData then
    redlog("Table_ActivityNew missing config", id)
    self:SetParentBgVisible(true)
    return
  end
  self:InitShopConfig()
  self.shopInfoInited = false
  if self.shopType and self.shopId then
    ShopProxy.Instance:CallQueryShopConfig(self.shopType, self.shopId)
    HappyShopProxy.Instance:InitShop(nil, self.shopId, self.shopType)
  else
    redlog("ActivityIntegrationLotteryRaidShopSubView missing shop config", id, self.shopType, self.shopId)
  end
  self:RefreshPage(id)
  self:SetParentBgVisible(false)
  self:SwitchCameraToModel()
  ActivityIntegrationLotteryRaidShopSubView.super.OnEnter(self)
end

function ActivityIntegrationLotteryRaidShopSubView:OnExit()
  TimeTickManager.Me():ClearTick(self)
  self:ResetCameraToDefault()
  self:SetParentBgVisible(true)
  self:DestroyRoleModel()
  self:DestroyScene()
  if self.rightBgTex then
    PictureManager.Instance:UnLoadUI(rightBgTexName, self.rightBgTex)
  end
  ActivityIntegrationLotteryRaidShopSubView.super.OnExit(self)
end

function ActivityIntegrationLotteryRaidShopSubView:OnDestroy()
  self:ResetCameraToDefault()
  self:SetParentBgVisible(true)
  self:DestroyRoleModel()
  self:DestroyScene()
  if self.vecCameraPosRecord then
    self.vecCameraPosRecord:Destroy()
    self.vecCameraPosRecord = nil
  end
  if self.quaCameraRotRecord then
    self.quaCameraRotRecord:Destroy()
    self.quaCameraRotRecord = nil
  end
  ActivityIntegrationLotteryRaidShopSubView.super.OnDestroy(self)
end
