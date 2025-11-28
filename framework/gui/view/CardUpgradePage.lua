autoImport("CardUpgradeCell")
autoImport("CardUpgradeMaterialCell")
autoImport("CardNCell")
autoImport("CardUpgradeData")
CardUpgradePage = class("CardUpgradePage", SubView)
CardUpgradePage.SortFilter = {
  [1] = ZhString.CardMake_NotOwned,
  [2] = ZhString.CardMake_Makeable
}
local _ArrayPushBack = TableUtility.ArrayPushBack
local _ArrayFindIndex = TableUtility.ArrayFindIndex
local _ArrayClear = TableUtility.ArrayClear
local _TableClear = TableUtility.TableClear
local _ArrayClearByDeleter = TableUtility.ArrayClearByDeleter
local Prefab_Path = ResourcePathHelper.UIView("CardUpgradePage")
local BgName = "preview_bg_figure_03"

function CardUpgradePage:Init(initParam)
  self:InitData(initParam)
  self:LoadPrefab()
  self:FindObjs()
  self:AddViewEvts()
  self:InitTitle()
  self.tipData = {}
  self.tipData.funcConfig = {}
end

function CardUpgradePage:InitData(initParam)
  self.tabIndex = initParam
  self.cardMap = {}
  self.filterCardList = {}
  self.lockedCardList = {}
  self.cardExpend = false
  self.upgradeCount = 1
  self:UpdateCardMap()
end

function CardUpgradePage:UpdateCardMap()
  if not Game.CardUpgradeMap then
    return
  end
  _TableClear(self.cardMap)
  local _bagProxy = BagProxy.Instance
  for id, v in pairs(Game.CardUpgradeMap) do
    local items = _bagProxy:GetItemsByStaticID(id)
    if items and 0 < #items then
      for i = 1, #items do
        local data = CardUpgradeData.new(items[i])
        self.cardMap[data.guid] = data
      end
    else
      local itemData = ItemData.new(id, id)
      local data = CardUpgradeData.new(itemData)
      self.cardMap[data.guid] = data
    end
  end
end

function CardUpgradePage:LoadPrefab()
  local obj = self:LoadPreferb_ByFullPath(Prefab_Path, self.container.container, true)
  obj.name = "CardUpgradePage"
  self.gameObject = obj
end

function CardUpgradePage:FindObjs()
  self.bgTex = self:FindComponent("TargetCardBg", UITexture)
  self.titleLabel = self:FindComponent("Title", UILabel)
  self.materialRoot = self:FindGO("MaterialRoot")
  self.targetName = self:FindComponent("TargetName", UILabel)
  self.confirmButton = self:FindComponent("ConfirmButton", UIMultiSprite)
  self.confirmCollider = self.confirmButton.gameObject:GetComponent(BoxCollider)
  self:AddClickEvent(self.confirmButton.gameObject, function()
    self:OnConfirm()
  end)
  self.confirmLabel = self:FindComponent("Label", UILabel, self.confirmButton.gameObject)
  self.cost = self:FindComponent("cost", UILabel)
  self.costIcon = self:FindGO("CoinIcon"):GetComponent(UISprite)
  IconManager:SetItemIcon(Table_Item[GameConfig.MoneyId.Zeny].Icon, self.costIcon)
  local container = self:FindGO("CardContainer")
  self.cardListCtrl = ListCtrl.new(container, CardUpgradeCell, "CardUpgradeCell")
  self.cardListCtrl:AddEventListener(MouseEvent.MouseClick, self.HandleClickCell, self)
  self.cardListCtrl:AddEventListener(MouseEvent.LongPress, self.HandleLongPress, self)
  local materialGrid = self:FindGO("MaterialGrid"):GetComponent(UIGrid)
  self.materialCtl = UIGridListCtrl.new(materialGrid, CardUpgradeMaterialCell, "CardUpgradeMaterialCell")
  self.materialCtl:AddEventListener(MouseEvent.MouseClick, self.HandleMaterialTip, self)
  local cardCellGO = self:FindGO("CardNNewCell")
  self.cardIcon = self:FindComponent("IconTex", UITexture, cardCellGO)
  self.loading = self:FindGO("Loading", cardCellGO)
  self.lockGO = self:FindGO("Lock", cardCellGO)
  self.curLvLabel = self:FindComponent("CurLevel", UILabel)
  self.nextLvLabel = self:FindComponent("NextLevel", UILabel)
  self.maxLvPreviewLabel = self:FindComponent("MaxLvPreview", UILabel)
  self.attrTable = self:FindComponent("AttrTable", UITable)
  self.attrLabels = {}
  self.attrLabelPfb = self:FindGO("LabelPfb")
  self.previewBtn = self:FindGO("PreviewBtn")
  self:AddClickEvent(self.previewBtn, function()
    self:OnPreview()
  end)
  self.previewIcon = self:FindComponent("Icon", UIMultiSprite, self.previewBtn)
  self.previewLvGO = self:FindGO("Label", self.previewBtn)
  self.previewLabel = self:FindComponent("Label2", UILabel, self.previewBtn)
  self.tipGO = self:FindGO("TipBg")
  self.tipLabel = self:FindComponent("TipLabel", UILabel, self.tipGO)
  self.cardCellSperate = self:FindGO("CardSperate")
  self.cardExpendBtn = self:FindGO("Sperate", self.cardCellSperate)
  self:AddClickEvent(self.cardExpendBtn, function()
    self:OnCardExpend()
  end)
  self.sperateArrow = self:FindComponent("Arrow", UISprite, self.cardCellSperate)
  self.lockedCardGrid = self:FindComponent("Grid", UIGrid, self.cardCellSperate)
  self.lockedCardListCtrl = UIGridListCtrl.new(self.lockedCardGrid, CardUpgradeCell, "CardUpgradeCell")
  self.lockedCardListCtrl:AddEventListener(MouseEvent.MouseClick, self.HandleClickCell, self)
  self.lockedCardListCtrl:AddEventListener(MouseEvent.LongPress, self.HandleLongPress, self)
  self.shareBtn = self:FindGO("ShareBtn")
  self:AddClickEvent(self.shareBtn, function()
    self:OnShare()
  end)
  self.effectContainer = self:FindGO("EffectContainer")
  self.discountBg = self:FindGO("DiscountBg")
  self.discountItemLabel = self:FindComponent("DiscountItem", UILabel)
  self.countdownLabel = self:FindComponent("Countdown", UILabel)
  self.materialCountdownLabel = self:FindComponent("MaterialCountdown", UILabel)
end

function CardUpgradePage:AddViewEvts()
end

function CardUpgradePage:InitTitle()
  local npcFunc = Table_NpcFunction[self.tabIndex]
  if npcFunc then
    self.titleLabel.text = npcFunc.NameZh
  end
end

function CardUpgradePage:HandleItemUpdate()
  self:UpdateCardMap()
  self:RefreshView()
end

function CardUpgradePage:InitFilter()
  local filters = self:GetFilters()
  self.filterTipData = {
    callback = self.FilterPropCallback,
    param = self,
    curCustomProps = nil,
    curPropData = nil,
    curKeys = nil,
    customTitle = ZhString.CardMake_PartTitle,
    customProps = filters
  }
  self:AddClickEvent(self.filterBtn, function()
    TipManager.Instance:ShowNewPropTypeTip(self.filterTipData, self.filterBtnSp, NGUIUtil.AnchorSide.AnchorSide, {90, -50})
  end)
end

function CardUpgradePage:InitSortFilter()
  self.sortFilter = self:FindComponent("SortPop", UIPopupList)
  EventDelegate.Add(self.sortFilter.onChange, function()
    self:OnSortChoose()
  end)
  self.sortFilter:Clear()
  local list = CardUpgradePage.SortFilter
  for i = 1, #list do
    self.sortFilter:AddItem(list[i], i)
  end
  local selectIndex = CardUpgradeProxy.Instance:GetSortFilterIndex() or 1
  self.sortFilter.value = list[selectIndex]
end

function CardUpgradePage:GetFilters()
  return GameConfig.CardMake.MakeFilter
end

function CardUpgradePage:OnEnter()
  self:RefreshView()
  PictureManager.Instance:SetUI(BgName, self.bgTex)
end

function CardUpgradePage:OnExit()
  PictureManager.Instance:UnLoadUI(BgName, self.bgTex)
  if self.assetname ~= nil then
    Game.AssetLoadEventDispatcher:RemoveEventListener(self.assetname, CardUpgradePage.LoadPicComplete, self)
    self.assetname = nil
  end
  if self.cardInfoName ~= nil then
    PictureManager.Instance:UnLoadCard(self.cardInfoName, self.cardIcon)
    self.cardInfoName = nil
  end
  self:ClearAttrLabels()
end

function CardUpgradePage:RefreshView()
  self.isDiscount, self.discountItem, self.discount = self:UpdateDiscount()
  self:UpdateCard()
  self:SelectCard()
end

function CardUpgradePage:FilterPropCallback(customProp, propData, keys)
  if self.filterTipData then
    self.filterTipData.curCustomProps = customProp
    self.filterTipData.curPropData = propData
    self.filterTipData.curKeys = keys
  end
  self:RefreshView()
end

function CardUpgradePage:OnSortChoose()
  if not self.sortFilter.data then
    return
  end
  local data = self.sortFilter.data
  local isOwned = data == 1
  local isMakeable = data == 2
  CardUpgradeProxy.Instance:SetSortParam(isOwned, isMakeable)
  self:RefreshView()
  CardUpgradeProxy.Instance:SetSortFilterIndex(data)
end

function CardUpgradePage:FilterCardByTypes(types)
  _ArrayClear(self.filterCardList)
  _ArrayClear(self.lockedCardList)
  if not types or #types == 0 then
    for k, v in pairs(self.cardMap) do
      if v:IsTimeValid() then
        if v:IsLocked() then
          _ArrayPushBack(self.lockedCardList, v)
        else
          _ArrayPushBack(self.filterCardList, v)
        end
      end
    end
  else
    for k, v in pairs(self.cardMap) do
      if v:IsTimeValid() and 0 < _ArrayFindIndex(types, v.itemData.staticData.Type) then
        if v:IsLocked() then
          _ArrayPushBack(self.lockedCardList, v)
        else
          _ArrayPushBack(self.filterCardList, v)
        end
      end
    end
  end
  self:SortCard()
end

local sortFunc = function(l, r)
  local cardCfgl = l.itemData.cardInfo
  local cardCfgr = r.itemData.cardInfo
  local posl = cardCfgl.Position
  local posr = cardCfgr.Position
  local levell = l.itemData.cardLv or 0
  local levelr = r.itemData.cardLv or 0
  local qualityl = 5 <= levell and 5 or l.itemData.staticData.Quality
  local qualityr = 5 <= levelr and 5 or r.itemData.staticData.Quality
  if posl == posr then
    if qualityl == qualityr then
      if levell == levelr then
        return l.itemData.staticData.id < r.itemData.staticData.id
      else
        return levell > levelr
      end
    else
      return qualityl > qualityr
    end
  else
    return posl < posr
  end
end

function CardUpgradePage:SortCard()
  table.sort(self.filterCardList, sortFunc)
  table.sort(self.lockedCardList, sortFunc)
end

function CardUpgradePage:UpdateCard()
  self:FilterCardByTypes()
  self.cardListCtrl:ResetDatas(self.filterCardList, nil, false)
  self.lockedCardListCtrl:ResetDatas(self.lockedCardList)
  self:LayoutCards()
end

local CellSpace = 10

function CardUpgradePage:LayoutCards()
  local cells = self.cardListCtrl:GetCells()
  local posY = 0
  for i = 1, #cells do
    local cell = cells[i]
    LuaGameObject.SetLocalPositionGO(cell.gameObject, 0, posY, 0)
    posY = posY - cell.height - CellSpace
  end
  self.cardCellSperate:SetActive(0 < #self.lockedCardList)
  LuaGameObject.SetLocalPositionGO(self.cardCellSperate, 0, posY + 31, 0)
  self.lockedCardGrid.gameObject:SetActive(self.cardExpend or false)
  self.sperateArrow.flip = self.cardExpend and 2 or 0
end

function CardUpgradePage:SelectCard()
  local cells = self.cardListCtrl:GetCells()
  local chooseCell = self:FindChooseCell(cells)
  if not chooseCell then
    cells = self.lockedCardListCtrl:GetCells()
    chooseCell = self:FindChooseCell(cells)
  end
  self:HandleClickCell(chooseCell)
end

function CardUpgradePage:FindChooseCell(cells)
  if not cells then
    return
  end
  local chooseCell
  for i = 1, #cells do
    local cell = cells[i]
    if cell.data.guid == self.chooseCardGuid then
      chooseCell = cell
      break
    end
  end
  chooseCell = chooseCell or cells[1]
  return chooseCell
end

function CardUpgradePage:UpdateMaterial()
  if not self.chooseCardData then
    return
  end
  local materials, zeny, isLack = self.chooseCardData:GetNextLvMaterials(self.isDiscount, self.discountItem, self.discount)
  if materials then
    self.materialCtl:ResetDatas(materials)
  end
  self.cost.text = StringUtil.NumThousandFormat(zeny)
  self:UpdateConfirmBtn(isLack)
end

function CardUpgradePage:UpdateCardAttrs(level)
  if not self.chooseCardData then
    return
  end
  self:ClearAttrLabels()
  local attrs = self.chooseCardData:GetAttrs(level)
  for i = 1, #attrs do
    local attr = attrs[i]
    local labelObj = self:CopyGameObject(self.attrLabelPfb)
    labelObj:SetActive(true)
    labelObj.name = string.format("AttrLabel%02d", i)
    self.attrLabels[i] = SpriteLabel.new(labelObj, nil, nil, nil, true, nil, "a0adc6")
    self.attrLabels[i]:SetText(attr)
  end
  self.attrTable:Reposition()
end

function CardUpgradePage:ClearAttrLabels()
  _ArrayClearByDeleter(self.attrLabels, function(label)
    local go = label.richLabel.gameObject
    label:Destroy()
    GameObject.DestroyImmediate(go)
  end)
end

function CardUpgradePage:UpdateConfirmBtn(isGray)
  self:SetConfirm(isGray)
end

function CardUpgradePage:UpdateInfo(isPreview)
  if not self.chooseCardData then
    return
  end
  local itemData = self.chooseCardData.itemData
  if not itemData then
    return
  end
  local isLocked = self.chooseCardData:IsLocked()
  self.lockGO:SetActive(isLocked)
  local itemId = itemData.staticData.id
  local cfg = Game.CardUpgradeMap and Game.CardUpgradeMap[itemId]
  if cfg then
    local maxLv = cfg[#cfg].Level
    local curLv = itemData.cardLv or 0
    local isMaxLv = maxLv <= curLv
    self.curLvLabel.gameObject:SetActive(not isMaxLv and not isPreview)
    self.maxLvPreviewLabel.gameObject:SetActive(isMaxLv or isPreview or false)
    self.tipGO:SetActive(isLocked or isMaxLv or isPreview or false)
    self.materialRoot:SetActive(not isLocked and not isMaxLv and not isPreview or false)
    self.previewBtn:SetActive(not isMaxLv)
    self.shareBtn:SetActive(isMaxLv and not isPreview)
    local tipStr = ""
    if isLocked then
      tipStr = ZhString.CardUpgrade_LockedTip
    elseif isMaxLv then
      tipStr = ZhString.CardUpgrade_MaxLvTip
    elseif isPreview then
      tipStr = ZhString.CardUpgrade_MaxLvPreviewTip
    end
    self.tipLabel.text = tipStr
    if isMaxLv then
      self.maxLvPreviewLabel.text = ZhString.CardUpgrade_MaxLv
      self.nextLvLabel.text = "+" .. curLv
    elseif isPreview then
      self.maxLvPreviewLabel.text = ZhString.CardUpgrade_MaxLvPreview
      self.nextLvLabel.text = "+" .. maxLv
    else
      self.curLvLabel.text = "+" .. curLv
      self.nextLvLabel.text = "+" .. curLv + 1
      self:UpdateMaterial()
    end
    self.previewLabel.text = isPreview and ZhString.CardUpgrade_CancelPreview or ZhString.CardUpgrade_MaxLvPreview
    self.previewIcon.CurrentState = isPreview and 0 or 1
    self.previewLvGO:SetActive(not isPreview)
    local attrLv = (isMaxLv or isPreview) and maxLv or curLv + 1
    self:UpdateCardAttrs(attrLv)
  end
end

function CardUpgradePage:HandleClickCell(cell)
  if not cell then
    return
  end
  self.chooseCardData = cell.data
  self.chooseCardGuid = self.chooseCardData.guid
  if self.chooseCardData then
    local itemData = self.chooseCardData.itemData
    self:SetTargetCard()
    self.targetName.text = itemData and itemData.staticData and itemData.staticData.NameZh or ""
    self:UpdateInfo(self.isPreview)
    cell:SetChoose(true)
    self:ClearOtherChoose(cell)
  end
end

function CardUpgradePage:ClearOtherChoose(cell)
  if not cell then
    return
  end
  local cells = self.cardListCtrl:GetCells()
  for i = 1, #cells do
    if cells[i] ~= cell then
      cells[i]:SetChoose(false)
    end
  end
  cells = self.lockedCardListCtrl:GetCells()
  for i = 1, #cells do
    if cells[i] ~= cell then
      cells[i]:SetChoose(false)
    end
  end
end

function CardUpgradePage:HandleLongPress(cell)
  local data = cell.data
  if data then
    self.tipData.itemdata = data.itemData
    self:ShowItemTip(self.tipData, cell.icon, NGUIUtil.AnchorSide.Right, {220, 0})
  end
end

function CardUpgradePage:OnPreview()
  self.isPreview = not self.isPreview
  self:UpdateInfo(self.isPreview)
end

local LoadingName = "card_loading"

function CardUpgradePage:SetTargetCard()
  if not self.chooseCardData then
    return
  end
  local itemData = self.chooseCardData.itemData
  if not itemData then
    return
  end
  local cardInfo = itemData.cardInfo
  if not cardInfo then
    return
  end
  if self.cardInfoName ~= nil and self.cardInfoName ~= cardInfo.Picture then
    PictureManager.Instance:UnLoadCard(self.cardInfoName, self.cardIcon)
    self.cardInfoName = nil
  end
  local _AssetLoadEventDispatcher = Game.AssetLoadEventDispatcher
  local assetname = _AssetLoadEventDispatcher:AddRequestUrl(ResourcePathHelper.ResourcePath(PictureManager.Config.Pic.Card .. cardInfo.Picture))
  if self.assetname ~= nil and self.assetname ~= assetname then
    _AssetLoadEventDispatcher:RemoveEventListener(self.assetname, CardUpgradePage.LoadPicComplete, self)
  end
  self.assetname = assetname
  if assetname ~= nil then
    _AssetLoadEventDispatcher:AddEventListener(assetname, CardUpgradePage.LoadPicComplete, self)
    self.cardInfoName = LoadingName
  else
    self.cardInfoName = cardInfo.Picture
  end
  PictureManager.Instance:SetCard(self.cardInfoName, self.cardIcon)
  self.loading:SetActive(assetname ~= nil)
end

function CardUpgradePage:LoadPicComplete(args)
  if args.success then
    self.loading:SetActive(false)
    if self.chooseCardData and self.chooseCardData.itemData and self.chooseCardData.itemData.cardInfo then
      self.cardInfoName = self.chooseCardData.itemData.cardInfo.Picture
      PictureManager.Instance:SetCard(self.cardInfoName, self.cardIcon)
    end
  end
end

function CardUpgradePage:SetConfirm(isGray)
  self.confirmCollider.enabled = not isGray
  if isGray then
    self.confirmButton.CurrentState = 1
    self.confirmLabel.effectStyle = UILabel.Effect.None
  else
    self.confirmButton.CurrentState = 0
    self.confirmLabel.effectStyle = UILabel.Effect.Outline
  end
end

function CardUpgradePage:HandleMaterialTip(cell)
  local data = cell.data
  if data then
    self.tipData.itemdata = data
    self:ShowItemTip(self.tipData, cell.icon, NGUIUtil.AnchorSide.Left, {-220, 0})
  end
end

function CardUpgradePage:OnCardExpend()
  self.cardExpend = not self.cardExpend
  self:LayoutCards()
end

function CardUpgradePage:OnConfirm()
  if not self.chooseCardData then
    return
  end
  local itemData = self.chooseCardData.itemData
  if not itemData then
    return
  end
  local isLocked = self.chooseCardData:IsLocked()
  if isLocked then
    return
  end
  local itemId = itemData.staticData.id
  local cfg = Game.CardUpgradeMap and Game.CardUpgradeMap[itemId]
  if not cfg then
    return
  end
  local curLv = itemData.cardLv or 0
  local maxLv = cfg[#cfg].Level
  if curLv >= maxLv then
    return
  end
  ServiceItemProxy.Instance:CallCardLevelupItemCmd(self.chooseCardData.guid, curLv + self.upgradeCount)
  local effectName = curLv + self.upgradeCount >= 5 and EffectMap.UI.CardUpgrade_Advanced or EffectMap.UI.CardUpgrade_Normal
  self:PlayUIEffect(effectName, self.effectContainer, true)
end

function CardUpgradePage:OnShare()
  if not self.chooseCardData then
    return
  end
  local item = self.chooseCardData.itemData
  local cardLv = item.cardLv or 0
  local shareLv = GameConfig.CardUpgrade and GameConfig.CardUpgrade.ShareLevel or 5
  if cardLv == shareLv then
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.CardUpgradeShareView,
      viewdata = {itemData = item}
    })
  end
end

function CardUpgradePage:UpdateDiscount()
  local actId = GameConfig.Card and GameConfig.Card.LevelUpActID
  local config = Table_ActPersonalTimer[actId]
  if config then
    local isTFBranch = EnvChannel.IsTFBranch()
    local startTimeStr = isTFBranch and config.TfStartTime or config.StartTime
    local endTimeStr = isTFBranch and config.TfEndTime or config.EndTime
    local startTime = ClientTimeUtil.GetOSDateTime(startTimeStr)
    local endTime = ClientTimeUtil.GetOSDateTime(endTimeStr)
    local curTime = ServerTime.CurServerTime() / 1000
    local discountItem = config.Misc and config.Misc.DiscountItem
    local dicountCount = config.Misc and config.Misc.DiscountCount or 0
    local discount = config.Misc and config.Misc.Discount or 1
    local usedDiscountCount = CardMakeProxy.Instance:GetCardUpgradeUsedDiscountCount(actId)
    local isActOpen = startTime and endTime and startTime <= curTime and endTime > curTime and dicountCount > usedDiscountCount
    self.discountBg:SetActive(isActOpen)
    self.materialCountdownLabel.gameObject:SetActive(isActOpen)
    if isActOpen then
      local itemConfig = Table_Item[discountItem]
      self.discountItemLabel.text = string.format(ZhString.CardUpgrade_DiscountItem, itemConfig and itemConfig.NameZh or "")
      local remainTime = endTime - curTime
      local day = math.floor(remainTime / 86400)
      local str = ""
      if 0 < day then
        str = string.format(ZhString.CardUpgrade_RemainDay, day)
      else
        local min = math.floor(remainTime / 60)
        local str = string.format(ZhString.CardUpgrade_RemainMin, min)
      end
      self.countdownLabel.text = string.format(ZhString.CardUpgrade_DiscountCountdown, str)
      self.materialCountdownLabel.text = string.format(ZhString.CardUpgrade_DiscountCountdown, str)
    end
    return isActOpen, discountItem, discount
  end
  return false, nil, 0
end
