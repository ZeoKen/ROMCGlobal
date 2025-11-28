autoImport("BaseCombineCell")
autoImport("GemCell")
GemCombineBaseCell = class("GemCombineBaseCell", BaseCombineCell)

function GemCombineBaseCell:Init()
  self.table = self:FindComponent("Table", UITable)
  self.checkTip = self:FindGO("Check")
  self.checkTip:SetActive(false)
end

function GemCombineBaseCell:InitCells(count)
  GemCombineBaseCell.super.InitCells(self, count, "GemCell", GemCell, self.table.gameObject)
end

function GemCombineBaseCell:SetData(data)
  GemCombineBaseCell.super.SetData(self, data)
  local index = self.indexInList
  if index then
    for i = 1, #self.childCells do
      self.childCells[i].indexInTable = #self.childCells * (index - 1) + i
    end
  end
  self:UpdateCheckTip()
end

function GemCombineBaseCell:Reposition()
  self.table:Reposition()
end

function GemCombineBaseCell:UpdateCheckTip()
  self.checkTip:SetActive(self:CheckCheckTipEnable())
end

function GemCombineBaseCell:CheckCheckTipEnable()
  if not self.checkTipEnablePredicate then
    return false
  end
  if not self.data or not next(self.data) then
    return false
  end
  return self.checkTipEnablePredicate(self.data)
end

function GemCombineBaseCell:GetCheckTipEnabled()
  return self.checkTip.activeSelf
end

function GemCombineBaseCell:SetCheckTipEnablePredicate(predicate)
  if predicate and type(predicate) ~= "function" then
    LogUtility.Error("Invalid argument: predicate")
    return
  end
  self.checkTipEnablePredicate = predicate
  self:UpdateCheckTip()
end

function GemCombineBaseCell:GetCell(index)
  if not self.childCells then
    return
  end
  return self.childCells[index]
end

function GemCombineBaseCell:SetShowNewTag(isShow)
  for _, cell in pairs(self.childCells) do
    cell:SetShowNewTag(isShow)
  end
end

function GemCombineBaseCell:ForceShowDeleteIcon()
  for _, cell in pairs(self.childCells) do
    if not cell:CheckDataIsNilOrEmpty() then
      cell:ForceShowDeleteIcon()
    end
  end
end

GemCombine5Cell = class("GemCombine5Cell", GemCombineBaseCell)

function GemCombine5Cell:Init()
  GemCombine5Cell.super.Init(self)
  self:InitCells(5)
end

GemCombine3Cell = class("GemCombine3Cell", GemCombineBaseCell)

function GemCombine3Cell:Init()
  GemCombine3Cell.super.Init(self)
  self:InitCells(3)
end
