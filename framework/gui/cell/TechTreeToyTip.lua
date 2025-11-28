autoImport("TechTreeLeafCommonTip")
TechTreeToyTip = class("TechTreeToyTip", TechTreeLeafCommonTip)
local minusLongPressTickId, addLongPressTickId = 78, 79
local tickManager

function TechTreeToyTip:FindObjs()
  if not tickManager then
    tickManager = TimeTickManager.Me()
  end
  TechTreeToyTip.super.FindObjs(self)
  self.makeToyParent = self:FindGO("MakeToy")
  self.unlockWayParent = self:FindGO("UnlockWay")
  self.unlockWayLabel = self:FindComponent("Label", UILabel, self.unlockWayParent)
end

function TechTreeToyTip:InitTip()
  TechTreeToyTip.super.InitTip(self)
  self:InitCountCtrl()
  self.tipFunc = self.MakeToy
end

function TechTreeToyTip:InitCountCtrl()
  self.countInput = self:FindComponent("CountInput", UIInput)
  EventDelegate.Set(self.countInput.onChange, function()
    self.countInput.value = math.clamp(tonumber(self.countInput.value) or 0, 0, 99)
    self:SetMaterials()
  end)
  UIUtil.LimitInputCharacter(self.countInput, 2)
  local minusBtn = self:FindGO("MinusButton")
  self:AddClickEvent(minusBtn, function()
    self:OnClickMinusBtn()
  end)
  self.minusLongPress = minusBtn:GetComponent(UILongPress)
  if self.minusLongPress then
    function self.minusLongPress.pressEvent(obj, state)
      self:OnLongPressMinusBtn(state)
    end
  end
  local addBtn = self:FindGO("AddButton")
  self:AddClickEvent(addBtn, function()
    self:OnClickAddBtn()
  end)
  self.addBtnLongPress = addBtn:GetComponent(UILongPress)
  if self.addBtnLongPress then
    function self.addBtnLongPress.pressEvent(obj, state)
      self:OnLongPressAddBtn(state)
    end
  end
end

function TechTreeToyTip:OnExit()
  tickManager:ClearTick(self)
  if self.minusLongPress then
    self.minusLongPress.pressEvent = nil
  end
  if self.addBtnLongPress then
    self.addBtnLongPress.pressEvent = nil
  end
  TechTreeToyTip.super.OnExit(self)
end

function TechTreeToyTip:SetData(drawingId)
  self.drawingId = drawingId
  self.staticData = self.drawingId and Table_ToyDrawing[self.drawingId]
  if not drawingId or not self.staticData then
    return
  end
  self:SetIconAndName()
  self:SetDesc()
  self:SetMaterials()
  self:SetBottomCtrl()
  self:SetTipCloseBtnActive(true)
end

function TechTreeToyTip:SetIconAndName()
  local item = self.staticData.Output
  local itemSData = item and Table_Item[item]
  if not IconManager:SetItemIcon(itemSData and itemSData.Icon, self.iconSp) then
    IconManager:SetItemIcon("item_45001", self.iconSp)
  end
  self.iconLabel.text = itemSData and itemSData.NameZh .. ZhString.TechTree_ToyDrawingSuffix or ""
  self.iconLabel2.text = ""
end

function TechTreeToyTip:SetDesc()
  local desc = OverSea.LangManager.Instance():GetLangByKey(self.staticData.Desc) or ""
  local modified = false
  if not StringUtil.IsEmpty(self.staticData.Duration) then
    desc = desc .. [[


]] .. string.format(ZhString.TechTree_ToyDurationFormat, self.staticData.Duration)
    modified = true
  end
  if self.staticData.UseLimit then
    desc = desc .. (modified and "\n" or [[


]]) .. string.format(ZhString.TechTree_ToyUseLimitFormat, self.staticData.UseLimit)
    modified = true
  end
  self.desc.text = desc
end

function TechTreeToyTip:SetMaterials()
  local items = self.staticData.Cost
  if type(items) == "table" then
    local sId, needNum, itemData
    for i = 1, #items do
      sId, needNum = items[i].itemid, items[i].num
      itemData = self.materials[i] or ItemData.new()
      itemData:ResetData(MaterialItemCell.MaterialType.Material, sId)
      itemData.num = BagProxy.Instance:GetItemNumByStaticID(sId, GameConfig.PackageMaterialCheck.techtree_maketoy)
      itemData.neednum = needNum * self:GetCurInputCount()
      self.materials[i] = itemData
    end
    for i = #items + 1, #self.materials do
      self.materials[i] = nil
    end
  else
    TableUtility.TableClear(self.materials)
  end
  self.matCtrl:ResetDatas(self.materials)
  self.matGrid.repositionNow = true
end

function TechTreeToyTip:SetBottomCtrl()
  local isUnlocked = TechTreeProxy.Instance:IsToyUnlocked(self.drawingId)
  self.makeToyParent:SetActive(isUnlocked)
  self.unlockWayParent:SetActive(not isUnlocked)
  if isUnlocked then
    self.countInput.value = 1
  else
    local unlockByLeaf = TechTreeProxy.Instance:IsToyToUnlockByLeaf(self.drawingId)
    self.unlockWayLabel.text = unlockByLeaf and ZhString.TechTree_ToyTipToyUnlockByLeaf or ZhString.TechTree_ToyTipToyUnlockNotByLeaf
  end
end

function TechTreeToyTip:GetCurInputCount()
  return math.floor(tonumber(self.countInput.value) or 0)
end

function TechTreeToyTip:OnClickMinusBtn()
  self.countInput.value = self:GetCurInputCount() - 1
end

function TechTreeToyTip:OnClickAddBtn()
  self.countInput.value = self:GetCurInputCount() + 1
end

function TechTreeToyTip:OnLongPressMinusBtn(state)
  if state then
    tickManager:CreateTick(0, 100, self.OnClickMinusBtn, self, minusLongPressTickId)
  else
    tickManager:ClearTick(self, minusLongPressTickId)
  end
end

function TechTreeToyTip:OnLongPressAddBtn(state)
  if state then
    tickManager:CreateTick(0, 100, self.OnClickAddBtn, self, addLongPressTickId)
  else
    tickManager:ClearTick(self, addLongPressTickId)
  end
end

function TechTreeToyTip:SetFunc()
end

function TechTreeToyTip:OnLeafUnlock()
end

function TechTreeToyTip:Unlock()
end

function TechTreeToyTip:MakeToy()
  for _, mat in pairs(self.materials) do
    if mat.num < mat.neednum then
      MsgManager.ShowMsgByID(8)
      return
    end
  end
  TechTreeProxy.CallMakeToy(self.drawingId, self:GetCurInputCount())
end
