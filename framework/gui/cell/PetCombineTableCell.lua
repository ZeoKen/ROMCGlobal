autoImport("PetComposeItemCell")
PetCombineTableCell = class("PetCombineTableCell", BaseCell)

function PetCombineTableCell:Init()
  self:FindObj()
  self:InitCell()
  self:AddCellClickEvent()
end

function PetCombineTableCell:FindObj()
  self.starGrid = self:FindComponent("StarGrid", UIGrid)
  self.petGrid = self:FindComponent("PetGrid", UIGrid)
  self.starPrefab = self:FindGO("StarPrefab")
  self.contractSymbol = self:FindGO("Contract")
  if self.contractSymbol == nil then
    self.contractSymbol = self:FindGO("ContractSymbol")
  end
end

function PetCombineTableCell:InitCell()
  self.starObj = {}
  self.petCtl = UIGridListCtrl.new(self.petGrid, PetComposeItemCell, "PetComposeItemCell")
  self.petCtl:AddEventListener(MouseEvent.MouseClick, self.ClickChoosenPetCell, self)
end

function PetCombineTableCell:ClickChoosenPetCell(cellctl)
  if cellctl and cellctl.data then
    self:PassEvent(MouseEvent.MouseClick, cellctl)
  end
end

function PetCombineTableCell:SetContractSymbol(active)
  if self.contractSymbol then
    self.contractSymbol:SetActive(active == true)
  end
end

function PetCombineTableCell:SetStar()
  if self.starGrid == nil then
    return
  end
  self.starGrid.gameObject:SetActive(true)
  local star = self.data and self.data.star or 0
  local childCount = self.starGrid.gameObject.transform.childCount
  for i = 1, childCount - 1 do
    local trans = self.starGrid.gameObject.transform:GetChild(i)
    self:Hide(trans.gameObject)
  end
  for i = 1, star do
    local obj = self.starObj[i]
    if not obj then
      local starObj = self:CopyGameObject(self.starPrefab)
      starObj:SetActive(true)
      starObj.transform:SetParent(self.starGrid.gameObject.transform)
      starObj.name = string.format("starSymbol%02d", i)
      self.starObj[i] = starObj
    else
      obj:SetActive(true)
    end
  end
  self.starGrid:Reposition()
end

function PetCombineTableCell:SetData(data)
  self.data = data
  if data then
    self.petCtl:ResetDatas(data.value)
    local isContract = data.contractSymbol == true
    self:SetContractSymbol(isContract)
    if "number" == type(data.star) then
      self:SetStar()
    elseif self.starGrid then
      self.starGrid.gameObject:SetActive(false)
    end
  else
    self.petCtl:ResetDatas()
    self:SetContractSymbol(false)
    if self.starGrid then
      self.starGrid.gameObject:SetActive(false)
    end
  end
end

function PetCombineTableCell:GetCells()
  return self.petCtl:GetCells()
end
