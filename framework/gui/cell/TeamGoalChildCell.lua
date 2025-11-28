local BaseCell = autoImport("BaseCell")
TeamGoalChildCell = class("TeamGoalChildCell", BaseCell)
TeamGoalChildCell.ChooseColor = LuaColor.New(0.12156862745098039, 0.4549019607843137, 0.7490196078431373)
TeamGoalChildCell.NormalColor = LuaColor.New(0.2196078431372549, 0.2196078431372549, 0.2196078431372549)
local IconStr = "{uiicon=new-com_icon_tips}"

function TeamGoalChildCell:Init()
  self.info = self:FindGO("info"):GetComponent(UIRichLabel)
  self.infoSL = SpriteLabel.new(self.info, nil, 30, 30, false)
  self:AddCellClickEvent()
  self.choose = false
end

function TeamGoalChildCell:SetData(data)
  self.data = data
  self.infoSL:SetText(IconStr .. OverSea.LangManager.Instance():GetLangByKey(data.NameZh), true)
  self.infoSL:SetLabelColor(self.choose and TeamGoalCell.ChooseColor or TeamGoalCell.NormalColor)
  self.infoSL:SetSpriteColor(0, self.choose and TeamGoalCell.ChooseColor or TeamGoalCell.NormalColor)
end

function TeamGoalChildCell:IsChoose()
  return self.choose
end

function TeamGoalChildCell:SetChoose(choose)
  self.choose = choose
  self.infoSL:SetLabelColor(self.choose and TeamGoalCell.ChooseColor or TeamGoalCell.NormalColor)
  self.infoSL:SetSpriteColor(0, self.choose and TeamGoalCell.ChooseColor or TeamGoalCell.NormalColor)
end
