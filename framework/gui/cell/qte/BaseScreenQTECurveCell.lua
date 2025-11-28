autoImport("ScreenQTEPrototypeCell")
autoImport("BaseScreenQTECompPoint")
BaseScreenQTECurveCell = class("BaseScreenQTECurveCell", ScreenQTEPrototypeCell)

function BaseScreenQTECurveCell:ctor(cfg, themeCfg, holderObj, fxHolderObj, callback, gameCtrl)
  self.cfg = cfg
  self.themeCfg = themeCfg
  self.curveObj = self:LoadCurvePfb(cfg.curve_shape, holderObj)
  self.curve = self.curveObj:GetComponent(Ferr2DT_PathCurveHelper)
  local x, y = self.CvtCfgScreenPos(cfg.pos[1], cfg.pos[2])
  self.curveObj.transform.localPosition = LuaGeometry.GetTempVector3(x, y, 0)
  self.curveObj.transform.localScale = LuaGeometry.GetTempVector3(self.curve.pixelScaleFactor, self.curve.pixelScaleFactor, self.curve.pixelScaleFactor)
  local lx, ly = self:GetPathPosInfo(0)
  self.point = BaseScreenQTECompPoint.new(themeCfg.point_cell, holderObj)
  self.point:SetPos(lx, ly, true)
  self.point:SetWithCfg(themeCfg)
  self.point:SetMarkSp(themeCfg.curve_mark_sp)
  self.fxHolderObj = fxHolderObj
  self.callback = callback
  self.gameCtrl = gameCtrl
end

function BaseScreenQTECurveCell:Start()
  if self.cfg.delay and self.cfg.delay > 0 then
    self:ToState("Delay")
  else
    self:ToState("Point")
  end
end

function BaseScreenQTECurveCell:E_Delay()
  self:ResetTimer(self.cfg.delay and self.cfg.delay > 0)
  self.point:ShowTimeOut(false)
end

function BaseScreenQTECurveCell:L_Delay()
end

function BaseScreenQTECurveCell:P_Delay(time, deltaTime)
  self:RefreshTimer(deltaTime)
  if self.timer > self.cfg.delay then
    return self:ToState("Point")
  end
end

function BaseScreenQTECurveCell:E_Point()
  self:ResetTimer(not self.cfg.delay or not (self.cfg.delay > 0))
  self.point:ShowTimeOut(not self.cfg.hide_point_circle)
  self.point:SetTimeOut(0)
  self.sx, self.sy = self.point:GetPos()
  self.pointClickVerified = nil
end

function BaseScreenQTECurveCell:L_Point()
  self.pointClickVerified = nil
  self.point:ShowTimeOut(false)
end

function BaseScreenQTECurveCell:P_Point(time, deltaTime)
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
    return self:ToState("Curve")
  else
    return self:ToEnd(false)
  end
end

function BaseScreenQTECurveCell:E_Curve()
  self:ResetTimer()
  self.startIndex = -1
end

function BaseScreenQTECurveCell:L_Curve()
end

function BaseScreenQTECurveCell:P_Curve(time, deltaTime)
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
    local lx, ly = self:GetPathPosInfo(pct, true)
    self.point:SetPos(lx, ly, true)
  else
    return self:ToEnd(true)
  end
end

function BaseScreenQTECurveCell:ToEnd(isSuccess)
  self:ToState("End")
  self.success = isSuccess
  if isSuccess ~= nil then
    self:ShowResult(isSuccess)
  end
  self:DeConstruct()
end

function BaseScreenQTECurveCell:ShowResult(success)
  local fxName = success and self.themeCfg.success_fx or self.themeCfg.fail_fx
  local x, y = self.point:GetPos()
  self:PlayFx(fxName, true, x, y, nil, nil, function()
    self:ToState("Exit")
  end)
  local seName = success and self.themeCfg.success_se or self.themeCfg.fail_se
  self:PlaySE(seName)
  self.super.ShowResult(self, success)
end

function BaseScreenQTECurveCell:DeConstruct()
  self.point:Destroy()
  if not self:ObjIsNil(self.curveObj) then
    GameObject.DestroyImmediate(self.curveObj)
  end
end

function BaseScreenQTECurveCell:GetPathPosInfo(pct, useStartIndex)
  if self.curve then
    local si = useStartIndex and self.startIndex or -1
    local posInfo = self.curve:GetPathRealPosInfoByPct(pct, si)
    if posInfo[3] >= 0 then
      if useStartIndex then
        self.startIndex = posInfo[3]
      end
      return posInfo[1], posInfo[2], posInfo[3]
    end
  end
end

function BaseScreenQTECurveCell:LoadCurvePfb(cName, holderObj)
  local cellpfb = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.CurveSprite2D(cName))
  if cellpfb == nil then
    error("can not find cellpfb" .. cName)
  end
  cellpfb.transform:SetParent(holderObj.transform, false)
  cellpfb.transform.localPosition = LuaVector3.zero
  return cellpfb
end
