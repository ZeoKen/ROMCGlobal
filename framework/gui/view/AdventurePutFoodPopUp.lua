AdventurePutFoodPopUp = class("AdventurePutFoodPopUp", BaseView)
AdventurePutFoodPopUp.ViewType = UIViewType.PopUpLayer
AdventurePutFoodPopUpToggle = {
  "Public",
  "Team",
  "Self",
  "Pet"
}
local _color, tickManager = LuaColor.New()

function AdventurePutFoodPopUp:Init()
  if not tickManager then
    tickManager = TimeTickManager.Me()
  end
  self:InitData()
  self:FindObjs()
  self:InitShow()
  self:AddEvents()
end

function AdventurePutFoodPopUp:InitData()
  local viewData = self.viewdata and self.viewdata.viewdata
  if not viewData or not next(viewData) then
    LogUtility.Error("Cannot get viewData!")
  end
  self.itemId = viewData.itemid
  self.recipeData = FunctionFood.Me():GetRecipeByFoodId(self.itemId)
  self.maxCount = 99
end

function AdventurePutFoodPopUp:FindObjs()
  self.titleLabel = self:FindComponent("Title", UILabel)
  self.cellParent = self:FindGO("FoodCellParent")
  for _, t in pairs(AdventurePutFoodPopUpToggle) do
    self[t] = self:FindComponent(t, UIToggle)
  end
  self.actionBtnSp = self:FindComponent("ActionBtn", UISprite)
  self.actionBtnLabel = self:FindComponent("ActionLabel", UILabel)
end

function AdventurePutFoodPopUp:InitShow()
  local obj = self:LoadPreferb("cell/AdventureFoodItemCell", self.cellParent)
  obj.transform.localPosition = LuaGeometry.Const_V3_zero
  self.adventureFoodCell = AdventureFoodItemCell.new(obj)
  self.adventureFoodCell:SetData({
    itemData = ItemData.new("Data", self.itemId),
    status = SceneFood_pb.EFOODSTATUS_CLICKED
  })
  self.adventureFoodCell:setIsSelected(false)
  self.titleLabel.text = string.format(ZhString.AdventureFoodPage_PutTitleFormat, Table_Item[self.itemId].NameZh)
  self:InitCountCtrl()
  self.maxCount = BagProxy.Instance:GetItemNumByStaticID(self.itemId, BagProxy.BagType.Food)
end

function AdventurePutFoodPopUp:InitCountCtrl()
  local countCtrl = self:FindGO("CountInput")
  self.countLabel = self:FindComponent("Count", UILabel, countCtrl)
  self.countInput = countCtrl:GetComponent(UIInput)
  EventDelegate.Set(self.countInput.onChange, function()
    self:OnInputChange()
  end)
  local countSubtract = self:FindGO("MinusButton")
  local countPlus = self:FindGO("AddButton")
  self:AddClickEvent(countSubtract, function()
    self:OnClickCountSubtract()
  end)
  self:AddClickEvent(countPlus, function()
    self:OnClickCountPlus()
  end)
  local subtractLongPress, plusLongPress = countSubtract:GetComponent(UILongPress), countPlus:GetComponent(UILongPress)
  
  function subtractLongPress.pressEvent(obj, state)
    if state then
      tickManager:CreateTick(0, 100, self.OnClickCountSubtract, self, 12)
    else
      tickManager:ClearTick(self, 12)
    end
  end
  
  function plusLongPress.pressEvent(obj, state)
    if state then
      tickManager:CreateTick(0, 100, self.OnClickCountPlus, self, 11)
    else
      tickManager:ClearTick(self, 11)
    end
  end
  
  self.countSubtractBg = countSubtract:GetComponent(UISprite)
  self.countSubtractSp = self:FindComponent("Sprite", UISprite, countSubtract)
  self.countPlusBg = countPlus:GetComponent(UISprite)
  self.countPlusSp = self:FindComponent("Sprite", UISprite, countPlus)
end

function AdventurePutFoodPopUp:AddEvents()
  self:AddButtonEvent("ActionBtn", function()
    if self.isInvalid then
      MsgManager.ShowMsgByIDTable(25418, Table_Item[self.itemId].NameZh)
      return
    end
    local func
    for _, t in pairs(AdventurePutFoodPopUpToggle) do
      if self[t].value then
        func = FunctionItemFunc["PutFood_" .. t]
        break
      end
    end
    if func then
      local items = BagProxy.Instance:GetItemsByStaticID(self.itemId, BagProxy.BagType.Food)
      if items then
        func(items[1], self:GetCurCount())
        GameFacade.Instance:sendNotification(UIEvent.CloseUI, AdventurePanel.ViewType)
      end
    end
    self:CloseSelf()
  end)
  self:AddButtonEvent("Collider", function()
    self:CloseSelf()
  end)
end

function AdventurePutFoodPopUp:OnEnter()
  AdventurePutFoodPopUp.super.OnEnter(self)
  self:SetActionBtnInvalid(self.maxCount <= 0)
  self.countInput.value = 1
  self:SetCountPlus(1)
  self:SetCountSubtract(0.5)
end

function AdventurePutFoodPopUp:OnInputChange()
  local count = self:GetCurCount()
  if not count then
    return
  end
  if count < 1 then
    self.countInput.value = 1
  elseif count > self.maxCount then
    if self.maxCount == 0 then
      self.countInput.value = 1
    else
      self.countInput.value = self.maxCount
    end
  end
  count = self:GetCurCount()
  if not count then
    return
  end
  if count <= 1 then
    self:SetCountPlus(1)
    self:SetCountSubtract(0.5)
  elseif count >= self.maxCount then
    self:SetCountPlus(0.5)
    self:SetCountSubtract(1)
  else
    self:SetCountPlus(1)
    self:SetCountSubtract(1)
  end
end

function AdventurePutFoodPopUp:OnClickCountSubtract()
  self.countInput.value = self:GetCurCount() - 1
end

function AdventurePutFoodPopUp:OnClickCountPlus()
  self.countInput.value = self:GetCurCount() + 1
end

function AdventurePutFoodPopUp:GetCurCount()
  return math.floor(tonumber(self.countInput.value) or 0)
end

function AdventurePutFoodPopUp:SetCountSubtract(alpha)
  if self.countSubtractBg.color.a ~= alpha then
    self:SetSpriteAlpha(self.countSubtractBg, alpha)
    self:SetSpriteAlpha(self.countSubtractSp, alpha)
  end
end

function AdventurePutFoodPopUp:SetCountPlus(alpha)
  if self.countPlusBg.color.a ~= alpha then
    self:SetSpriteAlpha(self.countPlusBg, alpha)
    self:SetSpriteAlpha(self.countPlusSp, alpha)
  end
end

function AdventurePutFoodPopUp:SetSpriteAlpha(sprite, alpha)
  LuaColor.Better_Set(_color, sprite.color.r, sprite.color.g, sprite.color.b, alpha)
  sprite.color = _color
end

function AdventurePutFoodPopUp:SetActionBtnInvalid(isInvalid)
  if isInvalid then
    self.actionBtnSp.color = LuaGeometry.GetTempColor(0.00392156862745098, 0.00784313725490196, 0.011764705882352941, 1)
    self.actionBtnLabel.effectColor = LuaGeometry.GetTempColor(0.5019607843137255, 0.5019607843137255, 0.5019607843137255, 1)
  else
    self.actionBtnSp.color = LuaGeometry.GetTempColor()
    self.actionBtnLabel.effectColor = LuaGeometry.GetTempColor(0.6196078431372549, 0.33725490196078434, 0 / 255, 1)
  end
  self.isInvalid = isInvalid
end
