MainViewDungeonInfoSubPage = class("MainViewDungeonInfoSubPage", SubMediatorView)

function MainViewDungeonInfoSubPage:ReLoadPerferb(path, keepDepth, localPos, parentTrans)
  MainViewDungeonInfoSubPage.super.ReLoadPerferb(self, path, keepDepth)
  self.mainViewTrans = self.gameObject.transform.parent
  self.traceInfoParent = Game.GameObjectUtil:DeepFindChild(self.mainViewTrans.gameObject, "TraceInfoBord")
  self.trans:SetParent(parentTrans or self.traceInfoParent.transform)
  self.trans.localPosition = localPos or LuaGeometry.Const_V3_zero
end
