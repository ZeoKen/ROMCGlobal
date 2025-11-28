EquipMemoryFullBodyChangeCell = class("EquipMemoryFullBodyChangeCell", BaseCell)

function EquipMemoryFullBodyChangeCell:Init()
  self.wax = self:FindGO("Wax"):GetComponent(UIMultiSprite)
  self.name = self:FindGO("Name"):GetComponent(UILabel)
  self.starGrid = self:FindGO("StarGrid"):GetComponent(UIGrid)
  self.stars = {}
  self.starStatusArrow = {}
  for i = 1, 3 do
    local go = self:FindGO("Star" .. i, self.starGrid.gameObject)
    self.stars[i] = go:GetComponent(UILabel)
    self.starStatusArrow[i] = self:FindGO("StatusArrow", go):GetComponent(UIMultiSprite)
  end
  self:AddCellClickEvent()
end

function EquipMemoryFullBodyChangeCell:SetData(data)
  self.data = data
  local waxLevel = data.wax_level or 0
  self.wax.CurrentState = waxLevel
  local levels = data.levels
  for i = 1, 3 do
    if levels[i] then
      local _level = levels[i].level
      self.stars[i].gameObject:SetActive(true)
      self.stars[i].text = _level
      local status = levels[i].status
      if status then
        self.starStatusArrow[i].gameObject:SetActive(true)
        self.starStatusArrow[i].CurrentState = status
      else
        self.starStatusArrow[i].gameObject:SetActive(false)
      end
    else
      self.stars[i].gameObject:SetActive(false)
    end
  end
  self.starGrid:Reposition()
  local attrId = data.id
  local attrInfo = attrId and ItemUtil.GetMemoryEffectInfo(attrId)
  if attrInfo then
    self.name.text = attrInfo[1].BuffName or "???"
  end
end
