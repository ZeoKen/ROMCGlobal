autoImport("BaseItemNewCell")
autoImport("MaterialItemCell")
MaterialItemNewCell1 = class("MaterialItemNewCell1", BaseItemNewCell)
MaterialItemNewCell1.TextColor_Red = "[c][FF6021]%s[-][/c]/%s"
MaterialItemNewCell1.Event = {
  Delete = "MaterialItemNewCell1.Event.Delete"
}
local zenyId

function MaterialItemNewCell1:Init()
  if not zenyId then
    zenyId = GameConfig.MoneyId.Zeny
  end
  self.deleteIcon = self:FindGO("deleteIcon")
  self:AddClickEvent(self.deleteIcon, function()
    self:PassEvent(MaterialItemNewCell1.Event.Delete, self)
  end)
  MaterialItemCell.Init(self)
end

function MaterialItemNewCell1:SetAttriPivot_BottomLeft()
  if not self.attrGrid then
    self.needSetAttriPivot = true
    return
  end
  self.needSetAttriPivot = false
  self.attrGrid.pivot = 8
  self.attrGrid.transform.localPosition = LuaGeometry.GetTempVector3(-37, -27)
  self.refinelv.pivot = 3
end

function MaterialItemNewCell1:ActiveDeleteIcon(b)
  self.deleteIcon:SetActive(b)
end

function MaterialItemNewCell1:SetData(data)
  self.data = data
  if type(data) == "table" then
    MaterialItemCell.SetData(self, data)
    if data.neednum and data.staticData.id == zenyId then
      self:UpdateNumLabel(string.format(data.num >= data.neednum and "%s" or "[c][FF6021]%s[-][/c]", data.neednum))
    end
    self:ActiveDeleteIcon(data.showDelete == true)
  else
    self.item:SetActive(false)
    if self.empty then
      self.empty:SetActive(true)
    end
    self:ActiveDeleteIcon(false)
    self:SetDisCountTip(false)
  end
  if self.needSetAttriPivot then
    self:SetAttriPivot_BottomLeft()
  end
end

function MaterialItemNewCell1:ActiveClickTip(b)
  MaterialItemCell.ActiveClickTip(self, false)
end

function MaterialItemNewCell1:SetDisCountTip(b, pct)
  MaterialItemCell.SetDisCountTip(self, b, pct)
end

function MaterialItemNewCell1:GetCellPartPrefix(key)
  return "ItemNewCell_"
end
