autoImport("ItemCell")
local BaseCell = autoImport("BaseCell")
EquipChooseCell = class("EquipChooseCell", BaseCell)
EquipChooseCell.CellControl = ItemCell
local redTipOffset = {-10, -10}

function EquipChooseCell:Init()
  self.itemCell = self.CellControl.new(self.gameObject)
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
  self.invalidTip = self:FindComponent("InvalidTip", UILabel)
  self.invalidItemTip = self:FindGO("InvalidItemTip")
  self.favoriteTip = self:FindGO("FavoriteTip")
  self.itemIcon = self:FindGO("Item")
  self.itemIconWidget = self.itemIcon:GetComponent(UIWidget)
  self:AddClickEvent(self.itemIcon, function()
    self:PassEvent(EquipChooseCellEvent.ClickItemIcon, self)
  end)
  self.personalArtifactUniqueEffect = self:FindGO("PersonalArtifactUniqueEffect")
  local itemTypeGO = self:FindGO("ItemType")
  self.typeLabel = itemTypeGO and SpriteLabel.new(itemTypeGO, nil, 30, 30, true)
end

function EquipChooseCell:SetData(data)
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
  self:CheckValid()
  self:UpdateChoose()
  self:UpdateShowRedTip(data)
  self:UpdateFavoriteTip()
  self:TryUpdatePersonalArtifact()
  self:UpdateTypeLabel()
  TimeTickManager.Me():CreateOnceDelayTick(16, function()
    if not Slua.IsNull(self.itemCell.attrGrid) then
      self.itemCell.attrGrid:Reposition()
    end
  end, self)
  self:RegisterGuide()
end

function EquipChooseCell:UpdateFavoriteTip()
  if not self.favoriteTip then
    return
  end
  self.favoriteTip:SetActive((not self.equipEd or not self.equipEd.activeSelf) and self.data ~= nil and BagProxy.Instance:CheckIsFavorite(self.data))
end

function EquipChooseCell:UpdateEquiped()
  if not self.equipEd then
    return
  end
  self.equipEd:SetActive(self.data ~= nil and self.data.equiped == 1)
end

function EquipChooseCell:SetChooseId(chooseId)
  self.chooseId = chooseId
  self:UpdateChoose()
end

function EquipChooseCell:UpdateChoose()
  if self.chooseSymbol then
    if self.chooseId and self.data and self.data.id == self.chooseId then
      self.chooseSymbol:SetActive(true)
      if self.chooseButton and self.showChooseButton then
        self.chooseButton:SetActive(false)
      end
    else
      self.chooseSymbol:SetActive(false)
      if self.chooseButton and self.showChooseButton then
        self.chooseButton:SetActive(true)
      end
    end
  end
end

function EquipChooseCell:TryUpdatePersonalArtifact()
  if not self.personalArtifactUniqueEffect then
    return
  end
  local paData = self.data and self.data.personalArtifactData
  self.personalArtifactUniqueEffect:SetActive(paData ~= nil and paData:IsUniqueEffectAvailable())
end

function EquipChooseCell:UpdateShowRedTip(data)
  local isActive = data and data.isShowRedTip
  if isActive then
    self:TryAddManualRedTip()
  else
    self:TryRemoveManualRedTip()
  end
  if self.redTip then
    self.redTip.gameObject:SetActive(isActive and true or false)
  end
end

function EquipChooseCell:UpdateTypeLabel()
  if not self.typeLabel then
    return
  end
  local descStr = self:GetTypeLabelText()
  if StringUtil.HasBufferIdToClick(descStr) then
    descStr = self:AdaptBufferIdToDesc(descStr)
  end
  self.typeLabel:SetText(descStr)
end

function EquipChooseCell:AdaptBufferIdToDesc(str)
  if StringUtil.IsEmpty(str) then
    return
  end
  return string.gsub(str, "%[enchantbuff%](%d+)%[/enchantbuff%]", function(id)
    id = tonumber(id)
    local bufferData = Table_Buffer[id]
    local sb = LuaStringBuilder.CreateAsTable()
    sb:Append(ZhString.EnchantAttrUp_CombineAttr)
    if bufferData then
      sb:Append(bufferData.BuffName)
      sb:Append(":")
      sb:Append(bufferData.BuffDesc)
    end
    local s = sb:ToString()
    sb:Destroy()
    return s
  end)
end

function EquipChooseCell:TryAddManualRedTip()
  if self.redTip then
    return
  end
  self.redTip = Game.AssetManager_UI:CreateAsset(RedTip.resID, self.itemIcon):GetComponent(UISprite)
  UIUtil.ChangeLayer(self.redTip, self.itemIcon.layer)
  self.redTip.transform.position = NGUIUtil.GetAnchorPoint(self.itemIcon, self.itemIconWidget, NGUIUtil.AnchorSide.TopRight, redTipOffset)
  self.redTip.transform.localScale = LuaGeometry.Const_V3_one
  self.redTip.depth = self.itemIconWidget.depth + 10
end

function EquipChooseCell:TryRemoveManualRedTip()
  if not self.redTip then
    return
  end
  Game.GOLuaPoolManager:AddToUIPool(RedTip.resID, self.redTip.gameObject)
  self.redTip = nil
end

function EquipChooseCell:Set_CheckValidFunc(checkFunc, checkFuncParam, checkTip, needShowInvalidItemTip)
  self.checkFunc = checkFunc
  self.checkFuncParam = checkFuncParam
  self.checkTip = checkTip
  self.isShowInvalidItemTip = needShowInvalidItemTip and true or false
  self:CheckValid()
end

function EquipChooseCell:CheckValid()
  if self.data == nil then
    return
  end
  if self.checkFunc then
    local otherTip
    self.isValid, otherTip = self.checkFunc(self.checkFuncParam, self.data)
    if self.isValid then
      self:SetShowChooseButton(true)
      if otherTip then
        self.invalidTip.gameObject:SetActive(true)
        self.invalidTip.text = tostring(otherTip)
      else
        self.invalidTip.gameObject:SetActive(false)
      end
    else
      self:SetShowChooseButton(false)
      self.invalidTip.gameObject:SetActive(true)
      self.invalidTip.text = tostring(otherTip or self.checkTip)
    end
    if self.invalidItemTip then
      self.invalidItemTip:SetActive(not self.isValid)
    end
  else
    self:SetShowChooseButton(true)
    self.invalidTip.gameObject:SetActive(false)
    if self.invalidItemTip then
      self.invalidItemTip:SetActive(false)
    end
  end
end

function EquipChooseCell:SetShowChooseButton(isShow)
  if not self.chooseButton then
    return
  end
  self.showChooseButton = isShow
  self.chooseButton:SetActive(isShow and true or false)
end

function EquipChooseCell:SetChooseButtonText(text)
  if not self.chooseButtonLabel then
    return
  end
  self.chooseButtonLabel.text = tostring(text) or ""
end

function EquipChooseCell:SetShowStrengthLvOfItem(b)
  self.itemCell.forbidShowStrengthLv = not b
end

function EquipChooseCell:SetShowRefineLvOfItem(b)
  self.itemCell.forbidShowRefineLv = not b
end

function EquipChooseCell:SetShowEquipLvOfItem(b)
  self.itemCell.forbidShowEquipLv = not b
end

local defaultTypeLabelTextGetter = function(data)
  return data and data.staticData and ItemUtil.GetItemTypeName(data.staticData) or ""
end

function EquipChooseCell:GetTypeLabelText()
  local getter = self.typeLabelTextGetter or defaultTypeLabelTextGetter
  return getter(self.data) or ""
end

function EquipChooseCell:SetTypeLabelTextGetter(getter)
  if type(getter) == "function" then
    self.typeLabelTextGetter = getter
  end
end

function EquipChooseCell:OnCellDestroy()
  TimeTickManager.Me():ClearTick(self)
  self:TryRemoveManualRedTip()
end

function EquipChooseCell:RegisterGuide()
  if self.data.staticData.id == 42692 then
    self:AddOrRemoveGuideId(self.chooseButton, 533)
  end
end

EquipMultiChooseCell = class("EquipMultiChooseCell", EquipChooseCell)

function EquipMultiChooseCell:Init()
  EquipMultiChooseCell.super.Init(self)
  self.cancelButton = self:FindGO("CancelButton")
  if self.cancelButton then
    self.cancelButtonLabel = self:FindComponent("Label", UILabel, self.cancelButton)
    self:AddClickEvent(self.cancelButton, function()
      self:PassEvent(EquipChooseCellEvent.ClickCancel, self)
    end)
  end
end

function EquipMultiChooseCell:SetChooseId(id)
end

function EquipMultiChooseCell:SetChoose(reference)
  self.chooseReference = reference
  self:UpdateChoose()
end

local choosePredicate = function(element, id)
  return element.id == id
end

function EquipMultiChooseCell:UpdateChoose()
  if not self.cancelButton then
    return
  end
  local isChoose = self.chooseReference ~= nil and self.data ~= nil and TableUtility.ArrayFindByPredicate(self.chooseReference, choosePredicate, self.data.id) ~= nil
  self.cancelButton:SetActive(isChoose)
  if self.chooseButton then
    if self.chooseButton.activeSelf and isChoose then
      self.chooseButton:SetActive(false)
    elseif not self.chooseButton.activeSelf and not isChoose and self.showChooseButton then
      self.chooseButton:SetActive(true)
    end
  end
end

function EquipMultiChooseCell:CheckValid()
  EquipMultiChooseCell.super.CheckValid(self)
  if not self.data then
    return
  end
  if self.cancelButton.activeSelf then
    if self.chooseButton.activeSelf then
      self.chooseButton:SetActive(false)
    else
      self.cancelButton:SetActive(false)
    end
  end
end

function EquipMultiChooseCell:SetCancelButtonText(text)
  if not self.cancelButtonLabel then
    return
  end
  self.cancelButtonLabel.text = tostring(text) or ""
end
