autoImport("TicketPreviewCell")
TicketPreview = class("TicketPreview", BaseView)
TicketPreview.ViewType = UIViewType.PopUpLayer

function TicketPreview:Init()
  self:FindObjs()
  self:InitView()
  self:AddListenEvts()
  self:InitData()
end

function TicketPreview:InitData()
  self.ticket = self.viewdata.viewdata
  self.tipData = {
    ignoreBounds = {
      self.grid.gameObject
    },
    funcConfig = _EmptyTable
  }
  self.products = {}
end

function TicketPreview:FindObjs()
  self.grid = self:FindComponent("Grid", UIGrid)
  self.roleTex = self:FindComponent("RoleTex", UITexture)
  self.normalStick = self:FindComponent("NormalStick", UISprite)
end

function TicketPreview:InitView()
  self.listCtrl = UIGridListCtrl.new(self.grid, TicketPreviewCell, "RecipeCell")
  self.listCtrl:AddEventListener(MouseEvent.MouseClick, self.OnMouseClick, self)
  self.listCtrl:AddEventListener(EquipChooseCellEvent.ClickItemIcon, self.OnShowItemTip, self)
  self:AddDragEvent(self.roleTex.gameObject, function(go, delta)
    self:RotateRoleEvt(go, delta)
  end)
end

function TicketPreview:AddListenEvts()
end

function TicketPreview:OnEnter()
  TicketPreview.super.OnEnter(self)
  self:AdjustDepth()
  self:ListProducts()
  self:UpdateRoleTex()
end

local addDepth = 10

function TicketPreview:AdjustDepth()
  if self.adjustDepth then
    return
  end
  self.adjustDepth = true
  local panels = self:FindComponents(UIPanel)
  for i = 1, #panels do
    panels[i].depth = panels[i].depth + addDepth
  end
end

function TicketPreview:OnMouseClick(cellCtl)
  if not ShopMallProxy.Instance:JudgeSelfProfession(cellCtl.data.staticData.id) then
    MsgManager.FloatMsg(nil, ZhString.TicketPrev_CurProfessionCannotEquip)
    return
  end
  if cellCtl.data.equipInfo and cellCtl.data.equipInfo:IsMyDisplayForbid() then
    MsgManager.ShowMsgByID(40310)
    return
  end
  self.chooseId = cellCtl.data.staticData.id
  local cells = self.listCtrl:GetCells()
  for _, cell in pairs(cells) do
    cell:SetChoose(self.chooseId)
  end
  self:UpdateRoleTex()
end

local itemTipOffset = {-210, -35}

function TicketPreview:OnShowItemTip(cellCtl)
  if cellCtl and cellCtl.data then
    self.tipData.itemdata = cellCtl.data
    local tip = self:ShowItemTip(self.tipData, self.normalStick, nil, itemTipOffset)
    if tip and tip.HideShowTpBtn then
      tip:HideShowTpBtn()
    end
  end
end

function TicketPreview:OnQueryShopConfig()
  TableUtility.ArrayClear(self.products)
  local shopItems, shopItemData = HappyShopProxy.Instance:GetShopItems()
  for i = 1, #shopItems do
    shopItemData = HappyShopProxy.Instance:GetShopItemDataByTypeId(shopItems[i])
    if shopItemData then
      TableUtility.ArrayPushBack(self.products, shopItemData:GetItemData())
    end
  end
  self.listCtrl:ResetDatas(self.products)
end

local previewStaticData = {}
local tryInitializePreviewStaticData = function()
  if next(previewStaticData) then
    return
  end
  local data
  for _, sData in pairs(Table_Preview) do
    data = previewStaticData[sData.Itemid] or {}
    data[1] = sData.MaleProduct
    data[2] = sData.FemaleProduct
    previewStaticData[sData.Itemid] = data
  end
end

function TicketPreview:ListProducts()
  TableUtility.ArrayClear(self.products)
  tryInitializePreviewStaticData()
  local ticketId = self.ticket.staticData.id
  local products = previewStaticData[ticketId] and previewStaticData[ticketId][Game.Myself.data.userdata:Get(UDEnum.SEX)]
  if products then
    for i = 1, #products do
      TableUtility.ArrayPushBack(self.products, ItemData.new("Product", products[i]))
    end
  end
  self.listCtrl:ResetDatas(self.products)
end

function TicketPreview:UpdateRoleTex()
  self:RefreshByUserData(Game.Myself.data.userdata)
end

function TicketPreview:RefreshByUserData(userdata)
  if not userdata then
    return
  end
  local prof = userdata:Get(UDEnum.PROFESSION)
  local parts = Asset_RoleUtility.CreateUserRoleParts(userdata)
  parts[Asset_Role.PartIndex.Mount] = 0
  Asset_RoleUtility.SetFashionPreviewParts(self.chooseId, prof, userdata:Get(UDEnum.SEX), nil, parts)
  local isPreviewMount = self.chooseId ~= nil and ItemUtil.getItemRolePartIndex(self.chooseId) == Asset_Role.PartIndex.Mount
  local mountScale = isPreviewMount and GameConfig.UIMountScale.scale or 1
  local suffixMap = Table_Class[prof].ActionSuffixMap
  self.model = UIModelUtil.Instance:SetRoleModelTexture(self.roleTex, parts, nil, mountScale, isPreviewMount, false, suffixMap, function(obj)
    self.model = obj
    self.uiModelCell = UIModelUtil.Instance:GetUIModelCell(self.roleTex)
    local equipData = self.chooseId and Table_Equip[self.chooseId]
    if equipData and (equipData.EquipType == 1 or equipData.Type == "Shield") then
      self.model:PlayAction_AttackIdle()
    elseif isPreviewMount then
      self.model:PlayAction_Idle()
    end
  end)
  self.model:RegisterWeakObserver(self)
  Asset_Role.DestroyPartArray(parts)
end

function TicketPreview:RotateRoleEvt(go, delta)
  if self.model then
    local deltaAngle = -delta.x * 360 / 400
    self.model:RotateDelta(deltaAngle)
  end
end

function TicketPreview:ObserverDestroyed(obj)
  if obj == self.model then
    self.model = nil
  end
end

function TicketPreview.IsTicket(itemId)
  if not itemId or not Table_Preview then
    return false
  end
  tryInitializePreviewStaticData()
  return previewStaticData[itemId] ~= nil
end
