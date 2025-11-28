autoImport("DojoRewardCell")
RaidResultPopUp = class("RaidResultPopUp", BaseView)
RaidResultPopUp.ViewType = UIViewType.CheckLayer

function RaidResultPopUp:Init()
  if not tickManager then
    tickManager = TimeTickManager.Me()
  end
  self:InitData()
  self:FindObjs()
  self:AddEvts()
  self:InitView()
  self:AddListenEvts()
end

function RaidResultPopUp:InitData()
  local viewData = self.viewdata.viewdata or _EmptyTable
  if not viewData or not next(viewData) then
    LogUtility.Error("RaidResultPopUp: viewdata is nothing")
  end
  self.baseExp = viewData.baseexp or 0
  self.jobExp = viewData.jobexp or 0
  self.closeTimestamp = ServerTime.CurServerTime() / 1000 + 60
  self.rewardDataArray = viewData.items
  self.score = viewData.score
end

function RaidResultPopUp:FindObjs()
  self.background = self:FindGO("Background")
  self.tipLabel = self:FindComponent("Tip", UILabel)
  self.nameLabel = self:FindComponent("Name", UILabel)
  self.tipNameLabel = self:FindComponent("TipName", UILabel)
  self.countDownLabel = self:FindComponent("CountDownLabel", UILabel)
  self.anim1 = self:FindGO("Anim1")
  self.anim2 = self:FindGO("Anim2")
  self.anim3 = self:FindGO("Anim3")
  self.grid = self:FindComponent("Grid", UIGrid)
  self.emptyLabel = self:FindComponent("EmptyTip", UILabel)
  self.scoreLabel = self:FindComponent("Score", UILabel)
  self.btnsGrid = self:FindGO("Btns"):GetComponent(UIGrid)
  self.shareBtn = self:FindGO("ShareButton")
end

function RaidResultPopUp:AddEvts()
  self:AddClickEvent(self.shareBtn, function()
    if ApplicationInfo.IsRunOnWindowns() then
      MsgManager.ShowMsgByID(43486)
      return
    end
    tickManager:ClearTick(self)
    self.countDownLabel.gameObject:SetActive(false)
    self.shareViewData = {}
    self.shareViewData.shareType = 3
    self.shareViewData.raidName = self.nameLabel.text
    self.shareViewData.score = self.score
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.ShareAwardView,
      viewdata = self.shareViewData
    })
  end)
end

function RaidResultPopUp:InitView()
  self.gameObject.name = self.__cname
  self.tipLabel.text = ZhString.ExpRaid_ResultViewTipLabel
  self.tipNameLabel.text = ZhString.Dojo_Reward
  self.nameLabel.text = ""
  local curRaidId = SceneProxy.Instance:GetCurRaidID()
  if curRaidId then
    local mapRaidData = Table_MapRaid[curRaidId]
    if mapRaidData and mapRaidData.NameZh then
      self.nameLabel.text = mapRaidData.NameZh
    end
  end
  local gridLocalPos = self.grid.transform.localPosition
  gridLocalPos.x = 321
  self.grid.transform.localPosition = gridLocalPos
  self.grid.cellWidth = 180
  self.grid.cellHeight = 80
  self.grid.pivot = UIWidget.Pivot.Left
  local hasReward = self.baseExp > 0 or 0 < self.jobExp or self.rewardDataArray and 0 < #self.rewardDataArray
  self.emptyLabel.text = ZhString.ExpRaid_NoReward
  if self.score then
    self.scoreLabel.gameObject:SetActive(true)
    self.emptyLabel.gameObject:SetActive(false)
    self.scoreLabel.text = string.format(ZhString.IPRaidBord_CellScore, self.score)
  elseif hasReward then
    self.emptyLabel.gameObject:SetActive(not hasReward)
    self.scoreLabel.gameObject:SetActive(false)
    self:AddJobAndBaseToDataArray()
    self.rewardCtl = UIGridListCtrl.new(self.grid, DojoRewardCell, "ExpRaidRewardCell")
    self.rewardCtl:ResetDatas(self.rewardDataArray)
  end
  self.shareBtn:SetActive(false)
  self.btnsGrid:Reposition()
  tickManager:CreateTick(0, 300, self.RefreshTime, self, 0)
end

function RaidResultPopUp:AddListenEvts()
  self:AddListenEvt(ServiceEvent.PlayerMapChange, self.CloseSelf)
  self:AddListenEvt(MainViewEvent.ShowOrHide, self.HandleMainViewShowOrHide)
  self:AddListenEvt(LoadingSceneView.ServerReceiveLoaded, self.CloseSelf)
end

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

function RaidResultPopUp:RefreshTime()
  local period = math.ceil(self.closeTimestamp - getNowTime())
  if period < 0 then
    period = 0
    tickManager:ClearTick(self, 0)
    ServiceFuBenCmdProxy.Instance:CallExitMapFubenCmd()
    self:CloseSelf()
  end
  self.countDownLabel.text = string.format(ZhString.Dojo_Secend, tostring(period))
end

function RaidResultPopUp:PlayAnim()
  self.anim1:SetActive(false)
  self.anim2:SetActive(false)
  self.anim3:SetActive(false)
  tickManager:CreateOnceDelayTick(1500, function()
    self.anim1:SetActive(true)
    tickManager:CreateOnceDelayTick(300, function()
      self.anim2:SetActive(true)
      tickManager:CreateOnceDelayTick(300, function()
        self.anim3:SetActive(true)
      end, self)
    end, self)
  end, self)
end

function RaidResultPopUp:OnEnter()
  RaidResultPopUp.super.OnEnter(self)
  self:CameraRotateToMe()
  self:PlayAnim()
  if Game.MapManager:IsRaidMode() then
    UIManagerProxy.Instance:ActiveLayer(UIViewType.FloatLayer, false)
  end
end

function RaidResultPopUp:OnExit()
  tickManager:ClearTick(self)
  RaidResultPopUp.super.OnExit(self)
  self:CameraReset()
  if Game.MapManager:IsRaidMode() then
    UIManagerProxy.Instance:ActiveLayer(UIViewType.FloatLayer, true)
  end
end

function RaidResultPopUp:AddJobAndBaseToDataArray()
  local newDojoRewardData = ReusableTable.CreateTable()
  if self.baseExp > 0 then
    newDojoRewardData.id = 300
    newDojoRewardData.count = self.baseExp
    TableUtility.ArrayPushFront(self.rewardDataArray, DojoRewardData.new(newDojoRewardData))
  end
  if 0 < self.jobExp then
    newDojoRewardData.id = 400
    newDojoRewardData.count = self.jobExp
    TableUtility.ArrayPushFront(self.rewardDataArray, DojoRewardData.new(newDojoRewardData))
  end
  ReusableTable.DestroyAndClearTable(newDojoRewardData)
end

function RaidResultPopUp:AddCloseButtonEvent()
  self:AddButtonEvent("CloseButton", function()
    ServiceFuBenCmdProxy.Instance:CallExitMapFubenCmd()
    self:CloseSelf()
  end)
end

function RaidResultPopUp:HandleMainViewShowOrHide(note)
  if note.body == true then
    self:CloseSelf()
  end
end
