autoImport("CustomModeView")
MultiPvpCustomModeView = class("MultiPvpCustomModeView", CustomModeView)

function MultiPvpCustomModeView:LoadSubView()
  local viewPath = ResourcePathHelper.UIView("CustomModeView")
  self.objRoot = self:FindGO("MultiPvpCustomModeView")
  local obj = self:LoadPreferb_ByFullPath(viewPath, self.objRoot, true)
  obj.name = "MultiPvpCustomModeView"
  self.gameObject = obj
end

function MultiPvpCustomModeView:Init()
  self.pvpType = PvpProxy.Type.TwelvePVPRelax
  self:LoadSubView()
  self:FindObjs()
  MultiPvpCustomModeView.super.AddViewEvts(self)
  MultiPvpCustomModeView.super.UpdateView(self)
end

function MultiPvpCustomModeView:FindObjs()
  self.titleLabel = self:FindGO("Title"):GetComponent(UILabel)
  self.titleLabel.text = ZhString.TwelvePVPCustom_TitleName
  MultiPvpCustomModeView.super.FindObjs(self)
end

function MultiPvpCustomModeView:ClickButtonMatch()
  local pvpcheckvalid = PvpProxy.Instance:CheckMatchValid()
  local valid = TeamProxy.Instance:CheckMatchValid(Table_MatchRaid[self.pwsConfig.matchid]) and pvpcheckvalid
  if valid then
    if TeamProxy.Instance:IHaveTeam() then
      local memberlst = TeamProxy.Instance.myTeam:GetPlayerMemberList(true, true)
      if #memberlst < GameConfig.Team.maxmember then
        MsgManager.ConfirmMsgByID(25904, function()
          self:CallMatch()
        end, nil)
        return
      end
    end
    self:CallMatch()
  end
end
