autoImport("BaseTip")
ItemFloatTip = class("ItemFloatTip", BaseTip)
autoImport("FashionPreviewTip")
autoImport("ItemTipComCell")
autoImport("UseWayTip")
autoImport("FramePreviewTip")
local getTempV3 = LuaGeometry.GetTempVector3

function ItemFloatTip:Init()
  self:AddGameObjectComp()
  self:InitCells()
  self.root = Game.GameObjectUtil:FindCompInParents(self.gameObject, UIRoot)
  self.closecomp = self.gameObject:GetComponent(CloseWhenClickOtherPlace)
  
  function self.closecomp.callBack(go)
    self:CloseSelf()
  end
  
  self.gpContainer = self:FindGO("GetPathContainer")
  self.foldButton = self:FindGO("FoldButton")
  self.foldArrowSp = self:FindComponent("FoldArrow", UISprite)
  self:AddClickEvent(self.foldButton, function()
    if self.foldArrowSp.flip == 0 then
      for i = 1, #self.cells do
        if 1 < i then
          self.cells[i].gameObject.transform.localPosition = getTempV3(10000)
        end
      end
      local x = LuaGameObject.GetLocalPosition(self.cells[1].gameObject.transform)
      self.foldButton.transform.localPosition = getTempV3(x - 198)
      self.foldArrowSp.flip = 1
    else
      self:Reposition()
    end
  end)
end

function ItemFloatTip:InitCells()
  self.grid = self:FindComponent("Grid", UIGrid)
  if not self.isInit then
    self.isInit = true
    self.cells = {}
    for i = 1, 3 do
      local obj = self:LoadPreferb("cell/ItemTipComCell", self.grid.gameObject)
      obj.name = string.format("%d_ItemTipComCell%d", 4 - i, i)
      obj:SetActive(i == 1)
      self.cells[i] = ItemTipComCell.new(obj, i)
      self.cells[i]:AddEventListener(ItemTipEvent.ClickTipFuncEvent, self.ClickTipFuncEvent, self)
      self.cells[i]:AddEventListener(ItemTipEvent.ShowGetPath, self.ShowGetPath, self)
      self.cells[i]:AddEventListener(ItemTipEvent.StoreToAdvManual, self.StoreToAdvManual, self)
      self.cells[i]:AddEventListener(ItemTipEvent.ShowFashionPreview, self.ShowFashionPreview, self)
      self.cells[i]:AddEventListener(ItemTipEvent.ShowGotoUse, self.ShowDoGotoUse, self)
      self.cells[i]:AddEventListener(ItemTipEvent.ShowEquipUpgrade, self.ShowEquipUpgrade, self)
      self.cells[i]:AddEventListener(ItemTipEvent.ConfirmMsgShowing, self.HandleConfirmMsgShowing, self)
      self.cells[i]:AddEventListener(ItemTipEvent.ShowPortraitFramePreview, self.ShowPortraitFramePreview, self)
      self.cells[i]:AddEventListener(ItemTipEvent.ClickItemUrl, self.ClickItemUrl, self)
      self.cells[i]:AddEventListener(ItemTipEvent.ShowAncientRandom, self.ShowAncientRandom, self)
      self.cells[i]:AddEventListener(ItemTipEvent.ClickBufferUrl, self.ClickBufferUrl, self)
    end
  end
  local cellTop = self:FindGO("3_Cell1")
  if cellTop and (BranchMgr.IsSEA() or BranchMgr.IsEU()) then
    local top = self:FindGO("Top", cellTop)
    if top then
      local phoneplat = ApplicationInfo.GetRunPlatformStr()
      if phoneplat == "iOS" then
        self.appleMusicButton = self:LoadPreferb("cell/AppleMusicButton", top)
        local sprite = self:FindComponent("Sprite", UISprite, self.appleMusicButton)
        sprite.depth = 100
        self.appleMusicButton.transform.localPosition = getTempV3(128, -13, 0)
        self.appleMusicButton:SetActive(false)
        self:AddClickEvent(sprite.gameObject, function(go)
          OverseaHostHelper:JumpToAppleMusic()
        end)
      end
    end
  end
end

function ItemFloatTip:ClickTipFuncEvent()
  self:CloseSelf()
end

function ItemFloatTip:ShowGetPath(cell)
  if cell and cell.gameObject then
    self:CloseGotouseBord()
    self:CloseFashionPreview()
    self.foldButton:SetActive(false)
    if not self.bdt then
      self.gpContainer.transform.localScale = LuaGeometry.Const_V3_one
      if not self.pos then
        self.pos = self.gameObject.transform.localPosition
      end
      local go, tempX
      for _, c in pairs(self.cells) do
        go = c.gameObject
        if go.activeInHierarchy and go.name == cell.gameObject.name then
          if math.abs(self.pos.x) > 10 then
            tempX = 0
          else
            tempX = (c.data.equiped == 1 and 1 or -1) * 198
          end
        else
          tempX = 10000
        end
        go.transform.localPosition = getTempV3(tempX, 0, 0)
      end
      local x = LuaGameObject.InverseTransformPointByTransform(self.root.transform, cell.gameObject.transform, Space.World)
      self.gpContainer.transform.position = cell.gameObject.transform.position
      local lx, ly = LuaGameObject.GetLocalPosition(self.gpContainer.transform)
      self.gpContainer.transform.localPosition = getTempV3(lx - (0 < x and 1 or -1) * 198, ly + 275, 0)
      local data = cell.data
      if data and data.staticData then
        self.bdt = GainWayTip.new(self.gpContainer)
        self.bdt:SetAnchorPos(x <= 0)
        self.bdt:SetData(data.staticData.id, self.context)
        self.bdt:AddEventListener(ItemEvent.GoTraceItem, function()
          self:CloseSelf()
        end, self)
        self.bdt:AddIgnoreBounds(self.gameObject)
        self:AddIgnoreBounds(self.bdt.gameObject)
        self.bdt:AddEventListener(GainWayTip.CloseGainWay, self.GetPathCloseCall, self)
      end
      self:PassEvent(ItemTipEvent.ShowGetPath, self.bdt)
    else
      self:CloseGetPath()
    end
  end
end

function ItemFloatTip:GetPathCloseCall()
  if self.__destroyed then
    return
  end
  if self.itemUrlClicked then
    self.cells[2]:SetData()
    self.cells[3]:SetData()
  end
  self:Reposition()
  self.closecomp:ReCalculateBound()
  self.bdt = nil
  self:PassEvent(GainWayTip.CloseGainWay)
end

function ItemFloatTip:CloseGetPath()
  if self.bdt then
    self.bdt:OnExit()
    self.bdt = nil
  end
end

function ItemFloatTip:StoreToAdvManual(cell)
  local t = cell and cell:GetStoreType()
  if not t then
    return
  end
  ServiceSceneManualProxy.Instance:CallStoreManualCmd(t, cell.data.id)
  if cell and cell.gameObject then
    cell:SetData(nil)
  end
end

function ItemFloatTip:ShowFashionPreview(cell)
  if cell and cell.gameObject then
    if self.showFrom ~= "ZenyShopItem" then
      for i = 1, #self.cells do
        if self.cells[i] ~= cell then
          self.cells[i]:SetData(nil)
        end
      end
    end
    self:CloseGotouseBord()
    self:CloseGetPath()
    self.foldButton:SetActive(false)
    if not self.sfp then
      local scale = 1
      self.gpContainer.transform.localScale = getTempV3(scale, scale, scale)
      local x = LuaGameObject.InverseTransformPointByTransform(self.root.transform, cell.gameObject.transform, Space.World)
      self.gpContainer.transform.position = cell.gameObject.transform.position
      local lx, ly = LuaGameObject.GetLocalPosition(cell.gameObject.transform)
      self.gpContainer.transform.localPosition = getTempV3(0 < x and lx - 198 or lx + 198, ly + 278, 0)
      local data = cell.data
      if data and data.staticData then
        self.sfp = FashionPreviewTip.new(self.gpContainer)
        self.sfp:SetAnchorPos(x <= 0)
        if data:IsPic() then
          local cid = data.staticData.ComposeID
          local composeData = cid and Table_Compose[cid]
          if composeData then
            self.sfp:SetData(composeData.Product.id)
          end
        else
          local equipPreview = GameConfig.BattlePass.EquipPreview and GameConfig.BattlePass.EquipPreview[data.staticData.id]
          local equipInfo = data.equipInfo
          local fashionGroupEquip = equipInfo and equipInfo:GetMyGroupFashionEquip()
          if equipPreview then
            local field = MyselfProxy.Instance:GetMySex() == 2 and "female" or "male"
            self.sfp:SetData(equipPreview[field])
          elseif fashionGroupEquip then
            self.sfp:SetData(fashionGroupEquip.id)
          elseif data:GetComposeFashionTarget() ~= nil then
            self.sfp:SetData(data:GetComposeFashionTarget())
          else
            self.sfp:SetData(data.staticData.id)
          end
        end
        self.sfp:AddEventListener(ItemEvent.GoTraceItem, function()
          self:CloseSelf()
        end, self)
        self.sfp:AddIgnoreBounds(self.gameObject)
        self:AddIgnoreBounds(self.sfp.gameObject)
        self.sfp:AddEventListener(FashionPreviewEvent.Close, self.FashionPreViewCloseCall, self)
      end
      self:PassEvent(ItemTipEvent.ShowFashionPreview, self.sfp)
    else
      self:CloseFashionPreview()
    end
  end
end

function ItemFloatTip:FashionPreViewCloseCall()
  self.closecomp:ReCalculateBound()
  self.sfp = nil
  self:Refresh()
  self:PassEvent(FashionPreviewEvent.Close)
end

function ItemFloatTip:CloseFashionPreview()
  if self.sfp then
    self.sfp:OnExit()
    self.sfp = nil
  end
end

function ItemFloatTip:CloseGotouseBord()
  if self.uwt then
    self.uwt:OnExit()
    self.uwt = nil
  end
end

function ItemFloatTip:ShowDoGotoUse(cell)
  if cell and cell.gameObject then
    self:CloseFashionPreview()
    self:CloseGetPath()
    self.foldButton:SetActive(false)
    for i = 1, #self.cells do
      if self.cells[i] ~= cell then
        self.cells[i]:SetData(nil)
      end
    end
    if not self.uwt then
      local x = LuaGameObject.InverseTransformPointByTransform(self.root.transform, cell.gameObject.transform, Space.World)
      self.gpContainer.transform.position = cell.gameObject.transform.position
      local lx, ly = LuaGameObject.GetLocalPosition(cell.gameObject.transform)
      self.gpContainer.transform.localPosition = getTempV3(lx - (0 < x and 1 or -1) * 198, ly + 275, 0)
      local data = cell.data
      if data and data.staticData then
        self.uwt = UseWayTip.new(self.gpContainer)
        self.uwt:SetAnchorPos(x <= 0)
        self.uwt:SetData(data)
        self.uwt:AddEventListener(ItemTipEvent.ClickGotoUse, self.ClickGotoUse, self)
        self.uwt:AddEventListener(ItemTipEvent.CloseShowGotoUse, self.CloseGotoModeCall, self)
        self.uwt:AddIgnoreBounds(self.gameObject)
        self:AddIgnoreBounds(self.uwt.gameObject)
      end
    else
      self:CloseGotouseBord()
    end
  end
end

function ItemFloatTip:ShowEquipUpgrade(cell)
  local packageEnter = BagProxy.Instance.packageEnter
  local packageViewTab = BagProxy.Instance.packageTab or 1
  GameFacade.Instance:sendNotification(UIEvent.ShowUI, {
    viewname = "EquipIntegrateView",
    viewdata = {
      itemdata = cell.data,
      index = 3
    }
  })
  if packageEnter then
    local exitCallback = function()
      if packageViewTab then
        BagProxy.Instance:SetPackageViewTab(packageViewTab)
      end
      GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.Bag
      })
    end
    EventManager.Me():PassEvent(UIEvent.ExitCallback, exitCallback)
  end
  self:CloseSelf()
end

function ItemFloatTip:ClickGotoUse(param)
  local cell, gotoCell = param[1], param[2]
  if cell and gotoCell then
    FuncShortCutFunc.Me():CallByID(gotoCell.data.GotoMode)
    self:CloseSelf()
  end
end

function ItemFloatTip:CloseGotoModeCall()
  self.closecomp:ReCalculateBound()
  self.uwt = nil
  self:Refresh()
end

function ItemFloatTip:CloseSelf()
  if self.callback then
    self.callback(self.callbackParam)
  end
  TipsView.Me():HideCurrent()
end

function ItemFloatTip:SetData(data)
  self.data = data
  self.context = data and data.context
  self:Refresh()
  self:Reposition()
end

function ItemFloatTip:Refresh()
  local data = self.data
  if data == nil then
    return
  end
  if (BranchMgr.IsSEA() or BranchMgr.IsEU()) and self.appleMusicButton ~= nil then
    self.appleMusicButton:SetActive(data.itemdata.staticData.id == 1000021)
  end
  self.cells[1]:SetData(data.itemdata, data.showFrom, data.showFullAttr, data.equipBuffUpSource, data.showButton)
  self.cells[1]:UpdateTipFunc(data.funcConfig)
  self.cells[1]:SetClickBgFunc(data.funcClickBg)
  if not data.funcConfig or not next(data.funcConfig) and data.customFuncConfig then
    self.cells[1]:UpdateCustomTipFunc(data.customFuncConfig)
  end
  self.cells[2]:SetData(data.compdata1, nil, nil, data.compEquipBuffUpSource1, data.showButton)
  self.cells[2]:UpdateTipFunc()
  self.cells[2]:SetClickBgFunc(data.funcClickBg)
  self.cells[3]:SetData(data.compdata2, nil, nil, data.compEquipBuffUpSource2, data.showButton)
  self.cells[3]:UpdateTipFunc()
  self.cells[3]:SetClickBgFunc(data.funcClickBg)
  if data.showUpTip ~= nil then
    if data.showUpTip == false then
      for i = 1, #self.cells do
        self.cells[i]:TrySetShowUpBtnActive(false)
      end
    else
      for i = 1, #self.cells do
        self.cells[i]:UpdateShowUpButton()
      end
    end
  end
  self.cells[1]:SetDelTimeTip(data.showDelTime == nil or data.showDelTime == true)
  if data.tip then
    self.cells[1]:SetDownTipText(data.tip)
  end
  if data.hideGetPath then
    self.cells[1]:HideGetPath()
  end
  if data.noSelfClose then
    self.closecomp.enabled = false
  else
    self.closecomp.enabled = true
  end
  if data.hideItemIcon then
    self:HideItemIcon()
  end
  if data.needLocker then
    self:ShowMonsterlvLocker()
  end
  if data.applyClose then
    for i = 1, #self.cells do
      self.cells[i]:SetApplyClose(data.applyClose)
    end
  end
  if data.showCloseBtn then
    self:TrySetCloseBtn(true)
  end
  self.closecomp:ReCalculateBound()
  self.callback = data.callback
  self.callbackParam = data.callbackParam
  self.clickItemUrlCallback = data.clickItemUrlCallback
  self.showFrom = data.showFrom
  self.ignoreBounds = data.ignoreBounds
  self.defaultShowGetPath = data.defaultShowGetPath
end

function ItemFloatTip:Reset()
  self.data = nil
  self:CloseGetPath()
  self:CloseFashionPreview()
  self.closecomp:ClearTarget()
  TimeTickManager.Me():ClearTick(self)
end

function ItemFloatTip:OnEnter()
  if type(self.ignoreBounds) == "table" then
    for i = 1, #self.ignoreBounds do
      if not self:ObjIsNil(self.ignoreBounds[i]) then
        self:AddIgnoreBounds(self.ignoreBounds[i])
      end
    end
  end
  if self.defaultShowGetPath then
    TimeTickManager.Me():CreateOnceDelayTick(100, function(owner, deltaTime)
      self:ShowGetPath(self.cells[1])
    end, self, 5)
  end
  local colliders = Game.GameObjectUtil:GetAllComponentsInChildren(self.gameObject, BoxCollider, true)
  for i = 1, #colliders do
    colliders[i].enabled = false
  end
  TimeTickManager.Me():CreateOnceDelayTick(300, function(owner, deltaTime)
    for i = 1, #colliders do
      if not self:ObjIsNil(colliders[i]) then
        colliders[i].enabled = true
      end
    end
    for i = 1, #self.cells do
      self.cells[i]:UpdateCountChooseBordButton()
    end
  end, self)
end

function ItemFloatTip:SetPos(pos)
  self:Reset()
  ItemFloatTip.super.SetPos(self, pos)
  TimeTickManager.Me():CreateOnceDelayTick(40, function(self)
    self:Reposition()
  end, self)
end

function ItemFloatTip:Reposition(pivot)
  self.grid.pivot = pivot or UIWidget.Pivot.Center
  self.grid:Reposition()
  self:TranslateCellWhenMultiple(1, 10)
  local cellDataCount = self:GetCellDataCount()
  self.foldButton:SetActive(1 < cellDataCount)
  self.foldButton.transform.localPosition = getTempV3(-198 * cellDataCount)
  self.foldArrowSp.flip = 0
end

function ItemFloatTip:TranslateCellWhenMultiple(index, x, y, z)
  if not self.cells[2].data then
    return
  end
  index = index or 1
  if 3 < index or index < 1 then
    return
  end
  x = x or 0
  y = y or 0
  z = z or 0
  local cellTrans = self.cells[index].gameObject.transform
  local x0, y0, z0 = LuaGameObject.GetLocalPosition(cellTrans)
  cellTrans.localPosition = getTempV3(x0 + x, y0 + y, z0 + z)
end

function ItemFloatTip:DestroySelf()
  GameObject.Destroy(self.gameObject)
end

function ItemFloatTip:AddIgnoreBounds(obj)
  if self.gameObject and self.closecomp then
    self.closecomp:AddTarget(obj.transform)
  end
end

function ItemFloatTip:RemoveIgnoreBounds(obj)
  if self.gameObject and self.closecomp then
    self.closecomp:RemoveTarget(obj.transform)
  end
end

function ItemFloatTip:HideItemIcon()
  for k, cell in pairs(self.cells) do
    cell:HideItemIcon()
  end
end

function ItemFloatTip:GetCell(index)
  return self.cells[index]
end

function ItemFloatTip:HideEquipedSymbol()
  for _, cell in pairs(self.cells) do
    cell:HideEquipedSymbol()
  end
end

function ItemFloatTip:ShowMonsterlvLocker()
  for _, cell in pairs(self.cells) do
    cell:ShowMonsterlvTip()
  end
end

function ItemFloatTip:OnExit()
  for _, cell in pairs(self.cells) do
    cell:Exit()
  end
  self:Reset()
  self.callback = nil
  self.callbackParam = nil
  self.clickItemUrlCallback = nil
  self.itemUrlClicked = nil
  self.closecomp = nil
  self.context = nil
  return true
end

function ItemFloatTip:ActiveFavorite()
  for _, cell in pairs(self.cells) do
    cell:TrySetFavoriteButtonActive(true)
  end
end

function ItemFloatTip:UpdateFavorite()
  for _, cell in pairs(self.cells) do
    cell:UpdateFavorite()
  end
end

function ItemFloatTip:HideShowTpBtn()
  for _, cell in pairs(self.cells) do
    cell:TrySetShowTpBtnActive(false)
  end
end

function ItemFloatTip:HideShowUpBtn()
  for _, cell in pairs(self.cells) do
    cell:TrySetShowUpBtnActive(false)
  end
end

function ItemFloatTip:TrySetCloseBtn(bool)
  for _, cell in pairs(self.cells) do
    cell:TrySetCloseBtn(bool)
  end
end

function ItemFloatTip:HandleConfirmMsgShowing(isShowing)
  self.closecomp.enabled = not isShowing
end

function ItemFloatTip:OnDestroy()
  ItemFloatTip.super.OnDestroy(self)
  for _, v in pairs(self.cells) do
    v:OnDestroy()
  end
  self.__destroyed = true
end

function ItemFloatTip:ShowPortraitFramePreview(cell)
  if cell and cell.gameObject then
    if self.showFrom ~= "ZenyShopItem" then
      for i = 1, #self.cells do
        if self.cells[i] ~= cell then
          self.cells[i]:SetData(nil)
        end
      end
    end
    self:CloseGotouseBord()
    self:CloseGetPath()
    self.foldButton:SetActive(false)
    if not self.sfp then
      local scale = 1
      self.gpContainer.transform.localScale = getTempV3(scale, scale, scale)
      local x = LuaGameObject.InverseTransformPointByTransform(self.root.transform, cell.gameObject.transform, Space.World)
      self.gpContainer.transform.position = cell.gameObject.transform.position
      local lx, ly = LuaGameObject.GetLocalPosition(cell.gameObject.transform)
      self.gpContainer.transform.localPosition = getTempV3(0 < x and lx - 198 or lx + 198, ly + 275, 0)
      local data = cell.data
      if data and data.staticData then
        self.sfp = FramePreviewTip.new(self.gpContainer)
        self.sfp:SetAnchorPos(x <= 0)
        local isPortrait, effectID = data:IsPortraitFrame()
        local isBackground, eID = data:IsBackground()
        local isChatframe, chatframeID = data:IsChatframe()
        if isPortrait then
          self.sfp:SetHeadIconCell(effectID)
        elseif isBackground then
          self.sfp:SetTeamMemberCell(eID)
        elseif isChatframe then
          self.sfp:SetChatframe(chatframeID)
        end
        self.sfp:AddIgnoreBounds(self.gameObject)
        self:AddIgnoreBounds(self.sfp.gameObject)
        self.sfp:AddEventListener(FramePreviewEvent.Close, self.FramePreviewCloseCall, self)
      end
    else
      self:CloseFramePreview()
    end
  end
end

function ItemFloatTip:GetCellDataCount()
  local cellDataCount = 0
  for i = 1, #self.cells do
    cellDataCount = cellDataCount + (self.cells[i].data and 1 or 0)
  end
  return cellDataCount
end

function ItemFloatTip:ClickItemUrl(id)
  local f = self.clickItemUrlCallback or self.DefaultClickItemUrl
  self.itemUrlClicked = true
  f(self, id)
end

local itemClickUrlData

function ItemFloatTip:DefaultClickItemUrl(id, pivot)
  local split = string.split(id, "+")
  id = tonumber(split[1])
  self:CloseGetPath()
  self:CloseFashionPreview()
  self:CloseGotouseBord()
  self.foldButton:SetActive(false)
  if not itemClickUrlData then
    itemClickUrlData = ItemData.new()
  end
  itemClickUrlData:ResetData("itemClickUrl", id)
  if itemClickUrlData:IsEquip() and split[2] then
    itemClickUrlData.equipInfo:SetRefine(tonumber(split[2]))
  end
  self.cells[2]:SetData(itemClickUrlData)
  self.cells[3]:SetData()
  self.closecomp:ReCalculateBound()
  self:RestrictInView()
  self:Reposition(pivot)
end

function ItemFloatTip:ClickBufferUrl(id)
  self:CloseGetPath()
  self:CloseFashionPreview()
  self:CloseGotouseBord()
  self.foldButton:SetActive(false)
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.EnchantInfoPopup,
    viewdata = {attriMenuType = 4, advCostID = id}
  })
  local layer = UIManagerProxy.Instance:GetLayerByType(UIViewType.Lv4PopUpLayer)
  if layer then
    local panelCtrl = layer:FindNodeByName("EnchantInfoPopup")
    if panelCtrl then
      self:AddIgnoreBounds(panelCtrl.gameObject)
    else
      self.closecomp:ReCalculateBound()
    end
  end
end

function ItemFloatTip:_DestroyHelpTip()
  if self.helpTip then
    self.helpTip:DestroySelf()
    self.helpTip = nil
  end
end

function ItemFloatTip:FramePreviewCloseCall()
  self.closecomp:ReCalculateBound()
  self.sfp = nil
  self:Refresh()
end

function ItemFloatTip:CloseFramePreview()
  if self.sfp then
    self.sfp:OnExit()
    self.sfp = nil
  end
end

function ItemFloatTip:RestrictInView()
  local rsSizeX = (UIManagerProxy.Instance:GetUIRootSize()[1] - 400) / 2
  local go1 = self.cells[1] and self.cells[1].gameObject
  if not Slua.IsNull(go1) and go1.activeInHierarchy then
    local x, y, z = NGUIUtil.GetUIPositionXYZ(go1)
    if x < -rsSizeX then
      local tx, ty, tz = LuaGameObject.GetLocalPositionGO(self.gameObject)
      LuaGameObject.SetLocalPositionGO(self.gameObject, tx + (-rsSizeX - x), ty, tz)
      return
    end
  end
  local go2 = self.cells[2] and self.cells[2].gameObject
  if not Slua.IsNull(go2) and go2.activeInHierarchy then
    local x, y, z = NGUIUtil.GetUIPositionXYZ(go2)
    if rsSizeX < x then
      local tx, ty, tz = LuaGameObject.GetLocalPositionGO(self.gameObject)
      LuaGameObject.SetLocalPositionGO(self.gameObject, tx - (x - rsSizeX), ty, tz)
      return
    end
  end
  local go3 = self.cells[3] and self.cells[3].gameObject
  if not Slua.IsNull(go3) and go3.activeInHierarchy then
    local x, y, z = NGUIUtil.GetUIPositionXYZ(go3)
    if rsSizeX < x then
      local tx, ty, tz = LuaGameObject.GetLocalPositionGO(self.gameObject)
      LuaGameObject.SetLocalPositionGO(self.gameObject, tx - (x - rsSizeX), ty, tz)
      return
    end
  end
end

function ItemFloatTip:ShowAncientRandom(cell)
  FunctionNpcFunc.RandomProperty(nil, {
    OnClickChooseBordCell_data = cell.data
  }, nil, true)
  self:CloseSelf()
end
