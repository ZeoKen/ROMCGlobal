autoImport("AdventureHomeSkillCell")
AdventureHomeSkillTipCell = class("AdventureHomeSkillTipCell", AdventureHomeSkillCell)

function AdventureHomeSkillTipCell:FindObjs()
  AdventureHomeSkillTipCell.super.FindObjs(self)
end

function AdventureHomeSkillTipCell:InitEvents()
  self:SetEvent(self.itemContainer.gameObject, function()
    self:PassEvent(UICellEvent.OnCellClicked, self)
  end)
end

function AdventureHomeSkillTipCell:SetData(data)
  AdventureHomeSkillTipCell.super.SetData(self, data)
  if data and data.skillItemData then
    self.name.text = data.skillItemData.staticData.NameZh or ""
    local skillItemData = data.skillItemData
    if skillItemData.learned then
      self.name.alpha = 0.5
      self.level.alpha = 0.5
    else
      self.name.alpha = 1
      self.level.alpha = 1
    end
  end
end
