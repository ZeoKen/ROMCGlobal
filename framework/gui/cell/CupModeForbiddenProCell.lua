CupModeForbiddenProCell = class("CupModeForbiddenProCell", CoreView)

function CupModeForbiddenProCell:ctor(obj)
  CupModeForbiddenProCell.super.ctor(self, obj)
  self:FindObjs()
end

function CupModeForbiddenProCell:FindObjs()
  self.icon = self.gameObject:GetComponent(UISprite)
end

function CupModeForbiddenProCell:SetData(data)
  self.data = data
  local icon = Table_Class[data] and Table_Class[data].icon or ""
  IconManager:SetProfessionIcon(icon, self.icon)
end
