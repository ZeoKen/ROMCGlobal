autoImport("NewContentPushCell")
NewContentPushView = class("NewContentPushView", ContainerView)
NewContentPushView.ViewType = UIViewType.NormalLayer
NewContentPushView.isAutoOpened = false
local bgName = "Push_bg_01"
local animStateName = "die"
local decorationDepth = 3

function NewContentPushView.CanShow()
  local contentIds = NewContentPushProxy.Instance:GetPushContentIds()
  return 0 < #contentIds and NewContentPushProxy.Instance.isfirst and not NewContentPushView.isAutoOpened
end

function NewContentPushView.SetAutoOpened()
  NewContentPushView.isAutoOpened = true
end

function NewContentPushView:Init()
  if self.viewdata and self.viewdata.viewdata then
    self.callback = self.viewdata.viewdata.callback
    self.removeCallBackWhenClickGO = self.viewdata.viewdata.removeCallbackWhenClickGO or false
  end
  self.children = {}
  self:AddListenEvt(NewContentPushEvent.Close, self.OnNewContentPushEventClose)
  self:AddListenEvt(UIEvent.FinishJump, self.OnJumpFinish)
  self:AddButtonEvent("closeBtn", function()
    self:PlayCloseAnim()
  end)
  if not BranchMgr.IsChina() then
    local iconNew = self:FindGO("iconNew")
    iconNew:SetActive(false)
  end
end

function NewContentPushView:OnEnter()
  self:InitBg()
  self:InitDecoration()
  self:InitContentsView()
  self:InitAnimator()
end

function NewContentPushView:OnExit()
  self:UnloadBg()
  for _, childView in pairs(self.children) do
    childView:OnDestroy()
  end
  TimeTickManager.Me():ClearTick(self)
  if self.callback then
    self.callback()
  end
end

function NewContentPushView:InitBg()
  self.bgLeft = self:FindGO("bg"):GetComponent(UITexture)
  self.bgRight = self:FindGO("bg2"):GetComponent(UITexture)
  self:LoadBg()
  self.bgRight.flip = 1
end

function NewContentPushView:InitDecoration()
  local decoration = GameConfig.VersionDecoration
  if decoration then
    local version = NewContentPushProxy.Instance.version
    local atlas = RO.AtlasMap.GetAtlas("Push")
    local decorationParent = self:FindGO("decoration")
    for i, data in ipairs(decoration[version] or {}) do
      local child = GameObject(i)
      child.transform:SetParent(decorationParent.transform)
      child.transform.localPosition = LuaVector3(data.x, data.y, 0)
      local sprite = child:AddComponent(UISprite)
      sprite.atlas = atlas
      sprite.spriteName = data.icon
      sprite.depth = decorationDepth + i - 1
      sprite:MakePixelPerfect()
    end
  end
end

function NewContentPushView:InitContentsView()
  for _, id in ipairs(NewContentPushProxy.Instance:GetPushContentIds()) do
    local data = Table_PushContent[id]
    if data then
      local parentName = "left"
      if data.parent == 1 then
        parentName = "right"
      end
      local parent = self:FindGO(parentName)
      local parentWidget = parent:GetComponent(UIWidget)
      local obj = self:LoadPreferb("cell/NewContentPushCell" .. data.prefabId, parent)
      local x = parentWidget.width * data.xOffset
      local y = -parentWidget.height * data.yOffset
      obj.transform.localPosition = LuaGeometry.GetTempVector3(x, y, 0)
      local childView = NewContentPushCell.new(obj)
      childView:SetData(data)
      self.children[id] = childView
    end
  end
end

function NewContentPushView:InitAnimator()
  self.animator = self.gameObject:GetComponent(Animator)
end

function NewContentPushView:LoadBg()
  PictureManager.Instance:SetPushTexture(bgName, self.bgLeft)
  PictureManager.Instance:SetPushTexture(bgName, self.bgRight)
end

function NewContentPushView:UnloadBg()
  PictureManager.Instance:UnloadPushTexture(bgName, self.bgLeft)
  PictureManager.Instance:UnloadPushTexture(bgName, self.bgRight)
end

function NewContentPushView:PlayCloseAnim(data)
  if self.animator then
    self.animator:Play(animStateName)
    local clips = self.animator.runtimeAnimatorController.animationClips
    TimeTickManager.Me():CreateOnceDelayTick(clips[1].length * 1000, function()
      self:CloseSelf()
    end, self)
  end
end

function NewContentPushView:OnNewContentPushEventClose(data)
  if data and data.body then
    if self.removeCallBackWhenClickGO then
      self.callback = nil
    end
    self.failJump = data.body.failJump
    self.failJumpParam = data.body.failJumpParam
    FuncShortCutFunc.Me():CallByID(data.body.shortId, data.body.param)
  end
  self:CloseSelf()
end

function NewContentPushView:OnJumpFinish(note)
  local isSuccess = note.body
  if not isSuccess and self.failJump then
    local failShortId = self.failJump
    self.failJump = nil
    FuncShortCutFunc.Me():CallByID(failShortId, self.failJumpParam)
  end
end
