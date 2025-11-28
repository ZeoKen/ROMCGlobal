local baseCell = autoImport("BaseCell")
QuestTypeTabCell = class("QuestTypeTabCell", baseCell)

function QuestTypeTabCell:Init()
  QuestTypeTabCell.super.Init(self)
  self:FindObjs()
  self:InitData()
end

function QuestTypeTabCell:FindObjs()
  self.chooseLabel = self:FindGO("ChooseLabel"):GetComponent(UILabel)
  self.commonLabel = self:FindGO("CommonLabel"):GetComponent(UILabel)
  self.newSymbol = self:FindGO("NewSymbol")
  self.newSymbol:SetActive(false)
  self.toggle = self.gameObject:GetComponent(UIToggle)
  self.tweenRoot = self:FindGO("TweenRoot")
  self.tween = self.tweenRoot:GetComponent(TweenScale)
  self:SetEvent(self.gameObject, function()
    self:PassEvent(QuestEvent.QuestTraceSwitchPage, self)
  end)
end

function QuestTypeTabCell:InitData()
end

function QuestTypeTabCell:SetData(data)
  self.data = data
  self.index = data.index
  self.chooseLabel.text = data.name
  self.commonLabel.text = data.name
end

function QuestTypeTabCell:SetNewSymbol(bool)
  self.newSymbol:SetActive(bool)
end

function QuestTypeTabCell:SetExtend(str)
  if str and str ~= "" then
    self.chooseLabel.text = self.data.name .. str
    self.commonLabel.text = self.data.name .. str
  end
  self.tween:ResetToBeginning()
  self.tween:PlayForward()
end
