IllustrationShowView = class("IllustrationShowView", ContainerView)
IllustrationShowView.ViewType = UIViewType.DialogLayer

function IllustrationShowView:Init()
  self.pic = self:FindGO("Pic"):GetComponent(UITexture)
  self.data = self.viewdata.viewdata and self.viewdata.viewdata
  self.questData = self.data.questData
  helplog("Picture界面参数", self.data.path, self.data.time)
  self:AddViewListeners()
  self:LoadPic()
end

function IllustrationShowView:LoadPic()
  PictureManager.Instance:SetIllustration(self.data.path, self.pic)
  if self.pic.mainTexture == nil then
    redlog("图片加载失败！")
    return
  end
  self.pic.width = 1024
  self.pic.height = 1024
  if self.data then
    self:TweenPic(0, 1, 0.5)
  end
  self.clicktime = UnityUnscaledTime
  self.timeTick = TimeTickManager.Me():CreateTick(0, 1000, self.updateShowCtl, self, 1, true)
end

function IllustrationShowView:TweenPic(from, to, duration)
  self:CancelTweenPic()
  LeanTween.alphaNGUI(self.pic, from, to, duration)
end

function IllustrationShowView:CancelTweenPic()
  LeanTween.cancel(self.pic.gameObject)
end

function IllustrationShowView:AddViewListeners()
end

function IllustrationShowView:updateShowCtl()
  if UnityUnscaledTime - self.clicktime > self.data.time then
    QuestProxy.Instance:notifyQuestState(self.questData.scope, self.questData.id, self.questData.staticData.FinishJump)
    self:ClearTick()
    self:CloseSelf()
  end
end

function IllustrationShowView:ClearTick()
  if self.timeTick then
    TimeTickManager.Me():ClearTick(self)
    self.timeTick = nil
  end
end

function IllustrationShowView:OnEnter()
  IllustrationModeView.super.OnEnter(self)
end

function IllustrationShowView:OnExit()
  PictureManager.Instance:UnLoadIllustration(self.data.path, self.pic)
  self:ClearTick()
end
