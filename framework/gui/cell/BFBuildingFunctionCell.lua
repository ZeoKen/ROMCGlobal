BFBuildingFunctionCell = class("BFBuildingFunctionCell", ItemCell)
local buildingIns, buildingType, shopIns, tickManager

function BFBuildingFunctionCell:Init()
  if not buildingIns then
    buildingIns = BFBuildingProxy.Instance
    buildingType = BFBuildingProxy.Type
    shopIns = HappyShopProxy.Instance
    tickManager = TimeTickManager.Me()
  end
  self.drag = self.gameObject:GetComponent(UIDragScrollView)
  self.cellContainer = self:FindGO("CellContainer")
  if self.cellContainer then
    local obj = self:LoadPreferb("cell/ItemCell", self.cellContainer)
    obj.transform.localPosition = LuaGeometry.Const_V3_zero
  end
  BFBuildingFunctionCell.super.Init(self)
  self.desc = self:FindComponent("desc", UILabel)
  self.choose = self:FindGO("Choose")
  self:SetChoose()
  self:FindGO("donateSp"):SetActive(false)
  self.btn = self:FindGO("ExchangeButton")
  self.btnColl = self.btn:GetComponent(BoxCollider)
  self.btnText = self:FindComponent("Label", UILabel, self.btn)
  self.iconlock = self:FindGO("iconlock")
  self:InitCostCtrl()
  self:AddUIEvents()
end

function BFBuildingFunctionCell:InitCostCtrl()
  self.costGrid = self:FindGO("CostGrid"):GetComponent(UIGrid)
  self.costMoneySprite = {}
  self.costMoneySprite[1] = self:FindComponent("costMoneySprite", UISprite)
  self.costMoneySprite[2] = self:FindComponent("costMoneySprite1", UISprite)
  self.costMoneyNums = {}
  self.costMoneyNums[1] = self:FindComponent("costMoneyNums", UILabel)
  self.costMoneyNums[2] = self:FindComponent("costMoneyNums1", UILabel)
end

function BFBuildingFunctionCell:AddUIEvents()
  self:AddCellClickEvent()
  self:AddClickEvent(self.cellContainer, function()
    self:PassEvent(HappyShopEvent.SelectIconSprite, self)
  end)
  UIUtil.HandleDragScrollForObj(self.cellContainer, self.drag)
  self:AddClickEvent(self.btn, function(go)
    self:PassEvent(BFBuildingEvent.UseFunction, self)
  end)
end

function BFBuildingFunctionCell:SetData(data)
  if self.btype == buildingType.Toy then
    self:ToySetData(data)
  elseif self.btype == buildingType.Transform then
    self:TransformSetData(data)
  else
    LogUtility.WarningFormat("Cannot find SetData func of btype = {0}", self.btype)
  end
end

function BFBuildingFunctionCell:ToySetData(data)
  self.btn:SetActive(false)
  local id = data
  data = shopIns:GetShopItemDataByTypeId(id)
  self.gameObject:SetActive(data ~= nil)
  if data then
    local itemData = data:GetItemData()
    local goodsCount = data.goodsCount
    if goodsCount and 1 < goodsCount then
      itemData.num = goodsCount
    end
    BFBuildingFunctionCell.super.SetData(self, itemData)
    self.choose:SetActive(false)
    local isLock = data:GetLock()
    self:SetLock(isLock)
    self.desc.text = isLock and data:GetLockDesc() or ""
    if data.ItemCount and data.ItemID and not isLock then
      for i = 1, #self.costMoneySprite do
        local temp = i
        if temp == 1 then
          temp = ""
        end
        local moneyId = data["ItemID" .. temp]
        local icon = Table_Item[moneyId] and Table_Item[moneyId].Icon
        if icon then
          self.costMoneySprite[i].gameObject:SetActive(true)
          IconManager:SetItemIcon(icon, self.costMoneySprite[i])
          local price = data:GetBuyDiscountPrice(data["ItemCount" .. temp], 1)
          local priceStr = StringUtil.NumThousandFormat(price)
          if price <= shopIns:GetItemNum(moneyId) then
            self.costMoneyNums[i].text = priceStr
          else
            self.costMoneyNums[i].text = string.format("[c][fb725f]%s[-][/c]", priceStr)
          end
        else
          self.costMoneySprite[i].gameObject:SetActive(false)
        end
      end
      tickManager:CreateOnceDelayTick(16, function(self)
        self.costGrid:Reposition()
        self.costGrid.repositionNow = true
      end, self)
    end
  end
  self.data = id
end

function BFBuildingFunctionCell:TransformSetData(data)
  self.itemid = data
  if not data then
    return
  end
  if data then
    self.itemData = ItemData.new("building", self.itemid)
    BFBuildingFunctionCell.super.SetData(self, self.itemData)
    self.nameLab.text = self.itemData.staticData.NameZh
    self.desc.text = self.itemData.staticData.Desc
  end
  self:SelfUpdateCell()
end

function BFBuildingFunctionCell:SetLock(isLock)
  isLock = isLock and true or false
  self.iconlock:SetActive(isLock)
  self.costGrid.gameObject:SetActive(not isLock)
  self.desc.width = isLock and 360 or 240
  if isLock then
    self:SetTextureGrey(self.cellContainer)
  else
    self:SetTextureWhite(self.cellContainer)
  end
end

function BFBuildingFunctionCell:SelfUpdateCell()
  self.costGrid.gameObject:SetActive(false)
  self.btn:SetActive(true)
  local cbData = buildingIns:GetCurBuildingData()
  local cbRun = cbData.status == EBUILDSTATUS.EBUILDSTATUS_RUN
  local cbui = buildingIns:GetCurBuildingUICtrl()
  self.inUse = cbui and buildingIns:CheckFunctionInUse(cbui.id, self.itemid)
  self:SetStatus(cbRun, self.inUse)
end

function BFBuildingFunctionCell:SetStatus(cbRun, inuse)
  if inuse then
    self.btnColl.enabled = false
    self:SetTextureGrey(self.btn)
    self:SetTextureWhite(self.cellContainer)
    self.btnText.text = ZhString.BFBuilding_button_inuse
  elseif cbRun then
    self.btnColl.enabled = true
    self:SetTextureWhite(self.btn, ColorUtil.ButtonLabelOrange)
    self:SetTextureWhite(self.cellContainer)
    self.btnText.text = ZhString.BFBuilding_button_use1
  else
    self.btnColl.enabled = false
    self:SetTextureGrey(self.btn)
    self:SetTextureGrey(self.cellContainer)
    self.btnText.text = ZhString.BFBuilding_button_use1
  end
  self.iconlock:SetActive(not cbRun)
end

function BFBuildingFunctionCell:SetChoose(isChoose)
  isChoose = isChoose and true or false
  self.choose:SetActive(isChoose)
end
