local BaseCell = autoImport("BaseCell")
TeamGoalCell = class("TeamGoalCell", BaseCell)
TeamGoalCell.ChooseColor = LuaColor.New(0.12156862745098039, 0.4549019607843137, 0.7490196078431373)
TeamGoalCell.NormalColor = LuaColor.New(0.2196078431372549, 0.2196078431372549, 0.2196078431372549)

function TeamGoalCell:Init()
  self.label = self:FindComponent("Label", UILabel)
  self.Img = self:FindComponent("Img", UISprite)
  self:AddCellClickEvent()
  self.choose = false
end

function TeamGoalCell:SetData(data)
  self.data = data
  self.label.text = data.NameZh
end

function TeamGoalCell:IsChoose()
  return self.choose
end

function TeamGoalCell:SetChoose(choose)
  self.choose = choose
  self.label.color = self.choose and TeamGoalCell.ChooseColor or TeamGoalCell.NormalColor
  self.Img.color = self.choose and TeamGoalCell.ChooseColor or TeamGoalCell.NormalColor
end
