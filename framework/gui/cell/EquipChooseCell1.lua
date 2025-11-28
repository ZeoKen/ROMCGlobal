autoImport("ItemCell")
local BaseCell = autoImport("BaseCell")
EquipChooseCell1 = class("EquipChooseCell1", BaseCell)
EquipChooseCell1.CellControl = ItemCell
EquipChooseCell1.CellPrefab = "cell/ItemCell"
EquipChooseCell1Event = {
  ClickItemIcon = "EquipChooseCell1Event_ClickItemIcon",
  ClickSelf = "EquipChooseCell1Event_CLickSelf"
}
local redTipOffset = {-10, -10}

function EquipChooseCell1:Init()
  if not self.itemCell then
    local itemContainer = self:FindGO("ItemContainer")
    local go = self:LoadPreferb(self.CellPrefab, itemContainer)
    self.itemCell = self.CellControl.new(go)
    
    function self.itemCell.AttriGridReposition()
      if self.itemCell.attrGrid then
        self.itemCell.attrGrid:Reposition()
        self.itemCell.attrGrid.repositionNow = true
      end
    end
    
    self:AddClickEvent(itemContainer, function()
      self:PassEvent(EquipChooseCell1Event.ClickItemIcon, self.itemCell)
    end)
  end
  self.nameLab = self:FindComponent("ItemName", UILabel)
  self.chooseButton = self:FindGO("ChooseButton")
  self.chooseButtonLabel = self:FindComponent("Label", UILabel, self.chooseButton)
  self.equiped = self:FindGO("Equiped")
  self:AddClickEvent(self.chooseButton, function()
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
  self:AddClickEvent(self.gameObject, function()
    if self.validMsgId and self.validEvent and not self.validEvent(self.validParam, self.data) then
      MsgManager.ShowMsgByIDTable(self.validMsgId)
    end
  end)
  self.inValid = self:FindGO("InValid")
end

function EquipChooseCell1:SetValidEvent(validEvent, validParam, msgId)
  self.validEvent = validEvent
  self.validParam = validParam
  self.validMsgId = msgId
end

function EquipChooseCell1:SetData(data)
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
  self.equiped:SetActive(data.equiped == 1)
  self.nameLab.text = data.specialName or string.format(ZhString.EquipChooseCell1_FmtName, data:GetName(), Table_ItemType[data.staticData.Type].Name)
  self:UpdateValid()
  self:UpdateShowRedTip()
  self:RegisterGuide()
end

function EquipChooseCell1:UpdateShowRedTip(data)
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

function EquipChooseCell1:TryAddManualRedTip()
  if self.redTip then
    return
  end
  self.redTip = Game.AssetManager_UI:CreateAsset(RedTip.resID, self.itemIcon):GetComponent(UISprite)
  UIUtil.ChangeLayer(self.redTip, self.itemIcon.layer)
  self.redTip.transform.position = NGUIUtil.GetAnchorPoint(self.itemIcon, self.itemIconWidget, NGUIUtil.AnchorSide.TopRight, redTipOffset)
  self.redTip.transform.localScale = LuaGeometry.Const_V3_one
  self.redTip.depth = self.itemIconWidget.depth + 10
end

function EquipChooseCell1:TryRemoveManualRedTip()
  if not self.redTip then
    return
  end
  Game.GOLuaPoolManager:AddToUIPool(RedTip.resID, self.redTip.gameObject)
  self.redTip = nil
end

function EquipChooseCell1:SetShowChooseButton(isShow)
  if not self.chooseButton then
    return
  end
  self.chooseButton:SetActive(isShow and true or false)
end

function EquipChooseCell1:SetChooseButtonText(text)
  if not self.chooseButtonLabel then
    return
  end
  self.chooseButtonLabel.text = tostring(text) or ""
end

function EquipChooseCell1:RegisterGuide()
  if self.data.staticData.id == 42692 then
    self:AddOrRemoveGuideId(self.chooseButton, 533)
  end
end

function EquipChooseCell1:UpdateValid()
  if self.validEvent then
    local b = self.validEvent(self.validParam, self.data)
    self.inValid:SetActive(not b)
    self.chooseButton:SetActive(b)
  else
    self.inValid:SetActive(false)
    self.chooseButton:SetActive(true)
  end
end

function EquipChooseCell1:HideItemInValid()
  if self.itemCell then
    self.itemCell.invalid = nil
  end
end
