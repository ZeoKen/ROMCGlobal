ScreenTransitView = class("ScreenTransitView", ContainerView)
ScreenTransitView.ViewType = UIViewType.DialogLayer
local FadeColor = {
  [1] = LuaColor.Black(),
  [2] = LuaColor.White(),
  [3] = LuaColor.Red()
}

function ScreenTransitView:Init()
  self.mask = self:FindGO("BlackBG"):GetComponent(UISprite)
  self.data = self.viewdata.viewdata and self.viewdata.viewdata
  self.questData = self.data.questData
  if self.questData then
    self.inTime = self.questData.params.fadein or 0
    self.outTime = self.questData.params.fadeout or 0
    self.duration = self.questData.params.time or 0
    self.color = self.questData.params.color or 1
  else
    self.inTime = self.data.inTime or 0
    self.outTime = self.data.outTime or 0
    self.duration = self.data.time or 2
    self.color = self.data.color or 1
  end
  self:DefaultColorMask()
end

function ScreenTransitView:DefaultColorMask()
  redlog("开启")
  if self.color and FadeColor[self.color] then
    self.mask.color = FadeColor[self.color]
  end
  helplog(self.inTime, self.outTime, self.duration)
  LeanTween.alphaNGUI(self.mask, 0, 1, self.inTime)
  self.timeTick = TimeTickManager.Me():CreateOnceDelayTick((self.duration - self.outTime) * 1000, function(owner, deltaTime)
    redlog("消失")
    LeanTween.alphaNGUI(self.mask, 1, 0, self.outTime)
  end, self, 2)
  self.timeTickEnd = TimeTickManager.Me():CreateOnceDelayTick(self.duration * 1000, function(owner, deltaTime)
    redlog("关闭")
    self:ClearTick()
    self:CloseSelf()
    if self.questData then
      QuestProxy.Instance:notifyQuestState(self.questData.scope, self.questData.id, self.questData.staticData.FinishJump)
    end
  end, self, 3)
end

function ScreenTransitView:ClearTick()
  if self.timeTick then
    TimeTickManager.Me():ClearTick(self)
    self.timeTick = nil
  end
end

function ScreenTransitView:OnEnter()
  ScreenTransitView.super.OnEnter(self)
end

function ScreenTransitView:OnExit()
  self:ClearTick()
end
