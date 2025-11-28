QTEPeriodCustomAction = class("QTEPeriodCustomAction")

function QTEPeriodCustomAction:SetGroupIndex(group, groupIdx)
  self.group = group
  self.groupIdx = groupIdx
  return false
end

function QTEPeriodCustomAction:ctor(cfg, callback, gameCtrl)
  self.cfg = cfg
  self.pointTimingQueue = cfg.extra_timing
  self.callback = callback
  self.gameCtrl = gameCtrl
end

function QTEPeriodCustomAction:Start()
  self.timer = 0
end

function QTEPeriodCustomAction:Update(time, deltaTime)
  self.timer = self.timer + deltaTime
  for i = #self.pointTimingQueue, 1, -1 do
    if self.pointTimingQueue[i] <= self.timer then
      table.remove(self.pointTimingQueue, i)
      self:DoCustomAction()
    end
  end
end

function QTEPeriodCustomAction:DoCustomAction()
  if self.cfg.AS_play_sound and self.cfg.plotProcess then
    self.cfg.plotProcess:play_sound(self.cfg)
  end
end

function QTEPeriodCustomAction:ForceExit()
  self.Exit_Flag = true
end

function QTEPeriodCustomAction:Is_FSM_Exit()
  return self.Exit_Flag ~= nil
end
