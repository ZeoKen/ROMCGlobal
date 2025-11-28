QTEGameControl = class("QTEGameControl")
local temp_theme_cfg = {
  [1] = {
    point_cell = "DisneyQTEPoint",
    line_cell = "DisneyQTELine",
    point_mark_sp = 0,
    line_mark_sp = 1,
    curve_mark_sp = 2,
    line_margin = 27.5,
    progress_margin = -20,
    click_ring_scale_range = {1.2, 0.37},
    click_accept_pct = {0.3, 0.7},
    click_perfect_pct = {0.45, 0.55},
    click_pos_accept_offset = 30,
    move_pos_accept_offset = 50,
    click_se = "",
    move_se = "",
    success_se = "",
    fail_se = "",
    success_fx = "eff_Disney_QTE_suc",
    fail_fx = "eff_Disney_QTE_fail"
  }
}
local isRunOnEditor = ApplicationInfo.IsRunOnEditor()
local isRunOnStandalone = Application.platform == RuntimePlatform.WindowsPlayer or Application.platform == RuntimePlatform.OSXPlayer

function QTEGameControl:ctor(id, plotId, panelConfig, themeCfg, autoEnd, resultCb, endCb, orderInfo)
  self.id = id
  self.plotId = plotId
  self.autoEnd = autoEnd
  self.defaultResultCb = resultCb
  self.endCb = endCb
  self.defaultThemeCfg = self:GetThemeCfg(themeCfg)
  self.orderInfo = orderInfo
  self.inputCheckLock = {}
  self:Reset()
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {view = panelConfig, viewdata = self})
end

function QTEGameControl:GetThemeCfg(themeCfg)
  return GameConfig.QTE and GameConfig.QTE.theme_cfg and GameConfig.QTE.theme_cfg[themeCfg] or temp_theme_cfg[themeCfg]
end

function QTEGameControl:Reset()
  if self.qte_parallel_seq then
    TableUtility.TableClear(self.qte_parallel_seq)
  else
    self.qte_parallel_seq = {}
  end
  if self.qte_normal_set then
    TableUtility.TableClear(self.qte_normal_set)
  else
    self.qte_normal_set = {}
  end
end

function QTEGameControl:Terminate()
  self:Reset()
  Game.GUISystemManager:ClearMonoLateUpdateFunction(self)
end

function QTEGameControl:SetView(view)
  self.view = view
  self.uiCamera = NGUIUtil:GetCameraByLayername("UI")
  self.inited = true
  Game.GUISystemManager:AddMonoLateUpdateFunction(self.Update, self)
end

function QTEGameControl:AddStep(cfg, resultCb)
  if type(cfg) == "number" then
    cfg = Table_QteCfg and Table_QteCfg[cfg]
  end
  if type(cfg) ~= "table" then
    return
  end
  local qte
  if cfg.type == "point_click" then
    qte = self.view:AddPointClick(cfg)
  elseif cfg.type == "point_hit" then
    qte = self.view:AddPointHit(cfg)
  elseif cfg.type == "line_route" then
    qte = self.view:AddLineRoute(cfg)
  elseif cfg.type == "curve_route" then
    qte = self.view:AddCurveRoute(cfg)
  elseif cfg.type == "period_click" then
    qte = self.view:AddPeriodClick(cfg)
  elseif cfg.type == "custom_action" then
    qte = self.view:AddPeriodCustomAction(cfg)
  end
  if not qte then
    return
  end
  local group = cfg.group
  if group then
    if not self.qte_parallel_seq[group] then
      self.qte_parallel_seq[group] = {}
      self.qte_parallel_seq[group].cur = 0
      self.qte_parallel_seq[group].cnt = 0
    end
    local seq = self.qte_parallel_seq[group]
    local groupIdx = seq.cnt + 1
    qte:SetGroupIndex(group, groupIdx)
    seq[groupIdx] = qte
    seq.cnt = groupIdx
  else
    TableUtility.ArrayPushBack(self.qte_normal_set, qte)
  end
end

function QTEGameControl:RemoveStepById(id)
  if not id then
    return
  end
  for i = 1, #self.qte_normal_set do
    if id == self.qte_normal_set[i].id then
      self.qte_normal_set[i]:ForceExit()
    end
  end
end

function QTEGameControl:Update(time, deltaTime)
  self.ut = UnityRealtimeSinceStartup
  self:ClearInputCheckLock()
  for group, v in pairs(self.qte_parallel_seq) do
    for _, c in pairs(v) do
      if type(c) == "table" then
        c:Update(time, deltaTime)
      end
    end
  end
  for i = #self.qte_normal_set, 1, -1 do
    if self.qte_normal_set[i]:Is_FSM_Exit() then
      table.remove(self.qte_normal_set, i)
    end
  end
  for i = 1, #self.qte_normal_set do
    self.qte_normal_set[i]:Update(time, deltaTime)
  end
end

QTEGameControl.InputStatus = {}

function QTEGameControl:UpdateInputFullStatus()
  TableUtility.TableClear(self.InputStatus)
  if isRunOnStandalone or isRunOnEditor then
    local status
    if Input.GetMouseButtonDown(0) then
      status = 1
    elseif Input.GetMouseButtonUp(0) then
      status = 3
    elseif Input.GetMouseButton(0) then
      status = 2
    end
    if status then
      QTEGameControl.InputStatus[1] = {
        status = status,
        x = Input.mousePosition.x,
        y = Input.mousePosition.y
      }
    end
  else
    for i = 1, Input.touchCount do
      local touch = Input.GetTouch(i - 1)
      local info = {}
      local touchPhase, touchPos = touch.phase, touch.position
      if touchPhase == TouchPhase.Began then
        info.status = 1
      elseif touchPhase == TouchPhase.Ended or touchPhase == TouchPhase.Cancelled then
        info.status = 3
      elseif touchPhase == TouchPhase.Moved or touchPhase == TouchPhase.Stationary then
        info.status = 2
      end
      info.x, info.y = touchPos.x, touchPos.y
      QTEGameControl.InputStatus[i] = info
    end
  end
end

function QTEGameControl:SetInputCheckLock(input)
  self.inputCheckLock[input] = true
  return input
end

function QTEGameControl:ClearInputCheckLock()
  if self.inputCheckLock then
    TableUtility.TableClear(self.inputCheckLock)
  end
end

function QTEGameControl:GetInput_NearestPos(rx, ry, statusCond)
  statusCond = statusCond or 0
  local x, y
  if isRunOnStandalone or isRunOnEditor then
    local status
    if self.inputCheckLock and self.inputCheckLock[0] then
      return
    end
    if Input.GetMouseButtonDown(0) then
      status = 1
    elseif Input.GetMouseButton(0) then
      status = 2
    end
    if status and statusCond == 0 or statusCond == status then
      x, y = self:ConvertScreenPosToLocalPos(Input.mousePosition.x, Input.mousePosition.y)
      return x, y, 0
    end
  else
    local nearDisSq = 9999999999
    local ix, iy, id
    for i = 1, Input.touchCount do
      if self.inputCheckLock and self.inputCheckLock[i] then
      else
        local touch = Input.GetTouch(i - 1)
        local touchPhase = touch.phase
        local tx, ty = LuaGameObject.GetTouchPosition(i - 1, false)
        local status
        if touchPhase == TouchPhase.Began then
          status = 1
        elseif touchPhase == TouchPhase.Moved or touchPhase == TouchPhase.Stationary then
          status = 2
        end
        if status and statusCond == 0 or statusCond == status then
          if rx and ry then
            local dx = tx - rx
            local dy = ty - ry
            local disSq = dx * dx + dy * dy
            if nearDisSq >= disSq then
              nearDisSq = disSq
              ix, iy = tx, ty
              id = i
            end
          else
            x, y = self:ConvertScreenPosToLocalPos(tx, ty)
            return x, y, i
          end
        end
      end
    end
    if ix and iy then
      x, y = self:ConvertScreenPosToLocalPos(ix, iy)
      return x, y, id
    end
  end
end

function QTEGameControl:GetInput_IsClick()
  if isRunOnStandalone or isRunOnEditor then
    return Input.GetMouseButtonDown(0)
  else
    for i = 1, Input.touchCount do
      local touch = Input.GetTouch(i - 1)
      if touch.phase == TouchPhase.Began then
        return true
      end
    end
  end
end

function QTEGameControl:GetInput_IsHold()
  if isRunOnStandalone or isRunOnEditor then
    return Input.GetMouseButton(0)
  else
    for i = 1, Input.touchCount do
      local touch = Input.GetTouch(i - 1)
      if touch.phase == TouchPhase.Moved or touch.phase == TouchPhase.Stationary then
        return true
      end
    end
  end
end

function QTEGameControl:ConvertScreenPosToLocalPos(ix, iy)
  local inputWorldPos = self.uiCamera:ScreenToWorldPoint(LuaGeometry.GetTempVector3(ix, iy, 0))
  local x, y, z = LuaGameObject.InverseTransformPointByVector3(self.view.qteHolder.transform, inputWorldPos)
  return x, y
end
