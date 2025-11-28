autoImport("EquipIntegrateTogCell")
autoImport("RefineCombineView")
autoImport("RefineIntegerCombineView")
autoImport("EnchantNewCombineView")
EquipIntegrateView = class("EquipIntegrateView", BaseView)
EquipIntegrateView.ViewType = UIViewType.NormalLayer
EquipIntegrateView.ForceCoExist = true
local TabConfig = {
  [1] = {
    Name = ZhString.PackageView_StrengthTabName
  },
  [2] = {
    Name = ZhString.NpcRefinePanel_RefineTabName
  },
  [3] = {
    Name = ZhString.FunctionDialogEvent_Upgrade
  },
  [4] = {
    Name = ZhString.ItemTip_CardInsert
  },
  [5] = {
    Name = ZhString.EnchantView_Enchant
  },
  [6] = {
    Name = ZhString.EquipMemory_Name
  }
}

function EquipIntegrateView:Init()
  self:InitView()
  self:InitData()
  self:MapEvent()
end

function EquipIntegrateView:InitView()
  self.togGrid = self:FindGO("TogGrid"):GetComponent(UIGrid)
  self.togCtrl = UIGridListCtrl.new(self.togGrid, EquipIntegrateTogCell, "EquipIntegrateTogCell")
  self.togCtrl:ResetDatas(TabConfig)
  local cells = self.togCtrl:GetCells()
  for i = 1, #cells do
    self:AddTabChangeEvent(cells[i].gameObject, nil, i)
  end
  local itemContainer = self:FindGO("EquipContainer")
  local obj = self:FindGO("ItemCell", itemContainer)
  obj.transform.localPosition = LuaGeometry.GetTempVector3()
  obj.transform.localScale = LuaGeometry.GetTempVector3(1.5, 1.5, 1.5)
  self.itemCell = ItemCell.new(obj)
  self:AddClickEvent(obj, function()
    self:sendNotification(ItemEvent.EquipIntegrate_TrySelectEquip)
  end)
  self.itemName = self:FindGO("ItemName"):GetComponent(UILabel)
  self.bgTexture = self:FindGO("BgTexture"):GetComponent(UITexture)
  self.cost = {}
  for i = 1, 2 do
    local go = self:FindGO("Cost" .. i)
    local label = self:FindGO("Label", go):GetComponent(UILabel)
    local icon = self:FindGO("CostIcon", go):GetComponent(UISprite)
    local plus = self:FindGO("Plus", go)
    self.cost[i] = {
      go = go,
      label = label,
      icon = icon,
      plus = plus
    }
    self:AddClickEvent(plus, function()
      local coinID = self.costItemIDs[i]
      if coinID == GameConfig.MoneyId.Zeny then
        self:TryGetMoney()
      end
    end)
  end
  IconManager:SetItemIconById(100, self.cost[1].icon)
  self.cost[2].go:SetActive(false)
end

function EquipIntegrateView:InitData()
  local viewData = self.viewdata.viewdata
  if viewData and viewData.itemdata then
    self.itemdata = viewData and viewData.itemdata
  elseif viewData and viewData.selectTicket then
    xdlog("使用票券")
    self.selectTicket = viewData and viewData.selectTicket
  else
    local lastGuid = BagProxy.Instance:GetLastOperEquip()
    if not lastGuid then
      return
    end
    local item = BagProxy.Instance:GetItemByGuid(lastGuid)
    self.itemdata = item
  end
  self.itemCell:SetData(self.itemdata)
  self.itemName.text = self.itemdata and self.itemdata:GetName() or "未选择"
  self.itemCell:UpdateNumLabel(1)
  self.itemCell:ActiveNewTag(false)
end

function EquipIntegrateView:MapEvent()
  self:AddListenEvt(ItemEvent.ItemUpdate, self.HandleEquipUpdate)
  self:AddListenEvt(ItemEvent.EquipUpdate, self.HandleEquipUpdate)
  self:AddListenEvt(MyselfEvent.ZenyChange, self.UpdateMoney)
  self:AddListenEvt(ItemEvent.StrengthLvUpdate, self.HandleEquipUpdate)
  self:AddListenEvt(ItemEvent.EquipUpgradeSuccess, self.HandleEquipUpdateSuccess)
  self:AddListenEvt(ItemEvent.EquipChooseSuccess, self.HandleEquipUpdateSuccess)
  self:AddListenEvt(ServiceEvent.LoginUserCmdLoginResultUserCmd, self.HandleReConnent, self)
end

function EquipIntegrateView:TabChangeHandler(key)
  if not EquipIntegrateView.super.TabChangeHandler(self, key) then
    return
  end
  BagProxy.Instance:SetEquipIntegrateIndex(key)
  self:JumpPanel(key)
  local cells = self.togCtrl:GetCells()
  for i = 1, #cells do
    cells[i]:SetChoose(key == i)
  end
end

local miyin_RefineType = {
  8,
  9,
  10,
  11,
  13
}
local should_miyin_refine = function(itemData)
  local equipInfo = itemData.equipInfo
  if not equipInfo then
    return
  end
  if TableUtility.ArrayFindIndex(miyin_RefineType, equipInfo.equipData.EquipType) > 0 then
    return true
  end
end

function EquipIntegrateView:RefreshTabs()
  local validCount = 0
  local isStrengthOpen = self:_CheckCanOpen(7)
  local isRefineOpen = self:_CheckCanOpen(4)
  local isEnchantOpen = self:_CheckCanOpen(73)
  local maxSlotNum = self.itemdata and self.itemdata.GetMaxCardSlot and self.itemdata:GetMaxCardSlot() or 0
  local canRefine = self.itemdata and self.itemdata.equipInfo and self.itemdata.equipInfo:CanRefine() or false
  local canUpgrade = self.itemdata and self.itemdata.equipInfo and self.itemdata.equipInfo.upgradeData ~= nil or false
  local canEnchant = self.itemdata and self.itemdata.equipInfo and self.itemdata.equipInfo:CanEnchant() or false
  local cells = self.togCtrl:GetCells()
  if cells[1] then
    cells[1].gameObject:SetActive(isStrengthOpen)
    validCount = validCount + (isStrengthOpen == true and 1 or 0)
  end
  if cells[2] then
    cells[2].gameObject:SetActive(isRefineOpen)
    validCount = validCount + (isRefineOpen == true and 1 or 0)
  end
  if cells[3] then
    cells[3].gameObject:SetActive(true)
    validCount = validCount + 1
  end
  if cells[4] then
    cells[4].gameObject:SetActive(true)
    validCount = validCount + 1
  end
  if cells[5] then
    cells[5].gameObject:SetActive(isEnchantOpen)
    validCount = validCount + (isEnchantOpen == true and 1 or 0)
  end
  if cells[6] then
    local valid = FunctionUnLockFunc.Me():CheckCanOpen(6211)
    cells[6].gameObject:SetActive(valid)
    validCount = validCount + (valid and 1 or 0)
  end
  xdlog("validCount", validCount)
  self.togGrid.cellHeight = 5 < validCount and 95 or 102
  self.togGrid:Reposition()
end

function EquipIntegrateView:OnEnter()
  EquipIntegrateView.super.OnEnter(self)
  PictureManager.Instance:SetUI("equip4_bg_01", self.bgTexture)
  self:RefreshTabs()
  local cells = self.togCtrl:GetCells()
  local index = self.viewdata and self.viewdata.viewdata and self.viewdata.viewdata.index
  index = index or BagProxy.Instance:GetEquipIntegrateIndex() or 1
  if index and cells[index] and cells[index].gameObject.activeSelf then
    self:TabChangeHandler(index)
  else
    for i = 1, 5 do
      if cells[i] and cells[i].gameObject.activeSelf then
        self:TabChangeHandler(i)
      end
    end
  end
  self.isFromBag = self.viewdata and self.viewdata.viewdata and self.viewdata.viewdata.isFromBag or false
  EventManager.Me():AddEventListener(UIEvent.ExitCallback, self.SetExitCallback, self)
end

function EquipIntegrateView:OnExit()
  TimeTickManager.Me():ClearTick(self)
  PictureManager.Instance:UnLoadUI("equip4_bg_01", self.bgTexture)
  self:sendNotification(UIEvent.CloseUI, {
    className = "EquipStrengthView",
    needRollBack = false
  })
  self:sendNotification(UIEvent.CloseUI, {
    className = "RefineIntegerCombineView",
    needRollBack = false
  })
  self:sendNotification(UIEvent.CloseUI, {
    className = "EquipUpgradeSubView",
    needRollBack = false
  })
  self:sendNotification(UIEvent.CloseUI, {
    className = "EquipCardView",
    needRollBack = false
  })
  self:sendNotification(UIEvent.CloseUI, {
    className = "EnchantIntegerCombineView",
    needRollBack = false
  })
  self:sendNotification(UIEvent.CloseUI, {
    className = "EquipMemoryCombineView",
    needRollBack = false
  })
  EquipIntegrateView.super.OnExit(self)
  if self.itemdata then
    BagProxy.Instance:SetLastOperEquip(self.itemdata.id)
  end
  self.itemCell = nil
  EventManager.Me():RemoveEventListener(UIEvent.ExitCallback, self.SetExitCallback, self)
  if self.exitCallback then
    self.exitCallback()
    self.exitCallback = nil
  elseif self.viewdata.viewdata and self.viewdata.viewdata.from_AdventureEquipComposeTip then
    local equipID = self.viewdata.viewdata.from_AdventureEquipComposeTip
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.AdventurePanel,
      viewdata = {
        tabId = SceneManual_pb.EMANUALTYPE_RESEARCH,
        selectItemId = equipID
      }
    })
  end
  EquipComposeProxy.Instance:SetCurOperEquipGuid(nil)
end

function EquipIntegrateView:JumpPanel(tabIndex)
  if tabIndex == 1 then
    local _itemData = self.itemdata and self.itemdata:IsEquip() and self.itemdata or nil
    self:_JumpPanel("EquipStrengthView", {isCombine = true, itemdata = _itemData})
    self:SetMoneyIDs({100})
  elseif tabIndex == 2 then
    local _itemData = self.itemdata and self.itemdata:IsEquip() and self.itemdata or nil
    self:_JumpPanel("RefineIntegerCombineView", {
      isCombine = true,
      OnClickChooseBordCell_data = _itemData,
      isfashion = false,
      selectTicket = self.selectTicket
    })
    self:SetMoneyIDs({100})
  elseif tabIndex == 3 then
    local _itemData = self.itemdata and self.itemdata:IsEquip() and self.itemdata or nil
    self:_JumpPanel("EquipUpgradeSubView", {isCombine = true, OnClickChooseBordCell_data = _itemData})
    self:SetMoneyIDs({100})
  elseif tabIndex == 4 then
    local _itemData = self.itemdata and self.itemdata:IsEquip() and self.itemdata or nil
    self:_JumpPanel("EquipCardView", {isCombine = true, itemdata = _itemData})
    self:SetMoneyIDs({100})
  elseif tabIndex == 5 then
    local _itemData = self.itemdata and self.itemdata:IsEquip() and self.itemdata or nil
    local advanceCost = self.viewdata.viewdata and self.viewdata.viewdata.lockedAdvanceCost
    self:_JumpPanel("EnchantIntegerCombineView", {
      isCombine = true,
      OnClickChooseBordCell_data = _itemData,
      lockedAdvanceCost = advanceCost
    })
    self:SetMoneyIDs({100, 135})
  elseif tabIndex == 6 then
    self:_JumpPanel("EquipMemoryCombineView", {
      isCombine = true,
      itemdata = self.itemdata
    })
    self:SetMoneyIDs({52901, 52902})
  end
  UIManagerProxy.Instance:_HideViewMaskAdaption()
end

function EquipIntegrateView:_JumpPanel(panelKey, viewData)
  if not panelKey or not PanelConfig[panelKey] then
    return
  end
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig[panelKey],
    viewdata = viewData
  })
end

function EquipIntegrateView:_CheckCanOpen(menuId, withTip)
  return FunctionUnLockFunc.Me():CheckCanOpen(menuId, withTip)
end

function EquipIntegrateView:HandleEquipUpdate()
  if not self.itemdata then
    return
  end
  local item = BagProxy.Instance:GetItemByGuid(self.itemdata.id)
  if item then
    self.itemCell:SetData(item)
    self.itemName.text = self.itemdata:GetName()
    self.itemCell:UpdateNumLabel(1)
    self.itemCell:ActiveNewTag(false)
  end
  self:UpdateMoney()
end

function EquipIntegrateView:HandleEquipUpdateSuccess(note)
  local item = note.body
  xdlog("HandleEquipUpdateSuccess", item and item.id)
  self.itemdata = item
  if item then
    self.itemCell:SetData(item)
    self.itemName.text = self.itemdata:GetName()
    self.itemCell:UpdateNumLabel(1)
    self.itemCell:ActiveNewTag(false)
  else
    EquipComposeProxy.Instance:SetCurOperEquipGuid(nil)
    self.itemCell:SetData()
    self.itemName.text = ZhString.EquipIntegrate_ChooseEquip
  end
  self:UpdateMoney()
  self:RefreshTabs()
end

function EquipIntegrateView:SetMoneyIDs(ids)
  if not self.costItemIDs then
    self.costItemIDs = {}
  else
    TableUtility.ArrayClear(self.costItemIDs)
  end
  TableUtility.ArrayShallowCopy(self.costItemIDs, ids)
  self:UpdateMoney()
end

function EquipIntegrateView:UpdateMoney()
  if not self.costItemIDs then
    return
  end
  for i = 1, 2 do
    local costID = self.costItemIDs[i]
    if costID then
      self.cost[i].go:SetActive(true)
      IconManager:SetItemIconById(costID, self.cost[i].icon)
      self.cost[i].label.text = StringUtil.NumThousandFormat(HappyShopProxy.Instance:GetItemNum(costID))
      local isMoney = costID == GameConfig.MoneyId.Zeny or costID == GameConfig.MoneyId.Lottery
      self.cost[i].plus:SetActive(isMoney and not BranchMgr.IsJapan())
    else
      self.cost[i].go:SetActive(false)
    end
  end
end

function EquipIntegrateView:TryGetMoney()
  MsgManager.ConfirmMsgByID(41164, function()
    EventManager.Me():PassEvent(UIEvent.ExitCallback)
    FunctionNewRecharge.Instance():OpenUI(PanelConfig.NewRecharge_TDeposit)
    self:CloseSelf()
  end)
end

function EquipIntegrateView:SetExitCallback(callback)
  self.exitCallback = callback
end

local miyin_refine_equiptype = {
  8,
  9,
  10,
  11,
  13
}
local should_miyin_refine = function(itemData)
  local equipInfo = itemData.equipInfo
  if not equipInfo then
    return
  end
  if TableUtility.ArrayFindIndex(miyin_refine_equiptype, equipInfo.equipData.EquipType) > 0 then
    return true
  end
end

function EquipIntegrateView:HandleReConnent()
  self.exitCallback = nil
  self:CloseSelf()
end
