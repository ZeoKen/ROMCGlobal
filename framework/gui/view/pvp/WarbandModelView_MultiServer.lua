autoImport("WarbandModelView")
WarbandModelView_MultiServer = class("WarbandModelView_MultiServer", WarbandModelView)
local view_Path = ResourcePathHelper.UIView("WarbandModelView")
local warbandProxy
autoImport("WarbandRankSubView_MultiServer")
autoImport("WarbandOpponentView_MultiServer")

function WarbandModelView_MultiServer:_loadSelf()
  self.root = self:FindGO("WarbandModelView_MultiServer")
  local obj = self:LoadPreferb_ByFullPath(view_Path, self.root, true)
  obj.name = "WarbandModelView_MultiServer"
  self.rankRoot = self:FindGO("WarbandRankSubView", self.root)
  self.rankRoot.name = "WarbandRankSubView_MultiServer"
  self.gameRoot = self:FindGO("WarbandOpponentView", self.root)
  self.gameRoot.name = "WarbandOpponentView_MultiServer"
  self.rankSubView = self:AddSubView("WarbandRankSubView_MultiServer", WarbandRankSubView_MultiServer)
  self.signupOpponentSubView = self:AddSubView("WarbandOpponentView_MultiServer", WarbandOpponentView_MultiServer)
end

function WarbandModelView_MultiServer:Init()
  warbandProxy = WarbandProxy_MultiServer.Instance
  self:FindObjs()
end
