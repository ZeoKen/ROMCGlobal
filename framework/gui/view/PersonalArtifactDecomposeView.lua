autoImport("DeComposeView")
PersonalArtifactDecomposeView = class("PersonalArtifactDecomposeView", DeComposeView)
PersonalArtifactDecomposeView.ViewType = UIViewType.NormalLayer

function PersonalArtifactDecomposeView:InitUI()
  PersonalArtifactDecomposeView.super.InitUI(self)
  self.topCostSprite = self:FindComponent("symbol", UISprite, self.userRob)
  self.costSprite = self:FindComponent("Sprite", UISprite, self.cost.gameObject)
  self:SetBusinessTip(false)
  GameObject.Destroy(self.waittingSymbol)
  self.waittingSymbol = nil
  local cfg = GameConfig.PersonalArtifact
  self.costItemId, self.perCost = cfg.DecomposeCostItemId, cfg.DecomposeCostItemCount
  self.productId, self.productCfg = cfg.DecomposeProduceItemId, cfg.DecomposeProduceItemCout
end

function PersonalArtifactDecomposeView:InitTipLabels()
  local titleLabel = self:FindComponent("Title", UILabel)
  titleLabel.text = Table_NpcFunction[11003].NameZh
  local addTipLab = self:FindComponent("TipLabel", UILabel, self.addbord)
  addTipLab.text = ZhString.PersonalArtifact_DecomposeAddTip
  local resultTipLab = self:FindComponent("TIPLabel", UILabel, self.decomposeBord)
  resultTipLab.text = ZhString.PersonalArtifact_DecomposeAddTip2
end

function PersonalArtifactDecomposeView:MapEvent()
  PersonalArtifactDecomposeView.super.MapEvent(self)
  self:AddListenEvt(ItemEvent.PersonalArtifactUpdate, self.HandlePersonalArtifactDecompose)
  self:AddListenEvt(ItemEvent.ItemUpdate, self.UpdateCoins)
  self:AddListenEvt(PersonalArtifactDecomposeEvent.PutIn, self.OnPutIn)
end

function PersonalArtifactDecomposeView:OnPutIn(note)
  TipManager.CloseTip()
  local data = note and note.body
  if not data then
    return
  end
  self:_PutIn(data.data, data.count)
end

function PersonalArtifactDecomposeView:_PutIn(item, count)
  local guid = item.id
  if self.chooseEquips[guid] then
    self.chooseEquips[guid].num = self.chooseEquips[guid].num + count
  else
    self.chooseEquips[guid] = item:Clone()
    self.chooseEquips[guid].num = count
  end
  self:Update()
end

function PersonalArtifactDecomposeView:StartDeCompose()
  if not self:CheckCoins(true) then
    return
  end
  if BagProxy.Instance:CheckBagIsFull(BagProxy.BagType.MainBag) then
    MsgManager.ShowMsgByID(989)
    return
  end
  MsgManager.ConfirmMsgByID(41335, function()
    PersonalArtifactProxy.CallDecompose(self.chooseEquips)
  end)
end

function PersonalArtifactDecomposeView:HandleChooseItem(cellCtl)
  local data = cellCtl and cellCtl.data
  if not data then
    return
  end
  if self.chooseEquips[data.id] then
    self.chooseEquips[data.id] = nil
    self:Update()
  end
end

local comparer = function(l, r)
  local lt, ls, rt, rs = l.staticData.Type, l.staticData.id, r.staticData.Type, r.staticData.id
  if lt ~= rt then
    return lt < rt
  end
  if ls ~= rs then
    return ls < rs
  end
  return l.id < r.id
end
local addDecomposeEquips = function(target, chooseMap, bagIns, bagType)
  local bag, item, chosen, clone = bagIns:GetBagByType(bagType)
  local source = bag and bag:GetItems()
  if not source then
    return
  end
  for i = 1, #source do
    item = source[i]
    if not bagIns:CheckIsFavorite(item, bagType) then
      chosen, clone = chooseMap[item.id], item:Clone()
      if chosen then
        clone.num = clone.num - chosen.num
      end
      if clone.num > 0 then
        if item.personalArtifactData then
          clone.personalArtifactData = item.personalArtifactData:Clone()
        end
        TableUtility.ArrayPushBack(target, clone)
      end
    end
  end
end

function PersonalArtifactDecomposeView:GetDecomposeEquips()
  local result, bagIns = {}, BagProxy.Instance
  addDecomposeEquips(result, self.chooseEquips, bagIns, BagProxy.BagType.PersonalArtifact)
  addDecomposeEquips(result, self.chooseEquips, bagIns, BagProxy.BagType.PersonalArtifactFragment)
  table.sort(result, comparer)
  return result
end

function PersonalArtifactDecomposeView:UpdateChooseBord()
  local equipDatas = self:GetDecomposeEquips()
  local resetPos = #equipDatas < 5
  self.chooseBord:SetBordTitle(ZhString.PersonalArtifact_FormulaChooseTitle)
  self.chooseBord:SetNoneTip(Table_Sysmsg[41334].Text)
  self.chooseBord.chooseCtl.scrollView.disableDragIfFits = resetPos
  self.chooseBord:ResetDatas(equipDatas, resetPos)
  self.chooseBord:Show(false)
end

local funcConfig = {72}

function PersonalArtifactDecomposeView:ChooseItem(itemData)
  if not itemData then
    return
  end
  local chooseData = self:GetChooseEquips()
  if #chooseData >= self:GetMaxDeComposeCount() then
    MsgManager.ShowMsgByID(244)
    return
  end
  if itemData.num > 1 then
    self:ShowItemTip(itemData, nil, nil, funcConfig, 180)
  elseif itemData.num == 1 then
    self:_PutIn(itemData, 1)
  else
    LogUtility.WarningFormat("Num of the item is 0. There must be sth wrong.")
  end
end

function PersonalArtifactDecomposeView:GetCoinCost(item)
  if not item then
    return 0
  end
  return self.perCost * item.num
end

function PersonalArtifactDecomposeView:Update()
  if not self.resultData then
    self.resultData = {
      ItemData.new("DecomposeProduct", self.productId)
    }
  end
  local totalCount, t, quality, count = 0
  for _, item in pairs(self.chooseEquips) do
    t, quality = item.staticData.Type, item.staticData.Quality
    count = self.productCfg[t] and self.productCfg[t][quality] or 0
    totalCount = totalCount + count * item.num
  end
  self.resultData[1]:SetItemNum(totalCount)
  local chooseData, totalCost = self:GetChooseEquips()
  self.decomposeBord:SetActive(0 < #chooseData)
  self.resultCtl:ResetDatas(self.resultData)
  self.addbord:SetActive(#chooseData <= 0)
  chooseData = self:ReUnitData(chooseData, 5)
  self.chooseCtl:UpdateInfo(chooseData)
  self:UpdateChooseBord()
  self.cost.text = self:CheckCoins() and tostring(totalCost) or string.format("[c]%s%s[-][/c]", CustomStrColor.BanRed, totalCost)
end

function PersonalArtifactDecomposeView:UpdateCoins()
  local iconName = Table_Item[self.costItemId].Icon
  IconManager:SetItemIcon(iconName, self.topCostSprite)
  IconManager:SetItemIcon(iconName, self.costSprite)
  self.robLabel.text = StringUtil.NumThousandFormat(self:GetMyCostItemNumByStaticId())
end

function PersonalArtifactDecomposeView:CheckCoins(showTip)
  local _, totalCost = self:GetChooseEquips()
  if totalCost and totalCost > self:GetMyCostItemNumByStaticId() then
    if showTip then
      if self.costItemId == GameConfig.MoneyId.Zeny then
        MsgManager.ShowMsgByID(1)
      else
        MsgManager.ShowMsgByIDTable(25418, Table_Item[self.costItemId].NameZh)
      end
    end
    return false
  end
  return true
end

function PersonalArtifactDecomposeView:GetMyCostItemNumByStaticId()
  return HappyShopProxy.Instance:GetItemNum(self.costItemId)
end

function PersonalArtifactDecomposeView:HandlePersonalArtifactDecompose()
  self:HandleEquipCompose()
  self:UpdateChooseBord()
end

function PersonalArtifactDecomposeView:GetMaxDeComposeCount()
  return GameConfig.PersonalArtifact.DecomposeCountMax
end
