autoImport("ItemNewCell")
DecomposeItemNewCell = class("DecomposeItemNewCell", ItemNewCell)

function DecomposeItemNewCell:Init()
  DecomposeItemNewCell.super.Init(self)
  self:AddCellClickEvent()
end

function DecomposeItemNewCell:SetData(data)
  DecomposeItemNewCell.super.SetData(self, data)
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
