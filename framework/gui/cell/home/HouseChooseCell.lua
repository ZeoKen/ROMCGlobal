HouseChooseCell = class("HouseChooseCell", BaseCell)

function HouseChooseCell.SetSelectID(id)
  HouseChooseCell.CurSelectID = id
end

function HouseChooseCell:Init()
  HouseChooseCell.super.Init(self)
  self:FindObjs()
  self:AddEvts()
end

function HouseChooseCell:FindObjs()
  self.objHouseIcon = self:FindGO("sprHouseIcon")
  self.sprHouseIcon = self.objHouseIcon:GetComponent(UISprite)
  self.objLock = self:FindGO("lock")
  self.labHouseName = self:FindComponent("labHouseName", UILabel)
  self.objSelect = self:FindGO("select")
end

function HouseChooseCell:AddEvts()
  self:AddCellClickEvent()
end

function HouseChooseCell:SetData(data)
  self.data = data
  local haveData = data ~= nil
  if self.isActive ~= haveData then
    self.gameObject:SetActive(haveData)
    self.isActive = haveData
  end
  if not haveData then
    return
  end
  self.labHouseName.text = data.NameZh
  local success = IconManager:SetHomeBuildingIcon(data.Icon, self.sprHouseIcon)
  self.objHouseIcon:SetActive(success == true)
  if success then
    self.sprHouseIcon:MakePixelPerfect()
  end
  self.objLock:SetActive(not FunctionUnLockFunc.Me():CheckCanOpen(data.MenuID))
  self:RefreshSelect()
end

function HouseChooseCell:RefreshSelect()
  self.objSelect:SetActive(self.CurSelectID ~= nil and (self.data and self.data.id) == self.CurSelectID)
end
