autoImport("ScreenQTEPrototypeCell")
autoImport("BaseScreenQTECompPoint")
BaseScreenQTEPointCell = class("BaseScreenQTEPointCell", ScreenQTEPrototypeCell)

function BaseScreenQTEPointCell:ctor(cfg, themeCfg, holderObj, fxHolderObj, callback, gameCtrl)
  self.cfg = cfg
  self.themeCfg = themeCfg
  self.point = BaseScreenQTECompPoint.new(themeCfg.point_cell, holderObj)
  local x, y = (cfg.pos_cvt_func or self.CvtCfgScreenPos)(cfg.pos[1], cfg.pos[2])
  self.point:SetPos(x, y)
  self.point:SetWithCfg(themeCfg)
  self.point:SetMarkSp(themeCfg.point_mark_sp, 0)
  self.fxHolderObj = fxHolderObj
  self.callback = callback
  self.gameCtrl = gameCtrl
end

function BaseScreenQTEPointCell:Start()
  if self.cfg.delay and self.cfg.delay > 0 then
    self:ToState("Delay")
  else
    self:ToState("Point")
  end
end

function BaseScreenQTEPointCell:E_Delay()
  self:ResetTimer(self.cfg.delay and self.cfg.delay > 0)
  self.point:ShowTimeOut(false)
end

function BaseScreenQTEPointCell:L_Delay()
end

function BaseScreenQTEPointCell:P_Delay(time, deltaTime)
  self:RefreshTimer(deltaTime)
  if self.timer > self.cfg.delay then
    return self:ToState("Point")
  end
end

function BaseScreenQTEPointCell:E_Point()
  self:ResetTimer(not self.cfg.delay or not (self.cfg.delay > 0))
  self.point:ShowTimeOut(not self.cfg.hide_point_circle)
  self.point:SetTimeOut(0)
  self.sx, self.sy = self.point:GetPos()
end

function BaseScreenQTEPointCell:L_Point()
  self.point:ShowTimeOut(false)
end

function BaseScreenQTEPointCell:P_Point(time, deltaTime)
  self:RefreshTimer(deltaTime)
  local pct = self.timer / self.cfg.click_timeout
  local ix, iy, input_id = self:GetNearestInput(self.sx, self.sy, 1)
  if self:CheckPointClickCanAccept(ix, iy) then
    self:LockInput(input_id)
    local isOK = self:CheckPointClickPct(pct)
    self:PlaySE(self.themeCfg.click_se)
    return self:ToEnd(isOK)
  end
  if pct <= 1 then
    self.point:SetTimeOut(pct)
  else
    return self:ToEnd(false)
  end
end

function BaseScreenQTEPointCell:ToEnd(isSuccess)
  self:ToState("End")
  self.success = isSuccess
  if isSuccess ~= nil then
    self:ShowResult(isSuccess)
  end
  self:DeConstruct()
end

function BaseScreenQTEPointCell:ShowResult(success)
  local fxName = success and self.themeCfg.success_fx or self.themeCfg.fail_fx
  local x, y = self.point:GetPos()
  self:PlayFx(fxName, true, x, y, nil, nil, function()
    self:ToState("Exit")
  end)
  local seName = success and self.themeCfg.success_se or self.themeCfg.fail_se
  self:PlaySE(seName)
  self.super.ShowResult(self, success)
end

function BaseScreenQTEPointCell:DeConstruct()
  self.point:Destroy()
end
