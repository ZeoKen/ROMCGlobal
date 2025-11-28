local baseCell = autoImport("BaseCell")
AttributePointSolutionCell = class("AttributePointSolutionCell", baseCell)

function AttributePointSolutionCell:Init()
  self:initView()
  self:addViewEventListener()
end

function AttributePointSolutionCell:initView()
  self.icon = self:FindGO("solutionIcon"):GetComponent(UIMultiSprite)
  self.name = self:FindGO("name"):GetComponent(UILabel)
  self.des = self:FindGO("des"):GetComponent(UILabel)
  self.recomand = self:FindGO("recomand"):GetComponent(UILabel)
  self.tips = self:FindGO("tips"):GetComponent(UILabel)
  self.cellBg = self:FindGO("cellBg")
  self.choose = self:FindGO("choose")
end

function AttributePointSolutionCell:addViewEventListener()
  self:SetEvent(self.cellBg, function()
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
end

function AttributePointSolutionCell:SetData(data)
  local solutionData = Table_AddPointSolution[data]
  if solutionData then
    self.data = solutionData
    self.name.text = solutionData.Title
    self.des.text = solutionData.Dsc
    self.recomand.text = solutionData.RecomandSkill
    local bWarp0 = UIUtil.WrapLabel(self.recomand)
    if not bWarp0 then
      UIUtil.GetTextBeforeLastSpace(self.recomand, true)
    end
    self.tips.text = solutionData.tips
    local bWarp1 = UIUtil.WrapLabel(self.tips)
    if not bWarp1 then
      UIUtil.GetTextBeforeLastSpace(self.tips, true)
    end
    self.icon.CurrentState = solutionData.Icon or 0
    if self.indexInList == 1 then
      self:AddOrRemoveGuideId(self.cellBg, 471)
    end
  else
    errorLog("Cannot Find solutionData in Table_AddPointSolution. solution  Id is " .. tostring(data))
  end
end

function AttributePointSolutionCell:SetSelected(v)
  self.choose:SetActive(v == true)
end
