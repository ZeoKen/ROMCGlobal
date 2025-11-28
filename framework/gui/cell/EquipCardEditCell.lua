local BaseCell = autoImport("BaseCell")
EquipCardEditCell = class("EquipCardEditCell", BaseCell)

function EquipCardEditCell:Init()
  self.cardName = self:FindGO("CardName"):GetComponent(UILabel)
  self.activePart = self:FindGO("ActivePart")
  self.descLabel = self:FindGO("DescLabel"):GetComponent(UILabel)
  local cardContainer = self:FindGO("CardContainer")
  local obj = self:LoadPreferb("cell/ItemCardCell", cardContainer)
  obj.transform.localPosition = LuaGeometry.GetTempVector3()
  self.cardCell = ItemCardCell.new(obj)
  self.emptyPart = self:FindGO("Empty")
  self.changeBtn = self:FindGO("ChangeBtn")
  self.holeBtn = self:FindGO("HoleBtn")
  self.insertBtn = self:FindGO("InsertBtn")
  self.empthLabel = self:FindGO("EmptyLabel"):GetComponent(UILabel)
  self.emptyIcon = self:FindGO("EmptyIcon"):GetComponent(UIMultiSprite)
  self.chooseSymbol = self:FindGO("ChooseSymbol")
  self:SetEvent(self.changeBtn, function()
    self:PassEvent(UICellEvent.OnMidBtnClicked, self)
  end)
  self:SetEvent(self.holeBtn, function()
    self:PassEvent(UICellEvent.OnRightBtnClicked, self)
  end)
  self:SetEvent(self.insertBtn, function()
    self:PassEvent(UICellEvent.OnMidBtnClicked, self)
  end)
  self:AddCellClickEvent()
end

function EquipCardEditCell:SetData(data)
  self.data = data
  if data == EquipCardChooseCell.Status.Empty then
    self.activePart:SetActive(false)
    self.emptyPart:SetActive(true)
    self.emptyIcon.CurrentState = 0
    self.empthLabel.text = ZhString.ItemTip_EmptyCardSlot
    self.holeBtn:SetActive(false)
    self.insertBtn:SetActive(true)
    self.cardName.text = ZhString.CardPosChoosePopUp_EmptyName
  elseif data == EquipCardChooseCell.Status.Lock then
    self.activePart:SetActive(false)
    self.emptyPart:SetActive(true)
    self.emptyIcon.CurrentState = 1
    self.empthLabel.text = ZhString.ItemTip_LockCardSlot
    self.holeBtn:SetActive(true)
    self.insertBtn:SetActive(false)
    self.cardName.text = ZhString.CardPosChoosePopUp_EmptyName
  elseif data and data.cardInfo then
    self.activePart:SetActive(true)
    self.emptyPart:SetActive(false)
    local cardInfo = data.cardInfo
    self.cardName.text = data:GetName()
    local descStr = ""
    local bufferIds = data.cardInfo.BuffEffect.buff
    if bufferIds then
      for i = 1, #bufferIds do
        local str = ItemUtil.getBufferDescById(bufferIds[i])
        if 1 < i then
          descStr = descStr .. "\n"
        end
        descStr = descStr .. str
      end
    end
    self.descLabel.text = descStr
    UIUtil.WrapLabel(self.descLabel)
    self.cardCell:SetData(data)
  end
end

function EquipCardEditCell:SetChoose(bool)
  self.chooseSymbol:SetActive(bool)
end

function EquipCardEditCell:OnCellDestroy()
  self.cardCell = nil
end
