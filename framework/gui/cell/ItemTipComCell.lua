autoImport("ItemTipBaseCell")
autoImport("TicketPreview")
autoImport("ItemNewCell")
autoImport("ItemTipFuncCell")
autoImport("ItemSecendFuncBord")
autoImport("UICycledScrollCtrl")
ItemTipComCell = class("ItemTipComCell", ItemTipBaseCell)
local BottomY = -194
local BottomY_Long = -264
local isNil = LuaGameObject.ObjectIsNull

function ItemTipComCell:ctor(obj, index)
  ItemTipComCell.super.ctor(self, obj)
  self.index = index
end

function ItemTipComCell:Init()
  ItemTipComCell.super.Init(self)
  self.bg = self:FindComponent("Bg", UISprite)
  self.tips = self:FindComponent("Tips", UILabel)
  self.refreshTip_GO = self:FindGO("RefreshTip")
  if self.refreshTip_GO then
    self.refreshTip = self:FindComponent("Label", UILabel, self.refreshTip_GO)
  end
  self.beforePanel = self:FindGO("BeforePanel")
  self.bottomBtns = self:FindGO("BottomButtons")
  if self.bottomBtns then
    self.func = {}
    local style1, style2, style3 = {}, {}, {}
    style1.obj = self:FindGO("Style1", self.bottomBtns)
    style2.obj = self:FindGO("Style2", self.bottomBtns)
    style3.obj = self:FindGO("Style3", self.bottomBtns)
    self:AddButtonEvent("FuncBtnMore")
    self:InitFuncBtnStyle(1, style1)
    self:InitFuncBtnStyle(2, style2)
    self:InitFuncBtnStyle(5, style3)
    self.func.style = {
      style1,
      style2,
      style3
    }
  end
  self.LockRoot = self:FindGO("LockRoot")
  self.LockDes = self:FindComponent("LockMenuDes", UILabel)
  self.btnGrid = self:FindComponent("BtnGrid", UIGrid)
  self.showfpButton = self:FindGO("ShowFPreviewButton")
  if self.showfpButton then
    self:AddClickEvent(self.showfpButton, function(go)
      if self.data.equipInfo and self.data.equipInfo:IsMyDisplayForbid() then
        MsgManager.ShowMsgByID(40310)
        return
      end
      if not self.data:IsPortraitFrame() and not self.data:IsBackground() and not self.data:IsChatframe() then
        self:PassEvent(ItemTipEvent.ShowFashionPreview, self)
      else
        self:PassEvent(ItemTipEvent.ShowPortraitFramePreview, self)
      end
    end)
  end
  self.showTpBtn = self:FindGO("ShowTPreviewButton")
  if self.showTpBtn then
    self:AddClickEvent(self.showTpBtn, function()
      self:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.TicketPreview,
        viewdata = self.data
      })
      TipsView.Me():HideCurrent()
    end)
  end
  self.showUpButton = self:FindGO("ShowUpgradeButton")
  if self.showUpButton then
    self.showUpButton_Symbol = self.showUpButton:GetComponent(UISprite)
    self:AddClickEvent(self.showUpButton, function()
      self:PassEvent(ItemTipEvent.ShowEquipUpgrade, self)
    end)
  end
  self.favoriteButton = self:FindGO("Favorite")
  if self.favoriteButton then
    self.favoriteSp = self.favoriteButton:GetComponent(UISprite)
    self.favoriteButton:SetActive(false)
    self:AddClickEvent(self.favoriteButton, function()
      self:OnFavoriteClick()
    end)
  end
  self.storeButton = self:FindGO("StoreButton")
  if self.storeButton then
    self.storeButtonSp = self.storeButton:GetComponent(UISprite)
    self:AddClickEvent(self.storeButton, function(go)
      if not self.isStoreButtonAvailable then
        return
      end
      self:PassEvent(ItemTipEvent.StoreToAdvManual, self)
    end)
  end
  self.helpInfoButton = self:FindGO("HelpInfoButton")
  if self.helpInfoButton then
    self:AddClickEvent(self.helpInfoButton, function()
      if not self.data then
        return
      end
      OverseaHostHelper:ShowGiftProbability(self.data.staticData.id)
    end)
  end
  if self.bg then
    self:AddClickEvent(self.bg.gameObject, function()
      if not self.funcClickBg ~= nil then
        return
      end
      self.funcClickBg()
    end)
  end
  self.closeBtn = self:FindGO("CloseBtn")
  if self.closeBtn then
    self:AddClickEvent(self.closeBtn, function()
      self:PassEvent(ItemTipEvent.ClickTipFuncEvent, self)
    end)
  end
  self.giftDetailBtn = self:FindGO("GiftDetailButton")
  if self.giftDetailBtn then
    self:AddClickEvent(self.giftDetailBtn, function()
      self:PassEvent(ItemTipEvent.ShowGiftDetail, self)
    end)
  end
  self:AddListener()
end

function ItemTipComCell:ActiveCountChooseBord(b, countChoose_maxCount)
  self.super.ActiveCountChooseBord(self, b, countChoose_maxCount)
  if not isNil(self.cardScrollPanel) then
    if b then
      self.cardScrollPanel:SetRect(0, 27.5, 370, 275)
    else
      self.cardScrollPanel:SetRect(0, 0, 370, 330)
    end
  end
end

function ItemTipComCell:InitItemCell(container)
  self:TryInitItemCell(container, "ItemNewCellForTips", ItemNewCellForTips)
end

function ItemTipComCell:AddListener()
  self:AddEventListener(ServiceEvent.NUserBattleTimelenUserCmd, self.HandleBattleTime)
end

function ItemTipComCell:InitFuncBtnStyle(num, container)
  container.button = {}
  for i = 1, num do
    local obj = self:FindGO("FuncBtn" .. i, container.obj)
    if obj then
      container.button[i] = ItemTipFuncCell.new(obj)
      container.button[i]:AddEventListener(MouseEvent.MouseClick, self.ClickTipFunc, self)
      if i == 1 then
        self:AddOrRemoveGuideId(obj, 202)
      end
    end
  end
end

function ItemTipComCell:ClickTipFunc(cellCtl)
  local data = cellCtl.data
  if data then
    local childFunction = data.childFunction
    if childFunction and self.beforePanel then
      self:ShowSecendFunc(childFunction, data.childFunction_Tip, self.beforePanel, cellCtl.bg)
    else
      if data.type == "GotoUse" then
        self:PassEvent(ItemTipEvent.ShowGotoUse, self)
        return
      end
      local count = self.chooseCount or 1
      self.data.chooseCount = count
      local callback = data.callback
      if callback then
        self:UpdateCountChooseBordButton()
        callback(data.callbackParam, count)
      else
        MsgManager.FloatMsgTableParam(nil, data.type .. " Not Implement")
      end
      if data == nil or self.data == nil then
        return
      end
      if not self.applyClose and data.type == "Apply" and count < self.data.num and (not self.data.staticData.UseMode or self.data.staticData.UseMode == 0) then
        return
      end
      if data.noClose then
        return
      end
      self:PassEvent(ItemTipEvent.ClickTipFuncEvent)
    end
  end
end

function ItemTipComCell:SetApplyClose(b)
  self.applyClose = b
end

function ItemTipComCell:SetData(data, showFrom, showFullAttr, equipBuffUpSource, showButton, notResetPos)
  self.data = data
  if self.data then
    self.data.showFrom = showFrom
    self.data.showButton = showButton
    self.data.showFullAttr = showFullAttr
    self.data.equipBuffUpSource = equipBuffUpSource
  end
  if data then
    self.gameObject:SetActive(true)
    self:ProcessPveCard()
    ItemTipComCell.super.SetData(self, data, not notResetPos)
    if not notResetPos then
      self.scrollview:ResetPosition()
      self.scrollview.gameObject:SetActive(false)
      self.scrollview.gameObject:SetActive(true)
    end
    self:UpdateShowFpButton()
    self:UpdateShowUpButton()
    self:UpdateFavorite()
    self:UpdateStoreButton()
    self:UpdateCardPreviewBtn()
    self:UpdateShowTpBtn()
    self:UpdateHelpInfoButton()
    self:UpdateGiftDetailButton()
  else
    self.gameObject:SetActive(false)
  end
end

function ItemTipComCell:ProcessPveCard()
  self:Show(self.scrollview)
  if not self.cardPreviewInited then
    self:InitCardPreview()
  end
  if self.cardPreviewPos then
    self:Hide(self.cardPreviewPos)
  end
end

function ItemTipComCell:GetStoreType()
  return AdventureDataProxy.Instance:GetStoreType(self.data)
end

function ItemTipComCell:UpdateStoreButton()
  local canStore = AdventureDataProxy.Instance:CheckCanStore(self.data)
  if self.storeButtonSp then
    self.isStoreButtonAvailable = canStore
    self.storeButtonSp.color = canStore and ItemTipSpriteNormalColor or ItemTipSpriteInvalidColor
    self.storeButtonSp.spriteName = canStore and "tips_icon_02" or "tips_icon_03"
  end
end

function ItemTipComCell:UpdateShowFpButton()
  local data = self.data
  if self.showfpButton then
    if data:IsExtraction() then
      self.showfpButton:SetActive(false)
    elseif data:IsPic() then
      local composeId = data.staticData.ComposeID
      local productId = composeId and Table_Compose[composeId] and Table_Compose[composeId].Product.id
      local product = productId and ItemData.new("Product", productId)
      self.showfpButton:SetActive(product and product:CanEquip() and true or false)
    elseif data:IsHomePic() then
      self.showfpButton:SetActive(not data:IsHomeMaterialPic())
    elseif data:EyeCanEquip() then
      self.showfpButton:SetActive(true)
    elseif data:HairCanEquip() then
      self.showfpButton:SetActive(true)
    elseif data:IsMountPet() then
      self.showfpButton:SetActive(true)
    elseif data:IsFurniture() then
      self.showfpButton:SetActive(true)
    elseif self.data:IsPortraitFrame() or self.data:IsBackground() or self.data:IsChatframe() then
      self.showfpButton:SetActive(true)
    elseif data:IsFashion() or data.equipInfo and (data.equipInfo:IsWeapon() or data.equipInfo:IsMount()) then
      if data:CanEquip(data.equipInfo:IsMount()) and not data:IsTrolley() then
        local myselfData = Game.Myself and Game.Myself.data
        if myselfData then
          self.showfpButton:SetActive(not myselfData:IsInMagicMachine() and not myselfData:IsEatBeing())
        else
          self.showfpButton:SetActive(false)
        end
      else
        self.showfpButton:SetActive(false)
      end
    elseif data.equipInfo and data.equipInfo:GetEquipType() == EquipTypeEnum.Shield then
      local cfgShowShield = GameConfig.Profession.show_shield_typeBranches
      self.showfpButton:SetActive(cfgShowShield ~= nil and TableUtility.ArrayFindIndex(cfgShowShield, MyselfProxy.Instance:GetMyProfessionTypeBranch()) > 0)
    elseif GameConfig.BattlePass.EquipPreview and GameConfig.BattlePass.EquipPreview[data.staticData.id] then
      self.showfpButton:SetActive(true)
    elseif data:GetComposeFashionTarget() ~= nil then
      self.showfpButton:SetActive(true)
    else
      self.showfpButton:SetActive(false)
    end
  end
  self:TryResetBtnGrid()
end

function ItemTipComCell:UpdateShowUpButton(data)
  local data = data or self.data
  if self.showUpButton then
    local isActive = false
    local showBtn = self.data and (self.data.showButton == "bag" or self.data.showButton == "equip")
    if showBtn then
      isActive = data and data.equipInfo and data.equipInfo:CanUpgrade() or false
    end
    if data and data:IsExtraction() then
      isActive = false
    end
    if FunctionUnLockFunc.CheckForbiddenByFuncState("equip_compose_forbidden") then
      isActive = false
    end
    self.showUpButton:SetActive(isActive)
    if isActive then
      local canUpgrade = data.equipInfo and data.equipInfo:CheckCanUpgradeSuccess(true)
      self.showUpButton_Symbol.color = canUpgrade and ItemTipSpriteGreenColor or ItemTipSpriteNormalColor
    end
  end
  self:TryResetBtnGrid()
end

function ItemTipComCell:TrySetShowUpBtnActive(isActive)
  if not self.showUpButton then
    return
  end
  self.showUpButton:SetActive(isActive and true or false)
  self:TryResetBtnGrid()
end

function ItemTipComCell:UpdateShowTpBtn()
  local id = self.data and self.data.staticData.id
  self:TrySetShowTpBtnActive(TicketPreview.IsTicket(id))
end

function ItemTipComCell:TrySetShowTpBtnActive(isActive)
  if not self.showTpBtn then
    return
  end
  self.showTpBtn:SetActive(isActive and true or false)
  self:TryResetBtnGrid()
end

function ItemTipComCell:SetDownTipText(tips)
  if self.tips then
    if tips and tips ~= "" then
      self.tips.gameObject:SetActive(true)
      self.tips.text = tips
    else
      self.tips.gameObject:SetActive(false)
    end
  end
  self:UpdateTipFunc()
end

function ItemTipComCell:HideGetPath()
  self:ActiveGetPath(false)
end

function ItemTipComCell:ActiveGetPath(b)
  if self.getPathBtn then
    self.getPathBtn.gameObject:SetActive(b)
  end
  self:TryResetBtnGrid()
end

function ItemTipComCell:UpdateGetPathBtn(data)
  ItemTipComCell.super.UpdateGetPathBtn(self, data)
  self:TryResetBtnGrid()
end

function ItemTipComCell:HidePreviewButton()
  if self.showfpButton then
    self.showfpButton.gameObject:SetActive(false)
  end
  self:TryResetBtnGrid()
end

function ItemTipComCell:ActiveBtns(bool)
  self.btnGrid.gameObject:SetActive(bool)
end

function ItemTipComCell:TryResetBtnGrid()
  if self.btnGrid then
    self.btnGrid:Reposition()
  end
end

local UseFuncKey = {
  Apply = 1,
  PutFood = 1,
  CombineTip = 1
}
local StoreFuncKey = {
  WthdrawnRepository = 1,
  PersonalWthdrawnRepository = 1,
  PutBackBarrow = 1,
  DepositRepository = 1,
  PersonalDepositRepository = 1,
  PutInBarrow = 1,
  HomeCompose = 1,
  HomeStoreIn = 1,
  HomeStoreOut = 1,
  PersonalArtifactIdentify = 1,
  PersonalArtifactPutIn = 1
}
local CombineFuncKey = {CombineTip = 1}
local itemTypeUseMaxNumberMap = {
  [55] = 20,
  [553] = GameConfig.PersonalArtifact.AppraisalItemCountMax
}

function ItemTipComCell:UpdateTipFunc(config)
  config = config or _EmptyTable
  if self.tips and 0 < #config then
    self.tips.gameObject:SetActive(false)
  end
  local funcDatas = ReusableTable.CreateArray()
  self.hasUseFunc = false
  self.hasStoreFunc = false
  self.hasCombineFunc = false
  for i = 1, #config do
    local cfgid = config[i]
    local cfgdata = GameConfig.ItemFunction[cfgid]
    if cfgdata then
      local state = FunctionItemFunc.Me():CheckFuncState(cfgdata.type, self.data)
      if state == ItemFuncState.Active or state == ItemFuncState.Grey then
        if UseFuncKey[cfgdata.type] then
          local sid = self.data and self.data.staticData.id
          local useItemData = sid and Table_UseItem[sid]
          if useItemData == nil or useItemData.UseInterval == nil and useItemData.UseEffect.type ~= "selectreward" then
            self.hasUseFunc = true
          end
        elseif StoreFuncKey[cfgdata.type] then
          self.hasStoreFunc = true
        end
        if CombineFuncKey[cfgdata.type] then
          self.hasCombineFunc = true
        end
        local data = {
          itemData = self.data,
          name = cfgdata.name,
          type = cfgdata.type,
          callback = FunctionItemFunc.Me():GetFuncById(cfgid),
          callbackParam = self.data,
          childFunction = cfgdata.childFunction,
          childFunction_Tip = cfgdata.childFunction_Tip
        }
        table.insert(funcDatas, data)
      end
    end
  end
  self:UpdateTipButtons(funcDatas)
  ReusableTable.DestroyAndClearArray(funcDatas)
  local d = self.data
  if self.hasStoreFunc then
    local useMaxNumber = itemTypeUseMaxNumberMap[d.staticData.Type]
    self:UpdateCountChooseBord(useMaxNumber or d.staticData.MaxNum)
    self:SetChooseCount(d.num)
  else
    self:UpdateCountChooseBord(nil, self.hasCombineFunc)
    self:SetChooseCount(1)
  end
  self.LockRoot:SetActive(false)
  self.LockDes.gameObject:SetActive(false)
end

function ItemTipComCell:UpdateCustomTipFunc(customCfg)
  if not customCfg then
    return
  end
  self.funcDatas = nil
  local needCountChoose, hasStoreFunc
  local insertData = function(cfg)
    self:AddTipFunc(cfg.name, cfg.callback, cfg.callbackParam, cfg.noClose, cfg.inactive, cfg.btnStyle)
    if cfg.needCountChoose then
      needCountChoose = true
    end
    if cfg.hasStoreFunc then
      hasStoreFunc = true
    end
  end
  if customCfg[1] then
    for i = 1, #customCfg do
      insertData(customCfg[i])
    end
  else
    insertData(customCfg)
  end
  local d = self.data
  self.hasUseFunc = needCountChoose or false
  self.hasStoreFunc = hasStoreFunc or false
  if needCountChoose or hasStoreFunc then
    local useMaxNumber = itemTypeUseMaxNumberMap[d.staticData.Type]
    self:UpdateCountChooseBord(useMaxNumber or customCfg.customCount or d.staticData.MaxNum)
    self:SetChooseCount(hasStoreFunc and d.num or 1)
  else
    self:UpdateCountChooseBord()
  end
end

function ItemTipComCell:UpdateTipButtons(funcDatas)
  self.funcDatas = funcDatas
  local n = #funcDatas
  self.hasFunc = 0 < n
  if self.func then
    if self.hasFunc then
      local style
      if n == 1 then
        style = self.func.style[1]
      elseif n == 2 then
        style = self.func.style[2]
      elseif 2 < n then
        style = self.func.style[3]
      end
      for i = 1, 3 do
        self.func.style[i].obj:SetActive(style == self.func.style[i])
      end
      for i = 1, #style.button do
        style.button[i]:SetData(funcDatas[i])
      end
    else
      for i = 1, 3 do
        self.func.style[i].obj:SetActive(false)
      end
    end
  end
  self:UpdateBgHeight()
end

function ItemTipComCell:UpdateBgHeight()
  local height = 560
  if self.refreshTip_GO and self.refreshTip_GO.activeInHierarchy then
    height = height + 22
  end
  if self.hasFunc and self.bottomBtns and self.bottomBtns.activeSelf or self.tips and self.tips.gameObject.activeInHierarchy then
    height = height + 74
  end
  self.bg.height = height
end

function ItemTipComCell:SetDelTimeTip(isShow)
  if Slua.IsNull(self.bottomBtns) then
    return
  end
  if self.hasStoreFunc then
    return
  end
  self.bottomBtns:SetActive(true)
  if not Slua.IsNull(self.refreshTip_GO) then
    self.refreshTip_GO.gameObject:SetActive(false)
    TimeTickManager.Me():ClearTick(self, 1)
  end
  local data = self.data
  local cttime
  if data then
    local useItemData = Table_UseItem[data.staticData.id]
    if useItemData and useItemData.UseInterval then
      local usedtime = data.usedtime or 0
      cttime = usedtime + useItemData.UseInterval
    else
      cttime = data.deltime
    end
  end
  if isShow and cttime and cttime * 1000 > ServerTime.CurServerTime() then
    self.bottomBtns.transform.localPosition = LuaGeometry.GetTempVector3(0, -298, 0)
    if not Slua.IsNull(self.refreshTip_GO) then
      self.refreshTip_GO.gameObject:SetActive(true)
    end
    TimeTickManager.Me():CreateTick(0, 1000, self.UpdateDelTimeTip, self, 1)
  else
    self.bottomBtns.transform.localPosition = LuaGeometry.GetTempVector3(0, -277, 0)
    if not Slua.IsNull(self.refreshTip_GO) then
      self.refreshTip_GO.gameObject:SetActive(false)
    end
    TimeTickManager.Me():ClearTick(self, 1)
    local existTimeType = self.data and self.data.staticData and self.data.staticData.ExistTimeType
    if existTimeType == 3 and data.deltime ~= nil and data.deltime ~= 0 then
      if not Slua.IsNull(self.refreshTip_GO) then
        self.refreshTip_GO.gameObject:SetActive(true)
      end
      self.bottomBtns:SetActive(false)
      self.refreshTip.text = ZhString.ItemTip_InvalidTip
    end
  end
  self:UpdateBgHeight()
end

function ItemTipComCell:UpdateDelTimeTip()
  local data = self.data
  local tip
  local cttime = 0
  if data then
    local useItemData = Table_UseItem[data.staticData.id]
    if useItemData and useItemData.UseInterval then
      cttime = data.usedtime + useItemData.UseInterval
      tip = ZhString.ItemTip_IntervalUseTip
    else
      cttime = data.deltime
    end
  end
  local existTimeType = self.data and self.data.staticData and self.data.staticData.ExistTimeType
  if existTimeType == 3 then
    tip = ZhString.ItemTip_InvalidRefreshTip
  end
  if tip == nil then
    tip = ZhString.ItemTip_DelRefreshTip
  end
  local deltaTime = cttime - ServerTime.CurServerTime() / 1000
  if deltaTime < 0 then
    self:SetDelTimeTip(false)
  elseif data.bagtype == BagProxy.BagType.Temp then
    local leftDay, leftHour, leftMin, leftSec = ClientTimeUtil.FormatTimeBySec(deltaTime)
    local leftTimeStr = string.format("%02d:%02d:%02d", leftDay * 24 + leftHour, leftMin, leftSec)
    self.refreshTip.text = string.format(tip, leftTimeStr)
  else
    local leftTimeTip = ""
    local leftDay, leftHour, leftMin, leftSec = ClientTimeUtil.FormatTimeBySec(deltaTime)
    if 86400 < deltaTime then
      leftTimeTip = string.format("%s%s%s%s", leftDay, ZhString.ItemTip_DelRefreshTip_Day, leftHour, ZhString.ItemTip_DelRefreshTip_Hour)
    elseif 3600 < deltaTime and deltaTime <= 86400 then
      leftTimeTip = string.format("%s%s%s%s", leftHour, ZhString.ItemTip_DelRefreshTip_Hour, leftMin, ZhString.ItemTip_DelRefreshTip_Min)
    elseif 60 < deltaTime and deltaTime <= 3600 then
      leftTimeTip = string.format("%s%s%s%s", leftMin, ZhString.ItemTip_DelRefreshTip_Min, leftSec, ZhString.ItemTip_DelRefreshTip_Sec)
    elseif deltaTime <= 60 then
      leftTimeTip = string.format("%s%s", leftSec, ZhString.ItemTip_DelRefreshTip_Sec)
    end
    self.refreshTip.text = string.format(tip, leftTimeTip)
  end
end

function ItemTipComCell:UpdateCountChooseBord(useMaxNumber, isCombine)
  if not self.countChooseBord or not self.data then
    return
  end
  if self.hasStoreFunc == true then
    self:ActiveCountChooseBord(true, useMaxNumber)
    return
  end
  if self.hasUseFunc == false and self.hasCombineFunc == false then
    self:ActiveCountChooseBord(false)
    return
  end
  if not useMaxNumber then
    local typeData = Table_ItemType[self.data.staticData.Type]
    useMaxNumber = typeData and typeData.UseNumber
    if not useMaxNumber then
      local useItemData = Table_UseItem[self.data.staticData.id]
      useMaxNumber = useItemData and useItemData.UseMultiple
    end
  end
  if not useMaxNumber and isCombine then
    self.countChooseIgnoreItemNumLimit = isCombine
    useMaxNumber = FunctionItemFunc._GetCombineMaxNum(self.data.staticData.id)
  end
  if useMaxNumber and 1 < useMaxNumber then
    self:ActiveCountChooseBord(true, useMaxNumber)
    self:UpdateCountChooseBordButton()
  else
    self:ActiveCountChooseBord(false)
  end
end

function ItemTipComCell:UpdateNoneItemTipCountChooseBord(useMaxNumber)
  if useMaxNumber and 0 < useMaxNumber then
    self:ActiveCountChooseBord(true, useMaxNumber)
    self:UpdateCountChooseBordButton()
  else
    self:ActiveCountChooseBord(false)
  end
end

function ItemTipComCell:AddTipFunc(funcname, callback, callbackParam, noClose, inactive, btnStyle)
  local data = {
    name = funcname,
    itemData = self.data,
    noClose = noClose,
    callback = callback,
    callbackParam = callbackParam,
    inactive = inactive,
    btnStyle = btnStyle
  }
  if self.funcDatas == nil then
    self.funcDatas = {}
  end
  table.insert(self.funcDatas, data)
  self:UpdateTipButtons(self.funcDatas)
end

local pixelDefaultOffset = {-11, 239}

function ItemTipComCell:ShowSecendFunc(funcConfig, title, parent, widget, side, pixelOffset)
  if self.itemSecendFuncBord == nil then
    self.itemSecendFuncBord = ItemSecendFuncBord.new()
    side = side or NGUIUtil.AnchorSide.TopRight
    pixelOffset = pixelOffset or pixelDefaultOffset
    self.itemSecendFuncBord:OnCreate(parent, widget, side, pixelOffset)
    self.itemSecendFuncBord:AddEventListener(MouseEvent.MouseClick, self.ClickSecendFunc, self)
    self.itemSecendFuncBord:AddEventListener(ItemSecendFuncEvent.Close, self.CloseSecendBord, self)
  end
  self.itemSecendFuncBord:SetData(funcConfig, self.data)
  if title then
    self.itemSecendFuncBord:SetTitle(title)
  end
end

function ItemTipComCell:ClickSecendFunc(data)
  local tipfunc = FunctionItemFunc.Me():GetFunc(data.type)
  if tipfunc then
    tipfunc(self.data, self.chooseCount)
    self:PassEvent(ItemTipEvent.ClickTipFuncEvent)
  end
end

function ItemTipComCell:CloseSecendBord()
  if self.itemSecendFuncBord then
    self.itemSecendFuncBord:OnDestroy()
    self.itemSecendFuncBord = nil
  end
end

function ItemTipComCell:Exit()
  local funcStyle = self.func and self.func.style
  if funcStyle then
    local buttons
    for i = 1, #funcStyle do
      buttons = funcStyle[i] and funcStyle[i].button
      if buttons then
        for j = 1, #buttons do
          buttons[j]:OnCellDestroy()
        end
      end
    end
  end
  self:SetClickBgFunc(nil)
  ItemTipComCell.super.Exit(self)
  if self.func then
    TableUtility.TableClear(self.func)
  end
  self:SetDelTimeTip(false)
  self:CloseSecendBord()
end

function ItemTipComCell:OnFavoriteClick()
  if not self.data then
    LogUtility.Error("Cannot find item data while marking item as favorite.")
    return
  end
  local msgId = BagProxy.Instance:CheckIsFavorite(self.data) and 32001 or 32000
  if not LocalSaveProxy.Instance:GetDontShowAgain(msgId) then
    self:PassEvent(ItemTipEvent.ConfirmMsgShowing, true)
    MsgManager.DontAgainConfirmMsgByID(msgId, function()
      self:NegateFavorite()
      self:PassEvent(ItemTipEvent.ConfirmMsgShowing, false)
    end, function()
      self:PassEvent(ItemTipEvent.ConfirmMsgShowing, false)
    end)
  else
    self:NegateFavorite()
  end
end

function ItemTipComCell:UpdateFavorite()
  if not self:CheckIfCanActiveFavoriteButton() then
    return
  end
  if not self.favoriteSp then
    return
  end
  self.favoriteSp.color = BagProxy.Instance:CheckIsFavorite(self.data) and ItemTipSpriteActivatedColor or ItemTipSpriteNormalColor
end

function ItemTipComCell:TrySetFavoriteButtonActive(isActive)
  if self:CheckIfCanActiveFavoriteButton() then
    self.favoriteButton:SetActive(isActive and true or false)
  end
end

function ItemTipComCell:CheckIfCanActiveFavoriteButton()
  if not self.favoriteButton then
    return false
  end
  if not self.data or self.data.staticData.Type == 65 then
    self.favoriteButton:SetActive(false)
    return false
  end
  return true
end

function ItemTipComCell:NegateFavorite()
  if not self.data then
    LogUtility.Error("Cannot negate favorite of item while item data == nil!")
    return
  end
  BagProxy.Instance:TryNegateFavoriteOfItem(self.data)
end

local MaxBattletime = GameConfig.Tutor.tutor_vip_max_battletime

function ItemTipComCell:HandleBattleTime(note)
  if not self.data then
    return
  end
  local count = self.chooseCount or 1
  if note and note.body and BagProxy.Instance.callBattletime then
    local data = note.body
    if data.tutortime then
      if self.data:GetUseEffectTime() * count + data.tutortime > MaxBattletime and data.tutortime < MaxBattletime then
        MsgManager.ConfirmMsgByID(39012, function()
          FunctionItemFunc.DoUseItem(self.data, nil, count)
        end, nil, nil)
        BagProxy.Instance.callBattletime = false
      else
        FunctionItemFunc.DoUseItem(self.data, nil, count)
        BagProxy.Instance.callBattletime = false
      end
    end
  end
end

function ItemTipComCell:UpdateHelpInfoButton()
  if self.helpInfoButton then
    local isActive = self.data ~= nil and ItemTipBaseCell.ShowHelpInfoPredicate(self.data.staticData.id)
    self.helpInfoButton:SetActive(isActive)
    if self.typeLabel then
      self.typeLabel.rightAnchor.absolute = isActive and -40 or 0
    end
  end
end

function ItemTipComCell:SetClickBgFunc(func)
  self.funcClickBg = func
end

function ItemTipComCell:OnDestroy()
  ItemTipComCell.super.OnDestroy(self)
end

function ItemTipComCell:OnClickItem(cellCtl)
  local d = cellCtl.data
  if not d then
    self:ShowItemTip()
  else
    local sdata = {
      itemdata = d,
      ignoreBounds = {
        cellCtl.gameObject
      },
      hideGetPath = true
    }
    self:ShowItemTip(sdata, cellCtl:GetBgSprite(), NGUIUtil.AnchorSide.Right, {-200, 0})
  end
end

function ItemTipComCell:TrySetCloseBtn(bool)
  if self.closeBtn then
    self.closeBtn:SetActive(bool)
  end
end

function ItemTipComCell:UpdateGiftDetailButton()
  if self.giftDetailBtn then
    local itemType = self.data and self.data.staticData and self.data.staticData.Type
    self.giftDetailBtn:SetActive(itemType == 30 and not self.cardPreviewBtn.gameObject.activeSelf and not GameConfig.SystemForbid.GiftDetail)
  end
  self:TryResetBtnGrid()
end
