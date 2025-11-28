autoImport("EquipUpgradeView")
EquipUpgradeSubView = class("EquipUpgradeSubView", EquipUpgradeView)
EquipUpgradeSubView.ViewType = UIViewType.NormalLayer
autoImport("EquipIntegrateView")
EquipUpgradeSubView.BrotherView = EquipIntegrateView

function EquipUpgradeSubView:FindObjs()
  EquipUpgradeSubView.super.FindObjs(self)
  self.gameObject.transform.localPosition = LuaGeometry.GetTempVector3(0, 0, 0)
end
