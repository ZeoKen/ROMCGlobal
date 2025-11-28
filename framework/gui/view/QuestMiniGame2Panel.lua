autoImport("TimeTickManager")
QuestMiniGame2Panel = class("QuestMiniGame2Panel", BaseView)
QuestMiniGame2Panel.ViewType = UIViewType.Popup10Layer
QuestMiniGame2Panel.stat = {
  wait1 = 0,
  step1 = 1,
  wait2 = 2,
  step2 = 3,
  result = 4
}
local cycle, interval = 1000, 50
local posx1, posx2 = 1, 0
local minlenp, maxlenp, len, tickInstance = 20, 80
local step1eff, step2eff = "WorldMissionIight_jindongtiao", "WorldMissionIight_xuetiao"

function QuestMiniGame2Panel:Init()
  tickInstance = TimeTickManager.Me()
  self:FindObjs()
end

function QuestMiniGame2Panel:FindObjs()
  self.bar = self:FindGO("Bar")
  self.title = self:FindComponent("title", UILabel)
  self.step2 = self:FindGO("step2")
  self.step2Bg = self.step2:GetComponent(UISprite)
  self.step2Center = self:FindComponent("center", UISprite, self.step2)
  self.arrow = self:FindGO("arrow")
  self.step1Slider = self:FindComponent("progressBar", UISlider)
  self:AddClickEvent(self:FindGO("click"), function()
    self:ClickOp()
  end)
end

function QuestMiniGame2Panel:ClickOp()
  if self.st == QuestMiniGame2Panel.stat.wait1 then
    self.tick = tickInstance:CreateTick(0, interval, self.TweenStep1, self)
    self:PlayTweenEffect(true, step1eff)
    self:PlaySEOn("Skill/Tnts_heart_wait")
    self.st = QuestMiniGame2Panel.stat.step1
  elseif self.st == QuestMiniGame2Panel.stat.step1 then
    tickInstance:ClearTick(self)
    self:PlayTweenEffect(false)
    self:StopSEOn()
    self.st = QuestMiniGame2Panel.stat.wait2
  elseif self.st == QuestMiniGame2Panel.stat.wait2 then
    self.tick = tickInstance:CreateTick(0, interval, self.TweenStep2, self)
    self:PlayTweenEffect(true, step2eff)
    self:PlaySEOn("Skill/Tnts_heart_fast")
    self.st = QuestMiniGame2Panel.stat.step2
  elseif self.st == QuestMiniGame2Panel.stat.step2 then
    tickInstance:ClearTick(self)
    self:PlayTweenEffect(false)
    self:StopSEOn()
    self.st = QuestMiniGame2Panel.stat.result
  elseif self.st == QuestMiniGame2Panel.stat.result then
    self:SubmitAndClose()
  end
  self:ShowUI()
end

function QuestMiniGame2Panel:ShowUI()
  if self.st == QuestMiniGame2Panel.stat.wait1 then
    self.title.text = ZhString.QuestMiniGame2_wait1
    self:ShowStep1()
  elseif self.st == QuestMiniGame2Panel.stat.step1 then
    self.title.text = ZhString.QuestMiniGame2_step1
  elseif self.st == QuestMiniGame2Panel.stat.wait2 then
    self.title.text = ZhString.QuestMiniGame2_wait2
    self:ShowStep2()
  elseif self.st == QuestMiniGame2Panel.stat.step2 then
    self.title.text = ZhString.QuestMiniGame2_step2
  elseif self.st == QuestMiniGame2Panel.stat.result then
    self:ShowResult()
  end
end

function QuestMiniGame2Panel:OnEnter()
  QuestMiniGame2Panel.super.OnEnter(self)
  self.questData = self.viewdata.viewdata
  self.step1Cycle = self.questData and self.questData.params and self.questData.params.step1cycle or cycle
  self.step2Cycle = self.questData and self.questData.params and self.questData.params.step2cycle or cycle
  self.transrate = self.questData and self.questData.params and self.questData.params.transrate or 100
  self.st = QuestMiniGame2Panel.stat.wait1
  self.result = false
  len = self.step2Bg.width
  posx2 = len - posx1
  self:ShowUI()
end

function QuestMiniGame2Panel:OnExit()
  if self.result then
  end
  QuestMiniGame2Panel.super.OnExit(self)
  tickInstance:ClearTick(self)
  self.tick = nil
  self:StopSEOn()
end

function QuestMiniGame2Panel:ShowStep1()
  self.step2:SetActive(false)
  self.step1Slider.value = 0
end

function QuestMiniGame2Panel:ShowStep2()
  self.step2:SetActive(true)
  self.arrow.transform.localPosition = LuaGeometry.GetTempVector3(posx1, -15, 0)
  local step1val = self.step1Slider.value
  local width = math.clamp(step1val * self.transrate, minlenp * len / 100, maxlenp * len / 100)
  self.step2Center.width = width
  math.randomseed(tostring(os.time()):reverse():sub(1, 6))
  local px = math.random(posx1 + width / 2, posx2 - width / 2)
  self.step2Center.transform.localPosition = LuaGeometry.GetTempVector3(px, 0, 0)
  self.step1Slider.value = 0
end

function QuestMiniGame2Panel:ShowResult()
  local hwidth = self.step2Center.width / 2
  local posx = self.arrow.transform.localPosition.x
  local centerx = self.step2Center.transform.localPosition.x
  self.result = posx >= centerx - hwidth and posx <= centerx + hwidth
  if self.result then
    self.title.text = ZhString.QuestMiniGame2_result_win
  else
    self.title.text = ZhString.QuestMiniGame2_result_fail
  end
  local se = self.result and "Common/cook_get" or "Common/cook_fail"
  self:PlayUISound(se)
end

function QuestMiniGame2Panel:TweenStep1()
  local val = self.step1Slider.value
  if 1 <= val then
    self.add = -1
  elseif val <= 0 then
    self.add = 1
  end
  self.step1Slider.value = math.clamp(val + self.add * 2 * interval / self.step1Cycle, 0, 1)
end

function QuestMiniGame2Panel:TweenStep2()
  local posx = self.arrow.transform.localPosition.x
  if posx >= posx2 then
    self.add = -1
  elseif posx <= posx1 then
    self.add = 1
  end
  self.arrow.transform.localPosition = LuaGeometry.GetTempVector3(posx + self.add * 2 * interval / self.step2Cycle * (posx2 - posx1), -15, 0)
end

function QuestMiniGame2Panel:CloseSelf()
  self:SubmitAndClose()
end

function QuestMiniGame2Panel:SubmitAndClose()
  if self.result then
    if self.questData and self.questData.scope and self.questData.id and self.questData.staticData and self.questData.staticData.FinishJump then
      QuestProxy.Instance:notifyQuestState(self.questData.scope, self.questData.id, self.questData.staticData.FinishJump)
    else
      redlog("钓鱼小游戏：任务数据有误")
    end
  elseif self.questData and self.questData.scope and self.questData.id and self.questData.staticData and self.questData.staticData.FailJump then
    QuestProxy.Instance:notifyQuestState(self.questData.scope, self.questData.id, self.questData.staticData.FailJump)
  else
    redlog("钓鱼小游戏：任务数据有误")
  end
  self.super.CloseSelf(self)
end

function QuestMiniGame2Panel:PlayTweenEffect(show, effId)
  if self.uiEffect then
    self.uiEffect:SetActive(false)
  end
  if show then
    self:PlayUIEffect(effId, self.bar, false, function(go, args, assetEffect)
      self.uiEffect = assetEffect
      local childtrans = go.transform:GetChild(0)
      if childtrans then
        childtrans.transform.localPosition = LuaGeometry.GetTempVector3(60, 5.5, 0)
        childtrans.transform.localScale = LuaGeometry.GetTempVector3(151, 155, 0)
      end
    end)
  end
end

local tempV3 = LuaVector3.Zero

function QuestMiniGame2Panel:PlaySEOn(sePath)
  if self.audioSource == nil then
    local clip = AudioUtility.GetAudioClip(sePath)
    self.audioSource = AudioHelper.PlayLoop_At(clip, 0, 0, 0, 0, AudioSourceType.UI)
    FunctionBGMCmd.Me():StartSolo()
  end
end

function QuestMiniGame2Panel:StopSEOn()
  if self.audioSource ~= nil then
    FunctionBGMCmd.Me():EndSolo()
    self.audioSource:Stop()
    self.audioSource = nil
  end
end
