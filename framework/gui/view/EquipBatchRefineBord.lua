autoImport("MaterialItemCell1")
autoImport("MaterialChooseBord1")
EquipBatchRefineBord = class("EquipBatchRefineBord", CoreView)

function EquipBatchRefineBord:ctor(go, isFashion)
  EquipBatchRefineBord.super.ctor(self, go)
  self:Init(isFashion)
end

function EquipBatchRefineBord:Init(isFashion)
  self.isFashion = isFashion
  self.oneClickTipLabel = self:FindGO("OneClickTipLabel")
  self.oneClickBeforePanel = self:FindGO("OneClickBeforePanel")
  self.oneClickMatCtl = UIGridListCtrl.new(self:FindComponent("OneClickMatGrid", UIGrid), MaterialItemCell1, "MaterialItemCell1")
  self.oneClickMatCtl:AddEventListener(MouseEvent.MouseClick, self.HandleClickOneClickMatCell, self)
  self.oneClickChooseCtl = WrapListCtrl.new(self:FindGO("ChoosenEquipWrap"), MaterialItemCell1, "MaterialItemCell2", WrapListCtrl_Dir.Vertical, 5, 95)
  self.oneClickChooseCtl:AddEventListener(MouseEvent.MouseClick, self.HandleChooseOneClickItem, self)
  self.oneClickChooseCtl:AddEventListener(MaterialItemCell1.Event.Delete, self.HandleChooseOneClickItem, self)
  self.oneClickChooseEquips = {}
  self.oneClickCoinNumLabel = self:FindComponent("CoinNum", UILabel, self.oneClickBeforePanel)
  self.oneClickOriginalCoinNumLabel = self:FindComponent("OriginalCoinNum", UILabel, self.oneClickBeforePanel)
  self.oneClickCoinIcon = self:FindComponent("CoinIcon", UISprite, self.oneClickBeforePanel)
  IconManager:SetItemIcon(Table_Item[100].Icon, self.oneClickCoinIcon)
  self.tipLocator = self:FindComponent("TipLocator", UIWidget)
  self.chooseBord = MaterialChooseBord1_CombineSize.new(self:FindGO("ChoosePanel/ChooseContainer"))
  self.chooseBord:AddEventListener(MaterialChooseBord1.Event.CountChooseChange, self.OnCountChooseChange, self)
  self.chooseBord:SetBordTitle(ZhString.EquipBatchRefineBord_ChooseEquip)
  self.chooseBord:SetUseItemNum(true)
  self.chooseBord:Show()
  self:AddButtonEvent("OneClickRefineBtn", function()
    local matEnough, robEnough = self:CheckOneClickMat()
    if not matEnough then
      QuickBuyProxy.Instance:TryOpenView(self.lackItems, QuickBuyProxy.QueryType.NoDamage)
      return
    end
    if not robEnough then
      MsgManager.ShowMsgByID(40803)
      return
    end
    if not self.oneClickServerMats then
      self.oneClickServerMats = {}
    else
      TableUtility.ArrayClear(self.oneClickServerMats)
    end
    for i = 1, #self.oneClickChooseEquips do
      table.insert(self.oneClickServerMats, self.oneClickChooseEquips[i]:ExportServerItemInfo())
    end
    if #self.oneClickServerMats > 0 then
      FunctionSecurity.Me():TryVerifySecurity(function(mats)
        ServiceItemProxy.Instance:CallBatchRefineItemCmd(mats, nil, self.npcguid or 0)
      end, self.oneClickServerMats)
    end
  end)
end

function EquipBatchRefineBord:OnCountChooseChange(cell)
  local config = GameConfig.FastRefineLimit
  local data, chooseCount = cell.data, cell.chooseCount
  if not data or not chooseCount then
    return
  end
  if chooseCount > config.EquipNumPerGrid then
    cell:SetChooseCount(config.EquipNumPerGrid)
    chooseCount = config.EquipNumPerGrid
    MsgManager.ShowMsgByID(244)
  end
  local finded = false
  for i = #self.oneClickChooseEquips, 1, -1 do
    if self.oneClickChooseEquips[i].id == data.id then
      if chooseCount == 0 then
        table.remove(self.oneClickChooseEquips, i)
      else
        self.oneClickChooseEquips[i].num = chooseCount
      end
      finded = true
      break
    end
  end
  if not finded and 0 < chooseCount then
    if #self.oneClickChooseEquips >= config.MaxGrid then
      cell:SetChooseCount(0)
      chooseCount = 0
      MsgManager.ShowMsgByID(244)
    else
      local newData = data:Clone()
      newData.num = chooseCount
      newData.showDelete = true
      table.insert(self.oneClickChooseEquips, newData)
    end
  end
  self:UpdateChoosedDatas()
end

local tipOffset = {-180, 0}

function EquipBatchRefineBord:HandleClickOneClickMatCell(cellCtl)
  if not self.tipData then
    self.tipData = {}
  end
  self.tipData.itemdata = cellCtl.data
  self.tipData.ignoreBounds = cellCtl.gameObject
  TipManager.Instance:ShowItemFloatTip(self.tipData, self.tipLocator, NGUIUtil.AnchorSide.Left, tipOffset)
end

function EquipBatchRefineBord:HandleChooseOneClickItem(cellCtl)
  if type(cellCtl.data) ~= "table" then
    return
  end
  for i = 1, #self.oneClickChooseEquips do
    if self.oneClickChooseEquips[i].id == cellCtl.data.id then
      table.remove(self.oneClickChooseEquips, i)
      break
    end
  end
  self:UpdateChoosedDatas()
end

local addOneClickMat = function(mats, sId, needNum)
  local matData = TableUtility.ArrayFindByPredicate(mats, function(mat, id)
    return mat.staticData.id == id
  end, sId)
  if matData then
    matData.neednum = matData.neednum + needNum
  else
    matData = ItemData.new(MaterialItemCell.MaterialType.Material, sId)
    matData.num = BagProxy.Instance:GetItemNumByStaticID(sId, GameConfig.PackageMaterialCheck.refine)
    matData.neednum = needNum
    table.insert(mats, matData)
  end
end
local tempOneClickMatData

function EquipBatchRefineBord:CheckOneClickMat()
  self.lackItems = self.lackItems or {}
  TableUtility.TableClear(self.lackItems)
  if not tempOneClickMatData then
    tempOneClickMatData = ItemData.new()
  end
  local discount = BlackSmithProxy.Instance:GetEquipOptDiscounts(ActivityCmd_pb.GACTIVITY_NORMAL_REFINE)
  discount = discount and discount[1]
  local homeWorkbenchDiscount = HomeManager.Me():TryGetHomeWorkbenchDiscount("Refine")
  local mats, matEnough, zeny, origZeny = ReusableTable.CreateArray(), true, 0, 0
  local sId, initialRefineLv, isLottery, composeIds, composeId, composeSData, bcItems, bcd, num, neednum, realDiscount, equipnum
  for i = 1, #self.oneClickChooseEquips do
    sId = self.oneClickChooseEquips[i].staticData.id
    tempOneClickMatData:ResetData("TempMat", sId)
    initialRefineLv = self.oneClickChooseEquips[i].equipInfo.refinelv
    isLottery = LotteryProxy.Instance:IsLotteryEquip(sId)
    realDiscount = not isLottery and discount or homeWorkbenchDiscount
    equipnum = self.oneClickChooseEquips[i].num or 1
    for j = initialRefineLv, 3 do
      tempOneClickMatData.equipInfo.refinelv = j
      composeIds = BlackSmithProxy.Instance:GetComposeIDsByItemData(tempOneClickMatData)
      composeId = composeIds and composeIds[1]
      composeSData = composeId and Table_Compose[composeId]
      if composeSData then
        bcItems = composeSData.BeCostItem
        for m = 1, equipnum do
          for k = 1, #bcItems do
            bcd = bcItems[k]
            addOneClickMat(mats, bcd.id, bcd.num)
          end
          origZeny = origZeny + composeSData.ROB
          zeny = zeny + math.floor(composeSData.ROB * realDiscount / 100 + 0.01)
        end
      end
    end
  end
  for _, mat in pairs(mats) do
    num, neednum = mat.num, mat.neednum
    if neednum and num < neednum then
      table.insert(self.lackItems, {
        id = mat.staticData.id,
        count = neednum - num
      })
      matEnough = false
    end
  end
  self.oneClickMatCtl:ResetDatas(mats)
  local robEnough = zeny <= MyselfProxy.Instance:GetROB()
  if robEnough then
    self.oneClickCoinNumLabel.text = zeny
  else
    self.oneClickCoinNumLabel.text = string.format("[c][fb725f]%s[-][/c]", zeny)
  end
  self.oneClickOriginalCoinNumLabel.text = origZeny
  self.oneClickOriginalCoinNumLabel.gameObject:SetActive(not math.Approximately(zeny, origZeny))
  ReusableTable.DestroyAndClearArray(mats)
  return matEnough, robEnough
end

function EquipBatchRefineBord:UpdateChoosedDatas()
  self.oneClickChooseCtl:ResetDatas(self.oneClickChooseEquips, false)
  self:UpdateChooseBordDatas(false)
  local hasChoose = #self.oneClickChooseEquips > 0
  self.oneClickTipLabel:SetActive(not hasChoose)
  self.oneClickBeforePanel:SetActive(hasChoose)
  self:CheckOneClickMat()
end

function EquipBatchRefineBord:Reset()
  TableUtility.TableClear(self.oneClickChooseEquips)
  self:Refresh()
end

function EquipBatchRefineBord:Refresh()
  self:UpdateChooseBordDatas()
  self:UpdateChoosedDatas()
end

local SearchBagTypes = {
  BagProxy.BagType.RoleEquip,
  BagProxy.BagType.MainBag
}

function EquipBatchRefineBord:UpdateChooseBordDatas(retPos)
  self.oneClickEquipDatas = self.oneClickEquipDatas or {}
  TableUtility.TableClear(self.oneClickEquipDatas)
  local refineTypeMap = {}
  TableUtility.TableShallowCopy(refineTypeMap, BlackSmithProxy.GetRefineEquipTypeMap())
  local validMiyinType = GuildBuildingProxy.Instance:GetMiyinRefineUnlockedType() or {}
  for i = 1, #validMiyinType do
    xdlog("缝纫机合法类型", validMiyinType[i])
    refineTypeMap[validMiyinType[i]] = 1
  end
  local bagIns, arrayFind = BagProxy.Instance, TableUtility.ArrayFindIndex
  local bagItems, item, equipInfo, refineLv
  for i = 1, #SearchBagTypes do
    bagItems = bagIns:GetBagByType(SearchBagTypes[i]):GetItems()
    if bagItems then
      for j = 1, #bagItems do
        item = bagItems[j]
        equipInfo = item.equipInfo
        refineLv = equipInfo and refineTypeMap[equipInfo.equipData.EquipType] and equipInfo:CanRefine() and equipInfo.refinelv
        if refineLv and refineLv < 4 and not equipInfo.damage and not bagIns:CheckIsFavorite(item) then
          local nItem = item:Clone()
          nItem.chooseCount = 0
          table.insert(self.oneClickEquipDatas, nItem)
        end
      end
    end
  end
  BlackSmithProxy.SortEquips(self.oneClickEquipDatas)
  self.chooseBord:ResetDatas(self.oneClickEquipDatas, retPos)
  self.chooseBord:SetChooseReference(self.oneClickChooseEquips)
end

function EquipBatchRefineBord:IsActived()
  return self._isShow == true
end

function EquipBatchRefineBord:Show()
  self.gameObject:SetActive(true)
  self._isShow = true
  self:Reset()
end

function EquipBatchRefineBord:Hide()
  self.gameObject:SetActive(false)
  self._isShow = false
end
