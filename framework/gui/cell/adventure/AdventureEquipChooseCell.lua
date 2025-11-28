autoImport("ItemCell")
local BaseCell = autoImport("BaseCell")
AdventureEquipChooseCell = class("AdventureEquipChooseCell", BaseCell)

function AdventureEquipChooseCell:Init()
  self.itemCell = ItemCell.new(self.gameObject)
  self.nameLab = self.itemCell.nameLab
  self.equipEd = self:FindGO("EquipEd")
  self.chooseSymbol = self:FindGO("ChooseSymbol")
  self.chooseButton = self:FindGO("ChooseButton")
  if self.chooseButton then
    self.chooseButtonLabel = self:FindComponent("Label", UILabel, self.chooseButton)
    self:AddClickEvent(self.chooseButton, function()
      self:PassEvent(MouseEvent.MouseClick, self)
    end)
  else
    self:AddClickEvent(self.gameObject, function()
      if self.isValid then
        self:PassEvent(MouseEvent.MouseClick, self)
      end
    end)
  end
  self.chooseButton:SetActive(true)
  self.invalidTip = self:FindComponent("InvalidTip", UILabel)
  self.invalidItemTip = self:FindGO("InvalidItemTip")
  self.favoriteTip = self:FindGO("FavoriteTip")
  self.itemIcon = self:FindGO("Item")
  self.itemIconWidget = self.itemIcon:GetComponent(UIWidget)
  self:AddClickEvent(self.itemIcon, function()
    self:PassEvent(EquipChooseCellEvent.ClickItemIcon, self)
  end)
  self.personalArtifactUniqueEffect = self:FindGO("PersonalArtifactUniqueEffect")
end

function AdventureEquipChooseCell:SetData(data)
  self.data = data
  local flag = data == nil or data.staticData == nil
  self.gameObject:SetActive(not flag)
  if flag then
    return
  end
  self.itemCell:SetData(data)
  self.itemCell:UpdateMyselfInfo()
  self.itemCell:SetIconGrey(data.id == "NoGet")
  self:Show(self.nameLab)
  self:SetShowChooseButton(true)
  self:UpdateEquiped()
  self:UpdateChoose()
  self:CheckValid()
end

function AdventureEquipChooseCell:SetChooseBtnStatus(id, targetLv)
  if id ~= self.data.staticData.id then
    targetLv = self.data.equipInfo:GetUpgradeReplaceLv()
  end
  local curEquipLv = self.data.equipInfo.equiplv
  if targetLv > curEquipLv then
    self.chooseButtonLabel.text = ZhString.EquipUpgradePopUp_Upgrade
    self.invalidTip.gameObject:SetActive(true)
    self.invalidTip.text = ZhString.AdventureEquipCompose_LowEquipLv
  else
    self.invalidTip.gameObject:SetActive(false)
    self.chooseButtonLabel.text = ZhString.PersonalArtifact_FormulaChoose
  end
end

function AdventureEquipChooseCell:SetShowChooseButton(isShow)
  if not self.chooseButton then
    return
  end
  self.chooseButton:SetActive(isShow and true or false)
end

function AdventureEquipChooseCell:UpdateEquiped()
  if not self.equipEd then
    return
  end
  self.equipEd:SetActive(self.data ~= nil and self.data.equiped == 1)
end

function AdventureEquipChooseCell:UpdateChoose()
  if self.chooseSymbol then
    if self.chooseId and self.data and self.data.id == self.chooseId then
      self.chooseSymbol:SetActive(true)
    else
      self.chooseSymbol:SetActive(false)
    end
  end
end

function AdventureEquipChooseCell:CheckValid()
end
