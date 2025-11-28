local fixedBg = "icon_34_new"
EquipMfrChooseItemCell = class("EquipMfrChooseItemCell", ItemCell)

function EquipMfrChooseItemCell:Init()
  self:InitView()
  self:AddEvt()
  self:AddCellClickEvent()
  EquipMfrChooseItemCell.super.Init(self)
end

function EquipMfrChooseItemCell:InitView()
  self.chooseFlag = self:FindGO("Choose")
  self.itemObj = self:LoadPreferb("cell/ItemCell", self.gameObject)
  self.itemObj.transform.localPosition = LuaGeometry.GetTempVector3()
  local bgobj = self:FindGO("Bg")
  bgobj:SetActive(false)
end

function EquipMfrChooseItemCell:AddEvt()
  self.tipData = {}
  self.tipData.funcConfig = {}
  local press = function(obj, state)
    if state and self.data ~= nil and self.data.itemData ~= nil then
      self.tipData.itemdata = self.data.itemData
      TipManager.Instance:ShowItemFloatTip(self.tipData, self.icon, NGUIUtil.AnchorSide.Right, {210, -50})
    end
  end
  self.longPress = self.gameObject:GetComponent(UILongPress)
  self.longPress.pressEvent = press
end

function EquipMfrChooseItemCell:SetData(data)
  if data then
    EquipMfrChooseItemCell.super.SetData(self, data.itemData)
    self.data = data
    self:Show(self.itemObj)
  else
    self.data = nil
    self:Hide(self.itemObj)
  end
  self:UpdateChoose()
end

function EquipMfrChooseItemCell:SetChoose(chooseId)
  self.chooseId = chooseId
  self:UpdateChoose()
end

function EquipMfrChooseItemCell:UpdateChoose()
  if self.data and self.chooseId and self.data.composeId == self.chooseId then
    self.chooseFlag:SetActive(true)
  else
    self.chooseFlag:SetActive(false)
  end
end
