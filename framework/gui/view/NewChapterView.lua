local _texture_name = "main_bg_blueline"
NewChapterView = class("NewChapterView", ContainerView)
NewChapterView.ViewType = UIViewType.MovieLayer

function NewChapterView:Init()
  self.root = self:FindGO("Root"):GetComponent(UISprite)
  self.questData = self.viewdata.viewdata and self.viewdata.viewdata and self.viewdata.viewdata.questData
  if not self.questData then
    return
  end
  local params = self.questData.params
  if not params then
    redlog("NewChapterView未配置字段params")
    return
  end
  FunctionQuest.Me():SetNewChapterCd(params.cd)
  self.fade_in_time = params.fade_in or 0
  self.fade_out_time = params.fade_out or 0
  self.duration = params.time or 1
  self.titleLab = self:FindGO("TitleLab"):GetComponent(UILabel)
  self.titleLab.text = params.title or ""
  self.descLab = self:FindGO("DescLab"):GetComponent(UILabel)
  self.descLab.text = params.desc or ""
  self.lineTexture = self:FindGO("LineTexture"):GetComponent(UITexture)
  PictureManager.Instance:SetUI(_texture_name, self.lineTexture)
end

function NewChapterView:clearAllTick()
  TimeTickManager.Me():ClearTick(self)
  self.timeTick = nil
  self.timeTickEnd = nil
end

function NewChapterView:DoEnter()
  LeanTween.alphaNGUI(self.root, 0, 1, self.fade_in_time)
  if not self.duration then
    return
  end
  self.timeTick = TimeTickManager.Me():CreateOnceDelayTick((self.duration - self.fade_out_time) * 1000, function(owner, deltaTime)
    self:_fade_out_call()
  end, self, 1)
  self.timeTickEnd = TimeTickManager.Me():CreateOnceDelayTick(self.duration * 1000, function(owner, deltaTime)
    self:_end_call()
  end, self, 2)
end

function NewChapterView:OnEnter()
  self:DoEnter()
  NewChapterView.super.OnEnter(self)
end

function NewChapterView:OnExit()
  self:clearAllTick()
  PictureManager.Instance:UnLoadUI(_texture_name, self.lineTexture)
  NewChapterView.super.OnExit(self)
end

function NewChapterView:_fade_out_call()
  LeanTween.alphaNGUI(self.root, 1, 0, self.fade_out_time)
end

function NewChapterView:_end_call()
  if self.questData then
    redlog("NewChapterView _end_call : ", self.questData.id)
    QuestProxy.Instance:notifyQuestState(self.questData.scope, self.questData.id, self.questData.staticData.FinishJump)
  end
  self:CloseSelf()
end
