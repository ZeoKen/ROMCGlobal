MainViewStarArkPage = class("MainViewStarArkPage", SubMediatorView)
local StarArkConfig = GameConfig.StarArk
local SpeedColor = {
  Low = LuaColor.New(0.9921568627450981, 0.9372549019607843, 0.34509803921568627),
  Normal = LuaColor.New(0.6784313725490196, 0.8705882352941177, 0.5647058823529412)
}
local LengthColor = {
  Full = LuaColor.New(0.6784313725490196, 0.8705882352941177, 0.5647058823529412),
  Empty = LuaColor.New(0.40784313725490196, 0.49411764705882355, 0.6823529411764706)
}

function MainViewStarArkPage:InitShow()
  self.lastMonsterNum = 0
  self.lastSpeed = 0
end

function MainViewStarArkPage:ResetParent(parent)
  self.trans:SetParent(parent.transform, false)
end

function MainViewStarArkPage:Show()
  MainViewStarArkPage.super.Show(self)
  if not self.updatetowerTick then
    self.updatetowerTick = TimeTickManager.Me():CreateTick(0, 1, self.UpdateTowers, self, 102)
  end
end

function MainViewStarArkPage:UpdateView()
  local ins = DungeonProxy.Instance
  local currentNum = ins.starArk_npcnum or 0
  self.monsterNum.text = currentNum
  self.numberTip:SetActive(0 < currentNum - self.lastMonsterNum)
  self.numberTip_label.text = string.format("+%d", currentNum - self.lastMonsterNum)
  if 0 < currentNum - self.lastMonsterNum then
    self:ShowOnce(self.numberTip, 105)
  end
  self.lastMonsterNum = currentNum
  self.boxNum.text = string.format(ZhString.StarArk_BoxCount, ins.starArk_boxnum, ins.starArk_boxtotalnum)
  self.reviveCount.text = ins.starArk_relivecount or ""
  self.begintime = ins.starArk_begintime
  if self.begintime and 0 < self.begintime then
    if not self.countdownTick then
      self.countdownTick = TimeTickManager.Me():CreateTick(0, 1000, self.UpdateSaililngTime, self, 101)
    end
  else
    self:ClearTick()
    self.time.text = string.format(ZhString.StarArk_SailingTime, 0, 0)
    self.progressSlider.value = 0
    self.lengthPercent.text = "0%"
    for len, sp in pairs(self.markSprites) do
      sp.color = LengthColor.Empty
    end
  end
  self.monsterTip:SetActive(10 < currentNum)
  local maxSpeed = ins.starArk_maxspeed
  local fullSpeed = ins.starArk_fullspeed or 30
  local currentSpeed = ins.starArk_speed or 0
  self.speed.color = 10 < currentSpeed and SpeedColor.Normal or SpeedColor.Low
  self.speedSprite.color = 10 < currentSpeed and SpeedColor.Normal or SpeedColor.Low
  local toValue = currentSpeed / fullSpeed * 2 / 3
  local dir = 0 > currentSpeed - self.lastSpeed and 0 or 1
  self:NumberChange(self.speed, currentSpeed, 0.5, dir)
  self:FillAmountChangeValue(self.speedSprite, toValue, 0.5, dir)
  self.speedTip.text = 0 < maxSpeed and maxSpeed < fullSpeed and string.format(ZhString.StarArk_SpeedLimit, maxSpeed) or ZhString.StarArk_Speed
  self.limitSpeed.fillAmount = (0 < maxSpeed and maxSpeed < fullSpeed and 1 - maxSpeed / fullSpeed or 0) * 2 / 3
  self.changeTip:SetActive(0 > currentSpeed - self.lastSpeed)
  if dir == 0 then
    self:ShowOnce(self.changeTip, 106)
  end
  self.lastSpeed = currentSpeed
end

function MainViewStarArkPage:FillAmountChangeValue(slider, tovalue, time, dir)
  local nowValue = slider and slider.fillAmount
  TimeTickManager.Me():ClearTick(self, 103)
  TimeTickManager.Me():CreateTickFromTo(0, nowValue, tovalue, time * 1000, function(owner, deltaTime, curValue)
    slider.fillAmount = curValue
  end, self, 103)
end

function MainViewStarArkPage:NumberChange(label, tovalue, time, dir)
  local nowValue = tonumber(label.text)
  TimeTickManager.Me():ClearTick(self, 104)
  TimeTickManager.Me():CreateTickFromTo(0, nowValue, tovalue, time * 1000, function(owner, deltaTime, curValue)
    label.text = string.format(ZhString.StarArk_SpeedNum, curValue)
  end, self, 104)
end

function MainViewStarArkPage:Init()
  self:ReLoadPerferb("view/MainViewStarArkPage")
  self:FindObjs()
  self:InitShow()
  self:AddViewEvents()
end

function MainViewStarArkPage:ShowOnce(obj, tickID)
  TimeTickManager.Me():ClearTick(self, tickID)
  TimeTickManager.Me():CreateOnceDelayTick(2000, function(owner, deltaTime)
    if obj then
      obj:SetActive(false)
    end
  end, self, tickID)
end

function MainViewStarArkPage:FindObjs()
  self.time = self:FindGO("TimeLabel"):GetComponent(UILabel)
  self.progressSlider = self:FindGO("ProgressSlider"):GetComponent(UISlider)
  local progressGrid = self:FindGO("ProgressGrid")
  local progressMark = StarArkConfig.SummonNpc
  local progressMarkGrid = self:FindGO("ProgressMarkGrid")
  self.markSprites = {}
  for i = 1, 3 do
    local go = self:FindGO("Sprite" .. i, progressGrid)
    local per = progressMark[i].len / StarArkConfig.Length * 207
    go.transform.localPosition = LuaGeometry.GetTempVector3(per, 0, 0)
    local markGo = self:FindGO("Sprite" .. i, progressMarkGrid)
    markGo.transform.localPosition = LuaGeometry.GetTempVector3(per, -13, 0)
    local sp = markGo:GetComponent(UISprite)
    self.markSprites[progressMark[i].len] = sp
    sp.color = LengthColor.Empty
  end
  self.speed = self:FindGO("SpeedLabel"):GetComponent(UILabel)
  self.monsterNum = self:FindGO("MonsterNumLabel"):GetComponent(UILabel)
  self.boxNum = self:FindGO("BoxNumLabel"):GetComponent(UILabel)
  self.reviveCount = self:FindGO("ReviveCountLabel"):GetComponent(UILabel)
  self.speedSprite = self:FindGO("SpeedSprite"):GetComponent(UISprite)
  self.lengthPercent = self:FindGO("lengthPercent"):GetComponent(UILabel)
  self.progressSlider.value = 0
  self.lengthPercent.text = "0%"
  self.speedTip = self:FindGO("SpeedTip"):GetComponent(UILabel)
  self.limitSpeed = self:FindGO("LimitSpeed"):GetComponent(UISprite)
  self.limitSpeed.fillAmount = 0
  self.speedSprite.fillAmount = 0
  self.monsterTip = self:FindGO("MonsterTip")
  self.numberTip = self:FindGO("numberTip")
  self.numberTip_label = self:FindGO("Label", self.numberTip):GetComponent(UILabel)
  self.changeTip = self:FindGO("changeTip")
  self.dammageButton = self:FindGO("DammageButton")
  self:AddClickEvent(self.dammageButton, function()
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.StarArkStatisticsView
    })
  end)
end

function MainViewStarArkPage:AddViewEvents()
  self:AddListenEvt(ServiceEvent.FuBenCmdSyncStarArkStatisticsFuBenCmd, self.FinishAll)
  self:AddListenEvt(ServiceEvent.FuBenCmdSyncStarArkInfoFuBenCmd, self.UpdateView)
end

function MainViewStarArkPage:UpdateSaililngTime()
  local curTime = ServerTime.CurServerTime() / 1000
  local totalSec = curTime - (self.begintime or 0)
  local length = DungeonProxy.Instance:GetCurrentLength()
  if 0 < totalSec then
    local min, sec = ClientTimeUtil.GetFormatSecTimeStr(totalSec)
    self.time.text = string.format(ZhString.StarArk_SailingTime, min, sec)
    for len, sp in pairs(self.markSprites) do
      if length >= len then
        sp.color = LengthColor.Full
      end
    end
  else
    self.time.text = string.format(ZhString.StarArk_SailingTime, 0, 0)
    self:ClearTick()
    self.progressSlider.value = 0
    self.lengthPercent.text = "0%"
  end
  local percent = length / (StarArkConfig.Length or 1)
  self.progressSlider.value = percent
  self.lengthPercent.text = string.format("%d%%", math.clamp(percent * 100, 0, 99))
end

function MainViewStarArkPage:FinishAll()
  self:ClearTick()
  self.progressSlider.value = 1
  self.lengthPercent.text = string.format("%d%%", 100)
  self.speed.color = SpeedColor.Low
  self.speed.text = 0
  self.speedSprite.fillAmount = 0
  self.speedSprite.color = SpeedColor.Low
  DungeonProxy.Instance:RemoveTowerSkillBtn()
end

function MainViewStarArkPage:ClearTick()
  if self.countdownTick then
    TimeTickManager.Me():ClearTick(self, 101)
    self.countdownTick = nil
  end
  TimeTickManager.Me():ClearTick(self, 103)
  TimeTickManager.Me():ClearTick(self, 104)
  TimeTickManager.Me():ClearTick(self, 105)
end

function MainViewStarArkPage:UpdateTowers()
  DungeonProxy.Instance:UpdateTowers()
end

function MainViewStarArkPage:Hide(target)
  MainViewStarArkPage.super.Hide(self)
end

function MainViewStarArkPage:OnExit()
  self:ClearTick()
  if self.updatetowerTick then
    TimeTickManager.Me():ClearTick(self, 102)
    self.updatetowerTick = nil
  end
  MainViewStarArkPage.super.OnExit(self)
end
