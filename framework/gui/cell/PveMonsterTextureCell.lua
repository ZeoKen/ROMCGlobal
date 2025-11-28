local baseCell = autoImport("BaseCell")
PveMonsterTextureCell = class("PveMonsterTextureCell", baseCell)

function PveMonsterTextureCell:ctor(obj)
  PveMonsterTextureCell.super.ctor(self, obj)
  self.texture = self.gameObject:GetComponent(UITexture)
end

function PveMonsterTextureCell:SetData(id, tex)
  self.data = id
  if not StringUtil.IsEmpty(tex) and self.tex ~= tex then
    self.tex = tex
    UIModelUtil.Instance:ChangeBGMeshRenderer(tex, self.texture)
  end
  UIModelUtil.Instance:SetMonsterModelTexture(self.texture, id, UIModelCameraTrans.Pve, false, function(obj)
    self.model = obj
    self.model:RegisterWeakObserver(self)
  end, true, true)
end

function PveMonsterTextureCell:ObserverDestroyed(obj)
  if obj == self.model then
    self.model = nil
  end
end

function PveMonsterTextureCell:OnCellDestroy()
  UIModelUtil.Instance:ClearModel(self.texture)
end

function PveMonsterTextureCell:RotateModel(delta)
  if self.model then
    self.model:RotateDelta(-delta.x)
  end
end
