autoImport("BaseScreenQTECompPoint")
BaseScreenQTEPeriodClickCell = class("BaseScreenQTEPeriodClickCell", BaseScreenQTECompPoint)
local CvtCfgScreenPos = ScreenQTEPrototypeCell.CvtCfgScreenPos_AutoAnchor

function BaseScreenQTEPeriodClickCell:ResetTimer(isInit)
  self.timer = 0
  if isInit then
    self.timer = math.max(0, self.cfg.plotProcess.time and self.cfg.plotProcess.time - self.cfg.start_time or 0)
  end
  self.rts = UnityRealtimeSinceStartup + self.timer
  self.timer_2 = 0
end

function BaseScreenQTEPeriodClickCell:RefreshTimer(deltaTime)
  self.timer = UnityRealtimeSinceStartup - self.rts
  if deltaTime then
    self.timer_2 = self.timer_2 + deltaTime
  end
  self.timer = math.max(self.timer, self.timer_2)
end

function BaseScreenQTEPeriodClickCell:ctor(cfg, themeCfg, holderObj, fxHolderObj, callback, gameCtrl)
  self.cfg = cfg
  self.themeCfg = themeCfg
  self.fxHolderObj = fxHolderObj
  self.callback = callback
  self.gameCtrl = gameCtrl
  self.pointTimingQueue = cfg.extra_timing
  self.gameObject = self:LoadCellPfb(themeCfg.base_cell, holderObj)
  self.markSp = self:FindComponent("MarkSp", UIMultiSprite)
  self:SetMarkSp(themeCfg.main_sp)
  local x, y = CvtCfgScreenPos(cfg.pos[1], cfg.pos[2])
  self:SetPos(x, y)
end

function BaseScreenQTEPeriodClickCell:Start()
  for i = 1, #self.pointTimingQueue do
    self.pointTimingQueue[i] = self.pointTimingQueue[i] - self.cfg.delay
  end
  self:ResetTimer(true)
  local plotProcess = self.cfg.plotProcess
  self.cfg.plotProcess = nil
  self.commonPointCfg = {}
  TableUtil.deepcopy(self.commonPointCfg, self.cfg)
  self.commonPointCfg.type = "point_click"
  self.commonPointCfg.theme_cfg = self.themeCfg.inuse_point_theme
  self.commonPointCfg.plotProcess = plotProcess
  self.commonPointCfg.pos_cvt_func = CvtCfgScreenPos
end

function BaseScreenQTEPeriodClickCell:Update(time, deltaTime)
  self:RefreshTimer(deltaTime)
  for i = #self.pointTimingQueue, 1, -1 do
    if self.pointTimingQueue[i] <= self.timer then
      self.commonPointCfg.start_time = self.cfg.start_time + self.pointTimingQueue[i]
      table.remove(self.pointTimingQueue, i)
      self.gameCtrl:AddStep(self.commonPointCfg)
    end
  end
end

function BaseScreenQTEPeriodClickCell:ForceExit()
  self:DeConstruct()
  self.Exit_Flag = true
end

function BaseScreenQTEPeriodClickCell:DeConstruct()
  self:Destroy()
end

function BaseScreenQTEPeriodClickCell:Is_FSM_Exit()
  return self.Exit_Flag ~= nil
end
