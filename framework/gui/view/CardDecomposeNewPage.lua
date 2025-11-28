autoImport("CardBagCardSubPage")
autoImport("CardDecomposeMaterialCell")
CardDecomposeNewPage = class("CardDecomposeNewPage", CardBagCardSubPage)
local skipType = SKIPTYPE.CardDecompose
local Prefab_Path = ResourcePathHelper.UIView("CardDecomposeNewPage")
local maxCount = 50

function CardDecomposeNewPage:Init(initParam)
  CardMakeProxy.Instance:InitDecomposeCard()
  CardDecomposeNewPage.super.Init(self, initParam)
  self.skipType = skipType
end

function CardDecomposeNewPage:LoadPrefab()
  local obj = self:LoadPreferb_ByFullPath(Prefab_Path, self.container.container, true)
  obj.name = "CardDecomposeNewPage"
  self.gameObject = obj
end

function CardDecomposeNewPage:FindObjs()
  CardDecomposeNewPage.super.FindObjs(self)
  self.emptyLabel = self:FindGO("EmptyLabel")
  self.materialRoot = self:FindGO("MaterialRoot")
  local materialGrid = self:FindComponent("MaterialGrid", UIGrid)
  self.materialCtl = UIGridListCtrl.new(materialGrid, CardDecomposeMaterialCell, "CardMakeMaterialCell")
  self.materialCtl:AddEventListener(MouseEvent.MouseClick, self.HandleMaterialTip, self)
  self.materialNum = self:FindComponent("MaterialNum", UILabel)
  self.totalCost = self:FindComponent("cost", UILabel)
  self.costIcon = self:FindGO("CoinIcon"):GetComponent(UISprite)
  IconManager:SetItemIcon(Table_Item[100].Icon, self.costIcon)
  self.choosedCardScrollView = self:FindComponent("CardScrollView", UIScrollView)
  self.cardWrapContainer = self:FindGO("CardWrapContainer")
  self.choosedCardsCtl = WrapListCtrl.new(self.cardWrapContainer, BagCardCell, "BagCardCell", WrapListCtrl_Dir.Vertical, 5, 95)
  self.choosedCardsCtl:AddEventListener(MouseEvent.MouseClick, self.ClickChoosedCard, self)
  self.confirmButton = self:FindComponent("ConfirmButton", UIMultiSprite)
  self.confirmCollider = self.confirmButton:GetComponent(BoxCollider)
  self:AddClickEvent(self.confirmButton.gameObject, function()
    self:Decompose()
  end)
  self.confirmLabel = self:FindComponent("Label", UILabel, self.confirmButton.gameObject)
end

function CardDecomposeNewPage:AddViewEvts()
  self:AddListenEvt(MyselfEvent.MyDataChange, self.UpdateTotalCost)
  self:AddListenEvt(ItemEvent.ItemUpdate, self.HandleItemUpdate)
  self:AddListenEvt(ServiceEvent.ItemExchangeCardItemCmd, self.HandleExchangeCardItem)
end

function CardDecomposeNewPage:InitMaterial()
  local material = self:LoadPreferb("cell/ItemCell", self.materialRoot)
  material.transform.localPosition = LuaGeometry.GetTempVector3(0, -171, 0)
  self.materialCell = ItemCell.new(material)
  self.materialCell:SetData(CardMakeProxy.Instance:GetDecomposeMaterialItemData())
  self.materialNum.text = string.format(ZhString.CardDecompose_Material, 0)
end

function CardDecomposeNewPage:GetFilters()
  return GameConfig.CardMake.DecomposeFilter
end

function CardDecomposeNewPage:GetMaxChooseCount()
  return maxCount
end

function CardDecomposeNewPage:OnEnter()
  CardDecomposeNewPage.super.OnEnter(self)
  self:UpdateChooseCards()
end

function CardDecomposeNewPage:OnExit()
  CardDecomposeNewPage.super.OnExit(self)
end

function CardDecomposeNewPage:GetFilterCardsByFilterData(filterData)
  return CardMakeProxy.Instance:FilterDecomposeCardByQualities(filterData)
end

function CardDecomposeNewPage:UpdateChooseCards(isLayout)
  self.emptyLabel:SetActive(#self.choosedCardDatas == 0)
  self.choosedCardsCtl:ResetDatas(self.choosedCardDatas)
  self.cardWrapContainer:SetActive(#self.choosedCardDatas > 0)
  self:ResetFilterCards()
  self.bagCardsListCtl:ResetDatas(self.filterCardDatas, isLayout)
  local decomposeCfg = GameConfig.Card.decompose_base
  local decomposeExtraItem = GameConfig.Card.CardDecompose
  local defaultDecomposeItem = GameConfig.Card.decompose_item_id
  local totalNum, singleNum, d = 0, 0
  local decomposeItemMap = {}
  for i = 1, #self.choosedCardDatas do
    d = self.choosedCardDatas[i]
    local cardConfig = Table_Card[d.staticData.id]
    local cardType = cardConfig and cardConfig.ComposeCardType or 0
    local itemId = defaultDecomposeItem
    totalNum = decomposeItemMap[itemId] and decomposeItemMap[itemId].num or 0
    singleNum = decomposeCfg[d.staticData.Quality] or 0
    totalNum = totalNum + singleNum * d.num
    decomposeItemMap[itemId] = decomposeItemMap[itemId] or {}
    decomposeItemMap[itemId].num = totalNum
    local extraItems = decomposeExtraItem and decomposeExtraItem[cardType] and decomposeExtraItem[cardType].extra_decompose_items
    if extraItems and 0 < #extraItems then
      for j = 1, #extraItems do
        local extraItemId = extraItems[j][1]
        totalNum = decomposeItemMap[extraItemId] and decomposeItemMap[extraItemId].num or 0
        singleNum = extraItems[j][2]
        totalNum = totalNum + singleNum * d.num
        decomposeItemMap[extraItemId] = decomposeItemMap[extraItemId] or {}
        decomposeItemMap[extraItemId].num = totalNum
        decomposeItemMap[extraItemId].isExtra = true
      end
    elseif cardType == 3 then
      itemId = 52838
      totalNum = decomposeItemMap[itemId] and decomposeItemMap[itemId].num or 0
      local cardLv = d.cardLv or 0
      local singleNum, decimal = ItemFun.calcMvpCardDecomposeExtraCrystalCountAndRate(d.staticData.id, cardLv)
      totalNum = totalNum + singleNum * d.num
      decomposeItemMap[itemId] = decomposeItemMap[itemId] or {}
      decomposeItemMap[itemId].num = totalNum
      if decomposeItemMap[itemId].isExtra == nil then
        decomposeItemMap[itemId].isExtra = not decimal or decimal <= 0
      else
        local isExtra = decomposeItemMap[itemId].isExtra and (not decimal or decimal <= 0)
        decomposeItemMap[itemId].isExtra = isExtra
      end
    end
  end
  local decomposeItems = {}
  local i = 1
  for itemId, item in pairs(decomposeItemMap) do
    local data = CardMakeMaterialData.new({
      id = itemId,
      num = item.num,
      isExtra = item.isExtra
    }, i)
    TableUtility.ArrayPushBack(decomposeItems, data)
    i = i + 1
  end
  self.materialCtl:ResetDatas(decomposeItems)
  self:UpdateTotalCost()
  self:SetConfirm(#self.choosedCardDatas == 0 or not self:CheckEnoughMoney())
  self.materialCell.gameObject:SetActive(#self.choosedCardDatas == 0)
  self.materialNum.gameObject:SetActive(#self.choosedCardDatas == 0)
end

function CardDecomposeNewPage:Decompose()
  FunctionSecurity.Me():CardCompose(function()
    self:_Decompose()
  end)
end

local tableFindKey = TableUtility.TableFindKey
local CheckConfirm = function(datas)
  if datas == nil then
    return false
  end
  local config = GameConfig.Card.confirm_quality
  local quality
  for i = 1, #datas do
    quality = datas[i].staticData.Quality
    if tableFindKey(config, quality) then
      return true
    end
  end
  return false
end

function CardDecomposeNewPage:_Decompose()
  if #self.choosedCardDatas == 0 then
    return
  end
  if not self:CheckEnoughMoney() then
    MsgManager.ShowMsgByID(1)
    return
  end
  if CheckConfirm(self.choosedCardDatas) then
    local id = 1151
    local dont = LocalSaveProxy.Instance:GetDontShowAgain(id)
    if dont == nil then
      MsgManager.DontAgainConfirmMsgByID(id, function()
        self:CallDecompose()
      end)
    else
      self:CallDecompose()
    end
  else
    self:CallDecompose()
  end
end

function CardDecomposeNewPage:CallDecompose()
  local skipValue = CardMakeProxy.Instance:IsSkipGetEffect(skipType)
  local materialCards = ReusableTable.CreateArray()
  for i = 1, #self.choosedCardDatas do
    table.insert(materialCards, self.choosedCardDatas[i].id)
  end
  ServiceItemProxy.Instance:CallExchangeCardItemCmd(CardMakeProxy.MakeType.Decompose, self.container.npcId, materialCards, nil, nil, skipValue)
  ReusableTable.DestroyAndClearArray(materialCards)
end

function CardDecomposeNewPage:CheckEnoughMoney()
  local _CardConfig = GameConfig.Card
  local priceId = _CardConfig.decompose_price_id
  local money = HappyShopProxy.Instance:GetItemNum(priceId)
  local cost = self:GetTotalCost()
  if money >= cost then
    return true
  end
  return false
end

function CardDecomposeNewPage:UpdateTotalCost()
  local totalCost = self:GetTotalCost()
  self.totalCost.text = StringUtil.NumThousandFormat(totalCost)
  if self:CheckEnoughMoney() then
    ColorUtil.DeepGrayUIWidget(self.totalCost)
  else
    ColorUtil.RedLabel(self.totalCost)
  end
end

function CardDecomposeNewPage:GetTotalCost()
  local totalCost = 0
  local costConf = GameConfig.Card.CardDecompose
  local defaultCost = GameConfig.Card.decompose_price_count
  for i = 1, #self.choosedCardDatas do
    local d = self.choosedCardDatas[i]
    local cardConfig = Table_Card[d.staticData.id]
    local cardType = cardConfig and cardConfig.ComposeCardType or 0
    totalCost = totalCost + (costConf and costConf[cardType] and costConf[cardType].cost_price or defaultCost) * d.num
  end
  return totalCost
end

function CardDecomposeNewPage:HandleItemUpdate()
  CardMakeProxy.Instance:InitDecomposeCard()
  TableUtility.ArrayClear(self.choosedCardDatas)
  TableUtility.TableClear(self.choosedCardIdsMap)
  self:UpdateChooseCards(true)
end

function CardDecomposeNewPage:HandleMaterialTip(cell)
  local data = cell.data
  if data then
    self.tipData.itemdata = data
    self:ShowItemTip(self.tipData, cell.icon, NGUIUtil.AnchorSide.Left, {-220, 0})
  end
end
