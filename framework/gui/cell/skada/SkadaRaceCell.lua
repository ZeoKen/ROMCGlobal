SkadaRaceCell = class("SkadaRaceCell", BaseCell)
local selectedSp = LuaColor(0.8431372549019608, 0.9372549019607843, 0.996078431372549, 1)
local selectedLabel = LuaColor(0 / 255, 0.4549019607843137, 0.7372549019607844, 1)

function SkadaRaceCell:Init()
  self:FindObjs()
  self:AddCellClickEvent()
end

function SkadaRaceCell:FindObjs()
  self.labName = self:FindComponent("name", UILabel)
  self.sprBG = self:FindComponent("bg", UISprite)
end

function SkadaRaceCell:SetData(data)
  self.data = data
  self.id = data.id
  self.labName.text = data.NameZh
end

function SkadaRaceCell:SetIsSelect(isSelect)
  if self.isSelected == isSelect then
    return
  end
  if isSelect then
    self.labName.color = selectedLabel
    self.sprBG.color = selectedSp
  else
    self.labName.color = LuaGeometry.GetTempColor(0, 0, 0, 1)
    self.sprBG.color = LuaGeometry.GetTempColor(1, 1, 1, 1)
  end
  self.isSelected = isSelect
end
