autoImport("WarbandOpponentView")
WarbandOpponentView_MultiServer = class("WarbandOpponentView_MultiServer", WarbandOpponentView)
local GRAY_LABEL_COLOR = Color(0.5764705882352941, 0.5686274509803921, 0.5686274509803921, 1)
local BTN_SP = {
  "com_btn_3s",
  "com_btn_13s"
}
local PVP_LINE_TEXTURE_NAME = "pvp_bg_01"
local view_Path = ResourcePathHelper.UIView("WarbandOpponentView")
local warbandProxy

function WarbandOpponentView_MultiServer:Init()
  self:_loadSelf()
  warbandProxy = WarbandProxy_MultiServer.Instance
  self:InitUI()
  self:AddUIEvt()
  self:AddEvts()
end

function WarbandOpponentView_MultiServer:_loadSelf()
  self.objRoot = self:FindGO("WarbandOpponentView_MultiServer")
  local obj = self:LoadPreferb_ByFullPath(view_Path, self.objRoot, true)
  obj.name = "OpponentSubView_MultiServer"
end
