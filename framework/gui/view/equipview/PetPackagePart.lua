autoImport("CoreView")
PetPackagePart = class("PetPackagePart", CoreView)
autoImport("BagItemCell")
autoImport("PetBagItemCell")
autoImport("WrapListCtrl")
PetPackagePart.IsNoticeShow = "ServantMainView_IsNoticeShow"

function PetPackagePart:ctor()
end

local PetPackagePart_Path = "GUI/v1/part/PetPackagePart"

function PetPackagePart:CreateSelf(parent)
  if self.inited == true then
    return
  end
  self.inited = true
  self.gameObject = self:LoadPreferb_ByFullPath(PetPackagePart_Path, parent, true)
  self:UpdateLocalPosCache()
  self:InitPart()
end

function PetPackagePart:InitPart()
  self:InitScrollPull()
  self.closeButton = self:FindGO("CloseButton")
  self:AddClickEvent(self.closeButton, function(go)
    TipManager.Instance:CloseItemTip()
    self:Hide()
  end)
  self.petHelpButton = self:FindGO("PetHelpButton")
  self:RegistShowGeneralHelpByHelpID(2100, self.petHelpButton)
  local container = self:FindGO("ItemContainer")
  self.itemCtrl = WrapListCtrl.new(container, PetBagItemCell, "BagItemCell", WrapListCtrl_Dir.Vertical, 4, 104)
  self.itemCtrl:AddEventListener(MouseEvent.MouseClick, self.ClickItemCell, self)
  self.itemCells = self.itemCtrl:GetCells()
  self.quickTitle = self:FindComponent("QuickTitle", UILabel)
  self.quickTitle.text = ZhString.PetPackagePart_QuickPetTitle
  self.quickGrid = self:FindGO("QuickItemGrid"):GetComponent(UIGrid)
  self.quickItemCtrl = UIGridListCtrl.new(self.quickGrid, PetBagItemCell, "BagItemCell")
  self.quickItemCtrl:AddEventListener(MouseEvent.MouseClick, self.ClickQuickItemCell, self)
  self.quickItemCells = self.quickItemCtrl:GetCells()
  self.normalStick = self:FindComponent("NormalStick", UIWidget)
  self.noneTip = self:FindGO("NoneTip")
  self.closecomp = self.gameObject:GetComponent(CloseWhenClickOtherPlace)
  
  function self.closecomp.callBack(go)
    self:Hide()
  end
  
  self:MapEvent()
end

function PetPackagePart:InitScrollPull()
  self.waitting = self:FindComponent("Waitting", UILabel)
  self.scrollView = self:FindComponent("ItemScrollView", ROUIScrollView)
  self.panel = self.scrollView.gameObject:GetComponent(UIPanel)
  
  function self.scrollView.OnBackToStop()
    self.waitting.text = ZhString.ItemNormalList_Refreshing
  end
  
  function self.scrollView.OnStop()
    self.scrollView:Revert()
    ServiceItemProxy.Instance:CallPackageSort(SceneItem_pb.EPACKTYPE_PET)
  end
  
  function self.scrollView.OnPulling(offsetY, triggerY)
    self.waitting.text = offsetY < triggerY and ZhString.ItemNormalList_PullRefresh or ZhString.ItemNormalList_CanRefresh
  end
  
  function self.scrollView.OnRevertFinished()
    self.waitting.text = ZhString.ItemNormalList_PullRefresh
  end
end

function PetPackagePart:AddIgnoreBounds(obj)
  if self.gameObject and self.closecomp then
    self.closecomp:AddTarget(obj.transform)
  end
end

function PetPackagePart:ClickItemCell(cellCtl)
  self:SetChoose(cellCtl)
  self:SetChoosen()
end

function PetPackagePart:SetChoose(cellCtl)
  local go = cellCtl and cellCtl.gameObject
  local data = cellCtl and cellCtl.data
  if data == nil or data == BagItemEmptyType.Empty or data == BagItemEmptyType.Grey or type(data) ~= "table" or data.staticData == nil then
    self.chooseId = 0
    self:ShowPackageItemTip()
    return
  end
  local newChooseId = data and data.id or 0
  if self.chooseId ~= newChooseId then
    self.chooseId = newChooseId
    self:ShowPackageItemTip(data, go)
  else
    self.chooseId = 0
    self:ShowPackageItemTip()
  end
end

function PetPackagePart:ClickQuickItemCell(cellCtl)
  self:SetChoose(cellCtl)
  self:SetChoosen()
end

function PetPackagePart:SetChoosen()
  for _, cell in pairs(self.quickItemCells) do
    cell:SetChooseId(self.chooseId)
  end
  for _, cell in pairs(self.itemCells) do
    cell:SetChooseId(self.chooseId)
  end
end

local PACK_FASHION_LEFTVIEWSTATE = "PackageView_LeftViewState_Fashion"

function PetPackagePart:ShowPackageItemTip(data, cellGO)
  if data == nil or data == BagItemEmptyType.Empty or data == BagItemEmptyType.Grey or type(data) ~= "table" or data.staticData == nil then
    self:ShowItemTip()
    return
  end
  local offset = {
    [1] = 190,
    [2] = 0
  }
  local callback = function()
    self.chooseId = 0
    for _, cell in pairs(self.itemCells) do
      cell:SetChooseId(self.chooseId)
    end
  end
  local state = FunctionItemFunc.Me():GetLeftViewState()
  local funcConfig = {}
  local baseFunc = FunctionItemFunc.GetItemFuncIds(data.staticData.id, nil, state == PACK_FASHION_LEFTVIEWSTATE)
  if baseFunc then
    for i = 1, #baseFunc do
      table.insert(funcConfig, baseFunc[i])
    end
  end
  local sdata = {
    itemdata = data,
    ignoreBounds = ignoreBounds,
    callback = callback,
    funcConfig = funcConfig
  }
  local itemtip = self:ShowItemTip(sdata, self.normalStick, NGUIUtil.AnchorSide.Right, offset)
  itemtip:AddIgnoreBounds(self.gameObject)
  self:AddIgnoreBounds(itemtip.gameObject)
end

function PetPackagePart:UpdateInfo(items, quickItems)
  local petBag = BagProxy.Instance.petBagData
  items = items or petBag:GetItems()
  if #items == 0 then
    self.noneTip:SetActive(true)
    self.scrollView.gameObject:SetActive(false)
  else
    self.noneTip:SetActive(false)
    self.scrollView.gameObject:SetActive(true)
  end
  self.itemCtrl:ResetDatas(items)
  quickItems = quickItems or petBag:GetQuickItems()
  self.quickItemCtrl:ResetDatas(quickItems)
  self:UpdateDataSign(items, quickItems)
end

function PetPackagePart:UpdatePetCD()
  if self.itemCells then
    for _, cell in pairs(self.itemCells) do
      if cell.UpdatePetCD then
        cell:UpdatePetCD()
      end
    end
  end
  if self.quickItemCells then
    for _, cell in pairs(self.quickItemCells) do
      if cell.UpdatePetCD then
        cell:UpdatePetCD()
      end
    end
  end
end

local GetPetItemSign = function(items)
  local sign = ""
  if items then
    for i = 1, #items do
      local data = items[i]
      sign = sign .. tostring(type(data) == "table" and data.id or data) .. ";"
    end
  end
  return sign
end

function PetPackagePart:UpdateDataSign(items, quickItems)
  self.itemDataCount = items and #items or 0
  self.quickItemDataSign = GetPetItemSign(quickItems)
end

function PetPackagePart:IsDataSignChanged(items, quickItems)
  return self.itemDataCount ~= (items and #items or 0) or self.quickItemDataSign ~= GetPetItemSign(quickItems)
end

function PetPackagePart:RefreshPetCellState()
  if self.itemCells then
    for _, cell in pairs(self.itemCells) do
      if cell.UpdatePetFighting then
        cell:UpdatePetFighting(cell.data)
      end
      if cell.UpdatePetCD then
        cell:UpdatePetCD()
      end
    end
  end
  if self.quickItemCells then
    for _, cell in pairs(self.quickItemCells) do
      if cell.UpdatePetFighting then
        cell:UpdatePetFighting(cell.data)
      end
      if cell.UpdatePetCD then
        cell:UpdatePetCD()
      end
    end
  end
  self:SetChoosen()
end

function PetPackagePart:HandlePetUpdate()
  local petBag = BagProxy.Instance.petBagData
  local items = petBag:GetItems()
  local quickItems = petBag:GetQuickItems()
  if self:IsDataSignChanged(items, quickItems) then
    self:UpdateInfo()
  else
    self:RefreshPetCellState()
  end
end

local tempV3 = LuaVector3()

function PetPackagePart:SetPos(x, y, z)
  if self.gameObject then
    LuaVector3.Better_Set(tempV3, x, y, z)
    self.gameObject.transform.position = tempV3
    self:UpdateLocalPosCache()
  end
end

function PetPackagePart:UpdateLocalPosCache()
  self.localPos_x, self.localPos_y, self.localPos_z = LuaGameObject.GetLocalPosition(self.gameObject.transform)
end

function PetPackagePart:SetLocalOffset(x, y, z)
  LuaVector3.Better_Set(tempV3, self.localPos_x + x, self.localPos_y + y, self.localPos_z + z)
  self.gameObject.transform.localPosition = tempV3
end

function PetPackagePart:MapEvent()
end

function PetPackagePart:Show()
  if not self.inited then
    return
  end
  local petBag = BagProxy.Instance.petBagData
  local items = petBag:GetItems()
  local isNoticeShow = FunctionPlayerPrefs.Me():GetBool(PetPackagePart.IsNoticeShow)
  if not isNoticeShow and 0 < #items then
    self.closecomp.enabled = false
    GameFacade.Instance:sendNotification(UIEvent.ShowUI, {
      viewname = "PetPackagePopView",
      viewdata = {msgid = 8026}
    })
  end
  self.gameObject:SetActive(true)
  EventManager.Me():AddEventListener(ItemEvent.PetUpdate, self.HandlePetUpdate, self)
  EventManager.Me():AddEventListener(ItemEvent.ItemUpdate, self.UpdatePetCD, self)
  EventManager.Me():AddEventListener(ServiceEvent.NUserCDTimeUserCmd, self.UpdatePetCD, self)
  EventManager.Me():AddEventListener(UICloseEvent.GeneralHelpClose, self.ResetClosecomp, self)
  EventManager.Me():AddEventListener(UICloseEvent.PetPackagePopViewClose, self.ResetClosecomp, self)
  EventManager.Me():AddEventListener(PetEvent.CallbackPetConfirm, self.HandleEnableCloseComp, self)
  self:UpdateInfo(items)
  self.itemCtrl:ResetPosition()
  self:SetChoosen()
end

function PetPackagePart:Hide()
  if not self.inited then
    return
  end
  ServiceItemProxy.Instance:CallBrowsePackage(SceneItem_pb.EPACKTYPE_PET)
  self.gameObject:SetActive(false)
  EventManager.Me():RemoveEventListener(ItemEvent.PetUpdate, self.HandlePetUpdate, self)
  EventManager.Me():RemoveEventListener(ItemEvent.ItemUpdate, self.UpdatePetCD, self)
  EventManager.Me():RemoveEventListener(ServiceEvent.NUserCDTimeUserCmd, self.UpdatePetCD, self)
  EventManager.Me():RemoveEventListener(UICloseEvent.GeneralHelpClose, self.ResetClosecomp, self)
  EventManager.Me():RemoveEventListener(UICloseEvent.PetPackagePopViewClose, self.ResetClosecomp, self)
  EventManager.Me():RemoveEventListener(PetEvent.CallbackPetConfirm, self.HandleEnableCloseComp, self)
  self.chooseId = 0
end

function PetPackagePart:ResetClosecomp()
  self:HandleEnableCloseComp(true)
end

function PetPackagePart:HandleEnableCloseComp(var)
  self.closecomp.enabled = var
end
