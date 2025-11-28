autoImport("EquipNewChooseCell")
EquipNewCountChooseCell = class("EquipNewCountChooseCell", EquipNewChooseCell)
local tickManager

function EquipNewCountChooseCell:Init()
  if not tickManager then
    tickManager = TimeTickManager.Me()
  end
  EquipNewCountChooseCell.super.Init(self)
  self:InitCountChooseBord()
  self.curCountLabel = self.typeLabel
  self.typeLabel = nil
  self.itemNumLabel = self:FindComponent("NumLabel", UILabel, self.itemCell.item)
end

function EquipNewCountChooseCell:InitCountChooseBord()
  self.countChooseBord = self:FindGO("CountChooseBord")
  if not self.countChooseBord then
    LogUtility.Error("Cannot find CountChooseBord. Is that what you want?")
    return
  end
  local countChoose_AddButton = self:FindGO("AddButton", self.countChooseBord)
  self.countChoose_AddButton_Sp = countChoose_AddButton:GetComponent(UISprite)
  self.countChoose_AddButton_Collider = countChoose_AddButton:GetComponent(BoxCollider)
  self:AddClickEvent(countChoose_AddButton, function()
    self:DoAddCountChoose()
  end)
  local longPress = countChoose_AddButton:GetComponent(UILongPress)
  
  function longPress.pressEvent(obj, state)
    self:QuickDoAddCountChoose(state)
  end
  
  local countChoose_MinusButton = self:FindGO("MinusButton", self.countChooseBord)
  self.countChoose_MinusButton_Sp = countChoose_MinusButton:GetComponent(UISprite)
  self.countChoose_MinusButton_Collider = countChoose_MinusButton:GetComponent(BoxCollider)
  self:AddClickEvent(countChoose_MinusButton, function()
    self:DoMinusCountChoose()
  end)
  longPress = countChoose_MinusButton:GetComponent(UILongPress)
  
  function longPress.pressEvent(obj, state)
    self:QuickMinusAddCountChoose(state)
  end
  
  self.countChoose_CountInput = self:FindComponent("CountInput", UIInput, self.countChooseBord)
  UIUtil.LimitInputCharacter(self.countChoose_CountInput, 5)
  EventDelegate.Set(self.countChoose_CountInput.onChange, function()
    self.chooseCount = tonumber(self.countChoose_CountInput.value) or 0
    self:UpdateCountChoose()
    self:PassEvent(EquipChooseCellEvent.CountChooseChange, self)
  end)
  self.countChoose_Count = self:FindComponent("Count", UILabel, self.countChooseBord)
end

function EquipNewCountChooseCell:SetData(data)
  EquipNewCountChooseCell.super.SetData(self, data)
  if not data then
    return
  end
  self:UpdateBagCountInfo()
  self.chooseCount = self.data.chooseCount or self.chooseCount or 0
  self:UpdateCountChoose()
end

function EquipNewCountChooseCell:DoAddCountChoose()
  if not self.data then
    return
  end
  self:SetChooseCount(self.chooseCount + 1)
end

function EquipNewCountChooseCell:QuickDoAddCountChoose(open)
  if open then
    tickManager:CreateTick(0, 100, self.DoAddCountChoose, self, 11)
  else
    tickManager:ClearTick(self, 11)
  end
end

function EquipNewCountChooseCell:DoMinusCountChoose()
  if not self.data then
    return
  end
  self:SetChooseCount(self.chooseCount - 1)
end

function EquipNewCountChooseCell:QuickMinusAddCountChoose(open)
  if open then
    tickManager:CreateTick(0, 100, self.DoMinusCountChoose, self, 12)
  else
    tickManager:ClearTick(self, 12)
  end
end

function EquipNewCountChooseCell:CheckValid()
  EquipNewCountChooseCell.super.CheckValid(self)
  if not self.data then
    return
  end
  if self.chooseButton.activeSelf then
    self.chooseButton:SetActive(false)
    self.countChooseBord:SetActive(true)
  else
    self.countChooseBord:SetActive(false)
  end
end

function EquipNewCountChooseCell:SetChooseCount(count)
  self.chooseCount = count
  if not self.countChooseBord then
    return
  end
  self.countChoose_CountInput.value = self.chooseCount
  if count == 0 then
    self.countChoose_CountInput.label.alpha = 0.5
  else
    self.countChoose_CountInput.label.alpha = 1
  end
  self:UpdateCountChoose()
end

function EquipNewCountChooseCell:SetChooseReference(refDatas)
  self.refDatas = refDatas
  if self.data then
    self.chooseCount = 0
    for k, v in pairs(self.refDatas) do
      if v.id == self.data.id then
        self.chooseCount = v.num
        break
      end
    end
  end
  self:SetChooseCount(self.chooseCount or 0)
end

function EquipNewCountChooseCell:SetUseItemNum(b)
  self.useItemNum = b
end

function EquipNewCountChooseCell:UpdateCountChoose()
  if not self.countChooseBord then
    return
  end
  if not self.data then
    return
  end
  local max = self:GetMaxNumOfItem()
  if max < self.chooseCount or self.chooseCount < 0 then
    self.chooseCount = math.clamp(self.chooseCount, 0, max)
    self.countChoose_CountInput.value = self.chooseCount
    if self.chooseCount == 0 then
      self.countChoose_CountInput.label.alpha = 0.5
    else
      self.countChoose_CountInput.label.alpha = 1
    end
  else
    self.countChoose_Count.text = self.chooseCount
  end
  if self.data.__isclone then
    self.data.chooseCount = self.chooseCount
  end
  self:_ActiveButton(self.chooseCount and max > self.chooseCount, self.countChoose_AddButton_Sp, self.countChoose_AddButton_Collider)
  self:_ActiveButton(self.chooseCount and self.chooseCount > 0, self.countChoose_MinusButton_Sp, self.countChoose_MinusButton_Collider)
end

function EquipNewCountChooseCell:UpdateBagCountInfo()
  if self.data and self.data.showRefineval then
    if self.data:IsEquip() then
      self.curCountLabel.text = string.format(ZhString.EquipNewChooseCell_MaterialTypeText, self:GetItemNum(), self.data.equipInfo:GetSafeRefineMatVal())
    else
      self.curCountLabel.text = string.format(ZhString.EquipNewChooseCell_MaterialTypeText, self:GetItemNum(), 1)
    end
    if self.itemNumLabel then
      self.itemNumLabel.text = ""
    end
  else
    self.curCountLabel.text = ZhString.HappyShop_haveObtain .. string.format("[c][64628a]%s[-][/c]", self:GetItemNum())
    if self.itemNumLabel then
      self.itemNumLabel.text = self:GetMaxNumOfItem()
    end
  end
end

function EquipNewCountChooseCell:GetMaxNumOfItem()
  if not self.data then
    return 0
  end
  local staticMaxNum, num = self.data.staticData.MaxNum, self:GetItemNum()
  local max = staticMaxNum and math.min(num, staticMaxNum) or num
  return math.min(max, 99999)
end

function EquipNewCountChooseCell:GetItemNum()
  if not self.data then
    return 0
  end
  if self.useItemNum then
    return self.data.num or 0
  end
  return HappyShopProxy.Instance:GetItemNum(self.data.staticData.id)
end

function EquipNewCountChooseCell:_ActiveButton(b, sp, collider)
  b = b and true or false
  sp.alpha = b and 1 or 0.5
  collider.enabled = b
end

function EquipNewCountChooseCell:UpdateChoose()
end
