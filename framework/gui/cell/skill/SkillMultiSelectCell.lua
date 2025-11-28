local baseCell = autoImport("BaseCell")
SkillMultiSelectCell = class("SkillMultiSelectCell", baseCell)

function SkillMultiSelectCell:Init()
  self:FindObjs()
  self:InitShow()
end

function SkillMultiSelectCell:FindObjs()
  self.label = self:FindGO("Label"):GetComponent(UILabel)
  self.checkMark = self:FindGO("CheckMark")
  self.toggleContainer = self:FindGO("ToggleContainer")
  if self.toggleContainer then
    self.toggleContainer:SetActive(false)
    self:InitToggle()
  end
end

function SkillMultiSelectCell:InitShow()
  self.check = self:FindGO("Check")
  self:SetEvent(self.check, function()
    self.select = not self.select
    if self.data.switchTeammate then
      local subSkillList = Game.SkillOptionManager:GetMultiSkillOption(self.opt, self.sortID)
      Game.SkillOptionManager:AskSetMultiSkillOption(self.opt, self.sortID, subSkillList, nil, nil, self.select and 1 or 0)
      self:ShowSelect(self.select)
    end
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
end

function SkillMultiSelectCell:SetData(data)
  self.data = data
  if data then
    self.label.text = data.text
    self.check:SetActive(data.isToggle ~= true)
    self.toggleContainer:SetActive(data.isToggle == true)
    self:ShowSelect(data.select)
    self.opt = data.opt
    self.sortID = data.sortID
    self.select = data.select
  end
end

function SkillMultiSelectCell:SetSelect(isSelect)
  local data = self.data
  if data then
    if isSelect == data.select then
      return
    end
    self:ShowSelect(isSelect)
    data.select = isSelect
  end
end

function SkillMultiSelectCell:ShowSelect(isShow)
  if self.data.isToggle then
    if self.selectSP then
      self.selectSP:SetActive(isShow)
    end
  else
    self.checkMark:SetActive(isShow)
  end
end

function SkillMultiSelectCell:IsSelect()
  return self.data and self.data.select or false
end

function SkillMultiSelectCell:IsToggle()
  return self.data and self.data.isToggle
end

function SkillMultiSelectCell:InitToggle()
  self.selectSP = self:FindGO("SpecialSelect", self.toggleContainer)
  local clicksp = self:FindGO("SpecialBg", self.toggleContainer)
  self:SetEvent(clicksp, function()
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
end
