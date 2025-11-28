autoImport("CupModeForbiddenProCell")
CupModeForbiddenPro = class("CupModeForbiddenPro", CoreView)

function CupModeForbiddenPro:ctor(obj)
  CupModeForbiddenPro.super.ctor(self, obj)
  self:FindObjs()
end

function CupModeForbiddenPro:FindObjs()
  self.grid = self:FindGO("Grid"):GetComponent(UIGrid)
  self.listCtl = UIGridListCtrl.new(self.grid, CupModeForbiddenProCell, "CupModeForbiddenProCell")
end

function CupModeForbiddenPro:SetData(data)
  self.data = data
  if data and 0 < #data then
    self.gameObject:SetActive(true)
    self.listCtl:ResetDatas(data)
  else
    self.gameObject:SetActive(false)
  end
end

function CupModeForbiddenPro:OnCellDestroy()
  self.listCtl:Destroy()
end
