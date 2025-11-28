local BaseCell = autoImport("BaseCell")
TeamGoalGroupCell = class("TeamGoalGroupCell", BaseCell)

function TeamGoalGroupCell:Init()
  self.tweenScale = self:FindComponent("ChildContainer", TweenScale)
  local goal = self:FindGO("goal")
  self.goalSprite = self:FindComponent("goal", UIMultiSprite)
  self.goalLabel = self:FindComponent("Label", UILabel)
  self.nextSymbol = self:FindGO("nextSymbol")
  self:AddCellClickEvent()
end

function TeamGoalGroupCell:ClickFather(cellCtl)
  if self.isAvailable == false then
    return
  end
  cellCtl = cellCtl or self.fatherCell
  self:SetChoose(true)
end

function TeamGoalGroupCell:SetData(data)
  self.data = data
  if self.data then
    self.groupid = self.data.groupid or 0
    if self.nextSymbol then
      self.nextSymbol:SetActive(self.groupid ~= 0)
    end
    self.goalLabel.text = data.NameZh or ""
  end
end

local chooseEffectColor, notChooseEffectColor = Color(0.6235294117647059, 0.30980392156862746, 0.03529411764705882), Color(0.11372549019607843, 0.17647058823529413, 0.4627450980392157)

function TeamGoalGroupCell:SetChoose(choose)
  self.goalSprite.CurrentState = choose and 1 or 0
  self.goalLabel.effectColor = choose and chooseEffectColor or notChooseEffectColor
  if choose then
    self:PassEvent(MouseEvent.MouseClick, {
      type = "Group",
      groupid = self.data.groupid
    })
  end
end
