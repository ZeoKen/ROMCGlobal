autoImport("BagItemCell")
MaterialSelectItemCell = class("MaterialSelectItemCell", BagItemCell)

function MaterialSelectItemCell:Init()
  MaterialSelectItemCell.super.Init(self)
  self:InitCell()
end

function MaterialSelectItemCell:InitCell()
  self.addIcon = self:FindGO("AddIcon")
  self.selected = self:FindGO("Selected")
  self.selectedLabel = self:FindComponent("SelectedLabel", UILabel)
  self.selectedTable = self.selected:GetComponent(UITable)
  self.deselect = self:FindGO("Deselect")
  if self.deselect then
    self:AddClickEvent(self.deselect, function()
      self:PassEvent(ItemEvent.ItemDeselect, self)
    end)
  end
  local longPress = self.gameObject:GetComponent(UILongPress)
  if longPress then
    function longPress.pressEvent(obj, state)
      self:PassEvent(MouseEvent.LongPress, {state, self})
    end
  end
  longPress = self.deselect:GetComponent(UILongPress)
  if longPress then
    function longPress.pressEvent(obj, state)
      self:PassEvent(ItemEvent.ItemDeselectLongPress, {state, self})
    end
  end
  self.selectedCount = 0
end

function MaterialSelectItemCell:SetData(data)
  MaterialSelectItemCell.super.SetData(self, data)
  self:_SetData(data)
end

function MaterialSelectItemCell:_SetData(data)
  self:UpdateSelect()
end

function MaterialSelectItemCell:SetSelectReference(reference)
  if type(reference) ~= "table" then
    LogUtility.Error("SelectedDatas is not table while setting selectedCount!")
    return
  end
  self.selectedReference = reference
  self:UpdateSelect()
end

function MaterialSelectItemCell:UpdateSelect()
  local selectedCount = 0
  if self.selectedReference and type(self.data) == "table" then
    for _, sData in pairs(self.selectedReference) do
      if sData.id == self.data.id then
        selectedCount = selectedCount + 1
      end
    end
  end
  self.selectedCount = selectedCount
  self:UpdateSelectedCount()
end

function MaterialSelectItemCell:UpdateSelectedCount()
  local isSelected = self.selectedCount > 0
  if isSelected then
    self:ShowMask()
  else
    self:HideMask()
  end
  self.selected:SetActive(isSelected)
  self.selectedLabel.text = string.format("x%s", self.selectedCount)
  if self.selectedTable then
    self.selectedTable:Reposition()
  end
  self:TrySetShowDeselect(isSelected)
end

function MaterialSelectItemCell:TrySetShowDeselect(isShow)
  if not self.deselect then
    return
  end
  self.deselect:SetActive(isShow and true or false)
end
