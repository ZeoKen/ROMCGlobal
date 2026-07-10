autoImport("NewRechargeVirtualRecommendTShopGoodsCell")
autoImport("BattlePassNewUpgradeCardCell")
autoImport("Asset_Role_UI")
BattlePassNewUpgradeView = class("BattlePassNewUpgradeView", BaseView)
BattlePassNewUpgradeView.ViewType = UIViewType.NormalLayer
local ADV_SHOW = 1
local SUPER_SHOW = 2
local ALL_SHOW = 3
local CARD_SHOWS = {ADV_SHOW, SUPER_SHOW}
local CARD_BG_TEXTURES = {
  [ADV_SHOW] = "calendar_bp_jinbg",
  [SUPER_SHOW] = "calendar_bp_dianbg"
}
local BgName2, BgName3 = "calendar_bp_bg02", "calendar_bp_bg03"
local scenePath = ResourcePathHelper.UIModel("BattlePassNewUpgradeScene")
local modelCameraFov = 20
local GetCameraPostProcessing = function(comp)
  return comp.renderPostProcessing
end
local SetCameraPostProcessing = function(comp, enable)
  comp.renderPostProcessing = enable
end
local ImportantRewardSortFunc = function(l, r)
  if l.sort ~= nil and r.sort ~= nil then
    if l.sort == r.sort then
      return l.index < r.index
    end
    return l.sort < r.sort
  end
  if l.sort ~= nil then
    return true
  end
  if r.sort ~= nil then
    return false
  end
  return l.index < r.index
end

function BattlePassNewUpgradeView:Init()
  BattlePassNewUpgradeView.super.Init(self)
  self.vecCameraPosRecord = LuaVector3()
  self.quaCameraRotRecord = LuaQuaternion()
  self.initRetryCount = 0
  self:InitView()
end

function BattlePassNewUpgradeView:InitView()
  if not self.gameObject then
    return
  end
  self:InitVirtualCells()
  self:AddListenEvt(ServiceEvent.SessionShopUpdateShopConfigCmd, self.HandleShopUpdate)
  self:AddListenEvt(ServiceEvent.SessionShopShopDataUpdateCmd, self.HandleShopUpdate)
  self:AddListenEvt(ServiceEvent.BattlePassSyncInfoBattlePassCmd, self.HandleBattlePassUpdate)
  self:AddListenEvt(ServiceEvent.BattlePassAdvanceBattlePassCmd, self.HandleBattlePassUpdate)
  self:InitUpgradeCardCells()
  self.bg = self:FindComponent("Bg", UITexture)
  self.bg2 = self:FindComponent("Bg2", UITexture)
  self.bg3 = self:FindComponent("Bg3", UITexture)
  self.allBuyPart = self:FindGO("AllBuyPart")
  self.allBuyBtn = self:FindGO("AllBuyBtn")
  self.allBuyLabel = self:FindComponent("AllBuyLabel", UILabel)
  self.allBuyPriceLabel = self:FindComponent("Price", UILabel)
  self.allBuyPriceIcon = self:FindComponent("PriceIcon", UISprite, self.allBuyBtn)
  self:AddClickEvent(self.allBuyBtn, function()
    self:BuyAll()
  end)
  self.helpBtn = self:FindGO("HelpBtn")
  local showHelpBtn = BranchMgr.IsJapan()
  self:SetGoActive(self.helpBtn, showHelpBtn)
  if showHelpBtn and self.helpBtn then
    self:RegistShowGeneralHelpByHelpID(8000002, self.helpBtn)
  end
  self:InitModel()
end

function BattlePassNewUpgradeView:InitVirtualCells()
  self.virtualCells = {}
  for i = ADV_SHOW, ALL_SHOW do
    local cell = NewRechargeVirtualRecommendTShopGoodsCell.new()
    cell:Init()
    cell:AddEventListener(NewRechargeEvent.GoodsCell_ShowShopItemPurchaseDetail, self.ShopItemPurchase, self)
    self.virtualCells[i] = cell
  end
end

function BattlePassNewUpgradeView:OnEnter()
  BattlePassNewUpgradeView.super.OnEnter(self)
  self:SetBgTextures()
  self:InitScene()
  self:SwitchCameraToModel()
  self:InitShopData()
  self:UpdateView()
  self:RefreshModel()
end

function BattlePassNewUpgradeView:SetBgTextures()
  self:SetMainBgVisible(false)
end

function BattlePassNewUpgradeView:SetMainBgVisible(visible)
  if self.bg and self.bg.gameObject then
    self.bg.gameObject:SetActive(visible == true)
  end
end

function BattlePassNewUpgradeView:InitModel()
  self.upgradeModelConfig = self:GetUpgradeModelConfig()
  self.modelTexture = self:FindGO("ModelTexture")
  if self.modelTexture then
    self:AddDragEvent(self.modelTexture, function(go, delta)
      self:RotateModel(go, delta)
    end)
  end
end

function BattlePassNewUpgradeView:InitShopData()
  local allItems = BattlePassProxy.Instance.UpgradeDepositItem
  if not allItems then
    return
  end
  for i = 1, #allItems do
    local item = allItems[i]
    if item.ShopType and item.ShopId then
      ShopProxy.Instance:CallQueryShopConfig(item.ShopType, item.ShopId)
      HappyShopProxy.Instance:InitShop(nil, item.ShopId, item.ShopType)
    end
  end
end

function BattlePassNewUpgradeView:InitUpgradeCardCells()
  self.cardCells = {}
  for _, show in pairs(CARD_SHOWS) do
    local go = self:FindGO("Card" .. show)
    if go then
      local cell = BattlePassNewUpgradeCardCell.new(go)
      cell:AddEventListener(MouseEvent.MouseClick, self.HandleClickRewardItem, self)
      cell:AddEventListener(BattlePassNewUpgradeCardEvent.ClickBuy, self.HandleClickCardBuy, self)
      self.cardCells[show] = cell
    end
  end
end

function BattlePassNewUpgradeView:UpdateView()
  if not self.gameObject then
    return
  end
  self.upgradeInfos = {}
  for show = ADV_SHOW, ALL_SHOW do
    self.upgradeInfos[show] = BattlePassProxy.Instance:GetUpgradeDepositByShow(show)
    self:SetVirtualCellData(show, self.upgradeInfos[show])
  end
  self:RefreshCard(self.cardCells and self.cardCells[ADV_SHOW], self.upgradeInfos[ADV_SHOW], "ProRewardItems", "ReplaceProRewardItems")
  self:RefreshCard(self.cardCells and self.cardCells[SUPER_SHOW], self.upgradeInfos[SUPER_SHOW], "SuperRewardItems", "ReplaceSuperRewardItems")
  self:RefreshAllBuyButton()
end

function BattlePassNewUpgradeView:RefreshCard(cell, info, rewardField, replaceField)
  if not cell then
    return
  end
  if not info then
    cell:SetData(nil)
    return
  end
  local canbuy, bought, name, price, priceItemId = self:GenerateStatusInfo(info)
  local enable = self:IsUpgradeInfoCanBuy(info)
  cell:SetData({
    info = info,
    show = info.Show,
    title = name,
    price = price,
    priceItemId = priceItemId,
    bgTexName = CARD_BG_TEXTURES[info.Show],
    rebate = info.Rebate,
    descDatas = self:GenerateDescTable(info),
    rewardDatas = self:GetImportantRewardDatas(rewardField, replaceField),
    enable = enable,
    tipText = ZhString.BattlePassUpgradeView_dualtext3,
    tipActive = info.Show == SUPER_SHOW and not canbuy and not bought
  })
end

function BattlePassNewUpgradeView:RefreshAllBuyButton()
  local allInfo = self.upgradeInfos and self.upgradeInfos[ALL_SHOW]
  local showAllBuyPart = allInfo ~= nil and not BranchMgr.IsJapan()
  self:SetGoActive(self.allBuyPart, showAllBuyPart)
  self.allBuyEnable = false
  self.allBuyInfo = nil
  if not showAllBuyPart or not self.allBuyBtn then
    return
  end
  local info, price, enable, priceItemId, labelText = self:GetAllBuyButtonInfo()
  self.allBuyEnable = enable == true
  self.allBuyInfo = self.allBuyEnable and info or nil
  self:SetLabel(self.allBuyLabel, labelText or "")
  self:SetLabel(self.allBuyPriceLabel, price or "")
  self:SetAllBuyPriceIcon(priceItemId)
  if self.allBuyBtn then
    self:SetButtonEnable(self.allBuyBtn, self.allBuyEnable, ColorUtil.ButtonLabelOrange)
  end
end

function BattlePassNewUpgradeView:GetAllBuyButtonInfo()
  local advInfo = self.upgradeInfos and self.upgradeInfos[ADV_SHOW]
  local superInfo = self.upgradeInfos and self.upgradeInfos[SUPER_SHOW]
  local allInfo = self.upgradeInfos and self.upgradeInfos[ALL_SHOW]
  local advBought = BattlePassProxy.Instance:IsUpgradeDepositBought(advInfo)
  local superBought = BattlePassProxy.Instance:IsUpgradeDepositBought(superInfo)
  local superCanBuy = self:IsUpgradeInfoCanBuy(superInfo)
  if advBought and superBought then
    return nil, "", false, nil, ZhString.BattlePassUpgradeView_allBought
  elseif not advBought then
    local price, priceItemId = self:GenerateAllBuyPrice(advInfo, superInfo)
    local allCanBuy = self:IsUpgradeInfoCanBuy(allInfo)
    return allInfo, price, allCanBuy, priceItemId, ZhString.BattlePassUpgradeView_buyAdvAndSuper
  else
    local _, _, _, price, priceItemId = self:GenerateStatusInfo(superInfo)
    return superInfo, price, superCanBuy, priceItemId, ZhString.BattlePassUpgradeView_buySuper
  end
end

function BattlePassNewUpgradeView:IsUpgradeInfoCanBuy(info)
  local canbuy, bought = self:GenerateStatusInfo(info)
  local japanCanBuy = self:CanBuyInJapanBranch(info)
  return canbuy and not bought and japanCanBuy
end

function BattlePassNewUpgradeView:GenerateStatusInfo(info)
  if not info then
    return false, false
  end
  local bought = BattlePassProxy.Instance:IsUpgradeDepositBought(info)
  local canbuy = BattlePassProxy.Instance:IsUpgradeDepositReachCondition(info) and BattlePassProxy.Instance:IsUpgradeDepositInSale(info)
  if bought then
    canbuy = true
  end
  local name = info.Name
  local price, _, _, priceItemId = self:GetPriceInfo(info)
  price = price or ZhString.HappyShop_Buy
  if bought then
    price = ZhString.BattlePassUpgradeView_bought
    priceItemId = nil
  end
  return canbuy, bought, name, price, priceItemId
end

function BattlePassNewUpgradeView:GetPriceInfo(info)
  if not info then
    return
  end
  if info.DepositeId then
    local deposit = Table_Deposit and Table_Deposit[info.DepositeId]
    if deposit then
      local price = not deposit.priceStr and deposit.CurrencyType and deposit.Rmb and deposit.CurrencyType .. deposit.Rmb
      return price, deposit.CurrencyType, deposit.Rmb
    end
  elseif self:IsShopItem(info) then
    local shopItemData = ShopProxy.Instance:GetShopItemDataByTypeId(info.ShopType, info.ShopId, info.ShopItemId)
    if shopItemData then
      local priceItemId = shopItemData.ItemID
      local priceNum = shopItemData.ItemCount
      if priceItemId and priceNum then
        return tostring(priceNum), priceItemId, priceNum, priceItemId
      end
    end
  end
end

function BattlePassNewUpgradeView:GenerateAllBuyPrice(advInfo, superInfo)
  local advPrice, advCurrency, advAmount, advPriceItemId = self:GetPriceInfo(advInfo)
  local superPrice, superCurrency, superAmount, superPriceItemId = self:GetPriceInfo(superInfo)
  if advCurrency and advCurrency == superCurrency and advAmount and superAmount then
    local totalAmount = advAmount + superAmount
    if advPriceItemId and advPriceItemId == superPriceItemId then
      return tostring(totalAmount), advPriceItemId
    end
    return advCurrency .. totalAmount
  end
  if advPrice and superPrice then
    local advPriceNum = tonumber(advPrice)
    local superPriceNum = tonumber(superPrice)
    if advPriceNum and superPriceNum then
      return tostring(advPriceNum + superPriceNum)
    end
    return advPrice .. "+" .. superPrice
  end
  if advPrice then
    return advPrice, advPriceItemId
  end
  if superPrice then
    return superPrice, superPriceItemId
  end
  return ZhString.HappyShop_Buy
end

function BattlePassNewUpgradeView:SetVirtualCellData(show, info)
  local cell = self.virtualCells and self.virtualCells[show]
  if not cell then
    return
  end
  if not info then
    cell:VirtualClearSetData()
    return
  end
  if info.DepositeId then
    cell:VirtualSetData(NewRechargePrototypeGoodsCell.GoodsTypeEnum.Deposit, info.DepositeId)
  elseif self:IsShopItem(info) then
    NewRechargeProxy.Instance.ShopType = info.ShopType
    NewRechargeProxy.Instance.ShopID = info.ShopId
    cell:VirtualSetData(NewRechargePrototypeGoodsCell.GoodsTypeEnum.Shop, info.ShopItemId)
    cell.shopType = info.ShopType
    cell.shopId = info.ShopId
  end
  cell:SetPurchaseSuccessCB(function()
    self:UpdateView()
  end)
end

function BattlePassNewUpgradeView:GetImportantRewardDatas(rewardField, replaceField)
  local result = {}
  local importantConfigs = {}
  local maxLv = BattlePassProxy.Instance.maxBpLevel or 0
  for i = 1, maxLv do
    local config = BattlePassProxy.Instance:LevelConfig(i)
    if config and config.Important == 1 then
      TableUtility.ArrayPushBack(importantConfigs, {
        config = config,
        sort = config.ImportantSort,
        index = i
      })
    end
  end
  table.sort(importantConfigs, ImportantRewardSortFunc)
  for i = 1, #importantConfigs do
    local config = importantConfigs[i].config
    local rewards = config[replaceField] or config[rewardField]
    if rewards then
      for j = 1, #rewards do
        local reward = rewards[j]
        if reward and reward.itemid then
          local itemData = ItemData.new("BattlePassNewUpgradeReward", reward.itemid)
          itemData:SetItemNum(reward.num or 1)
          TableUtility.ArrayPushBack(result, itemData)
        end
      end
    end
  end
  return result
end

function BattlePassNewUpgradeView:GenerateDescTable(info)
  local upgradeDesc = BattlePassProxy.Instance.CurrentBPConfig and BattlePassProxy.Instance.CurrentBPConfig.UpgradeDesc
  if not (info and info.Desc and upgradeDesc) or not upgradeDesc[info.Desc] then
    return {}
  end
  local rawDesc = upgradeDesc[info.Desc]
  local descTab = {}
  for i = 1, 9 do
    if rawDesc[i] then
      local desc = {}
      desc[1] = info.Show
      desc[2] = rawDesc[i].Text
      for j = 1, 5 do
        if rawDesc[i * 10 + j] then
          desc[2 + j] = rawDesc[i * 10 + j].Text
        end
      end
      TableUtility.ArrayPushBack(descTab, desc)
    end
  end
  return descTab
end

function BattlePassNewUpgradeView:SetLabel(label, text)
  if label then
    label.text = text or ""
  end
end

function BattlePassNewUpgradeView:SetAllBuyPriceIcon(priceItemId)
  if not self.allBuyPriceIcon then
    return
  end
  local itemData = priceItemId and Table_Item and Table_Item[priceItemId]
  local icon = itemData and itemData.Icon
  self.allBuyPriceIcon.gameObject:SetActive(icon ~= nil)
  if icon then
    IconManager:SetItemIcon(icon, self.allBuyPriceIcon)
  end
end

function BattlePassNewUpgradeView:SetGoActive(go, active)
  if go then
    go:SetActive(active == true)
  end
end

function BattlePassNewUpgradeView:GetUpgradeModelConfig()
  local config = BattlePassProxy.Instance.CurrentBPConfig
  local upgradeModelItems = config and config.UpgradeModelItems
  if not upgradeModelItems then
    return
  end
  local serverTime = ServerTime.CurServerTime()
  if not serverTime then
    return
  end
  local date = os.date("*t", serverTime / 1000)
  return upgradeModelItems[date.year * 100 + date.month]
end

function BattlePassNewUpgradeView:GetUpgradeModelItems(sex)
  local modelConfig = self.upgradeModelConfig
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

function BattlePassNewUpgradeView:IsValidModelItem(itemid)
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

function BattlePassNewUpgradeView:GetInvalidModelItemReason(itemid)
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

function BattlePassNewUpgradeView:SetUpgradeModelTransform(model)
  local modelConfig = self.upgradeModelConfig
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

function BattlePassNewUpgradeView:InitScene()
  if self.sceneObj then
    return
  end
  self.sceneObj = Game.AssetManager_UI:CreateAsset(scenePath)
  if not self.sceneObj then
    LogUtility.Error("BattlePassNewUpgradeView cannot load BattlePassNewUpgradeScene")
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

function BattlePassNewUpgradeView:DestroyScene()
  if self.sceneObj then
    LuaGameObject.DestroyObject(self.sceneObj)
  end
  self.sceneObj = nil
  self.rolePos = nil
  self.cameraPos = nil
  self.roleBg = nil
end

function BattlePassNewUpgradeView:DestroyRoleModel()
  if self.model and self.model:Alive() then
    self.model:UnregisterWeakObserver(self)
    self.model:SetEpNodesDisplay(false)
    self.model:Destroy()
  end
  self.model = nil
  self.hasMount = nil
end

function BattlePassNewUpgradeView:DestroyCameraTick()
  if self.ltInitCamera then
    self.ltInitCamera:Destroy()
    self.ltInitCamera = nil
  end
end

function BattlePassNewUpgradeView:DisableCameraPostProcessing()
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

function BattlePassNewUpgradeView:RestoreCameraPostProcessing()
  if self.cameraPostProcessingRecord ~= nil and self.cameraUrpData then
    xpcall(SetCameraPostProcessing, debug.traceback, self.cameraUrpData, self.cameraPostProcessingRecord)
  end
  self.cameraPostProcessingRecord = nil
  self.cameraUrpData = nil
end

function BattlePassNewUpgradeView:SwitchCameraToModel()
  if self.isCameraOnModel or self.ltInitCamera or not self.cameraPos then
    return
  end
  if not self.cameraWorld or LuaGameObject.ObjectIsNull(self.cameraWorld) then
    self.cameraWorld = NGUITools.FindCameraForLayer(Game.ELayer.Default)
    if not self.cameraWorld then
      self.initRetryCount = (self.initRetryCount or 0) + 1
      if self.initRetryCount > 9 then
        LogUtility.Error("BattlePassNewUpgradeView cannot find default camera")
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
    LogUtility.Error("BattlePassNewUpgradeView cannot find CameraController")
  end
  LuaVector3.Better_Set(self.vecCameraPosRecord, LuaGameObject.GetPosition(self.tsfCameraWorld))
  LuaQuaternion.Better_Set(self.quaCameraRotRecord, LuaGameObject.GetRotation(self.tsfCameraWorld))
  self.tsfCameraWorld.position = LuaGeometry.GetTempVector3(LuaGameObject.GetPosition(self.cameraPos))
  self.tsfCameraWorld.rotation = LuaGeometry.GetTempQuaternion(LuaGameObject.GetRotation(self.cameraPos))
  self.cameraWorld.fieldOfView = modelCameraFov
  self.isCameraOnModel = true
end

function BattlePassNewUpgradeView:ResetCameraToDefault()
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

function BattlePassNewUpgradeView:ClearModelTexture()
  self:DestroyRoleModel()
end

function BattlePassNewUpgradeView:RefreshModel()
  self:InitScene()
  if not self.modelTexture or not self.rolePos then
    return
  end
  local myself = Game.Myself and Game.Myself.data
  local userdata = myself and myself.userdata
  if not userdata then
    self:ClearModelTexture()
    return
  end
  local sex = userdata:Get(UDEnum.SEX)
  local modelItems, modelScale = self:GetUpgradeModelItems(sex)
  if not modelItems or #modelItems == 0 then
    self:ClearModelTexture()
    return
  end
  local parts = Asset_RoleUtility.CreateUserRoleParts(userdata)
  if not parts then
    self:ClearModelTexture()
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
      redlog("BattlePassNewUpgradeView invalid UpgradeModelItems itemid:", itemid, self:GetInvalidModelItemReason(itemid))
    end
  end
  local suffixMap = Asset_RoleUtility.GetSuffixReplaceMap(prof, parts[partIndex.Body], sex)
  local onCreated = function(assetRole)
    if not assetRole then
      return
    end
    if hasMount then
      assetRole:SetInvisible(false)
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
  self:SetUpgradeModelTransform(self.model)
  if self.model:_IsLoading() then
    self.model:SetExOnCreatedCallback(onCreated)
    if hasMount then
      self.model:SetInvisible(true)
    end
  else
    onCreated(self.model)
  end
  self.hasMount = hasMount
  Asset_Role.DestroyPartArray(parts)
end

function BattlePassNewUpgradeView:RotateModel(go, delta)
  if self.model then
    local deltaAngle = -delta.x * 360 / 400
    self.model:RotateDelta(deltaAngle)
  end
end

function BattlePassNewUpgradeView:ObserverDestroyed(obj)
  if obj == self.model then
    self.model:UnregisterWeakObserver(self)
    self.model = nil
  end
end

function BattlePassNewUpgradeView:IsShopItem(info)
  return info and info.ShopType and info.ShopId and info.ShopItemId
end

function BattlePassNewUpgradeView:BuyAll()
  if not self.allBuyEnable or not self.allBuyInfo then
    return
  end
  self:BuyInfo(self.allBuyInfo.Show, self.allBuyInfo)
end

function BattlePassNewUpgradeView:BuyInfo(show, info)
  if not info then
    return
  end
  if self:IsShopItem(info) then
    NewRechargeProxy.Instance.ShopType = info.ShopType
    NewRechargeProxy.Instance.ShopID = info.ShopId
    HappyShopProxy.Instance:InitShop(nil, info.ShopId, info.ShopType)
  end
  local cell = self.virtualCells and self.virtualCells[show]
  if cell then
    cell:Pre_Purchase()
  end
end

function BattlePassNewUpgradeView:ShopItemPurchase(data)
  if not data then
    return
  end
  if data.m_funcRmbBuy then
    data.m_funcRmbBuy()
  elseif data.info and data.info.id then
    HappyShopProxy.Instance:BuyItem(data.info.id, 1)
  end
end

local tipData = {}
tipData.funcConfig = {}

function BattlePassNewUpgradeView:HandleClickRewardItem(cellctl)
  if cellctl and cellctl.data then
    tipData.itemdata = cellctl.data
    self:ShowItemTip(tipData, nil, NGUIUtil.AnchorSide.Up)
  end
end

function BattlePassNewUpgradeView:HandleClickCardBuy(cellctl)
  if cellctl and cellctl.data then
    self:BuyInfo(cellctl.data.show, cellctl.data.info)
  end
end

function BattlePassNewUpgradeView:HandleShopUpdate()
  self:UpdateView()
end

function BattlePassNewUpgradeView:HandleBattlePassUpdate()
  self:UpdateView()
  self:RefreshModel()
end

function BattlePassNewUpgradeView:CanBuyInJapanBranch(info)
  if not BranchMgr.IsJapan() or not info then
    return true
  end
  local left = ChargeComfirmPanel.left
  if left then
    local currency = 0
    if info.DepositeId then
      currency = Table_Deposit and Table_Deposit[info.DepositeId] and Table_Deposit[info.DepositeId].Rmb or 0
    elseif self:IsShopItem(info) then
      local shopItemData = ShopProxy.Instance:GetShopItemDataByTypeId(info.ShopType, info.ShopId, info.ShopItemId)
      currency = shopItemData and shopItemData.price or 0
    end
    if left < currency then
      return false
    end
  end
  return true
end

function BattlePassNewUpgradeView:OnExit()
  self:ResetCameraToDefault()
  self:ClearModelTexture()
  self:DestroyScene()
  if self.virtualCells then
    for _, cell in pairs(self.virtualCells) do
      if cell and cell.OnCellDestroy then
        cell:OnCellDestroy()
      end
    end
  end
  if self.cardCells then
    for _, cell in pairs(self.cardCells) do
      if cell and cell.OnCellDestroy then
        cell:OnCellDestroy()
      end
    end
  end
  BattlePassNewUpgradeView.super.OnExit(self)
end

function BattlePassNewUpgradeView:OnDestroy()
  self:ResetCameraToDefault()
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
  BattlePassNewUpgradeView.super.OnDestroy(self)
end
