autoImport("ItemCell")
local BaseCell = autoImport("BaseCell")
MaterialChooseCell1 = class("MaterialChooseCell1", BaseCell)
MaterialChooseCell1.CellControl = ItemCell
MaterialChooseCell1.CellPrefab = "cell/MaterialItemCell1"
MaterialChooseCell1.Event = {
  ClickItemIcon = "MaterialChooseCell1_Event_ClickItemIcon",
  CountChooseChange = "MaterialChooseCell1_Event_CountChooseChange"
}
local redTipOffset = {-10, -10}

function MaterialChooseCell1:Init()
  if not self.itemCell then
    local itemContainer = self:FindGO("ItemContainer")
    local go = self:LoadPreferb(self.CellPrefab, itemContainer)
    self.itemCell = self.CellControl.new(go)
    self.itemCell.DefaultNumLabelLocalPos = LuaVector3.New(0, -37, 0)
    self:AddClickEvent(itemContainer, function()
      self:PassEvent(MaterialChooseCell1.Event.ClickItemIcon, self.itemCell)
    end)
  end
  self.nameLab = self:FindComponent("ItemName", UILabel)
  self.inValid = self:FindGO("InValid")
  self:AddClickEvent(self.gameObject, function()
    if self.validMsgId and self.validEvent and not self.validEvent(self.validParam, self.data) then
      MsgManager.ShowMsgByIDTable(self.validMsgId)
    end
  end)
  self:InitChooseButton()
  self:InitCountChooseBord()
end

function MaterialChooseCell1:InitChooseButton()
  self.chooseButton = self:FindGO("ChooseButton")
  self.chooseButtonLabel = self:FindComponent("Label", UILabel, self.chooseButton)
  self:AddClickEvent(self.chooseButton, function()
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
end

function MaterialChooseCell1:InitCountChooseBord()
  self.countChooseBord = self:FindGO("CountChooseBord")
  if not self.countChooseBord then
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
    self:PassEvent(MaterialChooseCell1.Event.CountChooseChange, self)
  end)
  self.countChoose_Count = self:FindComponent("Count", UILabel, self.countChooseBord)
end

function MaterialChooseCell1:DoAddCountChoose()
  if not self.data then
    return
  end
  self:SetChooseCount(self.chooseCount + 1)
  self:PassEvent(MaterialChooseCell1.Event.CountChooseChange, self)
end

function MaterialChooseCell1:DoMinusCountChoose()
  if not self.data then
    return
  end
  self:SetChooseCount(self.chooseCount - 1)
  self:PassEvent(MaterialChooseCell1.Event.CountChooseChange, self)
end

function MaterialChooseCell1:QuickMinusAddCountChoose(open)
  if open then
    TimeTickManager.Me():CreateTick(0, 100, self.DoMinusCountChoose, self, 12)
  else
    TimeTickManager.Me():ClearTick(self, 12)
  end
end

function MaterialChooseCell1:QuickDoAddCountChoose(open)
  if open then
    TimeTickManager.Me():CreateTick(0, 100, self.DoAddCountChoose, self, 11)
  else
    TimeTickManager.Me():ClearTick(self, 11)
  end
end

function MaterialChooseCell1:SetChooseReference(refDatas)
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

function MaterialChooseCell1:SetChooseCount(count)
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

function MaterialChooseCell1:_ActiveButton(b, sp, collider)
  b = b and true or false
  sp.alpha = b and 1 or 0.5
  collider.enabled = b
end

function MaterialChooseCell1:UpdateCountChoose()
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

function MaterialChooseCell1:GetMaxNumOfItem()
  if not self.data then
    return 0
  end
  local staticMaxNum, num = self.data.staticData.MaxNum, self:GetItemNum()
  local max = staticMaxNum and math.min(num, staticMaxNum) or num
  return math.min(max, 99999)
end

function MaterialChooseCell1:GetItemNum()
  if not self.data then
    return 0
  end
  if self.useItemNum then
    return self.data.num or 0
  end
  return HappyShopProxy.Instance:GetItemNum(self.data.staticData.id)
end

function MaterialChooseCell1:SetUseItemNum(b)
  self.useItemNum = b
end

function MaterialChooseCell1:SetData(data)
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
  self.nameLab.text = data:GetSpecialName() or data:GetName()
  self:UpdateShowRedTip()
  self:RegisterGuide()
  self:UpdateValid()
end

function MaterialChooseCell1:UpdateShowRedTip(data)
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

function MaterialChooseCell1:TryAddManualRedTip()
  if self.redTip then
    return
  end
  self.redTip = Game.AssetManager_UI:CreateAsset(RedTip.resID, self.itemIcon):GetComponent(UISprite)
  UIUtil.ChangeLayer(self.redTip, self.itemIcon.layer)
  self.redTip.transform.position = NGUIUtil.GetAnchorPoint(self.itemIcon, self.itemIconWidget, NGUIUtil.AnchorSide.TopRight, redTipOffset)
  self.redTip.transform.localScale = LuaGeometry.Const_V3_one
  self.redTip.depth = self.itemIconWidget.depth + 10
end

function MaterialChooseCell1:TryRemoveManualRedTip()
  if not self.redTip then
    return
  end
  Game.GOLuaPoolManager:AddToUIPool(RedTip.resID, self.redTip.gameObject)
  self.redTip = nil
end

function MaterialChooseCell1:SetShowChooseButton(isShow)
  if not self.chooseButton then
    return
  end
  self.chooseButton:SetActive(isShow and true or false)
end

function MaterialChooseCell1:SetChooseButtonText(text)
  if not self.chooseButtonLabel then
    return
  end
  self.chooseButtonLabel.text = tostring(text) or ""
end

function MaterialChooseCell1:RegisterGuide()
  if self.data.staticData.id == 42692 then
    self:AddOrRemoveGuideId(self.chooseButton, 533)
  end
end

function MaterialChooseCell1:SetValidEvent(validEvent, validParam, msgId)
  self.validEvent = validEvent
  self.validParam = validParam
  self.validMsgId = msgId
end

function MaterialChooseCell1:UpdateValid()
  if self.validEvent then
    local b = self.validEvent(self.validParam, self.data)
    self.inValid:SetActive(not b)
    if not b then
      self.chooseButton:SetActive(false)
      self.countChooseBord:SetActive(false)
    else
      self:UpdateChooseStyle()
    end
  else
    self.inValid:SetActive(false)
    self:UpdateChooseStyle()
  end
end

function MaterialChooseCell1:UpdateChooseStyle()
  if self.data.chooseCount then
    self.countChooseBord:SetActive(true)
    self.chooseButton:SetActive(false)
    self.chooseCount = self.data.chooseCount
    self:UpdateCountChoose()
  else
    self.countChooseBord:SetActive(false)
    self.chooseButton:SetActive(true)
  end
end
