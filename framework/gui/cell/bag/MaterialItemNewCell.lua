autoImport("BaseItemNewCell")
autoImport("MaterialItemCell")
MaterialItemNewCell = class("MaterialItemNewCell", BaseItemNewCell)
MaterialItemNewCell.TextColor_Red = "[c][FF6021]%s[-][/c]/%s"
local zenyId

function MaterialItemNewCell:Init()
  if not zenyId then
    zenyId = GameConfig.MoneyId.Zeny
  end
  MaterialItemCell.Init(self)
end

function MaterialItemNewCell:SetData(data)
  if data == "Add" then
    self.data = data
    self.item:SetActive(false)
    if self.empty then
      self.empty:SetActive(true)
    end
  else
    MaterialItemCell.SetData(self, data)
    if data.neednum and data.staticData.id == zenyId then
      self:UpdateNumLabel(string.format(data.num >= data.neednum and "%s" or "[c][FF6021]%s[-][/c]", data.neednum))
    end
  end
end

function MaterialItemNewCell:ActiveClickTip(b)
  MaterialItemCell.ActiveClickTip(self, b)
end

function MaterialItemNewCell:SetDisCountTip(b, pct)
  MaterialItemCell.SetDisCountTip(self, b, pct)
end

function MaterialItemNewCell:GetCellPartPrefix()
end
