autoImport("QTEGameControl")
FunctionQTE = class("FunctionQTE")

function FunctionQTE.Me()
  if nil == FunctionQTE.me then
    FunctionQTE.me = FunctionQTE.new()
  end
  return FunctionQTE.me
end

function FunctionQTE:ctor()
end

function FunctionQTE:GetGameControl()
  return self.activeGameControl
end

function FunctionQTE:StartQTE(plotId, panelConfig, autoEnd, defaultThemeCfg, resultCb, endCb)
  if self.activeGameControl then
    self.activeGameControl:Terminate()
    self.activeGameControl = nil
  end
  self.activeGameControl = QTEGameControl.new(ServerTime.CurServerTime(), plotId, panelConfig, defaultThemeCfg, autoEnd, resultCb, endCb, self.qteOrderInfo)
end

function FunctionQTE:AddStep(cfg, resultCb)
  if self.activeGameControl and self.activeGameControl.inited then
    self.activeGameControl:AddStep(cfg, resultCb)
  end
end

function FunctionQTE:AddQTEPeriodClick(cfg, resultCb)
  if self.activeGameControl and self.activeGameControl.inited then
    cfg.type = "period_click"
    self.activeGameControl:AddStep(cfg, resultCb)
  end
end

function FunctionQTE:RemoveQTEPeriodClick(cfg)
  if self.activeGameControl and self.activeGameControl.inited then
    self.activeGameControl:RemoveStepById(cfg and cfg.id)
  end
end

function FunctionQTE:AddQTEPeriodCustomAction(cfg, resultCb)
  if self.activeGameControl and self.activeGameControl.inited then
    cfg.type = "custom_action"
    self.activeGameControl:AddStep(cfg, resultCb)
  end
end

function FunctionQTE:RemoveQTEPeriodCustomAction(cfg)
  self:RemoveQTEPeriodClick(cfg)
end

function FunctionQTE:EndQTE(gameControl)
  if gameControl and self.activeGameControl == gameControl then
    self.activeGameControl:Terminate()
    self.activeGameControl = nil
  end
end

function FunctionQTE:ResetQteOrderInfo()
  if self.qteOrderInfo then
    self.qteOrderInfo = nil
  end
end

function FunctionQTE:AddQteOrderInfo(params)
  if not self.qteOrderInfo then
    self.qteOrderInfo = {}
  end
  self.qteOrderInfo[params.order_id] = params.callback_params
end
