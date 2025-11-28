autoImport("ItemTipBaseCell")
ActivityFlipCardBuyChanceCell = class("ActivityFlipCardBuyChanceCell", ItemTipBaseCell)

function ActivityFlipCardBuyChanceCell.Create(parent)
  local go = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell("ActivityFlipCardBuyChanceCell"), parent)
  go.transform.localPosition = LuaGeometry.GetTempVector3(0, 0, 0)
  NGUIUtil.AdjustPanelDepthByParent(go)
  return ActivityFlipCardBuyChanceCell.new(go)
end

function ActivityFlipCardBuyChanceCell:Init()
  self:FindObjs()
  self:InitAttriContext()
end

function ActivityFlipCardBuyChanceCell:FindObjs()
  local cellContainer = self:FindGO("CellContainer")
  self:InitItemCell(cellContainer)
  self.ownLabel = self:FindComponent("OwnInfo", UILabel)
  self.limitCountLabel = self:FindComponent("LimitCount", UILabel)
  self.price = self:FindComponent("Price", UILabel)
  self.confirmButton = self:FindGO("ConfirmButton")
  self:AddClickEvent(self.confirmButton, function()
    self:OnConfirm()
  end)
  self.cancelButton = self:FindGO("CancelButton")
  self.countInput = self:FindGO("CountBg"):GetComponent(UIInput)
  self.countPlusBg = self:FindGO("CountPlusBg"):GetComponent(UISprite)
  self.countSubtractBg = self:FindGO("CountSubtractBg"):GetComponent(UISprite)
  self:AddClickEvent(self.cancelButton.gameObject, function(g)
    self:OnCancel()
  end)
  self:AddPressEvent(self.countPlusBg.gameObject, function(g, b)
    self:PlusPressCount(b)
  end)
  self:AddPressEvent(self.countSubtractBg.gameObject, function(g, b)
    self:SubtractPressCount(b)
  end)
  EventDelegate.Set(self.countInput.onChange, function()
    self:InputOnChange()
  end)
  EventDelegate.Set(self.countInput.onSubmit, function()
    self:InputOnSubmit()
  end)
  self.priceIcon = self:FindComponent("PriceIcon", UISprite)
  self.totalPrice = self:FindGO("TotalPrice"):GetComponent(UILabel)
  self.totalPriceIcon = self:FindGO("TotalPriceIcon"):GetComponent(UISprite)
end

function ActivityFlipCardBuyChanceCell:SetData(data)
  self.activityId = data
  local config = Table_ActPersonalTimer[self.activityId]
  if config then
    self.itemId = config.Misc.chance_token
    self.data = ItemData.new("chanceToken", self.itemId)
    self.itemcell:SetData(self.data)
    if config.Misc.buy_chance_price then
      self.money = config.Misc.buy_chance_price[1]
      local price = config.Misc.buy_chance_price[2]
      IconManager:SetItemIconById(self.money, self.priceIcon)
      self.price.text = price
      IconManager:SetItemIconById(self.money, self.totalPriceIcon)
    end
    self:UpdateAttriContext()
    self.countInput.value = 1
  end
end

function ActivityFlipCardBuyChanceCell:Show()
  ActivityFlipCardBuyChanceCell.super.Show(self)
  self:OnShow()
end

function ActivityFlipCardBuyChanceCell:OnShow()
  self.maxcount = ActivityFlipCardProxy.Instance:GetMaxChanceCanBuy(self.activityId)
  local ownNum = ActivityFlipCardProxy.Instance:GetRemainFlipChance(self.activityId)
  self.ownLabel.text = string.format(ZhString.ItemTip_Owned, ownNum)
  self.limitCountLabel.text = string.format(ZhString.FlipCard_RemainBuyChance, self.maxcount)
  self:InputOnChange()
end

function ActivityFlipCardBuyChanceCell:InitItemCell(container)
  self:TryInitItemCell(container, "ItemCell", ItemCell)
end

function ActivityFlipCardBuyChanceCell:TryInitItemCell(container, pfbName, control)
  if container then
    local cellObj = self:LoadPreferb("cell/" .. pfbName, container)
    if not cellObj then
      return
    end
    cellObj.transform:SetParent(container.transform, true)
    cellObj.transform.localPosition = LuaGeometry.Const_V3_zero
    control = control or _G[pfbName]
    self.itemcell = control.new(container)
    self.itemcell:HideNum()
  end
end

function ActivityFlipCardBuyChanceCell:OnConfirm()
  local totalPrice = tonumber(self.price.text) * self.count
  MsgManager.DontAgainConfirmMsgByID(43445, function()
    if self.money == 151 then
      local myMoney = MyselfProxy.Instance:GetLottery()
      if myMoney < totalPrice then
        MsgManager.ConfirmMsgByID(3551, function()
          FunctionNewRecharge.Instance():OpenUI(PanelConfig.NewRecharge_TDeposit)
        end)
      else
        FunctionSecurity.Me():NormalOperation(function(price)
          ServiceActivityCmdProxy.Instance:CallFlipCardBuyChanceCmd(self.activityId, self.count, price)
        end, totalPrice)
      end
    else
      FunctionSecurity.Me():NormalOperation(function(price)
        ServiceActivityCmdProxy.Instance:CallFlipCardBuyChanceCmd(self.activityId, self.count, price)
      end, totalPrice)
    end
  end)
  self.gameObject:SetActive(false)
end

function ActivityFlipCardBuyChanceCell:OnCancel()
  self.gameObject:SetActive(false)
end

function ActivityFlipCardBuyChanceCell:PlusPressCount(isPressed)
  if isPressed then
    self.countChangeRate = 1
    TimeTickManager.Me():CreateTick(0, 150, function(owner, deltaTime)
      self:UpdateCount(1)
    end, self, 1001)
  else
    TimeTickManager.Me():ClearTick(self, 1001)
  end
end

function ActivityFlipCardBuyChanceCell:SubtractPressCount(isPressed)
  if isPressed then
    self.countChangeRate = 1
    TimeTickManager.Me():CreateTick(0, 150, function(owner, deltaTime)
      self:UpdateCount(-1)
    end, self, 1002)
  else
    TimeTickManager.Me():ClearTick(self, 1002)
  end
end

function ActivityFlipCardBuyChanceCell:UpdateCount(change)
  if tonumber(self.countInput.value) == nil then
    self.countInput.value = self.count
  end
  local count = tonumber(self.countInput.value) + self.countChangeRate * change
  if count < 1 then
    self.countChangeRate = 1
    return
  elseif count > self.maxcount then
    self.countChangeRate = 1
    return
  end
  self:UpdateTotalPrice(count)
  if self.countChangeRate <= 3 then
    self.countChangeRate = self.countChangeRate + 1
  end
end

function ActivityFlipCardBuyChanceCell:UpdateTotalPrice(count)
  self.count = count
  local totalPrice = tonumber(self.price.text) * count
  self.totalPrice.text = StringUtil.NumThousandFormat(totalPrice)
  if self.countInput.value ~= tostring(count) then
    self.countInput.value = count
  end
end

function ActivityFlipCardBuyChanceCell:InputOnChange()
  local count = tonumber(self.countInput.value)
  if count == nil then
    return
  end
  if self.maxcount == 0 then
    count = 0
    self:SetCountPlus(0.5)
    self:SetCountSubtract(0.5)
  elseif count <= 1 then
    count = 1
    self:SetCountPlus(1)
    self:SetCountSubtract(0.5)
  elseif count >= self.maxcount then
    count = self.maxcount
    self:SetCountPlus(0.5)
    self:SetCountSubtract(1)
  else
    self:SetCountPlus(1)
    self:SetCountSubtract(1)
  end
  self:UpdateTotalPrice(count)
end

function ActivityFlipCardBuyChanceCell:InputOnSubmit()
  local count = tonumber(self.countInput.value)
  if count == nil then
    self.countInput.value = self.count
  end
end

function ActivityFlipCardBuyChanceCell:SetCountPlus(alpha)
  self.countPlusBg.alpha = alpha
end

function ActivityFlipCardBuyChanceCell:SetCountSubtract(alpha)
  self.countSubtractBg.alpha = alpha
end
