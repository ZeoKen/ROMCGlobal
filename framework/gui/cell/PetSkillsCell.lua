local BaseCell = autoImport("BaseCell")
PetSkillsCell = class("PetSkillsCell", BaseCell)
autoImport("PetSkillCell")

function PetSkillsCell:Init()
  self.skillGrid = self:FindComponent("SkillGrid", UIGrid)
  self.skillsCtl = UIGridListCtrl.new(self.skillGrid, PetSkillCell, "PetSkillCell")
  self.skillsCtl:AddEventListener(MouseEvent.MouseClick, self.ClickSkill, self)
  self.endLine = self:FindGO("Line2")
end

function PetSkillsCell:ClickSkill(cell)
  self:PassEvent(MouseEvent.MouseClick, cell)
end

local tempV3 = LuaVector3()

function PetSkillsCell:SetData(datas)
  if datas and 0 < #datas then
    self.skillsCtl:ResetDatas(datas)
    local count = #datas
    local cellHeight = self.skillGrid.cellHeight
    local maxPerLine = self.skillGrid.maxPerLine
    local line2_posY = -135 - (math.ceil(count / maxPerLine) - 1) * cellHeight
    tempV3[2] = line2_posY
    self.endLine.transform.localPosition = tempV3
  end
end

function PetSkillsCell:HideLine(flag)
  if not flag then
    self:Show(self.endLine)
  else
    self:Hide(self.endLine)
  end
end

function PetSkillsCell:SetScale(size)
  local cells = self:GetCells()
  if not cells then
    return
  end
  for i = 1, #cells do
    cells[i]:SetScale(size)
  end
end

function PetSkillsCell:GetCells()
  if self.skillsCtl then
    return self.skillsCtl:GetCells()
  end
end

local IsSkillSlotMatch = function(skillSlots, skillSlot)
  if skillSlots == nil then
    return true
  end
  if skillSlot == nil then
    return false
  end
  for i = 1, #skillSlots do
    if skillSlots[i] == skillSlot then
      return true
    end
  end
  return false
end

function PetSkillsCell:PlayResetEffect(skillSlots)
  local cells = self:GetCells()
  if not cells then
    return
  end
  for i = 1, #cells do
    local data = cells[i].data
    if skillSlots == nil or type(data) == "table" and IsSkillSlotMatch(skillSlots, data.skillSlot) then
      cells[i]:PlayResetEffect()
    end
  end
end
