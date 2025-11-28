autoImport("ScreenQTEPrototypeCell")
autoImport("BaseScreenQTECompPoint")
autoImport("BaseScreenQTECompLine")
BaseScreenQTELineCell = class("BaseScreenQTELineCell", ScreenQTEPrototypeCell)

function BaseScreenQTELineCell:ctor(cfg, themeCfg, holderObj, fxHolderObj, callback, gameCtrl)
  self.cfg = cfg
  self.themeCfg = themeCfg
  self.line = BaseScreenQTECompLine.new(themeCfg.line_cell, holderObj)
  local x, y = self.CvtCfgScreenPos(cfg.pos[1], cfg.pos[2])
  local z, w = self.CvtCfgScreenPos(cfg.pos[3], cfg.pos[4])
  self.line:SetLine(x, y, z, w, themeCfg)
  self.point = BaseScreenQTECompPoint.new(themeCfg.point_cell, holderObj)
  self.point:SetPos(x, y)
  self.point:SetWithCfg(themeCfg)
  self.point:SetMarkSp(themeCfg.line_mark_sp, self.line:GetLineDir() + 180)
  self.fxHolderObj = fxHolderObj
  self.callback = callback
  self.gameCtrl = gameCtrl
end

function BaseScreenQTELineCell:Start()
  if self.cfg.delay and self.cfg.delay > 0 then
    self:ToState("Delay")
  else
    self:ToState("Point")
  end
end

function BaseScreenQTELineCell:E_Delay()
  self:ResetTimer(self.cfg.delay and self.cfg.delay > 0)
  self.point:ShowTimeOut(false)
end

function BaseScreenQTELineCell:L_Delay()
end

function BaseScreenQTELineCell:P_Delay(time, deltaTime)
  self:RefreshTimer(deltaTime)
  if self.timer > self.cfg.delay then
    return self:ToState("Point")
  end
end

function BaseScreenQTELineCell:E_Point()
  self:ResetTimer(not self.cfg.delay or not (self.cfg.delay > 0))
  self.point:ShowTimeOut(not self.cfg.hide_point_circle)
  self.point:SetTimeOut(0)
  self.sx, self.sy = self.point:GetPos()
  self.pointClickVerified = nil
end

function BaseScreenQTELineCell:L_Point()
  self.pointClickVerified = nil
  self.point:ShowTimeOut(false)
end

function BaseScreenQTELineCell:P_Point(time, deltaTime)
  self:RefreshTimer(deltaTime)
  local pct = self.timer / self.cfg.click_timeout
  if self.pointClickVerified then
    local ix, iy, input_id = self:GetNearestInput(self.sx, self.sy, 2)
    local is_hold_inRange = input_id and self:CheckHold() and self:CheckInputPosInRange(self.sx, self.sy, ix, iy, self.themeCfg.click_pos_accept_offset)
    if not is_hold_inRange then
      return self:ToEnd(false)
    else
      self:LockInput(input_id)
    end
  else
    local ix, iy, input_id = self:GetNearestInput(self.sx, self.sy, 1)
    if self:CheckPointClickCanAccept(ix, iy) then
      self:LockInput(input_id)
      local checkPointClickTiming = self:CheckPointClickPct(pct) ~= false
      if checkPointClickTiming then
        self.pointClickVerified = true
        self:PlaySE(self.themeCfg.click_se)
        self.point:ShowTimeOut(false)
      else
        return self:ToEnd(false)
      end
    end
  end
  if pct < 1 then
    if not self.pointClickVerified then
      self.point:SetTimeOut(pct)
    end
  elseif self.pointClickVerified then
    return self:ToState("Line")
  else
    return self:ToEnd(false)
  end
end

function BaseScreenQTELineCell:E_Line()
  self:ResetTimer()
end

function BaseScreenQTELineCell:L_Line()
end

function BaseScreenQTELineCell:P_Line(time, deltaTime)
  self:RefreshTimer(deltaTime)
  local pct = self.timer / self.cfg.move_timeout
  local rx, ry = self.point:GetPos()
  local ix, iy, input_id = self:GetNearestInput(rx, ry, 2)
  if input_id and self:CheckHold() then
    if pct < 1 then
      local inRange = self:CheckInputPosInRange(rx, ry, ix, iy, self.themeCfg.move_pos_accept_offset)
      if not inRange then
        return self:ToEnd(false)
      else
        self:LockInput(input_id)
      end
    end
  else
    return self:ToEnd(false)
  end
  if pct <= 1 then
    local lx, ly = self.line:GetLerpPos(pct)
    self.point:SetPos(lx, ly)
    self.line:SetProgress(pct)
  else
    return self:ToEnd(true)
  end
end

function BaseScreenQTELineCell:ToEnd(isSuccess)
  self:ToState("End")
  self.success = isSuccess
  if isSuccess ~= nil then
    self:ShowResult(isSuccess)
  end
  self:DeConstruct()
end

function BaseScreenQTELineCell:ShowResult(success)
  local fxName = success and self.themeCfg.success_fx or self.themeCfg.fail_fx
  local x, y = self.point:GetPos()
  self:PlayFx(fxName, true, x, y, nil, self.line:GetLineDir() + 180, function()
    self:ToState("Exit")
  end)
  local seName = success and self.themeCfg.success_se or self.themeCfg.fail_se
  self:PlaySE(seName)
  self.super.ShowResult(self, success)
end

function BaseScreenQTELineCell:DeConstruct()
  self.point:Destroy()
  self.line:Destroy()
end
