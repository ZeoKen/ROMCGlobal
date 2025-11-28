autoImport("DynamicSkillItemCell")
DynamicSkillEffTableCell = class("DynamicSkillEffTableCell", BaseCell)

function DynamicSkillEffTableCell:Init()
  self:FindObj()
  self:InitCell()
  self:AddCellClickEvent()
end

function DynamicSkillEffTableCell:FindObj()
  self.professionSpr = self:FindComponent("ProfessionSpr", UISprite)
  self.professionLab = self:FindComponent("ProfessionLab", UILabel)
  self.grid = self:FindComponent("Grid", UIGrid)
end

function DynamicSkillEffTableCell:InitCell()
  self.itemCtl = UIGridListCtrl.new(self.grid, DynamicSkillItemCell, "DynamicSkillItemCell")
  self.itemCtl:AddEventListener(MouseEvent.MouseClick, self.OnClickCell, self)
end

function DynamicSkillEffTableCell:OnClickCell(cellctl)
  if cellctl and cellctl.data then
    self:PassEvent(MouseEvent.MouseClick, cellctl)
  end
end

function DynamicSkillEffTableCell:SetData(data)
  self.data = data
  if data then
    local pro = data.pro and Table_Class[data.pro]
    if pro then
      self.professionLab.text = pro.NameZh
      IconManager:SetNewProfessionIcon(pro.icon, self.professionSpr)
    end
    self.itemCtl:ResetDatas(data.value:GetEffectList())
  end
end

function DynamicSkillEffTableCell:GetCells()
  return self.itemCtl:GetCells()
end
