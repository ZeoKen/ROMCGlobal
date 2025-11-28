local CELL_PREFAB = "cell/RoleEquipItemCell"
local EQUIP_MAXINDEX
autoImport("MyselfEquipItemCell")
autoImport("MyselfEquipMemoryItemCell")
EquipMemoryPage = class("EquipMemoryPage", SubView)

function EquipMemoryPage:Init()
  EQUIP_MAXINDEX = 12
  self.chooseSymbol = self:FindGO("EquipChoose")
  self.normalStick = self.container.normalStick
  self:InitCtls()
  self:AddViewInterest()
end

function EquipMemoryPage:InitCtls()
  self:InitEquipCtl()
end

function EquipMemoryPage:InitEquipCtl()
  self.equipGrid = self:FindComponent("EquipMemoryGrid", UIGrid)
  self.roleEquips = {}
  for i = 1, EQUIP_MAXINDEX do
    local obj
    obj = self:LoadPreferb("cell/RoleEquipItemCell", self.equipGrid)
    obj.name = "EquipMemoryItemCell" .. i
    self.roleEquips[i] = MyselfEquipMemoryItemCell.new(obj, i)
    self.roleEquips[i]:AddEventListener(MouseEvent.MouseClick, self.ClickEquip, self)
    self.roleEquips[i]:AddEventListener(MouseEvent.DoubleClick, self.DoubleClickEquip, self)
  end
  self.equipGrid:Reposition()
end

function EquipMemoryPage:AddViewInterest()
  self:AddListenEvt(ItemEvent.MemoryUpdate, self.UpdateEquip)
  self:AddListenEvt(ServiceEvent.ItemUpdateMemoryPosItemCmd, self.UpdateEquip)
  self:AddListenEvt(MyselfEvent.MyProfessionChange, self.UpdateEquip)
  self:AddListenEvt(ItemEvent.Equip, self.CancelChoose)
end

function EquipMemoryPage:OnEnter()
  xdlog("111111111111 EquipMemoryPage  OnEnter")
  EquipMemoryPage.super.OnEnter(self)
  self.grids = {}
  self:UpdateEquip()
end

function EquipMemoryPage:ClickEquip(cellCtl)
  if self.container.markingFavoriteMode then
    return
  end
  local packageView = self.container
  if cellCtl ~= nil and self.chooseEquip ~= cellCtl then
    self:SetChoose(cellCtl)
    local data = cellCtl.data
    if data and data.staticData then
      local funcs = self.container:GetDataFuncs(data, FunctionItemFunc_Source.RoleEquipBag, cellCtl.isfashion)
      local callback = function()
        self:CancelChoose()
      end
      local show = false
      local sdata = {
        itemdata = data,
        funcConfig = funcs,
        ignoreBounds = {
          cellCtl.gameObject
        },
        callback = callback,
        showUpTip = true,
        showFullAttr = PvpProxy.Instance:IsFreeFire() and show,
        showButton = "equip"
      }
      local itemTip = self:ShowItemTip(sdata, self.normalStick, nil, tipOffset)
      if not cellCtl:IsEffective() then
        itemTip:GetCell(1):SetNoEffectTip(true)
      end
    else
      self:ShowItemTip()
    end
  else
    self:CancelChoose()
  end
end

function EquipMemoryPage:SetChoose(cellCtl)
  self:SetChoosenSite()
  if cellCtl then
    local index = cellCtl.index
    if type(index) == "number" then
      BagProxy.Instance:SetToEquipPos(ItemUtil.GetEposByIndex(index))
    else
      BagProxy.Instance:SetToEquipPos()
    end
    local go = cellCtl.gameObject
    if go then
      self.chooseSymbol:SetActive(true)
      self.chooseSymbol.transform:SetParent(go.transform, false)
    else
      self.chooseSymbol:SetActive(false)
      self.chooseSymbol.transform:SetParent(go.transform, false)
      self.chooseSymbol.transform:SetParent(self.trans, false)
    end
    self.chooseEquip = cellCtl
  else
    self.chooseSymbol:SetActive(false)
    self.chooseSymbol.transform:SetParent(self.trans, false)
    BagProxy.Instance:SetToEquipPos()
    self.chooseEquip = nil
  end
end

function EquipMemoryPage:ShowHide(var)
  if var then
    self:Show(self.equipGrid)
    self.equipGrid:Reposition()
  else
    self:Hide(self.equipGrid)
  end
end

function EquipMemoryPage:SetChoosenSite(cellCtl)
  if cellCtl then
    local index = cellCtl.index
    local go = cellCtl.gameObject
    if go then
      self.chooseSymbol:SetActive(true)
      self.chooseSymbol.transform:SetParent(go.transform, false)
    else
      self.chooseSymbol:SetActive(false)
      self.chooseSymbol.transform:SetParent(go.transform, false)
      self.chooseSymbol.transform:SetParent(self.trans, false)
    end
    self.chooseSite = index
  else
    self.chooseSymbol:SetActive(false)
    self.chooseSymbol.transform:SetParent(self.trans, false)
    self.chooseSite = nil
  end
end

function EquipMemoryPage:DoubleClickEquip(cellCtl)
  if self.container.markingFavoriteMode then
    return
  end
  local packageView = self.container
  if packageView.equipStrengthenIsShow then
    return
  end
  local data = cellCtl.data
  if not data then
    return
  end
  if data:HasMemoryInfo() then
    local index = cellCtl.index
    xdlog("移除记忆 index", index)
    ServiceItemProxy.Instance:CallMemoryUnEmbedItemCmd(index)
  end
  self:SetChoose()
  TipManager.Instance:CloseItemTip()
  BagProxy.Instance:SetToEquipPos()
end

function EquipMemoryPage:UpdateEquip()
  self:UpdateEquipItems()
  if self.equipGrid then
    self.equipGrid.repositionNow = true
  end
end

function EquipMemoryPage:UpdateEquipItems()
  local memoryPosData = EquipMemoryProxy.Instance.equipPosData
  local fullfire = PvpProxy.Instance:IsFreeFire()
  for i = 1, EQUIP_MAXINDEX do
    local equipCell = self.roleEquips[i]
    local posData = EquipMemoryProxy.Instance:GetPosData(i, fullfire)
    if equipCell and posData then
      local _itemData = ItemData.new("EquipedMemory", posData.staticId)
      _itemData.equipMemoryData = posData
      _itemData.sitePos = i
      equipCell:SetData(_itemData)
    else
      equipCell:SetData(nil)
    end
  end
end

function EquipMemoryPage:CancelChoose()
  self.chooseSymbol:SetActive(false)
  self.chooseSymbol.transform:SetParent(self.trans, false)
  self:ShowItemTip()
  self:SetChoose()
end

function EquipMemoryPage:SetValidPosShow(itemData)
  if not itemData then
    for i = 1, #self.roleEquips do
      self.roleEquips[i]:ShowTarget(false)
    end
    return
  end
  local staticId = itemData.staticData.id
  local staticData = Table_ItemMemory[staticId]
  local equipPoses = staticData and staticData.CanEquip and staticData.CanEquip.EquipPos or {}
  for i = 1, #self.roleEquips do
    if self.roleEquips[i].index and TableUtility.ArrayFindIndex(equipPoses, self.roleEquips[i].index) > 0 then
      self.roleEquips[i]:ShowTarget(true)
    else
      self.roleEquips[i]:ShowTarget(false)
    end
  end
end
