ShopMallExchangeDetailCell = class("ShopMallExchangeDetailCell", ItemCell)

function ShopMallExchangeDetailCell:Init()
  self.cellContainer = self:FindGO("CellContainer")
  if self.cellContainer then
    local obj = self:LoadPreferb("cell/ItemCell", self.cellContainer)
    obj.transform.localPosition = LuaGeometry.GetTempVector3()
    self.cellContainer:AddComponent(UIDragScrollView)
  end
  ShopMallExchangeDetailCell.super.Init(self)
  self:FindObjs()
  self:AddEvts()
  self:AddCellClickEvent()
end

function ShopMallExchangeDetailCell:FindObjs()
  self.name = self:FindGO("Name"):GetComponent(UILabel)
  self.money = self:FindGO("Money"):GetComponent(UILabel)
  self.moneyIcon = self:FindGO("MoneyIcon"):GetComponent(UISprite)
  IconManager:SetItemIcon(Table_Item[100].Icon, self.moneyIcon)
  self.choose = self:FindGO("Choose")
  self.expire = self:FindGO("Expire")
  self.publicity = self:FindGO("Publicity")
  if self.publicity then
    self.publicity = self.publicity:GetComponent(UILabel)
  end
  self.bgSp = self.gameObject:GetComponent(UIMultiSprite)
  self.boothIcon = self:FindGO("BoothIcon")
  self.normalContainer = self:FindGO("normalContainer")
  self.emptyContainer = self:FindGO("emptyContainer")
end

function ShopMallExchangeDetailCell:AddEvts()
  self:AddClickEvent(self.cellContainer, function(g)
    self:ShowTips()
  end)
end

function ShopMallExchangeDetailCell:SetData(data)
  self.gameObject:SetActive(data ~= nil)
  if data then
    if data.itemid then
      local item = Table_Item[data.itemid]
      if item ~= nil then
        local itemData = data:GetItemData()
        if itemData and itemData:IsCard() then
          self.name.text = itemData:GetName()
        else
          self.name.text = item.NameZh
        end
        UIUtil.WrapLabel(self.name)
      else
        errorLog(string.format("ShopMallExchangeDetailCell SetData : Table_Item[%s] is nil", tostring(data.itemid)))
      end
    else
      errorLog("ShopMallExchangeDetailCell SetData : data.itemid is nil")
    end
    ShopMallExchangeDetailCell.super.SetData(self, data:GetItemData())
    self.data = data
    self.newTag:SetActive(false)
    if not data.isEmpty then
      if data.count and data.count > 999 then
        self.numLab.text = "999+"
      end
      if data.price then
        self.money.text = StringUtil.NumThousandFormat(data:GetPrice())
      else
        errorLog("ShopMallExchangeDetailCell SetData : data.price is nil")
      end
      if self.expire then
        if data.isExpired then
          self.expire:SetActive(true)
        else
          self.expire:SetActive(false)
        end
      end
      if self.choose then
        self.choose:SetActive(false)
      end
      if self.publicity then
        if data.publicityId and data.publicityId == 0 then
          self.publicity.gameObject:SetActive(false)
          self:OnDestroy()
        else
          self.publicity.gameObject:SetActive(true)
          if self.timeTick == nil then
            self.timeTick = TimeTickManager.Me():CreateTick(0, 1000, self.UpdatePublicity, self)
          end
          self:UpdatePublicity()
        end
      else
        self:OnDestroy()
      end
      if self.bgSp then
        self.bgSp.CurrentState = data.isBooth and 1 or 0
      end
      if self.boothIcon then
        self.boothIcon:SetActive(data.isBooth)
      end
    end
    if self.normalContainer then
      self.normalContainer:SetActive(not data.isEmpty)
    end
    if self.emptyContainer then
      self.emptyContainer:SetActive(true == data.isEmpty)
    end
  else
    if self.expire then
      self.expire:SetActive(false)
    end
    if self.bgSp then
      self.bgSp.CurrentState = 0
    end
    if self.boothIcon then
      self.boothIcon:SetActive(false)
    end
    if self.choose then
      self.choose:SetActive(false)
    end
    self:OnDestroy()
  end
end

function ShopMallExchangeDetailCell:SetChoose(isChoose)
  if isChoose then
    self.choose:SetActive(true)
  else
    self.choose:SetActive(false)
  end
end

local tipData, tipOffset = {
  funcConfig = {}
}, {205, 0}

function ShopMallExchangeDetailCell:ShowTips()
  tipData.itemdata = self.data:GetItemData()
  local tip = TipManager.Instance:ShowItemFloatTip(tipData, self.bg, NGUIUtil.AnchorSide.Right, tipOffset)
  if tip then
    tip:HideShowUpBtn()
  end
end

function ShopMallExchangeDetailCell:UpdatePublicity()
  if self.data and self.data.endTime then
    local time = self.data.endTime - ServerTime.CurServerTime() / 1000
    local min, sec
    if 0 < time then
      min, sec = ClientTimeUtil.GetFormatSecTimeStr(time)
    else
      min = 0
      sec = 0
    end
    self.publicity.text = string.format("%02d:%02d", min, sec)
    if min == 0 and sec == 0 then
      self:OnDestroy()
    end
  else
    self:OnDestroy()
  end
end

function ShopMallExchangeDetailCell:OnDestroy()
  self.timeTick = nil
  TimeTickManager.Me():ClearTick(self)
end

function ShopMallExchangeDetailCell:OnRemove()
  self:OnDestroy()
end
