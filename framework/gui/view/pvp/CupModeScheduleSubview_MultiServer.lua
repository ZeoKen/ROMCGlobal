autoImport("CupModeScheduleSubview")
CupModeScheduleSubview_MultiServer = class("CupModeScheduleSubview_MultiServer", CupModeScheduleSubview)
local viewPath = ResourcePathHelper.UIView("CupModeScheduleSubview")
local viewName = "CupModeScheduleSubview_MultiServer"

function CupModeScheduleSubview_MultiServer:LoadSubviews()
  self.rootGO = self:FindGO("CupModeScheduleSubview_MultiServer", self.gameObject)
  local obj = self:LoadPreferb_ByFullPath(viewPath, self.rootGO, true)
  obj.name = viewName
end

function CupModeScheduleSubview_MultiServer:Init()
  self.proxy = CupMode6v6Proxy_MultiServer.Instance
  self:LoadSubviews()
  self:FindObjs()
  self:AddBtnEvts()
  self:AddViewEvts()
  self:InitShow()
end

function CupModeScheduleSubview_MultiServer:HandleQueryMember(note)
  local data = note.body
  local season = data and data.season
  if 10000 < season then
    xdlog("HandleQueryMember", self.proxy.proxyName)
    TipManager.Instance:ShowTeamMemberTip({
      memberData = self.proxy.memberinfoData,
      teamName = self.proxy.memberinfoTeamName
    })
  end
end
