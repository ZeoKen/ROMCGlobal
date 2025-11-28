autoImport("SmilingLadyShopItemCell")
autoImport("SmilingLadyShopBuyItemCell")
SmilingLadyShop = class("SmilingLadyShop", ContainerView)
SmilingLadyShop.ViewType = UIViewType.NormalLayer
local tabIconNames = {"116", "121"}
local tabNames = {
  [1] = ZhString.SmilingLadyShopTabNameHead,
  [2] = ZhString.SmilingLadyShopTabNameWeapon
}
local ItemBoardRects = {
  [1] = {
    55,
    -89,
    530,
    518
  },
  [2] = {
    55,
    -41,
    530,
    608
  }
}

function SmilingLadyShop:Init()
  self.tipData = {
    funcConfig = {}
  }
  self:FindObjs()
  self:AddViewEvts()
  self:UpdateView()
end

function SmilingLadyShop:LoadCellPfb(cName)
  local cellpfb = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell(cName))
  if cellpfb == nil then
    error("can not find cellpfb" .. cName)
  end
  cellpfb.transform:SetParent(self.gameObject.transform, false)
  return cellpfb
end

function SmilingLadyShop:FindObjs()
  local leftUpGO = self:FindGO("LeftUp")
  self.dialogGO = self:FindGO("Dialog", leftUpGO)
  self.dialogLab = self:FindComponent("DialogLab", UILabel, self.dialogGO)
  self.moneyIcons = {}
  self.moneyLabs = {}
  local goldIcon = self:FindComponent("GoldIcon", UISprite, leftUpGO)
  self.moneyIcons[1] = goldIcon
  self.moneyLabs[1] = self:FindComponent("GoldLab", UILabel, goldIcon.gameObject)
  local silverIcon = self:FindComponent("SilverIcon", UISprite, leftUpGO)
  self.moneyIcons[2] = silverIcon
  self.moneyLabs[2] = self:FindComponent("SilverLab", UILabel, silverIcon.gameObject)
  local bgRightGO = self:FindGO("BgRight")
  self.tipStick = self:FindComponent("TipStick", UIWidget, bgRightGO)
  self.dropContainerGO = self:FindGO("DropContainer", bgRightGO)
  local tabsGO = self:FindGO("Tabs", bgRightGO)
  self.tabTable = tabsGO:GetComponent(UITable)
  self.tabs = {}
  self.tabIcons = {}
  for i = 1, 2 do
    local tab = self:FindComponent("Tab" .. i, UIToggle, tabsGO)
    self.tabs[i] = tab
    local tabIcon = self:FindComponent("Icon", UISprite, tab.gameObject)
    self.tabIcons[i] = tabIcon
    IconManager:SetUIIcon(tabIconNames[i], tabIcon)
    local checkIcon = self:FindComponent("CheckIcon", UISprite, tab.gameObject)
    IconManager:SetUIIcon(tabIconNames[i], checkIcon)
    self:AddClickEvent(tab.gameObject, function()
      self:OnTabClicked(i)
    end)
    local longPress = tab:GetComponent(UILongPress)
    
    function longPress.pressEvent(obj, state)
      self:PassEvent(TipLongPressEvent.SmilingLadyShop, {state, i})
    end
  end
  self:AddEventListener(TipLongPressEvent.SmilingLadyShop, self.HandleLongPress, self)
  local rightBordGO = self:FindGO("RightBord")
  self:AddClickEvent(self:FindGO("CloseButton", rightBordGO), function()
    self:CloseSelf()
  end)
  self:AddOrRemoveGuideId("CloseButton", 15)
  self.itemBoardGO = self:FindGO("ItemBord", rightBordGO)
  self.itemBoard = self.itemBoardGO:GetComponent(UIWidget)
  self.itemScrollPanel = self:FindComponent("ItemScrollView", UIPanel, self.itemBoard.gameObject)
  self.shadowTop = self:FindComponent("ShadowTop", UISprite, self.itemBoard.gameObject)
  self.shadowBottom = self:FindComponent("ShadowBottom", UISprite, self.itemBoard.gameObject)
  self.noneTipGO = self:FindGO("NoneTip", rightBordGO)
  self.title = self:FindComponent("Title", UILabel, rightBordGO)
  self.itemWrapperGO = self:FindGO("shop_itemContainer", rightBordGO)
  local wrapConfig = {
    wrapObj = self.itemWrapperGO,
    pfbNum = 6,
    cellName = "SmilingLady/SmilingLadyShopItemCell",
    control = SmilingLadyShopItemCell,
    dir = 1,
    disableDragIfFit = true
  }
  self.itemWrapper = WrapCellHelper.new(wrapConfig)
  self.itemWrapper:AddEventListener(MouseEvent.MouseClick, self.OnItemCellClicked, self)
  self.itemWrapper:AddEventListener(HappyShopEvent.SelectIconSprite, self.OnItemCellClicked, self)
  self.itemWrapper:AddEventListener(HappyShopEvent.ExchangeBtnClick, self.OnExchangeClicked, self)
  local rightTopGO = self:FindGO("RightTop", rightBordGO)
  self.rightTopGO = rightTopGO
  self.expLab = self:FindComponent("ExpLab", UILabel, rightTopGO)
  self.levelLab = self:FindComponent("LevelLab", UILabel, rightTopGO)
  local gainWayBtnGO = self:FindGO("GainWayBtn", rightTopGO)
  self:AddClickEvent(gainWayBtnGO, function()
    self:OnGainWayClicked()
  end)
  self.expBar = self:FindComponent("ExpProgress", UIProgressBar, rightTopGO)
  self.expectedExpBar = self:FindComponent("ExpectedProgress", UIProgressBar, rightBordGO)
  local buyCellGO = self:LoadCellPfb("SmilingLady/SmilingLadyShopBuyItemCell")
  self.buyCell = SmilingLadyShopBuyItemCell.new(buyCellGO)
  self.buyCell:AddEventListener(ItemTipEvent.ClickItemUrl, self.OnClickItemUrl, self)
  self.buyCell:AddCloseWhenClickOtherPlaceCallBack(self)
  self.buyCell.closecomp:AddTarget(self.itemWrapperGO.transform)
  self.buyCell.gameObject:SetActive(false)
  if self.buyCell.countPlusBg then
    self:AddOrRemoveGuideId(self.buyCell.countPlusBg.gameObject, 16)
  end
  if self.buyCell.confirmButton then
    self:AddOrRemoveGuideId(self.buyCell.confirmButton.gameObject, 17)
  end
end

function SmilingLadyShop:AddViewEvts()
  self:AddListenEvt(MyselfEvent.MyDataChange, self.UpdateMoney)
  self:AddListenEvt(ItemEvent.ItemUpdate, self.UpdateMoney)
  self:AddListenEvt(ServiceEvent.GuildCmdQueryPackGuildCmd, self.UpdateMoney)
  self:AddListenEvt(ServiceEvent.GuildCmdPackUpdateGuildCmd, self.UpdateMoney)
  self:AddListenEvt(ServiceEvent.SessionShopExchangeShopItemCmd, self.HideGoodsTip)
  self:AddListenEvt(ServiceEvent.SessionShopFreyExchangeShopCmd, self.HideGoodsTip)
  self:AddListenEvt(ServiceEvent.SessionShopBuyShopItem, self.UpdateShopItems)
  self:AddListenEvt(ServiceEvent.SessionShopQueryShopConfigCmd, self.RecvQueryShopConfig)
  self:AddListenEvt(ServiceEvent.SessionShopShopDataUpdateCmd, self.RecvShopDataUpdate)
  self:AddListenEvt(ServiceEvent.SessionShopServerLimitSellCountCmd, self.UpdateShopItems)
  self:AddListenEvt(ServiceEvent.SessionShopQueryShopSoldCountCmd, self.HandleShopSoldCountCmd)
  self:AddListenEvt(ServiceEvent.SessionShopUpdateShopConfigCmd, self.RecvUpdateShopConfig)
  self:AddListenEvt(ServiceEvent.SceneManualManualUpdate, self.OnManualUpdated)
  self:AddListenEvt(LoadSceneEvent.FinishLoad, self.CloseSelf)
  self:AddListenEvt(XDEUIEvent.CloseHappyShopView, self.OverseaAndroidBack)
end

function SmilingLadyShop:RecvUpdateShopConfig()
  self:UpdateShopItems(true)
  if self.buyCell then
    self.buyCell.gameObject:SetActive(false)
  end
end

function SmilingLadyShop:HandleShopSoldCountCmd(note)
  local cells = self.itemWrapper:GetCellCtls()
  for _, cell in ipairs(cells) do
    cell:RefreshBuyCondition()
  end
  if self.buyCell and self.buyCell.gameObject.activeSelf then
    self.buyCell:UpdateSoldCountInfo()
  end
end

function SmilingLadyShop:OnManualUpdated()
  self:UpdateView()
end

function SmilingLadyShop:RecvQueryShopConfig()
  self:UpdateView(true)
end

function SmilingLadyShop:RecvShopDataUpdate(note)
  local data = note.body
  if data then
    local proxy = HappyShopProxy.Instance
    if data.type == proxy:GetShopType() and data.shopid == proxy:GetShopId() then
      proxy:CallQueryShopConfig()
    end
  end
end

function SmilingLadyShop:HideGoodsTip()
  TipManager.Instance:HideExchangeGoodsTip()
end

function SmilingLadyShop:OverseaAndroidBack()
  if self.buyCell and self.buyCell.gameObject.activeSelf then
    self.buyCell.gameObject:SetActive(false)
  else
    self:CloseSelf()
  end
end

function SmilingLadyShop:UpdateView(force)
  self:UpdateTabVisiblity(force)
  self:UpdatePrestigeInfo()
  self:UpdateMoney()
  self:UpdateDialog()
end

function SmilingLadyShop:UpdateTabVisiblity(force)
  local proxy = HappyShopProxy.Instance
  local datas, firstVisibleTabIndex
  for i, tab in ipairs(self.tabs) do
    if proxy:GetTab() then
      datas = proxy:GetTabItem(i)
    else
      datas = proxy:GetShopItems()
    end
    local isVisible = datas and 0 < #datas or false
    tab.gameObject:SetActive(isVisible)
    if isVisible then
      if not firstVisibleTabIndex then
        firstVisibleTabIndex = i
      end
    elseif self.selectedTab == i then
      self.selectedTab = nil
    end
  end
  self.tabTable:Reposition()
  self:SwitchToTab(self.selectedTab or firstVisibleTabIndex or 1, force)
end

function SmilingLadyShop:CameraFocusToNpc()
  local focusOffset = LuaVector3.Zero()
  local npcdata = HappyShopProxy.Instance:GetNPC()
  if npcdata then
    local viewPort = CameraConfig.HappyShop_ViewPort
    local rotation = CameraConfig.HappyShop_Rotation
    local uiIns = UIManagerProxy.Instance
    if uiIns:GetUIRootSize()[2] > 720 then
      viewPort = viewPort + CameraConfig.HappyShop_Ipad_ViewPortOffset
    elseif uiIns.mobileScreenAdaptionMap then
      viewPort = viewPort + CameraConfig.HappyShop_WithMobileScreenAdaption_ViewPortOffset
    end
    if npcdata.data and npcdata.data.staticData and npcdata.data.staticData.CameraShopOffset then
      LuaVector3.Better_Set(focusOffset, 0, npcdata.data.staticData.CameraShopOffset, 0)
    end
    self:CameraFaceTo(npcdata.assetRole.completeTransform, viewPort, rotation, nil, nil, nil, focusOffset)
  else
    self:CameraFocusToMe()
  end
end

function SmilingLadyShop:OnEnter()
  SmilingLadyShop.super.OnEnter(self)
  self:CameraFocusToNpc()
  self.selectedCell = nil
end

function SmilingLadyShop:OnExit()
  self:CameraReset()
  HappyShopProxy.Instance:SetSelectId(nil)
  HappyShopProxy.Instance:RemoveLeanTween()
  self:CloseGainWayTip()
  self.buyCell:Exit()
  TipsView.Me():HideCurrent()
  SmilingLadyShop.super.OnExit(self)
end

function SmilingLadyShop:OnGainWayClicked()
  self:ShowGainWayTip()
end

function SmilingLadyShop:ShowGainWayTip()
  local prestigeData = self:GetPrestigeData()
  if not prestigeData then
    return
  end
  self.buyCell.gameObject:SetActive(false)
  TipsView.Me():HideCurrent()
  self:CloseGainWayTip()
  self.gainwayCtl = GainWayTip.new(self.dropContainerGO)
  self.gainwayCtl:SetData(prestigeData.staticData.ItemID)
end

function SmilingLadyShop:CloseGainWayTip()
  if self.gainwayCtl and not self:ObjIsNil(self.gainwayCtl.gameObject) then
    self.gainwayCtl:OnExit()
  end
  self.gainwayCtl = nil
end

function SmilingLadyShop:OnTabClicked(index)
  index = index or 1
  self:SwitchToTab(index)
end

function SmilingLadyShop:SwitchToTab(tabIndex, force)
  if not (self.selectedTab ~= tabIndex or force) or tabIndex <= 0 then
    return
  end
  self.selectedTab = tabIndex
  local tab = self.tabs[tabIndex]
  if not tab.value then
    tab.value = true
  end
  self:UpdateShopItems(true)
end

function SmilingLadyShop:UpdateShopItems(reset)
  local proxy = HappyShopProxy.Instance
  local datas
  if proxy:GetTab() then
    datas = proxy:GetTabItem(self.selectedTab or 1)
  else
    datas = proxy:GetShopItems()
  end
  if datas then
    self.itemWrapper:UpdateInfo(datas)
  end
  if self.noneTipGO then
    self.noneTipGO:SetActive(datas and #datas == 0 or false)
  end
  if reset == true then
    self.itemWrapper:ResetPosition()
  end
  self.buyCell.gameObject:SetActive(false)
  self.selectedCell = nil
end

function SmilingLadyShop:UpdateBuyItemInfo(data)
  if data then
    local itemType = data.itemtype
    if itemType and itemType ~= 2 then
      self.buyCell:SetData(data)
      TipsView.Me():HideCurrent()
    else
      self.buyCell.gameObject:SetActive(false)
    end
  end
end

function SmilingLadyShop:OnItemCellClicked(cell)
  if self.selectedCell ~= cell then
    if self.selectedCell then
      self.selectedCell:SetChoose(false)
    end
    self.selectedCell = cell
    cell:SetChoose(true)
  end
  local id = cell.data
  local data = HappyShopProxy.Instance:GetShopItemDataByTypeId(id)
  if data then
    if data:GetLock() then
      self.buyCell.gameObject:SetActive(false)
      self:OnItemIconClicked(cell)
      return
    end
    self:CloseGainWayTip()
    local happyShopProxy = HappyShopProxy.Instance
    local config = Table_NpcFunction[happyShopProxy:GetShopType()]
    if config ~= nil and config.Parama.Source == HappyShopProxy.SourceType.Guild and not GuildProxy.Instance:CanIDoAuthority(GuildAuthorityMap.Shop) then
      MsgManager.ShowMsgByID(3808)
      self.buyCell.gameObject:SetActive(false)
      return
    end
    happyShopProxy:SetSelectId(id)
    self:UpdateBuyItemInfo(data)
  end
end

function SmilingLadyShop:ShowHappyItemTip(data)
  if data.goodsID then
    self:CloseGainWayTip()
    self.tipData.itemdata = data:GetItemData()
    self.tipData.context = nil
    if GemProxy.CheckIsGemStaticData(self.tipData.itemdata.staticData) then
      GemCell.ShowGemTip(nil, self.tipData.itemdata, self.tipStick)
    else
      self.tipData.ignoreBounds = {
        self.itemWrapperGO
      }
      if data:GetLock() then
        self.tipData.context = {
          lockType = data.lockType,
          lockArg = data.lockArg,
          lockDesc = data.GetComplexLockDesc and data:GetComplexLockDesc() or data:GetMenuDes()
        }
      else
        self.tipData.context = nil
      end
      self:ShowItemTip(self.tipData, self.tipStick)
    end
  else
    errorLog("HappyShop ShowItemTip data.goodsID == nil")
  end
end

function SmilingLadyShop:OnItemIconClicked(cell)
  local data = HappyShopProxy.Instance:GetShopItemDataByTypeId(cell.data)
  self:ShowHappyItemTip(data)
  self.buyCell.gameObject:SetActive(false)
end

function SmilingLadyShop:OnExchangeClicked(cell)
end

local itemClickUrlTipData = {}

function SmilingLadyShop:OnClickItemUrl(id)
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

function SmilingLadyShop:ShowClickItemUrlTip(data)
  local tip = self:ShowItemTip(data, self.buyCell.bg, NGUIUtil.AnchorSide.Right, clickItemUrlTipOffset)
  if tip then
    tip:AddIgnoreBounds(self.buyCell.gameObject)
    self.buyCell.closeWhenClickOtherPlace:AddTarget(tip.gameObject.transform)
    tip:AddEventListener(ItemTipEvent.ShowFashionPreview, self.OnTipFashionPreviewShow, self)
    tip:AddEventListener(FashionPreviewEvent.Close, self.OnTipFashionPreviewClose, self)
  end
end

function SmilingLadyShop:OnTipFashionPreviewShow(preview)
  self.buyCell.closeWhenClickOtherPlace:AddTarget(preview.gameObject.transform)
end

function SmilingLadyShop:OnTipFashionPreviewClose()
  self.buyCell.closeWhenClickOtherPlace:ReCalculateBound()
end

function SmilingLadyShop:UpdateMoney()
  local proxy = HappyShopProxy.Instance
  local moneyTypes = proxy:GetMoneyType()
  local config = Table_NpcFunction[proxy:GetShopType()]
  local shopSource = config and config.Parama and config.Parama.Source
  for i, icon in ipairs(self.moneyIcons) do
    local moneyId = moneyTypes and moneyTypes[i]
    if moneyId then
      local itemData = Table_Item[moneyId]
      if itemData then
        icon.gameObject:SetActive(true)
        IconManager:SetItemIcon(itemData.Icon, icon)
        local moneyNum = StringUtil.NumThousandFormat(HappyShopProxy.Instance:GetItemNum(moneyId, shopSource))
        self.moneyLabs[i].text = moneyNum or 0
      else
        icon.gameObject:SetActive(false)
      end
    else
      icon.gameObject:SetActive(false)
    end
  end
end

function SmilingLadyShop:UpdateDialog()
  self.dialogLab.text = HappyShopProxy.Instance.desc or ""
end

function SmilingLadyShop:GetPrestigeData()
  local npcId = HappyShopProxy.Instance:GetNPCStaticid()
  return PrestigeProxy.Instance:GetPrestigeDataByNPC(npcId)
end

function SmilingLadyShop:UpdatePrestigeInfo()
  local prestigeData = self:GetPrestigeData()
  self.expectedExpBar.value = 0
  if prestigeData then
    self.rightTopGO:SetActive(true)
    self:ResizeItemBoard(1)
    self.title.text = prestigeData.staticData.Name
    self.levelLab.text = prestigeData.level
    if prestigeData:IsGraduate() then
      self.expLab.text = "MAX"
      self.expBar.value = 1
    else
      local nLeveldata = prestigeData:GetNextLevelExpData()
      self.expLab.text = string.format("%d/%d", prestigeData.exp, nLeveldata.NeedPre)
      self.expBar.value = prestigeData.exp / nLeveldata.NeedPre
    end
  else
    self.rightTopGO:SetActive(false)
    self:ResizeItemBoard(2)
    self.title.text = ""
    self.levelLab.text = ""
    self.expLab.text = ""
    self.expBar.value = 0
  end
end

function SmilingLadyShop:ResizeItemBoard(index)
  local config = ItemBoardRects[index]
  local x, y, z = LuaGameObject.GetLocalPositionGO(self.itemBoardGO)
  if x ~= config[1] or y ~= config[2] then
    LuaGameObject.SetLocalPositionGO(self.itemBoardGO, config[1], config[2], z)
  end
  if self.itemBoard.height ~= config[4] then
    self.itemBoard.height = config[4]
  end
  local baseClipRegion = self.itemScrollPanel.baseClipRegion
  local scrollHeight = config[4] - 8
  if baseClipRegion.w ~= scrollHeight then
    self.itemScrollPanel.baseClipRegion = LuaGeometry.GetTempVector4(baseClipRegion.x, baseClipRegion.y, baseClipRegion.z, scrollHeight)
  end
  self.shadowTop:UpdateAnchors()
  self.shadowBottom:UpdateAnchors()
end

function SmilingLadyShop:HandleLongPress(param)
  local isPressing, index = param[1], param[2]
  TabNameTip.OnLongPress(isPressing, tabNames[index], false, self.tabIcons[index])
end
