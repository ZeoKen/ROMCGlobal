GVGRoadBlockEditorCell = class("GVGRoadBlockEditorCell", BaseCell)
local BlockName = {
  [1] = ZhString.GVGRoadBlock_BlockA,
  [2] = ZhString.GVGRoadBlock_BlockB,
  [3] = ZhString.GVGRoadBlock_BlockC
}

function GVGRoadBlockEditorCell:Init()
  self:FindObjs()
end

function GVGRoadBlockEditorCell:FindObjs()
  self.nameLabel = self:FindComponent("name", UILabel)
  self.areaLabel = self:FindComponent("pos", UILabel)
  self.leftArrow = self:FindGO("leftArrow")
  self.rightArrow = self:FindGO("rightArrow")
  self:AddClickEvent(self.leftArrow, function()
    self:OnLeftBtnClick()
  end)
  self:AddClickEvent(self.rightArrow, function()
    self:OnRightBtnClick()
  end)
  self.leftArrowSp = self.leftArrow:GetComponent(UISprite)
  self.rightArrowSp = self.rightArrow:GetComponent(UISprite)
end

function GVGRoadBlockEditorCell:SetData(data)
  self.data = data
  self.index = data.index
  self.nameLabel.text = BlockName[data.index]
  self:SetBlockArea(data.state)
end

function GVGRoadBlockEditorCell:SetBlockArea(state)
  local str = ""
  local leftAlpha = 1
  local rightAlpha = 1
  if state == 0 then
    str = ZhString.SetViewSecurityPage_UnSet
    leftAlpha = 0.3
  elseif state == 1 then
    str = ZhString.HomeBuilding_Left
  elseif state == 2 then
    if self.index == 2 then
      str = ZhString.GVGRoadBlock_Middle
    else
      str = ZhString.HomeBuilding_Right
      rightAlpha = 0.3
    end
  elseif state == 3 then
    str = ZhString.HomeBuilding_Right
    rightAlpha = 0.3
  end
  self.state = state
  self.areaLabel.text = str
  self.leftArrowSp.alpha = leftAlpha
  self.rightArrowSp.alpha = rightAlpha
  self:PassEvent(MouseEvent.MouseClick, self)
end

function GVGRoadBlockEditorCell:OnLeftBtnClick()
  if self.state > 0 then
    self.state = self.state - 1
    self:SetBlockArea(self.state)
  end
end

function GVGRoadBlockEditorCell:OnRightBtnClick()
  if self.state < 3 then
    if self.state ~= 2 or self.index == 2 then
      self.state = self.state + 1
    end
    self:SetBlockArea(self.state)
  end
end
