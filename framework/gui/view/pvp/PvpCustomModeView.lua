autoImport("CustomModeView")
PvpCustomModeView = class("PvpCustomModeView", CustomModeView)

function PvpCustomModeView:LoadSubView()
  local viewPath = ResourcePathHelper.UIView("CustomModeView")
  self.objRoot = self:FindGO("PvpCustomModeView")
  local obj = self:LoadPreferb_ByFullPath(viewPath, self.objRoot, true)
  obj.name = "PvpCustomModeView"
  self.gameObject = obj
end

function PvpCustomModeView:Init()
  self.pvpType = PvpProxy.Type.FreeBattle
  self:LoadSubView()
  self:FindObjs()
  PvpCustomModeView.super.AddViewEvts(self)
  PvpCustomModeView.super.UpdateView(self)
end

function PvpCustomModeView:FindObjs()
  self.titleLabel = self:FindGO("Title"):GetComponent(UILabel)
  self.titleLabel.text = ZhString.TwelvePVP6V6Custom_TitleName
  PvpCustomModeView.super.FindObjs(self)
end

function CustomModeView:ClickButtonMatch()
  if not self.selectCell or self.disableClick then
    return
  end
  local pvpcheckvalid = PvpProxy.Instance:CheckPwsMatchValid(true, self.selectCell.id)
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
