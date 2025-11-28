autoImport("BaseCombineCell")
HomeScoreCombineCell = class("HomeScoreCombineCell", BaseCombineCell)
autoImport("HomeScoreCell")

function HomeScoreCombineCell:Init()
  self.isActive = true
  self.isTag = true
  self:FindObjs()
  self:AddEvents()
end

function HomeScoreCombineCell:FindObjs()
  self.objTag = self:FindGO("Tag")
  self.labTagTitle = self:FindComponent("labTagTitle", UILabel, self.objTag)
  self.objBtnSwitchFold = self:FindGO("BtnFoldTag", self.objTag)
  self.sprBtnSwitchFold = self.objBtnSwitchFold:GetComponent(UISprite)
  self.labTotalScore = self:FindComponent("labTotalScore", UILabel, self.objTag)
  self.labInvalidScore = self:FindComponent("labInvalidScore", UILabel, self.objTag)
  self.objCellsRoot = self:FindGO("gridScores")
  self:InitCells(2, "HomeScoreCell", HomeScoreCell, self.objCellsRoot)
end

function HomeScoreCombineCell:AddEvents()
  self:AddClickEvent(self.objBtnSwitchFold, function()
    self:OnClickBtnSwitchFold()
  end)
  HomeScoreCombineCell.super.AddEventListener(self, MouseEvent.MouseClick, self.OnClickScoreCell, self)
end

function HomeScoreCombineCell:AddEventListener(eventType, handler, handlerOwner)
  HomeScoreCombineCell.super.super.AddEventListener(self, eventType, handler, handlerOwner)
  HomeScoreCombineCell.super.AddEventListener(self, eventType, handler, handlerOwner)
end

function HomeScoreCombineCell:SetData(data)
  local haveData = data ~= nil
  self.data = data
  if self.isActive ~= haveData then
    self.gameObject:SetActive(haveData)
    self.isActive = haveData
  end
  if not haveData then
    return
  end
  if self.isTag ~= data.isTag then
    self.isTag = data.isTag
    self.objCellsRoot:SetActive(not data.isTag)
    self.objTag:SetActive(data.isTag == true)
  end
  if data.isTag then
    self.id = data.id
    self.sprBtnSwitchFold.spriteName = data.isTagOpen and "com_btn_cuts" or "com_btn_add"
    self.sprBtnSwitchFold:MakePixelPerfect()
    self.labTagTitle.text = data.name
    self.labTotalScore.text = data.totalScore or 0
    self.labInvalidScore.text = data.invalidScore or 0
  else
    HomeScoreCombineCell.super.SetData(self, data)
  end
end

function HomeScoreCombineCell:OnClickBtnSwitchFold(btn)
  if self.isTag then
    self:PassEvent(WrapTagListCtrl.ClickFoldTag, self.data)
  end
end

function HomeScoreCombineCell:OnClickScoreCell(cell)
  self:PassEvent(MouseEvent.MouseClick, cell)
end
