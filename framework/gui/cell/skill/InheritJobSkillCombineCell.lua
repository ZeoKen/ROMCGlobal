autoImport("InheritSkillCell")
InheritJobSkillCombineCell = class("InheritJobSkillCombineCell", BaseCell)

function InheritJobSkillCombineCell:Init()
  self.height = 0
  self.isExpend = true
  self:FindObjs()
end

function InheritJobSkillCombineCell:FindObjs()
  self.jobLabel = self:FindComponent("JobLabel", UILabel)
  self.jobBg = self:FindComponent("JobBg", UISprite)
  self.expendBtnSp = self:FindComponent("ExpendBtn", UISprite)
  self:AddClickEvent(self.expendBtnSp.gameObject, function()
    self.isExpend = not self.isExpend
    InheritSkillProxy.Instance:SetSkillExpandState(self.data and self.data.profession, self.isExpend)
    self:UpdateExpend()
    self:PassEvent(InheritSkillEvent.ExpendSkill)
  end)
  self.expendLabel = self:FindComponent("ExpendLabel", UILabel)
  self.grid = self:FindComponent("Grid", UIGrid)
  self.inheritSkillListCtrl = UIGridListCtrl.new(self.grid, InheritSkillCell, "InheritSkillCell")
  self.inheritSkillListCtrl:AddEventListener(MouseEvent.MouseClick, self.OnInheritSkillClick, self)
end

function InheritJobSkillCombineCell:SetData(data)
  self.data = data
  if data then
    self.isExpend = InheritSkillProxy.Instance:GetSkillExpandState(data.profession)
    local skills = data:GetSkills()
    local pro = data.profession
    if 0 < pro then
      local config = Table_Class[pro]
      if config then
        local sex = MyselfProxy.Instance:GetMySex()
        if config.gender and config.gender ~= 0 and sex ~= config.gender then
          local familyId = skills[1].sortID
          pro = InheritSkillProxy.GetSkillProfess(familyId)
          config = Table_Class[pro]
        end
        self.jobLabel.text = string.format(ZhString.InheritSkill_Job, ProfessionProxy.GetProfessionName(pro, sex))
      end
    else
      self.jobLabel.text = ZhString.InheritSkill_OtherJob
    end
    self.inheritSkillListCtrl:ResetDatas(skills)
    self:UpdateExpend()
  end
end

function InheritJobSkillCombineCell:UpdateExpend()
  self.expendBtnSp.flip = self.isExpend and 2 or 0
  self.expendLabel.text = self.isExpend and ZhString.InheritSkill_UnExpend or ZhString.InheritSkill_Expend
  self.grid.gameObject:SetActive(self.isExpend or false)
  self:CalculateHeight()
end

function InheritJobSkillCombineCell:CalculateHeight()
  self.height = NGUIMath.CalculateRelativeWidgetBounds(self.trans).size.y
end

function InheritJobSkillCombineCell:OnInheritSkillClick(cell)
  local skill = cell.data
  if skill then
    self:PassEvent(MouseEvent.MouseClick, cell)
  end
end

function InheritJobSkillCombineCell:GetSkillCells()
  return self.inheritSkillListCtrl:GetCells()
end

function InheritJobSkillCombineCell:UpdateDragable(enable)
  local cells = self.inheritSkillListCtrl:GetCells()
  for i = 1, #cells do
    cells[i]:UpdateDragable(enable)
  end
end
