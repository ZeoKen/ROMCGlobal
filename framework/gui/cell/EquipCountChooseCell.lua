autoImport("EquipChooseCell")
EquipCountChooseCell = class("EquipCountChooseCell", EquipChooseCell)
local tickManager

function EquipCountChooseCell:Init()
  if not tickManager then
    tickManager = TimeTickManager.Me()
  end
  EquipCountChooseCell.super.Init(self)
  self:InitCountChooseBord()
  self.itemNumLabel = self:FindComponent("NumLabel", UILabel, self.itemCell.item)
end

function EquipCountChooseCell:InitCountChooseBord()
  self.countChooseBord = self:FindGO("CountChooseBord")
  if not self.countChooseBord then
    LogUtility.Error("Cannot find CountChooseBord. Is that what you want?")
    return
  end
  self.countChooseBord_Widget = self.countChooseBord:GetComponent(UIWidget)
  local countChoose_AddButton = self:FindGO("AddButton", self.countChooseBord)
  self.countChoose_AddButton_Sp = countChoose_AddButton:GetComponent(UISprite)
  self.countChoose_AddButton_Collider = countChoose_AddButton:GetComponent(BoxCollider)
  self:AddClickEvent(countChoose_AddButton, function()
    if self.activePlus then
      self:DoAddCountChoose()
    end
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
  self.activePlus = true
end

function EquipCountChooseCell:SetData(data)
  EquipCountChooseCell.super.SetData(self, data)
  if not data then
    return
  end
  self:UpdateCurrentCount()
  self:SetChooseCount(self.data.chooseCount or self.chooseCount or 0)
end

function EquipCountChooseCell:DoAddCountChoose()
  if not self.data then
    return
  end
  self:SetChooseCount(self.chooseCount + 1)
end

function EquipCountChooseCell:QuickDoAddCountChoose(open)
  if open then
    tickManager:CreateTick(0, 100, self.DoAddCountChoose, self, 11)
  else
    tickManager:ClearTick(self, 11)
  end
end

function EquipCountChooseCell:DoMinusCountChoose()
  if not self.data then
    return
  end
  self:SetChooseCount(self.chooseCount - 1)
end

function EquipCountChooseCell:QuickMinusAddCountChoose(open)
  if open then
    tickManager:CreateTick(0, 100, self.DoMinusCountChoose, self, 12)
  else
    tickManager:ClearTick(self, 12)
  end
end

function EquipCountChooseCell:CheckValid()
  EquipCountChooseCell.super.CheckValid(self)
  if self.invalidTip.gameObject.activeSelf then
    self.countChooseBord:SetActive(false)
  else
    self.countChooseBord:SetActive(true)
  end
  if self.chooseButton.activeSelf then
    self.chooseButton:SetActive(false)
    self.countChooseBord:SetActive(true)
  else
    self.countChooseBord:SetActive(false)
  end
end

function EquipCountChooseCell:SetChooseCount(count)
  self.chooseCount = count
  if self.data and self.data.__isclone then
    self.data.chooseCount = count
  end
  if not self.countChooseBord then
    return
  end
  self.countChoose_CountInput.value = self.chooseCount
  self:UpdateCountChoose()
end

function EquipCountChooseCell:SetChooseReference(refDatas)
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

function EquipCountChooseCell:SetUseItemNum(b)
  self.useItemNum = b
end

function EquipCountChooseCell:UpdateCountChoose()
  if not self.countChooseBord then
    return
  end
  if not self.data then
    return
  end
  local max = self:GetMaxNumOfItem()
  if max < self.chooseCount or self.chooseCount < 0 then
    self.chooseCount = math.clamp(self.chooseCount, 0, max)
    if self.data and self.data.__isclone then
      self.data.chooseCount = count
    end
    self.countChoose_CountInput.value = self.chooseCount
  end
  self:_ActiveButton(self.activePlus and self.chooseCount and max > self.chooseCount, self.countChoose_AddButton_Sp, self.countChoose_AddButton_Collider)
  self:_ActiveButton(self.chooseCount and self.chooseCount > 0, self.countChoose_MinusButton_Sp, self.countChoose_MinusButton_Collider)
end

function EquipCountChooseCell:UpdateCurrentCount()
  if self.itemNumLabel then
    local count = self:GetMaxNumOfItem()
    self.itemNumLabel.text = count
    self.itemIconWidget.alpha = count == 0 and 0.5 or 1
    self.countChooseBord_Widget.alpha = count == 0 and 0.5 or 1
  end
end

function EquipCountChooseCell:GetMaxNumOfItem()
  if not self.data then
    return 0
  end
  local staticMaxNum, num = self.data.staticData.MaxNum, self:GetItemNum()
  local max = staticMaxNum and math.min(num, staticMaxNum) or num
  return math.min(max, 99999)
end

function EquipCountChooseCell:GetItemNum()
  if not self.data then
    return 0
  end
  if self.useItemNum then
    return self.data.num or 0
  end
  return HappyShopProxy.Instance:GetItemNum(self.data.staticData.id)
end

function EquipCountChooseCell:_ActiveButton(b, sp, collider)
  b = b and true or false
  sp.alpha = b and 1 or 0.5
  collider.enabled = b
end

function EquipCountChooseCell:ActivePlusButton(bool)
  self.activePlus = bool
  if bool then
    self:UpdateCountChoose()
  else
    self:_ActiveButton(false, self.countChoose_AddButton_Sp, self.countChoose_AddButton_Collider)
  end
end

function EquipCountChooseCell:UpdateChoose()
end

function EquipCountChooseCell:SetCountChooseCall(countChangeCall)
  self.countChangeCall = countChangeCall
end

EquipAlchemyChooseCell = class("EquipAlchemyChooseCell", EquipCountChooseCell)

function EquipAlchemyChooseCell:SetData(data)
  local flag = data ~= nil
  self.gameObject:SetActive(flag)
  if flag then
    self.data = self.data or ItemData.new()
    self.data:ResetData("AlchemyChoose", data[1])
    self.data.energy = data[2]
    EquipAlchemyChooseCell.super.SetData(self, self.data)
  end
end

function EquipAlchemyChooseCell:GetItemNum()
  if not self.data then
    return 0
  end
  return BagProxy.Instance:GetItemNumByStaticID(self.data.staticData.id, GameConfig.PackageMaterialCheck.EquipAlchemy_pack)
end

local defaultTypeLabelTextGetter = function(data)
  if not data or not data.energy then
    return
  end
  return string.format(ZhString.ItemExtract_CountChooseFormat, math.floor(data.energy * 10) / 100)
end

function EquipAlchemyChooseCell:GetTypeLabelText()
  local getter = self.typeLabelTextGetter or defaultTypeLabelTextGetter
  return getter(self.data) or ""
end

function EquipAlchemyChooseCell:UpdateDesc()
  EquipAlchemyChooseCell.super.UpdateDesc(self)
  if not self.data or not self.energy then
    return
  end
  self.desc.text = string.format(ZhString.ItemExtract_CountChooseFormat, math.floor(self.energy * 10) / 100)
end
