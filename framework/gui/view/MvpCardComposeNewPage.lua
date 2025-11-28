autoImport("BossComposeCardCell")
autoImport("MvpCardComposeMaterialCell")
autoImport("CardMakeRateUpCell")
autoImport("BossCardComposeNewPage")
MvpCardComposeNewPage = class("MvpCardComposeNewPage", BossCardComposeNewPage)
local skipType = SKIPTYPE.MvpCardCompose
local Prefab_Path = ResourcePathHelper.UIView("MvpCardComposeNewPage")
local CardPartDefaultPosY = 240
local CardPartPosOffsetY = 52
local MaxComposeNum = 100

function MvpCardComposeNewPage:Init(initParam)
  self.makeType = CardMakeProxy.MakeType.MvpCardCompose
  self.upTimesVarType = Var_pb.EACCVARTYPE_BOSSCARD_MVPCOMPOSE_UPTIMES
  self.firstUpVarType = Var_pb.EACCVARTYPE_BOSSCARD_MVPCOMPOSE_UP_FIRST_CHANCE
  MvpCardComposeNewPage.super.Init(self, initParam)
  self.skipType = skipType
end

function MvpCardComposeNewPage:LoadPrefab()
  local obj = self:LoadPreferb_ByFullPath(Prefab_Path, self.container.container, true)
  obj.name = "MvpCardComposeNewPage"
  self.gameObject = obj
end

function MvpCardComposeNewPage:FindObjs()
  MvpCardComposeNewPage.super.FindObjs(self)
  self.rateUpCardsGo = self:FindGO("RateUpGrid")
  self.rateUpGrid = self.rateUpCardsGo:GetComponent(UIGrid)
  self.rateUpListCtrl = UIGridListCtrl.new(self.rateUpGrid, CardMakeRateUpCell, "CardMakeRateUpCell")
  self.rateUpListCtrl:AddEventListener(MouseEvent.LongPress, self.OnSelectLongPress, self)
  self.upTipLabel = self:FindComponent("UpTip", UILabel)
  self.cardPartGo = self:FindGO("CardPart")
  local materialGrid = self:FindComponent("MaterialGrid", UIGrid)
  self.materialCtl = UIGridListCtrl.new(materialGrid, MvpCardComposeMaterialCell, "CardMakeMaterialCell")
  self.materialCtl:AddEventListener(MouseEvent.MouseClick, self.HandleMaterialTip, self)
  self.firstUp = self:FindGO("FirstUp")
end

function MvpCardComposeNewPage:InitCardList()
  self:UpdateRateUpCardList()
  MvpCardComposeNewPage.super.InitCardList(self)
end

function MvpCardComposeNewPage:InitMaterial()
  local beCostItem = GameConfig.Card.MvpCardComposeMaterial
  if beCostItem and beCostItem[self.makeType] then
    self.materialItems = {}
    local costItems = beCostItem[self.makeType]
    for i = 1, #costItems do
      local costItem = costItems[i]
      local itemId, ownNum = nil, 0
      itemId = costItem.items and costItem.items[1]
      local data = CardMakeMaterialData.new({
        id = itemId,
        num = costItem.count,
        extraItems = costItem.items
      }, i)
      TableUtility.ArrayPushBack(self.materialItems, data)
    end
  end
  self:UpdateMaterial()
end

function MvpCardComposeNewPage:UpdateMaterial()
  if self.materialItems then
    for i = 1, #self.materialItems do
      local data = self.materialItems[i]
      data.itemData.num = data.costNum * self.composeNum
      data:UpdateOwnNum()
    end
    self.materialCtl:ResetDatas(self.materialItems)
  end
  self:UpdateConfirmBtn()
end

function MvpCardComposeNewPage:UpdateCardList()
  local items = CardMakeProxy.Instance:FilterMvpComposeCardByTypes(self.filterTipData.curCustomProps)
  local data = AdventureDataProxy.Instance:getItemsByFilterData(nil, items, self.filterTipData.curPropData, self.filterTipData.curKeys)
  if data and 0 < #data then
    self.cardListCtl:ResetDatas(data)
  end
end

function MvpCardComposeNewPage:CanMake()
  if self.materialItems then
    for i = 1, #self.materialItems do
      local material = self.materialItems[i]
      if material.costNum and material.costNum > material.ownNum then
        return false
      end
    end
  end
  return true
end

function MvpCardComposeNewPage:CallExchangeCardItem()
  local skipValue = CardMakeProxy.Instance:IsSkipGetEffect(self.skipType)
  ServiceItemProxy.Instance:CallExchangeCardItemCmd(self.makeType, self.npcId, nil, nil, nil, not skipValue, nil, self.composeNum)
end

function MvpCardComposeNewPage:UpdateComposeNum()
  local count = MaxComposeNum
  if self.materialItems and #self.materialItems > 0 then
    for i = 1, #self.materialItems do
      local material = self.materialItems[i]
      local ownNum = material.ownNum or 0
      if material.costNum and 0 < material.costNum then
        local curCount = math.floor(ownNum / material.costNum)
        count = count or curCount
        count = math.min(curCount, count)
      end
    end
  end
  self.composeNum = math.min(count, self.composeNum)
  self.composeNum = math.clamp(self.composeNum, 1, MaxComposeNum)
  self.composeNumLabel.text = self.composeNum
end

function MvpCardComposeNewPage:UpdateRateUpCardList()
  local rateUpCards = CardMakeProxy.Instance:GetRateUpCardList(self.makeType)
  if rateUpCards then
    self.rateUpListCtrl:ResetDatas(rateUpCards)
  end
  local upCount = #rateUpCards
  self.rateUpCardsGo:SetActive(0 < upCount)
  local isFirstUp = MyselfProxy.Instance:GetAccVarValueByType(self.firstUpVarType) or 0
  self.firstUp:SetActive(0 < isFirstUp)
  self.upTipLabel.gameObject:SetActive(0 < upCount and isFirstUp <= 0)
  local myUpTimes = MyselfProxy.Instance:GetAccVarValueByType(self.upTimesVarType) or 0
  local safety_count = GameConfig.Card and GameConfig.Card.safety_count and GameConfig.Card.safety_count or 1
  local leftCount = safety_count - myUpTimes
  if leftCount <= 1 then
    self.upTipLabel.text = ZhString.CardMake_RateUpTipThisTime
  else
    self.upTipLabel.text = string.format(ZhString.CardMake_RateUpTip, leftCount)
  end
  if 0 < upCount then
    local posY = self.rateUpGrid.transform.localPosition.y - self.rateUpGrid.cellHeight * upCount - CardPartPosOffsetY
    LuaGameObject.SetLocalPositionGO(self.cardPartGo, 0, posY, 0)
  else
    LuaGameObject.SetLocalPositionGO(self.cardPartGo, 0, CardPartDefaultPosY, 0)
  end
  local cellChildInterval = 0 < upCount and 108 or 95
  self.cardListCtl.cellChildInterval = cellChildInterval
end
