autoImport("EquipCardChooseCell")
autoImport("EquipCardEditCell")
autoImport("EquipChooseBord")
autoImport("EquipMemoryEditCell")
autoImport("EquipMemorySiteChooseCell")
EquipMemoryEmbedView = class("EquipMemoryEmbedView", ContainerView)
EquipMemoryEmbedView.BrotherView = EquipMemoryCombineView
EquipMemoryEmbedView.ViewType = UIViewType.NormalLayer
local _EquipMemoryProxy
local _PACKAGECHECK = {
  1,
  2,
  22
}
local _ValidSites = {
  1,
  2,
  3,
  4,
  5,
  6
}
local _targetEquipCheck = {
  1,
  2,
  20
}
local actionBtnLabs = {
  ZhString.EquipMemory_Equip,
  ZhString.EquipMemory_Replace
}
local activeLabelEffectColor = LuaColor.New(0.6862745098039216, 0.3764705882352941, 0.10588235294117647)
local againActiveLabelEffectColor = LuaColor.New(0.6862745098039216, 0.3764705882352941, 0.10588235294117647)

function EquipMemoryEmbedView:Init()
  self:InitView()
  self:MapEvent()
  _EquipMemoryProxy = EquipMemoryProxy.Instance
end

function EquipMemoryEmbedView:InitView()
  self.gameObject.transform.localPosition = LuaGeometry.GetTempVector3(-50, 0, 0)
  local resultPanel = self:FindGO("CardResult")
  resultPanel:SetActive(false)
  self.targetCell = self:FindGO("TargetCell")
  local obj = self:FindGO("ItemCell", self.targetCell)
  obj.transform.localPosition = LuaGeometry.GetTempVector3()
  obj.transform.localScale = LuaGeometry.GetTempVector3(1, 1, 1)
  self.itemCell = ItemCell.new(obj)
  self.itemCell:InitEquipPart()
  local sps = Game.GameObjectUtil:GetAllComponentsInChildren(obj, UIWidget, true)
  for i = 1, #sps do
    sps[i].depth = 10 + sps[i].depth
  end
  self.symbol = self:FindGO("Symbol"):GetComponent(UISprite)
  self.item_empty = self:FindGO("Plus", obj)
  self.finishPart = self:FindGO("FinishPart")
  self.finishPart_Label = self:FindGO("Label", self.finishPart):GetComponent(UILabel)
  self.finishPart_Label.text = ZhString.EquipMemory_EmbedInvalid
  self:AddClickEvent(self.targetCell, function(go)
    self:ClickTargetCell()
  end)
  local chooseContaienr = self:FindGO("ChooseContainer")
  self.chooseBord = EquipChooseBord_CombineSize.new(chooseContaienr)
  self.chooseBord:ActiveCloseButton(false)
  self.chooseBord:AddEventListener(EquipChooseBord.ChooseItem, self.ChooseItem, self)
  self.chooseBord:Hide()
  self.memoryChooseBord = EquipMultiChooseBord_CombineSize.new(chooseContaienr)
  self.memoryChooseBord:AddEventListener(EquipChooseBord.ChooseItem, self.HandleChooseMemory, self)
  self.memoryChooseBord:AddEventListener(EquipChooseCellEvent.ClickCancel, self.HandleRemoveMemory, self)
  self.memoryChooseBord:SetTypeLabelTextGetter(ItemUtil.GetMemoryTag)
  self.memoryChooseBord:SetBordTitle(ZhString.EquipMemory_ChooseMemory)
  self.memoryChooseBord:SetNoneTip(ZhString.EquipMemory_NoResult)
  self.memoryChooseBord:ActiveCloseButton(false)
  self.memoryChooseBord:Hide()
  self.sitePanel = self:FindGO("SitePanel")
  self.closeSiteBtn = self:FindGO("CloseButton", self.sitePanel)
  self.closeSiteBtn:SetActive(false)
  self.scrollView = self:FindGO("ScrollView", self.sitePanel):GetComponent(UIScrollView)
  self.siteCtrl = WrapListCtrl.new(self:FindGO("ChooseGrid", self.sitePanel), EquipMemorySiteChooseCell, "EquipSiteChooseCell", nil, 1, 0, true)
  self.siteCtrl:AddEventListener(MouseEvent.MouseClick, self.ChooseEquipPos, self)
  self.siteCtrl:AddEventListener(UICellEvent.OnLeftBtnClicked, self.HandleShowSiteEquipedMemory, self)
  self:PlayUIEffect(EffectMap.UI.EquipMemory_BG, self.targetCell, false)
  self.activePart = self:FindGO("ActivePart")
  self.memoryScrollViewBG = self:FindGO("ScrollViewBg"):GetComponent(UISprite)
  self.memoryAttrScrollView = self:FindGO("MemoryAttrScrollView"):GetComponent(UIScrollView)
  self.memoryAttrGrid = self:FindGO("MemoryAttrGrid"):GetComponent(UITable)
  self.memoryListCtrl = UIGridListCtrl.new(self.memoryAttrGrid, EquipMemoryAttrCell, "EquipMemoryAttrCell")
  self.actionBgSp = self:FindComponent("ActionBtn", UIMultiSprite, self.mainBoard)
  self.actionLabel = self:FindComponent("ActionLabel", UILabel, self.actionBgSp.gameObject)
  self.actionBtn_BoxCollider = self:FindComponent("ActionBtn", BoxCollider, self.mainBoard)
  self.actionLabel.text = actionBtnLabs[1]
  self.actionBgSp.CurrentState = 1
  self.actionLabel.color = ColorUtil.NGUIWhite
  self.actionLabel.effectColor = againActiveLabelEffectColor
  self.actionBgSp.gameObject:SetActive(false)
  self:AddClickEvent(self.actionBgSp.gameObject, function()
    self:HandleOpenMemoryList()
  end)
  self.emptyTip = self:FindGO("EmptyTip")
  self.noneTip = self:FindGO("NoneTip")
  self.fullBodyEffect = self:FindGO("FullBodyEffect")
  self.fullBodyEffect_Bg = self:FindGO("ResultBg", self.fullBodyEffect):GetComponent(UISprite)
  self.fullBodyEffect_Pattern = self:FindGO("Pattern", self.fullBodyEffect):GetComponent(UISprite)
  self.effectUpperShadow = self:FindGO("UpperShadow", self.fullBodyEffect):GetComponent(UISprite)
  self.extendBtn = self:FindGO("Arrow", self.fullBodyEffect)
  self.extendBtn_Sprite = self.extendBtn:GetComponent(UISprite)
  self.isEffectExtend = false
  self.effectScrollView = self:FindGO("ScrollView", self.fullBodyEffect):GetComponent(UIScrollView)
  self.effectScrollView_Panel = self:FindGO("ScrollView", self.fullBodyEffect):GetComponent(UIPanel)
  self.effectGrid = self:FindGO("EffectGrid", self.fullBodyEffect):GetComponent(UITable)
  self:AddClickEvent(self.extendBtn, function()
    self.isEffectExtend = not self.isEffectExtend
    if self.isEffectExtend then
      self.fullBodyEffect_Bg.height = 738
      self.extendBtn_Sprite.flip = 2
    else
      self.fullBodyEffect_Bg.height = 242
      self.extendBtn_Sprite.flip = 0
    end
    self.effectScrollView_Panel:UpdateAnchors()
    self.effectScrollView:ResetPosition()
    self.effectUpperShadow:UpdateAnchors()
    self.extendBtn_Sprite:UpdateAnchors()
    self.fullBodyEffect_Pattern:UpdateAnchors()
  end)
end

function EquipMemoryEmbedView:MapEvent()
  self:AddListenEvt(ItemEvent.MemoryUpdate, self.HandleEmbedSuc)
  self:AddListenEvt(ServiceEvent.ItemUpdateMemoryPosItemCmd, self.HandleEmbedSuc)
  self:AddListenEvt(ItemEvent.EquipIntegrate_TrySelectEquip, self.ClickTargetCell)
end

function EquipMemoryEmbedView:HandleRemoveMemory(itemData)
  local curSite = self.nowdata and self.nowdata.site
  if curSite then
    redlog("移除记忆", curSite)
    ServiceItemProxy.Instance:CallMemoryUnEmbedItemCmd(curSite)
  end
end

function EquipMemoryEmbedView:OnEnter()
  EquipMemoryEmbedView.super.OnEnter(self)
  local targetEquip = self.viewdata and self.viewdata.viewdata and self.viewdata.viewdata.itemdata
  if targetEquip then
    local sitePos = targetEquip.sitePos
    if sitePos then
      local _tempData = {site = sitePos}
      local posData = _EquipMemoryProxy:GetPosData(sitePos)
      if posData then
        local itemData = ItemData.new("MemoryData", posData.staticId)
        itemData.equipMemoryData = posData:Clone()
        local _tempData = {itemdata = itemData, site = sitePos}
        self:UpdateView(_tempData)
      else
        local _tempData = {site = sitePos}
        self:UpdateView(_tempData)
      end
    else
      self:ClickTargetCell()
    end
  else
    self:ClickTargetCell()
  end
  if self.npcdata then
    local rootTrans = self.npcdata.assetRole.completeTransform
    self:CameraFocusAndRotateTo(rootTrans, CameraConfig.SwingMachine_ViewPort, CameraConfig.SwingMachine_Rotation)
  else
    self:CameraFocusToMe()
  end
end

function EquipMemoryEmbedView:OnExit()
  EquipMemoryEmbedView.super.OnExit(self)
  self.itemCell = nil
  self:CameraReset()
end

function EquipMemoryEmbedView:ChooseItem(itemData)
  self:UpdateView(itemData)
end

function EquipMemoryEmbedView:ClickTargetCell()
  self:ChooseItem(nil)
  self:UpdateSites()
  self.memoryChooseBord:Hide()
end

function EquipMemoryEmbedView:UpdateView(data)
  local data = data
  if not data then
    self.noneTip:SetActive(true)
    self.itemCell:SetData()
    self:Hide(self.fullBodyEffect)
    self.item_empty:SetActive(true)
    self.symbol.gameObject:SetActive(false)
    self.emptyTip:SetActive(false)
    self.activePart:SetActive(false)
    self.actionBgSp.gameObject:SetActive(false)
    self:sendNotification(ItemEvent.EquipChooseSuccess)
    return
  end
  xdlog("UpdateView")
  self.noneTip:SetActive(false)
  self.actionBgSp.gameObject:SetActive(false)
  self.nowdata = data
  local itemdata = data and data.itemdata
  local site = data and data.site
  local roleEquip = BagProxy.Instance:GetEquipBySite(site)
  if roleEquip then
    self.itemCell:SetData(roleEquip)
    self.itemCell:UpdateNumLabel(1)
    self.itemCell:ActiveNewTag(false)
    if itemdata then
      itemdata.sitePos = site
      self:sendNotification(ItemEvent.EquipChooseSuccess, itemdata)
      xdlog("选定记忆数据 ", itemdata.staticData.id, itemdata.sitePos)
    end
  else
    self.itemCell:SetData()
    local site = data and data.site
    if site then
      self.item_empty:SetActive(false)
      self.symbol.gameObject:SetActive(true)
      local spriteName
      if site == 5 or site == 6 then
        spriteName = "bag_equip_6"
      else
        spriteName = "bag_equip_" .. site
      end
      IconManager:SetUIIcon(spriteName, self.symbol)
      self.symbol:MakePixelPerfect()
    else
      self.item_empty:SetActive(true)
      self.symbol.gameObject:SetActive(false)
    end
    self:sendNotification(ItemEvent.EquipChooseSuccess)
  end
  self:UpdateEquipMemory()
  self:HandleOpenMemoryList()
  self.chooseBord:Hide()
end

function EquipMemoryEmbedView:UpdateEquipMemory()
  local itemdata = self.nowdata and self.nowdata.itemdata
  local memoryData = itemdata and itemdata.equipMemoryData
  if not memoryData then
    redlog("没有记忆数据")
    self.emptyTip:SetActive(true)
    self.activePart:SetActive(false)
    self:SetActionBtnState(1)
    return
  end
  self.emptyTip:SetActive(false)
  self.activePart:SetActive(true)
  self:SetActionBtnState(2)
  local maxAttrCount = memoryData.maxAttrCount or 0
  local attrs = memoryData.memoryAttrs
  local result = {}
  for i = 1, maxAttrCount do
    if attrs[i] and attrs[i].previewid ~= nil and 0 < #attrs[i].previewid then
      local _tempData = {
        id = attrs[i].id,
        text = ZhString.EquipMemory_NotChosen,
        canUnlock = attrs[i].id == 0 and true or false
      }
      table.insert(result, _tempData)
    else
      local _tempData = {
        id = 0,
        unlockLv = i * 10
      }
      table.insert(result, _tempData)
    end
  end
  self.memoryListCtrl:ResetDatas(result)
  local size = NGUIMath.CalculateRelativeWidgetBounds(self.memoryAttrGrid.transform)
  local height = size.size.y
  self.memoryScrollViewBG.height = height + 10
  local panel = self.memoryAttrScrollView.panel
  panel:UpdateAnchors()
  self.memoryAttrScrollView:ResetPosition()
  if self.memoryChooseBord:ActiveSelf() then
    self:HandleOpenMemoryList()
  end
end

function EquipMemoryEmbedView:HandleOpenMemoryList()
  xdlog("打开记忆列表")
  local _BagProxy = BagProxy.Instance
  local result = {}
  local itemdata = self.nowdata and self.nowdata.itemdata
  if itemdata and itemdata.equipMemoryData then
    local _itemData = ItemData.new(itemdata.id, itemdata.equipMemoryData.staticId)
    _itemData:Copy(itemdata)
    _itemData.embeded = true
    _itemData.equiped = itemdata.equiped
    table.insert(result, _itemData)
    xdlog("加入本体", itemdata.id)
  end
  local curSite = self.nowdata and self.nowdata.site
  if curSite then
    for i = 1, #_PACKAGECHECK do
      local items = _BagProxy:GetBagByType(_PACKAGECHECK[i]):GetItems()
      for j = 1, #items do
        if items[j].equipMemoryData then
          local staticData = Table_ItemMemory[items[j].equipMemoryData.staticId]
          local validPoses = staticData and staticData.CanEquip and staticData.CanEquip.EquipPos
          if validPoses and TableUtility.ArrayFindIndex(validPoses, curSite) > 0 and items[j]:IsMemory() then
            table.insert(result, items[j])
          end
        end
      end
    end
  end
  xdlog("装备记忆数量", #result)
  table.sort(result, function(l, r)
    local l_equiped = l.equiped or 0
    local r_equiped = r.equiped or 0
    if l_equiped ~= r_equiped then
      return l_equiped > r_equiped
    end
    local l_power = l.equipMemoryData and l.equipMemoryData:GetValuePower() or 0
    local r_power = r.equipMemoryData and r.equipMemoryData:GetValuePower() or 0
    if l_power ~= r_power then
      return l_power > r_power
    end
    return l.staticData.id > r.staticData.id
  end)
  if 0 < #result then
    self.memoryChooseBord:Show()
    self.memoryChooseBord:ResetDatas(result, true)
    self.memoryChooseBord:SetChooseReference({
      self.nowdata.itemdata
    })
    local cells = self.memoryChooseBord.chooseCtl:GetCells()
    for i = 1, #cells do
      cells[i]:SetCancelButtonText("卸下")
    end
  else
    self.memoryChooseBord:Show()
    self.memoryChooseBord:ResetDatas({}, true)
  end
  self.sitePanel:SetActive(false)
end

function EquipMemoryEmbedView:HandleChooseMemory(itemData)
  local itemGuid = itemData and itemData.id
  local curSite = self.nowdata and self.nowdata.site
  xdlog("镶嵌记忆", itemGuid)
  if curSite and itemGuid then
    ServiceItemProxy.Instance:CallMemoryEmbedItemCmd(itemGuid, curSite)
  end
end

function EquipMemoryEmbedView:GetValidEquips()
  local _BagProxy = BagProxy.Instance
  local result = {}
  local typeValidEquips = _BagProxy:GetEquipsBySites(_ValidSites, _targetEquipCheck)
  for i = 1, #typeValidEquips do
    if Table_EquipCompose[typeValidEquips[i].staticData.id] then
      table.insert(result, typeValidEquips[i])
    elseif not isNew or typeValidEquips[i]:IsEquip() and typeValidEquips[i].equipInfo:IsNextGen() then
      table.insert(result, typeValidEquips[i])
    end
  end
  table.sort(result, function(l, r)
    local l_isEquiped = l.equiped or 0
    local r_isEquiped = r.equiped or 0
    if l_isEquiped ~= r_isEquiped then
      return l_isEquiped > r_isEquiped
    end
    local l_hasMemory = l.equipMemoryData and 1 or 0
    local r_hasMemory = r.equipMemoryData and 1 or 0
    if l_hasMemory ~= r_hasMemory then
      return l_hasMemory > r_hasMemory
    end
  end)
  return result
end

function EquipMemoryEmbedView:HandleEmbedSuc(note)
  xdlog("镶嵌成")
  local curSite = self.nowdata and self.nowdata.site
  local posData = curSite and _EquipMemoryProxy:GetPosData(curSite)
  if posData then
    local itemData = ItemData.new("MemoryData", posData.staticId)
    itemData.equipMemoryData = posData:Clone()
    local _tempData = {itemdata = itemData, site = curSite}
    self:UpdateView(_tempData)
  else
    local _tempData = {site = curSite}
    self:UpdateView(_tempData)
  end
end

function EquipMemoryEmbedView:HandleSwitchSingle(cell)
  if cell then
    cell:SwitchFolderState()
  end
  self.effectGrid:Reposition()
end

function EquipMemoryEmbedView:UpdateSites()
  if not self.validEquipPos then
    self.validEquipPos = {}
    for _, info in pairs(Table_ItemMemory) do
      local equipPoses = info.CanEquip and info.CanEquip.EquipPos
      for i = 1, #equipPoses do
        if not self.validEquipPos[equipPoses[i]] then
          self.validEquipPos[equipPoses[i]] = 1
          xdlog("Validpos", equipPoses[i])
        end
      end
    end
  end
  local result = {}
  for _pos, _ in pairs(self.validEquipPos) do
    local posData = _EquipMemoryProxy:GetPosData(_pos)
    local _tempData = {site = _pos}
    if posData then
      local itemData = ItemData.new("MemoryData", posData.staticId)
      itemData.equipMemoryData = posData:Clone()
      _tempData.itemdata = itemData
    end
    local roleEquip = BagProxy.Instance:GetEquipBySite(_pos)
    if roleEquip then
      _tempData.equipedItemData = roleEquip
    end
    table.insert(result, _tempData)
  end
  self.sitePanel:SetActive(true)
  self.siteCtrl:ResetDatas(result)
end

function EquipMemoryEmbedView:ChooseEquipPos(cell)
  local data = cell.data
  self:UpdateView(data)
end

function EquipMemoryEmbedView:HandleShowSiteEquipedMemory(cellCtrl)
  local data = cellCtrl.data
  local equipItemData = data and data.equipedItemData
  local itemdata = data and data.itemdata
  local showItemData
  if equipItemData then
    showItemData = equipItemData
  elseif itemdata then
    showItemData = itemdata
  else
    return
  end
  local sdata = {
    itemdata = showItemData,
    funcConfig = {},
    hideGetPath = true
  }
  self:ShowItemTip(sdata, self.tipStick, nil, {-190, 0})
end

function EquipMemoryEmbedView:HandleShowTargetData(cellCtrl)
  local data = cellCtrl.data
  if data == nil then
    return
  end
  local sdata = {
    itemdata = data,
    funcConfig = {},
    hideGetPath = true
  }
  self:ShowItemTip(sdata, self.tipStick, nil, {-190, 0})
end

function EquipMemoryEmbedView:SetActionBtnState(type)
  if type == 1 then
    self.actionLabel.text = actionBtnLabs[1]
  else
    self.actionLabel.text = actionBtnLabs[2]
  end
end
