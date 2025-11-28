local baseCell = autoImport("BaseCell")
EquipPreviewMenuCell = class("EquipPreviewMenuCell", baseCell)
local _zhStr = {
  ZhString.RoleSuitEquipPreview_Save,
  ZhString.RoleSuitEquipPreview_Apply
}
local _uiconfig = {
  cur = {
    btn = "bag_btn_02",
    indexOutlineColor = Color(0.6509803921568628, 0.45098039215686275, 0.3607843137254902, 1)
  },
  toChoose = {
    btn = "bag_btn_01",
    indexOutlineColor = Color(0.4117647058823529, 0.4627450980392157, 0.6666666666666666, 1)
  }
}

function EquipPreviewMenuCell:Init()
  EquipPreviewMenuCell.super.Init(self)
  self:FindObj()
  self:AddEvts()
end

function EquipPreviewMenuCell:FindObj()
  self.bg = self:FindComponent("Bg", UISprite)
  self.indexLab = self:FindComponent("IndexLab", UILabel)
  self.descLab = self:FindComponent("DescLab", UILabel)
  self:Hide(self.descLab)
end

function EquipPreviewMenuCell:AddEvts()
  self:AddClickEvent(self.bg.gameObject, function(go)
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
  self:AddClickEvent(self.descLab.gameObject, function(go)
    self:PassEvent(RoleEquipEvent.UsePreviewSuitBag, self)
  end)
end

function EquipPreviewMenuCell:SetData(data)
  self.data = data
  if data then
    self.indexLab.text = tostring(data)
  end
end
