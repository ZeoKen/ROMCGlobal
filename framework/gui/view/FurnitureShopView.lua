autoImport("FurnitureShopItemCell")
autoImport("FurnitureShopThemeCell")
autoImport("FurnitureIconCell")
FurnitureShopView = class("FurnitureShopView", BaseView)
FurnitureShopView.ViewType = UIViewType.NormalLayer
local texName_BG = "home_Portable-store_bg"
local texName_ShopUp = "home_Portable-store_decoration"
local texName_FurnitureBG = "home_Portable-store_frame"
local texName_FurnitureModel = "home_Portable-store_frame_bg"
FurnitureShopView.PageStatus = {
  Empty = 0,
  Pack = 1,
  Furniture = 2
}

function FurnitureShopView:Init()
  self.themeDatas = {}
  self.itemDatas = {}
  self.packContentDatas = {}
  self.tipData = {
    funcConfig = {}
  }
  self.tmpItemData = ItemData.new("TmpFurnitureItem", 100)
  self:FindObjs()
  self:AddEvts()
  self:AddViewEvts()
end

function FurnitureShopView:FindObjs()
  self.objUpBoard = self:FindGO("UpBoard")
  self.objShopBoard = self:FindGO("ShopBoard")
  self.objFurnitureInfo = self:FindGO("FurnitureInfo")
  self.texBG = self:FindComponent("texBG", UITexture)
  self.texShopUp = self:FindComponent("texShopUp", UITexture, self.objShopBoard)
  self.labRebuyDiscount = self:FindComponent("labRebuyDiscount", UILabel, self.objShopBoard)
  self.moneySprite = {
    self:FindGO("silversIcon", self.objUpBoard):GetComponent(UISprite),
    self:FindGO("goldIcon", self.objUpBoard):GetComponent(UISprite)
  }
  self.moneyLabel = {
    self:FindGO("silvers", self.objUpBoard):GetComponent(UILabel),
    self:FindGO("gold", self.objUpBoard):GetComponent(UILabel)
  }
  self.listThemes = UIGridListCtrl.new(self:FindComponent("gridThemes", UIGrid), FurnitureShopThemeCell, "FurnitureShopThemeCell")
  local l_objScrollItem = self:FindGO("ItemScrollView", self.objShopBoard)
  self.scrollItem = l_objScrollItem:GetComponent(UIScrollView)
  self.listItem = WrapListCtrl.new(self:FindGO("shop_itemContainer", l_objScrollItem), FurnitureShopItemCell, "FurnitureShopItemCell", WrapListCtrl_Dir.Vertical)
  self.objNoItem = self:FindGO("NoneTip_Item", self.objShopBoard)
  self.widgetTipStick = self:FindComponent("TipStick", UIWidget, self.objShopBoard)
  self.texFurniture = self:FindComponent("texFurniture", UITexture, self.objFurnitureInfo)
  self.texFurnitureBG = self:FindComponent("texFurnitureBG", UITexture, self.objFurnitureInfo)
  self.objFurnitureBuff = self:FindGO("FurnitureBuff", self.objFurnitureInfo)
  self.sprLabBuff = SpriteLabel.new(self:FindGO("labBuff", self.objFurnitureBuff), nil, nil, nil, true)
  self.objFurniturePack = self:FindGO("PackFurnitures")
  self.sprFurniturePackBG = self:FindComponent("sprPackBG", UISprite, self.objFurniturePack)
  self.maxFurniturePackBGHeight = self.sprFurniturePackBG.width
  self.scrollPackContents = self:FindComponent("ScrollPackFurnitures", UIScrollView, self.objFurniturePack)
  self.listPackContents = UIGridListCtrl.new(self:FindComponent("gridPackFurnitures", UIGrid, self.objFurniturePack), FurnitureIconCell, "FurnitureIconCell")
  self.texShopGuide = self:FindComponent("texShopGuide", UITexture, self.objFurniturePack)
  self.widgetPackTipStick = self:FindComponent("PackTipStick", UIWidget, self.objShopBoard)
  self.objBtnBuy = self:FindGO("btnBuy", self.objShopBoard)
  self.objBtnBuy:SetActive(false)
end

function FurnitureShopView:AddEvts()
  self:AddClickEvent(self.objBtnBuy, function()
    self:HandleClickItemExchange()
  end)
  self:AddClickEvent(self:FindGO("BtnClose", self.objUpBoard), function()
    self:CloseSelf()
  end)
  local BtnHelp = self:FindGO("BtnHelp", self.objUpBoard)
  self:TryOpenHelpViewById(PanelConfig.FurnitureShopView.id, nil, BtnHelp)
  self:AddDragEvent(self.texFurniture.gameObject, function(go, delta)
    if not self.furnitureModel then
      return
    end
    if type(self.furnitureModel) == "table" and self.furnitureModel.RotateDelta then
      self.furnitureModel:RotateDelta(-delta.x)
      return
    end
    if LuaGameObject.ObjectIsNull(self.furnitureModel.gameObject) then
      return
    end
    LuaGameObject.LocalRotateDeltaByAxisY(self.furnitureModel.transform, -delta.x)
  end)
end

function FurnitureShopView:AddViewEvts()
  self.listThemes:AddEventListener(MouseEvent.MouseClick, self.HandleClickTheme, self)
  self.listItem:AddEventListener(MouseEvent.MouseClick, self.HandleClickItem, self)
  self.listItem:AddEventListener(HappyShopEvent.SelectIconSprite, self.HandleClickIconSprite, self)
  self.listItem:AddEventListener(HappyShopEvent.ExchangeBtnClick, self.HandleClickItemExchange, self)
  self.listPackContents:AddEventListener(MouseEvent.MouseClick, self.HandleClickPackFurniture, self)
  self:AddListenEvt(MyselfEvent.MyDataChange, self.UpdateMoney)
  self:AddListenEvt(ItemEvent.ItemUpdate, self.UpdateMoney)
  self:AddListenEvt(ItemEvent.BarrowUpdate, self.UpdateMoney)
  self:AddListenEvt(ItemEvent.FurnitureUpdate, self.UpdateGoodsNum)
  self:AddListenEvt(ServiceEvent.SessionShopQueryShopConfigCmd, self.RecvQueryShopConfig)
  self:AddListenEvt(ServiceEvent.SessionShopBuyShopItem, self.RecvBuyShopItem)
  self:AddListenEvt(ServiceEvent.SessionShopServerLimitSellCountCmd, self.UpdateShopInfo)
end

function FurnitureShopView:InitShow()
  self.labRebuyDiscount.text = string.format(ZhString.FurnitureShop_rebuyDiscount, GameConfig.FurnitureShopRebuyDiscount or "--")
  local moneyTypes = GameConfig.FurnitureShopMoney
  if moneyTypes then
    for i = 1, #self.moneySprite do
      local moneyId = moneyTypes[i]
      if moneyId then
        local item = Table_Item[moneyId]
        if item then
          IconManager:SetItemIcon(item.Icon, self.moneySprite[i])
          self.moneySprite[i].gameObject:SetActive(true)
        end
      else
        self.moneySprite[i].gameObject:SetActive(false)
      end
    end
  else
    for i = 1, #self.moneySprite do
      self.moneySprite[i].gameObject:SetActive(false)
    end
  end
  self:UpdateMoney()
  TableUtility.TableClear(self.themeDatas)
  local validArray = ReusableTable.CreateTable()
  local endArray = ReusableTable.CreateTable()
  for k, v in pairs(Table_Furnitureshops) do
    validArray[1] = v.AddDate
    validArray[2] = v.TFAddDate
    endArray[1] = v.EndDate or "2035-12-31 05:00:00"
    endArray[2] = v.TFEndDate or "2035-12-31 05:00:00"
    if ItemUtil.CheckDateValid(validArray) and not ItemUtil.CheckDateValid(endArray) then
      self.themeDatas[#self.themeDatas + 1] = v
    end
  end
  ReusableTable.DestroyAndClearTable(validArray)
  ReusableTable.DestroyAndClearTable(endArray)
  table.sort(self.themeDatas, function(a, b)
    return a.id > b.id
  end)
  self.listThemes:ResetDatas(self.themeDatas)
  if #self.themeDatas > 0 then
    self:HandleClickTheme(self.listThemes:GetCells()[1])
  end
end

function FurnitureShopView:HandleClickTheme(cellctl)
  if not cellctl.data or cellctl.data == FurnitureShopView.CurThemeData then
    return
  end
  if self.curTheme then
    self.curTheme:Select(false)
  end
  self.curTheme = cellctl
  self.curTheme:Select(true)
  FurnitureShopView.CurThemeData = self.curTheme.data
  FurnitureShopView.SelectItemData = nil
  ShopProxy.Instance:CallQueryShopConfig(cellctl.data.ShopType, cellctl.data.ShopID)
  self:UpdateShopInfo(true)
end

function FurnitureShopView.GetCurThemeData()
  return FurnitureShopView.CurThemeData
end

function FurnitureShopView.GetCurItemData()
  return FurnitureShopView.SelectItemData
end

function FurnitureShopView:HandleClickItem(cellctl)
  if FurnitureShopView.GetCurItemData() ~= cellctl.data then
    if self.currentItem then
      self.currentItem:SetChoose(false)
    end
    cellctl:SetChoose(true)
    self.currentItem = cellctl
    FurnitureShopView.SelectItemData = cellctl.data
  end
  local id = cellctl.data
  local themeData = FurnitureShopView.GetCurThemeData()
  local data = ShopProxy.Instance:GetShopItemDataByTypeId(themeData.ShopType, themeData.ShopID, id)
  self.objBtnBuy:SetActive(data ~= nil)
  self.furnitureModel = nil
  if data then
    if data:GetLock() then
      FunctionUnLockFunc.Me():CheckCanOpen(data.MenuID, true)
      self.objBtnBuy:SetActive(false)
    end
    if GameConfig.FurnitureShopTexName and GameConfig.FurnitureShopTexName[data.goodsID] then
      if self.curShopItemTexName then
        PictureManager.Instance:UnLoadHome(self.curShopItemTexName, self.texShopGuide)
      end
      self:SwitchPageStatus(FurnitureShopView.PageStatus.Pack)
      self.curShopItemTexName = GameConfig.FurnitureShopTexName[data.goodsID]
      PictureManager.Instance:SetHome(self.curShopItemTexName, self.texShopGuide)
      self:SetPackContentItems(data.goodsID)
    elseif Table_HomeFurniture[data.goodsID] then
      self:SwitchPageStatus(FurnitureShopView.PageStatus.Furniture)
      if self.isLoadingModel then
        return
      end
      self.isLoadingModel = true
      UIModelUtil.Instance:SetFurnitureModelTexture(self.texFurniture, data.goodsID, nil, function(obj)
        self:HandleClickItemCallBack(data, obj)
      end)
    elseif Table_HomeFurnitureMaterial[data.goodsID] then
      self:SwitchPageStatus(FurnitureShopView.PageStatus.Furniture)
      if self.isLoadingModel then
        return
      end
      self.isLoadingModel = true
      UIModelUtil.Instance:SetHomeMaterialModelTexture(self.texFurniture, data.goodsID, nil, function(obj)
        self:HandleClickItemCallBack(data, obj)
      end)
    else
      self:SwitchPageStatus(FurnitureShopView.PageStatus.Empty)
    end
  else
    self:SwitchPageStatus(FurnitureShopView.PageStatus.Empty)
    redlog("no furniture data!")
  end
end

function FurnitureShopView:HandleClickItemCallBack(data, obj)
  self.furnitureModel = obj
  UIModelUtil.Instance:ChangeBGMeshRenderer(texName_FurnitureModel, self.texFurniture)
  self.sprLabBuff:SetText(AdventureDataProxy.Instance:getUnlockRewardStr(Table_Item[data.goodsID], ZhString.ItemTip_ChAnd))
  self.isLoadingModel = false
end

function FurnitureShopView:SwitchPageStatus(status)
  self.objFurnitureBuff:SetActive(status == FurnitureShopView.PageStatus.Furniture)
  self.objFurniturePack:SetActive(status == FurnitureShopView.PageStatus.Pack)
  if status ~= FurnitureShopView.PageStatus.Furniture then
    UIModelUtil.Instance:ResetTexture(self.texFurniture)
  end
  self.texFurniture.gameObject:SetActive(status == FurnitureShopView.PageStatus.Furniture)
  self.texFurnitureBG.gameObject:SetActive(status == FurnitureShopView.PageStatus.Furniture)
end

function FurnitureShopView:SetPackContentItems(goodsID)
  self:ClearPackContentItems()
  local useSData = Table_UseItem[goodsID]
  local useEffect = useSData and useSData.UseEffect
  local datas = ItemUtil.GetRewardItemIdsByTeamId(useEffect and useEffect.id)
  if datas then
    local dataMap = ReusableTable.CreateTable()
    local singleItem, singleData
    for i = 1, #datas do
      singleItem = datas[i]
      singleData = dataMap[singleItem.id]
      if not singleData then
        singleData = ReusableTable.CreateTable()
        singleData.item = singleItem
        singleData.num = 0
        dataMap[singleItem.id] = singleData
      end
      singleData.num = singleData.num + (singleItem.num or 1)
    end
    for id, data in pairs(dataMap) do
      self.packContentDatas[#self.packContentDatas + 1] = data
    end
    ReusableTable.DestroyAndClearTable(dataMap)
    table.sort(self.packContentDatas, function(a, b)
      return a.item.id < b.item.id
    end)
  end
  self.listPackContents:ResetDatas(self.packContentDatas)
  self.scrollPackContents:ResetPosition()
end

function FurnitureShopView:ClearPackContentItems()
  for i = 1, #self.packContentDatas do
    ReusableTable.DestroyAndClearTable(self.packContentDatas[i])
  end
  TableUtility.TableClear(self.packContentDatas)
end

function FurnitureShopView:HandleClickPackFurniture(cellctl)
  if not cellctl.itemSData then
    return
  end
  self.tmpItemData:ResetData("TmpFurnitureItem", cellctl.itemSData.id)
  self.tipData.itemdata = self.tmpItemData
  TipsView.Me():HideCurrent()
  self:ShowItemTip(self.tipData, self.widgetPackTipStick)
end

function FurnitureShopView:HandleClickIconSprite(cellctl)
  local themeData = FurnitureShopView.GetCurThemeData()
  local data = ShopProxy.Instance:GetShopItemDataByTypeId(themeData.ShopType, themeData.ShopID, cellctl.data)
  self:HandleClickItem(cellctl)
  TipsView.Me():HideCurrent()
  self:ShowShopItemTip(data)
end

function FurnitureShopView:ShowShopItemTip(data)
  if data.goodsID then
    self.tipData.itemdata = data:GetItemData()
    self:ShowItemTip(self.tipData, self.widgetTipStick)
  else
    errorLog("FurnitureShopView ShowItemTip data.goodsID == nil")
  end
end

function FurnitureShopView:HandleClickItemExchange(cellctl)
  if self.ltForbidClick then
    return
  end
  cellctl = cellctl or self.currentItem
  if not cellctl then
    return
  end
  local themeData = FurnitureShopView.GetCurThemeData()
  local data = ShopProxy.Instance:GetShopItemDataByTypeId(themeData.ShopType, themeData.ShopID, cellctl.data)
  local itemSData = Table_Item[data.ItemID]
  local finalPrice = data:GetBuyFinalPrice(data.ItemCount, 1)
  local spendStr = ""
  if itemSData.id == 151 then
    local ticketNum = HappyShopProxy.Instance:GetItemNum(5665)
    if 0 < ticketNum then
      local tickedSData = Table_Item[5665]
      if tickedSData then
        spendStr = math.min(finalPrice, ticketNum) .. tickedSData.NameZh
      end
    end
    if finalPrice > ticketNum then
      local goldSData = Table_Item[itemSData.id]
      if finalPrice > ticketNum + HappyShopProxy.Instance:GetItemNum(goldSData.id) then
        MsgManager.FloatMsgTableParam(nil, ZhString.HappyShop_NotEnough, goldSData and goldSData.NameZh or "")
        return
      end
      if 0 < ticketNum then
        spendStr = spendStr .. ZhString.ItemTip_ChAnd
      end
      spendStr = string.format("%s%s%s", spendStr, finalPrice - ticketNum, goldSData.NameZh)
    end
  else
    if finalPrice > HappyShopProxy.Instance:GetItemNum(itemSData.id) then
      MsgManager.FloatMsgTableParam(nil, ZhString.HappyShop_NotEnough, itemSData and itemSData.NameZh or "")
      return
    end
    spendStr = finalPrice .. itemSData.NameZh
  end
  if LocalSaveProxy.Instance:GetDontShowAgain(40534) then
    HappyShopProxy.Instance:BuyItemByShopItemData(data, 1, true)
    self.ltForbidClick = TimeTickManager.Me():CreateOnceDelayTick(1000, function(owner, deltaTime)
      self.ltForbidClick = nil
    end, self)
  elseif not BranchMgr.IsJapan() then
    MsgManager.DontAgainConfirmMsgByID(40534, function()
      HappyShopProxy.Instance:BuyItemByShopItemData(data, 1, true)
      self.ltForbidClick = TimeTickManager.Me():CreateOnceDelayTick(1000, function(owner, deltaTime)
        self.ltForbidClick = nil
      end, self)
    end, nil, nil, spendStr)
  elseif itemSData.id == 151 then
    OverseaHostHelper:GachaUseComfirm(finalPrice, function()
      HappyShopProxy.Instance:BuyItemByShopItemData(data, 1, true)
      self.ltForbidClick = TimeTickManager.Me():CreateOnceDelayTick(1000, function(owner, deltaTime)
        self.ltForbidClick = nil
      end, self)
    end)
  else
    HappyShopProxy.Instance:BuyItemByShopItemData(data, 1, true)
    self.ltForbidClick = TimeTickManager.Me():CreateOnceDelayTick(1000, function(owner, deltaTime)
      self.ltForbidClick = nil
    end, self)
  end
end

function FurnitureShopView:UpdateShopInfo(isReset)
  self.objBtnBuy:SetActive(false)
  self.objFurnitureBuff:SetActive(false)
  self.objFurniturePack:SetActive(false)
  UIModelUtil.Instance:ResetTexture(self.texFurniture)
  self.isLoadingModel = false
  local curItemData = FurnitureShopView:GetCurItemData()
  local themeData = FurnitureShopView.GetCurThemeData()
  FurnitureShopView.SelectItemData = nil
  local datas = themeData and ShopProxy.Instance:GetConfigByTypeId(themeData.ShopType, themeData.ShopID)
  if datas then
    self.currentItem = nil
    TableUtility.TableClear(self.itemDatas)
    for id, data in pairs(datas) do
      self.itemDatas[#self.itemDatas + 1] = id
    end
    table.sort(self.itemDatas, function(a, b)
      return datas[a].ShopOrder < datas[b].ShopOrder
    end)
    self.listItem:ResetDatas(self.itemDatas, isReset)
    if #self.itemDatas > 0 then
      local found = false
      local cells = self.listItem:GetCells()
      if curItemData then
        for i = 1, #cells do
          if cells[i].data == curItemData then
            self:HandleClickItem(cells[i])
            found = true
            break
          end
        end
      end
      if not found then
        self:HandleClickItem(cells[1])
      end
    end
  else
    redlog("FurnitureShopView:UpdateShopInfo : datas is nil ~")
  end
  self.objNoItem:SetActive(not self.itemDatas or #self.itemDatas < 1)
end

function FurnitureShopView:UpdateGoodsNum()
  local cells = self.listItem:GetCells()
  if cells then
    for i = 1, #cells do
      cells[i]:RefreshOwnedNum()
    end
  end
end

function FurnitureShopView:UpdateMoney()
  local moneyTypes = GameConfig.FurnitureShopMoney
  if moneyTypes then
    for i = 1, #self.moneyLabel do
      local moneyType = moneyTypes[i]
      if moneyType then
        local money = StringUtil.NumThousandFormat(HappyShopProxy.Instance:GetItemNum(moneyTypes[i]))
        self.moneyLabel[i].text = money
      else
        self.moneyLabel[i].text = ""
      end
    end
  end
end

function FurnitureShopView:RecvBuyShopItem(note)
  self:UpdateShopInfo()
end

function FurnitureShopView:RecvQueryShopConfig(note)
  self:UpdateShopInfo(self.isFirst)
  self.isFirst = false
end

function FurnitureShopView:HandleShopSoldCountCmd(note)
  local cells = self.listItem:GetCells()
  for j = 1, #cells do
    cells[j]:RefreshBuyCondition()
  end
end

function FurnitureShopView:OnEnter()
  FurnitureShopView.super.OnEnter(self)
  PictureManager.Instance:SetHome(texName_BG, self.texBG)
  PictureManager.Instance:SetHome(texName_ShopUp, self.texShopUp)
  PictureManager.Instance:SetHome(texName_FurnitureBG, self.texFurnitureBG)
  self.isFirst = true
  self.isLoadingModel = false
  self:InitShow()
end

function FurnitureShopView:OnExit()
  self.isLoadingModel = false
  if self.ltForbidClick then
    self.ltForbidClick:Destroy()
    self.ltForbidClick = nil
  end
  self:ClearPackContentItems()
  TipsView.Me():HideCurrent()
  FurnitureShopView.CurThemeData = nil
  FurnitureShopView.SelectItemData = nil
  PictureManager.Instance:UnLoadHome(texName_BG, self.texBG)
  PictureManager.Instance:UnLoadHome(texName_ShopUp, self.texShopUp)
  PictureManager.Instance:UnLoadHome(texName_FurnitureBG, self.texFurnitureBG)
  if self.curShopItemTexName then
    PictureManager.Instance:UnLoadHome(self.curShopItemTexName, self.texShopGuide)
    self.curShopItemTexName = nil
  end
  FurnitureShopView.super.OnExit(self)
end
