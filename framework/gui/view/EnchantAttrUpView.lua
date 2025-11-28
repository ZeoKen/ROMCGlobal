local arrayClear = TableUtility.ArrayClear
local arrayPushBack = TableUtility.ArrayPushBack
local bagIns, lotteryIns, shopIns, tickManager, pictureMgr
local inactiveLabelColor = LuaColor.New(0.9372549019607843, 0.9372549019607843, 0.9372549019607843)
local activeLabelEffectColor = LuaColor.New(0.6862745098039216, 0.3764705882352941, 0.10588235294117647)
local inactiveLabelEffectColor = LuaColor.New(0.5019607843137255, 0.5019607843137255, 0.5019607843137255)
local enchantPackageCheck = {
  2,
  20,
  1
}
local enchantNewCell_PrefabPath = "cell/EnchantCell"
local createTable = ReusableTable.CreateTable
local destroyAndClearTable = ReusableTable.DestroyAndClearTable
local fixedCostTipOffset = {-210, 180}
local bg3TexName = "Equipmentopen_bg_bottom_16"
local enchantMatPackageCheck = GameConfig.PackageMaterialCheck.enchant
local getCellData = function(index, isReusable)
  local cellData = isReusable and createTable() or {}
  cellData.index = index
  return cellData
end
autoImport("EquipChooseBord")
autoImport("ItemNewCell")
autoImport("EnchantCombineView")
autoImport("EnchantNewCombineView")
autoImport("MaterialItemNewCell")
EnchantAttrUpView = class("EnchantAttrUpView", BaseView)
EnchantAttrUpView.ViewType = UIViewType.NormalLayer
EnchantAttrUpView.BrotherView = EnchantNewCombineView
EnchantAttrUpView.ViewMaskAdaption = {all = 1}
EnchantAttrUpView.EquipChooseControl = EquipChooseBord

function EnchantAttrUpView:Init()
  self:InitData()
  self:FindObjs()
  self:InitView()
  self:AddUIEvts()
  self:AddEvts()
end

function EnchantAttrUpView:InitData()
  pictureMgr = PictureManager.Instance
  bagIns, lotteryIns, shopIns = BagProxy.Instance, LotteryProxy.Instance, HappyShopProxy.Instance
  tickManager = TimeTickManager.Me()
  self.isCombine = self.viewdata.viewdata and self.viewdata.viewdata.isCombine
end

function EnchantAttrUpView:FindObjs()
  self.mainBoard = self:FindGO("MainBoard")
  self.mainBoardTrans = self.mainBoard.transform
  self.closeButton = self:FindGO("CloseButton")
  self.title = self:FindComponent("Title", UILabel, self.mainBoard)
  self.title.text = ZhString.EnchantAttrUp_Title
  self.actionBgSp = self:FindComponent("ActionBtn", UIMultiSprite, self.mainBoard)
  self.actionLabel = self:FindComponent("ActionLabel", UILabel, self.actionBgSp.gameObject)
  self.actionLabel.text = ZhString.EnchantAttrUp_ActionBtnDesc
  self.emptyTip = self:FindComponent("EmptyTip", UILabel, self.mainBoard)
  self.emptyTip.text = ZhString.EnchantAttrUp_EmptyTip
  self.chooseContainer = self:FindGO("ChooseContainer")
  self.targetCellObj = self:FindGO("TargetCell", self.mainBoard)
  self.bg3Tex = self:FindComponent("Bg3", UITexture, self.targetCellObj)
  self.targetCellAddIcon = self:FindGO("TargetCellAddIcon", self.targetCellObj)
  self.targetCellContent = self:FindGO("TargetCellContent", self.targetCellObj)
  self.targetIcon = self:FindComponent("Icon", UISprite, self.targetCellContent)
  self.removeTargetObj = self:FindGO("DeleteIcon", self.targetCellContent)
  self.actionBoard = self:FindGO("ActionBoard", self.mainBoard)
  self.targetName = self:FindComponent("ItemName", UILabel, self.actionBoard)
  self.enchantNoneTip = self:FindComponent("EnchantNoneTip", UILabel, self.actionBoard)
  self.enchantNoneTip.text = ZhString.EnchantAttrUp_EnchantNoneTip
  self.enchantCellParent = self:FindGO("EnchantCellParent", self.actionBoard)
  self.fixedCost = self:FindGO("FixedCost")
  self.fixedCostGrid = self:FindComponent("FixedCostGrid", UIGrid)
  self.effContainer = self:FindGO("EffectContainer")
  self.finishPart = self:FindGO("FinishPart")
  self:PlayUIEffect(EffectMap.UI.EquipEnchant_Bg, self:FindGO("TargetCell"), nil, function(obj, args, assetEffect)
    local effect = assetEffect
    local ps = effect.effectObj:GetComponentsInChildren(ParticleSystem, true)
    for i = 1, #ps do
      ps[i].gameObject:SetActive(false)
      ps[i].gameObject:SetActive(true)
    end
  end)
end

function EnchantAttrUpView:GetChooseBordDataFunc()
  self.chooseBoardData = self.chooseBoardData or {}
  arrayClear(self.chooseBoardData)
  local items, equipInfo
  for i = 1, #enchantPackageCheck do
    items = bagIns.bagMap[enchantPackageCheck[i]]:GetItems()
    if items then
      for j = 1, #items do
        equipInfo = items[j] and items[j].equipInfo
        if equipInfo and equipInfo:CanEnchant() then
          arrayPushBack(self.chooseBoardData, items[j])
        end
      end
    end
  end
  table.sort(self.chooseBoardData, function(l, r)
    local lValid = l:CheckAttrUpWorkValid() and 1 or 0
    local rValid = r:CheckAttrUpWorkValid() and 1 or 0
    if lValid == rValid then
      if l.bagtype == r.bagtype then
        return l.staticData.id > r.staticData.id
      else
        return l.bagtype > r.bagtype
      end
    else
      return lValid > rValid
    end
  end)
  return self.chooseBoardData
end

function EnchantAttrUpView:checkChooseBoardValid(itemdata)
  return itemdata:CheckAttrUpWorkValid()
end

function EnchantAttrUpView:InitView()
  self.mainBoardTrans.localPosition = LuaGeometry.GetTempVector3(self.isCombine and 289 or 289)
  self.closeButton:SetActive(not self.isCombine)
  self.targetChooseBord = self.EquipChooseControl.new(self.chooseContainer, function()
    return self:GetChooseBordDataFunc()
  end)
  self.targetChooseBord:SetFilterPopData(GameConfig.EquipChooseFilter)
  self.targetChooseBord:AddEventListener(EquipChooseBord.ChooseItem, self.OnClickChooseBordCell, self)
  self.targetChooseBord.needSetCheckValidFuncOnShow = true
  self.targetChooseBord:Show(true, nil, nil, self.checkChooseBoardValid, self, ZhString.EnchantAttrUp_InValid)
  self.enchantInfoBord = EnchantInfoBord.new(self.chooseContainer)
  self.enchantInfoBord:Hide()
  self.enchantScrollView = self:FindGO("EnchantCellScrollView"):GetComponent(UIScrollView)
  self.enchantCell = EnchantNewCell.new(self:LoadPreferb(enchantNewCell_PrefabPath, self.enchantScrollView.gameObject))
  self.enchantCell:HideBG()
  self.fixedCostCtl = ListCtrl.new(self.fixedCostGrid, MaterialItemCell, "MaterialItemCell")
  self.fixedCostCtl:AddEventListener(MouseEvent.MouseClick, self.OnClickFixedCostItemTip, self)
  self.tipData = {
    itemdata = nil,
    funcConfig = _EmptyTable,
    ignoreBounds = {
      self.fixedCostGrid.gameObject
    }
  }
  self.fixedCostItemDatas = {}
end

function EnchantAttrUpView:OnClickFixedCostItemTip(cell)
  local data = cell.data
  if not BagItemCell.CheckData(data) then
    return
  end
  self.tipData.itemdata = data
  EnchantAttrUpView.super.ShowItemTip(self, self.tipData, cell.icon, NGUIUtil.AnchorSide.Left, fixedCostTipOffset)
end

function EnchantAttrUpView:OnClickChooseBordCell(data)
  self:SetTargetCell(data)
end

function EnchantAttrUpView:SetActionBtnActive(active)
  if self.actionBtnActive == active then
    return
  end
  self.actionBtnActive = active
  self:_updateActionBtnActive()
end

function EnchantAttrUpView:_updateActionBtnActive()
  local isActive = self.actionBtnActive
  self.actionBgSp.CurrentState = isActive and 1 or 0
  self.actionLabel.color = isActive and ColorUtil.NGUIWhite or inactiveLabelColor
  self.actionLabel.effectColor = isActive and activeLabelEffectColor or inactiveLabelEffectColor
end

function EnchantAttrUpView:SetTargetCell(data)
  if not BagItemCell.CheckData(data) and data.staticData ~= nil then
    data = nil
  end
  local curEnchantItemId = data and data.id or nil
  EnchantEquipUtil.Instance:SetCurrentEnchantId(curEnchantItemId)
  self.targetData = data
  self.targetName.text = data:GetName()
  self:UpdateViewByTargetCell()
  if data then
    self:sendNotification(ItemEvent.EquipChooseSuccess, data)
  end
end

function EnchantAttrUpView:HasTarget()
  return nil ~= self.targetData and nil ~= self.targetData.staticData
end

function EnchantAttrUpView:OnRemoveTarget()
  self.targetData = nil
  self:UpdateViewByTargetCell()
  self.targetChooseBord:Show(true, nil, nil, self.checkChooseBoardValid, self, ZhString.EnchantAttrUp_InValid)
  self.targetChooseBord:SetChoose(nil)
  self.enchantInfoBord:Hide()
end

local iconScale = 1

function EnchantAttrUpView:UpdateViewByTargetCell()
  if not self:HasTarget() then
    self:Hide(self.actionBoard)
    self:Hide(self.targetCellContent)
    self:Show(self.emptyTip)
    self:Show(self.targetCellAddIcon)
    self.actionBgSp.gameObject:SetActive(false)
    return
  end
  self:Hide(self.emptyTip)
  self:Hide(self.targetCellAddIcon)
  self:Show(self.actionBoard)
  self:Show(self.targetCellContent)
  IconManager:SetItemIcon(self.targetData.staticData.Icon, self.targetIcon)
  self.targetIcon:MakePixelPerfect()
  self.targetIcon.transform.localScale = LuaGeometry.GetTempVector3(iconScale, iconScale, iconScale)
  self:updateTargetEnchantInfo()
  self:updateFixedCostItems()
  self:SetActionBtnActive(self.costEnough)
  self.targetChooseBord:Hide()
  self.enchantInfoBord:Hide()
end

function EnchantAttrUpView:getEnchantCellDataFromEnchantInfo(enchantInfo, index, isReusable)
  if enchantInfo and self:HasTarget() then
    local attrs = enchantInfo.enchantAttrs
    if attrs and 0 < #attrs then
      local cellData = getCellData(index, isReusable)
      cellData.enchantAttrList = attrs
      cellData.combineEffectList = enchantInfo.combineEffectlist
      cellData.minRatioAttrType = enchantInfo:GetMinRatioAttrType()
      cellData.nextAttrValue = enchantInfo.enchantUp_NextAttrValue
      cellData.allAttrIsMax = enchantInfo:CheckAllAttrIsMax()
      return cellData
    end
  end
end

function EnchantAttrUpView:updateTargetEnchantInfo()
  local hasEnchant = self.targetData:HasEnchant()
  self.enchantNoneTip.gameObject:SetActive(not hasEnchant)
  if hasEnchant then
    local data = self:getEnchantCellDataFromEnchantInfo(self.targetData.enchantInfo, nil, true)
    self.enchantCell:SetData(data)
    destroyAndClearTable(data)
  else
    self.enchantCell:SetData(nil)
  end
  self.enchantScrollView:ResetPosition()
end

function EnchantAttrUpView:updateFixedCostItems()
  self.costEnough = false
  if not self:HasTarget() then
    self.actionBgSp.gameObject:SetActive(false)
    return
  end
  arrayClear(self.fixedCostItemDatas)
  local costConfig = self.targetData.enchantInfo:GetAttrUpCostConfig()
  if not costConfig then
    return
  end
  local isAttrMax = self.targetData.enchantInfo:CheckAllAttrIsMax()
  self.fixedCost:SetActive(not isAttrMax)
  self.actionBgSp.gameObject:SetActive(not isAttrMax)
  self.finishPart:SetActive(isAttrMax)
  local staticItemCostItem = costConfig[1]
  local staticZenyCostItem = costConfig[2]
  local itemCostData = ItemData.new(MaterialItemCell.MaterialType.Material, staticItemCostItem[1])
  itemCostData.num = bagIns:GetItemNumByStaticID(staticItemCostItem[1], enchantMatPackageCheck)
  itemCostData.discount = 100
  itemCostData.neednum = staticItemCostItem[2]
  arrayPushBack(self.fixedCostItemDatas, itemCostData)
  local zenyData = ItemData.new(MaterialItemCell.MaterialType.Material, staticZenyCostItem[1])
  zenyData.num = MyselfProxy.Instance:GetROB()
  zenyData.discount = 100
  zenyData.neednum = staticZenyCostItem[2]
  arrayPushBack(self.fixedCostItemDatas, zenyData)
  if itemCostData.num >= itemCostData.neednum and zenyData.num >= zenyData.neednum then
    self.costEnough = true
  end
  self.fixedCostCtl:ResetDatas(self.fixedCostItemDatas)
end

function EnchantAttrUpView:AddUIEvts()
  self:AddClickEvent(self.targetCellObj, function()
    if self:HasTarget() then
      return
    end
    if self.targetChooseBord:ActiveSelf() then
      return
    end
    self.enchantInfoBord:Hide()
    self.targetChooseBord:Show(true, nil, nil, self.checkChooseBoardValid, self, ZhString.EnchantAttrUp_InValid)
  end)
  self:AddClickEvent(self.removeTargetObj, function()
    self:OnRemoveTarget()
  end)
  self:AddClickEvent(self.actionBgSp.gameObject, function()
    self:OnClickActionBtn()
  end)
  self:AddButtonEvent("EnchantInfoBtn", function()
    local curType = self.targetData and self.targetData.staticData.Type or nil
    local _data = {equipType = curType}
    self.enchantInfoBord:Show()
    self.enchantInfoBord:UpdateView(_data)
  end)
  TipsView.Me():TryShowGeneralHelpByHelpId(32, self:FindGO("HelpButton"))
end

function EnchantAttrUpView:OnClickActionBtn()
  if not self.targetData then
    return
  end
  if not self.costEnough then
    MsgManager.ShowMsgByID(8)
    return
  end
  if self.targetData.enchantInfo:CheckAllAttrIsMax() then
    MsgManager.ShowMsgByID(4302)
    return
  end
  FunctionSecurity.Me():EnchantingEquip(function(self)
    ServiceItemProxy.Instance:CallEnchantUpgradeAttr(self.targetData.id, self.targetData.enchantInfo:GetMinRatioAttrType())
    self:PlayUIEffect(EffectMap.UI.EquipReplaceNew, self.effContainer, true)
    self:PlayUISound(AudioMap.UI.EnchantAttrUpSuc)
  end, self)
end

function EnchantAttrUpView:AddEvts()
  self:AddListenEvt(ItemEvent.ItemUpdate, self.UpdateViewByTargetCell)
  self:AddListenEvt(ItemEvent.EquipUpdate, self.UpdateViewByTargetCell)
  self:AddListenEvt(MyselfEvent.ZenyChange, self.UpdateViewByTargetCell)
end

function EnchantAttrUpView:OnEnter()
  EnchantAttrUpView.super.OnEnter(self)
  local nnpc = self.viewdata.viewdata and self.viewdata.viewdata.npcdata
  if nnpc and nnpc.assetRole then
    self:CameraFocusOnNpc(nnpc.assetRole.completeTransform)
  else
    self:CameraRotateToMe()
  end
  local curEnchantId = EnchantEquipUtil.Instance:GetCurEnchantId()
  if curEnchantId then
    local item = bagIns:GetItemByGuid(curEnchantId, enchantPackageCheck)
    if item and self:checkChooseBoardValid(item) then
      self:SetTargetCell(item)
      return
    end
  end
  self:UpdateViewByTargetCell()
end

function EnchantAttrUpView:OnExit()
  self:CameraReset()
  EnchantAttrUpView.super.OnExit(self)
end
