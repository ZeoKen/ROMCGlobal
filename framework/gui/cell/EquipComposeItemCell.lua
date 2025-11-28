local fixedBg = "icon_34_new"
EquipComposeItemCell = class("EquipComposeItemCell", ItemNewCell)

function EquipComposeItemCell:Init()
  self:InitView()
  self:AddEvt()
  self:AddCellClickEvent()
  EquipComposeItemCell.super.Init(self)
end

function EquipComposeItemCell:InitView()
  self.chooseFlag = self:FindGO("Choose")
  self.itemObj = self:LoadPreferb("cell/ItemNewCell", self.gameObject)
  self.itemObj.transform.localPosition = LuaGeometry.GetTempVector3()
end

function EquipComposeItemCell:AddEvt()
  self.tipData = {}
  self.tipData.funcConfig = {}
  local press = function(obj, state)
    if state and self.data ~= nil and self.data.itemdata ~= nil then
      self.tipData.itemdata = self.data.itemdata
      TipManager.Instance:ShowItemFloatTip(self.tipData, self.icon, NGUIUtil.AnchorSide.Right, {210, -50})
    end
  end
  self.longPress = self.gameObject:GetComponent(UILongPress)
  self.longPress.pressEvent = press
end

function EquipComposeItemCell:SetData(data)
  if data then
    EquipComposeItemCell.super.SetData(self, data.itemdata)
    self.data = data
    self:Show(self.itemObj)
  else
    self.data = nil
    self:Hide(self.itemObj)
  end
  self:UpdateChoose()
end

function EquipComposeItemCell:SetChoose(chooseId)
  self.chooseId = chooseId
  self:UpdateChoose()
end

function EquipComposeItemCell:UpdateChoose()
  if self.data and self.chooseId and self.data.composeID == self.chooseId then
    self.chooseFlag:SetActive(true)
  else
    self.chooseFlag:SetActive(false)
  end
end
