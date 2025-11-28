autoImport("NewServerSignInMapCell")
NewServerSignInMapView = class("NewServerSignInMapView", BaseView)
NewServerSignInMapView.ViewType = UIViewType.NormalLayer
NewServerSignInMapView.FlippedRotation = LuaVector3.New(0, 180, 0)
local cellState

function NewServerSignInMapView:Init()
  if not cellState then
    cellState = NewServerSignInMapCellState
  end
  self:InitData()
  self:FindObjs()
  self:InitCellPart()
  self:UpdateShow(true)
  self:AddEvents()
end

function NewServerSignInMapView:InitData()
  self.proxyInstance = NewServerSignInProxy.Instance
  self.periodDayCount = NewServerSignInProxy.PeriodDayCount
  self.catPrefabName = "sign_bigcat"
  self.mapBgTexName = "sign_map"
  self.cellPartName = "SignInCells30"
end

function NewServerSignInMapView:FindObjs()
  self.contentParent = self:FindGO("Content")
  self.mapBgTex = self:FindComponent("MapBg", UITexture)
  self.tipButtonTex = self:FindComponent("TipButtonTex", UITexture)
  self.tipButton = self:FindGO("TipButton")
  self.catParent = self:FindGO("Cat")
  self.flowEffectParent = self:FindGO("FlowEffect")
  self.helpBtn = self:FindGO("HelpBtn")
  self.dateLabel = self:FindComponent("DateLabel", UILabel)
  if BranchMgr.IsJapan() then
    self.tipButton:SetActive(false)
  end
end

function NewServerSignInMapView:InitCellPart()
  local part = self:LoadPreferb("part/" .. self.cellPartName, self.contentParent)
  part.transform.localPosition = LuaGeometry.GetTempVector3()
  self.signInDayCellCtlMap = {}
  local cellGO
  for i = 1, self.periodDayCount do
    cellGO = self:FindGO("NewServerSignInMapCell" .. i, part)
    if not cellGO then
      LogUtility.ErrorFormat("Cannot find NewServerSignInMapCell{0}", i)
      return
    end
    self.signInDayCellCtlMap[i] = NewServerSignInMapCell.new(cellGO, i)
  end
  self.signInMapCell0 = self:FindGO("NewServerSignInMapCell0", part)
  self.lastDayCellEffectParent = self:FindGO("LastDayCellEffect", part)
end

function NewServerSignInMapView:UpdateShow(isFirstCall)
  local maxDay = self.periodDayCount
  for i = 1, maxDay do
    self.signInDayCellCtlMap[i]:SwitchToState(cellState.Unsigned)
  end
  self:UpdateTodayCell()
  if self.proxyInstance.signedCount == 0 then
    self.signedCountRemainder = 0
    self.passPeriodCount = 0
  else
    self.signedCountRemainder = self.proxyInstance:GetRemainderOfDay(self.proxyInstance.signedCount, maxDay)
    self.passPeriodCount = math.floor((self.proxyInstance.signedCount - self.signedCountRemainder) / maxDay)
  end
  if isFirstCall and self.signedCountRemainder == maxDay and self.proxyInstance:GetRewardDataOfDay(self.proxyInstance.signedCount + 1) then
    self.passPeriodCount = self.passPeriodCount + 1
    self.signedCountRemainder = 0
  end
  for i = 1, self.signedCountRemainder do
    self.signInDayCellCtlMap[i]:SwitchToState(cellState.Signed)
  end
  for i = 1, maxDay - self.signedCountRemainder do
    if self.proxyInstance:IsDayWithSmallGift(self.proxyInstance.signedCount + i) then
      self.signInDayCellCtlMap[i + self.signedCountRemainder]:SwitchToState(cellState.SmallGift)
    end
    if self.proxyInstance:IsDayWithLargeGift(self.proxyInstance.signedCount + i) then
      self.signInDayCellCtlMap[i + self.signedCountRemainder]:SwitchToState(cellState.LargeGift)
    end
  end
  if not self.cat then
    self:CreateCat()
  end
  local dest = self.signedCountRemainder == 0 and self.signInMapCell0.transform.position or self.signInDayCellCtlMap[self.signedCountRemainder].gameObject.transform.position
  if isFirstCall then
    self.catParent.transform.position = dest
    self:TryFlipCat()
  else
    self:PlayCatMoveAnim(dest)
  end
  self.lastDayCellEffectParent:SetActive(maxDay > self.signedCountRemainder)
end

function NewServerSignInMapView:AddEvents()
  for index, cellCtl in pairs(self.signInDayCellCtlMap) do
    self:AddClickEvent(cellCtl.gameObject, function()
      local day = self.passPeriodCount * self.periodDayCount + index
      self:ShowRewardPreview(day)
      if cellCtl.state == cellState.Barrier then
        self:sendNotification(UIEvent.JumpPanel, {
          view = PanelConfig.SignInQAView,
          viewdata = day
        })
      end
    end)
  end
  self:AddClickEvent(self.tipButton, function()
    local viewCfg = PanelConfig.SignInTipsView
    if not UIManagerProxy.Instance:HasUINode(viewCfg) then
      self:sendNotification(UIEvent.JumpPanel, {view = viewCfg})
    end
  end)
  self:AddListenEvt(ServiceEvent.NUserSignInNtfUserCmd, self.HandleSignInNotify)
  self:AddListenEvt(NewServerSignInEvent.RemoveBarrier, self.HandleRemoveBarrier)
  self:AddListenEvt(XDEUIEvent.SignInMapViewBack, self.CloseSelf)
end

function NewServerSignInMapView:OnEnter()
  NewServerSignInMapView.super.OnEnter(self)
  self.tipButtonTexName = "sign_icon_help"
  PictureManager.Instance:SetMap(self.mapBgTexName, self.mapBgTex)
  PictureManager.Instance:SetUI(self.tipButtonTexName, self.tipButtonTex)
  self.flowEffect = self:PlayUIEffect(EffectMap.UI.SignIn_Flow, self.flowEffectParent)
  self.lastDayCellEffect = self:PlayUIEffect(EffectMap.UI.SignIn_Box, self.lastDayCellEffectParent)
  self.helpBtn:SetActive(false)
  self.dateLabel.gameObject:SetActive(false)
end

function NewServerSignInMapView:OnExit()
  PictureManager.Instance:UnLoadMap(self.mapBgTexName, self.mapBgTex)
  PictureManager.Instance:UnLoadUI(self.tipButtonTexName, self.tipButtonTex)
  if self.cat then
    Game.GOLuaPoolManager:AddToSceneUIPool(self.resPath, self.cat)
  end
  if self.flowEffect then
    self.flowEffect:Destroy()
  end
  if self.lastDayCellEffect then
    self.lastDayCellEffect:Destroy()
  end
  self:sendNotification(NewServerSignInEvent.CloseRewardPreview)
  self:SendMapViewCloseEvent()
  NewServerSignInMapView.super.OnExit(self)
end

function NewServerSignInMapView:UpdateTodayCell()
  local today = self.proxyInstance:GetToday()
  if today then
    local todayCell = self.signInDayCellCtlMap[self.proxyInstance:GetRemainderOfDay(today, self.periodDayCount)]
    if todayCell then
      if not self.proxyInstance.isTodaySigned then
        if self.proxyInstance:IsDayWithQuestion(today) and not self.proxyInstance.isTodayQuestionAnswered then
          todayCell:SwitchToState(cellState.Barrier)
        else
          self:AddHintToCell(todayCell)
        end
      else
        self:DestroyHint()
      end
    end
  end
end

function NewServerSignInMapView:CreateCat()
  self.resPath = ResourcePathHelper.Emoji(self.catPrefabName)
  self.cat = Game.AssetManager_UI:CreateSceneUIAsset(self.resPath, self.catParent)
  if not self.cat then
    LogUtility.Error("Cannot find cat")
    return
  end
  self.cat.transform.localPosition = LuaGeometry.GetTempVector3(0, -10, 0)
  UIUtil.ChangeLayer(self.cat, self.catParent.layer)
  self.cat.transform.localScale = LuaGeometry.GetTempVector3(1, 1, 1)
  self.cat.gameObject:SetActive(true)
  self.cat.name = self.catPrefabName
  self.catAnimComp = self.cat:GetComponent(SkeletonAnimation)
  self:PlayCatStand()
  local uiSpine = self.cat:GetComponent(UISpine)
  uiSpine.depth = 20
end

function NewServerSignInMapView:PlayCatMoveAnim(toPosition)
  self:PlayCatAnim("jump", function()
    self:PlayCatStand()
    self:TryFlipCat()
  end)
  if not toPosition then
    return
  end
  local tp = TweenPosition.Begin(self.catParent, 0.5, toPosition, true)
  tp.delay = 0.2
end

function NewServerSignInMapView:PlayCatStand()
  self:PlayCatAnim("stand")
end

function NewServerSignInMapView:PlayCatAnim(animName, callback)
  self.catAnimComp:Reset()
  self.catAnimComp.loop = animName == "stand"
  SpineLuaHelper.PlayAnim(self.catAnimComp, animName, callback)
end

function NewServerSignInMapView:TryFlipCat()
  local day = self.signedCountRemainder
  local isFlip = 9 < day and day < 21 or 27 < day
  self.cat.transform.localEulerAngles = LuaGeometry.GetTempVector3(0, isFlip and 180 or 0)
end

function NewServerSignInMapView:ShowRewardPreview(day)
  if UIManagerProxy.Instance:HasUINode(PanelConfig.SignInRewardPreview) then
    self:sendNotification(NewServerSignInEvent.UpdateRewardPreview, day)
  else
    self:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.SignInRewardPreview,
      viewdata = {
        day = day,
        proxy = self.proxyInstance
      }
    })
  end
end

function NewServerSignInMapView:HandleSignInNotify()
  self:UpdateShow(not self.proxyInstance.isTodaySigned)
end

function NewServerSignInMapView:HandleRemoveBarrier()
  self.proxyInstance:SetTodayQuestionAnswered()
  self:UpdateShow()
end

function NewServerSignInMapView:AddHintToCell(cellCtl)
  if not self.hintGO then
    local hintResPath = ResourcePathHelper.EffectUI(EffectMap.UI.GlowHint4)
    self.hintGO = Game.AssetManager_UI:CreateAsset(hintResPath, cellCtl.gameObject)
    self.hintGO.transform.localPosition = LuaGeometry.GetTempVector3(0.34, -11.9, 0)
    self.hintGO.transform.localScale = LuaGeometry.Const_V3_one
  else
    self.hintGO.transform:SetParent(cellCtl.gameObject.transform, false)
  end
end

function NewServerSignInMapView:DestroyHint()
  if self.hintGO then
    GameObject.Destroy(self.hintGO)
    self.hintGO = nil
  end
end

function NewServerSignInMapView:SendMapViewCloseEvent()
  self:sendNotification(NewServerSignInEvent.MapViewClose)
end
