autoImport("DojoRewardCell")
ExpRaidResultView = class("ExpRaidResultView", BaseView)
ExpRaidResultView.ViewType = UIViewType.CheckLayer
local tickManager

function ExpRaidResultView:Init()
  if not tickManager then
    tickManager = TimeTickManager.Me()
  end
  self:InitData()
  self:FindObjs()
  self:InitView()
  self:AddListenEvts()
end

function ExpRaidResultView:InitData()
  local viewData = self.viewdata.viewdata or _EmptyTable
  if not viewData or not next(viewData) then
    LogUtility.Error("ExpRaidResultView: viewdata is nothing")
  end
  self.baseExp = viewData.baseexp or 0
  self.jobExp = viewData.jobexp or 0
  self.closeTimestamp = viewData.closetime or 60
  self.rewardDataArray = viewData.items
end

function ExpRaidResultView:FindObjs()
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
end

function ExpRaidResultView:InitView()
  local go = self:LoadPreferb_ByFullPath(ResourcePathHelper.EffectUI("59Instituteresult"), self.background)
  go.transform.localPosition = LuaGeometry.GetTempVector3(359.3, 106.7)
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
  self.grid.cellHeight = 90
  self.grid.pivot = UIWidget.Pivot.Left
  local hasReward = self.baseExp > 0 or 0 < self.jobExp or self.rewardDataArray and 0 < #self.rewardDataArray
  self.emptyLabel.gameObject:SetActive(not hasReward)
  if hasReward then
    self:AddJobAndBaseToDataArray()
    self.rewardCtl = UIGridListCtrl.new(self.grid, DojoRewardCell, "ExpRaidRewardCell")
    self.rewardCtl:ResetDatas(self.rewardDataArray)
    local ins = ExpRaidProxy.Instance
    for _, cell in pairs(self.rewardCtl:GetCells()) do
      if cell.data.id == 300 then
        local baseActivityGo = self:FindGO("BaseActivity", cell.gameObject)
        if baseActivityGo then
          baseActivityGo:SetActive(ins:CheckShowBaseActivity(curRaidId, true))
        end
      end
    end
  else
    self.emptyLabel.text = ZhString.ExpRaid_NoReward
  end
  tickManager:CreateTick(0, 300, self.RefreshTime, self, 0)
end

function ExpRaidResultView:AddListenEvts()
  self:AddListenEvt(ServiceEvent.PlayerMapChange, self.CloseSelf)
  self:AddListenEvt(MainViewEvent.ShowOrHide, self.HandleMainViewShowOrHide)
  self:AddListenEvt(LoadSceneEvent.FinishLoad, self.CloseSelf)
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

function ExpRaidResultView:RefreshTime()
  local period = math.ceil(self.closeTimestamp - getNowTime())
  if period < 0 then
    period = 0
    tickManager:ClearTick(self, 0)
  end
  self.countDownLabel.text = string.format(ZhString.Dojo_Secend, tostring(period))
end

function ExpRaidResultView:PlayAnim()
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

function ExpRaidResultView:OnEnter()
  ExpRaidResultView.super.OnEnter(self)
  self:CameraRotateToMe()
  self:PlayAnim()
end

function ExpRaidResultView:OnExit()
  tickManager:ClearTick(self)
  ExpRaidResultView.super.OnExit(self)
  self:CameraReset()
end

function ExpRaidResultView:AddJobAndBaseToDataArray()
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

function ExpRaidResultView:AddCloseButtonEvent()
  self:AddButtonEvent("CloseButton", function()
    ServiceFuBenCmdProxy.Instance:CallExitMapFubenCmd()
    self:CloseSelf()
  end)
end

function ExpRaidResultView:HandleMainViewShowOrHide(note)
  if note.body == true then
    self:CloseSelf()
  end
end
