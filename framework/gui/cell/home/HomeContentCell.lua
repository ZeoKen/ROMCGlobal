HomeContentCell = class("HomeContentCell", BaseCell)
local color_Red = LuaColor(1.0, 0.3764705882352941, 0.40784313725490196, 1)
local color_White = LuaColor.white

function HomeContentCell:Init()
  HomeContentCell.super.Init(self)
  self:FindObjs()
  self:AddEvts()
end

function HomeContentCell:FindObjs()
  local objIcon = self:FindGO("sprIcon")
  self.icon = {
    gameObject = objIcon,
    sprite = objIcon:GetComponent(UISprite)
  }
  self.objLabNum = self:FindGO("labNum")
  self.labNum = self.objLabNum:GetComponent(UILabel)
  self.objSelect = self:FindGO("Select")
  self.objMask = self:FindGO("Mask")
  self.objCanMake = self:FindGO("CanMake", self.objMask)
  self.objLock = self:FindGO("Lock", self.objMask)
  self.objBPNumBoard = self:FindGO("BPNumBoard")
  self.labTotalNum = self:FindComponent("labTotalNum", UILabel, self.objBPNumBoard)
  self.labCurNum = self:FindComponent("labCurNum", UILabel, self.objBPNumBoard)
end

function HomeContentCell:AddEvts()
  self:AddCellClickEvent()
  self:AddPressEvent(self.gameObject, function(go, isPress)
    self:OnPressCell(go, isPress)
  end)
  self:AddDragEvent(self.gameObject, function(go, delta)
    self:OnDragCell(go, delta)
  end)
  local objDragCollider = self:FindGO("DragCollider")
  self:AddPressEvent(objDragCollider, function(go, isPress)
    self:OnPressCell(go, isPress)
  end)
  self:AddDragEvent(objDragCollider, function(go, delta)
    self:OnDragList(go, delta)
  end)
end

function HomeContentCell:SetData(data)
  self.data = data
  local haveData = data ~= nil
  if not self.functionDisabled and self.isActive ~= haveData then
    self.gameObject:SetActive(haveData)
    self.isActive = haveData
  end
  if not haveData then
    return
  end
  self.staticID = data.staticID
  local setSuc = IconManager:SetItemIcon(data.itemStaticData and data.itemStaticData.Icon or "item_45001", self.icon.sprite)
  self.icon.gameObject:SetActive(setSuc)
  if setSuc then
    self.icon.sprite:MakePixelPerfect()
  end
  self:RefreshContentStatus()
  if self.functionDisabled then
    return
  end
  self:Select(data.isContentData and data:IsSelect())
  self:RefreshBPStatus()
end

function HomeContentCell:RefreshContentStatus()
  if self.functionDisabled or not self.data then
    return
  end
  self.objLabNum:SetActive(self.data.type == HomeContentData.Type.Furniture and self.data.numInBag > 0)
  self.labNum.text = self.data.numInBag
  self.objMask:SetActive(not self.data:IsUsable())
  self.objCanMake:SetActive(self.data.canMake == true)
  self.objLock:SetActive(not self.data.isUnlocked)
end

function HomeContentCell:SetID(id)
  self.id = id
end

function HomeContentCell:IsActive()
  return self.isActive == true
end

function HomeContentCell:DisableFunctions(keepColliderActive)
  self.functionDisabled = true
  self.objLabNum:SetActive(false)
  self.objMask:SetActive(false)
  self.gameObject:GetComponent(Collider).enabled = keepColliderActive == true
end

function HomeContentCell:OnPressCell(go, isPress)
  if self.functionDisabled then
    return
  end
  self.isPress = isPress
  self.isDragList = false
  self:PassEvent(MouseEvent.MousePress, self)
end

function HomeContentCell:OnDragCell(go, delta)
  if self.functionDisabled then
    return
  end
  self.delta = delta
  self.isDragList = self.data.type == HomeContentData.Type.Renovation
  self:PassEvent(DragDropEvent.OnDrag, self)
end

function HomeContentCell:OnDragList(go, delta)
  if self.functionDisabled then
    return
  end
  self.isDragList = true
  self:PassEvent(DragDropEvent.OnDrag, self)
end

function HomeContentCell:RefreshBPStatus()
  local isBpMode = HomeManager.Me():IsBluePrintMode()
  self.objBPNumBoard:SetActive(isBpMode == true)
  if isBpMode then
    local curBPData = HomeManager.Me():GetCurBluePrintData()
    local finishedNum = HomeManager.Me():GetBluePrintFurnitureFinishedNum(self.staticID) or 0
    local needNum = curBPData and curBPData:GetFurnitureNeedNum(self.staticID) or 0
    self.labCurNum.text = finishedNum
    self.labCurNum.color = finishedNum < needNum and color_Red or color_White
    self.labTotalNum.text = "/" .. needNum
  end
end

function HomeContentCell:Select(isSelect, data)
  if self.functionDisabled then
    return
  end
  self.objSelect:SetActive(isSelect)
  self.isSelect = isSelect
  if self.data and self.data == data then
    self.data:Select(isSelect)
  end
end
