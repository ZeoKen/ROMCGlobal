CardDecomposeView = class("CardDecomposeView", ContainerView)
autoImport("WrapListCtrl")
autoImport("BagCardCell")
CardDecomposeView.ViewType = UIViewType.NormalLayer
local skipType = SKIPTYPE.CardDecompose

function CardDecomposeView:Init()
  self:FindObjs()
  self:InitDeComposeView()
  self:AddEvts()
  self:AddViewEvts()
  self:InitShow()
end

function CardDecomposeView:FindObjs()
  self.itemRoot = self:FindGO("ItemRoot")
  self.materialRoot = self:FindGO("MaterialRoot")
  self.materialNum = self:FindGO("MaterialNum"):GetComponent(UILabel)
  self.totalCost = self:FindGO("TotalCost"):GetComponent(UILabel)
  self.chooseBord = self:FindGO("ChooseBord")
  self.filter = self:FindGO("Filter"):GetComponent(UIPopupList)
  self.skipBtn = self:FindGO("SkipBtn", self.chooseBord):GetComponent(UISprite)
  if BranchMgr.IsSEA() or BranchMgr.IsNA() or BranchMgr.IsEU() then
    self.tipLabel = self:FindGO("TipLabel"):GetComponent(UILabel)
    self.tipLabel.text = ZhString.CardDecomposeViewTitle
  end
end

function CardDecomposeView:InitDeComposeView()
  self.filterCardDatas = {}
  self.choosedCardDatas = {}
  self.choosedCardIdsMap = {}
  self.choosedCardsCtl = WrapListCtrl.new(self:FindGO("CardWrapContainer"), BagCardCell, "BagCardCell", WrapListCtrl_Dir.Vertical, 5, 95)
  self.choosedCardsCtl:AddEventListener(MouseEvent.MouseClick, self.ClickChoosedCard, self)
end

function CardDecomposeView:AddEvts()
  local closeButton = self:FindGO("CloseButton")
  self:AddClickEvent(closeButton, function()
    SceneUIManager.Instance:PlayerSpeak(self.npcId, ZhString.CardMark_EndDialog)
    self:CloseSelf()
  end)
  EventDelegate.Add(self.filter.onChange, function()
    if self.filter.data == nil then
      return
    end
    if self.filterData ~= self.filter.data then
      self.filterData = self.filter.data
      self:UpdateChooseCards()
    end
  end)
  self:AddClickEvent(self.skipBtn.gameObject, function()
    self:Skip()
  end)
  self:AddClickEvent(self.materialRoot, function()
    self.tipData.itemdata = self.materialCell.data
    self:ShowItemTip(self.tipData, self.materialCell.icon, NGUIUtil.AnchorSide.Left, {-220, 0})
  end)
  local decomposeBtn = self:FindGO("DecomposeBtn")
  self:AddClickEvent(decomposeBtn, function()
    self:Decompose()
  end)
  self:AddHelpButtonEvent()
end

function CardDecomposeView:AddViewEvts()
  self:AddListenEvt(MyselfEvent.MyDataChange, self.UpdateTotalCost)
  self:AddListenEvt(ItemEvent.ItemUpdate, self.HandleItemUpdate)
  self:AddListenEvt(ServiceEvent.ItemExchangeCardItemCmd, self.HandleExchangeCardItem)
end

function CardDecomposeView:InitShow()
  self.tipData = {}
  self.tipData.funcConfig = {}
  self.npcId = self.viewdata.viewdata.npcdata.data.id
  local wrapConfig = ReusableTable.CreateTable()
  wrapConfig.wrapObj = self:FindGO("Container")
  wrapConfig.pfbNum = 6
  wrapConfig.cellName = "EquipChooseCell"
  wrapConfig.control = EquipChooseCell
  wrapConfig.dir = 1
  self.bagCardsListCtl = WrapCellHelper.new(wrapConfig)
  self.bagCardsListCtl:AddEventListener(MouseEvent.MouseClick, self.ClickBagCard, self)
  self.bagCardsListCtl:AddEventListener(EquipChooseCellEvent.ClickItemIcon, self.ClickItemIcon, self)
  ReusableTable.DestroyAndClearTable(wrapConfig)
  local _CardConfig = GameConfig.Card
  local moneyIcon = self:FindGO("Sprite", self.totalCost.gameObject):GetComponent(UISprite)
  local money = Table_Item[_CardConfig.decompose_price_id]
  if money then
    IconManager:SetItemIcon(money.Icon, moneyIcon)
  end
  self:UpdateTotalCost()
  CardMakeProxy.Instance:InitDecomposeCard()
  self:InitFilter()
  self:InitMaterial()
  self:UpdateSkip()
end

function CardDecomposeView:InitFilter()
  self.filter:Clear()
  local decomposeFilter = GameConfig.CardMake.DecomposeFilter
  local rangeList = CardMakeProxy.Instance:GetFilter(decomposeFilter)
  for i = 1, #rangeList do
    local rangeData = decomposeFilter[rangeList[i]]
    self.filter:AddItem(rangeData, rangeList[i])
  end
  if 0 < #rangeList then
    local range = rangeList[1]
    self.filterData = range
    local rangeData = decomposeFilter[range]
    self.filter.value = rangeData
  end
end

function CardDecomposeView:InitMaterial()
  local material = self:LoadPreferb("cell/ItemCell", self.materialRoot)
  material.transform.localPosition = LuaGeometry.GetTempVector3(0, 0, 0)
  self.materialCell = ItemCell.new(material)
  self.materialCell:SetData(CardMakeProxy.Instance:GetDecomposeMaterialItemData())
end

function CardDecomposeView:UpdateSkip()
  local isShow = FunctionFirstTime.me:IsFirstTime(FunctionFirstTime.DecomposeCard)
  self.skipBtn.gameObject:SetActive(not isShow)
end

function CardDecomposeView:UpdateTotalCost()
  self.totalCost.text = StringUtil.NumThousandFormat(GameConfig.Card.decompose_price_count * #self.choosedCardDatas)
  if self:CheckEnoughMoney() then
    ColorUtil.DeepGrayUIWidget(self.totalCost)
  else
    ColorUtil.RedLabel(self.totalCost)
  end
end

function CardDecomposeView:ClickBagCard(cell)
  local data = cell.data
  if data == nil then
    self:ShowItemTip(nil)
    return
  end
  if data.num == 1 then
    self:AddChoosedCards(data, 1)
  else
    local showData = {
      itemdata = data,
      showUpTip = true,
      ignoreBounds = cell.gameObject,
      hideGetPath = true
    }
    
    function showData.callback()
      self.choosedBagData = nil
      self.tipActive = false
    end
    
    local itemTip = self:ShowItemTip(showData)
    local tipCell = itemTip:GetCell(1)
    tipCell:ActiveCountChooseBord(true)
    tipCell:AddTipFunc(ZhString.CardDecomposeView_PutCard, function(param, num)
      self:AddChoosedCards(data, num)
    end)
  end
end

function CardDecomposeView:ClickChoosedCard(cell)
  self:RemoveChoosedCards(cell.data, 1)
end

function CardDecomposeView:AddChoosedCards(data, num)
  if data == nil or num == 0 then
    return
  end
  local maxCount = 50
  local choosedCount = #self.choosedCardDatas
  local spaceCount = math.min(maxCount - choosedCount, num)
  if spaceCount <= 0 then
    MsgManager.ShowMsgByIDTable(244)
    return
  end
  if num > spaceCount then
    MsgManager.ShowMsgByIDTable(244)
  end
  if self.choosedCardIdsMap[data.id] == nil then
    self.choosedCardIdsMap[data.id] = spaceCount
  else
    self.choosedCardIdsMap[data.id] = spaceCount + self.choosedCardIdsMap[data.id]
  end
  for i = 1, spaceCount do
    local cData = data:Clone()
    cData.num = 1
    table.insert(self.choosedCardDatas, cData)
  end
  self:UpdateChooseCards()
end

function CardDecomposeView:RemoveChoosedCards(data, removeNum)
  if data == nil then
    return
  end
  if removeNum == 0 then
    return
  end
  local did = data.id
  local choosedNum = self.choosedCardIdsMap[did]
  if choosedNum == nil then
    return
  end
  for i = #self.choosedCardDatas, 1, -1 do
    if self.choosedCardDatas[i].id == did then
      table.remove(self.choosedCardDatas, i)
      choosedNum = choosedNum - 1
      removeNum = removeNum - 1
      if choosedNum == 0 or removeNum == 0 then
        break
      end
    end
  end
  if choosedNum == 0 then
    self.choosedCardIdsMap[did] = nil
  else
    self.choosedCardIdsMap[did] = choosedNum
  end
  self:UpdateChooseCards()
end

function CardDecomposeView:ClickItemIcon(cell)
  local data = cell.data
  if data ~= nil then
    self.tipData.itemdata = data
    self:ShowItemTip(self.tipData, cell.itemIconWidget, NGUIUtil.AnchorSide.Right, {220, 0})
  end
end

function CardDecomposeView:ResetChoosedCards()
  TableUtility.TableClear(self.choosedCardDatas)
  TableUtility.TableClear(self.choosedCardIdsMap)
  self:UpdateChooseCards()
end

function CardDecomposeView:ResetFilterCards()
  TableUtility.ArrayClear(self.filterCardDatas)
  local cardlistDatas = CardMakeProxy.Instance:FilterDecomposeCard(self.filterData)
  for i = 1, #cardlistDatas do
    local data = cardlistDatas[i]:Clone()
    local choosedNum = self.choosedCardIdsMap[data.id]
    if choosedNum then
      data.num = data.num - choosedNum
    end
    if data.num > 0 then
      table.insert(self.filterCardDatas, data)
    end
  end
end

function CardDecomposeView:UpdateChooseCards()
  self.itemRoot:SetActive(#self.choosedCardDatas > 0)
  self.choosedCardsCtl:ResetDatas(self.choosedCardDatas)
  self:ResetFilterCards()
  self.bagCardsListCtl:UpdateInfo(self.filterCardDatas)
  local decomposeCfg = GameConfig.Card.decompose_base
  local totalNum, singleNum, d = 0, 0
  for i = 1, #self.choosedCardDatas do
    d = self.choosedCardDatas[i]
    singleNum = decomposeCfg[d.staticData.Quality] or 0
    totalNum = totalNum + singleNum * d.num
  end
  self.materialNum.text = string.format(ZhString.CardDecompose_Material, totalNum)
  self:UpdateTotalCost()
end

function CardDecomposeView:Skip()
  TipManager.Instance:ShowSkipAnimationTip(skipType, self.skipBtn, NGUIUtil.AnchorSide.Right, {150, 0})
end

function CardDecomposeView:Decompose()
  FunctionSecurity.Me():CardCompose(function()
    self:_Decompose()
  end, arg)
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

function CardDecomposeView:_Decompose()
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

function CardDecomposeView:CallDecompose()
  local skipValue = CardMakeProxy.Instance:IsSkipGetEffect(skipType)
  local materialCards = ReusableTable.CreateArray()
  for i = 1, #self.choosedCardDatas do
    table.insert(materialCards, self.choosedCardDatas[i].id)
  end
  ServiceItemProxy.Instance:CallExchangeCardItemCmd(CardMakeProxy.MakeType.Decompose, self.npcId, materialCards, nil, nil, skipValue)
  ReusableTable.DestroyAndClearArray(materialCards)
end

function CardDecomposeView:CheckEnoughMoney()
  local _CardConfig = GameConfig.Card
  local priceId = _CardConfig.decompose_price_id
  local money = HappyShopProxy.Instance:GetItemNum(priceId)
  local cost = #self.choosedCardDatas * _CardConfig.decompose_price_count
  if money >= cost then
    return true
  end
  return false
end

function CardDecomposeView:HandleItemUpdate()
  CardMakeProxy.Instance:InitDecomposeCard()
  self:UpdateChooseCards()
end

function CardDecomposeView:HandleExchangeCardItem(note)
  local data = note.body
  if data ~= nil and data.charid == Game.Myself.data.id then
    self:CloseSelf()
  end
end

function CardDecomposeView:OnEnter()
  CardDecomposeView.super.OnEnter(self)
  self:UpdateChooseCards()
end

function CardDecomposeView:OnExit()
  CardDecomposeView.super.OnExit(self)
end
