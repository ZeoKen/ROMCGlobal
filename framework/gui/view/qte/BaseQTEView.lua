autoImport("BaseScreenQTEPointCell")
autoImport("BaseScreenQTELineCell")
autoImport("BaseScreenQTECurveCell")
autoImport("BaseScreenQTEPeriodClickCell")
autoImport("QTEPeriodCustomAction")
BaseQTEView = class("BaseQTEView", ContainerView)
BaseQTEView.ViewType = UIViewType.NormalLayer

function BaseQTEView:Init()
  self:FindObjs()
end

function BaseQTEView:FindObjs()
  self.qteHolder = self:FindGO("QteHolder")
  self.fxHolder = self:FindGO("FxHolder")
end

function BaseQTEView:AddListenEvent()
end

function BaseQTEView:OnEnter()
  self.gameControl = self.viewdata.viewdata
  self.gameControl:SetView(self)
  self:SetThemeCfg(self.gameControl.defaultThemeCfg)
  UIManagerProxy.Instance:NeedEnableAndroidKey(false)
end

function BaseQTEView:OnExit()
  FunctionQTE.Me():EndQTE(self.gameControl)
  UIManagerProxy.Instance:NeedEnableAndroidKey(true, UIManagerProxy.GetDefaultNeedEnableAndroidKeyCallback())
end

function BaseQTEView:SetThemeCfg(themeCfg)
  self.themeCfg = themeCfg
end

function BaseQTEView:AddPointClick(cfg)
  local themeCfg = cfg.theme_cfg and self.gameControl:GetThemeCfg(cfg.theme_cfg) or self.themeCfg
  local qteCell = BaseScreenQTEPointCell.new(cfg, themeCfg, self.qteHolder, self.fxHolder, function(result, params)
    self:QTEResultCallBack(result, params)
  end, self.gameControl)
  qteCell:Start()
  return qteCell
end

function BaseQTEView:AddPointHit(cfg)
  return nil
end

function BaseQTEView:AddLineRoute(cfg)
  local themeCfg = cfg.theme_cfg and self.gameControl:GetThemeCfg(cfg.theme_cfg) or self.themeCfg
  local qteCell = BaseScreenQTELineCell.new(cfg, themeCfg, self.qteHolder, self.fxHolder, function(result, params)
    self:QTEResultCallBack(result, params)
  end, self.gameControl)
  qteCell:Start()
  return qteCell
end

function BaseQTEView:AddCurveRoute(cfg)
  local themeCfg = cfg.theme_cfg and self.gameControl:GetThemeCfg(cfg.theme_cfg) or self.themeCfg
  local qteCell = BaseScreenQTECurveCell.new(cfg, themeCfg, self.qteHolder, self.fxHolder, function(result, params)
    self:QTEResultCallBack(result, params)
  end, self.gameControl)
  qteCell:Start()
  return qteCell
end

function BaseQTEView:AddPeriodClick(cfg)
  local themeCfg = cfg.theme_cfg and self.gameControl:GetThemeCfg(cfg.theme_cfg) or self.themeCfg
  local qteCell = BaseScreenQTEPeriodClickCell.new(cfg, themeCfg, self.qteHolder, self.fxHolder, function(result, params)
    self:QTEResultCallBack(result, params)
  end, self.gameControl)
  qteCell:Start()
  return qteCell
end

function BaseQTEView:AddPeriodCustomAction(cfg)
  local periodAction = QTEPeriodCustomAction.new(cfg, nil, self.gameControl)
  periodAction:Start()
  return periodAction
end

function BaseQTEView:CloseSelf()
  BaseQTEView.super.CloseSelf(self)
end

function BaseQTEView:QTEResultCallBack(result, params)
end
