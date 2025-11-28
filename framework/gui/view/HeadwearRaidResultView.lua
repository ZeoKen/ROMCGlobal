autoImport("DojoRewardCell")
HeadwearRaidResultView = class("HeadwearRaidResultView", BaseView)
HeadwearRaidResultView.ViewType = UIViewType.CheckLayer
local curServerTime
local getNowTime = function()
  if not curServerTime then
    curServerTime = ServerTime.CurServerTime
  end
  if curServerTime then
    return curServerTime() / 1000
  end
  return 0
end

function HeadwearRaidResultView:Init()
  self:InitData()
  self:FindObjs()
  self:InitView()
  self:AddEvents()
end

function HeadwearRaidResultView:InitData()
  local viewData = self.viewdata.viewdata or _EmptyTable
  if not viewData or not next(viewData) then
    LogUtility.Error("HeadwearRaidResultView: viewdata is nothing")
  end
  self.winNeedRound = viewData.winNeedRound
  self.round = viewData.round or 0
  self.weektimes = viewData.weektimes or 0
  self.iswin = viewData.iswin
  self.maxRound = viewData.maxRound
  self.weekMaxTime = viewData.weekMaxTime
  self.noRewardReason = viewData.noRewardReason or 0
  self.closeTimestamp = (viewData.closetime or 60) + getNowTime()
  self.rewardDataArray = viewData.items
  self.isActivity = HeadwearRaidProxy.Instance.isActivityRaid
  self.tipData = {}
  self.tipData.funcConfig = {}
end

function HeadwearRaidResultView:FindObjs()
  self.background = self:FindGO("Background")
  self.tipLabel = self:FindComponent("Tip", UILabel)
  self.nameLabel = self:FindComponent("Name", UILabel)
  self.tipNameLabel = self:FindComponent("TipName", UILabel)
  self.countDownLabel = self:FindComponent("CountDownLabel", UILabel)
  self.anim1 = self:FindGO("Anim1")
  self.anim2 = self:FindGO("Anim2")
  self.anim3 = self:FindGO("Anim3")
  self.grid = self:FindComponent("Grid", UIGrid)
  self.scrollview = self:FindComponent("ScrollView", UIScrollView)
  self.emptyLabel = self:FindComponent("EmptyTip", UILabel)
  self.staticLost = self:FindGO("picLose")
  self.tipsContainer = self:FindGO("tipsContainer"):GetComponent(UIWidget)
  IconManager:SetArtFontIcon("operate_txt_lose2", self:FindComponent("Bg1 (3)", UISprite, self.staticLost))
  local closeButton = self:FindGO("CloseButton")
  self:AddClickEvent(closeButton, function()
    ServiceFuBenCmdProxy.Instance:CallExitMapFubenCmd()
    self:CloseSelf()
  end)
end

function HeadwearRaidResultView:InitView()
  local go = self.iswin and self:LoadPreferb_ByFullPath(ResourcePathHelper.EffectUI("59Instituteresult"), self.background) or self:LoadPreferb_ByFullPath(ResourcePathHelper.EffectUI("59Instituteresult"), self.background)
  go.transform.localPosition = LuaGeometry.GetTempVector3(359.3, 106.7)
  if not self.iswin then
    go:SetActive(false)
    self.staticLost:SetActive(true)
  else
    self.staticLost:SetActive(false)
  end
  self.gameObject.name = self.__cname
  self.tipLabel.text = string.format(ZhString.HeadwearRaidResult_Round, self.round, self.maxRound)
  if self.weekMaxTime and self.weektimes then
    self.tipNameLabel.text = string.format(ZhString.HeadwearRaidResult_WeekTime, self.weektimes, self.weekMaxTime)
  else
    self.tipNameLabel.gameObject:SetActive(false)
  end
  self.nameLabel.text = ""
  local curRaidId = SceneProxy.Instance:GetCurRaidID()
  if curRaidId then
    local mapRaidData = Table_MapRaid[curRaidId]
    if mapRaidData and mapRaidData.NameZh then
      self.nameLabel.text = mapRaidData.NameZh
    end
  end
  local hasReward = self.rewardDataArray and #self.rewardDataArray > 0
  self.emptyLabel.gameObject:SetActive(not hasReward)
  if hasReward then
    self.rewardCtl = UIGridListCtrl.new(self.grid, DojoRewardCell, "HeadwearRaidRewardCell")
    self.rewardCtl:AddEventListener(MouseEvent.MouseClick, self.handleClickReward, self)
    self.rewardCtl:ResetDatas(self.rewardDataArray)
    self.scrollview:ResetPosition()
  elseif self.isActivity then
    if self.noRewardReason == 2 then
      self.emptyLabel.text = ZhString.HeadwearRaidResult_ActivityNoReward
    elseif self.noRewardReason == 1 then
      self.emptyLabel.text = string.format(ZhString.HeadwearRaidResult_ActivityNoReward2, self.winNeedRound)
    else
      self.emptyLabel.gameObject:SetActive(false)
    end
  elseif self.noRewardReason == 2 then
    self.emptyLabel.text = ZhString.HeadwearRaidResult_NoReward2
  elseif self.noRewardReason == 1 then
    self.emptyLabel.text = ZhString.HeadwearRaidResult_NoReward3
  elseif self.noRewardReason == 3 then
    self.emptyLabel.text = string.format(ZhString.HeadwearRaidResult_NoReward, self.winNeedRound)
  else
    self.emptyLabel.gameObject:SetActive(false)
  end
  self.refreshTick = TimeTickManager.Me():CreateTick(0, 300, self.RefreshTime, self)
end

function HeadwearRaidResultView:AddEvents()
  self:AddListenEvt(ServiceEvent.PlayerMapChange, self.CloseSelf)
  self:AddListenEvt(MainViewEvent.ShowOrHide, self.HandleMainViewShowOrHide)
  self:AddListenEvt(LoadingSceneView.ServerReceiveLoaded, self.CloseSelf)
end

function HeadwearRaidResultView:OnEnter()
  HeadwearRaidResultView.super.OnEnter(self)
  self:CameraRotateToMe()
  self:PlayAnim()
end

function HeadwearRaidResultView:PlayAnim()
  self.anim1:SetActive(false)
  self.anim2:SetActive(false)
  self.anim3:SetActive(false)
  TimeTickManager.Me():CreateOnceDelayTick(1500, function(owner, deltaTime)
    self.anim1:SetActive(true)
    TimeTickManager.Me():CreateOnceDelayTick(300, function(owner, deltaTime)
      self.anim2:SetActive(true)
      TimeTickManager.Me():CreateOnceDelayTick(300, function(owner, deltaTime)
        self.anim3:SetActive(true)
      end, self)
    end, self)
  end, self)
end

function HeadwearRaidResultView:OnExit()
  TimeTickManager.Me():ClearTick(self)
  HeadwearRaidResultView.super.OnExit(self)
  self:CameraReset()
end

function HeadwearRaidResultView:RefreshTime()
  local period = math.ceil(self.closeTimestamp - getNowTime())
  if period < 0 then
    period = 0
    if self.refreshTick then
      self.refreshTick:Destroy()
      self.refreshTick = nil
    end
  end
  self.countDownLabel.text = string.format(ZhString.Dojo_Secend, tostring(period))
end

function HeadwearRaidResultView:HandleMainViewShowOrHide(note)
  if note.body == true then
    self:CloseSelf()
  end
end

function HeadwearRaidResultView:handleClickReward(cellCtrl)
  if cellCtrl and cellCtrl.data then
    self.tipData.itemdata = ItemData.new("Reward", cellCtrl.data.id)
    self:ShowItemTip(self.tipData, self.tipsContainer, NGUIUtil.AnchorSide.Center, {0, 0})
  end
end
