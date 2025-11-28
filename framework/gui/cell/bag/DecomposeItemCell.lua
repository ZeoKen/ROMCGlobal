autoImport("ItemCell")
DecomposeItemCell = class("DecomposeItemCell", ItemCell)

function DecomposeItemCell:Init()
  DecomposeItemCell.super.Init(self)
  self:AddCellClickEvent()
end

function DecomposeItemCell:SetData(data)
  DecomposeItemCell.super.SetData(self, data)
  if data then
    if not self.numLab then
      self.numLab = self:FindComponent("NumLabel", UILabel)
    end
    if not data.minrate and not data.maxrate then
      self.numLab.text = data.num
    else
      local minrate, maxrate = data.minrate or 0, data.maxrate or 0
      self.numLab.text = minrate .. "~" .. maxrate
    end
  end
end
