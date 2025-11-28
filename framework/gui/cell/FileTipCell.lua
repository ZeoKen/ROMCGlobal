local BaseCell = autoImport("BaseCell")
FileTipCell = class("FileTipCell", BaseCell)
local calSize = NGUIMath.CalculateRelativeWidgetBounds

function FileTipCell:Init()
  FileTipCell.super.Init(self)
  self:FindObjs()
end

function FileTipCell:FindObjs()
  self.label = self:FindGO("Label"):GetComponent(UILabel)
  self.noneTip = self:FindGO("None")
  self.bg = self:FindGO("Bg"):GetComponent(UISprite)
  self.lockSymbol = self:FindGO("Lock")
  self:AddClickEvent(self.bg.gameObject, function()
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
end

function FileTipCell:SetData(data)
  self.data = data
  self.id = data.secret_id
  self.lighted = data.lighted
  local staticData = Table_CharacterSecret[self.id]
  self.noneTip:SetActive(false)
  if not self.lighted then
    self.label.text = ""
    self.lockSymbol:SetActive(true)
  else
    self.label.text = staticData.Description
    self.lockSymbol:SetActive(false)
  end
  local size = calSize(self.label.transform)
  local height = size.size.y
  self.bg.height = height + 30
end
