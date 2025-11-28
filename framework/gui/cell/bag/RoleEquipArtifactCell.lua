autoImport("BaseItemCell")
RoleEquipArtifactCell = class("RoleEquipArtifactCell", BaseItemCell)

function RoleEquipArtifactCell:ctor(go, index)
  self.index = index
  RoleEquipArtifactCell.super.ctor(self, go)
end

function RoleEquipArtifactCell:Init()
  local hideBtnGO = self:FindGO("ShowHideEquipBtn")
  self.checkIcon = self:FindComponent("Check", UISprite, hideBtnGO)
  self.arrowIcon = self:FindComponent("Symbol", UISprite, hideBtnGO)
  if self.index and self.index <= 6 then
    self.checkIcon.gameObject.transform.localEulerAngles = LuaGeometry.GetTempVector3(0, 0, -180)
  end
end

function RoleEquipArtifactCell:SetEmpty(b)
  self.checkIcon.alpha = b and 0 or 1
  self.arrowIcon.alpha = b and 1 or 0
end
