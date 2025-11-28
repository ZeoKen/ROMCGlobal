AdventureMakeFoodPopUp = class("AdventureMakeFoodPopUp", BaseView)
AdventureMakeFoodPopUp.ViewType = UIViewType.PopUpLayer
local _color, picIns, tickManager = LuaColor.New()
local texObjStaticNameMap = {
  Bg = "food_bg_bottom1",
  MaterialCell1 = "food_bg_bottom2",
  MaterialCell2 = "food_bg_bottom2",
  MaterialCell3 = "food_bg_bottom2",
  MaterialCell4 = "food_bg_bottom2",
  MaterialCell5 = "food_bg_bottom2",
  MaterialCell6 = "food_bg_bottom2"
}

function AdventureMakeFoodPopUp:Init()
  if not picIns then
    picIns = PictureManager.Instance
    tickManager = TimeTickManager.Me()
  end
  self:InitData()
  self:FindObjs()
  self:InitShow()
  self:AddEvents()
end

function AdventureMakeFoodPopUp:InitData()
  local viewData = self.viewdata and self.viewdata.viewdata
  if not viewData or not next(viewData) then
    LogUtility.Error("Cannot get viewData!")
  end
  self.itemId = viewData.itemid
  self.recipeData = FunctionFood.Me():GetRecipeByFoodId(self.itemId)
  self.maxCount = 99
end

function AdventureMakeFoodPopUp:FindObjs()
  for objName, _ in pairs(texObjStaticNameMap) do
    self[objName] = self:FindComponent(objName, UITexture)
  end
  self.titleLabel = self:FindComponent("Title", UILabel)
  self.cellParent = self:FindGO("FoodCellParent")
  self.actionBtnSp = self:FindComponent("ActionBtn", UISprite)
  self.actionBtnLabel = self:FindComponent("ActionLabel", UILabel)
  self.successRateLabel = self:FindComponent("SuccessRate", UILabel)
  self.materialNameLabels = {}
  self.materialCountLabels = {}
  self.materialNoneTips = {}
  local parent
  for i = 1, 6 do
    parent = self["MaterialCell" .. i].gameObject
    self.materialNameLabels[i] = self:FindComponent("Name", UILabel, parent)
    self.materialCountLabels[i] = self:FindComponent("Count", UILabel, parent)
    self.materialNoneTips[i] = self:FindGO("None", parent)
  end
end

function AdventureMakeFoodPopUp:InitShow()
  local obj = self:LoadPreferb("cell/AdventureFoodItemCell", self.cellParent)
  obj.transform.localPosition = LuaGeometry.Const_V3_zero
  self.adventureFoodCell = AdventureFoodItemCell.new(obj)
  self.adventureFoodCell:SetData({
    itemData = ItemData.new("Data", self.itemId),
    status = SceneFood_pb.EFOODSTATUS_CLICKED
  })
  self.adventureFoodCell:setIsSelected(false)
  local bg = self.adventureFoodCell:GetBgSprite()
  bg.spriteName = "new-com_bg_icon_05"
  self.titleLabel.text = string.format(ZhString.AdventureFoodPage_MakeTitleFormat, Table_Item[self.itemId].NameZh)
  self:InitCountCtrl()
  self.maxCount = FunctionFood.Me():Match_MakeNum(self.recipeData.id)
  self:SetActionBtnInvalid(self.maxCount <= 0)
  self:UpdateInfo()
end

function AdventureMakeFoodPopUp:InitCountCtrl()
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

local addMaterialGuid = function(arr, items, targetNum)
  local finishedNum, item, num = 0
  for i = 1, #items do
    item = items[i]
    num = targetNum > finishedNum + item.num and item.num or targetNum - finishedNum
    TableUtility.ArrayPushBack(arr, {
      guid = item.id,
      num = num
    })
    finishedNum = finishedNum + num
    if targetNum <= finishedNum then
      break
    end
  end
end

function AdventureMakeFoodPopUp:AddEvents()
  self:AddButtonEvent("ActionBtn", function()
    if self.isInvalid then
      MsgManager.ShowMsgByID(8)
      return
    end
    local bagIns, recipes, materialGuids, mat, func = BagProxy.Instance, ReusableTable.CreateArray(), ReusableTable.CreateArray()
    TableUtility.ArrayPushBack(recipes, {
      recipeId = self.recipeData.id
    })
    for i = 1, #self.recipeData.Material do
      mat, func = self.recipeData.Material[i], nil
      if mat[1] == 1 then
        func = bagIns.GetItemsByStaticID
      elseif mat[1] == 2 then
        func = bagIns.GetBagItemsByType
      end
      if func then
        addMaterialGuid(materialGuids, func(bagIns, mat[2], BagProxy.BagType.Food), mat[3] * self:GetCurCount())
      end
    end
    FunctionFood.Me():DoMakeFood(self.recipeData.Type or 1, materialGuids, false, recipes)
    ReusableTable.DestroyAndClearArray(recipes)
    ReusableTable.DestroyAndClearArray(materialGuids)
    GameFacade.Instance:sendNotification(AdventurePanel.ClosePanel)
    self:CloseSelf()
  end)
  self:AddButtonEvent("Collider", function()
    self:CloseSelf()
  end)
end

function AdventureMakeFoodPopUp:OnEnter()
  AdventureMakeFoodPopUp.super.OnEnter(self)
  for objName, texName in pairs(texObjStaticNameMap) do
    picIns:SetUI(texName, self[objName])
  end
  ServiceSceneFoodProxy.Instance:CallPrepareCook(true)
  FoodProxy.Instance.adventureFoodCookPreparing = true
  self.countInput.value = 1
  self:SetCountPlus(1)
  self:SetCountSubtract(0.5)
end

function AdventureMakeFoodPopUp:OnExit()
  for objName, texName in pairs(texObjStaticNameMap) do
    picIns:UnLoadUI(texName, self[objName])
  end
  AdventureMakeFoodPopUp.super.OnExit(self)
end

function AdventureMakeFoodPopUp:OnInputChange()
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
  self:UpdateInfo()
end

local _setCountLabel = function(label, realCount, targetCount)
  realCount = realCount < targetCount and string.format("[c][ea6161]%s[-][/c]", realCount) or tostring(realCount)
  label.text = string.format("%s/%s", realCount, targetCount)
end

function AdventureMakeFoodPopUp:UpdateInfo()
  local bagProxy, mats, totalCount, totalLv, matData, targetCount, bagNum, items, matExpInfo = BagProxy.Instance, self.recipeData.Material, 0, 0
  for i = 1, 6 do
    self.materialNameLabels[i].gameObject:SetActive(i <= #mats)
    self.materialCountLabels[i].gameObject:SetActive(i <= #mats)
    self.materialNoneTips[i].gameObject:SetActive(i > #mats)
  end
  for i = 1, #mats do
    matData = mats[i]
    targetCount = matData[3] * self:GetCurCount()
    if matData[1] == 1 then
      self.materialNameLabels[i].text = Table_Item[matData[2]].NameZh
      _setCountLabel(self.materialCountLabels[i], bagProxy:GetItemNumByStaticID(matData[2], BagProxy.BagType.Food), targetCount)
    elseif matData[1] == 2 then
      self.materialNameLabels[i].text = Table_ItemType[matData[2]].Name
      bagNum = 0
      items = bagProxy:GetBagItemsByType(matData[2], BagProxy.BagType.Food)
      for j = 1, #items do
        bagNum = bagNum + items[j].num
      end
      _setCountLabel(self.materialCountLabels[i], bagNum, targetCount)
    end
    matExpInfo = FoodProxy.Instance:Get_MaterialExpInfo(matData[2])
    if matExpInfo then
      totalLv = totalLv + matExpInfo.level * targetCount
    else
      totalLv = totalLv + targetCount
    end
    totalCount = totalCount + targetCount
  end
  if not self.isInvalid then
    local cookerLv, cookInfo, rData = Game.Myself.data.userdata:Get(UDEnum.COOKER_LV) or 1, FoodProxy.Instance:Get_FoodCookExpInfo(self.itemId), FoodProxy.Instance:GetRecipeByRecipeId(self.recipeData.id)
    local rate = CommonFun.calcCookSuccessRate(cookerLv, cookInfo and cookInfo.level or 1, rData:GetDiffLevel(), totalLv / totalCount, Table_CookerLevel[cookerLv] and Table_CookerLevel[cookerLv].SuccessRate or 1) / 10
    self.successRateLabel.text = string.format(ZhString.MakeFoodPopUp_SuccessRateFormat, rate)
  end
end

function AdventureMakeFoodPopUp:OnClickCountSubtract()
  self.countInput.value = self:GetCurCount() - 1
end

function AdventureMakeFoodPopUp:OnClickCountPlus()
  self.countInput.value = self:GetCurCount() + 1
end

function AdventureMakeFoodPopUp:GetCurCount()
  return math.floor(tonumber(self.countInput.value) or 0)
end

function AdventureMakeFoodPopUp:SetCountSubtract(alpha)
  if self.countSubtractBg.color.a ~= alpha then
    self:SetSpriteAlpha(self.countSubtractBg, alpha)
    self:SetSpriteAlpha(self.countSubtractSp, alpha)
  end
end

function AdventureMakeFoodPopUp:SetCountPlus(alpha)
  if self.countPlusBg.color.a ~= alpha then
    self:SetSpriteAlpha(self.countPlusBg, alpha)
    self:SetSpriteAlpha(self.countPlusSp, alpha)
  end
end

function AdventureMakeFoodPopUp:SetSpriteAlpha(sprite, alpha)
  LuaColor.Better_Set(_color, sprite.color.r, sprite.color.g, sprite.color.b, alpha)
  sprite.color = _color
end

function AdventureMakeFoodPopUp:SetActionBtnInvalid(isInvalid)
  isInvalid = isInvalid and true or false
  if isInvalid then
    self.actionBtnSp.spriteName = "new-com_btn_a_gray"
    self.actionBtnLabel.color = LuaGeometry.GetTempColor(0.9372549019607843, 0.9372549019607843, 0.9372549019607843)
    self.actionBtnLabel.effectColor = LuaGeometry.GetTempColor(0.39215686274509803, 0.40784313725490196, 0.4627450980392157)
  else
    self.actionBtnSp.spriteName = "new-com_btn_c"
    self.actionBtnLabel.color = LuaGeometry.GetTempColor()
    self.actionBtnLabel.effectColor = LuaGeometry.GetTempColor(0.7686274509803922, 0.5254901960784314, 0)
  end
  self.successRateLabel.gameObject:SetActive(not isInvalid)
  self.isInvalid = isInvalid
end
