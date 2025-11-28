ScreenQTEPrototypeCell = class("ScreenQTEPrototypeCell", BaseCell)

function ScreenQTEPrototypeCell:SetGroupIndex(group, groupIdx)
  self.group = group
  self.groupIdx = groupIdx
  return true
end

function ScreenQTEPrototypeCell:PlayFx(fxName, oneShot, x, y, isWorldCoord, dir, onCreatedCb)
  self.effect = self:PlayUIEffect(fxName, self.fxHolderObj, true, function(go)
    if isWorldCoord then
      go.gameObject.transform.position = LuaGeometry.GetTempVector3(x, y, 0)
    else
      go.gameObject.transform.localPosition = LuaGeometry.GetTempVector3(x, y, 0)
    end
    dir = dir or 0
    go.gameObject.transform.localEulerAngles = LuaGeometry.GetTempVector3(0, 0, dir)
    if onCreatedCb then
      onCreatedCb()
    end
  end)
end

function ScreenQTEPrototypeCell:PlaySE(seName)
  local se = ResourcePathHelper.AudioSE(seName)
  AudioUtility.PlayOneShot2D_Path(se)
end

function ScreenQTEPrototypeCell:ToState(p)
  if self.p and self["L_" .. self.p] then
    self["L_" .. self.p](self)
  end
  self.p = p
  if self.p and self["E_" .. self.p] then
    self["E_" .. self.p](self)
  end
end

function ScreenQTEPrototypeCell:Update(time, deltaTime)
  if self["P_" .. self.p] then
    self["P_" .. self.p](self, time, deltaTime)
  end
end

function ScreenQTEPrototypeCell:GetNearestInput(rx, ry, statusCond)
  return FunctionQTE.Me():GetGameControl():GetInput_NearestPos(rx, ry, statusCond)
end

function ScreenQTEPrototypeCell:CheckClick()
  return FunctionQTE.Me():GetGameControl():GetInput_IsClick()
end

function ScreenQTEPrototypeCell:CheckHold()
  return FunctionQTE.Me():GetGameControl():GetInput_IsHold()
end

function ScreenQTEPrototypeCell:CheckInputPosInRange(x, y, ix, iy, range)
  local dx = x - ix
  local dy = y - iy
  return dx * dx + dy * dy <= range * range
end

function ScreenQTEPrototypeCell:CheckPointClickCanAccept(ix, iy)
  if not ix or not iy then
    return false
  end
  local rx, ry = self.point:GetPos()
  local tcfg = self.themeCfg
  local dis_ok = self:CheckInputPosInRange(rx, ry, ix, iy, tcfg.click_pos_accept_offset)
  return dis_ok
end

function ScreenQTEPrototypeCell:LockInput(input_id)
  FunctionQTE.Me():GetGameControl():SetInputCheckLock(input_id)
end

function ScreenQTEPrototypeCell:CheckPointClickPct(pct)
  local tcfg = self.themeCfg
  self:TryCalcClickPct(tcfg)
  if pct >= tcfg.click_perfect_pct[1] and pct <= tcfg.click_perfect_pct[2] then
    return 2
  elseif pct >= tcfg.click_accept_pct[1] and pct <= tcfg.click_accept_pct[2] then
    return 1
  end
  return false
end

function ScreenQTEPrototypeCell:TryCalcClickPct(tcfg)
  if not tcfg.click_accept_pct and tcfg.click_accept_scale_range then
    tcfg.click_accept_pct = {}
    local len = tcfg.click_ring_scale_range[2] - tcfg.click_ring_scale_range[1]
    local len_s = tcfg.click_accept_scale_range[1] - tcfg.click_ring_scale_range[1]
    local len_e = tcfg.click_accept_scale_range[2] - tcfg.click_ring_scale_range[1]
    tcfg.click_accept_pct[1] = len_s / len
    tcfg.click_accept_pct[2] = len_e / len
  end
  if not tcfg.click_perfect_pct and tcfg.click_perfect_scale_range then
    tcfg.click_perfect_pct = {}
    local len = tcfg.click_ring_scale_range[2] - tcfg.click_ring_scale_range[1]
    local len_s = tcfg.click_perfect_scale_range[1] - tcfg.click_ring_scale_range[1]
    local len_e = tcfg.click_perfect_scale_range[2] - tcfg.click_ring_scale_range[1]
    tcfg.click_perfect_pct[1] = len_s / len
    tcfg.click_perfect_pct[2] = len_e / len
  end
end

function ScreenQTEPrototypeCell:ShowResult(success)
  if self.callback then
    self.callback(success, self)
  end
end

function ScreenQTEPrototypeCell:ForceExit()
  self:ToState("Exit")
end

function ScreenQTEPrototypeCell:E_Exit()
  self.Exit_Flag = true
end

function ScreenQTEPrototypeCell:Is_FSM_Exit()
  return self.Exit_Flag ~= nil
end

local screenWidth, screenHeight

function ScreenQTEPrototypeCell.CvtCfgScreenPos(x, y)
  local px = x / 1280
  local py = y / 720
  if not screenWidth then
    screenWidth, screenHeight = NGUITools.screenSize.x, NGUITools.screenSize.y
    if 1.7777777777777777 < screenWidth / screenHeight then
      screenWidth = 720 * screenWidth / screenHeight
      screenHeight = 720
    else
      screenHeight = 1280 * screenHeight / screenWidth
      screenWidth = 1280
    end
  end
  return screenWidth * px, screenHeight * py
end

function ScreenQTEPrototypeCell.CvtCfgScreenPos_AutoAnchor(x, y)
  local sx = 0 < x and 1 or -1
  local sy = 0 < y and 1 or -1
  if not screenWidth then
    screenWidth, screenHeight = NGUITools.screenSize.x, NGUITools.screenSize.y
    if 1.7777777777777777 < screenWidth / screenHeight then
      screenWidth = 720 * screenWidth / screenHeight
      screenHeight = 720
    else
      screenHeight = 1280 * screenHeight / screenWidth
      screenWidth = 1280
    end
  end
  return (screenWidth / 2 + math.abs(x) - 640) * sx, (screenHeight / 2 + math.abs(y) - 360) * sy
end

function ScreenQTEPrototypeCell:ResetTimer(isInit)
  self.timer = 0
  if isInit then
    self.timer = math.max(0, self.cfg.plotProcess.time and self.cfg.plotProcess.time - self.cfg.start_time or 0)
  end
  self.rts = UnityRealtimeSinceStartup + self.timer
  self.timer_2 = 0
end

function ScreenQTEPrototypeCell:RefreshTimer(deltaTime)
  self.timer = UnityRealtimeSinceStartup - self.rts
  if deltaTime then
    self.timer_2 = self.timer_2 + deltaTime
  end
  self.timer = math.max(self.timer, self.timer_2)
end
