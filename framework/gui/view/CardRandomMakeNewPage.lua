autoImport("CardBagCardSubPage")
autoImport("CardRandomMakeMaterialCell")
CardRandomMakeNewPage = class("CardRandomMakeNewPage", CardBagCardSubPage)
local skipType = SKIPTYPE.CardRandomMake
local maxCount = 150
local showCount = 15
local Prefab_Path = ResourcePathHelper.UIView("CardRandomMakeNewPage")

function CardRandomMakeNewPage:Init(initParam)
  CardMakeProxy.Instance:InitRandomCard()
  CardRandomMakeNewPage.super.Init(self, initParam)
  self.skipType = skipType
end

function CardRandomMakeNewPage:LoadPrefab()
  local obj = self:LoadPreferb_ByFullPath(Prefab_Path, self.container.container, true)
  obj.name = "CardRandomMakeNewPage"
  self.gameObject = obj
end

function CardRandomMakeNewPage:FindObjs()
  CardRandomMakeNewPage.super.FindObjs(self)
  self.choosedCardScrollView = self:FindComponent("CardScrollView", UIScrollView)
  local cardWrapContainer = self:FindGO("CardWrapContainer")
  self.choosedCardsCtl = WrapListCtrl.new(cardWrapContainer, BagCardCell, "BagCardCell", WrapListCtrl_Dir.Vertical, 3, 142)
  self.choosedCardsCtl:AddEventListener(MouseEvent.MouseClick, self.ClickChoosedCard, self)
  local materialGrid = self:FindComponent("MaterialGrid", UIGrid)
  self.materialListCtrl = UIGridListCtrl.new(materialGrid, CardRandomMakeMaterialCell, "CardRandomMakeMaterialCell")
  self.materialListCtrl:AddEventListener(MouseEvent.MouseClick, self.HandleMaterialTip, self)
  self.confirmButton = self:FindComponent("ConfirmButton", UIMultiSprite)
  self.confirmCollider = self.confirmButton:GetComponent(BoxCollider)
  self.confirmLabel = self:FindComponent("Label", UILabel, self.confirmButton.gameObject)
  self:AddClickEvent(self.confirmButton.gameObject, function()
    self:Confirm()
  end)
  self.costLabel = self:FindComponent("cost", UILabel)
  self.costIcon = self:FindGO("CoinIcon"):GetComponent(UISprite)
  IconManager:SetItemIcon(Table_Item[100].Icon, self.costIcon)
  self.remainLabel = self:FindComponent("remainNum", UILabel)
end

function CardRandomMakeNewPage:InitMaterial()
end

function CardRandomMakeNewPage:GetFilters()
  return GameConfig.CardMake.RandomFilter
end

function CardRandomMakeNewPage:OnEnter()
  self:UpdateRemainNum()
end

function CardRandomMakeNewPage:OnExit()
  CardRandomMakeNewPage.super.OnExit(self)
end

function CardRandomMakeNewPage:GetFilterCardsByFilterData(filterData)
  return CardMakeProxy.Instance:FilterRandomCardByQualities(filterData)
end

function CardRandomMakeNewPage:UpdateChooseCards(isLayout)
  self:ResetFilterCards()
  self.bagCardsListCtl:ResetDatas(self.filterCardDatas, isLayout)
  self.choosedCardsCtl:ResetDatas(self.choosedCardDatas)
  self.canMake = self:CheckCanMake()
  local materialList = {}
  local cost = 0
  if self.canMake then
    cost = CardMakeProxy.Instance:GetRandomMakeMaterialItemData(self.choosedCardDatas, materialList)
  else
    table.insert(materialList, ItemData.new("RandomMakeItem", GameConfig.CardMake.RandomMakeItemId))
  end
  self.materialListCtrl:ResetDatas(materialList)
  self.costLabel.text = cost
  self.cost = cost
  self:SetConfirm(not self.canMake)
end

function CardRandomMakeNewPage:AddChoosedCards(data, num)
  if data == nil or num == 0 then
    return
  end
  local emptyCards = {}
  for i = 1, #self.choosedCardDatas do
    local choosedData = self.choosedCardDatas[i]
    if choosedData == BagItemEmptyType.Empty then
      emptyCards[#emptyCards + 1] = i
    end
  end
  local emptyNum = #emptyCards
  local count = math.min(num, emptyNum)
  for i = 1, count do
    local cData = data:Clone()
    cData.num = 1
    local emptyIndex = emptyCards[i]
    self.choosedCardDatas[emptyIndex] = cData
  end
  local remainNum = 0
  if num > emptyNum then
    local choosedNum = #self.choosedCardDatas
    remainNum = math.min(maxCount - choosedNum, num - emptyNum)
    for i = 1, remainNum do
      local cData = data:Clone()
      cData.num = 1
      table.insert(self.choosedCardDatas, cData)
    end
  end
  local spaceCount = num < emptyNum and num or emptyNum + remainNum
  if self.choosedCardIdsMap[data.id] == nil then
    self.choosedCardIdsMap[data.id] = spaceCount
  else
    self.choosedCardIdsMap[data.id] = spaceCount + self.choosedCardIdsMap[data.id]
  end
  local curIndex = #self.choosedCardDatas
  local maxRowCount = self.choosedCardsCtl.cellNum
  local curRow = math.floor(curIndex / self.choosedCardsCtl.cellChildNum) - 1
  self.choosedCardScrollView:SetDragAmount(0, math.clamp(curRow / maxRowCount, 0, 1), false)
  self:UpdateChooseCards()
  if num > spaceCount then
    MsgManager.ShowMsgByIDTable(244)
  end
end

function CardRandomMakeNewPage:RemoveChoosedCards(data, removeNum)
  if data == nil or data == BagItemEmptyType.Empty then
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
      self.choosedCardDatas[i] = BagItemEmptyType.Empty
      choosedNum = choosedNum - 1
      removeNum = removeNum - 1
      if choosedNum == 0 or removeNum == 0 then
        break
      end
    end
  end
  for i = #self.choosedCardDatas, 1, -1 do
    if self.choosedCardDatas[i] ~= BagItemEmptyType.Empty then
      break
    end
    self.choosedCardDatas[i] = nil
  end
  if choosedNum == 0 then
    self.choosedCardIdsMap[did] = nil
  else
    self.choosedCardIdsMap[did] = choosedNum
  end
  self:UpdateChooseCards()
end

local tableFindKey = TableUtility.TableFindKey
local CheckConfirm = function(datas)
  if datas == nil then
    return false
  end
  local config = GameConfig.Card.confirm_quality
  local quality
  for i = 1, #datas do
    if datas[i] ~= BagItemEmptyType.Empty then
      quality = datas[i].staticData.Quality
      if tableFindKey(config, quality) then
        return true
      end
    end
  end
  return false
end

function CardRandomMakeNewPage:Confirm()
  FunctionSecurity.Me():CardCompose(function()
    self:_Confirm()
  end)
end

function CardRandomMakeNewPage:_Confirm()
  if self.canMake then
    if MyselfProxy.Instance:GetROB() < self.cost then
      MsgManager.ShowMsgByID(1)
      return
    end
    if CheckConfirm(self.choosedCardDatas) then
      local id = 43280
      local dont = LocalSaveProxy.Instance:GetDontShowAgain(id)
      if dont == nil then
        MsgManager.DontAgainConfirmMsgByID(id, function()
          self:CallExchangeCardItem()
        end)
      else
        self:CallExchangeCardItem()
      end
    else
      self:CallExchangeCardItem()
    end
  end
end

function CardRandomMakeNewPage:CallExchangeCardItem()
  local list = {}
  for i = 1, #self.choosedCardDatas, 3 do
    if self.choosedCardDatas[i] ~= BagItemEmptyType.Empty and self.choosedCardDatas[i + 1] and self.choosedCardDatas[i + 1] ~= BagItemEmptyType.Empty and self.choosedCardDatas[i + 2] and self.choosedCardDatas[i + 2] ~= BagItemEmptyType.Empty then
      for j = i, i + 2 do
        list[#list + 1] = self.choosedCardDatas[j].id
      end
    end
  end
  local skipValue = CardMakeProxy.Instance:IsSkipGetEffect(skipType)
  ServiceItemProxy.Instance:CallExchangeCardItemCmd(CardMakeProxy.MakeType.Random, self.container.npcId, list, nil, nil, not skipValue)
end

function CardRandomMakeNewPage:CheckCanMake()
  for i = 1, #self.choosedCardDatas, 3 do
    if self.choosedCardDatas[i] ~= BagItemEmptyType.Empty and self.choosedCardDatas[i + 1] and self.choosedCardDatas[i + 1] ~= BagItemEmptyType.Empty and self.choosedCardDatas[i + 2] and self.choosedCardDatas[i + 2] ~= BagItemEmptyType.Empty then
      return true
    end
  end
  return false
end

function CardRandomMakeNewPage:GetMaxChooseCount()
  return maxCount
end

function CardRandomMakeNewPage:HandleItemUpdate()
  CardMakeProxy.Instance:InitRandomCard()
  TableUtility.ArrayClear(self.choosedCardDatas)
  TableUtility.TableClear(self.choosedCardIdsMap)
  self:UpdateChooseCards(true)
  self:UpdateRemainNum()
end

function CardRandomMakeNewPage:HandleMaterialTip(cell)
  local data = cell.data
  if data then
    local sdata = {
      itemdata = data,
      ignoreBounds = {
        cell.gameObject
      }
    }
    self:ShowItemTip(sdata, cell:GetBgSprite(), NGUIUtil.AnchorSide.Left, {-200, 0})
  end
end

function CardRandomMakeNewPage:UpdateRemainNum()
  local count = MyselfProxy.Instance:getVarValueByType(Var_pb.EVARTYPE_EXCHANGECARD_DRAWMAX) or 0
  local maxCount = GameConfig.Card.exchangecard_draw_max
  count = math.max(maxCount - count, 0)
  self.remainLabel.text = string.format(ZhString.CardMake_RandomRemainTip, count, maxCount)
end
